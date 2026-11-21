---
id: c-03
title: Footprinting – Dienste verstehen
paths: cpts
order: 3
difficulty: medium
icon: magnifyingglass.circle.fill
summary: Die Enumerationsmethodik in Schichten und ein Rundgang durch FTP, SMB, NFS, DNS, SMTP, IMAP/POP3, SNMP, Datenbanken, IPMI und Fernzugriffsdienste – jeweils mit typischen Fehlkonfigurationen und Härtung.
htb: Footprinting
---

## Die Methodik in Schichten

HTB beschreibt Enumeration als sechs Schichten, durch die man sich von außen nach innen arbeitet:

| Schicht | Inhalt |
|---|---|
| 1. Internet Presence | Domains, Subdomains, IP-Bereiche, Cloud-Ressourcen |
| 2. Gateway | Firewalls, VPN, Schutzmechanismen |
| 3. Accessible Services | erreichbare Dienste und ihre Konfiguration |
| 4. Processes | Prozesse und Datenflüsse |
| 5. Privileges | Rechte, Gruppen, Berechtigungen |
| 6. OS Setup | Betriebssystem, interne Konfiguration |

## Dienste und ihre typischen Schwächen

| Dienst | typische Fehlkonfiguration | Härtung |
|---|---|---|
| [[FTP]] (21) | anonymer Zugang, Klartext, beschreibbare Verzeichnisse | abschalten oder SFTP/FTPS, anonym nur lesend und bewusst |
| [[SMB]] (445) | anonyme Freigaben, zu weite Rechte, SMBv1, fehlende Signierung | SMBv1 aus, Signing erzwingen, Freigaberechte prüfen |
| NFS (2049) | Exporte für alle Hosts, `no_root_squash` | Exporte auf Hosts beschränken, `root_squash` |
| [[DNS]] (53) | Zonentransfer für alle, offener Resolver | AXFR beschränken, Rekursion nur intern |
| [[SMTP]] (25) | Open Relay, Benutzer-Enumeration (VRFY/EXPN) | Relay beschränken, VRFY/EXPN deaktivieren, Authentifizierung |
| IMAP/POP3 | Klartext-Varianten | nur 993/995 mit TLS |
| [[SNMP]] (161/udp) | Standard-Community `public`, v1/v2c im Klartext | SNMPv3 mit Authentifizierung und Verschlüsselung |
| MySQL / MSSQL / Oracle | aus dem Netz erreichbar, schwache Passwörter, zu viele Rechte | nur von Anwendungsservern erreichbar, Least Privilege |
| IPMI (623/udp) | Standardpasswörter, Hash-Preisgabe im Protokoll | eigenes Management-Netz, Firmware, starke Passwörter |
| [[SSH]] (22) | Passwort-Login, alte Algorithmen | nur Schlüssel, aktuelle Kryptografie, Fail2ban |
| [[RDP]] (3389) / WinRM | aus dem Internet erreichbar | nur über VPN/Gateway, NLA, MFA |
| Rsync, R-Services | unauthentifizierter Zugriff, Vertrauen über hosts.equiv | abschalten oder absichern |

> [!PRAXIS] Für jeden Dienst dieselben Fragen
> Wie meldet er sich (Banner, Version)? Erlaubt er anonymen Zugriff? Welche Informationen gibt er ohne Anmeldung preis (Benutzer, Freigaben, Konfiguration)? Wird verschlüsselt? Gibt es bekannte Schwachstellen in der Version?

## Informationspreisgabe als Befund

Nicht jeder Befund ist eine „Lücke“ im engeren Sinne. Auch **Informationspreisgabe** – Benutzernamen über SMTP, Hostnamen über DNS, Netzstruktur über SNMP – ist relevant, weil sie spätere Schritte erleichtert. Im Bericht wird sie entsprechend niedriger, aber nachvollziehbar bewertet.

## Quiz

? Welche Schicht der Enumerationsmethodik betrachtet erreichbare Dienste?
= Accessible Services
= 3

? Welche NFS-Option erlaubt einem lokalen root auf dem Client volle root-Rechte auf der Freigabe?
= no_root_squash

? Welche SNMP-Version bietet Authentifizierung und Verschlüsselung?
= SNMPv3
= v3
= 3

? Welche SMTP-Befehle sollten deaktiviert werden, um Benutzer-Enumeration zu erschweren?
+ VRFY
+ EXPN
- HELO
- QUIT

? Was ist ein Open Relay?
+ ein Mailserver, der Mails beliebiger Absender an beliebige Empfänger weiterleitet
- ein Server ohne Port 25
- ein verschlüsselter Mailserver
- ein IMAP-Server

? Welche SMB-Version sollte abgeschaltet sein?
= SMBv1
= 1

?tf Informationspreisgabe ist nie ein Befund.
= falsch
