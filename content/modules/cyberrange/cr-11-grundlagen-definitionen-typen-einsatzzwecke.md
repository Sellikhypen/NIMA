---
id: cr-11
title: Grundlagen: Definitionen, Typen, Einsatzzwecke
paths: cyberrange
order: 11
difficulty: easy
icon: books.vertical
summary: Kapitel 11 deiner Cyber-Range-Dokumentation: Grundlagen: Definitionen, Typen, Einsatzzwecke.
source: Cyber_Range_Dokumentation.docx
htb: Cyber Range 16 · Fachbegriffe (Glossar)
---

## Definitionen

Es gibt keine einzelne genormte Definition. Die wichtigsten Referenzen beschreiben jedoch übereinstimmend dieselben Kernmerkmale:

| **Quelle** | **Kernaussage (sinngemäß, übersetzt)** | **Betonte Merkmale** |
|---|---|---|
| **NIST / NICE – »The Cyber Range: A Guide« (2023) und NICE-Papier »Cyber Ranges«** | Cyber Ranges sind interaktive, simulierte Abbilder des lokalen Netzes, der Systeme, Werkzeuge und Anwendungen einer Organisation, die an eine simulierte Internet-Umgebung angebunden sind. Sie bieten eine sichere, legale Umgebung für praktische Fähigkeiten sowie für Produktentwicklung und das Testen der Sicherheitslage. | Interaktivität, simuliertes Internet, legal und sicher, Training + Test |
| **ECSO (European Cyber Security Organisation)** | Eine Plattform für Entwicklung, Bereitstellung und Nutzung interaktiver Simulationsumgebungen, bestehend aus Kerntechnologien und zusätzlichen Komponenten für bestimmte Anwendungsfälle. | Plattformcharakter, Kern + Erweiterungen |
| **Yamin, Katt, Gkioulos (Computers & Security, 2020)** | Taxonomie entlang der Dimensionen Szenario, Monitoring, Lernen, Management, Teaming und Umgebung. | Funktionale Gliederung, Teams, Lernanalyse |
| **Davis & Magrath (DSTO, 2013)** | Klassifikation nach Realisierungsart: Simulation, Overlay, Emulation (plus Mischformen). | Technische Realisierungstiefe |

Tabelle 69: Definitionen einer Cyber Range im Vergleich

**Arbeitsdefinition dieses Projekts:** Eine Cyber Range ist eine isolierte, per Code reproduzierbare und vollständig überwachte Übungs- und Testumgebung, die reale Netze, Systeme, Benutzerverhalten und ein simuliertes Internet nachbildet und deren Ablauf durch eine Übungsleitung gesteuert, aufgezeichnet und bewertet wird.

## Abgrenzung zu verwandten Begriffen

| **Begriff** | **Was es ist** | **Unterschied zur Cyber Range** |
|---|---|---|
| **Homelab / Testlabor** | Einige VMs zum Ausprobieren | Keine Isolation by Design, kein Szenario, keine Bewertung, kein Reset-Konzept |
| **Testbed** | Forschungsumgebung für eine konkrete Fragestellung | Fokus auf Experiment und Messung, weniger auf Training und Teams |
| **Sandbox (Malware)** | Isolierte Ausführung einzelner Dateien (z. B. CAPE) | Ein Host statt Netzwerk; automatisierte Analyse statt Übung |
| **CTF-Plattform** | Aufgaben- und Flaggensystem (z. B. CTFd) | Liefert Aufgaben und Punkte – die Infrastruktur dahinter ist die Range |
| **Digital Twin** | Möglichst exaktes, oft live gespiegeltes Abbild eines realen Systems | Eine Range kann einen Digital Twin enthalten, ist aber allgemeiner |
| **Tabletop-Übung** | Diskussionsbasierte Übung ohne Technik | Range = technische Übung; Kombination (Hybrid) ist üblich |

Tabelle 70: Abgrenzung verwandter Begriffe

## Realisierungsarten

| **Typ** | **Prinzip** | **Vorteile** | **Nachteile** | **Beispiele** |
|---|---|---|---|---|
| **Simulation** | Netz und Systeme als Software-Modelle (keine echten Betriebssysteme) | Sehr skalierbar, günstig | Geringer Realismus, echte Exploits laufen nicht | ns-3, OMNeT++ |
| **Emulation** | Echte Betriebssysteme und Dienste in VMs/Containern | Hoher Realismus, echte Werkzeuge | Ressourcenhungrig | Proxmox-/OpenStack-Ranges, KYPO, Ludus |
| **Overlay** | Übungsnetz über reale, verteilte Infrastruktur | Echte Hardware, verteilt | Isolation schwieriger, teuer | Föderierte Testbeds |
| **Hybrid** | Emulation + echte Hardware (SPS, Router, IoT) | Realistisch für OT/ICS | Reset aufwendig | OT-Ranges mit Hardware-in-the-Loop |
| **Cloud / CRaaS** | Range in Public/Private Cloud (Cyber Range as a Service) | Elastisch, kein Hardwarekauf | Laufende Kosten, Nutzungsbedingungen | Splunk Attack Range, kommerzielle Anbieter |

Tabelle 71: Realisierungsarten von Cyber Ranges

Dieses Projekt ist eine **Emulations-Range**, die später um hybride Elemente (z. B. echte Netzwerk- oder OT-Hardware an einem dedizierten Port) erweitert werden kann.

## Einsatzzwecke

- **Training & Ausbildung:** Hands-on-Labs vom Einsteiger bis zum Experten (Pentesting, Forensik, Incident Response, Härtung), angelehnt an Kompetenzrahmen wie NICE (NIST SP 800-181 Rev. 1) oder ENISA ECSF.
- **Übungen:** Red-vs-Blue-, Purple-Team- und Live-Fire-Übungen; vgl. NIST SP 800-84 (Test, Training & Exercise Programs).
- **Detection Engineering:** Angriffe reproduzierbar ausführen und prüfen, ob SIEM-, Sigma- oder EDR-Regeln anschlagen – auch automatisiert in CI/CD.
- **Produkt- und Konfigurationstests:** Firewalls, EDR, Patches, Härtungs-Baselines vor dem Rollout testen.
- **Malware- und Schwachstellenforschung:** kontrollierte Detonation, Exploit-Entwicklung ohne Risiko für Produktivnetze.
- **Incident-Response-Drills:** Abläufe gegen realistische Angriffe proben, MTTD und MTTR messen.
- **Recruiting & Zertifizierung:** praktische Prüfungen statt Multiple Choice.
- **OT/ICS:** Angriffe auf Industrieprotokolle (Modbus/TCP 502, S7comm 102, OPC UA 4840) in hybriden Ranges üben.
## Übungsformate

| **Format** | **Beschreibung** | **Anforderung an die Range** |
|---|---|---|
| **Individuelles Lab** | Teilnehmer arbeitet allein Aufgaben ab | Viele kleine identische Sandboxen, schnelles Klonen/Reset |
| **CTF Jeopardy** | Aufgabenkatalog mit Flaggen | CTFd + einzelne Challenge-Container/VMs |
| **CTF Attack/Defense** | Teams verteidigen eigene Dienste und greifen andere an | Identische Team-Netze, Service-Checker, Runden-Scoring |
| **Red vs. Blue (Live-Fire)** | Red Team greift an, Blue Teams verteidigen eine »eigene« Firma | Vollständiges Firmennetz pro Blue Team, NPC-Verkehr, SIEM |
| **Purple Teaming** | Red und Blue arbeiten Technik für Technik zusammen | Angriffsautomatisierung + Detektionsfeedback in Echtzeit |
| **Hybride Krisenübung** | Technik + Management- und Kommunikations-Injects | Inject-Management, Kommunikationskanäle, Lagebild |

Tabelle 72: Übungsformate und ihre Anforderungen

## Kurze Geschichte der Cyber Ranges

Cyber Ranges sind aus dem militärischen Übungswesen entstanden und haben sich in rund fünfzehn Jahren zu einem eigenen Markt entwickelt. Die Entwicklung erklärt, warum heutige Ranges so aufgebaut sind, wie sie sind.

| **Zeitraum** | **Entwicklung** | **Bedeutung für heutige Ranges** |
|---|---|---|
| **vor 2008** | Isolierte Testlabore, »Red-Team-Labs« in Behörden und Universitäten; erste CTF-Wettbewerbe (DEF CON CTF seit 1996) | Spielerischer Wettbewerb als Lernform |
| **2008–2010** | Gründung des NATO CCDCOE (2008); DARPA startet die National Cyber Range; erste Locked Shields (2010); NATO-Übung Cyber Coalition (seit 2008) | Live-Fire-Übungen mit Red vs. Blue werden Standard |
| **2010–2015** | ENISA Cyber Europe (seit 2010, alle zwei Jahre); KYPO-Projekt an der Masaryk-Universität (ab 2013); Virtualisierung macht Ranges bezahlbar | Reproduzierbarkeit durch Virtualisierung |
| **2015–2020** | Infrastructure as Code, Cloud-Ranges, kommerzielle Anbieter; Open-Source-Werkzeuge wie GHOSTS, Caldera, DetectionLab | Automatisierung und simulierte Benutzer |
| **seit 2020** | Ranges als Dienst (CRaaS), Homelab-Orchestratoren (Ludus, GOAD), Integration von OT/ICS und Cloud; Locked Shields mit rund 4.000 Beteiligten aus über 40 Nationen | Skalierung, Mandantenfähigkeit, hybride Szenarien |

Tabelle 73: Meilensteine der Entwicklung

> [!INFO] Locked Shields 2025 in Zahlen
> Laut NATO CCDCOE nahmen 2025 mehr als 4.000 Personen aus 41 Nationen in 17 multinationalen Blue Teams teil (28. April bis 9. Mai 2025, Tallinn). Das Szenario setzte den fiktiven Konflikt zwischen »Berylia« und »Crimsonia« fort. Solche Größenordnungen sind nur mit hochautomatisierten Ranges möglich – das Prinzip ist aber dasselbe wie in der Pilot-Range dieses Dokuments.

## Marktüberblick: Bauen, mieten oder kombinieren?

Neben dem Eigenbau gibt es kommerzielle Angebote. Sie lassen sich grob in vier Kategorien einteilen; die Wahl hängt von Zielgruppe, Budget und gewünschter Kontrolle ab.

| **Kategorie** | **Typische Merkmale** | **Vorteile** | **Nachteile** |
|---|---|---|---|
| **Eigenbau (dieses Dokument)** | Open Source, eigene Hardware, volle Kontrolle | Anpassbar, keine Lizenzkosten, Wissensaufbau im Team | Personalaufwand, Verantwortung für Betrieb |
| **Akademische Plattformen** | z. B. KYPO CRP (Open Source), Crucible/TopoMojo | Erprobt, große Community, frei | Betrieb komplex (OpenStack bzw. Kubernetes) |
| **Kommerzielle Ranges / CRaaS** | Fertige Szenarien, Mandanten, Support | Schneller Start, professionelle Inhalte | Kosten, Abhängigkeit, eingeschränkte Anpassung |
| **Lernplattformen** | Browserbasierte Labs, CTF-Plattformen | Sehr niedrige Einstiegshürde | Kaum eigene Szenarien, keine eigene Infrastruktur |

Tabelle 74: Kategorien von Cyber-Range-Angeboten

In der Praxis ist ein **hybrides Modell** häufig sinnvoll: Grundlagen-Labs auf einer Lernplattform, eigene Szenarien mit firmenspezifischer Infrastruktur auf der eigenen Range. Der Vorteil der eigenen Range liegt darin, dass die Übungsumgebung der **eigenen** Produktivumgebung ähneln kann – inklusive der eigenen Firewall-Produkte, Namenskonventionen und Prozesse.

## Den Nutzen einer Range messen

Eine Range kostet Geld und Zeit. Damit sich die Investition begründen lässt, werden von Anfang an Kennzahlen erhoben. Bewährt hat sich die Einteilung in vier Ebenen (angelehnt an das Kirkpatrick-Modell für Trainingsevaluation):

| **Ebene** | **Frage** | **Kennzahl (Beispiele)** |
|---|---|---|
| **1 Reaktion** | Wie haben Teilnehmer die Übung erlebt? | Zufriedenheit, Realismus-Bewertung, Net Promoter Score |
| **2 Lernen** | Was können sie danach besser? | Vorher-/Nachher-Test, gelöste Aufgaben, Rubrik-Punkte |
| **3 Verhalten** | Wenden sie es im Alltag an? | Nutzung neuer Playbooks, Qualität echter Incident-Tickets |
| **4 Ergebnis** | Wird die Organisation sicherer? | MTTD und MTTR bei realen Vorfällen, Anzahl neuer Detektionsregeln, geschlossene Lücken |

Tabelle 75: Vier Ebenen der Wirkungsmessung

> [!TIPP] Kennzahlen der Range selbst
> Zusätzlich misst das Green Team die **Betriebskennzahlen**: Zeit für einen kompletten Neuaufbau, Reset-Dauer, Verfügbarkeit während Übungen, Anzahl manueller Eingriffe. Sinken diese Werte über die Zeit, reift die Plattform.

## Verwandte Begriffe genau abgegrenzt

Rund um Cyber Ranges werden mehrere Begriffe oft vermischt. Für Planung, Ausschreibungen und Gespräche mit Entscheidern hilft eine klare Abgrenzung:

| **Begriff** | **Hauptzweck** | **Wer ist »drin«?** | **Unterschied zur Cyber Range** |
|---|---|---|---|
| **Cyber Range** | Üben, Testen, Messen mit Szenario und Bewertung | Teilnehmer (Red, Blue), Übungsleitung | – |
| **Testbed** | Technik unter kontrollierten Bedingungen erproben | Forscher, Entwickler | meist ohne Szenario, Teams und Bewertung |
| **Sandbox (Malware-Analyse)** | verdächtige Dateien automatisch ausführen und beobachten | niemand interaktiv | kurzlebig, eine Probe, kein Übungsgeschehen |
| **Honeynet** | echte Angreifer anlocken und beobachten | echte, unbekannte Angreifer | absichtlich mit dem Internet verbunden – eine Range nie |
| **Digitaler Zwilling** | reales System möglichst genau abbilden, oft mit Live-Daten | Betreiber, Ingenieure | Abbild einer konkreten Anlage; eine Range kann einen Zwilling enthalten |
| **Schulungslabor** | Bedienung eines Produkts lernen | Schulungsteilnehmer | keine Gegenspieler, kein Szenario |
| **CTF-Plattform** | Wettbewerb mit Aufgaben und Flaggen | Spieler | Teil einer Range möglich; allein ohne realistische Firmenumgebung |

Tabelle 76: Abgrenzung verwandter Begriffe

> [!TIPP] Für Gespräche mit Entscheidern
> Die verständlichste Kurzformel lautet: **Ein Testbed prüft Technik, eine Cyber Range trainiert Menschen und Organisationen.** Beides kann auf derselben Plattform laufen – der Unterschied liegt in Szenario, Rollen und Bewertung.
