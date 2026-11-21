---
id: py-01
title: Python 1 · Grundlagen für Security
paths: grundlagen, cjca, cdsa
order: 40
difficulty: easy
icon: chevron.left.forwardslash.chevron.right
tags: python
summary: Datentypen, Listen und Dictionaries, Bedingungen, Schleifen, Funktionen, Dateien und Fehlerbehandlung – das Python, das man für Skripte im Security-Alltag braucht.
---

## Warum Python?

Python ist lesbar, auf fast jedem System verfügbar und hat Bibliotheken für alles: Netzwerk, Web, Kryptografie, Datenanalyse. Viele Security-Werkzeuge sind in Python geschrieben.

## Datentypen

```python
name = "srv01"            # str
port = 443                # int
quote = 0.97              # float
aktiv = True              # bool
ports = [22, 80, 443]     # list
host = {"name": "srv01", "ip": "10.0.0.5", "ports": ports}   # dict
erlaubt = {"tcp", "udp"}  # set
```

## Kontrollstrukturen

```python
for p in ports:
    if p < 1024:
        print(f"{p} ist ein privilegierter Port")
    elif p == 8080:
        print("Alternativer HTTP-Port")
    else:
        continue

zaehler = 0
while zaehler < 3:
    zaehler += 1
```

**List Comprehensions** fassen Schleifen kompakt:

```python
web = [p for p in ports if p in (80, 443)]
```

## Funktionen

```python
def ist_privat(ip: str) -> bool:
    erstes = int(ip.split(".")[0])
    return erstes == 10 or ip.startswith("192.168.")

print(ist_privat("10.10.14.5"))
```

> [!TIPP] Bibliotheken statt Eigenbau
> Für IP-Adressen gibt es das Modul `ipaddress`: `ipaddress.ip_address("10.0.0.5").is_private` ist korrekter als jede selbst geschriebene Prüfung.

## Dateien und Fehler

```python
try:
    with open("hosts.txt", encoding="utf-8") as f:
        hosts = [z.strip() for z in f if z.strip()]
except FileNotFoundError:
    print("hosts.txt fehlt")
    hosts = []
```

`with` schließt Dateien automatisch, `try/except` fängt erwartbare Fehler ab.

## Quiz

? Welcher Datentyp speichert Schlüssel-Wert-Paare?
= dict
= Dictionary

? Welches Modul prüft IP-Adressen zuverlässig, z. B. ob sie privat sind?
= ipaddress

? Was bewirkt `with open(...)`?
+ Die Datei wird automatisch geschlossen
- Die Datei wird verschlüsselt
- Die Datei wird gelöscht
- Die Datei wird schneller gelesen

? Mit welchem Konstrukt fängt man Fehler ab?
= try/except
= try except

? Wie heißt die kompakte Schreibweise `[p for p in ports if p > 1024]`?
= List Comprehension

@@@ MODULE @@@
---
id: py-02
title: Python 2 · Logs und Daten automatisiert auswerten
paths: cdsa, grundlagen
order: 41
difficulty: medium
icon: chart.bar.doc.horizontal
tags: python
summary: Logdateien parsen, reguläre Ausdrücke, Counter, CSV und JSON, Zeitstempel und ein vollständiges Beispielskript für eine SOC-Auswertung.
---

## Logzeilen parsen

```python
import re
from collections import Counter

muster = re.compile(r'(?P<ip>\d+\.\d+\.\d+\.\d+) .* "(?P<methode>\w+) (?P<pfad>\S+) [^"]+" (?P<status>\d{3})')
status = Counter()
ips_404 = Counter()

with open("access.log", encoding="utf-8", errors="replace") as f:
    for zeile in f:
        m = muster.search(zeile)
        if not m:
            continue
        status[m["status"]] += 1
        if m["status"] == "404":
            ips_404[m["ip"]] += 1

print(status.most_common())
print(ips_404.most_common(10))
```

## CSV und JSON

```python
import csv, json

with open("ergebnis.csv", "w", newline="", encoding="utf-8") as f:
    w = csv.writer(f)
    w.writerow(["ip", "anzahl"])
    w.writerows(ips_404.most_common())

with open("events.json", encoding="utf-8") as f:
    events = json.load(f)
hoch = [e for e in events if e.get("severity") == "high"]
```

## Zeitstempel

```python
from datetime import datetime, timezone, timedelta
t = datetime.strptime("21/Nov/2026:12:00:00 +0000", "%d/%b/%Y:%H:%M:%S %z")
vor_einer_stunde = datetime.now(timezone.utc) - timedelta(hours=1)
```

> [!MERKE] Zeitzonen
> Immer mit zeitzonenbewussten Zeitstempeln arbeiten und intern in UTC rechnen – sonst passen Ereignisse aus verschiedenen Quellen nicht zusammen.

## Kommandozeilenargumente

```python
import argparse
p = argparse.ArgumentParser(description="404-Auswertung")
p.add_argument("logdatei")
p.add_argument("--top", type=int, default=10)
args = p.parse_args()
```

## Quiz

? Welche Klasse zählt Häufigkeiten bequem?
= Counter
= collections.Counter

? Welches Modul liest und schreibt CSV-Dateien?
= csv

? Welche Funktion lädt JSON aus einer Datei?
= json.load

? In welcher Zeitzone sollte intern gerechnet werden?
= UTC

? Welches Modul verarbeitet Kommandozeilenargumente?
= argparse

? Welche Option beim Öffnen verhindert Abbrüche durch ungültige Zeichen?
= errors="replace"
= errors=replace

@@@ MODULE @@@
---
id: py-03
title: Python 3 · HTTP, APIs und Netzwerk
paths: cwes, grundlagen
order: 42
difficulty: medium
icon: network
tags: python
summary: HTTP-Anfragen mit requests, Sessions und Header, REST-APIs ansprechen, Zeitlimits und Fehlerbehandlung, Sockets und sichere Gewohnheiten beim Skripten gegen Webdienste.
---

## requests

```python
import requests

s = requests.Session()
s.headers.update({"User-Agent": "nima-skript/1.0"})
r = s.get("https://api.example.org/v1/status", timeout=10)
r.raise_for_status()
daten = r.json()

r = s.post("https://api.example.org/v1/login",
           json={"user": "alice", "password": "…"}, timeout=10)
token = r.json()["token"]
s.headers["Authorization"] = f"Bearer {token}"
```

| Aspekt | Gute Praxis |
|---|---|
| `timeout` | immer setzen, sonst kann ein Skript ewig hängen |
| `raise_for_status()` | HTTP-Fehler nicht übersehen |
| Session | Cookies und Header wiederverwenden, schneller |
| Zertifikate | `verify=True` (Standard) beibehalten; eigene CAs über `verify="ca.pem"` |
| Geheimnisse | aus Umgebungsvariablen lesen, nicht im Code |
| Rate Limits | Pausen, Retry mit Backoff |

## Paginierung

```python
url = "https://api.example.org/v1/items?page=1"
alle = []
while url:
    r = s.get(url, timeout=10); r.raise_for_status()
    j = r.json()
    alle += j["items"]
    url = j.get("next")
```

## Sockets

```python
import socket
with socket.create_connection(("10.0.0.5", 22), timeout=3) as sock:
    banner = sock.recv(1024).decode(errors="replace")
    print(banner.strip())
```

> [!WARNUNG] Nur gegen erlaubte Ziele
> Skripte, die viele Anfragen erzeugen, nur gegen eigene Systeme, Labs oder ausdrücklich beauftragte Ziele laufen lassen – und Last begrenzen.

## Quiz

? Welche Bibliothek ist der Standard für HTTP-Anfragen in Python?
= requests

? Welcher Parameter verhindert, dass eine Anfrage ewig hängt?
= timeout

? Welche Methode löst bei HTTP-Fehlern eine Ausnahme aus?
= raise_for_status
= raise_for_status()

? Warum sollte verify=True beibehalten werden?
+ Damit Zertifikate geprüft und Man-in-the-Middle verhindert wird
- Damit Anfragen schneller sind
- Damit Cookies gespeichert werden
- Damit JSON funktioniert

? Woher sollten Skripte API-Schlüssel lesen?
+ aus Umgebungsvariablen oder einem Secret-Store
- aus dem Quellcode
- aus der URL
- aus einem öffentlichen Repository

@@@ MODULE @@@
---
id: py-04
title: Reguläre Ausdrücke vertieft
paths: grundlagen, cdsa, cwes
order: 43
difficulty: medium
icon: textformat.abc
tags: regex
summary: Zeichenklassen, Quantoren, Gruppen, Anker, Lookarounds, gierig vs. genügsam, typische Muster für IPs, Domains und E-Mails sowie die Gefahr von ReDoS.
---

## Bausteine

| Element | Bedeutung | Beispiel |
|---|---|---|
| `.` | beliebiges Zeichen | `a.c` |
| `\d \w \s` | Ziffer, Wortzeichen, Leerraum | `\d{3}` |
| `[a-f0-9]` | Zeichenklasse | Hex |
| `[^...]` | negierte Klasse | `[^"]+` |
| `* + ? {n,m}` | Quantoren | `\d{1,3}` |
| `^ $ \b` | Anfang, Ende, Wortgrenze | `^ERROR` |
| `( )` | Gruppe | `(GET|POST)` |
| `(?P<name>...)` | benannte Gruppe (Python) | `(?P<ip>...)` |
| `(?:...)` | Gruppe ohne Speicherung | |
| `(?=...)`, `(?!...)` | Lookahead | |
| `(?<=...)`, `(?<!...)` | Lookbehind | |

## Gierig vs. genügsam

`".*"` greift so viel wie möglich (bis zum letzten Anführungszeichen der Zeile), `".*?"` so wenig wie möglich. Bei Logzeilen ist meist `"[^"]*"` am robustesten.

## Nützliche Muster

| Ziel | Muster (vereinfacht) |
|---|---|
| IPv4 | `\b(?:\d{1,3}\.){3}\d{1,3}\b` |
| Domain | `\b(?:[a-z0-9-]+\.)+[a-z]{2,}\b` |
| E-Mail | `[\w.+-]+@[\w-]+\.[\w.-]+` |
| SHA-256 | `\b[a-fA-F0-9]{64}\b` |
| Windows-Pfad | `[A-Za-z]:\\[^\s"]+` |

> [!INFO] Gut genug statt perfekt
> Ein Muster, das jede gültige E-Mail-Adresse exakt erkennt, ist riesig. Für Log-Auswertungen genügt ein pragmatisches Muster – entscheidend ist, die Grenzfälle zu kennen.

## ReDoS

Schlecht gebaute Ausdrücke mit verschachtelten Quantoren (z. B. `(a+)+$`) können bei bestimmten Eingaben exponentiell lange brauchen – ein **Regular Expression Denial of Service**. Schutz: einfache Muster, Zeitlimits, Engines ohne Backtracking (z. B. RE2).

## Quiz

? Was bedeutet `\b`?
+ Wortgrenze
- Backslash
- Leerzeichen
- Ziffer

? Wie schreibt man einen genügsamen (non-greedy) Quantor für beliebige Zeichen?
= .*?

? Wie viele Hex-Zeichen hat ein SHA-256-Hash?
= 64

? Wie heißt Denial of Service durch langsame reguläre Ausdrücke?
= ReDoS

? Wie schreibt man in Python eine benannte Gruppe?
= (?P<name>...)
= (?P<name>)

@@@ MODULE @@@
---
id: py-05
title: Datenformate – JSON, YAML, XML, CSV
paths: grundlagen, cwes, cyberrange
order: 44
difficulty: easy
icon: curlybraces
tags: daten
summary: Die Formate, in denen Konfigurationen, APIs, Logs und Infrastruktur beschrieben werden – Aufbau, typische Fehler und Sicherheitsaspekte beim Verarbeiten.
---

## JSON

```json
{"host": "srv01", "ip": "10.0.0.5", "ports": [22, 443], "aktiv": true}
```

Strenge Syntax: doppelte Anführungszeichen, keine Kommentare, kein abschließendes Komma. Standard für APIs und viele Logs.

## YAML

```yaml
host: srv01
ip: 10.0.0.5
ports:
  - 22
  - 443
aktiv: true
```

Einrückung ist Syntax. YAML ist Grundlage von Ansible, Kubernetes, GitHub Actions und Sigma-Regeln.

> [!WARNUNG] YAML-Fallen
> Unquotierte Werte werden interpretiert: `no` kann zu `false` werden, `010` zu einer Oktalzahl, Versionsnummern wie `1.10` zu `1.1`. Strings im Zweifel in Anführungszeichen. Beim Laden nicht vertrauenswürdiger Dateien sichere Loader verwenden (z. B. `yaml.safe_load`), weil manche Loader beliebige Objekte erzeugen können.

## XML

```xml
<host name="srv01"><ip>10.0.0.5</ip><port>22</port></host>
```

Verbreitet in SOAP, SAML, Office-Dokumenten und älteren Systemen. Sicherheitsaspekt: externe Entitäten ([[mod:b-08|XXE]]).

## CSV

Einfach, aber tückisch: Trennzeichen (Komma oder Semikolon), Anführungszeichen in Feldern, Kodierung (UTF-8 vs. Windows-1252).

> [!INFO] CSV-Injection
> Beginnt ein Feld mit `=`, `+`, `-` oder `@`, interpretieren Tabellenprogramme es als Formel. Anwendungen, die Benutzerdaten als CSV exportieren, sollten solche Felder entschärfen.

## Vergleich

| Format | lesbar | Kommentare | typische Nutzung |
|---|---|---|---|
| JSON | gut | nein | APIs, Logs |
| YAML | sehr gut | ja | Konfiguration, IaC |
| XML | mittel | ja | SOAP, SAML, Office |
| CSV | gut | nein | Tabellen, Exporte |

## Quiz

? Welches Format erlaubt keine Kommentare?
= JSON

? Wodurch wird in YAML die Struktur bestimmt?
+ durch Einrückung
- durch geschweifte Klammern
- durch Semikolons
- durch Tags

? Welcher Python-Aufruf lädt YAML sicher?
= yaml.safe_load
= safe_load

? Mit welchen Zeichen beginnende CSV-Felder können als Formel interpretiert werden?
+ =
+ +
+ @
- a
- 1

? Welche Schwachstelle betrifft XML-Verarbeitung besonders?
= XXE
