---
id: d-03
title: Windows Event Logs und Sysmon
paths: cdsa, cjca
order: 3
difficulty: medium
icon: list.bullet.rectangle
summary: Die wichtigsten Ereignis-IDs, Anmeldetypen, Sysmon-Ereignisse, Audit-Richtlinien und typische Muster, an denen man Angriffe auf Windows erkennt.
htb: Windows Event Logs & Finding Evil
---

## Aufbau der Ereignisprotokolle

Windows speichert Ereignisse in `.evtx`-Dateien unter `C:\Windows\System32\winevt\Logs`. Die wichtigsten Kanäle sind **Security**, **System**, **Application**, **Microsoft-Windows-PowerShell/Operational** und **Microsoft-Windows-Sysmon/Operational**.

## Die wichtigsten Security-Ereignisse

| ID | Ereignis | Wofür nützlich |
|---|---|---|
| 4624 | erfolgreiche Anmeldung | wer, von wo, welcher Typ |
| 4625 | fehlgeschlagene Anmeldung | Brute Force, Password Spraying |
| 4634 / 4647 | Abmeldung | Sitzungsdauer |
| 4648 | Anmeldung mit expliziten Anmeldeinformationen | Nutzung fremder Zugangsdaten |
| 4672 | Sonderrechte bei Anmeldung | Admin-Anmeldungen |
| 4688 | Prozess erstellt | Befehlsausführung |
| 4697 / 7045 | Dienst installiert | Persistenz, Fernausführung |
| 4698 | geplante Aufgabe erstellt | Persistenz |
| 4720 / 4726 | Konto erstellt / gelöscht | |
| 4728 / 4732 / 4756 | Mitglied zu Gruppe hinzugefügt | Rechteausweitung |
| 4740 | Konto gesperrt | Brute Force |
| 4768 / 4769 | Kerberos-TGT / Service-Ticket angefordert | Anomalien bei Kerberos |
| 4776 | NTLM-Authentifizierung am DC | |
| 1102 | Security-Log gelöscht | Spurenverwischung |

### Anmeldetypen (Logon Type in 4624)

| Typ | Bedeutung |
|---|---|
| 2 | interaktiv (an der Konsole) |
| 3 | Netzwerk (z. B. SMB-Freigabe) |
| 4 | Batch (geplante Aufgabe) |
| 5 | Dienst |
| 7 | Entsperren |
| 8 | NetworkCleartext |
| 9 | NewCredentials (z. B. `runas /netonly`) |
| 10 | RemoteInteractive (RDP) |
| 11 | zwischengespeicherte Anmeldedaten |

> [!BEISPIEL] Password Spraying erkennen
> Viele 4625-Ereignisse von **einer** Quelle gegen **viele verschiedene** Konten mit wenigen Versuchen pro Konto deuten auf Password Spraying hin – im Gegensatz zum klassischen Brute Force (viele Versuche gegen ein Konto).

## Sysmon

[[Sysmon]] (Sysinternals) liefert wesentlich detailliertere Daten als die Standardprotokolle. Die Konfiguration (z. B. auf Basis der SwiftOnSecurity- oder Olaf-Hartong-Vorlagen) legt fest, was protokolliert wird.

| ID | Ereignis |
|---|---|
| 1 | Prozess erstellt (mit Befehlszeile, Hash, Elternprozess) |
| 3 | Netzwerkverbindung |
| 7 | Bild (DLL) geladen |
| 8 | CreateRemoteThread |
| 10 | Prozesszugriff (z. B. auf LSASS) |
| 11 | Datei erstellt |
| 12 / 13 / 14 | Registry-Ereignisse |
| 15 | Alternate Data Stream erstellt |
| 22 | DNS-Abfrage |
| 23 / 26 | Datei gelöscht |

## Typische Muster

| Beobachtung | mögliche Bedeutung |
|---|---|
| Zugriff fremder Prozesse auf `lsass.exe` (Sysmon 10) | Versuch, Anmeldedaten aus dem Speicher zu lesen |
| `powershell.exe` mit `-enc` und langem Base64 | verschleierte Befehle |
| neuer Dienst mit zufälligem Namen (7045) | Fernausführung / Persistenz |
| Prozesse aus `AppData`, `Temp`, `ProgramData` | häufiger Ablageort für Schadsoftware |
| `svchost.exe` mit falschem Elternprozess oder Pfad | Tarnung |
| 1102 außerhalb von Wartungsfenstern | Spurenverwischung |
| viele 4769 mit RC4-Verschlüsselung für Dienstkonten | auffällige Service-Ticket-Anfragen |

> [!MERKE] Normale Eltern-Kind-Beziehungen
> `services.exe` startet `svchost.exe`, `explorer.exe` startet die Programme des Benutzers, `wininit.exe` startet `lsass.exe` und `services.exe`. Abweichungen davon sind ein starkes Signal.

## Audit-Richtlinien

Viele Ereignisse entstehen nur, wenn die **Erweiterte Überwachungsrichtlinie** sie aktiviert, z. B. Prozesserstellung inklusive Befehlszeile (4688), Überwachung der Kerberos-Dienstticket-Vorgänge oder Änderungen an Sicherheitsgruppen. Ohne diese Grundlage bleibt jedes SIEM blind.

## Quiz

? Welcher Anmeldetyp steht für RDP?
= 10

? Welcher Anmeldetyp steht für eine Netzwerkanmeldung?
= 3

? Welche Event ID zeigt eine Kontosperrung?
= 4740

? Welche Event ID zeigt ein angefordertes Kerberos-Service-Ticket?
= 4769

? Welche Sysmon-ID protokolliert Prozesszugriffe, etwa auf LSASS?
= 10

? Welche Sysmon-ID protokolliert DNS-Abfragen?
= 22

? Welcher Prozess ist der legitime Elternprozess von svchost.exe?
= services.exe

? Viele fehlgeschlagene Logins von einer Quelle gegen viele Konten mit je wenigen Versuchen deuten auf …
+ Password Spraying
- Brute Force gegen ein Konto
- einen Stromausfall
- eine Kontosperrung durch den Admin

? Welche Event ID zeigt, dass das Security-Log gelöscht wurde?
= 1102
