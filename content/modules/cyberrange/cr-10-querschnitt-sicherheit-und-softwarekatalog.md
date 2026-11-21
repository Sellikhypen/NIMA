---
id: cr-10
title: Querschnitt: Sicherheit und Softwarekatalog
paths: cyberrange
order: 10
difficulty: medium
icon: lock.shield
summary: Kapitel 10 deiner Cyber-Range-Dokumentation: Querschnitt: Sicherheit und Softwarekatalog.
source: Cyber_Range_Dokumentation.docx
htb: Cyber Range 13 · Sicherheit & Recht
---

## Sicherheit der Range selbst

Eine Cyber Range enthält absichtlich Angreifer, Angriffswerkzeuge und unter Umständen echte Schadsoftware. Sie muss daher selbst besonders gut geschützt sein – nach außen (nichts darf entkommen) und nach innen (Teilnehmer dürfen die Infrastruktur nicht übernehmen).

| **Bedrohung** | **Beispiel** | **Schutzmaßnahme** |
|---|---|---|
| **Ausbruch ins reale Netz** | Wurm verbreitet sich über eine falsche Route | Bridge ohne Uplink, Default Deny, Egress-Tests vor jeder Übung |
| **Angriff auf die Steuerung** | Teilnehmer scannt die Proxmox-API | MGMT aus der Range unerreichbar, Proxmox-Firewall, 2FA |
| **VM-Ausbruch (VM Escape)** | Exploit in QEMU | Updates, keine Container für Angreifer, minimale Gastfunktionen |
| **Manipulation der Bewertung** | Red Team stört Scoring-Checks | Checks aus SVC-Netz, RoE, Monitoring der Checks |
| **Diebstahl von Geheimnissen** | API-Token im Git-Repository | Ansible Vault / OpenBao, Tokens mit minimalen Rechten |
| **Datenschutzverletzung** | Echte Personendaten im Szenario | Nur synthetische Identitäten, Löschkonzept für Teilnehmerdaten |

Tabelle 63: Bedrohungen und Schutzmaßnahmen

## Softwarekatalog nach Schichten

| **Schicht** | **Software (Empfehlung fett)** | **Zweck** | **Lizenz** | **Alternativen** |
|---|---|---|---|---|
| **L1** | **Proxmox VE 9.x** | Hypervisor (KVM/QEMU, LXC), Cluster, API, Snapshots | OSS (AGPLv3), optionales Abo | VMware vSphere, XCP-ng, OpenStack, Hyper-V |
| **L1** | **Proxmox Backup Server** | Inkrementelle, deduplizierte Backups | OSS | Veeam, restic |
| **L2** | **Linux-Bridge + Proxmox SDN** | VLAN, VXLAN, EVPN, IPAM | OSS | Open vSwitch |
| **L2** | **OPNsense** | Router, Firewall, DNS, DHCP, VPN | OSS (BSD) | pfSense CE, VyOS, nftables |
| **L3** | **Packer** | Template-Bau aus ISO | BSL 1.1 | virt-builder |
| **L3** | **OpenTofu** bzw. Terraform | Infrastructure as Code | MPL 2.0 / BSL 1.1 | Pulumi |
| **L3** | **Ansible** | Konfigurationsmanagement | OSS (GPLv3) | Salt, PowerShell DSC |
| **L3** | **Gitea** | Git-Server + CI | OSS (MIT) | GitLab CE, Forgejo |
| **L3** | Ludus (optional) | Range-Orchestrator auf Proxmox | OSS (AGPLv3) | KYPO/CyberRangeCZ, Crucible |
| **L4** | **Windows Server 2022/2025 Eval** | AD DS, DNS, File, IIS | Eval 180 Tage | Samba AD |
| **L4** | **Windows 11 Enterprise Eval** | Clients | Eval 90 Tage | – |
| **L4** | **Ubuntu 24.04 LTS / Debian 13** | Linux-Server | OSS | Rocky, Alma |
| **L4** | **Kali Linux** | Angreifer-Arbeitsplatz | OSS | Parrot OS |
| **L4** | **GHOSTS** | NPC-Simulation | OSS | eigene Skripte |
| **L4** | **Caldera**, **Atomic Red Team** | Angreifer-Emulation | Apache 2.0 / MIT | Infection Monkey |
| **L4** | INetSim, step-ca, BIND | SINET-Dienste | OSS | FakeNet-NG, CoreDNS |
| **L4** | GOAD | Fertige AD-Labore | OSS | eigene Rollen |
| **L5** | **Security Onion 3** | NSM + SIEM | OSS (Teile Elastic License) | Arkime + Zeek + Suricata |
| **L5** | **Wazuh 4.14.x** | HIDS/XDR | OSS (GPLv2) | Elastic Defend, Velociraptor |
| **L5** | **Sysmon** | Windows-Telemetrie | Freeware | – |
| **L5** | Grafana + Prometheus | Lagebild, Range-Health | AGPLv3 / Apache 2.0 | Zabbix |
| **L6** | **Apache Guacamole** | Browser-Zugang, Aufzeichnung | Apache 2.0 | Kasm Workspaces |
| **L6** | **Keycloak** | IAM, SSO | Apache 2.0 | Authentik |
| **L6** | **CTFd** | Aufgaben, Scoreboard | Apache 2.0 | eigene Engine |
| **L6** | WireGuard | Admin-VPN | GPLv2 | OpenVPN |

Tabelle 64: Softwarekatalog nach Schichten (Stand November 2026)

> [!WARNUNG] Versions- und Statushinweise (Stand November 2026)
> **Security Onion 2.4** ist seit 01.10.2026 am Lebensende → nur **Security Onion 3** installieren.
> **Wazuh 5.0** ist laut Herstellerkanälen im Release-Candidate-Stadium; ein direktes Upgrade von 4.x wird laut Beta-Doku nicht unterstützt. Für den Pilot die stabile **4.14.x-Linie** verwenden.
> **KYPO CRP** wird nicht mehr aktiv entwickelt; Nachfolger ist die kompatible **CyberRangeCZ Platform**.
> **DetectionLab** ist seit 01.01.2023 ohne Pflege; **cisagov/Ludus** ist archiviert – aktiv ist die Version von **Bad Sector Labs**.
> **Windows-Evaluierungen** laufen ab (Server 180, Client 90 Tage) → Templates regelmäßig neu bauen oder lizenzieren.

## Härtung je Komponente

Die Range selbst ist ein attraktives Ziel: Teilnehmer sind per Definition Angreifer, und die Infrastruktur enthält Werkzeuge und Zugangsdaten. Die folgende Tabelle fasst die Mindesthärtung je Komponente zusammen (Hardening).

| **Komponente** | **Mindestmaßnahmen** |
|---|---|
| **Proxmox VE (beide Hosts)** | 2FA für alle Konten, root@pam nur Notfall; API-Token mit minimalen Rechten; Web-GUI nur aus MGMT/VPN; regelmäßige Updates außerhalb von Übungen; Host-Firewall aktiv |
| **BMC / IPMI** | eigenes Netz ohne Routing, Standardpasswörter ändern, Firmware aktuell, nicht benötigte Dienste (z. B. IPMI over LAN) aus |
| **OPNsense** | Admin-GUI nur auf SVC/MGMT, nie auf Übungs-VLANs; Konfigurations-Backups in Git; Logging an SIEM |
| **iac-01 (Gitea, Tofu, Ansible)** | kein Zugriff aus dem Übungsnetz; Secrets verschlüsselt; Branch-Schutz für main; Runner nur mit Zugriff auf benötigte Ziele |
| **access-01 (Keycloak, Guacamole)** | nur 443 nach außen, TLS mit gültigem Zertifikat, MFA verpflichtend, Brute-Force-Erkennung in Keycloak aktiv, Zwischenablage-Regeln |
| **so-01 / wazuh-01** | Weboberflächen nur aus SVC/BLUE-SOC; Indexer nicht von Übungs-VMs erreichbar; getrennte Konten je Team |
| **Übungs-VMs** | **absichtlich verwundbar** – aber ohne Weg in Control Plane; keine echten Zugangsdaten; Gast-Agent für Notfallzugriff |

Tabelle 65: Mindesthärtung der Range-Komponenten

## Versionsmatrix und Update-Strategie

Versionsstände ändern sich schnell. Die folgende Matrix hält den geprüften Stand dieses Dokuments fest; vor jeder Installation sind die Herstellerseiten erneut zu prüfen.

| **Software** | **Geprüfter Stand (Nov. 2026)** | **Update-Rhythmus der Range** | **Hinweis** |
|---|---|---|---|
| **Proxmox VE** | 9.x (9.1 seit Nov. 2025) | vor jeder Übungsserie, nie während | Debian 13 »Trixie« |
| **Proxmox Backup Server** | 4.x | quartalsweise | Debian 13, S3-Datastores als Technologievorschau |
| **OPNsense** | aktuelle Halbjahresversion | monatlich (Minor), halbjährlich (Major) | Konfiguration vorher sichern |
| **Security Onion** | 3.x (2.4 nur noch Wartung) | laut Projekt-Release | Sensor-Neuaufbau einplanen |
| **Wazuh** | 4.14.x (5.0 angekündigt) | Minor sofort, Major nach Test | 5.x nutzt teils andere Ports |
| **Keycloak** | ≥ 26 | quartalsweise | Bootstrap-Variablen KC_BOOTSTRAP_ADMIN_* |
| **Apache Guacamole** | 1.6.0 | bei Sicherheitsupdates sofort | AUDIT-Berechtigung neu |
| **MITRE Caldera** | 5.x | nach Bedarf | Weboberfläche »Magma« (Vue.js) |
| **MITRE ATT&CK** | v18 (Okt. 2025) | halbjährlich (Frühjahr/Herbst) | Detection Strategies statt Data Sources |

Tabelle 66: Versionsmatrix der wichtigsten Komponenten

> [!TIPP] Die »Golden-Image-Regel«
> Übungs-VMs werden nicht gepatcht, sondern **neu gebaut**: Packer erzeugt in regelmäßigen Abständen neue Templates mit aktuellen Updates. Absichtlich veraltete Software (für Schwachstellen) wird dabei gezielt gepinnt und dokumentiert.

## Lizenzen der eingesetzten Software

Alle Kernkomponenten sind quelloffen, aber nicht alle Lizenzen sind gleich. Für den internen Betrieb einer Range sind sie unproblematisch; wer die Range jedoch als Dienst für Dritte anbieten oder Komponenten verändert weitergeben möchte, muss die Bedingungen kennen.

| **Lizenz** | **Software (Beispiele)** | **Was zu beachten ist** |
|---|---|---|
| **AGPLv3** | Proxmox VE, Proxmox Backup Server | Wer veränderten Code als Netzdienst anbietet, muss den Quellcode bereitstellen |
| **GPLv2 / GPLv3** | Wazuh, Suricata, Linux, Security Onion (Teile) | Weitergabe veränderter Programme nur mit Quellcode |
| **BSD-2-Clause** | OPNsense, FreeBSD-Basis | sehr freizügig, Copyright-Hinweis erhalten |
| **Apache 2.0** | Keycloak, Guacamole, Caldera, Kubernetes | freizügig, Patentklausel, Hinweisdatei mitliefern |
| **MPL 2.0** | OpenTofu | Änderungen an Dateien unter MPL offenlegen |
| **Elastic License 2.0 / SSPL / AGPL** | Elasticsearch (je nach Version wählbar) | Einschränkungen beim Angebot als Managed Service |
| **Evaluierungslizenzen** | Windows Server / Windows 11 (180 bzw. 90 Tage) | nur für Test/Evaluation; für Dauerbetrieb Volumen- oder Bildungslizenzen klären |

Tabelle 67: Lizenzübersicht (keine Rechtsberatung)

## Das Betriebshandbuch

Neben dieser Dokumentation braucht der Betrieb ein kurzes, praktisches **Betriebshandbuch** im Git-Repository. Es enthält keine Erklärungen, sondern nur, was im Alltag gebraucht wird. Jeder Eintrag folgt demselben Aufbau, damit auch neue Mitglieder des Green Teams sofort zurechtkommen.

| **Kapitel des Handbuchs** | **Inhalt** |
|---|---|
| **Kontakte und Zuständigkeiten** | Wer ist für welche Komponente zuständig, Vertretung, Notfallkontakte |
| **Zugänge** | Wo liegen welche Zugangsdaten (Verweis auf Passwortmanager, nie die Daten selbst) |
| **Runbooks** | Schritt-für-Schritt-Anleitungen: Range aufbauen, zurücksetzen, Agent neu registrieren, Zertifikat erneuern, Team hinzufügen |
| **Störungsbehebung** | Symptom → Ursache → Lösung (wachsende Sammlung, siehe Kapitel 22.2) |
| **Änderungsprotokoll** | Was wurde wann warum geändert (ergänzt die Git-Historie um manuelle Eingriffe) |
| **Übungskalender** | geplante Übungen, Wartungsfenster, Sperrzeiten für Updates |

Tabelle 68: Gliederung des Betriebshandbuchs

**Beispiel eines Runbooks**

```
# Runbook: Wazuh-Agent neu registrieren
Zweck:        Agent erscheint im Dashboard als »disconnected« oder »never connected«
Dauer:        ca. 5 Minuten
Voraussetzung: Zugriff auf wazuh-01 (SVC) und Gast-Agent der betroffenen VM

1. Auf wazuh-01 alte Registrierung entfernen:      /var/ossec/bin/manage_agents -r <ID>
2. In der VM (über qm guest exec oder Konsole) Dienst stoppen
3. Neu registrieren:                               agent-auth -m 10.99.0.10 -G <Gruppe>
4. Dienst starten, nach 1 Minute Status im Dashboard prüfen
5. Eintrag im Änderungsprotokoll: Datum, VM, Ursache (falls bekannt)
Rückfall:     VM aus Snapshot »clean« zurücksetzen (Agent ist dort korrekt registriert)
```

> [!INFO]
> **TEIL B**
> **Logik & Kommunikation**
> Wozu eine Cyber Range dient, nach welcher Logik sie arbeitet und wie ihre Komponenten bis hinunter auf Paketebene miteinander sprechen.
> Kapitel 11: Grundlagen: Definitionen, Typen, Einsatzzwecke
> Kapitel 12: Teams, Rollen und Spielregeln
> Kapitel 13: Die Logik hinter der Range
> Kapitel 14: Kommunikation: Protokolle, Ports und Abläufe
> Kapitel 15: Paketebene: Wie Pakete versendet und angenommen werden
