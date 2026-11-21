---
id: d-11
title: Incident Response auf Linux und in der Cloud
paths: cdsa, specialist
order: 11
difficulty: hard
icon: cloud.bolt
summary: Erste Schritte auf einem kompromittierten Linux-Server, wichtige Artefakte, auditd, Container-Vorfälle sowie Untersuchungen in AWS, Azure und Microsoft 365.
---

## Linux-Server: erste Schritte

> [!WARNUNG] Erst sichern, dann ändern
> Arbeite nach der Order of Volatility ([[mod:s-07|Incident Response]]): Speicher und laufenden Zustand sichern, bevor Prozesse beendet oder das System neu gestartet wird. Nutze nach Möglichkeit vertrauenswürdige, statisch gelinkte Werkzeuge von einem externen Datenträger – Systemprogramme könnten manipuliert sein.

| Frage | Quelle |
|---|---|
| Wer ist angemeldet, wer war es? | `w`, `last`, `lastb`, `/var/log/auth.log`, `journalctl` |
| Welche Prozesse laufen? | `ps auxf`, `/proc/<PID>/exe`, `/proc/<PID>/cmdline` |
| Welche Verbindungen bestehen? | `ss -tanp`, Firewall-Logs |
| Was startet automatisch? | Cron-Verzeichnisse, systemd-Units und -Timer, `/etc/rc.local`, Shell-Profile |
| Welche Konten und Schlüssel sind neu? | `/etc/passwd`, `/etc/shadow` (Änderungszeit), `~/.ssh/authorized_keys` |
| Welche Dateien sind neu oder geändert? | `find` nach Zeit, Paketprüfung (`debsums`, `rpm -Va`) |
| Was liegt in temporären Verzeichnissen? | `/tmp`, `/var/tmp`, `/dev/shm` |

## auditd

Der Linux-Audit-Daemon protokolliert Systemaufrufe nach Regeln, z. B. Ausführung von Programmen, Zugriff auf `/etc/shadow`, Änderungen an sudoers oder Cron. Vorgefertigte Regelsätze (z. B. von Florian Roth oder Neo23x0) sind ein guter Start. Auswertung mit `ausearch` und `aureport`, Weiterleitung ins SIEM.

## Container-Vorfälle

| Besonderheit | Konsequenz |
|---|---|
| Container sind kurzlebig | Logs und Artefakte zentral sammeln, bevor der Container verschwindet |
| gemeinsamer Kernel | Ausbruch aus dem Container betrifft den Host |
| Images | betroffenes Image identifizieren und alle Instanzen davon prüfen |
| Orchestrierung | Kubernetes-Audit-Logs zeigen, wer was angelegt hat |

Vorgehen: Pod/Container isolieren (Network Policy), Dateisystem und Speicher sichern (`docker export`, Checkpoint), Image analysieren, Zugangsdaten des Containers (Service-Account-Token, Cloud-Rollen) widerrufen.

## AWS

| Quelle | Nutzen |
|---|---|
| CloudTrail | wer hat welche API aufgerufen (Konto, Rolle, IP, User-Agent) |
| GuardDuty | Erkennungen, z. B. ungewöhnliche API-Nutzung, Krypto-Mining |
| VPC Flow Logs | Netzwerkverbindungen |
| S3 Access Logs | Zugriffe auf Buckets |

Typische Schritte: kompromittierte Zugriffsschlüssel deaktivieren, Sitzungen der Rolle widerrufen, neue IAM-Benutzer/Schlüssel/Rollen-Vertrauensstellungen suchen, Snapshots betroffener Instanzen für die Forensik.

## Azure und Microsoft 365

| Quelle | Nutzen |
|---|---|
| Entra Sign-in Logs | Anmeldungen mit Ort, Gerät, MFA-Status |
| Entra Audit Logs | Änderungen an Benutzern, Rollen, Apps, Consent |
| Unified Audit Log (M365) | Postfachzugriffe, Regeln, Freigaben |
| Activity Log | Änderungen an Azure-Ressourcen |

Typische Schritte: Sitzungen widerrufen und Passwort zurücksetzen, MFA-Methoden prüfen, Postfachregeln und Weiterleitungen prüfen, App-Registrierungen und Zustimmungen kontrollieren, Conditional Access nachschärfen.

> [!TIPP] Vorbereitung entscheidet
> In der Cloud existieren viele Logs nur, wenn sie vorher aktiviert und lange genug aufbewahrt wurden. Ein Incident-Response-Plan für die Cloud beginnt deshalb mit der Logging-Konfiguration.

## Quiz

? Welche Befehle zeigen vergangene und fehlgeschlagene Anmeldungen unter Linux?
+ last und lastb
- ls und cat
- ps und top
- grep und awk

? Wo legen Angreifer häufig SSH-Persistenz an?
= authorized_keys
= ~/.ssh/authorized_keys

? Welcher Linux-Dienst protokolliert Systemaufrufe nach Regeln?
= auditd

? Welche AWS-Quelle zeigt, wer welche API aufgerufen hat?
= CloudTrail

? Welches Microsoft-365-Log zeigt Postfachzugriffe und Regeln?
= Unified Audit Log

? Warum ist Logging-Konfiguration Teil der Incident-Response-Vorbereitung in der Cloud?
+ Viele Logs existieren nur, wenn sie vorher aktiviert wurden
- Cloud-Anbieter löschen alle Logs sofort
- Logs sind in der Cloud verboten
- Logging ist dort automatisch vollständig

? Mit welchem Befehl prüft man unter Debian geänderte Paketdateien?
= debsums
