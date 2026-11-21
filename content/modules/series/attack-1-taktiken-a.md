---
id: att-01
title: ATT&CK 1 · Reconnaissance (TA0043)
paths: cdsa, cpts
order: 40
difficulty: medium
icon: binoculars.fill
tags: attack
summary: Die Taktik der Aufklärung – wie Angreifer Informationen über ein Ziel sammeln, bevor sie handeln, und was Verteidiger dagegen tun können.
---

## Ziel der Taktik

Bei **Reconnaissance** sammelt ein Angreifer Informationen, um spätere Schritte zu planen: Mitarbeitende, E-Mail-Formate, eingesetzte Technik, erreichbare Systeme, Partner. Viele dieser Aktivitäten finden außerhalb des eigenen Netzes statt und sind deshalb schwer zu beobachten.

## Wichtige Techniken

| ID | Technik | Beschreibung |
|---|---|---|
| T1595 | Active Scanning | Scans der öffentlich erreichbaren Systeme |
| T1592 | Gather Victim Host Information | Hardware, Software, Konfigurationen |
| T1589 | Gather Victim Identity Information | Namen, E-Mail-Adressen, Zugangsdaten aus Leaks |
| T1590 | Gather Victim Network Information | IP-Bereiche, DNS, Netzstruktur |
| T1591 | Gather Victim Org Information | Organigramme, Standorte, Geschäftsbeziehungen |
| T1593 | Search Open Websites/Domains | soziale Netzwerke, Suchmaschinen, Code-Plattformen |
| T1596 | Search Open Technical Databases | Zertifikats-Logs, WHOIS, Internet-Scanner-Datenbanken |
| T1598 | Phishing for Information | Täuschung, um Informationen statt Zugang zu erhalten |

## Erkennung

| Datenquelle | Hinweis |
|---|---|
| Firewall/IDS am Perimeter | systematische Scans aus derselben Quelle |
| Web-Logs | massenhafte Abrufe, Verzeichnis-Fuzzing |
| Mail-Gateway | Anfragen, die gezielt Informationen erfragen |
| externe Dienste | Benachrichtigung über neue Zertifikate oder Domains, die der eigenen ähneln |

> [!MERKE] Sichtbarkeit ist begrenzt
> Passive Aufklärung (OSINT) hinterlässt bei der Zielorganisation keine Spuren. Wirksamer als Erkennung ist hier, die **eigene Angriffsfläche zu kennen und zu verkleinern**.

## Gegenmaßnahmen

- regelmäßiges Attack Surface Management: Was sieht das Internet von uns?
- Informationen auf Website, in Stellenanzeigen und Profilen bewusst begrenzen
- Leak-Monitoring für Firmen-E-Mail-Adressen
- Testsysteme nicht öffentlich erreichbar machen
- Awareness für Anfragen, die Informationen erschleichen sollen

## Quiz

? Welche ATT&CK-ID hat die Taktik Reconnaissance?
= TA0043

? Welche Technik beschreibt das Scannen öffentlich erreichbarer Systeme?
= T1595
= Active Scanning

? Warum ist passive Aufklärung schwer zu erkennen?
+ Sie findet außerhalb des eigenen Netzes statt und hinterlässt dort keine Spuren
- Sie ist immer verschlüsselt
- Sie dauert nur Sekunden
- Sie nutzt nur UDP

? Was ist die wirksamste Gegenmaßnahme gegen Reconnaissance?
+ die eigene Angriffsfläche kennen und verkleinern
- alle Ports öffnen
- die Website abschalten
- nichts tun

?tf Phishing for Information zielt auf Informationen statt auf direkten Zugang.
= wahr

@@@ MODULE @@@
---
id: att-02
title: ATT&CK 2 · Resource Development (TA0042)
paths: cdsa, cpts
order: 41
difficulty: medium
icon: hammer.fill
tags: attack
summary: Wie Angreifer ihre Infrastruktur, Konten und Werkzeuge vorbereiten – und wie Threat Intelligence diese Vorbereitung sichtbar macht.
---

## Ziel der Taktik

Bevor ein Angriff beginnt, braucht der Angreifer **Ressourcen**: Domains, Server, E-Mail-Konten, Zertifikate, Schadsoftware, gestohlene Zugangsdaten. Diese Vorbereitung geschieht außerhalb des Zielnetzes.

## Wichtige Techniken

| ID | Technik | Beschreibung |
|---|---|---|
| T1583 | Acquire Infrastructure | Domains, VPS, Cloud-Konten kaufen bzw. mieten |
| T1584 | Compromise Infrastructure | fremde Server oder Domains übernehmen und missbrauchen |
| T1585 | Establish Accounts | Konten in sozialen Netzwerken, E-Mail-Dienste anlegen |
| T1586 | Compromise Accounts | echte Konten übernehmen (glaubwürdiger) |
| T1587 | Develop Capabilities | eigene Schadsoftware, Exploits, Zertifikate |
| T1588 | Obtain Capabilities | Werkzeuge kaufen oder herunterladen, gestohlene Zertifikate |
| T1608 | Stage Capabilities | Payloads und Phishing-Seiten bereitstellen |

## Erkennung und Gegenmaßnahmen

| Ansatz | Beispiel |
|---|---|
| Domain-Monitoring | neu registrierte Domains, die der eigenen ähneln (Typosquatting) |
| Zertifikats-Logs | Zertifikate für ähnliche Namen |
| Threat Intelligence | bekannte Infrastruktur von Angreifergruppen blockieren |
| Mail-Filter | Absender von sehr jungen Domains besonders prüfen |
| Takedowns | Phishing-Domains beim Registrar melden |

> [!TIPP] Junge Domains
> Viele Angriffsdomains sind nur wenige Tage alt. Proxys und Mail-Gateways, die das Domain-Alter berücksichtigen, fangen einen großen Teil davon ab.

## Quiz

? Welche ATT&CK-ID hat Resource Development?
= TA0042

? Welche Technik beschreibt das Übernehmen echter Konten, um glaubwürdiger zu wirken?
= T1586
= Compromise Accounts

? Wie erkennt man vorbereitete Phishing-Domains frühzeitig?
+ Monitoring neu registrierter, ähnlicher Domains
- durch Port-Scans im eigenen Netz
- gar nicht
- über die Druckerlogs

? Was beschreibt T1608?
+ Bereitstellen von Payloads und Phishing-Seiten
- Löschen von Logs
- Verschlüsseln von Daten
- Anmelden per RDP

?tf Resource Development findet meist innerhalb des Zielnetzes statt.
= falsch

@@@ MODULE @@@
---
id: att-03
title: ATT&CK 3 · Initial Access (TA0001)
paths: cdsa, cpts, cjca
order: 42
difficulty: medium
icon: door.left.hand.open
tags: attack
summary: Die Wege, über die Angreifer den ersten Fuß in ein Netz setzen – Phishing, exponierte Dienste, gültige Konten, Lieferkette – und die wirksamsten Gegenmaßnahmen.
---

## Ziel der Taktik

**Initial Access** beschreibt den ersten Zugang zu einem System des Ziels. Hier entscheidet sich, ob ein Angriff überhaupt beginnt – deshalb lohnen Investitionen an dieser Stelle besonders.

## Wichtige Techniken

| ID | Technik | Beschreibung | Gegenmaßnahme |
|---|---|---|---|
| T1566 | Phishing | Anhänge, Links, Social Engineering | Mail-Filter, Awareness, Makro-Sperre, MFA |
| T1190 | Exploit Public-Facing Application | Lücken in Web-Apps, VPN-Gateways, Appliances | schnelles Patchen, WAF, Inventar |
| T1133 | External Remote Services | VPN, RDP, Citrix mit gestohlenen Zugangsdaten | MFA, Monitoring, keine direkten RDP-Zugänge |
| T1078 | Valid Accounts | gültige Zugangsdaten aus Leaks oder Phishing | MFA, Leak-Abgleich, Anomalieerkennung |
| T1195 | Supply Chain Compromise | manipulierte Software oder Updates | Lieferantenmanagement, Signaturen, SBOM |
| T1199 | Trusted Relationship | Zugang über Dienstleister | eingeschränkte, überwachte Partnerzugänge |
| T1091 | Replication Through Removable Media | infizierte USB-Datenträger | USB-Richtlinien |
| T1189 | Drive-by Compromise | Infektion beim Besuch präparierter Webseiten | Browser-Updates, Isolation, Web-Filter |

## Erkennung

| Datenquelle | Hinweis |
|---|---|
| Mail-Gateway, Sandbox | schädliche Anhänge und Links |
| VPN- und Anmeldelogs | Anmeldungen aus ungewöhnlichen Ländern, unmögliche Reisezeiten |
| WAF und Web-Logs | Angriffsmuster gegen öffentliche Anwendungen |
| EDR | Office-Programme starten Interpreter |

> [!EXAM] Merksatz
> Die drei häufigsten Einfallstore sind seit Jahren: **Phishing, ausgenutzte öffentliche Anwendungen und gültige (gestohlene) Zugangsdaten.** MFA und schnelles Patchen internetfähiger Systeme sind deshalb die wirksamsten Einzelmaßnahmen.

## Quiz

? Welche ATT&CK-ID hat Initial Access?
= TA0001

? Welche Technik-ID steht für Phishing?
= T1566

? Welche Technik beschreibt das Ausnutzen öffentlich erreichbarer Anwendungen?
= T1190
= Exploit Public-Facing Application

? Welche Maßnahmen wirken gegen Valid Accounts?
+ MFA
+ Abgleich mit Leak-Datenbanken
- längere Bildschirmsperre
- mehr Drucker

? Was beschreibt T1199 Trusted Relationship?
+ Zugang über Dienstleister oder Partner
- Zugang über USB-Sticks
- Zugang über WLAN
- Zugang über Drucker

@@@ MODULE @@@
---
id: att-04
title: ATT&CK 4 · Execution (TA0002)
paths: cdsa, cpts
order: 43
difficulty: medium
icon: play.rectangle.fill
tags: attack
summary: Wie Angreifer Code ausführen – Interpreter, geplante Aufgaben, Benutzerinteraktion, Systemdienste – und wie man Ausführung kontrolliert und erkennt.
---

## Ziel der Taktik

**Execution** fasst Techniken zusammen, mit denen Angreifer Code auf einem System zum Laufen bringen. Sie nutzen dabei bevorzugt Programme, die ohnehin vorhanden sind.

## Wichtige Techniken

| ID | Technik | Beispiele |
|---|---|---|
| T1059 | Command and Scripting Interpreter | PowerShell (.001), cmd (.003), Unix-Shell (.004), Python (.006), JavaScript (.007) |
| T1204 | User Execution | Benutzer öffnet Anhang oder Link |
| T1053 | Scheduled Task/Job | Aufgabenplanung, cron |
| T1047 | Windows Management Instrumentation | Prozesse per WMI starten |
| T1569 | System Services | Ausführung über Dienste |
| T1106 | Native API | direkte Betriebssystemaufrufe |
| T1203 | Exploitation for Client Execution | Lücken in Browsern, Office, PDF-Readern |
| T1609/T1610 | Container Administration Command / Deploy Container | Ausführung in Container-Umgebungen |

## Erkennung

| Datenquelle | Logik |
|---|---|
| Sysmon 1 / 4688 | ungewöhnliche Eltern-Kind-Beziehungen, verdächtige Befehlszeilen |
| PowerShell 4104 | verschleierte oder kodierte Skripte |
| 4698 / cron-Logs | neue geplante Aufgaben |
| EDR-Verhalten | Skript-Hosts aus Benutzerverzeichnissen |

## Gegenmaßnahmen

- **Application Control** (AppLocker, WDAC) – nur erlaubte Programme und Skripte
- PowerShell **Constrained Language Mode** und umfassendes Logging
- Makros aus dem Internet blockieren
- Attack Surface Reduction-Regeln (Microsoft Defender)
- Benutzer ohne lokale Administratorrechte

## Quiz

? Welche ATT&CK-ID hat Execution?
= TA0002

? Welche Technik-ID steht für Command and Scripting Interpreter?
= T1059

? Welche Sub-Technik von T1059 steht für PowerShell?
= T1059.001
= .001

? Welche Maßnahme erlaubt nur freigegebene Programme?
+ Application Control (AppLocker, WDAC)
- längere Passwörter
- mehr Festplattenspeicher
- HTTPS

? Welche Technik beschreibt Ausführung über die Aufgabenplanung?
= T1053
= Scheduled Task/Job

@@@ MODULE @@@
---
id: att-05
title: ATT&CK 5 · Persistence (TA0003)
paths: cdsa, cpts
order: 44
difficulty: medium
icon: pin.fill
tags: attack
summary: Wie Angreifer ihren Zugang über Neustarts und Passwortwechsel hinweg sichern – Autostarts, Konten, Dienste, Aufgaben, Web-Shells – und wie man diese Spuren findet.
---

## Ziel der Taktik

Mit **Persistence** sorgt ein Angreifer dafür, dass sein Zugang bestehen bleibt – auch nach Neustart, Abmeldung oder geänderten Passwörtern.

## Wichtige Techniken

| ID | Technik | Spuren |
|---|---|---|
| T1547 | Boot or Logon Autostart Execution | Run-Keys, Startup-Ordner |
| T1053 | Scheduled Task/Job | neue Aufgaben, cron-Einträge |
| T1543 | Create or Modify System Process | neue oder geänderte Dienste, systemd-Units |
| T1136 | Create Account | neue lokale oder Domänenkonten |
| T1098 | Account Manipulation | zusätzliche Rechte, neue SSH-Schlüssel, zusätzliche MFA-Methoden |
| T1505.003 | Web Shell | Skriptdateien in Web-Verzeichnissen |
| T1546 | Event Triggered Execution | WMI-Abonnements, Bildschirmschoner, Dateizuordnungen |
| T1574 | Hijack Execution Flow | DLL-Suchreihenfolge, PATH |
| T1078 | Valid Accounts | weiter nutzbare Zugangsdaten |

## Erkennung

| Datenquelle | Hinweis |
|---|---|
| Sysmon 12/13/14 | Änderungen an Autostart-Schlüsseln |
| 7045 / 4697 | neue Dienste |
| 4698 | geplante Aufgaben |
| 4720 / 4732 | neue Konten, neue Gruppenmitglieder |
| File Integrity Monitoring | neue Dateien in Web-Verzeichnissen, geänderte `authorized_keys` |
| Autoruns-Vergleich | Differenz zu einer bekannten Basislinie |

> [!TIPP] Basislinien vergleichen
> Ein regelmäßiger Export aller Autostart-Orte (z. B. mit Autoruns oder Velociraptor) und der Vergleich mit dem Vorzustand zeigt neue Persistenz schnell – auch ohne passende Signatur.

## Quiz

? Welche ATT&CK-ID hat Persistence?
= TA0003

? Welche Technik-ID steht für Web Shells?
= T1505.003

? Welche Event ID zeigt die Installation eines neuen Dienstes?
= 7045

? Welche Sysmon-IDs zeigen Änderungen an Registry-Autostarts?
+ 12, 13 und 14
- 1, 2 und 3
- 22 und 23
- 8 und 10

? Was beschreibt T1098 Account Manipulation?
+ zusätzliche Rechte, Schlüssel oder MFA-Methoden für bestehende Konten
- Löschen von Konten
- Ändern der Bildschirmfarbe
- Neustart des Servers

@@@ MODULE @@@
---
id: att-06
title: ATT&CK 6 · Privilege Escalation (TA0004)
paths: cdsa, cpts
order: 45
difficulty: hard
icon: arrow.up.forward.square.fill
tags: attack
summary: Wie aus wenigen Rechten viele werden – Fehlkonfigurationen, Schwachstellen, Token und Gruppen – mit Erkennung und Härtung.
---

## Ziel der Taktik

**Privilege Escalation** bringt einen Angreifer von einem eingeschränkten Konto zu höheren Rechten (lokaler Admin, SYSTEM, root, Domänenadministrator). Details zu den Ursachen stehen in [[mod:c-07|Rechteausweitung verstehen]].

## Wichtige Techniken

| ID | Technik | Ursache |
|---|---|---|
| T1068 | Exploitation for Privilege Escalation | ungepatchte lokale Schwachstellen |
| T1548 | Abuse Elevation Control Mechanism | UAC-Umgehung, sudo, SUID |
| T1134 | Access Token Manipulation | Identitätswechsel über Token |
| T1574 | Hijack Execution Flow | beschreibbare Programm- oder DLL-Pfade |
| T1543 | Create or Modify System Process | Dienste mit hohen Rechten verändern |
| T1611 | Escape to Host | Ausbruch aus Containern |
| T1484 | Domain or Tenant Policy Modification | Gruppenrichtlinien oder Cloud-Richtlinien ändern |
| T1078 | Valid Accounts | Nutzung privilegierter Zugangsdaten |

## Erkennung

- Prozesse mit SYSTEM/root, deren Elternprozess ein Benutzer- oder Webprozess ist
- neue Mitglieder in Admin-Gruppen (4728/4732/4756)
- Änderungen an GPOs (5136) und sudoers
- EDR-Erkennungen für Token-Manipulation und bekannte Exploits

## Gegenmaßnahmen

- Patch-Management, besonders für Betriebssystem und Treiber
- Least Privilege, keine lokalen Adminrechte für Benutzer, LAPS
- Dienste mit eigenen, minimalen Konten
- Container ohne Privilegien, mit Seccomp/AppArmor
- regelmäßige Prüfung von SUID-Dateien, sudo-Regeln und Dienstrechten

## Quiz

? Welche ATT&CK-ID hat Privilege Escalation?
= TA0004

? Welche Technik beschreibt die Ausnutzung lokaler Schwachstellen zur Rechteausweitung?
= T1068

? Welche Technik beschreibt den Ausbruch aus Containern?
= T1611
= Escape to Host

? Welche Technik umfasst UAC-Umgehung und sudo/SUID-Missbrauch?
= T1548
= Abuse Elevation Control Mechanism

?tf Lokale Adminrechte für normale Benutzer erleichtern Rechteausweitung.
= wahr

@@@ MODULE @@@
---
id: att-07
title: ATT&CK 7 · Defense Evasion (TA0005)
paths: cdsa, cpts
order: 46
difficulty: hard
icon: eye.slash.fill
tags: attack
summary: Die größte ATT&CK-Taktik – wie Angreifer Schutzmechanismen umgehen, Spuren verwischen und sich tarnen, und welche Signale trotzdem bleiben.
---

## Ziel der Taktik

**Defense Evasion** umfasst alles, womit Angreifer unentdeckt bleiben wollen. Es ist die Taktik mit den meisten Techniken – und gleichzeitig eine große Chance für Verteidiger, denn viele Tarnversuche erzeugen selbst auffällige Spuren.

## Wichtige Techniken

| ID | Technik | Auffälliges Signal |
|---|---|---|
| T1070 | Indicator Removal | gelöschte Logs (1102, 104), gelöschte Dateien |
| T1562 | Impair Defenses | deaktivierter Virenschutz, gestoppte Logging-Dienste |
| T1027 | Obfuscated Files or Information | kodierte Befehle, hohe Entropie |
| T1036 | Masquerading | Programmnamen wie `svchost.exe` an falschen Orten |
| T1055 | Process Injection | Code in fremden Prozessen (Sysmon 8/10) |
| T1218 | System Binary Proxy Execution | `rundll32`, `regsvr32`, `mshta` als Tarnung |
| T1112 | Modify Registry | Sicherheitsfunktionen per Registry abschalten |
| T1140 | Deobfuscate/Decode Files | Dekodieren zur Laufzeit |
| T1497 | Virtualization/Sandbox Evasion | Analyseumgebungen erkennen |
| T1550 | Use Alternate Authentication Material | Hashes oder Tickets statt Passwörtern |

## Erkennung

> [!MERKE] Ausweichen erzeugt Spuren
> Das Abschalten eines Schutzes, das Löschen eines Logs oder ein Programm am falschen Ort sind selbst sehr aussagekräftige Ereignisse. Deshalb sollten gerade diese Signale **hoch priorisiert** alarmieren – und die Telemetrie sollte manipulationssicher außerhalb des Hosts gespeichert werden.

| Signal | Quelle |
|---|---|
| Log gelöscht | 1102, Sysmon-Ausfall, fehlende Heartbeats im SIEM |
| Defender deaktiviert | Defender 5001, Registry-Änderungen |
| Systemprogramm an falschem Pfad | Sysmon 1 mit Image-Pfad-Prüfung |
| kodierte PowerShell | 4104 (Script Block Logging protokolliert den dekodierten Inhalt) |

## Gegenmaßnahmen

- Manipulationsschutz (Tamper Protection) für Sicherheitssoftware
- zentrale, unveränderliche Logspeicherung
- Application Control gegen Proxy-Ausführung über Systemprogramme
- Credential Guard gegen Nutzung von Hashes und Tickets

## Quiz

? Welche ATT&CK-ID hat Defense Evasion?
= TA0005

? Welche Technik beschreibt das Löschen von Indikatoren wie Logs?
= T1070
= Indicator Removal

? Welche Technik beschreibt Prozessinjektion?
= T1055

? Welche Technik nutzt Systemprogramme wie rundll32 oder mshta zur Tarnung?
= T1218
= System Binary Proxy Execution

? Warum hilft Script Block Logging gegen kodierte PowerShell?
+ Es protokolliert den dekodierten Inhalt
- Es blockiert PowerShell vollständig
- Es verschlüsselt die Logs
- Es löscht kodierte Befehle

?tf Das Abschalten von Sicherheitssoftware ist selbst ein starkes Alarmsignal.
= wahr
