---
id: f-12
title: Active Directory – Grundlagen
paths: grundlagen, cjca, cpts, cape
order: 12
difficulty: medium
icon: point.3.connected.trianglepath.dotted
summary: Domänen, Domain Controller, Forests, OUs, Gruppenrichtlinien, Kerberos und NTLM verständlich erklärt – das Fundament für jeden AD-Pfad.
htb: Active Directory Enumeration & Attacks
---

## Was ist Active Directory?

[[Active Directory]] (AD) ist der Verzeichnisdienst von Microsoft. Er speichert Benutzer, Computer, Gruppen und Richtlinien zentral und regelt, wer sich wo anmelden darf. Rund 90 % der großen Unternehmen nutzen AD – deshalb steht es im Zentrum von CPTS, CAPE und vielen Blue-Team-Aufgaben.

## Bausteine

| Begriff | Erklärung |
|---|---|
| Domäne | Verwaltungseinheit mit gemeinsamer Datenbank, z. B. `corp.local` |
| [[Domain Controller]] (DC) | Server, der die AD-Datenbank (`NTDS.dit`) hält und Anmeldungen prüft |
| Forest | Sammlung von Domänen mit gemeinsamem Schema; die oberste Sicherheitsgrenze |
| Tree | Domänen mit zusammenhängendem Namensraum |
| Organizational Unit (OU) | Ordner zur Strukturierung und Delegation |
| [[GPO]] | Gruppenrichtlinie – zentral verteilte Einstellungen |
| Trust | Vertrauensbeziehung zwischen Domänen oder Forests |
| Global Catalog | Teilkopie aller Objekte des Forests für schnelle Suche |

> [!MERKE] Die Sicherheitsgrenze ist der Forest
> Innerhalb eines Forests kann ein Administrator der Stammdomäne alle Domänen kontrollieren. Wer Bereiche wirklich trennen will, braucht getrennte Forests.

## Wichtige Gruppen

| Gruppe | Bedeutung |
|---|---|
| Domain Admins | volle Kontrolle über die Domäne |
| Enterprise Admins | volle Kontrolle über den Forest |
| Administrators (Builtin) | Admin auf den DCs |
| Account Operators, Backup Operators, Server Operators | mächtiger, als die Namen vermuten lassen |
| Protected Users | Mitglieder erhalten zusätzliche Schutzmaßnahmen (z. B. kein NTLM, keine Delegation) |

## Protokolle im AD

- **[[LDAP]]** (389/636) – Abfragen des Verzeichnisses
- **[[Kerberos]]** (88) – Standard-Authentifizierung
- **[[NTLM]]** – älteres Challenge-Response-Verfahren, aus Kompatibilitätsgründen oft noch aktiv
- **[[SMB]]** (445) – Dateifreigaben, z. B. SYSVOL mit Gruppenrichtlinien
- **DNS** – AD ist ohne DNS nicht funktionsfähig
- **RPC** – Verwaltung und Replikation

## Kerberos verständlich

Kerberos arbeitet mit **Tickets**, damit Passwörter nicht ständig über das Netz gehen. Der DC enthält das **Key Distribution Center (KDC)**.

1. **AS-REQ / AS-REP** – Der Benutzer meldet sich an und erhält ein **Ticket Granting Ticket (TGT)**, verschlüsselt mit dem Schlüssel des Kontos `krbtgt`.
2. **TGS-REQ / TGS-REP** – Mit dem TGT fordert er ein **Service-Ticket (TGS)** für einen bestimmten Dienst an. Dieses ist mit dem Schlüssel des Dienstkontos verschlüsselt.
3. **AP-REQ** – Der Benutzer legt das Service-Ticket beim Dienst vor.

Dienste werden über **Service Principal Names (SPNs)** identifiziert, z. B. `MSSQLSvc/sql01.corp.local:1433`.

> [!ANALOGIE] Freizeitpark
> Am Eingang zeigst du deinen Ausweis und bekommst ein Armband (TGT). An jeder Attraktion zeigst du das Armband und erhältst eine Einzelfahrkarte (Service-Ticket). Den Ausweis musst du nicht mehr vorzeigen.

> [!WARNUNG] Warum Kerberos-Wissen sicherheitskritisch ist
> Weil Service-Tickets mit dem Schlüssel des Dienstkontos verschlüsselt sind, ist ein schwaches Passwort eines Dienstkontos ein ernstes Risiko. Das `krbtgt`-Konto ist das wertvollste Geheimnis der Domäne. Die AD-Pfade (CPTS, CAPE) erklären diese Angriffsklassen im Detail – und zeigen, wie man sie erkennt und verhindert.

## NTLM

Bei [[NTLM]] schickt der Server eine Zufallszahl (Challenge), der Client antwortet mit einem Wert, der aus dem Passwort-Hash berechnet wird. Schwächen: der Hash ist passwortäquivalent, keine gegenseitige Authentifizierung, anfällig für Weiterleitung (Relay). Empfehlung: NTLM wo möglich einschränken, **SMB Signing** und **LDAP Signing/Channel Binding** erzwingen.

## Gruppenrichtlinien

GPOs verteilen Einstellungen auf Benutzer und Computer: Passwortrichtlinien, Firewall-Regeln, Software, Skripte, lokale Admins. Sie liegen im **SYSVOL**-Share der DCs, den jeder Domänenbenutzer lesen kann – deshalb dürfen dort niemals Passwörter stehen.

> [!TIPP] Härtung in Kürze
> Tiering-Modell (Admin-Konten nur auf ihrer Ebene), LAPS für lokale Admin-Passwörter, Protected Users, Credential Guard, regelmäßige Prüfung von Rechten und Delegationen, starke Passwörter für Dienstkonten (am besten gMSA), Überwachung der DC-Ereignisse.

## Quiz

? Welche Datei enthält die AD-Datenbank auf einem Domain Controller?
= NTDS.dit
= ntds.dit

? Was ist die eigentliche Sicherheitsgrenze in Active Directory?
+ der Forest
- die OU
- die Domäne
- die Gruppe

? Wie heißt das Ticket, das ein Benutzer bei der Anmeldung von Kerberos erhält?
= TGT
= Ticket Granting Ticket

? Mit dem Schlüssel welches Kontos ist ein TGT verschlüsselt?
= krbtgt

? Wie werden Dienste in Kerberos identifiziert?
= SPN
= Service Principal Name

? Auf welchem Port läuft Kerberos?
= 88

? In welchem Share liegen Gruppenrichtlinien?
= SYSVOL

?order Bringe den Kerberos-Ablauf in die richtige Reihenfolge
> AS-REQ / AS-REP: TGT erhalten
> TGS-REQ / TGS-REP: Service-Ticket erhalten
> AP-REQ: Ticket beim Dienst vorlegen

? Welches Werkzeug verwaltet lokale Administratorpasswörter zufällig und eindeutig pro Rechner?
= LAPS

?tf In SYSVOL dürfen Passwörter stehen, weil nur Admins es lesen können.
= falsch
! Jeder authentifizierte Domänenbenutzer kann SYSVOL lesen.
