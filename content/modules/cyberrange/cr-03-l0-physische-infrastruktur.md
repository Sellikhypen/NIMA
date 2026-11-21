---
id: cr-03
title: L0 – Physische Infrastruktur
paths: cyberrange
order: 3
difficulty: medium
icon: server.rack
summary: Kapitel 3 deiner Cyber-Range-Dokumentation: L0 – Physische Infrastruktur.
source: Cyber_Range_Dokumentation.docx
htb: Cyber Range 03 · L0 Hardware
---

## Überblick

Die unterste Schicht ist die Hardware. Sie bestimmt, **wie viele** Systeme gleichzeitig laufen können und **wie schnell** sich Übungen auf- und abbauen lassen. Bei Cyber Ranges ist fast nie die CPU der Engpass, sondern der **Arbeitsspeicher**: Jede Windows-VM braucht 4–8 GB RAM, egal ob sie gerade arbeitet oder nicht.

## Prozessor (CPU)

Für Virtualisierung muss die CPU zwei Hardware-Funktionen besitzen, die im BIOS/UEFI aktiviert werden:

- **Hardware-Virtualisierung** – Intel VT-x bzw. AMD-V (SVM). Damit kann der Gast-Code direkt auf der CPU laufen; der Hypervisor greift nur bei privilegierten Befehlen ein.
- **Adressübersetzung in Hardware** – EPT (Intel) bzw. NPT/RVI (AMD). Ohne sie müsste der Hypervisor jede Speicheradresse per Software übersetzen – das wäre um ein Vielfaches langsamer.
- **IOMMU** – Intel VT-d bzw. AMD-Vi. Nötig, wenn physische Geräte (z. B. eine Netzwerkkarte) direkt an eine VM durchgereicht werden sollen, und verbessert die Isolation.

**Kerne:** Übungs-VMs sind die meiste Zeit im Leerlauf; man kann daher mehr virtuelle CPUs (vCPUs) vergeben, als physische Kerne vorhanden sind (Overcommit 3:1 bis 4:1 ist üblich). Für Maschine A sind 16 Kerne/32 Threads ein guter Wert, für Maschine B 8–12 Kerne. Sensoren (Zeek/Suricata) profitieren von hoher Einzelkernleistung.

**CPU-Funktionen prüfen**

```
# Prüfen, ob die CPU Virtualisierung unterstützt (Linux-Live-System oder Proxmox-Shell)
grep -Ec '(vmx|svm)' /proc/cpuinfo      # > 0 = VT-x (vmx) bzw. AMD-V (svm) vorhanden
dmesg | grep -i -e DMAR -e IOMMU        # IOMMU aktiv?
lscpu | grep -i virtualization
```

## Arbeitsspeicher (RAM)

RAM ist die **härteste Grenze** einer Range: CPU-Zeit kann man überbuchen, Arbeitsspeicher nur sehr begrenzt. Zwei Techniken helfen, sind aber kein Ersatz für ausreichend RAM:

- **KSM (Kernel Samepage Merging):** Viele gleiche Windows-VMs enthalten identische Speicherseiten (gleiche DLLs, gleicher Kernel). Der Host legt sie nur einmal ab. Konservativ sind 10–20 % Ersparnis realistisch.
- **Ballooning:** Ein Treiber in der VM gibt ungenutzten Speicher an den Host zurück. Funktioniert gut bei Linux, bei Windows nur mit installierten VirtIO-Treibern.

**ECC-Speicher** (Error-Correcting Code) erkennt und korrigiert Bitfehler. Für einen Server, der wochenlang viele VMs und ein ZFS-Dateisystem betreibt, ist ECC dringend empfohlen – Speicherfehler äußern sich sonst als schwer erklärbare Abstürze oder beschädigte Daten.

## Massenspeicher

Beim gleichzeitigen Start vieler VMs (»Boot-Storm«) entstehen zehntausende kleine Lese- und Schreibzugriffe pro Sekunde. Entscheidend sind daher **IOPS** (Ein-/Ausgabe-Operationen pro Sekunde), nicht die reine Kapazität. NVMe-SSDs sind Pflicht.

| **Speichertyp in Proxmox** | **Prinzip** | **Snapshots / Linked Clones** | **Empfehlung** |
|---|---|---|---|
| **ZFS (lokal)** | Dateisystem + Volume-Manager mit Prüfsummen, Kompression, Software-RAID | Ja, sehr schnell | **Pilot: ZFS-Mirror aus 2 NVMe** (übersteht Ausfall einer SSD) |
| **LVM-thin (lokal)** | Dünn bereitgestellte logische Volumes | Ja | Gute Alternative, wenig RAM-Bedarf |
| **Verzeichnis + qcow2** | Abbilddateien im Dateisystem | Ja (qcow2) | Für Tests, langsamer |
| **Ceph RBD (verteilt)** | Daten 3-fach über mehrere Server repliziert | Ja | Ab Cluster mit ≥ 3 Knoten (Kapitel 19) |
| **NFS/iSCSI (extern)** | Zentrales Speichersystem im Netz | Je nach Format | Wenn bereits vorhanden |

Tabelle 14: Speicheroptionen in Proxmox VE

> [!TIPP] ZFS-Speicherbedarf begrenzen
> ZFS nutzt standardmäßig freien RAM als Lese-Cache (ARC). Auf einem VM-Host sollte der ARC begrenzt werden, z. B. auf 16 GB: Datei `/etc/modprobe.d/zfs.conf` mit `options zfs zfs_arc_max=17179869184`, danach `update-initramfs -u` und Neustart.

## Netzwerkkarten und Switch

Jede Ebene erhält eine eigene physische Netzwerkkarte (NIC). So kann ein Fehler oder eine Fehlkonfiguration in einer Ebene die anderen nicht beeinträchtigen, und der Mitschnitt läuft auf einer eigenen Leitung ohne Konkurrenz.

| **Port (Beispiel)** | **Maschine A »range-01«** | **Maschine B »ops-01«** | **Verbindung** |
|---|---|---|---|
| **eno1** | MGMT (10.0.0.11) | MGMT (10.0.0.12) | Managebarer Switch, MGMT-VLAN |
| **enp2s0** | SVC/Transfer (Host ohne IP) | SVC/Transfer (Host ohne IP) | Direktkabel A ↔ B |
| **enp3s0** | MIRROR-OUT (sendet Kopien) | SNIFF-IN (empfängt Kopien) | Direktkabel A → B |
| **enp4s0** | Reserve (z. B. spätere Cluster-/Ceph-Verbindung) | – | – |

Tabelle 15: Belegung der Netzwerkports

Für den Pilot genügen 1- oder 2,5-Gigabit-Ports; für den Spiegelkanal ist 10 GbE vorteilhaft, sobald viel Verkehr erzeugt wird. Der Switch muss nur das Management-Netz bedienen; ein managebarer Switch erlaubt später zusätzliche VLANs (z. B. für Corosync im Cluster).

## Fernwartung, Strom und Umgebung

- **Out-of-Band-Zugang:** Server-Mainboards bringen IPMI (iDRAC, iLO, AST2600-BMC) mit; bei Workstations hilft Intel AMT oder ein KVM-over-IP-Gerät. Damit lassen sich Server auch bei hängendem Betriebssystem neu starten oder neu installieren.
- **USV:** Bei Stromausfall versorgt sie die Server weiter; über NUT (Network UPS Tools) fährt Proxmox die VMs geordnet herunter, bevor die Batterie leer ist – das schützt vor Datenverlust im ZFS-Pool.
- **Kühlung und Lärm:** Server-Hardware ist laut; zwei Rechner mit je 100–300 W Dauerlast erzeugen spürbare Wärme – Raum entsprechend wählen.
## Hardware-Empfehlung

| **Komponente** | **Maschine A »range-01« (empfohlen)** | **Maschine B »ops-01« (empfohlen)** | **Untergrenze (Budget)** |
|---|---|---|---|
| **CPU** | 16 Kerne / 32 Threads (z. B. AMD EPYC 4004 oder Ryzen 9, Intel Xeon W), VT-x/AMD-V + IOMMU | 8-12 Kerne | A: 8 Kerne, B: 4-6 Kerne |
| **RAM** | 128 GB (ECC bevorzugt) | 64 GB | A: 64 GB, B: 32 GB |
| **Storage** | 2 × 2 TB NVMe (ZFS-Mirror) für VMs | 1 × 2 TB NVMe (System + Logs) + optional 4 TB für PCAP | A: 1 TB NVMe, B: 1 TB SSD |
| **NICs** | 4 Ports (MGMT, SVC, MIRROR, Reserve) | 3 Ports (MGMT, SVC, SNIFF) | Je 3 Ports |
| **OOB** | IPMI/AMT oder KVM-over-IP | IPMI/AMT oder KVM-over-IP | optional |
| **Sonstiges** | USV, managebarer Switch, 2 Direktkabel |  | Unmanaged Switch nur für MGMT |

Tabelle 16: Hardwareempfehlung

## Im Inneren eines Servers: NUMA, PCIe und Fernwartung

Wer viele VMs auf einem Rechner betreibt, muss verstehen, wie CPU, Speicher und Erweiterungskarten zusammenhängen. Das wichtigste Stichwort ist NUMA: In Servern mit zwei CPU-Sockeln hat jeder Sockel eigene Speicherkanäle. Greift ein Prozess auf den Speicher des **anderen** Sockels zu, läuft der Zugriff über die Verbindung zwischen den Sockeln (Intel UPI, AMD Infinity Fabric) und dauert spürbar länger.

![Abbildung 5: Innenleben eines Zwei-Sockel-Servers mit NUMA-Knoten, PCIe-Geräten und BMC](asset:cyberrange/cr-03-005.png)

**So liest man die Abbildung:**

- Jeder **NUMA-Knoten** besteht aus einer CPU und den direkt angeschlossenen Speichermodulen (DIMMs). Die Speicherkanäle sollten gleichmäßig bestückt sein, sonst sinkt die Speicherbandbreite.
- Die rote Linie zwischen den CPUs ist der **Sockel-Interconnect**. Jeder Weg darüber kostet Latenz.
- Unten hängen die **PCIe-Geräte** – jedes ist einem Sockel zugeordnet. Eine Netzwerkkarte an CPU 1 ist für VMs auf CPU 0 »weiter weg«.
- Der **BMC** (lila) ist ein eigener kleiner Computer für die Fernwartung und gehört ausschließlich ins Management-Netz.

Für den Pilot mit **einem** CPU-Sockel pro Maschine (siehe Hardware-Empfehlung) spielt NUMA keine Rolle. Ab Stufe 3 mit Zwei-Sockel-Servern gilt: In Proxmox die Option `numa: 1` setzen und große VMs (Security Onion, Wazuh-Indexer) so dimensionieren, dass sie in **einen** NUMA-Knoten passen.

| **PCIe-Generation** | **Durchsatz je Lane (ca.)** | **x4 (NVMe)** | **x8 (NIC)** | **x16 (GPU)** |
|---|---|---|---|---|
| **PCIe 3.0** | ≈ 1 GB/s | ≈ 4 GB/s | ≈ 8 GB/s | ≈ 16 GB/s |
| **PCIe 4.0** | ≈ 2 GB/s | ≈ 8 GB/s | ≈ 16 GB/s | ≈ 32 GB/s |
| **PCIe 5.0** | ≈ 4 GB/s | ≈ 16 GB/s | ≈ 32 GB/s | ≈ 64 GB/s |

Tabelle 17: Bandbreite von PCIe je Richtung (gerundet)

Eine 25-GbE-Netzwerkkarte benötigt rund 3 GB/s – sie passt also problemlos in einen PCIe-4.0-x8-Steckplatz. Engpässe entstehen eher, wenn ein Mainboard Steckplätze über einen Chipsatz statt direkt an der CPU anbindet. Das Handbuch des Mainboards zeigt, welche Slots »CPU-direct« sind.

## Speicher dimensionieren: der »Boot-Sturm«

Der kritischste Moment einer Übung ist nicht der Angriff, sondern **STARTEX**: Wenn 30 Windows-VMs gleichzeitig starten, Updates prüfen, Gruppenrichtlinien laden und Virenscanner initialisieren, entsteht ein **Boot-Sturm**. Entscheidend sind dann nicht Gigabyte, sondern IOPS und Latenz.

| **Speichertyp** | **zufällige 4K-IOPS (ca.)** | **Latenz** | **Eignung** |
|---|---|---|---|
| **HDD 7.200 U/min** | ≈ 80–150 | 5–10 ms | nur Backup, ISO-Ablage |
| **SATA-SSD** | ≈ 50.000–90.000 | ≈ 0,1 ms | Minimum für VMs |
| **NVMe-SSD (PCIe 4.0)** | ≈ 500.000–1.000.000 | < 0,1 ms | **empfohlen für VM-Pools** |
| **NVMe Enterprise (PLP)** | ähnlich, aber konstant unter Dauerlast | < 0,1 ms | ideal: Stromausfallschutz für ZFS |

Tabelle 18: Leistung typischer Speichertypen (Herstellerangaben, Größenordnung)

**Rechenbeispiel:** Ein Windows-Server braucht beim Start kurzzeitig 300–1.000 IOPS. 30 VMs × 800 IOPS = 24.000 IOPS. Eine einzelne Consumer-NVMe schafft das rechnerisch spielend – aber Consumer-SSDs brechen bei langen Schreiblasten ein (SLC-Cache voll) und haben keinen Stromausfallschutz (PLP, Power Loss Protection). Für ZFS mit synchronen Schreibvorgängen sind daher **Enterprise-NVMe mit PLP** die solide Wahl.

> [!TIPP] ZFS-Layout für range-01
> **Mirror statt RAID-Z:** Zwei NVMe als Spiegel liefern doppelte Lese-IOPS und schnelle Wiederherstellung. RAID-Z lohnt sich erst für große Datengräber (PCAP, Backups).
> **ashift=12** (4-KiB-Sektoren), **compression=lz4** (spart Platz, kostet kaum CPU), **atime=off**.
> **ARC begrenzen:** Seit Proxmox VE 8.1 setzt der Installer für neue Systeme die Obergrenze auf 10 % des RAM (maximal 16 GiB). Bei 128 GB RAM sind 8–12 GiB ARC ein guter Wert.

## Netzwerkkarten: worauf es ankommt

| **Merkmal** | **Warum wichtig** | **Empfehlung** |
|---|---|---|
| **Chipsatz** | Treiberqualität unter Linux, Offloading, SR-IOV | Intel (i350, X710, E810), Mellanox/NVIDIA ConnectX; Realtek meiden |
| **Portanzahl** | MGMT, SVC, MIRROR, Reserve getrennt führen | ≥ 4 Ports an range-01, ≥ 3 an ops-01 |
| **Geschwindigkeit** | Mirror-Verkehr verdoppelt die Last auf dem Sensor-Link | 1 GbE genügt im Pilot, 10/25 GbE ab Stufe 3 |
| **Promiscuous Mode** | Sniff-NIC muss alle Frames annehmen | bei allen genannten Chipsätzen unterstützt |
| **SR-IOV** | Virtuelle Funktionen direkt in VMs (hohe Leistung) | optional, nicht für den Pilot nötig |

Tabelle 19: Auswahlkriterien für Netzwerkkarten

## UEFI-Einstellungen, Strom und Wärme

Vor der Proxmox-Installation werden im UEFI einige Einstellungen geprüft. Fehlt eine davon, fallen die Folgen oft erst Wochen später auf (z. B. kein PCI-Passthrough oder ungewollte Taktabsenkung unter Last).

☐  Virtualisierung aktiv: Intel VT-x / AMD-V (SVM)

☐  IOMMU aktiv: Intel VT-d / AMD-Vi

☐  SR-IOV aktiv (falls genutzt)

☐  Secure Boot: Proxmox VE unterstützt Secure Boot seit Version 8.1 – einheitlich entscheiden und dokumentieren

☐  Energieprofil »Performance« bzw. C-States begrenzen (stabile Latenz)

☐  Wake-on-LAN und Auto-Power-On nach Stromausfall nach Bedarf

☐  BMC: Standardpasswort geändert, eigene IP im MGMT-Netz, Firmware aktuell

☐  ECC-Fehlerprotokollierung im BMC prüfen

**Strom und Wärme:** Elektrische Leistung wird nahezu vollständig zu Wärme. Ein Server mit 350 W Dauerlast erzeugt rund 1.200 BTU/h (1 W ≈ 3,41 BTU/h). Zwei solche Maschinen plus Switch ergeben etwa 800 W – in einem kleinen Büroraum ohne Klimatisierung steigt die Temperatur dann merklich. Die USV wird auf diese Last plus 30 % Reserve ausgelegt; die Überbrückungszeit muss für ein sauberes Herunterfahren reichen (typisch 10 Minuten).

## Aufstellung, Verkabelung und Beschriftung

Auch in einem kleinen Pilot lohnt sich Ordnung bei der Hardware. Fehlerhafte Kabel sind eine der häufigsten Ursachen für »rätselhafte« Netzprobleme – und eine vertauschte Leitung zwischen Übungsnetz und Büronetz wäre ein Sicherheitsvorfall.

| **Regel** | **Umsetzung** | **Warum** |
|---|---|---|
| **Farbcode für Kabel** | MGMT = blau, SVC/Transfer = grün, Mirror = gelb, Uplink Büro = grau, Übungsnetz physisch = rot (ab Stufe 3) | Fehlsteckungen sind auf einen Blick sichtbar |
| **Beschriftung beider Enden** | Etikett mit Quelle und Ziel, z. B. »range-01 eno1 ↔ sw-mgmt p3« | Fehlersuche ohne Raten |
| **Port-Dokumentation** | Tabelle Port → Funktion → Kabelfarbe im Git-Repository | Änderungen sind nachvollziehbar |
| **Direktkabel statt Switch** | SVC und Mirror im Pilot als Direktkabel zwischen den Hosts | Kein Switch, der falsch konfiguriert werden kann |
| **Physische Trennung** | Kein Kabel vom Übungsnetz zu einem Büro-Switch – die Bridge vmbr1 hat gar keinen physischen Port | Isolation ist schon im Kabel garantiert |
| **Stromversorgung** | beide Netzteile der Server an USV bzw. getrennte Stromkreise | kein Ausfall durch ein defektes Netzteil |

Tabelle 20: Regeln für Aufstellung und Verkabelung

## Drei Ausbaustufen als Stückliste

Die folgende Stückliste beschreibt drei realistische Ausbaustufen ohne Preise – die Marktpreise ändern sich zu schnell. Die Mengenangaben ergeben sich aus der Kapazitätsplanung (Kapitel 19.3 und 19.7).

| **Komponente** | **Einstieg (1 Team, Lernlabor)** | **Pilot (dieses Dokument)** | **Stufe 3 (4–6 Teams)** |
|---|---|---|---|
| **Server** | 1 × Workstation/Tower, 8–16 Kerne | 2 × Server bzw. Workstation (range-01, ops-01) | 3–4 × Rack-Server, 1 Sockel je 32+ Kerne |
| **Arbeitsspeicher** | 64–128 GB | 128 GB + 64 GB, ECC | je 256–512 GB ECC |
| **Massenspeicher** | 1–2 × NVMe 2 TB | range-01: 2 × NVMe (Mirror); ops-01: NVMe + HDD/SSD für PCAP | je 4–6 × Enterprise-NVMe für Ceph + PCAP-Speicher |
| **Netzwerkkarten** | 2 × 1 GbE | 4 bzw. 3 Ports, Intel-Chipsätze | 2 × 25 GbE + 2 × 1 GbE je Knoten |
| **Switches** | ein unmanaged Switch für MGMT | ein managebarer Switch (MGMT), Direktkabel | 2 × 25-GbE-Switches (redundant), MGMT-Switch |
| **Fernwartung** | optional | IPMI/AMT oder KVM-over-IP | BMC je Server, eigenes Netz |
| **USV** | Steckdosen-USV | USV für beide Hosts + Switch | Rack-USV, ggf. Netzwerkkarte für Abschaltung |
| **Backup** | externe Festplatte | PBS-VM mit eigener Platte + Offline-Kopie | eigener PBS-Server + zweiter Standort |

Tabelle 21: Stücklisten für drei Ausbaustufen
