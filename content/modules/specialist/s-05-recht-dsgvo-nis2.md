---
id: s-05
title: Recht – DSGVO, NIS2, Strafrecht
paths: specialist, cpts, cjca
order: 5
difficulty: medium
icon: building.2
summary: Die rechtlichen Rahmenbedingungen für Security-Arbeit in Deutschland und der EU – Datenschutz, Meldepflichten, NIS2, KRITIS, Hackerparagrafen und was eine Pentest-Beauftragung rechtlich braucht.
---

> [!WARNUNG] Kein Rechtsrat
> Dieses Modul vermittelt Grundlagen für Prüfungen und Praxis. Im Einzelfall gilt immer die aktuelle Rechtslage – im Zweifel Juristen fragen.

## DSGVO – Datenschutz-Grundverordnung

Die [[DSGVO]] schützt **personenbezogene Daten** – alle Informationen, die sich auf eine identifizierte oder identifizierbare Person beziehen (Name, E-Mail, IP-Adresse, Standort …).

### Grundsätze (Art. 5)

1. Rechtmäßigkeit, Treu und Glauben, Transparenz
2. Zweckbindung
3. Datenminimierung
4. Richtigkeit
5. Speicherbegrenzung
6. Integrität und Vertraulichkeit
7. Rechenschaftspflicht

### Wichtige Artikel für Security

| Artikel | Inhalt |
|---|---|
| Art. 6 | Rechtsgrundlagen der Verarbeitung |
| Art. 25 | Privacy by Design und by Default |
| Art. 28 | Auftragsverarbeitung (AV-Vertrag) |
| Art. 30 | Verzeichnis von Verarbeitungstätigkeiten |
| Art. 32 | **Sicherheit der Verarbeitung** – angemessene technische und organisatorische Maßnahmen (TOM), u. a. Pseudonymisierung, Verschlüsselung, Verfügbarkeit, regelmäßige Überprüfung |
| Art. 33 | **Meldung** einer Datenschutzverletzung an die Aufsichtsbehörde innerhalb von **72 Stunden** |
| Art. 34 | Benachrichtigung der Betroffenen bei hohem Risiko |
| Art. 35 | Datenschutz-Folgenabschätzung (DSFA) |
| Art. 83 | Bußgelder bis 20 Mio. € oder 4 % des weltweiten Jahresumsatzes |

> [!PRAXIS] Pentests und Datenschutz
> Bei Pentests sieht man oft personenbezogene Daten. Deshalb gehören Regeln zum Umgang, zur Speicherung und zur Löschung in den Vertrag, ggf. ein AV-Vertrag, und Daten werden nur so weit eingesehen, wie es für den Nachweis nötig ist.

## NIS2

Die EU-Richtlinie **[[NIS2]]** (in Deutschland umgesetzt durch das NIS2-Umsetzungsgesetz) erweitert die Pflichten zur Cybersicherheit auf viele Tausend Unternehmen in 18 Sektoren, eingeteilt in **wesentliche** und **wichtige** Einrichtungen.

Kernpflichten:

- **Risikomanagementmaßnahmen** (u. a. Risikoanalyse, Vorfallbehandlung, Business Continuity, Lieferkettensicherheit, Kryptografie, Zugriffskontrolle, MFA, Schulungen)
- **Meldepflichten**: Frühwarnung binnen **24 Stunden**, Meldung binnen **72 Stunden**, Abschlussbericht binnen **eines Monats**
- **Verantwortung der Geschäftsleitung** – sie muss Maßnahmen billigen, überwachen und sich schulen lassen; persönliche Haftung ist möglich
- Registrierung beim BSI

## KRITIS

Betreiber **kritischer Infrastrukturen** (Energie, Wasser, Gesundheit, Transport, Finanzen …) unterliegen dem BSI-Gesetz und müssen den **Stand der Technik** einhalten, Angriffserkennung betreiben und dies regelmäßig nachweisen.

## Strafrecht – die „Hackerparagrafen“

| Paragraf (StGB) | Inhalt |
|---|---|
| § 202a | Ausspähen von Daten – unbefugter Zugang zu besonders gesicherten Daten |
| § 202b | Abfangen von Daten |
| § 202c | Vorbereiten des Ausspähens und Abfangens („Hackertools“) |
| § 202d | Datenhehlerei |
| § 303a | Datenveränderung |
| § 303b | Computersabotage |

> [!GEFAHR] Ohne Auftrag ist es eine Straftat
> Der Unterschied zwischen Pentest und Angriff ist die **schriftliche Erlaubnis** des Berechtigten. Ohne sie ist schon das Eindringen in ein fremdes System strafbar – auch „nur um zu helfen“. Übe deshalb ausschließlich auf eigenen Systemen, in Labs wie Hack The Box oder deiner Cyber Range und in klar beauftragten Projekten.

## Was eine Pentest-Beauftragung braucht

- schriftlicher Vertrag mit dem **Berechtigten** (Eigentümer bzw. Betreiber – bei Cloud und Hosting auch dessen Regeln beachten)
- klarer **Scope** (IP-Bereiche, Domains, Anwendungen, Ausschlüsse)
- **Rules of Engagement**: Zeitfenster, erlaubte Techniken, Umgang mit Daten, Notfallkontakte, Abbruchkriterien
- Vertraulichkeitsvereinbarung, ggf. AV-Vertrag
- Haftungsregelungen und Versicherung

Mehr dazu im Modul [[mod:c-01|Pentest-Prozess]].

## Weitere Regelwerke

| Regelwerk | Bereich |
|---|---|
| DORA | digitale operationale Resilienz im Finanzsektor (EU) |
| Cyber Resilience Act | Sicherheitsanforderungen an Produkte mit digitalen Elementen |
| TISAX | Informationssicherheit in der Automobilindustrie |
| PCI DSS | Kartenzahlungen |
| TTDSG / TDDDG | Telekommunikation und digitale Dienste (u. a. Cookies) |

## Quiz

? Innerhalb welcher Frist muss eine Datenschutzverletzung der Aufsichtsbehörde gemeldet werden?
= 72 Stunden
= 72

? Welcher DSGVO-Artikel regelt die Sicherheit der Verarbeitung?
= Art. 32
= 32
= Artikel 32

? Wie hoch können DSGVO-Bußgelder maximal sein?
+ 20 Mio. € oder 4 % des weltweiten Jahresumsatzes
- 1 Mio. €
- 10 % des Gewinns
- 50.000 €

? Innerhalb welcher Frist verlangt NIS2 eine Frühwarnung nach einem erheblichen Vorfall?
= 24 Stunden
= 24

? Welcher Paragraf des StGB stellt das Ausspähen von Daten unter Strafe?
= § 202a
= 202a

? Welcher Paragraf behandelt Computersabotage?
= § 303b
= 303b

?tf Ein Pentest ohne schriftliche Erlaubnis ist zulässig, wenn man nur helfen möchte.
= falsch

? Welcher Grundsatz der DSGVO verlangt, nur so viele Daten wie nötig zu verarbeiten?
= Datenminimierung

? Welche EU-Verordnung regelt die digitale Resilienz im Finanzsektor?
= DORA
