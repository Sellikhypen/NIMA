---
id: s-02
title: ISMS nach ISO/IEC 27001
paths: specialist
order: 2
difficulty: medium
icon: building.columns
summary: Aufbau eines Informationssicherheits-Managementsystems, der PDCA-Zyklus, die Kapitel der ISO 27001:2022, Annex A, Statement of Applicability und der Weg zur Zertifizierung.
---

## Was ist ein ISMS?

Ein **Informationssicherheits-Managementsystem ([[ISMS]])** ist kein Werkzeug, sondern eine Sammlung von Regeln, Prozessen und Verantwortlichkeiten, mit denen eine Organisation Informationssicherheit **planbar, steuerbar und nachweisbar** macht. Die international maßgebliche Norm ist **[[ISO 27001|ISO/IEC 27001]]** (aktuelle Fassung 2022).

> [!MERKE] Managementsystem statt Technikliste
> ISO 27001 schreibt nicht vor, welche Firewall man kauft. Sie verlangt, dass man Risiken systematisch ermittelt, angemessene Maßnahmen auswählt, deren Wirksamkeit überprüft und sich kontinuierlich verbessert.

## Der PDCA-Zyklus

| Phase | Inhalt |
|---|---|
| **Plan** | Kontext, Geltungsbereich, Leitlinie, Risikobewertung, Maßnahmenplanung |
| **Do** | Maßnahmen umsetzen, Schulungen, Betrieb |
| **Check** | Kennzahlen, interne Audits, Management-Review |
| **Act** | Abweichungen korrigieren, verbessern |

## Die Normkapitel 4–10

| Kapitel | Thema | Wichtige Ergebnisse |
|---|---|---|
| 4 | Kontext der Organisation | interessierte Parteien, Anforderungen, **Geltungsbereich (Scope)** |
| 5 | Führung | Verpflichtung der Leitung, **Informationssicherheitsleitlinie**, Rollen |
| 6 | Planung | **Risikobeurteilung und -behandlung**, Sicherheitsziele |
| 7 | Unterstützung | Ressourcen, Kompetenz, Bewusstsein, Kommunikation, dokumentierte Information |
| 8 | Betrieb | Umsetzung der Risikobehandlung |
| 9 | Bewertung der Leistung | Überwachung, Messung, **interne Audits**, **Management-Review** |
| 10 | Verbesserung | Nichtkonformitäten, Korrekturmaßnahmen, fortlaufende Verbesserung |

## Annex A – die Maßnahmen

Annex A der ISO 27001:2022 enthält **93 Maßnahmen** (Controls) in vier Themen:

| Thema | Anzahl | Beispiele |
|---|---|---|
| Organisatorisch (5.x) | 37 | Richtlinien, Rollen, Lieferantenbeziehungen, Vorfallmanagement, Threat Intelligence |
| Personell (6.x) | 8 | Überprüfung, Schulung, Vertraulichkeit, Remote-Arbeit |
| Physisch (7.x) | 14 | Zutritt, Arbeitsplatz, Geräte, Clear Desk |
| Technologisch (8.x) | 34 | Zugriffskontrolle, Kryptografie, Logging, Schwachstellenmanagement, sichere Entwicklung |

Ausführliche Umsetzungshinweise liefert **ISO/IEC 27002**.

> [!INFO] Neu in der Fassung 2022
> Unter anderem Threat Intelligence, Informationssicherheit für Cloud-Dienste, ICT-Bereitschaft für Business Continuity, physische Sicherheitsüberwachung, Konfigurationsmanagement, Löschung von Informationen, Datenmaskierung, Data Leakage Prevention, Überwachung von Aktivitäten, Web-Filterung und sichere Programmierung.

## Statement of Applicability (SoA)

Die **Erklärung zur Anwendbarkeit** listet alle 93 Controls und begründet für jedes, ob es angewendet wird, wie es umgesetzt ist und warum ausgeschlossene Controls nicht nötig sind. Sie ist das zentrale Dokument jedes Audits.

## Risikobeurteilung

ISO 27001 verlangt eine definierte, wiederholbare Methode (siehe [[mod:s-03|Risikomanagement]]):

1. Risiken identifizieren (Werte, Bedrohungen, Schwachstellen)
2. Risiken analysieren (Wahrscheinlichkeit, Auswirkung)
3. Risiken bewerten (gegen Akzeptanzkriterien)
4. Risiken behandeln: **vermeiden, reduzieren, übertragen, akzeptieren**
5. Restrisiken von den Risikoeigentümern akzeptieren lassen

## Der Weg zur Zertifizierung

1. Scope festlegen und Leitung gewinnen
2. Gap-Analyse
3. ISMS aufbauen, Risiken behandeln, SoA erstellen
4. Internes Audit und Management-Review
5. **Stufe-1-Audit** (Dokumentenprüfung) durch eine akkreditierte Zertifizierungsstelle
6. **Stufe-2-Audit** (Wirksamkeit vor Ort)
7. Zertifikat für drei Jahre, jährliche **Überwachungsaudits**, danach **Rezertifizierung**

> [!EXAM] Merkhilfe
> Kapitel 4–10 sind Pflicht („shall“), Annex-A-Controls werden risikobasiert ausgewählt und in der SoA begründet.

## Quiz

? Wie viele Controls enthält Annex A der ISO 27001:2022?
= 93

? In welche vier Themen ist Annex A 2022 gegliedert?
+ organisatorisch, personell, physisch, technologisch
- präventiv, detektiv, korrektiv, abschreckend
- Plan, Do, Check, Act
- Netzwerk, Server, Client, Cloud

?order Bringe den PDCA-Zyklus in die richtige Reihenfolge
> Plan
> Do
> Check
> Act

? Wie heißt das Dokument, das für jedes Control die Anwendung begründet?
= Statement of Applicability
= SoA
= Erklärung zur Anwendbarkeit

? Welche Norm liefert die ausführlichen Umsetzungshinweise zu den Controls?
= ISO 27002
= ISO/IEC 27002

? Welche vier Optionen der Risikobehandlung gibt es?
+ vermeiden, reduzieren, übertragen, akzeptieren
- ignorieren, löschen, kopieren, verschieben
- planen, prüfen, umsetzen, verbessern
- melden, sperren, löschen, wiederherstellen

? Wie lange ist ein ISO-27001-Zertifikat gültig?
= 3 Jahre
= drei Jahre
= 3

? In welchem Normkapitel stehen interne Audits und Management-Review?
= 9
= Kapitel 9

?tf ISO 27001 schreibt konkrete Produkte vor.
= falsch
