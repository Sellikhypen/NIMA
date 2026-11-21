---
id: c-08
title: Active-Directory-Sicherheit – Angriffsklassen und Abwehr
paths: cpts, cape
order: 8
difficulty: hard
icon: person.2.badge.key
summary: Die wichtigsten AD-Risikoklassen – Kerberos-Schwächen, NTLM-Weiterleitung, ACL-Missbrauch, Delegation, ADCS, DCSync, Golden Tickets – verständlich erklärt mit Erkennung und Härtung.
htb: Windows Privilege Escalation
---

> [!INFO] Voraussetzung
> Dieses Modul baut auf [[mod:f-12|Active Directory – Grundlagen]] auf. Es erklärt, **warum** bestimmte Konstellationen gefährlich sind und wie man sie erkennt und behebt – das Wissen, das CPTS und CAPE in Theorie und Bericht verlangen.

## Warum AD so oft das Ziel ist

Wer die Domäne kontrolliert, kontrolliert praktisch alle Rechner, Benutzer und Daten. Und AD ist über Jahre gewachsen: alte Konten, vergessene Rechte, Kompatibilitätseinstellungen. Werkzeuge wie **BloodHound** visualisieren Beziehungen als Graph und zeigen Pfade zu kritischen Gruppen – für Verteidiger genauso wertvoll wie für Prüfer.

## Kerberos-bezogene Risiken

| Klasse | Ursache | Erkennung | Härtung |
|---|---|---|---|
| **[[Kerberoasting]]** | Dienstkonten mit SPN und schwachem Passwort; Service-Tickets sind mit deren Schlüssel verschlüsselt und lassen sich offline prüfen | viele 4769-Ereignisse, RC4-Verschlüsselung, ungewöhnliche Anfragende | lange Passwörter bzw. **gMSA**, AES erzwingen, Honeypot-SPNs |
| **AS-REP Roasting** | Konten mit deaktivierter Vorauthentifizierung | 4768 ohne Vorauthentifizierung | Vorauthentifizierung immer aktivieren |
| **Golden Ticket** | Schlüssel des `krbtgt`-Kontos gestohlen → beliebige TGTs fälschbar | Tickets mit ungewöhnlicher Lebensdauer, Anomalien in 4769 ohne vorheriges 4768 | `krbtgt` schützen, nach Vorfall zweimal zurücksetzen |
| **Silver Ticket** | Schlüssel eines Dienstkontos → Service-Tickets fälschbar | PAC-Validierung, Anomalien | starke Dienstkonten-Passwörter |
| Delegation | unbeschränkte oder falsch konfigurierte Delegation erlaubt Identitätsübernahme | Inventar der Delegationseinstellungen | keine Unconstrained Delegation, sensible Konten „cannot be delegated“, Protected Users |

## NTLM-Risiken

| Klasse | Ursache | Härtung |
|---|---|---|
| Pass-the-Hash | der NT-Hash ist passwortäquivalent | LAPS, Credential Guard, Tiering, NTLM einschränken |
| NTLM-Relay | Anmeldungen werden an andere Dienste weitergeleitet | **SMB Signing**, **LDAP Signing und Channel Binding**, EPA für HTTP-Dienste |
| Namensauflösungs-Vergiftung (LLMNR/NBT-NS) | Clients fragen per Broadcast, jeder kann antworten | LLMNR und NBT-NS per GPO deaktivieren |

## Rechte und Konfiguration

| Klasse | Ursache | Härtung |
|---|---|---|
| ACL-Missbrauch | Rechte wie `GenericAll`, `WriteDACL`, `ForceChangePassword` auf sensiblen Objekten | regelmäßige ACL-Analyse (BloodHound, PingCastle), Bereinigung |
| **DCSync** | Konten mit Replikationsrechten können alle Hashes vom DC anfordern | Replikationsrechte nur für DCs; Alarm bei 4662 mit Replikations-GUIDs von Nicht-DCs |
| **ADCS**-Fehlkonfigurationen | Zertifikatsvorlagen erlauben z. B. frei wählbare Identitäten | Vorlagen prüfen (z. B. mit Certify im Audit-Modus, PingCastle), Manager-Freigabe, strenge Rechte |
| GPP-Passwörter | alte Gruppenrichtlinien-Einstellungen mit (bekannt verschlüsselten) Passwörtern in SYSVOL | SYSVOL bereinigen, betroffene Passwörter ändern |
| Trusts | zu weit gefasste Vertrauensstellungen | SID Filtering, selektive Authentifizierung |

> [!MERKE] Das Tiering-Modell
> Tier 0 (DCs, ADCS, Identität), Tier 1 (Server), Tier 2 (Clients). Admin-Konten melden sich nur auf ihrer eigenen Ebene an. Dann landen hochprivilegierte Anmeldeinformationen nie auf weniger geschützten Rechnern – das unterbricht die meisten AD-Angriffspfade.

## Prüfwerkzeuge für Verteidiger

| Werkzeug | Zweck |
|---|---|
| PingCastle | Risikobewertung der Domäne mit Punktzahl |
| BloodHound / SharpHound | Angriffspfade als Graph |
| Purple Knight | AD-Sicherheitsbewertung |
| Microsoft Defender for Identity | Erkennung von AD-Angriffen in Echtzeit |

## Quiz

? Welche Klasse nutzt aus, dass Service-Tickets mit dem Schlüssel des Dienstkontos verschlüsselt sind?
= Kerberoasting

? Welche Maßnahme entschärft Kerberoasting am wirksamsten?
+ gMSA bzw. sehr lange, zufällige Passwörter für Dienstkonten
- SPNs löschen und neu anlegen
- SMBv1 aktivieren
- Kerberos abschalten

? Welche Konteneinstellung ermöglicht AS-REP Roasting?
+ deaktivierte Kerberos-Vorauthentifizierung
- aktivierte MFA
- abgelaufenes Passwort
- Mitglied in Protected Users

? Welches Konto muss für ein Golden Ticket kompromittiert sein?
= krbtgt

? Welche Maßnahmen verhindern NTLM-Relay auf SMB und LDAP?
+ SMB Signing
+ LDAP Signing und Channel Binding
- längere SSIDs
- WPS deaktivieren

? Welche Protokolle sollte man per GPO deaktivieren, um Namensauflösungs-Vergiftung zu verhindern?
+ LLMNR
+ NBT-NS
- DNS
- Kerberos

? Wie heißt die Technik, bei der ein Konto mit Replikationsrechten Hashes vom DC anfordert?
= DCSync

? Welches Werkzeug bewertet die Sicherheit einer Domäne mit einer Punktzahl?
= PingCastle
