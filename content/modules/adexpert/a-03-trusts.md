---
id: a-03
title: Domänen- und Forest-Trusts
paths: cape
order: 13
difficulty: hard
icon: arrow.triangle.swap
summary: Trust-Typen, Richtungen und Transitivität, wie Authentifizierung über Trusts läuft, SID-History und SID Filtering, selektive Authentifizierung und warum der Forest die Sicherheitsgrenze ist.
---

## Was ist ein Trust?

Ein **Trust** erlaubt Benutzern einer Domäne, auf Ressourcen einer anderen Domäne zuzugreifen. Er sagt aus: „Die vertrauende Domäne akzeptiert Anmeldungen, die die vertraute Domäne geprüft hat.“

| Begriff | Bedeutung |
|---|---|
| trusting domain | vertrauende Domäne (hat die Ressourcen) |
| trusted domain | vertraute Domäne (hat die Benutzer) |
| Richtung | ein- oder zweiseitig |
| Transitivität | gilt der Trust auch für weitere Domänen „hinter“ der Partnerdomäne? |

> [!MERKE] Richtung merken
> Die Richtung des Vertrauens ist entgegengesetzt zur Richtung des Zugriffs: Vertraut A der Domäne B, dürfen Benutzer aus B auf Ressourcen in A zugreifen.

## Trust-Typen

| Typ | Beschreibung | transitiv |
|---|---|---|
| Parent-Child | automatisch zwischen Eltern- und Kinddomäne im Forest | ja, zweiseitig |
| Tree-Root | zwischen Bäumen desselben Forests | ja |
| Forest | zwischen zwei Forests | transitiv innerhalb der Forests, nicht darüber hinaus |
| External | zu einer einzelnen Domäne eines anderen Forests | nein |
| Shortcut | Abkürzung zwischen Domänen desselben Forests | ja |
| Realm | zu einem Nicht-Windows-Kerberos-Bereich | konfigurierbar |

## Authentifizierung über Trusts

Bei Kerberos stellt der DC der eigenen Domäne ein **Inter-Realm-TGT** aus, das mit einem **Trust-Schlüssel** verschlüsselt ist. Damit fragt der Benutzer beim DC der Partnerdomäne ein Service-Ticket an. Der Trust-Schlüssel ist daher ähnlich sensibel wie der krbtgt-Schlüssel.

## SID-History und SID Filtering

**SID-History** erlaubt bei Migrationen, dass ein Konto die alte SID mitnimmt und weiterhin auf alte Ressourcen zugreift. Wird SID-History missbraucht, kann ein Konto Rechte aus einer anderen Domäne beanspruchen.

**SID Filtering** entfernt bei Forest- und External-Trusts SIDs, die nicht zur vertrauten Domäne gehören. Innerhalb eines Forests (Parent-Child) gibt es standardmäßig **kein** SID Filtering – deshalb kann die Kompromittierung einer Kinddomäne den ganzen Forest gefährden.

> [!GEFAHR] Die Sicherheitsgrenze ist der Forest
> Eine Domäne ist **keine** Sicherheitsgrenze. Wer Domain Admin einer Kinddomäne ist, kann mit bekannten Techniken in der Regel auch die Stammdomäne übernehmen. Bereiche, die wirklich getrennt sein müssen, brauchen eigene Forests.

## Härtung von Trusts

- nicht benötigte Trusts entfernen, Inventar regelmäßig prüfen (`Get-ADTrust`, `nltest /domain_trusts`)
- SID Filtering bei Forest- und External-Trusts aktiv lassen
- **Selective Authentication**: nur explizit berechtigte Konten dürfen sich über den Trust an bestimmten Servern anmelden
- Trust-Schlüssel regelmäßig erneuern lassen, Admin-Konten nicht über Trusts hinweg nutzen
- Erkennung: Anmeldungen über Trusts (4768/4769 mit fremden Realms), Änderungen an SID-History (4765/4766)

## Quiz

? Vertraut Domäne A der Domäne B – wer darf auf wessen Ressourcen zugreifen?
+ Benutzer aus B auf Ressourcen in A
- Benutzer aus A auf Ressourcen in B
- niemand
- nur Administratoren beider Domänen

? Welcher Trust-Typ entsteht automatisch zwischen Eltern- und Kinddomäne?
= Parent-Child

? Welcher Mechanismus entfernt fremde SIDs bei Forest-Trusts?
= SID Filtering

? Was ist die eigentliche Sicherheitsgrenze im Active Directory?
= Forest
= der Forest

? Wie heißt die Option, bei der nur explizit berechtigte Konten über einen Trust zugreifen dürfen?
= Selective Authentication
= selektive Authentifizierung

? Welches Attribut erlaubt bei Migrationen, alte SIDs mitzunehmen?
= SID-History
= SIDHistory

? Mit welchem PowerShell-Cmdlet listet man Trusts auf?
= Get-ADTrust
