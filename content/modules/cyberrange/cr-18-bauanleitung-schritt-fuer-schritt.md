---
id: cr-18
title: Bauanleitung Schritt für Schritt
paths: cyberrange
order: 18
difficulty: medium
icon: hammer
summary: Kapitel 18 deiner Cyber-Range-Dokumentation: Bauanleitung Schritt für Schritt.
source: Cyber_Range_Dokumentation.docx
htb: 
---

## Überblick

Die Bauanleitung folgt dem Schichtenmodell von unten nach oben. Jeder Schritt endet mit einem **Prüfkriterium**. Befehle sind Beispiele und vor der Ausführung an die konkrete Umgebung und die aktuelle Herstellerdokumentation anzupassen; Platzhalter stehen in spitzen Klammern.

## Phase A – Hardware und UEFI

1. Virtualisierung (Intel VT-x / AMD SVM) und IOMMU (VT-d / AMD-Vi) im UEFI aktivieren.
1. RAM-Test (memtest86+) über mehrere Durchläufe.
1. Firmware von Mainboard, NVMe und NICs aktualisieren; Netzwerkports beschriften (MGMT / SVC / MIRROR).
1. IPMI/AMT mit eigenem Passwort einrichten und nur im MGMT-Netz erreichbar machen.
1. **Prüfkriterium:** `/proc/cpuinfo` enthält `vmx` bzw. `svm`; alle NICs zeigen Link.
## Phase B – Proxmox VE installieren und härten

1. Proxmox VE 9.x (Debian 13 »Trixie«) installieren; auf range-01 Dateisystem **ZFS (RAID1)** über beide NVMe.
1. Paketquellen einrichten (Abo-Repository oder »no-subscription«) und aktualisieren.
1. Admin-Konten mit **TOTP/WebAuthn** anlegen; root-SSH nur mit Schlüssel.
1. API-Benutzer und -Token für die Automatisierung mit minimalen Rechten anlegen.
1. Datacenter-Firewall aktivieren: 8006/22 nur aus dem Admin-Netz.
1. ZFS-ARC begrenzen, NTP prüfen (chrony), E-Mail-Benachrichtigung einrichten.
**Proxmox-Grundeinrichtung (Beispiele)**

```
# Paketquelle »no-subscription« (deb822-Format ab Proxmox VE 9; Inhalt laut Proxmox-Doku prüfen)
cat > /etc/apt/sources.list.d/proxmox.sources <<'EOF'
Types: deb
URIs: http://download.proxmox.com/debian/pve
Suites: trixie
Components: pve-no-subscription
Signed-By: /usr/share/keyrings/proxmox-archive-keyring.gpg
EOF
apt update && apt full-upgrade -y

# API-Benutzer, Rolle und Token für OpenTofu/Packer
pveum user add iac@pve --comment "IaC-Automatisierung"
pveum role add IaC --privs "Datastore.AllocateSpace Datastore.Audit Pool.Allocate Sys.Audit Sys.Console Sys.Modify \
  VM.Allocate VM.Audit VM.Clone VM.Config.CDROM VM.Config.Cloudinit VM.Config.CPU VM.Config.Disk \
  VM.Config.HWType VM.Config.Memory VM.Config.Network VM.Config.Options VM.PowerMgmt SDN.Use"
pveum acl modify / --users iac@pve --roles IaC
pveum user token add iac@pve tofu --privsep 0      # gibt Token-ID und Geheimnis EINMALIG aus

# ZFS-ARC auf 16 GiB begrenzen
echo "options zfs zfs_arc_max=17179869184" > /etc/modprobe.d/zfs.conf && update-initramfs -u
```

**Prüfkriterium:** Weboberfläche unter https://10.0.0.11:8006 erreichbar, 2FA erzwungen, `pveversion` zeigt 9.x, Token funktioniert (`curl` aus Kapitel 14.2).

## Phase C – Netzwerk und OPNsense

1. Bridges gemäß Kapitel 17.3 eintragen und mit `ifreload -a` aktivieren.
1. OPNsense-ISO hochladen, VM anlegen (2 vCPU, 4 GB, 32 GB, VirtIO-NICs: net0 = vmbr1 ohne Tag, net1 = vmbr2) und installieren.
1. In OPNsense unter **Interfaces → Other Types → VLAN** die VLAN-Geräte 10/20/30/40/50/90 auf dem Trunk-Interface (vtnet0) anlegen.
1. Unter **Interfaces → Assignments** zuweisen, IP-Adressen gemäß Kapitel 5.3 vergeben (jeweils .1/24), Interfaces aktivieren.
1. Unbound als Resolver konfigurieren; Weiterleitung an den SINET-Root-DNS 10.10.40.53 statt ins Internet.
1. Firewall-Regeln gemäß Kapitel 5.5 je Interface anlegen; jede Regel mit Logging.
1. Unter **System → Settings → Logging → Remote** Syslog an Security Onion bzw. Wazuh senden.
1. Konfiguration exportieren (XML) und im Git-Repository versionieren.

**Prüfkriterium:** Eine Test-VM in VLAN 10 erreicht 10.10.10.1, aber **nicht** 10.0.0.11, nicht das SVC-Netz (außer erlaubte Ports) und nicht das reale Internet.

## Phase D – Templates mit Packer

**Packer-Template (gekürzt)**

```
packer {
  required_plugins {
    proxmox = { source = "github.com/hashicorp/proxmox", version = ">= 1.2.0" }
  }
}
source "proxmox-iso" "ubuntu2404" {
  proxmox_url              = "https://10.0.0.11:8006/api2/json"
  username                 = "iac@pve!tofu"           # API-Token-ID
  token                    = var.pve_token
  insecure_skip_tls_verify = true
  node                     = "range-01"
  vm_id                    = 9001
  template_name            = "tpl-ubuntu-2404"
  cores                    = 2
  memory                   = 2048
  qemu_agent               = true
  cloud_init               = true
  cloud_init_storage_pool  = "local-zfs"
  # ISO-, Disk-, Netzwerk- und boot_command-Angaben je nach Plugin-Version ergänzen
  http_directory           = "http"                   # enthält autoinstall user-data
  ssh_username             = "packer"
  ssh_timeout              = "30m"
}
build {
  sources = ["source.proxmox-iso.ubuntu2404"]
  provisioner "shell" { inline = ["sudo apt-get update", "sudo apt-get -y upgrade", "sudo cloud-init clean"] }
}
```

**Template bauen**

```
packer init packer/ubuntu-2404.pkr.hcl
packer validate -var-file=secrets.pkrvars.hcl packer/ubuntu-2404.pkr.hcl
packer build    -var-file=secrets.pkrvars.hcl packer/ubuntu-2404.pkr.hcl
```

Für Windows liefert `Autounattend.xml` die Antworten der Installation; ein virtuelles CD-Laufwerk enthält die VirtIO-Treiber, damit Windows die VirtIO-Platte überhaupt sieht. Am Ende wird Windows per Sysprep generalisiert. **Prüfkriterium:** Templates 9001–9004 existieren; ein Linked Clone startet in unter 30 Sekunden.

## Phase E – Provisionierung mit OpenTofu

**OpenTofu mit dem Provider bpg/proxmox (Auszug)**

```
terraform {
  required_providers {
    proxmox = { source = "bpg/proxmox" }
  }
}
provider "proxmox" {
  endpoint  = "https://10.0.0.11:8006/"
  api_token = var.pve_api_token          # "iac@pve!tofu=<UUID>"
  insecure  = true
}
resource "proxmox_virtual_environment_vm" "web01" {
  name      = "dmz-web01"
  node_name = "range-01"
  vm_id     = 120
  tags      = ["dmz", "team1"]
  clone {
    vm_id = 9001
    full  = false                        # Linked Clone
  }
  agent {
    enabled = true
  }
  cpu {
    cores = 2
  }
  memory {
    dedicated = 2048
  }
  network_device {
    bridge  = "vmbr1"
    vlan_id = 20
  }
  initialization {
    ip_config {
      ipv4 {
        address = "10.10.20.10/24"
        gateway = "10.10.20.1"
      }
    }
  }
}
```

**Range provisionieren**

```
cd tofu/envs/pilot
tofu init
tofu plan  -out range.plan        # zeigt, was angelegt/geändert/gelöscht wird
tofu apply range.plan
tofu output                       # IP-Adressen für das Ansible-Inventar
```

Die Range wird als **Modul** beschrieben, sodass weitere Teams durch einen Zähler (`count`/`for_each`) entstehen. **Prüfkriterium:** `tofu apply` erzeugt alle VMs fehlerfrei; `tofu destroy` entfernt sie vollständig.

## Phase F – Konfiguration mit Ansible

**Ansible-Inventar und Playbook-Struktur**

```
# inventory/range.yml
all:
  children:
    windows:
      hosts:
        dc01: { ansible_host: 10.10.30.10 }
        fs01: { ansible_host: 10.10.30.20 }
      vars:
        ansible_connection: winrm
        ansible_port: 5986
        ansible_winrm_transport: ntlm
        ansible_winrm_server_cert_validation: ignore
    linux:
      hosts:
        web01: { ansible_host: 10.10.20.10 }
      vars:
        ansible_user: ansible

# site.yml – Reihenfolge der Rollen
- hosts: dc01
  roles: [ad_forest, ad_users_synthetic, ad_vulns_kerberoast]
- hosts: windows
  roles: [domain_join, sysmon, wazuh_agent, ghosts_client]
- hosts: linux
  roles: [hardening_baseline, nginx_shop, wazuh_agent]
```

**Konfiguration ausführen**

```
ansible-galaxy collection install microsoft.ad ansible.windows community.general
ansible-playbook -i inventory/range.yml site.yml --ask-vault-pass
ansible-playbook -i inventory/range.yml site.yml --ask-vault-pass   # 2. Lauf: changed=0 erwartet
```

## Phase G – Monitoring

1. Security-Onion-3-ISO auf ops-01 als VM installieren (8 vCPU, 32 GB, 500 GB+); im Setup »Standalone« wählen, Management-Interface = net0 (10.99.0.11), Sniff-Interface = net1 (vmbr3).
1. Wazuh All-in-One auf wazuh-01 installieren (Installationsassistent des Herstellers, Version 4.14.x).
1. Agenten per Ansible ausrollen (Beispiele unten); Sysmon-Konfiguration ausrollen.
1. OPNsense-Syslog an die Collector senden; NTP-Quelle für alle Systeme festlegen.
**Wazuh installieren (Beispiele nach Herstellerdoku)**

```
# Wazuh-Server (All-in-One) – Installationsassistent, Version an aktuelle 4.14.x anpassen
curl -sO https://packages.wazuh.com/4.14/wazuh-install.sh && sudo bash ./wazuh-install.sh -a

# Windows-Agent (z. B. aus einer Ansible-Aufgabe heraus)
msiexec.exe /i wazuh-agent.msi /q WAZUH_MANAGER="10.99.0.10" WAZUH_REGISTRATION_SERVER="10.99.0.10" WAZUH_AGENT_GROUP="windows"

# Linux-Agent (Debian/Ubuntu, nach Einbinden des Wazuh-Repositorys)
sudo WAZUH_MANAGER="10.99.0.10" apt-get install -y wazuh-agent && sudo systemctl enable --now wazuh-agent
```

**Prüfkriterium:** `nmap -sS` von kali01 auf 10.10.20.0/24 erzeugt innerhalb einer Minute Zeek-Einträge mit `conn_state=S0/REJ` und Suricata-Alarme; ein fehlgeschlagener RDP-Login erzeugt Event 4625 im SIEM.

## Phase H – Zugang, Portal und Scoring

**Zugangsschicht als Docker-Compose (Struktur)**

```
# docker-compose.yml auf access-01 (vereinfacht; Images und Variablen laut Guacamole-/Keycloak-Doku prüfen)
services:
  keycloak:
    image: quay.io/keycloak/keycloak:<version>
    command: start --hostname=https://sso.range.lab --http-enabled=true
    environment:
      KC_BOOTSTRAP_ADMIN_USERNAME: admin
      KC_BOOTSTRAP_ADMIN_PASSWORD: ${KC_ADMIN_PW}
      KC_DB: postgres
      KC_DB_URL: jdbc:postgresql://db/keycloak
  guacd:
    image: guacamole/guacd:<version>
  guacamole:
    image: guacamole/guacamole:<version>
    environment:
      GUACD_HOSTNAME: guacd
      POSTGRESQL_HOSTNAME: db
      OPENID_AUTHORIZATION_ENDPOINT: https://sso.range.lab/realms/range/protocol/openid-connect/auth
      OPENID_JWKS_ENDPOINT: https://sso.range.lab/realms/range/protocol/openid-connect/certs
      OPENID_ISSUER: https://sso.range.lab/realms/range
      OPENID_CLIENT_ID: guacamole
      OPENID_REDIRECT_URI: https://range.lab/guacamole/
  db:
    image: postgres:<version>
  proxy:
    image: nginx:<version>      # TLS-Terminierung auf 443
```

1. Keycloak: Realm »range«, Client »guacamole« (OpenID Connect), Gruppen `red`, `blue-1`, `white`, `green`, TOTP erzwingen.
1. Guacamole: Verbindungen je Gruppe anlegen, Sitzungsaufzeichnung aktivieren.
1. CTFd mit Aufgaben/Flaggen des Szenarios; Scoring-Engine mit Service-Checks (Kapitel 21).
1. **Prüfkriterium:** Ein Testbenutzer jeder Gruppe sieht ausschließlich die vorgesehenen Systeme.
## Phase I – Test und Abnahme

| **Test** | **Erwartung** | **Ergebnis** |
|---|---|---|
| **Egress-Test aus jeder Zone (curl auf reale Domain, ping 8.8.8.8, DNS gegen 1.1.1.1)** | Alles scheitert bzw. landet im SINET | ☐ |
| **Zugriff aus der Range auf 10.0.0.0/24 und Proxmox 8006** | Blockiert und protokolliert | ☐ |
| **Mirror: tcpdump auf ops-01 sieht VLAN-getaggten Verkehr** | Ja, alle gerouteten VLANs | ☐ |
| **Agenten aller VMs im SIEM aktiv** | 100 % | ☐ |
| **Reset: Rollback aller Snapshots** | < 10 Minuten, Dienste wieder grün | ☐ |
| **Rebuild: destroy + apply + Ansible** | < 90 Minuten, identischer Zustand | ☐ |
| **Dry-Run des Szenarios durch Green + Red Team** | Alle Detektionspunkte auslösbar | ☐ |

Tabelle 121: Abnahmetests

## Den Isolationstest automatisieren

Der wichtigste Abnahmetest – kommt etwas aus der Range heraus? – wird nicht von Hand, sondern per Skript aus **jeder** Zone ausgeführt. Das Skript läuft über `qm guest exec` in einer Test-VM je VLAN und meldet jedes unerwartete Erfolgsergebnis.

**Automatischer Egress- und Isolationstest**

```
#!/usr/bin/env bash
# egress-test.sh – läuft in einer Linux-Test-VM in jeder Zone
# Erwartung: ALLE Versuche schlagen fehl (Timeout/Refused). Jeder Erfolg = FEHLER.
TARGETS=("1.1.1.1:53" "8.8.8.8:443" "10.0.0.11:8006" "10.0.0.12:22" "192.168.1.1:80")
FAIL=0
for t in "${TARGETS[@]}"; do
  host=${t%%:*}; port=${t##*:}
  if timeout 3 bash -c "</dev/tcp/$host/$port" 2>/dev/null; then
    echo "FEHLER: $host:$port erreichbar!"; FAIL=1
  else
    echo "ok: $host:$port gesperrt"
  fi
done
# DNS darf nur SINET-Antworten liefern
dig +short +time=2 www.google.com @10.10.30.1 | grep -qv "^198\.51\.100\." && { echo "FEHLER: echte DNS-Antwort"; FAIL=1; }
exit $FAIL
```

> [!ERGEBNIS] Abnahmeregel
> Der Test läuft vor **jeder** Übung (Pre-Flight-Checkliste) und nach **jeder** Änderung am Netz oder an OPNsense. Ein einziges »FEHLER« blockiert den Übungsstart, bis die Ursache behoben und der Test erneut bestanden ist.

## Vorlage für das Abnahmeprotokoll

| **Nr.** | **Prüfpunkt** | **Methode** | **Ergebnis** | **Datum / Kürzel** |
|---|---|---|---|---|
| **A1** | Beide Hypervisoren erreichbar, 2FA aktiv | Anmeldung über VPN | ☐ bestanden ☐ nicht bestanden |  |
| **A2** | Range vollständig aus Git aufbaubar | Pipeline-Lauf auf leerem System | ☐ / ☐ |  |
| **A3** | Isolationstest aus allen Zonen | egress-test.sh | ☐ / ☐ |  |
| **A4** | Zonenmatrix korrekt | nmap-Matrixscan | ☐ / ☐ |  |
| **A5** | Telemetrie aller VMs im SIEM | Wazuh-Agentenliste, SO-Dashboard | ☐ / ☐ |  |
| **A6** | Mirror liefert Verkehr aller VLANs | Zeek conn.log je Subnetz | ☐ / ☐ |  |
| **A7** | Teilnehmerzugang mit MFA | Testkonto je Team | ☐ / ☐ |  |
| **A8** | Scoring-Checks grün | score-01 Dashboard | ☐ / ☐ |  |
| **A9** | Angriffskette vollständig durchführbar | Caldera-Operation | ☐ / ☐ |  |
| **A10** | Reset auf »clean« in < 15 Minuten | Rollback-Skript mit Zeitmessung | ☐ / ☐ |  |

Tabelle 122: Abnahmeprotokoll (Vorlage)

## Realistischer Zeitbedarf

| **Phase** | **Erfahrenes Team** | **Einsteiger-Team** | **Häufigste Zeitfresser** |
|---|---|---|---|
| **A – Hardware und UEFI** | 0,5 Tage | 1–2 Tage | Lieferzeiten, fehlende Kabel |
| **B – Proxmox und Härtung** | 1 Tag | 2–3 Tage | 2FA, Zertifikate, Repository-Konfiguration |
| **C – Netzwerk und OPNsense** | 2 Tage | 4–5 Tage | VLAN-Fehler, Regelwerk, SINET-DNS |
| **D – Packer-Templates** | 2 Tage | 4–6 Tage | Windows-Unattend, VirtIO-Treiber, WinRM |
| **E – OpenTofu** | 2 Tage | 3–4 Tage | Provider-Rechte, Cloud-Init |
| **F – Ansible** | 5 Tage | 8–12 Tage | AD-Rollen, Idempotenz, Windows-Neustarts |
| **G – Monitoring** | 3 Tage | 5–7 Tage | Mirror, Sensor-Tuning, Agenten-Registrierung |
| **H – Zugang und Scoring** | 2 Tage | 4 Tage | OIDC-Konfiguration, Gruppen-Mapping |
| **I – Test und Abnahme** | 2 Tage | 3–4 Tage | Fehler aus allen vorherigen Phasen |

Tabelle 123: Zeitbedarf nach Erfahrung (Arbeitstage, Richtwerte)
