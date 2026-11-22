---
id: pg-01
title: Programmierung 1 · Bash vertieft – robuste Skripte
paths: grundlagen, cdsa, cyberrange
order: 22.1
difficulty: medium
icon: terminal
tags: bash, scripting
summary: Fehlerbehandlung, Quoting, Arrays, Funktionen, Argumente und sichere Temp-Dateien – damit Bash-Skripte nicht im falschen Moment Schaden anrichten.
---

## Einfach erklärt

Ein Bash-Skript ist ein Rezept, das der Computer Wort für Wort ausführt – auch dann, wenn ein Schritt schiefgeht. Ein Koch merkt, wenn die Milch sauer ist; ein naives Skript gießt sie trotzdem in den Teig. Robuste Skripte **prüfen Fehler**, **zitieren Variablen** richtig und brechen kontrolliert ab.

## Der sichere Anfang

```bash
#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'
```

| Option | Wirkung |
|---|---|
| `-e` | bei Fehler abbrechen |
| `-u` | unbekannte Variablen sind ein Fehler |
| `-o pipefail` | ein Fehler in einer Pipe zählt als Fehler |

## Quoting – die häufigste Fehlerquelle

```bash
datei="Mein Bericht.txt"
rm $datei      # FALSCH: löscht "Mein" und "Bericht.txt"
rm "$datei"    # richtig
```

> [!GEFAHR] Ungequotete Variablen mit rm
> `rm -rf $VERZ/` mit leerer Variable wird zu `rm -rf /`. Immer quoten und mit `${VERZ:?}` erzwingen, dass die Variable gesetzt ist.

## Arrays, Funktionen, Argumente

```bash
hosts=("web01" "db01" "mail01")
for h in "${hosts[@]}"; do ping -c1 -W1 "$h" >/dev/null && echo "$h up"; done

log() { printf '%s [%s] %s\n' "$(date -u +%FT%TZ)" "$1" "$2"; }
log INFO "Start"

while getopts "t:v" opt; do
  case $opt in
    t) ziel="$OPTARG" ;;
    v) verbose=1 ;;
    *) echo "Nutzung: $0 -t ziel [-v]"; exit 1 ;;
  esac
done
```

## Tiefer eingetaucht

- **Temporäre Dateien** mit `mktemp` anlegen und per `trap 'rm -f "$tmp"' EXIT` aufräumen – feste Namen in `/tmp` sind ein klassisches Sicherheitsrisiko (Symlink-Angriffe).
- **Eingaben validieren**, bevor sie in Befehle gehen; niemals `eval` mit Nutzereingaben.
- **ShellCheck** findet die meisten typischen Fehler automatisch.
- Für alles über ~100 Zeilen, mit komplexen Datenstrukturen oder JSON: lieber Python.

## Quiz

? Welche Option bricht ein Bash-Skript bei einem Fehler ab?
= set -e
= -e
! Zusammen mit -u und -o pipefail der empfohlene Skriptanfang.

? Warum sollte man Variablen in Anführungszeichen setzen?
+ damit Leerzeichen und Sonderzeichen nicht zu Worttrennung führen
- damit das Skript schneller läuft
- weil Bash sonst abstürzt
- damit die Variable verschlüsselt wird
! "$datei" bleibt ein Argument, auch mit Leerzeichen.

? Mit welchem Befehl legt man sichere temporäre Dateien an?
= mktemp
! mktemp erzeugt einen zufälligen, nicht vorhersagbaren Namen.

?tf `eval` mit Nutzereingaben ist in Bash unbedenklich.
= falsch
! eval führt Eingaben als Code aus – Command Injection.

? Welches Werkzeug findet typische Fehler in Shell-Skripten?
= ShellCheck
! Lässt sich auch in Editoren und CI einbinden.

? Was bewirkt `${VERZ:?}`?
+ bricht ab, wenn VERZ nicht gesetzt oder leer ist
- setzt VERZ auf ein Fragezeichen
- fragt den Nutzer nach VERZ
- löscht VERZ
! Schützt z. B. vor rm -rf mit leerer Variable.

@@@ MODULE @@@
---
id: pg-02
title: Programmierung 2 · PowerShell vertieft – Objekte, Pipeline, Remoting
paths: grundlagen, cdsa, cpts
order: 22.2
difficulty: medium
icon: chevron.left.forwardslash.chevron.right
tags: powershell, windows, scripting
summary: Wie die objektbasierte Pipeline funktioniert, wie man filtert und formatiert, Remoting nutzt, Module schreibt und PowerShell sicher betreibt.
---

## Einfach erklärt

In Bash fließt **Text** durch die Pipe. In PowerShell fließen **Objekte** – also Dinge mit Eigenschaften. Statt mühsam Spalten aus einem Text zu schneiden, fragt man direkt: „Gib mir von jedem Prozess den Namen und den Speicher.“

```powershell
Get-Process | Where-Object WorkingSet -gt 200MB | Sort-Object WorkingSet -Descending | Select-Object Name, Id, WorkingSet
```

## Die wichtigsten Bausteine

| Cmdlet | Zweck |
|---|---|
| `Get-Command`, `Get-Help`, `Get-Member` | entdecken: welche Befehle, welche Eigenschaften? |
| `Where-Object` | filtern |
| `Select-Object` | Eigenschaften auswählen |
| `Sort-Object`, `Group-Object`, `Measure-Object` | sortieren, gruppieren, zählen |
| `ForEach-Object` | pro Objekt etwas tun |
| `Export-Csv`, `ConvertTo-Json` | ausgeben |

> [!TIPP] Get-Member ist dein Freund
> `Get-Service | Get-Member` zeigt alle Eigenschaften und Methoden – so findest du heraus, wonach du filtern kannst.

## Remoting

```powershell
Invoke-Command -ComputerName srv01, srv02 -ScriptBlock { Get-HotFix | Select-Object -Last 3 }
Enter-PSSession -ComputerName srv01
```

PowerShell Remoting läuft über **WinRM** (HTTP 5985 / HTTPS 5986) und nutzt standardmäßig Kerberos.

## Tiefer eingetaucht

Sicherer Betrieb:

- **Execution Policy** ist keine Sicherheitsgrenze, sondern ein Schutz vor versehentlichem Ausführen.
- **Script Block Logging**, Module Logging und Transcription aktivieren.
- **Constrained Language Mode** und **JEA** (Just Enough Administration): Nutzer dürfen per Remoting nur definierte Befehle ausführen – ideal für Helpdesk-Aufgaben.
- PowerShell 7 parallel zu Windows PowerShell 5.1; v2 entfernen.

Eigene Funktionen mit `[CmdletBinding()]`, Parametervalidierung (`[ValidateSet()]`, `[ValidatePattern()]`) und Kommentarhilfe werden zu wiederverwendbaren Werkzeugen; mehrere davon in einem Modul (`.psm1`) gebündelt und signiert.

## Quiz

? Was fließt in PowerShell durch die Pipeline?
+ Objekte
- reiner Text
- Binärdaten
- nur Zahlen
! Deshalb kann man direkt nach Eigenschaften filtern.

? Welches Cmdlet zeigt Eigenschaften und Methoden eines Objekts?
= Get-Member
! Unverzichtbar, um herauszufinden, wonach man filtern kann.

? Über welches Protokoll läuft PowerShell Remoting?
= WinRM
! HTTP 5985, HTTPS 5986.

?tf Die Execution Policy ist eine wirksame Sicherheitsgrenze gegen Angreifer.
= falsch
! Sie lässt sich leicht umgehen und dient nur gegen versehentliches Ausführen.

? Wie heißt die Funktion, mit der Nutzer per Remoting nur ausgewählte Befehle ausführen dürfen?
= JEA
= Just Enough Administration
! Ideal, um Aufgaben zu delegieren, ohne Admin-Rechte zu vergeben.

? Welches Cmdlet filtert Objekte nach Bedingungen?
= Where-Object
! Kurzform: ? oder where.

@@@ MODULE @@@
---
id: pg-03
title: Programmierung 3 · Python für Security-Werkzeuge
paths: grundlagen, cdsa, cwes, cpts
order: 22.3
difficulty: medium
icon: curlybraces.square.fill
tags: python, werkzeuge
summary: Kommandozeilenargumente, Logging, Fehlerbehandlung, Nebenläufigkeit, virtuelle Umgebungen und sichere Gewohnheiten – vom Skript zum Werkzeug.
---

## Einfach erklärt

Ein Skript ist ein Zettel mit Notizen, ein Werkzeug ist ein ordentlich beschrifteter Schraubenzieher. Der Unterschied: **Argumente** statt fest eingetragener Werte, **Fehlerbehandlung** statt Absturz, **Logging** statt `print`, und eine **Umgebung**, in der es auch morgen noch läuft.

## Grundgerüst

```python
#!/usr/bin/env python3
import argparse, logging, sys

def main() -> int:
    ap = argparse.ArgumentParser(description="Prüft HTTP-Header einer Liste von URLs")
    ap.add_argument("datei", help="Datei mit einer URL pro Zeile")
    ap.add_argument("-v", "--verbose", action="store_true")
    args = ap.parse_args()
    logging.basicConfig(level=logging.DEBUG if args.verbose else logging.INFO,
                        format="%(asctime)s %(levelname)s %(message)s")
    try:
        with open(args.datei, encoding="utf-8") as f:
            urls = [z.strip() for z in f if z.strip()]
    except OSError as e:
        logging.error("Datei nicht lesbar: %s", e)
        return 1
    for u in urls:
        logging.info("prüfe %s", u)
    return 0

if __name__ == "__main__":
    sys.exit(main())
```

## Nützliche Standardbibliothek

| Modul | Zweck |
|---|---|
| `argparse` | Argumente |
| `logging` | Protokollierung |
| `pathlib` | Pfade |
| `json`, `csv` | Datenformate |
| `ipaddress` | IP-Adressen und Netze |
| `hashlib`, `hmac`, `secrets` | Hashes, MACs, sichere Zufallswerte |
| `subprocess` | externe Programme (mit Argumentliste!) |
| `concurrent.futures` | parallele Aufgaben |

> [!WARNUNG] random ist nicht für Sicherheit
> Für Tokens, Passwörter und Schlüssel immer `secrets` verwenden – `random` ist vorhersagbar.

## Tiefer eingetaucht

- **Virtuelle Umgebungen** (`python -m venv .venv`) und gepinnte Abhängigkeiten (`requirements.txt` mit Versionen oder Lockfile) machen Werkzeuge reproduzierbar.
- **Nebenläufigkeit**: Für viele Netzwerkanfragen `ThreadPoolExecutor` oder `asyncio`; immer mit Limits, um Ziele nicht zu überlasten.
- **Typ-Hinweise** und `mypy`/`ruff` finden Fehler früh.
- **Sicherheit**: keine Geheimnisse im Code, `yaml.safe_load`, keine Shell (`shell=True`) mit Eingaben, Zertifikatsprüfung bei HTTPS nicht abschalten.

## Quiz

? Welches Modul verarbeitet Kommandozeilenargumente?
= argparse
! Erzeugt automatisch auch eine Hilfe mit -h.

? Welches Modul erzeugt kryptografisch sichere Zufallswerte?
= secrets
! random ist für Sicherheit ungeeignet.

? Wie legt man eine virtuelle Umgebung an?
= python -m venv .venv
= python3 -m venv .venv
! So bleiben Abhängigkeiten projektbezogen.

?tf `subprocess.run(befehl, shell=True)` mit Nutzereingaben ist sicher.
= falsch
! Mit shell=True wird die Eingabe von einer Shell interpretiert – Command Injection.

? Welches Modul hilft beim Rechnen mit IP-Netzen?
= ipaddress
! Z. B. ip_network("10.0.0.0/24").hosts().

? Womit parallelisiert man viele Netzwerkanfragen einfach?
+ ThreadPoolExecutor aus concurrent.futures
- time.sleep
- print
- os.fork in einer Schleife ohne Limit
! Immer mit begrenzter Parallelität arbeiten.

@@@ MODULE @@@
---
id: pg-04
title: Programmierung 4 · C und Speicher verstehen
paths: cwee, cape, grundlagen
order: 22.4
difficulty: hard
icon: memorychip
tags: c, speicher, grundlagen
summary: Stack, Heap, Zeiger und Puffer – warum Speicherfehler in C/C++ zu Sicherheitslücken werden und welche Sprachen und Werkzeuge sie verhindern.
---

## Einfach erklärt

In vielen Sprachen kümmert sich die Laufzeitumgebung um den Speicher. In **C** macht man das selbst – wie ein Lagerist, der jede Kiste von Hand ins Regal stellt. Packt man in ein Fach für 10 Kisten aus Versehen 12, landen zwei im Nachbarfach. Genau das ist ein **Pufferüberlauf** – und das Nachbarfach kann wichtige Daten enthalten, etwa die Rücksprungadresse einer Funktion.

## Speicherbereiche

| Bereich | Inhalt | Eigenschaft |
|---|---|---|
| Stack | lokale Variablen, Rücksprungadressen | automatisch verwaltet, wächst/schrumpft mit Funktionsaufrufen |
| Heap | dynamisch angeforderter Speicher (`malloc`) | manuell freigeben (`free`) |
| Daten/BSS | globale Variablen | fest |
| Text | Programmcode | normalerweise nur lesbar/ausführbar |

## Typische Fehlerklassen

```c
char name[16];
strcpy(name, eingabe);          // keine Längenprüfung → Überlauf
snprintf(name, sizeof name, "%s", eingabe);   // begrenzt
```

| Klasse | Beschreibung |
|---|---|
| Buffer Overflow | Schreiben über das Pufferende |
| Use-after-free | Zugriff auf bereits freigegebenen Speicher |
| Double free | Speicher zweimal freigeben |
| Integer Overflow | Zahl läuft über, z. B. bei Größenberechnung |
| Format String | Nutzereingabe als Formatstring (`printf(eingabe)`) |
| Out-of-bounds Read | Lesen außerhalb des Puffers (z. B. Heartbleed) |

> [!MERKE] Rund 70 % schwerer Lücken
> Große Hersteller berichteten, dass ein Großteil ihrer schweren Sicherheitslücken auf Speicherfehler zurückgeht. Deshalb der Trend zu speichersicheren Sprachen wie Rust, Go, Swift oder Java/C#.

## Tiefer eingetaucht

Gegenmaßnahmen auf mehreren Ebenen:

- **Sprache**: speichersichere Sprachen für neuen Code.
- **Compiler**: Stack Canaries (`-fstack-protector-strong`), `_FORTIFY_SOURCE`, Warnungen als Fehler.
- **Betriebssystem**: ASLR, DEP/NX, Control Flow Integrity.
- **Tests**: Sanitizer (AddressSanitizer, UBSan), **Fuzzing** (AFL++, libFuzzer) findet Speicherfehler automatisch.
- **Code-Review**: unsichere Funktionen (`strcpy`, `gets`, `sprintf`) verbieten.

## Quiz

? Was passiert bei einem Pufferüberlauf?
+ Daten werden über das Ende eines Puffers hinaus geschrieben
- der Speicher wird automatisch erweitert
- das Programm wird schneller
- die Daten werden verschlüsselt
! Dabei können benachbarte Daten wie Rücksprungadressen überschrieben werden.

? Wo liegen lokale Variablen und Rücksprungadressen?
= Stack
= auf dem Stack
! Der Heap enthält dynamisch angeforderten Speicher.

? Welche C-Funktion ist wegen fehlender Längenprüfung gefährlich?
+ strcpy
- snprintf
- strnlen
- memcmp
! Sicherer sind begrenzende Varianten mit Größenangabe.

? Wie nennt man den Zugriff auf bereits freigegebenen Speicher?
= Use-after-free
= use after free
! Eine häufige Ursache schwerer Browser-Lücken.

?tf Fuzzing ist eine wirksame Methode, Speicherfehler automatisch zu finden.
= wahr
! Fuzzer füttern Programme mit Millionen veränderter Eingaben.

? Welche Sprachen gelten als speichersicher?
+ Rust
+ Go
+ Swift
- C
! Sie verhindern ganze Fehlerklassen per Design.

@@@ MODULE @@@
---
id: pg-05
title: Programmierung 5 · Assembler-Grundlagen x86-64
paths: cwee, cdsa, cape
order: 22.5
difficulty: hard
icon: cpu.fill
tags: assembler, reverse engineering
summary: Register, Befehle, Stack-Frames und Aufrufkonventionen – genug Assembler, um Disassembly in Malware-Analyse und Reverse Engineering zu lesen.
---

## Einfach erklärt

Die CPU versteht keine Hochsprache, sondern nur sehr einfache Befehle: „Lade diesen Wert“, „Addiere“, „Vergleiche“, „Springe dorthin“. **Assembler** ist die menschenlesbare Form dieser Befehle. Wer Malware analysiert oder Software ohne Quellcode untersucht, liest Assembler – nicht um es zu schreiben, sondern um zu verstehen, was passiert.

## Register (Auswahl, 64 Bit)

| Register | Typische Verwendung |
|---|---|
| RAX | Rückgabewert |
| RBX, R12–R15 | allgemeine Register (callee-saved) |
| RCX, RDX, R8, R9 | erste Argumente (Windows x64) |
| RDI, RSI, RDX, RCX, R8, R9 | erste Argumente (Linux System V) |
| RSP | Stack-Zeiger |
| RBP | Basiszeiger des Stack-Frames |
| RIP | Befehlszeiger – nächste Anweisung |

## Häufige Befehle

| Befehl | Bedeutung |
|---|---|
| `mov rax, rbx` | kopieren |
| `lea rax, [rbx+8]` | Adresse berechnen |
| `add`, `sub`, `xor`, `and` | Rechnen, Logik (`xor eax, eax` = auf 0 setzen) |
| `cmp`, `test` | vergleichen, setzt Flags |
| `jmp`, `je`, `jne`, `jg` | springen (bedingt) |
| `call`, `ret` | Funktion aufrufen, zurückkehren |
| `push`, `pop` | auf den Stack legen, holen |

> [!TIPP] Muster erkennen statt jede Zeile lesen
> `cmp` + bedingter Sprung = `if`. Ein Rückwärtssprung = Schleife. `call` mit bekanntem API-Namen verrät die Absicht (z. B. `CreateFileW`, `InternetOpenUrlA`).

## Tiefer eingetaucht

Ein **Stack-Frame** entsteht beim Funktionsaufruf: `call` legt die Rücksprungadresse ab, die Funktion sichert ggf. RBP und reserviert Platz für lokale Variablen. Bei einem Pufferüberlauf in einer lokalen Variable kann genau diese Rücksprungadresse überschrieben werden – deshalb Stack Canaries.

**Aufrufkonventionen** unterscheiden sich: Windows x64 übergibt die ersten vier Argumente in RCX, RDX, R8, R9 und reserviert 32 Byte „Shadow Space“; Linux nutzt sechs Register. Werkzeuge wie Ghidra und IDA übersetzen Assembler zusätzlich in Pseudo-C (Decompiler) – trotzdem lohnt es sich, die Grundlagen zu kennen, um Fehler des Decompilers zu erkennen.

## Quiz

? Welches Register enthält den Rückgabewert einer Funktion?
= RAX
! Unter x86-64 in beiden gängigen Konventionen.

? Welches Register zeigt auf die nächste auszuführende Anweisung?
= RIP
! Instruction Pointer.

? Was bewirkt `xor eax, eax`?
+ setzt EAX auf 0
- verdoppelt EAX
- vertauscht zwei Register
- beendet das Programm
! Ein kompaktes Idiom zum Nullsetzen.

? In welchen Registern übergibt Windows x64 die ersten vier Argumente?
+ RCX, RDX, R8, R9
- RDI, RSI, RDX, RCX
- RAX, RBX, RCX, RDX
- nur über den Stack
! Linux System V nutzt RDI, RSI, RDX, RCX, R8, R9.

?tf Ein `cmp` gefolgt von einem bedingten Sprung entspricht meist einem if.
= wahr
! Rückwärtssprünge deuten dagegen auf Schleifen hin.

? Was legt der Befehl `call` auf den Stack?
+ die Rücksprungadresse
- das Ergebnis der Funktion
- alle Register
- nichts
! ret holt sie wieder und springt zurück.

@@@ MODULE @@@
---
id: pg-06
title: Programmierung 6 · Exploit-Schutzmechanismen verstehen
paths: cwee, cape, specialist
order: 22.6
difficulty: hard
icon: shield.checkered
tags: exploit mitigation, speicher
summary: ASLR, DEP/NX, Stack Canaries, CFG/CET und Sandboxing – wie moderne Systeme Speicherfehler-Ausnutzung erschweren und was ihre Grenzen sind.
---

## Einfach erklärt

Wenn ein Programm einen Speicherfehler hat, ist das wie ein Loch im Zaun. Moderne Betriebssysteme bauen hinter dem Zaun weitere Hindernisse auf: Sie verstecken die Wertsachen an zufälligen Orten (**ASLR**), verbieten, dass auf dem Rasen Gebäude errichtet werden (**DEP**), legen Stolperdrähte aus (**Canaries**) und lassen nur genehmigte Wege zu (**CFI**). Ein Angreifer muss alle Hindernisse gleichzeitig überwinden.

## Die Mechanismen

| Schutz | Idee | Umgehungsansatz (konzeptionell) |
|---|---|---|
| DEP / NX | Daten-Speicher nicht ausführbar | vorhandenen Code wiederverwenden (ROP) |
| ASLR | Speicheradressen zufällig | Informationsleck verrät Adressen |
| Stack Canary | Prüfwert vor der Rücksprungadresse | Canary auslesen, andere Ziele überschreiben |
| CFG / CFI | indirekte Sprünge nur zu erlaubten Zielen | erlaubte, aber missbrauchbare Ziele |
| CET Shadow Stack | Hardware-Kopie der Rücksprungadressen | stark – erschwert ROP erheblich |
| Sandboxing | Prozess mit minimalen Rechten | zusätzliche Lücke zum Ausbruch nötig |

> [!MERKE] Verteidigung in der Tiefe
> Kein einzelner Schutz ist perfekt. Zusammen machen sie Exploits teuer, unzuverlässig und oft nur mit mehreren verketteten Lücken möglich.

## Prüfen

- Linux: `checksec --file=programm` zeigt RELRO, Canary, NX, PIE.
- Windows: Exploit Protection (Systemeinstellungen, `Get-ProcessMitigation`), Binärdatei-Flags mit Werkzeugen wie dumpbin oder PE-Analysetools.

## Tiefer eingetaucht

**PIE** (Position Independent Executable) ist nötig, damit auch das Hauptprogramm von ASLR profitiert. **RELRO** schützt Tabellen für dynamisches Linken vor Überschreiben. Browser kombinieren alles mit strikter Prozessisolation (Site Isolation) – deshalb brauchen Angriffe auf aktuelle Browser oft Ketten aus Renderer-Lücke plus Sandbox-Ausbruch.

Für Verteidiger: Altsoftware ohne diese Schutzmechanismen ist ein bevorzugtes Ziel. Inventarisieren, aktualisieren oder isolieren; systemweite Schutzfunktionen (z. B. Windows Exploit Protection, Kernel-Härtung) aktiviert lassen.

## Quiz

? Was macht ASLR?
+ platziert Speicherbereiche an zufälligen Adressen
- verschlüsselt den Arbeitsspeicher
- verbietet Netzwerkzugriffe
- blockiert Viren
! Angreifer kennen dadurch die Adressen nicht im Voraus.

? Welcher Schutz verhindert, dass Code aus Datenbereichen ausgeführt wird?
= DEP
= NX
= DEP/NX
! Data Execution Prevention bzw. No-Execute-Bit.

? Wie nennt man die Technik, vorhandene Codefragmente zu verketten, um DEP zu umgehen?
= ROP
= Return-Oriented Programming
! CET Shadow Stacks erschweren ROP erheblich.

? Welches Linux-Werkzeug zeigt Schutzmechanismen einer Binärdatei?
= checksec
! Es zeigt u. a. RELRO, Canary, NX und PIE.

?tf ASLR schützt auch dann zuverlässig, wenn ein Informationsleck Speicheradressen verrät.
= falsch
! Ein Leak hebt die Zufälligkeit auf.

? Was ist ein Stack Canary?
+ ein Prüfwert vor der Rücksprungadresse, dessen Veränderung erkannt wird
- ein Vogel im Rechenzentrum
- ein Virenscanner
- eine Firewall-Regel
! Wird er überschrieben, bricht das Programm ab.

@@@ MODULE @@@
---
id: pg-07
title: Programmierung 7 · Reverse Engineering mit Ghidra – der Einstieg
paths: cdsa, cwee, cape
order: 22.7
difficulty: hard
icon: eye.circle.fill
tags: reverse engineering, ghidra, malware
summary: Wie man ein unbekanntes Programm strukturiert untersucht – Import, Strings, Funktionen, Querverweise, Umbenennen und Kommentieren in Ghidra.
---

## Einfach erklärt

Reverse Engineering ist wie das Verstehen einer Maschine ohne Bauplan: Man schaut, welche Teile sie hat, welche mit welchen verbunden sind und was passiert, wenn man einen Knopf drückt. **Ghidra** (kostenlos, von der NSA veröffentlicht) zerlegt Programme in Assembler und übersetzt sie in lesbaren Pseudo-C-Code.

## Vorgehen in fünf Schritten

1. **Überblick**: Dateityp, Architektur, Compiler, gepackt? (Entropie, Sektionen)
2. **Importe**: Welche Systemfunktionen nutzt das Programm? (Netzwerk, Dateien, Registry, Kryptografie)
3. **Strings**: URLs, Befehle, Fehlermeldungen, Registry-Pfade
4. **Einstieg finden**: `main` bzw. Entry Point, oder über Querverweise (XREFs) von interessanten Strings/Importen zu den Funktionen, die sie nutzen
5. **Verstehen und dokumentieren**: Funktionen und Variablen **umbenennen**, Kommentare setzen, Datentypen korrigieren

> [!TIPP] Von außen nach innen
> Nicht beim Entry Point anfangen und jede Zeile lesen. Lieber von einem interessanten Import („InternetOpenUrl“) rückwärts zur aufrufenden Funktion springen.

## Nützliche Ghidra-Funktionen

| Funktion | Zweck |
|---|---|
| Symbol Tree | Funktionen, Importe, Exporte |
| Defined Strings | alle gefundenen Zeichenketten |
| References / XREFs | wo wird etwas verwendet? |
| Decompiler-Fenster | Pseudo-C |
| Function Graph | Kontrollfluss als Diagramm |
| Rename (L) / Retype | Lesbarkeit verbessern |

## Tiefer eingetaucht

Hindernisse: **Packer** (das eigentliche Programm wird erst zur Laufzeit entpackt → dynamisch entpacken oder Speicherabbild analysieren), **Verschleierung** (verschlüsselte Strings, die erst zur Laufzeit entschlüsselt werden → Entschlüsselungsroutine finden und nachbauen), **Anti-Debugging**.

Ergänzende Werkzeuge: x64dbg (Windows-Debugger), Detect It Easy (Packer/Compiler erkennen), PE-bear, CyberChef (Daten dekodieren). Rechtlich: Reverse Engineering kann durch Lizenzbedingungen und Urheberrecht eingeschränkt sein – bei Malware-Analyse und Interoperabilität gibt es aber anerkannte Ausnahmen; im Zweifel klären.

## Quiz

? Welches kostenlose Werkzeug der NSA dekompiliert Programme zu Pseudo-C?
= Ghidra
! Alternativen sind IDA (kommerziell) und Binary Ninja.

? Was zeigen XREFs?
+ an welchen Stellen eine Funktion, Variable oder ein String verwendet wird
- die Dateigröße
- die Lizenz
- den Autor des Programms
! Querverweise sind die wichtigste Navigationshilfe.

? Warum sind die Importe eines Programms aufschlussreich?
+ sie zeigen, welche Systemfunktionen genutzt werden
- sie enthalten den Quellcode
- sie zeigen das Passwort
- sie verraten den Kaufpreis
! Netzwerk-, Datei- oder Krypto-APIs verraten die Absicht.

?tf Bei gepackten Programmen sieht man in der statischen Analyse oft nur den Entpacker.
= wahr
! Das eigentliche Programm entsteht erst zur Laufzeit.

? Was verbessert die Lesbarkeit beim Reverse Engineering am stärksten?
+ Funktionen und Variablen sinnvoll umbenennen
- Farben ändern
- Datei umbenennen
- Programm neu kompilieren
! Erkenntnisse werden so im Projekt festgehalten.

? Welches Werkzeug erkennt Packer und Compiler einer Datei?
= Detect It Easy
= DIE
! Hilfreich für den ersten Überblick.

@@@ MODULE @@@
---
id: pg-08
title: Programmierung 8 · Go und Rust für Security-Tools
paths: grundlagen, cwee, specialist
order: 22.8
difficulty: medium
icon: hammer.fill
tags: go, rust, entwicklung
summary: Warum moderne Security-Werkzeuge oft in Go oder Rust geschrieben werden – Eigenschaften, typische Einsatzzwecke und erste Schritte.
---

## Einfach erklärt

Python ist schnell geschrieben, aber langsam in der Ausführung und braucht einen Interpreter. **Go** und **Rust** erzeugen eigenständige, schnelle Programme – eine einzige Datei, die man auf ein System kopiert und startet. Deshalb sind viele moderne Scanner, Agenten und Proxys in diesen Sprachen geschrieben.

## Vergleich

| | Go | Rust |
|---|---|---|
| Speicher | Garbage Collector, speichersicher | Ownership-System, speichersicher ohne GC |
| Lernkurve | flach | steil |
| Nebenläufigkeit | Goroutines, Channels – sehr einfach | async/Threads, sehr sicher |
| Typische Tools | Scanner, Proxys, CLI-Tools, Cloud-Werkzeuge | Hochleistungs-Parser, Agenten, Systemsoftware |
| Cross-Compiling | `GOOS=windows go build` – trivial | gut möglich |

## Ein Mini-Beispiel in Go

```go
package main

import (
    "fmt"
    "net"
    "sync"
    "time"
)

func main() {
    var wg sync.WaitGroup
    for _, port := range []int{22, 80, 443} {
        wg.Add(1)
        go func(p int) {
            defer wg.Done()
            c, err := net.DialTimeout("tcp", fmt.Sprintf("127.0.0.1:%d", p), time.Second)
            if err == nil { c.Close(); fmt.Println(p, "offen") }
        }(port)
    }
    wg.Wait()
}
```

> [!MERKE] Speichersicherheit als Sicherheitsgewinn
> Beide Sprachen verhindern ganze Klassen von Speicherfehlern, die in C/C++ zu schweren Lücken führen.

## Tiefer eingetaucht

Für Verteidiger relevant: Auch Malware wird zunehmend in Go und Rust geschrieben – große, statisch gelinkte Binärdateien mit eigenen Laufzeit-Strukturen erschweren die klassische Analyse. Werkzeuge und Plugins für Ghidra/IDA helfen, Go-Funktionsnamen (aus `pclntab`) wiederherzustellen.

Für eigene Werkzeuge gilt: Abhängigkeiten prüfen (`go mod`, `cargo audit`), reproduzierbare Builds, Signaturen für Releases, und Rate-Limits einbauen, damit Scanner niemanden überlasten.

## Quiz

? Was ist ein großer Vorteil von Go für Kommandozeilen-Werkzeuge?
+ einfache Cross-Compilierung zu einer eigenständigen Binärdatei
- es braucht immer einen Interpreter
- es ist nicht speichersicher
- es läuft nur unter Linux
! GOOS/GOARCH setzen genügt.

? Wie verwaltet Rust Speicher ohne Garbage Collector?
= Ownership
= Ownership-System
! Der Compiler prüft Lebensdauern und Besitz zur Übersetzungszeit.

? Wie heißen die leichtgewichtigen Nebenläufigkeitseinheiten in Go?
= Goroutines
= Goroutinen
! Gestartet mit dem Schlüsselwort go.

?tf Go und Rust verhindern ganze Klassen von Speicherfehlern.
= wahr
! Ein wichtiger Grund für ihren Einsatz in Security-Software.

? Mit welchem Werkzeug prüft man Rust-Abhängigkeiten auf bekannte Schwachstellen?
= cargo audit
! Für Go gibt es govulncheck.

@@@ MODULE @@@
---
id: pg-09
title: Programmierung 9 · SQL vertieft – Joins, Rechte und sichere Abfragen
paths: grundlagen, cwes, cdsa
order: 14.5
difficulty: medium
icon: tablecells.fill
tags: sql, datenbanken
summary: Joins, Aggregation, Unterabfragen, Indizes, Rechtevergabe und Transaktionen – SQL für Analysten, Entwickler und Tester.
---

## Einfach erklärt

Eine Datenbank besteht aus Tabellen, die sich über **Schlüssel** aufeinander beziehen – wie Karteikästen mit Querverweisen: Bestellung Nr. 17 gehört zu Kunde Nr. 4. Mit **Joins** verbindet man diese Karten zu einer gemeinsamen Ansicht.

## Joins

```sql
SELECT k.name, b.datum, b.summe
FROM kunden k
JOIN bestellungen b ON b.kunde_id = k.id
WHERE b.datum >= '2026-01-01';
```

| Join | Ergebnis |
|---|---|
| INNER JOIN | nur Zeilen mit Treffer in beiden Tabellen |
| LEFT JOIN | alle links, rechts falls vorhanden (sonst NULL) |
| RIGHT JOIN | umgekehrt |
| FULL JOIN | alles aus beiden |

## Aggregation

```sql
SELECT benutzer, COUNT(*) AS fehlversuche
FROM logins
WHERE erfolg = 0 AND zeit > NOW() - INTERVAL '1 hour'
GROUP BY benutzer
HAVING COUNT(*) > 10
ORDER BY fehlversuche DESC;
```

`WHERE` filtert Zeilen **vor**, `HAVING` Gruppen **nach** der Aggregation.

## Rechte

```sql
CREATE ROLE app_leser;
GRANT SELECT ON produkte TO app_leser;
REVOKE ALL ON kunden FROM PUBLIC;
```

> [!MERKE] Least Privilege in der Datenbank
> Die Webanwendung braucht selten `DROP`, `ALTER` oder Zugriff auf alle Tabellen. Ein eigenes, minimal berechtigtes Konto begrenzt den Schaden einer SQL-Injection erheblich.

## Tiefer eingetaucht

- **Prepared Statements** trennen Befehl und Daten – die wichtigste Maßnahme gegen SQL-Injection. Bezeichner (Tabellen-, Spaltennamen, Sortierrichtung) lassen sich nicht parametrisieren → Allowlist.
- **Transaktionen** (`BEGIN … COMMIT`) machen mehrere Änderungen atomar; Isolationsstufen beeinflussen Race Conditions.
- **Indizes** beschleunigen Suchen – auch für Analysen großer Logtabellen.
- **Auditing** in der Datenbank (z. B. pgaudit) protokolliert Zugriffe auf sensible Tabellen.
- Gefährliche Funktionen je System (Dateizugriff, Befehlsausführung, externe Verbindungen) für Anwendungskonten sperren.

## Quiz

? Welcher Join liefert nur Zeilen mit Treffern in beiden Tabellen?
= INNER JOIN
! LEFT JOIN behält zusätzlich alle Zeilen der linken Tabelle.

? Was ist der Unterschied zwischen WHERE und HAVING?
+ WHERE filtert Zeilen vor, HAVING Gruppen nach der Aggregation
- es gibt keinen Unterschied
- HAVING ist schneller
- WHERE funktioniert nur mit Zahlen
! HAVING arbeitet auf Ergebnissen von COUNT, SUM usw.

? Mit welchem Befehl vergibt man Rechte?
= GRANT
! REVOKE entzieht sie wieder.

?tf Tabellennamen lassen sich wie normale Werte als Parameter in Prepared Statements übergeben.
= falsch
! Bezeichner müssen über eine Allowlist geprüft werden.

? Was begrenzt den Schaden einer SQL-Injection zusätzlich zu Prepared Statements?
+ ein minimal berechtigtes Datenbankkonto für die Anwendung
- ein längerer Datenbankname
- mehr Arbeitsspeicher
- eine bunte Oberfläche
! Least Privilege auch in der Datenbank.

? Wie macht man mehrere Änderungen atomar?
+ mit einer Transaktion
- mit einem Index
- mit einem Join
- mit einem Kommentar
! Entweder alle Änderungen gelten oder keine.

@@@ MODULE @@@
---
id: pg-10
title: Programmierung 10 · Git-Workflows und sichere Zusammenarbeit
paths: grundlagen, cwee, specialist, cyberrange
order: 16.5
difficulty: easy
icon: arrow.triangle.branch
tags: git, devsecops
summary: Branches, Pull Requests, Reviews, signierte Commits, Branch-Schutz und was man tut, wenn etwas Falsches im Repository gelandet ist.
---

## Einfach erklärt

Git ist eine Zeitmaschine mit Paralleluniversen: Jeder **Branch** ist eine eigene Version der Geschichte, in der man experimentieren kann, ohne die Hauptlinie zu stören. Über einen **Pull Request** schlägt man vor, die Änderungen zu übernehmen – und Kollegen schauen vorher drüber.

## Der typische Ablauf

```bash
git switch -c feature/login-ratelimit
# ... Dateien ändern ...
git add -p                 # Änderungen gezielt auswählen
git commit -m "Rate Limit für Login-Endpunkt"
git push -u origin feature/login-ratelimit
# Pull Request öffnen, Review, Tests, Merge
```

## Sicherheit im Repository

| Maßnahme | Wirkung |
|---|---|
| Branch Protection | kein direkter Push auf `main`, Reviews und Tests verpflichtend |
| Code Owners | Änderungen an sensiblen Bereichen brauchen bestimmte Reviewer |
| Signierte Commits | Herkunft nachweisbar (GPG/SSH/Sigstore) |
| Secret Scanning + Push Protection | Geheimnisse werden blockiert |
| Dependabot o. ä. | Abhängigkeiten aktuell |
| MFA für alle Konten | Kontoübernahme erschweren |

> [!WARNUNG] Öffentliche Repos sind öffentlich – für immer
> Was einmal gepusht wurde, kann kopiert, geforkt oder archiviert worden sein. Secrets sofort rotieren, nicht nur löschen.

## Tiefer eingetaucht

Workflows: **Trunk-based** (kurze Branches, häufige Merges, Feature-Flags) vs. **Git Flow** (lange Release-Branches). Für Sicherheit wichtig ist weniger der Stil als dass jede Änderung nachvollziehbar, geprüft und getestet ist.

CI/CD ist Teil der Angriffsfläche: Pipelines haben oft weitreichende Rechte (Deployments, Cloud-Zugänge). Schutz: Workflows aus Forks nicht mit Secrets laufen lassen, Rechte von Pipeline-Tokens minimieren, Drittanbieter-Actions auf Versionen pinnen (am besten per Commit-Hash), Build-Artefakte signieren (z. B. SLSA-Provenance).

## Quiz

? Mit welchem Befehl legt man einen neuen Branch an und wechselt hinein?
= git switch -c
= git checkout -b
! Beide Varianten funktionieren.

? Was verhindert Branch Protection?
+ direkte Pushes auf geschützte Branches ohne Review und Tests
- das Klonen des Repositories
- das Lesen des Codes
- das Anlegen neuer Dateien in Feature-Branches
! Änderungen laufen dann immer über Pull Requests.

? Was zeigen signierte Commits?
+ dass ein Commit nachweislich von einem bestimmten Schlüsselinhaber stammt
- dass der Code fehlerfrei ist
- dass der Commit verschlüsselt ist
- dass der Commit schneller ist
! Die Herkunft wird überprüfbar.

?tf Drittanbieter-Actions in CI-Pipelines sollten auf einen festen Commit-Hash gepinnt werden.
= wahr
! So kann eine spätere Änderung der Action nicht unbemerkt eingeschleust werden.

? Mit welcher Option wählt man Änderungen beim Hinzufügen stückweise aus?
= git add -p
= -p
! Patch-Modus – hilft, versehentliche Änderungen auszuschließen.

? Was ist bei einem versehentlich gepushten Secret zuerst zu tun?
+ das Secret rotieren
- den Commit-Text ändern
- das Repository umbenennen
- nichts, wenn es privat ist
! Auch private Repos können geleakt oder später öffentlich werden.
