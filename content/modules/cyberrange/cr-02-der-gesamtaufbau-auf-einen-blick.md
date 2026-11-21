---
id: cr-02
title: Der Gesamtaufbau auf einen Blick
paths: cyberrange
order: 2
difficulty: easy
icon: square.3.layers.3d
summary: Kapitel 2 deiner Cyber-Range-Dokumentation: Der Gesamtaufbau auf einen Blick.
source: Cyber_Range_Dokumentation.docx
htb: Cyber Range 02 · Architektur: Ebenen & Schichten
---

## Überblick

Bevor die einzelnen Schichten im Detail beschrieben werden, zeigt dieses Kapitel das große Bild: alle Komponenten, wie sie gruppiert sind und welche Verbindungen zwischen ihnen bestehen. Die folgende Abbildung ist die **Landkarte** für das gesamte Dokument – jede spätere Abbildung zoomt in einen Ausschnitt davon hinein.

![Abbildung 1: Gesamtaufbau der Cyber Range mit allen Komponenten und Verbindungen](asset:cyberrange/cr-02-001.png)

**So liest man die Abbildung:**

- **Oben** stehen die Menschen: Red Team (Angreifer), Blue Team (Verteidiger), White Team (Übungsleitung) und Green Team (Betrieb). Teilnehmer gelangen **ausschließlich** über die Zugangsschicht L6 in die Range – nie direkt.
- **Der orange Kasten (Data Plane)** ist das eigentliche Übungsgelände: getrennte Netzsegmente (Zonen) für Angreifer, öffentlich erreichbare Server, das interne Firmennetz, das simulierte Internet, die Analysten und die simulierten Benutzer. Alle Zonen sind nur über die virtuelle Firewall **OPNsense** miteinander verbunden.
- **Der türkise Kasten (Observation Plane)** beobachtet: Er erhält eine Kopie des gesamten Netzwerkverkehrs (gelber Pfeil) und die Meldungen der Agenten (türkiser Pfeil), wertet sie aus und bewertet die Teams.
- **Der untere Kasten (Control Plane)** baut und steuert alles: Aus dem Git-Repository erzeugen Packer, OpenTofu und Ansible über die Proxmox-API die gesamte Range. Diese Ebene ist für Teilnehmer unerreichbar.
- **Ganz unten** liegt die Hardware: zwei physische Rechner.
## Die drei Ebenen (Planes)

Das wichtigste Architekturprinzip einer Cyber Range ist die strikte Trennung in **drei Ebenen**, die man aus der Netzwerktechnik kennt. Diese Trennung garantiert gleichzeitig Sicherheit (Teilnehmer können die Infrastruktur nicht angreifen) und Messbarkeit (die Beobachtung ist für Angreifer unsichtbar und unverfälschbar).

![Abbildung 2: Die drei Ebenen einer Cyber Range](asset:cyberrange/cr-02-002.png)

| **Ebene** | **Aufgabe** | **Netz** | **Wer hat Zugriff?** | **Regel** |
|---|---|---|---|---|
| **Control Plane (Steuerung)** | Hypervisor-API, Automatisierung, Snapshots, Backups, Fernwartung | MGMT 10.0.0.0/24, IPMI-Netz | Nur Green Team | Für Teilnehmer und VMs niemals erreichbar |
| **Data Plane (Übung)** | Alle Übungssysteme, Angriffe, Benutzerverkehr, Dienste | VLAN 10–90 auf vmbr1, SINET | Red, Blue, NPCs (je nach Zone) | Kein Ausgang ins reale Netz, Default Deny |
| **Observation Plane (Beobachtung)** | Mitschnitt, Telemetrie, Logs, Scoring | Sniff-Link ohne IP, SVC 10.99.0.0/24 | White Team, Blue Team (lesend) | Daten fließen nur zur Auswertung hin |

Tabelle 5: Die drei Ebenen im Vergleich

## Die sieben Schichten (L0 – L6)

Quer zu den drei Ebenen lässt sich eine Cyber Range in **sieben Schichten** zerlegen, ähnlich dem OSI-Modell der Netzwerktechnik. Jede Schicht nutzt die Dienste der Schicht darunter und bietet der Schicht darüber eine klar definierte Schnittstelle. Das Modell ist eine eigene Synthese aus veröffentlichten Architekturen (KYPO, Crucible, Ludus, CyRIS, NIST-Leitfaden, Yamin et al.); einen genormten Standard gibt es nicht.

![Abbildung 3: Referenz-Schichtenmodell L0 – L6 mit Querschnittsfunktionen](asset:cyberrange/cr-02-003.png)

| **Schicht** | **Name** | **Kernfrage** | **Hauptsoftware in diesem Projekt** | **Kapitel** |
|---|---|---|---|---|
| **L0** | Physische Infrastruktur | Worauf läuft alles? | 2 Server, NVMe, NICs, Switch, USV | 3 |
| **L1** | Virtualisierung & Compute | Wie entstehen virtuelle Rechner? | Proxmox VE (KVM/QEMU), ZFS | 4 |
| **L2** | Netzvirtualisierung | Wie werden sie vernetzt und getrennt? | Linux-Bridge, VLAN, OPNsense, Proxmox SDN | 5 |
| **L3** | Orchestrierung | Wie wird alles automatisch gebaut? | Gitea, Packer, OpenTofu, Ansible | 6 |
| **L4** | Szenario & Inhalte | Was wird geübt? | Windows/AD, Linux-Dienste, Kali, GHOSTS, Caldera | 7 |
| **L5** | Monitoring & Scoring | Was passiert gerade, wie gut sind die Teams? | Security Onion, Wazuh, Sysmon, Grafana | 8 |
| **L6** | Zugang & Portal | Wie kommen Menschen hinein? | Keycloak, Guacamole, CTFd, WireGuard | 9 |

Tabelle 6: Die sieben Schichten im Überblick

## Physische Sicht: Was steht im Raum?

Physisch besteht der Pilot aus nur wenigen Geräten. Entscheidend ist, dass die drei Ebenen auch **physisch** getrennt sind: Die Verwaltung läuft über einen Switch, die Telemetrie und der Spiegelverkehr über zwei direkte Kabel zwischen den Maschinen. Das Übungsnetz selbst hat überhaupt **kein** physisches Kabel – es existiert nur virtuell in Maschine A.

![Abbildung 4: Physische Verkabelung des 2-Maschinen-Setups](asset:cyberrange/cr-02-004.png)

## Ein Durchlauf durch die Range – die Komponenten im Zusammenspiel

Um zu verstehen, wie die Teile zusammenarbeiten, hilft ein gedanklicher Durchlauf durch einen Übungstag:

1. **Vorbereitung (Green Team):** Ein Administrator ändert im Git-Repository die Beschreibung der Range (z. B. ein zusätzlicher Webserver). Die CI/CD-Pipeline startet: Packer baut bei Bedarf neue Golden Images, OpenTofu legt über die Proxmox-API die VMs als Linked Clones an, Ansible konfiguriert Active Directory, Dienste, absichtliche Schwachstellen und Agenten. Automatische Tests prüfen Isolation und Telemetrie; danach wird ein Snapshot »clean« gesetzt.
1. **Start (White Team):** Die Übungsleitung gibt die Range frei (»STARTEX«) und schaltet die Zugänge der Teams frei.
1. **Anmeldung (alle Teams):** Teilnehmer öffnen im Browser das Portal, melden sich bei Keycloak mit Passwort und TOTP an und erhalten über Guacamole Bildschirmzugriff auf genau die VMs ihres Teams.
1. **Angriff (Red Team):** Von Kali-VMs aus wird nach Drehbuch angegriffen – z. B. eine Phishing-Mail über den Mailserver im simulierten Internet.
1. **Hintergrund (NPCs):** Simulierte Benutzer (GHOSTS) surfen, schreiben Mails und öffnen Dokumente – auch den präparierten Anhang.
1. **Beobachtung (automatisch):** Jedes Paket zwischen den Zonen wird gespiegelt und von Zeek und Suricata ausgewertet; Sysmon und Wazuh melden Prozessstarts und Anmeldungen.
1. **Verteidigung (Blue Team):** Analysten sehen Alarme im SIEM, untersuchen, isolieren betroffene Systeme und berichten an das White Team.
1. **Bewertung (White Team):** Die Scoring-Engine prüft minütlich, ob die Dienste der Blue Teams verfügbar sind; Erkennungen und Berichte werden bewertet.
1. **Ende und Reset:** Nach »ENDEX« werden Logs gesichert, die Range per Snapshot zurückgesetzt, und die Nachbesprechung (AAR) rekonstruiert anhand der Telemetrie den Zeitstrahl.
## Komponentenliste des Pilotprojekts

| **Komponente** | **Schicht** | **Läuft auf** | **Funktion in einem Satz** |
|---|---|---|---|
| **Proxmox VE 9.x** | L1 | A + B (bare metal) | Hypervisor: stellt VMs, Netze, Snapshots und die API bereit |
| **ZFS-Mirror** | L1 | A | Ausfallsicherer Speicher mit schnellen Snapshots und Klonen |
| **OPNsense »rtr-01«** | L2 | A (VM) | Router und Firewall zwischen allen Übungszonen |
| **Kali Linux** | L4 | A (VM) | Werkzeugkasten des Red Teams |
| **Windows Server (DC01, FS01)** | L4 | A (VM) | Active Directory, DNS, Dateiserver des fiktiven Unternehmens |
| **Windows 11 (WS01–03)** | L4 | A (VM) | Arbeitsplätze der simulierten Mitarbeiter |
| **Ubuntu-Server (web01, mail01)** | L4 | A (VM) | Webshop und Mailserver in der DMZ |
| **SINET-Server** | L4 | A (VM) | Simuliertes Internet: DNS, Webseiten, Mail, Zertifikate |
| **GHOSTS** | L4 | A (VM + Clients) | Simulierte Benutzer für realistischen Hintergrundverkehr |
| **Security Onion 3** | L5 | B (VM) | Netzwerküberwachung: Zeek, Suricata, Paketmitschnitt, Analyse |
| **Wazuh** | L5 | B (VM) | Host-Überwachung über Agenten, Regeln, Alarme |
| **Scoring / CTFd / Grafana** | L5/L6 | B (VM) | Bewertung, Aufgaben, Lagebild |
| **Keycloak + Guacamole** | L6 | B (VM) | Anmeldung mit 2FA und Remote-Desktop im Browser |
| **Gitea + OpenTofu + Ansible + Packer** | L3 | B (VM) | Range als Code: Bauen, Ändern, Zurücksetzen |

Tabelle 7: Komponenten des Pilotprojekts

## Alle Datenflüsse der Range in einer Tabelle

Eine Architektur ist erst dann vollständig beschrieben, wenn jeder Datenfluss bekannt ist: **wer** spricht **mit wem**, **worüber**, **in welche Richtung** und **warum**. Die folgende Tabelle ist die Grundlage für das Firewall-Regelwerk (Kapitel 5), die Härtung (Kapitel 10) und das Bedrohungsmodell (Kapitel 30). Jeder Fluss, der hier nicht steht, ist verboten.

| **Nr.** | **Quelle → Ziel** | **Protokoll / Port** | **Zweck** | **Ebene** |
|---|---|---|---|---|
| **F1** | Admin-PC → range-01 / ops-01 | HTTPS 8006, SSH 22 (über WireGuard) | Verwaltung der Hypervisoren | Control |
| **F2** | iac-01 → range-01 | HTTPS 8006 (API-Token) | VMs anlegen, klonen, Snapshots | Control |
| **F3** | iac-01 → Übungs-VMs | SSH 22, WinRM 5986 (über SVC) | Konfiguration mit Ansible | Control → Data |
| **F4** | Teilnehmer-Browser → access-01 | HTTPS 443 | Portal, Guacamole, CTFd | Zugang |
| **F5** | access-01 (guacd) → Übungs-VMs | RDP 3389, SSH 22, VNC 5900 | Remote-Desktop der Teilnehmer | Zugang → Data |
| **F6** | Übungs-VMs (Agent) → wazuh-01 | 1514/tcp, 1515/tcp | Host-Telemetrie, Registrierung | Data → Observation |
| **F7** | OPNsense → so-01 / wazuh-01 | Syslog 514/udp+tcp | Firewall- und DNS-Logs | Data → Observation |
| **F8** | range-01 (Mirror) → so-01 (Sniff) | Layer-2-Kopie, keine IP | Netzwerk-Mitschnitt | Data → Observation |
| **F9** | score-01 → Übungs-Dienste | HTTP/SMTP/DNS/SMB (Checks) | Verfügbarkeitsprüfung für Scoring | Observation → Data |
| **F10** | GHOSTS-Clients → ghosts-api | HTTP 5000 (im NPC-VLAN) | Timelines abholen, Aktivität melden | Data |
| **F11** | Alle Hosts → NTP-Quelle (OPNsense) | NTP 123/udp | Gemeinsame Zeitbasis | alle |
| **F12** | Übungs-VMs ↔ Übungs-VMs | laut Szenario-Matrix | Das eigentliche Übungsgeschehen | Data |

Tabelle 8: Datenflüsse der Pilot-Range (Whitelist)

> [!GEFAHR] Die drei verbotenen Richtungen
> **Data → Control:** Keine Übungs-VM darf die Proxmox-API, das IPMI-Netz oder iac-01 erreichen.
> **Data → reales Netz:** Kein Paket verlässt das Übungsnetz Richtung Büro oder Internet.
> **Observation → Data (schreibend):** Sensoren senden nichts ins Übungsnetz; nur der Scoring-Dienst darf lesend prüfen (F9).

## Architekturentscheidungen und ihre Begründung

Jede größere Technologieentscheidung wird in Form eines **Architecture Decision Record (ADR)** festgehalten: Kontext, betrachtete Alternativen, Entscheidung und Konsequenzen. So kann später jeder nachvollziehen, warum etwas so gebaut wurde – und erkennen, wann eine Entscheidung neu getroffen werden sollte.

### ADR-01: Hypervisor

| **Kriterium** | **Proxmox VE** | **VMware vSphere/ESXi** | **OpenStack** | **Hyper-V** |
|---|---|---|---|---|
| **Lizenz / Kosten** | AGPLv3, optionale Subskription | kommerziell, seit 2024 nur noch Abo-Modelle | Apache 2.0 | in Windows Server enthalten |
| **Einstiegsaufwand** | gering (ISO, Web-GUI) | mittel | hoch (viele Dienste) | mittel |
| **API / IaC** | REST-API, Terraform-Provider bpg/proxmox | sehr gut | sehr gut (Heat, Terraform) | PowerShell, eingeschränkt |
| **Netz-Virtualisierung** | Linux-Bridge, SDN mit VXLAN/EVPN | vDS, NSX (teuer) | Neutron (sehr flexibel) | Hyper-V-Switch |
| **Mandantenfähigkeit** | Pools, Rechte, SDN-Zonen | gut | sehr gut (Projekte) | gering |
| **Eignung Pilot** | **sehr gut** | gut, aber Lizenzkosten | überdimensioniert | mäßig |

Tabelle 9: Vergleich der Hypervisoren

**Entscheidung:** Proxmox VE. **Konsequenz:** Ab etwa 20 Hosts oder mehreren hundert gleichzeitigen Teilnehmern wird OpenStack (wie bei KYPO) erneut geprüft.

### ADR-02: Firewall / Router im Übungsnetz

| **Kriterium** | **OPNsense** | **pfSense CE** | **VyOS** | **nftables auf Linux** |
|---|---|---|---|---|
| **Weboberfläche** | ja, modern | ja | nein (CLI) | nein |
| **API für Automatisierung** | REST-API, Ansible-Collection | eingeschränkt | sehr gut (CLI/API) | über Ansible-Templates |
| **Realismus für Teilnehmer** | hoch (typische Unternehmensfirewall) | hoch | mittel (Provider-Router) | gering |
| **Rolle in der Range** | **zentrale Firewall** | Alternative | **SINET-Backbone-Router** | Host-Firewall |

Tabelle 10: Vergleich der Router/Firewalls

### ADR-03: Monitoring-Plattform

| **Kriterium** | **Security Onion + Wazuh** | **Elastic Stack selbst gebaut** | **Splunk** | **Graylog** |
|---|---|---|---|---|
| **Netzwerk-Sensorik integriert** | ja (Zeek, Suricata, PCAP) | nein, selbst bauen | über Apps | nein |
| **Host-Telemetrie** | Wazuh, Elastic Agent | Elastic Agent | Universal Forwarder | Sidecar |
| **Kosten** | Open Source | Open Source / Lizenz | nach Datenvolumen | Open Source / Lizenz |
| **Lernwert für Blue Teams** | hoch (realistischer SOC) | hoch | hoch (Marktstandard) | mittel |

Tabelle 11: Vergleich der Monitoring-Plattformen

> [!TIPP] Regel für alle ADRs
> Eine Entscheidung wird nur dann revidiert, wenn sich eine Annahme aus dem Kontext nachweislich geändert hat (z. B. Teilnehmerzahl verdreifacht, Lizenzmodell geändert) – nicht wegen eines neuen Trends.

## Namens- und Nummernschema

In einer Range mit Dutzenden VMs, mehreren Teams und häufigen Neuaufbauten entsteht ohne feste Regeln schnell Chaos: Welche VM gehört zu welchem Team? Welche Nummer hat der Domänencontroller von Team 3? Ein durchgängiges Schema macht Namen und Nummern **vorhersagbar** – für Menschen und für Skripte.

| **Bereich der VMID** | **Verwendung** | **Beispiele** |
|---|---|---|
| **100** | Firewall/Router der Range | rtr-01 |
| **101–109** | RED-Zone (Angreifer-Systeme) | kali01 = 101, kali02 = 102, c2-01 = 105 |
| **110–119** | SINET (simuliertes Internet) | inet-dns = 110, inet-web = 111, inet-mail = 112 |
| **120–129** | DMZ | web01 = 120, mail01 = 121 |
| **130–139** | CORP-Server | dc01 = 130, fs01 = 131, dc02 = 132 |
| **140–169** | CORP-Clients | ws01 = 141, ws02 = 142 … |
| **170–179** | BLUE-SOC | soc01 = 170 |
| **180–199** | NPC-Systeme (GHOSTS) | ghosts-api = 180, npc01 = 181 … |
| **200–299** | Betriebs-VMs auf ops-01 | iac-01 = 201, wazuh-01 = 202, so-01 = 203, access-01 = 204, score-01 = 205 |
| **9001–9099** | Templates | 9001 Ubuntu, 9002 Windows Server, 9003 Windows 11, 9004 Kali |
| **n·1000 + Rest** | weitere Teams ab Stufe 3 | Team 2: rtr = 2100, dc01 = 2130; Team 3: dc01 = 3130 |

Tabelle 12: Schema der VMIDs

| **Element** | **Regel** | **Beispiel** |
|---|---|---|
| **Hostname** | Funktion + laufende Nummer, klein, ohne Teamangabe (alle Teams sehen identische Namen) | dc01, ws07, web01 |
| **VM-Name in Proxmox** | Team + Zone + Hostname, damit die Admin-Oberfläche eindeutig ist | t1-corp-dc01, t2-dmz-web01 |
| **Tags in Proxmox** | Team, Zone, Rolle, Szenario-Version | team1, corp, dc, nordlicht-v3 |
| **Proxmox-Pool** | ein Pool je Team bzw. Sandbox | team1, sbx-017 |
| **DNS intern** | Hostname + AD-Domäne | dc01.nordwind.lab |
| **Git-Branch** | Art/Thema | feature/sinet-pki, fix/opnsense-dmz-rule |

Tabelle 13: Namensregeln

> [!TIPP] Warum Teams identische Hostnamen bekommen
> Alle Blue Teams sollen **dieselbe** Firma verteidigen. Würde der Domänencontroller bei Team 2 »dc01-t2« heißen, wären Musterlösung, Sigma-Regeln und Berichte für jedes Team anders. Die Unterscheidung erfolgt deshalb nur dort, wo Teilnehmer sie nicht sehen: in VMID, VM-Name, Tags und Pool.

## Was bei STARTEX in der Range passiert – Schritt für Schritt

Die Architektur wird besonders verständlich, wenn man verfolgt, was in den ersten Minuten einer Übung tatsächlich passiert. Die folgende Erzählung verbindet die Bausteine aus diesem Kapitel zu einem Ablauf.

1. **T−60 Minuten:** Die Pipeline hat am Vorabend alle VMs aus den Templates geklont, Ansible hat sie konfiguriert, und jede VM besitzt einen Snapshot »clean«. Das Green Team prüft die Pre-Flight-Checkliste (Kapitel 34.1), der Egress-Test meldet »alles gesperrt«.
1. **T−30 Minuten:** Die Startreihenfolge läuft: zuerst Firewall und SINET, dann Domänencontroller, dann Server, zuletzt Clients und NPCs. Die Wazuh-Agenten melden sich nacheinander beim Manager; Security Onion zeigt den ersten Netzverkehr.
1. **T−10 Minuten:** Die GHOSTS-Clients holen ihre Timelines ab. Erste Anmeldungen der simulierten Mitarbeitenden erzeugen Kerberos-Verkehr, Mails werden abgerufen, Webseiten im SINET aufgerufen – das Grundrauschen beginnt.
1. **T−5 Minuten:** Das Green Team schaltet die Guacamole-Verbindungen der Teams frei. Die Scoring-Engine startet ihre Checks; alle Dienste sind grün.
1. **T±0 (STARTEX):** Der Exercise Director gibt die Übung frei. Die Teilnehmer melden sich über Keycloak an (Passwort + Einmalcode) und sehen im Portal nur die Verbindungen ihres Teams.
1. **T+5 Minuten:** Ein Blue-Team-Mitglied öffnet per Browser eine RDP-Sitzung zum Domänencontroller. Der Datenstrom läuft Browser → Guacamole (HTTPS) → guacd → SVC-Netz → OPNsense → VLAN 30 → dc01. Jede Sitzung wird aufgezeichnet.
1. **T+20 Minuten:** Das Red Team beginnt gemäß Drehbuch. Jede seiner Aktionen erzeugt Telemetrie: Pakete werden gespiegelt (Security Onion), Ereignisse auf den Hosts protokolliert (Wazuh). Ob das Blue Team sie bemerkt, entscheidet über Punkte und Lernerfolg.
