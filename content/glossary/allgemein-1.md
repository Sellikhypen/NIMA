# NIMA-Lexikon: Allgemeine Grundbegriffe, Netzwerk, Web

## CIA-Triade
aka: Schutzziele, CIA-Triad
kat: Grundbegriffe
kurz: Die drei klassischen Schutzziele Vertraulichkeit, Integrität und Verfügbarkeit.
Fast jede Sicherheitsmaßnahme dient einem dieser Ziele. Ergänzt werden sie oft um Authentizität, Nichtabstreitbarkeit und Zurechenbarkeit.
siehe: Vertraulichkeit, Integrität, Verfügbarkeit

## Vertraulichkeit
aka: Confidentiality
kat: Grundbegriffe
kurz: Schutzziel: Nur Berechtigte können Informationen einsehen.
Verletzt wird sie z. B. durch Datenlecks, Mitlesen unverschlüsselter Verbindungen oder unberechtigte Zugriffe. Maßnahmen: Verschlüsselung, Zugriffskontrolle, Klassifizierung.
siehe: CIA-Triade

## Integrität
aka: Integrity
kat: Grundbegriffe
kurz: Schutzziel: Daten und Systeme werden nicht unbemerkt verändert.
Schutz bieten Hashes, digitale Signaturen, Zugriffskontrolle und Änderungsprotokolle.
siehe: CIA-Triade, Hashfunktion

## Verfügbarkeit
aka: Availability
kat: Grundbegriffe
kurz: Schutzziel: Systeme und Daten sind nutzbar, wenn sie gebraucht werden.
Bedroht durch Ausfälle, DDoS, Ransomware. Maßnahmen: Redundanz, Backups, Notfallplanung.
siehe: CIA-Triade, DDoS, BCM

## Authentizität
aka: Authenticity
kat: Grundbegriffe
kurz: Echtheit einer Person, eines Systems oder einer Nachricht ist nachgewiesen.
Wird über Authentifizierung, Zertifikate und Signaturen sichergestellt.

## Nichtabstreitbarkeit
aka: Non-Repudiation
kat: Grundbegriffe
kurz: Eine Handlung kann später nicht glaubhaft geleugnet werden.
Typisch umgesetzt mit digitalen Signaturen und manipulationssicheren Protokollen.

## Authentifizierung
aka: Authentication, AuthN
kat: Grundbegriffe
kurz: Nachweis der Identität – „Wer bist du?“.
Erfolgt über Wissen (Passwort), Besitz (Token, Smartphone) oder Biometrie. Mehrere Faktoren kombiniert ergeben MFA.
siehe: Autorisierung, MFA

## Autorisierung
aka: Authorization, AuthZ
kat: Grundbegriffe
kurz: Entscheidung, was eine authentifizierte Identität darf – „Was darfst du?“.
Viele Web-Schwachstellen (IDOR, BOLA) sind Autorisierungsfehler bei korrekt funktionierender Anmeldung.
siehe: Authentifizierung, IDOR

## Bedrohung
aka: Threat
kat: Grundbegriffe
kurz: Mögliche Ursache eines Schadens – etwa ein Angreifer, ein Fehler oder ein Naturereignis.
Erst wenn eine Bedrohung auf eine passende Schwachstelle trifft, entsteht ein Risiko.
siehe: Schwachstelle, Risiko

## Restrisiko
aka: Residual Risk
kat: Management
kurz: Das Risiko, das nach Umsetzung aller Maßnahmen verbleibt.
Es muss von der Leitung bewusst und dokumentiert akzeptiert werden.
siehe: Risiko

## Sicherheitsvorfall
aka: Security Incident, Vorfall
kat: Blue Team
kurz: Ereignis, das Schutzziele tatsächlich verletzt oder akut bedroht.
Nicht jeder Alarm und nicht jeder Angriffsversuch ist ein Vorfall; die Einstufung folgt festen Kriterien.
siehe: Incident Response

## Incident Response
aka: IR, Vorfallbehandlung
kat: Blue Team
kurz: Strukturierte Reaktion auf Sicherheitsvorfälle von der Erkennung bis zur Nachbereitung.
Typische Phasen: Vorbereitung, Erkennung, Eindämmung, Beseitigung, Wiederherstellung, Lessons Learned.
siehe: Playbook (IR), Lessons Learned

## Lessons Learned
aka: Post-Mortem, Nachbesprechung
kat: Blue Team
kurz: Nachbereitung eines Vorfalls oder einer Übung mit dem Ziel konkreter Verbesserungen.
Wirksam als „blameless“ Format ohne Schuldzuweisung, mit messbaren Maßnahmen.

## Virus
aka: Computervirus
kat: Bedrohungen
kurz: Schadprogramm, das sich an andere Dateien anhängt und sich mit ihnen verbreitet.
Benötigt einen Wirt und meist eine Nutzeraktion; heute seltener als Würmer und Trojaner.
siehe: Malware, Wurm

## Wurm
aka: Worm
kat: Bedrohungen
kurz: Schadprogramm, das sich selbstständig über Netzwerke verbreitet.
Nutzt Schwachstellen oder schwache Zugangsdaten; Beispiele für große Wurmausbrüche betrafen ungepatchte SMB-Dienste.
siehe: Malware, SMB

## Trojaner
aka: Trojanisches Pferd
kat: Bedrohungen
kurz: Schadprogramm, das sich als nützliche Software tarnt.
Wird vom Nutzer selbst installiert und öffnet dann z. B. eine Hintertür.
siehe: Malware, Backdoor

## Spyware
aka: Infostealer
kat: Bedrohungen
kurz: Schadsoftware, die Daten wie Passwörter, Cookies oder Krypto-Wallets ausspioniert.
Infostealer verkaufen erbeutete Sitzungen und Zugangsdaten oft an weitere Angreifer.
siehe: Malware

## Keylogger
kat: Bedrohungen
kurz: Programm oder Gerät, das Tastatureingaben aufzeichnet.
Gefährlich für Passwörter; MFA und Passkeys mindern die Folgen.

## Rootkit
kat: Bedrohungen
kurz: Schadsoftware, die sich und andere Malware tief im System versteckt.
Kernel-Rootkits manipulieren das Betriebssystem selbst; Erkennung oft nur von außen (Speicher- oder Offline-Analyse).
siehe: Malware

## Backdoor
aka: Hintertür
kat: Bedrohungen
kurz: Verdeckter Zugang, der normale Sicherheitsmechanismen umgeht.
Kann bewusst eingebaut oder von Angreifern installiert sein.

## RAT
aka: Remote Access Trojan
kat: Bedrohungen
kurz: Schadprogramm zur vollständigen Fernsteuerung eines Systems.
Bietet Dateizugriff, Bildschirmübertragung, Befehlsausführung – oft getarnt als legitime Software.
siehe: C2

## Botnetz
aka: Botnet
kat: Bedrohungen
kurz: Netz ferngesteuerter, infizierter Geräte.
Wird für DDoS, Spam, Credential Stuffing und als Infrastruktur für weitere Angriffe genutzt.
siehe: DDoS, C2

## DDoS
aka: Distributed Denial of Service, Überlastungsangriff
kat: Bedrohungen
kurz: Angriff, der einen Dienst durch massenhafte Anfragen aus vielen Quellen überlastet.
Varianten: volumetrisch, protokollbasiert, auf Anwendungsebene. Abwehr meist über spezialisierte Anbieter und Vorbereitung.
siehe: Verfügbarkeit

## Cryptominer
aka: Cryptojacking
kat: Bedrohungen
kurz: Schadsoftware, die fremde Rechenleistung zum Schürfen von Kryptowährungen nutzt.
Auffällig durch hohe CPU/GPU-Last und unerwartete Cloud-Kosten.

## Adware
kat: Bedrohungen
kurz: Software, die ungewollt Werbung einblendet und oft Daten sammelt.
Häufig Beifang bei kostenlosen Downloads; kann Einfallstor für weitere Malware sein.

## Living off the Land
aka: LotL, LOLBins
kat: Angriffsklassen
kurz: Angriffe mit vorhandenen Systemwerkzeugen statt eigener Schadsoftware.
Beispiele: PowerShell, WMI, certutil. Erkennung erfordert Verhaltensanalyse statt Dateisignaturen.
siehe: EDR

## Credential Stuffing
kat: Angriffsklassen
kurz: Automatisiertes Ausprobieren geleakter Zugangsdaten bei anderen Diensten.
Funktioniert wegen Passwort-Wiederverwendung; Abwehr: einzigartige Passwörter, MFA, Rate Limits.
siehe: Password Spraying

## Brute Force
aka: Brute-Force-Angriff
kat: Angriffsklassen
kurz: Systematisches Durchprobieren vieler Passwörter oder Schlüssel.
Online durch Sperren und Rate Limits begrenzbar; offline nur durch starke Passwörter und langsame Hashes.

## Spear Phishing
aka: Spear-Phishing
kat: Angriffsklassen
kurz: Zielgerichtetes Phishing mit recherchierten persönlichen Details.
Glaubwürdiger und gefährlicher als Massen-Phishing.
siehe: Phishing

## Vishing
kat: Angriffsklassen
kurz: Phishing per Telefonanruf.
Oft als angeblicher Support, Bank oder Vorgesetzter; zunehmend mit KI-Stimmen.
siehe: Social Engineering

## Smishing
kat: Angriffsklassen
kurz: Phishing per SMS oder Messenger.
Typisch: Paketbenachrichtigungen mit Link und kleiner „Gebühr“.

## Quishing
kat: Angriffsklassen
kurz: Phishing über QR-Codes.
Der Link steckt im Bild und umgeht so manche Link-Filter; oft auf Plakaten oder in E-Mails.

## Pretexting
kat: Angriffsklassen
kurz: Social Engineering mit einer erfundenen, glaubwürdigen Geschichte.
Beispiel: angeblicher IT-Support, der um einen MFA-Code bittet.
siehe: Social Engineering

## Tailgating
aka: Piggybacking
kat: Angriffsklassen
kurz: Unbefugtes Mitgehen durch eine gesicherte Tür hinter einer berechtigten Person.
Abwehr: Vereinzelungsanlagen und eine Kultur des freundlichen Nachfragens.

## Typosquatting
kat: Angriffsklassen
kurz: Registrieren ähnlich geschriebener Domains oder Paketnamen zur Täuschung.
Genutzt für Phishing und Lieferkettenangriffe in Paket-Registern.

## Watering Hole
aka: Watering-Hole-Angriff
kat: Angriffsklassen
kurz: Kompromittierung einer Webseite, die von der Zielgruppe häufig besucht wird.
Besucher werden dort mit Schadcode angegriffen.

## Drive-by-Download
kat: Angriffsklassen
kurz: Infektion allein durch den Besuch einer präparierten Webseite.
Nutzt Lücken in Browsern oder Plugins; schnelle Updates sind der wichtigste Schutz.

## MFA-Fatigue
aka: Push-Bombing, MFA-Bombing
kat: Angriffsklassen
kurz: Überfluten eines Nutzers mit MFA-Push-Anfragen, bis er entnervt zustimmt.
Abwehr: Zahlenabgleich, Begrenzung von Anfragen, phishing-resistente Verfahren.

## Adversary-in-the-Middle
aka: AiTM, AiTM-Phishing
kat: Angriffsklassen
kurz: Phishing über einen Proxy, der Anmeldung und MFA durchreicht und das Session-Cookie stiehlt.
Klassische MFA-Codes schützen nicht; Passkeys und Gerätebindung schon.
siehe: Passkey

## Passkey
aka: Passkeys
kat: Grundbegriffe
kurz: Phishing-resistente Anmeldung per Schlüsselpaar, gebunden an die echte Domain.
Basiert auf FIDO2/WebAuthn; der private Schlüssel verlässt das Gerät nicht.
siehe: FIDO2, WebAuthn

## FIDO2
kat: Grundbegriffe
kurz: Standardfamilie für passwortlose, phishing-resistente Anmeldung.
Besteht aus WebAuthn (Browser-API) und CTAP (Kommunikation mit Authentifikatoren).
siehe: Passkey, WebAuthn

## WebAuthn
kat: Web
kurz: Browser-Schnittstelle für Anmeldungen mit Public-Key-Kryptografie.
Bindet Anmeldungen an die Domain der Webseite.
siehe: FIDO2

## Passwortmanager
aka: Password Manager
kat: Grundbegriffe
kurz: Programm, das starke, einzigartige Passwörter erzeugt und verschlüsselt speichert.
Das Masterpasswort und idealerweise MFA schützen den Tresor.

## Single Sign-on
aka: SSO
kat: Grundbegriffe
kurz: Einmal anmelden, viele Anwendungen nutzen.
Umgesetzt mit SAML oder OIDC; erhöht Komfort und erlaubt zentrale MFA und Sperrung.
siehe: SAML, OIDC

## SAML
kat: Web
kurz: XML-basierter Standard für föderierte Anmeldung (SSO) zwischen Identitätsanbieter und Anwendung.
Fehler bei der Signaturprüfung von SAML-Antworten führten zu bekannten Anmeldeumgehungen.
siehe: Single Sign-on

## Patch
aka: Sicherheitsupdate, Update
kat: Betrieb
kurz: Softwareaktualisierung, die Fehler oder Sicherheitslücken behebt.
Nach Veröffentlichung ist die Lücke öffentlich bekannt – schnelles Einspielen ist entscheidend.
siehe: Patch-Management

## Backup
aka: Datensicherung
kat: Betrieb
kurz: Unabhängige Kopie von Daten zur Wiederherstellung.
Wirksam erst mit Offline-/Immutable-Kopie und regelmäßigen Wiederherstellungstests.
siehe: 3-2-1-Regel, Immutable Backup

## Immutable Backup
aka: unveränderliches Backup
kat: Betrieb
kurz: Sicherung, die für eine festgelegte Frist nicht verändert oder gelöscht werden kann.
Schützt gegen Angreifer, die gezielt Backups zerstören.
siehe: Backup, WORM-Speicher

## Inkrementelles Backup
kat: Betrieb
kurz: Sichert nur Änderungen seit der letzten Sicherung beliebiger Art.
Schnell und platzsparend, die Wiederherstellung braucht aber die ganze Kette.

## Differenzielles Backup
kat: Betrieb
kurz: Sichert alle Änderungen seit der letzten Vollsicherung.
Kompromiss zwischen Speicherbedarf und Wiederherstellungsaufwand.

## Snapshot (Speicher)
aka: Speicher-Snapshot
kat: Betrieb
kurz: Zeitpunktabbild eines Systems auf demselben Speicher.
Praktisch für schnelle Rücksprünge, aber kein vollwertiges Backup.
siehe: Backup

## Hochverfügbarkeit
aka: High Availability
kat: Betrieb
kurz: Auslegung eines Systems, um Ausfälle durch Redundanz zu überbrücken.
Typisch über Cluster, Lastverteilung und automatische Umschaltung.
siehe: HA

## Redundanz
kat: Betrieb
kurz: Mehrfach vorhandene Komponenten, damit der Ausfall einer einzelnen nicht zum Gesamtausfall führt.

## OSI-Modell
aka: OSI
kat: Netzwerk
kurz: Siebenschichtiges Referenzmodell für Netzwerkkommunikation.
Schichten: Bitübertragung, Sicherung, Vermittlung, Transport, Sitzung, Darstellung, Anwendung.
siehe: TCP/IP-Modell

## TCP/IP-Modell
kat: Netzwerk
kurz: Praxisnahes Vierschichtenmodell: Netzzugang, Internet, Transport, Anwendung.

## Kapselung
aka: Encapsulation
kat: Netzwerk
kurz: Jede Schicht verpackt die Daten der darüberliegenden mit einem eigenen Header.

## Drei-Wege-Handshake
aka: Three-Way-Handshake
kat: Netzwerk
kurz: TCP-Verbindungsaufbau mit SYN, SYN-ACK und ACK.
Portscanner nutzen ihn, z. B. beim SYN-Scan.
siehe: TCP

## Default Gateway
aka: Standardgateway
kat: Netzwerk
kurz: Router, an den ein Host Pakete für fremde Netze schickt.

## Broadcast
kat: Netzwerk
kurz: Nachricht an alle Teilnehmer eines Netzsegments.
Protokolle wie ARP, DHCP und NetBIOS nutzen Broadcasts.

## Multicast
kat: Netzwerk
kurz: Nachricht an eine Gruppe interessierter Empfänger.
IPv6 ersetzt viele Broadcasts durch Multicast.

## Loopback
aka: localhost
kat: Netzwerk
kurz: Virtuelle Schnittstelle des eigenen Rechners (127.0.0.1 bzw. ::1).
Dienste, die nur auf Loopback lauschen, sind von außen nicht direkt erreichbar.

## Private IP-Adresse
aka: RFC 1918
kat: Netzwerk
kurz: Adressbereiche für interne Netze: 10.0.0.0/8, 172.16.0.0/12, 192.168.0.0/16.
Sie werden im Internet nicht geroutet und per NAT übersetzt.
siehe: NAT

## Portweiterleitung
aka: Port Forwarding
kat: Netzwerk
kurz: Regel, die eingehende Verbindungen an einen Port eines internen Geräts weiterleitet.
Macht das Gerät aus dem Internet erreichbar – nur bewusst einsetzen.

## UPnP
aka: Universal Plug and Play
kat: Netzwerk
kurz: Protokoll, mit dem Geräte selbst Ports am Router öffnen können.
Bequem, aber riskant; im Zweifel deaktivieren.

## Proxy
aka: Forward Proxy
kat: Netzwerk
kurz: Stellvertreter, der Anfragen im Auftrag von Clients stellt.
Unternehmen nutzen Proxys für Filterung, Protokollierung und Malware-Schutz.
siehe: Reverse Proxy

## CDN
aka: Content Delivery Network
kat: Netzwerk
kurz: Verteiltes Netz von Servern, das Inhalte nahe beim Nutzer ausliefert.
Bietet oft auch DDoS-Schutz und WAF-Funktionen.

## Anycast
kat: Netzwerk
kurz: Dieselbe IP-Adresse wird an vielen Standorten angekündigt; Anfragen erreichen den nächstgelegenen.
Grundlage vieler DNS- und DDoS-Schutzdienste.

## QUIC
kat: Netzwerk
kurz: Transportprotokoll über UDP mit integriertem TLS 1.3, Basis von HTTP/3.
Schneller Verbindungsaufbau, aber für klassische Inspektion schwerer sichtbar.
siehe: HTTP/3

## HTTP/3
kat: Web
kurz: HTTP-Version über QUIC statt TCP.

## ALPN
kat: Web
kurz: TLS-Erweiterung zur Aushandlung des Anwendungsprotokolls, z. B. h2 für HTTP/2.

## DNSSEC
kat: Netzwerk
kurz: Erweiterung, die DNS-Antworten signiert und so ihre Echtheit prüfbar macht.
Schützt die Integrität, nicht die Vertraulichkeit.
siehe: DNS

## DNS over HTTPS
aka: DoH, DoT, DNS over TLS
kat: Netzwerk
kurz: Verschlüsselte DNS-Abfragen über HTTPS bzw. TLS.
Schützt vor Mitlesen, kann aber unternehmensinterne DNS-Filter umgehen.

## CAA-Record
aka: CAA
kat: Netzwerk
kurz: DNS-Eintrag, der festlegt, welche Zertifizierungsstellen Zertifikate für eine Domain ausstellen dürfen.

## PTR-Record
aka: Reverse DNS
kat: Netzwerk
kurz: DNS-Eintrag zur Rückwärtsauflösung von IP-Adresse zu Namen.

## MX-Record
kat: Netzwerk
kurz: DNS-Eintrag, der die Mailserver einer Domain angibt.

## TXT-Record
kat: Netzwerk
kurz: DNS-Eintrag für Text, u. a. für SPF, DKIM, DMARC und Domain-Verifizierungen.

## Wildcard-Zertifikat
kat: Kryptografie
kurz: Zertifikat für alle Subdomains einer Ebene, z. B. *.example.com.
Praktisch, aber ein gestohlener Schlüssel gefährdet alle abgedeckten Namen.

## Certificate Transparency
aka: CT
kat: Kryptografie
kurz: Öffentliche, manipulationssichere Logs aller ausgestellten TLS-Zertifikate.
Hilft, fehlerhaft ausgestellte Zertifikate zu erkennen – und verrät Subdomains.

## OCSP
aka: Online Certificate Status Protocol, OCSP-Stapling
kat: Kryptografie
kurz: Protokoll zur Abfrage, ob ein Zertifikat widerrufen wurde.
Beim Stapling liefert der Server die Antwort gleich mit.

## CRL
aka: Certificate Revocation List, Sperrliste
kat: Kryptografie
kurz: Von einer CA veröffentlichte Liste widerrufener Zertifikate.

## Forward Secrecy
aka: Perfect Forward Secrecy, PFS
kat: Kryptografie
kurz: Eigenschaft, dass ein später kompromittierter Schlüssel alte Sitzungen nicht entschlüsselt.
Erreicht durch kurzlebige Schlüssel im Schlüsselaustausch (z. B. ECDHE).

## Cipher Suite
kat: Kryptografie
kurz: Kombination aus Schlüsselaustausch, Verschlüsselung und Integritätsschutz in TLS.

## HTTP-Methode
aka: HTTP-Verb
kat: Web
kurz: Art einer HTTP-Anfrage, z. B. GET, POST, PUT, DELETE, OPTIONS.
GET sollte keine Daten verändern.

## HTTP-Statuscode
aka: Statuscode
kat: Web
kurz: Dreistellige Antwortkennung: 2xx Erfolg, 3xx Weiterleitung, 4xx Client-Fehler, 5xx Server-Fehler.

## Same-Origin-Policy
aka: SOP
kat: Web
kurz: Browserregel, nach der Skripte nur Antworten desselben Origins (Schema, Host, Port) lesen dürfen.
Grundlage der Websicherheit; CORS lockert sie gezielt.
siehe: CORS

## Origin
kat: Web
kurz: Kombination aus Schema, Host und Port einer Webadresse.

## CORS
aka: Cross-Origin Resource Sharing
kat: Web
kurz: Mechanismus, mit dem ein Server anderen Origins das Lesen seiner Antworten erlaubt.
Zu großzügige Konfiguration (reflektierter Origin mit Credentials) ist eine häufige Lücke.
siehe: Same-Origin-Policy

## SameSite
aka: SameSite-Cookie
kat: Web
kurz: Cookie-Attribut, das das Mitsenden bei Cross-Site-Anfragen steuert (Strict, Lax, None).
Wichtiger Baustein gegen CSRF.
siehe: Cookie, CSRF

## HttpOnly
kat: Web
kurz: Cookie-Attribut, das den Zugriff per JavaScript verhindert.
Schützt Sitzungscookies bei XSS vor dem Auslesen.

## DOM
aka: Document Object Model
kat: Web
kurz: Objektbaum, den der Browser aus HTML erzeugt und den JavaScript verändern kann.

## DOM-XSS
aka: DOM-based XSS
kat: Web
kurz: XSS, das vollständig im Browser entsteht, wenn nutzerkontrollierte Quellen in gefährliche Senken fließen.
siehe: XSS

## Stored XSS
aka: persistentes XSS
kat: Web
kurz: Eingeschleuster Code wird gespeichert und bei jedem Aufruf ausgeliefert.

## Reflected XSS
aka: reflektiertes XSS
kat: Web
kurz: Eingeschleuster Code steckt in der Anfrage und wird direkt in der Antwort zurückgegeben.

## Trusted Types
kat: Web
kurz: Browser-Mechanismus, der gefährliche DOM-Senken nur mit geprüften Werten erlaubt – Schutz gegen DOM-XSS.

## Subresource Integrity
aka: SRI
kat: Web
kurz: Hash-Prüfung für eingebundene Skripte und Stylesheets aus fremden Quellen.

## Web Cache Poisoning
aka: Cache Poisoning
kat: Web
kurz: Ablegen einer manipulierten Antwort in einem Cache, die dann an andere Nutzer ausgeliefert wird.
siehe: Cache-Key

## Cache-Key
kat: Web
kurz: Merkmale, anhand derer ein Cache entscheidet, ob zwei Anfragen gleich sind.

## Host-Header-Injection
aka: Host Header Poisoning
kat: Web
kurz: Missbrauch eines manipulierten Host-Headers, z. B. für falsche Links in Passwort-Reset-Mails.

## Session Fixation
kat: Web
kurz: Angreifer gibt dem Opfer eine Session-ID vor, die nach dem Login weiter gilt.
Abhilfe: nach Anmeldung neue Session-ID ausstellen.

## Session Hijacking
aka: Sitzungsübernahme
kat: Web
kurz: Übernahme einer aktiven Sitzung, meist durch Diebstahl des Session-Cookies oder Tokens.

## Rate Limiting
aka: Ratenbegrenzung
kat: Web
kurz: Begrenzung der Anzahl von Anfragen pro Zeitraum.
Schützt vor Brute Force, Missbrauch und Überlastung.

## Insecure Deserialization
aka: unsichere Deserialisierung
kat: Web
kurz: Verarbeitung manipulierter serialisierter Objekte, die zu Codeausführung führen kann.
Abhilfe: keine nativen Objektformate für fremde Daten.

## Gadget Chain
kat: Web
kurz: Verkettung vorhandener Klassen, die bei unsicherer Deserialisierung zu Codeausführung führt.

## NoSQL-Injection
kat: Web
kurz: Manipulation von NoSQL-Abfragen über Operatoren in Eingaben, z. B. {"$ne": null}.

## LDAP-Injection
kat: Web
kurz: Manipulation von LDAP-Suchfiltern über ungeprüfte Eingaben.

## ReDoS
aka: Regular Expression Denial of Service
kat: Web
kurz: Überlastung durch reguläre Ausdrücke mit katastrophalem Backtracking.

## Path Normalization
aka: Pfadnormalisierung
kat: Web
kurz: Vereinheitlichung von Pfaden vor der Prüfung, um Umgehungen mit ../ oder Kodierungen zu verhindern.

## Webshell-Erkennung
kat: Blue Team
kurz: Erkennung von Skripten auf Webservern, die Befehle ausführen – etwa über Prozessketten und Dateiintegritätsüberwachung.
siehe: Webshell

## API-Gateway
kat: Web
kurz: Zentrale Komponente vor APIs für Authentifizierung, Rate Limits, Routing und Protokollierung.

## OpenAPI
aka: Swagger
kat: Web
kurz: Standardformat zur Beschreibung von REST-APIs.
Hilft Tests, Dokumentation und Scannern, alle Endpunkte zu kennen.

## BOLA
aka: Broken Object Level Authorization
kat: Web
kurz: API-Schwachstelle, bei der Nutzer auf fremde Objekte zugreifen können.
API-Gegenstück zu IDOR.
siehe: IDOR

## BFLA
aka: Broken Function Level Authorization
kat: Web
kurz: API-Schwachstelle, bei der Nutzer Funktionen höherer Rollen aufrufen können.

## Webhook-Sicherheit
kat: Web
kurz: Absicherung eingehender Webhooks durch Signaturprüfung, Zeitstempel und Allowlists.
siehe: Webhook

## Backend-for-Frontend
aka: BFF
kat: Web
kurz: Architekturmuster, bei dem ein Backend OAuth-Tokens hält und der Browser nur ein Session-Cookie bekommt.

## Refresh Token
kat: Web
kurz: Langlebiges Token, mit dem neue Access Tokens angefordert werden.
Muss besonders geschützt und widerrufbar sein.

## Access Token
kat: Web
kurz: Kurzlebiger Berechtigungsnachweis für den Zugriff auf eine API.

## Scope (OAuth)
kat: Web
kurz: Umfang der Berechtigungen, die ein OAuth-Token gewährt.

## Redirect URI
kat: Web
kurz: Adresse, an die ein OAuth-Identitätsanbieter nach der Anmeldung zurückleitet; muss exakt geprüft werden.
