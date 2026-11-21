# Glossar aus der Cyber-Range-Dokumentation

## 3-2-1-Regel
kat: Cyber Range
kurz: Backup-Grundregel: 3 Kopien der Daten, auf 2 verschiedenen Medientypen, davon 1 Kopie außer Haus bzw.

Backup-Grundregel: 3 Kopien der Daten, auf 2 verschiedenen Medientypen, davon 1 Kopie außer Haus bzw. offline.

## 802.1Q
kat: Cyber Range
kurz: IEEE-Standard für VLANs: fügt einen 4-Byte-Tag mit 12-Bit-VLAN-ID in den Ethernet-Frame ein.

IEEE-Standard für VLANs: fügt einen 4-Byte-Tag mit 12-Bit-VLAN-ID in den Ethernet-Frame ein.

## AAR
kat: Cyber Range
kurz: After-Action-Review – strukturierte Nachbesprechung einer Übung: Was war geplant, was ist passiert, warum, was lernen wir daraus?.

After-Action-Review – strukturierte Nachbesprechung einer Übung: Was war geplant, was ist passiert, warum, was lernen wir daraus?

## Access-Port
kat: Cyber Range
kurz: Port, der genau einem VLAN zugeordnet ist und Frames ohne Tag an das Endgerät liefert.

Port, der genau einem VLAN zugeordnet ist und Frames ohne Tag an das Endgerät liefert. Die VM merkt nichts vom VLAN.

## Active Directory
kat: Cyber Range
kurz: Verzeichnisdienst von Microsoft (AD DS), der Benutzer, Computer, Gruppen und Richtlinien einer Windows-Domäne zentral verwaltet; Hauptangriffsziel in Unternehmensnetzen.

Verzeichnisdienst von Microsoft (AD DS), der Benutzer, Computer, Gruppen und Richtlinien einer Windows-Domäne zentral verwaltet; Hauptangriffsziel in Unternehmensnetzen.

## Active Response
kat: Cyber Range
kurz: Wazuh-Funktion, die bei bestimmten Alarmen automatisch eine Gegenmaßnahme auf dem Agenten ausführt (z.

Wazuh-Funktion, die bei bestimmten Alarmen automatisch eine Gegenmaßnahme auf dem Agenten ausführt (z. B. IP sperren, Konto deaktivieren).

## ADCS
kat: Cyber Range
kurz: Active Directory Certificate Services: Microsofts Zertifizierungsstelle im AD.

Active Directory Certificate Services: Microsofts Zertifizierungsstelle im AD. Fehlkonfigurierte Zertifikatsvorlagen (ESC1–ESC8 u. a.) erlauben Rechteausweitung.

## AES
kat: Cyber Range
kurz: Advanced Encryption Standard – symmetrisches Verschlüsselungsverfahren (gleicher Schlüssel zum Ver- und Entschlüsseln), Standard für schnelle Datenverschlüsselung.

Advanced Encryption Standard – symmetrisches Verschlüsselungsverfahren (gleicher Schlüssel zum Ver- und Entschlüsseln), Standard für schnelle Datenverschlüsselung.

## AF_PACKET
kat: Cyber Range
kurz: Linux-Socket-Typ zum direkten Mitlesen von Frames einer Netzwerkkarte; mit »Fanout« wird die Last auf mehrere Prozesse verteilt.

Linux-Socket-Typ zum direkten Mitlesen von Frames einer Netzwerkkarte; mit »Fanout« wird die Last auf mehrere Prozesse verteilt.

## Agent
kat: Cyber Range
kurz: Kleines Programm auf einem überwachten System, das lokal Daten (Logs, Prozesse, Dateiänderungen) sammelt und an einen zentralen Server sendet.

Kleines Programm auf einem überwachten System, das lokal Daten (Logs, Prozesse, Dateiänderungen) sammelt und an einen zentralen Server sendet.

## Alias
kat: Cyber Range
kurz: In OPNsense ein benannter Platzhalter für Adressen, Netze oder Ports, der in vielen Regeln verwendet werden kann.

In OPNsense ein benannter Platzhalter für Adressen, Netze oder Ports, der in vielen Regeln verwendet werden kann.

## Ansible Vault
kat: Cyber Range
kurz: Verschlüsselung sensibler Variablen (Passwörter, Schlüssel) in Ansible-Dateien mit AES-256, damit sie gefahrlos im Git-Repository liegen können.

Verschlüsselung sensibler Variablen (Passwörter, Schlüssel) in Ansible-Dateien mit AES-256, damit sie gefahrlos im Git-Repository liegen können.

## API
kat: Cyber Range
kurz: Application Programming Interface – definierte Schnittstelle, über die Programme miteinander kommunizieren (hier meist REST über HTTPS).

Application Programming Interface – definierte Schnittstelle, über die Programme miteinander kommunizieren (hier meist REST über HTTPS).

## API-Token
kat: Cyber Range
kurz: Geheime Zeichenfolge, mit der sich ein Programm statt mit Benutzername und Passwort an einer API anmeldet; kann auf bestimmte Rechte beschränkt und einzeln widerrufen werden.

Geheime Zeichenfolge, mit der sich ein Programm statt mit Benutzername und Passwort an einer API anmeldet; kann auf bestimmte Rechte beschränkt und einzeln widerrufen werden.

## ARC
kat: Cyber Range
kurz: Adaptive Replacement Cache: Lesecache von ZFS im Arbeitsspeicher.

Adaptive Replacement Cache: Lesecache von ZFS im Arbeitsspeicher. Belegt ohne Grenze bis zur Hälfte des RAMs; Obergrenze über zfs_arc_max.

## ARP
kat: Cyber Range
kurz: Address Resolution Protocol – ermittelt im lokalen Netz zu einer IPv4-Adresse die zugehörige MAC-Adresse (»Wer hat 10.10.10.1?«).

Address Resolution Protocol – ermittelt im lokalen Netz zu einer IPv4-Adresse die zugehörige MAC-Adresse (»Wer hat 10.10.10.1?«).

## AS-REP-Roasting
kat: Cyber Range
kurz: Angriff auf Konten ohne Kerberos-Vorauthentifizierung: Der Angreifer erhält verschlüsselte Daten, deren Passwort er offline knacken kann.

Angriff auf Konten ohne Kerberos-Vorauthentifizierung: Der Angreifer erhält verschlüsselte Daten, deren Passwort er offline knacken kann.

## Atomic Red Team
kat: Cyber Range
kurz: Bibliothek kleiner, einzeln ausführbarer Tests (»Atomics«), die je eine ATT&CK-Technik nachstellen; von Red Canary gepflegt.

Bibliothek kleiner, einzeln ausführbarer Tests (»Atomics«), die je eine ATT&CK-Technik nachstellen; von Red Canary gepflegt.

## ATT&CK
kat: Cyber Range
kurz: MITRE ATT&CK – frei verfügbare Wissensbasis realer Angreifer-Taktiken (Ziele, z.

MITRE ATT&CK – frei verfügbare Wissensbasis realer Angreifer-Taktiken (Ziele, z. B. »Credential Access«) und -Techniken (Wege, z. B. T1003 »OS Credential Dumping«).

## Attack-Defense
kat: Cyber Range
kurz: CTF-Format, bei dem jedes Team eigene Dienste verteidigt und gleichzeitig die Dienste der anderen Teams angreift.

CTF-Format, bei dem jedes Team eigene Dienste verteidigt und gleichzeitig die Dienste der anderen Teams angreift.

## Audit-Richtlinie
kat: Cyber Range
kurz: Windows-Einstellung, die festlegt, welche sicherheitsrelevanten Ereignisse ins Sicherheitsprotokoll geschrieben werden.

Windows-Einstellung, die festlegt, welche sicherheitsrelevanten Ereignisse ins Sicherheitsprotokoll geschrieben werden.

## Authorization Code Flow
kat: Cyber Range
kurz: Empfohlener OIDC/OAuth-Ablauf: Der Browser erhält nur einen kurzlebigen Code, den die Anwendung serverseitig gegen Tokens tauscht.

Empfohlener OIDC/OAuth-Ablauf: Der Browser erhält nur einen kurzlebigen Code, den die Anwendung serverseitig gegen Tokens tauscht.

## Autoritativer Nameserver
kat: Cyber Range
kurz: DNS-Server, der für eine Zone verbindlich antwortet (AA-Flag gesetzt), weil er die Zonendaten selbst verwaltet.

DNS-Server, der für eine Zone verbindlich antwortet (AA-Flag gesetzt), weil er die Zonendaten selbst verwaltet.

## autounattend.xml
kat: Cyber Range
kurz: Antwortdatei für die unbeaufsichtigte Windows-Installation: Partitionierung, Sprache, Treiber, Konten und erste Befehle.

Antwortdatei für die unbeaufsichtigte Windows-Installation: Partitionierung, Sprache, Treiber, Konten und erste Befehle.

## Ballooning
kat: Cyber Range
kurz: Verfahren, bei dem ein Treiber in der VM ungenutzten Arbeitsspeicher »aufbläst« und so an den Host zurückgibt, damit andere VMs ihn nutzen können.

Verfahren, bei dem ein Treiber in der VM ungenutzten Arbeitsspeicher »aufbläst« und so an den Host zurückgibt, damit andere VMs ihn nutzen können.

## Beacon
kat: Cyber Range
kurz: Regelmäßige Rückmeldung einer Schadsoftware an ihren C2-Server; erkennbar an gleichmäßigen Intervallen, auch mit Zufallsabweichung (Jitter).

Regelmäßige Rückmeldung einer Schadsoftware an ihren C2-Server; erkennbar an gleichmäßigen Intervallen, auch mit Zufallsabweichung (Jitter).

## Benchmark
kat: Cyber Range
kurz: Standardisierte Messung der Leistung eines Systems (z.

Standardisierte Messung der Leistung eines Systems (z. B. fio für Speicher, iperf3 für Netz), um Konfigurationen vergleichbar zu machen.

## BGP
kat: Cyber Range
kurz: Border Gateway Protocol – Routing-Protokoll (TCP 179), das Routen zwischen Routern austauscht; bei EVPN transportiert es MAC- und IP-Informationen.

Border Gateway Protocol – Routing-Protokoll (TCP 179), das Routen zwischen Routern austauscht; bei EVPN transportiert es MAC- und IP-Informationen.

## BloodHound
kat: Cyber Range
kurz: Werkzeug, das Beziehungen im Active Directory als Graph darstellt und Angriffspfade zu Domain Admins findet; wird von Red und Blue Teams genutzt.

Werkzeug, das Beziehungen im Active Directory als Graph darstellt und Angriffspfade zu Domain Admins findet; wird von Red und Blue Teams genutzt.

## Bloom-Taxonomie
kat: Cyber Range
kurz: Einteilung von Lernzielen in sechs Stufen (Erinnern, Verstehen, Anwenden, Analysieren, Bewerten, Erschaffen), in der überarbeiteten Fassung von Anderson und Krathwohl.

Einteilung von Lernzielen in sechs Stufen (Erinnern, Verstehen, Anwenden, Analysieren, Bewerten, Erschaffen), in der überarbeiteten Fassung von Anderson und Krathwohl.

## Blue Team
kat: Cyber Range
kurz: Gruppe, die in einer Übung die Systeme verteidigt, Angriffe erkennt und darauf reagiert.

Gruppe, die in einer Übung die Systeme verteidigt, Angriffe erkennt und darauf reagiert.

## BMC
kat: Cyber Range
kurz: Baseboard Management Controller: eigener kleiner Rechner auf der Hauptplatine (z.

Baseboard Management Controller: eigener kleiner Rechner auf der Hauptplatine (z. B. iDRAC, iLO), der Fernsteuerung, Konsole und Sensorwerte bereitstellt – auch bei ausgeschaltetem Server.

## Bridge
kat: Cyber Range
kurz: Virtueller Switch im Linux-Kernel (z.

Virtueller Switch im Linux-Kernel (z. B. vmbr1): verbindet die Netzwerkkarten von VMs auf Layer 2 und lernt, welche MAC-Adresse an welchem Port hängt.

## BUM-Verkehr
kat: Cyber Range
kurz: Broadcast, Unknown Unicast, Multicast – Frames, die ein Switch an mehrere bzw.

Broadcast, Unknown Unicast, Multicast – Frames, die ein Switch an mehrere bzw. alle Ports verteilen muss, weil das Ziel nicht eindeutig bekannt ist.

## C2
kat: Cyber Range
kurz: Command and Control – Infrastruktur und Kommunikationskanal, über den Angreifer kompromittierte Systeme fernsteuern (z.

Command and Control – Infrastruktur und Kommunikationskanal, über den Angreifer kompromittierte Systeme fernsteuern (z. B. HTTPS-Beacons).

## Caldera
kat: Cyber Range
kurz: Automatisierungsplattform von MITRE zur Nachstellung von Angreifern (Adversary Emulation) mit Agenten, Fähigkeiten und Operationen; Weboberfläche standardmäßig auf Port 8888.

Automatisierungsplattform von MITRE zur Nachstellung von Angreifern (Adversary Emulation) mit Agenten, Fähigkeiten und Operationen; Weboberfläche standardmäßig auf Port 8888.

## Ceph
kat: Cyber Range
kurz: Verteiltes Speichersystem, das Daten über mehrere Server repliziert; liefert Blockgeräte (RBD) für VMs und toleriert den Ausfall einzelner Knoten.

Verteiltes Speichersystem, das Daten über mehrere Server repliziert; liefert Blockgeräte (RBD) für VMs und toleriert den Ausfall einzelner Knoten.

## cgroups
kat: Cyber Range
kurz: Control Groups: Linux-Kernelfunktion, die CPU, RAM und I/O für Prozessgruppen begrenzt und misst.

Control Groups: Linux-Kernelfunktion, die CPU, RAM und I/O für Prozessgruppen begrenzt und misst. Grundlage für Ressourcenlimits von VMs und Containern.

## Change-Management
kat: Cyber Range
kurz: Geregeltes Verfahren für Änderungen: Antrag, Bewertung, Freigabe, Umsetzung, Test, Dokumentation.

Geregeltes Verfahren für Änderungen: Antrag, Bewertung, Freigabe, Umsetzung, Test, Dokumentation.

## Chaos Engineering
kat: Cyber Range
kurz: Gezieltes Herbeiführen von Störungen (z.

Gezieltes Herbeiführen von Störungen (z. B. Dienstabsturz, Netzlatenz), um die Robustheit eines Systems zu prüfen.

## chrony
kat: Cyber Range
kurz: Moderne NTP-Implementierung für Linux, die Uhren schnell und genau synchronisiert; Standard in vielen Distributionen.

Moderne NTP-Implementierung für Linux, die Uhren schnell und genau synchronisiert; Standard in vielen Distributionen.

## CI/CD
kat: Cyber Range
kurz: Continuous Integration / Continuous Delivery – automatische Prüfung und Auslieferung von Code bei jeder Änderung über eine Pipeline.

Continuous Integration / Continuous Delivery – automatische Prüfung und Auslieferung von Code bei jeder Änderung über eine Pipeline.

## Claim
kat: Cyber Range
kurz: Einzelne Aussage in einem Token, z.

Einzelne Aussage in einem Token, z. B. Benutzername, E-Mail oder Gruppenzugehörigkeit (»groups«).

## Client (OIDC)
kat: Cyber Range
kurz: Anwendung, die sich bei einem Identity Provider anmeldet und Tokens erhält, z.

Anwendung, die sich bei einem Identity Provider anmeldet und Tokens erhält, z. B. Guacamole oder CTFd.

## cloud-init
kat: Cyber Range
kurz: Standard-Werkzeug, das Linux-VMs beim ersten Start automatisch konfiguriert (Hostname, IP-Adresse, Benutzer, SSH-Schlüssel, Pakete).

Standard-Werkzeug, das Linux-VMs beim ersten Start automatisch konfiguriert (Hostname, IP-Adresse, Benutzer, SSH-Schlüssel, Pakete).

## cloudbase-init
kat: Cyber Range
kurz: Windows-Gegenstück zu cloud-init: übernimmt beim ersten Start Hostname, Benutzer, Netz und Skripte aus einer Datenquelle.

Windows-Gegenstück zu cloud-init: übernimmt beim ersten Start Hostname, Benutzer, Netz und Skripte aus einer Datenquelle.

## Conntrack
kat: Cyber Range
kurz: Connection Tracking im Linux-Kernel – merkt sich jede Verbindung und ihren Zustand (NEW, ESTABLISHED, RELATED, INVALID), damit Antworten automatisch erlaubt werden können.

Connection Tracking im Linux-Kernel – merkt sich jede Verbindung und ihren Zustand (NEW, ESTABLISHED, RELATED, INVALID), damit Antworten automatisch erlaubt werden können.

## Container
kat: Cyber Range
kurz: Isolierte Laufzeitumgebung für Anwendungen, die sich den Kernel des Hosts teilt (Docker, LXC) – leichter als eine VM, aber schwächer isoliert.

Isolierte Laufzeitumgebung für Anwendungen, die sich den Kernel des Hosts teilt (Docker, LXC) – leichter als eine VM, aber schwächer isoliert.

## Copy-on-Write
kat: Cyber Range
kurz: Speicherverfahren, bei dem eine Kopie zunächst nur auf das Original verweist; erst geänderte Blöcke werden tatsächlich neu geschrieben.

Speicherverfahren, bei dem eine Kopie zunächst nur auf das Original verweist; erst geänderte Blöcke werden tatsächlich neu geschrieben.

## Corosync
kat: Cyber Range
kurz: Cluster-Kommunikationsdienst von Proxmox VE; sorgt dafür, dass alle Knoten denselben Konfigurationsstand haben und das Quorum bestimmt wird.

Cluster-Kommunikationsdienst von Proxmox VE; sorgt dafür, dass alle Knoten denselben Konfigurationsstand haben und das Quorum bestimmt wird.

## CRUSH
kat: Cyber Range
kurz: Controlled Replication Under Scalable Hashing: Algorithmus, mit dem Ceph berechnet, auf welchen OSDs ein Datenobjekt liegt – ohne zentrale Tabelle.

Controlled Replication Under Scalable Hashing: Algorithmus, mit dem Ceph berechnet, auf welchen OSDs ein Datenobjekt liegt – ohne zentrale Tabelle.

## CTF
kat: Cyber Range
kurz: Capture the Flag – Wettbewerbsformat, bei dem gefundene geheime Zeichenfolgen (»Flaggen«) als Lösungsnachweis eingereicht werden.

Capture the Flag – Wettbewerbsformat, bei dem gefundene geheime Zeichenfolgen (»Flaggen«) als Lösungsnachweis eingereicht werden.

## CVE
kat: Cyber Range
kurz: Common Vulnerabilities and Exposures: weltweit eindeutige Kennung einer veröffentlichten Schwachstelle (z.

Common Vulnerabilities and Exposures: weltweit eindeutige Kennung einer veröffentlichten Schwachstelle (z. B. CVE-2021-44228).

## CVSS
kat: Cyber Range
kurz: Common Vulnerability Scoring System: Bewertung des Schweregrads einer Schwachstelle auf einer Skala von 0 bis 10.

Common Vulnerability Scoring System: Bewertung des Schweregrads einer Schwachstelle auf einer Skala von 0 bis 10.

## DCSync
kat: Cyber Range
kurz: Angriff, bei dem sich ein Angreifer mit Replikationsrechten als Domänencontroller ausgibt und Passwort-Hashes (z.

Angriff, bei dem sich ein Angreifer mit Replikationsrechten als Domänencontroller ausgibt und Passwort-Hashes (z. B. von krbtgt) anfordert.

## Decoder
kat: Cyber Range
kurz: In Wazuh die Regel, die eine Rohzeile eines Logs in Felder zerlegt, bevor die eigentlichen Detektionsregeln greifen.

In Wazuh die Regel, die eine Rohzeile eines Logs in Felder zerlegt, bevor die eigentlichen Detektionsregeln greifen.

## Deduplizierung
kat: Cyber Range
kurz: Gleiche Datenblöcke werden nur einmal gespeichert.

Gleiche Datenblöcke werden nur einmal gespeichert. Bei vielen ähnlichen VMs spart das sehr viel Speicherplatz.

## Default Deny
kat: Cyber Range
kurz: Firewall-Grundsatz »alles ist verboten, was nicht ausdrücklich erlaubt ist«; die letzte Regel blockiert jeden übrigen Verkehr.

Firewall-Grundsatz »alles ist verboten, was nicht ausdrücklich erlaubt ist«; die letzte Regel blockiert jeden übrigen Verkehr.

## Detection Engineering
kat: Cyber Range
kurz: Systematische Entwicklung, Prüfung, Pflege und Messung von Detektionsregeln – behandelt wie Software (Versionierung, Tests, Reviews).

Systematische Entwicklung, Prüfung, Pflege und Messung von Detektionsregeln – behandelt wie Software (Versionierung, Tests, Reviews).

## Detection Strategy
kat: Cyber Range
kurz: Seit ATT&CK v18 Objekt, das beschreibt, wie eine Technik grundsätzlich erkannt werden kann; konkrete Logik steckt in zugehörigen Analytics.

Seit ATT&CK v18 Objekt, das beschreibt, wie eine Technik grundsätzlich erkannt werden kann; konkrete Logik steckt in zugehörigen Analytics.

## DHCP
kat: Cyber Range
kurz: Dynamic Host Configuration Protocol (UDP 67/68) – vergibt automatisch IP-Adresse, Gateway und DNS-Server an Clients.

Dynamic Host Configuration Protocol (UDP 67/68) – vergibt automatisch IP-Adresse, Gateway und DNS-Server an Clients.

## Dienstkonto
kat: Cyber Range
kurz: Benutzerkonto, unter dem ein Dienst (z.

Benutzerkonto, unter dem ein Dienst (z. B. SQL Server) läuft. Hat oft einen SPN, hohe Rechte und ein selten geändertes Passwort – beliebtes Angriffsziel.

## Digitaler Zwilling
kat: Cyber Range
kurz: Virtuelles Abbild eines realen Systems, das dessen Verhalten möglichst genau nachbildet und mit echten Daten abgeglichen werden kann.

Virtuelles Abbild eines realen Systems, das dessen Verhalten möglichst genau nachbildet und mit echten Daten abgeglichen werden kann.

## Dirty Bitmap
kat: Cyber Range
kurz: Liste der seit der letzten Sicherung geänderten Blöcke einer VM-Disk; ermöglicht sehr schnelle inkrementelle Backups.

Liste der seit der letzten Sicherung geänderten Blöcke einer VM-Disk; ermöglicht sehr schnelle inkrementelle Backups.

## DKIM
kat: Cyber Range
kurz: DomainKeys Identified Mail: digitale Signatur von E-Mails, deren öffentlicher Schlüssel im DNS steht.

DomainKeys Identified Mail: digitale Signatur von E-Mails, deren öffentlicher Schlüssel im DNS steht.

## DMARC
kat: Cyber Range
kurz: Richtlinie im DNS, die festlegt, was mit Mails geschieht, die SPF/DKIM nicht bestehen, und wohin Berichte gehen.

Richtlinie im DNS, die festlegt, was mit Mails geschieht, die SPF/DKIM nicht bestehen, und wohin Berichte gehen.

## DMZ
kat: Cyber Range
kurz: Demilitarisierte Zone – Netzsegment für Server, die aus dem Internet erreichbar sein müssen (Web, Mail), getrennt vom internen Netz.

Demilitarisierte Zone – Netzsegment für Server, die aus dem Internet erreichbar sein müssen (Web, Mail), getrennt vom internen Netz.

## DNAT
kat: Cyber Range
kurz: Destination NAT: Umschreiben der Zieladresse eines Pakets, z.

Destination NAT: Umschreiben der Zieladresse eines Pakets, z. B. Portweiterleitung von der öffentlichen Firewall-Adresse auf einen DMZ-Server.

## DNP3
kat: Cyber Range
kurz: Distributed Network Protocol 3: Fernwirkprotokoll vor allem in Energie- und Wasserversorgung, TCP-Port 20000.

Distributed Network Protocol 3: Fernwirkprotokoll vor allem in Energie- und Wasserversorgung, TCP-Port 20000.

## DNS
kat: Cyber Range
kurz: Domain Name System (UDP/TCP 53) – übersetzt Namen wie shop.nordwind.lab in IP-Adressen; in AD-Umgebungen zusätzlich für das Auffinden von Domain Controllern nötig.

Domain Name System (UDP/TCP 53) – übersetzt Namen wie shop.nordwind.lab in IP-Adressen; in AD-Umgebungen zusätzlich für das Auffinden von Domain Controllern nötig.

## DNS-Tunneling
kat: Cyber Range
kurz: Verstecken von Daten in DNS-Anfragen und -Antworten (z.

Verstecken von Daten in DNS-Anfragen und -Antworten (z. B. Base32 in Subdomains), um Firewalls zu umgehen oder Daten auszuleiten.

## Domain Controller
kat: Cyber Range
kurz: Windows-Server, der Active Directory bereitstellt: Anmeldung (Kerberos/NTLM), Verzeichnisdienst (LDAP), Gruppenrichtlinien und meist DNS.

Windows-Server, der Active Directory bereitstellt: Anmeldung (Kerberos/NTLM), Verzeichnisdienst (LDAP), Gruppenrichtlinien und meist DNS.

## DORA
kat: Cyber Range
kurz: Discover, Offer, Request, Acknowledge: die vier Nachrichten, mit denen ein Client per DHCP eine Adresse erhält.

Discover, Offer, Request, Acknowledge: die vier Nachrichten, mit denen ein Client per DHCP eine Adresse erhält.

## Drift
kat: Cyber Range
kurz: Abweichung zwischen dem im Code beschriebenen Soll-Zustand und dem tatsächlichen Zustand der Infrastruktur, z.

Abweichung zwischen dem im Code beschriebenen Soll-Zustand und dem tatsächlichen Zustand der Infrastruktur, z. B. durch manuelle Änderungen.

## Dry-Run
kat: Cyber Range
kurz: Probedurchlauf einer Übung ohne Teilnehmer, um Fehler in Technik, Szenario und Bewertung vorab zu finden.

Probedurchlauf einer Übung ohne Teilnehmer, um Fehler in Technik, Szenario und Bewertung vorab zu finden.

## ECC
kat: Cyber Range
kurz: Error-Correcting Code: Arbeitsspeicher, der Einzelbitfehler erkennt und korrigiert.

Error-Correcting Code: Arbeitsspeicher, der Einzelbitfehler erkennt und korrigiert. Für Server mit vielen VMs und ZFS dringend empfohlen.

## ECS
kat: Cyber Range
kurz: Elastic Common Schema: einheitliche Feldnamen für Log-Ereignisse (z.

Elastic Common Schema: einheitliche Feldnamen für Log-Ereignisse (z. B. source.ip, process.name), damit Daten verschiedener Quellen vergleichbar sind.

## ECSF
kat: Cyber Range
kurz: European Cybersecurity Skills Framework der ENISA mit 12 Rollenprofilen (z.

European Cybersecurity Skills Framework der ENISA mit 12 Rollenprofilen (z. B. Incident Responder, Penetration Tester), Missionen, Aufgaben und Kompetenzen.

## EDR
kat: Cyber Range
kurz: Endpoint Detection and Response – Sicherheitssoftware auf Endgeräten, die verdächtiges Verhalten erkennt, aufzeichnet und Gegenmaßnahmen erlaubt.

Endpoint Detection and Response – Sicherheitssoftware auf Endgeräten, die verdächtiges Verhalten erkennt, aufzeichnet und Gegenmaßnahmen erlaubt.

## Egress
kat: Cyber Range
kurz: Ausgehender Netzwerkverkehr; Egress-Filterung kontrolliert, wohin Systeme Verbindungen aufbauen dürfen.

Ausgehender Netzwerkverkehr; Egress-Filterung kontrolliert, wohin Systeme Verbindungen aufbauen dürfen.

## Einstufungstest
kat: Cyber Range
kurz: Kurzer Test vor einer Ausbildung, mit dem Teilnehmer der passenden Stufe oder Gruppe zugeordnet werden.

Kurzer Test vor einer Ausbildung, mit dem Teilnehmer der passenden Stufe oder Gruppe zugeordnet werden.

## Elasticsearch
kat: Cyber Range
kurz: Verteilte Such- und Analyse-Datenbank, in der Security Onion (und optional Wazuh-kompatible Indexer) Ereignisse speichert und durchsuchbar macht.

Verteilte Such- und Analyse-Datenbank, in der Security Onion (und optional Wazuh-kompatible Indexer) Ereignisse speichert und durchsuchbar macht.

## Emulation
kat: Cyber Range
kurz: Nachbildung mit echten Komponenten (echte Betriebssysteme in VMs) – im Gegensatz zur Simulation, die Verhalten nur mathematisch modelliert.

Nachbildung mit echten Komponenten (echte Betriebssysteme in VMs) – im Gegensatz zur Simulation, die Verhalten nur mathematisch modelliert.

## ENDEX
kat: Cyber Range
kurz: End of Exercise – offizielles Ende einer Übung, ab dem keine Aktionen mehr gewertet werden (Gegenstück: STARTEX).

End of Exercise – offizielles Ende einer Übung, ab dem keine Aktionen mehr gewertet werden (Gegenstück: STARTEX).

## EPS
kat: Cyber Range
kurz: Events per Second: Anzahl der Log-Ereignisse pro Sekunde – Grundgröße für die Dimensionierung eines SIEM.

Events per Second: Anzahl der Log-Ereignisse pro Sekunde – Grundgröße für die Dimensionierung eines SIEM.

## EPT
kat: Cyber Range
kurz: Extended Page Tables (Intel) bzw.

Extended Page Tables (Intel) bzw. NPT/RVI (AMD) – Hardware-Funktion, die Speicheradressen der VM direkt in Host-Adressen übersetzt und Virtualisierung stark beschleunigt.

## etcd
kat: Cyber Range
kurz: Verteilte Schlüssel-Wert-Datenbank, in der Kubernetes seinen gesamten Zustand speichert – inklusive Secrets.

Verteilte Schlüssel-Wert-Datenbank, in der Kubernetes seinen gesamten Zustand speichert – inklusive Secrets.

## EVE-JSON
kat: Cyber Range
kurz: Ausgabeformat von Suricata: ein JSON-Objekt pro Ereignis (Alarm, Flow, DNS, HTTP, TLS …), gut für SIEM-Systeme verarbeitbar.

Ausgabeformat von Suricata: ein JSON-Objekt pro Ereignis (Alarm, Flow, DNS, HTTP, TLS …), gut für SIEM-Systeme verarbeitbar.

## EVPN
kat: Cyber Range
kurz: Ethernet VPN – Verfahren, das per BGP verteilt, welche MAC-/IP-Adressen hinter welchem VXLAN-Tunnelendpunkt liegen (RFC 7432, RFC 8365).

Ethernet VPN – Verfahren, das per BGP verteilt, welche MAC-/IP-Adressen hinter welchem VXLAN-Tunnelendpunkt liegen (RFC 7432, RFC 8365).

## Exfiltration
kat: Cyber Range
kurz: Unerlaubtes Herausschleusen von Daten aus einem Netzwerk durch einen Angreifer.

Unerlaubtes Herausschleusen von Daten aus einem Netzwerk durch einen Angreifer.

## Exploit
kat: Cyber Range
kurz: Programm oder Befehlsfolge, die eine Schwachstelle gezielt ausnutzt.

Programm oder Befehlsfolge, die eine Schwachstelle gezielt ausnutzt.

## Facts
kat: Cyber Range
kurz: Informationen, die Ansible zu Beginn eines Laufs automatisch über ein Zielsystem sammelt (Betriebssystem, IPs, Hardware).

Informationen, die Ansible zu Beginn eines Laufs automatisch über ein Zielsystem sammelt (Betriebssystem, IPs, Hardware).

## Faker
kat: Cyber Range
kurz: Programmbibliothek, die realistisch aussehende, aber erfundene Daten erzeugt (Namen, Adressen, Telefonnummern); mit festem Startwert reproduzierbar.

Programmbibliothek, die realistisch aussehende, aber erfundene Daten erzeugt (Namen, Adressen, Telefonnummern); mit festem Startwert reproduzierbar.

## Falco
kat: Cyber Range
kurz: Laufzeit-Sicherheitswerkzeug für Container, das Systemaufrufe beobachtet und verdächtiges Verhalten (z.

Laufzeit-Sicherheitswerkzeug für Container, das Systemaufrufe beobachtet und verdächtiges Verhalten (z. B. Shell im Container) meldet.

## False Negative
kat: Cyber Range
kurz: Verpasster Angriff: Ein Angriff findet statt, aber keine Regel schlägt an.

Verpasster Angriff: Ein Angriff findet statt, aber keine Regel schlägt an. In Übungen das wichtigste Messziel.

## False Positive
kat: Cyber Range
kurz: Fehlalarm: Eine Regel schlägt an, obwohl kein Angriff vorliegt.

Fehlalarm: Eine Regel schlägt an, obwohl kein Angriff vorliegt. Zu viele False Positives führen zu Alarmmüdigkeit.

## FDB
kat: Cyber Range
kurz: Forwarding Database – MAC-Adresstabelle einer Bridge bzw.

Forwarding Database – MAC-Adresstabelle einer Bridge bzw. eines Switches: welche MAC-Adresse ist über welchen Port erreichbar?

## FIM
kat: Cyber Range
kurz: File Integrity Monitoring: Überwachung von Dateien auf Änderungen (Hash, Rechte, Inhalt).

File Integrity Monitoring: Überwachung von Dateien auf Änderungen (Hash, Rechte, Inhalt). Erkennt z. B. Webshells oder Massen-Umbenennungen durch Ransomware.

## fio
kat: Cyber Range
kurz: Flexible I/O Tester: Werkzeug zum Messen von IOPS, Durchsatz und Latenz eines Speichers mit frei wählbaren Lastmustern.

Flexible I/O Tester: Werkzeug zum Messen von IOPS, Durchsatz und Latenz eines Speichers mit frei wählbaren Lastmustern.

## Firewall
kat: Cyber Range
kurz: System, das Netzwerkverkehr anhand von Regeln (Quelle, Ziel, Port, Protokoll, Zustand) erlaubt oder blockiert.

System, das Netzwerkverkehr anhand von Regeln (Quelle, Ziel, Port, Protokoll, Zustand) erlaubt oder blockiert.

## Flow
kat: Cyber Range
kurz: Zusammenfassung aller Pakete einer Verbindung (5-Tupel: Quell-/Ziel-IP, Quell-/Zielport, Protokoll) mit Zeit, Bytes und Paketzahl.

Zusammenfassung aller Pakete einer Verbindung (5-Tupel: Quell-/Ziel-IP, Quell-/Zielport, Protokoll) mit Zeit, Bytes und Paketzahl.

## for_each
kat: Cyber Range
kurz: Sprachmittel in OpenTofu/Terraform, um aus einer Liste oder Tabelle beliebig viele gleichartige Ressourcen zu erzeugen.

Sprachmittel in OpenTofu/Terraform, um aus einer Liste oder Tabelle beliebig viele gleichartige Ressourcen zu erzeugen.

## Frame
kat: Cyber Range
kurz: Dateneinheit auf Layer 2 (Ethernet): enthält MAC-Adressen, optional VLAN-Tag, Typfeld, Nutzdaten (z.

Dateneinheit auf Layer 2 (Ethernet): enthält MAC-Adressen, optional VLAN-Tag, Typfeld, Nutzdaten (z. B. ein IP-Paket) und Prüfsumme.

## FRRouting
kat: Cyber Range
kurz: Open-Source-Routing-Software (BGP, OSPF, IS-IS u.

Open-Source-Routing-Software (BGP, OSPF, IS-IS u. a.), die Proxmox SDN für EVPN und Fabrics nutzt.

## GHOSTS
kat: Cyber Range
kurz: Framework des CMU Software Engineering Institute zur Simulation realistischer Benutzer (NPCs), die browsen, Office nutzen, Mails schreiben und so Hintergrundverkehr erzeugen.

Framework des CMU Software Engineering Institute zur Simulation realistischer Benutzer (NPCs), die browsen, Office nutzen, Mails schreiben und so Hintergrundverkehr erzeugen.

## Gitea
kat: Cyber Range
kurz: Leichtgewichtiger, selbst gehosteter Git-Server mit Weboberfläche, Issues und CI-Runnern.

Leichtgewichtiger, selbst gehosteter Git-Server mit Weboberfläche, Issues und CI-Runnern.

## GitOps
kat: Cyber Range
kurz: Betriebsmodell, bei dem der gewünschte Zustand der Infrastruktur ausschließlich in Git beschrieben wird und Pipelines ihn automatisch herstellen.

Betriebsmodell, bei dem der gewünschte Zustand der Infrastruktur ausschließlich in Git beschrieben wird und Pipelines ihn automatisch herstellen.

## Golden Image
kat: Cyber Range
kurz: Sorgfältig vorbereitetes, getestetes Master-Abbild eines Betriebssystems, aus dem alle VMs geklont werden.

Sorgfältig vorbereitetes, getestetes Master-Abbild eines Betriebssystems, aus dem alle VMs geklont werden.

## Golden Ticket
kat: Cyber Range
kurz: Gefälschtes Kerberos-TGT, signiert mit dem Hash des krbtgt-Kontos – verschafft praktisch unbegrenzten Domänenzugriff.

Gefälschtes Kerberos-TGT, signiert mit dem Hash des krbtgt-Kontos – verschafft praktisch unbegrenzten Domänenzugriff.

## GoPhish
kat: Cyber Range
kurz: Open-Source-Plattform für Phishing-Simulationen: Kampagnen, Vorlagen, Landingpages und Klick-Statistiken.

Open-Source-Plattform für Phishing-Simulationen: Kampagnen, Vorlagen, Landingpages und Klick-Statistiken.

## Goss
kat: Cyber Range
kurz: Werkzeug für schnelle Server-Tests in YAML (»Ist Port 443 offen? Läuft Dienst X?«); geeignet als Abnahmetest nach Ansible.

Werkzeug für schnelle Server-Tests in YAML (»Ist Port 443 offen? Läuft Dienst X?«); geeignet als Abnahmetest nach Ansible.

## GPO
kat: Cyber Range
kurz: Group Policy Object (Gruppenrichtlinie): zentral im AD definierte Einstellungen, die auf Computer und Benutzer einer OU angewendet werden.

Group Policy Object (Gruppenrichtlinie): zentral im AD definierte Einstellungen, die auf Computer und Benutzer einer OU angewendet werden.

## Grafana
kat: Cyber Range
kurz: Visualisierungsplattform für Metriken und Logs (Dashboards); Standardport 3000.

Visualisierungsplattform für Metriken und Logs (Dashboards); Standardport 3000.

## Green Team
kat: Cyber Range
kurz: Infrastruktur-Team, das die Cyber Range baut, betreibt, zurücksetzt und Fehler behebt.

Infrastruktur-Team, das die Cyber Range baut, betreibt, zurücksetzt und Fehler behebt.

## Grey Space
kat: Cyber Range
kurz: Bezeichnung für das simulierte Internet einer Range (auch »SINET«): Netze und Dienste, die das echte Internet nachahmen.

Bezeichnung für das simulierte Internet einer Range (auch »SINET«): Netze und Dienste, die das echte Internet nachahmen.

## Guacamole
kat: Cyber Range
kurz: Apache Guacamole – Gateway, das RDP-, SSH- und VNC-Sitzungen im Webbrowser anzeigt, ohne dass der Nutzer einen Client installieren muss.

Apache Guacamole – Gateway, das RDP-, SSH- und VNC-Sitzungen im Webbrowser anzeigt, ohne dass der Nutzer einen Client installieren muss.

## guacd
kat: Cyber Range
kurz: Proxy-Dienst von Apache Guacamole (TCP 4822), der die eigentlichen RDP/SSH/VNC-Verbindungen aufbaut und in das Guacamole-Protokoll übersetzt.

Proxy-Dienst von Apache Guacamole (TCP 4822), der die eigentlichen RDP/SSH/VNC-Verbindungen aufbaut und in das Guacamole-Protokoll übersetzt.

## HA
kat: Cyber Range
kurz: High Availability: Hochverfügbarkeit.

High Availability: Hochverfügbarkeit. Fällt ein Cluster-Knoten aus, startet der HA-Manager die betroffenen VMs automatisch auf einem anderen Knoten.

## Handler
kat: Cyber Range
kurz: Ansible-Task, der nur ausgeführt wird, wenn ein anderer Task eine Änderung gemeldet hat – typischerweise ein Dienst-Neustart.

Ansible-Task, der nur ausgeführt wird, wenn ein anderer Task eine Änderung gemeldet hat – typischerweise ein Dienst-Neustart.

## Hardening
kat: Cyber Range
kurz: Härtung – Reduzierung der Angriffsfläche eines Systems durch Abschalten unnötiger Dienste, sichere Konfiguration und Updates.

Härtung – Reduzierung der Angriffsfläche eines Systems durch Abschalten unnötiger Dienste, sichere Konfiguration und Updates.

## HCL
kat: Cyber Range
kurz: HashiCorp Configuration Language – deklarative Konfigurationssprache von Terraform, OpenTofu und Packer.

HashiCorp Configuration Language – deklarative Konfigurationssprache von Terraform, OpenTofu und Packer.

## HIDS
kat: Cyber Range
kurz: Host-based Intrusion Detection System – erkennt Angriffe anhand von Daten auf dem Rechner selbst (Logs, Dateien, Prozesse), z.

Host-based Intrusion Detection System – erkennt Angriffe anhand von Daten auf dem Rechner selbst (Logs, Dateien, Prozesse), z. B. Wazuh.

## Historian
kat: Cyber Range
kurz: Datenbank, die Prozesswerte einer Anlage zeitlich speichert; oft Brücke zwischen OT- und IT-Netz.

Datenbank, die Prozesswerte einer Anlage zeitlich speichert; oft Brücke zwischen OT- und IT-Netz.

## HMI
kat: Cyber Range
kurz: Human-Machine Interface: Bedien- und Beobachtungsoberfläche einer Anlage für das Bedienpersonal.

Human-Machine Interface: Bedien- und Beobachtungsoberfläche einer Anlage für das Bedienpersonal.

## Honeynet
kat: Cyber Range
kurz: Netz aus Ködersystemen, das Angreifer anlocken und beobachten soll; anders als eine Range dient es der Beobachtung echter Angreifer.

Netz aus Ködersystemen, das Angreifer anlocken und beobachten soll; anders als eine Range dient es der Beobachtung echter Angreifer.

## Honeytoken
kat: Cyber Range
kurz: Köder-Datensatz (z.

Köder-Datensatz (z. B. ein nie genutztes Konto oder eine Datei), dessen bloße Verwendung zuverlässig einen Angriff anzeigt.

## Hookscript
kat: Cyber Range
kurz: Skript, das Proxmox VE automatisch zu bestimmten Zeitpunkten im Lebenszyklus einer VM ausführt (pre-start, post-start, pre-stop, post-stop).

Skript, das Proxmox VE automatisch zu bestimmten Zeitpunkten im Lebenszyklus einer VM ausführt (pre-start, post-start, pre-stop, post-stop).

## Hostname
kat: Cyber Range
kurz: Eindeutiger Name eines Rechners im Netz, z.

Eindeutiger Name eines Rechners im Netz, z. B. dc01 oder web01.

## Hot-Wash
kat: Cyber Range
kurz: Kurze, unmittelbare Nachbesprechung direkt nach Übungsende, bevor der ausführliche After-Action-Review folgt.

Kurze, unmittelbare Nachbesprechung direkt nach Übungsende, bevor der ausführliche After-Action-Review folgt.

## Hypervisor
kat: Cyber Range
kurz: Software, die mehrere virtuelle Maschinen auf einer physischen Hardware ausführt und voneinander isoliert (Typ 1: direkt auf der Hardware, z.

Software, die mehrere virtuelle Maschinen auf einer physischen Hardware ausführt und voneinander isoliert (Typ 1: direkt auf der Hardware, z. B. KVM/Proxmox, ESXi).

## IaC
kat: Cyber Range
kurz: Infrastructure as Code – Infrastruktur wird in Textdateien beschrieben, versioniert und automatisch aufgebaut statt von Hand geklickt.

Infrastructure as Code – Infrastruktur wird in Textdateien beschrieben, versioniert und automatisch aufgebaut statt von Hand geklickt.

## IAM
kat: Cyber Range
kurz: Identity and Access Management – zentrale Verwaltung von Identitäten (Benutzer, Gruppen) und deren Zugriffsrechten.

Identity and Access Management – zentrale Verwaltung von Identitäten (Benutzer, Gruppen) und deren Zugriffsrechten.

## ICMP
kat: Cyber Range
kurz: Internet Control Message Protocol: Hilfsprotokoll von IP für Fehler- und Diagnosemeldungen, z.

Internet Control Message Protocol: Hilfsprotokoll von IP für Fehler- und Diagnosemeldungen, z. B. »Ziel nicht erreichbar« oder Echo (Ping).

## Idempotenz
kat: Cyber Range
kurz: Eigenschaft eines Vorgangs, bei mehrfacher Ausführung dasselbe Ergebnis zu liefern; ein idempotentes Ansible-Playbook ändert beim zweiten Lauf nichts mehr.

Eigenschaft eines Vorgangs, bei mehrfacher Ausführung dasselbe Ergebnis zu liefern; ein idempotentes Ansible-Playbook ändert beim zweiten Lauf nichts mehr.

## IDS
kat: Cyber Range
kurz: Intrusion Detection System – erkennt Angriffe (z.

Intrusion Detection System – erkennt Angriffe (z. B. anhand von Signaturen) und meldet sie; ein IPS blockiert zusätzlich.

## INetSim
kat: Cyber Range
kurz: Software, die typische Internetdienste (DNS, HTTP, SMTP, FTP …) simuliert und auf beliebige Anfragen antwortet – v.

Software, die typische Internetdienste (DNS, HTTP, SMTP, FTP …) simuliert und auf beliebige Anfragen antwortet – v. a. für Malware-Analyse.

## Ingress
kat: Cyber Range
kurz: Kubernetes-Objekt, das HTTP(S)-Verkehr von außen anhand von Hostname und Pfad auf Dienste im Cluster verteilt.

Kubernetes-Objekt, das HTTP(S)-Verkehr von außen anhand von Hostname und Pfad auf Dienste im Cluster verteilt.

## Inject
kat: Cyber Range
kurz: Geplantes Ereignis, das die Übungsleitung in eine Übung einspielt (technischer Vorfall, Anruf, Presseanfrage, Anweisung).

Geplantes Ereignis, das die Übungsleitung in eine Übung einspielt (technischer Vorfall, Anruf, Presseanfrage, Anweisung).

## Inventar
kat: Cyber Range
kurz: Liste aller Zielsysteme in Ansible mit Gruppen und Variablen (z.

Liste aller Zielsysteme in Ansible mit Gruppen und Variablen (z. B. hosts.yml); kann statisch oder dynamisch aus der Proxmox-API erzeugt werden.

## IO-Delay
kat: Cyber Range
kurz: Anteil der Zeit, in der die CPU auf Massenspeicher wartet; in Proxmox als »IO delay« sichtbar.

Anteil der Zeit, in der die CPU auf Massenspeicher wartet; in Proxmox als »IO delay« sichtbar. Hohe Werte = Speicher ist Engpass.

## IOMMU
kat: Cyber Range
kurz: Input-Output Memory Management Unit (Intel VT-d / AMD-Vi) – isoliert Gerätezugriffe auf den Speicher; Voraussetzung, um PCI-Geräte direkt an VMs durchzureichen.

Input-Output Memory Management Unit (Intel VT-d / AMD-Vi) – isoliert Gerätezugriffe auf den Speicher; Voraussetzung, um PCI-Geräte direkt an VMs durchzureichen.

## IOPS
kat: Cyber Range
kurz: Input/Output Operations per Second: Anzahl der Lese-/Schreibvorgänge pro Sekunde, die ein Speichersystem schafft.

Input/Output Operations per Second: Anzahl der Lese-/Schreibvorgänge pro Sekunde, die ein Speichersystem schafft. Wichtigste Kennzahl für viele gleichzeitig startende VMs.

## IPAM
kat: Cyber Range
kurz: IP Address Management – Verwaltung, welche IP-Adressen und Netze vergeben bzw.

IP Address Management – Verwaltung, welche IP-Adressen und Netze vergeben bzw. frei sind (z. B. NetBox, phpIPAM, PVE-IPAM).

## iperf3
kat: Cyber Range
kurz: Werkzeug zur Messung des Netzwerkdurchsatzes zwischen zwei Endpunkten (TCP und UDP).

Werkzeug zur Messung des Netzwerkdurchsatzes zwischen zwei Endpunkten (TCP und UDP).

## IPMI
kat: Cyber Range
kurz: Intelligent Platform Management Interface – separater Management-Controller im Server (z.

Intelligent Platform Management Interface – separater Management-Controller im Server (z. B. iDRAC, iLO) zum Fernsteuern auch bei ausgeschaltetem Betriebssystem.

## JA4
kat: Cyber Range
kurz: Fingerabdruckverfahren für TLS-Clients (Nachfolger von JA3): aus den Parametern des ClientHello entsteht ein Hash, der z.

Fingerabdruckverfahren für TLS-Clients (Nachfolger von JA3): aus den Parametern des ClientHello entsteht ein Hash, der z. B. Malware-Familien erkennbar macht.

## Jeopardy
kat: Cyber Range
kurz: CTF-Format mit einer Aufgabentafel nach Kategorien (Web, Krypto, Forensik …); jede gelöste Aufgabe liefert eine Flagge und Punkte.

CTF-Format mit einer Aufgabentafel nach Kategorien (Web, Krypto, Forensik …); jede gelöste Aufgabe liefert eine Flagge und Punkte.

## Jitter
kat: Cyber Range
kurz: Zufällige Abweichung vom Grundintervall (z.

Zufällige Abweichung vom Grundintervall (z. B. 60 s ± 20 %), mit der Beacons ihre Regelmäßigkeit verschleiern.

## Job-Queue
kat: Cyber Range
kurz: Warteschlange, in die eine API Aufträge legt, die dann von Worker-Prozessen asynchron abgearbeitet werden (z.

Warteschlange, in die eine API Aufträge legt, die dann von Worker-Prozessen asynchron abgearbeitet werden (z. B. Redis, RabbitMQ).

## JWKS
kat: Cyber Range
kurz: JSON Web Key Set: vom Identity Provider veröffentlichte öffentliche Schlüssel, mit denen Anwendungen die Signatur von Tokens prüfen.

JSON Web Key Set: vom Identity Provider veröffentlichte öffentliche Schlüssel, mit denen Anwendungen die Signatur von Tokens prüfen.

## JWT
kat: Cyber Range
kurz: JSON Web Token: signiertes, Base64url-kodiertes Token aus Header, Nutzdaten (Claims) und Signatur; Grundlage von OIDC-ID-Tokens.

JSON Web Token: signiertes, Base64url-kodiertes Token aus Header, Nutzdaten (Claims) und Signatur; Grundlage von OIDC-ID-Tokens.

## Kea
kat: Cyber Range
kurz: DHCP-Server des ISC (Nachfolger von ISC DHCP), in aktuellen OPNsense-Versionen als DHCP-Dienst verfügbar.

DHCP-Server des ISC (Nachfolger von ISC DHCP), in aktuellen OPNsense-Versionen als DHCP-Dienst verfügbar.

## Kerberoasting
kat: Cyber Range
kurz: Angriff, bei dem ein Domänenbenutzer Service-Tickets für Dienstkonten anfordert und deren Passwort-Hash offline knackt (ATT&CK T1558.003).

Angriff, bei dem ein Domänenbenutzer Service-Tickets für Dienstkonten anfordert und deren Passwort-Hash offline knackt (ATT&CK T1558.003).

## Kerberos
kat: Cyber Range
kurz: Netzwerk-Authentifizierungsprotokoll (Port 88) in Active Directory, das mit verschlüsselten Tickets (TGT, Service-Tickets) statt Passwörtern arbeitet.

Netzwerk-Authentifizierungsprotokoll (Port 88) in Active Directory, das mit verschlüsselten Tickets (TGT, Service-Tickets) statt Passwörtern arbeitet.

## Keycloak
kat: Cyber Range
kurz: Open-Source-Identitätsanbieter für Single Sign-on über OpenID Connect und SAML, mit Benutzer-, Gruppen- und 2FA-Verwaltung.

Open-Source-Identitätsanbieter für Single Sign-on über OpenID Connect und SAML, mit Benutzer-, Gruppen- und 2FA-Verwaltung.

## Kill Chain
kat: Cyber Range
kurz: Modell der aufeinanderfolgenden Phasen eines Angriffs (Aufklärung, Zugang, Ausführung, Ausbreitung, Ziel); Verteidiger versuchen, die Kette früh zu unterbrechen.

Modell der aufeinanderfolgenden Phasen eines Angriffs (Aufklärung, Zugang, Ausführung, Ausbreitung, Ziel); Verteidiger versuchen, die Kette früh zu unterbrechen.

## Kill Switch
kat: Cyber Range
kurz: Not-Aus: vorbereiteter Mechanismus, mit dem die Übungsleitung alle Aktivitäten sofort anhalten oder Netze trennen kann.

Not-Aus: vorbereiteter Mechanismus, mit dem die Übungsleitung alle Aktivitäten sofort anhalten oder Netze trennen kann.

## KSM
kat: Cyber Range
kurz: Kernel Samepage Merging – der Linux-Kernel erkennt identische Speicherseiten verschiedener VMs und legt sie nur einmal ab; spart RAM bei vielen gleichen VMs.

Kernel Samepage Merging – der Linux-Kernel erkennt identische Speicherseiten verschiedener VMs und legt sie nur einmal ab; spart RAM bei vielen gleichen VMs.

## Kubelet
kat: Cyber Range
kurz: Agent auf jedem Kubernetes-Knoten, der Pods startet und überwacht; API auf Port 10250, die nie anonym erreichbar sein darf.

Agent auf jedem Kubernetes-Knoten, der Pods startet und überwacht; API auf Port 10250, die nie anonym erreichbar sein darf.

## Kubernetes
kat: Cyber Range
kurz: Plattform zur Orchestrierung von Containern: verteilt sie auf Knoten, startet sie neu, verbindet sie per Netz.

Plattform zur Orchestrierung von Containern: verteilt sie auf Knoten, startet sie neu, verbindet sie per Netz.

## KVM
kat: Cyber Range
kurz: Kernel-based Virtual Machine – Virtualisierungsmodul des Linux-Kernels, das Hardware-Virtualisierung der CPU nutzbar macht; Basis von Proxmox VE.

Kernel-based Virtual Machine – Virtualisierungsmodul des Linux-Kernels, das Hardware-Virtualisierung der CPU nutzbar macht; Basis von Proxmox VE.

## Lagebild
kat: Cyber Range
kurz: Verdichtete, aktuelle Übersicht über die Sicherheitslage (Vorfälle, betroffene Systeme, Maßnahmen) für Entscheider.

Verdichtete, aktuelle Übersicht über die Sicherheitslage (Vorfälle, betroffene Systeme, Maßnahmen) für Entscheider.

## Lateral Movement
kat: Cyber Range
kurz: Seitwärtsbewegung eines Angreifers von einem kompromittierten System zu weiteren Systemen im Netz.

Seitwärtsbewegung eines Angreifers von einem kompromittierten System zu weiteren Systemen im Netz.

## LDAP
kat: Cyber Range
kurz: Lightweight Directory Access Protocol (TCP/UDP 389, LDAPS 636) – Protokoll zum Abfragen und Ändern von Verzeichnisdiensten wie Active Directory.

Lightweight Directory Access Protocol (TCP/UDP 389, LDAPS 636) – Protokoll zum Abfragen und Ändern von Verzeichnisdiensten wie Active Directory.

## Lease
kat: Cyber Range
kurz: Befristete Zuteilung einer IP-Adresse durch DHCP; der Client muss sie vor Ablauf verlängern.

Befristete Zuteilung einer IP-Adresse durch DHCP; der Client muss sie vor Ablauf verlängern.

## Lieferkettenangriff
kat: Cyber Range
kurz: Angriff über einen Zulieferer oder eine Software-Abhängigkeit, z.

Angriff über einen Zulieferer oder eine Software-Abhängigkeit, z. B. ein manipuliertes Update oder Paket.

## Linked Clone
kat: Cyber Range
kurz: VM-Kopie, die nur auf ein Template verweist und ausschließlich ihre Änderungen speichert – in Sekunden erstellt, sehr platzsparend.

VM-Kopie, die nur auf ein Template verweist und ausschließlich ihre Änderungen speichert – in Sekunden erstellt, sehr platzsparend.

## Lint
kat: Cyber Range
kurz: Automatische statische Prüfung von Code oder Konfiguration auf Fehler und Stilverstöße (z.

Automatische statische Prüfung von Code oder Konfiguration auf Fehler und Stilverstöße (z. B. ansible-lint, tflint).

## Live-Fire
kat: Cyber Range
kurz: Übungsform, in der echte Angriffe mit echten Werkzeugen auf echte (virtuelle) Systeme ausgeführt werden.

Übungsform, in der echte Angriffe mit echten Werkzeugen auf echte (virtuelle) Systeme ausgeführt werden.

## Live-Migration
kat: Cyber Range
kurz: Verschieben einer laufenden VM auf einen anderen Host ohne Unterbrechung; der Arbeitsspeicher wird im Hintergrund kopiert.

Verschieben einer laufenden VM auf einen anderen Host ohne Unterbrechung; der Arbeitsspeicher wird im Hintergrund kopiert.

## LLMNR
kat: Cyber Range
kurz: Link-Local Multicast Name Resolution: Windows-Rückfallmechanismus zur Namensauflösung per Multicast (UDP 5355), wenn DNS keine Antwort hat – leicht zu fälschen.

Link-Local Multicast Name Resolution: Windows-Rückfallmechanismus zur Namensauflösung per Multicast (UDP 5355), wenn DNS keine Antwort hat – leicht zu fälschen.

## Logstash
kat: Cyber Range
kurz: Datenverarbeitungs-Pipeline von Elastic, die Logs entgegennimmt, zerlegt (parst), anreichert und in Elasticsearch schreibt.

Datenverarbeitungs-Pipeline von Elastic, die Logs entgegennimmt, zerlegt (parst), anreichert und in Elasticsearch schreibt.

## LSASS
kat: Cyber Range
kurz: Local Security Authority Subsystem Service (lsass.exe) – Windows-Prozess, der Anmeldungen verarbeitet und Anmeldedaten im Speicher hält; beliebtes Ziel von Credential Dumping.

Local Security Authority Subsystem Service (lsass.exe) – Windows-Prozess, der Anmeldungen verarbeitet und Anmeldedaten im Speicher hält; beliebtes Ziel von Credential Dumping.

## LXC
kat: Cyber Range
kurz: Linux Containers – Container-Technik, die in Proxmox VE neben VMs angeboten wird.

Linux Containers – Container-Technik, die in Proxmox VE neben VMs angeboten wird.

## MAC-Adresse
kat: Cyber Range
kurz: Hardware-Adresse einer Netzwerkschnittstelle (48 Bit, z.

Hardware-Adresse einer Netzwerkschnittstelle (48 Bit, z. B. bc:24:11:aa:bb:01), mit der Frames auf Layer 2 zugestellt werden.

## Malware
kat: Cyber Range
kurz: Schadsoftware – Programme mit schädlicher Absicht (Trojaner, Ransomware, Würmer, Backdoors).

Schadsoftware – Programme mit schädlicher Absicht (Trojaner, Ransomware, Würmer, Backdoors).

## Mandantenfähigkeit
kat: Cyber Range
kurz: Fähigkeit einer Plattform, mehrere voneinander getrennte Nutzergruppen (Mandanten, z.

Fähigkeit einer Plattform, mehrere voneinander getrennte Nutzergruppen (Mandanten, z. B. Teams) gleichzeitig zu bedienen, ohne dass sie sich sehen.

## Mapper
kat: Cyber Range
kurz: Keycloak-Funktion, die festlegt, welche Informationen (z.

Keycloak-Funktion, die festlegt, welche Informationen (z. B. Gruppen) als Claim in ein Token geschrieben werden.

## MFA
kat: Cyber Range
kurz: Multi-Faktor-Authentifizierung: Anmeldung mit mindestens zwei unabhängigen Faktoren (Wissen, Besitz, Biometrie), z.

Multi-Faktor-Authentifizierung: Anmeldung mit mindestens zwei unabhängigen Faktoren (Wissen, Besitz, Biometrie), z. B. Passwort + TOTP-Code.

## Mimikatz
kat: Cyber Range
kurz: Bekanntes Werkzeug, das Passwort-Hashes, Klartext-Passwörter und Kerberos-Tickets aus dem Speicher des LSASS-Prozesses ausliest.

Bekanntes Werkzeug, das Passwort-Hashes, Klartext-Passwörter und Kerberos-Tickets aus dem Speicher des LSASS-Prozesses ausliest.

## Modbus
kat: Cyber Range
kurz: Einfaches Industrieprotokoll (1979) für das Lesen/Schreiben von Registern und Spulen; als Modbus TCP auf Port 502, ohne Authentifizierung.

Einfaches Industrieprotokoll (1979) für das Lesen/Schreiben von Registern und Spulen; als Modbus TCP auf Port 502, ohne Authentifizierung.

## Modul (OpenTofu)
kat: Cyber Range
kurz: Wiederverwendbarer Baustein aus OpenTofu-Code mit Eingaben (Variablen) und Ausgaben (Outputs), z.

Wiederverwendbarer Baustein aus OpenTofu-Code mit Eingaben (Variablen) und Ausgaben (Outputs), z. B. »eine VM« oder »ein Netz«.

## MON
kat: Cyber Range
kurz: Ceph-Monitor: hält die Cluster-Karte (welche OSDs gibt es, wo liegen Daten) und bildet per Mehrheitsentscheid das Quorum.

Ceph-Monitor: hält die Cluster-Karte (welche OSDs gibt es, wo liegen Daten) und bildet per Mehrheitsentscheid das Quorum.

## MSEL
kat: Cyber Range
kurz: Master Scenario Events List – zeitlich geordnete Liste aller geplanten Ereignisse (Injects) einer Übung mit erwarteter Reaktion.

Master Scenario Events List – zeitlich geordnete Liste aller geplanten Ereignisse (Injects) einer Übung mit erwarteter Reaktion.

## MSL
kat: Cyber Range
kurz: Maximum Segment Lifetime: angenommene Höchstlebensdauer eines TCP-Segments im Netz; TIME_WAIT dauert 2 × MSL.

Maximum Segment Lifetime: angenommene Höchstlebensdauer eines TCP-Segments im Netz; TIME_WAIT dauert 2 × MSL.

## MSS
kat: Cyber Range
kurz: Maximum Segment Size: größte Nutzlast eines TCP-Segments, die beim Verbindungsaufbau ausgehandelt wird (bei MTU 1500 meist 1460 Byte).

Maximum Segment Size: größte Nutzlast eines TCP-Segments, die beim Verbindungsaufbau ausgehandelt wird (bei MTU 1500 meist 1460 Byte).

## MTTD
kat: Cyber Range
kurz: Mean Time to Detect – durchschnittliche Zeit vom Beginn eines Angriffs bis zu seiner Erkennung.

Mean Time to Detect – durchschnittliche Zeit vom Beginn eines Angriffs bis zu seiner Erkennung.

## MTTR
kat: Cyber Range
kurz: Mean Time to Respond/Recover – durchschnittliche Zeit von der Erkennung bis zur Eindämmung bzw.

Mean Time to Respond/Recover – durchschnittliche Zeit von der Erkennung bis zur Eindämmung bzw. Wiederherstellung.

## MTU
kat: Cyber Range
kurz: Maximum Transmission Unit – größte Paketgröße, die ohne Fragmentierung übertragen wird (Ethernet-Standard: 1500 Byte).

Maximum Transmission Unit – größte Paketgröße, die ohne Fragmentierung übertragen wird (Ethernet-Standard: 1500 Byte).

## NAT
kat: Cyber Range
kurz: Network Address Translation – Umschreiben von IP-Adressen/Ports beim Durchlaufen eines Routers (SNAT für ausgehenden, DNAT/Port-Forward für eingehenden Verkehr).

Network Address Translation – Umschreiben von IP-Adressen/Ports beim Durchlaufen eines Routers (SNAT für ausgehenden, DNAT/Port-Forward für eingehenden Verkehr).

## Nested Virtualization
kat: Cyber Range
kurz: Verschachtelte Virtualisierung – ein Hypervisor läuft selbst in einer VM (z.

Verschachtelte Virtualisierung – ein Hypervisor läuft selbst in einer VM (z. B. Proxmox in Proxmox); funktioniert, kostet aber Leistung.

## NetBIOS
kat: Cyber Range
kurz: Altes Namens- und Sitzungsprotokoll von Windows (NBT-NS, UDP 137); wie LLMNR anfällig für gefälschte Antworten.

Altes Namens- und Sitzungsprotokoll von Windows (NBT-NS, UDP 137); wie LLMNR anfällig für gefälschte Antworten.

## Netfilter
kat: Cyber Range
kurz: Paketfilter-Framework im Linux-Kernel mit festen Eingriffspunkten (Hooks), an denen iptables/nftables Regeln anwenden.

Paketfilter-Framework im Linux-Kernel mit festen Eingriffspunkten (Hooks), an denen iptables/nftables Regeln anwenden.

## nftables
kat: Cyber Range
kurz: Moderner Nachfolger von iptables zur Konfiguration von Netfilter-Regeln im Linux-Kernel.

Moderner Nachfolger von iptables zur Konfiguration von Netfilter-Regeln im Linux-Kernel.

## NIC
kat: Cyber Range
kurz: Network Interface Card – Netzwerkkarte (physisch oder virtuell).

Network Interface Card – Netzwerkkarte (physisch oder virtuell).

## NICE Framework
kat: Cyber Range
kurz: NIST-Rahmenwerk (SP 800-181) für Cybersecurity-Rollen mit Aufgaben-, Wissens- und Fähigkeitsbeschreibungen (TKS); Version 2.0.0 erschien im März 2025.

NIST-Rahmenwerk (SP 800-181) für Cybersecurity-Rollen mit Aufgaben-, Wissens- und Fähigkeitsbeschreibungen (TKS); Version 2.0.0 erschien im März 2025.

## NoCloud
kat: Cyber Range
kurz: Datenquelle von cloud-init, bei der die Konfiguration von einem lokalen Datenträger statt von einem Cloud-Metadatendienst gelesen wird.

Datenquelle von cloud-init, bei der die Konfiguration von einem lokalen Datenträger statt von einem Cloud-Metadatendienst gelesen wird.

## NPC
kat: Cyber Range
kurz: Non-Player Character – simulierter Benutzer, der automatisch »normale« Tätigkeiten ausführt und so realistischen Hintergrundverkehr erzeugt.

Non-Player Character – simulierter Benutzer, der automatisch »normale« Tätigkeiten ausführt und so realistischen Hintergrundverkehr erzeugt.

## NSM
kat: Cyber Range
kurz: Network Security Monitoring – systematisches Erfassen und Auswerten von Netzwerkverkehr zur Angriffserkennung.

Network Security Monitoring – systematisches Erfassen und Auswerten von Netzwerkverkehr zur Angriffserkennung.

## NTLM
kat: Cyber Range
kurz: Älteres Microsoft-Authentifizierungsprotokoll (Challenge-Response), anfällig für Pass-the-Hash und Relay-Angriffe.

Älteres Microsoft-Authentifizierungsprotokoll (Challenge-Response), anfällig für Pass-the-Hash und Relay-Angriffe.

## NTLM-Relay
kat: Cyber Range
kurz: Angriff, bei dem eine abgefangene NTLM-Anmeldung in Echtzeit an einen anderen Server weitergereicht wird, um sich dort als Opfer anzumelden.

Angriff, bei dem eine abgefangene NTLM-Anmeldung in Echtzeit an einen anderen Server weitergereicht wird, um sich dort als Opfer anzumelden.

## NTP
kat: Cyber Range
kurz: Network Time Protocol (UDP 123) – synchronisiert die Uhrzeit von Systemen; Grundvoraussetzung für Log-Korrelation und Kerberos.

Network Time Protocol (UDP 123) – synchronisiert die Uhrzeit von Systemen; Grundvoraussetzung für Log-Korrelation und Kerberos.

## NUMA
kat: Cyber Range
kurz: Non-Uniform Memory Access: Bei Servern mit mehreren CPU-Sockeln hat jeder Sockel »eigenen« Arbeitsspeicher.

Non-Uniform Memory Access: Bei Servern mit mehreren CPU-Sockeln hat jeder Sockel »eigenen« Arbeitsspeicher. Zugriffe auf den Speicher des anderen Sockels sind langsamer.

## NVMe
kat: Cyber Range
kurz: Non-Volatile Memory Express: Protokoll für SSDs, die direkt am PCIe-Bus hängen.

Non-Volatile Memory Express: Protokoll für SSDs, die direkt am PCIe-Bus hängen. Deutlich mehr IOPS und geringere Latenz als SATA-SSDs.

## OCI
kat: Cyber Range
kurz: Open Container Initiative: Standard für Container-Images und -Laufzeiten; Proxmox VE 9.1 kann OCI-Images als Basis für Container nutzen.

Open Container Initiative: Standard für Container-Images und -Laufzeiten; Proxmox VE 9.1 kann OCI-Images als Basis für Container nutzen.

## OIDC
kat: Cyber Range
kurz: OpenID Connect – auf OAuth 2.0 aufbauendes Protokoll für Single Sign-on: der Identitätsanbieter bestätigt per signiertem Token, wer der Benutzer ist.

OpenID Connect – auf OAuth 2.0 aufbauendes Protokoll für Single Sign-on: der Identitätsanbieter bestätigt per signiertem Token, wer der Benutzer ist.

## OOB
kat: Cyber Range
kurz: Out-of-Band-Management – Verwaltungszugang über einen getrennten Kanal (IPMI, KVM-over-IP), der auch funktioniert, wenn das Hauptsystem nicht läuft.

Out-of-Band-Management – Verwaltungszugang über einen getrennten Kanal (IPMI, KVM-over-IP), der auch funktioniert, wenn das Hauptsystem nicht läuft.

## OPC UA
kat: Cyber Range
kurz: Open Platform Communications Unified Architecture: moderner, sicherheitsfähiger Industriestandard für Datenaustausch (Standardport 4840).

Open Platform Communications Unified Architecture: moderner, sicherheitsfähiger Industriestandard für Datenaustausch (Standardport 4840).

## OpenStack
kat: Cyber Range
kurz: Open-Source-Cloud-Plattform für große Rechenzentren (Compute, Netz, Storage als Dienste); Basis von KYPO/CyberRangeCZ.

Open-Source-Cloud-Plattform für große Rechenzentren (Compute, Netz, Storage als Dienste); Basis von KYPO/CyberRangeCZ.

## OpenTofu
kat: Cyber Range
kurz: Quelloffene Abspaltung von Terraform (Linux Foundation), kompatibel zu Terraform-Konfigurationen und -Providern.

Quelloffene Abspaltung von Terraform (Linux Foundation), kompatibel zu Terraform-Konfigurationen und -Providern.

## OPNsense
kat: Cyber Range
kurz: Open-Source-Firewall- und Router-Distribution auf FreeBSD-Basis mit Weboberfläche, Paketfilter pf, VPN, DNS und DHCP.

Open-Source-Firewall- und Router-Distribution auf FreeBSD-Basis mit Weboberfläche, Paketfilter pf, VPN, DNS und DHCP.

## OSD
kat: Cyber Range
kurz: Object Storage Daemon: Ceph-Dienst, der genau einen Datenträger verwaltet und Daten repliziert.

Object Storage Daemon: Ceph-Dienst, der genau einen Datenträger verwaltet und Daten repliziert.

## OU
kat: Cyber Range
kurz: Organizational Unit (Organisationseinheit): Container im Active Directory zum Strukturieren von Benutzern und Computern; an OUs werden Gruppenrichtlinien gebunden.

Organizational Unit (Organisationseinheit): Container im Active Directory zum Strukturieren von Benutzern und Computern; an OUs werden Gruppenrichtlinien gebunden.

## Overcommit
kat: Cyber Range
kurz: Überbuchung – den VMs zusammen mehr virtuelle Ressourcen zuweisen, als physisch vorhanden sind (bei CPU unkritisch, bei RAM riskant).

Überbuchung – den VMs zusammen mehr virtuelle Ressourcen zuweisen, als physisch vorhanden sind (bei CPU unkritisch, bei RAM riskant).

## Overlay
kat: Cyber Range
kurz: Logisches Netz, das über ein bestehendes physisches Netz (Underlay) gelegt wird, z.

Logisches Netz, das über ein bestehendes physisches Netz (Underlay) gelegt wird, z. B. per VXLAN-Tunnel.

## OVMF
kat: Cyber Range
kurz: Open Virtual Machine Firmware: UEFI-Firmware für virtuelle Maschinen; nötig für Secure Boot und Windows 11.

Open Virtual Machine Firmware: UEFI-Firmware für virtuelle Maschinen; nötig für Secure Boot und Windows 11.

## Packer
kat: Cyber Range
kurz: HashiCorp-Werkzeug, das aus einer Konfigurationsdatei automatisch VM-Templates (Golden Images) baut.

HashiCorp-Werkzeug, das aus einer Konfigurationsdatei automatisch VM-Templates (Golden Images) baut.

## Paravirtualisierung
kat: Cyber Range
kurz: Der Gast weiß, dass er virtualisiert ist, und nutzt optimierte Treiber (VirtIO) statt emulierter Hardware – deutlich schneller.

Der Gast weiß, dass er virtualisiert ist, und nutzt optimierte Treiber (VirtIO) statt emulierter Hardware – deutlich schneller.

## Pass-the-Hash
kat: Cyber Range
kurz: Anmeldung an Windows-Systemen mit einem gestohlenen NTLM-Hash statt des Klartext-Passworts.

Anmeldung an Windows-Systemen mit einem gestohlenen NTLM-Hash statt des Klartext-Passworts.

## PCAP
kat: Cyber Range
kurz: Packet Capture – Dateiformat bzw.

Packet Capture – Dateiformat bzw. Vorgang des vollständigen Mitschneidens von Netzwerkpaketen (z. B. mit tcpdump oder Wireshark).

## PCIe
kat: Cyber Range
kurz: PCI Express: serieller Hochgeschwindigkeitsbus, über den Netzwerkkarten, NVMe-SSDs und GPUs an die CPU angebunden sind.

PCI Express: serieller Hochgeschwindigkeitsbus, über den Netzwerkkarten, NVMe-SSDs und GPUs an die CPU angebunden sind. Die Bandbreite hängt von Generation und Anzahl der Lanes ab.

## Persistence
kat: Cyber Range
kurz: Maßnahmen eines Angreifers, um nach Neustart oder Passwortwechsel Zugriff zu behalten (z.

Maßnahmen eines Angreifers, um nach Neustart oder Passwortwechsel Zugriff zu behalten (z. B. geplante Aufgaben, Dienste, Run-Keys).

## Persona
kat: Cyber Range
kurz: Ausgedachte, typische Person mit Rolle, Gewohnheiten und Tagesablauf, nach der das Verhalten simulierter Benutzer gestaltet wird.

Ausgedachte, typische Person mit Rolle, Gewohnheiten und Tagesablauf, nach der das Verhalten simulierter Benutzer gestaltet wird.

## pf
kat: Cyber Range
kurz: Packet Filter – der Paketfilter von OpenBSD/FreeBSD, auf dem die Firewall von OPNsense und pfSense basiert.

Packet Filter – der Paketfilter von OpenBSD/FreeBSD, auf dem die Firewall von OPNsense und pfSense basiert.

## Phishing
kat: Cyber Range
kurz: Täuschungsangriff per E-Mail oder Nachricht, um Empfänger zum Öffnen schädlicher Anhänge/Links oder zur Preisgabe von Zugangsdaten zu bringen.

Täuschungsangriff per E-Mail oder Nachricht, um Empfänger zum Öffnen schädlicher Anhänge/Links oder zur Preisgabe von Zugangsdaten zu bringen.

## Pipeline
kat: Cyber Range
kurz: Automatisch ablaufende Folge von Prüf- und Bauschritten (z.

Automatisch ablaufende Folge von Prüf- und Bauschritten (z. B. Lint, Plan, Apply, Test), ausgelöst durch einen Commit.

## Pivoting
kat: Cyber Range
kurz: Nutzen eines bereits übernommenen Systems als Sprungbrett in weitere, sonst unerreichbare Netzsegmente.

Nutzen eines bereits übernommenen Systems als Sprungbrett in weitere, sonst unerreichbare Netzsegmente.

## PKCE
kat: Cyber Range
kurz: Proof Key for Code Exchange: Erweiterung des OAuth-Code-Flows, bei der der Client einen Zufallswert nachweist; verhindert das Abfangen des Autorisierungscodes.

Proof Key for Code Exchange: Erweiterung des OAuth-Code-Flows, bei der der Client einen Zufallswert nachweist; verhindert das Abfangen des Autorisierungscodes.

## PKI
kat: Cyber Range
kurz: Public Key Infrastructure: System aus Zertifizierungsstellen, Zertifikaten und Regeln, mit dem die Echtheit von Servern, Personen oder Software digital bestätigt wird.

Public Key Infrastructure: System aus Zertifizierungsstellen, Zertifikaten und Regeln, mit dem die Echtheit von Servern, Personen oder Software digital bestätigt wird.

## Playbook
kat: Cyber Range
kurz: Ansible-Datei (YAML), die beschreibt, welche Aufgaben auf welchen Systemen in welcher Reihenfolge ausgeführt werden.

Ansible-Datei (YAML), die beschreibt, welche Aufgaben auf welchen Systemen in welcher Reihenfolge ausgeführt werden.

## Playbook (IR)
kat: Cyber Range
kurz: Festgelegte Schrittfolge für die Reaktion auf einen bestimmten Vorfalltyp (z.

Festgelegte Schrittfolge für die Reaktion auf einen bestimmten Vorfalltyp (z. B. Phishing, Ransomware).

## Pod
kat: Cyber Range
kurz: Kleinste Einheit in Kubernetes: ein oder mehrere Container mit gemeinsamer IP-Adresse und gemeinsamen Volumes.

Kleinste Einheit in Kubernetes: ein oder mehrere Container mit gemeinsamer IP-Adresse und gemeinsamen Volumes.

## Pool
kat: Cyber Range
kurz: Gruppe gleichartiger, vorab erzeugter Sandboxes, aus der Teilnehmern bei Übungsbeginn sofort eine zugewiesen wird.

Gruppe gleichartiger, vorab erzeugter Sandboxes, aus der Teilnehmern bei Übungsbeginn sofort eine zugewiesen wird.

## Port
kat: Cyber Range
kurz: 16-Bit-Nummer (0–65535) bei TCP/UDP, die einen Dienst auf einem Rechner adressiert (z.

16-Bit-Nummer (0–65535) bei TCP/UDP, die einen Dienst auf einem Rechner adressiert (z. B. 443 = HTTPS).

## PostgreSQL
kat: Cyber Range
kurz: Leistungsfähige quelloffene relationale Datenbank; genutzt von GHOSTS, Keycloak, Gitea und eigenen Portalen.

Leistungsfähige quelloffene relationale Datenbank; genutzt von GHOSTS, Keycloak, Gitea und eigenen Portalen.

## Privilege Escalation
kat: Cyber Range
kurz: Rechteausweitung: vom normalen Benutzer zu Administrator/root, z.

Rechteausweitung: vom normalen Benutzer zu Administrator/root, z. B. über falsch gesetzte SUID-Bits oder sudo-Regeln.

## Prometheus
kat: Cyber Range
kurz: Quelloffenes Monitoring-System, das Metriken per HTTP abfragt (»scrapt«) und als Zeitreihen speichert; Anzeige meist mit Grafana.

Quelloffenes Monitoring-System, das Metriken per HTTP abfragt (»scrapt«) und als Zeitreihen speichert; Anzeige meist mit Grafana.

## Provider
kat: Cyber Range
kurz: Plugin für Terraform/OpenTofu, das eine bestimmte Plattform-API anspricht (z.

Plugin für Terraform/OpenTofu, das eine bestimmte Plattform-API anspricht (z. B. bpg/proxmox für Proxmox VE).

## Proxmox Backup Server
kat: Cyber Range
kurz: Backup-Lösung von Proxmox mit inkrementellen, deduplizierten und verschlüsselten Sicherungen; Version 4 basiert auf Debian 13.

Backup-Lösung von Proxmox mit inkrementellen, deduplizierten und verschlüsselten Sicherungen; Version 4 basiert auf Debian 13.

## Proxmox VE
kat: Cyber Range
kurz: Open-Source-Virtualisierungsplattform auf Debian-Basis mit KVM-VMs, LXC-Containern, Weboberfläche, REST-API, Cluster und SDN.

Open-Source-Virtualisierungsplattform auf Debian-Basis mit KVM-VMs, LXC-Containern, Weboberfläche, REST-API, Cluster und SDN.

## PSI
kat: Cyber Range
kurz: Pressure Stall Information: Linux-Kennzahlen (/proc/pressure/cpu, memory, io), wie viel Zeit Prozesse auf eine Ressource warten.

Pressure Stall Information: Linux-Kennzahlen (/proc/pressure/cpu, memory, io), wie viel Zeit Prozesse auf eine Ressource warten.

## Pull Request
kat: Cyber Range
kurz: Änderungsvorschlag in einem Git-Server (bei Gitea auch Merge Request genannt), der vor dem Zusammenführen geprüft und freigegeben wird.

Änderungsvorschlag in einem Git-Server (bei Gitea auch Merge Request genannt), der vor dem Zusammenführen geprüft und freigegeben wird.

## Purdue-Modell
kat: Cyber Range
kurz: Referenzmodell für industrielle Netze mit Ebenen von Level 0 (Prozess) bis Level 5 (Unternehmen) und einer Industrie-DMZ (Level 3.5).

Referenzmodell für industrielle Netze mit Ebenen von Level 0 (Prozess) bis Level 5 (Unternehmen) und einer Industrie-DMZ (Level 3.5).

## Purple Team
kat: Cyber Range
kurz: Gemeinsames Team oder Format aus Angreifern und Verteidigern, die offen zusammenarbeiten, um die Erkennung zu verbessern.

Gemeinsames Team oder Format aus Angreifern und Verteidigern, die offen zusammenarbeiten, um die Erkennung zu verbessern.

## Purple Teaming
kat: Cyber Range
kurz: Zusammenarbeit von Red und Blue Team in einer offenen Schleife: Angriffstechnik ausführen, Erkennung prüfen, sofort verbessern.

Zusammenarbeit von Red und Blue Team in einer offenen Schleife: Angriffstechnik ausführen, Erkennung prüfen, sofort verbessern.

## PVID
kat: Cyber Range
kurz: Port VLAN ID – die VLAN-Nummer, der ungetaggte Frames an einem Bridge-/Switch-Port zugeordnet werden (Access-Port).

Port VLAN ID – die VLAN-Nummer, der ungetaggte Frames an einem Bridge-/Switch-Port zugeordnet werden (Access-Port).

## q35
kat: Cyber Range
kurz: Moderner virtueller Chipsatz in QEMU mit PCIe-Unterstützung; empfohlen für Windows-VMs und Geräte-Durchreichung.

Moderner virtueller Chipsatz in QEMU mit PCIe-Unterstützung; empfohlen für Windows-VMs und Geräte-Durchreichung.

## QEMU
kat: Cyber Range
kurz: Open-Source-Emulator/Virtualisierer; stellt mit KVM die virtuelle Hardware (Platten, Netzwerkkarten, Konsole) einer VM bereit.

Open-Source-Emulator/Virtualisierer; stellt mit KVM die virtuelle Hardware (Platten, Netzwerkkarten, Konsole) einer VM bereit.

## QEMU Guest Agent
kat: Cyber Range
kurz: Dienst in der VM, über den der Host z.

Dienst in der VM, über den der Host z. B. IP-Adressen abfragen, Dateisysteme für Snapshots einfrieren und sauber herunterfahren kann.

## QMP
kat: Cyber Range
kurz: QEMU Machine Protocol: JSON-basierte Steuerschnittstelle eines QEMU-Prozesses, über die Proxmox Snapshots, Hotplug oder Migration auslöst.

QEMU Machine Protocol: JSON-basierte Steuerschnittstelle eines QEMU-Prozesses, über die Proxmox Snapshots, Hotplug oder Migration auslöst.

## Quorum
kat: Cyber Range
kurz: Mehrheit der Stimmen in einem Cluster; nur die Seite mit Quorum darf Änderungen vornehmen – verhindert »Split Brain«.

Mehrheit der Stimmen in einem Cluster; nur die Seite mit Quorum darf Änderungen vornehmen – verhindert »Split Brain«.

## Quote
kat: Cyber Range
kurz: Obergrenze für Ressourcen (CPU, RAM, Speicher, Anzahl VMs), die ein Team, Pool oder Kurs belegen darf.

Obergrenze für Ressourcen (CPU, RAM, Speicher, Anzahl VMs), die ein Team, Pool oder Kurs belegen darf.

## RACI
kat: Cyber Range
kurz: Matrix zur Zuordnung von Verantwortlichkeiten: Responsible (führt aus), Accountable (verantwortet), Consulted (wird gefragt), Informed (wird informiert).

Matrix zur Zuordnung von Verantwortlichkeiten: Responsible (führt aus), Accountable (verantwortet), Consulted (wird gefragt), Informed (wird informiert).

## RAID-Z
kat: Cyber Range
kurz: Software-RAID von ZFS mit einfacher (Z1), doppelter (Z2) oder dreifacher (Z3) Parität.

Software-RAID von ZFS mit einfacher (Z1), doppelter (Z2) oder dreifacher (Z3) Parität. Für VM-Speicher sind Mirror-Verbünde wegen höherer IOPS meist besser.

## Ransomware
kat: Cyber Range
kurz: Schadsoftware, die Daten verschlüsselt und Lösegeld für die Entschlüsselung fordert.

Schadsoftware, die Daten verschlüsselt und Lösegeld für die Entschlüsselung fordert.

## RBAC
kat: Cyber Range
kurz: Role-Based Access Control – Rechte werden Rollen zugeordnet, Benutzer erhalten Rollen (z.

Role-Based Access Control – Rechte werden Rollen zugeordnet, Benutzer erhalten Rollen (z. B. »blue-1« darf nur die eigenen VMs sehen).

## RBD
kat: Cyber Range
kurz: RADOS Block Device: virtuelle Festplatte, die in Ceph verteilt gespeichert wird; Proxmox nutzt RBD als VM-Disk.

RADOS Block Device: virtuelle Festplatte, die in Ceph verteilt gespeichert wird; Proxmox nutzt RBD als VM-Disk.

## RCE
kat: Cyber Range
kurz: Remote Code Execution: Ausführen beliebigen Codes auf einem fremden System über das Netz – die schwerste Schwachstellenklasse.

Remote Code Execution: Ausführen beliebigen Codes auf einem fremden System über das Netz – die schwerste Schwachstellenklasse.

## RDP
kat: Cyber Range
kurz: Remote Desktop Protocol (TCP 3389) – Microsoft-Protokoll für grafische Fernzugriffe auf Windows-Systeme.

Remote Desktop Protocol (TCP 3389) – Microsoft-Protokoll für grafische Fernzugriffe auf Windows-Systeme.

## Realm
kat: Cyber Range
kurz: In Keycloak ein abgeschlossener Bereich mit eigenen Benutzern, Gruppen, Anwendungen (Clients) und Einstellungen.

In Keycloak ein abgeschlossener Bereich mit eigenen Benutzern, Gruppen, Anwendungen (Clients) und Einstellungen.

## Red Team
kat: Cyber Range
kurz: Gruppe, die in einer Übung die Rolle der Angreifer übernimmt.

Gruppe, die in einer Übung die Rolle der Angreifer übernimmt.

## Regelkreis
kat: Cyber Range
kurz: Steuerung, die einen Messwert (z.

Steuerung, die einen Messwert (z. B. Füllstand) laufend erfasst und Stellglieder (z. B. Ventil) so verändert, dass ein Sollwert eingehalten wird.

## Reifegradmodell
kat: Cyber Range
kurz: Stufenmodell, das beschreibt, wie weit eine Fähigkeit entwickelt ist (z.

Stufenmodell, das beschreibt, wie weit eine Fähigkeit entwickelt ist (z. B. von »nicht vorhanden« bis »optimiert«).

## Rekursiver Resolver
kat: Cyber Range
kurz: DNS-Server, der eine Anfrage stellvertretend für den Client bis zur endgültigen Antwort auflöst (Root → TLD → autoritativer Server) und das Ergebnis zwischenspeichert.

DNS-Server, der eine Anfrage stellvertretend für den Client bis zur endgültigen Antwort auflöst (Root → TLD → autoritativer Server) und das Ergebnis zwischenspeichert.

## Remote-Logging
kat: Cyber Range
kurz: Weiterleitung von Protokollen an einen zentralen Server (z.

Weiterleitung von Protokollen an einen zentralen Server (z. B. per Syslog), damit sie auch bei Kompromittierung des Quellsystems erhalten bleiben.

## Responder
kat: Cyber Range
kurz: Werkzeug, das LLMNR-/NBT-NS-Anfragen beantwortet, um Anmeldedaten abzufangen; Standardwerkzeug in AD-Übungen.

Werkzeug, das LLMNR-/NBT-NS-Anfragen beantwortet, um Anmeldedaten abzufangen; Standardwerkzeug in AD-Übungen.

## REST
kat: Cyber Range
kurz: Architekturstil für Web-APIs: Ressourcen werden über URLs adressiert und mit HTTP-Methoden (GET, POST, PUT, DELETE) bearbeitet.

Architekturstil für Web-APIs: Ressourcen werden über URLs adressiert und mit HTTP-Methoden (GET, POST, PUT, DELETE) bearbeitet.

## RFC 5424
kat: Cyber Range
kurz: Aktueller Standard für das Syslog-Nachrichtenformat mit Priorität, Version, Zeitstempel (inkl.

Aktueller Standard für das Syslog-Nachrichtenformat mit Priorität, Version, Zeitstempel (inkl. Zeitzone), Host, Anwendung und strukturierten Daten.

## RoE
kat: Cyber Range
kurz: Rules of Engagement – verbindliche Regeln einer Übung: Was ist Ziel, was ist verboten, wann darf angegriffen werden?.

Rules of Engagement – verbindliche Regeln einer Übung: Was ist Ziel, was ist verboten, wann darf angegriffen werden?

## Root-CA
kat: Cyber Range
kurz: Oberste Zertifizierungsstelle einer PKI.

Oberste Zertifizierungsstelle einer PKI. Ihr selbstsigniertes Zertifikat ist der »Vertrauensanker«; sie sollte offline aufbewahrt werden.

## Root-Hints
kat: Cyber Range
kurz: Liste der IP-Adressen der DNS-Root-Server, mit der ein Resolver seine Rekursion beginnt.

Liste der IP-Adressen der DNS-Root-Server, mit der ein Resolver seine Rekursion beginnt. Im SINET zeigt sie auf eigene, simulierte Root-Server.

## RPO
kat: Cyber Range
kurz: Recovery Point Objective: maximal tolerierter Datenverlust in Zeit (z.

Recovery Point Objective: maximal tolerierter Datenverlust in Zeit (z. B. »höchstens die Änderungen der letzten 24 Stunden«).

## RST
kat: Cyber Range
kurz: Reset-Flag im TCP-Header: bricht eine Verbindung sofort ab, z.

Reset-Flag im TCP-Header: bricht eine Verbindung sofort ab, z. B. wenn auf einem Port kein Dienst lauscht.

## RTO
kat: Cyber Range
kurz: Recovery Time Objective: maximal tolerierte Zeit bis zur Wiederherstellung eines Dienstes.

Recovery Time Objective: maximal tolerierte Zeit bis zur Wiederherstellung eines Dienstes.

## Runbook
kat: Cyber Range
kurz: Schritt-für-Schritt-Anleitung für einen wiederkehrenden Betriebsvorgang, z.

Schritt-für-Schritt-Anleitung für einen wiederkehrenden Betriebsvorgang, z. B. »Range zurücksetzen« oder »Agent neu registrieren«.

## S7comm
kat: Cyber Range
kurz: Proprietäres Protokoll von Siemens-S7-Steuerungen, transportiert über ISO-on-TCP (RFC 1006) auf Port 102.

Proprietäres Protokoll von Siemens-S7-Steuerungen, transportiert über ISO-on-TCP (RFC 1006) auf Port 102.

## SACL
kat: Cyber Range
kurz: System Access Control List: Teil der Berechtigungen eines Objekts, der festlegt, welche Zugriffe protokolliert werden.

System Access Control List: Teil der Berechtigungen eines Objekts, der festlegt, welche Zugriffe protokolliert werden.

## Sandbox
kat: Cyber Range
kurz: Isolierte, eigenständige Umgebung; in einer Cyber Range die vollständige Übungsumgebung eines Teilnehmers oder Teams.

Isolierte, eigenständige Umgebung; in einer Cyber Range die vollständige Übungsumgebung eines Teilnehmers oder Teams.

## Sandbox-Definition
kat: Cyber Range
kurz: In KYPO ein Git-Repository mit Topologie-Datei (topology.yml), Variablen und Provisionierungs-Playbook, aus dem identische Sandboxes erzeugt werden.

In KYPO ein Git-Repository mit Topologie-Datei (topology.yml), Variablen und Provisionierungs-Playbook, aus dem identische Sandboxes erzeugt werden.

## SBOM
kat: Cyber Range
kurz: Software Bill of Materials: maschinenlesbare Liste aller Komponenten und Abhängigkeiten einer Software.

Software Bill of Materials: maschinenlesbare Liste aller Komponenten und Abhängigkeiten einer Software.

## SCA
kat: Cyber Range
kurz: Security Configuration Assessment: Wazuh-Modul, das Systeme gegen Härtungsrichtlinien (z.

Security Configuration Assessment: Wazuh-Modul, das Systeme gegen Härtungsrichtlinien (z. B. CIS Benchmarks) prüft.

## SCADA
kat: Cyber Range
kurz: Supervisory Control and Data Acquisition: System zur Überwachung und Steuerung verteilter Anlagen.

Supervisory Control and Data Acquisition: System zur Überwachung und Steuerung verteilter Anlagen.

## ScoringEngine
kat: Cyber Range
kurz: Dienst, der in festen Takten Service-Checks ausführt und daraus Punkte für die Teams berechnet.

Dienst, der in festen Takten Service-Checks ausführt und daraus Punkte für die Teams berechnet.

## SDN
kat: Cyber Range
kurz: Software-Defined Networking – Netze werden per Software zentral definiert (Zonen, VNets, Subnetze) statt an jedem Gerät einzeln konfiguriert.

Software-Defined Networking – Netze werden per Software zentral definiert (Zonen, VNets, Subnetze) statt an jedem Gerät einzeln konfiguriert.

## Secure Boot
kat: Cyber Range
kurz: UEFI-Funktion, die nur digital signierte Bootloader und Kernel startet.

UEFI-Funktion, die nur digital signierte Bootloader und Kernel startet. Schützt vor Bootkits; in VMs mit OVMF-Firmware ebenfalls nutzbar.

## Security Onion
kat: Cyber Range
kurz: Freie Linux-Distribution für Network Security Monitoring und Threat Hunting mit Zeek, Suricata, PCAP-Speicherung, Elastic und eigener Analyseoberfläche.

Freie Linux-Distribution für Network Security Monitoring und Threat Hunting mit Zeek, Suricata, PCAP-Speicherung, Elastic und eigener Analyseoberfläche.

## Seed
kat: Cyber Range
kurz: Startwert eines Zufallszahlengenerators.

Startwert eines Zufallszahlengenerators. Gleicher Seed bedeutet gleiche »Zufallsdaten« – wichtig für identische Range-Kopien.

## Sensor
kat: Cyber Range
kurz: System, das Netzwerkverkehr (meist über einen Spiegelport) empfängt und auswertet, ohne selbst in den Verkehr einzugreifen.

System, das Netzwerkverkehr (meist über einen Spiegelport) empfängt und auswertet, ohne selbst in den Verkehr einzugreifen.

## ServiceAccount
kat: Cyber Range
kurz: Identität eines Pods gegenüber dem Kubernetes-API-Server; ihr Token liegt standardmäßig im Pod und ist ein beliebtes Angriffsziel.

Identität eines Pods gegenüber dem Kubernetes-API-Server; ihr Token liegt standardmäßig im Pod und ist ein beliebtes Angriffsziel.

## SIEM
kat: Cyber Range
kurz: Security Information and Event Management – zentrale Sammlung, Speicherung, Korrelation und Alarmierung von Sicherheitsereignissen vieler Quellen.

Security Information and Event Management – zentrale Sammlung, Speicherung, Korrelation und Alarmierung von Sicherheitsereignissen vieler Quellen.

## Sigma
kat: Cyber Range
kurz: Herstellerneutrales Regelformat (YAML) für Detektionen in Logdaten, das in Abfragen verschiedener SIEM-Systeme übersetzt werden kann.

Herstellerneutrales Regelformat (YAML) für Detektionen in Logdaten, das in Abfragen verschiedener SIEM-Systeme übersetzt werden kann.

## SINET
kat: Cyber Range
kurz: Simulated Internet – nachgebautes Internet innerhalb der Range (DNS, Webseiten, Mail, PKI), ohne Verbindung zum echten Internet.

Simulated Internet – nachgebautes Internet innerhalb der Range (DNS, Webseiten, Mail, PKI), ohne Verbindung zum echten Internet.

## SMB-Signing
kat: Cyber Range
kurz: Digitale Signatur jedes SMB-Pakets.

Digitale Signatur jedes SMB-Pakets. Wenn erzwungen, scheitern NTLM-Relay-Angriffe auf SMB.

## Snapshot
kat: Cyber Range
kurz: Gespeicherter Zustand einer VM (Platten, optional RAM) zu einem Zeitpunkt, auf den jederzeit zurückgerollt werden kann.

Gespeicherter Zustand einer VM (Platten, optional RAM) zu einem Zeitpunkt, auf den jederzeit zurückgerollt werden kann.

## SNAT
kat: Cyber Range
kurz: Source NAT: Umschreiben der Quelladresse eines Pakets, z.

Source NAT: Umschreiben der Quelladresse eines Pakets, z. B. wenn interne Clients mit der Adresse der Firewall ins (simulierte) Internet gehen.

## SNI
kat: Cyber Range
kurz: Server Name Indication – Feld im TLS-ClientHello, das den gewünschten Servernamen im Klartext enthält; für Sensoren eine wichtige Information.

Server Name Indication – Feld im TLS-ClientHello, das den gewünschten Servernamen im Klartext enthält; für Sensoren eine wichtige Information.

## SOAR
kat: Cyber Range
kurz: Security Orchestration, Automation and Response: Plattform, die Reaktionsschritte (Playbooks) über mehrere Werkzeuge hinweg automatisiert.

Security Orchestration, Automation and Response: Plattform, die Reaktionsschritte (Playbooks) über mehrere Werkzeuge hinweg automatisiert.

## SOC
kat: Cyber Range
kurz: Security Operations Center – Team bzw.

Security Operations Center – Team bzw. Leitstelle, die Sicherheitsereignisse rund um die Uhr überwacht und darauf reagiert.

## Sollwert
kat: Cyber Range
kurz: Gewünschter Zielwert einer Regelung, etwa »Tankfüllstand 60 %«.

Gewünschter Zielwert einer Regelung, etwa »Tankfüllstand 60 %«.

## SOPS
kat: Cyber Range
kurz: Secrets OPerationS: Werkzeug, das nur die Werte in YAML/JSON-Dateien verschlüsselt (z.

Secrets OPerationS: Werkzeug, das nur die Werte in YAML/JSON-Dateien verschlüsselt (z. B. mit age oder GPG) und Schlüssel lesbar lässt.

## SPAN
kat: Cyber Range
kurz: Switched Port Analyzer – Funktion, die den Verkehr eines oder mehrerer Ports auf einen Analyseport kopiert (»Port Mirroring«).

Switched Port Analyzer – Funktion, die den Verkehr eines oder mehrerer Ports auf einen Analyseport kopiert (»Port Mirroring«).

## SPF
kat: Cyber Range
kurz: Sender Policy Framework: DNS-Eintrag, der festlegt, welche Server Mails für eine Domain versenden dürfen.

Sender Policy Framework: DNS-Eintrag, der festlegt, welche Server Mails für eine Domain versenden dürfen.

## SPN
kat: Cyber Range
kurz: Service Principal Name – eindeutiger Name eines Dienstes in Active Directory (z.

Service Principal Name – eindeutiger Name eines Dienstes in Active Directory (z. B. MSSQLSvc/fs01), über den Kerberos-Tickets angefordert werden.

## SPS
kat: Cyber Range
kurz: Speicherprogrammierbare Steuerung (engl.

Speicherprogrammierbare Steuerung (engl. PLC): Industriecomputer, der Sensoren liest und Aktoren nach einem Programm schaltet.

## SQL-Injection
kat: Cyber Range
kurz: Einschleusen von SQL-Befehlen über ungeprüfte Eingaben in eine Datenbankabfrage; Gegenmittel sind Prepared Statements.

Einschleusen von SQL-Befehlen über ungeprüfte Eingaben in eine Datenbankabfrage; Gegenmittel sind Prepared Statements.

## SSH
kat: Cyber Range
kurz: Secure Shell (TCP 22) – verschlüsseltes Protokoll für Kommandozeilen-Fernzugriff und Dateiübertragung.

Secure Shell (TCP 22) – verschlüsseltes Protokoll für Kommandozeilen-Fernzugriff und Dateiübertragung.

## State
kat: Cyber Range
kurz: Eintrag in der Zustandstabelle einer Firewall für eine erlaubte Verbindung; Antwortpakete passen zum State und werden ohne erneute Regelprüfung durchgelassen.

Eintrag in der Zustandstabelle einer Firewall für eine erlaubte Verbindung; Antwortpakete passen zum State und werden ohne erneute Regelprüfung durchgelassen.

## State-Datei
kat: Cyber Range
kurz: Datei (terraform.tfstate), in der OpenTofu/Terraform festhält, welche realen Ressourcen zu welcher Code-Zeile gehören.

Datei (terraform.tfstate), in der OpenTofu/Terraform festhält, welche realen Ressourcen zu welcher Code-Zeile gehören. Enthält oft Geheimnisse und muss geschützt werden.

## Stateful Firewall
kat: Cyber Range
kurz: Firewall, die Verbindungen verfolgt und Antwortpakete automatisch zulässt, statt jedes Paket isoliert zu bewerten.

Firewall, die Verbindungen verfolgt und Antwortpakete automatisch zulässt, statt jedes Paket isoliert zu bewerten.

## Stratum
kat: Cyber Range
kurz: Ebene in der NTP-Hierarchie: Stratum 0 sind Referenzuhren, Stratum 1 direkt daran angeschlossene Server, jede weitere Stufe zählt eins hoch.

Ebene in der NTP-Hierarchie: Stratum 0 sind Referenzuhren, Stratum 1 direkt daran angeschlossene Server, jede weitere Stufe zählt eins hoch.

## Strelka
kat: Cyber Range
kurz: Datei-Analysesystem in Security Onion, das aus dem Netzverkehr extrahierte Dateien mit YARA-Regeln und weiteren Scannern untersucht.

Datei-Analysesystem in Security Onion, das aus dem Netzverkehr extrahierte Dateien mit YARA-Regeln und weiteren Scannern untersucht.

## STRIDE
kat: Cyber Range
kurz: Microsoft-Methode zur Bedrohungsmodellierung: Spoofing, Tampering, Repudiation, Information Disclosure, Denial of Service, Elevation of Privilege.

Microsoft-Methode zur Bedrohungsmodellierung: Spoofing, Tampering, Repudiation, Information Disclosure, Denial of Service, Elevation of Privilege.

## SUID
kat: Cyber Range
kurz: Set-User-ID-Bit unter Linux: Ein Programm läuft mit den Rechten seines Besitzers (oft root) statt des Aufrufers.

Set-User-ID-Bit unter Linux: Ein Programm läuft mit den Rechten seines Besitzers (oft root) statt des Aufrufers.

## Suricata
kat: Cyber Range
kurz: Open-Source-IDS/IPS, das Netzwerkverkehr mit Signaturen vergleicht und Alarme sowie Protokolldaten (EVE-JSON) erzeugt.

Open-Source-IDS/IPS, das Netzwerkverkehr mit Signaturen vergleicht und Alarme sowie Protokolldaten (EVE-JSON) erzeugt.

## Syslog
kat: Cyber Range
kurz: Standardprotokoll (RFC 5424, Port 514/6514) zum Versenden von Log-Meldungen an einen zentralen Server.

Standardprotokoll (RFC 5424, Port 514/6514) zum Versenden von Log-Meldungen an einen zentralen Server.

## Sysmon
kat: Cyber Range
kurz: System Monitor aus den Microsoft Sysinternals – Windows-Dienst, der detaillierte Ereignisse (Prozessstarts, Netzverbindungen, Registry …) protokolliert.

System Monitor aus den Microsoft Sysinternals – Windows-Dienst, der detaillierte Ereignisse (Prozessstarts, Netzverbindungen, Registry …) protokolliert.

## Sysprep
kat: Cyber Range
kurz: Windows-Werkzeug, das eine Installation »verallgemeinert« (eindeutige Kennungen entfernen), damit sie als Vorlage für viele Kopien dienen kann.

Windows-Werkzeug, das eine Installation »verallgemeinert« (eindeutige Kennungen entfernen), damit sie als Vorlage für viele Kopien dienen kann.

## Table-Top
kat: Cyber Range
kurz: Planspiel am Tisch: Teilnehmer besprechen anhand eines Szenarios Entscheidungen und Abläufe, ohne technische Systeme zu bedienen.

Planspiel am Tisch: Teilnehmer besprechen anhand eines Szenarios Entscheidungen und Abläufe, ohne technische Systeme zu bedienen.

## tap-Interface
kat: Cyber Range
kurz: Virtuelle Netzwerkschnittstelle auf dem Host (z.

Virtuelle Netzwerkschnittstelle auf dem Host (z. B. tap120i0 = VM 120, Netzwerkkarte 0), über die Frames einer VM an die Bridge gelangen.

## TCP
kat: Cyber Range
kurz: Transmission Control Protocol – verbindungsorientiertes, zuverlässiges Transportprotokoll mit Handshake, Reihenfolge und Bestätigungen.

Transmission Control Protocol – verbindungsorientiertes, zuverlässiges Transportprotokoll mit Handshake, Reihenfolge und Bestätigungen.

## Template
kat: Cyber Range
kurz: Schreibgeschützte VM-Vorlage, aus der neue VMs geklont werden.

Schreibgeschützte VM-Vorlage, aus der neue VMs geklont werden.

## Terraform
kat: Cyber Range
kurz: HashiCorp-Werkzeug für Infrastructure as Code: beschreibt gewünschte Infrastruktur deklarativ und setzt sie über Provider-APIs um.

HashiCorp-Werkzeug für Infrastructure as Code: beschreibt gewünschte Infrastruktur deklarativ und setzt sie über Provider-APIs um.

## Testbed
kat: Cyber Range
kurz: Versuchsumgebung, in der Technologien unter kontrollierten Bedingungen getestet werden; oft mit Forschungsschwerpunkt.

Versuchsumgebung, in der Technologien unter kontrollierten Bedingungen getestet werden; oft mit Forschungsschwerpunkt.

## TGT
kat: Cyber Range
kurz: Ticket Granting Ticket – Kerberos-»Eintrittskarte«, die nach der Anmeldung ausgestellt wird und zum Anfordern weiterer Service-Tickets dient.

Ticket Granting Ticket – Kerberos-»Eintrittskarte«, die nach der Anmeldung ausgestellt wird und zum Anfordern weiterer Service-Tickets dient.

## Threat Hunting
kat: Cyber Range
kurz: Proaktive, hypothesengetriebene Suche nach Angreifern, die von automatischen Regeln noch nicht erkannt wurden.

Proaktive, hypothesengetriebene Suche nach Angreifern, die von automatischen Regeln noch nicht erkannt wurden.

## Tier-Modell
kat: Cyber Range
kurz: Microsoft-Sicherheitskonzept, das Administratorkonten in Ebenen trennt (Tier 0 = Domänencontroller, Tier 1 = Server, Tier 2 = Arbeitsplätze), damit hochprivilegierte Zugangsdaten nicht auf schwächeren Systemen liegen.

Microsoft-Sicherheitskonzept, das Administratorkonten in Ebenen trennt (Tier 0 = Domänencontroller, Tier 1 = Server, Tier 2 = Arbeitsplätze), damit hochprivilegierte Zugangsdaten nicht auf schwächeren Systemen liegen.

## Timeline
kat: Cyber Range
kurz: In GHOSTS die Beschreibung, was ein simulierter Benutzer wann tut (Handler, Befehle, Zeitfenster, Verzögerungen).

In GHOSTS die Beschreibung, was ein simulierter Benutzer wann tut (Handler, Befehle, Zeitfenster, Verzögerungen).

## TLS
kat: Cyber Range
kurz: Transport Layer Security – Verschlüsselungsprotokoll für Verbindungen (HTTPS, LDAPS, SMTPS); aktuelle Version 1.3.

Transport Layer Security – Verschlüsselungsprotokoll für Verbindungen (HTTPS, LDAPS, SMTPS); aktuelle Version 1.3.

## TOTP
kat: Cyber Range
kurz: Time-based One-Time Password – zeitbasierter Einmalcode (z.

Time-based One-Time Password – zeitbasierter Einmalcode (z. B. aus einer Authenticator-App) als zweiter Faktor.

## TPID
kat: Cyber Range
kurz: Tag Protocol Identifier: die ersten zwei Byte eines 802.1Q-Tags (Wert 0x8100).

Tag Protocol Identifier: die ersten zwei Byte eines 802.1Q-Tags (Wert 0x8100). Sie zeigen an, dass der Frame ein VLAN-Tag trägt.

## Traceroute
kat: Cyber Range
kurz: Diagnosewerkzeug, das durch schrittweise steigende TTL-Werte die Router auf dem Weg zu einem Ziel sichtbar macht.

Diagnosewerkzeug, das durch schrittweise steigende TTL-Werte die Router auf dem Weg zu einem Ziel sichtbar macht.

## Triage
kat: Cyber Range
kurz: Erste Sichtung und Priorisierung eingehender Alarme: echt oder Fehlalarm, wie dringend, wer kümmert sich?.

Erste Sichtung und Priorisierung eingehender Alarme: echt oder Fehlalarm, wie dringend, wer kümmert sich?

## Trunk
kat: Cyber Range
kurz: Switch- oder Bridge-Port, der Frames mehrerer VLANs mit Tag überträgt – z.

Switch- oder Bridge-Port, der Frames mehrerer VLANs mit Tag überträgt – z. B. die Verbindung zwischen Bridge und Firewall.

## TTL
kat: Cyber Range
kurz: Time to Live – Zähler im IP-Header, den jeder Router um 1 verringert; bei 0 wird das Paket verworfen (verhindert Endlosschleifen).

Time to Live – Zähler im IP-Header, den jeder Router um 1 verringert; bei 0 wird das Paket verworfen (verhindert Endlosschleifen).

## UDP
kat: Cyber Range
kurz: User Datagram Protocol – verbindungsloses, schnelles Transportprotokoll ohne Zustellgarantie (DNS, Syslog, VXLAN, WireGuard).

User Datagram Protocol – verbindungsloses, schnelles Transportprotokoll ohne Zustellgarantie (DNS, Syslog, VXLAN, WireGuard).

## UEFI
kat: Cyber Range
kurz: Unified Extensible Firmware Interface: moderne Firmware eines Rechners (Nachfolger des BIOS); startet das Betriebssystem und verwaltet u.

Unified Extensible Firmware Interface: moderne Firmware eines Rechners (Nachfolger des BIOS); startet das Betriebssystem und verwaltet u. a. Secure Boot und Virtualisierungsoptionen.

## Underlay
kat: Cyber Range
kurz: Das physische bzw.

Das physische bzw. darunterliegende Netz, über das ein Overlay (z. B. VXLAN) transportiert wird.

## UPID
kat: Cyber Range
kurz: Unique Process ID – eindeutige Kennung eines Proxmox-Tasks, über die sich dessen Status und Log abfragen lassen.

Unique Process ID – eindeutige Kennung eines Proxmox-Tasks, über die sich dessen Status und Log abfragen lassen.

## user-data
kat: Cyber Range
kurz: Konfigurationsdatei für cloud-init (meist YAML mit »#cloud-config« am Anfang): Benutzer, Pakete, Dateien, Befehle.

Konfigurationsdatei für cloud-init (meist YAML mit »#cloud-config« am Anfang): Benutzer, Pakete, Dateien, Befehle.

## USV
kat: Cyber Range
kurz: Unterbrechungsfreie Stromversorgung – Batteriepuffer, der bei Stromausfall weiterversorgt und ein geordnetes Herunterfahren ermöglicht.

Unterbrechungsfreie Stromversorgung – Batteriepuffer, der bei Stromausfall weiterversorgt und ein geordnetes Herunterfahren ermöglicht.

## vCPU
kat: Cyber Range
kurz: Virtuelle CPU einer VM; auf dem Host ein Thread, der vom Scheduler auf physische Kerne verteilt wird.

Virtuelle CPU einer VM; auf dem Host ein Thread, der vom Scheduler auf physische Kerne verteilt wird.

## Vertrauensgrenze
kat: Cyber Range
kurz: Stelle in einer Architektur, an der Daten oder Befehle von einem weniger vertrauenswürdigen in einen vertrauenswürdigeren Bereich wechseln – dort müssen Kontrollen sitzen.

Stelle in einer Architektur, an der Daten oder Befehle von einem weniger vertrauenswürdigen in einen vertrauenswürdigeren Bereich wechseln – dort müssen Kontrollen sitzen.

## Vertrauensspeicher
kat: Cyber Range
kurz: Liste der Root-Zertifikate, denen ein Betriebssystem oder Browser vertraut (Trust Store).

Liste der Root-Zertifikate, denen ein Betriebssystem oder Browser vertraut (Trust Store).

## vhost-net
kat: Cyber Range
kurz: Kernel-Modul, das Netzwerkpakete einer VM direkt im Host-Kernel verarbeitet statt im QEMU-Prozess.

Kernel-Modul, das Netzwerkpakete einer VM direkt im Host-Kernel verarbeitet statt im QEMU-Prozess. Senkt Latenz und CPU-Last erheblich.

## VirtIO
kat: Cyber Range
kurz: Standard für paravirtualisierte Geräte (Netz, Platte, Ballooning, Konsole) in KVM/QEMU-VMs – deutlich schneller als emulierte Hardware.

Standard für paravirtualisierte Geräte (Netz, Platte, Ballooning, Konsole) in KVM/QEMU-VMs – deutlich schneller als emulierte Hardware.

## VLAN
kat: Cyber Range
kurz: Virtual LAN (IEEE 802.1Q) – logische Aufteilung eines physischen Netzes in getrennte Segmente mittels 12-Bit-Kennung im Frame.

Virtual LAN (IEEE 802.1Q) – logische Aufteilung eines physischen Netzes in getrennte Segmente mittels 12-Bit-Kennung im Frame.

## VM
kat: Cyber Range
kurz: Virtuelle Maschine – vollständig nachgebildeter Rechner mit eigenem Betriebssystem, der auf einem Hypervisor läuft.

Virtuelle Maschine – vollständig nachgebildeter Rechner mit eigenem Betriebssystem, der auf einem Hypervisor läuft.

## VM-Escape
kat: Cyber Range
kurz: Ausbruch aus einer virtuellen Maschine auf den Hypervisor über eine Schwachstelle in der Virtualisierung (selten, aber kritisch).

Ausbruch aus einer virtuellen Maschine auf den Hypervisor über eine Schwachstelle in der Virtualisierung (selten, aber kritisch).

## VMID
kat: Cyber Range
kurz: Eindeutige Nummer einer VM oder eines Containers in Proxmox (100 bis 999.999.999).

Eindeutige Nummer einer VM oder eines Containers in Proxmox (100 bis 999.999.999).

## VNet
kat: Cyber Range
kurz: Virtuelles Netz in Proxmox SDN, das einem VLAN bzw.

Virtuelles Netz in Proxmox SDN, das einem VLAN bzw. einer VXLAN-VNI entspricht und an das VMs angeschlossen werden.

## VNI
kat: Cyber Range
kurz: VXLAN Network Identifier – 24-Bit-Kennung eines VXLAN-Segments (ca.

VXLAN Network Identifier – 24-Bit-Kennung eines VXLAN-Segments (ca. 16,7 Mio. mögliche Netze).

## VPN
kat: Cyber Range
kurz: Virtual Private Network – verschlüsselter Tunnel, über den entfernte Nutzer sicher in ein Netz gelangen (z.

Virtual Private Network – verschlüsselter Tunnel, über den entfernte Nutzer sicher in ein Netz gelangen (z. B. WireGuard, OpenVPN).

## VRF
kat: Cyber Range
kurz: Virtual Routing and Forwarding – mehrere voneinander getrennte Routing-Tabellen auf einem Router; erlaubt identische IP-Bereiche pro Mandant.

Virtual Routing and Forwarding – mehrere voneinander getrennte Routing-Tabellen auf einem Router; erlaubt identische IP-Bereiche pro Mandant.

## VT-x
kat: Cyber Range
kurz: Intel Virtualization Technology (bei AMD: AMD-V): CPU-Erweiterung, die Hardware-Virtualisierung ermöglicht.

Intel Virtualization Technology (bei AMD: AMD-V): CPU-Erweiterung, die Hardware-Virtualisierung ermöglicht. Muss im UEFI aktiviert sein.

## VTEP
kat: Cyber Range
kurz: VXLAN Tunnel Endpoint – Stelle, an der Frames in VXLAN verpackt bzw.

VXLAN Tunnel Endpoint – Stelle, an der Frames in VXLAN verpackt bzw. ausgepackt werden (bei Proxmox: der Host).

## vTPM
kat: Cyber Range
kurz: Virtuelles Trusted Platform Module für VMs; nötig z.

Virtuelles Trusted Platform Module für VMs; nötig z. B. für Windows 11 und BitLocker.

## VXLAN
kat: Cyber Range
kurz: Virtual Extensible LAN (RFC 7348) – verpackt Ethernet-Frames in UDP-Pakete (Port 4789), um Layer-2-Netze über Layer-3-Netze zu spannen.

Virtual Extensible LAN (RFC 7348) – verpackt Ethernet-Frames in UDP-Pakete (Port 4789), um Layer-2-Netze über Layer-3-Netze zu spannen.

## WAF
kat: Cyber Range
kurz: Web Application Firewall: filtert HTTP-Anfragen auf Angriffsmuster (z.

Web Application Firewall: filtert HTTP-Anfragen auf Angriffsmuster (z. B. ModSecurity mit OWASP Core Rule Set).

## Wartungsfenster
kat: Cyber Range
kurz: Vereinbarter Zeitraum, in dem Änderungen und Updates durchgeführt werden dürfen, ohne den Betrieb (hier: Übungen) zu stören.

Vereinbarter Zeitraum, in dem Änderungen und Updates durchgeführt werden dürfen, ohne den Betrieb (hier: Übungen) zu stören.

## Wazuh
kat: Cyber Range
kurz: Open-Source-Sicherheitsplattform (HIDS/XDR/SIEM) mit Agenten für Log-Analyse, Dateiintegrität, Schwachstellen- und Konfigurationsprüfung.

Open-Source-Sicherheitsplattform (HIDS/XDR/SIEM) mit Agenten für Log-Analyse, Dateiintegrität, Schwachstellen- und Konfigurationsprüfung.

## Webhook
kat: Cyber Range
kurz: HTTP-Aufruf, den ein System bei einem Ereignis automatisch an eine hinterlegte Adresse sendet (z.

HTTP-Aufruf, den ein System bei einem Ereignis automatisch an eine hinterlegte Adresse sendet (z. B. Gitea → Pipeline bei Push).

## Webshell
kat: Cyber Range
kurz: Skript (z.

Skript (z. B. PHP), das ein Angreifer auf einen Webserver lädt, um darüber Befehle auszuführen.

## WebSocket
kat: Cyber Range
kurz: Protokoll für dauerhafte, bidirektionale Verbindungen zwischen Browser und Server über eine HTTP(S)-Verbindung.

Protokoll für dauerhafte, bidirektionale Verbindungen zwischen Browser und Server über eine HTTP(S)-Verbindung.

## White Team
kat: Cyber Range
kurz: Übungsleitung: plant das Szenario, steuert Injects, überwacht Regeln und bewertet.

Übungsleitung: plant das Szenario, steuert Injects, überwacht Regeln und bewertet.

## Window Scaling
kat: Cyber Range
kurz: TCP-Option, mit der das Empfangsfenster über 64 KiB hinaus vergrößert wird – wichtig für hohe Bandbreiten.

TCP-Option, mit der das Empfangsfenster über 64 KiB hinaus vergrößert wird – wichtig für hohe Bandbreiten.

## WinRM
kat: Cyber Range
kurz: Windows Remote Management (TCP 5985 HTTP / 5986 HTTPS) – Fernverwaltungsschnittstelle von Windows, u.

Windows Remote Management (TCP 5985 HTTP / 5986 HTTPS) – Fernverwaltungsschnittstelle von Windows, u. a. für PowerShell Remoting und Ansible.

## WireGuard
kat: Cyber Range
kurz: Modernes, schlankes VPN-Protokoll (Standard UDP 51820) mit starker Kryptografie.

Modernes, schlankes VPN-Protokoll (Standard UDP 51820) mit starker Kryptografie.

## Worker
kat: Cyber Range
kurz: Hintergrundprozess, der Aufträge aus einer Job-Queue holt und ausführt, z.

Hintergrundprozess, der Aufträge aus einer Job-Queue holt und ausführt, z. B. »Sandbox 17 aufbauen«.

## XDR
kat: Cyber Range
kurz: Extended Detection and Response – Erweiterung von EDR, die Daten von Endgeräten, Netz und Cloud gemeinsam auswertet.

Extended Detection and Response – Erweiterung von EDR, die Daten von Endgeräten, Netz und Cloud gemeinsam auswertet.

## YARA
kat: Cyber Range
kurz: Regelsprache zum Erkennen von Dateien anhand von Textmustern, Byte-Folgen und Bedingungen; Standard in der Malware-Analyse.

Regelsprache zum Erkennen von Dateien anhand von Textmustern, Byte-Folgen und Bedingungen; Standard in der Malware-Analyse.

## Zeek
kat: Cyber Range
kurz: Open-Source-Netzwerkanalyse-Framework, das Verkehr in strukturierte Protokoll-Logs (conn, dns, http, ssl, smb …) übersetzt.

Open-Source-Netzwerkanalyse-Framework, das Verkehr in strukturierte Protokoll-Logs (conn, dns, http, ssl, smb …) übersetzt.

## ZFS
kat: Cyber Range
kurz: Dateisystem mit integriertem Volume-Management, Prüfsummen, Snapshots, Klonen und Software-RAID; in Proxmox VE als Installationsoption.

Dateisystem mit integriertem Volume-Management, Prüfsummen, Snapshots, Klonen und Software-RAID; in Proxmox VE als Installationsoption.

## Zone
kat: Cyber Range
kurz: Netzsegment mit einheitlichem Schutzbedarf und eigenen Regeln (z.

Netzsegment mit einheitlichem Schutzbedarf und eigenen Regeln (z. B. DMZ, CORP); in Proxmox SDN auch der Typ eines Overlays (VLAN, VXLAN, EVPN).

## Zwischen-CA
kat: Cyber Range
kurz: Zertifizierungsstelle unterhalb der Root-CA, die im Alltag Zertifikate ausstellt.

Zertifizierungsstelle unterhalb der Root-CA, die im Alltag Zertifikate ausstellt. Wird sie kompromittiert, kann man sie sperren, ohne die Root-CA zu ersetzen.
