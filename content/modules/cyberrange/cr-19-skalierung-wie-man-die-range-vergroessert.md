---
id: cr-19
title: Skalierung: Wie man die Range vergrößert
paths: cyberrange
order: 19
difficulty: medium
icon: chart.line.uptrend.xyaxis
summary: Kapitel 19 deiner Cyber-Range-Dokumentation: Skalierung: Wie man die Range vergrößert.
source: Cyber_Range_Dokumentation.docx
htb: 
---

## Überblick

Eine Range wächst selten auf einmal, sondern in Stufen. Jede Stufe bringt neue Anforderungen an Automatisierung, Netzwerk und Telemetrie mit sich.

![Abbildung 54: Stufenmodell der Skalierung](asset:cyberrange/cr-19-054.png)

## Skalierungsdimensionen

| **Dimension** | **Frage** | **Maßnahme** |
|---|---|---|
| **Teams / Mandanten** | Wie viele Gruppen üben parallel? | Klon-Ranges per IaC (count/for_each), eigene SDN-Zonen/VRFs |
| **Szenario-Größe** | Wie viele Systeme pro Team? | Mehr RAM, Linked Clones, KSM, schlanke Server-Images (Core-Installationen) |
| **Realismus** | Wie viel Benutzer- und Internetsimulation? | Mehr GHOSTS-Clients, größeres SINET |
| **Telemetrie** | Wie viele Ereignisse pro Sekunde? | Security Onion verteilt (Manager + Search Nodes + Sensoren), größerer Index-Cluster |
| **Zugriff** | Wie viele gleichzeitige Sitzungen? | Mehrere guacd-Instanzen, Load Balancer |
| **Geografie** | Verteilte Teilnehmer? | Remote-Zugang, ggf. Cloud-Bursting |

Tabelle 124: Skalierungsdimensionen

## Stufenmodell im Detail

| **Stufe** | **Aufbau** | **Kapazität (Richtwert)** | **Technik** |
|---|---|---|---|
| **1 – Einzelplatz** | 1 Host, 64–128 GB | 1 Szenario, 1 Team | Proxmox, Linux-Bridge, alles als VM |
| **2 – Pilot (dieses Projekt)** | 2 Hosts, Rollentrennung | 1–2 Teams, 15–25 VMs | Proxmox ×2, OPNsense, Security Onion, Wazuh |
| **3 – Abteilungs-Range** | 3–5 Hosts Cluster + Ceph + SIEM-Host | 4–10 Teams, 100–300 VMs | Proxmox-Cluster, Ceph, SDN VXLAN/EVPN, Ludus oder eigener Orchestrator |
| **4 – Institution** | Mehrere Racks, Spine-Leaf-Netz | Dutzende Teams, > 1.000 VMs | OpenStack (KYPO/CyberRangeCZ) oder vSphere + Crucible, verteiltes SIEM |
| **4b – Cloud-Bursting** | Lokal + AWS/Azure | Elastisch | Terraform-Module für Cloud, Netze ohne Internet-Gateway, Kostenkontrolle |

Tabelle 125: Stufenmodell

![Abbildung 55: Skalierte Architektur mit Cluster, Ceph und SDN-Overlay](asset:cyberrange/cr-19-055.png)

**So liest man die Abbildung:**

- Jeder Knoten (pve-01 bis pve-04) trägt VMs mehrerer Teams, einen VXLAN-Tunnelendpunkt und Ceph-Speicher.
- Das **Underlay** (dunkler Balken) trennt per VLAN Cluster-Kommunikation, Ceph, Overlay und Migration und läuft mit Jumbo Frames (MTU 9000).
- Ein **Mandant** (Team) entspricht einer eigenen SDN-Zone bzw. VRF – so können alle Teams identische IP-Pläne haben.
## Kapazitätsplanung

**RAM-Bedarf** ≈ (Σ RAM der VMs eines Teams × Anzahl Teams) × (1 − KSM-Ersparnis) + gemeinsame Dienste + Host-Reserve (8 GB je Host) + ZFS-ARC bzw. Ceph-OSD-Speicher (ca. 4–5 GB je OSD). **CPU:** Überbuchung von 3:1 bis 4:1 für Übungs-VMs, keine Überbuchung für Sensoren und SIEM. **Storage:** Linked Clones brauchen anfangs wenige GB pro VM; IOPS sind beim gleichzeitigen Start vieler Windows-VMs der Engpass → NVMe und gestaffelter Start.

**Kapazitätsrechnung (Beispiel)**

```
Beispiel: 6 Teams × 82 GB  = 492 GB
          − 15 % KSM        = 418 GB
          + Gemeinsam (SINET, Red, GHOSTS) 30 GB
          + 4 Hosts × 8 GB Reserve = 32 GB
          + Ceph 4 Hosts × 2 OSD × 5 GB = 40 GB
          = ca. 520 GB RAM  →  4 Hosts à 192 GB (mit Puffer für Wartung eines Knotens)
```

## Mandantenfähigkeit

- **Getrennte Adressräume:** Schema 10.<Team>.<VLAN>.<Host> (einfach, kein Overlap) **oder** identische Adressen pro Team in getrennten EVPN-VRFs (realistischer).
- **Zugriffsrechte:** Proxmox-Pools je Team, Keycloak-Gruppen, Guacamole-Verbindungsgruppen.
- **Telemetrie-Trennung:** Agent-Gruppen bzw. VLAN/VNI im Sensor; Dashboards je Team.
- **Fairness:** Ressourcenlimits je Pool, damit ein Team die anderen nicht ausbremst.
## Weg vom Pilot zum Cluster

1. Dritten Host beschaffen → Proxmox-Cluster mit 3 Stimmen (kein QDevice nötig), Corosync auf eigenem Netz mit zwei Links.
1. Ceph mit 3 Replikaten (size=3, min_size=2) auf eigenem 10/25-GbE-Netz.
1. SDN: VXLAN-Zone (einfach) bzw. EVPN-Zone (VRFs, Anycast-Gateway) definieren; Underlay-MTU 9000.
1. OpenTofu-Module um die Verteilung auf Knoten erweitern; ggf. Ludus-Cluster-Modus nutzen.
1. Security Onion von Standalone auf verteilt umstellen (Manager + Search Nodes + Sensoren je Host).
## Verteilter Speicher mit Ceph

Ab Stufe 3 (drei oder mehr Knoten) lohnt sich Ceph als gemeinsamer Speicher: Jede VM-Disk liegt verteilt und mehrfach auf allen Knoten, VMs können live zwischen Knoten wandern (Live-Migration), und der Ausfall eines Knotens führt nicht zu Datenverlust (HA).

![Abbildung 56: Proxmox-Cluster mit Ceph über drei Knoten](asset:cyberrange/cr-19-056.png)

**So liest man die Abbildung:**

- Auf jedem Knoten laufen ein **MON** (Cluster-Karte, Quorum), ein Manager und mehrere **OSDs** – je ein Dienst pro Datenträger.
- VMs greifen über **RBD** auf ihre Disks zu; die Daten liegen verteilt auf allen OSDs.
- Der Pool hat **size=3, min_size=2**: Jeder Block existiert dreimal auf verschiedenen Knoten. Fällt ein Knoten aus, bleibt der Pool schreibbar.
- Unten die drei Netze: **Public** (Zugriff der Clients), **Cluster** (Replikation) und **Corosync** (Cluster-Kommunikation von Proxmox, latenzkritisch).
| **Dienst** | **Port(s)** | **Bemerkung** |
|---|---|---|
| **Ceph MON** | 3300/tcp (msgr2), 6789/tcp (msgr1) | mindestens 3 Monitore für ein Quorum |
| **Ceph OSD / MGR / MDS** | 6800–7300/tcp | Bereich für Daemon-Kommunikation |
| **Corosync (Proxmox-Cluster)** | 5405–5412/udp | eigenes, redundantes Netz empfohlen |
| **Live-Migration** | 60000–60050/tcp | über SSH-Tunnel oder unverschlüsselt im eigenen Netz |
| **Proxmox Web/API** | 8006/tcp | auf allen Knoten |

Tabelle 126: Ports im Proxmox-/Ceph-Cluster

> [!WARNUNG] Ceph braucht ein schnelles Netz
> Jeder Schreibvorgang wird über das Cluster-Netz an zwei weitere Knoten repliziert. Mit 1-GbE-Leitungen wird Ceph zum Flaschenhals; empfohlen sind **mindestens 10 GbE**, besser 25 GbE, und ausschließlich Enterprise-SSDs mit Stromausfallschutz.

## Kapazität grafisch planen

![Abbildung 57: Ressourcenbedarf in Abhängigkeit von der Zahl paralleler Teams](asset:cyberrange/cr-19-057.png)

**So liest man die Abbildung:**

- Die blaue Linie zeigt den **RAM-Bedarf**: eine Grundlast von 48 GB plus 70 GB je Team-Kopie des Szenarios.
- Die gestrichelten Linien zeigen die **Kapazitätsgrenzen**: Der Pilot-Host range-01 (128 GB) reicht für **ein** Team; zwei Range-Hosts mit je 256 GB reichen für sechs Teams.
- Bei einem Cluster wird mit **N+1** gerechnet: Ein Knoten muss ausfallen dürfen, ohne dass die Übung stoppt. Von drei Knoten mit je 256 GB sind daher nur 512 GB planbar.
## Netzwerkdesign im Cluster

| **Thema** | **Pilot** | **Cluster (Stufe 3)** |
|---|---|---|
| **Topologie** | Direktkabel zwischen zwei Hosts | zwei Switches (redundant), später Spine-Leaf |
| **Bündelung** | keine | LACP-Bonds (802.3ad) über beide Switches (MLAG) |
| **MTU** | 1500 | 9000 (Jumbo Frames) im Underlay für VXLAN und Ceph |
| **Overlay** | VLANs auf lokaler Bridge | Proxmox SDN mit VXLAN- oder EVPN-Zonen |
| **Trennung** | physische Ports | VLANs je Funktion: MGMT, Corosync, Ceph-Public, Ceph-Cluster, Overlay, Mirror |
| **Mirror** | lokal per tc | ERSPAN/GRE-Tunnel zum Sensor oder dedizierter Sensor je Knoten |

Tabelle 127: Netzwerkdesign: Pilot und Cluster im Vergleich

## Kostenstruktur (ohne Preise)

Preise ändern sich zu schnell, um sie hier festzuschreiben. Die Struktur der Kosten bleibt aber stabil und eignet sich als Gerüst für jede Kalkulation:

| **Kostenart** | **Einmalig** | **Laufend** | **Treiber** |
|---|---|---|---|
| **Hardware** | Server, Switches, USV, Kabel | Ersatzteile, Erweiterung | RAM und Speicher pro Team |
| **Software** | – | optionale Subskriptionen (Proxmox, Support) | Supportbedarf |
| **Lizenzen Windows** | ggf. Volumen-/Bildungslizenzen | Verlängerung | Anzahl Windows-VMs, Dauerbetrieb |
| **Personal Aufbau** | Personentage aus Kapitel 33 | – | Erfahrung des Teams |
| **Personal Betrieb** | – | Green Team, Pflege der Szenarien | Übungsfrequenz |
| **Strom und Kühlung** | – | Dauerlast × Betriebsstunden | Leerlaufverbrauch, Abschaltung zwischen Übungen |
| **Szenario-Entwicklung** | Erstellung | Aktualisierung (neue Techniken) | Anzahl und Komplexität der Szenarien |

Tabelle 128: Kostenstruktur einer eigenen Range

## Mandanten mit Proxmox SDN umsetzen

Ab Stufe 3 sollen mehrere Teams **identische** Kopien des Szenarios bekommen – mit denselben IP-Adressen, damit Musterlösungen und Regeln für alle gelten. Das gelingt nur, wenn die Netze der Teams vollständig voneinander getrennt sind. Proxmox SDN bietet dafür Zonen und VNets.

![Abbildung 58: Getrennte SDN-Zonen je Team mit identischen Adressbereichen](asset:cyberrange/cr-19-058.png)

**So liest man die Abbildung:**

- Jedes Team erhält eine eigene **Zone** vom Typ VXLAN. Innerhalb der Zone gibt es je Szenario-Netz ein **VNet** mit eigener VXLAN-Kennung (VNI).
- Die Adressbereiche sind in allen Zonen **gleich** (z. B. 10.10.30.0/24 für CORP). Das ist möglich, weil die VNets verschiedener Teams nie miteinander verbunden sind.
- Jedes Team hat eine **eigene OPNsense** als Router zwischen seinen VNets.
- Alle Zonen laufen über dasselbe **Underlay** – das physische Netz zwischen den Cluster-Knoten mit erhöhter MTU.
**SDN-Konfiguration für zwei Teams (Prinzip; Einrichtung über GUI oder API)**

```
# /etc/pve/sdn/zones.cfg (Auszug) – eine VXLAN-Zone je Team
vxlan: team1
        peers 10.0.1.11,10.0.1.12,10.0.1.13
        mtu 1450

vxlan: team2
        peers 10.0.1.11,10.0.1.12,10.0.1.13
        mtu 1450

# /etc/pve/sdn/vnets.cfg (Auszug) – VNets mit eigener VXLAN-Kennung (VNI)
vnet: t1corp
        zone team1
        tag 10030

vnet: t2corp
        zone team2
        tag 11030
```

> [!INFO] Warum MTU 1450?
> VXLAN fügt jedem Frame 50 Byte hinzu. Läuft das Underlay mit der Standard-MTU 1500, dürfen die VNets höchstens 1450 Byte nutzen. Wird das Underlay auf 9000 Byte (Jumbo Frames) eingestellt, können die VNets die volle MTU 1500 behalten – das ist für Windows-Gäste die bessere Wahl, weil sie MTU-Probleme schlecht vertragen.

| **Aufgabe** | **Ohne SDN (Pilot)** | **Mit SDN (Stufe 3)** |
|---|---|---|
| **Neues Team hinzufügen** | VLAN-IDs vergeben, Bridges anpassen, Firewall erweitern | Zone + VNets per API anlegen, Szenario-Code mit Team-Nummer ausführen |
| **Team über mehrere Knoten verteilen** | nicht möglich (lokale Bridge) | automatisch über VXLAN |
| **Gleiche Adressen für alle Teams** | nur mit getrennten Hosts | ja, durch getrennte Zonen |
| **Live-Migration von VMs** | nein | ja |

Tabelle 129: Vergleich: Pilot ohne SDN und Cluster mit SDN
