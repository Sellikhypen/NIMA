---
id: c-02
title: Netzwerk-Enumeration verstehen
paths: cpts, cjca
order: 2
difficulty: easy
icon: dot.radiowaves.up.forward
summary: Wie Host Discovery, Port-Scans und Diensterkennung technisch funktionieren, wie man Ergebnisse liest und bewertet – und was Verteidiger daraus über ihre Angriffsfläche lernen.
htb: Network Enumeration with Nmap
---

## Ziel der Enumeration

Enumeration beantwortet: **Welche Systeme existieren, welche Dienste bieten sie an, in welcher Version, und was verraten sie?** Für Verteidiger ist dieselbe Frage die Grundlage des **Attack Surface Managements** – man kann nur schützen, was man kennt.

> [!INFO] Deine Notizen
> Die Fragen aus deinen Nmap-Notizen (Host Discovery, Port-Zustände, NSE, Performance, Firewall-Verhalten) sind diesem Modul zugeordnet und tauchen im Modul-Quiz auf.

## Die Bausteine eines Scans

| Phase | Frage | Technik |
|---|---|---|
| Host Discovery | Wer ist online? | ARP im lokalen Netz, ICMP Echo, TCP/UDP-Probes |
| Port-Scan | Welche Ports sind offen? | SYN-Scan (halb offen), Connect-Scan (vollständiger Handshake), UDP-Scan |
| Diensterkennung | Was läuft dort? | Banner, Protokoll-Probes, Signaturvergleich |
| OS-Erkennung | Welches System? | Eigenheiten des TCP/IP-Stacks, TTL |
| Skripte | Details | gezielte Abfragen pro Dienst |

Die Port-Zustände (`open`, `closed`, `filtered` …) und ihre Bedeutung kennst du aus [[mod:f-04|TCP, UDP und Dienste]].

## Ergebnisse lesen

```text
PORT     STATE SERVICE  VERSION
22/tcp   open  ssh      OpenSSH 8.9p1 Ubuntu
80/tcp   open  http     Apache httpd 2.4.52
445/tcp  open  microsoft-ds?
3306/tcp open  mysql    MySQL 8.0.36
Service Info: OS: Linux
```

Was man daraus ableitet:

- **Betriebssystem und Distribution** aus Bannern („Ubuntu“)
- **Versionen** → Abgleich mit Schwachstellendatenbanken (CVE, Hersteller-Advisories)
- **unerwartete Dienste** – eine Datenbank, die direkt erreichbar ist, ist oft schon ein Befund
- **Rolle des Systems** (Webserver, Dateiserver, Domain Controller)

> [!TIPP] Sauber arbeiten
> Ergebnisse immer speichern (alle Formate), zuerst schnell und breit, dann gezielt und tief scannen, UDP nicht vergessen und jeden Fund manuell verifizieren. Automatische Ergebnisse sind Hinweise, keine Beweise.

## Rücksicht auf die Zielumgebung

Scans erzeugen Last. Aggressive Einstellungen können empfindliche Systeme (OT-Anlagen, alte Drucker, Embedded-Geräte) stören. Im Scope steht, welche Intensität erlaubt ist; im Zweifel langsamer scannen und kritische Systeme ausnehmen.

## Die Verteidigersicht

| Beobachtung | Gegenmaßnahme |
|---|---|
| unnötige Dienste offen | abschalten, Firewall-Regeln |
| Management-Dienste (RDP, SSH, Datenbanken) aus vielen Netzen erreichbar | nur aus Admin-Netz bzw. über VPN/Jump-Host |
| detaillierte Banner | Banner reduzieren – aber vor allem patchen |
| Scans bleiben unbemerkt | IDS-Regeln, Firewall-Logs ins SIEM, Alarm bei vielen Verbindungsversuchen auf viele Ports |

> [!MERKE] Regelmäßig selbst scannen
> Unternehmen sollten ihre eigene Angriffsfläche regelmäßig von außen und innen scannen und die Ergebnisse mit dem Soll-Zustand vergleichen. Neue offene Ports sind ein Änderungsereignis, das jemand erklären können muss.

## Quiz

? Welche Information ist Grundlage des Attack Surface Managements?
+ welche Systeme und Dienste erreichbar sind
- welche Farben die Webseite hat
- wie viele Mitarbeiter es gibt
- welches Antivirenprogramm genutzt wird

? Welcher Scan baut den TCP-Handshake vollständig auf?
= Connect-Scan
= -sT
= TCP Connect

? Was ist bei einer direkt aus dem Internet erreichbaren Datenbank meist der Befund?
+ unnötig exponierter Dienst
- korrekte Konfiguration
- ein IDS-Fehlalarm
- ein Netzwerkdrucker

?tf Automatische Scan-Ergebnisse sind Beweise und müssen nicht verifiziert werden.
= falsch

? Warum können aggressive Scans riskant sein?
+ Sie können empfindliche Systeme wie OT-Anlagen stören
- Sie sind immer illegal
- Sie finden keine Ports
- Sie löschen Daten
