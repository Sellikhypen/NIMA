---
id: cr-14
title: Kommunikation: Protokolle, Ports und Abläufe
paths: cyberrange
order: 14
difficulty: medium
icon: arrow.left.arrow.right
summary: Kapitel 14 deiner Cyber-Range-Dokumentation: Kommunikation: Protokolle, Ports und Abläufe.
source: Cyber_Range_Dokumentation.docx
htb: Cyber Range 10 · Protokolle & Pakete
---

## Überblick

Dieses Kapitel beantwortet die Frage, **über welche Software die Komponenten miteinander kommunizieren** und auf welchen Ports. Die Angaben entsprechen den Herstellerstandards (Stand November 2026) und wurden zweifach geprüft; abweichende Konfigurationen sind möglich.

## Kommunikationsmatrix

| **Von** | **Nach** | **Protokoll / Port** | **Software** | **Zweck** |
|---|---|---|---|---|
| **Admin-Browser** | Proxmox | HTTPS TCP 8006 | pveproxy | Web-UI und REST-API (/api2/json) |
| **Admin** | Proxmox | SSH TCP 22 | OpenSSH | Shell, Cluster-Aktionen |
| **Browser (noVNC)** | Proxmox | TCP 5900-5999 (über 8006) | vncproxy | VM-Konsole |
| **SPICE-Client** | Proxmox | TCP 3128 | spiceproxy | SPICE-Konsole |
| **Proxmox ↔ Proxmox** | Cluster | UDP 5405-5412 | Corosync (kronosnet) | Cluster-Kommunikation, Quorum |
| **Proxmox ↔ Proxmox** | Cluster | TCP 60000-60050 | QEMU Migration | Live-Migration |
| **Proxmox ↔ Proxmox** | Overlay | UDP 4789 | Linux VXLAN / FRRouting | SDN-Overlay zwischen Hosts |
| **Proxmox ↔ Proxmox** | EVPN | TCP 179 (BGP) | FRRouting | MAC/IP-Routen (EVPN Typ 2/3/5) |
| **Proxmox** | Backup Server | HTTPS TCP 8007 | proxmox-backup | Backups |
| **OpenTofu / Packer** | Proxmox | HTTPS TCP 8006 | bpg/proxmox, packer-plugin-proxmox | VMs/Templates anlegen |
| **Gast-VM (Installer)** | Packer-Host | HTTP TCP 8000-9000 | Packer-HTTP-Server | Antwortdateien abrufen |
| **Ansible** | Linux-VMs | SSH TCP 22 | OpenSSH | Konfiguration |
| **Ansible** | Windows-VMs | WinRM TCP 5985/5986 | pywinrm / psrp | Konfiguration (HTTPS 5986 bevorzugt) |
| **Wazuh-Agent 4.x** | Wazuh-Manager | TCP 1514 / 1515 | agentd → remoted / authd | Ereignisse (AES) / Enrollment (TLS) |
| **Wazuh-Agent 5.x** | Wazuh-Manager | TCP 1517 (TLS) | Wazuh 5 | Neuer Agent-Kanal (5.0 aktuell RC) |
| **Wazuh-Dashboard** | API / Indexer | TCP 55000 / 9200 | REST über HTTPS | Verwaltung / Suche |
| **Elastic Agent** | Security Onion | TCP 8220 / 5055 / 8443 | Fleet / Logstash / Updates | Policy, Daten, Binär-Updates |
| **OPNsense, Linux** | Log-Sammler | UDP/TCP 514, TLS 6514 | Syslog | Logs |
| **Router** | Collector | UDP 2055 / 4739 | NetFlow v9 / IPFIX | Flow-Daten |
| **Mirror-Port** | Sensor-NIC | Layer 2 (kein IP) | tc mirred / OVS | SPAN-Kopie |
| **Browser** | Guacamole | HTTPS 443 | Tomcat/Proxy | Remote-Desktop |
| **Guacamole** | guacd | TCP 4822 | Guacamole-Protokoll | Sitzungsaufbau |
| **guacd** | Ziel-VM | RDP 3389 / SSH 22 / VNC 5900 | FreeRDP / libssh2 / libvnc | Sitzung |
| **Apps** | Keycloak | HTTPS 8443/443 | OIDC / SAML 2.0 | Single Sign-on |
| **Admin** | VPN-Gateway | UDP 51820 | WireGuard | Admin-Zugang |
| **GHOSTS-Client** | GHOSTS-API | HTTP TCP 5000 | REST + SignalR | Timelines, Ergebnisse |
| **Sandcat-Agent** | Caldera | HTTP TCP 8888 | Caldera (POST /beacon) | Angreifer-Emulation |
| **Payload** | Kali | TCP 4444 (Standard) | Meterpreter | Reverse Shell (Szenario) |
| **Alle VMs** | Zeitserver | UDP 123 | chrony / w32time | Zeitsynchronisation |
| **Alle VMs** | DNS | UDP/TCP 53 | BIND / AD-DNS / Unbound | Namensauflösung |

Tabelle 89: Kommunikationsmatrix der Cyber Range

## Steuerkanal: die Proxmox-API

Die gesamte Steuerung läuft über **HTTPS-REST-Aufrufe** an die Proxmox-API. OpenTofu, Packer, Ludus und eigene Skripte nutzen dieselbe Schnittstelle. Authentifiziert wird mit einem API-Token im HTTP-Header:

**Proxmox-REST-API (Beispiele)**

```
# Header-Format laut Proxmox-Doku
Authorization: PVEAPIToken=terraform@pve!iac=<TOKEN-UUID>

# alle VMs eines Knotens auflisten
curl -s -H "Authorization: PVEAPIToken=terraform@pve!iac=<TOKEN-UUID>" \
     https://10.0.0.11:8006/api2/json/nodes/range-01/qemu

# Linked Clone von Template 9001 als VM 120 erzeugen
curl -s -X POST -H "Authorization: PVEAPIToken=..." \
     -d newid=120 -d name=dmz-web01 -d full=0 \
     https://10.0.0.11:8006/api2/json/nodes/range-01/qemu/9001/clone

# Snapshot setzen und später zurückrollen
curl -s -X POST -H "..." -d snapname=clean https://10.0.0.11:8006/api2/json/nodes/range-01/qemu/120/snapshot
curl -s -X POST -H "..." https://10.0.0.11:8006/api2/json/nodes/range-01/qemu/120/snapshot/clean/rollback
```

## Telemetriekanal

- **Push über Agenten:** Wazuh- bzw. Elastic-Agent lesen lokal Logs (z. B. den Kanal `Microsoft-Windows-Sysmon/Operational`) und senden sie verschlüsselt. Bei Verbindungsverlust puffern sie lokal.
- **Syslog:** OPNsense und Linux-Dienste senden RFC-5424-Nachrichten (UDP 514 schnell, aber verlustbehaftet; TCP/TLS 6514 zuverlässig und verschlüsselt).
- **Passiv über SPAN:** Der Sensor empfängt Kopien aller Frames, ohne selbst Pakete zu senden – für Angreifer unsichtbar.
- **Pull durch Scoring:** Die Scoring-Engine fragt Dienste aktiv ab (z. B. `GET https://10.10.20.10/` erwartet HTTP 200).
## Benutzerzugang: das Guacamole-Protokoll

Zwischen Webanwendung und `guacd` läuft das textbasierte Guacamole-Protokoll. Jede Instruktion besteht aus Elementen der Form `LÄNGE.WERT`, getrennt durch Kommas und abgeschlossen mit einem Semikolon:

**Guacamole-Handshake (vereinfacht)**

```
6.select,3.rdp;                      ← Webapp wählt das Protokoll
4.size,4.1920,4.1080,2.96;            ← Bildschirmgröße und DPI
7.connect,10.10.50.10,4.3389,...;     ← Verbindungsparameter (vereinfacht)
5.ready,37.$a1b2c3...;                ← guacd bestätigt die Sitzung
```

## Protokolle im Szenario: Active Directory und Kerberos

Fast jedes Firmenszenario enthält Active Directory. Die folgenden Protokolle müssen zwischen Clients und Domain Controller funktionieren – und sind gleichzeitig die wichtigsten Angriffsflächen:

| **Port** | **Protokoll** | **Funktion** | **Relevante Angriffe / Detektion** |
|---|---|---|---|
| **53 TCP/UDP** | DNS | Namensauflösung, SRV-Records (_ldap._tcp) | DNS-Tunneling, Zonentransfer (Zeek dns.log) |
| **88 TCP/UDP** | Kerberos | Authentifizierung (AS/TGS) | Kerberoasting (4769, RC4 0x17), AS-REP-Roasting (4768), Golden Ticket |
| **135 + 49152-65535 TCP** | MS-RPC / DCOM | Endpoint Mapper, dynamische Ports | Lateral Movement (WMI, DCOM) |
| **389 / 636 TCP** | LDAP / LDAPS | Verzeichnisabfragen | BloodHound-Enumeration, LDAP-Relay |
| **445 TCP** | SMB | Dateien, Named Pipes | PsExec (7045), Pass-the-Hash, NTLM-Relay |
| **464 TCP/UDP** | kpasswd | Passwortänderung | – |
| **3268/3269 TCP** | Global Catalog | Forest-weite Suche | Enumeration |
| **3389 TCP** | RDP | Remote Desktop | Brute Force (4625), Logon-Typ 10 |
| **5985/5986 TCP** | WinRM | PowerShell Remoting | Lateral Movement (Evil-WinRM) |
| **123 UDP** | NTP | Zeit (Kerberos toleriert standardmäßig max. 5 Min.) | – |

Tabelle 90: Active-Directory-Protokolle

Wie ein solcher Ablauf konkret aussieht – und wo ein Angreifer ihn ausnutzt –, zeigt die folgende Abbildung am Beispiel des Kerberoasting-Angriffs, der im Szenario »Operation Nordlicht« vorkommt:

![Abbildung 40: Kerberos-Ablauf und Kerberoasting-Angriff](asset:cyberrange/cr-14-040.png)

**So liest man die Abbildung:**

- Schritte 1–3: Normale Anmeldung – der Benutzer erhält ein TGT (»Eintrittskarte«). Der DC protokolliert Event 4768.
- Schritt 4: Der Angreifer sucht per LDAP alle Konten mit einem SPN (Dienstkonten).
- Schritte 5–7: Er fordert ein Service-Ticket an – absichtlich mit der schwachen RC4-Verschlüsselung. Das Ticket ist mit dem Passwort-Hash des Dienstkontos verschlüsselt. Event 4769 mit Typ 0x17 ist das Erkennungsmerkmal.
- Schritt 8: Das Ticket wird **offline** geknackt – ohne weiteren Netzwerkverkehr. Deshalb muss die Erkennung bei Schritt 5/6 ansetzen.
## Ein Angriff auf Protokollebene: LLMNR-Poisoning und NTLM-Relay

Viele Angriffe im internen Netz nutzen keine Software-Schwachstelle, sondern das **Verhalten von Protokollen**. Ein Paradebeispiel ist die Kombination aus gefälschten LLMNR-Antworten und NTLM-Relay. Er zeigt, warum Konfiguration (SMB-Signing, abgeschaltete Altprotokolle) so wichtig ist.

![Abbildung 41: Ablauf von LLMNR-Poisoning und NTLM-Relay](asset:cyberrange/cr-14-041.png)

**So liest man die Abbildung:**

- Ein Benutzer vertippt sich bei einem Freigabenamen. DNS kennt den Namen nicht, also fragt Windows per **Multicast** im lokalen Netz.
- Der Angreifer (mit Responder) antwortet als Erster: »Das bin ich.«
- Der Client beginnt die NTLM-Anmeldung beim Angreifer. Der Angreifer **reicht jede Nachricht in Echtzeit an einen echten Server weiter** (Relay).
- Weil der Zielserver kein SMB-Signing erzwingt, akzeptiert er die weitergereichte Anmeldung. Der Angreifer hat eine Sitzung mit den Rechten des Opfers.
- Unten stehen die Gegenmaßnahmen und die Spuren, die das Blue Team finden kann.

In der Range wird diese Schwachstelle (V7) bewusst offen gelassen. Das Blue Team kann sie auf zwei Wegen schließen: LLMNR und NetBIOS per Gruppenrichtlinie deaktivieren und SMB-Signing erzwingen. Beides lässt sich anschließend durch Wiederholung des Angriffs prüfen – ein typischer Purple-Teaming-Moment.

## Kerberos vollständig

Kerberos ist das zentrale Authentifizierungsprotokoll im Active Directory und Ziel vieler Angriffe. Der vollständige Ablauf besteht aus drei Nachrichtenpaaren über Port 88:

| **Nachricht** | **Von → An** | **Inhalt** | **Angriff / Erkennung** |
|---|---|---|---|
| **AS-REQ** | Client → KDC (DC) | Benutzername, Zeitstempel verschlüsselt mit Passwort-Hash (Vorauthentifizierung) | Passwort-Spraying (4771), AS-REP-Roasting ohne Vorauth. |
| **AS-REP** | KDC → Client | TGT (verschlüsselt mit krbtgt-Schlüssel) + Sitzungsschlüssel | Golden Ticket = gefälschtes TGT (krbtgt-Hash nötig) |
| **TGS-REQ** | Client → KDC | TGT + gewünschter Dienst (SPN) | Kerberoasting: viele Anfragen, RC4 (4769) |
| **TGS-REP** | KDC → Client | Dienstticket, verschlüsselt mit dem Schlüssel des Dienstkontos | Offline-Knacken des Dienstkonto-Passworts |
| **AP-REQ** | Client → Dienst | Dienstticket + Authenticator | Silver Ticket = gefälschtes Dienstticket |
| **AP-REP** | Dienst → Client | optionale gegenseitige Authentifizierung | – |

Tabelle 91: Kerberos-Nachrichten und zugehörige Angriffe

> [!INFO] Warum RC4 verdächtig ist
> Moderne Domänen nutzen für Kerberos AES (Verschlüsselungstypen 0x11 und 0x12). Fordert ein Client ein Dienstticket mit RC4 (0x17) an, ist das ein starkes Indiz für Kerberoasting – Angriffswerkzeuge bevorzugen RC4, weil sich solche Tickets schneller knacken lassen. Microsoft schränkt RC4 in neueren Windows-Versionen zunehmend ein; im Szenario wird es bewusst noch zugelassen.

## Ports und Protokolle im Szenario

| **Port** | **Protokoll** | **Verwendung** | **Port** | **Protokoll** | **Verwendung** |
|---|---|---|---|---|---|
| **22/tcp** | SSH | Linux-Verwaltung | 445/tcp | SMB | Freigaben, PsExec |
| **25/tcp** | SMTP | Mail-Zustellung | 464/tcp+udp | kpasswd | Kerberos-Passwortänderung |
| **53/udp+tcp** | DNS | Namensauflösung | 502/tcp | Modbus TCP | ICS-Szenario |
| **80, 443/tcp** | HTTP(S) | Web, C2 | 636/tcp | LDAPS | LDAP über TLS |
| **88/tcp+udp** | Kerberos | Authentifizierung | 1433/tcp | MS SQL | Datenbank (svc_sql) |
| **123/udp** | NTP | Zeitsynchronisation | 3268/3269 | Global Catalog | Gesamtstrukturweite Suche |
| **135/tcp** | RPC-Endpunkt-Mapper | DCOM, WMI | 3389/tcp | RDP | Remote-Desktop |
| **137–139** | NetBIOS | Altprotokolle | 5355/udp | LLMNR | Namensauflösung (Multicast) |
| **389/tcp+udp** | LDAP | Verzeichnisabfragen | 5985/5986 | WinRM | PowerShell-Remoting |
| **49152–65535** | RPC dynamisch | dynamische RPC-Ports | 5432/tcp | PostgreSQL | Datenbank des Webshops |

Tabelle 92: Ports im Szenario (Auswahl)

## Command-and-Control-Kommunikation verstehen

Nach der Erstinfektion braucht ein Angreifer einen dauerhaften Kanal zu seinem C2-Server. In der Range betreibt das Red Team dafür quelloffene C2-Frameworks im SINET (z. B. Sliver oder Mythic). Für das Blue Team ist entscheidend, die **Muster** solcher Kanäle zu erkennen – nicht einzelne Werkzeuge.

| **Kanal** | **Funktionsweise** | **Erkennungsmerkmale** |
|---|---|---|
| **HTTPS** | Implantat fragt regelmäßig per HTTPS nach Aufgaben (Beacon) | gleichmäßige Intervalle trotz Jitter, seltene Ziel-Domain, ungewöhnliches TLS-Profil (JA4), kleine Anfragen mit großen Pausen |
| **DNS** | Daten in Subdomains, Antworten in TXT-Records | lange, zufällige Labels, viele Anfragen an eine Zone, hohe Entropie |
| **SMB Named Pipes** | Implantate im internen Netz sprechen über Pipes miteinander, nur eines nach außen | Sysmon 17/18, ungewöhnliche Pipe-Namen, SMB zwischen Workstations |
| **Domain Fronting / CDN** | C2 versteckt sich hinter legitimer Infrastruktur | SNI und Host-Header passen nicht zusammen (in der Range simulierbar) |

Tabelle 93: C2-Kanäle und ihre Erkennungsmerkmale

> [!WARNUNG] C2-Werkzeuge bleiben im SINET
> C2-Server laufen ausschließlich auf VMs im simulierten Internet. Ihre Implantate werden nur innerhalb der Range erzeugt und nach der Übung mit den VMs verworfen. Kein Implantat und keine Konfiguration verlässt die Range.

## Syslog im Detail: Formate und Transportwege

Syslog ist der älteste und verbreitetste Weg, Protokolle von einem System zu einem anderen zu schicken. In der Range senden OPNsense, Linux-Server und einige Dienste ihre Meldungen per Syslog an das SIEM. Es gibt zwei Nachrichtenformate und drei Transportwege, die man kennen sollte.

| **Merkmal** | **RFC 3164 (»BSD-Syslog«, alt)** | **RFC 5424 (aktuell)** |
|---|---|---|
| **Zeitstempel** | ohne Jahr und ohne Zeitzone (»Nov 20 10:15:02«) | vollständig mit Zeitzone (»2026-11-20T10:15:02.123+01:00«) |
| **Struktur** | Freitext nach Host und Programm | feste Felder: Version, Host, App, Prozess-ID, Nachrichten-ID, strukturierte Daten |
| **Eignung** | verbreitet, aber unpräzise | **empfohlen** – eindeutig auswertbar |

Tabelle 94: Syslog-Nachrichtenformate

**Eine Syslog-Zeile nach RFC 5424 zerlegt (Nachrichtenteil vereinfacht)**

```
<134>1 2026-11-20T10:15:02.123+01:00 rtr-01.range filterlog 51722 - - block,in,vtnet1.30,tcp,...
│    │ │                             │            │         │     │ │ └ Nachricht (Filterprotokoll von OPNsense, gekürzt)
│    │ │                             │            │         │     │ └ strukturierte Daten (keine: »-«)
│    │ │                             │            │         │     └ Nachrichten-ID (keine: »-«)
│    │ │                             │            │         └ Prozess-ID
│    │ │                             │            └ Anwendung
│    │ │                             └ Hostname
│    │ └ Zeitstempel mit Zeitzone
│    └ Version des Formats (1 = RFC 5424)
└ Priorität = Facility × 8 + Severity (134 = local0 (16) × 8 + informational (6))
```

| **Transport** | **Port** | **Eigenschaften** | **Einsatz in der Range** |
|---|---|---|---|
| **UDP** | 514 | einfach, schnell, aber Verluste möglich, keine Verschlüsselung | nur im SVC-Netz, wenn Quellen nichts anderes können |
| **TCP** | 514 (verbreitet) bzw. 601 | zuverlässige Zustellung, keine Verschlüsselung | Standard für OPNsense → SIEM |
| **TLS** | 6514 | zuverlässig und verschlüsselt, Zertifikate nötig | ab Stufe 3 oder wenn Logs Netze überqueren |

Tabelle 95: Transportwege für Syslog

## Wie NTP die Zeit überträgt

NTP (Network Time Protocol, UDP-Port 123) misst nicht nur die Uhrzeit eines Servers, sondern auch, wie lange die Pakete unterwegs waren. Dazu werden vier Zeitstempel ausgetauscht:

| **Zeitstempel** | **Bedeutung** |
|---|---|
| **T1** | Client sendet die Anfrage (Uhr des Clients) |
| **T2** | Server empfängt die Anfrage (Uhr des Servers) |
| **T3** | Server sendet die Antwort (Uhr des Servers) |
| **T4** | Client empfängt die Antwort (Uhr des Clients) |

Tabelle 96: Die vier NTP-Zeitstempel

Daraus berechnet der Client die **Laufzeit** δ = (T4 − T1) − (T3 − T2) und die **Abweichung** seiner Uhr θ = ((T2 − T1) + (T3 − T4)) ÷ 2. Er korrigiert seine Uhr dann behutsam in kleinen Schritten, statt zu springen – große Zeitsprünge würden Protokolle durcheinanderbringen. Genau deshalb müssen VMs nach einem Snapshot-Rollback ihre Uhr neu synchronisieren: Ein zurückgesetzter Snapshot »erinnert« sich an die alte Zeit.

> [!TIPP] Zeit nach einem Reset
> Nach `qm rollback` laufen Windows-VMs zunächst mit der Uhrzeit des Snapshots. Der Gast-Agent und der Windows-Zeitdienst korrigieren das, brauchen aber etwas Zeit. Das Reset-Skript stößt die Synchronisierung deshalb aktiv an (z. B. `w32tm /resync` über `qm guest exec`), bevor die nächste Übung beginnt.
