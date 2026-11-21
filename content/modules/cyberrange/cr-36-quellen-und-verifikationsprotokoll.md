---
id: cr-36
title: Quellen und Verifikationsprotokoll
paths: cyberrange
order: 36
difficulty: hard
icon: doc.text.magnifyingglass
summary: Kapitel 36 deiner Cyber-Range-Dokumentation: Quellen und Verifikationsprotokoll.
source: Cyber_Range_Dokumentation.docx
htb: 
---

## Vorgehen der Prüfung (zweistufig)

1. **Erster Durchgang (beim Schreiben):** Jede technische Aussage wurde gegen Herstellerdokumentation, Standards (IEEE 802.1Q, RFC 791/768/9293/7348/7432/5424) oder Fachliteratur abgeglichen.
1. **Zweiter Durchgang (gezielt):** Aussagen mit hohem Fehlerrisiko – Ports, Mindestanforderungen, Versionen, Projektstatus – wurden mit einer zweiten, unabhängigen Quelle geprüft. Korrigiert bzw. präzisiert wurden: (a) Security Onion 2.4 ist seit 01.10.2026 am Lebensende → Empfehlung Version 3; (b) Wazuh 5.x nutzt für neue Agenten Port 1517 und ist noch nicht allgemein freigegeben → Empfehlung 4.14.x; (c) Security-Onion-Agent-Ports und Ludus-Adressschema wurden in einer zweiten Quelle bestätigt.
1. **Dritter Durchgang (Überarbeitung):** Bei der Erweiterung dieses Dokuments wurden neu hinzugekommene Angaben (Guacamole-OIDC-Variablen, Keycloak-Bootstrap-Variablen, Proxmox-Rechte, Ablaufdiagramme) erneut gegen die Herstellerdokumentation geprüft; Angaben, die von Versionen abhängen, sind im Text als »laut Doku prüfen« gekennzeichnet.
| **Aussage** | **Prüfung 1** | **Prüfung 2** | **Status** |
|---|---|---|---|
| **Proxmox-Ports 8006, 3128, 22, Corosync UDP 5405–5412, Migration 60000–60050** | Proxmox Wiki »Ports« | pve-devel-Patch zur Portliste | ✔ |
| **Proxmox VE 9.0 (08/2025), 9.1 (11/2025), SDN-Fabrics, EVPN/VXLAN-Zonen** | Proxmox-Pressemitteilungen | heise, ServeTheHome, Forum | ✔ |
| **nftables-Firewall in PVE 9 nur Technology Preview** | Proxmox Wiki »Firewall« | Proxmox-Forum (Staff-Aussage) | ✔ |
| **VXLAN UDP 4789, VNI 24 Bit, 8-Byte-Header, 50 Byte Overhead** | RFC 7348 | Proxmox SDN-Kapitel (MTU-Hinweis) | ✔ |
| **802.1Q: TPID 0x8100, PCP 3 / DEI 1 / VID 12 Bit** | IEEE 802.1Q | Fachliteratur | ✔ |
| **Wazuh 4.x: 1514/1515/55000, Indexer 9200; 5.x: 1517** | Wazuh-Doku 4.14 | Wazuh-Doku 5.0-RC | ✔ (5.0 = RC) |
| **Security Onion 3 Standalone min. 24 GB RAM, 4 Kerne, 200 GB** | SO-Doku Version 3 | SO-Doku 2.4 | ✔ |
| **Security Onion 2.4 EOL 01.10.2026** | Drittquelle mit Zitat der Doku | SO-Releasehinweise | ✔ |
| **Security-Onion-Agent-Ports 5055 / 8220 / 8443** | SO-Doku 2.4 »Firewall« | SO-Doku 3 »Firewall« | ✔ |
| **GHOSTS-API Port 5000, Grafana 3000** | GHOSTS-Quickstart | GHOSTS-Doku API/Grafana | ✔ |
| **Caldera Standardport 8888, Sandcat, /beacon** | Caldera-Doku 5.x | MITRE-Emulationspläne | ✔ |
| **KYPO: OpenStack + K8s/Helm, Sandboxen aus Git, KYPO lite 48 GB; Nachfolger CyberRangeCZ** | KYPO-Doku | KYPO-Webseite | ✔ |
| **Ludus: Proxmox + Packer + Ansible, 32 GB/Range, Adressschema 10.<Range>.<VLAN>.<Host>** | Ludus-Doku »Intro«, »Networking« | Ludus-Doku »Configuration« | ✔ |
| **Locked Shields: CCDCOE, CR14 (2011), > 4.000 VMs, Teamfarben** | army.mil / EUCOM | Al Jazeera, BAE Systems | ✔ (VM-Zahl je Jahr verschieden) |
| **GOAD: 5 VMs / 2 Forests / 3 Domänen; Light 3/1/2** | GOAD-Repository | Ludus-Doku GOAD | ✔ |
| **DetectionLab seit 01.01.2023 ohne Pflege** | Repository-Hinweis | Drittquellen | ✔ |
| **Packer-HTTP-Server Standardbereich 8000–9000** | Packer-Doku | vSphere-Builder-Doku | ✔ |
| **Guacamole: guacd TCP 4822; OIDC-Variablen OPENID_*** | Guacamole-Handbuch | Docker-Image-Doku | ✔ |
| **Guacamole-OIDC nutzt den Implicit Flow (response_type id_token)** | Guacamole-Handbuch (OpenID-Erweiterung) | Apache-Jira (Issue zur response_type) | ✔ |
| **Proxmox VE 9: Paketquellen im deb822-Format (*.sources), Suite »trixie«** | Proxmox-Forum (Upgrade-Threads) | Anleitungen Dritter | ✔ |
| **Keycloak ≥ 26: KC_BOOTSTRAP_ADMIN_USERNAME / _PASSWORD** | Keycloak-Doku (Getting Started Docker) | Red-Hat-Build-of-Keycloak-Doku | ✔ |
| **pveum: »acl modify / --users … --roles …«, »user token add … --privsep 0«** | Proxmox-Doku »User Management« | pveum-Manpage | ✔ |
| **Budgetzahlen** | – | – | ◐ bewusst nur Struktur |

Tabelle 189: Verifikationsprotokoll (✔ = in zwei Quellen bestätigt, ◐ = vor Umsetzung erneut prüfen)

## Quellen

- NIST: »The Cyber Range: A Guide« (2023); NIST NICE: »Cyber Ranges«
- ECSO: Cyber Range Features Checklist / Definitionen
- Yamin, Katt, Gkioulos: »Cyber ranges and security testbeds: Scenarios, functions, tools and architecture«, Computers & Security 88 (2020)
- Davis, Magrath: »A Survey of Cyber Ranges and Testbeds«, DSTO-GD-0771 (2013)
- KYPO CRP Dokumentation – docs.crp.kypo.muni.cz; crp.kypo.muni.cz (Status/CyberRangeCZ)
- Ludus Dokumentation – docs.ludus.cloud (Intro, Networking, Configuration, GOAD); github.com/badsectorlabs/ludus
- CMU SEI: Crucible – cmu-sei.github.io/crucible; GHOSTS – cmu-sei.github.io/GHOSTS; CMU/SEI-2018-TR-005 »GHOSTS in the Machine«
- CyRIS – github.com/cyb3rlab/CyRIS; Beuran et al., IEICE Trans. Inf. & Syst. E101-D(3), 2018
- Splunk Attack Range – github.com/splunk/attack_range; Splunk-Blog
- GOAD – github.com/Orange-Cyberdefense/GOAD
- Proxmox VE Admin Guide (Ports, Firewall, SDN, pveum), Wiki »Ports«, Pressemitteilungen 9.0/9.1
- Wazuh Dokumentation – documentation.wazuh.com (Architecture, Installation 4.14, 5.0-RC)
- Security Onion Dokumentation – docs.securityonion.net (Version 3 Hardware/Firewall, 2.4)
- Apache Guacamole Manual (OpenID Connect, Docker); Keycloak Server Guide
- MITRE Caldera – caldera.readthedocs.io; MITRE ATT&CK – attack.mitre.org; Sigma – sigmahq.io
- Locked Shields / CR14 – army.mil, eucom.mil, aljazeera.com, baesystems.com, ccdcoe.org
- Standards: IEEE 802.1Q; RFC 791, 768, 9293, 7348, 7432, 8365, 5424, 7011, 8446 (TLS 1.3)
- NIST SP 800-84; NIST SP 800-181 Rev. 1 (NICE Framework)
## Vierte Prüfrunde (Version 3.0)

Für die erweiterte Fassung wurden alle neu aufgenommenen, zeitabhängigen Angaben erneut gegen Primär- oder Herstellerquellen geprüft. Angaben, die sich nicht eindeutig bestätigen ließen, wurden vorsichtig formuliert oder weggelassen.

| **Angabe** | **Ergebnis der Prüfung** | **Status** |
|---|---|---|
| **Locked Shields 2025: über 4.000 Beteiligte, 41 Nationen, 17 Blue Teams** | laut NATO CCDCOE bestätigt | ✔ |
| **MITRE ATT&CK v18 (Okt. 2025): Detection Strategies und Analytics, Data Sources abgekündigt, Objektzahlen** | laut offiziellen Release Notes bestätigt | ✔ |
| **Proxmox VE 9.1 (19.11.2025): OCI-Images, vCPU-Flag für Nested Virtualization, vTPM in qcow2, Debian 13.2, Kernel 6.17** | laut Hersteller und Forum bestätigt; Name des vCPU-Flags bewusst nicht genannt | ✔ |
| **Proxmox Backup Server 4.0 (Aug. 2025): Debian 13, S3-Datastores als Technologievorschau** | laut Pressemitteilung und Mailingliste bestätigt | ✔ |
| **Apache Guacamole 1.6.0 (Juni 2025): AUDIT-Berechtigung, Rendering-Optimierungen** | laut Release Notes bestätigt | ✔ |
| **MITRE Caldera v5 »Magma«, Weboberfläche Port 8888** | laut Projekt bestätigt | ✔ |
| **NICE Framework Components v2.0.0 (März 2025), neue OT-Rolle** | laut NIST bestätigt; spätere Minor-Versionen vor Nutzung prüfen | ✔ |
| **ENISA ECSF: 12 Rollenprofile** | laut ENISA bestätigt | ✔ |
| **NIS2UmsuCG in Kraft seit 06.12.2025** | laut mehreren übereinstimmenden Fachquellen bestätigt | ✔ |
| **KYPO-Topologie: Gültigkeitsregeln (eindeutige Namen, keine Überlappung, Adressen im Netz)** | laut KYPO-Dokumentation bestätigt; Schema-Version beachten | ✔ |
| **Leistungswerte (IOPS, Durchsatz, Overcommit-Kurve)** | Größenordnungen bzw. schematisch – vor Ort messen (Kapitel 28) | ◐ |

Tabelle 190: Ergebnisse der vierten Prüfrunde

## Zusätzliche Quellen der Version 3.0

- NATO CCDCOE: Locked Shields 2025 – ccdcoe.org/news/2025/locked-shields-2025-showcased-nations-commitment-to-defending-cyberspace/
- MITRE ATT&CK: Updates – October 2025 (v18) – attack.mitre.org/resources/updates/updates-october-2025/
- Proxmox: What's new in Proxmox VE 9.1 – proxmox.com; Forum-Ankündigung »Proxmox Virtual Environment 9.1 available«
- Proxmox: Pressemitteilung Proxmox Backup Server 4.0 – proxmox.com/en/about/company-details/press-releases/proxmox-backup-server-4-0
- Apache Guacamole 1.6.0 Release Notes – guacamole.apache.org/releases/1.6.0/
- MITRE Caldera – github.com/mitre/caldera; Ankündigung Caldera v5 »Magma«
- NIST: NICE Framework Components v2.0.0 – Summary of Changes (März 2025) – nist.gov
- ENISA: European Cybersecurity Skills Framework (ECSF) – enisa.europa.eu/topics/cybersecurity-education/european-cybersecurity-skills-framework
- KYPO CRP Dokumentation: Topology Definition – docs.crp.kypo.muni.cz/user-guide-advanced/sandboxes/topology-definition
- GRFICS – Formby et al., USENIX ASE 2018; github.com/djformby/GRFICS
- Yamin, Katt, Gkioulos (2020), Computers & Security 88; Ukwandu et al. (2020), Sensors 20(24); Chouliaras et al. (2021), Applied Sciences 11(4)
- NIS2-Umsetzungs- und Cybersicherheitsstärkungsgesetz, BGBl. 2025 I Nr. 301
## Fünfte Prüfrunde (Version 4.0)

Die in Version 4.0 ergänzten Angaben wurden gegen Standards und Herstellerdokumentation geprüft. Neue zeitabhängige Produktangaben wurden vermieden; wo die Syntax von Werkzeugversionen abhängt, ist das im Text vermerkt.

| **Angabe** | **Ergebnis der Prüfung** | **Status** |
|---|---|---|
| **Dokumentations-Adressbereiche 198.51.100.0/24 und 203.0.113.0/24** | RFC 5737 – für Dokumentation reserviert | ✔ |
| **Syslog-Formate RFC 3164 / RFC 5424, TLS-Transport Port 6514** | RFC 5424, RFC 5425 | ✔ |
| **NTP-Laufzeit- und Abweichungsformel (vier Zeitstempel)** | RFC 5905 | ✔ |
| **Kerberos-Toleranz für Uhrabweichung 5 Minuten (Standard im AD)** | Microsoft-Dokumentation (Kerberos-Richtlinie) | ✔ |
| **TCP-SYN-Aufbau, Optionen MSS/SACK/Zeitstempel/Window Scale** | RFC 9293, RFC 7323, RFC 2018 | ✔ |
| **cloud-init-Phasen (local, network, config, final), Datenquelle NoCloud** | cloud-init-Dokumentation | ✔ |
| **Proxmox SDN: VXLAN-Zonen, VNets mit Tag (VNI), MTU-Überhang 50 Byte** | Proxmox-Admin-Handbuch (SDN) | ✔ |
| **Guacamole-REST-API (Token, Verbindungen je Datenquelle)** | Guacamole-Quellcode und -Dokumentation | ✔ |
| **Packer-Proxmox-Plugin: Blockstruktur je Version unterschiedlich** | Plugin-Dokumentation – im Text als Prinzip gekennzeichnet | ◐ |
| **Datenvolumen- und Kapazitätsrechnungen** | Rechenbeispiele mit offengelegten Annahmen – vor Ort messen | ◐ |

Tabelle 191: Ergebnisse der fünften Prüfrunde
