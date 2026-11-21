---
id: f-16
title: Git, Infrastructure as Code und Automatisierung
paths: grundlagen, cyberrange, specialist
order: 16
difficulty: medium
icon: arrow.triangle.branch
summary: Versionskontrolle mit Git, Branches und Pull Requests, Geheimnisse in Repositories, Infrastructure as Code mit Terraform und Ansible, CI/CD-Grundlagen und warum all das für Sicherheit zählt.
---

## Warum Versionskontrolle?

**Git** speichert jede Änderung mit Autor, Zeit und Beschreibung. Man kann Änderungen nachvollziehen, rückgängig machen, parallel entwickeln und prüfen lassen. Heute wird nicht nur Code, sondern auch Infrastruktur, Konfiguration und sogar Erkennungsregeln in Git verwaltet.

## Grundbegriffe

| Begriff | Bedeutung |
|---|---|
| Repository | Projekt mit vollständiger Historie |
| Commit | gespeicherter Änderungsstand mit Nachricht |
| Branch | paralleler Entwicklungszweig |
| Merge / Pull Request | Änderungen zusammenführen, idealerweise nach Review |
| Remote | entfernte Kopie (GitHub, GitLab, Gitea) |
| `.gitignore` | Dateien, die nicht versioniert werden |

```bash
git clone https://example.org/team/projekt.git
git switch -c feature/login
git add . && git commit -m "Login mit MFA"
git push -u origin feature/login
git log --oneline --graph
```

## Geheimnisse und Historie

> [!GEFAHR] Git vergisst nichts
> Ein Passwort, das einmal committet wurde, bleibt in der Historie – auch wenn die Datei später gelöscht wird. Öffentliche Repositories werden automatisiert nach Schlüsseln durchsucht, oft innerhalb von Minuten. Einmal veröffentlichte Geheimnisse müssen **widerrufen** werden.

Gegenmaßnahmen: `.gitignore` für Konfigurationsdateien, Pre-Commit-Hooks mit Secret-Scanning (Gitleaks), Secret-Stores, Push-Protection der Plattform.

Auch für Prüfer und Verteidiger interessant: Ein öffentlich erreichbares `.git`-Verzeichnis auf einem Webserver kann den kompletten Quellcode samt Historie preisgeben.

## Infrastructure as Code (IaC)

Statt Server per Hand zu klicken, beschreibt man den gewünschten Zustand in Dateien:

| Werkzeug | Aufgabe | Sprache |
|---|---|---|
| Terraform / OpenTofu | Infrastruktur anlegen (VMs, Netze, Cloud-Ressourcen) | HCL, deklarativ |
| Ansible | Systeme konfigurieren (Pakete, Dateien, Dienste) | YAML-Playbooks, agentenlos über SSH/WinRM |
| Packer | Basis-Images bauen | HCL/JSON |
| Docker / Compose | Container definieren | Dockerfile, YAML |
| Kubernetes-Manifeste | Container-Plattform | YAML |

Deine Cyber Range nutzt genau diese Kette – siehe [[mod:cr-06|L3 Orchestrierung]].

> [!INFO] Sicherheitsvorteile von IaC
> Reproduzierbare, geprüfte Konfiguration; Änderungen per Review; Drift erkennen; Härtung als Code; schnelle Wiederherstellung. Risiken: Fehler werden ebenfalls automatisiert verteilt, und Secrets dürfen nicht in den Dateien stehen.

## CI/CD

**Continuous Integration / Continuous Delivery** baut, testet und verteilt Änderungen automatisch. Ein Beispiel ist der Workflow, der die NIMA-App selbst baut: Bei jedem Push wird der Inhalt geprüft, das Projekt erzeugt, kompiliert und als IPA veröffentlicht.

Sicherheitsaspekte von Pipelines: minimale Rechte der Pipeline-Tokens, Schutz des Hauptzweigs (Reviews erforderlich), geprüfte Drittanbieter-Aktionen (auf Versionen bzw. Commit-Hashes festlegen), Secrets nur in geschützten Umgebungen, Sicherheitsscans als Pflichtschritt.

## Quiz

? Was ist ein Commit?
+ ein gespeicherter Änderungsstand mit Nachricht
- ein Server
- ein Passwort
- eine Firewall-Regel

? Welche Datei legt fest, welche Dateien Git ignoriert?
= .gitignore

? Was muss man tun, wenn ein Passwort in die Git-Historie gelangt ist?
+ das Passwort widerrufen bzw. ändern
- nur die Datei löschen
- den Branch umbenennen
- nichts

? Welches Werkzeug konfiguriert Systeme agentenlos mit YAML-Playbooks?
= Ansible

? Welches Werkzeug legt Infrastruktur deklarativ in HCL an?
+ Terraform / OpenTofu
- Ansible
- Wireshark
- Git

? Warum ist ein öffentlich erreichbares .git-Verzeichnis gefährlich?
+ Es kann den kompletten Quellcode samt Historie preisgeben
- Es verlangsamt den Webserver
- Es löscht Daten
- Es ist ungefährlich

? Wofür steht CI/CD?
= Continuous Integration / Continuous Delivery
= Continuous Integration Continuous Delivery
