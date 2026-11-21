---
id: cr-30
title: Bedrohungsmodell der Range
paths: cyberrange
order: 30
difficulty: hard
icon: exclamationmark.shield
summary: Kapitel 30 deiner Cyber-Range-Dokumentation: Bedrohungsmodell der Range.
source: Cyber_Range_Dokumentation.docx
htb: 
---

## Überblick

Eine Cyber Range ist eine ungewöhnliche Umgebung: Ihre Benutzer **sollen** angreifen. Das Bedrohungsmodell beantwortet deshalb nicht nur die Frage »Wer greift uns von außen an?«, sondern vor allem: **Was passiert, wenn ein Teilnehmer die Grenzen der Übung überschreitet** – absichtlich oder aus Versehen?

## Vertrauensgrenzen

![Abbildung 76: Vertrauensgrenzen der Range mit STRIDE-Bedrohungen](asset:cyberrange/cr-30-076.png)

**So liest man die Abbildung:**

- Die Range ist in fünf Bereiche geteilt: **außen**, **Zugangsschicht**, **Control Plane**, **Data Plane** und **Observation Plane**.
- Die **roten gestrichelten Linien** sind Vertrauensgrenzen: Überall dort, wo Daten oder Befehle sie überqueren, braucht es Kontrollen.
- An jeder Grenze steht eine typische Bedrohung nach **STRIDE** mit der wichtigsten Gegenmaßnahme.
## STRIDE-Analyse

| **Kategorie** | **Bedrohung in der Range** | **Gegenmaßnahme** | **Restrisiko** |
|---|---|---|---|
| **S – Spoofing (Identität vortäuschen)** | Übernahme eines Teilnehmer- oder White-Team-Kontos | MFA, Brute-Force-Schutz, kurze Sitzungen | gering |
| **T – Tampering (Manipulation)** | Teilnehmer manipulieren Logs oder Sensoren, um Bewertung zu beeinflussen | einseitiger Telemetriefluss, Sensoren außerhalb der Data Plane | gering |
| **R – Repudiation (Abstreiten)** | Regelverstoß ist nicht nachweisbar | Guacamole-Aufzeichnung, zentrale Logs, Zeitsynchronisation | gering |
| **I – Information Disclosure** | PCAP oder Musterlösung gelangen zu Teams; Szenario-Inhalte werden öffentlich | RBAC, getrennte Ablage des Szenario-Handbuchs | mittel |
| **D – Denial of Service** | Ein Team überlastet die gemeinsame Infrastruktur | Ressourcenlimits je Pool, Monitoring, Not-Aus | mittel |
| **E – Elevation of Privilege** | Ausbruch aus der Data Plane zur Proxmox-API oder ins reale Netz; VM-Escape | Netztrennung, keine Routen, aktuelle Hypervisor-Patches, kein Geräte-Passthrough in Übungs-VMs | gering, aber höchste Auswirkung |

Tabelle 174: STRIDE-Analyse der Range

## Risikomatrix

| **Risiko** | **Eintritt** | **Auswirkung** | **Bewertung** | **Maßnahme** |
|---|---|---|---|---|
| **Schadsoftware aus Übung erreicht reales Netz** | selten | sehr hoch | hoch | Isolation, Egress-Test vor jeder Übung, Not-Aus |
| **Teilnehmerkonto kompromittiert** | gelegentlich | mittel | mittel | MFA, Sperren nach ENDEX |
| **Fehlkonfiguration öffnet Weg zur API** | selten | hoch | mittel | GitOps-Review, automatische Netztests |
| **Ausfall während Übung** | gelegentlich | mittel | mittel | Dry-Run, Lasttest, Ersatzteile |
| **Musterlösung wird bekannt** | gelegentlich | gering | gering | Szenario-Varianten, Rotation |
| **Datenschutzverstoß bei Aufzeichnungen** | selten | mittel | gering | Löschkonzept, Zugriffsbeschränkung |

Tabelle 175: Risikomatrix der Range

> [!ERGEBNIS] Leitprinzip
> Die Range darf jederzeit **kaputtgehen** – aber nie **auslaufen**. Jede Designentscheidung wird daran gemessen, ob sie im schlimmsten Fall nur die Übung beeinträchtigt oder einen Weg nach außen öffnet.

## Die Range selbst regelmäßig prüfen

Bedrohungsmodelle veralten. Neue Komponenten, geänderte Regeln oder neue Szenarien können unbemerkt Lücken öffnen. Deshalb wird die Range in festen Abständen selbst geprüft – idealerweise von Personen, die nicht am Aufbau beteiligt waren.

| **Prüfung** | **Rhythmus** | **Inhalt** | **Durchführung** |
|---|---|---|---|
| **Isolationstest** | vor jeder Übung | Egress-Skript aus allen Zonen (Kapitel 18.10) | automatisch |
| **Regelwerks-Review** | quartalsweise | jede Firewall-Regel gegen die Zonenmatrix; ungenutzte Regeln entfernen | Green Team + zweite Person |
| **Rechte-Review** | quartalsweise | Keycloak-Gruppen, Proxmox-Rechte, API-Token, Gitea-Zugänge | Green Lead |
| **Patch-Stand Infrastruktur** | monatlich | Proxmox, OPNsense, Betriebs-VMs (nicht die absichtlich verwundbaren Übungs-VMs) | Green Team |
| **Interne Sicherheitsprüfung** | jährlich | Prüfung der Infrastruktur (nicht der Szenario-Systeme) durch ein unabhängiges Team | intern oder extern |
| **Notfallübung** | jährlich | Wiederanlauf (Kapitel 29.4) und Ausbruchsszenario (Kapitel 22.7) am Tisch durchspielen | Projektleitung |

Tabelle 176: Regelmäßige Prüfungen der Range
