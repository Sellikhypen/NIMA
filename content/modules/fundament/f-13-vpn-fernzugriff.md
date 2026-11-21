---
id: f-13
title: VPN, Proxys und Fernzugriff
paths: grundlagen, cjca, specialist
order: 13
difficulty: medium
icon: lock.shield.fill
summary: Wie VPNs funktionieren (IPsec, WireGuard, OpenVPN, SSL-VPN), Forward- und Reverse-Proxys, Load Balancer, Jump-Hosts und wie man Fernzugriff sicher gestaltet.
---

## Wozu ein VPN?

Ein **Virtual Private Network** baut einen verschlüsselten Tunnel über ein unsicheres Netz (meist das Internet). Daten im Tunnel sind vertraulich und gegen Manipulation geschützt.

| Einsatz | Beschreibung |
|---|---|
| Remote Access | Mitarbeitende verbinden sich von unterwegs ins Firmennetz |
| Site-to-Site | zwei Standorte werden dauerhaft verbunden |
| Lab-Zugang | wie bei Hack The Box über `tun0` |
| Privatsphäre | Verkehr in öffentlichen WLANs schützen |

## Die wichtigsten VPN-Technologien

| Technologie | Schicht | Merkmale |
|---|---|---|
| **IPsec** | 3 | Standard für Site-to-Site; IKEv2 zur Schlüsselaushandlung, ESP für Verschlüsselung; komplex, aber weit verbreitet |
| **WireGuard** | 3 | modern, schlank (wenige tausend Zeilen Code), feste moderne Kryptografie, sehr schnell |
| **OpenVPN** | 3/4 | TLS-basiert, flexibel, läuft über UDP oder TCP |
| **SSL-VPN** | 4–7 | über HTTPS, oft mit Browserportal; Produkte großer Hersteller |

> [!WARNUNG] VPN-Gateways sind Hochrisiko-Systeme
> VPN-Gateways stehen per Definition im Internet und gewähren Zugang ins interne Netz. Schwachstellen in solchen Produkten gehören seit Jahren zu den am schnellsten ausgenutzten Lücken überhaupt. Deshalb: sofort patchen, MFA erzwingen, Logs überwachen, Admin-Oberflächen nicht aus dem Internet erreichbar machen.

## Split Tunneling

| Modus | Verkehr | Abwägung |
|---|---|---|
| Full Tunnel | aller Verkehr durch das VPN | volle Kontrolle und Filterung, aber mehr Last |
| Split Tunnel | nur Firmenziele durch das VPN | schneller, aber Internetverkehr am Unternehmensschutz vorbei |

## Proxys

| Art | Position | Zweck |
|---|---|---|
| Forward Proxy | vor den Clients | Webfilter, Protokollierung, Caching, Malware-Scan |
| Reverse Proxy | vor den Servern | TLS-Terminierung, Lastverteilung, WAF, Verbergen interner Struktur |
| SOCKS-Proxy | generisch | leitet beliebige TCP-Verbindungen weiter |

> [!INFO] Reverse Proxys und Header
> Hinter einem Reverse Proxy sieht der Server nicht mehr die echte Client-IP. Sie wird in Headern wie `X-Forwarded-For` übergeben. Anwendungen dürfen solchen Headern nur vertrauen, wenn sie vom eigenen Proxy stammen – sonst lassen sich IP-basierte Regeln umgehen.

## Load Balancer

Load Balancer verteilen Anfragen auf mehrere Server (Round Robin, Least Connections, Hash). Layer-4-Balancer arbeiten mit IP/Port, Layer-7-Balancer verstehen HTTP und können nach Pfad oder Host verteilen. Sie erhöhen die Verfügbarkeit und sind oft gleichzeitig Reverse Proxy und TLS-Endpunkt.

## Sicherer Fernzugriff auf Server

| Methode | Empfehlung |
|---|---|
| Jump-Host / Bastion | einziger Zugangspunkt, gehärtet, mit MFA und Sitzungsaufzeichnung |
| SSH | nur Schlüssel, kein Root-Login, aktuelle Algorithmen |
| RDP | nie direkt aus dem Internet; über Gateway mit MFA, NLA aktiv |
| Zero Trust Network Access (ZTNA) | Zugriff pro Anwendung statt auf ganze Netze |
| Fernwartung durch Dienstleister | nur bei Bedarf freigeschaltet, protokolliert, zeitlich begrenzt |

## Quiz

? Welches VPN-Protokoll gilt als besonders schlank und modern?
= WireGuard

? Welches Protokoll dient bei IPsec zur Schlüsselaushandlung?
= IKEv2
= IKE

? Wie heißt der Modus, bei dem nur Verkehr zu Firmenzielen durch das VPN geht?
= Split Tunnel
= Split Tunneling

? Welche Proxy-Art steht vor den Servern?
= Reverse Proxy

? Welcher Header überträgt hinter einem Reverse Proxy die ursprüngliche Client-IP?
= X-Forwarded-For

? Warum sind VPN-Gateways besonders gefährdet?
+ Sie stehen im Internet und gewähren Zugang ins interne Netz
- Sie haben keine Verschlüsselung
- Sie laufen nur auf Windows
- Sie sind immer veraltet

? Wofür steht ZTNA?
= Zero Trust Network Access

?tf RDP sollte direkt aus dem Internet erreichbar sein, wenn ein starkes Passwort gesetzt ist.
= falsch
