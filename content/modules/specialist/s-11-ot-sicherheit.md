---
id: s-11
title: OT- und Industriesicherheit
paths: specialist, cyberrange
order: 11
difficulty: hard
icon: gearshape.arrow.triangle.2.circlepath
summary: Was OT von IT unterscheidet, das Purdue-Modell, Industrieprotokolle, IEC 62443 mit Zonen und Conduits, typische Risiken und die Besonderheiten bei Prüfungen in Anlagen.
---

## IT vs. OT

**Operational Technology (OT)** steuert physische Prozesse: Kraftwerke, Wasserwerke, Fabriken, Gebäudetechnik.

| | IT | OT |
|---|---|---|
| wichtigstes Schutzziel | Vertraulichkeit | **Verfügbarkeit und Sicherheit von Menschen** (Safety) |
| Lebensdauer | 3–5 Jahre | 15–30 Jahre |
| Patchen | regelmäßig | selten, oft nur in Wartungsfenstern oder gar nicht |
| Echtzeit | meist unkritisch | oft kritisch |
| Folgen eines Fehlers | Datenverlust | Produktionsausfall, Umweltschäden, Gefahr für Leib und Leben |

## Das Purdue-Modell

| Ebene | Inhalt |
|---|---|
| 5 | Unternehmensnetz, Internet |
| 4 | Geschäftsplanung, ERP |
| 3.5 | **Industrial DMZ** – Übergang IT/OT |
| 3 | Betriebsführung, Historian, Engineering-Stationen |
| 2 | Leitsysteme, SCADA, HMI |
| 1 | Steuerungen (SPS/PLC, RTU) |
| 0 | Sensoren und Aktoren |

Verkehr zwischen IT und OT läuft ausschließlich über die Industrial DMZ – nie direkt.

## Industrieprotokolle

| Protokoll | Einsatz | Sicherheitsproblem |
|---|---|---|
| Modbus/TCP (502) | Steuerungen | keine Authentifizierung |
| S7comm (102) | Siemens-Steuerungen | ältere Versionen ohne Schutz |
| DNP3 (20000) | Energie, Wasser | Secure Authentication optional |
| OPC UA (4840) | modernes Interoperabilitätsprotokoll | Sicherheit konfigurierbar – muss aktiviert werden |
| BACnet | Gebäudeautomation | oft ungeschützt erreichbar |
| PROFINET, EtherNet/IP | Feldebene | für geschützte Netze konzipiert |

> [!GEFAHR] Vorsicht bei Prüfungen
> Schon ein aggressiver Port-Scan kann alte Steuerungen zum Absturz bringen. OT-Prüfungen erfolgen bevorzugt passiv (Verkehrsanalyse), mit Herstellerabstimmung, in Testumgebungen oder Wartungsfenstern und nie ohne die Betreiber vor Ort. Deine Cyber Range bildet OT deshalb gezielt nach – siehe [[mod:cr-25|OT/ICS-Range]].

## IEC 62443

Die Normenreihe **IEC 62443** ist der Standard für industrielle Cybersicherheit.

| Konzept | Bedeutung |
|---|---|
| Zonen | Gruppen von Komponenten mit gleichem Schutzbedarf |
| Conduits | kontrollierte Kommunikationswege zwischen Zonen |
| Security Levels (SL 1–4) | Schutz gegen zunehmend fähige Angreifer |
| Rollen | Betreiber, Integrator, Hersteller mit eigenen Anforderungen |

## Typische Risiken und Maßnahmen

| Risiko | Maßnahme |
|---|---|
| flache Netze zwischen IT und OT | Segmentierung nach Purdue/IEC 62443 |
| Fernwartungszugänge von Dienstleistern | zentrale, protokollierte Fernwartungslösung mit MFA und Freigabe |
| ungepatchte Systeme | kompensierende Maßnahmen, Allowlisting, Monitoring |
| USB-Sticks als Datenträger | Datenschleusen, Malware-Prüfung |
| fehlende Sichtbarkeit | passive OT-Monitoring-Lösungen, Asset-Inventar |

## Quiz

? Welches Schutzziel hat in der OT Vorrang?
+ Verfügbarkeit und Safety
- Vertraulichkeit
- Anonymität
- Nichtabstreitbarkeit

? Welche Purdue-Ebene ist der kontrollierte Übergang zwischen IT und OT?
= 3.5
= Industrial DMZ

? Auf welcher Purdue-Ebene liegen SPS-Steuerungen?
= 1
= Ebene 1

? Welches Industrieprotokoll auf Port 502 hat keine Authentifizierung?
= Modbus
= Modbus/TCP

? Welche Normenreihe ist der Standard für industrielle Cybersicherheit?
= IEC 62443

? Wie heißen bei IEC 62443 die kontrollierten Kommunikationswege zwischen Zonen?
= Conduits

?tf Aggressive Port-Scans sind in OT-Netzen unbedenklich.
= falsch
