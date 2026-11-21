---
id: cr-06
title: L3 – Orchestrierung und Automatisierung
paths: cyberrange
order: 6
difficulty: medium
icon: gearshape.2
summary: Kapitel 6 deiner Cyber-Range-Dokumentation: L3 – Orchestrierung und Automatisierung.
source: Cyber_Range_Dokumentation.docx
htb: Cyber Range 06 · L3 Automatisierung
---

## Überblick

Eine Range, die von Hand zusammengeklickt wurde, ist nach wenigen Wochen nicht mehr nachvollziehbar: Niemand weiß genau, welche Einstellung warum gesetzt wurde, und ein Neuaufbau dauert Tage. Deshalb wird die gesamte Range als **Code** beschrieben (IaC – Infrastructure as Code). Alle untersuchten Plattformen – von KYPO bis Ludus – arbeiten so.

## Die Pipeline im Überblick

![Abbildung 19: Infrastructure-as-Code-Pipeline vom Git-Commit zur übungsbereiten Range](asset:cyberrange/cr-06-019.png)

**So liest man die Abbildung:**

- Jede Änderung beginnt mit einem **Commit** im Git-Repository (Gitea). Ein **CI-Runner** prüft die Dateien automatisch auf Syntaxfehler.
- **Packer** baut aus Installations-ISOs die Templates (nur bei Änderungen am Betriebssystem nötig).
- **OpenTofu/Terraform** erzeugt aus den Templates die VMs und Netze – das »Skelett« der Range.
- **Ansible** füllt das Skelett: Domäne, Benutzer, Dienste, Schwachstellen, Agenten.
- **Validierung** prüft Isolation, Dienste und Telemetrie; erst dann wird der Snapshot »clean« gesetzt.
- Der **rote Pfeil** ist die Reset-Schleife nach jeder Übung.
## Aufbau des Git-Repositorys

**Struktur des IaC-Repositorys**

```
cyber-range/
├── README.md                    # Einstieg, Konventionen
├── docs/                        # diese Dokumentation, Netzpläne, Runbooks
├── packer/
│   ├── ubuntu-2404.pkr.hcl      # Linux-Template
│   ├── win2022.pkr.hcl          # Windows-Server-Template
│   ├── win11.pkr.hcl
│   └── http/ + answer_files/    # autoinstall user-data, Autounattend.xml
├── tofu/
│   ├── providers.tf             # bpg/proxmox, Backend
│   ├── modules/
│   │   ├── corp-net/            # AD-Netz eines Teams (DC, FS, WS)
│   │   ├── dmz/                 # Web, Mail
│   │   └── sinet/               # simuliertes Internet
│   └── envs/pilot/main.tf       # setzt Module für Team 1 (und 2) zusammen
├── ansible/
│   ├── inventory/range.yml
│   ├── site.yml                 # Reihenfolge aller Rollen
│   └── roles/                   # ad_forest, sysmon, wazuh_agent, vuln_*, ghosts_client …
├── scenarios/nordlicht/         # MSEL, Injects, Lernziele, Bewertungsrubriken
└── tests/                       # Egress-, Service-, Telemetrie-Tests
```

## Packer: Golden Images bauen

Packer startet über die Proxmox-API eine temporäre VM mit der Installations-ISO, beantwortet die Installationsfragen automatisch (Linux: autoinstall/Preseed, Windows: `Autounattend.xml`), verbindet sich nach dem ersten Start per SSH bzw. WinRM, führt Skripte aus (Updates, VirtIO-Treiber, Guest Agent, Sysmon) und wandelt die VM in ein Template um. Für die Antwortdateien startet Packer einen kleinen HTTP-Server (Standard-Portbereich 8000–9000), von dem der Installer liest.

| **Template** | **VMID** | **Inhalt** | **Besonderheiten** |
|---|---|---|---|
| **tpl-ubuntu-2404** | 9001 | Ubuntu Server 24.04, cloud-init, Guest Agent | Basis für Web, Mail, SINET, GHOSTS |
| **tpl-win2022** | 9002 | Windows Server 2022 Eval, VirtIO, Guest Agent, Sysmon | sysprep-fähig, Evaluierung 180 Tage |
| **tpl-win11** | 9003 | Windows 11 Enterprise Eval, TPM, VirtIO | Evaluierung 90 Tage |
| **tpl-kali** | 9004 | Kali Linux (Rolling), Werkzeuge vorinstalliert | Desktop für Guacamole |

Tabelle 41: Templates der Pilot-Range

## OpenTofu/Terraform: Infrastruktur deklarieren

Terraform bzw. die quelloffene Abspaltung OpenTofu arbeiten **deklarativ**: Man beschreibt den gewünschten Endzustand (»es soll eine VM dmz-web01 mit 2 Kernen in VLAN 20 geben«), nicht die Schritte dorthin. Das Werkzeug vergleicht diesen Soll-Zustand mit dem gespeicherten Ist-Zustand (State-Datei) und berechnet einen **Plan** – die minimale Menge an API-Aufrufen, um beides anzugleichen. Die Sprache heißt HCL; die Verbindung zu Proxmox stellt ein Provider her (empfohlen: `bpg/proxmox`).

![Abbildung 20: Ablauf einer Provisionierung zwischen OpenTofu und der Proxmox-API](asset:cyberrange/cr-06-020.png)

**So liest man die Abbildung:**

- Schritt 1: OpenTofu berechnet lokal den Plan. Schritte 2–5: Die API nimmt den Klon-Auftrag an, prüft das API-Token und gibt sofort eine Task-Kennung (UPID) zurück – die eigentliche Arbeit läuft asynchron.
- Schritt 6: OpenTofu fragt den Task-Status ab, bis er fertig ist. Schritte 7–8: Konfiguration setzen und VM starten.
- Schritte 9–12: Die VM bootet, cloud-init setzt Adresse und Schlüssel, der Guest Agent meldet die IP; OpenTofu liest sie und speichert sie im State – Ansible kann übernehmen.
## Ansible: Systeme konfigurieren

Ansible verbindet sich **ohne vorinstallierten Agenten** per SSH (Linux) bzw. WinRM (Windows) mit den VMs und führt Aufgaben aus einem Playbook aus. Aufgaben sind in **Rollen** gebündelt (z. B. »ad_forest« baut eine AD-Gesamtstruktur). Wichtigste Eigenschaft ist Idempotenz: Ein Playbook kann beliebig oft laufen; beim zweiten Mal ändert es nichts mehr, wenn das System bereits im Sollzustand ist.

**Ansible-Rolle für eine absichtliche Schwachstelle (Beispiel)**

```
# ansible/roles/ad_vulns_kerberoast/tasks/main.yml  – absichtliche Schwachstelle, dokumentiert
- name: Dienstkonto mit schwachem Passwort anlegen
  microsoft.ad.user:
    name: svc_sql
    password: "{{ vault_svc_sql_weak_password }}"   # aus Ansible Vault, z. B. ein Wörterbuchwort
    password_never_expires: true
    state: present
- name: SPN setzen (macht das Konto »kerberoastable«)
  ansible.windows.win_command: setspn -S MSSQLSvc/fs01.nordwind.lab:1433 nordwind\svc_sql
  register: spn
  changed_when: "'Updated object' in spn.stdout"
```

## Alternative: Ludus als fertiger Orchestrator

**Ludus** (Bad Sector Labs) bündelt Packer, Ansible und die Proxmox-API in einem Werkzeug. Eine einzige YAML-Datei beschreibt die komplette Range; Ludus erzeugt pro Range einen eigenen Router, eigene VLANs und Adressen nach dem Schema 10.<Range>.<VLAN>.<Host>. Für die Pilotphase wird Ludus parallel evaluiert – passt es, ersetzt es große Teile der eigenen Pipeline.

**Ludus range-config.yml (Beispiel)**

```
# Ausschnitt einer Ludus-Range-Konfiguration (Struktur gemäß Ludus-Doku)
ludus:
  - vm_name: "{{ range_id }}-ad-dc-win2022-server-x64"
    hostname: "{{ range_id }}-DC01"
    template: win2022-server-x64-template
    vlan: 10
    ip_last_octet: 11
    ram_gb: 8
    cpus: 4
    windows:
      sysprep: false
    domain:
      fqdn: nordwind.lab
      role: primary-dc
  - vm_name: "{{ range_id }}-kali"
    hostname: "{{ range_id }}-kali"
    template: kali-x64-desktop-template
    vlan: 99
    ip_last_octet: 1
    ram_gb: 8
    cpus: 4
```

## GitOps: Änderungen nur über Git

In einer reifen Range ändert niemand mehr »schnell mal« etwas in der Proxmox-Oberfläche. Stattdessen gilt das **GitOps-Prinzip**: Der gewünschte Zustand steht im Git-Repository, und eine Pipeline stellt ihn her. Das macht jede Änderung nachvollziehbar, prüfbar und rückgängig machbar.

![Abbildung 21: Der GitOps-Kreislauf vom Branch bis zum automatischen Test](asset:cyberrange/cr-06-021.png)

**So liest man die Abbildung:**

- Eine Änderung beginnt immer auf einem **Branch** und wird per **Pull Request** vorgeschlagen.
- Die Pipeline prüft zuerst Syntax und Stil (Lint), dann zeigt `tofu plan` exakt, welche Ressourcen sich ändern würden.
- Erst nach **Review und Freigabe** wird `tofu apply` ausgeführt, anschließend konfiguriert Ansible die Systeme und automatische **Tests** bestätigen das Ergebnis.
- Schlägt ein Test fehl, geht die Änderung zurück an den Autor (rote Linie). Manuelle Eingriffe auf dem Hypervisor sind nicht vorgesehen.

Gitea bringt mit **Gitea Actions** eine zu GitHub Actions weitgehend kompatible CI-Funktion mit. Die Workflows liegen im Repository unter `.gitea/workflows/`, ausgeführt werden sie von einem separaten Runner-Programm (`act_runner`) auf iac-01.

**Gitea-Actions-Workflow (Beispiel)**

```
# .gitea/workflows/range.yaml
name: range-pipeline
on:
  pull_request:
  push:
    branches: [ main ]
jobs:
  validate:
    runs-on: iac
    steps:
      - uses: actions/checkout@v4
      - run: tofu -chdir=tofu fmt -check && tofu -chdir=tofu init -input=false && tofu -chdir=tofu validate
      - run: ansible-lint ansible/
      - run: tofu -chdir=tofu plan -input=false -out=plan.bin
  deploy:
    if: github.ref == 'refs/heads/main'
    needs: validate
    runs-on: iac
    steps:
      - uses: actions/checkout@v4
      - run: tofu -chdir=tofu init -input=false && tofu -chdir=tofu apply -input=false -auto-approve
      - run: ansible-playbook -i ansible/inventory ansible/site.yml
      - run: goss -g tests/goss.yaml validate --format documentation
```

> [!WARNUNG] Die State-Datei schützen
> Die State-Datei von OpenTofu enthält eine vollständige Liste der Infrastruktur und oft auch Passwörter im Klartext. Sie gehört **nicht** ins Git-Repository, sondern in ein geschütztes Backend (z. B. lokales Verzeichnis auf iac-01 mit Backup oder ein S3-kompatibler Speicher mit Verschlüsselung). OpenTofu unterstützt zusätzlich die clientseitige Verschlüsselung des States.

## Ansible im Detail

Ansible arbeitet **agentenlos**: Es verbindet sich per SSH oder WinRM mit dem Zielsystem, überträgt kleine Programme (Module), führt sie aus und löscht sie wieder. Jedes Modul prüft zuerst den Ist-Zustand und ändert nur, wenn nötig – das ist die Idempotenz.

![Abbildung 22: Arbeitsweise von Ansible vom Inventar bis zur Rückmeldung](asset:cyberrange/cr-06-022.png)

**So liest man die Abbildung:**

- Das **Inventar** listet alle Systeme mit Gruppen und Variablen.
- Ein **Playbook** ordnet Gruppen **Rollen** zu; eine Rolle besteht aus Tasks, Vorlagen, Dateien und Handlern.
- Jeder **Task** ruft ein **Modul** auf, das über SSH (Linux) oder WinRM (Windows) ausgeführt wird.
- Zurück kommen Status (ok / changed / failed) und die gesammelten **Facts**.
**Struktur des Ansible-Verzeichnisses**

```
ansible/
├── inventory/
│   ├── hosts.yml              # statisch, oder dynamisch per Proxmox-Inventory-Plugin
│   └── group_vars/
│       ├── all.yml            # Zeitzone, NTP, Wazuh-Manager-Adresse
│       ├── windows.yml        # ansible_connection: winrm, Port 5986, Zertifikatsprüfung
│       └── vault.yml          # mit Ansible Vault verschlüsselt
├── roles/
│   ├── ad_dc/                 # Domäne nordwind.lab aufsetzen
│   ├── ad_objects/            # OUs, Benutzer, Gruppen, absichtliche Fehlkonfigurationen
│   ├── sysmon/                # Sysmon mit Range-Konfiguration
│   ├── wazuh_agent/           # Agent installieren und registrieren
│   ├── web_shop/              # verwundbare Web-Anwendung in der DMZ
│   └── vulns/                 # Szenario-Schwachstellen (nur im Übungsnetz!)
└── site.yml
```

**Beispiel-Rolle für den Wazuh-Agenten**

```
# roles/wazuh_agent/tasks/main.yml (Auszug, Linux)
- name: Wazuh-Repository-Schlüssel hinterlegen
  ansible.builtin.get_url:
    url: http://iac-01.svc/mirror/wazuh/GPG-KEY-WAZUH       # lokaler Spiegel, kein Internet!
    dest: /usr/share/keyrings/wazuh.asc
- name: Agent installieren
  ansible.builtin.apt:
    name: wazuh-agent
    state: present
  environment:
    WAZUH_MANAGER: "10.99.0.10"
    WAZUH_AGENT_GROUP: "{{ wazuh_group | default('default') }}"
- name: Agent starten und aktivieren
  ansible.builtin.service:
    name: wazuh-agent
    state: started
    enabled: true
```

> [!INFO] Pakete ohne Internet
> Das Übungsnetz hat keinen Internetzugang. Alle Pakete (apt-Repositories, Windows-Installer, Python-Pakete) kommen deshalb aus einem **lokalen Spiegel** auf iac-01, der vor der Übung über die Control Plane befüllt wird (z. B. mit `apt-mirror` oder `aptly`).

## Infrastruktur testen

»Es läuft« ist keine Abnahme. Nach jedem Aufbau prüfen automatische Tests, ob die Range dem Soll entspricht. Das leichtgewichtige Werkzeug Goss beschreibt Erwartungen in YAML und liefert in Sekunden ein Ergebnis:

**Goss-Test (Auszug)**

```
# tests/goss.yaml – läuft auf web01 nach dem Ansible-Lauf
port:
  tcp:443:
    listening: true
service:
  nginx:   { enabled: true, running: true }
  wazuh-agent: { enabled: true, running: true }
http:
  https://localhost/:
    status: 200
    allow-insecure: true
    body: [ "Nordwind Shop" ]
command:
  "curl -s -m 3 https://example.com":
    exit-status: 28        # Erwartet: Timeout – kein Weg ins echte Internet!
```

| **Testebene** | **Frage** | **Werkzeug** |
|---|---|---|
| **Syntax** | Ist der Code gültig? | tofu validate, ansible-lint, yamllint |
| **Plan** | Was würde sich ändern? | tofu plan (im Pull Request sichtbar) |
| **Host** | Laufen Dienste, sind Ports offen? | Goss, Testinfra |
| **Netz** | Stimmt die Zonenmatrix? | nmap-Skript aus jeder Zone gegen jede Zone |
| **Isolation** | Kommt etwas nach draußen? | Egress-Test (Kapitel 18.9) |
| **Szenario** | Funktioniert die Angriffskette? | Caldera-Operation im Dry-Run |

Tabelle 42: Testpyramide der Range

## Geheimnisse verwalten

Eine Range enthält zwangsläufig viele Passwörter: Domänen-Admin, Dienstkonten, API-Token, Datenbankzugänge. Zwei Arten müssen unterschieden werden:

| **Art** | **Beispiele** | **Behandlung** |
|---|---|---|
| **Betriebsgeheimnisse** | Proxmox-API-Token, Keycloak-Admin, Wazuh-API, Backup-Schlüssel | Ansible Vault oder SOPS, nie im Klartext im Repository, regelmäßige Rotation |
| **Szenario-»Geheimnisse«** | absichtlich schwache Passwörter, Flaggen, Honeytokens | dürfen im Szenario-Repository stehen, aber nur in der Übungsumgebung gelten |

Tabelle 43: Zwei Arten von Geheimnissen

> [!GEFAHR] Niemals Szenario-Passwörter in der Infrastruktur verwenden
> Ein im Szenario absichtlich schwaches Passwort (z. B. `Sommer2026!`) darf nirgends sonst auftauchen – weder bei Proxmox noch bei Keycloak noch auf ops-01. Teilnehmer lernen diese Passwörter; sie dürfen nie zu einem Weg aus der Range werden.

## OpenTofu-Module im Detail

Der OpenTofu-Code der Range ist in **Module** gegliedert. Ein Modul ist ein wiederverwendbarer Baustein mit Eingaben und Ausgaben – ähnlich einer Funktion in einer Programmiersprache. Die Range besteht aus vier Modulen, die in einer festen Reihenfolge voneinander abhängen.

![Abbildung 23: Wurzelmodul, Module und Abhängigkeiten des OpenTofu-Codes](asset:cyberrange/cr-06-023.png)

**So liest man die Abbildung:**

- Das **Wurzelmodul** enthält nur den Provider, die Variablen und die Aufrufe der vier Module.
- Die **Abhängigkeiten** (rote Pfeile) erzwingen die Reihenfolge: erst Netz, dann Firewall, dann die VMs, zuletzt das Ansible-Inventar.
- Alle VMs werden in **einer** Variable beschrieben (links unten). Das Modul `vm` erzeugt daraus mit **for_each** beliebig viele VMs.
- Die **Ausgaben** (rechts unten) – IP-Adressen, VMIDs – werden von Ansible, Guacamole und dem Scoring weiterverwendet.
**Ausschnitt aus Variablen, Modul und Ausgaben**

```
# variables.tf – Beschreibung aller VMs in einer Tabelle
variable "vms" {
  type = map(object({
    vmid = number, tpl = number, vlan = number,
    ip = string,   cpu = number, ram = number, tags = list(string)
  }))
}

# modules/vm/main.tf – eine Ressource, beliebig viele VMs
resource "proxmox_virtual_environment_vm" "this" {
  for_each  = var.vms
  name      = "t${var.team}-${each.key}"
  vm_id     = var.team * 1000 + each.value.vmid
  node_name = var.node
  tags      = concat(["team${var.team}"], each.value.tags)
  clone { vm_id = each.value.tpl, full = false }
  cpu    { cores = each.value.cpu, type = "host" }
  memory { dedicated = each.value.ram, floating = floor(each.value.ram * 0.7) }
  network_device { bridge = "vmbr1", vlan_id = each.value.vlan, model = "virtio" }
  agent  { enabled = true }
}

# outputs.tf – Ergebnisse für nachfolgende Werkzeuge
output "inventory" {
  value = { for k, v in proxmox_virtual_environment_vm.this : k => {
    vmid = v.vm_id, ip = var.vms[k].ip } }
}
```

> [!INFO] Zum Lesen des Codes
> `map(object({...}))` beschreibt eine Tabelle: Schlüssel ist der Hostname, Wert ein Objekt mit allen Eigenschaften.
> `for_each = var.vms` erzeugt für jeden Eintrag eine VM; `each.key` ist der Hostname, `each.value` sind die Eigenschaften.
> `vm_id = var.team * 1000 + each.value.vmid` setzt das Nummernschema aus Kapitel 2.8 um (Team 1 nutzt im Pilot die Basisnummern ohne Aufschlag, wenn `team = 0` gesetzt wird).
> `floating` ist das Ballooning-Minimum: 70 % des zugewiesenen Speichers.

## Den Windows-Bau mit Packer beschreiben

Der Ablauf aus Abbildung 68 wird in einer Packer-Konfiguration (HCL) beschrieben. Die genaue Syntax hängt von der Version des Proxmox-Plugins ab – neuere Versionen fassen ISO-Angaben in eigenen Blöcken zusammen. Das Prinzip bleibt gleich:

**Packer-Konfiguration für das Windows-Server-Template (Prinzip)**

```
packer {
  required_plugins {
    proxmox = { source = "github.com/hashicorp/proxmox", version = ">= 1.2.0" }
  }
}

source "proxmox-iso" "win2022" {
  proxmox_url  = "https://10.0.0.11:8006/api2/json"
  username     = "iac@pve!packer"          # API-Token, kein Passwort
  token        = var.pve_token
  node         = "range-01"
  vm_id        = 9002
  template_name = "tpl-win2022"
  machine = "q35"
  bios    = "ovmf"
  efi_config { efi_storage_pool = "local-zfs", efi_type = "4m", pre_enrolled_keys = true }
  scsi_controller = "virtio-scsi-single"
  disks { type = "scsi", disk_size = "60G", storage_pool = "local-zfs", io_thread = true, discard = true }
  network_adapters { model = "virtio", bridge = "vmbr2" }   # Build-Netz (SVC)
  cores = 2
  memory = 4096
  # Windows-ISO, virtio-win-ISO und ein CD-Laufwerk mit autounattend.xml + Skripten
  # (Blocknamen je nach Plugin-Version: boot_iso / additional_iso_files mit cd_files)
  communicator   = "winrm"
  winrm_username = "Administrator"
  winrm_password = var.build_password
  winrm_use_ssl  = true
  winrm_insecure = true
  winrm_timeout  = "2h"
}

build {
  sources = ["source.proxmox-iso.win2022"]
  provisioner "powershell" { scripts = ["scripts/guest-tools.ps1", "scripts/sysmon.ps1", "scripts/baseline.ps1"] }
  provisioner "windows-restart" {}
  provisioner "powershell" { script = "scripts/sysprep.ps1" }   # Verallgemeinern als letzter Schritt
}
```

## Drift erkennen und vermeiden

**Drift** entsteht, wenn jemand die Infrastruktur an der Pipeline vorbei ändert – etwa eine Firewall-Regel »nur kurz« in der Oberfläche anlegt. Danach stimmt der Code nicht mehr mit der Wirklichkeit überein, und der nächste Neuaufbau verhält sich anders als erwartet.

| **Werkzeug** | **Erkennt Drift bei** | **Vorgehen** |
|---|---|---|
| `tofu plan` | VMs, Netzen, Ressourcen der Proxmox-API | nächtlicher Plan-Lauf; jede Abweichung erzeugt ein Ticket |
| `ansible-playbook --check --diff` | Konfiguration in den VMs | Trockenlauf zeigt, was Ansible ändern würde |
| **Git-Vergleich der OPNsense-**`config.xml` | Firewall-Regeln | exportierte Datei mit der Version im Repository vergleichen |
| **Goss-Tests** | Diensten und Ports | regelmäßiger Testlauf (Kapitel 6.9) |

Tabelle 44: Drift-Erkennung

> [!TIPP] Die Notfall-Ausnahme
> Muss während einer Übung doch etwas von Hand geändert werden (z. B. eine fehlende Regel), wird die Änderung sofort im Betriebsprotokoll vermerkt und **noch am selben Tag** als Pull Request nachgezogen. Erst dann gilt die Übung als sauber abgeschlossen.
