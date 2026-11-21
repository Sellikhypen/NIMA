---
id: ot-01
title: OT · Industrieprotokolle im Detail
paths: specialist, cyberrange
order: 90
difficulty: hard
icon: gearshape.2.fill
tags: ot
summary: Modbus, S7comm, DNP3, IEC 60870-5-104, IEC 61850, PROFINET und OPC UA – Aufbau, fehlende oder vorhandene Sicherheitsfunktionen und Konsequenzen für die Verteidigung.
---

## Warum OT-Protokolle besonders sind

Viele Industrieprotokolle stammen aus einer Zeit abgeschotteter Netze. Sie haben oft **keine Authentifizierung und keine Verschlüsselung**: Wer das Netz erreicht, kann Werte lesen und Befehle senden. Schutz entsteht daher vor allem durch Segmentierung und Überwachung.

## Übersicht

| Protokoll | Port | Einsatz | Sicherheit |
|---|---|---|---|
| Modbus/TCP | 502 | Fertigung, Gebäude | keine Authentifizierung; Secure-Variante (TLS) selten |
| S7comm / S7comm-plus | 102 | Siemens-SPS | neuere Versionen mit Integritätsschutz |
| DNP3 | 20000 | Energie, Wasser (Nordamerika) | Secure Authentication (SAv5/6) optional |
| IEC 60870-5-104 | 2404 | Energie-Fernwirktechnik (Europa) | Absicherung über IEC 62351 |
| IEC 61850 (MMS, GOOSE) | 102 / Layer 2 | Umspannwerke | GOOSE zeitkritisch, Absicherung über IEC 62351 |
| PROFINET | Layer 2/UDP | Echtzeit in Fertigung | Security-Klassen in neueren Versionen |
| OPC UA | 4840 | herstellerübergreifend | eingebaut: Zertifikate, Signatur, Verschlüsselung |

## Modbus im Kurzporträt

Daten liegen in **Coils** (Bits, lesend/schreibend), **Discrete Inputs**, **Input Registers** und **Holding Registers**. Funktionscodes wie 3 (Read Holding Registers) oder 6/16 (Write) steuern den Zugriff. Für die Überwachung heißt das: **Schreibende Funktionscodes** von unerwarteten Quellen sind ein starkes Alarmkriterium.

## Folgen für die Verteidigung

- Zonen und Conduits nach IEC 62443 ([[mod:s-11|OT/ICS]])
- nur bekannte Kommunikationsbeziehungen erlauben (Allowlisting)
- Protokoll-bewusste Firewalls/DPI, die z. B. nur lesende Funktionscodes durchlassen
- wo möglich auf sichere Varianten migrieren (OPC UA mit SignAndEncrypt)

## Quiz

? Welcher Port wird von Modbus/TCP genutzt?
= 502

? Welches Protokoll bringt Zertifikate, Signatur und Verschlüsselung bereits mit?
= OPC UA

? Welche Modbus-Funktionscodes sind für Alarme besonders interessant?
+ schreibende Funktionscodes von unerwarteten Quellen
- lesende Codes vom HMI
- gar keine
- nur Fehlercodes

? Welcher Standard beschreibt die Absicherung von IEC-60870-5-104 und IEC 61850?
= IEC 62351

? Welcher Port gehört zu IEC 60870-5-104?
= 2404

@@@ MODULE @@@
---
id: ot-02
title: OT · Monitoring industrieller Netze
paths: specialist, cdsa, cyberrange
order: 91
difficulty: hard
icon: waveform.badge.magnifyingglass
tags: ot
summary: Passive Überwachung über SPAN/TAP, Asset-Erkennung, Baselines, protokollbewusste Erkennung, Integration ins SOC und die Grenzen aktiver Scans in OT.
---

## Passiv vor aktiv

> [!GEFAHR] Vorsicht mit aktiven Scans
> Ältere SPS und Feldgeräte können auf ungewöhnliche Pakete (z. B. Portscans) mit Absturz oder Fehlverhalten reagieren. In OT wird deshalb vorrangig **passiv** überwacht; aktive Abfragen nur abgestimmt, mit Herstellerfreigabe und in Wartungsfenstern.

## Datengewinnung

| Methode | Hinweis |
|---|---|
| SPAN/Mirror-Port | einfach, kann bei Last Pakete verlieren |
| Netzwerk-TAP | verlustfrei, rückwirkungsfrei |
| Datendiode | Daten nur in eine Richtung (OT → IT) |

## Was OT-Monitoring leistet

| Funktion | Nutzen |
|---|---|
| Asset-Inventar | Hersteller, Modell, Firmware aus dem Datenverkehr |
| Kommunikationsbaseline | wer spricht mit wem, welches Protokoll, welche Funktion |
| Protokollanalyse | Lese-/Schreibbefehle, Programm-Downloads, Betriebsmodus-Wechsel |
| Schwachstellenabgleich | Firmware-Stände gegen Advisories (z. B. CISA ICS) |

## Typische Alarme

- neues Gerät im Steuerungsnetz
- Engineering-Workstation spricht außerhalb von Wartungsfenstern mit SPS
- Programm-Upload/-Download oder Wechsel in STOP/PROGRAM
- Kommunikation zwischen Zonen, die nie miteinander sprechen
- IT-Protokolle (RDP, SMB) an ungewöhnlichen Stellen

## Integration ins SOC

OT-Alarme brauchen **Prozesswissen**: Analysten sollten wissen, welche Anlage betroffen ist, und Eskalationswege zur Betriebsmannschaft haben. Reaktionen werden mit dem Betrieb abgestimmt – Sicherheit von Menschen und Anlage geht vor ([[mod:ot-03|OT Incident Response]]).

Open-Source-Bausteine: Zeek mit OT-Parsern, Suricata mit ICS-Regeln, Malcolm.

## Quiz

? Warum wird OT vorrangig passiv überwacht?
+ Ältere Geräte können auf aktive Scans mit Fehlverhalten reagieren
- weil passive Überwachung mehr kostet
- weil OT keinen Netzwerkverkehr hat
- weil Scans verboten sind

? Welche Methode liefert Daten verlustfrei und rückwirkungsfrei?
= TAP
= Netzwerk-TAP

? Welches Gerät erlaubt Datenfluss nur in eine Richtung?
= Datendiode

? Welcher Alarm ist in OT besonders kritisch?
+ Wechsel einer SPS in den STOP- oder PROGRAM-Modus außerhalb von Wartung
- ein HMI liest Werte
- NTP-Synchronisation
- ein geplantes Backup

@@@ MODULE @@@
---
id: ot-03
title: OT · Incident Response in Industrieumgebungen
paths: specialist, cdsa
order: 92
difficulty: hard
icon: exclamationmark.octagon.fill
tags: ot
summary: Was IR in OT anders macht, Rollen zwischen IT, OT und Betrieb, Sicherheit vor Verfügbarkeit vor Vertraulichkeit, Notbetrieb, Beweissicherung an Feldgeräten und Wiederanlauf.
---

## Andere Prioritäten

In der IT gilt oft Vertraulichkeit → Integrität → Verfügbarkeit. In OT steht **Safety** (Leib und Leben, Umwelt) an erster Stelle, dann Verfügbarkeit und Integrität des Prozesses, zuletzt Vertraulichkeit.

## Rollen

| Rolle | Aufgabe |
|---|---|
| Anlagenverantwortliche/Betrieb | Entscheidungen über Prozess und Abschaltung |
| OT-Engineering | Kenntnis von Steuerung, Programmen, Netzen |
| IT-Sicherheit/SOC | Analyse, Forensik, Koordination |
| Hersteller/Integratoren | Spezialwissen, Ersatzteile, Programme |
| Management/Recht | Meldepflichten (KRITIS, NIS2) |

## Vorbereitung

- Notfallpläne für **Handbetrieb** oder sicheren Zustand
- Offline-Sicherungen von SPS-Programmen, Konfigurationen, HMI-Projekten – mit Prüfsummen
- Ersatz-Engineering-Workstation (sauber, offline)
- Kontaktlisten, Netzwerkpläne, Asset-Inventar
- gemeinsame Übungen von IT und OT ([[mod:bt-08|Übungen]])

## Eindämmung mit Augenmaß

Netzwerkverbindungen zwischen IT und OT können oft getrennt werden, **ohne** den Prozess zu stoppen – das ist eine typische erste Maßnahme. Abschalten von Steuerungen ist eine Betriebsentscheidung, nicht die des SOC.

## Beweissicherung

- Netzwerkmitschnitte (TAP) laufen lassen
- Programme aus SPS auslesen und mit dem Sollstand vergleichen
- Engineering-Workstations und HMIs wie IT-Systeme forensisch sichern
- Projektdateien und Logs der Steuerungssoftware sichern

## Wiederanlauf

Steuerungsprogramme aus geprüften Sicherungen, Engineering-Workstations neu aufsetzen, Funktionsprüfung mit dem Betrieb, schrittweiser Wiederanlauf mit verstärktem Monitoring.

## Quiz

? Was hat in OT höchste Priorität?
+ Safety – Schutz von Menschen und Umwelt
- Vertraulichkeit
- Kosten
- Schnelligkeit der Forensik

? Wer entscheidet über das Abschalten einer Steuerung?
+ der Betrieb bzw. Anlagenverantwortliche
- das SOC allein
- der Angreifer
- der Hersteller allein

? Welche erste Eindämmungsmaßnahme stoppt oft nicht den Prozess?
+ Trennung der IT/OT-Verbindung
- Abschalten aller SPS
- Löschen der Programme
- Neustart des Kraftwerks

? Was sollte offline vorgehalten werden?
+ Sicherungen von SPS-Programmen und Konfigurationen
- Social-Media-Passwörter
- Werbematerial
- Urlaubsfotos
