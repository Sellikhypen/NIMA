---
id: att-08
title: ATT&CK 8 · Credential Access (TA0006)
paths: cdsa, cpts, cape
order: 47
difficulty: hard
icon: key.fill
tags: attack
summary: Wie Angreifer an Passwörter, Hashes und Tickets gelangen – Speicher, Dateien, Netz, Raten – und welche Schutzmechanismen das verhindern.
---

## Ziel der Taktik

**Credential Access** zielt auf Anmeldedaten. Mit ihnen bewegt sich ein Angreifer wie ein legitimer Benutzer – deshalb gehört diese Taktik zu den gefährlichsten.

## Wichtige Techniken

| ID | Technik | Schutz |
|---|---|---|
| T1003 | OS Credential Dumping (LSASS, SAM, NTDS, DCSync) | Credential Guard, LSA-Schutz, Tiering, Überwachung |
| T1110 | Brute Force (inkl. Password Spraying, Credential Stuffing) | MFA, Lockout, Blocklisten |
| T1558 | Steal or Forge Kerberos Tickets (Kerberoasting, AS-REP, Golden/Silver Ticket) | gMSA, AES, Vorauthentifizierung, krbtgt-Schutz |
| T1557 | Adversary-in-the-Middle (LLMNR/NBT-NS, ARP) | LLMNR/NBT-NS aus, SMB Signing |
| T1552 | Unsecured Credentials (Dateien, Registry, Skripte, Cloud-Metadaten) | Secret-Management, Scans nach Klartext-Passwörtern |
| T1555 | Credentials from Password Stores (Browser, Passwortmanager) | Richtlinien, Schutz der Endgeräte |
| T1056 | Input Capture (Keylogging) | EDR, Application Control |
| T1621 | MFA Request Generation (MFA-Fatigue) | Number Matching, Rate Limits |
| T1528 | Steal Application Access Token | kurzlebige Tokens, Consent-Kontrolle |

## Erkennung

| Signal | Quelle |
|---|---|
| Zugriff auf LSASS | Sysmon 10 |
| viele fehlgeschlagene Anmeldungen | 4625, 4771, Cloud-Sign-in-Logs |
| auffällige Kerberos-Anfragen | 4769 (RC4, viele SPNs) |
| Replikationsanfragen von Nicht-DCs | 4662 |
| viele abgelehnte MFA-Anfragen | Identity-Provider-Logs |

## Quiz

? Welche ATT&CK-ID hat Credential Access?
= TA0006

? Welche Technik umfasst LSASS-, SAM- und NTDS-Dumping sowie DCSync?
= T1003
= OS Credential Dumping

? Unter welcher Technik-ID fällt Kerberoasting?
= T1558

? Welche Gegenmaßnahme hilft gegen MFA-Fatigue?
+ Number Matching und Rate Limits
- SMS statt App
- MFA abschalten
- längere Passwörter

? Welche Technik beschreibt Passwörter in Dateien, Skripten oder der Registry?
= T1552
= Unsecured Credentials

@@@ MODULE @@@
---
id: att-09
title: ATT&CK 9 · Discovery (TA0007)
paths: cdsa, cpts
order: 48
difficulty: medium
icon: magnifyingglass.circle.fill
tags: attack
summary: Wie Angreifer nach dem Zugang die Umgebung erkunden – Konten, Gruppen, Netze, Freigaben, Software – und wie man ungewöhnliche Erkundung erkennt.
---

## Ziel der Taktik

Nach dem ersten Zugang orientiert sich der Angreifer: Wo bin ich? Wer bin ich? Was ist erreichbar? Wo liegen wertvolle Daten und mächtige Konten?

## Wichtige Techniken

| ID | Technik | Typische Befehle bzw. Quellen |
|---|---|---|
| T1087 | Account Discovery | `net user /domain`, LDAP-Abfragen |
| T1069 | Permission Groups Discovery | `net group "Domain Admins" /domain` |
| T1482 | Domain Trust Discovery | `nltest /domain_trusts` |
| T1018 | Remote System Discovery | Ping-Sweeps, AD-Computerabfragen |
| T1046 | Network Service Discovery | interne Portscans |
| T1135 | Network Share Discovery | Freigaben auflisten |
| T1083 | File and Directory Discovery | Suche nach Dateien |
| T1082 | System Information Discovery | `systeminfo`, `uname -a` |
| T1016 | System Network Configuration Discovery | `ipconfig`, `ip a`, Routen |
| T1057 | Process Discovery | `tasklist`, `ps` |
| T1518 | Software Discovery | installierte Software, Sicherheitsprodukte |

## Erkennung

> [!TIPP] Häufung ist das Signal
> Ein einzelnes `whoami` ist normal. Eine schnelle Folge von `whoami`, `net group`, `nltest`, `systeminfo` und `ipconfig` aus einem Benutzerprozess innerhalb weniger Minuten ist es nicht. Regeln, die **mehrere Discovery-Befehle in kurzer Zeit** zählen, sind sehr wirksam.

Weitere Signale: große LDAP-Abfragen von Arbeitsplätzen (z. B. durch Sammelwerkzeuge für Graph-Analysen), interne Portscans (Flow-Daten), viele Freigabezugriffe in kurzer Zeit (5140/5145).

## Gegenmaßnahmen

Discovery lässt sich kaum verhindern, aber begrenzen: Segmentierung, eingeschränkte LDAP-Leserechte für sensible Attribute, Honeytokens (z. B. ein auffälliges Konto, dessen Abfrage einen Alarm auslöst).

## Quiz

? Welche ATT&CK-ID hat Discovery?
= TA0007

? Welcher Befehl listet Domänen-Trusts auf?
= nltest /domain_trusts

? Welche Technik beschreibt interne Portscans?
= T1046
= Network Service Discovery

? Was ist ein starkes Signal für Discovery?
+ viele Erkundungsbefehle in kurzer Zeit aus einem Benutzerprozess
- ein einzelnes whoami
- ein Windows-Update
- eine Druckanfrage

? Welche Technik beschreibt das Auflisten von Freigaben?
= T1135
= Network Share Discovery

@@@ MODULE @@@
---
id: att-10
title: ATT&CK 10 · Lateral Movement (TA0008)
paths: cdsa, cpts, cape
order: 49
difficulty: hard
icon: arrow.left.arrow.right.square.fill
tags: attack
summary: Wie sich Angreifer von System zu System bewegen – Remote-Dienste, alternative Authentifizierung, interne Phishing-Mails – und wie Segmentierung und Monitoring das bremsen.
---

## Ziel der Taktik

**Lateral Movement** bringt den Angreifer vom ersten System zu wertvolleren: Server, Admin-Arbeitsplätze, Domain Controller.

## Wichtige Techniken

| ID | Technik | Varianten |
|---|---|---|
| T1021 | Remote Services | RDP (.001), SMB/Admin-Shares (.002), DCOM (.003), SSH (.004), VNC (.005), WinRM (.006) |
| T1550 | Use Alternate Authentication Material | Pass-the-Hash, Pass-the-Ticket, Token-Diebstahl |
| T1570 | Lateral Tool Transfer | Werkzeuge über Freigaben kopieren |
| T1534 | Internal Spearphishing | Phishing von kompromittierten internen Konten |
| T1210 | Exploitation of Remote Services | Lücken in internen Diensten |
| T1563 | Remote Service Session Hijacking | Übernahme bestehender RDP-/SSH-Sitzungen |

## Erkennung

| Signal | Quelle |
|---|---|
| Anmeldungen von Workstation zu Workstation | 4624 Typ 3/10, Flow-Daten |
| neue Dienste auf Zielsystemen | 7045 |
| Zugriffe auf ADMIN$/C$ | 5145 |
| Admin-Konten an vielen Hosts in kurzer Zeit | 4624/4672-Korrelation |
| WinRM/WMI-Prozesse starten Shells | Sysmon 1 |

## Gegenmaßnahmen

| Maßnahme | Wirkung |
|---|---|
| Host-Firewall: keine SMB/RDP/WinRM-Verbindungen zwischen Clients | stoppt die häufigsten Wege |
| LAPS | lokale Admin-Passwörter nicht wiederverwendbar |
| Tiering, Protected Users, Credential Guard | Admin-Anmeldedaten nicht auf unsicheren Hosts |
| Netzsegmentierung | weniger erreichbare Ziele |
| Jump-Hosts für Administration | klar abgegrenzte legitime Pfade |

## Quiz

? Welche ATT&CK-ID hat Lateral Movement?
= TA0008

? Welche Sub-Technik von T1021 steht für RDP?
= T1021.001
= .001

? Welche Technik umfasst Pass-the-Hash und Pass-the-Ticket?
= T1550
= Use Alternate Authentication Material

? Welche Maßnahme stoppt viele Wege zwischen Arbeitsplätzen?
+ Host-Firewall ohne SMB/RDP/WinRM zwischen Clients
- längere Bildschirmsperre
- mehr Speicherplatz
- ein schnelleres WLAN

? Welche Event ID zeigt Zugriffe auf Admin-Shares wie ADMIN$?
= 5145

@@@ MODULE @@@
---
id: att-11
title: ATT&CK 11 · Collection (TA0009)
paths: cdsa, cpts
order: 50
difficulty: medium
icon: tray.full.fill
tags: attack
summary: Wie Angreifer interessante Daten zusammentragen – Dateien, E-Mails, Bildschirme, Zwischenablage – und wie Datenklassifizierung und Monitoring helfen.
---

## Ziel der Taktik

**Collection** beschreibt das Sammeln der Daten, die der Angreifer eigentlich will: Kundendaten, Konstruktionspläne, E-Mails, Zugangsdaten, Finanzdaten.

## Wichtige Techniken

| ID | Technik | Beispiel |
|---|---|---|
| T1005 | Data from Local System | Dokumente auf dem Rechner |
| T1039 | Data from Network Shared Drive | Dateiserver |
| T1114 | Email Collection | Postfächer, Weiterleitungsregeln |
| T1213 | Data from Information Repositories | SharePoint, Confluence, Wikis, Code-Repositories |
| T1560 | Archive Collected Data | ZIP/RAR, oft verschlüsselt |
| T1074 | Data Staged | Sammeln an einem Zwischenort vor dem Abfluss |
| T1113 | Screen Capture | Bildschirmfotos |
| T1115 | Clipboard Data | Zwischenablage |
| T1530 | Data from Cloud Storage | Buckets, Blob Storage |

## Erkennung

- ungewöhnlich viele Dateizugriffe eines Kontos (Dateiserver-Audit, UEBA)
- große Archive in temporären oder ungewöhnlichen Verzeichnissen
- Archivprogramme, die von Nicht-Standard-Prozessen gestartet werden
- neue Postfachregeln und Weiterleitungen
- massenhafte Downloads aus SharePoint oder Cloud-Speichern

## Gegenmaßnahmen

- **Datenklassifizierung** und Need-to-know-Rechte
- Data Loss Prevention (DLP)
- Audit-Logging auf sensiblen Freigaben
- Verbot externer Mailweiterleitung

## Quiz

? Welche ATT&CK-ID hat Collection?
= TA0009

? Welche Technik beschreibt das Packen gesammelter Daten in Archive?
= T1560
= Archive Collected Data

? Welche Technik beschreibt das Sammeln von E-Mails?
= T1114
= Email Collection

? Welche Maßnahme begrenzt, welche Daten ein Konto überhaupt erreichen kann?
+ Datenklassifizierung und Need-to-know-Rechte
- ein größerer Bildschirm
- mehr Arbeitsspeicher
- längere Logon-Zeiten

? Wofür steht DLP?
= Data Loss Prevention

@@@ MODULE @@@
---
id: att-12
title: ATT&CK 12 · Command and Control (TA0011)
paths: cdsa, cpts
order: 51
difficulty: hard
icon: antenna.radiowaves.left.and.right.circle.fill
tags: attack
summary: Wie Angreifer mit kompromittierten Systemen kommunizieren – Web-Protokolle, DNS, Verschlüsselung, Proxys, legitime Dienste – und wie man diese Kanäle erkennt.
---

## Ziel der Taktik

Über **Command and Control** steuert der Angreifer seine Implantate: Befehle senden, Ergebnisse empfangen, Werkzeuge nachladen. Siehe auch [[mod:c-15|Frameworks und C2]].

## Wichtige Techniken

| ID | Technik | Beispiel |
|---|---|---|
| T1071 | Application Layer Protocol | HTTP(S), DNS, SMTP |
| T1573 | Encrypted Channel | eigene oder TLS-Verschlüsselung |
| T1090 | Proxy | Umleitung über Zwischenstationen |
| T1102 | Web Service | Kommunikation über Cloud-Speicher, Social Media, Paste-Seiten |
| T1105 | Ingress Tool Transfer | Werkzeuge nachladen |
| T1572 | Protocol Tunneling | Verkehr in anderen Protokollen verstecken |
| T1568 | Dynamic Resolution | wechselnde Domains (DGA), Fast Flux |
| T1219 | Remote Access Software | legitime Fernwartungstools |
| T1095 | Non-Application Layer Protocol | ICMP, rohe TCP/UDP-Protokolle |

## Erkennung

| Signal | Quelle |
|---|---|
| regelmäßige Verbindungen (Beaconing) | Proxy, Flow-Daten |
| frisch registrierte oder seltene Domains | DNS-Logs, Threat Intelligence |
| DGA-ähnliche Domainnamen | DNS-Logs, Entropie |
| ungewöhnliche TLS-Fingerprints | JA3/JA4 |
| nicht freigegebene Fernwartungssoftware | EDR, Software-Inventar |
| Server mit direktem Internetverkehr | Firewall |

## Gegenmaßnahmen

- Egress-Filterung, Server ohne direkten Internetzugang
- Proxy mit Authentifizierung und Kategorisierung
- DNS über zentrale Resolver mit Filterung (Protective DNS)
- Allowlist für Fernwartungssoftware

## Quiz

? Welche ATT&CK-ID hat Command and Control?
= TA0011

? Welche Technik beschreibt Kommunikation über HTTP(S) oder DNS?
= T1071
= Application Layer Protocol

? Wie nennt man algorithmisch erzeugte, wechselnde Domains?
= DGA
= Domain Generation Algorithm

? Welche Technik beschreibt das Nachladen von Werkzeugen?
= T1105
= Ingress Tool Transfer

? Welche Maßnahme erschwert C2-Kommunikation von Servern?
+ Egress-Filterung ohne direkten Internetzugang
- mehr offene Ports
- deaktivierte Logs
- längere Benutzernamen

@@@ MODULE @@@
---
id: att-13
title: ATT&CK 13 · Exfiltration (TA0010)
paths: cdsa, cpts
order: 52
difficulty: medium
icon: arrow.up.doc.fill
tags: attack
summary: Wie Daten das Unternehmen verlassen – über den C2-Kanal, Cloud-Speicher, alternative Protokolle, physische Medien – und wie man Abflüsse bemerkt.
---

## Ziel der Taktik

**Exfiltration** ist das Herausbringen der gesammelten Daten. Bei moderner Erpressung (Double Extortion) ist sie fester Bestandteil – die Drohung mit Veröffentlichung erhöht den Druck.

## Wichtige Techniken

| ID | Technik | Beispiel |
|---|---|---|
| T1041 | Exfiltration Over C2 Channel | über den bestehenden Steuerkanal |
| T1567 | Exfiltration Over Web Service | Cloud-Speicher, Filesharing-Dienste |
| T1048 | Exfiltration Over Alternative Protocol | DNS, FTP, SMTP |
| T1020 | Automated Exfiltration | Skripte, die kontinuierlich übertragen |
| T1030 | Data Transfer Size Limits | kleine Häppchen, um Schwellen zu unterlaufen |
| T1052 | Exfiltration Over Physical Medium | USB |
| T1537 | Transfer Data to Cloud Account | in ein fremdes Cloud-Konto kopieren |

## Erkennung

- ungewöhnlich große ausgehende Datenmengen pro Host oder Benutzer
- Uploads zu Filesharing-Diensten, die im Unternehmen nicht genutzt werden
- viele DNS-Anfragen mit langen Subdomains
- Übertragungen außerhalb der Geschäftszeiten
- Cloud: Kopien in fremde Konten, öffentliche Freigaben

## Gegenmaßnahmen

- Egress-Filterung und Proxy-Kategorien
- DLP für sensible Datenklassen
- USB-Richtlinien
- Cloud-Richtlinien gegen externes Teilen
- Verschlüsselung sensibler Daten im Ruhezustand

## Quiz

? Welche ATT&CK-ID hat Exfiltration?
= TA0010

? Welche Technik beschreibt Abfluss über Cloud-Speicher oder Filesharing-Dienste?
= T1567
= Exfiltration Over Web Service

? Was beschreibt T1030 Data Transfer Size Limits?
+ Daten werden in kleinen Häppchen übertragen, um Schwellen zu unterlaufen
- Daten werden gelöscht
- Daten werden komprimiert
- Daten werden gedruckt

? Wie heißt Erpressung mit Verschlüsselung plus Veröffentlichungsdrohung?
= Double Extortion

?tf Exfiltration kann auch über DNS stattfinden.
= wahr

@@@ MODULE @@@
---
id: att-14
title: ATT&CK 14 · Impact (TA0040)
paths: cdsa, cpts, specialist
order: 53
difficulty: medium
icon: flame.fill
tags: attack
summary: Was Angreifer am Ende anrichten – Verschlüsselung, Zerstörung, Manipulation, Dienstunterbrechung, Ressourcenmissbrauch – und wie Resilienz den Schaden begrenzt.
---

## Ziel der Taktik

**Impact** beschreibt die Wirkung auf Verfügbarkeit und Integrität: Daten verschlüsseln, löschen, manipulieren oder Dienste lahmlegen.

## Wichtige Techniken

| ID | Technik | Beispiel |
|---|---|---|
| T1486 | Data Encrypted for Impact | Ransomware |
| T1490 | Inhibit System Recovery | Schattenkopien und Backups löschen |
| T1485 | Data Destruction | Wiper |
| T1565 | Data Manipulation | gezielte Veränderung von Daten |
| T1489 | Service Stop | Datenbanken und Backupdienste stoppen |
| T1499 / T1498 | Endpoint / Network Denial of Service | Überlastung |
| T1496 | Resource Hijacking | Kryptomining |
| T1531 | Account Access Removal | Konten sperren, Passwörter ändern |
| T1491 | Defacement | Webseiten verändern |

## Erkennung – vor dem Schaden

> [!WARNUNG] Impact ist das Ende der Kette
> Wenn Verschlüsselung beginnt, ist es für Prävention zu spät. Frühe Signale sind entscheidend: Löschen von Schattenkopien (`vssadmin delete shadows`, `wmic shadowcopy delete`), Stoppen vieler Dienste, Deaktivieren der Wiederherstellung (`bcdedit`), massenhafte Dateiänderungen.

## Resilienz

- Backups nach 3-2-1-1-0, unveränderlich bzw. offline, getestet
- Backup-Infrastruktur getrennt authentifiziert (nicht in der Domäne)
- Notfallpläne und Übungen ([[mod:s-07|Incident Response und BCM]])
- Segmentierung begrenzt die Ausbreitung
- EDR mit Ransomware-Schutz und Rollback-Funktionen

## Quiz

? Welche ATT&CK-ID hat Impact?
= TA0040

? Welche Technik beschreibt Ransomware-Verschlüsselung?
= T1486
= Data Encrypted for Impact

? Welche Technik beschreibt das Löschen von Schattenkopien und Backups?
= T1490
= Inhibit System Recovery

? Welcher Befehl löscht Schattenkopien und ist ein starkes Frühwarnsignal?
= vssadmin delete shadows
= vssadmin

? Warum sollte die Backup-Infrastruktur nicht in der Domäne authentifizieren?
+ damit ein kompromittiertes AD die Backups nicht mitreißt
- weil Backups dann schneller sind
- weil Domänen keine Backups erlauben
- aus Lizenzgründen

? Welche Technik beschreibt Kryptomining auf fremden Ressourcen?
= T1496
= Resource Hijacking
