---
id: cr-29
title: Datensicherung und Wiederherstellung
paths: cyberrange
order: 29
difficulty: hard
icon: externaldrive
summary: Kapitel 29 deiner Cyber-Range-Dokumentation: Datensicherung und Wiederherstellung.
source: Cyber_Range_Dokumentation.docx
htb: 
---

## Überblick

Eine Range besteht zum größten Teil aus Code – die Übungs-VMs lassen sich jederzeit neu erzeugen. Trotzdem gibt es Daten, deren Verlust schmerzt: das Git-Repository, die Templates, die Konfiguration der Betriebsdienste, Szenario-Artefakte und die Ergebnisse vergangener Übungen. Für sie gilt ein klares Sicherungskonzept.

## Was gesichert wird – und was nicht

| **Daten** | **Sichern?** | **Begründung** | **RPO / RTO** |
|---|---|---|---|
| **Git-Repository (iac-01)** | ja, mehrfach | Quelle der gesamten Range | 24 h / 4 h |
| **Packer-Templates** | ja | Neubau dauert Stunden (Windows-Updates) | 1 Woche / 1 Tag |
| **Betriebs-VMs (Keycloak, Guacamole, CTFd, Wazuh-Konfiguration)** | ja | Konfiguration und Benutzer | 24 h / 4 h |
| **Security-Onion-Daten (PCAP, Indizes)** | nur übungsbezogen exportieren | sehr groß, nach AAR meist nicht mehr nötig | – / – |
| **Übungs-VMs** | nein | werden aus Code neu erzeugt | – / 90 Min. (Neuaufbau) |
| **Übungsergebnisse, Berichte, AAR** | ja, archivieren | Nachweis, Auswertung, Vergleich | 24 h / 1 Tag |
| **Proxmox-Host-Konfiguration** | ja (/etc/pve, Netzwerk) | schnelle Wiederherstellung der Hosts | 1 Woche / 4 h |

Tabelle 173: Sicherungsumfang der Range

## Die 3-2-1-Regel mit Proxmox Backup Server

![Abbildung 74: Datensicherung nach der 3-2-1-Regel mit Proxmox Backup Server](asset:cyberrange/cr-29-074.png)

**So liest man die Abbildung:**

- Proxmox sichert VMs im **Snapshot-Modus** im laufenden Betrieb an den **Proxmox Backup Server** (PBS).
- Dank **Dirty Bitmap** werden nach der ersten Vollsicherung nur geänderte Blöcke übertragen; PBS speichert Daten in Stücken (Chunks) und **dedupliziert** sie über alle VMs hinweg.
- Ein **Sync-Job** kopiert den Datenbestand auf einen zweiten PBS an einem anderen Ort; eine **Offline-Kopie** schützt vor Ransomware und Bedienfehlern.
- **Verify-Jobs** prüfen regelmäßig die Integrität, monatliche **Restore-Tests** beweisen, dass die Wiederherstellung wirklich funktioniert.

Proxmox Backup Server 4.0 erschien im August 2025 auf Basis von Debian 13. Neu ist u. a. die Möglichkeit, Datastores auf S3-kompatiblem Objektspeicher abzulegen (als Technologievorschau). Für die Range genügt ein kleiner PBS – als eigene Maschine oder, im Pilot, als VM auf ops-01 mit separatem Datenträger.

**Proxmox Backup Server einrichten (Beispiel)**

```
# Auf dem Backup-Server: Datastore anlegen
proxmox-backup-manager datastore create range-store /mnt/datastore/range

# Auf dem Proxmox-Host: PBS als Speicher einbinden (Fingerprint vom PBS-Dashboard)
pvesm add pbs pbs-range --server 10.0.0.40 --datastore range-store \
     --username backup@pbs --fingerprint 'AA:BB:…' --password '<geheim>' \
     --encryption-key autogen

# Aufbewahrung: 7 tägliche, 4 wöchentliche, 6 monatliche Stände
#  (in der GUI unter Datacenter → Backup → Retention bzw. als Prune-Job auf dem PBS)
```

> [!GEFAHR] Verschlüsselungsschlüssel sichern
> Mit `--encryption-key autogen` werden Sicherungen clientseitig verschlüsselt. Geht der Schlüssel verloren, sind alle Sicherungen wertlos. Der Schlüssel (und ein Papierausdruck des Wiederherstellungsschlüssels) gehört getrennt von den Sicherungen an einen sicheren Ort.

## Wiederherstellung üben

1. **Monatlich:** eine zufällig gewählte Betriebs-VM auf einen Test-Knoten wiederherstellen und starten; Funktion prüfen (z. B. Anmeldung an Keycloak).
1. **Quartalsweise:** Neuaufbau der kompletten Übungsumgebung aus Git auf einem leeren System, Zeit messen (Ziel < 90 Minuten).
1. **Jährlich:** »Totalverlust« von ops-01 simulieren: Wiederherstellung aller Betriebsdienste aus dem zweiten PBS.
1. **Nach jedem Test:** Ergebnis, Dauer und Probleme im Betriebshandbuch dokumentieren.
## Wiederanlauf nach einem Totalausfall

Der schlimmste anzunehmende Fall ist der Verlust beider Maschinen – etwa durch einen Brand, einen Wasserschaden oder einen erfolgreichen Angriff auf die Verwaltung. Ein vorbereiteter **Wiederanlaufplan** legt fest, in welcher Reihenfolge die Plattform zurückkommt und wie lange das dauern darf.

![Abbildung 75: Wiederanlaufplan nach einem Totalausfall](asset:cyberrange/cr-29-075.png)

**So liest man die Abbildung:**

- Die Schritte bauen aufeinander auf: Ohne Hypervisor keine Wiederherstellung, ohne Git-Repository kein Neuaufbau der Range.
- Unter jedem Schritt steht die **geplante Dauer**. Zusammen ergeben sie etwa einen Arbeitstag – das ist das RTO der Gesamtplattform.
- Unten stehen die **Voraussetzungen**, die schon vor dem Ernstfall erfüllt sein müssen – ein Wiederanlauf scheitert fast immer an fehlenden Schlüsseln oder ungeprüften Backups.

☐  Installationsmedien (Proxmox VE, PBS) liegen offline vor

☐  Verschlüsselungsschlüssel der Backups und Wiederherstellungsschlüssel sind getrennt gesichert

☐  Netz- und IP-Plan sowie diese Dokumentation liegen ausgedruckt bzw. offline vor

☐  Zugangsdaten für den Notfall (Passwortmanager-Notfallzugang) sind hinterlegt

☐  Der Wiederanlauf wurde in den letzten 12 Monaten mindestens einmal geübt
