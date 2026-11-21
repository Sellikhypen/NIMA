#!/usr/bin/env python3
"""NIMA Content-Compiler: content/**  ->  App/Content/content.json + App/Content/img/

Modul-Datei (content/modules/<ordner>/<datei>.md):
    ---
    id: nmap
    title: Network Enumeration with Nmap
    paths: cpts, cjca            (Pfad-IDs aus content/paths.json)
    order: 3                     (Sortierung innerhalb der Pfade)
    difficulty: easy|medium|hard|insane
    minutes: 45
    icon: network                (SF Symbol)
    htb: Network Enumeration with Nmap   (HTB-Modulname(n) -> PwnDeck-Fragen werden angehängt)
    summary: Ein Satz
    ---
    ## Lektion
    Absatz mit [[Begriff]] oder [[Begriff|Text]] und [[mod:id|Text]]
    ### Unterüberschrift
    - Liste / 1. Liste
    > [!TIPP] Titel          (INFO, TIPP, MERKE, WARNUNG, GEFAHR, BEISPIEL, ERGEBNIS, EXAM, PRAXIS)
    > Text
    ```bash ... ```
    | Tabelle | ... |
    ![Bildunterschrift](asset:ordner/datei.png)
    ## Quiz                    (danach PwnDeck-Fragensyntax: ? = + - ! ~ ?tf ?order >)

Glossar (content/glossary/*.md):
    ## Begriff
    aka: Alias1, Alias2
    kat: Kategorie
    kurz: Ein Satz.
    Langer Text mit [[Links]] ...
    siehe: Begriff2, Begriff3
"""
import argparse
import json
import re
import shutil
import sys
import time
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
CONTENT = ROOT / "content"
OUT = ROOT / "App" / "Content"
PWNDECK_DIRS = [CONTENT / "quizbanks"]

CALLOUTS = {"INFO", "TIPP", "MERKE", "WARNUNG", "GEFAHR", "BEISPIEL", "ERGEBNIS", "EXAM", "PRAXIS", "DEFINITION", "ANALOGIE"}
DIFFS = {"easy", "medium", "hard", "insane"}

errors, warnings = [], []


def slug(s):
    s = s.lower().replace("ä", "ae").replace("ö", "oe").replace("ü", "ue").replace("ß", "ss")
    return re.sub(r"[^a-z0-9]+", "-", s).strip("-") or "x"


def split_list(v):
    return [x.strip() for x in re.split(r"[,;]", v or "") if x.strip()]


# ---------------------------------------------------------------- quiz parser (PwnDeck format)
TRUE_RE = re.compile(r"^(wahr|true|richtig|ja|yes|w|t|1|stimmt)$", re.I)
FALSE_RE = re.compile(r"^(falsch|false|nein|no|f|0)$", re.I)


def parse_quiz(text, origin):
    qs, meta = [], {}
    cur = None
    last = None
    in_code = False
    code = []

    def finish():
        nonlocal cur
        if not cur:
            return
        c = cur
        cur = None
        base = {"q": c["q"].strip(), "explain": c["explain"].strip(), "hint": c["hint"].strip()}
        if c.get("code"):
            base["code"] = c["code"]
        if c.get("difficulty"):
            base["difficulty"] = c["difficulty"]
        if c.get("case"):
            base["caseSensitive"] = True
        if not base["q"]:
            return
        if c["kind"] == "tf":
            a = (c["answers"] or [""])[0]
            if TRUE_RE.match(a):
                base.update(type="tf", value=True)
            elif FALSE_RE.match(a):
                base.update(type="tf", value=False)
            else:
                warnings.append(f"{origin}:{c['line']}: tf ohne wahr/falsch")
                return
        elif c["kind"] == "order" or c["order"]:
            if len(c["order"]) < 2:
                warnings.append(f"{origin}:{c['line']}: order < 2")
                return
            base.update(type="order", order=c["order"])
        elif c["opts"]:
            ok = [i for i, o in enumerate(c["opts"]) if o[1]]
            if len(c["opts"]) < 2 or not ok:
                warnings.append(f"{origin}:{c['line']}: MC ungültig")
                return
            base.update(type="multi" if len(ok) > 1 else "mc", options=[o[0] for o in c["opts"]], correct=ok)
        elif c["answers"]:
            base.update(type="input", answers=c["answers"])
        else:
            warnings.append(f"{origin}:{c['line']}: Frage ohne Antwort")
            return
        qs.append(base)

    for n, raw in enumerate(text.replace("\r", "").split("\n"), 1):
        if in_code:
            if raw.strip().startswith("```"):
                in_code = False
                cur["code"] = "\n".join(code).rstrip()
            else:
                code.append(raw)
            continue
        line = raw.strip()
        if not line:
            continue
        if line.startswith("```"):
            if cur:
                in_code, code = True, []
            continue
        if line.startswith("#"):
            m = re.match(r"^#+\s*([A-Za-zÄÖÜäöüß]+)\s*:\s*(.*)$", line)
            if m and not cur and not qs:
                meta[m.group(1).lower()] = m.group(2).strip()
            continue
        if line.startswith("?"):
            finish()
            m = re.match(r"^\?(tf|wf|order|reihe|mc|multi|input)?(?=\s|$)\s*(.*)$", line, re.I)
            kind = (m.group(1) or "").lower() if m else ""
            kind = {"wf": "tf", "reihe": "order"}.get(kind, kind)
            cur = {"kind": kind, "q": (m.group(2) if m else line[1:]).strip(), "opts": [], "answers": [], "order": [], "explain": "", "hint": "", "line": n}
            last = "q"
            continue
        if not cur:
            continue
        p, rest = line[0], line[1:].strip()
        if p == "+":
            cur["opts"].append((rest, True)); last = "o"
        elif p == "-":
            cur["opts"].append((rest, False)); last = "o"
        elif p == "=":
            if rest:
                cur["answers"].append(rest)
            last = "a"
        elif p == ">":
            if rest:
                cur["order"].append(rest)
            last = "r"
        elif p == "!":
            cur["explain"] += ("\n" if cur["explain"] else "") + rest; last = "e"
        elif p == "~":
            cur["hint"] = rest; last = "h"
        elif p == "@":
            m = re.match(r"^([A-Za-zäöü]+)\s*:\s*(.*)$", rest)
            if m:
                k, v = m.group(1).lower(), m.group(2).strip()
                if k in ("diff", "difficulty", "schwierigkeit"):
                    cur["difficulty"] = norm_diff(v)
                elif k in ("case",):
                    cur["case"] = bool(TRUE_RE.match(v)) or v.lower() == "an"
        else:
            if last == "q":
                cur["q"] += "\n" + line
            elif last == "e":
                cur["explain"] += "\n" + line
    finish()
    return qs, meta


def norm_diff(s, default="medium"):
    s = (s or "").lower().strip()
    return {"leicht": "easy", "einfach": "easy", "mittel": "medium", "schwer": "hard", "extrem": "insane"}.get(s, s if s in DIFFS else default)


# ---------------------------------------------------------------- glossary
def load_glossary():
    terms = {}
    for f in sorted((CONTENT / "glossary").glob("*.md")):
        cur = None
        for raw in f.read_text(encoding="utf-8").replace("\r", "").split("\n"):
            if raw.startswith("## "):
                name = raw[3:].strip()
                tid = slug(name)
                if tid in terms:
                    # merge: later files may extend an existing term
                    cur = terms[tid]
                    cur["_more"] = True
                    continue
                cur = {"id": tid, "term": name, "aka": [], "cat": "Allgemein", "short": "", "body": [], "see": [], "src": f.stem}
                terms[tid] = cur
                continue
            if cur is None or raw.startswith("# "):
                continue
            m = re.match(r"^(aka|kat|kurz|siehe):\s*(.*)$", raw.strip())
            if m:
                k, v = m.groups()
                if k == "aka":
                    cur["aka"] += split_list(v)
                elif k == "kat":
                    if not cur.get("_more"):
                        cur["cat"] = v.strip()
                elif k == "kurz":
                    if not cur["short"]:
                        cur["short"] = v.strip()
                elif k == "siehe":
                    cur["see"] += split_list(v)
                continue
            cur["body"].append(raw)
    return terms


# ---------------------------------------------------------------- markdown -> blocks
class Linker:
    def __init__(self, terms, module_ids):
        self.alias = {}
        for t in terms.values():
            for name in [t["term"]] + t["aka"]:
                self.alias.setdefault(slug(name), t["id"])
        self.module_ids = module_ids
        self.refs = {}  # term id -> set of module ids
        self.unknown = {}

    def build_auto(self, terms):
        """Regex über alle Begriffe/Aliasse (längste zuerst) für die automatische Verlinkung."""
        names = {}
        for t in terms.values():
            for n in [t["term"]] + t["aka"]:
                n = n.strip()
                if len(n) >= 3 and not n.isdigit():
                    names[n] = t["id"]
        self.auto_names = names
        alts = sorted(names, key=len, reverse=True)
        self.auto_re = re.compile(r"(?<![\w\-/.])(" + "|".join(re.escape(a) for a in alts) + r")(?![\w\-])") if alts else None

    def autolink(self, text, ctx_module, seen):
        if not getattr(self, "auto_re", None):
            return text
        parts = re.split(r"(\[[^\]]*\]\([^)]*\)|`[^`]*`)", text)
        out = []
        for p in parts:
            if p.startswith("`") or (p.startswith("[") and "](" in p):
                out.append(p)
                continue

            def rep(m):
                word = m.group(1)
                tid = self.auto_names.get(word)
                if not tid or tid in seen:
                    return word
                seen.add(tid)
                if ctx_module:
                    self.refs.setdefault(tid, set()).add(ctx_module)
                return f"[{word}](nima://term/{tid})"

            out.append(self.auto_re.sub(rep, p))
        return "".join(out)

    def resolve(self, name):
        s = slug(name)
        if s in self.alias:
            return self.alias[s]
        # tolerate plural / genitive endings
        for suf in ("s", "e", "es", "n", "en"):
            if s.endswith(suf) and s[: -len(suf)] in self.alias:
                return self.alias[s[: -len(suf)]]
        return None

    def inline(self, text, ctx_module=None):
        def rep(m):
            inner = m.group(1)
            target, _, label = inner.partition("|")
            target, label = target.strip(), (label or inner.split("|")[0]).strip()
            if target.startswith("mod:"):
                mid = target[4:]
                if mid not in self.module_ids:
                    warnings.append(f"Modul-Link unbekannt: {mid}")
                    return label
                return f"[{label}](nima://module/{mid})"
            tid = self.resolve(target)
            if not tid:
                self.unknown[target] = self.unknown.get(target, 0) + 1
                return f"**{label}**"
            if ctx_module:
                self.refs.setdefault(tid, set()).add(ctx_module)
            return f"[{label}](nima://term/{tid})"

        # nicht innerhalb von Inline-Code (`...`) verlinken
        parts = re.split(r"(`[^`]*`)", text)
        return "".join(p if p.startswith("`") and p.endswith("`") and len(p) > 1 else re.sub(r"\[\[([^\]]+)\]\]", rep, p) for p in parts)


def md_to_blocks(lines, linker, ctx, origin, seen=None):
    blocks = []
    i = 0
    para = []
    seen = set() if seen is None else seen
    al = lambda s: linker.autolink(s, ctx, seen)

    def flush_para():
        nonlocal para
        if para:
            blocks.append({"t": "p", "text": al(linker.inline(" ".join(x.strip() for x in para), ctx))})
            para = []

    while i < len(lines):
        line = lines[i]
        s = line.strip()
        if not s:
            flush_para(); i += 1; continue
        if s.startswith("```"):
            flush_para()
            lang = s[3:].strip()
            code = []
            i += 1
            while i < len(lines) and not lines[i].strip().startswith("```"):
                code.append(lines[i].rstrip("\n"))
                i += 1
            if i >= len(lines):
                errors.append(f"{origin}: Codeblock nicht geschlossen")
            blocks.append({"t": "code", "text": "\n".join(code), "lang": lang})
            i += 1
            continue
        m = re.match(r"^(#{3,4})\s+(.*)$", s)
        if m:
            flush_para()
            blocks.append({"t": "h3" if len(m.group(1)) == 3 else "h4", "text": linker.inline(m.group(2), ctx)})
            i += 1; continue
        if s.startswith(">"):
            flush_para()
            m = re.match(r"^>\s*\[!([A-ZÄÖÜ]+)\]\s*(.*)$", s)
            kind, title = ("INFO", "")
            body = []
            if m:
                kind, title = m.group(1), m.group(2).strip()
                if kind not in CALLOUTS:
                    warnings.append(f"{origin}: unbekannte Box {kind}")
                    kind = "INFO"
                i += 1
            while i < len(lines) and lines[i].strip().startswith(">"):
                body.append(lines[i].strip()[1:].strip())
                i += 1
            if not m:
                pass
            # split body into paragraphs / list items
            items = []
            for b in body:
                if not b:
                    continue
                items.append(al(linker.inline(b, ctx)))
            blocks.append({"t": "callout", "kind": kind.lower(), "title": linker.inline(title, ctx), "items": items})
            continue
        if s.startswith("|"):
            flush_para()
            rows = []
            while i < len(lines) and lines[i].strip().startswith("|"):
                row = lines[i].strip().strip("|")
                cells = [c.strip() for c in row.split("|")]
                if not all(re.match(r"^:?-{2,}:?$", c) for c in cells if c):
                    rows.append([linker.inline(c, ctx) for c in cells])
                i += 1
            if rows:
                blocks.append({"t": "table", "rows": rows})
            continue
        m = re.match(r"^!\[(.*?)\]\((asset:)?([^)]+)\)$", s)
        if m:
            flush_para()
            src = m.group(3)
            asset = CONTENT / "assets" / src
            if not asset.exists():
                errors.append(f"{origin}: Bild fehlt {src}")
            blocks.append({"t": "img", "src": src.replace("/", "__"), "text": m.group(1)})
            i += 1; continue
        if re.match(r"^(-|\*|•)\s+", s):
            flush_para()
            items = []
            while i < len(lines) and re.match(r"^\s*(-|\*|•)\s+", lines[i]):
                items.append(al(linker.inline(re.sub(r"^\s*(-|\*|•)\s+", "", lines[i]).strip(), ctx)))
                i += 1
            blocks.append({"t": "ul", "items": items})
            continue
        if re.match(r"^\d+[.)]\s+", s):
            flush_para()
            items = []
            while i < len(lines) and re.match(r"^\s*\d+[.)]\s+", lines[i]):
                items.append(al(linker.inline(re.sub(r"^\s*\d+[.)]\s+", "", lines[i]).strip(), ctx)))
                i += 1
            blocks.append({"t": "ol", "items": items})
            continue
        if re.match(r"^(---|\*\*\*)$", s):
            flush_para()
            blocks.append({"t": "hr"})
            i += 1; continue
        para.append(s)
        i += 1
    flush_para()
    return blocks


SERIES_SEP = re.compile(r"^@@@ MODULE @@@\s*$", re.M)


def parse_modules(path):
    """Eine Datei kann mehrere Module enthalten (Serien), getrennt durch '@@@ MODULE @@@'."""
    raw = path.read_text(encoding="utf-8").replace("\r", "")
    chunks = [c.strip("\n") + "\n" for c in SERIES_SEP.split(raw) if c.strip()]
    out = []
    for n, c in enumerate(chunks, 1):
        origin = path.name if len(chunks) == 1 else f"{path.name}#{n}"
        m = parse_module(path, c, origin)
        if m:
            out.append(m)
    return out


def parse_module(path, raw, origin):
    m = re.match(r"^---\n(.*?)\n---\n(.*)$", raw, re.S)
    if not m:
        errors.append(f"{origin}: Front-Matter fehlt")
        return None
    fm = {}
    for line in m.group(1).split("\n"):
        if ":" in line:
            k, v = line.split(":", 1)
            fm[k.strip().lower()] = v.strip()
    body = m.group(2).split("\n")
    mid = fm.get("id") or slug(path.stem)
    mod = {
        "id": mid,
        "title": fm.get("title", path.stem),
        "summary": fm.get("summary", ""),
        "icon": fm.get("icon", "book"),
        "difficulty": norm_diff(fm.get("difficulty")),
        "minutes": int(fm.get("minutes") or 0),
        "paths": split_list(fm.get("paths")),
        "order": float(fm.get("order") or 999),
        "htb": split_list(fm.get("htb")),
        "tags": split_list(fm.get("tags")),
        "source": fm.get("source", ""),
        "lessons": [],
        "quiz": [],
        "_body": body,
        "_file": origin,
    }
    return mod


def build_module_body(mod, linker):
    body = mod.pop("_body")
    origin = mod.pop("_file")
    lessons, cur, quiz_lines, in_quiz = [], None, [], False
    in_code = False
    for line in body:
        if line.strip().startswith("```"):
            in_code = not in_code
        if not in_code and re.match(r"^##\s+Quiz\s*$", line.strip(), re.I):
            in_quiz = True
            continue
        if in_quiz:
            quiz_lines.append(line)
            continue
        if not in_code and line.startswith("## "):
            cur = {"title": line[3:].strip(), "lines": []}
            lessons.append(cur)
            continue
        if cur is None:
            if line.strip():
                cur = {"title": "Einführung", "lines": []}
                lessons.append(cur)
            else:
                continue
        cur["lines"].append(line)
    words = 0
    for n, l in enumerate(lessons, 1):
        blocks = md_to_blocks(l["lines"], linker, mod["id"], origin)
        words += sum(len(" ".join(l["lines"]).split()) for _ in [0])
        mod["lessons"].append({"id": f"{mod['id']}.{n}", "title": linker.inline(l["title"]).replace("](nima://", "](nima://"), "blocks": blocks})
    if quiz_lines:
        qs, _ = parse_quiz("\n".join(quiz_lines), origin)
        mod["quiz"].extend(qs)
    mod["words"] = words
    if not mod["minutes"]:
        mod["minutes"] = max(5, round(words / 180))
    if not mod["lessons"]:
        warnings.append(f"{origin}: keine Lektionen")


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--strict", action="store_true")
    args = ap.parse_args()
    t0 = time.time()

    paths = json.loads((CONTENT / "paths.json").read_text(encoding="utf-8"))
    terms = load_glossary()
    files = sorted((CONTENT / "modules").rglob("*.md"))
    mods = [m for f in files for m in parse_modules(f)]
    ids = [m["id"] for m in mods]
    dup = {i for i in ids if ids.count(i) > 1}
    if dup:
        errors.append(f"Doppelte Modul-IDs: {dup}")
    linker = Linker(terms, set(ids))
    linker.build_auto(terms)
    for m in mods:
        build_module_body(m, linker)

    # attach PwnDeck question banks by HTB module name
    by_htb = {}
    for m in mods:
        for h in m["htb"]:
            by_htb.setdefault(slug(h), []).append(m)
    bank_count = 0
    for d in PWNDECK_DIRS:
        if not d.exists():
            continue
        for f in sorted(d.glob("*.txt")):
            qs, meta = parse_quiz(f.read_text(encoding="utf-8"), f.name)
            targets = []
            for h in split_list(meta.get("modul", "")):
                targets += by_htb.get(slug(h), [])
            if not targets:
                warnings.append(f"Quizbank {f.name}: kein passendes Modul ({meta.get('modul', '-')})")
                continue
            # attach to the first target only (avoid duplicates)
            targets[0]["quiz"].extend(qs)
            bank_count += len(qs)

    # question ids + difficulty defaults
    for m in mods:
        seen = set()
        for n, qq in enumerate(m["quiz"]):
            qid = f"{m['id']}#{slug(qq['q'])[:40]}"
            while qid in seen:
                qid += "x"
            seen.add(qid)
            qq["id"] = qid
            qq.setdefault("difficulty", m["difficulty"])
            qq["q"] = linker.inline(qq["q"]) if "[[" in qq["q"] else qq["q"]
            if qq.get("explain") and "[[" in qq["explain"]:
                qq["explain"] = linker.inline(qq["explain"])

    # glossary output
    gl = []
    for t in sorted(terms.values(), key=lambda x: x["term"].lower()):
        body = "\n".join(t["body"]).strip()
        paras = [linker.inline(p.strip().replace("\n", " ")) for p in re.split(r"\n\s*\n", body) if p.strip()]
        see = []
        for s in t["see"]:
            r = linker.resolve(s)
            if r and r != t["id"]:
                see.append(r)
            elif not r:
                linker.unknown[s] = linker.unknown.get(s, 0) + 1
        gl.append({"id": t["id"], "term": t["term"], "aka": t["aka"], "cat": t["cat"], "short": linker.inline(t["short"] or (paras[0][:160] if paras else "")),
                   "text": paras, "see": see, "modules": sorted(linker.refs.get(t["id"], []))})
    # backlinks: also terms referenced from other terms
    # paths
    path_out = []
    for p in paths:
        pm = sorted([m for m in mods if p["id"] in m["paths"]], key=lambda m: (m["order"], m["title"]))
        if not pm:
            warnings.append(f"Pfad {p['id']} hat keine Module")
        path_out.append({**p, "modules": [m["id"] for m in pm]})
    for m in mods:
        for pid in m["paths"]:
            if pid not in {p["id"] for p in paths}:
                errors.append(f"Modul {m['id']}: unbekannter Pfad {pid}")

    # images
    img_out = OUT / "img"
    if img_out.exists():
        shutil.rmtree(img_out)
    img_out.mkdir(parents=True, exist_ok=True)
    used = set()
    for m in mods:
        for l in m["lessons"]:
            for b in l["blocks"]:
                if b["t"] == "img":
                    used.add(b["src"])
    img_bytes = 0
    for src in used:
        orig = CONTENT / "assets" / src.replace("__", "/")
        if orig.exists():
            shutil.copy2(orig, img_out / src)
            img_bytes += orig.stat().st_size

    for m in mods:
        m.pop("htb", None)
    stats = {
        "modules": len(mods),
        "lessons": sum(len(m["lessons"]) for m in mods),
        "questions": sum(len(m["quiz"]) for m in mods),
        "terms": len(gl),
        "words": sum(m["words"] for m in mods),
        "images": len(used),
        "paths": len(path_out),
    }
    bundle = {"version": time.strftime("%Y.%m.%d-%H%M"), "stats": stats, "paths": path_out, "modules": mods, "glossary": gl}
    OUT.mkdir(parents=True, exist_ok=True)
    data = json.dumps(bundle, ensure_ascii=False, separators=(",", ":"))
    (OUT / "content.json").write_text(data, encoding="utf-8")

    print(f"NIMA content {bundle['version']}: " + ", ".join(f"{k}={v}" for k, v in stats.items()))
    print(f"content.json {len(data.encode()) / 1e6:.1f} MB, Bilder {img_bytes / 1e6:.1f} MB, Fragen aus Quizbanken {bank_count}, {time.time() - t0:.1f}s")
    if linker.unknown:
        top = sorted(linker.unknown.items(), key=lambda x: -x[1])
        print(f"Unbekannte Begriffe ({len(top)}): " + ", ".join(f"{k}({v})" for k, v in top[:60]))
    for w in warnings[:40]:
        print("WARN", w)
    if len(warnings) > 40:
        print(f"... {len(warnings) - 40} weitere Warnungen")
    for e in errors:
        print("ERROR", e)
    if errors and args.strict:
        sys.exit(1)


if __name__ == "__main__":
    main()
