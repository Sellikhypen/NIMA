---
id: ow-01
title: OWASP A01 · Broken Access Control
paths: cwes, cpts, cwee, cjca
order: 30
difficulty: medium
icon: lock.open.trianglebadge.exclamationmark
tags: owasp
summary: Die häufigste Web-Schwachstelle – wenn Benutzer Daten oder Funktionen erreichen, die ihnen nicht zustehen. Formen, Ursachen, Tests und robuste Zugriffskontrolle.
---

## Worum es geht

Zugriffskontrolle stellt sicher, dass Benutzer nur das tun können, wofür sie berechtigt sind. **Broken Access Control** steht seit 2021 auf Platz 1 der OWASP Top 10: In über 90 % der getesteten Anwendungen wurde irgendeine Form gefunden.

> [!INFO] Nummern gelten für die Ausgabe 2021
> Die OWASP-Module dieser Serie folgen der Ausgabe 2021. In der Ausgabe 2025 bleibt A01 vorn und nimmt SSRF auf, die meisten anderen Nummern verschieben sich ([[mod:f-09|Übersicht 2025]]).

## Erscheinungsformen

| Form | Beispiel |
|---|---|
| horizontaler Zugriff ([[IDOR]]) | `/konto/1002` statt `/konto/1001` zeigt fremde Daten |
| vertikaler Zugriff | normaler Benutzer ruft `/admin/` auf |
| fehlende Prüfung bei API-Methoden | GET ist geschützt, PUT/DELETE nicht |
| Manipulation von Rollen im Client | `role=admin` im Cookie oder Token wird übernommen |
| erzwungenes Browsen | ungeschützte, nur „versteckte“ URLs |
| CORS-Fehlkonfiguration | fremde Origins dürfen API mit Cookies nutzen |
| Pfadmanipulation | Zugriff auf Dateien außerhalb des Bereichs |

## Prävention

1. **Deny by default** – alles ist verboten, was nicht ausdrücklich erlaubt ist
2. Zugriffskontrolle **zentral** und **serverseitig** implementieren, einmal und überall wiederverwenden
3. Bei jedem Objektzugriff Besitz bzw. Berechtigung prüfen
4. Rollen und Rechte nie aus Client-Daten übernehmen
5. Verzeichnislisten deaktivieren, Metadaten (z. B. `.git`) nicht ausliefern
6. Fehlversuche protokollieren und alarmieren
7. Rate Limits gegen automatisierte Aufzählung
8. Tests für Rechte als Teil der automatisierten Testsuite

## Testen (Konzept)

Mit mindestens zwei Benutzern unterschiedlicher Rolle prüfen, ob Anfragen des einen mit der Sitzung des anderen funktionieren. Proxy-Erweiterungen automatisieren diesen Vergleich. Jede Funktion und jede Objekt-ID ist ein Testfall.

## Quiz

? Welche Kategorie steht in den OWASP Top 10 2021 auf Platz 1?
= Broken Access Control

? Was bedeutet „Deny by default“?
+ Alles ist verboten, was nicht ausdrücklich erlaubt ist
- Alles ist erlaubt, was nicht verboten ist
- Nur Admins dürfen sich anmelden
- Fehler werden ignoriert

? Wo muss Zugriffskontrolle implementiert werden?
+ serverseitig und zentral
- nur im JavaScript
- nur in der Firewall
- im Cookie

? Wie testet man Zugriffskontrolle sinnvoll?
+ mit mindestens zwei Benutzern unterschiedlicher Rollen
- nur mit dem Admin-Konto
- gar nicht
- nur mit Scannern

?tf Eine „versteckte“ URL ist eine wirksame Zugriffskontrolle.
= falsch

@@@ MODULE @@@
---
id: ow-02
title: OWASP A02 · Cryptographic Failures
paths: cwes, cpts, cwee
order: 31
difficulty: medium
icon: lock.slash
tags: owasp
summary: Wenn sensible Daten ungeschützt übertragen oder gespeichert werden – fehlende Verschlüsselung, veraltete Verfahren, schlechte Schlüssel und Passwort-Hashing.
---

## Worum es geht

Früher „Sensitive Data Exposure“ genannt: Die Ursache ist meist fehlende oder falsch eingesetzte Kryptografie.

## Typische Fehler

| Fehler | Beispiel |
|---|---|
| Klartextübertragung | HTTP, FTP, SMTP ohne TLS für sensible Daten |
| veraltete Verfahren | MD5/SHA-1 für Passwörter, DES, RC4, ECB-Modus |
| schwache Schlüssel | kurze, hartkodierte oder im Repository liegende Schlüssel |
| fehlende Zertifikatsprüfung | Clients akzeptieren jedes Zertifikat |
| vorhersagbare Zufallszahlen | Tokens aus nicht-kryptografischen Generatoren |
| fehlende Verschlüsselung im Ruhezustand | Backups, Datenbanken, Laptops |
| Passwörter falsch gespeichert | ungesalzen, schnell gehasht, umkehrbar verschlüsselt |

## Prävention

- Daten klassifizieren: Was ist sensibel (Gesetze, Geschäftsgeheimnisse)?
- nichts speichern, was man nicht braucht
- TLS 1.2+/1.3 überall, HSTS
- sensible Daten im Ruhezustand verschlüsseln, Schlüssel getrennt verwalten (KMS, HSM)
- Passwörter mit Argon2id, bcrypt oder scrypt
- kryptografisch sichere Zufallszahlen (`secrets` in Python, `crypto.randomBytes`)
- bewährte Bibliotheken, keine Eigenbauten
- Caching für sensible Antworten deaktivieren

Grundlagen in [[mod:f-08|Kryptografie]].

## Quiz

? Wie hieß A02 früher?
= Sensitive Data Exposure

? Welche Verfahren sind für Passwortspeicherung geeignet?
+ Argon2id
+ bcrypt
- MD5
- SHA-1 ohne Salt

? Welcher Python-Modul erzeugt kryptografisch sichere Zufallswerte?
= secrets

? Wo sollten Schlüssel verwaltet werden?
+ getrennt von den Daten, z. B. in KMS oder HSM
- im Quellcode
- in der gleichen Datenbanktabelle
- in einer E-Mail

?tf Der ECB-Modus ist für die Verschlüsselung strukturierter Daten empfehlenswert.
= falsch

@@@ MODULE @@@
---
id: ow-03
title: OWASP A03 · Injection
paths: cwes, cpts, cwee, cjca
order: 32
difficulty: medium
icon: syringe
tags: owasp
summary: SQL-, NoSQL-, OS-Command-, LDAP- und Template-Injection sowie XSS als gemeinsame Klasse – das Muster, die Varianten und die Abwehr.
---

## Worum es geht

Seit 2021 umfasst **Injection** auch Cross-Site Scripting. Gemeinsame Ursache: Benutzerdaten werden von einem Interpreter als Befehl verstanden.

| Interpreter | Injection-Art | Modul |
|---|---|---|
| SQL-Datenbank | SQL-Injection | [[mod:b-02|SQL-Injection]] |
| NoSQL-Datenbank | NoSQL-Injection | – |
| Shell | OS Command Injection | [[mod:b-08|Serverseitige Schwachstellen]] |
| LDAP | LDAP-Injection | – |
| Template-Engine | SSTI | [[mod:b-08|Serverseitige Schwachstellen]] |
| Browser | XSS | [[mod:b-03|XSS]] |
| XPath, Expression Languages, ORM-Abfragen | jeweilige Injection | – |

## Erkennen

- Quellcode-Review: Datenfluss von Eingaben zu Interpretern (Sources → Sinks, siehe [[mod:x-01|Code-Review]])
- SAST- und DAST-Werkzeuge
- manuelle Tests mit Sonderzeichen des jeweiligen Kontexts

## Prävention

1. sichere APIs, die Interpreter vermeiden oder parametrisieren
2. positive serverseitige Validierung (Allowlist)
3. kontextgerechtes Kodieren, wo Parametrisierung nicht möglich ist
4. `LIMIT` und ähnliche Begrenzungen gegen Massenauslese
5. Least Privilege für Datenbank- und Systemkonten

## Quiz

? Welche Schwachstelle gehört seit 2021 zur Kategorie Injection?
= XSS
= Cross-Site Scripting

? Was ist die gemeinsame Ursache aller Injection-Arten?
+ Benutzerdaten werden von einem Interpreter als Befehl verstanden
- zu lange Passwörter
- fehlende Backups
- langsame Server

? Welche Validierung ist zu bevorzugen?
+ positive Validierung mit Allowlist
- negative Validierung mit Blocklist
- gar keine
- nur im Browser

? Gegen welchen Interpreter richtet sich SSTI?
= Template-Engine
= Template Engine

?tf Parametrisierte Abfragen schützen auch vor LDAP-Injection automatisch.
= falsch

@@@ MODULE @@@
---
id: ow-04
title: OWASP A04 · Insecure Design
paths: cwes, cwee, specialist
order: 33
difficulty: medium
icon: pencil.and.ruler
tags: owasp
summary: Sicherheitsfehler, die schon im Entwurf stecken und sich durch perfekte Implementierung nicht beheben lassen – Threat Modeling, sichere Muster und Missbrauchsfälle.
---

## Worum es geht

**Insecure Design** unterscheidet sich von Implementierungsfehlern: Selbst fehlerfreier Code ist unsicher, wenn das Design keinen Schutz vorsieht – etwa ein Passwort-Reset über leicht recherchierbare Sicherheitsfragen oder ein Ticketverkauf ohne Begrenzung gegen Bots.

## Beispiele

| Design-Fehler | Folge |
|---|---|
| keine Begrenzung von Geschäftsabläufen | Bots kaufen Kontingente auf |
| Sicherheitsfragen statt sicherer Wiederherstellung | Kontoübernahme durch Recherche |
| Vertrauen in Client-seitige Berechnungen | Preis- oder Rabattmanipulation |
| fehlende Trennung von Mandanten | Datenlecks zwischen Kunden |
| kein Plan für Missbrauch | Funktionen werden zweckentfremdet |

## Prävention

- sicheren Entwicklungsprozess etablieren ([[mod:x-04|Secure SDLC]])
- **Threat Modeling** für kritische Abläufe (STRIDE, [[mod:s-06|Sicherheitsarchitektur]])
- **Missbrauchsfälle** (Abuse Cases) neben Anwendungsfällen beschreiben
- Bibliothek sicherer Designmuster und Komponenten
- Mandantentrennung auf allen Ebenen
- Plausibilitätsprüfungen und Limits in Geschäftsabläufen

## Quiz

? Was unterscheidet Insecure Design von Implementierungsfehlern?
+ Der Fehler steckt im Entwurf und lässt sich durch perfekten Code nicht beheben
- Er betrifft nur das Layout
- Er entsteht nur durch Tippfehler
- Es gibt keinen Unterschied

? Wie nennt man Szenarien, die beschreiben, wie eine Funktion missbraucht werden könnte?
= Abuse Cases
= Missbrauchsfälle

? Welche Methode identifiziert Bedrohungen schon im Design?
= Threat Modeling

? Warum sind Sicherheitsfragen ein Designfehler?
+ Die Antworten lassen sich oft recherchieren oder erraten
- Sie sind zu lang
- Sie werden verschlüsselt
- Sie sind zu sicher

@@@ MODULE @@@
---
id: ow-05
title: OWASP A05 · Security Misconfiguration
paths: cwes, cpts, cjca
order: 34
difficulty: easy
icon: gearshape.2
tags: owasp
summary: Standardpasswörter, offene Debug-Modi, unnötige Funktionen, fehlende Härtung und zu gesprächige Fehlermeldungen – und wie man Konfiguration reproduzierbar sicher macht.
---

## Typische Fehlkonfigurationen

| Bereich | Beispiel |
|---|---|
| Standardwerte | Standardkonten und -passwörter, Beispielanwendungen |
| Debug | Debug-Modus und Stacktraces in Produktion |
| unnötige Funktionen | offene Admin-Oberflächen, Verzeichnislisten, ungenutzte Ports |
| Header | fehlende Sicherheits-Header ([[mod:b-01|HTTP in der Tiefe]]) |
| Cloud | öffentliche Buckets, offene Sicherheitsgruppen |
| Frameworks | unsichere Standardoptionen, XML-Parser mit externen Entitäten |
| Updates | Konfiguration nach Updates nicht geprüft |

## Prävention

- **Härtungsprozess**, der identische, minimale Umgebungen erzeugt (Infrastructure as Code)
- Entwicklung, Test und Produktion gleich konfiguriert – mit unterschiedlichen Zugangsdaten
- nur benötigte Komponenten installieren
- Konfigurationsprüfung automatisieren (CIS Benchmarks, CSPM, Scanner)
- Segmentierung der Anwendungsarchitektur
- Fehlerseiten ohne interne Details

## Quiz

? Was gehört zu Security Misconfiguration?
+ Debug-Modus in Produktion
+ Standardpasswörter
- Prepared Statements
- MFA

? Welche Benchmarks helfen bei der Härtung?
= CIS Benchmarks
= CIS

? Warum sollte man Stacktraces nicht ausgeben?
+ Sie verraten interne Details wie Pfade, Versionen und Code
- Sie sind zu langsam
- Sie verbrauchen Speicher
- Sie sind verschlüsselt

?tf Entwicklungs- und Produktionsumgebung sollten identische Zugangsdaten verwenden.
= falsch

@@@ MODULE @@@
---
id: ow-06
title: OWASP A06 · Vulnerable and Outdated Components
paths: cwes, cpts, specialist
order: 35
difficulty: easy
icon: shippingbox.and.arrow.backward.fill
tags: owasp
summary: Bibliotheken, Frameworks und Plattformen mit bekannten Lücken – Inventar, SCA, Update-Prozesse und warum ungenutzte Abhängigkeiten ein Risiko sind.
---

## Worum es geht

Moderne Anwendungen bestehen zum Großteil aus Fremdkomponenten. Eine einzige verwundbare Bibliothek kann tausende Anwendungen betreffen – Log4Shell (2021) ist das bekannteste Beispiel.

## Risiken

- Versionen der eingesetzten Komponenten (auch transitive Abhängigkeiten) sind unbekannt
- Software ist veraltet oder wird nicht mehr unterstützt (End of Life)
- keine regelmäßige Prüfung auf Schwachstellen
- Updates werden lange aufgeschoben
- Kompatibilität nach Updates wird nicht getestet

## Prävention

| Maßnahme | Werkzeug |
|---|---|
| Inventar aller Komponenten | SBOM (CycloneDX, SPDX) |
| automatische Prüfung | SCA: Dependabot, Renovate, OWASP Dependency-Check, Trivy |
| Informationsquellen | CVE/NVD, Hersteller-Advisories, GitHub Security Advisories |
| ungenutzte Abhängigkeiten | entfernen |
| Bezugsquellen | nur offizielle Quellen, Signaturen prüfen |
| Patch-Fristen | nach Kritikalität, siehe [[mod:s-09|Schwachstellenmanagement]] |

## Quiz

? Welche Lücke von 2021 betraf eine weit verbreitete Java-Logging-Bibliothek?
= Log4Shell

? Wie heißt die Werkzeugklasse, die Abhängigkeiten auf bekannte Lücken prüft?
= SCA
= Software Composition Analysis

? Welche Werkzeuge erstellen automatisch Update-Pull-Requests?
+ Dependabot
+ Renovate
- Wireshark
- Volatility

? Warum sind ungenutzte Abhängigkeiten ein Risiko?
+ Sie vergrößern die Angriffsfläche ohne Nutzen
- Sie verlangsamen nur das Kompilieren
- Sie haben nie Schwachstellen
- Sie sind verschlüsselt

?tf Auch transitive Abhängigkeiten können Schwachstellen enthalten.
= wahr

@@@ MODULE @@@
---
id: ow-07
title: OWASP A07 · Identification and Authentication Failures
paths: cwes, cpts, cwee
order: 36
difficulty: medium
icon: person.fill.questionmark
tags: owasp
summary: Schwache Anmeldung, fehlendes MFA, Credential Stuffing, unsichere Wiederherstellung und Session-Fehler – und wie robuste Authentifizierung aussieht.
---

## Typische Schwächen

| Schwäche | Beispiel |
|---|---|
| automatisierte Angriffe möglich | kein Schutz gegen Credential Stuffing und Spraying |
| schwache Passwörter erlaubt | „Passwort123“ wird akzeptiert |
| unsichere Wiederherstellung | ratbare Reset-Tokens, Sicherheitsfragen |
| schlechte Passwortspeicherung | siehe A02 |
| fehlende oder umgehbare MFA | MFA nur im Frontend geprüft |
| Session-Fehler | Session-ID in der URL, keine Erneuerung nach Login, kein Ablauf |

## Prävention

- MFA, bevorzugt phishing-resistent (FIDO2/Passkeys)
- keine Standardzugangsdaten ausliefern
- Prüfung neuer Passwörter gegen Listen kompromittierter Passwörter
- Längenanforderungen nach NIST SP 800-63B statt Komplexitätsregeln
- einheitliche Fehlermeldungen gegen Benutzer-Enumeration
- Verzögerung/Begrenzung fehlgeschlagener Versuche, Alarmierung
- serverseitiger, sicherer Session-Manager mit zufälliger, nach Login erneuerter ID

Vertiefung: [[mod:x-02|Authentifizierung, OAuth, JWT]] und [[mod:c-06|Passwortsicherheit]].

## Quiz

? Welche MFA-Verfahren sind phishing-resistent?
+ FIDO2
+ Passkeys
- SMS
- E-Mail-Code

? Welcher NIST-Standard regelt digitale Identitäten und Passwörter?
= SP 800-63B
= 800-63B
= NIST SP 800-63B

? Wann muss eine Session-ID erneuert werden?
+ nach der Anmeldung
- nie
- nur beim Logout
- einmal im Jahr

? Warum sind einheitliche Fehlermeldungen beim Login wichtig?
+ Sie verhindern, dass man existierende Benutzernamen erkennt
- Sie sehen schöner aus
- Sie sind schneller
- Sie ersetzen MFA

@@@ MODULE @@@
---
id: ow-08
title: OWASP A08 · Software and Data Integrity Failures
paths: cwes, cwee, specialist
order: 37
difficulty: hard
icon: checkmark.seal.trianglebadge.exclamationmark
tags: owasp
summary: Unsignierte Updates, unsichere CI/CD-Pipelines, Abhängigkeiten aus unsicheren Quellen und unsichere Deserialisierung – Integrität von Code und Daten sichern.
---

## Worum es geht

A08 betrifft Annahmen über die **Integrität** von Software und Daten: Updates, Plugins, Bibliotheken und serialisierte Objekte werden ohne Prüfung vertraut.

## Beispiele

| Fall | Risiko |
|---|---|
| Auto-Update ohne Signaturprüfung | manipulierte Updates werden installiert |
| Bibliotheken aus öffentlichen CDNs ohne Integritätsprüfung | kompromittierte Skripte laufen auf der Seite |
| CI/CD mit zu weiten Rechten | Angreifer schleusen Code in den Build |
| unsichere Deserialisierung | Codeausführung beim Laden von Objekten |
| unsignierte Daten im Client (Cookies, versteckte Felder) | Manipulation von Zustand |

## Prävention

- Signaturen für Software und Updates prüfen (Code Signing, Sigstore)
- **Subresource Integrity** (`integrity="sha384-…"`) für externe Skripte
- Abhängigkeiten aus vertrauenswürdigen Repositories, idealerweise gespiegelt
- CI/CD absichern: Review-Pflicht, minimale Rechte, getrennte Secrets ([[mod:x-04|DevSecOps]])
- keine nativen Serialisierungsformate für nicht vertrauenswürdige Daten; signieren, wenn nötig

## Quiz

? Mit welchem HTML-Attribut prüft der Browser die Integrität externer Skripte?
= integrity
= Subresource Integrity

? Welche Schwachstellenklasse gehört zu A08?
+ unsichere Deserialisierung
- SQL-Injection
- Clickjacking
- Open Redirect

? Wie schützt man Updates vor Manipulation?
+ durch Signaturprüfung
- durch längere Dateinamen
- durch HTTP statt HTTPS
- gar nicht

?tf Eine CI/CD-Pipeline mit weitreichenden Rechten ist ein Integritätsrisiko.
= wahr

@@@ MODULE @@@
---
id: ow-09
title: OWASP A09 · Security Logging and Monitoring Failures
paths: cwes, cdsa, specialist
order: 38
difficulty: easy
icon: list.bullet.clipboard
tags: owasp
summary: Wenn Angriffe nicht bemerkt werden – was protokolliert werden muss, wie Logs geschützt werden und wie Alarmierung und Reaktion zusammenspielen.
---

## Worum es geht

Ohne Logging und Monitoring bleiben Einbrüche oft monatelang unentdeckt. A09 ist schwer automatisch zu testen, wiegt aber schwer: Die mittlere Zeit bis zur Entdeckung eines Einbruchs lag lange bei vielen Monaten.

## Was protokolliert werden sollte

- Anmeldungen (erfolgreich und fehlgeschlagen), Abmeldungen, Passwort- und MFA-Änderungen
- Zugriffsverweigerungen und Validierungsfehler
- Änderungen an Rechten, Rollen und kritischen Daten
- administrative Aktionen
- sicherheitsrelevante Konfigurationsänderungen

## Qualität von Logs

| Anforderung | Umsetzung |
|---|---|
| Kontext | Zeit (UTC), Benutzer, Quelle, Aktion, Ergebnis, Korrelations-ID |
| Format | strukturiert (JSON), maschinenlesbar |
| Integrität | zentral, schreibgeschützt bzw. unveränderlich |
| Datenschutz | keine Passwörter, Tokens oder unnötigen personenbezogenen Daten |
| Schutz vor Injection | Zeilenumbrüche und Steuerzeichen in Logdaten kodieren |
| Aufbewahrung | nach Bedarf und Recht festgelegt |

## Monitoring und Reaktion

Logs ohne Auswertung nützen wenig: SIEM-Use-Cases, Alarmierung mit Schwellen, Incident-Response-Plan und regelmäßige Tests (z. B. Purple Teaming). Siehe [[mod:d-01|SOC und SIEM]].

## Quiz

? Warum ist A09 so gefährlich?
+ Angriffe bleiben ohne Logging und Monitoring lange unbemerkt
- Logs verlangsamen Anwendungen
- Logs sind immer verschlüsselt
- es gibt keine Logs

? Welche Daten dürfen nicht in Logs stehen?
+ Passwörter
+ Session-Tokens
- Zeitstempel
- Ergebnis der Aktion

? In welcher Zeitzone sollten Logs idealerweise gespeichert werden?
= UTC

? Wie schützt man Logs vor Manipulation?
+ zentral und unveränderlich speichern
- lokal in einer Textdatei
- per E-Mail versenden
- gar nicht

@@@ MODULE @@@
---
id: ow-10
title: OWASP A10 · Server-Side Request Forgery
paths: cwes, cwee, cpts
order: 39
difficulty: hard
icon: arrow.triangle.turn.up.right.diamond
tags: owasp
summary: Wenn der Server Anfragen an vom Angreifer gewählte Ziele schickt – Varianten, Cloud-Metadaten, Umgehungstechniken auf Konzeptebene und mehrschichtige Abwehr.
---

## Worum es geht

**SSRF** entsteht, wenn eine Anwendung eine URL abruft, die (teilweise) vom Benutzer stammt. Der Server wird so zum Werkzeug, um Ziele zu erreichen, die von außen nicht erreichbar sind.

## Varianten

| Variante | Beschreibung |
|---|---|
| Basic SSRF | die Antwort wird dem Benutzer angezeigt |
| Blind SSRF | keine Antwort sichtbar, nur Nebenwirkungen (Zeit, externe Verbindung) |
| Teil-SSRF | nur Pfad oder Parameter kontrollierbar |

## Warum Filter oft scheitern

IP-Adressen lassen sich in vielen Schreibweisen darstellen, DNS-Namen können auf interne Adressen zeigen, Weiterleitungen können zu anderen Zielen führen und Namen können sich zwischen Prüfung und Abruf ändern (DNS-Rebinding). Prüfungen müssen deshalb **nach der Auflösung** und für **jede Weiterleitung** erfolgen.

## Abwehr in Schichten

| Ebene | Maßnahme |
|---|---|
| Netzwerk | Anwendungsserver dürfen nur benötigte Ziele erreichen (Egress-Filter) |
| Anwendung | Allowlist von Schemas, Hosts und Ports; Auflösung prüfen; keine Weiterleitungen folgen; rohe Antworten nicht zurückgeben |
| Cloud | Metadaten-Dienste absichern (IMDSv2), Rollen mit minimalen Rechten |
| Monitoring | Verbindungen von Anwendungsservern zu internen oder ungewöhnlichen Zielen alarmieren |

Vertiefung: [[mod:b-08|Serverseitige Schwachstellen]].

## Quiz

? Wie heißt SSRF, bei der keine Antwort sichtbar ist?
= Blind SSRF

? Wann muss die Zieladresse bei SSRF-Schutz geprüft werden?
+ nach der DNS-Auflösung und bei jeder Weiterleitung
- nur vor der Auflösung
- gar nicht
- nur am Wochenende

? Welcher Angriff ändert die DNS-Antwort zwischen Prüfung und Abruf?
= DNS-Rebinding
= DNS Rebinding

? Welcher Cloud-Schutz erschwert Zugriffe auf Metadaten?
= IMDSv2

?tf Egress-Filterung ist eine wirksame zusätzliche Schicht gegen SSRF.
= wahr
