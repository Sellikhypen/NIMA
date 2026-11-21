---
id: cr-12
title: Teams, Rollen und Spielregeln
paths: cyberrange
order: 12
difficulty: easy
icon: person.3
summary: Kapitel 12 deiner Cyber-Range-Dokumentation: Teams, Rollen und Spielregeln.
source: Cyber_Range_Dokumentation.docx
htb: 
---

## Überblick

Eine Cyber Range ist nicht nur Technik. Die Logik einer Übung ergibt sich aus dem Zusammenspiel klar getrennter Teams. Die »Farbenlehre« hat sich international durchgesetzt und wird z. B. bei der NATO-Übung **Locked Shields** verwendet.

## Die Farbenlehre der Teams

| **Team** | **Aufgabe** | **Zugriff in der Range** | **Werkzeuge (Beispiele)** |
|---|---|---|---|
| **Red Team** | Angreifer; führt die Angriffskette nach Drehbuch aus | RED-Netz, SINET, C2-Infrastruktur | Kali, Metasploit, Sliver/Mythic, Caldera, Impacket, BloodHound |
| **Blue Team** | Verteidiger; erkennt, analysiert, reagiert, hält Dienste verfügbar | Eigene Firmennetze, SOC-VMs, SIEM | Security Onion, Wazuh, Velociraptor, Sysmon |
| **Purple Team** | Vermittelt zwischen Red und Blue, maximiert Lerneffekt | Lesend auf beides | ATT&CK Navigator, VECTR, Atomic Red Team |
| **White Team** | Übungsleitung: Regeln, Szenario, Injects, Bewertung, Schiedsrichter | Lesend überall, Steuerkonsole | MSEL, Scoring-Engine, CTFd, Chat |
| **Green Team** | Betreibt die Infrastruktur (Build, Betrieb, Reset) | Vollzugriff L0–L3 | Proxmox, OpenTofu, Ansible, Gitea |
| **Yellow Team** | Lagebild (Locked Shields); teils Nutzer-/Business-Simulation | Lesend, Dashboards | Grafana, Kibana, Berichte |
| **Grey / NPC** | Simulierte »normale« Benutzer und Hintergrundverkehr | Automatisiert in allen Netzen | CMU SEI GHOSTS |

Tabelle 77: Teams einer Cyber-Übung

## Verantwortlichkeiten

| **Aktivität** | **White** | **Green** | **Red** | **Blue** |
|---|---|---|---|---|
| **Lernziele & Szenario definieren** | A/R | C | C | I |
| **Infrastruktur bauen und testen** | C | A/R | C | I |
| **Angriffe ausführen** | A | I | R | – |
| **Verteidigen, berichten** | A | I | – | R |
| **Injects einspielen** | A/R | C | C | I |
| **Scoring & Debriefing** | A/R | C | C | C |
| **Reset / Teardown** | A | R | I | I |

Tabelle 78: RACI-Matrix (R = Responsible, A = Accountable, C = Consulted, I = Informed)

## Spielregeln (Rules of Engagement)

Die RoE werden vor jeder Übung schriftlich verteilt und von allen bestätigt:

- **Scope:** Welche Netze sind Ziel? (z. B. nur 10.10.0.0/16, niemals 10.0.0.0/24 = Management).
- **Verbotene Aktionen:** Angriffe auf die Range-Infrastruktur (Hypervisor, Scoring, Monitoring), Störung der Scoring-Checks, Ausbruchsversuche aus VMs – außer es ist ausdrückliches Übungsziel.
- **Zeitfenster:** Angriffe nur in definierten Phasen; »Pause« und »ENDEX« durch das White Team.
- **Kommunikation:** ein Kanal je Team, Eskalationsweg zum White Team, Kennwort für Übungsabbruch.
- **Daten:** keine echten personenbezogenen Daten, nur synthetische Identitäten.
## Die Übungsleitung im Detail

Bei größeren Übungen ist das White Team keine einzelne Person, sondern eine kleine Organisation – oft »White Cell« oder »EXCON« (Exercise Control) genannt. Die folgenden Rollen haben sich international bewährt:

| **Rolle** | **Aufgaben** | **Anzahl (Pilot)** |
|---|---|---|
| **Exercise Director** | Gesamtverantwortung, Go/No-Go, Abbruchentscheidung | 1 |
| **Lead Planner / Szenario-Autor** | Szenario, MSEL, Lernziele, Injects | 1 (oft Personalunion mit Director) |
| **Controller** | Führen die Injects aus, beantworten Rückfragen der Teams, spielen Rollen (Geschäftsführung, Presse, Behörde) | 1–2 |
| **Evaluator / Schiedsrichter** | Bewerten Berichte und Leistungen anhand der Rubrik | 1 je 2 Teams |
| **Technical Lead (Green)** | Stabiler Betrieb, Fehlerbehebung, Reset | 1–2 |
| **Red Lead** | Koordiniert das Red Team, hält die MSEL-Zeitpunkte ein | 1 |
| **Beobachter** | Lernen zu, keine Eingriffe | beliebig |

Tabelle 79: Rollen der Übungsleitung

### RACI-Matrix für den Übungszyklus

| **Tätigkeit** | **Director** | **Planner** | **Green** | **Red Lead** | **Evaluator** |
|---|---|---|---|---|---|
| **Lernziele festlegen** | A | R | I | C | C |
| **Szenario und MSEL schreiben** | A | R | C | C | C |
| **Range bauen und testen** | I | C | A/R | C | I |
| **Dry-Run durchführen** | A | R | R | R | C |
| **Injects während der Übung** | A | R | I | C | I |
| **Notfall-Abbruch** | A/R | I | R | I | I |
| **Bewertung und Scoring** | A | C | C | I | R |
| **AAR moderieren** | A | R | C | C | R |

Tabelle 80: RACI: R = durchführend, A = verantwortlich, C = konsultiert, I = informiert

## Kommunikation während der Übung

Klare Kommunikationswege verhindern Chaos. Jede Übung legt vorab fest, **welcher Kanal wofür** genutzt wird – und wie man echte Notfälle von Übungsereignissen unterscheidet.

| **Kanal** | **Nutzer** | **Zweck** |
|---|---|---|
| **Team-Chat (je Team)** | Teammitglieder | Interne Abstimmung des Teams |
| **Ticket-/Berichtssystem** | Blue → White | Lageberichte, Incident-Meldungen (werden bewertet) |
| **Inject-Kanal** | White → Teams | Ereignisse der Übungswelt (E-Mails der Geschäftsführung, Presseanfragen) |
| **Technik-Hotline** | alle → Green | Technische Störungen der Range (werden nicht bewertet) |
| **Leitungskanal** | White, Green, Red Lead | Steuerung, Absprachen, Pausen |

Tabelle 81: Kommunikationskanäle

> [!GEFAHR] Codewörter für den Ernstfall
> **»ÜBUNG – ÜBUNG – ÜBUNG«** steht vor jeder Nachricht aus der Übungswelt, die mit echter Kommunikation verwechselt werden könnte (z. B. E-Mails an echte Postfächer).
> **»REALEREIGNIS«** (international oft »NO DUFF«) kennzeichnet einen echten Notfall – etwa einen medizinischen Notfall oder einen realen Sicherheitsvorfall. Die Übung pausiert sofort.
> **»STOPP«** durch den Exercise Director hält alle Aktivitäten an; **»ENDEX«** beendet die Übung.

## Musterfassung der Spielregeln (Rules of Engagement)

Die Spielregeln werden vor jeder Übung schriftlich festgelegt und von allen Beteiligten zur Kenntnis genommen. Die folgende Musterfassung ist eine Vorlage, die an die jeweilige Übung angepasst wird.

| **Abschnitt** | **Regel (Mustertext)** |
|---|---|
| **1 Geltungsbereich** | Die Übung findet ausschließlich in den Netzen der Range statt (10.10.0.0/16 sowie SINET-Bereiche 198.51.100.0/24 und 203.0.113.0/24). Alle anderen Netze und Systeme sind tabu. |
| **2 Verbotene Ziele** | Hypervisoren, Proxmox-API, Monitoring-Systeme, Scoring, Guacamole, Keycloak und die Netze MGMT und SVC sind keine Übungsziele. Ein Zugriffsversuch führt zum Ausschluss. |
| **3 Erlaubte Mittel (Red)** | nur vom White Team freigegebene Werkzeuge und Infrastruktur im SINET; keine zerstörenden Aktionen außer den im Drehbuch vorgesehenen Simulationen |
| **4 Erlaubte Mittel (Blue)** | Härtung, Überwachung, Eindämmung und Wiederherstellung der eigenen Systeme; Pflichtdienste (Webshop, Mail, Fileserver) dürfen nicht dauerhaft abgeschaltet werden |
| **5 Zeiten** | Angriffe nur zwischen STARTEX und ENDEX, nicht in der Pause (12:00–12:30) |
| **6 Kommunikation** | Meldungen nur über die festgelegten Kanäle; Codewörter »REALEREIGNIS« und »STOPP« sind jederzeit verbindlich |
| **7 Daten** | keine Daten aus der Range kopieren; Bildschirmaufzeichnung und Protokollierung finden statt (Datenschutzhinweis) |
| **8 Unklarheiten** | Im Zweifel nachfragen (Technik-Hotline bzw. Leitungskanal) – nicht ausprobieren |
| **9 Verstöße** | Das White Team kann Punkte abziehen, Zugänge sperren oder Teilnehmende ausschließen |

Tabelle 82: Musterfassung der Rules of Engagement
