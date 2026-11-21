---
id: a-01
title: Kerberos im Detail – Tickets, PAC und Delegation
paths: cape
order: 11
difficulty: hard
icon: ticket
summary: Verschlüsselungstypen, PAC und Gruppenmitgliedschaften im Ticket, die drei Delegationsarten, S4U-Erweiterungen und Ressourcen-basierte Delegation – verständlich erklärt mit Sicherheitsfolgen.
---

## Wiederholung

Der Grundablauf (TGT → Service-Ticket → Dienst) steht in [[mod:f-12|AD-Grundlagen]]. Hier geht es um die Details, die für Expertenprüfungen und für die Härtung entscheidend sind.

## Verschlüsselungstypen

| etype | Verfahren | Bewertung |
|---|---|---|
| 23 | RC4-HMAC (basiert auf dem NT-Hash) | veraltet; Tickets lassen sich leichter offline prüfen |
| 17 | AES128-CTS-HMAC-SHA1 | gut |
| 18 | AES256-CTS-HMAC-SHA1 | empfohlen |

> [!TIPP] RC4 abschalten
> Wo möglich RC4 für Konten und DCs deaktivieren (`msDS-SupportedEncryptionTypes`) und Ereignisse mit Verschlüsselungstyp 0x17 (RC4) überwachen. Anfragen nach RC4-Tickets für AES-fähige Konten sind ein Warnsignal.

## Das PAC

Jedes Ticket enthält das **Privilege Attribute Certificate (PAC)** mit der SID des Benutzers und seinen Gruppenmitgliedschaften. Dienste entscheiden anhand des PAC über Zugriffe. Das PAC ist mit Schlüsseln des KDC bzw. des Dienstes signiert. Wer diese Schlüssel besitzt, kann Tickets mit beliebigen Gruppen fälschen (Golden/Silver Tickets). Neuere Windows-Updates haben PAC-Validierung und -Signaturen verschärft.

## Delegation

Delegation erlaubt einem Dienst, im Namen eines Benutzers auf andere Dienste zuzugreifen – z. B. ein Webserver, der mit der Identität des Benutzers auf eine Datenbank zugreift.

| Art | Funktionsweise | Risiko | Empfehlung |
|---|---|---|---|
| **Unconstrained** | der Dienst erhält eine Kopie des TGT jedes Benutzers, der sich anmeldet | wer den Server kontrolliert, kann sich als jeder Benutzer ausgeben, inkl. Admins | nicht verwenden (außer auf DCs, wo es Standard ist) |
| **Constrained** | der Dienst darf nur zu festgelegten Diensten delegieren (S4U2Proxy) | Fehlkonfiguration und Protokollwechsel (S4U2Self) können Missbrauch erlauben | auf das Nötigste beschränken |
| **Resource-Based Constrained (RBCD)** | die Zielressource legt fest, wer zu ihr delegieren darf (`msDS-AllowedToActOnBehalfOfOtherIdentity`) | wer dieses Attribut schreiben kann, kann sich Zugriff verschaffen | Schreibrechte auf Computerobjekte streng kontrollieren |

> [!MERKE] Schutz sensibler Konten
> Administratorkonten auf „Account is sensitive and cannot be delegated“ setzen und in die Gruppe **Protected Users** aufnehmen. Dann werden ihre Anmeldedaten nicht delegiert.

## S4U-Erweiterungen

| Erweiterung | Zweck |
|---|---|
| S4U2Self | ein Dienst holt sich ein Ticket für einen Benutzer zu sich selbst (z. B. nach Anmeldung per Formular statt Kerberos) |
| S4U2Proxy | ein Dienst nutzt dieses Ticket, um weiter zu delegieren |

Die Kombination ermöglicht Protokollwechsel – deshalb ist die Option „Use any authentication protocol“ bei Constrained Delegation besonders sensibel.

## Machine Account Quota

Standardmäßig darf jeder Domänenbenutzer bis zu **10 Computerkonten** anlegen (`ms-DS-MachineAccountQuota`). Zusammen mit RBCD-Fehlkonfigurationen wird das zum Risiko. Empfehlung: auf 0 setzen und Computerkonten nur über delegierte Gruppen anlegen lassen.

## Erkennung

| Ereignis | Hinweis |
|---|---|
| 4769 mit etype 0x17 für AES-fähige Konten | auffällige RC4-Anfragen |
| 4769 mit S4U-Merkmalen von untypischen Konten | Delegationsmissbrauch |
| 5136 (Verzeichnisobjekt geändert) an `msDS-AllowedToActOnBehalfOfOtherIdentity` | RBCD-Konfiguration geändert |
| 4741 (Computerkonto erstellt) durch normale Benutzer | Machine Account Quota genutzt |

## Quiz

? Welcher Kerberos-Verschlüsselungstyp gilt als veraltet?
+ RC4-HMAC (etype 23)
- AES256 (etype 18)
- AES128 (etype 17)
- keiner

? Wie heißt die Datenstruktur im Ticket mit SID und Gruppenmitgliedschaften?
= PAC
= Privilege Attribute Certificate

? Welche Delegationsart ist am gefährlichsten?
= Unconstrained
= Unconstrained Delegation

? Bei welcher Delegationsart legt die Zielressource fest, wer delegieren darf?
= Resource-Based Constrained Delegation
= RBCD

? Welche Gruppe verhindert unter anderem die Delegation der Anmeldedaten ihrer Mitglieder?
= Protected Users

? Wie viele Computerkonten darf ein normaler Benutzer standardmäßig anlegen?
= 10

? Auf welchen Wert sollte die Machine Account Quota gesetzt werden?
= 0
