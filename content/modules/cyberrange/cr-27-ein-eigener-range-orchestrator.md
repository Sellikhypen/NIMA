---
id: cr-27
title: Ein eigener Range-Orchestrator
paths: cyberrange
order: 27
difficulty: hard
icon: slider.horizontal.3
summary: Kapitel 27 deiner Cyber-Range-Dokumentation: Ein eigener Range-Orchestrator.
source: Cyber_Range_Dokumentation.docx
htb: 
---

## Überblick

Mit OpenTofu und Ansible lässt sich **eine** Range gut verwalten. Sobald aber regelmäßig viele gleichartige Umgebungen für wechselnde Teilnehmer bereitgestellt werden sollen, lohnt sich eine Steuerungsschicht darüber: ein **Orchestrator** mit Portal. Große Plattformen wie KYPO CRP zeigen, wie das aussieht; dieses Kapitel beschreibt eine vereinfachte Fassung für Proxmox.

## Architektur

![Abbildung 71: Architektur eines eigenen Range-Orchestrators](asset:cyberrange/cr-27-071.png)

**So liest man die Abbildung:**

- Trainer und Teilnehmer arbeiten im **Web-Frontend**; jede Aktion wird an die **Range-API** gesendet (REST/JSON, Anmeldung über Keycloak).
- Langlaufende Aufgaben (»Sandbox aufbauen«) landen in einer **Job-Queue** und werden von **Workern** abgearbeitet, die OpenTofu und Ansible ausführen.
- Die **Datenbank** speichert Definitionen und Zustände; die **Sandbox-Definitionen** selbst liegen in Git.
- Statusmeldungen laufen über einen **Event-Bus** zurück ins Frontend (live per WebSocket) sowie in SIEM und Monitoring.
## Begriffe und Datenmodell

| **Begriff** | **Bedeutung** | **Beispiel** |
|---|---|---|
| **Sandbox-Definition** | Git-Repository mit Topologie, Variablen und Provisionierung | nordlicht-mini v1.3 |
| **Pool** | Menge gleichartiger, vorab erzeugter Sandboxes einer Definition | Pool »Kurs 12/2026«, Größe 8 |
| **Sandbox** | eine konkrete, laufende Instanz mit eigenen VMs und Netzen | Sandbox 17 (Team 3) |
| **Allokation** | Zuordnung einer Sandbox zu einem Teilnehmer oder Team | Sandbox 17 → blue-team-3 |
| **Zustand** | aktueller Lebenszyklus-Status (siehe Kapitel 13.3) | BUILDING, READY, IN_USE, RESETTING, FAILED |

Tabelle 164: Datenmodell des Orchestrators

## Topologie als Datei

Kern des Ansatzes ist eine **deklarative Beschreibung** der Topologie. Das Format orientiert sich an KYPO: Hosts, Router, Netze und deren Zuordnungen in einer YAML-Datei. Der Orchestrator prüft die Datei, erzeugt daraus OpenTofu-Variablen und ein Ansible-Inventar.

![Abbildung 72: Von der Topologie-Datei zur Sandbox](asset:cyberrange/cr-27-072.png)

**So liest man die Abbildung:**

- **Links** die Topologie-Datei: Hosts, ein Router, drei Netze mit Adressbereichen und die Zuordnung jedes Hosts zu einem Netz mit fester Adresse.
- **Rechts** der daraus entstehende Graph: Netze als Kreise, der Router in der Mitte, die Hosts außen.
- Bevor etwas gebaut wird, prüft der Orchestrator die **Gültigkeitsregeln**: eindeutige Namen, keine überlappenden Netze, jede Adresse innerhalb ihres Netzes.
| **Prüfregel** | **Warum** |
|---|---|
| **Namen von Hosts, Netzen und Routern sind eindeutig** | Inventar und DNS-Einträge werden daraus erzeugt |
| **Netzbereiche überlappen nicht** | sonst ist Routing nicht eindeutig |
| **Jede zugewiesene Adresse liegt im Bereich ihres Netzes** | sonst ist der Host unerreichbar |
| **Gateway-Adressen sind reserviert** | Konflikte mit dem Router vermeiden |
| **Jedes Netz hat höchstens einen Router (im einfachen Modell)** | klare Pfade für Firewall-Regeln |
| **Ressourcen-Summe passt in die Quote des Pools** | Überlastung des Clusters verhindern |

Tabelle 165: Gültigkeitsregeln für Topologie-Dateien (angelehnt an KYPO)

## Die Proxmox-API aus Python ansprechen

Worker können statt OpenTofu auch direkt mit der Proxmox-API sprechen – etwa für schnelle Aktionen wie Reset per Snapshot. Die Bibliothek **proxmoxer** kapselt die REST-API:

**Reset einer Sandbox über die Proxmox-API (Python, proxmoxer)**

```
from proxmoxer import ProxmoxAPI

px = ProxmoxAPI("range-01.mgmt", user="orchestrator@pve", token_name="worker",
                token_value=open("/run/secrets/pve_token").read().strip(), verify_ssl=True)

def reset_sandbox(pool: str, snapshot: str = "clean") -> list[str]:
    """Setzt alle VMs eines Proxmox-Pools auf einen Snapshot zurück und startet sie neu."""
    tasks = []
    for m in px.pools(pool).get()["members"]:
        if m.get("type") != "qemu":
            continue
        node, vmid = m["node"], m["vmid"]
        tasks.append(px.nodes(node).qemu(vmid).snapshot(snapshot).rollback.post())
    return tasks          # UPIDs der Tasks – der Worker wartet anschließend auf deren Abschluss

def wait(node: str, upid: str):
    import time
    while px.nodes(node).tasks(upid).status.get()["status"] == "running":
        time.sleep(2)
```

> [!TIPP] Ein Pool pro Sandbox
> Proxmox-**Ressourcenpools** gruppieren VMs. Wenn jede Sandbox einen eigenen Pool erhält (z. B. `sbx-017`), lassen sich Rechte (Teilnehmer sieht nur seinen Pool), Reset und Löschung mit einem einzigen API-Aufruf je Pool erledigen.

## Schnittstellen der Range-API

| **Methode und Pfad** | **Funktion** | **Berechtigung** |
|---|---|---|
| **GET /definitions** | Sandbox-Definitionen auflisten | Trainer |
| **POST /pools** | Pool aus Definition anlegen (Größe, Laufzeit) | Trainer |
| **POST /pools/{id}/sandboxes** | n Sandboxes im Hintergrund erzeugen | Trainer |
| **POST /pools/{id}/allocations** | Sandbox einem Teilnehmer zuweisen | Trainer, Portal |
| **POST /sandboxes/{id}/reset** | auf Snapshot »clean« zurücksetzen | Trainer, Teilnehmer (eigene) |
| **GET /sandboxes/{id}/access** | Guacamole-Verbindungen der Sandbox abrufen | Teilnehmer (eigene) |
| **DELETE /pools/{id}** | alle Sandboxes und Netze löschen | Trainer |
| **GET /events (WebSocket)** | Statusmeldungen live | alle angemeldeten Benutzer (gefiltert) |

Tabelle 166: Schnittstellen eines einfachen Range-Orchestrators

## Fehler, Wiederholungen und Quoten im Orchestrator

Ein Orchestrator, der in 90 % der Fälle funktioniert, ist im Übungsbetrieb wertlos: Bei 20 Sandboxes fallen dann zwei aus – kurz vor Kursbeginn. Robustheit entsteht durch drei Prinzipien:

| **Prinzip** | **Bedeutung** | **Umsetzung** |
|---|---|---|
| **Idempotente Schritte** | Jeder Schritt kann gefahrlos wiederholt werden | Vor dem Anlegen prüfen, ob die Ressource schon existiert; OpenTofu und Ansible sind von Natur aus idempotent |
| **Wiederholung mit Wartezeit** | Vorübergehende Fehler (API ausgelastet, Sperren) werden automatisch erneut versucht | bis zu 3 Versuche mit steigender Wartezeit (z. B. 10 s, 30 s, 90 s); danach Zustand FAILED |
| **Quoten und Vorabprüfung** | Ein Auftrag wird nur angenommen, wenn genug Ressourcen frei sind | Summe von RAM, CPU, Speicher des Pools gegen freie Kapazität prüfen, bevor der erste Worker startet |

Tabelle 167: Prinzipien für einen robusten Orchestrator

| **Zustand** | **Bedeutung** | **Erlaubte Übergänge** |
|---|---|---|
| **REQUESTED** | Auftrag angenommen, wartet in der Queue | → BUILDING, → REJECTED (Quote) |
| **BUILDING** | Worker baut die Sandbox | → READY, → FAILED |
| **READY** | fertig, noch keinem Teilnehmer zugewiesen | → ALLOCATED, → DELETING |
| **ALLOCATED** | einem Teilnehmer bzw. Team zugewiesen | → RESETTING, → DELETING |
| **RESETTING** | Rückkehr zum Snapshot »clean« | → ALLOCATED, → FAILED |
| **FAILED** | Fehler nach allen Wiederholungen | → DELETING (Aufräumen), → BUILDING (manueller Neustart) |
| **DELETING** | VMs, Netze, Pool werden entfernt | → (gelöscht) |

Tabelle 168: Zustände einer Sandbox im Orchestrator

> [!WARNUNG] Aufräumen ist Pflicht
> Fehlgeschlagene Bauvorgänge hinterlassen oft halbe Sandboxes: einzelne VMs, verwaiste Netze, belegte VMIDs. Ein nächtlicher Aufräumjob vergleicht die Datenbank des Orchestrators mit den Proxmox-Pools und meldet bzw. entfernt alles, was keiner gültigen Sandbox gehört.
