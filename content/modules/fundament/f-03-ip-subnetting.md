---
id: f-03
title: IP-Adressen, Subnetting und IPv6
paths: grundlagen, cjca
order: 3
difficulty: medium
icon: point.3.filled.connected.trianglepath.dotted
summary: IPv4-Aufbau, private Bereiche, CIDR-Notation, Subnetze sicher berechnen, NAT und die Grundlagen von IPv6.
---

## Aufbau einer IPv4-Adresse

Eine [[IP-Adresse|IPv4-Adresse]] ist eine 32-Bit-Zahl, geschrieben als vier Dezimalzahlen (Oktette) von 0 bis 255: `192.168.10.25`. Jede Adresse besteht aus zwei Teilen:

- **Netzanteil** – welches Netz?
- **Hostanteil** – welches Gerät im Netz?

Wo die Grenze liegt, bestimmt die [[Subnetzmaske]].

## Subnetzmaske und CIDR

Die Maske ist ebenfalls 32 Bit lang: Einsen markieren den Netzanteil, Nullen den Hostanteil. Die **CIDR-Notation** schreibt einfach die Anzahl der Einsen:

| CIDR | Maske | Adressen | nutzbare Hosts |
|---|---|---|---|
| /8 | 255.0.0.0 | 16.777.216 | 16.777.214 |
| /16 | 255.255.0.0 | 65.536 | 65.534 |
| /24 | 255.255.255.0 | 256 | 254 |
| /25 | 255.255.255.128 | 128 | 126 |
| /26 | 255.255.255.192 | 64 | 62 |
| /27 | 255.255.255.224 | 32 | 30 |
| /28 | 255.255.255.240 | 16 | 14 |
| /30 | 255.255.255.252 | 4 | 2 |
| /32 | 255.255.255.255 | 1 | Einzelhost |

> [!MERKE] Formel
> Adressen pro Netz = 2^(32 − Präfix). Nutzbare Hosts = Adressen − 2, denn die erste Adresse ist die **Netzadresse** und die letzte die **Broadcast-Adresse**.

## Ein Subnetz berechnen – Schritt für Schritt

Gegeben: `10.10.14.77/27`

1. /27 → 32 Adressen pro Netz (Blockgröße 32).
2. Die Netze beginnen bei Vielfachen von 32 im letzten Oktett: 0, 32, 64, 96 …
3. 77 liegt zwischen 64 und 95 → **Netzadresse 10.10.14.64**.
4. **Broadcast** = nächste Netzadresse − 1 = **10.10.14.95**.
5. **Hostbereich**: 10.10.14.65 bis 10.10.14.94 (30 Hosts).

> [!PRAXIS] Warum Pentester und Admins das brauchen
> Wenn du nach einem Zugang die Konfiguration eines Rechners siehst (`10.129.5.20/23`), musst du sofort wissen, welcher Adressbereich zu diesem Netz gehört – für Dokumentation, Scope-Prüfung und Firewall-Regeln gleichermaßen.

## Private und besondere Adressbereiche

| Bereich | Zweck |
|---|---|
| 10.0.0.0/8 | privat (RFC 1918) |
| 172.16.0.0/12 | privat (172.16.0.0 – 172.31.255.255) |
| 192.168.0.0/16 | privat |
| 127.0.0.0/8 | Loopback (der Rechner selbst) |
| 169.254.0.0/16 | Link-Local (APIPA – kein DHCP erreichbar) |
| 100.64.0.0/10 | Carrier-Grade-NAT |
| 224.0.0.0/4 | Multicast |

Private Adressen werden im Internet nicht geroutet. Damit Geräte trotzdem ins Internet kommen, gibt es [[NAT]].

## NAT – Network Address Translation

Ein Router mit NAT ersetzt die private Quelladresse ausgehender Pakete durch seine öffentliche Adresse und merkt sich die Zuordnung in einer Tabelle. Antworten werden anhand dieser Tabelle zurückübersetzt.

> [!INFO] NAT ist keine Firewall
> NAT verhindert nebenbei, dass Verbindungen von außen ungefragt ankommen. Das ist aber ein Nebeneffekt, kein Sicherheitskonzept. Eine echte Firewall-Policy ersetzt es nicht – besonders nicht bei IPv6, wo NAT meist fehlt.

**Portweiterleitung** (Destination NAT) öffnet gezielt einen Dienst nach innen, zum Beispiel einen Webserver in der [[DMZ]].

## Segmentierung als Sicherheitsprinzip

Subnetze sind nicht nur Ordnung, sondern Sicherheit. Wer Server, Clients, Verwaltung und Gäste in getrennte Netze legt und dazwischen filtert, begrenzt, wie weit sich ein Angreifer nach einem Einbruch bewegen kann ([[Lateral Movement]]). Dieses Prinzip heißt [[Netzsegmentierung]] und ist Kernbestandteil jeder Sicherheitsarchitektur – auch deiner [[mod:cr-05|Cyber Range]].

## IPv6 in Kürze

IPv6-Adressen haben 128 Bit und werden hexadezimal in acht Blöcken geschrieben: `2001:0db8:0000:0000:0000:ff00:0042:8329`. Führende Nullen dürfen entfallen, und **eine** Folge von Null-Blöcken darf durch `::` ersetzt werden: `2001:db8::ff00:42:8329`.

| Präfix | Bedeutung |
|---|---|
| ::1 | Loopback |
| fe80::/10 | Link-Local (immer vorhanden) |
| fc00::/7 | Unique Local (ähnlich privat) |
| 2000::/3 | global routbar |

> [!WARNUNG] Vergessenes IPv6
> Viele Netze sind für IPv4 gut abgesichert, während IPv6 auf den Geräten einfach mitläuft. Firewall-Regeln, Monitoring und Hardening müssen beide Protokolle abdecken.

## Quiz

? Wie viele nutzbare Hosts hat ein /24-Netz?
= 254

? Wie viele Adressen umfasst ein /27-Netz insgesamt?
= 32

? Welche Subnetzmaske entspricht /26?
= 255.255.255.192

? Wie lautet die Netzadresse von 10.10.14.77/27?
= 10.10.14.64

? Wie lautet die Broadcast-Adresse von 10.10.14.77/27?
= 10.10.14.95

? Welche Bereiche sind private IPv4-Bereiche nach RFC 1918?
+ 10.0.0.0/8
+ 172.16.0.0/12
+ 192.168.0.0/16
- 169.254.0.0/16
- 100.64.0.0/10

? Was bedeutet eine Adresse aus 169.254.0.0/16 auf einem Client meist?
+ Es wurde kein DHCP-Server erreicht (APIPA)
- Der Client ist ein Router
- Der Client nutzt IPv6
- Der Client ist im Internet

?tf NAT ersetzt eine Firewall.
= falsch

? Wie viele Bit hat eine IPv6-Adresse?
= 128

? Welches IPv6-Präfix steht für Link-Local-Adressen?
= fe80::/10
= fe80

? Wie heißt das Prinzip, Netze aufzuteilen und dazwischen zu filtern, um Lateral Movement zu begrenzen?
= Netzsegmentierung
= Segmentierung
