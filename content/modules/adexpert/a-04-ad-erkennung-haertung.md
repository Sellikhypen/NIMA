---
id: a-04
title: AD verteidigen – Erkennung, Härtung, Wiederherstellung
paths: cape, cdsa, specialist
order: 14
difficulty: hard
icon: shield.lefthalf.filled.badge.checkmark
summary: Ein vollständiges Verteidigungsprogramm für Active Directory – Tiering, PAW, Credential Guard, Audit-Richtlinien, Honeytokens, Defender for Identity, Backup und Wiederherstellung des Forests.
---

## Ziel

Nach den Angriffsklassen aus [[mod:c-08|AD-Sicherheit]], [[mod:a-01|Kerberos]], [[mod:a-02|ADCS]] und [[mod:a-03|Trusts]] fasst dieses Modul zusammen, wie man eine Domäne systematisch absichert. Dieses Wissen hilft auch im CAPE-Bericht: Jeder Befund braucht eine konkrete Empfehlung.

## Die zehn wichtigsten Maßnahmen

| # | Maßnahme | wirkt gegen |
|---|---|---|
| 1 | **Tiering-Modell** mit getrennten Admin-Konten | Ausbreitung von Admin-Anmeldedaten |
| 2 | **Privileged Access Workstations** für Tier-0-Administration | Diebstahl von Anmeldedaten auf Admin-Geräten |
| 3 | **LAPS** für lokale Administratoren | Wiederverwendung lokaler Passwörter |
| 4 | **gMSA** für Dienstkonten, AES erzwingen | Kerberoasting |
| 5 | **Protected Users** und „cannot be delegated“ für Admins | Delegationsmissbrauch, NTLM |
| 6 | **SMB Signing, LDAP Signing, Channel Binding**, NTLM einschränken | Relay-Angriffe |
| 7 | LLMNR, NBT-NS und WPAD deaktivieren | Namensauflösungs-Vergiftung |
| 8 | **Credential Guard** und LSA-Schutz (RunAsPPL) | Auslesen von Anmeldedaten aus dem Speicher |
| 9 | ADCS-Vorlagen und CA-Einstellungen prüfen | Zertifikatsmissbrauch |
| 10 | ACL- und Gruppenmitgliedschaften regelmäßig rezertifizieren | versteckte Angriffspfade |

## Audit-Richtlinien für DCs

| Unterkategorie | liefert |
|---|---|
| Kerberos Authentication Service / Service Ticket Operations | 4768, 4769, 4771 |
| Credential Validation | 4776 |
| Security Group Management | 4728, 4732, 4756 |
| User Account Management | 4720, 4722, 4724, 4738 |
| Directory Service Changes | 5136 (Attributänderungen) |
| Directory Service Access mit SACL | 4662 (z. B. Replikationsrechte) |
| Logon / Special Logon | 4624, 4672 |

## Honeytokens

Ein **Honeytoken** ist ein Köderobjekt, das niemand legitim benutzt – z. B. ein Konto mit attraktivem Namen und SPN, ein falscher Admin-Benutzer oder präparierte Zugangsdaten in einer Datei. **Jede** Nutzung ist verdächtig und erzeugt einen sehr präzisen Alarm.

## Erkennungsplattformen

- **Microsoft Defender for Identity** erkennt viele AD-Angriffe direkt an den DCs (Kerberoasting-Muster, DCSync von Nicht-DCs, Pass-the-Ticket, Golden-Ticket-Anomalien).
- SIEM-Regeln (Sigma) für die oben genannten Ereignisse.
- regelmäßige Bewertungen mit **PingCastle** oder **Purple Knight** mit Trend über die Zeit.

## Wiederherstellung nach Kompromittierung

> [!WARNUNG] Forest Recovery ist schwer
> Eine vollständig kompromittierte Domäne lässt sich nicht durch das Zurücksetzen einiger Passwörter retten. Microsoft beschreibt eine eigene **Active Directory Forest Recovery**-Prozedur.

Kernschritte nach einer Domänenkompromittierung:

1. Umfang klären, Angreiferzugänge und Persistenz identifizieren (neue Konten, Gruppen, GPOs, Delegationen, Zertifikate, geplante Aufgaben)
2. **krbtgt-Passwort zweimal zurücksetzen** (mit Abstand, damit die Replikation durchläuft)
3. alle privilegierten Konten und Dienstkonten zurücksetzen, Trust-Schlüssel erneuern
4. kompromittierte Zertifikate widerrufen, ggf. CA neu aufsetzen
5. Systeme aus vertrauenswürdigen Quellen neu aufbauen
6. **Offline-Backups der DCs** (System State) regelmäßig erstellen und die Wiederherstellung üben

## Quiz

? Welche Windows-Funktion schützt Anmeldedaten durch Virtualisierung vor dem Auslesen?
= Credential Guard

? Was ist ein Honeytoken?
+ ein Köderobjekt, dessen Nutzung immer verdächtig ist
- ein besonders starkes Passwort
- ein Hardware-Token für MFA
- ein Backup des DCs

? Welche Event ID zeigt Änderungen an Verzeichnisattributen?
= 5136

? Welche Maßnahmen verhindern Namensauflösungs-Vergiftung?
+ LLMNR deaktivieren
+ NBT-NS deaktivieren
- SMBv1 aktivieren
- RC4 erzwingen

? Wie oft wird das krbtgt-Passwort nach einer Kompromittierung zurückgesetzt?
= zweimal
= 2

? Welche Microsoft-Lösung erkennt AD-Angriffe direkt an den Domain Controllern?
= Microsoft Defender for Identity
= Defender for Identity
= MDI

? Wofür steht PAW?
= Privileged Access Workstation
