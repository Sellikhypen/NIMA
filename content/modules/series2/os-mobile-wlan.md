---
id: os-11
title: Betriebssysteme 11 · Linux-Persistenz erkennen
paths: cdsa, specialist
order: 25.1
difficulty: hard
icon: magnifyingglass.circle
tags: linux, persistenz, forensik
summary: Die wichtigsten Orte, an denen sich Angreifer auf Linux-Systemen einnisten – und wie man sie systematisch prüft und überwacht.
---

## Einfach erklärt

Ein Einbrecher, der wiederkommen will, versteckt einen Zweitschlüssel – unter der Fußmatte, im Blumentopf, beim Nachbarn. Auf Linux gibt es ähnlich viele Verstecke. Wer sie alle kennt, kann sie gezielt durchsuchen.

## Verstecke und Prüfungen

| Ort | Prüfen |
|---|---|
| Cron | `/etc/crontab`, `/etc/cron.*/`, `crontab -l` für alle Nutzer, `/var/spool/cron/` |
| systemd | neue/geänderte Units in `/etc/systemd/system/`, User-Units, Timer |
| SSH | `~/.ssh/authorized_keys` aller Nutzer inkl. root |
| Shell-Startdateien | `.bashrc`, `.profile`, `/etc/profile.d/`, `/etc/bash.bashrc` |
| Neue Konten | `/etc/passwd` (UID 0!), `/etc/shadow`, `/etc/sudoers(.d)` |
| SUID-Dateien | `find / -perm -4000 -type f` mit Baseline vergleichen |
| LD_PRELOAD | `/etc/ld.so.preload` – lädt Bibliotheken in jeden Prozess |
| PAM | manipulierte Module in `/etc/pam.d/` oder `lib/security` |
| Kernel-Module | `lsmod`, unbekannte Module |
| Webroots | Webshells in `/var/www` |
| Init-Skripte, rc.local | `/etc/rc.local`, `/etc/init.d/` |
| Paketintegrität | `debsums`, `rpm -Va` – veränderte Systemdateien |

> [!WARNUNG] /etc/ld.so.preload
> Ein Eintrag dort wird in jeden dynamisch gelinkten Prozess geladen – ein klassischer Ort für Userland-Rootkits, die Dateien und Prozesse verstecken.

## Systematisch vorgehen

1. Mit einer **Baseline** vergleichen (Konfigurationsmanagement, Golden Image, Dateiintegritätsüberwachung).
2. Werkzeuge nutzen: Velociraptor-Artefakte, `chkrootkit`/`rkhunter` (Hinweise, nicht Beweise), auditd-Ereignisse.
3. Zeitstempel und Paketzugehörigkeit prüfen: Gehört die Datei zu einem Paket? Wann wurde sie geändert?
4. Bei Verdacht auf Kernel-Rootkits: Analyse von außen (Speicherabbild, Offline-Analyse der Platte).

## Tiefer eingetaucht

Überwachung statt nur Suche: FIM (z. B. Wazuh, AIDE) auf die genannten Pfade, auditd-Regeln für Schreibzugriffe, Alarme bei neuen UID-0-Konten, neuen SSH-Schlüsseln und neuen Systemd-Units. In Containern ist Persistenz seltener im Container selbst (kurzlebig), eher in Images, CI-Pipelines oder auf dem Host – entsprechend dort suchen.

## Quiz

? Welche Datei lädt Bibliotheken in jeden dynamisch gelinkten Prozess?
= /etc/ld.so.preload
= ld.so.preload
! Beliebt für Userland-Rootkits.

? Wie findet man SUID-Dateien?
= find / -perm -4000 -type f
= find / -perm -4000
! Ergebnis mit einer Baseline vergleichen.

? Welche Werkzeuge prüfen, ob Paketdateien verändert wurden?
+ debsums
+ rpm -Va
- lsmod
- crontab -l
! Sie vergleichen Dateien mit den Prüfsummen der Pakete.

?tf Ein Konto mit UID 0 in /etc/passwd hat root-Rechte, auch wenn es nicht „root“ heißt.
= wahr
! Die UID zählt, nicht der Name.

? Wo stehen erlaubte SSH-Schlüssel eines Nutzers?
= ~/.ssh/authorized_keys
= authorized_keys
! Auch für root prüfen.

? Warum sind rkhunter und chkrootkit nur Hinweisgeber?
+ sie arbeiten mit Signaturen und Heuristiken und können getäuscht werden
- sie sind kostenpflichtig
- sie laufen nur unter Windows
- sie löschen Dateien
! Bei ernstem Verdacht offline bzw. per Speicherabbild analysieren.

@@@ MODULE @@@
---
id: os-12
title: Betriebssysteme 12 · Windows Event Forwarding und Log-Sammlung
paths: cdsa, specialist
order: 25.2
difficulty: medium
icon: arrow.up.bin.fill
tags: windows, logging, wef
summary: Wie man Windows-Ereignisse zentral sammelt – WEF/WEC, Abonnements, Kanäle, Agenten im Vergleich und eine sinnvolle Auswahl.
---

## Einfach erklärt

Jeder Windows-Rechner schreibt sein eigenes Tagebuch. Damit das SOC nicht hunderte Tagebücher einzeln aufschlagen muss, werden sie an eine zentrale Stelle geschickt. **Windows Event Forwarding (WEF)** ist der eingebaute Postdienst dafür – ohne zusätzliche Software auf den Clients.

## Bausteine

| Baustein | Aufgabe |
|---|---|
| WEC (Windows Event Collector) | Server, der Ereignisse empfängt |
| Abonnement | legt fest, welche Ereignisse von welchen Rechnern kommen (XPath-Filter) |
| Source-initiated | Clients melden sich per GPO beim Collector (empfohlen) |
| ForwardedEvents-Log | Zielkanal auf dem Collector |
| Weiterleitung ins SIEM | Agent auf dem Collector |

```xml
<QueryList>
  <Query Id="0" Path="Security">
    <Select Path="Security">*[System[(EventID=4624 or EventID=4625 or EventID=4688 or EventID=4698 or EventID=4720 or EventID=1102)]]</Select>
  </Query>
</QueryList>
```

## WEF vs. Agent

| | WEF | Agent (z. B. SIEM-/EDR-Agent) |
|---|---|---|
| Installation | keine auf Clients | Software verteilen |
| Filterung | XPath | oft flexibler |
| Andere Quellen (Dateien, Sysmon) | nur Ereignisprotokolle (Sysmon ist ein Kanal → geht) | auch Dateien, Metriken |
| Skalierung | mehrere Collector für große Umgebungen | herstellerabhängig |

> [!TIPP] Auswahl statt alles
> „Alles sammeln“ ist teuer und laut. Bewährte Listen (z. B. NSA-Leitfaden „Spotting the Adversary“, Microsoft-Empfehlungen) als Startpunkt nehmen und an eigene Erkennungen anpassen.

## Tiefer eingetaucht

Voraussetzungen: passende **Audit-Richtlinien** (Advanced Audit Policy) – sonst entstehen die Ereignisse gar nicht; ausreichende Logröße auf Clients (falls der Collector kurz ausfällt); WinRM für den Transport; Überwachung der Collector selbst (Event-Rate pro Client, fehlende Clients = blinde Flecken). Die Abdeckung regelmäßig prüfen: Melden wirklich alle Domain Controller und Server?

## Quiz

? Was ist WEF?
+ der eingebaute Windows-Mechanismus, Ereignisse an einen zentralen Collector zu senden
- ein Virenscanner
- ein Webserver
- ein Backup-Programm
! Windows Event Forwarding.

? Wie heißt der Server, der weitergeleitete Ereignisse empfängt?
= WEC
= Windows Event Collector
! Ereignisse landen dort im Log ForwardedEvents.

? Womit filtert ein WEF-Abonnement Ereignisse?
= XPath
! Abfragen auf IDs, Kanäle und Felder.

?tf Ohne passende Audit-Richtlinien entstehen viele Sicherheitsereignisse gar nicht.
= wahr
! Logging muss erst aktiviert werden, bevor man es sammeln kann.

? Welche Variante von WEF wird für große Umgebungen empfohlen?
+ source-initiated per Gruppenrichtlinie
- manuelles Kopieren der Logs
- collector-initiated ohne GPO
- E-Mail-Versand der Logs
! Clients melden sich selbst beim Collector.

@@@ MODULE @@@
---
id: os-13
title: Betriebssysteme 13 · Linux-Server-Logs zentralisieren mit rsyslog und journald
paths: cdsa, cyberrange, specialist
order: 25.3
difficulty: medium
icon: tray.and.arrow.up.fill
tags: linux, logging, syslog
summary: Lokale Logs, journald-Persistenz, rsyslog-Weiterleitung über TLS, Formate und was man auf Linux-Servern mindestens zentral sammeln sollte.
---

## Einfach erklärt

Linux-Server führen Tagebuch in **journald** (binär, mit Metadaten) und klassisch in Textdateien unter `/var/log`. Damit Angreifer ihre Spuren nicht einfach löschen können und das SOC alles an einer Stelle sieht, werden die Einträge per **rsyslog** an einen zentralen Server geschickt.

## journald

```bash
journalctl --since "2026-11-22 08:00" -p warning
journalctl -u ssh -o json-pretty
```

- Persistenz aktivieren: `Storage=persistent` in `/etc/systemd/journald.conf` (sonst nur im RAM).
- Größenlimits (`SystemMaxUse`) festlegen.

## rsyslog-Weiterleitung

```text
# /etc/rsyslog.d/90-forward.conf
$DefaultNetstreamDriver gtls
$DefaultNetstreamDriverCAFile /etc/ssl/certs/log-ca.pem
$ActionSendStreamDriverMode 1
$ActionSendStreamDriverAuthMode x509/name
action(type="omfwd" target="logs.example.local" port="6514" protocol="tcp"
       queue.type="LinkedList" queue.filename="fwd" queue.saveOnShutdown="on"
       action.resumeRetryCount="-1")
```

| Punkt | Warum |
|---|---|
| TCP + TLS (Port 6514) | zuverlässig und vertraulich |
| Disk-Queue | keine Verluste bei kurzzeitigem Ausfall des Empfängers |
| RFC 5424 / strukturiert | bessere Auswertung |
| Zeit in UTC, NTP | korrelierbar |

## Was mindestens sammeln?

- Authentifizierung (`auth`/`authpriv`, sshd, sudo)
- auditd-Ereignisse
- Dienste: Webserver, Datenbanken, Mail
- Kernel-Meldungen
- Paketmanager-Logs (Installationen)
- Firewall-Logs (nftables)

> [!MERKE] Lokale Logs sind nicht vertrauenswürdig nach einem Einbruch
> Mit root-Rechten lassen sich lokale Logs manipulieren. Die zentrale Kopie – idealerweise unveränderlich gespeichert – ist die Wahrheit.

## Tiefer eingetaucht

Alternativen und Ergänzungen: SIEM-Agenten (Elastic Agent, Wazuh, Splunk UF), `systemd-journal-remote` für Journal-Übertragung, Vector/Fluent Bit für flexible Pipelines. Auf dem Empfänger: Zugriff stark beschränken, Integrität sichern (WORM, Hash-Ketten), Aufbewahrung nach Datenschutz und Bedarf.

## Quiz

? Welche Einstellung macht das journald-Journal dauerhaft?
= Storage=persistent
! Sonst liegen Logs nur im flüchtigen Speicher.

? Welcher Port ist für Syslog über TLS üblich?
= 6514
! 514 ist klassisches Syslog über UDP/TCP.

? Wozu dient eine Disk-Queue in rsyslog?
+ Logs werden zwischengespeichert, wenn der Empfänger nicht erreichbar ist
- Logs werden gelöscht
- Logs werden komprimiert verschickt
- Logs werden verschlüsselt lokal gespeichert
! So gehen bei Ausfällen keine Ereignisse verloren.

?tf Nach einer root-Kompromittierung sind lokale Logs nicht mehr vertrauenswürdig.
= wahr
! Die zentrale Kopie ist entscheidend.

? Welche Logquellen sollte man auf Linux-Servern mindestens zentral sammeln?
+ Authentifizierung und sudo
+ auditd
+ Dienst-Logs wie Webserver
- Bildschirmschoner-Einstellungen
! Plus Kernel-, Paketmanager- und Firewall-Logs.

@@@ MODULE @@@
---
id: mb-01
title: Mobile 1 · iOS-Sicherheitsarchitektur
paths: specialist, wifi
order: 8.1
difficulty: medium
icon: iphone
tags: ios, mobile
summary: Secure Boot, Secure Enclave, Datenschutzklassen, Sandbox, Code-Signatur, App Store und was das für Unternehmen und Forensik bedeutet.
---

## Einfach erklärt

Apple baut iOS wie ein Hochsicherheitsgebäude, bei dem jede Tür vom Hersteller kontrolliert wird: Nur geprüfte Apps kommen hinein (App Store), jede App hat ihr eigenes Zimmer (Sandbox), Schlüssel liegen in einem Tresor im Chip (Secure Enclave), und schon beim Einschalten wird geprüft, ob das Gebäude unverändert ist (Secure Boot).

## Bausteine

| Baustein | Aufgabe |
|---|---|
| Secure Boot Chain | jede Stufe prüft die Signatur der nächsten |
| Secure Enclave | isolierter Prozessor für Schlüssel, Face ID/Touch ID |
| Datenschutzklassen | Dateien nur nach Entsperren lesbar (Complete Protection) usw. |
| Code Signing | nur signierter Code läuft |
| Sandbox | Apps sehen nur eigene Daten, Zugriff über Berechtigungen |
| App Review | Prüfung vor Veröffentlichung |
| Schnelle Updates | lange Unterstützung älterer Geräte |

> [!MERKE] Vor dem ersten Entsperren
> Nach einem Neustart sind viele Daten bis zum ersten Entsperren besonders geschützt (Before First Unlock). Das ist für Diebstahlschutz und Forensik gleichermaßen relevant.

## Unternehmensaspekte

- **MDM** mit Supervised Mode für Firmengeräte (mehr Kontrollmöglichkeiten).
- **User Enrollment** für private Geräte (getrennter Firmenbereich, mehr Privatsphäre).
- **Managed Apps** und Managed Open-In verhindern Datenabfluss in private Apps.
- **Lockdown-Modus** für besonders gefährdete Personen.

## Tiefer eingetaucht

Angriffe auf iOS sind teuer: Ketten aus mehreren Lücken (Browser, Kernel, Sandbox), oft als Zero-Click über Messenger. Sie werden vor allem gegen Journalisten, Aktivisten und Politiker eingesetzt. Schutz: schnelle Updates, Lockdown-Modus, regelmäßige Neustarts (viele Implantate überleben keinen Neustart).

Für Forensik: Vollständige Extraktion ist ohne Entsperrung schwer; logische Backups (verschlüsselt mit Passwort) liefern viele Artefakte; Werkzeuge wie das Mobile Verification Toolkit (MVT) suchen nach Spuren bekannter Spyware.

## Quiz

? Wo werden Schlüssel und biometrische Daten auf iOS geschützt?
= Secure Enclave
! Ein isolierter Prozessor im Chip.

? Was prüft die Secure Boot Chain?
+ dass jede Startstufe eine gültige Signatur der nächsten hat
- die Akkulaufzeit
- die WLAN-Stärke
- die App-Bewertungen
! Manipulierte Systemsoftware startet nicht.

?tf Nach einem Neustart sind viele iOS-Daten bis zum ersten Entsperren besonders geschützt.
= wahr
! Before First Unlock.

? Welcher Modus schränkt iOS für besonders gefährdete Personen stark ein?
= Lockdown-Modus
= Lockdown Mode
! Reduziert die Angriffsfläche erheblich.

? Welches Werkzeug sucht auf Mobilgeräten nach Spuren bekannter Spyware?
= MVT
= Mobile Verification Toolkit
! Entwickelt von Amnesty International.

? Wie trennt iOS Firmen- und Privatdaten auf privaten Geräten?
= User Enrollment
! Mit getrenntem verwaltetem Bereich.

@@@ MODULE @@@
---
id: mb-02
title: Mobile 2 · Android-Sicherheitsarchitektur
paths: specialist, wifi
order: 8.2
difficulty: medium
icon: candybarphone
tags: android, mobile
summary: Linux-Basis, App-Sandbox per UID, Berechtigungsmodell, Verified Boot, SELinux, Play Protect, Patch-Level und Arbeitsprofile.
---

## Einfach erklärt

Android basiert auf Linux und nutzt dessen Rechtekonzept geschickt: **Jede App ist ein eigener Benutzer** (eigene UID) und darf nur in ihren eigenen Ordner. Weil es viele Hersteller gibt, hängt die Sicherheit aber auch davon ab, wie schnell der jeweilige Hersteller Updates liefert.

## Bausteine

| Baustein | Aufgabe |
|---|---|
| App-Sandbox | eigene Linux-UID pro App |
| Berechtigungen | Laufzeit-Abfrage für gefährliche Rechte |
| SELinux (enforcing) | Mandatory Access Control für Systemdienste |
| Verified Boot | prüft Systempartitionen beim Start |
| Dateiverschlüsselung | pro Nutzer, an Entsperrung gebunden |
| Play Protect | Malware-Scans, auch für Sideloading |
| Monatliche Sicherheitspatches | Patch-Level in den Einstellungen sichtbar |
| Work Profile | getrennter Firmenbereich |

> [!WARNUNG] Patch-Level prüfen
> Ein Gerät mit Patch-Level von vor zwei Jahren hat viele bekannte Lücken. Für Firmengeräte nur Modelle mit langer Update-Garantie beschaffen und den Patch-Stand per MDM durchsetzen.

## Typische Risiken

- **Sideloading** von APKs außerhalb des Play Store
- Missbrauch der **Bedienungshilfen** durch Banking-Trojaner
- **Overlay**-Angriffe (gefälschte Eingabemasken über echten Apps)
- veraltete Geräte ohne Updates
- **gerootete** Geräte

## Tiefer eingetaucht

Für die App-Entwicklung gilt: Netzwerkverkehr nur verschlüsselt (Network Security Config), keine sensiblen Daten in Logs oder externem Speicher, exportierte Komponenten (Activities, Services, Content Provider) bewusst absichern, Geheimnisse nicht in der App hinterlegen. Für Tests eignen sich Emulatoren und Werkzeuge zur dynamischen Analyse; die OWASP **MASVS/MASTG** liefert den Prüfkatalog für mobile Apps.

## Quiz

? Wie trennt Android Apps voneinander?
+ jede App läuft unter einer eigenen Linux-UID
- alle Apps teilen einen Benutzer
- nur über die App-Namen
- gar nicht
! Basis der App-Sandbox.

? Was prüft Verified Boot?
+ die Integrität der Systempartitionen beim Start
- die Internetgeschwindigkeit
- die App-Bewertungen
- die Akkutemperatur
! Manipulierte Systeme werden erkannt.

?tf Das Sicherheitspatch-Level eines Android-Geräts ist für die Sicherheit unwichtig.
= falsch
! Alte Patch-Stände bedeuten viele bekannte Lücken.

? Was sind Overlay-Angriffe?
+ gefälschte Eingabemasken über echten Apps
- zu helle Bildschirme
- doppelte Benachrichtigungen
- große App-Symbole
! Beliebt bei Banking-Trojanern.

? Welcher OWASP-Standard beschreibt Sicherheitsanforderungen für mobile Apps?
= MASVS
! Ergänzt durch den Testleitfaden MASTG.

@@@ MODULE @@@
---
id: mb-03
title: Mobile 3 · Mobile Apps sicher entwickeln und prüfen
paths: cwee, cwes, specialist
order: 8.3
difficulty: hard
icon: app.badge.checkmark.fill
tags: mobile, appsec, masvs
summary: Datenspeicherung, Netzwerk, Authentifizierung, Plattforminteraktion und Code-Schutz – die wichtigsten Prüfbereiche nach OWASP MASVS.
---

## Einfach erklärt

Eine Mobile-App ist ein Programm, das man aus der Hand gibt: Jeder kann sie herunterladen, auseinandernehmen und genau ansehen, wie sie mit dem Server spricht. Deshalb gilt: **Die App ist nie vertrauenswürdig – der Server muss alles prüfen.**

## Prüfbereiche nach OWASP MASVS

| Bereich | Typische Fehler | Richtig |
|---|---|---|
| Storage | Tokens/Passwörter im Klartext, sensible Daten in Logs, Backups | Keychain/Keystore, minimale Speicherung |
| Crypto | eigene Kryptografie, fest codierte Schlüssel | Plattform-APIs, Schlüssel im sicheren Speicher |
| Auth | Prüfung nur in der App, lange Tokens | serverseitig, kurzlebige Tokens, Biometrie korrekt an Schlüssel gebunden |
| Network | kein TLS, Zertifikatsprüfung deaktiviert | TLS, ggf. Certificate Pinning |
| Platform | ungeschützte exportierte Komponenten, WebView mit JS-Brücke | bewusste Freigaben, WebView einschränken |
| Code | Debug-Builds, alte Bibliotheken | Release-Builds, Abhängigkeiten aktuell |
| Resilience | keine Erkennung von Root/Jailbreak (wo nötig) | Härtung für Hochrisiko-Apps |
| Privacy | übermäßige Datensammlung | Datenminimierung, Transparenz |

> [!MERKE] Geheimnisse in Apps sind keine Geheimnisse
> API-Schlüssel, die in einer App stecken, lassen sich extrahieren. Für Zugriffe auf eigene Backends: Nutzer-Authentifizierung und serverseitige Prüfung; für Drittdienste: über das eigene Backend proxyen.

## Tiefer eingetaucht

Testmethoden: statische Analyse (dekompilierte APK/IPA nach Schlüsseln, URLs, unsicheren Einstellungen durchsuchen), dynamische Analyse (Traffic über einen Proxy, Laufzeitinstrumentierung in Testumgebungen), Backend-Tests wie bei jeder API (die meisten kritischen Funde liegen dort: IDOR, fehlende Autorisierung).

Certificate Pinning schützt gegen manipulierte CAs, erschwert aber auch legitime Analysen und braucht ein Konzept für Zertifikatswechsel – sonst sperrt man nach einer Rotation alle Nutzer aus.

## Quiz

? Wo sollten Tokens auf Mobilgeräten gespeichert werden?
+ in Keychain bzw. Keystore
- in einer Textdatei auf der SD-Karte
- in den Logs
- im App-Namen
! Plattform-Speicher schützen Geheimnisse hardwaregestützt.

?tf In einer App eingebettete API-Schlüssel sind vor Nutzern sicher.
= falsch
! Sie lassen sich aus der App extrahieren.

? Wo liegen bei Mobile-Tests oft die kritischsten Funde?
+ im Backend bzw. der API
- in der App-Farbe
- im App-Store-Text
- im Icon
! Fehlende serverseitige Autorisierung ist häufig.

? Was ist ein Risiko von Certificate Pinning?
+ bei Zertifikatswechsel ohne Konzept funktionieren Apps nicht mehr
- es deaktiviert TLS
- es verlangsamt das Gerät dauerhaft
- es löscht Daten
! Pinning braucht eine Rotationsstrategie.

? Welche Komponenten von Android-Apps müssen bewusst abgesichert werden?
+ exportierte Activities, Services und Content Provider
- nur das App-Icon
- nur die Farben
- nur die Schriftart
! Andere Apps können sie sonst aufrufen.

@@@ MODULE @@@
---
id: wf-10
title: WLAN vertieft 10 · Gästenetz-Architektur und Captive Portals in der Tiefe
paths: wifi, specialist
order: 21.5
difficulty: medium
icon: person.crop.circle.badge.plus
tags: wlan, gastnetz, captive portal
summary: Wie Gästenetze technisch getrennt werden, welche Rolle Captive Portals spielen, Rechtsfragen bei öffentlichem WLAN und typische Fehler.
---

## Einfach erklärt

Ein Gästenetz ist wie die Lobby eines Hotels: Gäste dürfen hinein, ins Internet surfen, aber nicht in die Büros oder den Serverraum. Ein **Captive Portal** ist der Empfangstresen, an dem man sich kurz anmeldet oder die Nutzungsbedingungen bestätigt.

## Architektur

| Element | Umsetzung |
|---|---|
| eigene SSID | getrennt vom Firmen-WLAN |
| eigenes VLAN | Ausleitung direkt zur Firewall/Internet |
| Firewall-Regeln | nur Internet; keine internen Netze, keine Management-Oberflächen |
| Client-Isolation | Gäste sehen sich nicht gegenseitig |
| Bandbreitenlimit | Schutz vor Missbrauch |
| DNS-Filter | Schutz vor Malware-Domains |
| eigener DHCP/DNS | keine internen Namen sichtbar |

## Captive Portals

- Leiten HTTP-Anfragen auf eine Anmeldeseite um, bis der Client freigeschaltet ist.
- Varianten: Klick-Bestätigung, Gutscheincodes, Anmeldung per Konto/SMS.
- **Kein Verschlüsselungsschutz**: Das Portal regelt nur den Zugang. Für Vertraulichkeit WPA2/3 mit Gastpasswort oder **OWE** nutzen.

> [!WARNUNG] Portal ist kein Sicherheitsfeature
> MAC-Adressen freigeschalteter Clients lassen sich ggf. kopieren, und offenes WLAN ist abhörbar. Das Portal ist Komfort und Rechtsschutz, keine Verschlüsselung.

## Tiefer eingetaucht

Rechtliches in Deutschland: Seit der Abschaffung der Störerhaftung für WLAN-Betreiber (TMG/TTDSG-Änderungen) ist die Haftung für Rechtsverletzungen von Nutzern weitgehend entschärft; Vorschaltseiten sind nicht mehr zwingend, aber Nutzungsbedingungen und Datenschutzhinweise bleiben sinnvoll.

Häufige Fehler in Audits: Gästenetz erreicht interne Drucker oder die WLAN-Controller-Oberfläche, gleiches VLAN wie IoT-Geräte, Gastpasswort seit Jahren unverändert, Portal per DNS-Tunneling oder fremde Ports umgehbar.

## Quiz

? Was sollte das Gästenetz erreichen dürfen?
+ nur das Internet
- interne Server
- die Verwaltung der Access Points
- das Druckernetz der Buchhaltung
! Alles andere wird per Firewall blockiert.

?tf Ein Captive Portal verschlüsselt den WLAN-Verkehr.
= falsch
! Es regelt nur den Zugang – Verschlüsselung braucht WPA2/3 oder OWE.

? Was verhindert Client-Isolation im Gästenetz?
+ dass sich Gäste-Geräte gegenseitig erreichen
- den Internetzugang
- die DHCP-Vergabe
- das Captive Portal
! Schützt Gäste voreinander.

? Welches Verfahren verschlüsselt offene Gastnetze ohne Passwort?
= OWE
= Opportunistic Wireless Encryption
! Auch „Enhanced Open“ genannt.

? Was ist ein häufiger Audit-Fund bei Gastnetzen?
+ die Verwaltungsoberfläche des WLAN-Controllers ist erreichbar
- das Internet ist erreichbar
- Gäste bekommen eine IP-Adresse
- es gibt eine Anmeldeseite
! Management-Zugänge dürfen aus Gastnetzen nie erreichbar sein.

@@@ MODULE @@@
---
id: wf-11
title: WLAN vertieft 11 · Störungen, Jamming und Verfügbarkeit
paths: wifi, cdsa
order: 22.5
difficulty: medium
icon: wave.3.left.circle.fill
tags: wlan, verfügbarkeit, störung
summary: Warum Funk anfällig für Störungen ist, wie man Störquellen und absichtliches Jamming erkennt und wie kritische Prozesse unabhängig vom WLAN bleiben.
---

## Einfach erklärt

Funk ist ein geteiltes Medium – wie ein Raum, in dem alle sprechen. Wird jemand sehr laut (ein Störsender) oder dröhnt eine Maschine (Mikrowelle, Funkkamera), versteht niemand mehr etwas. Gegen Lärm hilft keine Verschlüsselung. Deshalb gilt: **Kritisches sollte nicht allein am WLAN hängen.**

## Störquellen

| Quelle | Band |
|---|---|
| Mikrowellen | 2,4 GHz |
| Bluetooth, Funkmäuse | 2,4 GHz |
| Analoge Funkkameras, Babyphones | 2,4/5 GHz |
| Nachbar-WLANs (Gleichkanal) | alle |
| Radar (DFS) | 5 GHz |
| Absichtliche Störsender (Jammer) | breitbandig – in Deutschland illegal |

## Erkennen

- **Spektrumanalyse** zeigt Nicht-WLAN-Störer (Form und Dauer der Signale).
- Kennzahlen: hohe **Channel Utilization**, viele **Retransmissions**, steigender Noise Floor, viele Verbindungsabbrüche.
- WIDS-Alarme bei Deauth-/Disassoc-Fluten.
- Plötzlicher Ausfall in einem Bereich bei normalem Kabelnetz → Funkproblem.

> [!MERKE] Verfügbarkeit planen
> Prozesse wie Kassensysteme, Lagerscanner oder Sicherheitstechnik brauchen eine Ausweichlösung (Kabel, Mobilfunk, Pufferung offline), wenn das WLAN gestört ist.

## Tiefer eingetaucht

Gegenmaßnahmen: Kanal- und Leistungsplanung, 5/6 GHz statt überfülltem 2,4 GHz, PMF gegen Deauth-Angriffe, Ortung von Störquellen mit Richtantenne und Spektrumanalysator, bei Sabotageverdacht Beweise sichern (Zeit, Ort, Spektrumaufnahmen) und Behörden einschalten (Bundesnetzagentur bei Funkstörungen). Für Video-Überwachung und Alarmanlagen gilt besonders: Funk-Jamming ist eine bekannte Einbruchsmethode – kabelgebundene oder überwachte Funkstrecken mit Störungsalarm wählen.

## Quiz

? Welche Haushaltsgeräte stören typischerweise das 2,4-GHz-Band?
+ Mikrowellen
- Kühlschränke
- Bücherregale
- Holzstühle
! Sie arbeiten im selben Frequenzbereich.

?tf Verschlüsselung schützt vor Funkstörungen (Jamming).
= falsch
! Jamming greift die Verfügbarkeit an, nicht die Vertraulichkeit.

? Welches Werkzeug zeigt Nicht-WLAN-Störquellen?
+ Spektrumanalysator
- Passwortmanager
- Texteditor
- Taschenrechner
! WLAN-Karten sehen nur WLAN-Frames.

? Welche Kennzahlen deuten auf Störungen hin?
+ hohe Kanalauslastung
+ viele Retransmissions
+ steigender Noise Floor
- niedrige Stromrechnung
! Kombiniert mit Verbindungsabbrüchen ein klares Bild.

? Welche Behörde ist in Deutschland bei Funkstörungen zuständig?
= Bundesnetzagentur
! Störsender sind in Deutschland verboten.

@@@ MODULE @@@
---
id: wf-12
title: WLAN vertieft 12 · WLAN-Forensik und Spuren auf Clients
paths: wifi, cdsa
order: 23.5
difficulty: hard
icon: wifi.circle.fill
tags: wlan, forensik
summary: Welche WLAN-Spuren Clients und Infrastruktur hinterlassen – Profile, Verbindungshistorie, Controller-Logs, RADIUS – und wie man sie für Untersuchungen nutzt.
---

## Einfach erklärt

Jedes Gerät merkt sich, mit welchen WLANs es verbunden war – wie ein Notizbuch mit besuchten Orten. Und das Firmen-WLAN notiert, welches Gerät wann an welchem Access Point war. Bei Untersuchungen kann das zeigen, **wo** ein Gerät war und **wann**.

## Spuren auf Clients

| System | Ort |
|---|---|
| Windows | WLAN-Profile: `C:\ProgramData\Microsoft\Wlansvc\Profiles\Interfaces\`; Ereignisse: `Microsoft-Windows-WLAN-AutoConfig/Operational` (z. B. 8001 verbunden, 8003 getrennt); `netsh wlan show profiles` |
| macOS | bekannte Netze in Systemkonfiguration (`com.apple.wifi.known-networks.plist`) |
| Linux | NetworkManager-Profile in `/etc/NetworkManager/system-connections/` |
| Mobile | in Backups/Extraktionen, oft mit Zeitstempeln |

> [!WARNUNG] Gespeicherte Passwörter
> WLAN-Profile enthalten oft die Passphrase (lokal geschützt, für Admins auslesbar). Bei der Beweissicherung vertraulich behandeln.

## Spuren in der Infrastruktur

- **WLAN-Controller-Logs**: Assoziation, Roaming, Client-MAC, AP, Signalstärke, Zeit.
- **RADIUS-Logs**: welcher Nutzer bzw. welches Zertifikat wann, mit welchem Ergebnis.
- **DHCP-Logs**: MAC → IP-Zuordnung über die Zeit.
- **NAC/Firewall**: Verbindung von IP zu Nutzer und Aktivitäten.

Zusammen ergibt sich eine Kette: **Nutzer → Gerät (MAC) → IP → Aktivität → Ort (AP)**.

## Tiefer eingetaucht

Fallstricke: zufällige MAC-Adressen (Privacy-Funktionen moderner Betriebssysteme, oft pro SSID stabil), Zeitabweichungen zwischen Controller, RADIUS und DHCP (NTP!), kurze Aufbewahrungsfristen auf Controllern. Datenschutz: Standortdaten sind personenbezogen und sensibel – Auswertung nur zweckgebunden, mit Rechtsgrundlage und dokumentiert.

## Quiz

? Welches Windows-Ereignisprotokoll enthält WLAN-Verbindungen?
= Microsoft-Windows-WLAN-AutoConfig/Operational
= WLAN-AutoConfig
! Z. B. Ereignis 8001 für eine erfolgreiche Verbindung.

? Mit welchem Befehl zeigt Windows gespeicherte WLAN-Profile?
= netsh wlan show profiles
! Mit key=clear zeigt es (als Admin) auch die Passphrase.

? Welche Logs verbinden eine MAC-Adresse mit einer IP-Adresse über die Zeit?
= DHCP-Logs
= DHCP
! Grundlage, um Aktivitäten Geräten zuzuordnen.

?tf Zufällige MAC-Adressen können die Zuordnung von Geräten erschweren.
= wahr
! Moderne Betriebssysteme nutzen sie aus Datenschutzgründen.

? Welche Kette lässt sich aus WLAN-, RADIUS-, DHCP- und Firewall-Logs bilden?
+ Nutzer → Gerät → IP → Aktivität → Ort
- Passwort → Farbe → Größe
- Drucker → Papier → Toner
- Kabel → Stecker → Dose
! Voraussetzung: synchronisierte Zeit.

? Warum ist Datenschutz bei WLAN-Forensik besonders wichtig?
+ Standortdaten sind personenbezogen und sensibel
- weil WLAN verboten ist
- weil Logs öffentlich sind
- weil Controller keine Zeit kennen
! Auswertung nur zweckgebunden und dokumentiert.
