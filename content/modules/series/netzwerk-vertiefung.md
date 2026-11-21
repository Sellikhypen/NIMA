---
id: nw-01
title: Netzwerk 1 · Ethernet und Switching
paths: grundlagen, cyberrange
order: 50
difficulty: medium
icon: cable.connector
tags: netzwerk
summary: Ethernet-Frames, MAC-Adressen, wie Switches lernen und weiterleiten, Broadcast-Domänen, Duplex, PoE und die Sicherheitsfunktionen moderner Switches.
---

## Der Ethernet-Frame

| Feld | Größe | Inhalt |
|---|---|---|
| Präambel + SFD | 8 Byte | Synchronisation |
| Ziel-MAC | 6 Byte | Empfänger |
| Quell-MAC | 6 Byte | Absender |
| (802.1Q-Tag) | 4 Byte | VLAN-ID, Priorität |
| EtherType | 2 Byte | z. B. 0x0800 IPv4, 0x86DD IPv6, 0x0806 ARP |
| Nutzdaten | 46–1500 Byte | Paket der Schicht 3 |
| FCS | 4 Byte | Prüfsumme |

Eine **MAC-Adresse** hat 48 Bit; die ersten 24 Bit (OUI) kennzeichnen den Hersteller. Die maximale Nutzlast heißt **MTU** (Standard 1500 Byte, Jumbo Frames bis ca. 9000).

## Wie ein Switch arbeitet

1. Er **lernt** die Quell-MAC jedes Frames und merkt sich den Port (MAC-Tabelle / CAM).
2. Er **leitet weiter**: kennt er die Ziel-MAC, nur an diesen Port.
3. Er **flutet** unbekannte Ziele und Broadcasts an alle Ports desselben VLANs.

Eine **Broadcast-Domäne** umfasst alle Geräte, die einen Broadcast empfangen – ohne VLANs ist das der ganze Switch.

## Sicherheitsfunktionen

| Funktion | schützt gegen |
|---|---|
| Port Security (MAC-Limit) | MAC-Flooding, fremde Geräte |
| 802.1X | nicht authentifizierte Geräte |
| DHCP Snooping | fremde DHCP-Server |
| Dynamic ARP Inspection | ARP-Spoofing |
| IP Source Guard | gefälschte Quell-IPs |
| BPDU Guard | fremde Switches, STP-Manipulation |
| Storm Control | Broadcast-Stürme |
| ungenutzte Ports abschalten | Anschluss unbekannter Geräte |

> [!INFO] MAC-Flooding
> Wird die MAC-Tabelle mit gefälschten Adressen überfüllt, flutet ein einfacher Switch allen Verkehr an alle Ports – er verhält sich wie ein Hub. Port Security begrenzt die Zahl der Adressen pro Port.

## Quiz

? Wie viele Bit hat eine MAC-Adresse?
= 48

? Welcher EtherType kennzeichnet IPv4?
= 0x0800

? Was macht ein Switch mit Frames an unbekannte Ziel-MACs?
+ Er flutet sie an alle Ports des VLANs
- Er verwirft sie
- Er schickt sie an den Router
- Er verschlüsselt sie

? Welche Funktion schützt gegen ARP-Spoofing?
= Dynamic ARP Inspection
= DAI

? Wie groß ist die Standard-MTU bei Ethernet?
= 1500

@@@ MODULE @@@
---
id: nw-02
title: Netzwerk 2 · VLANs, Trunks und Spanning Tree
paths: grundlagen, cyberrange, specialist
order: 51
difficulty: medium
icon: square.split.2x2
tags: netzwerk
summary: VLANs nach 802.1Q, Access- und Trunk-Ports, natives VLAN, VLAN-Hopping verstehen und verhindern, Spanning Tree gegen Schleifen.
---

## VLANs

Ein **VLAN** teilt einen physischen Switch in mehrere logische Switches. Geräte in verschiedenen VLANs erreichen sich nur über einen Router bzw. eine Firewall – Grundlage jeder Segmentierung, auch in deiner [[mod:cr-05|Range]].

| Begriff | Bedeutung |
|---|---|
| VLAN-ID | 12 Bit, 1–4094 |
| Access-Port | gehört zu genau einem VLAN, Endgerät sendet ohne Tag |
| Trunk-Port | überträgt mehrere VLANs mit 802.1Q-Tag |
| natives VLAN | Verkehr ohne Tag auf einem Trunk |
| Inter-VLAN-Routing | Router oder Layer-3-Switch verbindet VLANs |

## VLAN-Hopping verstehen

| Variante | Prinzip | Gegenmaßnahme |
|---|---|---|
| Switch Spoofing | ein Endgerät handelt automatisch einen Trunk aus (DTP) | DTP deaktivieren, Ports fest als Access konfigurieren |
| Double Tagging | ein Frame mit zwei Tags gelangt über das native VLAN in ein anderes VLAN | natives VLAN ungenutzt lassen, Tagging des nativen VLANs erzwingen |

## Spanning Tree

Redundante Verbindungen zwischen Switches erzeugen ohne Gegenmaßnahme **Schleifen**: Broadcasts kreisen endlos und legen das Netz lahm. Das **Spanning Tree Protocol** (STP, schneller: RSTP) blockiert redundante Pfade, bis sie gebraucht werden.

- **Root Bridge**: Mittelpunkt des Baums, bewusst festlegen
- **BPDU Guard** auf Endgeräte-Ports: Ein Gerät, das STP-Nachrichten sendet, wird abgeschaltet
- **Root Guard**: verhindert, dass fremde Switches Root werden

## Quiz

? Wie viele Bit hat eine VLAN-ID?
= 12

? Welcher Port-Typ überträgt mehrere VLANs mit Tag?
= Trunk
= Trunk-Port

? Welches Protokoll sollte gegen Switch Spoofing deaktiviert werden?
= DTP

? Wofür ist Spanning Tree zuständig?
+ Schleifen in redundanten Switch-Netzen verhindern
- VLANs verschlüsseln
- IP-Adressen vergeben
- Namen auflösen

? Welche Funktion schaltet Endgeräte-Ports ab, die STP-Nachrichten senden?
= BPDU Guard

@@@ MODULE @@@
---
id: nw-03
title: Netzwerk 3 · Routing und Routingprotokolle
paths: grundlagen, specialist
order: 52
difficulty: medium
icon: point.topleft.down.to.point.bottomright.curvepath
tags: netzwerk
summary: Routing-Tabellen, Longest Prefix Match, statisches und dynamisches Routing, OSPF und BGP im Überblick und Sicherheitsrisiken wie Route-Hijacking.
---

## Die Routing-Entscheidung

Ein Router schaut für jedes Paket in seine **Routing-Tabelle** und wählt den Eintrag mit dem **längsten passenden Präfix** (Longest Prefix Match). Passt nichts Spezifischeres, gilt die **Default Route** (`0.0.0.0/0`).

```text
Ziel             Gateway       Interface
0.0.0.0/0        192.0.2.1     wan
10.10.0.0/16     10.0.0.2      lan
10.10.20.0/24    10.0.0.3      lan      ← gewinnt für 10.10.20.5
```

## Statisch vs. dynamisch

| | statisch | dynamisch |
|---|---|---|
| Pflege | manuell | Router tauschen Routen aus |
| geeignet für | kleine Netze, Default Routes | große Netze, Redundanz |
| Risiko | Fehler bei Änderungen | manipulierte Routing-Updates |

## Routingprotokolle

| Protokoll | Typ | Einsatz |
|---|---|---|
| OSPF | Link State, intern | Unternehmensnetze |
| IS-IS | Link State | Provider |
| EIGRP | Advanced Distance Vector | Cisco-Umgebungen |
| RIP | Distance Vector | veraltet |
| **BGP** | Path Vector, zwischen autonomen Systemen | Internet |

## Sicherheitsaspekte

- **Authentifizierung** der Routingprotokolle (z. B. OSPF mit Kryptografie), damit keine fremden Router Routen einspeisen
- Routingprotokolle nur auf Schnittstellen zu anderen Routern aktivieren (passive interfaces)
- **BGP-Hijacking**: Ein autonomes System kündigt fremde Präfixe an und lenkt Verkehr um. Gegenmaßnahme: **RPKI** (Route Origin Validation), Filter
- Management-Zugänge der Router absichern, Konfigurationsänderungen protokollieren

## Quiz

? Nach welchem Prinzip wählt ein Router zwischen mehreren passenden Routen?
= Longest Prefix Match

? Wie lautet die Default Route in IPv4?
= 0.0.0.0/0

? Welches Protokoll verbindet autonome Systeme im Internet?
= BGP

? Welches Verfahren schützt vor BGP-Hijacking durch Prüfung der Ursprungs-AS?
= RPKI

? Welches Routingprotokoll ist ein Link-State-Protokoll für Unternehmensnetze?
= OSPF

@@@ MODULE @@@
---
id: nw-04
title: Netzwerk 4 · IPv6 vertieft
paths: grundlagen, specialist
order: 53
difficulty: hard
icon: number.circle
tags: netzwerk
summary: Adresstypen, SLAAC und DHCPv6, Neighbor Discovery, ICMPv6, Router Advertisements, Sicherheitsrisiken eines unbeachteten IPv6 und die richtige Absicherung.
---

## Adresstypen

| Typ | Präfix | Zweck |
|---|---|---|
| Global Unicast | `2000::/3` | weltweit routbar |
| Unique Local | `fc00::/7` (praktisch `fd00::/8`) | intern, ähnlich privat |
| Link-Local | `fe80::/10` | immer vorhanden, nur im lokalen Segment |
| Multicast | `ff00::/8` | Gruppen; Broadcast gibt es nicht mehr |
| Loopback | `::1` | der Rechner selbst |

Typisch ist ein **/64** pro Segment; Provider vergeben Präfixe wie /48 oder /56.

## Adressvergabe

| Verfahren | Funktionsweise |
|---|---|
| SLAAC | Hosts bilden ihre Adresse selbst aus dem Präfix im Router Advertisement |
| DHCPv6 | Server vergibt Adressen bzw. Zusatzinformationen |
| Privacy Extensions | wechselnde, zufällige Schnittstellen-IDs |

## Neighbor Discovery (NDP)

NDP ersetzt ARP und nutzt ICMPv6: Router Solicitation/Advertisement, Neighbor Solicitation/Advertisement, Redirect.

> [!WARNUNG] Rogue Router Advertisements
> Wie bei ARP gibt es keine eingebaute Authentifizierung. Ein Gerät kann sich per Router Advertisement als Router anbieten und Verkehr umleiten – selbst in Netzen, die „gar kein IPv6 nutzen“, weil Betriebssysteme IPv6 standardmäßig aktiv haben. Schutz: **RA Guard**, DHCPv6 Guard auf Switches, Monitoring.

## ICMPv6 nicht blind blockieren

ICMPv6 ist für IPv6 essenziell (NDP, Path MTU Discovery). Firewalls müssen benötigte Typen erlauben – pauschales Blockieren bricht das Netz.

## Absicherung

- IPv6 bewusst betreiben oder bewusst deaktivieren – nie „unbeachtet“ laufen lassen
- Firewall-Regeln für IPv4 **und** IPv6
- RA Guard, DHCPv6 Guard
- Logging und Monitoring auch für IPv6-Adressen
- Inventar mit IPv6-Adressen der Systeme

## Quiz

? Welches Präfix haben Link-Local-Adressen?
= fe80::/10

? Welches Protokoll ersetzt ARP in IPv6?
= NDP
= Neighbor Discovery

? Wie bilden Hosts bei SLAAC ihre Adresse?
+ selbst aus dem Präfix im Router Advertisement
- über einen DHCP-Server
- aus der MAC-Adresse des Routers
- gar nicht

? Welche Switch-Funktion schützt vor gefälschten Router Advertisements?
= RA Guard

?tf ICMPv6 kann in IPv6-Netzen bedenkenlos vollständig blockiert werden.
= falsch

@@@ MODULE @@@
---
id: nw-05
title: Netzwerk 5 · Firewalls und Next-Generation-Firewalls
paths: grundlagen, specialist, cyberrange
order: 54
difficulty: medium
icon: flame.circle
tags: netzwerk
summary: Paketfilter, Stateful Inspection, Proxys und NGFW, Regelwerke richtig aufbauen, NAT, Logging und typische Fehler in Firewall-Konfigurationen.
---

## Firewall-Typen

| Typ | prüft | Beispiel |
|---|---|---|
| Paketfilter (stateless) | jedes Paket einzeln nach IP/Port | Router-ACLs |
| Stateful Firewall | Verbindungszustand; Antworten werden automatisch erlaubt | iptables/nftables, OPNsense |
| Application-Level Gateway / Proxy | Inhalte eines Protokolls | Web-Proxy |
| Next-Generation Firewall (NGFW) | Anwendungen, Benutzer, IPS, TLS-Inspektion | große Hersteller |
| Web Application Firewall | HTTP-Anfragen an Webanwendungen | ModSecurity, Cloud-WAF |

## Regelwerk aufbauen

1. **Default Deny** am Ende jeder Richtung
2. spezifische Regeln vor allgemeinen (Reihenfolge zählt, „first match“)
3. Quellen und Ziele so eng wie möglich, keine `any`-Regeln ohne Begründung
4. ausgehenden Verkehr ebenfalls filtern
5. jede Regel mit Zweck, Verantwortlichem, Ticket, Ablaufdatum dokumentieren
6. regelmäßige Rezertifizierung und Aufräumen ungenutzter Regeln (Hit Counts)

> [!WARNUNG] Typische Fehler
> `any → any`-Regeln „zum Testen“, die nie entfernt werden; offene Management-Oberflächen; Regeln für längst abgebaute Systeme; fehlendes Logging für verworfene Pakete; IPv6 vergessen.

## NAT in der Firewall

Source NAT (ausgehend, viele interne Adressen hinter einer öffentlichen) und Destination NAT/Portweiterleitung (eingehend in die DMZ). Portweiterleitungen sind Löcher in der Firewall und gehören dokumentiert und begrenzt – siehe [[mod:cr-05|Range-Kapitel L2]].

## Logging

- verworfene Verbindungen protokollieren (mit Bedacht wegen Datenmenge)
- erlaubte Verbindungen über kritische Regeln protokollieren
- Logs ins SIEM, Alarme bei Regeländerungen

## Quiz

? Was unterscheidet eine stateful Firewall von einem einfachen Paketfilter?
+ Sie kennt den Verbindungszustand und erlaubt Antworten automatisch
- Sie arbeitet nur mit MAC-Adressen
- Sie verschlüsselt den Verkehr
- Sie hat keine Regeln

? Welche Regel steht am Ende eines guten Regelwerks?
= Default Deny

? Welche Firewall-Art schützt speziell Webanwendungen?
= WAF
= Web Application Firewall

? Welche Information hilft, ungenutzte Regeln zu finden?
= Hit Counts
= Hit Count

?tf Ausgehender Verkehr muss nicht gefiltert werden.
= falsch

@@@ MODULE @@@
---
id: nw-06
title: Netzwerk 6 · Netzwerkdienste im Betrieb – NTP, Syslog, SNMP
paths: grundlagen, cdsa, cyberrange
order: 55
difficulty: easy
icon: clock.badge.checkmark
tags: netzwerk
summary: Warum Zeitsynchronisation für Sicherheit unverzichtbar ist, zentrales Logging mit Syslog, Monitoring mit SNMPv3 und wie man diese Dienste absichert.
---

## NTP – gemeinsame Zeit

Ohne synchrone Uhren lassen sich Ereignisse aus Firewall, Server und Client nicht in eine Reihenfolge bringen. Außerdem hängen Kerberos (Standard: maximal 5 Minuten Abweichung), Zertifikatsprüfung und viele Protokolle von korrekter Zeit ab.

| Aspekt | Empfehlung |
|---|---|
| Hierarchie | interne NTP-Server synchronisieren mit vertrauenswürdigen Quellen; Clients nur mit internen Servern |
| Active Directory | der PDC-Emulator ist Zeitquelle der Domäne |
| Sicherheit | NTP nicht öffentlich als offenen Server anbieten (Missbrauch für Verstärkungsangriffe), NTS für authentifizierte Zeit |
| Logs | immer mit Zeitzone, idealerweise UTC |

## Syslog – zentrales Logging

Syslog (UDP/TCP 514, verschlüsselt 6514) transportiert Meldungen mit **Facility** (Quelle, z. B. `auth`, `kern`) und **Severity** (0 Emergency bis 7 Debug). Netzwerkgeräte, Linux-Server und Appliances schicken ihre Logs an einen zentralen Collector oder direkt ins SIEM.

| Severity | Name |
|---|---|
| 0 | Emergency |
| 1 | Alert |
| 2 | Critical |
| 3 | Error |
| 4 | Warning |
| 5 | Notice |
| 6 | Informational |
| 7 | Debug |

## SNMP – Monitoring

SNMP liest Zustände (Interfaces, CPU, Speicher) über **OIDs** aus der **MIB**. Agenten können auch **Traps** senden. Nur **SNMPv3** mit `authPriv` (Authentifizierung und Verschlüsselung) verwenden, Zugriff auf Monitoring-Server beschränken, Schreibzugriff deaktivieren.

## Quiz

? Welche maximale Zeitabweichung erlaubt Kerberos standardmäßig?
= 5 Minuten
= 5

? Welches Domänensystem ist Zeitquelle im Active Directory?
= PDC-Emulator
= PDC

? Welcher Port wird für verschlüsseltes Syslog genutzt?
= 6514

? Welche Syslog-Severity hat den Wert 0?
= Emergency

? Welcher SNMPv3-Modus bietet Authentifizierung und Verschlüsselung?
= authPriv

@@@ MODULE @@@
---
id: nw-07
title: Netzwerk 7 · Fehlersuche systematisch
paths: grundlagen, cyberrange
order: 56
difficulty: easy
icon: stethoscope
tags: netzwerk
summary: Netzwerkprobleme Schicht für Schicht eingrenzen – Methode, Werkzeuge, typische Fehlerbilder und wie man Ursachen sauber dokumentiert.
---

## Die Methode

1. **Problem genau beschreiben** – wer, was, seit wann, wie oft, was hat sich geändert?
2. **Schichtweise prüfen** – von unten (Kabel, Link) nach oben (Anwendung) oder von oben nach unten
3. **Eine Hypothese nach der anderen** testen
4. **Vergleichen** – funktioniert es von einem anderen Rechner, aus einem anderen Netz?
5. **Dokumentieren** – Ursache, Lösung, Vorbeugung

## Werkzeuge je Schicht

| Schicht | Prüfung | Werkzeug |
|---|---|---|
| 1 | Link, Kabel, Funk | Link-LEDs, `ethtool`, Signalstärke |
| 2 | MAC, VLAN | `ip neigh`, Switch-MAC-Tabelle, VLAN-Zuordnung |
| 3 | IP, Routing | `ip a`, `ip r`, `ping`, `traceroute` |
| 4 | Ports, Firewall | `nc -zv`, `Test-NetConnection`, Firewall-Logs |
| 7 | Anwendung, DNS, TLS | `dig`, `curl -v`, `openssl s_client` |

## Typische Fehlerbilder

| Symptom | häufige Ursache |
|---|---|
| Adresse 169.254.x.x | DHCP nicht erreichbar |
| Ping per IP geht, per Name nicht | DNS |
| nur große Pakete/Downloads hängen | MTU-Problem (z. B. VPN, PPPoE) |
| Verbindung bricht nach Minuten ab | Timeout in Firewall/NAT, Session-Tabelle |
| funktioniert nur aus einem VLAN | fehlende Firewall-Regel oder Route |
| Zertifikatsfehler | falscher Hostname, abgelaufen, fehlende Zwischenzertifikate, falsche Uhrzeit |

> [!TIPP] Asymmetrisches Routing
> Wenn Hin- und Rückweg über verschiedene Firewalls laufen, verwirft eine stateful Firewall die Antworten, weil sie den Verbindungsaufbau nie gesehen hat. Ein häufiger und schwer zu findender Fehler.

## Quiz

? Was bedeutet eine Adresse 169.254.x.x?
+ DHCP war nicht erreichbar
- DNS ist ausgefallen
- das VPN ist aktiv
- die Firewall blockiert ICMP

? Ping per IP funktioniert, per Name nicht. Wo liegt das Problem meist?
= DNS

? Welche Ursache hat es oft, wenn nur große Downloads hängen?
= MTU
= MTU-Problem

? Welches Werkzeug prüft TLS-Verbindungen auf der Kommandozeile?
= openssl s_client

? Warum verwirft eine stateful Firewall Antworten bei asymmetrischem Routing?
+ Sie hat den Verbindungsaufbau nie gesehen
- Sie ist überlastet
- Sie blockiert grundsätzlich Antworten
- Sie kennt keine Ports

@@@ MODULE @@@
---
id: nw-08
title: Netzwerk 8 · DDoS verstehen und abwehren
paths: specialist, cdsa
order: 57
difficulty: medium
icon: bolt.horizontal.circle
tags: netzwerk
summary: Arten von Denial-of-Service-Angriffen (volumetrisch, Protokoll, Anwendung), Verstärkungsangriffe, Erkennung und mehrstufige Abwehr mit Provider, CDN und Architektur.
---

## Arten von DDoS

| Art | Ziel | Beispiel |
|---|---|---|
| volumetrisch | Bandbreite überlasten | UDP-Fluten, Verstärkungsangriffe |
| Protokoll | Zustandstabellen erschöpfen | SYN-Flood |
| Anwendung (Layer 7) | Server-Ressourcen binden | viele teure HTTP-Anfragen |

## Verstärkung (Amplification)

Angreifer senden kleine Anfragen mit gefälschter Absenderadresse (der des Opfers) an offene Dienste, die große Antworten schicken – etwa offene DNS-Resolver, NTP-, Memcached- oder CLDAP-Server. Das Opfer wird mit Antworten überschwemmt.

> [!MERKE] Teil des Problems nicht sein
> Eigene Dienste dürfen nicht als Verstärker missbrauchbar sein: keine offenen Resolver, NTP und SNMP nicht öffentlich, Ingress-Filterung gegen gefälschte Absender (BCP 38).

## Erkennung

- plötzlicher Anstieg von Verkehr, Verbindungen oder Anfragen pro Sekunde
- viele halb offene Verbindungen (SYN-Flood)
- ungewöhnliche Quellländer oder User-Agents
- Monitoring auf Provider-, Firewall- und Anwendungsebene

## Abwehr

| Ebene | Maßnahme |
|---|---|
| Provider / Scrubbing | Verkehrsreinigung vor dem eigenen Anschluss |
| CDN / Anycast | Last auf viele Standorte verteilen |
| Netzwerk | SYN-Cookies, Rate Limits, Geo-Filter im Notfall |
| Anwendung | Caching, teure Funktionen schützen, Bot-Erkennung |
| Organisation | DDoS-Notfallplan, Kontakt zum Provider, Übungen |

## Quiz

? Welcher DDoS-Typ zielt auf die Bandbreite?
= volumetrisch

? Wie heißt ein Angriff, bei dem kleine gefälschte Anfragen große Antworten an das Opfer auslösen?
= Amplification
= Verstärkungsangriff

? Welche Technik schützt Server gegen SYN-Floods?
= SYN-Cookies
= SYN Cookies

? Welche Best Practice verhindert gefälschte Absenderadressen aus dem eigenen Netz?
= BCP 38
= Ingress-Filterung

? Welche Dienste werden häufig für Verstärkungsangriffe missbraucht?
+ offene DNS-Resolver
+ öffentliche NTP-Server
- interne Drucker
- Bluetooth-Kopfhörer
