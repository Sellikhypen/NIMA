---
id: adx-01
title: AD verstehen 1 · Forests, Domänen, OUs und Sites
paths: cpts, cape, cjca, grundlagen
order: 12.1
difficulty: easy
icon: tree.fill
tags: active directory, grundlagen
summary: Die logische und physische Struktur von Active Directory – warum der Forest die Sicherheitsgrenze ist und wofür OUs und Sites da sind.
---

## Einfach erklärt

Active Directory ist das Adressbuch und der Ausweisdienst eines Windows-Netzes. Es weiß, wer wer ist (Benutzer, Computer, Gruppen) und wer was darf.

Stell dir einen Konzern vor:
- Der **Forest** ist der ganze Konzern mit gemeinsamen Grundregeln.
- Eine **Domäne** ist eine Landesgesellschaft mit eigener Verwaltung.
- Eine **OU** (Organisationseinheit) ist eine Abteilung – ein Ordner, um Objekte zu sortieren und Richtlinien zuzuweisen.
- Eine **Site** ist ein Standort mit schneller Verbindung – sie steuert, welcher Server lokal antwortet.

## Logische Struktur

| Element | Zweck |
|---|---|
| Forest | oberste Ebene, gemeinsames Schema und Konfiguration, **Sicherheitsgrenze** |
| Tree | Domänen mit zusammenhängendem DNS-Namensraum |
| Domain | Verwaltungs- und Replikationseinheit, eigene Richtlinien |
| OU | Container für Delegation und Gruppenrichtlinien |

> [!MERKE] Der Forest ist die Sicherheitsgrenze – nicht die Domäne
> Wer in einer Domäne volle Kontrolle hat, kann in der Regel den ganzen Forest übernehmen. Wer echte Trennung braucht, braucht getrennte Forests.

## Physische Struktur

- **Domain Controller (DC)** – Server, die die AD-Datenbank (`NTDS.dit`) halten und Anmeldungen prüfen.
- **Sites und Subnetze** – ordnen Clients dem nächstgelegenen DC zu und steuern die Replikation zwischen Standorten.
- **Global Catalog** – Teilkopie aller Objekte des Forests für schnelle Suchen.
- **FSMO-Rollen** – fünf Sonderaufgaben, die nur ein DC gleichzeitig hat (z. B. PDC-Emulator für Zeit und Passwortänderungen).

## Tiefer eingetaucht

Jedes Objekt hat eindeutige Kennungen: den **Distinguished Name** (`CN=Anna,OU=Vertrieb,DC=firma,DC=local`), eine **GUID** und für Sicherheitsprinzipale eine **SID**. Die SID setzt sich aus der Domänen-SID und einer **RID** zusammen; bekannte RIDs: 500 = eingebauter Administrator, 512 = Domain Admins, 519 = Enterprise Admins.

Sicherheitsrelevant ist die Frage, wer Rechte **auf** OUs hat: Wer eine OU verwalten darf, kann Gruppenrichtlinien verknüpfen, Passwörter darin zurücksetzen oder Objekte verschieben – oft unbemerkt weitreichend. Deshalb OU-Delegation dokumentieren und regelmäßig prüfen.

## Quiz

? Was ist die eigentliche Sicherheitsgrenze in Active Directory?
= Forest
= der Forest
! Domänen innerhalb eines Forests vertrauen sich gegenseitig.

? Wie heißt die AD-Datenbankdatei auf einem Domain Controller?
= NTDS.dit
! Sie enthält u. a. die Passwort-Hashes aller Konten.

? Wofür werden OUs hauptsächlich genutzt?
+ Objekte strukturieren, Rechte delegieren und Gruppenrichtlinien zuweisen
- Daten verschlüsseln
- Netzwerkverkehr routen
- Backups speichern
! OUs sind die Verwaltungscontainer innerhalb einer Domäne.

? Was steuern Sites in AD?
+ Zuordnung von Clients zu nahen DCs und Replikation zwischen Standorten
- Benutzerpasswörter
- Dateiberechtigungen
- Druckerwarteschlangen
! Sites bilden die physische Netzwerktopologie ab.

? Welche RID hat die Gruppe Domain Admins?
= 512
! 500 = Administrator, 512 = Domain Admins, 519 = Enterprise Admins.

?tf Wer volle Kontrolle über eine Domäne hat, kann oft den ganzen Forest kompromittieren.
= wahr
! Deshalb gilt der Forest als Sicherheitsgrenze.

? Welche FSMO-Rolle ist u. a. für die Zeitsynchronisation zuständig?
= PDC-Emulator
= PDC Emulator
= PDC
! Der PDC-Emulator ist Zeitquelle der Domäne.

@@@ MODULE @@@
---
id: adx-02
title: AD verstehen 2 · Gruppen, Verschachtelung und privilegierte Gruppen
paths: cpts, cape, cdsa, specialist
order: 12.2
difficulty: medium
icon: person.3.fill
tags: active directory, gruppen
summary: Gruppentypen und -bereiche, das AGDLP-Prinzip und warum verschachtelte Mitgliedschaften und Schattenadmins gefährlich sind.
---

## Einfach erklärt

Gruppen sind Schlüsselbunde. Statt jedem Mitarbeiter einzeln Schlüssel zu geben, hängt man Schlüssel an einen Bund und gibt den Bund aus. Problem: Bunde können an anderen Bunden hängen – und plötzlich hat jemand über drei Ecken den Generalschlüssel.

## Typen und Bereiche

| Bereich | Mitglieder aus | Verwendbar in |
|---|---|---|
| Domänenlokal | beliebigen Domänen des Forests/vertrauten Domänen | nur eigene Domäne |
| Global | eigener Domäne | ganzem Forest |
| Universal | ganzem Forest | ganzem Forest |

**Sicherheitsgruppen** vergeben Rechte, **Verteilergruppen** nur E-Mail.

**AGDLP**: Accounts → Global Groups (Rolle) → Domain Local Groups (Ressourcenrecht) → Permissions. So bleibt nachvollziehbar, warum jemand ein Recht hat.

## Privilegierte Gruppen

| Gruppe | Warum kritisch |
|---|---|
| Enterprise Admins / Domain Admins / Administrators | volle Kontrolle |
| Schema Admins | Forest-Schema ändern |
| Account Operators | viele Konten verwalten |
| Backup Operators | Dateien auf DCs lesen – inkl. NTDS.dit |
| Server Operators | Dienste auf DCs ändern |
| Print Operators | Treiber auf DCs laden |
| DnsAdmins | kann DNS-Dienst auf DCs beeinflussen |
| Group Policy Creator Owners | GPOs erstellen |

> [!WARNUNG] Schattenadmins
> Konten, die nicht in „Domain Admins“ stehen, aber über Gruppen wie Backup Operators, Rechte auf AdminSDHolder oder Kontrolle über GPOs faktisch Admin werden können.

## Tiefer eingetaucht

Schutzmechanismen: **AdminSDHolder** setzt stündlich (SDProp) die Berechtigungen geschützter Konten zurück; Mitglieder erhalten `adminCount=1`. Achtung: Wer einmal Mitglied war, behält oft `adminCount=1` und abweichende Berechtigungen.

Gute Praxis:

- Privilegierte Gruppen möglichst **leer** halten; Mitgliedschaft nur temporär (JIT/PAM).
- Mitgliedschaftsänderungen überwachen (Events 4728, 4732, 4756).
- Verschachtelung in privilegierte Gruppen vermeiden; regelmäßig mit Werkzeugen wie PingCastle oder BloodHound (defensiv) prüfen, **wer effektiv** Admin werden kann.
- Konto „Administrator“ (RID 500) sicher verwahren, nicht im Alltag nutzen.

## Quiz

? Welcher Gruppenbereich kann Mitglieder aus dem ganzen Forest enthalten und überall verwendet werden?
= Universal
= universell
! Universelle Gruppen werden im Global Catalog repliziert.

? Wofür steht das A am Anfang von AGDLP?
= Accounts
= Account
! Konten kommen in globale Gruppen, diese in domänenlokale, diese erhalten Rechte.

? Warum ist die Gruppe Backup Operators auf DCs kritisch?
+ ihre Mitglieder können die AD-Datenbank sichern und damit Hashes erlangen
- sie darf das Internet nicht nutzen
- sie ist für Drucker zuständig
- sie hat keine Rechte
! Sicherungsrechte umgehen Dateiberechtigungen.

? Welches Objekt setzt die Rechte geschützter Konten regelmäßig zurück?
= AdminSDHolder
! Der SDProp-Prozess läuft standardmäßig stündlich.

?tf Ein Konto mit adminCount=1 ist garantiert aktuell Mitglied einer privilegierten Gruppe.
= falsch
! Das Attribut bleibt oft nach dem Entfernen bestehen.

? Welche Event-ID zeigt das Hinzufügen zu einer globalen Sicherheitsgruppe?
= 4728
! 4732 = domänenlokal, 4756 = universell.

? Wie nennt man Konten, die ohne offensichtliche Admin-Gruppe faktisch Admin-Rechte erlangen können?
= Schattenadmins
= Shadow Admins
! Sie entstehen über verschachtelte Gruppen und delegierte Rechte.

@@@ MODULE @@@
---
id: adx-03
title: AD verstehen 3 · Kerberos einfach erklärt
paths: cpts, cape, cdsa, cjca
order: 12.3
difficulty: medium
icon: ticket.fill
tags: active directory, kerberos
summary: Wie Kerberos mit Tickets statt Passwörtern arbeitet – AS, TGS, TGT, Service-Tickets – und welche Angriffe auf welche Schwäche zielen.
---

## Einfach erklärt

Kerberos funktioniert wie ein Freizeitpark:

1. Am Eingang zeigst du einmal deinen Ausweis und bekommst ein **Tagesarmband** (TGT – Ticket Granting Ticket).
2. An jeder Attraktion zeigst du das Armband am Ticketschalter und bekommst eine **Fahrkarte** für genau diese Attraktion (Service-Ticket).
3. Die Attraktion prüft nur die Fahrkarte – dein Ausweis wird nicht mehr gebraucht.

Der Vorteil: Dein Passwort wird nicht ständig über das Netz geschickt.

## Die Beteiligten

| Rolle | Wer |
|---|---|
| Client | Benutzer bzw. sein Rechner |
| KDC (Key Distribution Center) | läuft auf jedem Domain Controller |
| AS (Authentication Service) | stellt das TGT aus |
| TGS (Ticket Granting Service) | stellt Service-Tickets aus |
| Dienst | z. B. Dateiserver, identifiziert über einen **SPN** |

## Ablauf

1. **AS-REQ/AS-REP**: Der Client beweist mit einem aus dem Passwort abgeleiteten Schlüssel, wer er ist (Vorauthentifizierung) und erhält das TGT. Das TGT ist mit dem Schlüssel des Kontos **krbtgt** verschlüsselt.
2. **TGS-REQ/TGS-REP**: Mit dem TGT fordert er ein Service-Ticket an. Dieses ist mit dem Schlüssel des **Dienstkontos** verschlüsselt.
3. **AP-REQ**: Der Client legt das Service-Ticket beim Dienst vor.

> [!MERKE] Wer den Schlüssel hat, macht die Tickets
> Das krbtgt-Konto signiert alle TGTs. Wer dessen Hash besitzt, kann beliebige TGTs fälschen (Golden Ticket). Wer den Hash eines Dienstkontos hat, kann Tickets für diesen Dienst fälschen (Silver Ticket).

## Tiefer eingetaucht

Angriffsklassen und ihre Ursache (konzeptionell):

| Klasse | Ausgenutzte Eigenschaft | Abwehr |
|---|---|---|
| Kerberoasting | Service-Tickets sind mit dem Dienstkonto-Schlüssel verschlüsselt und offline angreifbar | lange Zufallspasswörter, gMSA, AES statt RC4 |
| AS-REP-Roasting | Konten ohne Vorauthentifizierung | Vorauthentifizierung nie deaktivieren |
| Golden Ticket | gestohlener krbtgt-Hash | krbtgt-Passwort zweimal rotieren, DCs schützen |
| Silver Ticket | gestohlener Dienstkonto-Hash | PAC-Validierung, Dienstkonten schützen |
| Delegationsmissbrauch | zu weit gefasste Delegation | Delegation einschränken, sensible Konten markieren |

Kerberos braucht **synchronisierte Zeit** (Standard: max. 5 Minuten Abweichung) und **DNS**, weil Dienste über Namen (SPNs) gefunden werden.

## Quiz

? Wofür steht TGT?
= Ticket Granting Ticket
! Das „Tagesarmband“, mit dem man Service-Tickets anfordert.

? Mit welchem Schlüssel ist das TGT verschlüsselt?
+ dem Schlüssel des krbtgt-Kontos
- dem Passwort des Benutzers
- dem Schlüssel des Dateiservers
- gar nicht
! Deshalb ist der krbtgt-Hash so wertvoll.

? Wie heißt die Kennung, über die Kerberos einen Dienst identifiziert?
= SPN
= Service Principal Name
! Beispiel: MSSQLSvc/sql01.firma.local:1433.

? Welche Schwäche nutzt Kerberoasting aus?
+ Service-Tickets sind mit dem Schlüssel des Dienstkontos verschlüsselt und offline angreifbar
- fehlende Firewall
- unverschlüsselte E-Mails
- schwache WLAN-Passwörter
! Mit schwachem Dienstkonto-Passwort lässt sich der Schlüssel offline erraten.

? Welche Abwehr hilft am besten gegen Kerberoasting?
+ gMSA bzw. sehr lange Zufallspasswörter für Dienstkonten
- kürzere Bildschirmsperre
- mehr Speicher auf dem DC
- VPN für alle Nutzer
! Group Managed Service Accounts haben automatisch rotierte, sehr lange Passwörter.

?tf Kerberos funktioniert auch mit stark abweichenden Uhrzeiten zuverlässig.
= falsch
! Standardmäßig sind höchstens 5 Minuten Abweichung erlaubt.

? Was muss nach einem Golden-Ticket-Verdacht mit dem krbtgt-Passwort geschehen?
+ zweimal zurücksetzen, mit Abstand
- einmal löschen
- nichts, es läuft automatisch ab
- in Base64 umwandeln
! Es werden zwei Passwortversionen akzeptiert; erst der zweite Wechsel entwertet alte Tickets vollständig.

@@@ MODULE @@@
---
id: adx-04
title: AD verstehen 4 · NTLM und Relay-Angriffe verhindern
paths: cpts, cape, cdsa, specialist
order: 12.4
difficulty: hard
icon: arrow.triangle.swap
tags: active directory, ntlm, relay
summary: Wie NTLM-Challenge-Response funktioniert, warum Relay möglich ist und wie Signing, EPA, LLMNR-Abschaltung und NTLM-Reduktion schützen.
---

## Einfach erklärt

NTLM ist ein älteres Anmeldeverfahren: Der Server stellt eine Rechenaufgabe (Challenge), der Client löst sie mit seinem Passwort-Hash (Response). Das Problem: Ein Angreifer in der Mitte kann die Aufgabe eines **echten** Servers an das Opfer weiterreichen und die Lösung zurückgeben – er meldet sich so mit fremder Identität an, ohne das Passwort zu kennen. Das ist ein **Relay**.

## Ablauf und Schwachstellen

1. Client → Server: „Ich will mich anmelden“ (NEGOTIATE)
2. Server → Client: Challenge
3. Client → Server: Response (aus Challenge + NT-Hash berechnet)

Schwächen:

- Die Response ist nicht an das Ziel gebunden – sie lässt sich **weiterleiten**.
- Der NT-Hash ist passwortäquivalent – **Pass-the-Hash**.
- NetNTLMv1 ist kryptografisch schwach; v2 ist offline angreifbar, wenn das Passwort schwach ist.

## Wie Opfer zum Angreifer gelockt werden

- **LLMNR/NBT-NS/mDNS**: Findet DNS einen Namen nicht, fragt Windows per Broadcast in die Runde – jeder kann antworten („Ich bin der Server!“).
- **Erzwungene Authentifizierung** (Coercion): Dienste wie der Druckerspooler oder bestimmte RPC-Schnittstellen lassen sich dazu bringen, sich bei einem beliebigen Host anzumelden.
- **WPAD**: Automatische Proxy-Erkennung über Namensauflösung.

## Schutzmaßnahmen

| Maßnahme | Wirkung |
|---|---|
| SMB-Signing erzwingen | Relay auf SMB scheitert |
| LDAP-Signing und Channel Binding | Relay auf LDAP(S) scheitert |
| EPA (Extended Protection for Authentication) | bindet Anmeldung an den TLS-Kanal (HTTP, z. B. ADCS-Webenrollment) |
| LLMNR und NBT-NS deaktivieren | entzieht Broadcast-Täuschung die Grundlage |
| Druckerspooler auf DCs/Servern deaktivieren | weniger Coercion-Möglichkeiten |
| NTLM auditieren und reduzieren | Kerberos bevorzugen, NTLMv1 verbieten |

> [!EXAM] Merksatz
> Relay braucht ein Ziel ohne Signing/Channel Binding. Signing überall erzwingen ist die wirksamste Einzelmaßnahme.

## Tiefer eingetaucht

Erkennung: Event 4624 mit Authentifizierungspaket NTLM, besonders Anmeldungen von Computerkonten an ungewöhnlichen Zielen; Netzwerkanomalien wie LLMNR-Antworten von Arbeitsplätzen; NTLM-Audit-Ereignisse (8001–8004 im NTLM-Operational-Log) zeigen, wer noch NTLM nutzt.

Microsoft treibt die Abkehr von NTLM voran (u. a. IAKerb, lokaler KDC). Bis dahin gilt: inventarisieren, wo NTLM noch nötig ist, und den Rest abschalten.

## Quiz

? Was macht ein NTLM-Relay-Angriff?
+ leitet die Challenge-Response eines Opfers an einen anderen Server weiter
- knackt das Passwort per Brute Force
- verschlüsselt die Festplatte
- fälscht ein Kerberos-Ticket
! Der Angreifer kennt das Passwort nicht, nutzt aber die gültige Antwort.

? Welche Maßnahme verhindert Relay auf SMB?
= SMB-Signing
= SMB Signing
! Signierte Sitzungen können nicht ohne den Sitzungsschlüssel übernommen werden.

? Welche Protokolle sollten deaktiviert werden, um Broadcast-Namensauflösungs-Täuschung zu verhindern?
+ LLMNR
+ NBT-NS
- DNS
- DHCP
! Ohne diese Fallbacks kann niemand im Netz „Ich bin es!“ rufen.

? Wofür steht EPA im Zusammenhang mit NTLM?
= Extended Protection for Authentication
! EPA bindet die Anmeldung an den TLS-Kanal.

?tf Der NT-Hash eines Kontos ist passwortäquivalent.
= wahr
! Mit ihm kann man sich per NTLM anmelden (Pass-the-Hash).

? Welcher Dienst sollte auf Domain Controllern deaktiviert werden, um Coercion zu erschweren?
+ Druckerspooler
- DNS-Server
- Netlogon
- Kerberos
! Der Spooler wurde vielfach für erzwungene Authentifizierung missbraucht.

? Welche NTLM-Version sollte verboten werden?
= NTLMv1
= v1
! NTLMv1 ist kryptografisch schwach.

@@@ MODULE @@@
---
id: adx-05
title: AD verstehen 5 · Delegation sicher gestalten
paths: cape, cpts, specialist
order: 12.5
difficulty: hard
icon: person.line.dotted.person.fill
tags: active directory, kerberos, delegation
summary: Uneingeschränkte, eingeschränkte und ressourcenbasierte Delegation – wofür sie gedacht sind, warum sie riskant sind und wie man sie absichert.
---

## Einfach erklärt

Manchmal muss ein Dienst **im Namen eines Nutzers** auf einen anderen Dienst zugreifen: Ein Webserver holt die Daten des angemeldeten Nutzers aus einer Datenbank. Dafür gibt es **Delegation** – eine Vollmacht. Wie im echten Leben gilt: Eine Generalvollmacht ist gefährlich, eine eng begrenzte ist vertretbar.

## Die drei Arten

| Art | Wie | Risiko |
|---|---|---|
| Uneingeschränkt (Unconstrained) | Dienst erhält das TGT des Nutzers und darf **überall** in seinem Namen auftreten | sehr hoch – kompromittierter Server sammelt TGTs, auch von Admins |
| Eingeschränkt (Constrained, KCD) | Dienst darf nur zu festgelegten Ziel-SPNs delegieren | mittel – mit „Protocol Transition“ höher |
| Ressourcenbasiert (RBCD) | das **Ziel** legt fest, wer zu ihm delegieren darf (`msDS-AllowedToActOnBehalfOfOtherIdentity`) | wer dieses Attribut schreiben darf, kontrolliert die Delegation |

> [!GEFAHR] Uneingeschränkte Delegation
> Ein Server mit uneingeschränkter Delegation speichert die TGTs aller Nutzer, die sich bei ihm anmelden. Lässt sich ein Domain Controller dazu bringen, sich dort anzumelden (Coercion), gerät dessen TGT in falsche Hände.

## Absichern

1. **Inventar**: Welche Konten/Computer haben Delegation? (Ausnahme: DCs haben standardmäßig uneingeschränkte Delegation.)
2. Uneingeschränkte Delegation **entfernen**; durch eingeschränkte oder RBCD ersetzen.
3. Sensible Konten mit **„Account is sensitive and cannot be delegated“** markieren oder in **Protected Users** aufnehmen.
4. Schreibrechte auf Computerobjekte beschränken (RBCD-Missbrauch) und `ms-DS-MachineAccountQuota` auf 0 setzen, damit normale Nutzer keine Computerkonten anlegen.
5. Änderungen an Delegationsattributen überwachen (Event 5136).

## Tiefer eingetaucht

Technisch basieren eingeschränkte Delegationen auf den Kerberos-Erweiterungen **S4U2Self** (Ticket für einen Nutzer an sich selbst anfordern) und **S4U2Proxy** (damit zu einem anderen Dienst weitergehen). „Protocol Transition“ erlaubt, auch Nutzer zu vertreten, die sich gar nicht per Kerberos angemeldet haben – entsprechend weitreichend.

Prüfen lässt sich die Delegationslage z. B. mit PowerShell (`Get-ADComputer -Filter {TrustedForDelegation -eq $true}`), PingCastle oder BloodHound. Für Prüfungen wie CAPE ist entscheidend, die Bedingungen zu verstehen, unter denen eine Delegation zu Rechteausweitung führt – und welches Attribut oder Recht dafür nötig ist.

## Quiz

? Welche Delegationsart ist am gefährlichsten?
+ uneingeschränkte Delegation
- eingeschränkte Delegation ohne Protocol Transition
- gar keine Delegation
- Delegation nur an einen SPN
! Der Server erhält die TGTs aller Nutzer, die sich anmelden.

? Wo wird bei RBCD festgelegt, wer delegieren darf?
+ am Zielobjekt im Attribut msDS-AllowedToActOnBehalfOfOtherIdentity
- in der Gruppenrichtlinie des Clients
- im DNS
- im Benutzerobjekt des Admins
! Wer dieses Attribut schreiben kann, kontrolliert die Delegation.

? Wie schützt man Admin-Konten vor Delegation?
+ „Account is sensitive and cannot be delegated“ setzen oder Protected Users nutzen
- ihnen kein Passwort geben
- sie in eine OU namens „Sicher“ verschieben
- sie täglich umbenennen
! Dann werden für diese Konten keine delegierbaren Tickets ausgestellt.

? Welches Attribut sollte auf 0 gesetzt werden, damit normale Nutzer keine Computerkonten anlegen können?
= ms-DS-MachineAccountQuota
= MachineAccountQuota
! Standardmäßig darf jeder Nutzer 10 Computerkonten anlegen.

?tf Domain Controller haben standardmäßig uneingeschränkte Delegation.
= wahr
! Das ist erwartet; außerhalb von DCs sollte sie nicht vorkommen.

? Welche Kerberos-Erweiterungen liegen eingeschränkter Delegation zugrunde?
+ S4U2Self
+ S4U2Proxy
- AS-REQ
- NTLMv2
! Sie erlauben das Anfordern von Tickets im Namen anderer Nutzer.

? Welche Event-ID zeigt Änderungen an Verzeichnisobjekt-Attributen?
= 5136
! Directory Service Changes – Überwachung muss aktiviert sein.

@@@ MODULE @@@
---
id: adx-06
title: AD verstehen 6 · Tiering, PAWs und administrative Hygiene
paths: cape, cdsa, specialist
order: 12.6
difficulty: medium
icon: square.3.layers.3d
tags: active directory, härtung, tiering
summary: Wie das Ebenenmodell Admin-Anmeldedaten schützt, was Privileged Access Workstations sind und welche Gewohnheiten Domänen wirklich sicherer machen.
---

## Einfach erklärt

Ein Bankdirektor trägt den Tresorschlüssel nicht mit in die Kantine. Genauso sollten Domänen-Admins ihre Anmeldedaten nicht auf Rechnern verwenden, auf denen E-Mails geöffnet und Webseiten besucht werden. Denn: **Wo man sich anmeldet, bleiben Spuren der Anmeldedaten im Speicher** – und ein Angreifer auf diesem Rechner kann sie stehlen.

## Das Ebenenmodell (Tiering)

| Ebene | Systeme | Admins |
|---|---|---|
| Tier 0 | DCs, AD-Konten mit Domänenrechten, PKI, Entra Connect, Identity-Systeme | Tier-0-Admins |
| Tier 1 | Server und Anwendungen | Server-Admins |
| Tier 2 | Arbeitsplätze und Endgeräte | Helpdesk |

**Regel**: Ein Konto einer höheren Ebene meldet sich **nie** interaktiv an einem System einer niedrigeren Ebene an. Durchsetzen lässt sich das z. B. mit Gruppenrichtlinien („Deny log on locally/through RDP“) oder Authentication Policies/Silos.

> [!MERKE] Tier 0 ist alles, was Tier 0 kontrollieren kann
> Auch ein Backup-Server, der DCs sichert, oder ein Management-Tool mit Agent auf DCs gehört zu Tier 0.

## Privileged Access Workstations (PAW)

Ein gehärteter Rechner nur für Administration: keine E-Mails, kein Surfen, Application Control, Credential Guard, MFA. Von dort aus wird über Sprungserver verwaltet.

## Hygiene-Checkliste

- Getrennte Admin-Konten, Admin-Rechte nur temporär.
- **LAPS** für lokale Administratorkonten.
- **Protected Users** für privilegierte Konten.
- **Credential Guard** auf Clients und Servern.
- Dienstkonten als **gMSA**; keine Dienstkonten in Domain Admins.
- Alte Protokolle (NTLMv1, SMBv1, RC4) abschalten.
- krbtgt-Passwort regelmäßig rotieren.
- Regelmäßige AD-Sicherheitsbewertung (PingCastle, Purple Knight, BloodHound).

## Tiefer eingetaucht

Microsoft hat das klassische Tiermodell im „Enterprise Access Model“ weiterentwickelt (Control Plane, Management Plane, Data/Workload Plane, User/App Access) – die Grundidee bleibt: Kontrolle über Identitäten ist die höchste Ebene und muss isoliert werden.

Die Umsetzung ist ein Projekt, kein Schalter: Tier-0-Assets identifizieren, Anmeldewege kartieren, Konten trennen, Richtlinien schrittweise durchsetzen, Ausnahmen dokumentieren. Der Nutzen ist enorm: Selbst ein vollständig kompromittierter Arbeitsplatz liefert dann keine Domänen-Admin-Anmeldedaten mehr.

## Quiz

? Welche Systeme gehören zu Tier 0?
+ Domain Controller
+ PKI-Server
+ Entra Connect
- normale Arbeitsplätze
! Alles, was Identitäten kontrolliert, ist Tier 0.

? Was ist die Grundregel des Tiering?
+ Konten höherer Ebenen melden sich nicht an Systemen niedrigerer Ebenen an
- alle Admins nutzen ein gemeinsames Konto
- Arbeitsplätze verwalten Server
- Tier 2 ist am wichtigsten
! So bleiben privilegierte Anmeldedaten von unsicheren Systemen fern.

? Wofür steht PAW?
= Privileged Access Workstation
! Ein gehärteter Rechner ausschließlich für administrative Tätigkeiten.

?tf Ein Backup-Server, der Domain Controller sichert, gehört faktisch zu Tier 0.
= wahr
! Wer die Sicherung kontrolliert, kontrolliert auch die AD-Daten.

? Welche Funktion schützt Anmeldedaten im Speicher per Virtualisierung?
= Credential Guard
! Geheimnisse liegen in einer isolierten Umgebung, nicht im normalen LSASS-Speicher.

? Was sollten Dienstkonten idealerweise sein?
+ gMSA
- Mitglieder von Domain Admins
- Konten mit nie ablaufendem, kurzem Passwort
- persönliche Benutzerkonten
! gMSAs haben automatisch rotierte, lange Passwörter.

? Welches Werkzeug bewertet die AD-Sicherheit mit einem Score und Empfehlungen?
= PingCastle
! Alternativen: Purple Knight, BloodHound für Angriffspfade.

@@@ MODULE @@@
---
id: adx-07
title: AD verstehen 7 · Angriffspfade mit BloodHound defensiv lesen
paths: cape, cpts, cdsa
order: 12.7
difficulty: hard
icon: point.topleft.down.to.point.bottomright.curvepath
tags: active directory, bloodhound, graph
summary: Warum Verteidiger in Graphen denken müssen, welche Kanten Rechte bedeuten und wie man die wichtigsten Pfade zu Tier 0 abschneidet.
---

## Einfach erklärt

Angreifer denken in **Wegen**, Verteidiger oft in **Listen**. Eine Liste sagt: „Anna ist in Gruppe X.“ Ein Graph sagt: „Anna ist in Gruppe X, X darf das Passwort von Ben ändern, Ben ist Admin auf Server Y, auf Y ist ein Domain-Admin angemeldet.“ Erst der Weg zeigt das Risiko. **BloodHound** visualisiert genau diese Wege.

## Knoten und Kanten

**Knoten**: Benutzer, Gruppen, Computer, OUs, GPOs, Domänen.

**Kanten** (Beziehungen), Auswahl:

| Kante | Bedeutung |
|---|---|
| MemberOf | Mitgliedschaft |
| AdminTo | lokaler Admin auf Computer |
| HasSession | Nutzer ist auf Computer angemeldet (Anmeldedaten im Speicher) |
| GenericAll / GenericWrite | volle bzw. Schreibrechte auf Objekt |
| WriteDacl / WriteOwner | darf Rechte bzw. Besitzer ändern |
| ForceChangePassword | darf Passwort zurücksetzen |
| AddMember | darf Gruppenmitglieder hinzufügen |
| GPLink / GenericWrite auf GPO | Kontrolle über Richtlinien von OUs |
| AllowedToDelegate / AllowedToAct | Delegation |
| DCSync (GetChanges/GetChangesAll) | darf Passwortdaten replizieren |

> [!MERKE] Jede Kante ist eine Frage
> „Muss Gruppe X wirklich GenericAll auf diese OU haben?“ – Viele gefährliche Kanten sind historische Altlasten.

## Defensiv vorgehen

1. Daten sammeln (mit Erlaubnis und abgestimmt mit dem SOC, sonst löst die Sammlung Alarme aus).
2. **Tier 0 markieren** (High Value Targets).
3. Kürzeste Pfade von „Domain Users“ bzw. „Authenticated Users“ zu Tier 0 anzeigen.
4. **Engpässe** finden: Kanten, die in vielen Pfaden vorkommen – eine Korrektur schneidet viele Wege ab.
5. Beheben, neu sammeln, Verbesserung messen.

## Tiefer eingetaucht

Typische Funde und Korrekturen:

- **Helpdesk-Gruppe mit ForceChangePassword auf Admins** → Rechte auf Nicht-Admin-OUs beschränken.
- **Domain-Admin-Sessions auf Servern/Arbeitsplätzen** → Tiering durchsetzen.
- **Lokaler Admin für „Domain Users“** auf vielen Rechnern → GPO bereinigen.
- **GenericWrite auf GPOs, die auf DCs wirken** → Rechte entfernen.
- **DCSync-Rechte** für Nicht-DC-Konten → entfernen (häufig Altlast von Sync-Werkzeugen).

BloodHound Community Edition und Enterprise unterstützen auch **Entra ID** (AzureHound) – hybride Pfade, etwa über Entra Connect oder Rollen mit Rechten auf Geräte, werden sichtbar. Ergänzend messen Werkzeuge wie PingCastle die „Hygiene“; BloodHound zeigt die **Ausnutzbarkeit**.

## Quiz

? Was bedeutet die Kante HasSession?
+ ein Nutzer ist auf einem Computer angemeldet, seine Anmeldedaten liegen dort im Speicher
- ein Nutzer hat ein Passwort
- ein Computer ist eingeschaltet
- eine Gruppe ist leer
! Wer den Computer kontrolliert, kann die Sitzung ggf. missbrauchen.

? Welche Kante erlaubt, die Berechtigungen eines Objekts zu ändern?
= WriteDacl
! Damit kann man sich selbst beliebige Rechte geben.

? Welche Rechte ermöglichen DCSync?
+ Replicating Directory Changes
+ Replicating Directory Changes All
- Read Property
- List Contents
! Damit lassen sich Passwort-Hashes vom DC replizieren.

?tf Eine BloodHound-Sammlung im Unternehmensnetz sollte mit dem SOC abgestimmt werden.
= wahr
! Die Abfragen ähneln Angreiferverhalten und können Alarme auslösen.

? Warum sucht man nach „Engpass“-Kanten?
+ weil ihre Korrektur viele Angriffspfade gleichzeitig abschneidet
- weil sie am leichtesten zu finden sind
- weil sie nur Computer betreffen
- weil BloodHound nur diese anzeigt
! Maximale Wirkung mit minimalem Aufwand.

? Wie heißt der Collector, der Entra-ID-Daten für BloodHound sammelt?
= AzureHound
! So werden hybride Angriffspfade sichtbar.

? Welche Kante beschreibt das Recht, ein Passwort ohne Kenntnis des alten zurückzusetzen?
= ForceChangePassword
! Gefährlich, wenn sie auf privilegierte Konten zeigt.

@@@ MODULE @@@
---
id: adx-08
title: AD verstehen 8 · Zertifikatsdienste (ADCS) sicher betreiben
paths: cape, specialist, cdsa
order: 12.8
difficulty: hard
icon: checkmark.seal.text.page.fill
tags: active directory, pki, adcs
summary: Warum falsch konfigurierte Zertifikatsvorlagen zur Domänenübernahme führen können und wie man Vorlagen, CA und Web-Enrollment absichert.
---

## Einfach erklärt

Eine Zertifizierungsstelle (CA) ist ein Passamt. Ein Zertifikat für die Anmeldung ist wie ein Personalausweis: Wer einen gültigen Ausweis auf den Namen des Chefs bekommt, wird überall als Chef behandelt. Ist das Passamt zu großzügig („Schreib einfach rein, wer du sein willst“), entsteht ein riesiges Problem.

## Wo die Gefahr liegt

Zertifikate mit dem Zweck **Client Authentication** erlauben die Kerberos-Anmeldung (PKINIT). Kritisch wird es, wenn:

| Fehlkonfiguration | Folge |
|---|---|
| Antragsteller darf den **Subject Alternative Name** frei wählen (`ENROLLEE_SUPPLIES_SUBJECT`) und normale Nutzer dürfen beantragen | Zertifikat für einen Admin beantragbar |
| Vorlagen mit sehr allgemeinen Zwecken (Any Purpose, keine EKU) | Zertifikat für alles verwendbar |
| zu weite **Schreibrechte auf Vorlagen** | Vorlage lässt sich gefährlich umkonfigurieren |
| **Web-Enrollment** per HTTP mit NTLM ohne EPA | Relay-Angriff auf die CA |
| Flag `EDITF_ATTRIBUTESUBJECTALTNAME2` an der CA | SAN für jede Vorlage angebbar |
| Enrollment-Agent-Vorlagen zu offen | Zertifikate im Namen anderer |

In der Fachliteratur sind diese Klassen als **ESC1, ESC2, …** durchnummeriert.

> [!GEFAHR] Zertifikate überleben Passwortwechsel
> Ein gestohlenes oder missbräuchlich ausgestelltes Anmeldezertifikat bleibt bis zum Ablauf gültig – auch wenn das Passwort geändert wird. Widerruf und CRL-Prüfung sind entscheidend.

## Absichern

1. Vorlagen inventarisieren (z. B. mit Locksmith, PSPKIAudit oder Certify im Audit-Modus).
2. `Supply in the request` nur, wo zwingend nötig – dann **Genehmigung durch CA-Manager** verlangen.
3. Enrollment-Rechte eng fassen; Schreibrechte auf Vorlagen nur für PKI-Admins.
4. Web-Enrollment: nur HTTPS mit **EPA**, NTLM deaktivieren oder Rolle entfernen.
5. CA-Server als **Tier 0** behandeln.
6. Microsoft-Härtung für **strenge Zertifikatszuordnung** (Strong Mapping) aktivieren.
7. Ausstellung überwachen: Events 4886/4887 (Anfrage/Ausstellung), ungewöhnliche SANs.

## Tiefer eingetaucht

Eine PKI ist Vertrauensanker vieler Systeme (WLAN-802.1X, VPN, Smartcards, TLS). Wer die CA-Schlüssel stiehlt, kann beliebige Zertifikate fälschen („Golden Certificate“). Deshalb: privater CA-Schlüssel idealerweise im **HSM**, Offline-Root-CA, getestetes Backup und Wiederherstellungskonzept.

## Quiz

? Welcher Erweiterter Schlüsselverwendungszweck erlaubt die Anmeldung per Zertifikat?
= Client Authentication
! Zusammen mit PKINIT kann man damit Kerberos-Tickets erhalten.

? Welche Vorlageneinstellung ist besonders gefährlich, wenn normale Nutzer beantragen dürfen?
+ der Antragsteller darf den Subject Alternative Name selbst angeben
- die Gültigkeit beträgt ein Jahr
- der Schlüssel ist 2048 Bit lang
- die Vorlage hat einen Anzeigenamen
! Man könnte ein Zertifikat für einen Admin beantragen.

?tf Ein Passwortwechsel macht ein bereits ausgestelltes Anmeldezertifikat ungültig.
= falsch
! Zertifikate müssen widerrufen werden.

? Wie werden die bekannten ADCS-Fehlkonfigurationsklassen nummeriert?
= ESC
= ESC1
! ESC1, ESC2, ESC8 usw. beschreiben unterschiedliche Fehlkonfigurationen.

? Wie sichert man Web-Enrollment gegen Relay?
+ nur HTTPS mit Extended Protection for Authentication
- längere Passwörter
- mehr Vorlagen
- HTTP statt HTTPS
! EPA bindet die Anmeldung an den TLS-Kanal.

? Zu welcher Ebene gehört ein CA-Server im Tiermodell?
= Tier 0
= 0
! Wer die CA kontrolliert, kann Identitäten fälschen.

? Wo sollte der private Schlüssel einer CA idealerweise liegen?
= HSM
= Hardware-Sicherheitsmodul
! Das HSM verhindert das Kopieren des Schlüssels.

@@@ MODULE @@@
---
id: adx-09
title: AD verstehen 9 · Forest-Recovery und AD-Backup
paths: cape, specialist, cdsa
order: 12.9
difficulty: hard
icon: arrow.counterclockwise.circle.fill
tags: active directory, wiederherstellung, backup
summary: Wie man Active Directory nach einer vollständigen Kompromittierung oder Ransomware wiederherstellt – Backups, Reihenfolge, Bereinigung.
---

## Einfach erklärt

Wenn Active Directory komplett verschlüsselt oder übernommen wurde, funktioniert nichts mehr: keine Anmeldung, keine Dateifreigaben, oft kein E-Mail. Eine **Forest-Recovery** ist der Wiederaufbau des Fundaments – und er muss geübt sein, bevor man ihn braucht.

## Was gesichert werden muss

- **System State** mindestens zweier DCs pro Domäne (enthält AD-Datenbank, SYSVOL, Registry).
- Sicherungen **offline/unveränderlich** und getrennt von der Domäne (eigene Anmeldedaten!).
- Dokumentation: Domänen, DCs, FSMO-Rollen, DNS-Konfiguration, Trusts, Kennwort für den **DSRM** (Directory Services Restore Mode).
- Aufbewahrung über die **Tombstone Lifetime** hinaus bedenken (Standard 180 Tage): Ältere Sicherungen sind problematisch.

> [!WARNUNG] Backup vom kompromittierten Zustand
> Eine Sicherung nach dem Einbruch enthält möglicherweise Hintertüren (neue Admins, manipulierte GPOs, krbtgt-Hash beim Angreifer). Wiederherstellen allein reicht nicht – man muss **bereinigen**.

## Ablauf einer Forest-Recovery (vereinfacht)

1. Netz isolieren; Wiederherstellungsumgebung ohne Kontakt zum kompromittierten Netz.
2. **Einen** DC pro Domäne aus einer vertrauenswürdigen Sicherung wiederherstellen (autoritativ für SYSVOL).
3. Metadaten der übrigen DCs bereinigen, FSMO-Rollen übernehmen.
4. Bereinigen: **krbtgt zweimal** zurücksetzen, Passwörter privilegierter Konten und Dienstkonten neu setzen, Vertrauenskonten neu, verdächtige Objekte/GPOs entfernen.
5. Weitere DCs neu installieren und replizieren lassen.
6. Schrittweise Server und Clients wieder anbinden – mit Überwachung.

## Tiefer eingetaucht

Microsoft-Leitfaden und spezialisierte Werkzeuge (z. B. für automatisierte Forest-Recovery) helfen, aber das Wichtigste ist **Übung**: Eine Wiederherstellung in einem isolierten Labor zeigt, welche Abhängigkeiten fehlen (DNS, Zeit, Hardwaretreiber, Backup-Software, die selbst AD-Anmeldung braucht!).

Kennzahl: Wie lange dauert es realistisch, bis Anmeldungen wieder funktionieren? Viele Organisationen planen Stunden und brauchen Wochen. Eine dokumentierte, getestete Recovery ist eines der stärksten Mittel gegen Ransomware-Erpressung.

## Quiz

? Was enthält eine System-State-Sicherung eines DCs?
+ AD-Datenbank
+ SYSVOL
+ Registry
- alle Benutzerdokumente der Clients
! Der System State ist die Basis für die DC-Wiederherstellung.

? Wofür steht DSRM?
= Directory Services Restore Mode
! Ein Wiederherstellungsmodus mit eigenem lokalen Kennwort.

? Wie lang ist die Standard-Tombstone-Lifetime in neueren Forests?
= 180 Tage
= 180
! Sicherungen älter als die Tombstone Lifetime sind für AD problematisch.

?tf Nach einer Kompromittierung reicht es, das letzte Backup zurückzuspielen.
= falsch
! Das Backup kann bereits Hintertüren enthalten – Bereinigung ist nötig.

? Was muss nach einer Domänenkompromittierung mit dem krbtgt-Passwort passieren?
+ zweimal zurücksetzen
- unverändert lassen
- auf leer setzen
- in eine Datei exportieren
! Damit werden gefälschte TGTs ungültig.

? Warum sollten Backup-Systeme eigene, von der Domäne getrennte Anmeldedaten haben?
+ damit Angreifer mit Domänenrechten die Sicherungen nicht löschen können
- weil Backup-Software kein AD unterstützt
- damit Backups schneller laufen
- weil es gesetzlich vorgeschrieben ist
! Ransomware-Gruppen zielen gezielt auf Backups.

@@@ MODULE @@@
---
id: adx-10
title: AD verstehen 10 · Entra ID – Rollen, PIM und Conditional Access
paths: specialist, cdsa, cape
order: 13
difficulty: medium
icon: person.crop.circle.badge.checkmark
tags: entra id, cloud, identität
summary: Wie Microsofts Cloud-Identität funktioniert – Rollen, Privileged Identity Management, Conditional Access und die wichtigsten Schutzschalter.
---

## Einfach erklärt

Entra ID (früher Azure AD) ist der Ausweisdienst für Microsoft 365 und viele Cloud-Apps. Anders als das klassische AD gibt es keine Domain Controller im eigenen Keller – die Anmeldung läuft über das Internet. Deshalb ist **wer, von wo, mit welchem Gerät** hier die wichtigste Frage.

## Rollen

| Rolle | Kann |
|---|---|
| Global Administrator | alles |
| Privileged Role Administrator | Rollen vergeben – faktisch Global Admin |
| Security Administrator | Sicherheitseinstellungen |
| User Administrator | Nutzer verwalten, Passwörter zurücksetzen (nicht für Admins) |
| Application Administrator | Apps und deren Secrets verwalten – oft unterschätzt |
| Conditional Access Administrator | Zugriffsregeln ändern |

> [!WARNUNG] Wenige Global Admins
> Empfohlen sind weniger als fünf Global Admins, dazu zwei **Notfallkonten** (Break-Glass) mit sehr starkem Schutz und Überwachung.

## Privileged Identity Management (PIM)

Statt dauerhafter Rollen: **berechtigt** (eligible) statt **aktiv**. Bei Bedarf aktiviert man die Rolle für begrenzte Zeit, mit MFA, Begründung und ggf. Genehmigung. Jede Aktivierung wird protokolliert.

## Conditional Access

Regeln nach dem Muster **Wenn – Dann**:

- **Wenn** Benutzer X auf App Y von Ort Z mit Gerät W zugreift,
- **dann** erlauben, MFA verlangen, konformes Gerät verlangen oder blockieren.

Bewährte Grundregeln:

1. MFA für alle (phishing-resistent für Admins).
2. Legacy-Authentifizierung blockieren (IMAP/POP/SMTP-Basic-Auth umgehen MFA).
3. Admin-Zugriff nur von verwalteten Geräten.
4. Risikobasierte Regeln: hohes Anmelderisiko → blockieren oder Passwortwechsel.

## Tiefer eingetaucht

Angriffsflächen in Entra ID: Consent Phishing (bösartige Apps), Service Principals mit zu vielen Rechten, Token-Diebstahl (Cookies/Refresh-Tokens), Geräte-Code-Phishing, Synchronisationskonten von Entra Connect (Tier 0!). Gegenmittel: Nutzerzustimmung zu Apps einschränken, App-Berechtigungen regelmäßig prüfen, **Token Protection** und kontinuierliche Zugriffsevaluierung, Überwachung der Audit- und Sign-in-Logs.

Hybride Umgebungen verbinden beide Welten: Wer das lokale AD kontrolliert, kann je nach Konfiguration (Passwort-Hash-Sync, Pass-Through, Föderation) auch Cloud-Identitäten beeinflussen – und umgekehrt. Beide Seiten müssen als zusammenhängende Tier-0-Fläche betrachtet werden.

## Quiz

? Was macht Privileged Identity Management?
+ Admin-Rollen nur bei Bedarf und zeitlich begrenzt aktivieren
- Passwörter speichern
- Geräte verschlüsseln
- E-Mails filtern
! Berechtigt statt dauerhaft aktiv – weniger Angriffsfläche.

? Warum sollte Legacy-Authentifizierung blockiert werden?
+ sie umgeht MFA
- sie ist zu langsam
- sie funktioniert nur intern
- sie ist kostenpflichtig
! Alte Protokolle kennen keine moderne Authentifizierung mit MFA.

? Wie viele Global Admins werden empfohlen?
+ weniger als fünf
- mindestens zwanzig
- alle IT-Mitarbeiter
- genau einer ohne Notfallkonto
! Dazu zwei überwachte Notfallkonten.

? Wie heißt das Regelwerk „Wenn Nutzer/App/Ort/Gerät, dann Zugriff erlauben/MFA/blockieren“?
= Conditional Access
! Das zentrale Steuerinstrument für Zugriffe in Entra ID.

?tf Die Rolle „Privileged Role Administrator“ ist faktisch so mächtig wie Global Administrator.
= wahr
! Sie kann sich selbst oder anderen jede Rolle zuweisen.

? Wie nennt man Notfallkonten, die bei Ausfall von MFA oder Richtlinien den Zugriff sichern?
= Break-Glass
= Break Glass
= Notfallkonten
! Sie brauchen besonderen Schutz und lückenlose Überwachung.

? Welches lokale System gehört bei hybrider Identität zu Tier 0?
= Entra Connect
= Azure AD Connect
! Der Synchronisationsserver hat weitreichende Rechte in beiden Welten.
