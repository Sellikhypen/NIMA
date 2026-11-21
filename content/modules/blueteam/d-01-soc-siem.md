---
id: d-01
title: SOC und SIEM-Grundlagen
paths: cdsa, cjca
order: 1
difficulty: easy
icon: display.2
summary: Wie ein Security Operations Center arbeitet, was ein SIEM tut, Log-Quellen, Use Cases, Alarm-Triage, Analysten-Stufen und die wichtigsten Frameworks.
htb: Security Monitoring & SIEM Fundamentals
---

## Das Security Operations Center

Ein **[[SOC]]** überwacht die IT einer Organisation rund um die Uhr, erkennt Angriffe und koordiniert die Reaktion. Es besteht aus Menschen, Prozessen und Technik.

| Stufe | Aufgabe |
|---|---|
| Tier 1 – Triage | Alarme sichten, Fehlalarme aussortieren, eskalieren |
| Tier 2 – Incident Responder | tiefe Analyse, Eindämmung, Koordination |
| Tier 3 – Threat Hunter / Experte | proaktive Suche, Detection Engineering, Malware-Analyse |
| SOC-Manager | Prozesse, Kennzahlen, Personal |

## Was ist ein SIEM?

Ein **[[SIEM]]** (Security Information and Event Management) sammelt Logs aus vielen Quellen, normalisiert sie, korreliert Ereignisse und löst Alarme aus.

1. **Sammeln** – Agenten, Syslog, APIs
2. **Parsen und Normalisieren** – Felder wie `src_ip`, `user`, `event_id` vereinheitlichen
3. **Anreichern** – Geo-IP, Asset-Informationen, Threat Intelligence
4. **Korrelieren** – Regeln über mehrere Ereignisse hinweg
5. **Alarmieren und Visualisieren** – Dashboards, Tickets
6. **Speichern** – für Untersuchungen und Compliance

Bekannte Produkte: Splunk, Elastic Security, Microsoft Sentinel, IBM QRadar, Wazuh (Open Source, in deiner [[mod:cr-08|Range]]).

## Wichtige Log-Quellen

| Quelle | Was man erkennt |
|---|---|
| Windows Security Log | Anmeldungen, Kontoänderungen, Rechtevergaben |
| [[Sysmon]] | Prozessstarts mit Befehlszeile, Netzwerkverbindungen, Dateierstellung |
| PowerShell-Logs | ausgeführte Skripte |
| Firewall / Proxy | Verbindungen, blockierte Zugriffe, Ziele im Internet |
| DNS-Logs | Abfragen zu verdächtigen Domains |
| [[EDR]] | Verhalten auf Endpunkten |
| Authentifizierung (AD, VPN, Cloud) | ungewöhnliche Logins, Impossible Travel |
| Web-/Anwendungslogs | Angriffe auf Anwendungen |

> [!MERKE] Ohne Logs keine Erkennung
> Viele Organisationen sammeln die falschen Logs oder gar keine. Bevor man Regeln schreibt, muss die **Audit-Richtlinie** stimmen – das zeigt auch [[mod:cr-08|Kapitel L5]] deiner Range.

## Use Cases und Alarm-Triage

Ein **Use Case** beschreibt, welches Verhalten erkannt werden soll, mit welchen Daten und wie zu reagieren ist – z. B. „viele fehlgeschlagene Anmeldungen gefolgt von einer erfolgreichen“.

Bei der Triage fragt sich der Analyst:

1. Was genau hat ausgelöst? (Regel, Rohdaten)
2. Ist es plausibel? (Kontext: Benutzer, Gerät, Uhrzeit, übliches Verhalten)
3. Wie kritisch ist das betroffene Asset?
4. Gibt es weitere Indizien? (Pivot über Benutzer, Host, IP, Hash)
5. **True Positive**, **False Positive** oder **Benign True Positive**? Dokumentieren, eskalieren oder schließen.

| Ergebnis | Bedeutung |
|---|---|
| True Positive | echter Angriff korrekt erkannt |
| False Positive | Alarm, aber kein Angriff |
| False Negative | Angriff, aber kein Alarm – der gefährlichste Fall |
| True Negative | kein Angriff, kein Alarm |

## Frameworks

- **[[MITRE ATT&CK]]** – Wissensbasis über Taktiken und Techniken von Angreifern (z. B. T1059 Command and Scripting Interpreter). Ideal, um Erkennungslücken sichtbar zu machen.
- **Cyber Kill Chain** (Lockheed Martin) – Reconnaissance, Weaponization, Delivery, Exploitation, Installation, Command & Control, Actions on Objectives.
- **Pyramid of Pain** – je weiter oben ein Indikator (Hash → IP → Domain → Artefakte → Tools → TTPs), desto mehr schmerzt es den Angreifer, wenn wir ihn erkennen.

## Quiz

? Wofür steht SIEM?
= Security Information and Event Management

? Welche SOC-Stufe sichtet Alarme zuerst?
= Tier 1
= 1

? Welcher Fall ist für ein SOC am gefährlichsten?
+ False Negative
- False Positive
- True Positive
- True Negative

?order Bringe die Phasen der Cyber Kill Chain in Reihenfolge
> Reconnaissance
> Weaponization
> Delivery
> Exploitation
> Installation
> Command & Control
> Actions on Objectives

? Welcher Indikator steht in der Pyramid of Pain ganz oben?
+ TTPs
- Hashwerte
- IP-Adressen
- Domainnamen

? Welches Framework katalogisiert Taktiken und Techniken realer Angreifer?
= MITRE ATT&CK
= ATT&CK

? Welches Open-Source-SIEM/XDR nutzt deine Cyber Range?
= Wazuh
