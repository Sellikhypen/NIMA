---
id: cr-01
title: Einleitung und Überblick
paths: cyberrange
order: 1
difficulty: easy
icon: book.pages
summary: Kapitel 1 deiner Cyber-Range-Dokumentation: Einleitung und Überblick.
source: Cyber_Range_Dokumentation.docx
htb: Cyber Range 01 · Grundlagen & Zweck
---

## Was ist eine Cyber Range – in einem Satz

Eine **Cyber Range** ist ein abgeschottetes »Trainingsgelände« für IT-Sicherheit: eine vollständig nachgebaute, aber vom echten Netz getrennte IT-Umgebung, in der Angriffe und Verteidigung realistisch, legal und gefahrlos geübt, getestet und gemessen werden. Der Begriff stammt aus dem Militär – eine »Range« ist dort ein Schießplatz, auf dem mit scharfer Munition geübt wird, ohne dass jemand außerhalb gefährdet ist. Genau das ist die Idee: **scharfe Angriffe, aber in einem geschlossenen Raum**.

## Was sie von einem normalen Testlabor unterscheidet

Ein paar virtuelle Maschinen auf einem Rechner sind noch keine Cyber Range. Erst vier Eigenschaften zusammen machen daraus eine:

| **Eigenschaft** | **Was das bedeutet** | **Woran man es technisch erkennt** |
|---|---|---|
| **1. Isolation** | Nichts – kein Scan, keine Schadsoftware, kein Datenpaket – gelangt aus der Übung in reale Netze. | Übungsnetz ohne physischen Ausgang, Firewall mit Default Deny, simuliertes Internet |
| **2. Reproduzierbarkeit** | Jede Übung lässt sich identisch wiederholen und nach dem Ende in Minuten zurücksetzen. | IaC (Infrastructure as Code), Templates, Snapshots |
| **3. Beobachtbarkeit** | Alles, was passiert, wird aufgezeichnet und kann ausgewertet und bewertet werden. | Netzwerk-Mitschnitt, Agenten auf allen Systemen, zentrales SIEM |
| **4. Szenario-Steuerung** | Eine Übungsleitung gibt Ziele vor, spielt Ereignisse ein und bewertet die Leistung. | Drehbuch (MSEL), Injects, Scoring, Nachbesprechung (AAR) |

Tabelle 1: Die vier Kerneigenschaften einer Cyber Range

## Wozu dieses Dokument dient

Dieses Dokument ist **Fachkonzept, Architekturbeschreibung, Bauanleitung und Projektplan in einem**. Es soll so genau sein, dass ein kleines Team die Range danach tatsächlich bauen und betreiben kann. Es beginnt – wie beim Hausbau – mit dem **Aufbau**: Welche Teile gibt es, wie liegen sie übereinander, wie sind sie verbunden? Erst danach wird erklärt, nach welcher Logik die Range arbeitet und wie die Teile auf Protokoll- und Paketebene miteinander sprechen.

| **Teil** | **Inhalt** | **Für wen besonders wichtig** |
|---|---|---|
| **A – Aufbau (Kap. 1–10)** | Gesamtarchitektur, sieben Schichten L0–L6, Netzwerk, Software je Schicht | Alle; Pflichtlektüre für Infrastruktur-Verantwortliche |
| **B – Logik & Kommunikation (Kap. 11–15)** | Definitionen, Teams, Übungsablauf, Protokolle, Ports, Paketwege | Architekten, Netzwerk- und Security-Fachleute |
| **C – Praxis & Umsetzung (Kap. 16–22)** | Wie andere Ranges gebaut sind, 2-Maschinen-Setup, Bauanleitung, Skalierung, Szenario, Betrieb | Umsetzungsteam |
| **D – Vertiefung (Kap. 23–32)** | Detection Engineering, Szenario-Katalog, OT/ICS, Container, eigener Orchestrator, Performance, Backup, Bedrohungsmodell, Didaktik, 16 Praxislabore | Fortgeschrittene, Ausbilder, Betrieb |
| **E – Projekt & Anhang (Kap. 33–36)** | Projektplan, Checklisten, Glossar, Quellen und Prüfprotokoll | Projektleitung, Nachschlagen |

Tabelle 2: Aufbau des Dokuments

> [!INFO] Fachbegriffe werden unten auf der Seite erklärt
> Jeder Fachbegriff wird beim **ersten Vorkommen** mit einer hochgestellten Zahl markiert; die Erklärung steht als Fußnote **unten auf derselben Seite**. Alle Begriffe sind zusätzlich alphabetisch im **Glossar (Kapitel 35)** gesammelt.

## Das Ergebnis vorweg

> [!ERGEBNIS] Kernaussagen
> **Eine echte Cyber Range ist mit 2 physischen Maschinen machbar.** Maschine A (»range-01«) betreibt mit Proxmox VE alle Übungs-VMs inklusive einer virtuellen Firewall (OPNsense). Maschine B (»ops-01«) betreibt Überwachung (Security Onion, Wazuh), Zugang (Guacamole, Keycloak), Bewertung (CTFd) und die Automatisierung (Gitea, Terraform/OpenTofu, Ansible, Packer).
> **Der Software-Stack ist vollständig quelloffen.** Kosten entstehen im Wesentlichen für Hardware (vor allem Arbeitsspeicher) und Arbeitszeit.
> **Die Range wächst in Stufen:** 1 Rechner → 2 Rechner (Pilot) → Cluster ab 3 Knoten mit Ceph und SDN → institutionelle Plattform (OpenStack/Crucible).
> **Projektdauer bis zur ersten echten Übung:** rund 16 Wochen.

## Ein Rundgang für Einsteiger: die Range in Bildern aus dem Alltag

Wer zum ersten Mal mit einer Cyber Range zu tun hat, wird mit Fachbegriffen überschüttet. Die folgenden Vergleiche aus dem Alltag helfen, die Bausteine einzuordnen. Sie sind bewusst vereinfacht – die genaue technische Beschreibung folgt in den jeweiligen Kapiteln.

| **Baustein der Range** | **Vergleich aus dem Alltag** | **Was der Vergleich zeigt** | **Kapitel** |
|---|---|---|---|
| **Physische Server (L0)** | Das Grundstück und das Fundament eines Übungsgeländes | Alles steht darauf; ist es zu klein, passt nichts mehr hinzu | 3 |
| **Hypervisor (L1)** | Ein Gebäude mit beliebig vielen verschiebbaren Wänden | Aus einem großen Raum werden viele kleine, voneinander getrennte Räume (VMs) | 4 |
| **VLANs und Firewall (L2)** | Flure mit verschlossenen Türen und einem Pförtner | Jeder Raum hat seinen Flur; nur der Pförtner (Firewall) entscheidet, wer durch welche Tür darf | 5 |
| **Infrastructure as Code (L3)** | Ein Bauplan, nach dem ein Roboter das Gebäude jederzeit neu errichtet | Nichts wird von Hand gebaut; der Plan ist die Wahrheit | 6 |
| **Szenario (L4)** | Die Kulissen und Schauspieler eines Theaterstücks | Firma, Mitarbeitende, Dokumente und Schwachstellen wirken echt, sind aber erfunden | 7 |
| **Monitoring (L5)** | Überwachungskameras und Schiedsrichter | Alles wird aufgezeichnet und bewertet, ohne in das Spiel einzugreifen | 8 |
| **Zugangsschicht (L6)** | Der Empfang mit Ausweiskontrolle | Niemand betritt das Gelände, ohne sich anzumelden; jeder bekommt nur Zutritt zu seinen Räumen | 9 |
| **Snapshot / Reset** | Der Speicherstand in einem Videospiel | Nach der Übung wird auf den Ausgangszustand zurückgesprungen | 4.8 |
| **SINET** | Eine Filmkulisse einer Stadt | Sieht aus wie das Internet, ist aber vollständig nachgebaut und abgeschlossen | 5.6 |

Tabelle 3: Alltagsvergleiche für die Bausteine einer Range

> [!INFO] Die wichtigste Einsicht in einem Satz
> Eine Cyber Range ist **kein Werkzeug, sondern ein System aus Werkzeugen**: Erst das Zusammenspiel von getrennten Netzen, reproduzierbarem Aufbau, realistischem Szenario und lückenloser Beobachtung macht aus ein paar virtuellen Maschinen ein Übungsgelände.

## Lesepfade: Welche Kapitel brauche ich?

Nicht jede Rolle muss das ganze Dokument lesen. Die folgenden Lesepfade führen gezielt durch die für eine Rolle wichtigen Kapitel; alle anderen Kapitel dienen dann als Nachschlagewerk.

| **Rolle** | **Pflichtkapitel** | **Empfohlen** | **Zum Nachschlagen** |
|---|---|---|---|
| **Entscheider / Projektauftraggeber** | 1, 2, 11, 19, 33 | 16, 22.8–22.9, 30, 31 | Glossar (35) |
| **Projektleitung / White Lead** | 1–2, 12–13, 20–21, 33–34 | 23–24, 31 | alle übrigen |
| **Infrastruktur (Green Team)** | 2–6, 9–10, 17–19, 22, 28–29 | 14–15, 27, 30 | Bauanleitung (18), Checklisten (34) |
| **Detection / Blue Lead** | 2, 8, 14–15, 20–21, 23 | 24–26, 32 | Referenztabellen in 8.10–8.12 |
| **Red Lead** | 2, 5, 7, 12–14, 20 | 23–26, 30 | Schwachstellenkatalog (7.8) |
| **Szenario-Autor / Ausbilder** | 1, 7, 12–13, 20–21, 24, 31 | 23, 25–26, 32 | Glossar (35) |
| **Teilnehmer (vor einer Übung)** | 1.1–1.5, 12.3, 12.5 | 8.10–8.12, 15 | Glossar (35) |

Tabelle 4: Lesepfade nach Rolle
