# NIMA-Lexikon: Erweiterung (Web, Netz, Cloud, Blue Team, AD)

## IPsec
aka: IKEv2, ESP
kat: Netzwerk
kurz: Protokollfamilie für verschlüsselte und authentifizierte IP-Kommunikation, Standard für Site-to-Site-VPNs.
IPsec arbeitet auf Schicht 3. IKE bzw. IKEv2 handelt Schlüssel und Sicherheitsparameter aus, ESP verschlüsselt und schützt die Integrität der Pakete. Im Tunnelmodus wird das komplette Originalpaket gekapselt – typisch für Verbindungen zwischen Standorten.
siehe: VPN, WireGuard

## Reverse Proxy
kat: Netzwerk
kurz: Server vor den eigentlichen Anwendungen, der Anfragen annimmt und weiterleitet.
Reverse Proxys terminieren TLS, verteilen Last, cachen Inhalte, filtern Angriffe (WAF) und verbergen die interne Struktur. Anwendungen dahinter dürfen Headern wie `X-Forwarded-For` nur vertrauen, wenn sie vom eigenen Proxy stammen.
siehe: Load Balancer, WAF

## Load Balancer
aka: Lastverteiler
kat: Netzwerk
kurz: Komponente, die Anfragen auf mehrere Server verteilt, um Leistung und Verfügbarkeit zu erhöhen.
Layer-4-Balancer verteilen nach IP und Port, Layer-7-Balancer verstehen HTTP und können nach Host, Pfad oder Cookie entscheiden. Health Checks nehmen ausgefallene Server automatisch aus der Verteilung.
siehe: Reverse Proxy

## Prepared Statement
aka: parametrisierte Abfrage, Parameterized Query
kat: Web
kurz: Datenbankabfrage, deren Struktur feststeht, bevor Benutzerdaten als Parameter eingesetzt werden.
Weil Code und Daten getrennt übertragen werden, kann eine Eingabe die Logik der Abfrage nicht verändern. Prepared Statements sind die grundlegende Maßnahme gegen SQL-Injection.
siehe: SQL-Injection

## SQL-Injection
aka: SQLi, SQL Injection
kat: Web
kurz: Schwachstelle, bei der Benutzereingaben die Struktur einer Datenbankabfrage verändern.
Ursache ist das Zusammensetzen von Abfragen aus Text. Folgen reichen vom Auslesen vertraulicher Daten bis zur Übernahme des Servers. Varianten: In-Band, Blind (Boolean/Time), Out-of-Band, Second Order. Schutz: Prepared Statements, Least Privilege, keine Fehlerausgaben.
siehe: Prepared Statement, OWASP

## CSP
aka: Content Security Policy
kat: Web
kurz: HTTP-Header, der festlegt, aus welchen Quellen eine Seite Skripte, Styles, Bilder und Frames laden darf.
Eine strenge CSP mit Nonces oder Hashes und ohne `'unsafe-inline'` macht viele XSS-Lücken unschädlich. Über `frame-ancestors` schützt sie zusätzlich vor Clickjacking. Einführung am besten im Report-Only-Modus.
siehe: XSS, HSTS

## HSTS
aka: HTTP Strict Transport Security
kat: Web
kurz: Header, der den Browser anweist, eine Domain künftig nur noch per HTTPS aufzurufen.
HSTS verhindert, dass Verbindungen unbemerkt auf HTTP herabgestuft werden. Mit `includeSubDomains` und Eintrag in die Preload-Liste der Browser gilt der Schutz schon beim ersten Besuch.
siehe: CSP, TLS

## Open Redirect
kat: Web
kurz: Weiterleitung, deren Ziel aus Benutzereingaben übernommen wird und so auf beliebige Seiten führt.
Open Redirects machen Phishing-Links glaubwürdiger, weil sie mit der vertrauenswürdigen Domain beginnen, und können OAuth-Abläufe gefährden. Schutz: nur relative Ziele oder eine Allowlist erlauben.
siehe: OAuth

## Path Traversal
aka: Directory Traversal, Verzeichnisüberschreitung
kat: Web
kurz: Zugriff auf Dateien außerhalb des vorgesehenen Verzeichnisses durch manipulierte Pfadangaben.
Entsteht, wenn Dateipfade aus Eingaben gebildet werden. Filter auf Zeichenebene sind unzuverlässig; richtig ist, keine Pfade aus Eingaben zu bilden oder den kanonischen Pfad gegen das Basisverzeichnis zu prüfen.
siehe: File Inclusion

## File Inclusion
aka: LFI, RFI, Local File Inclusion, Remote File Inclusion
kat: Web
kurz: Schwachstelle, bei der eine Anwendung vom Benutzer bestimmte Dateien einbindet und ausführt.
Local File Inclusion bindet Dateien des Servers ein, Remote File Inclusion Dateien über URLs. Neben Informationspreisgabe kann daraus Codeausführung werden. Schutz: feste Zuordnung statt Pfaden aus Eingaben, `allow_url_include` deaktiviert.
siehe: Path Traversal

## Command Injection
aka: OS Command Injection, Befehlsinjektion
kat: Web
kurz: Benutzereingaben gelangen in Betriebssystembefehle und ermöglichen zusätzliche Befehle.
Ursache ist der Aufruf externer Programme über eine Shell mit eingesetzten Eingaben. Schutz: keine Shell, Argumentlisten, strikte Validierung, minimale Rechte. Ein starkes Erkennungssignal sind Shell-Prozesse unter dem Webserver-Prozess.

## SSTI
aka: Server-Side Template Injection
kat: Web
kurz: Benutzereingaben werden als Template statt als Daten gerendert und dadurch ausgewertet.
Template-Engines können Ausdrücke auswerten und auf Laufzeitobjekte zugreifen; im schlimmsten Fall führt das zu Codeausführung. Schutz: Templates sind fester Code, Eingaben nur als Variablen übergeben.

## XXE
aka: XML External Entities
kat: Web
kurz: XML-Parser lösen externe Entitäten auf und lesen dadurch Dateien oder rufen URLs ab.
XXE betrifft alle Stellen, an denen XML verarbeitet wird: SOAP, SAML, Office-Dokumente, SVG. Schutz: DTDs und externe Entitäten im Parser deaktivieren.

## Subdomain-Takeover
aka: Subdomain Takeover
kat: Web
kurz: Übernahme einer Subdomain, deren DNS-Eintrag auf einen nicht mehr existierenden externen Dienst zeigt.
Verwaiste CNAME-Einträge auf gelöschte Cloud-Ressourcen erlauben es Dritten, die Ressource neu zu registrieren und Inhalte unter der fremden Subdomain auszuliefern. Schutz: DNS-Einträge beim Abbau von Diensten mitlöschen und regelmäßig prüfen.

## OAuth
aka: OAuth 2.0
kat: Web
kurz: Standard für delegierte Autorisierung – Apps erhalten begrenzten Zugriff, ohne das Passwort zu kennen.
Rollen: Resource Owner, Client, Authorization Server, Resource Server. Empfohlen ist der Authorization Code Flow mit PKCE. Häufige Fehler: ungenaue Prüfung der `redirect_uri`, fehlender `state`, zu weite Scopes.
siehe: OIDC, JWT, Open Redirect

## OIDC
aka: OpenID Connect
kat: Web
kurz: Identitätsschicht auf OAuth 2.0, die Anmeldung mit einem signierten ID Token ermöglicht.
Clients müssen Signatur, Aussteller, Empfänger, Ablauf und Nonce des ID Tokens prüfen. OIDC ist die Grundlage moderner Single-Sign-On-Lösungen (z. B. Keycloak, Entra ID).
siehe: OAuth

## GraphQL
kat: Web
kurz: API-Abfragesprache, bei der der Client über einen Endpunkt genau die benötigten Felder anfordert.
Sicherheitsthemen: Introspection in Produktion einschränken, Tiefen- und Komplexitätslimits, Batching beim Rate Limiting berücksichtigen, Autorisierung auf Feld- und Resolver-Ebene.
siehe: API

## Bug Bounty
aka: Bug-Bounty-Programm, VDP, Vulnerability Disclosure Program
kat: Offensive Sicherheit
kurz: Programm, in dem Unternehmen Sicherheitsforschende für gültige Schwachstellenmeldungen belohnen.
Erlaubt ist nur, was der Scope zulässt; Safe-Harbor-Regeln schützen bei Einhaltung. Gute Berichte sind reproduzierbar, realistisch in der Auswirkung und ohne fremde Daten. Ein VDP ist ein Meldeweg ohne Prämie.

## Metasploit
aka: Metasploit Framework, Meterpreter
kat: Werkzeuge
kurz: Verbreitetes Framework mit Modulen zum Prüfen und Nachweisen bekannter Schwachstellen.
Modultypen: Auxiliary, Exploit, Payload, Post, Encoder. Verteidiger kennen seine typischen Artefakte (Standard-Ports, Payload-Muster, Speicherinjektion) und decken sie mit EDR-, Sigma- und IDS-Regeln ab.
siehe: C2

## Beaconing
kat: Blue Team
kurz: Regelmäßige Rückmeldung eines Implantats an seinen Command-and-Control-Server.
Beacons melden sich in festen Intervallen mit etwas Zufall (Jitter). Auffällig gleichmäßige Verbindungen zu seltenen Zielen lassen sich in Flow-Daten und Proxy-Logs statistisch erkennen – auch bei verschlüsseltem Inhalt.
siehe: C2, Threat Hunting

## BEC
aka: Business E-Mail Compromise, CEO-Fraud
kat: Angriffsklassen
kurz: Betrug über kompromittierte oder gefälschte geschäftliche E-Mail-Konten, meist mit Zahlungsumleitung.
Angreifer übernehmen Postfächer, lesen Kommunikation mit und ändern im richtigen Moment Bankverbindungen. Schutz: MFA, Überwachung von Postfachregeln, Rückruf über bekannte Nummer bei Zahlungsänderungen.
siehe: Phishing

## auditd
aka: Linux Audit Daemon
kat: Blue Team
kurz: Linux-Dienst, der Systemaufrufe und Dateizugriffe nach Regeln protokolliert.
auditd erfasst z. B. Programmausführungen, Zugriffe auf `/etc/shadow` und Änderungen an sudoers oder Cron. Auswertung mit `ausearch` und `aureport`, Weiterleitung ins SIEM.

## CloudTrail
kat: Cloud
kurz: AWS-Dienst, der API-Aufrufe in einem AWS-Konto protokolliert.
CloudTrail zeigt, welche Identität wann von wo welche Aktion ausgeführt hat – die wichtigste Quelle für Untersuchungen in AWS. Trails sollten organisationsweit aktiviert und manipulationssicher gespeichert werden.

## Conditional Access
aka: bedingter Zugriff
kat: Cloud
kurz: Richtlinien in Entra ID, die Zugriffe abhängig von Benutzer, Gerät, Ort und Risiko erlauben oder einschränken.
Typische Regeln: MFA für alle, Zugriff nur von verwalteten Geräten, Legacy-Authentifizierung blockieren, Admin-Zugriffe nur von PAWs. Ein Kernbaustein von Zero Trust.
siehe: Zero Trust, MFA

## MDM
aka: Mobile Device Management, UEM
kat: Mobile
kurz: Zentrale Verwaltung mobiler Geräte – Richtlinien, App-Verteilung, Compliance und Fernlöschung.
MDM stellt sicher, dass nur aktuelle, verschlüsselte, nicht gejailbreakte Geräte auf Unternehmensdaten zugreifen, und trennt Arbeits- und Privatbereich.
siehe: Jailbreak

## Jailbreak
aka: Root, Rooting
kat: Mobile
kurz: Entfernen der Hersteller-Einschränkungen eines Mobilgeräts, wodurch Schutzmechanismen ausgehebelt werden.
Gejailbreakte bzw. gerootete Geräte gelten in Unternehmen als nicht vertrauenswürdig, weil Sandbox, Code-Signierung und Updates beeinträchtigt sein können. MDM-Lösungen erkennen und sperren sie.
siehe: MDM

## SAST
aka: Static Application Security Testing
kat: Entwicklung
kurz: Statische Analyse von Quellcode auf Sicherheitsfehler, ohne die Anwendung auszuführen.
Werkzeuge wie Semgrep, CodeQL oder SonarQube verfolgen Datenflüsse von Sources zu Sinks. Ergebnisse brauchen manuelle Prüfung, weil Fehlalarme häufig sind.
siehe: DAST, SBOM

## DAST
aka: Dynamic Application Security Testing
kat: Entwicklung
kurz: Prüfung einer laufenden Anwendung von außen durch automatisierte Anfragen.
DAST-Werkzeuge (z. B. OWASP ZAP, Burp Scanner) finden Fehler, die erst im Betrieb sichtbar werden, sehen aber den Code nicht. Ideal in Kombination mit SAST.
siehe: SAST

## IEC 62443
kat: OT
kurz: Normenreihe für die Cybersicherheit industrieller Automatisierungs- und Steuerungssysteme.
Kernkonzepte: Zonen und Conduits, Security Levels 1–4, Anforderungen an Betreiber, Integratoren und Hersteller. Grundlage für die Absicherung von OT-Netzen.
siehe: Purdue-Modell

## Delegation
aka: Kerberos-Delegation, Unconstrained Delegation, Constrained Delegation, RBCD
kat: Active Directory
kurz: Erlaubt einem Dienst, im Namen eines Benutzers auf andere Dienste zuzugreifen.
Unconstrained Delegation ist besonders riskant, weil der Dienst TGTs der Benutzer erhält. Constrained und ressourcenbasierte Delegation begrenzen die Ziele. Sensible Konten sollten als „cannot be delegated“ markiert bzw. Mitglied von Protected Users sein.
siehe: Kerberos

## PingCastle
kat: Werkzeuge
kurz: Werkzeug zur Risikobewertung von Active-Directory-Domänen mit Punktzahl und Maßnahmenliste.
PingCastle prüft u. a. veraltete Konfigurationen, privilegierte Gruppen, Delegationen, Trusts und ADCS-Vorlagen und eignet sich, um den Härtungsfortschritt über die Zeit zu verfolgen.
siehe: BloodHound

## EPSS
aka: Exploit Prediction Scoring System
kat: Grundbegriffe
kurz: Wert, der die Wahrscheinlichkeit angibt, dass eine Schwachstelle in den nächsten 30 Tagen ausgenutzt wird.
EPSS ergänzt CVSS um die Perspektive „Wie wahrscheinlich ist ein Angriff?“ und hilft bei der Priorisierung im Schwachstellenmanagement.
siehe: CVSS, KEV

## KEV
aka: Known Exploited Vulnerabilities, CISA KEV
kat: Grundbegriffe
kurz: Katalog der US-Behörde CISA mit Schwachstellen, die nachweislich aktiv ausgenutzt werden.
Einträge im KEV-Katalog sollten unabhängig vom CVSS-Wert mit höchster Priorität behoben werden, besonders auf internetfähigen Systemen.
siehe: EPSS, CVE

## Credential Guard
aka: Windows Defender Credential Guard
kat: Windows
kurz: Windows-Funktion, die Anmeldegeheimnisse in einer virtualisierungsgeschützten Umgebung isoliert.
Credential Guard verhindert, dass Werkzeuge NTLM-Hashes und Kerberos-Tickets direkt aus dem LSASS-Speicher lesen. Ergänzend schützt der LSA-Schutz (RunAsPPL) den LSASS-Prozess.
siehe: LSASS

## ZTNA
aka: Zero Trust Network Access
kat: Sicherheitsarchitektur
kurz: Zugriff auf einzelne Anwendungen nach Prüfung von Identität und Gerät statt Zugang zu ganzen Netzen.
ZTNA ersetzt oder ergänzt klassische VPNs: Benutzer sehen nur die Anwendungen, für die sie berechtigt sind, und jede Sitzung wird anhand von Richtlinien bewertet.
siehe: Zero Trust, VPN

## Bastion
aka: Jump-Host, Bastion Host, Sprungserver
kat: Sicherheitsarchitektur
kurz: Gehärteter, einziger Zugangspunkt für die Administration von Servern in geschützten Netzen.
Ein Bastion-Host erzwingt MFA, protokolliert und zeichnet Sitzungen auf und ist der einzige Weg in Management- oder Server-Zonen. So bleibt Administration nachvollziehbar und die Angriffsfläche klein.
siehe: Zero Trust

## Clickjacking
aka: UI Redressing
kat: Web
kurz: Eine fremde Seite bettet eine Anwendung unsichtbar ein und erschleicht Klicks der Benutzer.
Schutz bieten die CSP-Direktive `frame-ancestors` und der Header `X-Frame-Options`.
siehe: CSP

## Race Condition
aka: TOCTOU, Wettlaufsituation
kat: Web
kurz: Fehler, bei dem das Ergebnis von der zeitlichen Reihenfolge paralleler Vorgänge abhängt.
Prüfen gleichzeitige Anfragen denselben Zustand, bevor er aktualisiert wird, lassen sich z. B. Gutscheine mehrfach einlösen. Schutz: Transaktionen, Sperren, atomare Operationen, Idempotenz.

## Mass Assignment
kat: Web
kurz: Frameworks übernehmen ungeprüft alle Felder einer Anfrage in ein Objekt – auch nicht vorgesehene wie Rollen.
Schutz: explizite Allowlists erlaubter Felder über DTOs, Serializer oder `fillable`-Definitionen.

## Prototype Pollution
kat: Web
kurz: JavaScript-Schwachstelle, bei der Eigenschaften des gemeinsamen Objekt-Prototyps verändert werden.
Entsteht beim ungeprüften rekursiven Zusammenführen von Objekten mit Schlüsseln wie `__proto__`. Folgen reichen von Logikfehlern bis zur Codeausführung. Schutz: gefährliche Schlüssel ablehnen, `Map` oder `Object.create(null)` nutzen.

## Request Smuggling
aka: HTTP Request Smuggling
kat: Web
kurz: Frontend und Backend bestimmen die Grenzen von HTTP-Anfragen unterschiedlich, wodurch Anfragen „geschmuggelt“ werden.
Ursache sind widersprüchliche Angaben in `Content-Length` und `Transfer-Encoding`. Schutz: mehrdeutige Anfragen ablehnen, standardkonforme, aktuelle Proxys, HTTP/2 Ende-zu-Ende.
