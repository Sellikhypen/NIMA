# NIMA – Cyber Academy (iOS 18)

Lern-App für alle Hack-The-Box-Zertifikate (CJCA, CPTS, CWES/CBBH, CDSA, CWEE, CAPE), WiFi-Pentesting,
Cyber Security Specialist und die eigene Cyber Range.

**Umfang:** 470 Module · 2.664 Lektionen (inkl. kurzer Einstiege und Vertiefungen) · 3.887 Modulfragen (+ ~1.000 generierte Begriffsfragen) · 1.007 Lexikonbegriffe.

## Lernkonzept (App 2.0)

- **Einfach rein, tief raus:** Jedes Modul beginnt mit einer Einstiegslektion („Einfach erklärt“ oder Überblick) und hat mindestens eine
  Vertiefung. Bei den 230 Modulen der ersten Ausbaustufe ist das eine kurze Lektion mit Denkaufgabe (`content/vertiefung/*.md`).
- **Wissens-Check** nach jeder Lektion (1–3 Fragen, vom Compiler per Textähnlichkeit der Lektion zugeordnet).
- **Erklär-Panel:** 59 % der Fragen (2.280 von 3.887) haben eine geschriebene Erklärung. Weitere 36 % zeigen nur einen
  automatisch gewählten Satz aus der Lektion, der nicht immer passt.
- **Spaced Repetition 2.0:** SM-2-Variante (Leichtigkeit, Intervalle, Problemkarten/Leeches), Karteikarten mit Nochmal/Schwer/Gut/Leicht,
  Migration alter Leitner-Boxen.
- **Zwei Fortschrittsachsen:** 15 XP-Ränge (Fleiß, bis Level 100) und Elo-basierte **Skill-Ligen** (Können) gesamt und pro Pfad.
- **Motivation:** Tages-/Wochenmissionen mit Truhe, Streak-Freeze, Shop (Booster, Farbthemen), 60+ Achievements, Pfad-Zertifikate.
- **Modi:** Training (leicht → schwer), Karteikarten, Terminal-Drill, Schwierigkeitsfilter, Begriffe-Training, Blitz, Survival, Daily Box,
  Prüfungssimulation, Fehlerbuch.
- **Werkzeuge:** Lernplan mit Zieldatum, Notizen & Lesezeichen pro Lektion, Statistik (Kalender, Prognose, Skill), Einstellungen
  (Textgröße, SRS-Intensität, Prüfungsparameter, Erinnerung, Backup/Import), Onboarding.

## Aufbau

| Pfad | Inhalt |
|---|---|
| `App/` | SwiftUI-Quellcode (iOS 18) |
| `App/Content/` | wird beim Build erzeugt: `content.json` + Bilder |
| `content/paths.json` | Lernpfade |
| `content/modules/<pfad>/*.md` | Module (Markdown mit Front-Matter, Lektionen = `##`, Quiz = `## Quiz`) |
| `content/glossary/*.md` | Lexikon (`## Begriff`, `kat:`, `kurz:`, `siehe:`) |
| `content/quizbanks/*.txt` | Fragen im PwnDeck-Format, Zuordnung über `# modul:` ↔ `htb:` im Modul oder Abschnitte `=== modul-id ===` |
| `content/einfach/*.md` | „Einfach erklärt“-Einstiege für Module (`## modul-id` + Text, wird Lektion 0) |
| `content/vertiefung/*.md` | Vertiefungen (`## modul-id \| Thema` + Text, wird letzte Lektion `<id>.deep`) |
| `content/erklaerungen/*.txt` | nachgetragene Erklärungen (`fragen-id \| Text`) |
| `content/modules/series2/*.md` | Serien der Ausbaustufe 2.0 (mehrere Module je Datei, getrennt durch `@@@ MODULE @@@`) |
| `content/assets/` | Bilder (`![Text](asset:ordner/datei.png)`) |
| `tools/build_content.py` | Content-Compiler mit Prüfung (`--strict`) |
| `tools/convert_docx.py` | Cyber-Range-Dokumentation (.docx) → Module |
| `.github/workflows/build-ipa.yml` | baut die unsignierte IPA auf macOS (Artefakt + Release) |

## Stand der Inhalte

Die Inhalte der Ausbaustufe 2.0 sind mit KI-Unterstützung aus Modellwissen geschrieben und **nicht vollständig gegen Quellen geprüft**.
Stichprobenartig mit Websuche abgeglichen wurden am 22.11.2026 einzelne zeitkritische Punkte (ATT&CK v19, OWASP Top 10:2025,
NIST SP 800-61r3, NIS2-Umsetzung, KRITIS-Dachgesetz, Grundschutz++, TLS-Laufzeiten, HTB-Zertifikate). Keine Rechtsberatung.

## IPA bauen

Jeder Push auf `main` startet die GitHub Action. Die IPA liegt danach unter **Actions → Artefakt `NIMA-ipa`**
und als **Release**. Installation per AltStore oder Sideloadly (die signieren mit deiner Apple-ID).

Lokal prüfen: `python tools/build_content.py --strict`

## Inhalte erweitern

Neues Modul = neue `.md`-Datei unter `content/modules/…` mit Front-Matter (`id`, `title`, `paths`, `order`,
`difficulty`, `icon`, `summary`). Fachbegriffe mit `[[Begriff]]` verlinken – fehlende Begriffe meldet der Compiler.
