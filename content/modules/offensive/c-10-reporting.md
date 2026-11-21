---
id: c-10
title: Dokumentation und Reporting
paths: cpts, cwes, cdsa, cwee, cape
order: 10
difficulty: medium
icon: doc.richtext
summary: Notizen während der Arbeit, Beweise sammeln, Aufbau eines professionellen Berichts, Findings schreiben, CVSS-Bewertung und wie man Management und Technik gleichermaßen erreicht.
htb: Documentation & Reporting
---

## Warum der Bericht das eigentliche Produkt ist

Der Kunde bezahlt nicht für den Einbruch, sondern für den **Bericht**. Er entscheidet über Budgets, Prioritäten und Fristen. Alle HTB-Profi-Zertifikate (CPTS, CWES, CDSA, CWEE, CAPE) verlangen deshalb einen professionellen Bericht – ohne ihn besteht man nicht, egal wie viele Flags man hat.

## Notizen während der Arbeit

| Bereich | Inhalt |
|---|---|
| Administratives | Scope, Kontakte, Zeitfenster, Zugangsdaten für den Test |
| Aktivitätslog | Zeitstempel, Quelle, Ziel, Aktion, Ergebnis |
| Befunde | je Fund: Beschreibung, Nachweis, betroffene Systeme |
| Zugangsdaten | gefundene Anmeldedaten mit Fundort (geschützt aufbewahren) |
| Hosts und Dienste | Ergebnisse der Enumeration |
| offene Punkte | Ideen, die noch geprüft werden müssen |

Werkzeuge: Obsidian, CherryTree, Joplin, Notion oder Git-Repositories mit Markdown. Terminal-Sitzungen lassen sich mit `script` oder tmux-Logging mitschreiben.

> [!TIPP] Screenshots mit Kontext
> Ein guter Nachweis zeigt Zeitstempel, Hostname bzw. IP und das Ergebnis in einem Bild. Sensible Daten (Passwörter, Hashes, personenbezogene Daten) werden sauber geschwärzt – mit deckenden Balken, nicht mit Weichzeichner.

## Aufbau eines Berichts

1. **Deckblatt und Versionierung**
2. **Executive Summary** – für die Geschäftsleitung: Ziel, Gesamtbewertung, wichtigste Risiken, empfohlene Prioritäten, ohne Fachjargon
3. **Scope und Methodik** – was wurde wann wie geprüft, was nicht
4. **Zusammenfassung der Befunde** – Tabelle nach Schweregrad
5. **Angriffsweg / Attack Chain** – wie einzelne Befunde zusammen zum Ziel führten
6. **Detaillierte Befunde**
7. **Anhänge** – Hostlisten, Werkzeuge, Bereinigungsnachweise

## Ein Befund

| Feld | Inhalt |
|---|---|
| Titel | präzise, z. B. „SMB-Signierung auf Servern nicht erzwungen“ |
| Schweregrad | nach CVSS bzw. eigener Matrix |
| Beschreibung | was ist das Problem, warum entsteht es |
| Auswirkung | konkret für **diesen** Kunden |
| betroffene Systeme | vollständige Liste |
| Nachweis | Schritte und Screenshots, reproduzierbar |
| Empfehlung | konkret und umsetzbar, kurzfristig und langfristig |
| Referenzen | Herstellerhinweise, CWE, CVE, Standards |

## CVSS

Das **Common Vulnerability Scoring System** (v3.1, zunehmend v4.0) bewertet Schwachstellen von 0.0 bis 10.0:

| Bereich | Stufe |
|---|---|
| 0.0 | None |
| 0.1 – 3.9 | Low |
| 4.0 – 6.9 | Medium |
| 7.0 – 8.9 | High |
| 9.0 – 10.0 | Critical |

Basismetriken (v3.1): Angriffsvektor, Komplexität, benötigte Rechte, Benutzerinteraktion, Scope, Auswirkungen auf Vertraulichkeit, Integrität, Verfügbarkeit.

> [!MERKE] Kontext schlägt Zahl
> Ein CVSS-Wert beschreibt die Schwachstelle allgemein. Die Priorität für den Kunden hängt zusätzlich davon ab, wie exponiert das System ist, welche Daten es verarbeitet und ob die Lücke bereits aktiv ausgenutzt wird (z. B. CISA-KEV-Liste, EPSS).

## Schreibstil

- sachlich, präzise, ohne Übertreibung oder Schuldzuweisung
- aktiv formulieren, Fachbegriffe beim ersten Auftreten erklären
- positive Beobachtungen erwähnen (was gut funktioniert hat)
- Grenzen des Tests offenlegen

## Quiz

? Für wen ist die Executive Summary geschrieben?
+ für die Geschäftsleitung bzw. nicht-technische Entscheider
- für andere Pentester
- für die Polizei
- für den Webserver

? Ab welchem CVSS-Wert gilt eine Schwachstelle als Critical?
= 9.0
= 9

? Welcher CVSS-Bereich entspricht High?
+ 7.0 – 8.9
- 4.0 – 6.9
- 9.0 – 10.0
- 0.1 – 3.9

? Wie heißt die Darstellung, wie mehrere Befunde zusammen zum Ziel führten?
= Attack Chain
= Angriffsweg

? Wie schwärzt man sensible Daten in Screenshots richtig?
+ mit deckenden Balken
- mit Weichzeichner
- gar nicht
- durch Verkleinern des Bildes

? Mit welchem Linux-Befehl zeichnet man eine Terminal-Sitzung auf?
= script

?tf Ohne Bericht kann man CPTS nicht bestehen.
= wahr
