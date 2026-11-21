# NIMA-Lexikon: Grundlagen, Security-Management, Blue Team, Web, WLAN

## Hashfunktion
aka: Hash, Hashwert, Prüfsumme
kat: Kryptografie
kurz: Einwegfunktion, die beliebige Daten auf einen Wert fester Länge abbildet.
Eine Hashfunktion erzeugt aus beliebigen Eingaben einen Fingerabdruck fester Länge. Gute Hashfunktionen sind nicht umkehrbar, kollisionsresistent und ändern bei kleinster Änderung der Eingabe etwa die Hälfte der Ausgabebits.

Einsatz: Integritätsprüfung von Dateien, digitale Signaturen, Identifikation von Schadsoftware, Passwortspeicherung (dort nur mit langsamen, gesalzenen Verfahren). Aktuell: SHA-256, SHA-3. Gebrochen: MD5, SHA-1.
siehe: Salt, bcrypt, Rainbow Table, Base64

## Base64
kat: Grundlagen
kurz: Kodierung, die Binärdaten mit 64 druckbaren Zeichen darstellt – keine Verschlüsselung.
Base64 wandelt je drei Bytes in vier Zeichen aus `A–Z`, `a–z`, `0–9`, `+` und `/` um; am Ende wird mit `=` aufgefüllt. Es wird genutzt, um Binärdaten durch textbasierte Kanäle zu schicken (E-Mail-Anhänge, HTTP-Basic-Auth, Zertifikate im PEM-Format, Teile von JWTs).

Base64 bietet keinerlei Schutz: Jeder kann es ohne Schlüssel zurückwandeln. Passwörter, die nur Base64-kodiert gespeichert sind, gelten als Klartext.
siehe: Hashfunktion, JWT

## Subnetzmaske
aka: Netzmaske, Subnet Mask
kat: Netzwerk
kurz: 32-Bit-Wert, der festlegt, welcher Teil einer IPv4-Adresse das Netz und welcher den Host bezeichnet.
Einsen in der Maske markieren den Netzanteil, Nullen den Hostanteil. `255.255.255.0` entspricht 24 Einsen und wird in CIDR-Notation als `/24` geschrieben. Aus Adresse und Maske ergeben sich Netzadresse, Broadcast-Adresse und der nutzbare Hostbereich.
siehe: Subnetting, IP-Adresse

## Subnetting
aka: Subnetzbildung, CIDR
kat: Netzwerk
kurz: Aufteilen eines IP-Adressbereichs in kleinere Netze.
Beim Subnetting verlängert man den Netzanteil einer Adresse, um aus einem großen Bereich mehrere kleine Netze zu machen. Formel: Adressen pro Netz = 2^(32 − Präfix), nutzbare Hosts = Adressen − 2. Subnetting ist Grundlage für Netzsegmentierung, Firewall-Regeln und Scope-Definitionen in Pentests.
siehe: Subnetzmaske, Netzsegmentierung

## IP-Adresse
aka: IPv4, IPv6, IP
kat: Netzwerk
kurz: Logische Adresse eines Geräts auf Schicht 3 – 32 Bit (IPv4) oder 128 Bit (IPv6).
IPv4-Adressen werden als vier Dezimalzahlen geschrieben (`192.168.1.10`), IPv6-Adressen als acht hexadezimale Blöcke (`2001:db8::1`). Private Bereiche nach RFC 1918 (10/8, 172.16/12, 192.168/16) werden im Internet nicht geroutet und per NAT übersetzt.
siehe: Subnetzmaske, NAT, Router

## Router
kat: Netzwerk
kurz: Gerät, das Pakete anhand von IP-Adressen zwischen Netzen weiterleitet (OSI-Schicht 3).
Ein Router entscheidet anhand seiner Routing-Tabelle, über welche Schnittstelle ein Paket sein Ziel erreicht. Zwischen Sicherheitszonen übernimmt meist eine Firewall die Routerfunktion und filtert dabei den Verkehr.
siehe: Switch, Firewall

## Switch
kat: Netzwerk
kurz: Gerät, das Frames anhand von MAC-Adressen innerhalb eines Netzes weiterleitet (OSI-Schicht 2).
Ein Switch lernt, an welchem Port welche MAC-Adresse hängt, und leitet Frames gezielt weiter. Managebare Switches unterstützen VLANs, Port Security, 802.1X, DHCP Snooping und Dynamic ARP Inspection – wichtige Schutzmechanismen gegen Angriffe auf Schicht 2.
siehe: Router, ARP-Spoofing

## Netzsegmentierung
aka: Segmentierung, Mikrosegmentierung
kat: Sicherheitsarchitektur
kurz: Aufteilen eines Netzes in Zonen, zwischen denen nur erlaubter Verkehr fließt.
Segmentierung begrenzt, wie weit sich ein Angreifer nach einem Einbruch bewegen kann. Typische Zonen: DMZ, Server, Clients, Management, OT, Gäste. Zwischen den Zonen gilt Default Deny. Mikrosegmentierung geht noch weiter und regelt Verkehr bis auf einzelne Workloads.
siehe: Zero Trust, Subnetting

## ARP-Spoofing
aka: ARP Poisoning, ARP-Cache-Vergiftung
kat: Netzwerk
kurz: Gefälschte ARP-Antworten, mit denen sich ein Gerät als anderes ausgibt, um Verkehr umzuleiten.
ARP prüft Antworten nicht. Ein Gerät im selben Netz kann daher behaupten, die IP-Adresse des Gateways zu besitzen, und Verkehr über sich leiten (Man-in-the-Middle). Schutz: Dynamic ARP Inspection auf Switches, Segmentierung, durchgehende Verschlüsselung (TLS), Überwachung auf doppelte IP-MAC-Zuordnungen.
siehe: Man-in-the-Middle, Switch

## Man-in-the-Middle
aka: MitM, AitM, Adversary-in-the-Middle
kat: Angriffsklassen
kurz: Ein Angreifer schaltet sich unbemerkt zwischen zwei Kommunikationspartner.
Bei einem Man-in-the-Middle-Angriff kann der Angreifer Verkehr mitlesen oder verändern. Möglich wird das z. B. durch ARP-Spoofing, gefälschte WLAN-Zugangspunkte oder manipulierte DNS-Antworten. Schutz bietet vor allem Ende-zu-Ende-Verschlüsselung mit korrekter Zertifikatsprüfung.
siehe: ARP-Spoofing, Evil Twin, Zertifikat

## Zonentransfer
aka: AXFR, Zone Transfer
kat: Netzwerk
kurz: Übertragung einer kompletten DNS-Zone an einen anderen Nameserver.
Zonentransfers dienen der Replikation zwischen primärem und sekundärem Nameserver. Ist AXFR für beliebige Anfragende erlaubt, erhält jeder eine vollständige Liste aller Hostnamen der Zone – wertvolle Aufklärung für Angreifer. Zonentransfers gehören auf autorisierte Server beschränkt.

## FTP
aka: File Transfer Protocol
kat: Dienste
kurz: Altes Dateiübertragungsprotokoll auf Port 21, überträgt standardmäßig alles im Klartext.
FTP nutzt einen Steuerkanal (21) und separate Datenkanäle (aktiv/passiv). Häufige Befunde: anonymer Zugang, Klartext-Passwörter, beschreibbare Verzeichnisse. Sichere Alternativen sind SFTP (über SSH) oder FTPS (FTP mit TLS).
siehe: SSH

## SMB
aka: Server Message Block, CIFS, Samba
kat: Dienste
kurz: Protokoll für Datei- und Druckerfreigaben unter Windows, Port 445.
SMB ist zentral für Windows-Netze und Active Directory (z. B. SYSVOL). Risiken: anonyme Freigaben, zu weite Rechte, die veraltete Version SMBv1 (Einfallstor großer Würmer) und fehlende Signierung (ermöglicht Relay-Angriffe). Härtung: SMBv1 deaktivieren, Signing erzwingen, Freigaberechte regelmäßig prüfen.
siehe: NTLM, Active Directory

## SMTP
aka: Simple Mail Transfer Protocol
kat: Dienste
kurz: Protokoll für den Mailversand zwischen Servern (Port 25, Submission 587).
SMTP-Server sollten keine Mails beliebiger Absender an beliebige Empfänger weiterleiten (Open Relay) und Benutzer-Enumeration über VRFY/EXPN unterbinden. Absenderdomänen werden mit SPF, DKIM und DMARC abgesichert.

## SNMP
aka: Simple Network Management Protocol
kat: Dienste
kurz: Protokoll zur Überwachung und Verwaltung von Netzwerkgeräten (UDP 161).
SNMPv1 und v2c schützen Zugriffe nur mit Klartext-„Community-Strings“ wie `public`. Darüber lassen sich oft Netzstruktur, Software und Konfiguration auslesen. SNMPv3 bietet Authentifizierung und Verschlüsselung und sollte ausschließlich verwendet werden.

## Cookie
kat: Web
kurz: Kleiner Datensatz, den der Browser für eine Website speichert und bei jeder Anfrage mitschickt.
Cookies tragen meist die Session-ID. Wichtige Attribute: `Secure` (nur HTTPS), `HttpOnly` (für JavaScript unlesbar), `SameSite` (nicht bei fremden Seiten mitsenden). Fehlen diese Attribute, steigt das Risiko von Session-Diebstahl und CSRF.
siehe: Session, CSRF, XSS

## Session
aka: Sitzung, Session-ID
kat: Web
kurz: Serverseitiger Zustand einer angemeldeten Benutzersitzung, referenziert über eine zufällige ID.
Weil HTTP zustandslos ist, merkt sich die Anwendung angemeldete Benutzer in Sessions. Die Session-ID muss lang und zufällig sein, nach dem Login neu vergeben werden (gegen Session Fixation), ablaufen und beim Logout serverseitig ungültig werden.
siehe: Cookie

## XSS
aka: Cross-Site Scripting
kat: Web
kurz: Schwachstelle, bei der eingeschleuster Code im Browser anderer Benutzer ausgeführt wird.
XSS entsteht, wenn Benutzereingaben ohne kontextgerechte Kodierung in Webseiten ausgegeben werden. Varianten: reflected, stored, DOM-basiert. Schutz: Ausgabe-Kodierung, Templates mit automatischem Escaping, Content Security Policy, HttpOnly-Cookies.
siehe: CSRF, Cookie, OWASP

## CSRF
aka: Cross-Site Request Forgery, XSRF
kat: Web
kurz: Eine fremde Seite löst im Namen eines angemeldeten Benutzers ungewollte Aktionen aus.
Weil Browser Cookies automatisch mitschicken, kann eine präparierte Seite Anfragen an eine Anwendung auslösen, bei der das Opfer angemeldet ist. Schutz: Anti-CSRF-Token, SameSite-Cookies, erneute Bestätigung bei kritischen Aktionen.
siehe: Cookie, XSS

## IDOR
aka: Insecure Direct Object Reference, BOLA
kat: Web
kurz: Zugriff auf fremde Datensätze, weil der Server nicht prüft, ob der Benutzer das Objekt sehen darf.
Ein typisches Beispiel: `/api/rechnung/1001` liefert auch dann Daten, wenn man die ID auf 1002 ändert. IDOR gehört zur Kategorie Broken Access Control (OWASP A01). Schutz: Autorisierung bei jedem Objektzugriff serverseitig prüfen.
siehe: OWASP

## SSRF
aka: Server-Side Request Forgery
kat: Web
kurz: Der Server ruft vom Angreifer bestimmte URLs auf und erreicht so interne Ziele.
SSRF entsteht bei Funktionen wie „Bild von URL laden“ oder Webhooks. Angreifer erreichen darüber interne Dienste oder Cloud-Metadaten mit temporären Zugangsdaten. Schutz: Allowlist erlaubter Ziele, Blockieren interner Adressbereiche, abgesicherte Metadaten-Dienste, Egress-Filterung.
siehe: OWASP

## OWASP
aka: Open Worldwide Application Security Project, OWASP Top 10
kat: Web
kurz: Gemeinnützige Organisation für Anwendungssicherheit, bekannt für die OWASP Top 10.
OWASP veröffentlicht frei verfügbare Standards und Werkzeuge: die Top 10 der häufigsten Web-Risiken, den Web Security Testing Guide (WSTG), den Application Security Verification Standard (ASVS), die API Security Top 10 und Werkzeuge wie OWASP ZAP.
siehe: XSS, IDOR, SSRF

## Wireshark
kat: Werkzeuge
kurz: Grafisches Werkzeug zur Analyse von Netzwerkverkehr auf Paketebene.
Wireshark zeigt jedes Paket mit allen Protokollschichten, bietet Anzeigefilter (z. B. `tcp.port == 445`), Statistiken und kann TCP-Unterhaltungen rekonstruieren. Standardwerkzeug für Fehlersuche, Forensik und Lernen.
siehe: Nmap

## Nmap
aka: Network Mapper
kat: Werkzeuge
kurz: Open-Source-Scanner für Host Discovery, Port-Scans, Diensterkennung und Skripte.
Nmap ermittelt erreichbare Hosts, offene Ports, Dienstversionen und Betriebssysteme und erweitert dies mit Lua-Skripten (NSE). Administratoren nutzen es zur Inventarisierung ihrer Angriffsfläche, Prüfer zur Enumeration – immer nur in erlaubtem Scope.
siehe: Wireshark

## SAM
aka: Security Account Manager
kat: Windows
kurz: Windows-Datenbank mit den lokalen Benutzerkonten und ihren Passwort-Hashes.
Die SAM liegt unter `C:\Windows\System32\config\SAM` und ist im laufenden Betrieb gesperrt. Zum Entschlüsseln der Hashes wird zusätzlich der SYSTEM-Hive benötigt. Lokale Administratorpasswörter sollten mit LAPS pro Rechner eindeutig sein.

## Diffie-Hellman
aka: DH, ECDH, ECDHE
kat: Kryptografie
kurz: Verfahren, mit dem zwei Parteien über einen unsicheren Kanal einen gemeinsamen Schlüssel vereinbaren.
Beide Seiten tauschen öffentliche Werte aus und berechnen daraus denselben geheimen Schlüssel, ohne ihn je zu übertragen. Mit flüchtigen Schlüsseln (DHE/ECDHE) entsteht Forward Secrecy. Diffie-Hellman allein authentifiziert nicht – das übernehmen Zertifikate.
siehe: RSA, Zertifikat

## RSA
kat: Kryptografie
kurz: Asymmetrisches Verfahren für Verschlüsselung und Signaturen, basiert auf der Faktorisierung großer Zahlen.
RSA nutzt ein Schlüsselpaar aus öffentlichem und privatem Schlüssel. Empfohlene Schlüssellänge heute mindestens 2048 Bit, besser 3072 Bit. Für neue Systeme werden oft elliptische Kurven bevorzugt.
siehe: Diffie-Hellman, Zertifikat

## bcrypt
aka: scrypt, Argon2, PBKDF2
kat: Kryptografie
kurz: Langsames, gesalzenes Verfahren zum sicheren Speichern von Passwörtern.
bcrypt, scrypt und Argon2 sind absichtlich rechenaufwendig (Work Factor) und enthalten einen Salt. Dadurch werden Offline-Rateversuche nach einem Datenleck stark verlangsamt. Argon2id gilt heute als Empfehlung.
siehe: Salt, Hashfunktion

## Salt
kat: Kryptografie
kurz: Zufallswert, der vor dem Hashen an jedes Passwort angehängt wird.
Durch den Salt ergeben gleiche Passwörter unterschiedliche Hashes, und vorberechnete Tabellen werden nutzlos. Der Salt ist nicht geheim und wird zusammen mit dem Hash gespeichert.
siehe: Rainbow Table, bcrypt

## Rainbow Table
kat: Kryptografie
kurz: Vorberechnete Tabelle, um ungesalzene Hashes schnell auf Passwörter zurückzuführen.
Rainbow Tables tauschen Rechenzeit gegen Speicher. Gegen gesalzene Hashes sind sie wirkungslos, weil für jeden Salt eine eigene Tabelle nötig wäre.
siehe: Salt

## Zertifikat
aka: X.509, TLS-Zertifikat, digitales Zertifikat
kat: Kryptografie
kurz: Von einer Zertifizierungsstelle signiertes Dokument, das einen öffentlichen Schlüssel an eine Identität bindet.
Ein X.509-Zertifikat enthält u. a. Subject, alternative Namen (SAN), Aussteller, Gültigkeitszeitraum und den öffentlichen Schlüssel. Clients prüfen die Vertrauenskette bis zu einer vertrauenswürdigen Root-CA. Ohne Zertifikatsprüfung ist TLS anfällig für Man-in-the-Middle.
siehe: Diffie-Hellman, RSA

## Docker
aka: Container
kat: Virtualisierung
kurz: Plattform für Container – leichtgewichtige, isolierte Prozessumgebungen mit gemeinsamem Kernel.
Container isolieren über Namespaces und cgroups. Risiken: Ausführung als root, `--privileged`, gemounteter Docker-Socket, Secrets in Images, veraltete Basis-Images. Mitglieder der Gruppe `docker` haben faktisch Root-Rechte auf dem Host.

## Penetrationstest
aka: Pentest, Penetration Test
kat: Offensive Sicherheit
kurz: Beauftragte Sicherheitsprüfung, bei der Schwachstellen kontrolliert nachgewiesen werden.
Ein Pentest folgt einem definierten Prozess (Pre-Engagement bis Retest) innerhalb klarer Rules of Engagement. Ergebnis ist ein Bericht mit bewerteten Befunden und Empfehlungen. Ohne schriftliche Erlaubnis des Berechtigten ist ein „Test“ eine Straftat.

## Password Spraying
kat: Angriffsklassen
kurz: Wenige häufige Passwörter werden gegen viele Konten getestet, um Kontosperren zu umgehen.
Erkennungsmerkmal sind fehlgeschlagene Anmeldungen, die sich über viele Konten verteilen, mit wenigen Versuchen pro Konto. Schutz: Passwort-Blocklisten, MFA, Überwachung der Ereignisse 4625/4771 und Smart Lockout.
siehe: MFA

## Schwachstelle
aka: Vulnerability, Sicherheitslücke
kat: Grundbegriffe
kurz: Eigenschaft eines Systems, die von einer Bedrohung ausgenutzt werden kann.
Schwachstellen entstehen durch Programmierfehler, Fehlkonfiguration, fehlende Updates oder menschliches Verhalten. Öffentlich bekannte Schwachstellen erhalten eine CVE-Nummer und werden mit CVSS bewertet.
siehe: Risiko

## Risiko
kat: Grundbegriffe
kurz: Kombination aus Eintrittswahrscheinlichkeit und Schadenshöhe eines Ereignisses.
Risiken werden identifiziert, analysiert, bewertet und behandelt: vermeiden, reduzieren, übertragen oder akzeptieren. Das verbleibende Restrisiko muss vom Risikoeigentümer bewusst akzeptiert werden.
siehe: Schwachstelle, ISMS

## APT
aka: Advanced Persistent Threat
kat: Grundbegriffe
kurz: Hochqualifizierte, meist staatlich unterstützte Angreifergruppe mit langfristigen Zielen.
APTs arbeiten geduldig und unauffällig, oft über Monate, mit eigenen Werkzeugen und gezieltem Social Engineering. Ihre Techniken werden in MITRE ATT&CK unter Gruppennamen dokumentiert.
siehe: MITRE ATT&CK

## ISMS
aka: Informationssicherheits-Managementsystem
kat: Management
kurz: Regeln, Prozesse und Verantwortlichkeiten, mit denen Informationssicherheit gesteuert und verbessert wird.
Ein ISMS folgt dem PDCA-Zyklus und ist z. B. in ISO/IEC 27001 und BSI-Standard 200-1 beschrieben. Kern sind Risikobeurteilung, Maßnahmenauswahl, Messung der Wirksamkeit und kontinuierliche Verbesserung.
siehe: ISO 27001, BSI

## ISO 27001
aka: ISO/IEC 27001
kat: Management
kurz: Internationale Norm für Informationssicherheits-Managementsysteme, zertifizierbar.
Die Fassung 2022 enthält die Pflichtkapitel 4–10 und im Annex A 93 Maßnahmen in vier Themen. Zentrales Dokument ist die Erklärung zur Anwendbarkeit (SoA). Zertifikate gelten drei Jahre mit jährlichen Überwachungsaudits.
siehe: ISMS, BSI

## BSI
aka: Bundesamt für Sicherheit in der Informationstechnik
kat: Management
kurz: Deutsche Bundesbehörde für Cybersicherheit, Herausgeber des IT-Grundschutzes.
Das BSI veröffentlicht die BSI-Standards 200-1 bis 200-4, das IT-Grundschutz-Kompendium, Lageberichte und Warnungen, betreibt das CERT-Bund und ist zuständig für KRITIS- und NIS2-Aufsicht in Deutschland.
siehe: ISMS, NIS2

## DSGVO
aka: GDPR, Datenschutz-Grundverordnung
kat: Recht
kurz: EU-Verordnung zum Schutz personenbezogener Daten.
Wichtig für Security: Art. 32 (Sicherheit der Verarbeitung), Art. 33 (Meldung von Datenpannen binnen 72 Stunden), Art. 25 (Privacy by Design). Bußgelder bis 20 Mio. € oder 4 % des weltweiten Jahresumsatzes.
siehe: NIS2

## NIS2
aka: NIS-2-Richtlinie
kat: Recht
kurz: EU-Richtlinie, die Cybersicherheitspflichten auf viele Unternehmen in 18 Sektoren ausweitet.
NIS2 verlangt Risikomanagementmaßnahmen, gestaffelte Meldepflichten (24 Stunden Frühwarnung, 72 Stunden Meldung, ein Monat Abschlussbericht) und nimmt die Geschäftsleitung in die Verantwortung.
siehe: DSGVO, BSI

## BCM
aka: Business Continuity Management
kat: Management
kurz: Management der Aufrechterhaltung kritischer Geschäftsprozesse in Krisen.
BCM umfasst Business Impact Analysis, Notfallpläne, Wiederanlaufpläne und Übungen. Kennzahlen: RTO (Wiederherstellungszeit), RPO (tolerierbarer Datenverlust), MTPD (maximal tolerierbare Ausfallzeit). Normen: BSI-Standard 200-4, ISO 22301.

## Zero Trust
aka: Zero-Trust-Architektur, ZTA
kat: Sicherheitsarchitektur
kurz: Sicherheitsmodell ohne implizites Vertrauen – jede Anfrage wird explizit geprüft.
„Never trust, always verify“: Identität, Gerätezustand und Kontext werden bei jedem Zugriff bewertet, Rechte minimal vergeben und man geht von einem Einbruch aus. Beschrieben in NIST SP 800-207.
siehe: Netzsegmentierung, MFA

## MITRE ATT&CK
aka: ATT&CK, MITRE ATTACK
kat: Blue Team
kurz: Frei verfügbare Wissensbasis über Taktiken und Techniken realer Angreifer.
ATT&CK ordnet Angreiferverhalten in Taktiken (das Ziel, z. B. Persistence) und Techniken (den Weg, z. B. T1053 Scheduled Task). Verteidiger nutzen es, um Erkennungslücken sichtbar zu machen, Threat Intelligence einzuordnen und Übungen zu planen.
siehe: APT, IOC

## IOC
aka: Indicator of Compromise, Kompromittierungsindikator
kat: Blue Team
kurz: Technisches Merkmal, das auf eine Kompromittierung hinweist – Hash, IP, Domain, Dateipfad.
IOCs stammen aus Vorfallanalysen und Threat Intelligence und werden in SIEM, EDR und Firewalls eingespielt. Sie veralten schnell; verhaltensbasierte Erkennung (TTPs) ist langlebiger.
siehe: MITRE ATT&CK

## SSID
aka: Service Set Identifier, WLAN-Name
kat: WLAN
kurz: Der Name eines WLANs, ausgestrahlt in Beacon-Frames.
Mehrere Access Points können dieselbe SSID nutzen (ESS); jeder hat eine eigene BSSID (MAC-Adresse). Das Verstecken der SSID ist kein wirksamer Schutz, da sie in Verbindungsanfragen sichtbar bleibt.
siehe: Evil Twin, WPA2

## WPA2
aka: Wi-Fi Protected Access 2, WPA2-PSK, WPA2-Enterprise
kat: WLAN
kurz: WLAN-Sicherheitsstandard mit AES-CCMP, als Personal (PSK) oder Enterprise (802.1X).
Bei WPA2-Personal hängt die Sicherheit vor allem an einer langen, zufälligen Passphrase, weil mitgeschnittene Handshakes offline geprüft werden können. Updates gegen Implementierungsfehler (z. B. KRACK) sind Pflicht. Nachfolger: WPA3.
siehe: WPA3, 802.1X

## WPA3
aka: Wi-Fi Protected Access 3, SAE
kat: WLAN
kurz: Aktueller WLAN-Sicherheitsstandard mit SAE-Handshake und verpflichtendem PMF.
WPA3-Personal ersetzt den PSK-Handshake durch SAE und verhindert Offline-Wörterbuchangriffe auf mitgeschnittene Handshakes. Protected Management Frames sind Pflicht, im 6-GHz-Band ist WPA3 vorgeschrieben.
siehe: WPA2

## 802.1X
aka: IEEE 802.1X, Port-basierte Zugangskontrolle
kat: WLAN
kurz: Standard für die Authentifizierung von Geräten an LAN- und WLAN-Ports über EAP und RADIUS.
Rollen: Supplicant (Client), Authenticator (Switch/AP), Authentication Server (RADIUS). Bis zur erfolgreichen Anmeldung wird nur EAP-Verkehr durchgelassen. Grundlage von WPA-Enterprise und kabelgebundener Netzwerkzugangskontrolle.
siehe: RADIUS, WPA3

## RADIUS
aka: Remote Authentication Dial-In User Service
kat: WLAN
kurz: Protokoll für zentrale Authentifizierung, Autorisierung und Abrechnung von Netzwerkzugängen.
RADIUS-Server (z. B. FreeRADIUS, Microsoft NPS) prüfen Anmeldungen bei 802.1X, VPN und Netzwerkgeräten und können Attribute wie das VLAN zurückgeben. Die Kommunikation zwischen Authenticator und Server wird mit einem gemeinsamen Geheimnis geschützt.
siehe: 802.1X

## Evil Twin
aka: Rogue Twin
kat: WLAN
kurz: Fremder Access Point, der die SSID eines legitimen Netzes imitiert, um Clients anzulocken.
Evil Twins zielen auf offene Netze, Gastnetze mit Anmeldeseiten und Enterprise-WLANs, deren Clients das Serverzertifikat nicht prüfen. Schutz: strikte Zertifikatsprüfung, WPA3/PMF, keine automatische Verbindung zu offenen Netzen, Wireless-IDS.
siehe: SSID, Man-in-the-Middle

## Zero-Day
aka: 0-Day
kat: Grundbegriffe
kurz: Schwachstelle, für die zum Zeitpunkt der Ausnutzung noch kein Patch existiert.
Der Hersteller hatte „null Tage“ Zeit zur Behebung. Gegen Zero-Days helfen keine Patches, sondern Defense in Depth: Segmentierung, Least Privilege, Härtung, verhaltensbasierte Erkennung und schnelle Reaktion.
siehe: Schwachstelle

## CVE
aka: Common Vulnerabilities and Exposures
kat: Grundbegriffe
kurz: Eindeutige Kennung für öffentlich bekannte Schwachstellen, z. B. CVE-2021-44228.
CVE-Nummern werden von CNAs vergeben und ermöglichen es, Schwachstellen eindeutig zu benennen. Bewertet werden sie meist mit CVSS; die CISA-KEV-Liste zeigt, welche aktiv ausgenutzt werden.
siehe: CVSS

## CVSS
aka: Common Vulnerability Scoring System
kat: Grundbegriffe
kurz: Standard zur Bewertung des Schweregrads von Schwachstellen auf einer Skala von 0.0 bis 10.0.
Stufen: Low (0.1–3.9), Medium (4.0–6.9), High (7.0–8.9), Critical (9.0–10.0). Die Basismetriken beschreiben Angriffsvektor, Komplexität, benötigte Rechte, Benutzerinteraktion und Auswirkungen. Für die Priorisierung zählen zusätzlich Exposition und aktive Ausnutzung.
siehe: CVE

## Defense in Depth
aka: Verteidigung in der Tiefe, mehrschichtige Verteidigung
kat: Sicherheitsarchitektur
kurz: Mehrere unabhängige Schutzschichten, damit ein einzelner Fehler nicht zum Totalschaden führt.
Beispiel: Firewall, Segmentierung, Härtung, EDR, MFA, Backups, Monitoring und geschulte Mitarbeitende greifen ineinander. Fällt eine Schicht aus, halten die anderen.
siehe: Zero Trust

## Least Privilege
aka: Prinzip der geringsten Rechte, minimale Rechte
kat: Sicherheitsarchitektur
kurz: Jede Person und jeder Prozess erhält nur die Rechte, die für die Aufgabe nötig sind.
Least Privilege begrenzt den Schaden kompromittierter Konten und erschwert Rechteausweitung. Umsetzung: rollenbasierte Rechte, getrennte Admin-Konten, Just-in-Time-Zugriff, regelmäßige Rezertifizierung.
siehe: Zero Trust

## Patch-Management
aka: Patchmanagement, Update-Management
kat: Betrieb
kurz: Geregelter Prozess, Sicherheitsupdates zu bewerten, zu testen und zeitnah einzuspielen.
Kritische, aktiv ausgenutzte Lücken brauchen kurze Fristen (Tage), andere werden im regulären Zyklus behoben. Voraussetzung ist ein vollständiges Inventar aller Systeme und Softwarestände.
siehe: CVE, Schwachstelle

## Ransomware
kat: Angriffsklassen
kurz: Schadsoftware, die Daten verschlüsselt und für die Entschlüsselung Lösegeld fordert.
Moderne Gruppen stehlen zusätzlich Daten und drohen mit Veröffentlichung (Double Extortion). Schutz: unveränderliche bzw. offline Backups, getestete Wiederherstellung, Segmentierung, MFA, schnelle Erkennung und ein geübter Notfallplan.
siehe: BCM

## Social Engineering
kat: Angriffsklassen
kurz: Manipulation von Menschen, damit sie Informationen preisgeben oder Handlungen ausführen.
Social Engineering nutzt Autorität, Dringlichkeit, Angst, Neugier und Hilfsbereitschaft. Formen: Phishing, Vishing, Pretexting, Baiting, Tailgating. Gegenmaßnahmen: Awareness, klare Prozesse (Rückruf über bekannte Nummer), technische Filter und eine positive Meldekultur.
siehe: Phishing

## OSINT
aka: Open Source Intelligence
kat: Offensive Sicherheit
kurz: Informationsgewinnung aus öffentlich zugänglichen Quellen.
Quellen: Websites, Suchmaschinen, soziale Netzwerke, DNS, Zertifikats-Logs, Handelsregister, Stellenanzeigen, Code-Repositories. OSINT ist passive Aufklärung ohne direkten Kontakt zum Ziel – und zeigt Unternehmen, was sie ungewollt preisgeben.

## SPF
aka: Sender Policy Framework, DKIM, DMARC
kat: Dienste
kurz: DNS-basierte Verfahren, mit denen Mailserver prüfen, ob eine Mail von einem berechtigten Absender stammt.
SPF listet erlaubte sendende Server, DKIM signiert Mails kryptografisch, DMARC legt fest, wie Empfänger mit Fehlschlägen umgehen, und liefert Berichte. Gemeinsam erschweren sie das Fälschen von Absenderdomänen.
siehe: Phishing, SMTP

## EAP
aka: Extensible Authentication Protocol, EAP-TLS, PEAP
kat: WLAN
kurz: Rahmenprotokoll für Authentifizierungsmethoden bei 802.1X.
Wichtige Methoden: EAP-TLS (Zertifikate auf beiden Seiten, sehr sicher), PEAP und EAP-TTLS (TLS-Tunnel mit Passwort-Anmeldung, sicher nur mit strikter Zertifikatsprüfung). Veraltet: LEAP, EAP-MD5.
siehe: 802.1X, RADIUS

## PMF
aka: Protected Management Frames, 802.11w, MFP
kat: WLAN
kurz: Schutz von WLAN-Management-Frames gegen Fälschung.
Ohne PMF lassen sich z. B. gefälschte Abmelde-Frames senden, die Clients trennen. Bei WPA3 ist PMF Pflicht, bei WPA2 optional und sollte aktiviert werden, wo die Geräte es unterstützen.
siehe: WPA3

## Wireless IDS
aka: WIDS, WIPS
kat: WLAN
kurz: System, das Funkverkehr überwacht und Rogue APs, Evil Twins und Protokollanomalien erkennt.
Sensoren (oft in Access Points integriert) werten Beacons, Probe- und Management-Frames aus. WIPS können zusätzlich Gegenmaßnahmen einleiten. Alarme gehören ins SIEM.
siehe: Evil Twin

## Tiering-Modell
aka: Tier-Modell, Enterprise Access Model
kat: Active Directory
kurz: Trennung administrativer Konten nach Schutzebenen: Tier 0 (Identität/DCs), Tier 1 (Server), Tier 2 (Clients).
Admin-Konten melden sich nur auf Systemen ihrer Ebene an. So landen hochprivilegierte Anmeldeinformationen nie auf weniger geschützten Rechnern, und die meisten Angriffspfade im Active Directory werden unterbrochen.
siehe: Active Directory, Least Privilege

## gMSA
aka: Group Managed Service Account
kat: Active Directory
kurz: Dienstkonto, dessen langes Passwort Active Directory automatisch verwaltet und rotiert.
gMSAs verhindern schwache, nie geänderte Dienstkonten-Passwörter – die Hauptursache für erfolgreiches Kerberoasting. Mehrere Server können dasselbe gMSA nutzen.
siehe: Kerberoasting

## LAPS
aka: Local Administrator Password Solution, Windows LAPS
kat: Active Directory
kurz: Microsoft-Lösung für eindeutige, automatisch rotierende lokale Administratorpasswörter pro Rechner.
LAPS speichert das Passwort geschützt im AD oder in Entra ID. Damit funktioniert ein erbeutetes lokales Admin-Passwort nicht mehr auf allen anderen Rechnern.
siehe: Tiering-Modell

## Threat Hunting
kat: Blue Team
kurz: Proaktive, hypothesengetriebene Suche nach Angreifern, die von Regeln nicht erkannt wurden.
Hunting geht von „Assume Breach“ aus, nutzt ATT&CK, Statistik und Erfahrung und mündet idealerweise in neue Erkennungsregeln.
siehe: MITRE ATT&CK, IOC

## Chain of Custody
aka: Beweismittelkette
kat: Forensik
kurz: Lückenlose Dokumentation, wer wann welches Beweismittel gesichert, übergeben und analysiert hat.
Ohne Chain of Custody sind Beweise vor Gericht angreifbar. Dazu gehören Hashwerte der Abbilder, Zeitstempel, Personen und Aufbewahrungsorte.
siehe: Order of Volatility

## Order of Volatility
aka: Reihenfolge der Flüchtigkeit
kat: Forensik
kurz: Grundsatz, flüchtige Daten zuerst zu sichern – Arbeitsspeicher vor Festplatte vor Backups.
Arbeitsspeicher, Netzwerkverbindungen und laufende Prozesse gehen beim Ausschalten verloren. Deshalb werden sie zuerst gesichert, danach Datenträger, Logs und Archive.
siehe: Chain of Custody
