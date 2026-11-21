---
id: c-09
title: Netzsegmente, Pivoting und Tunneling verstehen
paths: cpts, cape
order: 9
difficulty: hard
icon: arrow.triangle.branch
summary: Warum Angreifer sich über kompromittierte Systeme in tiefere Netze bewegen, welche Konzepte dahinterstehen (Port-Weiterleitung, SOCKS, VPN-artige Tunnel) und wie Segmentierung und Monitoring das erkennen und verhindern.
htb: Pivoting, Tunneling, and Port Forwarding
---

## Das Konzept

Interne Netze sind von außen nicht direkt erreichbar. Wer einen ersten Rechner kontrolliert, der in mehreren Netzen hängt, kann ihn als **Sprungbrett** nutzen – das nennt man **Pivoting**. **Tunneling** verpackt dabei Verkehr in ein anderes Protokoll, um Filter zu passieren.

| Begriff | Bedeutung |
|---|---|
| Pivot-Host | kompromittiertes System mit Zugang zu weiteren Netzen |
| Lokale Port-Weiterleitung | ein lokaler Port wird über eine Verbindung zu einem entfernten Ziel durchgereicht |
| Remote/Reverse Port-Weiterleitung | ein Port auf der Gegenseite wird zurück zu einem lokalen Ziel geleitet |
| Dynamische Weiterleitung (SOCKS) | ein Proxy leitet beliebige Verbindungen weiter |
| Tunnel | Verkehr wird in ein anderes Protokoll eingebettet (SSH, HTTP(S), DNS, ICMP) |

> [!INFO] Legitime Nutzung
> Dieselben Techniken nutzen Administratoren täglich: SSH-Port-Weiterleitung zum Datenbank-Admin, Jump-Hosts, VPNs. Die Frage ist nie die Technik, sondern ob sie **erwartet** ist.

## Typische Werkzeugkategorien (Überblick)

| Kategorie | Beispiele | Prinzip |
|---|---|---|
| SSH-Funktionen | `-L`, `-R`, `-D` | Weiterleitungen über eine SSH-Verbindung |
| Windows-Bordmittel | `netsh interface portproxy` | Port-Weiterleitung im Betriebssystem |
| SOCKS-Clients | proxychains | Programme über einen SOCKS-Proxy schicken |
| Tunnel-Programme | chisel, ligolo-ng, sshuttle | Tunnel über HTTP(S) oder eigene Protokolle, teils mit virtuellem Netzwerkadapter |

## Warum das für Prüfungen wichtig ist

In CPTS und CAPE liegen Ziele oft in Netzen, die nur über mehrere Zwischenstationen erreichbar sind. Man muss verstehen, **welcher Host welche Netze sieht**, Routen und Schnittstellen auswerten und die Erreichbarkeit sauber dokumentieren. Netzwerkgrundlagen aus [[mod:f-03|Subnetting]] sind hier entscheidend.

## Die Verteidigersicht

| Maßnahme | Wirkung |
|---|---|
| strikte **Segmentierung** und Default-Deny zwischen Zonen | weniger erreichbare Ziele von einem Pivot-Host |
| **Egress-Filterung** | Tunnel nach außen werden erschwert |
| Proxy mit Authentifizierung und TLS-Inspektion (wo zulässig) | unerwartete Verbindungen werden sichtbar |
| keine Dual-Homed-Server zwischen Zonen | weniger natürliche Sprungbretter |
| Jump-Hosts mit MFA und Aufzeichnung | legitime Administration ist klar abgegrenzt |

| Erkennungssignal | Quelle |
|---|---|
| lang laufende Verbindungen mit gleichmäßigem Volumen | Flow-Daten, Zeek `conn.log` |
| ungewöhnliche DNS-Abfragemuster (sehr viele, sehr lange Subdomains) | DNS-Logs |
| SSH von Servern, die normalerweise kein SSH nach außen nutzen | Firewall-Logs |
| neue lauschende Ports auf Servern | EDR, `ss`/`netstat`-Inventar |
| Port-Proxy-Konfiguration in der Registry | Sysmon 13, EDR |

## Quiz

? Wie nennt man ein kompromittiertes System, über das man tiefere Netze erreicht?
= Pivot-Host
= Pivot

? Welche SSH-Option erzeugt eine dynamische Weiterleitung (SOCKS)?
= -D

? Welche SSH-Option leitet einen lokalen Port zu einem entfernten Ziel weiter?
= -L

? Welches Windows-Bordmittel kann Ports weiterleiten?
= netsh interface portproxy
= netsh portproxy
= netsh

? Welche Maßnahme erschwert Tunnel nach außen besonders?
= Egress-Filterung
= Egress Filtering

? Welche Beobachtung kann auf DNS-Tunneling hinweisen?
+ sehr viele Abfragen mit langen, zufällig wirkenden Subdomains
- ein einzelner A-Record
- ein abgelaufenes Zertifikat
- ein voller Druckerspeicher

?tf Port-Weiterleitung ist immer ein Angriff.
= falsch
