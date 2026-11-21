#!/usr/bin/env python3
"""Wandelt die Cyber-Range-Dokumentation (.docx) in NIMA-Markdown-Module um.

Kapitel (Heading1)  -> ein Modul  content/modules/cyberrange/cr-XX-*.md
Unterkapitel (H2)   -> eine Lektion (## ...)
H3                  -> ### Überschrift
1x1-Tabellen mit Symbol (ℹ ➜ ⚠ ⛔ ✔) -> Hinweisboxen  > [!KIND]
Consolas-Absätze    -> Codeblöcke
Bilder              -> content/assets/cyberrange/*.png
Glossar-Kapitel     -> content/glossary/cyberrange.md

Aufruf: python tools/convert_docx.py <datei.docx>
"""
import re
import sys
import zipfile
import xml.etree.ElementTree as ET
from pathlib import Path

W = "http://schemas.openxmlformats.org/wordprocessingml/2006/main"
R = "http://schemas.openxmlformats.org/officeDocument/2006/relationships"
A = "http://schemas.openxmlformats.org/drawingml/2006/main"
PR = "http://schemas.openxmlformats.org/package/2006/relationships"
ns = {"w": W, "r": R, "a": A}
q = lambda tag: "{%s}%s" % (W, tag)

ROOT = Path(__file__).resolve().parent.parent
OUT_MOD = ROOT / "content" / "modules" / "cyberrange"
OUT_IMG = ROOT / "content" / "assets" / "cyberrange"
OUT_GLO = ROOT / "content" / "glossary"

ICONS = {"ℹ": "INFO", "➜": "TIPP", "⚠": "WARNUNG", "⛔": "GEFAHR", "✔": "ERGEBNIS", "✅": "ERGEBNIS", "💡": "TIPP"}
SKIP_CHAPTERS = ("dokumentinformationen", "inhaltsverzeichnis")
CH_ICON = {
    1: "book.pages", 2: "square.3.layers.3d", 3: "server.rack", 4: "cpu", 5: "network", 6: "gearshape.2",
    7: "building.2", 8: "waveform.path.ecg", 9: "person.badge.key", 10: "lock.shield", 11: "books.vertical",
    12: "person.3", 13: "brain", 14: "arrow.left.arrow.right", 15: "shippingbox", 16: "globe.europe.africa",
    17: "desktopcomputer", 18: "hammer", 19: "chart.line.uptrend.xyaxis", 20: "scope", 21: "trophy",
    22: "wrench.and.screwdriver", 23: "eye", 24: "list.bullet.rectangle", 25: "bolt.horizontal",
    26: "shippingbox.circle", 27: "slider.horizontal.3", 28: "speedometer", 29: "externaldrive",
    30: "exclamationmark.shield", 31: "graduationcap", 32: "shield.lefthalf.filled", 33: "calendar",
    34: "checklist", 36: "doc.text.magnifyingglass",
}


# Zuordnung der vorhandenen PwnDeck-Cyber-Range-Decks (# modul:) zu den Kapiteln
CH_HTB = {
    1: "Cyber Range 01 · Grundlagen & Zweck", 2: "Cyber Range 02 · Architektur: Ebenen & Schichten",
    3: "Cyber Range 03 · L0 Hardware", 4: "Cyber Range 04 · L1 Virtualisierung",
    5: "Cyber Range 05 · L2 Netzwerk & Firewall", 6: "Cyber Range 06 · L3 Automatisierung",
    7: "Cyber Range 07 · L4 Szenario & Inhalte", 8: "Cyber Range 08 · L5 Monitoring & Erkennung",
    9: "Cyber Range 09 · L6 Zugang & Identität", 14: "Cyber Range 10 · Protokolle & Pakete",
    22: "Cyber Range 11 · Betrieb & Skalierung", 31: "Cyber Range 12 · Übungsbetrieb & Didaktik",
    10: "Cyber Range 13 · Sicherheit & Recht", 25: "Cyber Range 14 · OT/ICS & Container",
    16: "Cyber Range 15 · Referenzprojekte & Orchestrierung", 11: "Cyber Range 16 · Fachbegriffe (Glossar)",
}


def slug(s):
    s = s.lower().replace("ä", "ae").replace("ö", "oe").replace("ü", "ue").replace("ß", "ss")
    return re.sub(r"[^a-z0-9]+", "-", s).strip("-")[:48] or "x"


def run_text(run):
    out = []
    for el in run:
        if el.tag == q("t"):
            out.append(el.text or "")
        elif el.tag == q("tab"):
            out.append("    ")
        elif el.tag in (q("br"), q("cr")):
            out.append("\n")
    return "".join(out)


def run_props(run):
    rpr = run.find("w:rPr", ns)
    bold = mono = italic = False
    if rpr is not None:
        b = rpr.find("w:b", ns)
        bold = b is not None and b.get(q("val"), "1") not in ("0", "false")
        i = rpr.find("w:i", ns)
        italic = i is not None and i.get(q("val"), "1") not in ("0", "false")
        f = rpr.find("w:rFonts", ns)
        mono = f is not None and "consolas" in (f.get(q("ascii")) or "").lower()
    return bold, italic, mono


def para_runs(p):
    """yield (text, bold, italic, mono) for all runs incl. hyperlinks"""
    for el in p.iter():
        if el.tag == q("r"):
            t = run_text(el)
            if t:
                b, i, m = run_props(el)
                yield t, b, i, m


def inline_md(p):
    parts = []
    for t, b, i, m in para_runs(p):
        if m:
            t = t.replace("`", "'")
            parts.append(("code", t))
        elif b:
            parts.append(("b", t))
        else:
            parts.append(("t", t))
    # merge neighbours of same type
    merged = []
    for k, t in parts:
        if merged and merged[-1][0] == k:
            merged[-1] = (k, merged[-1][1] + t)
        else:
            merged.append((k, t))
    out = []
    for k, t in merged:
        if not t.strip():
            out.append(t)
            continue
        lead = t[: len(t) - len(t.lstrip())]
        trail = t[len(t.rstrip()):]
        core = t.strip()
        if k == "code":
            out.append(f"{lead}`{core}`{trail}")
        elif k == "b":
            out.append(f"{lead}**{core}**{trail}")
        else:
            out.append(t.replace("[[", "[ [").replace("]]", "] ]"))
    return "".join(out).strip()


def plain(el):
    return "".join(t for t, *_ in para_runs(el))


def is_mono_para(p):
    runs = list(para_runs(p))
    txt = "".join(r[0] for r in runs).strip()
    if not txt:
        return False
    mono_len = sum(len(r[0]) for r in runs if r[3])
    return mono_len >= 0.8 * sum(len(r[0]) for r in runs)


def pstyle(p):
    ps = p.find("w:pPr/w:pStyle", ns)
    return ps.get(q("val")) if ps is not None else ""


class Numbering:
    def __init__(self, z):
        self.fmt = {}
        try:
            root = ET.fromstring(z.read("word/numbering.xml"))
        except KeyError:
            return
        absfmt = {}
        for an in root.findall("w:abstractNum", ns):
            lvl = an.find("w:lvl", ns)
            nf = lvl.find("w:numFmt", ns) if lvl is not None else None
            absfmt[an.get(q("abstractNumId"))] = nf.get(q("val")) if nf is not None else "bullet"
        for n in root.findall("w:num", ns):
            a = n.find("w:abstractNumId", ns)
            self.fmt[n.get(q("numId"))] = absfmt.get(a.get(q("val")) if a is not None else "", "bullet")

    def ordered(self, p):
        n = p.find("w:pPr/w:numPr/w:numId", ns)
        if n is None:
            return False
        return self.fmt.get(n.get(q("val")), "bullet") not in ("bullet", "none")


def main(docx):
    z = zipfile.ZipFile(docx)
    rels = {}
    for rel in ET.fromstring(z.read("word/_rels/document.xml.rels")):
        rels[rel.get("Id")] = rel.get("Target")
    numbering = Numbering(z)
    body = ET.fromstring(z.read("word/document.xml")).find("w:body", ns)

    OUT_MOD.mkdir(parents=True, exist_ok=True)
    OUT_IMG.mkdir(parents=True, exist_ok=True)
    OUT_GLO.mkdir(parents=True, exist_ok=True)
    for old in OUT_MOD.glob("*.md"):
        old.unlink()

    chapters = []  # list of dict(title, num, lines)
    cur = None
    img_count = 0
    last_was_img = False
    glossary_rows = []

    def emit(line):
        if cur is not None:
            cur["lines"].append(line)

    def flush_code(buf):
        if buf:
            emit("```")
            for l in buf:
                emit(l.rstrip())
            emit("```")
            emit("")

    code_buf = []
    for el in body:
        if el.tag == q("p"):
            st = pstyle(el)
            txt = plain(el).strip()
            # images
            blips = el.findall(".//a:blip", ns)
            if blips:
                flush_code(code_buf); code_buf = []
                for b in blips:
                    rid = b.get("{%s}embed" % R)
                    target = rels.get(rid)
                    if not target or cur is None:
                        continue
                    data = z.read("word/" + target)
                    img_count += 1
                    ext = Path(target).suffix.lower() or ".png"
                    name = f"cr-{cur['num']:02d}-{img_count:03d}{ext}"
                    (OUT_IMG / name).write_bytes(data)
                    emit(f"![](asset:cyberrange/{name})")
                    emit("")
                    last_was_img = True
                continue
            if st == "Heading1":
                flush_code(code_buf); code_buf = []
                m = re.match(r"^(\d+)\s+(.*)$", txt)
                num = int(m.group(1)) if m else 0
                title = m.group(2).strip() if m else txt
                if txt.lower().startswith(SKIP_CHAPTERS) or not m:
                    cur = None
                    continue
                cur = {"num": num, "title": title, "lines": []}
                chapters.append(cur)
                continue
            if cur is None:
                continue
            if st == "Heading2":
                flush_code(code_buf); code_buf = []
                t = re.sub(r"^\d+(\.\d+)*\s+", "", txt)
                emit(f"## {t}")
                emit("")
                continue
            if st == "Heading3":
                flush_code(code_buf); code_buf = []
                emit(f"### {txt}")
                emit("")
                continue
            if is_mono_para(el):
                code_buf.append(plain(el))
                continue
            flush_code(code_buf); code_buf = []
            if not txt:
                continue
            md = inline_md(el)
            if last_was_img and re.match(r"^(Abbildung|Abb\.|Bild)\s*\d+", txt):
                cur["lines"][-2] = f"![{txt}](asset:cyberrange/{cur['lines'][-2].split('/')[-1][:-1]})"
                last_was_img = False
                continue
            last_was_img = False
            if st == "ListParagraph":
                emit(("1. " if numbering.ordered(el) else "- ") + md)
                continue
            if cur["lines"] and (cur["lines"][-1].startswith("- ") or cur["lines"][-1].startswith("1. ")):
                emit("")
            emit(md)
            emit("")
        elif el.tag == q("tbl"):
            flush_code(code_buf); code_buf = []
            last_was_img = False
            if cur is None:
                continue
            rows = el.findall("w:tr", ns)
            cells = [r.findall("w:tc", ns) for r in rows]
            ncell = sum(len(c) for c in cells)
            if ncell == 1:
                tc = cells[0][0]
                paras = tc.findall(".//w:p", ns)
                texts = [plain(p).strip() for p in paras]
                full = [t for t in texts if t]
                if not full:
                    continue
                nonempty = [p for p in paras if plain(p).strip()]
                monos = [p for p in nonempty if is_mono_para(p)]
                if monos and len(monos) >= 0.6 * len(nonempty):
                    started = False
                    for p in paras:
                        t = plain(p).rstrip()
                        if is_mono_para(p) or (started and not t.strip()):
                            if not started:
                                emit("```")
                                started = True
                            emit(t)
                        elif t.strip():
                            if started:
                                emit("```")
                                emit("")
                                started = False
                            emit(f"**{t.strip()}**")
                            emit("")
                    if started:
                        emit("```")
                    emit("")
                    continue
                head = full[0]
                kind = None
                for ic, k in ICONS.items():
                    if head.startswith(ic):
                        kind = k
                        head = head[len(ic):].strip()
                        break
                if kind:
                    emit(f"> [!{kind}] {head}")
                    for p in paras[1:] if plain(paras[0]).strip() else paras:
                        t = inline_md(p)
                        if t:
                            emit(f"> {t}")
                    emit("")
                else:
                    emit("> [!INFO]")
                    for p in paras:
                        t = inline_md(p)
                        if t:
                            emit(f"> {t}")
                    emit("")
                continue
            # data table
            table = []
            for r in cells:
                row = []
                for tc in r:
                    parts = [inline_md(p) for p in tc.findall(".//w:p", ns)]
                    cell = " ".join(x for x in parts if x).replace("|", "/")
                    row.append(cell)
                table.append(row)
            if cur["title"].lower().startswith("glossar"):
                glossary_rows.extend(table)
                continue
            width = max(len(r) for r in table)
            emit("| " + " | ".join(table[0] + [""] * (width - len(table[0]))) + " |")
            emit("|" + "---|" * width)
            for r in table[1:]:
                emit("| " + " | ".join(r + [""] * (width - len(r))) + " |")
            emit("")
    flush_code(code_buf)

    # write modules
    written = 0
    for ch in chapters:
        t = ch["title"]
        if t.lower().startswith("glossar"):
            # glossary can also be paragraphs "Begriff – Erklärung"
            for line in ch["lines"]:
                m = re.match(r"^(?:- )?\*\*(.+?)\*\*\s*[–:-]\s*(.+)$", line)
                if m:
                    glossary_rows.append([m.group(1), m.group(2)])
            continue
        lines = ch["lines"]
        # ensure content before first lesson becomes an intro lesson
        first_h2 = next((i for i, l in enumerate(lines) if l.startswith("## ")), None)
        if first_h2 is None or any(l.strip() for l in lines[:first_h2]):
            lines = ["## Überblick", ""] + lines if first_h2 != 0 else lines
        fm = [
            "---",
            f"id: cr-{ch['num']:02d}",
            f"title: {t}",
            "paths: cyberrange",
            f"order: {ch['num']}",
            "difficulty: " + ("easy" if ch["num"] in (1, 2, 11, 12, 13) else "hard" if ch["num"] >= 23 else "medium"),
            f"icon: {CH_ICON.get(ch['num'], 'book')}",
            f"summary: Kapitel {ch['num']} deiner Cyber-Range-Dokumentation: {t}.",
            "source: Cyber_Range_Dokumentation.docx",
            f"htb: {CH_HTB.get(ch['num'], '')}",
            "---",
            "",
        ]
        text = "\n".join(fm + lines)
        text = re.sub(r"\n{3,}", "\n\n", text)
        (OUT_MOD / f"cr-{ch['num']:02d}-{slug(t)}.md").write_text(text.strip() + "\n", encoding="utf-8")
        written += 1

    # glossary
    gl = ["# Glossar aus der Cyber-Range-Dokumentation", ""]
    seen = set()
    for row in glossary_rows:
        if len(row) < 2:
            continue
        term, desc = row[0].strip().strip("*"), " ".join(row[1:]).strip()
        if not term or not desc or term.lower() in ("begriff", "abkürzung", "term") or term.lower() in seen:
            continue
        seen.add(term.lower())
        gl += [f"## {term}", "kat: Cyber Range", f"kurz: {desc.split('. ')[0].rstrip('.')}.", "", desc, ""]
    (OUT_GLO / "cyberrange.md").write_text("\n".join(gl), encoding="utf-8")
    print(f"{written} Module, {img_count} Bilder, {len(seen)} Glossar-Begriffe")


if __name__ == "__main__":
    main(sys.argv[1] if len(sys.argv) > 1 else str(Path.home() / "Desktop/CY_Range/Cyber_Range_Dokumentation.docx"))
