---
id: d-10
title: Angriffstechniken in Windows-Logs erkennen
paths: cdsa, cape
order: 10
difficulty: hard
icon: eye.trianglebadge.exclamationmark
summary: Von der ATT&CK-Technik zur Erkennung – Ausführung, Persistenz, Rechteausweitung, Credential Access, Lateral Movement und Defense Evasion mit konkreten Ereignissen und Abfragelogik.
---

## Vorgehen: Technik → Daten → Regel

Für jede Technik fragt man: Welche Spuren entstehen? In welchen Logs? Wie unterscheide ich sie von normaler Administration? Diese Tabelle ist eine Arbeitsgrundlage – die konkreten Schwellen hängen von der eigenen Umgebung ab.

## Ausführung (Execution)

| Beobachtung | Daten | Logik |
|---|---|---|
| PowerShell mit kodierten Befehlen | 4104, Sysmon 1 | Befehlszeile enthält `-enc`/`-EncodedCommand`, lange Base64-Strings |
| Office startet Interpreter | Sysmon 1 | ParentImage Office, Image cmd/powershell/wscript/mshta |
| Skript-Hosts aus Downloads/Temp | Sysmon 1 | `wscript`, `cscript`, `mshta` mit Pfaden in Benutzerverzeichnissen |
| LOLBins mit Netzwerkzugriff | Sysmon 1 + 3 | `certutil`, `bitsadmin`, `regsvr32`, `rundll32` mit ausgehenden Verbindungen |

## Persistenz

| Technik | Daten |
|---|---|
| Run-Keys | Sysmon 13 auf `…\CurrentVersion\Run*` |
| geplante Aufgaben | 4698, Task-Scheduler-Log 106 |
| neue Dienste | 7045, 4697 |
| WMI-Ereignisabonnements | Sysmon 19/20/21 |
| Startup-Ordner | Sysmon 11 in Startup-Pfaden |
| neue lokale Admins | 4732 |

## Credential Access

| Technik | Daten |
|---|---|
| Zugriff auf LSASS-Speicher | Sysmon 10 mit TargetImage `lsass.exe` und verdächtigen GrantedAccess-Werten |
| Sichern der Registry-Hives SAM/SYSTEM | Sysmon 1 (`reg save`), 4656/4663 mit SACL |
| Zugriff auf NTDS.dit / Schattenkopien | Sysmon 1 (`vssadmin`, `ntdsutil`), 8222 |
| auffällige Kerberos-Service-Tickets | 4769 mit RC4, viele SPNs in kurzer Zeit |
| DCSync | 4662 mit Replikations-GUIDs von Nicht-DC-Konten |

## Lateral Movement

| Technik | Daten |
|---|---|
| Fernausführung über Dienste (PsExec-artig) | 7045 auf dem Ziel, 5145 auf `ADMIN$`/`IPC$` |
| WMI-Fernausführung | `WmiPrvSE.exe` startet Prozesse (Sysmon 1) |
| WinRM / PowerShell Remoting | `wsmprovhost.exe`, 4624 Logon Type 3, WinRM-Logs 91 |
| RDP | 4624 Logon Type 10, RDP-Logs 1149, 21/25 |
| Pass-the-Hash-Muster | 4624 Logon Type 9 mit Prozess `seclogo` bzw. NTLM-Anmeldungen von Admin-Konten an vielen Hosts |

> [!MERKE] Basislinie ist alles
> Administratoren nutzen dieselben Mechanismen legitim. Die beste Erkennung entsteht aus **Abweichung**: Konto meldet sich an Hosts an, die es nie benutzt; Workstation verbindet sich per SMB zu anderen Workstations; Dienstinstallation außerhalb von Wartungsfenstern.

## Defense Evasion

| Technik | Daten |
|---|---|
| Löschen von Logs | 1102, 104 |
| Deaktivieren von Defender | Defender-Log 5001, Registry-Änderungen |
| Zeitstempel ändern | Sysmon 2 |
| Prozess-Injektion | Sysmon 8, 10 |
| Ausführung aus ungewöhnlichen Verzeichnissen | Sysmon 1 mit Pfaden in `C:\Users\Public`, `C:\ProgramData` |

## Aus Regeln werden Use Cases

Jede Regel braucht: Beschreibung, ATT&CK-Zuordnung, Datenquelle, Logik, bekannte Fehlalarme, Schweregrad, Handlungsanweisung für das SOC (Playbook) und Testdaten. So bleibt die Erkennung wartbar – siehe [[mod:d-07|YARA und Sigma]] und [[mod:cr-23|Detection Engineering]] in deiner Range.

## Quiz

? Welches Sysmon-Ereignis zeigt Zugriffe auf den Speicher von LSASS?
= 10

? Welche Ereignisse deuten auf eine neue geplante Aufgabe hin?
+ 4698
+ Task-Scheduler 106
- 4625
- 1102

? Welche Sysmon-IDs gehören zu WMI-Ereignisabonnements?
+ 19, 20 und 21
- 1, 2 und 3
- 10, 11 und 12
- 22, 23 und 24

? Welcher Anmeldetyp in 4624 steht für RDP?
= 10

? Welches Ereignis kann DCSync von Nicht-DC-Konten zeigen?
= 4662

? Welcher Prozess startet Prozesse bei WMI-Fernausführung?
= WmiPrvSE.exe
= WmiPrvSE

?tf Die beste Erkennung entsteht aus Abweichungen von einer Basislinie.
= wahr
