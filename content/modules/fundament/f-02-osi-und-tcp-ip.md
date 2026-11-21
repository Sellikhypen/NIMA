---
id: f-02
title: Netzwerkmodelle – OSI und TCP/IP
paths: grundlagen, cjca
order: 2
difficulty: easy
icon: square.3.layers.3d
summary: Die zwei Landkarten der Netzwerkwelt. Wer die Schichten versteht, kann jedes Protokoll, jedes Tool und jeden Angriff einordnen.
---

## Warum es Schichtenmodelle gibt

Netzwerkkommunikation ist kompliziert: Strom auf einem Kabel, Funkwellen, Adressen, Wegfindung, verlorene Pakete, Verschlüsselung, Webseiten. Niemand könnte das als ein einziges Programm bauen. Deshalb teilt man die Aufgabe in **Schichten**. Jede Schicht erledigt eine Aufgabe und nutzt die Dienste der Schicht darunter.

> [!ANALOGIE] Ein Brief
> Du schreibst einen Brief (Inhalt), steckst ihn in einen Umschlag mit Adresse (Transport), die Post sortiert ihn nach Postleitzahl (Vermittlung) und ein Fahrzeug bringt ihn zum nächsten Verteilzentrum (Übertragung). Du musst nicht wissen, welcher LKW fährt – und der Fahrer liest deinen Brief nicht.

## Das OSI-Modell (7 Schichten)

| Nr. | Schicht | Aufgabe | Beispiele | Dateneinheit |
|---|---|---|---|---|
| 7 | Anwendung (Application) | Dienste für Programme | HTTP, DNS, SMTP, SSH | Daten |
| 6 | Darstellung (Presentation) | Format, Kodierung, Verschlüsselung | TLS, UTF-8, JPEG | Daten |
| 5 | Sitzung (Session) | Verbindungen verwalten | NetBIOS-Session, RPC | Daten |
| 4 | Transport | Ende-zu-Ende, Ports, Zuverlässigkeit | [[TCP]], [[UDP]] | Segment / Datagramm |
| 3 | Vermittlung (Network) | logische Adressen, Routing | [[IP-Adresse|IP]], ICMP | Paket |
| 2 | Sicherung (Data Link) | Rahmen im lokalen Netz, MAC | Ethernet, WLAN, [[ARP]], [[VLAN]] | Frame |
| 1 | Bitübertragung (Physical) | Signale auf dem Medium | Kabel, Funk, Glasfaser | Bits |

> [!MERKE] Eselsbrücke
> Von unten nach oben: **P**lease **D**o **N**ot **T**hrow **S**ausage **P**izza **A**way – Physical, Data Link, Network, Transport, Session, Presentation, Application.

## Das TCP/IP-Modell (4 Schichten)

In der Praxis arbeitet das Internet mit dem einfacheren TCP/IP-Modell:

| TCP/IP-Schicht | entspricht OSI | Beispiele |
|---|---|---|
| Anwendung | 5–7 | HTTP, DNS, FTP, SMB |
| Transport | 4 | TCP, UDP |
| Internet | 3 | IPv4, IPv6, ICMP |
| Netzzugang (Link) | 1–2 | Ethernet, WLAN |

Das OSI-Modell ist das Vokabular („ein Layer-2-Problem“), TCP/IP ist die Realität.

## Kapselung: wie ein Paket entsteht

Wenn du eine Webseite aufrufst, wird die Anfrage auf dem Weg nach unten in immer neue Umschläge gepackt (**Kapselung / Encapsulation**):

1. Der Browser erzeugt eine HTTP-Anfrage (Anwendung).
2. TCP fügt einen Header mit Quell- und Zielport hinzu (Transport).
3. IP fügt Quell- und Ziel-IP hinzu (Internet).
4. Ethernet fügt Quell- und Ziel-MAC sowie eine Prüfsumme hinzu (Link).
5. Die Netzwerkkarte sendet Bits.

Beim Empfänger wird in umgekehrter Reihenfolge ausgepackt (**Decapsulation**).

> [!INFO] Router und Switches lesen nicht alles
> Ein [[Switch]] schaut nur bis Schicht 2 (MAC-Adressen). Ein [[Router]] bis Schicht 3 (IP). Eine [[Firewall]] meist bis Schicht 4 (Ports), moderne „Next-Generation“-Firewalls auch bis Schicht 7.

## Schichten und Sicherheit

Jede Schicht hat ihre eigenen Schwachstellen und Schutzmechanismen. Wer ein Problem einer Schicht zuordnen kann, findet schneller die richtige Gegenmaßnahme.

| Schicht | typische Bedrohung | typische Schutzmaßnahme |
|---|---|---|
| 1 | Abhören von Funk, physischer Zugang | Zutrittskontrolle, abgeschirmte Kabel |
| 2 | [[ARP-Spoofing]], MAC-Flooding, VLAN-Hopping | Port Security, Dynamic ARP Inspection, 802.1X |
| 3 | IP-Spoofing, Routing-Manipulation | Ingress-/Egress-Filter, Segmentierung |
| 4 | Port-Scans, SYN-Flood | Firewall-Regeln, SYN-Cookies, Rate Limits |
| 5–6 | Session-Übernahme, schwache Verschlüsselung | aktuelles [[TLS]], sichere Session-Verwaltung |
| 7 | Injection, fehlerhafte Authentifizierung | sichere Programmierung, [[WAF]], Patches |

> [!EXAM] Prüfungstipp
> Fragen wie „Auf welcher OSI-Schicht arbeitet ARP?“ (2) oder „Welche Schicht nutzt Portnummern?“ (4) sind Klassiker in Einsteiger-Zertifizierungen.

## Ports – die Hausnummern der Dienste

Eine IP-Adresse identifiziert einen Rechner, ein [[Port]] den Dienst darauf. Ports sind 16-Bit-Zahlen (0–65535):

- **0–1023**: Well-known Ports (z. B. 22 SSH, 80 HTTP, 443 HTTPS)
- **1024–49151**: registrierte Ports (z. B. 3306 MySQL, 3389 RDP)
- **49152–65535**: dynamische / ephemere Ports für Client-Verbindungen

Eine Verbindung wird eindeutig durch das **5-Tupel** beschrieben: Protokoll, Quell-IP, Quellport, Ziel-IP, Zielport.

## Quiz

? Auf welcher OSI-Schicht arbeitet ein Router?
= 3
= Schicht 3
= Vermittlungsschicht
= Network

? Auf welcher OSI-Schicht arbeitet ein klassischer Switch?
= 2
= Schicht 2
= Sicherungsschicht

? Welche OSI-Schicht ist für Portnummern zuständig?
+ Transport (4)
- Sitzung (5)
- Vermittlung (3)
- Anwendung (7)

?order Ordne die OSI-Schichten von unten nach oben
> Bitübertragung
> Sicherung
> Vermittlung
> Transport
> Sitzung
> Darstellung
> Anwendung

? Wie nennt man das schrittweise Hinzufügen von Headern beim Senden?
= Kapselung
= Encapsulation

? Wie heißt die Dateneinheit auf Schicht 2?
+ Frame
- Paket
- Segment
- Bit

? Wie viele Schichten hat das TCP/IP-Modell?
= 4
= vier

? Welcher Portbereich gilt als „well-known“?
+ 0–1023
- 1024–49151
- 49152–65535
- 0–65535

? Welche Angaben bilden das 5-Tupel einer Verbindung?
+ Protokoll, Quell-IP, Quellport, Ziel-IP, Zielport
- MAC, IP, Port, TTL, Prüfsumme
- Hostname, Domain, Port, Pfad, Protokoll
- Quell-IP, Ziel-IP, VLAN, MTU, Port
