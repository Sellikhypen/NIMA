---
id: adv-01
title: AD defensiv · Gruppenrichtlinien zur Härtung
paths: cdsa, specialist, cpts
order: 40
difficulty: medium
icon: list.bullet.rectangle.portrait.fill
tags: ad
summary: Wie GPOs verarbeitet werden, Vorrang und Vererbung, die wichtigsten Sicherheitseinstellungen, Security Baselines und wie man GPOs selbst vor Missbrauch schützt.
---

## Verarbeitung von Gruppenrichtlinien

Reihenfolge **LSDOU**: Local → Site → Domain → OU (von oben nach unten). Spätere Richtlinien überschreiben frühere – außer bei **Enforced**. **Block Inheritance** auf einer OU stoppt die Vererbung von oben (aber nicht Enforced-GPOs).

| Begriff | Bedeutung |
|---|---|
| Computerkonfiguration | gilt beim Start, für das Gerät |
| Benutzerkonfiguration | gilt bei der Anmeldung, für den Benutzer |
| Sicherheitsfilterung | GPO nur für bestimmte Gruppen |
| WMI-Filter | GPO nur bei bestimmten Bedingungen (z. B. Betriebssystem) |
| `gpresult /r` | zeigt angewendete Richtlinien |

## Wichtige Härtungseinstellungen

| Bereich | Einstellung |
|---|---|
| Authentifizierung | NTLMv1 und LM verbieten, NTLM-Nutzung überwachen und reduzieren |
| SMB | SMB-Signing erzwingen, SMBv1 deaktivieren |
| LDAP | LDAP-Signing und Channel Binding erzwingen |
| Namensauflösung | LLMNR und NetBIOS over TCP/IP deaktivieren |
| Anmeldedaten | LSA-Schutz (RunAsPPL), Credential Guard, WDigest aus |
| Lokale Admins | LAPS, „Deny log on“-Rechte für privilegierte Konten auf Clients |
| Skripte/Apps | AppLocker/WDAC, PowerShell Script Block Logging |
| Audit | Advanced Audit Policy ([[mod:adv-04|AD überwachen]]) |

## Security Baselines

Microsoft veröffentlicht **Security Baselines** (über das Security Compliance Toolkit) als fertige GPOs. CIS Benchmarks bieten vergleichbare Empfehlungen. Vorgehen: Baseline importieren, in Testgruppe ausrollen, Ausnahmen dokumentieren, stufenweise erweitern.

## GPOs selbst schützen

> [!WARNUNG] Wer GPOs bearbeiten darf, kontrolliert die Geräte
> Schreibrechte auf eine GPO, die auf Server oder Domain Controller wirkt, sind gleichbedeutend mit Admin-Rechten dort. GPO-Berechtigungen und die SYSVOL-Rechte regelmäßig prüfen; keine Passwörter in GPP-Dateien (cpassword).

## Quiz

? In welcher Reihenfolge werden GPOs verarbeitet?
= LSDOU
= Local Site Domain OU

? Was bewirkt „Enforced“ bei einer GPO?
+ Sie kann nicht von untergeordneten GPOs überschrieben werden
- Sie wird gelöscht
- Sie gilt nur lokal
- Sie wird ignoriert

? Welcher Befehl zeigt die angewendeten Richtlinien?
= gpresult /r
= gpresult

? Welche Namensauflösungsprotokolle sollten deaktiviert werden?
+ LLMNR
+ NetBIOS over TCP/IP
- DNS
- Kerberos

? Warum sind Schreibrechte auf GPOs kritisch?
+ Sie erlauben, Code oder Einstellungen auf allen betroffenen Geräten durchzusetzen
- Sie sind harmlos
- Sie betreffen nur Hintergrundbilder
- Sie erlauben nur Lesen

@@@ MODULE @@@
---
id: adv-02
title: AD defensiv · Objekte, Attribute und Berechtigungen
paths: cdsa, cpts, specialist
order: 41
difficulty: hard
icon: person.crop.rectangle.stack.fill
tags: ad
summary: Benutzer, Computer, Gruppen und ihre sicherheitsrelevanten Attribute, ACLs und gefährliche Rechte, AdminSDHolder, Gruppenarten und wie man Rechtepfade findet und bereinigt.
---

## Wichtige Objekte und Attribute

| Attribut | Bedeutung | Sicherheitsrelevanz |
|---|---|---|
| `sAMAccountName` | Anmeldename | |
| `userAccountControl` | Flags (deaktiviert, Passwort läuft nie ab, keine Vorauthentifizierung, Delegation) | riskante Flags prüfen |
| `servicePrincipalName` | Dienst-Kennung | Konten mit SPN sind Ziel von Ticket-Angriffen → lange Passwörter/gMSA |
| `memberOf` / `member` | Gruppenmitgliedschaft | verschachtelte Gruppen beachten |
| `adminCount` | Objekt war/ist geschützt | Hinweis auf (frühere) Privilegien |
| `msDS-AllowedToDelegateTo` | eingeschränkte Delegation | regelmäßig prüfen |
| `pwdLastSet`, `lastLogonTimestamp` | Passwortalter, letzte Anmeldung | alte/inaktive Konten finden |

## Gruppen

| Gruppe | Hinweis |
|---|---|
| Domain Admins, Enterprise Admins, Schema Admins | Tier 0, möglichst leer bzw. minimal |
| Administrators (eingebaut) | auf DCs volle Rechte |
| Account/Server/Backup/Print Operators | unterschätzte Rechte – möglichst leer |
| DnsAdmins | kann auf DCs Code laden lassen |
| Protected Users | Schutzgruppe für privilegierte Konten |

## ACLs und gefährliche Rechte

Jedes Objekt hat eine **DACL**. Besonders kritisch:

| Recht | Folge |
|---|---|
| GenericAll / GenericWrite | Objekt vollständig bzw. weitgehend ändern |
| WriteDACL / WriteOwner | Berechtigungen bzw. Besitzer ändern |
| ResetPassword (Extended Right) | Passwort setzen |
| AddMember / Self | sich zu Gruppen hinzufügen |
| DS-Replication-Get-Changes(-All) | Passwort-Hashes replizieren – nur DCs! |

## AdminSDHolder

Das Objekt **AdminSDHolder** ist die Vorlage für die ACLs geschützter Gruppen. Der SDProp-Prozess setzt deren Berechtigungen regelmäßig (standardmäßig stündlich) darauf zurück. Änderungen an AdminSDHolder sind daher besonders kritisch und müssen überwacht werden.

## Rechtepfade finden

Werkzeuge wie BloodHound (defensiv eingesetzt), PingCastle oder Purple Knight zeigen Pfade zu Tier 0 und Fehlkonfigurationen. Ziel: Pfade schließen, nicht nur einzelne Konten bereinigen. Siehe [[mod:a-04|AD verteidigen]].

## Quiz

? Welches Attribut enthält Flags wie „Passwort läuft nie ab“?
= userAccountControl

? Welches Recht erlaubt das Replizieren von Passwort-Hashes?
+ DS-Replication-Get-Changes-All
- ReadProperty
- ListChildren
- Self

? Was ist AdminSDHolder?
+ die Vorlage für die Berechtigungen geschützter Gruppen
- ein Backup-Dienst
- eine Firewall
- ein Druckerobjekt

? Warum sind Konten mit SPN besonders zu schützen?
+ Sie sind Ziel von Ticket-Angriffen, daher lange Passwörter oder gMSA
- Sie können nicht angemeldet werden
- Sie sind immer deaktiviert
- Sie haben keine Passwörter

? Welches Recht erlaubt, die Berechtigungen eines Objekts zu ändern?
= WriteDACL

@@@ MODULE @@@
---
id: adv-03
title: AD defensiv · Hybride Identität mit Entra ID
paths: cdsa, specialist
order: 42
difficulty: hard
icon: arrow.triangle.2.circlepath.circle.fill
tags: ad
summary: Synchronisation, Authentifizierungsmethoden, der Sync-Server als Tier-0-System, Cloud-Konten für Admins, Seamless SSO, Gerätezugehörigkeit und Überwachung hybrider Umgebungen.
---

## Wie Hybrid funktioniert

**Entra Connect** (bzw. Cloud Sync) synchronisiert Benutzer, Gruppen und optional Passwort-Hashes vom lokalen AD nach Entra ID.

| Methode | Funktionsweise | Hinweis |
|---|---|---|
| Password Hash Sync (PHS) | Hash eines Hashes wird synchronisiert | einfach, robust, ermöglicht Leaked-Credential-Erkennung |
| Pass-Through Authentication (PTA) | Agenten prüfen Passwort lokal | Agenten-Server sind kritisch |
| Federation (AD FS) | lokale Föderation | komplex, Token-Signaturschlüssel sind Kronjuwelen |

## Kritische Systeme

> [!GEFAHR] Sync-Server ist Tier 0
> Der Entra-Connect-Server hat weitreichende Rechte im lokalen AD und in Entra ID. Er gehört in Tier 0: geschützt wie ein Domain Controller, keine normale Anmeldung, eingeschränkter Netzwerkzugang.

Gleiches gilt für AD-FS-Server und PTA-Agenten.

## Grundsätze

- **Cloud-Admins sind reine Cloud-Konten** – nicht aus dem lokalen AD synchronisiert. So führt eine Kompromittierung on-premises nicht automatisch zur Cloud-Übernahme.
- Privilegierte lokale Gruppen nicht synchronisieren.
- MFA und Conditional Access für alle, besonders für Admins ([[mod:cl-02|Azure und Entra ID]]).
- Seamless SSO nutzt ein Computerkonto (`AZUREADSSOACC`), dessen Kerberos-Schlüssel regelmäßig erneuert werden sollte.

## Geräte

| Status | Bedeutung |
|---|---|
| Entra registered | private Geräte, lose Bindung |
| Entra joined | nur Cloud-Verwaltung |
| Hybrid joined | lokal und in Entra ID bekannt |

Gerätestatus und Konformität (Intune) können in Conditional Access genutzt werden.

## Überwachung

Entra-Anmelde- und Audit-Logs, Identity Protection (riskante Anmeldungen), Defender for Identity für das lokale AD – zusammengeführt im SIEM.

## Quiz

? Welches Werkzeug synchronisiert lokales AD mit Entra ID?
= Entra Connect
= Azure AD Connect

? Welcher Tier gehört der Entra-Connect-Server an?
= Tier 0
= 0

? Warum sollten Cloud-Admins reine Cloud-Konten sein?
+ Damit eine Kompromittierung des lokalen AD nicht automatisch die Cloud übernimmt
- Weil es billiger ist
- Weil lokale Konten keine Passwörter haben
- Weil Entra ID nichts synchronisieren kann

? Welche Authentifizierungsmethode synchronisiert einen Hash des Passwort-Hashes?
= Password Hash Sync
= PHS

? Welches Computerkonto nutzt Seamless SSO?
= AZUREADSSOACC

@@@ MODULE @@@
---
id: adv-04
title: AD defensiv · Active Directory überwachen
paths: cdsa, specialist
order: 43
difficulty: hard
icon: eye.trianglebadge.exclamationmark.fill
tags: ad
summary: Advanced Audit Policy, die wichtigsten Event-IDs auf Domain Controllern, Kerberos-Anomalien, Änderungen an kritischen Objekten und Erkennungsideen für typische Angriffstechniken.
---

## Advanced Audit Policy auf DCs

| Kategorie | aktivieren |
|---|---|
| Account Logon | Kerberos Authentication Service, Service Ticket Operations, Credential Validation |
| Account Management | User/Group/Computer Account Management |
| DS Access | Directory Service Changes, Directory Service Access (mit SACLs) |
| Logon/Logoff | Logon, Special Logon |
| Policy Change | Audit Policy Change, Authentication Policy Change |
| Privilege Use | Sensitive Privilege Use |

## Wichtige Event-IDs

| ID | Ereignis |
|---|---|
| 4624 / 4625 | Anmeldung erfolgreich / fehlgeschlagen |
| 4768 | Kerberos-TGT angefordert |
| 4769 | Kerberos-Service-Ticket angefordert |
| 4771 | Kerberos-Vorauthentifizierung fehlgeschlagen |
| 4776 | NTLM-Anmeldeprüfung |
| 4720 / 4726 | Benutzer erstellt / gelöscht |
| 4728 / 4732 / 4756 | Mitglied zu globaler / lokaler / universeller Gruppe hinzugefügt |
| 4662 | Operation an einem AD-Objekt (z. B. Replikationsrechte) |
| 5136 | Verzeichnisobjekt geändert |
| 4738 | Benutzerkonto geändert |
| 1102 | Sicherheitsprotokoll gelöscht |

## Erkennungsideen

| Technik | Hinweis im Log |
|---|---|
| Ticket-Anfragen für viele Dienste | viele 4769 von einem Konto, oft mit RC4-Verschlüsselung (0x17) |
| Konten ohne Vorauthentifizierung | 4768 mit Pre-Auth-Typ 0 |
| Replikation durch Nicht-DC | 4662 mit Replikations-GUIDs von einem Nicht-DC-Konto |
| Änderungen an Tier-0-Gruppen | 4728/4732/4756 auf privilegierte Gruppen |
| Änderung an AdminSDHolder oder GPOs | 5136 auf diese Objekte |
| Passwort-Spraying | viele 4771/4625 über viele Konten von einer Quelle |
| Honeytoken-Nutzung | jedes Ereignis zu Köderkonten ([[mod:bt-06|Deception]]) |

## Werkzeuge

Defender for Identity (DC-Sensoren), SIEM-Regeln (z. B. Sigma), regelmäßige Bewertungen mit PingCastle/Purple Knight. Ausführlich: [[mod:d-03|Windows-Eventlogs]].

## Quiz

? Welche Event-ID steht für die Anforderung eines Kerberos-Service-Tickets?
= 4769

? Welche Event-ID zeigt eine Änderung an einem Verzeichnisobjekt?
= 5136

? Welcher Verschlüsselungstyp in 4769 ist oft ein Hinweis auf Ticket-Angriffe?
+ RC4 (0x17)
- AES256
- keiner
- SHA-256

? Welche Event-ID zeigt, dass das Sicherheitsprotokoll gelöscht wurde?
= 1102

? Was deutet auf Passwort-Spraying hin?
+ viele fehlgeschlagene Anmeldungen über viele Konten von einer Quelle
- eine erfolgreiche Anmeldung
- ein Passwortwechsel
- ein neuer Drucker
