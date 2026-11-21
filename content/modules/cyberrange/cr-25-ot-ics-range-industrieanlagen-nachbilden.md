---
id: cr-25
title: OT/ICS-Range: Industrieanlagen nachbilden
paths: cyberrange
order: 25
difficulty: hard
icon: bolt.horizontal
summary: Kapitel 25 deiner Cyber-Range-Dokumentation: OT/ICS-Range: Industrieanlagen nachbilden.
source: Cyber_Range_Dokumentation.docx
htb: Cyber Range 14 · OT/ICS & Container
---

## Überblick

Viele Organisationen betreiben neben der Büro-IT auch **Operational Technology (OT)**: Steuerungen für Produktion, Energie, Wasser oder Gebäudetechnik. Angriffe auf diese Systeme haben physische Folgen – deshalb ist Üben hier besonders wertvoll und echte Anlagen sind dafür besonders ungeeignet. Eine Range kann eine Industrieanlage vollständig virtuell nachbilden.

## Das Purdue-Modell als Zonenplan

Industrienetze werden traditionell nach dem **Purdue-Modell** in Ebenen eingeteilt. Es dient in der Range als Vorlage für die Zonen und Firewalls – genauso wie die Zonenmatrix der Büro-IT.

![Abbildung 67: Purdue-Referenzmodell als Zonenplan für die OT-Range](asset:cyberrange/cr-25-067.png)

**So liest man die Abbildung:**

- **Level 4–5** entsprechen der bestehenden Büro-IT der Range (CORP, SINET).
- **Level 3.5** ist die Industrie-DMZ: Hier treffen IT und OT kontrolliert aufeinander (Jump-Host, Historian-Spiegel, Update-Server).
- **Level 3–1** bilden die eigentliche Anlage: Leitebene mit Historian und Engineering-Station, Prozessführung mit HMI/SCADA, Steuerungen (SPS).
- **Level 0** – Sensoren und Aktoren – wird in der Range durch ein **Physikmodell** in Software ersetzt (z. B. ein Tank, der sich füllt und leert).
- Die **roten Linien** sind Firewalls. Ein direkter Weg von Level 4 nach Level 1 darf nicht existieren.
## Bausteine einer virtuellen Anlage

| **Ebene** | **Komponente in der Range** | **Beispiel (Open Source)** | **Protokoll** |
|---|---|---|---|
| **Level 0** | Physikalisches Prozessmodell | Python-Simulation (Tank, Pumpe, Ventil), GRFICS-Prozessmodell | intern |
| **Level 1** | Software-SPS | OpenPLC Runtime | Modbus TCP 502 |
| **Level 2** | HMI / SCADA | ScadaBR, FUXA | Modbus TCP, ggf. OPC UA 4840 |
| **Level 3** | Historian, Engineering-Station | InfluxDB + Grafana, Windows-VM mit Programmiersoftware | SQL/HTTP, Modbus |
| **Level 3.5** | Industrie-DMZ | Jump-Host, Datei-Austausch, Update-Spiegel | RDP, HTTPS |
| **Monitoring** | OT-fähige Sensorik | Zeek (Modbus-, DNP3-Analyse), Suricata mit Modbus-Schlüsselwörtern | passiv (Mirror) |

Tabelle 157: Komponenten einer virtuellen Industrieanlage

> [!INFO] GRFICS als Vorbild
> Das Projekt GRFICS (Graphical Realism Framework for Industrial Control Simulation), ursprünglich von Fortiphyd Logic und dem Georgia Institute of Technology entwickelt, virtualisiert ein komplettes Industrienetz – von der Bedienoberfläche bis zum visualisierten physikalischen Prozess. Es ist ein guter Ausgangspunkt, um die Ebenen 0–2 in die Range zu integrieren.

> [!GEFAHR] Niemals echte Steuerungen anbinden
> Die OT-Range enthält ausschließlich Software-Steuerungen. Echte SPSen, Feldbusse oder Anlagen werden nicht angeschlossen – auch nicht »nur zum Testen«. Wer reale Hardware einsetzen möchte (z. B. Schulungskoffer), betreibt sie in einem physisch getrennten Labor mit eigener Sicherheitsfreigabe.

## Industrieprotokolle verstehen: Modbus TCP

Modbus stammt aus dem Jahr 1979 und ist bis heute eines der verbreitetsten Industrieprotokolle. Sein Aufbau ist sehr einfach – und genau das macht es für die Ausbildung so wertvoll: Teilnehmer können jedes Byte verstehen.

![Abbildung 68: Aufbau einer Modbus-TCP-Anfrage](asset:cyberrange/cr-25-068.png)

**So liest man die Abbildung:**

- **Oben** die Kapselung: Modbus TCP läuft über TCP-Port 502. Vor den eigentlichen Daten steht der **MBAP-Header** (7 Byte).
- **Mitte** die Bytes einer Anfrage: Transaktions-ID (ordnet Antworten zu), Protokoll-ID (immer 0), Länge, Unit-ID (Gerätenummer), dann die **PDU** mit Funktionscode und Daten.
- **Unten** die wichtigsten Funktionscodes: Lesende Funktionen (türkis) und schreibende (rot).
- Modbus hat **keine Authentifizierung**: Wer die Steuerung über das Netz erreicht, kann lesen und schreiben. Schutz entsteht nur durch Segmentierung und Überwachung.
| **Protokoll** | **Port** | **Typische Branche** | **Sicherheitsmerkmale** |
|---|---|---|---|
| **Modbus TCP** | 502/tcp | Fertigung, Gebäudetechnik | keine (Erweiterung »Modbus Security« mit TLS existiert, kaum verbreitet) |
| **S7comm** | 102/tcp (ISO-on-TCP) | Siemens-Steuerungen | ältere Varianten ohne Schutz, neuere mit Integritätsschutz |
| **DNP3** | 20000/tcp | Energie, Wasser | Secure Authentication als Erweiterung |
| **OPC UA** | 4840/tcp | modern, herstellerübergreifend | Signatur und Verschlüsselung eingebaut |
| **EtherNet/IP (CIP)** | 44818/tcp, 2222/udp | Rockwell/Allen-Bradley | CIP Security als Erweiterung |

Tabelle 158: Wichtige Industrieprotokolle

## Überwachung der OT-Zone

OT-Netze sind sehr gleichförmig: Dieselben Geräte sprechen in festen Zyklen mit denselben Partnern. Das macht **Anomalie-Erkennung** besonders wirksam. Schon einfache Regeln erkennen viel:

**Suricata-Regeln für die OT-Zone (Variablen in suricata.yaml definieren)**

```
# Suricata (mit aktiviertem Modbus-Parser): Schreibzugriffe von Systemen außerhalb der Leitebene melden
alert modbus !$OT_ENGINEERING any -> $OT_PLC 502 (msg:"OT: Modbus-Schreibzugriff von nicht autorisierter Quelle (FC 6)"; \
  modbus: function 6; classtype:policy-violation; sid:9100001; rev:1;)
alert modbus !$OT_ENGINEERING any -> $OT_PLC 502 (msg:"OT: Modbus-Schreibzugriff von nicht autorisierter Quelle (FC 16)"; \
  modbus: function 16; classtype:policy-violation; sid:9100002; rev:1;)
```

| **Erkennungsansatz** | **Beispiel** | **Datenquelle** |
|---|---|---|
| **Neue Kommunikationspartner** | Ein Rechner aus Level 4 spricht direkt mit einer SPS | Zeek conn.log, Firewall |
| **Ungewöhnliche Funktionscodes** | Schreibzugriffe außerhalb von Wartungsfenstern | Zeek modbus.log, Suricata |
| **Prozesswerte außerhalb der Grenzen** | Tankfüllstand > 95 %, Pumpe läuft trotzdem | Historian, Grafana-Alarm |
| **Programmänderungen an der SPS** | Neues Steuerungsprogramm geladen | SPS-Ereignisprotokoll, Engineering-Station |
| **Zugriffe über die Industrie-DMZ** | Anmeldungen am Jump-Host außerhalb der Arbeitszeit | Windows-Ereignisse, Wazuh |

Tabelle 159: Erkennungsansätze in OT-Netzen

## Lernziele einer OT-Übung

- **IT und OT gemeinsam:** Büro-Analysten und Anlagenverantwortliche arbeiten zusammen – unterschiedliche Prioritäten (Vertraulichkeit vs. Verfügbarkeit und Sicherheit von Menschen) werden sichtbar.
- **Physische Folgen bewerten:** Was bedeutet eine Manipulation für den Prozess? Wann muss die Anlage in den sicheren Zustand gefahren werden?
- **Segmentierung prüfen:** Gibt es ungeplante Wege von IT zu OT?
- **Wiederanlauf üben:** Steuerungsprogramme aus gesicherten Ständen wiederherstellen, Prozesswerte prüfen.
> [!TIPP] Ressourcenbedarf
> Eine kleine OT-Zone (SPS, HMI, Historian, Engineering-Station, Physikmodell) benötigt etwa 5 VMs mit zusammen 16 GB RAM und passt damit auch in die Pilot-Range – allerdings nur, wenn parallel kein großes Büro-Szenario läuft.

## Das Physikmodell: wie der Prozess simuliert wird

Eine Steuerung ohne Prozess ist langweilig: Die Werte ändern sich nie, und Manipulationen haben keine sichtbare Folge. Deshalb steht hinter jeder virtuellen SPS ein kleines **Physikmodell** – ein Programm, das den Prozess nachbildet. Das einfachste und anschaulichste Beispiel ist ein Wassertank.

![Abbildung 69: Regelkreis eines simulierten Wassertanks](asset:cyberrange/cr-25-069.png)

**So liest man die Abbildung:**

- Der **Füllstandssensor** liefert den aktuellen Füllstand an die SPS, die ihn als Register bereitstellt.
- Die SPS führt ihr Programm alle 100 ms aus (Zyklus) und schaltet **Zulaufventil** und **Ablaufpumpe** so, dass der Sollwert eingehalten wird – ein klassischer **Regelkreis**.
- Die **HMI** zeigt Werte und Alarme an und erlaubt dem Bedienpersonal, Sollwerte zu ändern.
- Unten steht die **Simulationsformel**: Der Füllstand ändert sich mit Zulauf und Ablauf. Grenzwerte lösen simulierte Alarme aus – es gibt kein echtes Wasser und keinen echten Schaden.
**Physikmodell als Python-Programm (vereinfacht, nur für die Range)**

```
#!/usr/bin/env python3
"""Einfaches Tankmodell: liest Aktoren aus der SPS, berechnet den Füllstand, schreibt den Sensorwert zurück."""
import time
from pymodbus.client import ModbusTcpClient

PLC = ModbusTcpClient("10.20.1.10", port=502)        # Software-SPS in der OT-Zone der Range
level = 60.0                                          # Füllstand in Prozent
ZULAUF, ABLAUF, DT = 4.0, 3.0, 0.1                    # Prozent pro Sekunde, Zykluszeit in Sekunden

PLC.connect()
while True:
    coils = PLC.read_coils(0, count=2).bits           # Spule 0 = Ventil offen, Spule 1 = Pumpe an
    ventil, pumpe = coils[0], coils[1]
    level += (ZULAUF * ventil - ABLAUF * pumpe) * DT  # Physik: Bilanz aus Zu- und Ablauf
    level = max(0.0, min(100.0, level))
    PLC.write_register(0, int(level * 10))            # Sensorwert (Promille) in Holding-Register 0
    if level > 95: print("SIMULATION: Überlauf-Alarm")
    time.sleep(DT)
```

> [!INFO] Warum das didaktisch so wertvoll ist
> Weil das Modell sichtbar reagiert, erleben Teilnehmer unmittelbar, was eine Störung in der OT bedeutet: Werte laufen aus dem Ruder, Alarme erscheinen auf der HMI, Gegenmaßnahmen wirken mit Verzögerung. Gleichzeitig lernt das Blue Team, im Netzverkehr zwischen normalen zyklischen Abfragen und ungewöhnlichen Zugriffen zu unterscheiden.

Hinweis zum Adressbereich: Die OT-Zone erhält im Pilot ein eigenes Präfix (hier 10.20.x.x), damit sie in Firewall-Regeln und Dashboards sofort von der Büro-IT (10.10.x.x) zu unterscheiden ist.
