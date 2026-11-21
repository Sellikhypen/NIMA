---
id: s-03
title: Risikomanagement in der Praxis
paths: specialist
order: 3
difficulty: medium
icon: chart.bar.xaxis
summary: Werte erfassen, Schutzbedarf feststellen, Risiken qualitativ und quantitativ bewerten, Risikomatrix, Behandlungsplan und Restrisiko.
---

## Warum Risikomanagement?

Kein Unternehmen kann alles perfekt schützen. Budget, Personal und Zeit sind begrenzt. Risikomanagement beantwortet die Frage: **Wo wirkt jeder investierte Euro am stärksten?**

## Schritt 1: Werte erfassen

Zuerst muss man wissen, was man schützt. Ein **Asset-Inventar** enthält Informationen, Anwendungen, IT-Systeme, Räume, Personen und Dienstleister – jeweils mit **Eigentümer**.

## Schritt 2: Schutzbedarf

Für jeden Wert wird bewertet, welcher Schaden bei Verletzung von Vertraulichkeit, Integrität und Verfügbarkeit entstünde. Der BSI-Standard 200-2 nutzt drei Kategorien:

| Kategorie | Bedeutung |
|---|---|
| normal | Schadensauswirkungen begrenzt und überschaubar |
| hoch | Schadensauswirkungen beträchtlich |
| sehr hoch | existenzbedrohend oder katastrophal |

Schadensszenarien: Verstoß gegen Gesetze, Beeinträchtigung des informationellen Selbstbestimmungsrechts, persönliche Unversehrtheit, Aufgabenerfüllung, negative Außenwirkung, finanzielle Auswirkungen.

> [!MERKE] Vererbung
> Ein Server erbt den höchsten Schutzbedarf der Anwendungen, die auf ihm laufen (**Maximumprinzip**). Viele kleine Schäden können sich addieren (**Kumulationseffekt**), Redundanz kann den Bedarf senken (**Verteilungseffekt**).

## Schritt 3: Risiken bewerten

### Qualitativ – die Risikomatrix

| Wahrscheinlichkeit ↓ / Auswirkung → | gering | mittel | hoch | sehr hoch |
|---|---|---|---|---|
| sehr häufig | mittel | hoch | sehr hoch | sehr hoch |
| häufig | gering | mittel | hoch | sehr hoch |
| selten | gering | gering | mittel | hoch |
| sehr selten | gering | gering | gering | mittel |

### Quantitativ – in Euro

| Kennzahl | Formel | Bedeutung |
|---|---|---|
| SLE (Single Loss Expectancy) | Wert × Exposure Factor | Schaden pro Ereignis |
| ARO (Annual Rate of Occurrence) | Anzahl pro Jahr | Häufigkeit |
| ALE (Annual Loss Expectancy) | SLE × ARO | erwarteter Schaden pro Jahr |

> [!BEISPIEL] Rechnung
> Ein Webshop-Ausfall kostet 40.000 € (SLE) und tritt statistisch alle zwei Jahre auf (ARO = 0,5). ALE = 20.000 € pro Jahr. Eine Maßnahme, die jährlich 8.000 € kostet und das Risiko halbiert, spart 10.000 € – sie lohnt sich.

## Schritt 4: Risiken behandeln

| Strategie | Beispiel |
|---|---|
| vermeiden | riskanten Dienst abschalten |
| reduzieren / mindern | Patchen, MFA, Segmentierung |
| übertragen / teilen | Cyberversicherung, Outsourcing (Verantwortung bleibt!) |
| akzeptieren | bewusst und dokumentiert durch den Risikoeigentümer |

Ergebnis ist ein **Risikobehandlungsplan** mit Maßnahmen, Verantwortlichen, Fristen und dem erwarteten **Restrisiko**.

## Bekannte Methoden

- **ISO/IEC 27005** – Leitfaden zum Informationssicherheits-Risikomanagement
- **BSI-Standard 200-3** – Risikoanalyse auf Basis von IT-Grundschutz
- **NIST SP 800-30** – Risk Assessments
- **FAIR** – quantitatives Modell
- **STRIDE / Threat Modeling** – Bedrohungsanalyse für Anwendungen (siehe [[mod:s-06|Sicherheitsarchitektur]])

## Quiz

? Wie berechnet man die ALE?
+ SLE × ARO
- Wert × Wahrscheinlichkeit × 12
- ARO ÷ SLE
- SLE + ARO

? Ein Schaden kostet 10.000 € und tritt zweimal pro Jahr auf. Wie hoch ist die ALE in Euro?
= 20000
= 20.000
= 20.000 €

? Welche Schutzbedarfskategorien kennt der BSI-Standard 200-2?
+ normal, hoch, sehr hoch
- niedrig, mittel, hoch
- öffentlich, intern, geheim
- grün, gelb, rot

? Wie heißt das Prinzip, nach dem ein Server den höchsten Schutzbedarf seiner Anwendungen übernimmt?
= Maximumprinzip

?tf Beim Übertragen eines Risikos (z. B. Versicherung) geht auch die Verantwortung vollständig über.
= falsch

? Welche Norm ist der Leitfaden zum Informationssicherheits-Risikomanagement?
= ISO 27005
= ISO/IEC 27005

? Wer muss Restrisiken akzeptieren?
+ der Risikoeigentümer bzw. die Leitung
- der Administrator
- der Auditor
- der Pentester
