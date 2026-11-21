# NIMA – Cyber Academy (iOS 18)

Lern-App für alle Hack-The-Box-Zertifikate (CJCA, CPTS, CWES/CBBH, CDSA, CWEE, CAPE), WiFi-Pentesting,
Cyber Security Specialist und die eigene Cyber Range. Gamification aus PwnDeck: XP, Ränge, Flags, Streaks,
Lernkartei (Spaced Repetition), Prüfungssimulation, Blitz, Karteikarten, Lexikon mit verlinkten Fachbegriffen.

## Aufbau

| Pfad | Inhalt |
|---|---|
| `App/` | SwiftUI-Quellcode (iOS 18) |
| `App/Content/` | wird beim Build erzeugt: `content.json` + Bilder |
| `content/paths.json` | Lernpfade |
| `content/modules/<pfad>/*.md` | Module (Markdown mit Front-Matter, Lektionen = `##`, Quiz = `## Quiz`) |
| `content/glossary/*.md` | Lexikon (`## Begriff`, `kat:`, `kurz:`, `siehe:`) |
| `content/quizbanks/*.txt` | Fragen im PwnDeck-Format, Zuordnung über `# modul:` ↔ `htb:` im Modul |
| `content/assets/` | Bilder (`![Text](asset:ordner/datei.png)`) |
| `tools/build_content.py` | Content-Compiler mit Prüfung (`--strict`) |
| `tools/convert_docx.py` | Cyber-Range-Dokumentation (.docx) → Module |
| `.github/workflows/build-ipa.yml` | baut die unsignierte IPA auf macOS (Artefakt + Release) |

## IPA bauen

Jeder Push auf `main` startet die GitHub Action. Die IPA liegt danach unter **Actions → Artefakt `NIMA-ipa`**
und als **Release**. Installation per AltStore oder Sideloadly (die signieren mit deiner Apple-ID).

Lokal prüfen: `python tools/build_content.py --strict`

## Inhalte erweitern

Neues Modul = neue `.md`-Datei unter `content/modules/…` mit Front-Matter (`id`, `title`, `paths`, `order`,
`difficulty`, `icon`, `summary`). Fachbegriffe mit `[[Begriff]]` verlinken – fehlende Begriffe meldet der Compiler.
