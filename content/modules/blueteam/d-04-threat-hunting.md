---
id: d-04
title: Threat Hunting und Threat Intelligence
paths: cdsa
order: 4
difficulty: hard
icon: binoculars
summary: Proaktiv nach Angreifern suchen – Hypothesen, Datenquellen, ATT&CK-basiertes Hunting, Indikatoren, Threat-Intelligence-Typen und wie aus einem Fund eine Erkennungsregel wird.
htb: Introduction to Threat Hunting & Hunting With Elastic
---

## Was ist Threat Hunting?

**Threat Hunting** ist die proaktive Suche nach Angreifern, die von den vorhandenen Regeln nicht erkannt wurden. Grundannahme: *Assume Breach* – jemand ist bereits im Netz. Hunting schließt die Lücke zwischen automatischer Erkennung und tatsächlichem Angreiferverhalten.

## Arten des Huntings

| Ansatz | Ausgangspunkt | Beispiel |
|---|---|---|
| hypothesengetrieben | Annahme über Angreiferverhalten | „Ein Angreifer nutzt geplante Aufgaben zur Persistenz.“ |
| indikatorgetrieben | bekannte [[IOC|IOCs]] aus Threat Intelligence | Hashes oder Domains aus einem aktuellen Bericht |
| datengetrieben / Anomalie | Statistik, Ausreißer | seltene Prozesse, ungewöhnliche Datenmengen |
| TTP-basiert | [[MITRE ATT&CK]]-Techniken | Suche nach typischen Mustern einer Technik |

## Der Hunting-Zyklus

1. **Hypothese** formulieren (z. B. aus ATT&CK, Threat-Intel, Erfahrung)
2. **Daten** bestimmen und prüfen, ob sie vorhanden sind
3. **Untersuchen** – Abfragen, Statistik, Visualisierung
4. **Ergebnis** bewerten – Fund, kein Fund, Datenlücke
5. **Verbessern** – neue Erkennungsregel, bessere Logs, Dokumentation

> [!MERKE] Auch „nichts gefunden“ ist ein Ergebnis
> Wenn eine Hypothese keinen Treffer liefert, weiß man entweder, dass die Umgebung sauber ist – oder dass Daten fehlen. Beides ist wertvoll und gehört dokumentiert.

## Beispiel-Hypothesen

| Hypothese | Datenquelle | Hinweis |
|---|---|---|
| Persistenz über Run-Keys | Sysmon 13, Autoruns-Inventar | neue Einträge mit Pfaden in AppData |
| Datenabfluss über DNS | DNS-Logs | sehr lange Subdomains, hohe Abfragerate an eine Domain |
| Beaconing zu Kontrollservern | Proxy/Firewall | regelmäßige Verbindungen in festen Intervallen |
| Missbrauch legitimer Admin-Tools | Prozesslogs | PsExec, WMI, WinRM von untypischen Quellen |
| Credential Access | Sysmon 10 | Zugriffe auf LSASS durch untypische Prozesse |

> [!TIPP] Beaconing finden
> Schadsoftware meldet sich oft in festen Abständen beim Kontrollserver. Wer Verbindungen pro Ziel gruppiert und die Zeitabstände betrachtet, erkennt auffällig gleichmäßige Muster – auch wenn der Inhalt verschlüsselt ist.

## Threat Intelligence

| Ebene | Zielgruppe | Inhalt |
|---|---|---|
| strategisch | Management | Trends, Motive, Risiken für die Branche |
| taktisch | Security-Team | TTPs von Angreifergruppen |
| operativ | Incident Response | konkrete Kampagnen, Zeitpunkte |
| technisch | Werkzeuge, SIEM | IOCs: Hashes, IPs, Domains, URLs |

Formate und Plattformen: **STIX/TAXII** (Austauschstandards), **MISP** (Open-Source-Plattform), Berichte von CERTs und Herstellern.

> [!INFO] Indikatoren altern
> IPs und Domains wechseln schnell, Hashes ändern sich mit jeder neuen Variante. Verhalten (TTPs) bleibt viel länger gleich – siehe Pyramid of Pain im Modul [[mod:d-01|SOC und SIEM]].

## Vom Fund zur Regel

Jeder Hunting-Erfolg sollte in eine dauerhafte Erkennung münden: Sigma-Regel schreiben (siehe [[mod:d-07|YARA und Sigma]]), testen, Fehlalarme minimieren, dokumentieren, mit ATT&CK-Technik verknüpfen. Diesen Kreislauf beschreibt deine Range im Kapitel [[mod:cr-23|Detection Engineering und Purple Teaming]].

## Quiz

? Welche Grundannahme steckt hinter Threat Hunting?
= Assume Breach

? Wie nennt man Hunting, das von einer Annahme über Angreiferverhalten ausgeht?
= hypothesengetrieben
= hypothesengetriebenes Hunting

? Welche Threat-Intelligence-Ebene richtet sich an das Management?
= strategisch

? Welche Standards dienen dem Austausch von Threat Intelligence?
+ STIX
+ TAXII
- SMTP
- SNMP

? Wie heißt die bekannte Open-Source-Plattform für Threat Intelligence?
= MISP

? Was deutet auf Beaconing hin?
+ regelmäßige Verbindungen zu einem Ziel in festen Zeitabständen
- ein einzelner Webseitenaufruf
- ein Druckauftrag
- eine fehlgeschlagene Anmeldung

?tf Ein Hunt ohne Fund ist wertlos.
= falsch
