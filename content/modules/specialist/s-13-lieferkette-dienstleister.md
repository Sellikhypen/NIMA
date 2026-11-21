---
id: s-13
title: Lieferkette, Dienstleister und Security-Steuerung
paths: specialist
order: 13
difficulty: medium
icon: shippingbox.and.arrow.backward
summary: Risiken durch Dienstleister und Software-Lieferanten, Lieferantenbewertung, Verträge und Audits, Cloud-Outsourcing sowie Kennzahlen und Reporting für die Geschäftsleitung.
---

## Warum die Lieferkette zählt

Unternehmen hängen von IT-Dienstleistern, Cloud-Anbietern, Softwareherstellern und Wartungsfirmen ab. Angreifer nutzen das: Ein kompromittierter Dienstleister mit Fernzugriff oder ein manipuliertes Software-Update kann hunderte Kunden gleichzeitig treffen. NIS2 verlangt deshalb ausdrücklich Maßnahmen zur **Sicherheit der Lieferkette**.

## Lieferantenmanagement

| Schritt | Inhalt |
|---|---|
| Inventar | Welche Lieferanten haben Zugriff auf welche Daten und Systeme? |
| Klassifizierung | Kritikalität nach Daten, Zugriff, Abhängigkeit |
| Bewertung vor Vertrag | Fragebogen, Zertifikate (ISO 27001, SOC 2, TISAX), Pentest-Berichte |
| Vertrag | Sicherheitsanforderungen, Meldepflichten bei Vorfällen, Auditrechte, Unterauftragnehmer, Datenrückgabe und Löschung |
| laufende Überwachung | jährliche Neubewertung, Vorfälle, Änderungen beim Lieferanten |
| Beendigung | Zugänge entziehen, Daten zurückholen bzw. löschen lassen |

> [!WARNUNG] Fernzugänge von Dienstleistern
> Dauerhaft offene Fernwartungszugänge mit geteilten Passwörtern gehören zu den häufigsten Einfallstoren. Zugänge nur bei Bedarf freischalten, personalisierte Konten mit MFA, Sitzungen aufzeichnen, Rechte auf das Nötigste begrenzen.

## Cloud- und IT-Outsourcing

- Verantwortung bleibt beim Auftraggeber – nur die Durchführung wird übertragen
- Shared-Responsibility-Modell verstehen ([[mod:f-11|Cloud]])
- Exit-Strategie: Daten müssen portabel sein
- Standort der Daten, Unterauftragnehmer, Zugriff durch Drittstaaten bewerten
- Nachweise: Zertifikate, Prüfberichte (z. B. C5 des BSI für Cloud-Dienste)

## Software-Lieferkette

SBOMs, signierte Updates, Prüfung von Abhängigkeiten und Herstellerprozessen – siehe [[mod:x-04|Sichere Softwareentwicklung]]. Der **Cyber Resilience Act** verpflichtet Hersteller künftig zu Sicherheitsupdates und Schwachstellenmeldungen.

## Security-Steuerung und Reporting

Die Geschäftsleitung braucht keine Rohdaten, sondern Entscheidungsgrundlagen:

| Kennzahl | Aussage |
|---|---|
| Top-Risiken mit Trend | Wo stehen wir, was wird besser/schlechter? |
| Patch-Fristen eingehalten (%) | Wirksamkeit des Schwachstellenmanagements |
| MFA-Abdeckung (%) | Basisschutz von Identitäten |
| MTTD / MTTR | Erkennungs- und Reaktionsgeschwindigkeit |
| offene Audit-Feststellungen | Umsetzungsstand |
| Ergebnisse von Übungen | Bereitschaft für Vorfälle |
| Budget und Ressourcen | Abgleich mit Risiken |

> [!TIPP] Risiken in Geschäftssprache
> Statt „47 kritische CVEs offen“: „Zwei internetfähige Systeme haben Lücken, die aktiv ausgenutzt werden; ein Ausfall würde den Onlineshop etwa drei Tage lahmlegen. Behebung bis Freitag ist geplant.“

## Quiz

? Welche EU-Richtlinie verlangt ausdrücklich Maßnahmen zur Sicherheit der Lieferkette?
= NIS2

? Was gehört in einen Dienstleistervertrag?
+ Meldepflichten bei Vorfällen
+ Auditrechte
+ Regelungen zur Datenrückgabe und Löschung
- das private Passwort des Dienstleisters
- keine Sicherheitsanforderungen

? Welcher BSI-Katalog dient als Nachweis für Cloud-Dienste?
= C5

? Bleibt bei Outsourcing die Verantwortung beim Auftraggeber?
+ Ja, nur die Durchführung wird übertragen
- Nein, sie geht vollständig über
- Nur bei Cloud-Diensten
- Nur bei kleinen Firmen

? Wie sollten Fernwartungszugänge von Dienstleistern gestaltet sein?
+ nur bei Bedarf freigeschaltet, personalisiert, mit MFA und Aufzeichnung
- dauerhaft offen mit geteiltem Passwort
- ohne Protokollierung
- mit Domain-Admin-Rechten

? Welche EU-Verordnung verpflichtet Hersteller zu Sicherheitsupdates für Produkte mit digitalen Elementen?
= Cyber Resilience Act
= CRA
