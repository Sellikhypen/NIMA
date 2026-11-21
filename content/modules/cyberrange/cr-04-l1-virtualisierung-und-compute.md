---
id: cr-04
title: L1 – Virtualisierung und Compute
paths: cyberrange
order: 4
difficulty: medium
icon: cpu
summary: Kapitel 4 deiner Cyber-Range-Dokumentation: L1 – Virtualisierung und Compute.
source: Cyber_Range_Dokumentation.docx
htb: Cyber Range 04 · L1 Virtualisierung
---

## Überblick

Auf der Hardware läuft ein **Typ-1-Hypervisor**: Proxmox VE. Er verwandelt die zwei physischen Rechner in Dutzende virtuelle. Dieses Kapitel erklärt, was dabei im Inneren passiert – denn wer das versteht, kann Leistungsprobleme, Netzwerkfehler und Sicherheitsfragen später gezielt beurteilen.

## Proxmox VE, KVM und QEMU

**Proxmox VE** ist eine Debian-basierte Virtualisierungsplattform. Sie bündelt drei Bausteine:

- **KVM** – ein Modul des Linux-Kernels, das die Virtualisierungsfunktionen der CPU nutzbar macht. Der Code einer VM läuft damit direkt auf dem Prozessor; nur bei privilegierten Operationen (z. B. Zugriff auf Geräte) springt die CPU per »VM-Exit« zurück in den Hypervisor.
- **QEMU** – ein Programm, das für jede VM als eigener Prozess läuft und die virtuelle Hardware bereitstellt: Festplatten-Controller, Netzwerkkarten, Grafik, Konsole. Jede vCPU ist ein Thread dieses Prozesses.
- **Verwaltungsschicht** – Weboberfläche und REST-API (`pveproxy`, Port 8006), Task-Ausführung (`pvedaemon`), Cluster-Dateisystem (`/etc/pve`), Firewall, Backup, SDN.
![Abbildung 6: Was in einem Proxmox-Host passiert – von der Anwendung in der VM bis zur Bridge](asset:cyberrange/cr-04-006.png)

**So liest man die Abbildung:**

- **Links oben** der Gast: Eine Anwendung schreibt Daten in einen Socket, der TCP/IP-Stack der VM baut daraus Pakete, der VirtIO-Netzwerktreiber legt sie in Ringpuffer (Virtqueues) im Speicher der VM.
- **Links unten** der Host: Der Kernel-Thread **vhost-net** holt die Frames direkt aus diesen Ringpuffern (ohne Umweg über den QEMU-Prozess) und übergibt sie dem tap-Interface `tap101i0`, das als Port an der Linux-Bridge `vmbr1` hängt.
- **Rechts oben:** CPU und RAM werden nicht emuliert, sondern über KVM direkt genutzt; EPT/NPT übersetzt die Speicheradressen in Hardware.
- **Rechts Mitte:** Jede VM-Netzwerkkarte erscheint als eigener Bridge-Port; die VLAN-Zuordnung (PVID) bestimmt, in welcher Übungszone die VM steht.
## Paravirtualisierung mit VirtIO

Eine voll emulierte Netzwerkkarte (z. B. Intel E1000) muss jedes Register-Zugriff der VM per Software nachspielen – langsam. Bei **Paravirtualisierung** weiß der Gast, dass er virtualisiert ist, und verwendet die schlanken VirtIO-Treiber. Linux bringt sie mit, für Windows werden sie von der »virtio-win«-ISO installiert (im Packer-Template automatisiert).

| **VirtIO-Gerät** | **Zweck** | **Hinweis** |
|---|---|---|
| **virtio-net** | Netzwerkkarte | Bis zu mehreren Gbit/s pro VM; Multiqueue für viele vCPUs |
| **virtio-scsi (single)** | Festplatten-Controller | Unterstützt TRIM/Discard (wichtig für Thin Provisioning und Linked Clones) |
| **virtio-balloon** | Speicher-Ballooning | Ermöglicht dynamische RAM-Rückgabe |
| **virtio-serial / QEMU Guest Agent** | Kommunikationskanal Host ↔ VM | IP-Abfrage, Freeze für konsistente Snapshots, sauberes Herunterfahren |
| **virtio-rng** | Zufallszahlen | Beschleunigt kryptografische Operationen beim Boot |

Tabelle 22: VirtIO-Geräte

## Aufbau einer VM-Konfiguration

Jede VM ist in Proxmox eine kleine Textdatei unter `/etc/pve/qemu-server/<VMID>.conf`. Die Datei zeigt, wie eine VM »gebaut« ist – Terraform erzeugt genau diese Einträge über die API:

**Beispiel einer VM-Konfiguration**

```
# /etc/pve/qemu-server/120.conf  (dmz-web01, Linked Clone von Template 9001)
agent: 1                                   # QEMU Guest Agent aktiv
boot: order=scsi0
cores: 2
cpu: x86-64-v2-AES                         # CPU-Modell (bei Bedarf: host)
memory: 2048
balloon: 1024                              # Ballooning bis minimal 1 GB
name: dmz-web01
net0: virtio=BC:24:11:3A:5F:20,bridge=vmbr1,tag=20,firewall=0
ipconfig0: ip=10.10.20.10/24,gw=10.10.20.1 # cloud-init
ide2: local-zfs:vm-120-cloudinit,media=cdrom
scsi0: local-zfs:base-9001-disk-0/vm-120-disk-0,discard=on,iothread=1,size=32G
scsihw: virtio-scsi-single
ostype: l26
tags: dmz;team1;nordlicht
```

Bemerkenswert ist die Zeile `scsi0`: `base-9001-disk-0/vm-120-disk-0` zeigt, dass die Platte ein **Linked Clone** des Templates 9001 ist. `tag=20` an `net0` setzt die VM in VLAN 20 (DMZ). Die MAC-Adresse beginnt mit `BC:24:11` – dem Herstellerpräfix, das Proxmox für VMs verwendet.

## Templates, Klone und Snapshots

Drei Mechanismen machen die Range schnell und reproduzierbar:

| **Mechanismus** | **Was passiert technisch** | **Dauer** | **Einsatz in der Range** |
|---|---|---|---|
| **Template** | VM wird schreibgeschützt; ihre Platte wird zur Basis (ZFS-Snapshot `@__base__`) | einmalig | Golden Images pro Betriebssystem (Kapitel 6) |
| **Full Clone** | Vollständige Kopie aller Daten | Minuten | Wenn eine VM unabhängig vom Template sein muss |
| **Linked Clone** | Copy-on-Write-Verweis auf das Template, nur Änderungen werden gespeichert | Sekunden | Standard für alle Übungs-VMs |
| **Snapshot** | Zustand einer VM (Platten, optional RAM) wird eingefroren | Sekunden | »clean«-Zustand vor der Übung, Reset danach |
| **Backup (vzdump/PBS)** | Konsistente Kopie auf ein anderes Speichersystem | Minuten | Templates und Infrastruktur-VMs sichern |

Tabelle 23: Templates, Klone, Snapshots, Backups

> [!WARNUNG] Linked Clones und Templates hängen zusammen
> Ein Template kann nicht gelöscht werden, solange Linked Clones darauf verweisen. Bei einem Template-Update (z. B. neue Windows-Patches) wird daher ein **neues** Template mit neuer VMID gebaut und die Range neu provisioniert – das alte Template wird erst danach entfernt.

## CPU-Modell, Nested Virtualization und Container

- **CPU-Typ:** `host` reicht alle CPU-Funktionen durch (maximale Leistung, nötig für Nested Virtualization), erschwert aber die Migration zwischen unterschiedlichen CPUs. `x86-64-v2-AES` bzw. `x86-64-v3` sind kompatibler.
- **Nested Virtualization:** Soll in einer VM wieder ein Hypervisor laufen (z. B. Proxmox in Proxmox zum Testen, Hyper-V für Windows-Sicherheitsfunktionen), muss im Kernelmodul `kvm_intel nested=1` bzw. `kvm_amd nested=1` aktiv sein und die VM den CPU-Typ `host` haben.
- **LXC-Container** sind leichter als VMs, teilen sich aber den Kernel des Hosts. Für Infrastrukturdienste (z. B. einen DNS-Server) geeignet – **niemals** für Malware oder Angreifer-Systeme, weil ein Kernel-Exploit direkt den Host träfe.
## Empfohlene VM-Einstellungen

| **Einstellung** | **Linux-VM** | **Windows-VM** | **Begründung** |
|---|---|---|---|
| **Maschinentyp / BIOS** | q35 / OVMF (UEFI) | q35 / OVMF + TPM 2.0 (Windows 11) | Moderne Plattform, Secure Boot möglich |
| **Platte** | VirtIO SCSI single, discard, iothread | wie Linux (Treiber aus virtio-win) | Leistung, Platz sparen |
| **Netzwerk** | VirtIO, Firewall aus | VirtIO | Übungsregeln in OPNsense, nicht pro VM |
| **Guest Agent** | qemu-guest-agent | QEMU Guest Agent aus virtio-win | IP-Abfrage für Terraform/Ansible |
| **Ballooning** | an | an (Treiber nötig) | RAM-Rückgabe |
| **Start** | »Start at boot« nur für Infrastruktur | nein | Übungs-VMs startet die Automatisierung |

Tabelle 24: Empfohlene VM-Einstellungen

## Was beim Betrieb einer VM im Host passiert

Eine laufende VM ist für den Linux-Kernel des Hosts **ein normaler Prozess** – ein QEMU-Prozess mit einem Thread pro virtueller CPU. Der Trick ist, dass diese Threads mit Hilfe der CPU-Erweiterungen VT-x/AMD-V direkt auf dem Prozessor laufen und nur bei besonderen Ereignissen (Ein-/Ausgabe, privilegierte Befehle) zurück an den Hypervisor fallen.

![Abbildung 7: Schichten einer laufenden VM: vom Gast-Programm bis zum Silizium](asset:cyberrange/cr-04-007.png)

**So liest man die Abbildung:**

- **Oben** laufen Programme im Gast. Sie sehen eine scheinbar echte Hardware.
- Der **Gast-Kernel** läuft im »Non-Root-Mode« der CPU: Er glaubt, Ring 0 zu haben, wird aber von der Hardware überwacht.
- Der **QEMU-Prozess** emuliert Geräte und stellt mit QMP eine Steuerschnittstelle bereit, über die Proxmox Snapshots oder Hotplug auslöst.
- **KVM** im Host-Kernel führt die vCPU-Threads aus. Will der Gast z. B. auf eine Netzwerkkarte zugreifen, entsteht ein **VM-Exit**; vhost-net bearbeitet Netzpakete direkt im Kernel, ohne Umweg über QEMU.
- **Ganz unten** sorgen EPT/NPT dafür, dass Gast-Speicheradressen in Hardware übersetzt werden, und die IOMMU schützt den Speicher bei Geräte-Durchreichung.

Daraus folgen zwei praktische Regeln: Erstens kann man VMs mit normalen Linux-Werkzeugen beobachten (`top -H -p <PID>` zeigt die vCPU-Threads). Zweitens sind **VM-Exits teuer** – deshalb sind paravirtualisierte Geräte (VirtIO) so viel schneller als emulierte Hardware (z. B. e1000-Netzwerkkarte).

## Copy-on-Write: warum Klone in Sekunden entstehen

Die Reproduzierbarkeit einer Range beruht auf einem einfachen Prinzip: **Copy-on-Write** (CoW). Ein Linked Clone kopiert nicht die 40 GB des Templates, sondern legt nur eine leere Delta-Ebene an. Gelesen wird aus dem Template, geschrieben wird ausschließlich in die Delta-Ebene.

![Abbildung 8: Template, Linked Clone und Snapshot auf Blockebene](asset:cyberrange/cr-04-008.png)

**So liest man die Abbildung:**

- Das **Template** (links) ist schreibgeschützt. Alle Klone verweisen darauf.
- Jeder **Klon** speichert nur die Blöcke, die er selbst verändert hat (orange im Blockstreifen unten).
- Ein **Snapshot** friert einen Zustand ein. Beim Rollback werden alle danach geschriebenen Blöcke verworfen – das dauert Sekunden, unabhängig von der Diskgröße.
| **Speicher-Backend** | **Linked Clones** | **Snapshots** | **Bemerkung** |
|---|---|---|---|
| **ZFS (zvol)** | ja | ja, sehr schnell | **Standard im Pilot**; Rollback nur auf den jüngsten Snapshot ohne Zwischenschritte zu löschen |
| **LVM-Thin** | ja | ja | einfach, aber keine Prüfsummen |
| **Ceph RBD** | ja | ja | Standard ab Stufe 3 (Cluster) |
| **qcow2 auf Verzeichnis/NFS** | ja | ja | flexibel, etwas langsamer |
| **LVM (dick)** | nein | seit PVE 9 als Technologievorschau über qcow2-Snapshot-Ketten | für Ranges ungeeignet |

Tabelle 25: Speicher-Backends und ihre Klon-/Snapshot-Fähigkeiten

> [!WARNUNG] ZFS-Eigenheit beim Rollback
> Unter ZFS kann man nur auf den **jüngsten** Snapshot zurückrollen. Existieren neuere Snapshots, löscht Proxmox sie beim Rollback auf einen älteren Stand. Deshalb gibt es pro Übungs-VM genau einen Referenz-Snapshot »clean« – Zwischenstände der Übung werden nicht als Snapshot gesichert.

## Arbeitsspeicher: Overcommit, KSM, Ballooning

Arbeitsspeicher ist in fast jeder Range der erste Engpass. Proxmox bietet drei Mechanismen, um ihn besser zu nutzen – jeder mit Nebenwirkungen.

![Abbildung 9: Zuweisung, tatsächliche Belegung und Einsparung durch KSM auf range-01](asset:cyberrange/cr-04-009.png)

**So liest man die Abbildung:**

- Die **linke Säule** zeigt die Summe des RAMs, der den VMs zugewiesen wurde (150 GB) – mehr als physisch vorhanden ist (rote Linie bei 128 GB). Das ist Overcommit.
- Die **zweite Säule** zeigt, was tatsächlich belegt ist: Viele VMs nutzen ihren zugewiesenen Speicher nicht voll.
- Die **dritte Säule** zeigt den Effekt von KSM: Identische Speicherseiten vieler gleicher Windows-VMs werden zusammengelegt.
| **Mechanismus** | **Wirkung** | **Risiko** | **Empfehlung im Pilot** |
|---|---|---|---|
| **KSM** | Gleiche 4-KiB-Seiten werden nur einmal gespeichert; Proxmox aktiviert die Zusammenlegung (ksmtuned) standardmäßig ab 80 % RAM-Auslastung | CPU-Last; theoretische Seitenkanal-Angriffe zwischen VMs | aktiv lassen |
| **Ballooning** | Treiber im Gast gibt ungenutzten RAM zurück | Gast kann bei Bedarf zu langsam Speicher zurückbekommen | Minimum = 70 % des Maximums setzen |
| **Swap auf dem Host** | Notreserve | extreme Verlangsamung aller VMs | **vermeiden**, kleines Swap oder zram |
| **Hugepages** | weniger Verwaltungsaufwand bei großen VMs | Speicher fest reserviert, kein KSM | nur für Security Onion erwägen |

Tabelle 26: Mechanismen der Speicherverwaltung

## Neuerungen in Proxmox VE 9.1 mit Bezug zur Range

Proxmox VE 9.1 erschien am 19. November 2025 und basiert auf Debian 13.2 »Trixie« mit Kernel 6.17. Für Cyber Ranges sind vor allem folgende Neuerungen interessant:

| **Neuerung** | **Nutzen für die Range** |
|---|---|
| **OCI-Images für Container (Technologievorschau)** | Container für SINET-Dienste (Fake-Webseiten, DNS) direkt aus Registry-Images erzeugen |
| **Neues vCPU-Flag zur Steuerung verschachtelter Virtualisierung** | Gezielt einzelne VMs (z. B. Windows mit VBS oder eine Mini-Range in der Range) mit Virtualisierungserweiterungen versorgen |
| **vTPM-Zustand im qcow2-Format** | Offline-Snapshots von Windows-11-VMs inklusive TPM auch auf Speichern ohne native Snapshots |
| **Überarbeitete SDN-Statusansicht** | Fehlersuche in VXLAN/EVPN-Zonen ab Stufe 3 deutlich einfacher |
| **Massenaktionen im Rechenzentrum** | Viele VMs auf einmal starten, stoppen oder migrieren – praktisch bei STARTEX/ENDEX |

Tabelle 27: Ausgewählte Neuerungen in Proxmox VE 9.1

> [!WARNUNG] Upgrade-Hinweis
> Ein Upgrade von 8.4 auf 9.x ist ein zweistufiger Vorgang (bei Ceph zuerst Reef → Squid). Vor jedem Major-Upgrade das Prüfskript `pve8to9 --full` ausführen und die Release Notes lesen. Ranges werden **nie** während eines Übungszeitraums aktualisiert.

## Befehlsreferenz: VMs auf der Kommandozeile

Die Weboberfläche genügt für den Alltag, aber Automatisierung und Fehlersuche gehen auf der Shell schneller. Die wichtigsten Befehle des Werkzeugs `qm` (QEMU Manager) und `pvesh` (API auf der Shell):

**Shell auf range-01**

```
# Übersicht
qm list                                   # alle VMs des Knotens mit Status
qm config 130                            # Konfiguration einer VM anzeigen
pvesh get /cluster/resources --type vm    # alle VMs im Cluster als Tabelle (API)

# Lebenszyklus
qm clone 9002 130 --name dc01 --full 0   # Linked Clone aus Template 9002
qm set 130 --memory 6144 --balloon 4096  # RAM 6 GB, Ballooning-Minimum 4 GB
qm set 130 --net0 virtio,bridge=vmbr1,tag=30,firewall=0
qm start 130 && qm agent 130 ping       # starten, Gast-Agent prüfen

# Snapshots
qm snapshot 130 clean --description "vor STARTEX"
qm listsnapshot 130
qm rollback 130 clean                    # in Sekunden zurück auf »clean«

# Befehle im Gast ausführen (über QEMU Guest Agent, ohne Netzwerk!)
qm guest exec 130 -- powershell -Command "Get-Service NTDS"
```

> [!INFO] Warum der Guest Agent so wertvoll ist
> Über `qm guest exec` kann das Green Team Befehle in einer VM ausführen, **ohne** dass die VM eine Netzwerkverbindung zur Verwaltung braucht. Das hält die Control Plane sauber vom Übungsnetz getrennt – und funktioniert auch dann, wenn ein Blue Team versehentlich die Netzwerkkarte deaktiviert hat.

## Windows-VMs richtig anlegen

Windows stellt die meisten Anforderungen an die virtuelle Hardware. Eine falsch angelegte Windows-VM ist langsam, lässt sich nicht als Template verwenden oder bootet nach einem Update nicht mehr. Die folgenden Einstellungen haben sich für Ranges bewährt.

| **Einstellung** | **Wert** | **Erklärung** |
|---|---|---|
| **Maschinentyp** | q35 | moderner Chipsatz mit PCIe; Voraussetzung für viele aktuelle Funktionen |
| **Firmware** | OVMF (UEFI) mit EFI-Disk, vorab eingeschriebene Secure-Boot-Schlüssel | Windows 11 verlangt UEFI und Secure Boot |
| **TPM** | vTPM 2.0 (eigene kleine Disk) | Pflicht für Windows 11, nützlich für BitLocker-Szenarien |
| **Disk-Controller** | VirtIO SCSI single, Disk mit `discard`, `iothread` | schnell; der Treiber muss bei der Installation geladen werden |
| **Netzwerkkarte** | VirtIO | schnellster Typ; Treiber aus der virtio-win-ISO |
| **CPU-Typ** | host bzw. einheitliches Modell im Cluster | volle Befehlssätze; im Cluster Migrationsfähigkeit beachten |
| **Zweites CD-Laufwerk** | virtio-win.iso | enthält Speicher-, Netz-, Ballooning-Treiber und den Gast-Agenten |
| **Gast-Agent** | aktiviert (`agent: 1`) und im Gast installiert | saubere Snapshots, Befehle ohne Netzwerk, IP-Anzeige |

Tabelle 28: Empfohlene Einstellungen für Windows-VMs

Die Installation selbst wird nicht von Hand durchgeführt, sondern von Packer automatisiert. Die folgende Abbildung zeigt, was dabei Schritt für Schritt geschieht.

![Abbildung 10: Automatischer Bau eines Windows-Templates mit Packer](asset:cyberrange/cr-04-010.png)

**So liest man die Abbildung:**

- Packer legt über die **Proxmox-API** eine neue VM mit den oben genannten Einstellungen an und hängt drei Medien ein: Windows-ISO, VirtIO-Treiber-ISO und ein kleines Laufwerk mit der **autounattend.xml**.
- Windows-Setup findet die Antwortdatei automatisch, lädt den VirtIO-Speichertreiber, partitioniert die Disk und legt das Administratorkonto an – ganz ohne Eingabe.
- Ein Skript aus der Antwortdatei aktiviert **WinRM**; darüber verbindet sich Packer und installiert Updates, Gast-Agent, Sysmon und die Grundhärtung.
- Zum Schluss wird Windows mit **Sysprep** verallgemeinert und heruntergefahren. Packer wandelt die VM in ein **Template** um, aus dem beliebig viele Linked Clones entstehen.
> [!WARNUNG] Häufigster Stolperstein
> Wenn Windows-Setup »keine Laufwerke gefunden« meldet, fehlt der VirtIO-SCSI-Treiber. In der Antwortdatei muss im Abschnitt `windowsPE` unter `DriverPaths` der passende Ordner der virtio-win-ISO stehen (z. B. `vioscsi\2k22\amd64`). Die Laufwerksbuchstaben der eingehängten ISOs können je nach Reihenfolge variieren – Skripte sollten sie deshalb suchen statt fest annehmen.

## Linux-VMs mit cloud-init

Linux-VMs werden in der Range aus einem Template erzeugt, das cloud-init enthält. Beim ersten Start liest cloud-init seine Konfiguration von einem kleinen virtuellen Laufwerk, das Proxmox bereitstellt (Datenquelle NoCloud), und richtet die VM ein: Hostname, Benutzer, SSH-Schlüssel, Netzwerk, Paketquellen.

![Abbildung 11: Die vier Phasen von cloud-init beim ersten Start](asset:cyberrange/cr-04-011.png)

**So liest man die Abbildung:**

- **init-local** läuft, bevor das Netz verfügbar ist: cloud-init sucht die Datenquelle und schreibt die Netzwerkkonfiguration.
- **init (network)** setzt Hostname, legt Benutzer an und hinterlegt SSH-Schlüssel.
- **modules-config** schreibt Konfigurationen wie Paketquellen, Zeitzone und NTP.
- **modules-final** installiert Pakete und führt eigene Befehle aus. Danach meldet cloud-init »fertig« – erst jetzt sollte Ansible übernehmen.
**user-data für web01 (Beispiel)**

```
#cloud-config
hostname: web01
fqdn: web01.nordwind.lab
timezone: Europe/Berlin
users:
  - name: ansible
    groups: [sudo]
    shell: /bin/bash
    sudo: "ALL=(ALL) NOPASSWD:ALL"
    ssh_authorized_keys:
      - ssh-ed25519 AAAAC3Nza...ersetzt... ansible@iac-01
apt:
  primary:
    - arches: [default]
      uri: http://10.99.0.30/mirror/ubuntu      # lokaler Spiegel auf iac-01 – kein Internet
ntp:
  enabled: true
  servers: [10.10.20.1]                          # OPNsense im eigenen VLAN
package_update: true
packages: [qemu-guest-agent, chrony]
runcmd:
  - systemctl enable --now qemu-guest-agent
```

**cloud-init-Daten in Proxmox setzen**

```
# Eigene user-data als »Snippet« ablegen und der VM zuweisen
cp web01-user.yaml /var/lib/vz/snippets/
qm set 120 --cicustom "user=local:snippets/web01-user.yaml"
qm set 120 --ipconfig0 ip=10.10.20.10/24,gw=10.10.20.1 --nameserver 10.10.20.1
qm cloudinit dump 120 user          # erzeugte Konfiguration zur Kontrolle anzeigen
```

## Container oder VM?

Proxmox kann neben VMs auch LXC-Container betreiben. Container teilen sich den Kernel des Hosts, starten in Sekunden und brauchen kaum Speicher. Für eine Range ist das verlockend – aber nicht für jede Aufgabe geeignet.

| **Kriterium** | **VM (KVM)** | **Container (LXC)** |
|---|---|---|
| **Isolation** | stark: eigener Kernel, Hardware-Virtualisierung | schwächer: gemeinsamer Host-Kernel |
| **Betriebssysteme** | beliebig (Windows, Linux, BSD) | nur Linux |
| **Ressourcenbedarf** | höher | sehr gering |
| **Startzeit** | Sekunden bis Minuten | Sekunden |
| **Eignung für Angreifer- oder Opfersysteme** | **ja** – Teilnehmer dürfen root werden | **nein** – Kernel-Ausbruch würde den Host gefährden |
| **Eignung für SINET-Kulissen** | ja | ja, gut geeignet (Webseiten, DNS, Mail) |
| **Eignung für Betriebsdienste** | ja | eingeschränkt (z. B. kleine Hilfsdienste) |

Tabelle 29: VM oder Container – Entscheidungshilfe

> [!GEFAHR] Faustregel
> Überall dort, wo Teilnehmer **Administratorrechte erlangen können oder sollen**, kommt eine VM zum Einsatz. Container sind nur für Kulissen erlaubt, mit denen Teilnehmer nicht interaktiv arbeiten.
