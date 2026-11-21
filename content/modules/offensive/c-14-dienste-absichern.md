---
id: c-14
title: Gängige Dienste – Risiken und Härtung
paths: cpts, specialist
order: 7.5
difficulty: medium
icon: server.rack
summary: Datei-, Datenbank-, Mail-, DNS- und Fernzugriffsdienste aus Angreifer- und Verteidigersicht – welche Fehlkonfigurationen zu Zugriff führen, wie man sie erkennt und welche Härtung wirkt.
htb: Attacking Common Services
---

## Denkweise

Dienste werden selten über spektakuläre Exploits kompromittiert, sondern über **Fehlkonfigurationen, schwache oder wiederverwendete Zugangsdaten und fehlende Updates**. Für jeden Dienst lohnen dieselben Fragen: Wer darf zugreifen? Wird verschlüsselt? Welche Funktionen sind aktiv, obwohl sie niemand braucht? Läuft eine aktuelle Version?

## Dateidienste

| Dienst | Risiko | Härtung |
|---|---|---|
| SMB | Freigaben mit Schreibrechten für „Jeder“, sensible Dateien (Skripte, Backups, Konfigurationen mit Passwörtern), SMBv1, fehlende Signierung | Freigaben inventarisieren, Rechte nach Need-to-know, SMBv1 aus, Signing erzwingen, Dateien mit Zugangsdaten entfernen |
| FTP | anonym, Klartext, Schreibzugriff ins Webroot | SFTP statt FTP, anonym deaktivieren |
| NFS | Exporte für alle, `no_root_squash` | Exporte auf Hosts beschränken, `root_squash`, NFSv4 mit Kerberos |

## Datenbanken

| Risiko | Härtung |
|---|---|
| aus beliebigen Netzen erreichbar | nur von Anwendungsservern, Firewall |
| Standard- oder schwache Admin-Passwörter (z. B. `sa`) | starke Passwörter, Integration in zentrale Authentifizierung |
| gefährliche Funktionen aktiv (`xp_cmdshell`, Dateizugriff, Linked Servers mit hohen Rechten) | deaktivieren, Linked Servers mit minimalen Rechten |
| Dienst läuft mit hohen Systemrechten | eigenes, unprivilegiertes Dienstkonto |
| unverschlüsselte Verbindungen | TLS erzwingen |

## Mail und DNS

| Dienst | Risiko | Härtung |
|---|---|---|
| SMTP | Open Relay, Benutzer-Enumeration | Relay nur für Authentifizierte, VRFY/EXPN aus |
| IMAP/POP3 | Passwort-Spraying-Ziel, Klartext | nur TLS-Varianten, MFA bzw. moderne Authentifizierung |
| DNS | offene Zonentransfers, offener Resolver, Subdomain-Takeover durch verwaiste CNAMEs | AXFR beschränken, Rekursion intern, verwaiste Einträge löschen |

> [!INFO] Subdomain-Takeover
> Zeigt ein CNAME auf einen Cloud-Dienst (z. B. eine gelöschte App oder einen Speicher-Bucket), den es nicht mehr gibt, kann jemand anderes diesen Namen beim Anbieter registrieren und Inhalte unter der Subdomain des Unternehmens ausliefern. Regelmäßige Prüfung aller DNS-Einträge verhindert das.

## Fernzugriff

| Dienst | Risiko | Härtung |
|---|---|---|
| RDP | aus dem Internet erreichbar, Passwort-Spraying, alte Lücken | Gateway + MFA, NLA, Lockout-Richtlinien, Patchen |
| SSH | Passwort-Login, schwache Schlüssel, alte Algorithmen | nur Schlüssel, `PermitRootLogin no`, Fail2ban/Rate Limiting |
| WinRM | breite Freigabe, Klartext über HTTP (5985) in fremden Netzen | auf Admin-Netze beschränken, HTTPS, JEA (Just Enough Administration) |
| VNC | oft ohne oder mit schwachem Passwort | nur über SSH/VPN, starke Authentifizierung |

## Erkennung

| Signal | Quelle |
|---|---|
| viele fehlgeschlagene Anmeldungen an einem Dienst | Dienst-Logs, 4625, SSH-Logs |
| Zugriff auf Freigaben durch ungewöhnliche Konten | Windows-Ereignis 5140/5145 |
| neue Verbindungen zu Datenbanken von Clients | Firewall, DB-Audit |
| Aktivierung gefährlicher Funktionen | DB-Audit-Logs, Konfigurationsüberwachung |

## Quiz

? Was ist die häufigste Ursache kompromittierter Dienste?
+ Fehlkonfigurationen, schwache Zugangsdaten und fehlende Updates
- zu viele Benutzer
- zu schnelle Server
- HTTPS

? Wie heißt die Schwachstelle, wenn ein verwaister CNAME auf einen gelöschten Cloud-Dienst zeigt?
= Subdomain-Takeover
= Subdomain Takeover

? Welche SSH-Einstellung verbietet die direkte Root-Anmeldung?
= PermitRootLogin no

? Welches PowerShell-Konzept beschränkt Remote-Administratoren auf bestimmte Befehle?
= JEA
= Just Enough Administration

? Welche Windows-Ereignisse protokollieren Zugriffe auf Freigaben?
+ 5140 und 5145
- 4624 und 4625
- 7045 und 4697
- 1102 und 104

? Welche MSSQL-Funktion sollte deaktiviert sein?
= xp_cmdshell

?tf NFSv4 kann mit Kerberos abgesichert werden.
= wahr
