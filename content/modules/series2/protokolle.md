---
id: np-01
title: Protokolle 1 · SMB im Detail
paths: cpts, cjca, cdsa, grundlagen
order: 4.2
difficulty: medium
icon: externaldrive.connected.to.line.below.fill
tags: protokolle, smb, windows
summary: Wie Windows-Dateifreigaben funktionieren – Versionen, Freigaben, Authentifizierung, Signing, Verschlüsselung und typische Risiken.
---

## Einfach erklärt

SMB (Server Message Block) ist die Sprache, mit der Windows-Rechner Dateien und Drucker teilen. Wenn du `\\server\projekte` öffnest, spricht dein Rechner SMB. Weil fast jedes Windows-Netz SMB nutzt, ist es auch ein beliebtes Ziel – von Ransomware-Würmern bis zum Abgreifen von Anmeldedaten.

## Versionen

| Version | Wichtig |
|---|---|
| SMBv1 | veraltet, unsicher (z. B. EternalBlue/WannaCry) – **deaktivieren** |
| SMBv2/2.1 | modernisiert, effizienter |
| SMBv3.x | Verschlüsselung, Signing mit AES, Pre-Auth-Integrity |

Ports: **445/TCP** (direkt), historisch 139/TCP über NetBIOS.

## Freigaben und Rechte

- Standard-Administratorfreigaben: `C$`, `ADMIN$`, `IPC$`.
- Zwei Rechteebenen: **Freigaberechte** und **NTFS-Rechte** – es gilt die strengere Kombination.
- Häufiges Problem: Freigaben mit „Jeder: Vollzugriff“ und darin Skripte, Backups oder Passwortlisten.

> [!WARNUNG] SYSVOL und NETLOGON lesen alle
> Jeder Domänennutzer kann diese Freigaben lesen. Skripte oder alte GPP-Dateien (Group Policy Preferences) mit Passwörtern darin sind für alle sichtbar.

## Authentifizierung und Schutz

- Anmeldung per Kerberos (bevorzugt) oder NTLM.
- **SMB-Signing** schützt Integrität und verhindert Relay.
- **SMB-Verschlüsselung** (ab v3) schützt Vertraulichkeit.
- Gast- und anonymer Zugriff (Null Session) sollte deaktiviert sein.

## Tiefer eingetaucht

Erkennung und Härtung:

- Eingehendes SMB von Arbeitsplatz zu Arbeitsplatz per Host-Firewall blockieren – stoppt viel Lateral Movement und Wurmverbreitung.
- Ausgehendes SMB (445) ins Internet blockieren – sonst können Links auf `\\angreifer\x` Hashes abfließen lassen.
- Zugriffe auf Freigaben protokollieren (Event 5140/5145), besonders `ADMIN$` und `C$`.
- Regelmäßig nach offenen Freigaben mit sensiblen Dateien suchen (z. B. mit Werkzeugen, die Freigaben inventarisieren).
- Seit Windows 11 24H2/Server 2025 ist Signing standardmäßig strenger – ein gutes Zeichen, aber ältere Systeme bleiben zu prüfen.

## Quiz

? Welcher Port wird von modernem SMB direkt genutzt?
= 445
! 139 wird nur für SMB über NetBIOS verwendet.

? Welche SMB-Version sollte deaktiviert werden?
= SMBv1
= v1
! SMBv1 war Grundlage für WannaCry und NotPetya.

? Welche Rechte gelten bei SMB-Freigaben?
+ die strengere Kombination aus Freigabe- und NTFS-Rechten
- nur die Freigaberechte
- nur die NTFS-Rechte
- immer Vollzugriff für Admins im Netzwerk
! Beide Ebenen werden geprüft; die restriktivere gewinnt.

?tf Alle Domänennutzer können die Freigabe SYSVOL lesen.
= wahr
! Deshalb dürfen dort keine Passwörter liegen.

? Welche Maßnahme verhindert NTLM-Relay auf SMB?
= SMB-Signing
= Signing
! Signierte Sitzungen sind an den Sitzungsschlüssel gebunden.

? Welche Event-ID protokolliert detaillierte Zugriffe auf Freigabe-Objekte?
= 5145
! 5140 protokolliert den Zugriff auf eine Freigabe an sich.

? Warum sollte ausgehendes SMB ins Internet blockiert werden?
+ damit Anmeldedaten-Hashes nicht an fremde Server abfließen
- weil SMB sonst langsamer wird
- weil Updates SMB nutzen
- weil Drucker nicht funktionieren
! Ein Link auf eine externe Freigabe kann eine automatische Anmeldung auslösen.

@@@ MODULE @@@
---
id: np-02
title: Protokolle 2 · LDAP – das Verzeichnisprotokoll
paths: cpts, cape, cdsa, specialist
order: 4.3
difficulty: medium
icon: list.bullet.indent
tags: protokolle, ldap, active directory
summary: Wie LDAP Verzeichnisse abfragt, wie Filter aufgebaut sind, warum LDAP-Signing und LDAPS wichtig sind und was LDAP-Injection bedeutet.
---

## Einfach erklärt

LDAP (Lightweight Directory Access Protocol) ist die Abfragesprache für Verzeichnisse wie Active Directory – wie SQL für Datenbanken. Fragt ein Programm „Welche Gruppen hat Anna?“ oder „Gib mir alle deaktivierten Konten“, spricht es LDAP.

## Grundlagen

| Begriff | Bedeutung |
|---|---|
| DN | Distinguished Name, eindeutiger Pfad: `CN=Anna,OU=IT,DC=firma,DC=local` |
| Base DN | Startpunkt der Suche |
| Scope | base, one level, subtree |
| Filter | Suchbedingung |
| Bind | Anmeldung (anonym, einfach, SASL/Kerberos) |

Ports: **389** (LDAP, ggf. mit StartTLS), **636** (LDAPS), **3268/3269** (Global Catalog).

## Filter lesen

```text
(&(objectClass=user)(memberOf=CN=Admins,OU=Gruppen,DC=firma,DC=local))
(|(sAMAccountName=anna)(mail=anna@firma.de))
(&(objectCategory=person)(userAccountControl:1.2.840.113556.1.4.803:=2))
```

`&` = und, `|` = oder, `!` = nicht. Der letzte Filter findet deaktivierte Konten über ein Bit in `userAccountControl`.

## Sicherheit

- **Simple Bind** über unverschlüsseltes LDAP überträgt Passwörter im Klartext → nur über TLS.
- **LDAP-Signing** und **Channel Binding** erzwingen → schützt gegen Relay und Manipulation.
- Anonyme Binds deaktivieren.
- Dienstkonten für LDAP-Abfragen (z. B. für Webanwendungen) minimal berechtigen.

> [!MERKE] Jeder Domänennutzer darf viel lesen
> Standardmäßig kann jedes authentifizierte Konto große Teile des AD per LDAP auslesen – darauf beruhen viele Aufklärungswerkzeuge. Sensible Infos gehören nicht in Beschreibungsfelder.

## Tiefer eingetaucht

**LDAP-Injection** entsteht, wenn Anwendungen Nutzereingaben ungeprüft in Filter einsetzen: Aus `(uid=EINGABE)` wird mit der Eingabe `*)(uid=*` ein Filter, der alle Nutzer trifft. Abhilfe: Sonderzeichen (`* ( ) \ NUL`) gemäß RFC 4515 escapen, parametrisierte Bibliotheksfunktionen nutzen.

Erkennung im AD: Ungewöhnlich große oder viele LDAP-Abfragen eines Clients (z. B. alle Objekte mit allen Attributen) können auf Aufklärung hindeuten. Event 1644 (bei aktivierter Diagnose) protokolliert teure LDAP-Suchen; Microsoft Defender for Identity erkennt typische Aufklärungsmuster.

## Quiz

? Welcher Port wird für LDAPS verwendet?
= 636
! 389 ist LDAP (optional mit StartTLS).

? Was bedeutet `&` in einem LDAP-Filter?
+ UND
- ODER
- NICHT
- Platzhalter
! | = ODER, ! = NICHT.

? Welche Ports gehören zum Global Catalog?
+ 3268
+ 3269
- 53
- 88
! 3269 ist die TLS-Variante.

?tf Ein Simple Bind über unverschlüsseltes LDAP überträgt das Passwort im Klartext.
= wahr
! Deshalb nur über LDAPS oder StartTLS.

? Welche Maßnahmen schützen LDAP gegen Relay?
+ LDAP-Signing
+ Channel Binding
- längere Benutzernamen
- anonymer Bind
! Beide binden die Sitzung kryptografisch.

? Wie heißt der Angriff, bei dem Eingaben einen LDAP-Filter verändern?
= LDAP-Injection
= LDAP Injection
! Sonderzeichen müssen escaped werden.

? Wofür steht DN?
= Distinguished Name
! Der eindeutige Pfad eines Objekts im Verzeichnis.

@@@ MODULE @@@
---
id: np-03
title: Protokolle 3 · SSH sicher nutzen und härten
paths: grundlagen, cpts, specialist
order: 4.4
difficulty: medium
icon: lock.rectangle.stack.fill
tags: protokolle, ssh, linux, härtung
summary: Wie SSH Verbindungen absichert, warum Schlüssel besser als Passwörter sind, was Host-Keys bedeuten und wie man sshd härtet.
---

## Einfach erklärt

SSH ist ein verschlüsselter Tunnel zu einem anderen Rechner – das Standardwerkzeug für Linux-Administration. Zwei Fragen müssen beantwortet werden:

1. **Ist der Server der richtige?** → Host-Key (Fingerabdruck beim ersten Verbinden).
2. **Bin ich berechtigt?** → Passwort oder besser **Schlüsselpaar**.

## Schlüsselbasierte Anmeldung

```bash
ssh-keygen -t ed25519 -C "anna@laptop"
ssh-copy-id anna@server
ssh anna@server
```

Der **private Schlüssel** bleibt auf deinem Rechner (mit Passphrase!), der **öffentliche** kommt in `~/.ssh/authorized_keys` auf dem Server.

> [!WARNUNG] Host-Key-Warnung ernst nehmen
> „REMOTE HOST IDENTIFICATION HAS CHANGED“ kann eine Neuinstallation bedeuten – oder einen Man-in-the-Middle. Erst klären, dann verbinden.

## sshd härten

| Einstellung | Empfehlung |
|---|---|
| `PermitRootLogin` | `no` (oder `prohibit-password`) |
| `PasswordAuthentication` | `no` (nur Schlüssel) |
| `PubkeyAuthentication` | `yes` |
| `AllowUsers` / `AllowGroups` | nur berechtigte Konten |
| `MaxAuthTries` | niedrig, z. B. 3 |
| `X11Forwarding` | `no`, wenn nicht benötigt |
| `AllowTcpForwarding` | nur bei Bedarf |
| Kryptografie | moderne Algorithmen (ed25519, curve25519, chacha20/aes-gcm) |

Zusätzlich: SSH nicht direkt ins Internet, sondern über VPN/Bastion; Fail2ban oder ähnliche Rate-Limits; Logs überwachen.

## Tiefer eingetaucht

SSH kann **Ports weiterleiten** (`-L` lokal, `-R` remote, `-D` dynamischer SOCKS-Proxy). Für Admins praktisch, für Angreifer ein Tunnel durch Firewalls – darum Forwarding auf Servern einschränken und ungewöhnliche Weiterleitungen überwachen.

Für größere Umgebungen: **SSH-Zertifikate** (eine CA signiert Nutzer- und Host-Schlüssel mit Ablaufdatum) statt verstreuter `authorized_keys`, oder zentrale Zugriffslösungen mit kurzlebigen Credentials und Sitzungsaufzeichnung. `authorized_keys` regelmäßig prüfen – ein unbekannter Schlüssel dort ist eine klassische Hintertür.

## Quiz

? Welcher Schlüsseltyp wird für neue SSH-Schlüssel empfohlen?
= ed25519
! Schnell, sicher, kurze Schlüssel.

? In welcher Datei stehen erlaubte öffentliche Schlüssel eines Nutzers?
= ~/.ssh/authorized_keys
= authorized_keys
! Ein fremder Eintrag dort ist eine Hintertür.

? Welche sshd-Einstellung verbietet die Passwortanmeldung?
= PasswordAuthentication no
! Dann sind nur noch Schlüssel (oder andere starke Methoden) erlaubt.

?tf Eine Host-Key-Warnung beim Verbinden kann auf einen Man-in-the-Middle hindeuten.
= wahr
! Immer die Ursache klären, bevor man den neuen Schlüssel akzeptiert.

? Welche SSH-Option erstellt einen dynamischen SOCKS-Proxy?
= -D
! -L = lokale, -R = entfernte Portweiterleitung.

? Was ist der Vorteil von SSH-Zertifikaten gegenüber authorized_keys?
+ zentral signiert, mit Ablaufdatum und leichter widerrufbar
- sie brauchen keine Kryptografie
- sie funktionieren ohne Server
- sie sind kürzer als Passwörter
! Verstreute Einzelschlüssel sind schwer zu verwalten.

? Welche Einstellung sollte root-Logins verbieten?
= PermitRootLogin no
! Admins melden sich persönlich an und nutzen sudo.

@@@ MODULE @@@
---
id: np-04
title: Protokolle 4 · RDP und Fernwartung absichern
paths: cpts, cdsa, specialist
order: 4.5
difficulty: medium
icon: display.2
tags: protokolle, rdp, fernzugriff
summary: Wie RDP funktioniert, warum offenes RDP im Internet ein Hauptweg für Ransomware ist und wie NLA, Gateways, MFA und Überwachung schützen.
---

## Einfach erklärt

Mit RDP (Remote Desktop Protocol) sitzt man vor einem entfernten Windows-Bildschirm, als wäre man da. Steht RDP offen im Internet, probieren automatisierte Werkzeuge rund um die Uhr Passwörter durch. **Offenes RDP ist einer der häufigsten Einstiegspunkte für Ransomware.**

## Grundlagen

- Port **3389/TCP** (und UDP für bessere Leistung).
- **NLA** (Network Level Authentication): Anmeldung vor dem Aufbau der vollständigen Sitzung – reduziert Angriffsfläche.
- Verschlüsselung per TLS; Zertifikat sollte vertrauenswürdig sein.

## Sicher bereitstellen

1. **Nie direkt ins Internet**, sondern über VPN oder **RD Gateway** (HTTPS) mit MFA.
2. NLA erzwingen.
3. Nur berechtigte Gruppen in „Remote Desktop Users“.
4. Kontosperr- und Rate-Limit-Richtlinien.
5. **Restricted Admin** bzw. **Remote Credential Guard** für Admins – Anmeldedaten bleiben nicht auf dem Zielsystem.
6. Zwischenablage- und Laufwerksumleitung einschränken, wo sinnvoll.

> [!GEFAHR] Fernwartungs-Tools sind auch Angreifer-Tools
> Kommerzielle Fernwartung (AnyDesk, TeamViewer, ScreenConnect usw.) wird von Angreifern gern installiert, weil sie legitim aussieht. Erlaubte Tools festlegen, andere blockieren und Installationen überwachen.

## Tiefer eingetaucht

Spuren in den Logs:

| Log | Event | Bedeutung |
|---|---|---|
| Security | 4624 Type 10 | RDP-Anmeldung |
| Security | 4625 | fehlgeschlagene Anmeldung (Brute Force) |
| RemoteConnectionManager | 1149 | Netzwerkanmeldung am RDP-Dienst erfolgreich |
| LocalSessionManager | 21, 24, 25 | Sitzung angemeldet, getrennt, wiederverbunden |

Auf dem Client hinterlässt RDP Spuren: zuletzt verbundene Server in der Registry (`Terminal Server Client\Servers`), der **Bitmap-Cache** mit Bildschirmkacheln – für Forensiker manchmal ein Fenster in die Sitzung des Angreifers.

BlueKeep (CVE-2019-0708) zeigte, dass auch das Protokoll selbst angreifbar sein kann – Patchen und NLA sind daher Pflicht.

## Quiz

? Welcher Port wird standardmäßig für RDP verwendet?
= 3389
! Ein Portwechsel schützt kaum – Scanner finden RDP auch auf anderen Ports.

? Wofür steht NLA?
= Network Level Authentication
! Die Anmeldung erfolgt vor dem Aufbau der vollständigen Sitzung.

? Wie sollte RDP von außen bereitgestellt werden?
+ über VPN oder RD Gateway mit MFA
- direkt auf Port 3389 ins Internet
- auf Port 80 ohne Passwort
- nur mit langem Benutzernamen
! Nie direkt exponieren.

?tf Kommerzielle Fernwartungssoftware wird auch von Angreifern zur Tarnung genutzt.
= wahr
! Deshalb nur freigegebene Tools erlauben.

? Welche Funktion verhindert, dass Admin-Anmeldedaten auf dem RDP-Zielsystem zurückbleiben?
= Remote Credential Guard
= Restricted Admin
! Beide reduzieren das Risiko von Credential-Diebstahl auf dem Ziel.

? Welche Event-ID im Log RemoteConnectionManager zeigt eine erfolgreiche Netzwerkanmeldung am RDP-Dienst?
= 1149
! Hilfreich, auch wenn Security-Logs fehlen.

? Welche RDP-Schwachstelle von 2019 war wurmfähig?
= BlueKeep
! CVE-2019-0708.

@@@ MODULE @@@
---
id: np-05
title: Protokolle 5 · DNS vertieft – Zonen, DNSSEC, DoH und Angriffe
paths: grundlagen, cwes, cdsa, specialist
order: 5.2
difficulty: medium
icon: signpost.right.and.left.fill
tags: protokolle, dns
summary: Wie DNS-Zonen, Record-Typen und Resolver zusammenspielen, was DNSSEC und verschlüsseltes DNS leisten und welche Angriffe es gibt.
---

## Einfach erklärt

DNS ist das Telefonbuch des Internets – aber verteilt auf Millionen Server. Niemand hat das ganze Buch: Root-Server wissen, wer für `.de` zuständig ist, die `.de`-Server wissen, wer für `firma.de` zuständig ist, und erst dieser **autoritative** Server kennt `www.firma.de`.

## Record-Typen

| Typ | Inhalt |
|---|---|
| A / AAAA | IPv4 / IPv6-Adresse |
| CNAME | Alias auf einen anderen Namen |
| MX | Mailserver |
| TXT | Text – u. a. SPF, DKIM, DMARC, Domain-Verifizierung |
| NS | zuständige Nameserver |
| SOA | Zonen-Stammdaten |
| PTR | Rückwärtsauflösung (IP → Name) |
| SRV | Dienste (z. B. `_ldap._tcp` im AD) |
| CAA | welche CAs Zertifikate ausstellen dürfen |

## Resolver und Caching

Ein **rekursiver Resolver** (z. B. der des Providers oder der Firma) erledigt die Suche und **cacht** Antworten für die Dauer der **TTL**. Caching macht DNS schnell – und Cache-Poisoning gefährlich.

## Sicherheit

- **DNSSEC** signiert Antworten; Resolver können prüfen, dass sie echt sind (Integrität, keine Vertraulichkeit).
- **DoT/DoH** (DNS over TLS/HTTPS) verschlüsseln den Weg zum Resolver (Vertraulichkeit).
- **Zonentransfer (AXFR)** nur zu berechtigten sekundären Servern erlauben – sonst verrät er die ganze Zone.
- **CAA-Records** begrenzen, wer Zertifikate für die Domain ausstellen darf.

> [!MERKE] Integrität vs. Vertraulichkeit
> DNSSEC: Ist die Antwort echt? DoH/DoT: Kann jemand mitlesen? Zwei verschiedene Schutzziele.

## Tiefer eingetaucht

Angriffe und Missbrauch:

- **Cache Poisoning** – gefälschte Antworten im Resolver-Cache (Kaminsky-Angriff); Gegenmittel: zufällige Quellports, DNSSEC-Validierung.
- **Domain Hijacking** – Übernahme des Registrar-Kontos → Registrar-Lock und MFA.
- **Typosquatting** – ähnliche Domains für Phishing.
- **DNS-Tunneling** – Daten in Abfragen schmuggeln.
- **DNS-Amplification** – offene Resolver als DDoS-Verstärker → keine offenen Resolver betreiben.
- **Dangling CNAMEs** – Subdomain-Takeover.

Für Unternehmen: DoH der Browser kann interne DNS-Sicherheitsfilter umgehen – deshalb DoH zentral steuern bzw. auf eigene Resolver lenken.

## Quiz

? Welcher Record-Typ enthält den Mailserver einer Domain?
= MX
! Mail Exchanger.

? Welcher Record legt fest, welche CAs Zertifikate ausstellen dürfen?
= CAA
! Certification Authority Authorization.

? Was schützt DNSSEC?
+ die Echtheit und Integrität von DNS-Antworten
- die Vertraulichkeit der Abfragen
- vor DDoS-Angriffen
- vor Phishing-Mails
! DNSSEC verschlüsselt nicht.

? Was ist ein Zonentransfer (AXFR)?
+ die Übertragung einer kompletten DNS-Zone an einen anderen Server
- ein Domainumzug zu einem neuen Registrar
- ein DNS-Cache-Leeren
- eine verschlüsselte Abfrage
! Unbeschränkt erlaubt, verrät er alle Einträge.

?tf DNS over HTTPS kann interne DNS-Sicherheitsfilter umgehen.
= wahr
! Browser senden Anfragen dann direkt an externe Resolver.

? Wie lange darf ein Resolver eine Antwort im Cache halten?
+ für die Dauer der TTL
- für immer
- genau eine Sekunde
- bis zum Neustart des Clients
! Time to Live.

? Welcher Record-Typ dient der Rückwärtsauflösung?
= PTR
! Von der IP-Adresse zum Namen.

@@@ MODULE @@@
---
id: np-06
title: Protokolle 6 · E-Mail-Authentifizierung – SPF, DKIM, DMARC, ARC, BIMI
paths: specialist, cdsa, grundlagen
order: 15.5
difficulty: medium
icon: envelope.badge.fill
tags: protokolle, e-mail, dmarc
summary: Wie SPF, DKIM und DMARC zusammenarbeiten, wie man DMARC schrittweise auf reject bringt und was Alignment bedeutet.
---

## Einfach erklärt

E-Mail wurde ohne Absenderprüfung erfunden – jeder kann „Von: chef@firma.de“ schreiben. Drei Verfahren reparieren das nachträglich:

- **SPF**: Die Domain veröffentlicht, **welche Server** in ihrem Namen senden dürfen.
- **DKIM**: Der Absenderserver **signiert** die Mail; der Empfänger prüft die Signatur mit einem öffentlichen Schlüssel aus dem DNS.
- **DMARC**: Die Domain sagt, **was passieren soll**, wenn SPF/DKIM nicht passen – und will Berichte darüber.

## Beispiele

```text
firma.de.            TXT "v=spf1 include:_spf.mailprovider.example -all"
sel1._domainkey      TXT "v=DKIM1; k=rsa; p=MIIBIjANBg..."
_dmarc.firma.de.     TXT "v=DMARC1; p=reject; rua=mailto:dmarc@firma.de; adkim=s; aspf=s"
```

## Alignment – der entscheidende Punkt

SPF prüft den Umschlag-Absender (Return-Path), DKIM die signierende Domain. Der Nutzer sieht aber die **From-Adresse**. DMARC verlangt, dass mindestens eine der geprüften Domains zur From-Domain **passt** (Alignment). Erst das schützt gegen sichtbare Absenderfälschung.

| DMARC-Policy | Wirkung |
|---|---|
| `p=none` | nur beobachten, Berichte sammeln |
| `p=quarantine` | in den Spam |
| `p=reject` | abweisen |

> [!TIPP] Schrittweise einführen
> Mit `p=none` beginnen, Berichte (rua) auswerten, alle legitimen Absender (CRM, Newsletter, Ticketsystem) korrekt einrichten, dann `quarantine` und schließlich `reject`.

## Tiefer eingetaucht

- SPF hat ein Limit von **10 DNS-Lookups** – zu viele `include:` brechen SPF.
- `~all` (Softfail) vs. `-all` (Fail): Mit DMARC ist der Unterschied geringer, `-all` ist klarer.
- **ARC** erhält Authentifizierungsergebnisse über Weiterleitungen und Mailinglisten hinweg.
- **BIMI** zeigt das Logo der Marke an, wenn DMARC auf `quarantine`/`reject` steht.
- Auch **nicht sendende Domains** brauchen Schutz: `v=spf1 -all` und `p=reject`, damit sie nicht für Phishing missbraucht werden.
- Seit 2024 verlangen große Mailanbieter von Massenversendern SPF, DKIM und DMARC.

DMARC schützt nicht vor **ähnlichen** Domains (`firma-de.com`) – dagegen helfen Markenüberwachung und Nutzerschulung.

## Quiz

? Was legt SPF fest?
+ welche Server im Namen der Domain senden dürfen
- wie Mails verschlüsselt werden
- die Größe von Anhängen
- welche Empfänger erlaubt sind
! SPF ist eine Liste autorisierter Absenderserver.

? Was macht DKIM?
+ signiert E-Mails kryptografisch
- blockiert Spam anhand von Wörtern
- verschlüsselt den Anhang
- prüft Rechtschreibung
! Der öffentliche Schlüssel liegt im DNS.

? Welche DMARC-Policy weist nicht passende Mails ab?
= reject
= p=reject
! none beobachtet nur, quarantine verschiebt in den Spam.

? Was bedeutet Alignment bei DMARC?
+ die geprüfte Domain passt zur sichtbaren From-Domain
- SPF und DKIM haben dieselbe Länge
- alle Mails sind gleich formatiert
- der Mailserver steht im selben Land
! Nur so schützt DMARC gegen sichtbare Fälschung.

? Wie viele DNS-Lookups erlaubt SPF höchstens?
= 10
! Zu viele include-Einträge führen zu einem permerror.

?tf Domains, die keine E-Mails versenden, brauchen keine SPF- und DMARC-Einträge.
= falsch
! Gerade sie werden sonst für Phishing missbraucht.

? Welches Verfahren erhält Authentifizierungsergebnisse über Weiterleitungen hinweg?
= ARC
= Authenticated Received Chain
! Wichtig für Mailinglisten und Weiterleitungen.

@@@ MODULE @@@
---
id: np-07
title: Protokolle 7 · VPN-Protokolle – IPsec, WireGuard, OpenVPN, SSL-VPN
paths: grundlagen, specialist, cyberrange
order: 13.5
difficulty: medium
icon: network.badge.shield.half.filled
tags: protokolle, vpn
summary: Wie die gängigen VPN-Verfahren funktionieren, worin sie sich unterscheiden und warum VPN-Gateways zu den meistangegriffenen Systemen gehören.
---

## Einfach erklärt

Ein VPN baut einen verschlüsselten Tunnel durch ein unsicheres Netz – wie eine private, blickdichte Röhre durch die öffentliche Straße. Zwei Einsatzarten:

- **Site-to-Site**: zwei Standorte dauerhaft verbinden.
- **Remote Access**: einzelne Nutzer von unterwegs ins Firmennetz.

## Die Verfahren

| Verfahren | Merkmale |
|---|---|
| IPsec (IKEv2) | Standard für Site-to-Site, im Betriebssystem integriert, komplexe Konfiguration (Phasen, Proposals) |
| WireGuard | sehr schlank, moderne feste Kryptografie (Curve25519, ChaCha20-Poly1305), schnell, einfach zu prüfen |
| OpenVPN | TLS-basiert, flexibel, läuft über UDP oder TCP (auch 443) |
| SSL-VPN (Hersteller) | Browser-/Client-basiert über HTTPS, oft mit Portal – häufig angegriffen |

## IPsec in Kürze

- **IKE** handelt Schlüssel und Parameter aus (Phase 1: sicherer Kanal, Phase 2: Tunnel für Daten).
- **ESP** verschlüsselt und schützt die Daten; **AH** nur Integrität (selten genutzt).
- **Tunnel-Modus** (ganzes Paket verpackt) vs. **Transport-Modus**.

> [!GEFAHR] VPN-Gateways sind Hauptziele
> Schwachstellen in VPN- und Firewall-Produkten werden oft innerhalb von Tagen massenhaft ausgenutzt. VPN-Gateways gehören ganz oben auf die Patch-Prioritätenliste – mit MFA und Überwachung.

## Tiefer eingetaucht

Sicherheitsaspekte:

- **Split Tunneling**: Nur Firmenverkehr durch den Tunnel – schont Bandbreite, aber der Client hängt gleichzeitig ungeschützt im Internet.
- **Always-On-VPN** und Gerätezertifikate: nur verwaltete Geräte verbinden sich.
- **Pre-Shared Keys** bei IPsec nur lang und zufällig; besser Zertifikate.
- Altlasten vermeiden: PPTP, L2TP ohne IPsec, IKEv1 Aggressive Mode, schwache Proposals (DES, 3DES, MD5, DH-Gruppe 2).

Zukunftstrend: **ZTNA** (Zero Trust Network Access) ersetzt den Netzzugang durch Zugriff auf **einzelne Anwendungen** nach Identitäts- und Geräteprüfung – ein kompromittierter Client sieht dann nicht mehr das ganze Netz.

## Quiz

? Welches VPN-Verfahren ist besonders schlank und nutzt feste moderne Kryptografie?
= WireGuard
! Wenige tausend Codezeilen, Curve25519 und ChaCha20-Poly1305.

? Welches IPsec-Protokoll verschlüsselt die Nutzdaten?
= ESP
= Encapsulating Security Payload
! AH schützt nur die Integrität.

? Welches Protokoll handelt bei IPsec die Schlüssel aus?
= IKE
= IKEv2
! Internet Key Exchange.

?tf VPN-Gateways gehören wegen häufiger Massenausnutzung zu den Systemen mit höchster Patch-Priorität.
= wahr
! Sie sind direkt aus dem Internet erreichbar und öffnen das Firmennetz.

? Was bedeutet Split Tunneling?
+ nur ein Teil des Verkehrs geht durch das VPN
- das VPN nutzt zwei Server
- der Tunnel wird halbiert verschlüsselt
- zwei Nutzer teilen sich einen Tunnel
! Der restliche Verkehr geht direkt ins Internet.

? Welches veraltete VPN-Protokoll sollte nicht mehr verwendet werden?
+ PPTP
- WireGuard
- IKEv2
- OpenVPN mit TLS 1.3
! PPTP gilt seit Langem als gebrochen.

? Wie heißt das Konzept, statt Netzzugang nur Zugriff auf einzelne Anwendungen zu gewähren?
= ZTNA
= Zero Trust Network Access
! Weniger Bewegungsfreiheit für kompromittierte Clients.

@@@ MODULE @@@
---
id: np-08
title: Protokolle 8 · HTTP/2, HTTP/3 und QUIC
paths: cwes, cwee, grundlagen
order: 6.2
difficulty: medium
icon: bolt.horizontal.fill
tags: protokolle, http
summary: Was sich mit HTTP/2 und HTTP/3 geändert hat – binäre Frames, Multiplexing, Header-Kompression, QUIC über UDP – und was das für Sicherheit und Analyse bedeutet.
---

## Einfach erklärt

HTTP/1.1 ist wie ein Kassierer, der jeden Kunden einzeln bedient: Eine Anfrage nach der anderen pro Verbindung. **HTTP/2** öffnet viele Kassen auf einer Verbindung gleichzeitig (**Multiplexing**). **HTTP/3** verlegt das Ganze auf **QUIC**, ein neues Transportprotokoll über UDP, das schneller startet und Paketverluste besser verkraftet.

## Vergleich

| | HTTP/1.1 | HTTP/2 | HTTP/3 |
|---|---|---|---|
| Format | Text | binäre Frames | binäre Frames |
| Transport | TCP | TCP (+TLS) | QUIC über UDP (TLS 1.3 integriert) |
| Parallelität | mehrere Verbindungen | Streams auf einer Verbindung | Streams ohne Head-of-Line-Blocking |
| Header | Klartext | HPACK-komprimiert | QPACK-komprimiert |

## Sicherheitsrelevantes

- **Rapid Reset (2023)**: Massenhaftes Öffnen und sofortiges Abbrechen von Streams führte zu Rekord-DDoS-Angriffen – Server mussten Limits einführen.
- **Request Smuggling**: Durchgängiges HTTP/2 verringert es; **Downgrade** auf HTTP/1.1 am Proxy kann es wieder ermöglichen.
- **Header-Kompression**: HPACK wurde so gestaltet, dass frühere Kompressions-Seitenkanäle (CRIME) erschwert werden.
- **QUIC über UDP/443**: Klassische Firewalls und Proxies, die TCP-Inhalte prüfen, sehen QUIC oft nicht – manche Unternehmen blockieren QUIC, damit Browser auf HTTP/2 über TCP zurückfallen und gefiltert werden können.

> [!INFO] Verbindungsmigration
> QUIC-Verbindungen haben eigene IDs und können IP-Wechsel (WLAN → Mobilfunk) überstehen – angenehm für Nutzer, eine Herausforderung für Netzwerküberwachung.

## Tiefer eingetaucht

Für Analyse und Tests: Proxies wie Burp unterstützen HTTP/2; manche Schwachstellen treten nur in HTTP/2 auf (z. B. Header mit Zeilenumbrüchen, die beim Downgrade gefährlich werden). In Wireshark lassen sich HTTP/2 und QUIC nur mit den TLS-Sitzungsschlüsseln entschlüsseln (`SSLKEYLOGFILE` im Browser).

Die Aushandlung erfolgt über **ALPN** im TLS-Handshake (`h2`), HTTP/3 wird per `Alt-Svc`-Header oder HTTPS-DNS-Record angekündigt.

## Quiz

? Welches Transportprotokoll nutzt HTTP/3?
= QUIC
! QUIC läuft über UDP und integriert TLS 1.3.

? Was bedeutet Multiplexing in HTTP/2?
+ mehrere Anfragen laufen parallel als Streams über eine Verbindung
- jede Anfrage braucht eine eigene Verbindung
- Anfragen werden doppelt gesendet
- der Server antwortet nur auf eine Anfrage pro Minute
! Das spart Verbindungen und Wartezeit.

? Welcher DDoS-Angriff nutzte 2023 das schnelle Öffnen und Abbrechen von Streams?
= Rapid Reset
= HTTP/2 Rapid Reset
! CVE-2023-44487.

?tf Manche Unternehmen blockieren QUIC, damit Browser auf filterbares HTTP/2 über TCP ausweichen.
= wahr
! So bleibt die Inhaltsprüfung am Proxy möglich.

? Wie wird HTTP/2 im TLS-Handshake ausgehandelt?
= ALPN
! Application-Layer Protocol Negotiation mit dem Wert h2.

? Welche Umgebungsvariable lässt Browser TLS-Schlüssel für Wireshark protokollieren?
= SSLKEYLOGFILE
! Damit lässt sich eigener Verkehr zu Analysezwecken entschlüsseln.

@@@ MODULE @@@
---
id: np-09
title: Protokolle 9 · Wireshark-Praxis
paths: grundlagen, cjca, cdsa, cyberrange
order: 2.5
difficulty: medium
icon: waveform
tags: wireshark, pcap, analyse
summary: Mitschnitte effizient auswerten – Anzeige- und Mitschnittfilter, Streams folgen, Statistiken, Objekte exportieren und typische Fragen an einen PCAP.
---

## Einfach erklärt

Wireshark ist ein Mikroskop für Netzwerkverkehr. Ein Mitschnitt (PCAP) enthält oft hunderttausende Pakete – die Kunst ist, mit **Filtern** genau die richtigen zu finden.

## Zwei Arten von Filtern

| Art | Zeitpunkt | Syntax | Beispiel |
|---|---|---|---|
| Capture-Filter | beim Mitschneiden | BPF | `host 10.0.0.5 and port 443` |
| Display-Filter | beim Anzeigen | Wireshark | `ip.addr == 10.0.0.5 && tls` |

## Nützliche Display-Filter

```text
http.request.method == "POST"
dns.qry.name contains "update"
tcp.flags.syn == 1 && tcp.flags.ack == 0
tcp.analysis.retransmission
tls.handshake.extensions_server_name
smb2.cmd == 5
frame contains "password"
!(arp || dns || icmp)
```

## Die wichtigsten Funktionen

- **Follow TCP/HTTP Stream** – die Unterhaltung als Text lesen.
- **Statistics → Conversations / Endpoints** – wer spricht mit wem, wie viel?
- **Statistics → Protocol Hierarchy** – welche Protokolle sind enthalten?
- **File → Export Objects → HTTP/SMB** – übertragene Dateien extrahieren.
- **Expert Information** – Auffälligkeiten wie Retransmissions, Resets.
- **Zeitanzeige** auf UTC oder „seit vorherigem Paket“ umstellen.

> [!TIPP] Vom Großen ins Kleine
> Erst Statistik (Protokolle, Gesprächspartner, Datenmengen), dann gezielt filtern, dann Streams lesen.

## Tiefer eingetaucht

Typische Fragen bei einer Analyse:

1. Welche internen Hosts sprechen mit welchen externen Zielen?
2. Gibt es ungewöhnliche Protokolle oder Ports?
3. Welche Domains wurden aufgelöst (DNS) und welche SNI-Namen stehen in TLS-Handshakes?
4. Wurden Dateien übertragen? (Export Objects, Hash bilden, prüfen)
5. Gibt es Klartext-Anmeldedaten (FTP, HTTP Basic, Telnet)?

Für große Mitschnitte ist Wireshark langsam – dann `tshark` (Kommandozeile), Zeek (Logs aus PCAPs) oder `editcap`/`mergecap` zum Zerteilen. Mitschnitte enthalten oft personenbezogene und vertrauliche Daten: sicher aufbewahren, nur im Rahmen der Berechtigung erstellen.

## Quiz

? Welche Filterart wird beim Mitschneiden angewendet und nutzt BPF-Syntax?
= Capture-Filter
= Capture Filter
! Display-Filter wirken nur auf die Anzeige.

? Welcher Display-Filter zeigt nur Pakete mit einer bestimmten IP?
= ip.addr == 10.0.0.5
= ip.addr==10.0.0.5
! ip.src und ip.dst filtern nach Richtung.

? Mit welcher Funktion liest man eine TCP-Unterhaltung als Text?
= Follow TCP Stream
= Follow Stream
! Rechtsklick auf ein Paket → Follow → TCP Stream.

? Wie extrahiert man über HTTP übertragene Dateien?
+ File → Export Objects → HTTP
- Statistics → Endpoints
- Edit → Preferences
- View → Zoom
! Danach Hash bilden und prüfen.

?tf Im TLS-Handshake kann man den Ziel-Hostnamen oft trotz Verschlüsselung im SNI sehen.
= wahr
! Außer bei Encrypted Client Hello (ECH).

? Welcher Filter zeigt TCP-Verbindungsaufbauten (nur SYN)?
= tcp.flags.syn == 1 && tcp.flags.ack == 0
! SYN gesetzt, ACK nicht gesetzt.

? Wie heißt die Kommandozeilenversion von Wireshark?
= tshark
! Ideal für Skripte und große Dateien.

@@@ MODULE @@@
---
id: np-10
title: Protokolle 10 · tcpdump für den Ernstfall
paths: grundlagen, cdsa, cyberrange
order: 2.6
difficulty: medium
icon: terminal
tags: tcpdump, pcap, linux
summary: Auf Servern ohne Oberfläche schnell und sicher mitschneiden – Optionen, BPF-Filter, Rotation und typische Einzeiler.
---

## Einfach erklärt

Auf einem Server gibt es keinen Wireshark mit Fenstern. `tcpdump` ist das Taschenmesser: klein, überall vorhanden, schnell. Man schneidet auf dem Server mit und analysiert später in Ruhe am eigenen Rechner.

## Wichtige Optionen

| Option | Wirkung |
|---|---|
| `-i eth0` / `-i any` | Schnittstelle |
| `-n` / `-nn` | keine Namens- bzw. Portauflösung (schneller, keine DNS-Spuren) |
| `-w datei.pcap` | in Datei schreiben |
| `-r datei.pcap` | Datei lesen |
| `-c 1000` | nach 1000 Paketen stoppen |
| `-s 0` | vollständige Pakete (Standard bei modernen Versionen) |
| `-A` / `-X` | Inhalt als ASCII / Hex+ASCII |
| `-C 100 -W 10` | Dateien à 100 MB, maximal 10 (Ringpuffer) |
| `-G 3600` | jede Stunde neue Datei |

## BPF-Filter

```bash
tcpdump -nn -i eth0 host 203.0.113.7
tcpdump -nn -i eth0 'tcp port 443 and not net 10.0.0.0/8'
tcpdump -nn -i any 'udp port 53'
tcpdump -nn -i eth0 'tcp[tcpflags] & (tcp-syn) != 0 and tcp[tcpflags] & (tcp-ack) == 0'
tcpdump -nn -i eth0 -w /tmp/vorfall-%H%M.pcap -G 900 -W 8 'not port 22'
```

> [!WARNUNG] Nicht den eigenen SSH-Verkehr mitschneiden
> Wer per SSH arbeitet und alles mitschneidet, erzeugt eine Rückkopplung. `not port 22` (oder die eigene IP ausschließen) spart Platz und Nerven.

## Tiefer eingetaucht

Praxis bei einem Vorfall:

1. Ziel klären: Welche Frage soll der Mitschnitt beantworten?
2. Filter so eng wie möglich, aber nicht so eng, dass man das Unerwartete verpasst.
3. Plattenplatz bedenken: Ringpuffer mit `-C`/`-W`.
4. Mitschnitt hashen, Zeitpunkt und Ort dokumentieren (Beweissicherung).
5. Auswertung offline mit Wireshark, tshark oder Zeek.

Für Dauerbetrieb eignen sich spezialisierte Sensoren (Zeek, Suricata, Arkime) statt tcpdump – sie indexieren und machen Mitschnitte durchsuchbar. Auf Switches liefern **SPAN-Ports** oder **TAPs** den Verkehr an den Sensor.

## Quiz

? Welche tcpdump-Option verhindert Namens- und Portauflösung?
= -nn
! Schneller und ohne zusätzliche DNS-Anfragen.

? Mit welcher Option schreibt tcpdump in eine Datei?
= -w
! -r liest eine Datei wieder ein.

? Was bewirkt `-C 100 -W 10`?
+ Ringpuffer aus maximal 10 Dateien à 100 MB
- 100 Pakete in 10 Sekunden
- 10 Schnittstellen gleichzeitig
- Verschlüsselung der Datei
! So läuft die Platte nicht voll.

?tf Beim Mitschneiden über SSH ist es sinnvoll, Port 22 auszuschließen.
= wahr
! Sonst erzeugt der eigene Verkehr eine Rückkopplung.

? Welcher Filter zeigt nur DNS über UDP?
= udp port 53
! DNS kann auch TCP nutzen, z. B. bei großen Antworten.

? Welche Geräte bzw. Funktionen liefern Netzwerkverkehr an einen Sensor?
+ SPAN-Port
+ TAP
- USB-Hub
- KVM-Switch
! Ein TAP kopiert passiv, ein SPAN-Port spiegelt am Switch.
