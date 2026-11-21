---
id: cr-28
title: Leistung messen und optimieren
paths: cyberrange
order: 28
difficulty: hard
icon: speedometer
summary: Kapitel 28 deiner Cyber-Range-Dokumentation: Leistung messen und optimieren.
source: Cyber_Range_Dokumentation.docx
htb: 
---

## Überblick

Eine Range, die bei STARTEX in die Knie geht, ruiniert jede Übung: Remote-Desktops ruckeln, Dienste fallen in Timeouts, Service-Checks werden rot, obwohl niemand angegriffen hat. Leistung wird deshalb nicht geschätzt, sondern **gemessen** – vor der ersten Übung und nach jeder größeren Änderung.

## Die drei Engpässe: CPU, Speicher, Ein-/Ausgabe

![Abbildung 73: Schematischer Zusammenhang zwischen CPU-Überbuchung und Wartezeit](asset:cyberrange/cr-28-073.png)

**So liest man die Abbildung:**

- Die **x-Achse** zeigt das Verhältnis von vergebenen vCPUs zu physischen Kernen.
- Die **y-Achse** zeigt, wie lange vCPUs im Mittel auf einen freien Kern warten müssen.
- Bis etwa 3:1 bleibt die Wartezeit bei typischer Range-Last gering (grün); darüber steigt sie schnell an. Die Kurve ist **schematisch** – die genaue Lage hängt davon ab, wie viele VMs gleichzeitig rechnen.
- Leerlaufende Systeme (Domänencontroller, NPCs) vertragen hohe Überbuchung, Analyse-Systeme (Security Onion, Wazuh-Indexer) dagegen kaum.
| **Ressource** | **Kennzahl** | **Wo ablesen** | **Alarmzeichen** |
|---|---|---|---|
| **CPU** | Druck (PSI) »some« in /proc/pressure/cpu, Steal-Zeit im Gast | node_exporter, `top` im Gast (st) | dauerhaft > 10 % Druck |
| **Arbeitsspeicher** | freier RAM, KSM-Einsparung, Ballooning-Aktivität | Proxmox-Übersicht, `free -h` | Host beginnt zu swappen |
| **Massenspeicher** | IO-Delay, Latenz, Warteschlangenlänge | Proxmox-Übersicht, `iostat -x 1`, `zpool iostat -v 1` | IO-Delay > 10 %, Latenz > 5 ms |
| **Netzwerk** | Durchsatz, verworfene Pakete | `ip -s link`, Sensor-Statistik | Drops auf tap- oder Sensor-Interfaces |

Tabelle 169: Leistungskennzahlen und Alarmzeichen

## Benchmarks vor der ersten Übung

Mit zwei Standardwerkzeugen lässt sich die Grundleistung in wenigen Minuten bestimmen: fio für den Massenspeicher und iperf3 für das Netz. Die Ergebnisse werden dokumentiert und dienen als Vergleich, wenn später etwas langsam wirkt.

**Basismessungen mit fio und iperf3**

```
# Zufällige 4K-Lese-/Schreiblast wie bei vielen startenden VMs (in einer Test-VM auf dem VM-Pool)
fio --name=bootsturm --filename=/root/fio.test --size=8G --direct=1 --rw=randrw --rwmixread=70 \
    --bs=4k --ioengine=libaio --iodepth=32 --numjobs=4 --runtime=60 --time_based --group_reporting

# Sequenzieller Durchsatz (z. B. für PCAP-Speicher auf ops-01)
fio --name=seq --filename=/nsm/fio.test --size=16G --direct=1 --rw=write --bs=1M \
    --ioengine=libaio --iodepth=16 --runtime=60 --time_based

# Netzdurchsatz zwischen zwei VMs in verschiedenen VLANs (also durch OPNsense)
iperf3 -s                                  # auf web01
iperf3 -c 10.10.20.10 -t 30 -P 4           # auf ws01: 4 parallele Ströme, 30 Sekunden
```

| **Messung** | **Erwartung im Pilot (Richtwert)** | **Wenn deutlich darunter** |
|---|---|---|
| **fio randrw 4K, NVMe-Mirror** | mehrere 10.000 IOPS, Latenz < 1 ms | ZFS-Einstellungen, SSD-Typ (Consumer, voller SLC-Cache) prüfen |
| **iperf3 innerhalb eines VLANs** | nahe der Speicherbandbreite (mehrere Gbit/s), da nur Bridge | VirtIO-Treiber, Multiqueue prüfen |
| **iperf3 über OPNsense** | 1–5 Gbit/s je nach vCPU-Zahl der Firewall | mehr vCPUs für rtr-01, Hardware-Offloading in OPNsense aus (VirtIO) |
| **Boot-Sturm: 30 VMs gleichzeitig** | alle Anmeldeseiten in < 5 Minuten erreichbar | Startreihenfolge staffeln, mehr IOPS |

Tabelle 170: Erwartungswerte und Reaktionen

## Optimierungen, die sich lohnen

| **Bereich** | **Einstellung** | **Wirkung** |
|---|---|---|
| **CPU-Typ** | `host` für Leistung oder ein einheitliches Modell (z. B. x86-64-v2-AES) für Migration im Cluster | volle CPU-Befehlssätze bzw. Kompatibilität |
| **Disk-Controller** | VirtIO SCSI single mit `iothread=1` je Disk | parallele Ein-/Ausgabe, weniger Blockieren |
| **Disk-Optionen** | `discard=on`, `ssd=1`, Cache »none« (Standard) | freigegebener Platz kommt zurück, sauberes Verhalten mit ZFS |
| **Netzwerkkarte** | VirtIO mit `queues=` gleich Anzahl vCPUs (Multiqueue) | höherer Durchsatz bei mehreren Kernen |
| **Firewall-VM** | Hardware-Offloading (CRC, TSO, LRO) in OPNsense deaktivieren | vermeidet Probleme mit VirtIO-Paketen |
| **Windows-Gäste** | VirtIO-Treiber und Guest Agent, Energieplan »Höchstleistung«, Defender-Scans zeitlich staffeln | weniger CPU- und I/O-Spitzen |
| **ZFS** | ARC begrenzen, `compression=lz4`, `atime=off`, getrennter Pool für PCAP | mehr RAM für VMs, weniger Schreiblast |
| **Startverhalten** | Startreihenfolge mit Wartezeiten (Kapitel 17.9) | kein Boot-Sturm |

Tabelle 171: Lohnende Optimierungen

> [!TIPP] Ein Lasttest gehört zum Dry-Run
> Beim Dry-Run (Phase P7) wird STARTEX mit allen VMs **und** laufenden NPCs simuliert und eine Stunde gemessen. Erst wenn alle Kennzahlen im grünen Bereich bleiben, gibt es das »Go« für die Übung.

## Beispielrechnung: Passt das Szenario auf die Hardware?

Die folgende Rechnung zeigt Schritt für Schritt, wie man prüft, ob das Szenario »Operation Nordlicht« für ein Team auf range-01 (16 Kerne, 128 GB RAM, 2 × 2 TB NVMe) passt.

| **Position** | **Anzahl** | **vCPU je VM** | **RAM je VM** | **Summe vCPU** | **Summe RAM** |
|---|---|---|---|---|---|
| **rtr-01 (OPNsense)** | 1 | 2 | 4 GB | 2 | 4 GB |
| **SINET (DNS, Web, Mail, Router)** | 4 | 1 | 2 GB | 4 | 8 GB |
| **RED (Kali, C2)** | 3 | 2 | 4 GB | 6 | 12 GB |
| **DMZ (web01, mail01)** | 2 | 2 | 4 GB | 4 | 8 GB |
| **CORP-Server (dc01, dc02, fs01)** | 3 | 2 | 6 GB | 6 | 18 GB |
| **CORP-Clients (Windows 11)** | 5 | 2 | 4 GB | 10 | 20 GB |
| **BLUE-SOC (Analysten-VM)** | 1 | 2 | 4 GB | 2 | 4 GB |
| **NPC-Systeme + GHOSTS-API** | 6 | 1 | 3 GB | 6 | 18 GB |
| **Summe** | **25** |  |  | **40** | **92 GB** |

Tabelle 172: Ressourcenbedarf eines Teams

- **RAM:** 92 GB für VMs + 8 GB Host + 12 GB ZFS-ARC = 112 GB von 128 GB – passt mit etwa 12 % Reserve. Ballooning und KSM schaffen in der Praxis zusätzlich Luft.
- **CPU:** 40 vCPU auf 16 Kerne (32 Threads) = Überbuchung 2,5 : 1 bezogen auf Kerne. Da die meisten VMs überwiegend warten (DCs, NPCs), ist das unkritisch (siehe Abbildung 61).
- **Speicher:** 25 Linked Clones × durchschnittlich 5 GB Delta + Templates 4 × 40 GB ≈ 285 GB – weit unter 2 TB. Platz bleibt für Snapshots und weitere Szenarien.
- **Ergebnis:** Ein Team passt sicher; ein **zweites** Team würde den RAM sprengen (2 × 92 GB > 128 GB). Für zwei parallele Teams wird ein zweiter Range-Host oder ein Ausbau auf 256 GB benötigt.
