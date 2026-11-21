---
id: cr-33
title: Projektplan
paths: cyberrange
order: 33
difficulty: hard
icon: calendar
summary: Kapitel 33 deiner Cyber-Range-Dokumentation: Projektplan.
source: Cyber_Range_Dokumentation.docx
htb: 
---

## Projektziele und Abnahmekriterien

| **Ziel** | **Abnahmekriterium** |
|---|---|
| **Funktionsfähige 2-Maschinen-Range** | Alle Abnahmetests aus Kapitel 18.9 bestanden |
| **Vollständig reproduzierbar** | Kompletter Neuaufbau aus Git in < 90 Minuten (ohne Template-Bau) |
| **Beobachtbar** | Alle 9 Phasen von »Operation Nordlicht« erzeugen die erwartete Telemetrie |
| **Durchgeführte Pilotübung** | Mindestens 1 Red-vs-Blue-Übung mit AAR-Bericht |
| **Dokumentiert** | Diese Dokumentation + Runbooks + Szenario-Handbuch im Repository |
| **Skalierungsentscheidung** | Begründete Empfehlung für Stufe 3 (Kapitel 19) |

Tabelle 182: Ziele und Abnahmekriterien

## Phasen und Meilensteine

![Abbildung 80: Projektplan als Gantt-Diagramm](asset:cyberrange/cr-33-080.png)

| **Phase** | **Inhalt** | **Dauer** | **Meilenstein / Ergebnis** |
|---|---|---|---|
| **P0 Initiierung** | Ziele, Beteiligte, Budget, RoE-Entwurf, Hardware bestellen | 1 Woche | M0: Projektauftrag |
| **P1 Basis** | Hardware, UEFI, Proxmox auf beiden Maschinen, Härtung, Backup | 2 Wochen | M1: Hypervisoren betriebsbereit |
| **P2 Netz** | Bridges, OPNsense, VLANs, Regelwerk, SINET-Grundgerüst | 2 Wochen | M2: Isolation nachgewiesen (Egress-Test) |
| **P3 IaC** | Gitea, Packer-Templates, OpenTofu-Module, Ansible-Rollen | 3 Wochen | M3: Range per Code aufbaubar |
| **P4 Monitoring** | Spiegelung, Security Onion, Wazuh, Sysmon, Dashboards | 2 Wochen | M4: Telemetrie vollständig |
| **P5 Szenario** | AD, Schwachstellen, GHOSTS, Red-Team-Automatisierung, MSEL | 3 Wochen | M5: Szenario vollständig |
| **P6 Zugang & Scoring** | Keycloak, Guacamole, CTFd, Service-Checks | 1 Woche | M6: Teilnehmerzugang |
| **P7 Dry-Run** | Testdurchlauf, Fehlerbehebung, Reset-Test | 1 Woche | M7: Go/No-Go |
| **P8 Pilotübung** | Durchführung, AAR | 1 Woche | M8: Pilot abgeschlossen |
| **P9 Review** | Lessons Learned, Skalierungsentscheidung | laufend | M9: Roadmap Stufe 3 |

Tabelle 183: Phasenplan (Summe ≈ 16 Wochen)

## Arbeitspakete im Detail (Auszug)

| **AP** | **Arbeitspaket** | **Ergebnis** | **Aufwand (PT)** |
|---|---|---|---|
| **1.1** | Hardware beschaffen, aufbauen, verkabeln | Zwei betriebsbereite Server | 3 |
| **1.2** | Proxmox installieren, härten, Backup einrichten | Hypervisoren mit 2FA, Token, Backup | 3 |
| **2.1** | OPNsense, VLANs, Regelwerk | Isolierte Zonen, dokumentiertes Regelwerk | 4 |
| **2.2** | SINET (DNS, Web, Mail, PKI, INetSim) | Simuliertes Internet | 4 |
| **3.1** | Packer-Templates (4 Betriebssysteme) | Templates 9001–9004 | 5 |
| **3.2** | OpenTofu-Module (corp-net, dmz, sinet) | Range per `tofu apply` | 5 |
| **3.3** | Ansible-Rollen (AD, Dienste, Agenten, Schwachstellen) | Konfigurierte Range, idempotent | 8 |
| **4.1** | Security Onion + Spiegelung | NSM-Telemetrie | 3 |
| **4.2** | Wazuh + Sysmon + Sigma-Regeln | Host-Telemetrie, Detektionen | 4 |
| **5.1** | Szenario Nordlicht (Story, MSEL, Lernziele) | Szenario-Handbuch | 5 |
| **5.2** | Caldera-Operation, GHOSTS-Timelines | Automatisierte Angriffskette, NPC-Verkehr | 5 |
| **6.1** | Keycloak, Guacamole, CTFd, Scoring | Teilnehmerzugang, Bewertung | 4 |
| **7.1** | Dry-Run, Fehlerbehebung | Go/No-Go-Entscheidung | 4 |
| **8.1** | Pilotübung + AAR | Übungsbericht | 4 |

Tabelle 184: Arbeitspakete (PT = Personentage, Richtwerte für erfahrene Bearbeiter)

## Rollen im Projekt

| **Rolle** | **Aufgaben** | **Kompetenzen** |
|---|---|---|
| **Projektleitung / White Lead** | Ziele, Zeitplan, Szenario-Freigabe, RoE | Projektmanagement, Übungsdesign |
| **Infrastruktur (Green)** | L0–L3, Proxmox, Netz, IaC, Betrieb | Linux, Virtualisierung, Netzwerk, OpenTofu/Ansible |
| **Detection / Blue Lead** | L5, SIEM, Sensoren, Detektionsregeln | Security Onion, Wazuh, Zeek/Suricata, Sigma |
| **Red Lead** | Angriffskette, Automatisierung, C2 | Pentesting, AD-Angriffe, Caldera |
| **Szenario-Autor** | Storyline, Injects, Lernziele, Rubriken | Didaktik, Fachwissen |

Tabelle 185: Projektrollen (in kleinen Teams in Personalunion)

## Risiken

| **Risiko** | **Eintritt** | **Auswirkung** | **Gegenmaßnahme** |
|---|---|---|---|
| **Ausbruch (Malware/Scan verlässt Range)** | Niedrig | Sehr hoch | Bridge ohne Uplink, Default Deny, Egress-Tests vor jeder Übung |
| **RAM-Engpass** | Hoch | Mittel | 128 GB auf A, Linked Clones, KSM, Szenario-Größe begrenzen |
| **Szenariobau dauert länger** | Hoch | Mittel | Fertige Bausteine (GOAD, Ludus-Rollen), iterativ vorgehen |
| **Eval-Lizenz läuft während Übung ab** | Mittel | Mittel | Template-Refresh vor jeder Übung, Ablaufdatum überwachen |
| **Wissen bei einer Person** | Mittel | Hoch | Alles als Code + Doku, Pair-Work |
| **Hardware-Ausfall** | Niedrig | Hoch | Backups, Neuaufbau per IaC, Ersatz-NVMe |
| **Komponenten werden eingestellt** | Mittel | Mittel | Offene Standards, regelmäßige Marktbeobachtung |
| **Datenschutz bei Leistungsmessung** | Mittel | Mittel | Information, Pseudonymisierung, Löschkonzept |

Tabelle 186: Risikoregister

## Budget-Richtwerte

Hardwarepreise schwanken stark (insbesondere Arbeitsspeicher und NVMe waren 2025/2026 deutlich teurer als in den Vorjahren). Die Tabelle dient nur der **Struktur**; vor der Beschaffung aktuelle Angebote einholen.

| **Position** | **Variante »Budget«** | **Variante »Empfohlen«** | **Hinweis** |
|---|---|---|---|
| **Maschine A (Range)** | Gebrauchter Server/Workstation, 64 GB | Neu, 16 Kerne, 128 GB ECC, 2 × 2 TB NVMe | RAM ist Hauptkostentreiber |
| **Maschine B (Ops)** | Gebrauchter Rechner, 32 GB | 8–12 Kerne, 64 GB, 2 TB NVMe + PCAP-Speicher |  |
| **Netzwerk** | Unmanaged Switch, Zusatz-NIC | Managebarer Switch, 4-Port-NICs |  |
| **USV** | optional | ja | Geordnetes Herunterfahren |
| **Software** | 0 € (Open Source, Eval-Lizenzen) | optional Proxmox-Abo, Windows-Lizenzen | Abo = Enterprise-Repository + Support |
| **Personal** | Größter Posten: ca. 60–70 Personentage (23.3) |  |  |

Tabelle 187: Budget-Struktur
