---
id: f-07
title: Windows-Grundlagen für Security
paths: grundlagen, cjca, cpts, cdsa
order: 7
difficulty: easy
icon: macwindow
summary: Architektur, Benutzer und Gruppen, Registry, Dienste, NTFS-Rechte, PowerShell und Ereignisprotokolle – das Windows-Wissen, das jede Prüfung voraussetzt.
htb: Windows Fundamentals
---

## Windows im Unternehmen

In fast jedem Unternehmen laufen Windows-Clients und Windows-Server, meist verwaltet über [[Active Directory]]. Viele Angriffe zielen deshalb auf Windows – und viele Verteidigungswerkzeuge (Ereignisprotokolle, [[Sysmon]], [[EDR]]) sind auf Windows spezialisiert.

## Wichtige Pfade

| Pfad | Inhalt |
|---|---|
| `C:\Windows\System32` | Systemprogramme (64-Bit) |
| `C:\Windows\SysWOW64` | 32-Bit-Komponenten |
| `C:\Windows\System32\config` | Registry-Hives (SAM, SYSTEM, SECURITY, SOFTWARE) |
| `C:\Windows\System32\winevt\Logs` | Ereignisprotokolle (.evtx) |
| `C:\Users\<Name>` | Benutzerprofil, `AppData` mit Programmdaten |
| `C:\ProgramData` | programmübergreifende Daten |
| `C:\Windows\Temp` | temporäre Dateien |

## Benutzer, Gruppen und Kontext

- **Lokale Konten** existieren nur auf einem Rechner und stehen in der [[SAM]]-Datenbank.
- **Domänenkonten** stehen im Active Directory.
- **SYSTEM** (LocalSystem) ist das mächtigste Konto auf einem Rechner – mächtiger als ein lokaler Administrator.
- Dienste laufen häufig als **LocalService**, **NetworkService** oder als eigenes Dienstkonto.

Jeder Benutzer und jede Gruppe hat eine eindeutige **SID** (Security Identifier), z. B. endet die SID des eingebauten Administrators auf `-500`.

> [!INFO] UAC
> Auch Administratoren arbeiten standardmäßig mit einem eingeschränkten Token. Die **Benutzerkontensteuerung (UAC)** fragt nach, bevor ein Programm volle Rechte erhält. UAC ist eine Komfort- und Schutzgrenze, aber keine vollwertige Sicherheitsgrenze.

## Privilegien

Neben Gruppen gibt es **Privilegien**, die bestimmte Systemaktionen erlauben. `whoami /priv` zeigt sie an. Einige sind besonders mächtig und sollten nur Konten besitzen, die sie wirklich brauchen:

| Privileg | erlaubt | Warum sensibel |
|---|---|---|
| SeDebugPrivilege | Prozesse anderer Benutzer debuggen | Zugriff auf Speicher, z. B. von [[LSASS]] |
| SeImpersonatePrivilege | Identitäten anderer Clients annehmen | Dienstkonten können darüber oft SYSTEM erreichen |
| SeBackupPrivilege | Dateien unabhängig von Rechten lesen | Zugriff auf Registry-Hives und Datenbanken |
| SeTakeOwnershipPrivilege | Besitz übernehmen | Rechte beliebiger Objekte ändern |
| SeLoadDriverPrivilege | Treiber laden | Code im Kernel |

## Die Registry

Die Registry ist die zentrale Konfigurationsdatenbank. Wichtige Hauptschlüssel:

| Schlüssel | Inhalt |
|---|---|
| HKLM | systemweite Einstellungen |
| HKCU | Einstellungen des angemeldeten Benutzers |
| HKU | alle geladenen Benutzerprofile |
| HKCR | Dateizuordnungen, COM |

> [!WARNUNG] Autostart-Orte
> Schlüssel wie `HKLM\Software\Microsoft\Windows\CurrentVersion\Run`, geplante Aufgaben und Dienste sind beliebte Orte für Persistenz. Werkzeuge wie **Autoruns** (Sysinternals) zeigen alle Autostart-Einträge – ein Standardwerkzeug für Verteidiger.

## Dienste und geplante Aufgaben

Dienste werden mit `services.msc`, `sc.exe` oder PowerShell (`Get-Service`) verwaltet. Jeder Dienst hat einen Pfad zur ausführbaren Datei und ein Konto, unter dem er läuft. Häufige Fehlkonfigurationen sind beschreibbare Programmpfade, Pfade mit Leerzeichen ohne Anführungszeichen und zu weite Rechte auf die Dienstkonfiguration.

Geplante Aufgaben (Task Scheduler, `schtasks`) führen Programme zeitgesteuert oder bei Ereignissen aus.

## NTFS-Rechte

NTFS nutzt **Access Control Lists (ACLs)**. Jeder Eintrag (ACE) erlaubt oder verweigert einer Identität bestimmte Rechte (Lesen, Schreiben, Ändern, Vollzugriff). `icacls` zeigt sie auf der Kommandozeile. Rechte werden vererbt; explizite Verweigerungen haben Vorrang.

## PowerShell

PowerShell ist Shell und Skriptsprache zugleich und arbeitet mit **Objekten** statt Text.

```powershell
Get-Process | Sort-Object CPU -Descending | Select-Object -First 5
Get-Service | Where-Object Status -eq Running
Get-LocalUser; Get-LocalGroupMember Administrators
Get-WinEvent -LogName Security -MaxEvents 20
```

> [!TIPP] Logging für Verteidiger
> Aktiviere **Script Block Logging** und **Module Logging** per Gruppenrichtlinie. Dann landen ausgeführte PowerShell-Inhalte im Ereignisprotokoll (Event ID 4104) – eine der wertvollsten Datenquellen für die Erkennung.

## Ereignisprotokolle

| Event ID | Bedeutung |
|---|---|
| 4624 / 4625 | erfolgreiche / fehlgeschlagene Anmeldung |
| 4672 | Anmeldung mit Sonderrechten |
| 4688 | Prozess erstellt (bei aktivierter Überwachung) |
| 4720 | Benutzerkonto erstellt |
| 4732 | Mitglied zu lokaler Gruppe hinzugefügt |
| 7045 | neuer Dienst installiert |
| 1102 | Sicherheitsprotokoll gelöscht |
| 4104 | PowerShell-Skriptblock |

Mehr dazu im Blue-Team-Modul [[mod:d-03|Windows Event Logs]].

## Quiz

? Welches Konto ist auf einem Windows-Rechner am mächtigsten?
= SYSTEM
= LocalSystem
= NT AUTHORITY\SYSTEM

? In welcher Datenbank stehen lokale Benutzerkonten?
= SAM

? Welcher Befehl zeigt die Privilegien des aktuellen Benutzers?
= whoami /priv

? Mit welcher Endung der SID wird das eingebaute Administratorkonto gekennzeichnet?
= 500
= -500

? Welche Event ID steht für eine fehlgeschlagene Anmeldung?
= 4625

? Welche Event ID zeigt die Installation eines neuen Dienstes?
= 7045

? Welche Event ID protokolliert PowerShell-Skriptblöcke?
= 4104

? Welcher Registry-Hauptschlüssel enthält systemweite Einstellungen?
= HKLM
= HKEY_LOCAL_MACHINE

? Welches Sysinternals-Werkzeug zeigt alle Autostart-Einträge?
= Autoruns

?tf UAC ist eine vollwertige Sicherheitsgrenze.
= falsch

? Wo liegen die Windows-Ereignisprotokolle?
= C:\Windows\System32\winevt\Logs
