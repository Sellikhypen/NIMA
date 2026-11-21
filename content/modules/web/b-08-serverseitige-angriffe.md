---
id: b-08
title: Serverseitige Schwachstellen – Command Injection, SSTI, SSRF, XXE
paths: cwes, cpts, cwee
order: 11
difficulty: hard
icon: server.rack
summary: Vier Klassen, bei denen der Server selbst zum Werkzeug wird – wie sie entstehen, woran man sie im Code und im Verhalten erkennt, welche Auswirkungen sie haben und wie man sie konsequent verhindert.
htb: Command Injections
---

## Command Injection

**Ursache:** Die Anwendung ruft ein Betriebssystemprogramm über eine Shell auf und setzt Benutzereingaben in die Befehlszeile ein (z. B. eine „Ping-Funktion“ im Router-Webinterface). Shell-Steuerzeichen wie Trennzeichen, Pipes oder Befehlssubstitution ermöglichen dann zusätzliche Befehle.

| sichere Gestaltung | Beispiel |
|---|---|
| keine Shell verwenden | `subprocess.run(["ping", "-c", "1", host])` statt `os.system("ping " + host)` |
| Eingabe streng validieren | Hostname/IP gegen Format prüfen |
| Bibliotheken statt Programme | DNS-Auflösung per Bibliothek statt `nslookup` |
| Rechte minimieren | Webanwendung ohne Root, Container mit eingeschränkten Capabilities |

**Erkennen:** Funktionen wie `system`, `exec`, `popen`, `Runtime.exec`, `child_process.exec`; im Betrieb: Shell-Prozesse als Kind des Webserver-Prozesses (EDR/Sysmon) – ein sehr starkes Signal.

## Server-Side Template Injection (SSTI)

**Ursache:** Benutzereingaben werden **als Template** gerendert statt als Daten eingesetzt. Template-Sprachen (Jinja2, Twig, Freemarker, Velocity …) können Ausdrücke auswerten und auf Objekte der Laufzeit zugreifen – im schlimmsten Fall bis zur Codeausführung.

**Erkennen:** Templates, die per String-Verkettung aus Benutzerdaten gebaut werden (`render_template_string(f"Hallo {name}")`). Im Verhalten: Eingaben mit Template-Syntax werden ausgewertet statt angezeigt.

**Verhindern:** Templates sind fester Code, Benutzerdaten werden nur als Variablen übergeben; Sandbox-Modi der Engines nutzen; logikarme Template-Sprachen bevorzugen.

## Server-Side Request Forgery (SSRF)

**Ursache:** Der Server ruft eine URL ab, die der Benutzer bestimmt – Bild-Import, PDF-Erzeugung aus Webseiten, Webhooks, Link-Vorschauen.

**Auswirkung:** Zugriff auf interne Dienste, die von außen nicht erreichbar sind; in der Cloud auf **Metadaten-Dienste**, die temporäre Zugangsdaten liefern können; Portscans interner Netze.

| Schutz | Wirkung |
|---|---|
| Allowlist erlaubter Ziele | nur bekannte Domains |
| interne und Link-Local-Bereiche blockieren – nach der DNS-Auflösung prüfen | verhindert Umwege über DNS |
| Weiterleitungen nicht automatisch folgen | verhindert Umgehung per Redirect |
| IMDSv2 (AWS) bzw. Header-Pflicht für Metadaten | erschwert Zugriff auf Cloud-Zugangsdaten |
| Egress-Filterung für Anwendungsserver | begrenzt erreichbare Ziele |

## XML External Entities (XXE)

**Ursache:** XML-Parser verarbeiten Document Type Definitions (DTDs) und lösen **externe Entitäten** auf – Verweise auf Dateien oder URLs, deren Inhalt in das Dokument eingesetzt wird.

**Auswirkung:** Lesen lokaler Dateien, SSRF, Denial of Service durch verschachtelte Entitäten.

**Wo XML versteckt ist:** SOAP-APIs, SAML, Office-Dokumente (DOCX/XLSX sind ZIP-Archive mit XML), SVG-Bilder, RSS-Feeds.

**Verhindern:** DTD-Verarbeitung und externe Entitäten im Parser deaktivieren (die sichere Einstellung ist sprach- und bibliotheksabhängig), aktuelle Bibliotheken, wo möglich JSON.

> [!MERKE] Gemeinsames Muster
> In allen vier Fällen wird eine Eingabe von einer mächtigen Komponente interpretiert: Shell, Template-Engine, HTTP-Client, XML-Parser. Die Abwehr folgt immer derselben Logik: **Interpretation vermeiden, Eingaben strikt begrenzen, Rechte und Netzwerkzugriff des Servers minimieren.**

## Quiz

? Was ist die sicherste Art, ein Programm aus einer Anwendung aufzurufen?
+ mit einer Argumentliste ohne Shell
- mit os.system und Escaping
- über eval
- über eine Web-Shell

? Welches Signal deutet im Betrieb stark auf Command Injection hin?
+ Shell-Prozesse als Kind des Webserver-Prozesses
- viele 200-OK-Antworten
- ein Zertifikatswechsel
- ein neuer DNS-Record

? Wie heißt die Klasse, bei der Benutzereingaben als Template gerendert werden?
= SSTI
= Server-Side Template Injection

? Welcher AWS-Mechanismus erschwert SSRF-Zugriffe auf Metadaten?
= IMDSv2

? In welchen Formaten kann XML versteckt sein?
+ DOCX
+ SVG
+ SAML
- PNG ohne Metadaten
- reiner Text

? Wie verhindert man XXE?
+ DTDs und externe Entitäten im Parser deaktivieren
- XML-Dateien umbenennen
- HTTPS verwenden
- Cookies setzen

?tf Bei SSRF sollte man die Zieladresse erst nach der DNS-Auflösung prüfen.
= wahr
