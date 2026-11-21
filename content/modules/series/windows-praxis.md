---
id: wp-01
title: Windows-Praxis 1 · Kommandozeile cmd
paths: grundlagen, cjca
order: 30
difficulty: easy
icon: terminal
tags: windows
summary: Die klassische Windows-Eingabeaufforderung – Navigation, Dateien, Systeminformationen, Benutzer, Netzwerk und nützliche Bordmittel für Administration und Analyse.
---

## Navigation und Dateien

```bat
cd C:\Users\Public
dir /a                 :: alle Dateien inkl. versteckter
dir /s /b *.config     :: rekursiv suchen
type datei.txt
copy, move, del, mkdir, rmdir /s
where python           :: Pfad eines Programms
tree /f
```

## Systeminformationen

```bat
systeminfo                  :: Betriebssystem, Patches, Domäne
hostname
whoami /all                 :: Benutzer, Gruppen, Privilegien
wmic qfe list brief         :: installierte Updates (veraltet, aber verbreitet)
tasklist /v
sc query state= all         :: Dienste
schtasks /query /fo LIST /v :: geplante Aufgaben
```

## Benutzer und Gruppen

```bat
net user
net user alice
net localgroup administrators
net user /domain
net group "Domain Admins" /domain
```

## Netzwerk

```bat
ipconfig /all
route print
arp -a
netstat -ano              :: Verbindungen mit Prozess-ID
nslookup example.com
netsh advfirewall show allprofiles
```

> [!INFO] Warum diese Befehle wichtig sind
> Administratoren nutzen sie täglich – und Angreifer genauso für die Erkundung (siehe [[mod:att-09|ATT&CK Discovery]]). Eine schnelle Folge solcher Befehle von einem untypischen Konto ist ein klassisches Erkennungsmuster.

## Quiz

? Welcher cmd-Befehl zeigt Benutzer, Gruppen und Privilegien?
= whoami /all

? Welcher Befehl zeigt Verbindungen mit Prozess-ID?
= netstat -ano

? Welcher Befehl listet die Mitglieder der lokalen Administratorgruppe?
= net localgroup administrators

? Welcher Befehl zeigt Betriebssystem und installierte Patches?
= systeminfo

? Welcher Befehl zeigt die Firewall-Profile?
= netsh advfirewall show allprofiles

@@@ MODULE @@@
---
id: wp-02
title: Windows-Praxis 2 · PowerShell-Grundlagen
paths: grundlagen, cjca, cdsa
order: 31
difficulty: easy
icon: chevron.left.forwardslash.chevron.right
tags: windows
summary: Verb-Nomen-Cmdlets, Hilfe und Erkundung, die Objekt-Pipeline, Filtern, Sortieren, Auswählen, Formatieren und Exportieren.
---

## Cmdlets verstehen

PowerShell-Befehle folgen dem Muster **Verb-Nomen**: `Get-Process`, `Stop-Service`, `New-Item`. Erlaubte Verben listet `Get-Verb`.

```powershell
Get-Command *service*        # Befehle finden
Get-Help Get-Process -Examples
Get-Process | Get-Member     # Eigenschaften und Methoden der Objekte
```

## Die Objekt-Pipeline

Anders als in Bash fließen **Objekte**, nicht Text, durch die Pipeline:

```powershell
Get-Process |
  Where-Object CPU -gt 100 |
  Sort-Object CPU -Descending |
  Select-Object -First 5 Name, Id, CPU
```

| Cmdlet | Alias | Zweck |
|---|---|---|
| `Where-Object` | `?`, `where` | filtern |
| `Select-Object` | `select` | Eigenschaften auswählen |
| `Sort-Object` | `sort` | sortieren |
| `Group-Object` | `group` | gruppieren und zählen |
| `Measure-Object` | `measure` | zählen, summieren |
| `ForEach-Object` | `%` | pro Objekt ausführen |

## Ausgabe und Export

```powershell
Get-Service | Export-Csv dienste.csv -NoTypeInformation
Get-LocalUser | ConvertTo-Json | Out-File benutzer.json
Get-ChildItem C:\Logs | Format-Table Name, Length -AutoSize
```

> [!TIPP] Format-Cmdlets ans Ende
> `Format-Table` und `Format-List` erzeugen Darstellungsobjekte. Danach kann man nicht mehr sinnvoll filtern oder exportieren – deshalb immer zuletzt verwenden.

## Variablen und Bedingungen

```powershell
$log = "C:\Windows\System32\winevt\Logs\Security.evtx"
if (Test-Path $log) { "vorhanden" } else { "fehlt" }
$dienste = Get-Service | Where-Object Status -eq 'Running'
$dienste.Count
```

## Quiz

? Nach welchem Muster sind PowerShell-Cmdlets benannt?
= Verb-Nomen
= Verb-Noun

? Welches Cmdlet zeigt Eigenschaften und Methoden von Objekten?
= Get-Member

? Welches Cmdlet filtert Objekte in der Pipeline?
= Where-Object

? Welches Cmdlet exportiert Objekte als CSV?
= Export-Csv

? Warum gehören Format-Cmdlets ans Ende der Pipeline?
+ Danach lassen sich die Objekte nicht mehr sinnvoll verarbeiten
- Sie sind langsam
- Sie löschen Daten
- Sie funktionieren nur am Anfang

@@@ MODULE @@@
---
id: wp-03
title: Windows-Praxis 3 · Benutzer, Gruppen und Active Directory per PowerShell
paths: grundlagen, cpts, cape
order: 32
difficulty: medium
icon: person.3.fill
tags: windows
summary: Lokale Konten und Gruppen verwalten, das ActiveDirectory-Modul nutzen, Benutzer und Computer abfragen, privilegierte Gruppen prüfen und Berichte erstellen.
---

## Lokale Konten

```powershell
Get-LocalUser
Get-LocalGroupMember -Group "Administratoren"   # Gruppenname je nach Sprache
New-LocalUser -Name "svc_backup" -NoPassword
Disable-LocalUser -Name "Gast"
```

## Das ActiveDirectory-Modul

Auf Servern mit RSAT bzw. Domain Controllern verfügbar:

```powershell
Import-Module ActiveDirectory
Get-ADUser -Identity alice -Properties *
Get-ADUser -Filter 'Enabled -eq $true' -Properties LastLogonDate |
  Where-Object LastLogonDate -lt (Get-Date).AddDays(-90)   # inaktive Konten
Get-ADGroupMember "Domain Admins" -Recursive
Get-ADComputer -Filter * -Properties OperatingSystem | Group-Object OperatingSystem
Get-ADDomain; Get-ADForest; Get-ADTrust -Filter *
```

## Prüfabfragen für die Härtung

| Frage | Abfrage (Idee) |
|---|---|
| Konten mit nie ablaufendem Passwort | `Get-ADUser -Filter 'PasswordNeverExpires -eq $true'` |
| Konten ohne Kerberos-Vorauthentifizierung | `Get-ADUser -Filter 'DoesNotRequirePreAuth -eq $true'` |
| Konten mit SPN (Dienstkonten) | `Get-ADUser -Filter 'ServicePrincipalName -like "*"' -Properties ServicePrincipalName` |
| Computer mit Unconstrained Delegation | `Get-ADComputer -Filter 'TrustedForDelegation -eq $true'` |
| Mitglieder privilegierter Gruppen | `Get-ADGroupMember` für Domain/Enterprise/Schema Admins, Account/Backup Operators |

> [!MERKE] Regelmäßig berichten
> Solche Abfragen als geplante Berichte laufen lassen und Änderungen verfolgen. Jede neue Mitgliedschaft in einer privilegierten Gruppe sollte erklärbar sein – siehe [[mod:a-04|AD verteidigen]].

## Quiz

? Welches Cmdlet zeigt Mitglieder einer lokalen Gruppe?
= Get-LocalGroupMember

? Welche Option von Get-ADGroupMember berücksichtigt verschachtelte Gruppen?
= -Recursive

? Welches AD-Attribut kennzeichnet Konten ohne Kerberos-Vorauthentifizierung?
= DoesNotRequirePreAuth

? Welches Attribut kennzeichnet Computer mit Unconstrained Delegation?
= TrustedForDelegation

? Wie findet man Dienstkonten mit SPN?
+ Get-ADUser mit Filter auf ServicePrincipalName
- Get-Process
- Get-NetIPAddress
- Get-Service

@@@ MODULE @@@
---
id: wp-04
title: Windows-Praxis 4 · Dienste, Prozesse, Registry und Ereignisse
paths: grundlagen, cdsa
order: 33
difficulty: medium
icon: gearshape.fill
tags: windows
summary: Dienste und Prozesse untersuchen, die Registry lesen und überwachen, geplante Aufgaben, Autostarts und Ereignisprotokolle mit Get-WinEvent effizient filtern.
---

## Dienste und Prozesse

```powershell
Get-Service | Where-Object StartType -eq Automatic
Get-CimInstance Win32_Service | Select-Object Name, StartName, PathName   # Konto und Pfad
Get-Process | Select-Object Name, Id, Path, StartTime
Get-CimInstance Win32_Process | Select-Object ProcessId, ParentProcessId, CommandLine
```

> [!TIPP] Pfade prüfen
> Dienstpfade mit Leerzeichen ohne Anführungszeichen oder in beschreibbaren Verzeichnissen sind klassische Fehlkonfigurationen (siehe [[mod:c-07|Rechteausweitung]]).

## Registry

```powershell
Get-ItemProperty 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Run'
Get-ItemProperty 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Run'
Get-ChildItem 'HKLM:\SYSTEM\CurrentControlSet\Services' | Select-Object -First 5
```

## Geplante Aufgaben

```powershell
Get-ScheduledTask | Where-Object State -ne Disabled |
  Select-Object TaskName, TaskPath, @{n='Aktion';e={$_.Actions.Execute}}
```

## Ereignisse mit Get-WinEvent

```powershell
# Fehlgeschlagene Anmeldungen der letzten 24 Stunden
Get-WinEvent -FilterHashtable @{LogName='Security'; Id=4625; StartTime=(Get-Date).AddDays(-1)}

# Neue Dienste
Get-WinEvent -FilterHashtable @{LogName='System'; Id=7045} | Select-Object TimeCreated, Message

# Sysmon-Prozessstarts mit PowerShell
Get-WinEvent -LogName 'Microsoft-Windows-Sysmon/Operational' -FilterXPath '*[System[EventID=1]]' -MaxEvents 50
```

`-FilterHashtable` filtert bereits beim Lesen und ist viel schneller als nachträgliches `Where-Object`.

## Quiz

? Welche WMI/CIM-Klasse zeigt Dienstkonto und Pfad von Diensten?
= Win32_Service

? Welche Klasse liefert die Befehlszeile von Prozessen?
= Win32_Process

? Unter welchem Registry-Pfad liegen klassische Autostarts?
= HKLM:\Software\Microsoft\Windows\CurrentVersion\Run
= CurrentVersion\Run

? Warum ist -FilterHashtable schneller als Where-Object?
+ Es filtert bereits beim Lesen der Ereignisse
- Es nutzt mehr CPU
- Es liest weniger Logs ein
- Es ignoriert Zeitstempel

? Welches Cmdlet listet geplante Aufgaben?
= Get-ScheduledTask

@@@ MODULE @@@
---
id: wp-05
title: Windows-Praxis 5 · Netzwerk und Remoting
paths: grundlagen, cpts
order: 34
difficulty: medium
icon: network.badge.shield.half.filled
tags: windows
summary: Netzwerkkonfiguration und Verbindungen mit PowerShell, Ports testen, Firewall-Regeln, PowerShell Remoting sicher einsetzen und Just Enough Administration.
---

## Netzwerk-Cmdlets

```powershell
Get-NetIPConfiguration
Get-NetIPAddress -AddressFamily IPv4
Get-NetRoute
Get-NetTCPConnection -State Listen | Select-Object LocalAddress, LocalPort, OwningProcess
Get-NetTCPConnection -State Established |
  Select-Object RemoteAddress, RemotePort, @{n='Prozess';e={(Get-Process -Id $_.OwningProcess).Name}}
Resolve-DnsName example.com
Test-NetConnection 10.0.0.5 -Port 445
```

## Firewall

```powershell
Get-NetFirewallProfile | Select-Object Name, Enabled, DefaultInboundAction
New-NetFirewallRule -DisplayName "SMB nur aus Servernetz" -Direction Inbound `
  -Protocol TCP -LocalPort 445 -RemoteAddress 10.10.30.0/24 -Action Allow
```

## PowerShell Remoting

Remoting nutzt **WinRM** (5985 HTTP, 5986 HTTPS). Innerhalb einer Domäne wird Kerberos verwendet; der Inhalt ist dann trotz HTTP verschlüsselt.

```powershell
Enter-PSSession -ComputerName srv01
Invoke-Command -ComputerName srv01, srv02 -ScriptBlock { Get-Service wuauserv }
```

| Sicherheitsmaßnahme | Wirkung |
|---|---|
| Zugriff nur aus Admin-Netzen (Firewall) | begrenzt Lateral Movement |
| **Just Enough Administration (JEA)** | Benutzer erhalten nur definierte Befehle mit virtuellen Konten |
| Logging (4104, WinRM-Operational) | Nachvollziehbarkeit |
| keine CredSSP-Nutzung | verhindert Weitergabe von Anmeldedaten |

## Quiz

? Welches Cmdlet testet die Erreichbarkeit eines Ports?
= Test-NetConnection

? Welches Cmdlet zeigt lauschende TCP-Verbindungen?
+ Get-NetTCPConnection -State Listen
- Get-Process
- Get-Service
- Get-NetRoute

? Auf welchen Ports läuft WinRM?
+ 5985 und 5986
- 3389 und 445
- 80 und 443
- 22 und 23

? Wie heißt das Konzept, Remote-Benutzern nur definierte Befehle zu erlauben?
= JEA
= Just Enough Administration

? Welches Cmdlet führt einen Befehl auf mehreren entfernten Rechnern aus?
= Invoke-Command

@@@ MODULE @@@
---
id: wp-06
title: Windows-Praxis 6 · Härtung und Sicherheitsfunktionen
paths: grundlagen, specialist, cdsa
order: 35
difficulty: medium
icon: lock.shield
tags: windows
summary: Microsoft Defender, Attack Surface Reduction, Application Control, BitLocker, Credential Guard, LAPS, Windows-Update-Steuerung und Sicherheitsbaselines.
---

## Bausteine eines gehärteten Windows

| Funktion | Zweck |
|---|---|
| Microsoft Defender Antivirus + Tamper Protection | Schadsoftware erkennen, Abschalten verhindern |
| Attack Surface Reduction (ASR) | blockiert z. B. Office-Kindprozesse, Credential-Diebstahl aus LSASS, ausführbare Mail-Anhänge |
| Windows Defender Application Control / AppLocker | nur erlaubte Software |
| BitLocker | Festplattenverschlüsselung |
| Credential Guard, LSA-Schutz | Schutz von Anmeldedaten |
| Windows LAPS | eindeutige lokale Admin-Passwörter |
| SmartScreen | Warnung vor unbekannten Downloads |
| Windows Firewall | Host-Segmentierung |
| Controlled Folder Access | Schutz vor Ransomware für ausgewählte Ordner |

## Prüfen per PowerShell

```powershell
Get-MpComputerStatus | Select-Object AMServiceEnabled, RealTimeProtectionEnabled, IsTamperProtected
Get-MpPreference | Select-Object AttackSurfaceReductionRules_Ids, AttackSurfaceReductionRules_Actions
Get-BitLockerVolume
Get-CimInstance -ClassName Win32_DeviceGuard -Namespace root\Microsoft\Windows\DeviceGuard
```

## Sicherheitsbaselines

Microsoft veröffentlicht **Security Baselines** (Gruppenrichtlinien-Vorlagen, Security Compliance Toolkit), das CIS veröffentlicht **CIS Benchmarks**. Beide sind gute Startpunkte, die an die eigene Umgebung angepasst werden.

## Updates

Windows Update for Business, WSUS oder Intune steuern Updates. Kritische Sicherheitsupdates mit kurzen Fristen, Neustarts erzwingen, Status zentral überwachen – siehe [[mod:s-09|Schwachstellenmanagement]].

## Quiz

? Welche Defender-Funktion verhindert, dass Schadsoftware den Virenschutz abschaltet?
= Tamper Protection
= Manipulationsschutz

? Wofür stehen die ASR-Regeln?
= Attack Surface Reduction

? Welches Cmdlet zeigt den Status von BitLocker?
= Get-BitLockerVolume

? Welche Funktion schützt ausgewählte Ordner vor Ransomware?
= Controlled Folder Access

? Welche Organisationen veröffentlichen Sicherheitsbaselines?
+ Microsoft (Security Baselines)
+ CIS (Benchmarks)
- Wikipedia
- Hack The Box
