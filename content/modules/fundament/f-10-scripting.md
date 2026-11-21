---
id: f-10
title: Scripting – Bash, Python, PowerShell
paths: grundlagen, cjca, cdsa
order: 10
difficulty: medium
icon: chevron.left.forwardslash.chevron.right
summary: Warum Automatisierung im Security-Alltag unverzichtbar ist und wie du mit Bash, Python und PowerShell Logs auswertest, Daten verarbeitest und Routineaufgaben erledigst.
htb: Introduction to Bash Scripting
---

## Warum Skripten?

Ob Pentester, SOC-Analyst oder Administrator: Wiederkehrende Aufgaben kosten Zeit und sind fehleranfällig. Ein kleines Skript, das tausend Logzeilen filtert, Ergebnisse sortiert oder hundert Hosts prüft, spart Stunden – und macht Arbeit nachvollziehbar und wiederholbar, was für Dokumentation und Reports entscheidend ist.

## Bash

Bash ist die Standard-Shell der meisten Linux-Systeme. Stärken: Programme verketten, Dateien verarbeiten, schnelle Einzeiler.

```bash
#!/usr/bin/env bash
# Fehlgeschlagene SSH-Logins pro IP zählen
grep "Failed password" /var/log/auth.log \
  | grep -oE "from [0-9.]+" \
  | awk '{print $2}' \
  | sort | uniq -c | sort -rn | head
```

| Baustein | Beispiel |
|---|---|
| Variable | `ziel="10.0.0.5"`, Zugriff `"$ziel"` |
| Bedingung | `if [[ -f datei ]]; then …; fi` |
| Schleife | `for h in $(cat hosts.txt); do …; done` |
| Funktion | `pruefe() { echo "$1"; }` |
| Exit-Code | `$?` – 0 bedeutet Erfolg |

> [!TIPP] Immer zitieren
> Schreibe Variablen in Anführungszeichen (`"$var"`). Sonst zerlegt die Shell Inhalte mit Leerzeichen oder Sonderzeichen – eine häufige Quelle für Fehler und Sicherheitslücken.

## Python

Python ist die Sprache der Security-Welt: lesbar, mit riesiger Bibliothek. Viele Werkzeuge (z. B. Impacket, Volatility) sind in Python geschrieben.

```python
import re
from collections import Counter

ips = Counter()
with open("access.log", encoding="utf-8", errors="replace") as f:
    for line in f:
        m = re.match(r"(\d+\.\d+\.\d+\.\d+)", line)
        if m and " 404 " in line:
            ips[m.group(1)] += 1

for ip, n in ips.most_common(10):
    print(f"{ip:15} {n} x 404")
```

Nützliche Module: `requests` (HTTP), `socket` (Netzwerk), `json`, `csv`, `re` (reguläre Ausdrücke), `hashlib`, `base64`, `argparse` (Kommandozeilenargumente), `subprocess` (Programme aufrufen – mit Argumentlisten statt Shell-Strings).

## PowerShell

PowerShell ist auf Windows unverzichtbar und arbeitet mit Objekten:

```powershell
# Fehlgeschlagene Anmeldungen der letzten 24 Stunden nach Konto gruppieren
Get-WinEvent -FilterHashtable @{LogName='Security'; Id=4625; StartTime=(Get-Date).AddDays(-1)} |
  ForEach-Object { $_.Properties[5].Value } |
  Group-Object | Sort-Object Count -Descending | Select-Object -First 10 Count, Name
```

> [!INFO] Execution Policy
> Die Execution Policy (`Get-ExecutionPolicy`) ist eine Schutzfunktion gegen versehentliches Ausführen von Skripten, **keine** Sicherheitsgrenze. Für echte Kontrolle sorgen Application Control (AppLocker, WDAC), Constrained Language Mode und Logging.

## Reguläre Ausdrücke

Reguläre Ausdrücke beschreiben Textmuster und sind in allen drei Sprachen sowie in SIEM-Abfragen und YARA-Regeln zu finden.

| Muster | Bedeutung |
|---|---|
| `\d` | Ziffer |
| `\w` | Buchstabe, Ziffer oder _ |
| `\s` | Leerraum |
| `.` | beliebiges Zeichen |
| `*`, `+`, `?` | 0+, 1+, 0–1 Wiederholungen |
| `{2,4}` | 2 bis 4 Wiederholungen |
| `^`, `$` | Anfang, Ende |
| `( )` | Gruppe |

Beispiel für eine IPv4-ähnliche Zeichenkette: `\b(?:\d{1,3}\.){3}\d{1,3}\b`

## Gute Praxis

- Skripte versionieren (Git), kommentieren, mit Parametern statt fest codierten Werten.
- Keine Passwörter im Skript – Umgebungsvariablen oder Secret-Stores nutzen.
- Fehler abfangen und sinnvolle Ausgaben erzeugen.
- Bei Arbeit an Kundensystemen: Was das Skript tut, muss vorher klar und im Scope erlaubt sein.

## Quiz

? Welcher Exit-Code bedeutet in Bash Erfolg?
= 0

? Mit welchem Zeichen verbindet man in Bash die Ausgabe eines Programms mit der Eingabe des nächsten?
= |
= Pipe

? Welches Python-Modul eignet sich für HTTP-Anfragen?
= requests

? Wofür steht `\d` in regulären Ausdrücken?
+ eine Ziffer
- ein Buchstabe
- ein Leerzeichen
- ein beliebiges Zeichen

?tf Die PowerShell Execution Policy ist eine Sicherheitsgrenze.
= falsch

? Warum sollte man Variablen in Bash in Anführungszeichen schreiben?
+ Damit Inhalte mit Leerzeichen oder Sonderzeichen nicht zerlegt werden
- Damit das Skript schneller läuft
- Weil Bash sonst keine Variablen kennt
- Damit die Variable verschlüsselt wird

? Welche Bash-Befehle kombiniert man typischerweise, um Vorkommen zu zählen und zu sortieren?
+ sort | uniq -c | sort -rn
- cat | echo | ls
- grep | chmod | cut
- find | rm | mv

? Mit welchem Cmdlet liest man Windows-Ereignisprotokolle?
= Get-WinEvent
