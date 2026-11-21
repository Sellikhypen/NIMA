---
id: f-11
title: Virtualisierung, Container und Cloud
paths: grundlagen, specialist, cyberrange
order: 11
difficulty: medium
icon: cloud
summary: Hypervisoren, virtuelle Maschinen, Container, Kubernetes und die Cloud-Servicemodelle – mit dem Modell der geteilten Verantwortung und den typischen Fehlkonfigurationen.
---

## Virtualisierung

Ein **[[Hypervisor]]** teilt die Hardware eines Rechners in mehrere voneinander isolierte **virtuelle Maschinen (VMs)**.

| Typ | Beschreibung | Beispiele |
|---|---|---|
| Typ 1 (bare metal) | läuft direkt auf der Hardware | VMware ESXi, Proxmox VE (KVM), Hyper-V |
| Typ 2 (hosted) | läuft als Programm auf einem Betriebssystem | VirtualBox, VMware Workstation |

Vorteile: bessere Auslastung, Snapshots, schnelle Bereitstellung, Isolation – genau deshalb basiert auch deine [[mod:cr-04|Cyber Range]] auf Virtualisierung.

> [!WARNUNG] Isolation hat Grenzen
> VMs sind gut, aber nicht perfekt isoliert. Schwachstellen im Hypervisor („VM Escape“), gemeinsam genutzte Netze und Management-Schnittstellen sind kritische Angriffsflächen. Die Verwaltungsoberfläche eines Hypervisors gehört in ein eigenes, streng abgeschottetes Management-Netz.

## Container

Container (z. B. [[Docker]]) teilen sich den Kernel des Hosts und isolieren Prozesse über Linux-Mechanismen:

- **Namespaces** – eigene Sicht auf Prozesse, Netzwerk, Dateisystem, Benutzer
- **cgroups** – Begrenzung von CPU, RAM, I/O
- **Capabilities, seccomp, AppArmor/SELinux** – Einschränkung erlaubter Systemaufrufe und Rechte

| | VM | Container |
|---|---|---|
| Isolation | eigener Kernel | gemeinsamer Kernel |
| Start | Sekunden bis Minuten | Millisekunden |
| Größe | GB | MB |
| Sicherheitsgrenze | stark | schwächer, hängt von Konfiguration ab |

> [!GEFAHR] Typische Container-Fehler
> Container als root ausführen, `--privileged` setzen, den Docker-Socket in Container mounten, Secrets in Images einbauen, veraltete Basis-Images verwenden. Jeder dieser Punkte kann die Isolation zum Host praktisch aufheben. Mitglieder der Gruppe `docker` haben faktisch Root-Rechte auf dem Host.

## Kubernetes in einem Absatz

Kubernetes orchestriert Container über viele Rechner: **Pods** (kleinste Einheit), **Deployments** (gewünschter Zustand), **Services** (stabile Netzwerkadressen), **Namespaces** (Trennung), **RBAC** (Rechte). Sicherheitsrelevant sind vor allem die API-Server-Absicherung, RBAC-Rechte von Service Accounts, Network Policies und Pod-Security-Standards.

## Cloud-Servicemodelle

| Modell | Kunde verwaltet | Anbieter verwaltet | Beispiele |
|---|---|---|---|
| IaaS | Betriebssystem, Middleware, Anwendung, Daten | Hardware, Netz, Virtualisierung | AWS EC2, Azure VMs |
| PaaS | Anwendung, Daten | zusätzlich Betriebssystem und Laufzeit | App Service, Heroku |
| SaaS | Daten, Benutzer, Konfiguration | fast alles | Microsoft 365, Salesforce |

> [!MERKE] Shared Responsibility Model
> Der Anbieter ist für die Sicherheit **der** Cloud verantwortlich (Rechenzentren, Hardware, Basisdienste), der Kunde für die Sicherheit **in** der Cloud (Konfiguration, Identitäten, Daten). Die meisten Cloud-Vorfälle entstehen auf der Kundenseite.

## Typische Cloud-Risiken

- öffentlich zugängliche Speicher (Buckets, Blob Container)
- zu weit gefasste Berechtigungen im **[[IAM]]** (z. B. Wildcard-Rechte, Admin für Dienste)
- Zugangsschlüssel in Code-Repositories
- fehlendes Logging (CloudTrail, Azure Activity Log) und fehlende Alarmierung
- offene Management-Ports in Sicherheitsgruppen
- ungeschützte Metadaten-Dienste von VMs, die temporäre Zugangsdaten liefern

> [!TIPP] Prüfen mit Werkzeugen
> Cloud-Konfigurationen werden mit Werkzeugen wie ScoutSuite, Prowler oder den nativen Security-Centern der Anbieter gegen Best Practices (z. B. CIS Benchmarks) geprüft.

## Quiz

? Welcher Hypervisor-Typ läuft direkt auf der Hardware?
= Typ 1
= 1
= bare metal

? Was teilen sich Container mit dem Host?
+ den Kernel
- die BIOS-Einstellungen
- nichts
- die Festplatte immer komplett

? Welche Linux-Mechanismen isolieren Container?
+ Namespaces
+ cgroups
- Registry
- NTFS

? Bei welchem Cloud-Modell verwaltet der Kunde das Betriebssystem selbst?
= IaaS

? Wer ist im Shared Responsibility Model für die Konfiguration der Cloud-Ressourcen verantwortlich?
+ der Kunde
- der Anbieter
- niemand
- der Hardware-Hersteller

?tf Mitglieder der Gruppe docker haben faktisch Root-Rechte auf dem Host.
= wahr

? Wie heißt die kleinste Einheit in Kubernetes?
= Pod

? Welche Abkürzung steht für das Identitäts- und Rechtemanagement in der Cloud?
= IAM
