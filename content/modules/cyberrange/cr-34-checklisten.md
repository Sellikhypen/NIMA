---
id: cr-34
title: Checklisten
paths: cyberrange
order: 34
difficulty: hard
icon: checklist
summary: Kapitel 34 deiner Cyber-Range-Dokumentation: Checklisten.
source: Cyber_Range_Dokumentation.docx
htb: 
---

## Vor jeder Übung (Pre-Flight)

☐  Templates aktuell, Eval-Lizenzen länger gültig als die Übung

☐  Range frisch aufgebaut bzw. auf Snapshot »clean« zurückgesetzt

☐  Egress-Test aus allen Zonen bestanden

☐  Alle Agenten im SIEM aktiv, Sensor empfängt Spiegelverkehr, Zeit synchron (NTP)

☐  Service-Checks grün, Scoreboard leer

☐  Benutzerkonten und Gruppen in Keycloak und Guacamole geprüft

☐  RoE an alle verteilt und bestätigt, Kommunikationskanäle getestet

☐  MSEL und Inject-Material bereit, White Team gebrieft

☐  Ansible-Build-Fenster geschlossen (Regel 5 deaktiviert)

☐  Backup der Infrastruktur-VMs (B) aktuell

## Nach jeder Übung (Post-Flight)

☐  Logs, PCAP, Sitzungsaufzeichnungen, Tickets gesichert (mit Prüfsummen)

☐  Hot-Wash direkt nach ENDEX, AAR innerhalb einer Woche

☐  Erkenntnisse als Issues im Git-Repository erfasst

☐  Range zurückgesetzt oder zerstört, Ressourcen freigegeben

☐  Personenbezogene Daten gemäß Löschkonzept behandelt

## Neue VM in die Range aufnehmen

☐  Zone/VLAN und IP-Adresse im IP-Plan reserviert

☐  VM im OpenTofu-Modul beschrieben (Template, Tag, IP, Ressourcen)

☐  Ansible-Rollen zugeordnet (inkl. Agent, Sysmon bei Windows)

☐  Firewall-Regeln ergänzt und dokumentiert

☐  Service-Check und erwartete Telemetrie definiert

☐  Merge-Request geprüft, Pipeline grün

## Neues Szenario freigeben

☐  Szenario-Steckbrief vollständig (Kapitel 24.1)

☐  Lernziele messbar formuliert und einer Bloom-Stufe zugeordnet

☐  Jede Phase mit ATT&CK-Technik und erwarteter Telemetrie dokumentiert

☐  Schadwirkungen ausschließlich simuliert, Reset-Verfahren getestet

☐  Keine echten Personen-, Firmen- oder Zugangsdaten enthalten

☐  Angriffswerkzeuge und Infrastruktur ausschließlich im SINET bzw. Übungsnetz

☐  Musterlösung und Bewertungsrubrik erstellt, getrennt von Teilnehmerunterlagen abgelegt

☐  Dry-Run mit Zeitmessung durchgeführt, Ergebnisse eingearbeitet

☐  Freigabe durch Exercise Director dokumentiert

## Wöchentlicher Betrieb

☐  Updates der Betriebs-VMs geprüft (nicht während einer Übungsserie)

☐  Backup-Jobs erfolgreich, Verify-Job ohne Fehler

☐  Speicherbelegung ZFS < 80 %, PCAP-Speicher bereinigt

☐  Zertifikatslaufzeiten > 14 Tage

☐  Keine verwaisten Sandboxes oder Pools

☐  Konten ehemaliger Teilnehmer deaktiviert
