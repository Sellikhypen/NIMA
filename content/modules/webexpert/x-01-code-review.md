---
id: x-01
title: Whitebox-Analyse und Code-Review
paths: cwee, cwes
order: 11
difficulty: hard
icon: doc.text.magnifyingglass
summary: Wie man Quellcode systematisch auf Schwachstellen prüft – Sources und Sinks, Datenfluss, gefährliche Funktionen je Sprache, Framework-Wissen, Werkzeuge für SAST und eine wiederholbare Review-Methodik.
---

## Warum Whitebox?

Bei einem **Whitebox-Test** liegt der Quellcode vor. Das ist kein „Schummeln“, sondern die effizienteste Art, Schwachstellen zu finden: Statt Verhalten von außen zu erraten, sieht man direkt, wie Eingaben verarbeitet werden. Das CWEE legt großen Wert darauf, Fehler im Code zu erkennen und zu verketten.

## Sources, Sinks und Datenfluss

| Begriff | Bedeutung | Beispiele |
|---|---|---|
| **Source** | Stelle, an der nicht vertrauenswürdige Daten eintreten | Request-Parameter, Header, Cookies, Datei-Uploads, Datenbankinhalte aus Benutzerhand, Webhooks |
| **Sink** | Stelle, an der Daten gefährlich werden können | SQL-Abfragen, Shell-Aufrufe, Dateipfade, Template-Rendering, HTML-Ausgabe, Deserialisierung, HTTP-Clients |
| **Sanitizer / Validator** | Stelle, an der Daten geprüft oder kodiert werden | Prepared Statements, Escaping-Funktionen, Allowlists |

Die Kernfrage jedes Reviews: **Gibt es einen Weg von einer Source zu einem Sink, auf dem kein ausreichender Schutz liegt?** Das nennt man **Taint-Analyse**.

> [!TIPP] Zwei Richtungen
> *Top-down*: von den Endpunkten (Routen, Controller) ausgehen und Eingaben verfolgen. *Bottom-up*: gefährliche Sinks suchen und rückwärts prüfen, ob Benutzerdaten sie erreichen. Erfahrene Reviewer kombinieren beides.

## Gefährliche Muster nach Sprache (Auswahl)

| Sprache | Sink-Kategorie | Beispiele für Funktionen, die genau geprüft werden müssen |
|---|---|---|
| PHP | Code/Befehl | `eval`, `system`, `exec`, `shell_exec`, `passthru`, Backticks |
| PHP | Datei | `include`, `require`, `file_get_contents`, `fopen` |
| PHP | Deserialisierung | `unserialize` |
| Python | Befehl | `os.system`, `subprocess` mit `shell=True` |
| Python | Deserialisierung | `pickle.loads`, `yaml.load` ohne SafeLoader |
| Python | Template | `render_template_string` mit Benutzerdaten |
| JavaScript/Node | Code | `eval`, `Function`, `vm` ohne Isolation |
| JavaScript/Node | Objekt | rekursives Zusammenführen von Objekten (Prototype Pollution) |
| Java | Deserialisierung | `ObjectInputStream.readObject` |
| Java | Ausdrücke | Expression Languages mit Benutzerdaten |
| .NET | Deserialisierung | `BinaryFormatter` (veraltet und unsicher) |
| alle | SQL | String-Verkettung in Abfragen statt Parameter |

> [!WARNUNG] Frameworks schützen nur, wenn man sie lässt
> Moderne Frameworks escapen Ausgaben und parametrisieren Abfragen automatisch. Lücken entstehen dort, wo Entwickler diese Mechanismen bewusst umgehen: „raw“-Abfragen, `|safe`-Filter, `dangerouslySetInnerHTML`, eigene Template-Strings.

## Autorisierung im Code prüfen

Viele kritische Fehler sind keine Injections, sondern fehlende Prüfungen:

- Hat **jeder** Endpunkt eine Authentifizierungs- und Autorisierungsprüfung? (Routen-Liste gegen Middleware abgleichen)
- Wird bei Objektzugriffen geprüft, ob das Objekt dem Benutzer gehört? ([[IDOR]])
- Werden Rollen serverseitig aus der Sitzung gelesen oder aus der Anfrage übernommen?
- Werden alle Felder eines Objekts aus der Anfrage übernommen (**Mass Assignment**)?

## Werkzeuge

| Kategorie | Beispiele | Hinweis |
|---|---|---|
| Suche | `grep`/`ripgrep`, IDE-Suche | schnell, aber ohne Kontext |
| SAST | Semgrep, CodeQL, SonarQube | regelbasierte Datenflussanalyse; Fehlalarme prüfen |
| SCA | Dependabot, OWASP Dependency-Check, Trivy | bekannte Lücken in Abhängigkeiten |
| Secret-Scanning | Gitleaks, TruffleHog | versehentlich eingecheckte Schlüssel |
| Debugger | IDE-Debugger, Xdebug | Verhalten zur Laufzeit nachvollziehen |

## Eine wiederholbare Review-Methodik

1. **Architektur verstehen** – Framework, Routing, Authentifizierung, Datenbankzugriff, Konfiguration
2. **Angriffsfläche inventarisieren** – alle Endpunkte mit Methode und benötigten Rechten
3. **Querschnittsthemen prüfen** – Authentifizierung, Sessions, Autorisierung, Fehlerbehandlung, Kryptografie, Logging
4. **Sinks suchen** und Datenflüsse zurückverfolgen
5. **Abhängigkeiten und Konfiguration** prüfen (Debug-Modus, Secrets, CORS)
6. **Hypothesen dynamisch verifizieren** in einer Testinstanz
7. **Befunde mit Codezeile, Datenfluss und Fix** dokumentieren

> [!MERKE] Verkettung
> Expertenprüfungen belohnen das Kombinieren kleiner Fehler: eine Informationspreisgabe liefert eine ID, ein Autorisierungsfehler erlaubt Zugriff, eine unsichere Funktion ermöglicht den Rest. Im Bericht wird die gesamte Kette als Attack Chain beschrieben – siehe [[mod:c-10|Reporting]].

## Quiz

? Wie nennt man die Stelle, an der nicht vertrauenswürdige Daten in eine Anwendung gelangen?
= Source
= Quelle

? Wie nennt man die Stelle, an der Daten gefährlich verarbeitet werden?
= Sink
= Senke

? Wie heißt die Analyse, die Datenflüsse von Sources zu Sinks verfolgt?
= Taint-Analyse
= Taint Analysis
= Taint

? Welche Werkzeuge sind SAST-Werkzeuge?
+ Semgrep
+ CodeQL
- Wireshark
- Nmap

? Welche Python-Funktion ist bei nicht vertrauenswürdigen Daten ein Deserialisierungs-Risiko?
= pickle.loads
= pickle

? Wie heißt der Fehler, bei dem alle Felder eines Objekts ungeprüft aus der Anfrage übernommen werden?
= Mass Assignment

?tf Frameworks schützen auch dann, wenn Entwickler „raw“-Abfragen nutzen.
= falsch

? Welche Werkzeuge finden versehentlich eingecheckte Schlüssel?
+ Gitleaks
+ TruffleHog
- Burp Repeater
- Volatility
