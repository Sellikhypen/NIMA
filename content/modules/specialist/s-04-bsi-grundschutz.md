---
id: s-04
title: BSI IT-Grundschutz
paths: specialist
order: 4
difficulty: medium
icon: checkmark.shield
summary: Die BSI-Standards 200-1 bis 200-4, das IT-Grundschutz-Kompendium mit Bausteinen und Anforderungen, Basis-, Standard- und Kern-Absicherung und die Zertifizierung auf Basis von IT-Grundschutz.
---

## Was ist IT-Grundschutz?

Der **IT-Grundschutz** des Bundesamts für Sicherheit in der Informationstechnik ([[BSI]]) ist die deutsche Methodik für Informationssicherheit. Er ist kompatibel zu ISO 27001, liefert aber zusätzlich einen sehr konkreten Katalog von Anforderungen – das **IT-Grundschutz-Kompendium**.

## Die BSI-Standards

| Standard | Inhalt |
|---|---|
| 200-1 | Managementsysteme für Informationssicherheit (ISMS) |
| 200-2 | IT-Grundschutz-Methodik |
| 200-3 | Risikoanalyse auf Basis von IT-Grundschutz |
| 200-4 | Business Continuity Management (BCM) |

## Drei Vorgehensweisen

| Vorgehensweise | Ziel | geeignet für |
|---|---|---|
| **Basis-Absicherung** | schneller Einstieg, wichtigste Anforderungen flächendeckend | kleine Organisationen, Start |
| **Kern-Absicherung** | die „Kronjuwelen“ besonders schützen | Fokus auf kritische Geschäftsprozesse |
| **Standard-Absicherung** | umfassender Schutz aller Bereiche | Ziel für die meisten Organisationen, Grundlage der Zertifizierung |

## Ablauf der Standard-Absicherung

1. **Strukturanalyse** – Geschäftsprozesse, Anwendungen, IT-Systeme, Räume, Netze erfassen
2. **Schutzbedarfsfeststellung** – normal, hoch, sehr hoch (siehe [[mod:s-03|Risikomanagement]])
3. **Modellierung** – passende Bausteine des Kompendiums den Zielobjekten zuordnen
4. **IT-Grundschutz-Check** – Soll-Ist-Vergleich: Welche Anforderungen sind erfüllt?
5. **Risikoanalyse** – für Objekte mit hohem/sehr hohem Schutzbedarf oder ohne passenden Baustein
6. **Umsetzungsplanung** und Realisierung
7. Aufrechterhaltung und kontinuierliche Verbesserung

## Das Kompendium

Das Kompendium besteht aus **Bausteinen** in zehn Schichten:

| Kürzel | Schicht | Beispiele |
|---|---|---|
| ISMS | Sicherheitsmanagement | ISMS.1 |
| ORP | Organisation und Personal | Identitäts- und Berechtigungsmanagement, Schulung |
| CON | Konzepte und Vorgehensweisen | Kryptokonzept, Datenschutz, Löschen und Vernichten |
| OPS | Betrieb | Patch- und Änderungsmanagement, Protokollierung, Schutz vor Schadprogrammen |
| DER | Detektion und Reaktion | Detektion, Behandlung von Sicherheitsvorfällen, Forensik, Audits |
| APP | Anwendungen | Webanwendungen, Datenbanken, Verzeichnisdienste (AD), E-Mail |
| SYS | IT-Systeme | Server, Clients, Windows, Linux, Virtualisierung, Smartphones |
| IND | Industrielle IT | OT-Segmentierung, SPS |
| NET | Netze und Kommunikation | Netzarchitektur, WLAN, VPN, Firewall |
| INF | Infrastruktur | Gebäude, Rechenzentrum, Serverraum, Verkabelung |

Jeder Baustein enthält eine Beschreibung, Gefährdungslage und **Anforderungen** in drei Stufen:

- **Basis** (MUSS) – Mindestanforderungen
- **Standard** (SOLLTE) – zusammen mit Basis der Stand der Technik
- **erhöhter Schutzbedarf** – zusätzliche Anforderungen

> [!TIPP] Elementare Gefährdungen
> Das BSI beschreibt 47 elementare Gefährdungen (G 0.1 Feuer bis G 0.47 Schädliche Seiteneffekte IT-gestützter Angriffe). Sie dienen als Checkliste in der Risikoanalyse.

## Zertifizierung

Organisationen können eine **ISO-27001-Zertifizierung auf der Basis von IT-Grundschutz** erhalten. Auditoren werden vom BSI zertifiziert. Für Einsteiger gibt es zudem den **IT-Grundschutz-Check** und Testate.

## Quiz

? Welcher BSI-Standard beschreibt die IT-Grundschutz-Methodik?
= 200-2
= BSI-Standard 200-2

? Welcher BSI-Standard behandelt Business Continuity Management?
= 200-4

? Welche Vorgehensweise ist Grundlage der Zertifizierung?
+ Standard-Absicherung
- Basis-Absicherung
- Kern-Absicherung
- Notfall-Absicherung

? Welche Schicht des Kompendiums behandelt Detektion und Reaktion?
= DER

? Welche Schicht enthält Bausteine zu Windows- und Linux-Servern?
= SYS

?order Bringe die ersten Schritte der Standard-Absicherung in Reihenfolge
> Strukturanalyse
> Schutzbedarfsfeststellung
> Modellierung
> IT-Grundschutz-Check

? Welches Modalverb kennzeichnet Basis-Anforderungen?
= MUSS
= muss

? Wie viele elementare Gefährdungen beschreibt das BSI?
= 47
