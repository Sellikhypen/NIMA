---
id: cr-16
title: Wie andere Cyber Ranges aufgebaut sind
paths: cyberrange
order: 16
difficulty: medium
icon: globe.europe.africa
summary: Kapitel 16 deiner Cyber-Range-Dokumentation: Wie andere Cyber Ranges aufgebaut sind.
source: Cyber_Range_Dokumentation.docx
htb: Cyber Range 15 · Referenzprojekte & Orchestrierung
---

## Überblick

Die folgenden Projekte wurden ausgewertet, weil sie öffentlich dokumentiert sind und sehr unterschiedliche Größenordnungen abdecken – von der weltweit größten Live-Fire-Übung bis zum Homelab-Werkzeug. Für jedes Projekt zeigt ein Steckbrief, wie es auf die sieben Schichten dieses Dokuments abgebildet werden kann.

## NATO CCDCOE Locked Shields und CR14 (Estland)

**Locked Shields** ist die größte internationale Live-Fire-Cyberabwehrübung. Sie wird jährlich vom NATO Cooperative Cyber Defence Centre of Excellence (CCDCOE) in Tallinn organisiert und auf der estnischen Cyber Range **CR14** umgesetzt (gegründet 2011, seit 2019 an erweitertem Standort), die auch die NATO-Übung Cyber Coalition unterstützt.

| **Schicht** | **Umsetzung bei Locked Shields (öffentlich dokumentierter Stand)** |
|---|---|
| **L0/L1** | Eigene Großinfrastruktur; Berichte nennen über 3.000 (2017) bzw. über 4.000 virtualisierte Systeme |
| **L2** | Pro Blue Team ein identisches Netz einer fiktiven Nation (IT und OT); alle verbunden über ein simuliertes Internet (SINET) |
| **L4** | Komplexe Infrastruktur inkl. kritischer Dienste; ein User Simulation Team erzeugt Benutzeraktivität |
| **L5** | Zentrales Lagebild, Bewertung von Verfügbarkeit, Berichten und Reaktionen |
| **L6** | Blue Teams arbeiten remote aus ihren Heimatländern |
| **Teams** | Red (Angriff), Blue (Verteidigung), White (Planung, Szenario, Injects), Green (Infrastruktur), Yellow (Lagebild) |

Tabelle 109: Steckbrief Locked Shields / CR14

**Lehre:** Das **Klon-Prinzip** (ein Template-Netz × N Teams) und das **simulierte Internet** als zentrales Bindeglied sind die tragenden Architekturideen; ebenso die strikte Trennung zwischen Infrastruktur-Team, Übungsleitung und Teilnehmern.

## KYPO CRP / CyberRangeCZ (Masaryk-Universität, Brno)

| **Schicht** | **Umsetzung** |
|---|---|
| **L1** | OpenStack als »Engine« (VMs, Netze, Images) |
| **L2** | OpenStack-Netzwerke; jede Sandbox als eigener OpenStack-Stack; ein dedizierter Proxy-Server für SSH-Zugriff auf alle Sandboxen |
| **L3** | Infrastruktur per Terraform (`tf-openstack-base`, `tf-head-services`); Head-Services als Microservices auf Kubernetes (Helm); Sandbox-Definitionen in Git (Topologie + Ansible) |
| **L4/L6** | Lineare und adaptive Trainings, Webportal, Lernanalyse |
| **Einstieg** | »KYPO lite« installiert OpenStack in einer einzelnen KVM-VM – mindestens 4 vCPU und 48 GB RAM |
| **Status 2026** | Aktive Entwicklung beendet; Nachfolger ist die kompatible CyberRangeCZ Platform; MIT-Lizenz |

Tabelle 110: Steckbrief KYPO / CyberRangeCZ

**Lehre:** Range-Definitionen gehören in Git, der Sandbox-Lebenszyklus wird als Zustandsmaschine geführt. OpenStack lohnt sich aber erst bei großer Skalierung – für den Pilot ist es zu schwergewichtig.

## CMU SEI Crucible, GHOSTS und TopoMojo

| **Komponente** | **Aufgabe** |
|---|---|
| **Player** | Zentrale Oberfläche, in der Teams und Administratoren an einer Übung teilnehmen |
| **Caster** | Terraform-basierte Bereitstellung mit Weboberfläche; Ziele u. a. vSphere, Azure, AWS, Proxmox |
| **Steamfitter** | Geplante Aufgaben und Injects, die in VMs ausgeführt werden |
| **Alloy** | Verbindet die Komponenten zu einem Ereignis (Übungsinstanz) |
| **TopoMojo** | Lab-Builder und -Player für kleinere Umgebungen (vSphere/Proxmox) |
| **GHOSTS** | NPC-Framework: Clients führen Timelines aus, zentrale API (Port 5000) mit Postgres und Grafana (Port 3000) |

Tabelle 111: Steckbrief Crucible-Ökosystem

**Lehre:** Hintergrundverkehr ist kein Luxus. Laut SEI berichteten Teilnehmer mit GHOSTS von deutlich höherem Realismus, was mit höherer Bewertung des Trainingswerts einherging. Terraform-Module als wiederverwendbare Bausteine sind ein bewährtes Muster.

## Ludus (Bad Sector Labs)

| **Schicht** | **Umsetzung** |
|---|---|
| **L1** | Proxmox VE 8/9 bzw. Debian 12/13; mindestens 32 GB RAM pro Range, x86_64-CPU (PassMark > 6.000), NVMe; nur kabelgebundenes Netz, kein Docker auf dem Host |
| **L2** | Pro Range ein eigener Router und eigene VLANs; Einzelhost mit lokalen Bridges (vmbr1000 + Range-Nr.), Cluster mit Proxmox SDN/VXLAN; Adressen 10.<Range>.<VLAN>.<Host> |
| **L3** | Packer für Templates, Ansible für Konfiguration, eine YAML-Datei pro Range, CLI und API |
| **L4** | Rollen für GOAD, SCCM-Labore, Elastic, Wazuh; beliebige Ansible-Galaxy-Rollen |

Tabelle 112: Steckbrief Ludus

**Lehre:** Für 1–2 Maschinen ist Ludus der schnellste Weg zu reproduzierbaren Ranges, und sein Konfigurationsschema ist ein gutes Vorbild für eigene Definitionen.

## CyRIS / CyTrONE (JAIST, Japan)

**CyRIS** (Cyber Range Instantiation System) erzeugt Ranges aus einer YAML-Beschreibung auf KVM in drei Phasen: Basis-VM vorbereiten, Inhalte installieren (Benutzer, Dienste, Angriffsspuren), Gast-VMs klonen. **CyTrONE** ist das übergeordnete Trainingsframework (Inhalte, Fragen, LMS-Anbindung) und delegiert den Range-Bau an CyRIS. **Lehre:** klare Trennung zwischen Trainingslogik (L4/L6) und Range-Instanziierung (L3).

## Splunk Attack Range, GOAD und DetectionLab

- **Splunk Attack Range:** Labor des Splunk Threat Research Teams für Detection Engineering: Windows-DC, Server, Workstation, Kali und Splunk-Server; Bereitstellung per Terraform (Cloud) bzw. lokal; Angriffe über Atomic Red Team und Caldera (Port 8888); Telemetrie landet in Splunk. Wird in CI/CD-Pipelines genutzt, um Detektionen automatisch zu testen.
- **GOAD (Game of Active Directory, Orange Cyberdefense):** verwundbares AD-Labor, 5 VMs / 2 Forests / 3 Domänen (GOAD-Light: 3 VMs / 1 Forest / 2 Domänen); Provider u. a. VirtualBox, VMware, Proxmox, Azure, AWS, Ludus; Bau mit Packer/Terraform/Vagrant + Ansible; nutzt Windows-Evaluierungslizenzen.
- **DetectionLab:** früher verbreitetes Packer/Vagrant/Terraform-Labor mit Splunk, osquery, Zeek, Suricata – seit 01.01.2023 ohne Pflege; als Ideengeber weiterhin lesenswert.
## Vergleich

| **Projekt** | **Basis** | **Skalierung** | **Einstieg** | **Stärke** | **Status 2026** |
|---|---|---|---|---|---|
| **Locked Shields / CR14** | Eigene Großinfrastruktur | > 4.000 VMs | – (nicht verfügbar) | Realismus, Klon-Teams, SINET | Jährlich aktiv |
| **KYPO / CyberRangeCZ** | OpenStack + Kubernetes | Hoch | Hoch | Lernplattform, Sandboxen aus Git | Nachfolger aktiv |
| **Crucible + GHOSTS** | Terraform → vSphere/Proxmox/Cloud | Hoch | Mittel-hoch | Übungssteuerung, NPCs | Aktiv |
| **Ludus** | Proxmox + Packer + Ansible | Mittel (Cluster) | Niedrig | Schnell, YAML, viele Rollen | Aktiv |
| **CyRIS / CyTrONE** | KVM, YAML | Mittel | Mittel | Trainingslogik | Forschungsprojekt |
| **Splunk Attack Range** | Terraform, Cloud/lokal | Niedrig-mittel | Niedrig | Detection Engineering | Aktiv |
| **GOAD** | Packer/Terraform + Ansible | Klein | Niedrig | Realistisches AD | Aktiv |
| **Eigenbau (dieses Projekt)** | Proxmox + OPNsense + IaC | Klein → mittel | Mittel | Volle Kontrolle, Lerneffekt | – |

Tabelle 113: Vergleich realer Ansätze

## Lessons Learned

1. **Alles als Code** – manuelle Klicks sind nicht reproduzierbar.
1. **Klon-Prinzip** – ein sauberes Template-Netz, N identische Kopien.
1. **Simuliertes Internet** früh einplanen – es verbindet alle Szenarien.
1. **NPC-Verkehr** erhöht Realismus und Trainingswert messbar.
1. **RAM ist der Engpass** – Ludus kalkuliert 32 GB pro Range, KYPO lite 48 GB für den Kern.
1. **Telemetrie von Anfang an** – nachträglich eingebaute Sensoren verfälschen Szenarien.
1. **Lizenzlaufzeiten** der Windows-Evaluierungen einplanen.
1. **Projekte altern** – auf aktiv gepflegte Komponenten und offene Standards setzen.
## Weitere Übungen, Plattformen und Projekte

Neben den ausführlich beschriebenen Projekten gibt es zahlreiche weitere Ranges und Übungsformate, aus denen sich lernen lässt. Die Auswahl zeigt die Bandbreite von internationalen Großübungen bis zu Bildungsplattformen.

| **Name** | **Betreiber / Herkunft** | **Format** | **Was man daraus lernen kann** |
|---|---|---|---|
| **Cyber Europe** | ENISA (EU), seit 2010 alle zwei Jahre | Europaweite Krisenübung mit technischen und organisatorischen Anteilen | Zusammenspiel von Technik, Management und Behördenmeldungen |
| **Cyber Coalition** | NATO, seit 2008 jährlich | Verteidigungsübung mit Schwerpunkt Zusammenarbeit und Informationsaustausch | Lageaustausch zwischen Organisationen |
| **Crossed Swords** | NATO CCDCOE | Technische Red-Team-Übung | Ausbildung von Angreifern, Zusammenspiel Cyber und kinetische Effekte |
| **Virginia Cyber Range** | Virginia Tech (USA), seit 2016 | Cloud-basierte Kurs-Umgebungen für Schulen und Hochschulen | Skalierbare Bildungs-Ranges mit fertigen Kursmodulen |
| **EU-Pilotprojekte (z. B. ECHO, CONCORDIA, SPARTA, CyberSec4Europe)** | EU-Forschungsförderung, ca. 2019–2022 | Föderierte Cyber Ranges, Übungsbibliotheken | Föderation mehrerer Ranges, gemeinsame Szenario-Formate |
| **Hack The Box, TryHackMe, RangeForce** | kommerzielle Lernplattformen | Browser-Labs, CTFs, Team-Übungen | Gamification, kurze Lerneinheiten, automatische Prüfung |

Tabelle 114: Weitere Übungen und Plattformen (Auswahl)

## Wissenschaftliche Literatur als Fundament

Die Architektur dieses Dokuments stützt sich neben Herstellerdokumentationen auf Übersichtsarbeiten aus der Forschung. Sie lohnen sich als vertiefende Lektüre, weil sie Dutzende Ranges systematisch vergleichen:

| **Arbeit** | **Kernaussage** |
|---|---|
| **Yamin, Katt, Gkioulos (2020): »Cyber ranges and security testbeds: Scenarios, functions, tools and architecture«, Computers & Security 88** | Systematische Auswertung von rund 100 Arbeiten; Taxonomie aus Szenario, Funktionen (Management, Monitoring, Teaming, Scoring) und Werkzeugen – Grundlage des Schichtenmodells in diesem Dokument |
| **Ukwandu et al. (2020): »A Review of Cyber-Ranges and Test-Beds: Current and Future Trends«, Sensors 20(24)** | Einteilung nach Einsatzgebiet (Militär, Bildung, Industrie, Forschung) und Trends wie Cloud-Ranges und IoT/OT |
| **Chouliaras et al. (2021): »Cyber Ranges and TestBeds for Education, Training, and Research«, Applied Sciences 11(4)** | Vergleich von Ranges für Lehre; Bedeutung von Szenario-Bibliotheken und Bewertung |
| **Vykopal et al. (2017): »KYPO Cyber Range: Design and Use Cases«, ICSOFT** | Architektur von KYPO: Sandboxes, Isolation, Monitoring – Vorbild für Kapitel 27 |
| **Davis, Magrath (2013): »A Survey of Cyber Ranges and Testbeds«, DSTO (Australien)** | Frühe Einteilung in Simulation, Emulation und Overlay |

Tabelle 115: Übersichtsarbeiten zu Cyber Ranges
