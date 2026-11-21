---
id: f-04
title: TCP, UDP und die wichtigsten Dienste
paths: grundlagen, cjca
order: 4
difficulty: easy
icon: arrow.left.arrow.right
summary: Three-Way-Handshake, TCP-Flags, UDP, Port-Zustände und ein Rundgang durch die Dienste, die dir in jeder Umgebung begegnen.
---

## TCP – zuverlässig und verbindungsorientiert

[[TCP]] garantiert, dass Daten vollständig, in der richtigen Reihenfolge und ohne Fehler ankommen. Dafür baut es zuerst eine Verbindung auf, nummeriert jedes Byte (Sequenznummern), bestätigt den Empfang (ACK) und wiederholt verlorene Segmente.

### Der Three-Way-Handshake

1. **SYN** – der Client möchte eine Verbindung und schickt seine Start-Sequenznummer.
2. **SYN-ACK** – der Server bestätigt und schickt seine eigene Sequenznummer.
3. **ACK** – der Client bestätigt. Die Verbindung steht.

Abgebaut wird mit **FIN**/**ACK** in beide Richtungen oder hart mit **RST**.

| Flag | Bedeutung |
|---|---|
| SYN | Verbindung aufbauen, Sequenznummern synchronisieren |
| ACK | Empfang bestätigen |
| FIN | Senden beenden (sauberer Abbau) |
| RST | Verbindung sofort abbrechen / Port geschlossen |
| PSH | Daten sofort an die Anwendung weitergeben |
| URG | dringende Daten (heute kaum genutzt) |

> [!INFO] Was Port-Zustände bedeuten
> Antwortet ein Host auf ein SYN mit **SYN-ACK**, lauscht dort ein Dienst (*open*). Antwortet er mit **RST**, ist niemand da (*closed*). Kommt gar nichts zurück, verwirft vermutlich eine [[Firewall]] das Paket (*filtered*). So arbeiten Netzwerkscanner wie [[Nmap]] – und genau deshalb sind „drop“-Regeln für Verteidiger aussagekräftiger als „reject“.

## UDP – schnell und verbindungslos

[[UDP]] schickt Datagramme ohne Verbindungsaufbau, ohne Bestätigung und ohne Reihenfolge. Das ist ideal, wenn Geschwindigkeit wichtiger ist als Vollständigkeit oder wenn die Anwendung selbst für Zuverlässigkeit sorgt: DNS, DHCP, NTP, SNMP, VoIP, Streaming, Online-Spiele, QUIC.

> [!WARNUNG] UDP wird oft vergessen
> Weil UDP-Dienste nicht auf Verbindungsaufbau antworten müssen, sind sie schwerer zu erkennen. Administratoren vergessen sie in Firewall-Regeln, Prüfer vergessen sie bei Scans. Beides ist ein Risiko.

## Die wichtigsten Dienste und Ports

| Port | Protokoll | Dienst | Sicherheitsnotiz |
|---|---|---|---|
| 21 | TCP | [[FTP]] | Klartext; anonyme Logins prüfen |
| 22 | TCP | [[SSH]] | sicherer Fernzugriff; Schlüssel statt Passwörter |
| 23 | TCP | Telnet | Klartext – sollte nicht mehr existieren |
| 25 | TCP | [[SMTP]] | Mailversand; Open Relay vermeiden |
| 53 | UDP/TCP | [[DNS]] | Zonentransfers nur für autorisierte Server |
| 67/68 | UDP | [[DHCP]] | Rogue-DHCP-Server sind ein Risiko |
| 80 / 443 | TCP | HTTP / HTTPS | häufigste Angriffsfläche |
| 88 | TCP/UDP | [[Kerberos]] | Hinweis auf einen Domain Controller |
| 110 / 143 | TCP | POP3 / IMAP | Postfächer; verschlüsselte Varianten 995/993 |
| 123 | UDP | NTP | Zeitsynchronisation – wichtig für Logs |
| 135 | TCP | MS-RPC | Windows-Verwaltung |
| 139 / 445 | TCP | [[SMB]] | Dateifreigaben; früher Wurm-Einfallstor |
| 161 | UDP | [[SNMP]] | Netzwerkverwaltung; Community-Strings |
| 389 / 636 | TCP | [[LDAP]] / LDAPS | Verzeichnisdienst (Active Directory) |
| 1433 | TCP | MSSQL | Datenbank |
| 3306 | TCP | MySQL | Datenbank |
| 3389 | TCP | [[RDP]] | Windows-Desktop-Fernzugriff |
| 5985/5986 | TCP | WinRM | PowerShell-Remoting |

> [!EXAM] Prüfungstipp
> Die Port-Tabelle solltest du auswendig können. Im Trainings-Tab gibt es dafür einen eigenen Terminal-Drill.

## Banner und Versionsinformationen

Viele Dienste melden sich nach dem Verbindungsaufbau mit einem **Banner**, zum Beispiel `220 mail.example.local ESMTP Postfix (Ubuntu)`. Darin stecken Produktname, Version und oft das Betriebssystem. Für Angreifer ist das wertvolle Aufklärung, für Verteidiger ein Grund, Banner zu minimieren und – viel wichtiger – Software aktuell zu halten.

## Quiz

?order Bringe den TCP-Verbindungsaufbau in die richtige Reihenfolge
> SYN
> SYN-ACK
> ACK

? Welches TCP-Flag bricht eine Verbindung sofort ab?
= RST

? Ein Host antwortet auf ein SYN mit SYN-ACK. Welcher Port-Zustand?
= open
= offen

? Keine Antwort auf ein SYN. Welcher Zustand ist am wahrscheinlichsten?
= filtered
= gefiltert

?tf UDP bestätigt jedes empfangene Datagramm.
= falsch

? Welche Dienste nutzen typischerweise UDP?
+ DNS
+ DHCP
+ SNMP
- SSH
- SMB

? Welcher Port gehört zu SMB?
= 445

? Welcher Port gehört zu RDP?
= 3389

? Welcher Port deutet auf einen Domain Controller hin (Kerberos)?
= 88

? Welcher Port gehört zu LDAPS?
= 636

? Warum ist Telnet heute ein Sicherheitsrisiko?
+ Es überträgt alles im Klartext, inklusive Passwörtern
- Es nutzt UDP
- Es braucht root-Rechte
- Es ist zu langsam
