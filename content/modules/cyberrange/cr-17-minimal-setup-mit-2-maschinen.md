---
id: cr-17
title: Minimal-Setup mit 2 Maschinen
paths: cyberrange
order: 17
difficulty: medium
icon: desktopcomputer
summary: Kapitel 17 deiner Cyber-Range-Dokumentation: Minimal-Setup mit 2 Maschinen.
source: Cyber_Range_Dokumentation.docx
htb: 
---

## Überblick

Die zentrale Frage: **Funktioniert eine echte Cyber Range mit nur zwei physischen Rechnern?** Ja – sofern die drei Ebenen auch physisch sauber getrennt werden und die RAM-Ausstattung stimmt. Dieses Kapitel beschreibt die Zielarchitektur des Pilotprojekts im Detail.

![Abbildung 51: Zielarchitektur mit 2 physischen Maschinen](asset:cyberrange/cr-17-051.png)

**So liest man die Abbildung:**

- **Links (Maschine A):** Alle Übungs-VMs hängen an der VLAN-aware Bridge `vmbr1`, die weder einen physischen Port noch eine IP-Adresse hat. Nur OPNsense verbindet die VLANs.
- **Gelber Pfad:** Der Verkehr am Router-Trunk wird gespiegelt und über ein eigenes Kabel an die Sniff-Netzwerkkarte von Maschine B gesendet – eine Einbahnstraße ohne IP-Adressen.
- **Rechts (Maschine B):** Monitoring, Zugang, Scoring und Automatisierung als VMs. Sie erreichen die Range ausschließlich über das Transfernetz (VLAN 99) und die Regeln der OPNsense.
- **Unten:** Das Management-Netz verbindet nur die Hypervisoren und den Admin-Zugang.
## Designentscheidung: Rollentrennung statt 2-Knoten-Cluster

Naheliegend wäre, beide Rechner zu einem Proxmox-Cluster zu verbinden. Davon wird abgeraten: Ein Corosync-Cluster braucht für Hochverfügbarkeit ein **Quorum**; mit zwei Knoten führt der Ausfall eines Knotens zum Quorumverlust – Proxmox empfiehlt dafür ein externes **QDevice** (corosync-qnetd) als dritte Stimme. Für eine Cyber Range bringt Hochverfügbarkeit wenig, erhöht aber die Komplexität.

| **Variante** | **Beschreibung** | **Bewertung** |
|---|---|---|
| **A: Rollentrennung (empfohlen)** | range-01 = alle Übungs-VMs; ops-01 = Monitoring, Zugang, Scoring, IaC; zwei unabhängige Proxmox-Installationen | ✔ Klare Trennung der Ebenen, Sensor unabhängig vom beobachteten System, einfach |
| **B: 2-Knoten-Cluster + QDevice** | Beide Knoten hosten Übungs-VMs; QDevice z. B. auf Raspberry Pi | ◐ Mehr Range-Kapazität, aber Monitoring teilt Ressourcen mit der Übung |
| **C: Arbeitsplatz + Range-Host** | Maschine 2 ist nur Angreifer-PC (Kali auf Hardware) | ✘ Kein unabhängiges Monitoring, physische Verbindung in die Range |

Tabelle 116: Varianten für 2 Maschinen

## Ressourcenplanung der VMs

| **VM** | **Host** | **OS** | **vCPU** | **RAM (GB)** | **Disk (GB)** | **Netz** |
|---|---|---|---|---|---|---|
| **rtr-01** | A | OPNsense | 2 | 4 | 32 | Trunk vmbr1 + vmbr2 (SVC) |
| **kali01, kali02** | A | Kali Linux | 4 + 4 | 8 + 8 | 80 + 80 | VLAN 10 |
| **c2-01 / redirector** | A | Ubuntu 24.04 | 2 | 2 | 32 | VLAN 10 / 40 |
| **web01, mail01** | A | Ubuntu 24.04 | 2 + 2 | 2 + 2 | 32 + 32 | VLAN 20 |
| **dc01** | A | Windows Server 2022/2025 | 4 | 6 | 80 | VLAN 30 |
| **fs01** | A | Windows Server | 2 | 4 | 80 | VLAN 30 |
| **ws01-ws03** | A | Windows 11 Enterprise | 3 × 2 | 3 × 4 | 3 × 64 | VLAN 30 |
| **inet-svc** | A | Debian 13 | 2 | 4 | 40 | VLAN 40 |
| **soc01, soc02** | A | Ubuntu Desktop / Windows | 2 × 4 | 2 × 8 | 2 × 64 | VLAN 50 |
| **ghosts-api** | A | Ubuntu + Docker | 2 | 4 | 40 | VLAN 90 |
| **Summe A** |  |  | **≈ 40** | **≈ 82** | **≈ 1.000** | + Host-Reserve 8 GB + ZFS-ARC 8–16 GB |
| **so-01** | B | Security Onion 3 | 8 | 32 | 500 + PCAP | vmbr2 + vmbr3 (Sniff) |
| **wazuh-01** | B | Wazuh All-in-One | 4 | 8 | 200 | vmbr2 |
| **access-01** | B | Guacamole + Keycloak | 2 | 4 | 40 | vmbr2 + vmbr0 |
| **score-01** | B | CTFd + Scoring + Grafana | 2 | 4 | 40 | vmbr2 |
| **iac-01** | B | Gitea + OpenTofu + Ansible + Packer | 2 | 4 | 80 | vmbr0 + vmbr2 |
| **Summe B** |  |  | **≈ 18** | **≈ 52** | **≈ 900 + PCAP** | + Host-Reserve 8 GB |

Tabelle 117: Ressourcenplanung (vCPU dürfen überbucht werden, RAM nicht)

> [!TIPP] Warum 128 GB auf Maschine A?
> Ein vollständiges Szenario benötigt ≈ 82 GB. Mit 128 GB bleibt Platz für einen **zweiten Klon** des CORP-/DMZ-Netzes (zweites Blue Team) über Linked Clones und KSM, oder für größere Szenarien wie GOAD mit 5 Windows-VMs.

## Netzwerkkonfiguration der Hypervisoren

**Netzwerkkonfiguration range-01**

```
# /etc/network/interfaces auf range-01 (Maschine A)
auto lo
iface lo inet loopback

iface eno1 inet manual
iface enp2s0 inet manual

auto vmbr0                      # MGMT – nur Hypervisor-Verwaltung
iface vmbr0 inet static
    address 10.0.0.11/24
    gateway 10.0.0.1
    bridge-ports eno1
    bridge-stp off
    bridge-fd 0

auto vmbr1                      # RANGE – VLAN-aware, OHNE physischen Port, OHNE IP
iface vmbr1 inet manual
    bridge-ports none
    bridge-stp off
    bridge-fd 0
    bridge-vlan-aware yes
    bridge-vids 2-4094

auto vmbr2                      # SVC/TRANSFER – Direktkabel zu ops-01, Host ohne IP
iface vmbr2 inet manual
    bridge-ports enp2s0
    bridge-stp off
    bridge-fd 0

auto enp3s0                     # MIRROR-OUT – Direktkabel zur Sniff-NIC von ops-01
iface enp3s0 inet manual
    mtu 9000
```

**Netzwerkkonfiguration ops-01**

```
# /etc/network/interfaces auf ops-01 (Maschine B) – Auszug
auto vmbr2                      # SVC/TRANSFER (Wazuh, SO, Guacamole, IaC hängen hier)
iface vmbr2 inet manual
    bridge-ports enp2s0
    bridge-stp off
    bridge-fd 0

auto vmbr3                      # SNIFF – reine Empfangsbridge für Security Onion
iface vmbr3 inet manual
    bridge-ports enp3s0
    bridge-stp off
    bridge-fd 0
    bridge-ageing 0             # Hub-Verhalten: alles an die Sensor-VM weiterreichen
    mtu 9000
    post-up ethtool -K enp3s0 gro off lro off tso off gso off
```

Die OPNsense-VM erhält zwei virtuelle NICs: **net0** an `vmbr1` als Trunk (die VLANs 10/20/30/40/50/90 werden in OPNsense als VLAN-Interfaces angelegt) und **net1** an `vmbr2` (SVC, 10.99.0.1). Die Security-Onion-VM auf ops-01 erhält **net0** an `vmbr2` (Management, 10.99.0.11) und **net1** an `vmbr3` (Sniff-Interface ohne IP; VLAN-Tags bleiben erhalten).

## Spiegelung per Hookscript

tc-Filter hängen am tap-Interface, das Proxmox bei jedem VM-Start neu erzeugt. Deshalb wird die Spiegelung über ein Proxmox-Hookscript in der Phase `post-start` gesetzt:

**Hookscript für die SPAN-Spiegelung**

```
#!/bin/bash
# /var/lib/vz/snippets/mirror.sh – an die Router-VM (VMID 100) hängen:
#   qm set 100 --hookscript local:snippets/mirror.sh
vmid="$1"; phase="$2"
SRC="tap${vmid}i0"     # Trunk-NIC der Router-VM (sieht alle VLANs, mit Tag)
DST="enp3s0"           # physische Mirror-NIC -> ops-01
if [ "$phase" = "post-start" ]; then
  tc qdisc add dev "$SRC" clsact 2>/dev/null
  tc filter add dev "$SRC" ingress matchall action mirred egress mirror dev "$DST"
  tc filter add dev "$SRC" egress  matchall action mirred egress mirror dev "$DST"
fi
exit 0
```

> [!WARNUNG] Grenzen dieser Abgriffstelle
> Am Router-Trunk wird **jeder geroutete** Verkehr gesehen (zwischen Zonen, ins SINET). Verkehr **innerhalb** eines VLANs (z. B. ws01 → dc01 in VLAN 30) läuft nicht über den Router. Für vollständige Sicht zusätzlich die tap-Interfaces wichtiger VMs (dc01, fs01) spiegeln; Host-Telemetrie (Sysmon/Wazuh) schließt die Lücke ebenfalls.

## Telemetrie und Zugang über das Transfernetz

- Alle Agenten senden über ihr Default-Gateway (OPNsense) ins Transfernetz 10.99.0.0/24; OPNsense erlaubt nur die Agent-Ports zu den Collector-IPs.
- Guacamole (10.99.0.20) erreicht die Ziel-VMs nur auf RDP/SSH; Teilnehmer erreichen Guacamole per HTTPS mit Keycloak-Anmeldung.
- Ansible (10.99.0.30) erhält nur während des Build-Fensters Zugriff (Regel per OPNsense-Zeitplan oder API aktivieren/deaktivieren).
- Der Hypervisor range-01 hat auf `vmbr2` **keine** IP – er ist aus dem Transfernetz nicht erreichbar.
## Variante: nur eine Maschine

Eine Cyber Range funktioniert auch auf **einem** Rechner (64–128 GB RAM): Alle Rollen laufen als VMs auf einem Proxmox-Host, die Spiegelung erfolgt intern per tc-mirred auf das tap-Interface der Security-Onion-VM. Nachteile: Monitoring und Übung konkurrieren um Ressourcen, ein Ausfall betrifft alles, und die Trennung der Ebenen ist nur logisch. Für Lernzwecke und Szenario-Entwicklung genügt das; Ludus und GOAD sind genau für diesen Fall gebaut.

## Erlaubte Verbindungen zwischen den Maschinen

Die beiden Maschinen sind über drei Wege verbunden: das Management-Netz (vmbr0), das Transfernetz (vmbr2) und die einseitige Mirror-Leitung. Für jeden Weg ist genau festgelegt, welche Verbindungen erlaubt sind.

![Abbildung 52: Erlaubte Verbindungen zwischen range-01 und ops-01](asset:cyberrange/cr-17-052.png)

**So liest man die Abbildung:**

- **Telemetrie** (türkis) fließt nur von range-01 zu ops-01: Syslog der Firewall und die Wazuh-Agenten der VMs.
- **Steuerung** (dunkelblau) geht von ops-01 zur Proxmox-API – aber über das Management-Netz, nicht über das Transfernetz, damit kein Pfad aus dem Übungsnetz zur API entsteht.
- Die **Mirror-Leitung** (gelb) ist rein passiv: Auf beiden Seiten hat die Schnittstelle keine IP-Adresse.
- **Konsolenzugriffe** (lila) gehen von guacd auf ops-01 zu den VMs – nur aus dem SVC-Netz und nur auf die freigegebenen Ports.
## Firewall auf den Proxmox-Hosts

Zusätzlich zu OPNsense schützt die eingebaute Proxmox-Firewall die Hypervisoren selbst. Sie wird auf Rechenzentrums-Ebene in `/etc/pve/firewall/cluster.fw` konfiguriert und gilt dann für alle Knoten.

**/etc/pve/firewall/cluster.fw**

```
[OPTIONS]
enable: 1
policy_in: DROP
policy_out: ACCEPT

[IPSET management]          # Admin-Jump, iac-01 und der jeweils andere Host
10.0.0.11
10.0.0.12
10.0.0.20
10.0.0.30

[RULES]
IN ACCEPT -source +management -p tcp -dport 8006 -log nolog   # Web-GUI und API
IN SSH(ACCEPT) -source +management                             # SSH (Makro)
IN ACCEPT -source +management -p icmp
# Alles andere wird durch policy_in: DROP verworfen
```

> [!WARNUNG] Vor dem Aktivieren testen
> Eine falsche Firewall-Regel kann den eigenen Zugang aussperren. Deshalb vor `enable: 1` eine zweite SSH-Sitzung offen halten und den Zugriff über den BMC (Konsole) sicherstellen. Proxmox lässt Zugriffe aus dem lokalen Cluster-Netz standardmäßig zu, solange die Regel für die Web-GUI fehlt – darauf sollte man sich aber nicht verlassen.

## Startreihenfolge und Abhängigkeiten

Nach einem Stromausfall oder Neustart müssen die VMs in der richtigen Reihenfolge starten: Ohne Firewall kein Netz, ohne Domänencontroller keine Anmeldung, ohne Monitoring keine Telemetrie. Proxmox kennt dafür die Option `startup` mit Reihenfolge und Wartezeit.

| **Reihenfolge** | **Maschine** | **VMs** | **Wartezeit danach** |
|---|---|---|---|
| **1** | ops-01 | iac-01 (Gitea, lokaler Paketspiegel) | 30 s |
| **2** | ops-01 | wazuh-01, so-01 | 120 s (Indexer braucht Zeit) |
| **3** | range-01 | rtr-01 (OPNsense) | 60 s |
| **4** | range-01 | SINET (Root-DNS, Mail, Web) | 30 s |
| **5** | range-01 | dc01, dc02 | 120 s |
| **6** | range-01 | Server (fs01, web01, mail01) | 60 s |
| **7** | range-01 | Clients, NPCs, Red-VMs | – |
| **8** | ops-01 | access-01, score-01 | – |

Tabelle 118: Startreihenfolge der Range

**Startreihenfolge per Befehl setzen**

```
qm set 100 --onboot 1 --startup order=3,up=60     # rtr-01
qm set 130 --onboot 1 --startup order=5,up=120    # dc01
qm set 141 --onboot 0                             # Clients: nur zu Übungen starten
```

## Was passiert, wenn eine Maschine ausfällt?

| **Ausfall** | **Auswirkung** | **Sofortmaßnahme** | **Vorbeugung** |
|---|---|---|---|
| **ops-01** | Kein Monitoring, kein Teilnehmerzugang, kein Scoring; Übungsnetz läuft weiter | Übung pausieren (STOPP), Zeit im Scoring einfrieren | Backup der ops-01-VMs, Wiederherstellung auf range-01 vorbereitet |
| **range-01** | Gesamte Übung steht | ENDEX oder Verschiebung | Templates und Git-Repo gesichert; Neuaufbau in < 90 Minuten |
| **Mirror-Leitung** | Security Onion ohne Netzdaten; Host-Telemetrie läuft weiter | Teams informieren, Bewertung anpassen | Ersatzkabel, Monitoring der Sensor-Paketrate |
| **Stromausfall** | beide Maschinen | USV fährt geordnet herunter | USV-Software (NUT) auf beiden Hosts |

Tabelle 119: Ausfallszenarien im 2-Maschinen-Setup

## Inbetriebnahme Tag für Tag

Die Bauanleitung (Kapitel 18) beschreibt **was** zu tun ist. Der folgende Plan zeigt, **in welcher Reihenfolge** ein erfahrenes Zwei-Personen-Team die Pilot-Range in drei Arbeitswochen in Betrieb nimmt. Die Meilensteine entsprechen dem Projektplan (Kapitel 33).

![Abbildung 53: Inbetriebnahme der Pilot-Range in 15 Arbeitstagen](asset:cyberrange/cr-17-053.png)

**So liest man die Abbildung:**

- Jeder Balken ist ein **Arbeitspaket**; überlappende Balken werden parallel von zwei Personen bearbeitet.
- Die **roten Linien** sind Meilensteine: Isolation nachgewiesen (Tag 5), Range per Code aufbaubar (Tag 9), Telemetrie vollständig (Tag 13), Go-Entscheidung (Tag 15).
- Die Templates (Packer) laufen parallel zum SINET-Aufbau, weil der Windows-Bau viel Wartezeit enthält.
| **Tag** | **Person A (Infrastruktur)** | **Person B (Dienste/Detection)** | **Ergebnis am Abend** |
|---|---|---|---|
| **1** | Hardware aufbauen, UEFI, Proxmox auf range-01 | Proxmox auf ops-01, Git-Repository anlegen | beide Hosts erreichbar |
| **2** | Härtung, 2FA, API-Token, Firewall der Hosts | iac-01 (Gitea, OpenTofu, Ansible, Packer) | sichere Verwaltung |
| **3** | Bridges, Direktkabel, OPNsense installieren | PBS einrichten, erste Sicherung | Grundnetz steht |
| **4** | VLANs, Regeln, DHCP, DNS | Paketspiegel befüllen (apt, Windows-Updates) | Zonen getrennt |
| **5** | Egress- und Isolationstest | Packer: Ubuntu-Template | **M2: Isolation** |
| **6** | SINET: DNS-Hierarchie | Packer: Windows-Server-Template | Namensauflösung im SINET |
| **7** | SINET: Web, Mail, PKI | Packer: Windows-11-Template | Kulissen online |
| **8** | OpenTofu-Module | Packer: Kali-Template, Template-Tests | Templates fertig |
| **9** | Range per `tofu apply` | Ansible: Basis-Rollen | **M3: Code** |
| **10** | Ansible: AD, Benutzer, GPOs | Security Onion installieren, Mirror | Domäne läuft |
| **11** | Ansible: Dienste DMZ, Schwachstellen | Wazuh, Agenten-Rolle, Sysmon | Szenario-Systeme |
| **12** | GHOSTS, Personas | Audit-Richtlinien, erste Regeln | Grundrauschen |
| **13** | Keycloak, Guacamole | Dashboards, Telemetrie-Test je Phase | **M4: Telemetrie** |
| **14** | CTFd, Scoring-Checks | Caldera-Operation, Musterlösung prüfen | Übung spielbar |
| **15** | Abnahmeprotokoll, Lasttest | Dry-Run mit Testteam | **M7: Go / No-Go** |

Tabelle 120: Tagesplan der Inbetriebnahme
