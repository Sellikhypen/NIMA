---
id: cr-15
title: Paketebene: Wie Pakete versendet und angenommen werden
paths: cyberrange
order: 15
difficulty: medium
icon: shippingbox
summary: Kapitel 15 deiner Cyber-Range-Dokumentation: Paketebene: Wie Pakete versendet und angenommen werden.
source: Cyber_Range_Dokumentation.docx
htb: 
---

## Überblick

Dieses Kapitel verfolgt den Weg einzelner Pakete durch die Range – vom Angreifer bis zum Ziel und gleichzeitig zum Sensor. Wer diesen Weg versteht, kann Fehler (Paketverlust, MTU-Probleme, fehlende Mitschnitte) schnell eingrenzen und weiß genau, welche Informationen der Sensor sehen kann.

## Schichtenmodell der Netzwerktechnik

Jedes Datenpaket ist wie eine russische Puppe aufgebaut: Jede Schicht verpackt die Daten der Schicht darüber mit einem eigenen Kopf (Header).

| **OSI-Schicht** | **Name** | **Dateneinheit** | **Adressierung** | **Beispiel in der Range** |
|---|---|---|---|---|
| **7–5** | Anwendung | Nachricht | URL, Benutzer | HTTP, DNS, Kerberos, RDP, Syslog |
| **4** | Transport | Segment / Datagramm | Port | TCP 443, UDP 53 |
| **3** | Vermittlung | Paket | IP-Adresse | IPv4 10.10.10.50 → 10.10.20.10 |
| **2** | Sicherung | Frame | MAC-Adresse, VLAN-ID | Ethernet + 802.1Q-Tag VID 10 |
| **1** | Bitübertragung | Bits | – | Kupfer/Glasfaser – bzw. Speicher bei virtuellen NICs |

Tabelle 97: OSI-Modell und Range-Beispiele

## Aufbau der Frames und Header

![Abbildung 42: Ethernet-Frame mit 802.1Q-Tag (oben) und VXLAN-Kapselung (unten)](asset:cyberrange/cr-15-042.png)

### Ethernet II mit 802.1Q-Tag

| **Feld** | **Länge** | **Inhalt / Bedeutung** |
|---|---|---|
| **Ziel-MAC** | 6 Byte | Adresse des nächsten Hops (z. B. OPNsense); Proxmox-VMs haben standardmäßig das Präfix BC:24:11 |
| **Quell-MAC** | 6 Byte | Absender; die Bridge lernt daraus ihre FDB (MAC → Port) |
| **TPID** | 2 Byte | 0x8100 = 802.1Q-Tag folgt (0x88A8 = 802.1ad QinQ) |
| **PCP / DEI / VID** | 3 / 1 / 12 Bit | Priorität (802.1p), Drop-Eligible, VLAN-ID 1–4094 (0 und 4095 reserviert) |
| **EtherType** | 2 Byte | 0x0800 IPv4, 0x86DD IPv6, 0x0806 ARP |
| **Payload** | 46–1500 Byte | IP-Paket (Standard-MTU 1500) |
| **FCS** | 4 Byte | CRC-32-Prüfsumme; von der NIC berechnet, in Mitschnitten meist nicht sichtbar |

Tabelle 98: Ethernet-II-Frame mit 802.1Q

### IPv4-Header (RFC 791)

| **Feld** | **Bits** | **Bedeutung in der Range** |
|---|---|---|
| **Version / IHL** | 4 / 4 | 4 und Header-Länge in 32-Bit-Worten (5 = 20 Byte) |
| **DSCP / ECN** | 6 / 2 | QoS-Markierung |
| **Total Length** | 16 | Gesamtlänge des Pakets |
| **Identification / Flags / Offset** | 16 / 3 / 13 | Fragmentierung; DF-Bit ist für Path-MTU-Discovery entscheidend |
| **TTL** | 8 | Jeder Router (OPNsense) verringert um 1 – Grundlage von Traceroute |
| **Protocol** | 8 | 6 = TCP, 17 = UDP, 1 = ICMP, 47 = GRE, 50 = ESP |
| **Header Checksum** | 16 | Bei jedem Hop neu berechnet |
| **Quell-/Zieladresse** | 32 / 32 | z. B. 10.10.10.50 → 10.10.20.10; bei NAT umgeschrieben |

Tabelle 99: IPv4-Header

### TCP- und UDP-Header

| **Feld** | **Länge** | **Bedeutung** |
|---|---|---|
| **Quell-/Zielport** | 16 / 16 Bit | Ephemerer Client-Port (Linux 32768–60999, Windows 49152–65535) → Dienstport |
| **Sequence / Acknowledgment** | 32 / 32 Bit | Byte-genaue Reihenfolge und Bestätigung |
| **Data Offset** | 4 Bit | Header-Länge 20–60 Byte (Optionen MSS, SACK, Window Scale, Timestamps) |
| **Flags** | 9 Bit | SYN, ACK, FIN, RST, PSH, URG (+ ECE, CWR) – Scans erzeugen typische Muster |
| **Window** | 16 Bit | Empfangsfenster |
| **UDP-Header** | 8 Byte | Quellport, Zielport, Länge, Prüfsumme – verbindungslos |

Tabelle 100: TCP- und UDP-Header

## Bevor das erste Paket fließt: ARP

Ein Rechner kann ein IP-Paket nur zustellen, wenn er die **MAC-Adresse** des nächsten Hops kennt. Liegt das Ziel in einem anderen Netz, ist das der Router. Diese Zuordnung liefert ARP:

**ARP-Austausch (illustrativ)**

```
kali01 → Broadcast ff:ff:ff:ff:ff:ff   ARP Request:  Who has 10.10.10.1? Tell 10.10.10.50
rtr-01 → kali01                         ARP Reply:    10.10.10.1 is at bc:24:11:00:01:0a
# Ergebnis im ARP-Cache von kali01:  ip neigh  →  10.10.10.1 dev eth0 lladdr bc:24:11:00:01:0a REACHABLE
```

ARP ist gleichzeitig ein beliebtes Angriffsziel (ARP-Spoofing: ein Angreifer behauptet, die Router-MAC zu besitzen). Der Spoofing-Schutz von Proxmox (`macfilter`) und Zeek-Hinweise auf wechselnde MAC-Zuordnungen machen solche Angriffe sichtbar.

## Weg eines Pakets durch die Range

![Abbildung 43: Paketweg von der Kali-VM (VLAN 10) zum Webserver (VLAN 20) mit paralleler Spiegelung](asset:cyberrange/cr-15-043.png)

1. **Anwendung:** Auf `kali01` (10.10.10.50) ruft der Angreifer `curl https://10.10.20.10/` auf. Die Routing-Tabelle zeigt: Ziel liegt nicht im eigenen Netz → Next Hop = Gateway 10.10.10.1.
1. **ARP:** MAC von 10.10.10.1 ermitteln (siehe 15.3).
1. **TCP-SYN:** Kali baut ein Segment (SYN, Zielport 443, MSS-Option) → IPv4-Header (TTL 64) → Ethernet-Frame (Ziel-MAC = OPNsense) und übergibt es dem virtio-net-Treiber.
1. **tap-Interface:** vhost-net reicht den Frame an `tap101i0` (VM 101, NIC 0). Der Port ist Access-Port in VLAN 10.
1. **Bridge** `vmbr1`**:** ordnet den Frame VLAN 10 zu, lernt die Quell-MAC, schlägt die Ziel-MAC nach → Port `tap100i0` (Router, Trunk).
1. **Egress zum Router:** Am Trunk-Port verlässt der Frame die Bridge **mit 802.1Q-Tag VID 10**.
1. **OPNsense, Eingang:** FreeBSD ordnet den Frame anhand des Tags dem VLAN-Interface 10 zu und reicht das IP-Paket an pf. Kein State vorhanden (neues SYN) → Regelauswertung → Regel 6 (RED → DMZ, pass) → neuer State.
1. **Routing:** Ziel 10.10.20.0/24 hängt direkt am VLAN-Interface 20. TTL 63, neue Prüfsumme, ARP für 10.10.20.10, neuer Ethernet-Header (Quell-MAC = OPNsense), Tag VID 20.
1. **Bridge → Ziel:** `vmbr1` stellt den Frame an `tap120i0` zu (Access-Port VLAN 20, Tag wird entfernt).
1. **Annahme im Ziel:** Ziel-MAC → IP → TCP-Port 443 → Nginx lauscht → SYN/ACK. Die Antwort nimmt den umgekehrten Weg; pf erkennt sie am State und lässt sie ohne Regelprüfung passieren. Danach folgt der TLS-Handshake.
1. **Beobachtung:** Ein tc-mirred-Filter am Trunk-Port der Router-VM kopiert jeden Frame (beide Richtungen, mit Tag) auf die Mirror-NIC → Maschine B → Security Onion.
## Verbindungsaufbau und Verschlüsselung: TCP und TLS 1.3

![Abbildung 44: TCP-Verbindungsaufbau und TLS-1.3-Handshake aus Sicht von Firewall und Sensor](asset:cyberrange/cr-15-044.png)

**So liest man die Abbildung:**

- Schritte 1–4: Der **Drei-Wege-Handshake** (SYN, SYN/ACK, ACK). Beim ersten SYN legt OPNsense den State an; alle weiteren Pakete passen dazu.
- Schritt 5: Das **ClientHello** ist unverschlüsselt. Es enthält den gewünschten Servernamen (SNI) und die angebotenen Verfahren – daraus lässt sich (z. B. mit dem JA4-Paket für Zeek) der JA4-Fingerabdruck des Clients berechnen.
- Schritt 7: Ab dem ServerHello ist bei TLS 1.3 alles verschlüsselt, auch das Zertifikat. Der Sensor sieht danach nur noch Größen, Zeiten und Richtungen.
- Schritte 11–12: Beim Verbindungsabbau schreibt Zeek den Eintrag ins conn.log (`conn_state=SF` = normal auf- und abgebaut).
## Annahme im Linux-Kernel des Hypervisors

![Abbildung 45: Paketpfad im Linux-Kernel: Netfilter-Hooks und Bridge-Pfad](asset:cyberrange/cr-15-045.png)

Der obere Teil zeigt den Weg von **IP-Paketen**, die der Host selbst verarbeitet (z. B. Zugriffe auf die Proxmox-Weboberfläche): Sie durchlaufen die Netfilter-Hooks PREROUTING, dann je nach Ziel INPUT (für den Host) oder FORWARD (weiterleiten) und schließlich POSTROUTING. An diesen Hooks wirken iptables- bzw. nftables-Regeln und Conntrack. Der untere Teil zeigt den Weg von Frames **zwischen VMs** über die Bridge – dieser Verkehr verlässt Layer 2 nicht und wird nur gefiltert, wenn die Proxmox-VM-Firewall aktiv ist.

| **Stufe** | **Subsystem** | **Entscheidung** | **Diagnosebefehl** |
|---|---|---|---|
| **1** | NIC / tap / vhost-net | Frame angenommen (Größe ≤ MTU) | ip -s link show tap101i0 |
| **2** | Bridge-Ingress | VLAN-Filter: ist die VID am Port erlaubt? | bridge vlan show |
| **3** | FDB-Lookup | Ziel-MAC bekannt → Unicast; unbekannt → Flooding im VLAN | bridge fdb show br vmbr1 |
| **4** | Netfilter (bridge) | Nur bei aktiver Firewall/br_netfilter | nft list ruleset |
| **5** | Conntrack | NEW / ESTABLISHED / RELATED / INVALID | conntrack -L |
| **6** | tc (Traffic Control) | Filter, z. B. mirred für SPAN | tc filter show dev tap100i0 ingress |
| **7** | Bridge-Egress | VLAN-Tag setzen (Trunk) oder entfernen (Access) | tcpdump -e -i tap100i0 |

Tabelle 101: Verarbeitungsstufen im Linux-Kernel

> [!INFO] Proxmox-Firewall: iptables vs. nftables
> Die klassische Proxmox-Firewall (`pve-firewall`) nutzt iptables/ebtables und zusätzliche Firewall-Bridges (`fwbrXXX`) je VM-NIC. Der nftables-basierte Dienst `proxmox-firewall` ist auch in Proxmox VE 9 noch **Technology Preview** und wird von Proxmox nicht für den Produktivbetrieb empfohlen. Im Projekt: klassische Firewall für den Hostschutz, Übungsregeln ausschließlich in OPNsense.

## Annahme in der Firewall (pf / OPNsense)

- **Regelauswertung:** pro Interface eingehend; `quick`-Regeln beenden die Auswertung beim ersten Treffer; Floating Rules werden vorher ausgewertet.
- **State-Tracking:** Für jede erlaubte Verbindung entsteht ein State (5-Tupel + TCP-Sequenzfenster). Rückpakete passieren ohne Regelprüfung.
- **Normalisierung (scrub):** Reassemblierung fragmentierter Pakete, Bereinigung ungültiger Flags.
- **NAT:** Outbound-NAT und Port-Forwards werden vor bzw. nach der Filterung angewendet.
- **Logging:** `filterlog` schreibt pro Treffer eine CSV-artige Zeile (Regel, Interface, Aktion, Richtung, Protokoll, Adressen, Ports) – per Syslog ins SIEM.
## VXLAN: Ein Netzsegment über mehrere Hosts

Sobald die Range auf mehrere Hosts verteilt wird, muss ein Segment (z. B. das CORP-Netz von Team 1) auf allen Hosts existieren. Dafür werden Frames in UDP-Pakete verpackt (VXLAN, RFC 7348) und über das physische Netz (Underlay) getunnelt.

![Abbildung 46: VXLAN-Overlay zwischen zwei Hosts](asset:cyberrange/cr-15-046.png)

1. Ein Frame von ws01 auf pve-01 erreicht das VNet »t1corp« (VNI 11030).
1. Die Ziel-MAC (dc01) liegt auf pve-02 → der VTEP verpackt den Frame: innerer Frame + VXLAN-Header (VNI) + UDP (Zielport 4789) + äußeres IP (Underlay-Adressen) + äußeres Ethernet.
1. pve-02 empfängt das UDP-Paket, entfernt die Verpackung und stellt den inneren Frame im passenden VNet zu.
1. **Ohne EVPN:** BUM-Verkehr wird per Head-End-Replication an alle Peers gesendet; MAC-Adressen werden aus dem Datenverkehr gelernt.
1. **Mit EVPN:** FRRouting verteilt per BGP Routen vom Typ 2 (MAC/IP), Typ 3 (BUM-Ziele) und Typ 5 (IP-Präfixe); VRFs trennen Mandanten.
## MTU, Fragmentierung und Offloading

- **VXLAN-Overhead:** 50 Byte (14 äußeres Ethernet + 20 IPv4 + 8 UDP + 8 VXLAN), bei IPv6-Underlay 70 Byte. Entweder Gast-MTU **1450** (in Proxmox SDN pro Zone/VNet einstellbar) oder Underlay-MTU **≥ 1550**, besser 9000.
- **Symptom falscher MTU:** Ping und SSH-Login funktionieren, aber große Downloads, TLS-Handshakes oder SMB hängen (»PMTU-Blackhole«). Test: `ping -M do -s 1422 <ziel>`.
- **Offloading (TSO/GSO/GRO):** Im Mitschnitt auf dem Host erscheinen Pakete > MTU oder »falsche« Prüfsummen. Auf der Sniff-NIC abschalten: `ethtool -K enp3s0 gro off lro off tso off gso off`.
## Mitschnitt: SPAN, Mirror und tcpdump

| **Methode** | **Prinzip** | **Vorteile** | **Nachteile** |
|---|---|---|---|
| **tc mirred (clsact)** | Kernel-Filter am tap-Interface kopiert Frames auf ein Ziel-Interface | Präzise, performant | Nach jedem VM-Start neu setzen (Hookscript) |
| **Open vSwitch Mirror** | OVS-Mirror mit select-all und output-port | Native SPAN-Funktion, persistent | Umstieg auf OVS nötig |
| **Bridge-Ageing 0 (Hub)** | Bridge lernt keine MACs → flutet alle Frames im VLAN | Trivial | Mehr Last; nur VLANs, in denen der Sensorport Mitglied ist |

Tabelle 102: Spiegelungsmethoden

**tcpdump-Beispiel (illustrativ)**

```
# auf der Sniff-NIC (Maschine B), -e zeigt L2-Header inkl. VLAN
tcpdump -i enp3s0 -e -nn -c 3 'vlan and tcp port 443'

12:00:01.123456 bc:24:11:aa:bb:01 > bc:24:11:cc:dd:02, ethertype 802.1Q (0x8100),
  length 78: vlan 10, p 0, ethertype IPv4 (0x0800), 10.10.10.50.51544 > 10.10.20.10.443:
  Flags [S], seq 1234567890, win 64240, options [mss 1460,sackOK,TS val 1 ecr 0,nop,wscale 7], length 0
# 78 Byte = 14 Ethernet + 4 VLAN-Tag + 20 IPv4 + 40 TCP (20 Header + 20 Optionen)
```

## Telemetrie-Formate

### Zeek conn.log (JSON)

**Zeek conn.log (illustrativ)**

```
{"ts":1795680001.123,"uid":"CHhAvVGS1DHFjwGM9","id.orig_h":"10.10.10.50","id.orig_p":51544,
 "id.resp_h":"10.10.20.10","id.resp_p":443,"proto":"tcp","service":"ssl","duration":0.84,
 "orig_bytes":517,"resp_bytes":4120,"conn_state":"SF","history":"ShADadFf",
 "orig_pkts":9,"resp_pkts":8,"vlan":10}
```

| **conn_state** | **Bedeutung** | **Typischer Anlass** |
|---|---|---|
| **S0** | SYN gesendet, keine Antwort | Portscan auf gefilterte Ports |
| **REJ** | Verbindungsversuch abgewiesen (RST) | Portscan auf geschlossene Ports |
| **SF** | Normal auf- und abgebaut | Reguläre Verbindung |
| **S1** | Aufgebaut, nicht beendet | Langlebige Verbindung, z. B. C2 |
| **RSTO / RSTR** | Vom Originator / Responder zurückgesetzt | Abbruch, Fehler, Scanner |
| **OTH** | Kein SYN gesehen (Mitschnitt begann mitten in der Verbindung) | Sensor-Neustart |

Tabelle 103: Wichtige Werte von conn_state

### Suricata EVE-JSON (Alarm)

**Suricata EVE-Alarm (illustrativ, Signatur-ID fiktiv)**

```
{"timestamp":"2026-11-20T10:15:02.003+0100","flow_id":1234567890123456,"in_iface":"enp3s0",
 "event_type":"alert","vlan":[10],"src_ip":"10.10.10.50","src_port":51544,
 "dest_ip":"10.10.20.10","dest_port":443,"proto":"TCP",
 "alert":{"action":"allowed","gid":1,"signature_id":2000000,"rev":1,
          "signature":"ET SCAN Beispielsignatur","category":"Attempted Information Leak","severity":2}}
```

### Syslog nach RFC 5424

**Aufbau einer Syslog-Nachricht (Interface-Name je nach OPNsense-Version)**

```
<134>1 2026-11-20T10:15:02.003Z rtr-01 filterlog 4711 - - 86,,,0,vlan0.10,match,pass,in,4,...
 │    │ │                         │      │         │    └ MSGID / Structured Data ("-" = leer)
 │    │ │                         │      │         └ PROCID
 │    │ │                         │      └ APP-NAME
 │    │ │                         └ HOSTNAME
 │    │ └ TIMESTAMP (ISO 8601)
 │    └ VERSION
 └ PRI = Facility × 8 + Severity = 16 (local0) × 8 + 6 (info) = 134
```

### Windows: Sysmon- und Security-Ereignisse

| **Quelle** | **Event-ID** | **Bedeutung** | **Nutzen im Szenario** |
|---|---|---|---|
| **Sysmon** | 1 | Process Create (Kommandozeile, Hashes, Elternprozess) | Payload-Ausführung, PowerShell |
| **Sysmon** | 3 | Network Connection | C2-Beacons, Lateral Movement |
| **Sysmon** | 7 / 8 | Image Loaded / CreateRemoteThread | DLL-Injection |
| **Sysmon** | 10 | Process Access | Zugriff auf lsass.exe (Credential Dumping) |
| **Sysmon** | 11 | File Create | Ablage von Malware, Ransomware-Notizen |
| **Sysmon** | 12 / 13 / 14 | Registry-Ereignisse | Persistenz (Run Keys) |
| **Sysmon** | 22 | DNS Query | C2-Domains, DNS-Tunneling |
| **Security** | 4624 / 4625 | Anmeldung erfolgreich / fehlgeschlagen (Logon-Typ!) | Brute Force, RDP (Typ 10), Netzwerk (Typ 3) |
| **Security** | 4648 | Anmeldung mit expliziten Anmeldedaten | runas, Lateral Movement |
| **Security** | 4672 | Spezielle Privilegien | Admin-Anmeldungen |
| **Security** | 4688 | Prozess erstellt | Alternative zu Sysmon 1 |
| **Security** | 4698 | Geplante Aufgabe erstellt | Persistenz |
| **Security** | 4720 / 4728 / 4732 | Benutzer angelegt / Gruppe erweitert | Persistenz, Rechteausweitung |
| **Security** | 4768 / 4769 | Kerberos TGT / Service-Ticket | AS-REP-Roasting / Kerberoasting (0x17 = RC4) |
| **Security** | 4776 | NTLM-Anmeldeprüfung | Pass-the-Hash, Password Spraying |
| **Security** | 1102 | Audit-Log gelöscht | Spurenverwischung |
| **System** | 7045 | Dienst installiert | PsExec, Persistenz |

Tabelle 104: Wichtige Windows-Ereignis-IDs

## DHCP: Wie eine VM ihre Adresse bekommt

Beim Start einer neuen VM ohne feste Adresse läuft der DHCP-Austausch ab – vier Nachrichten, abgekürzt DORA. Weil der Client anfangs noch keine Adresse hat, nutzt er Broadcasts.

![Abbildung 47: DHCP-Austausch (DORA) im VLAN 30](asset:cyberrange/cr-15-047.png)

**So liest man die Abbildung:**

- **DISCOVER:** Der Client sendet von 0.0.0.0, UDP-Port 68, an die Broadcast-Adresse 255.255.255.255, Port 67.
- **OFFER:** Der DHCP-Server (Kea auf OPNsense) bietet eine Adresse mit Netzmaske, Gateway, DNS-Server und Lease-Dauer an.
- **REQUEST:** Der Client bestätigt per Broadcast, welches Angebot er annimmt – so erfahren auch andere DHCP-Server davon.
- **ACK:** Der Server bestätigt. Vor der Nutzung prüft der Client per ARP, ob die Adresse wirklich frei ist.
> [!TIPP] Feste Adressen in der Range
> Server und Domänencontroller erhalten feste Adressen (über cloud-init bzw. Ansible). DHCP wird nur für Clients und NPCs genutzt. Für Forensik wichtig: Die DHCP-Leases von OPNsense werden an das SIEM gesendet, damit eine IP-Adresse zu jedem Zeitpunkt einem Rechnernamen zugeordnet werden kann.

## Ein DNS-Paket Byte für Byte

![Abbildung 48: Aufbau eines DNS-Anfragepakets](asset:cyberrange/cr-15-048.png)

**So liest man die Abbildung:**

- **Oben** die Kapselung: Ethernet (14 Byte), IPv4 (20 Byte), UDP (8 Byte), DNS-Header (12 Byte) und der Frageteil.
- **Mitte** der DNS-Header: Die 16-Bit-**ID** ordnet Antworten Anfragen zu. Die Flags enthalten u. a. QR (Anfrage/Antwort), RD (Rekursion gewünscht), RA (Rekursion verfügbar) und den Antwortcode **RCODE** (0 = NOERROR, 3 = NXDOMAIN).
- **Unten** der Name: Er wird nicht mit Punkten gespeichert, sondern als Folge von Längenangaben und Zeichen (7 »update«, 14 »nordwind-cloud«, 3 »com«, 0).

Diese Kodierung erklärt, warum DNS-Tunneling auffällt: Jedes Label darf höchstens 63 Zeichen und der gesamte Name höchstens 253 Zeichen lang sein. Tunnel-Werkzeuge reizen diese Grenzen aus und erzeugen dadurch ungewöhnlich lange Namen mit hoher Zeichenvielfalt (Entropie). Eine einfache Zeek- oder SIEM-Abfrage nach Anfragen mit mehr als 50 Zeichen pro Label findet solche Kanäle zuverlässig.

## Der TCP-Zustandsautomat

Jede TCP-Verbindung durchläuft feste Zustände. Wer sie kennt, versteht Firewall-States, Zeek-Verbindungszustände und typische Scan-Muster.

![Abbildung 49: Vereinfachter TCP-Zustandsautomat](asset:cyberrange/cr-15-049.png)

**So liest man die Abbildung:**

- Der **Server** wartet im Zustand LISTEN, der **Client** wechselt mit dem ersten SYN nach SYN_SENT.
- Nach dem Drei-Wege-Handshake sind beide Seiten in **ESTABLISHED** (grün).
- Beim Abbau sendet die schließende Seite FIN und wartet am Ende in **TIME_WAIT** für die doppelte MSL, damit verspätete Pakete keine neue Verbindung stören.
- Unten rechts die Übersetzung in Zeek: **S0** (nur SYN, keine Antwort – typisch für Scans auf gefilterte Ports), **REJ** (Antwort RST), **SF** (sauber auf- und abgebaut).
| **Scan-Typ (nmap)** | **Pakete** | **Antwort bei offenem Port** | **Spur in Zeek** |
|---|---|---|---|
| **SYN-Scan (-sS)** | SYN, dann RST statt ACK | SYN/ACK | viele Verbindungen mit Zustand S0/REJ/RSTO |
| **Connect-Scan (-sT)** | kompletter Handshake | SYN/ACK → ACK | kurze SF-Verbindungen ohne Nutzdaten |
| **UDP-Scan (-sU)** | leere UDP-Pakete | meist keine (oder Dienstantwort) | ICMP »port unreachable« für geschlossene Ports |
| **Ping-Sweep (-sn)** | ICMP Echo, TCP 443/80, ARP im lokalen Netz | Echo Reply | viele Ziele in kurzer Zeit (notice.log) |

Tabelle 105: Scan-Arten und ihre Spuren

## Werkzeuge für die Paketanalyse

Für die Arbeit mit Mitschnitten braucht das Blue Team zwei Filtersprachen: die **BPF-Syntax** (Berkeley Packet Filter) zum Mitschneiden mit tcpdump und die **Anzeigefilter** von Wireshark zur Analyse.

| **Aufgabe** | **tcpdump (BPF, beim Mitschneiden)** | **Wireshark (Anzeigefilter)** |
|---|---|---|
| **Nur ein Host** | `host 10.10.30.101` | `ip.addr == 10.10.30.101` |
| **Nur DNS** | `port 53` | `dns` |
| **SYN ohne ACK (Scans)** | `'tcp[tcpflags] & (tcp-syn/tcp-ack) == tcp-syn'` | `tcp.flags.syn == 1 && tcp.flags.ack == 0` |
| **Kerberos-Dienstticket-Anfragen** | `port 88` | `kerberos.msg_type == 12` |
| **HTTP-POST** | – | `http.request.method == "POST"` |
| **TLS-ClientHello mit SNI** | `port 443` | `tls.handshake.type == 1 && tls.handshake.extensions_server_name` |
| **Lange DNS-Namen** | – | `dns.qry.name.len > 60` |
| **SMB-Dateizugriffe** | `port 445` | `smb2.cmd == 5` (CREATE) |

Tabelle 106: Filter für tcpdump und Wireshark

**Paketanalyse auf der Kommandozeile**

```
# Mitschnitt auf dem Sensor (Security Onion speichert ohnehin PCAP – dies ist für Einzelanalysen)
tcpdump -i bond0 -nn -s 0 -w /tmp/dc01.pcap host 10.10.30.10 and port 88
# Statistik: Wer spricht mit wem? (tshark = Wireshark auf der Kommandozeile)
tshark -r /tmp/dc01.pcap -q -z conv,ip
# Alle angeforderten Dienste (SPNs) aus TGS-Anfragen
tshark -r /tmp/dc01.pcap -Y "kerberos.msg_type == 12" -T fields -e ip.src -e kerberos.SNameString
```

## IPv6 in der Range nicht vergessen

Moderne Windows-Systeme bevorzugen IPv6, selbst wenn das Netz »nur IPv4« hat. Das schafft Angriffsflächen, die in Übungen sehr lehrreich sind:

- **SLAAC und Router Advertisements:** Clients konfigurieren sich selbst, sobald ein Router Advertisement im Netz erscheint. Ein Angreifer kann sich so als IPv6-Router und DNS-Server ausgeben (bekannt durch das Werkzeug mitm6) und Anmeldungen umleiten.
- **Neighbor Discovery (NDP)** ersetzt ARP und ist ebenso fälschbar.
- **Gegenmaßnahmen:** IPv6 bewusst planen statt ignorieren – entweder sauber betreiben (RA-Guard, DHCPv6-Guard auf Switches) oder per Gruppenrichtlinie auf »IPv4 bevorzugen« setzen und unerwünschte RAs auf der Firewall blockieren.
- **Monitoring:** Zeek und Suricata analysieren IPv6 vollständig; das Blue Team muss Filter und Dashboards aber auch für IPv6-Adressen auslegen.
## Ein Paket in der Hex-Ansicht lesen

Werkzeuge wie Wireshark zeigen Pakete zusätzlich als Folge von Bytes in hexadezimaler Schreibweise. Diese Ansicht wirkt zunächst abschreckend, ist aber logisch aufgebaut: Jedes Feld der Header hat seine feste Position. Wer ein einziges Paket einmal Byte für Byte gelesen hat, versteht danach jede Protokollanalyse besser.

![Abbildung 50: Ein TCP-SYN-Paket Byte für Byte](asset:cyberrange/cr-15-050.png)

**So liest man die Abbildung:**

- Jede **Zeile** enthält 16 Byte; links steht die Position (Offset) des ersten Bytes in hexadezimaler Zählung (0000, 0010, 0020 …).
- Die **ersten 14 Byte** sind der Ethernet-Header: Ziel-MAC, Quell-MAC und der EtherType `08 00` für IPv4.
- Ab Byte 14 folgt der **IPv4-Header** (blau): `45` bedeutet Version 4 mit 20 Byte Header, `00 3c` die Gesamtlänge 60, `40` die TTL 64, `06` das Protokoll TCP. Die Adressen `0a 0a 1e 65` und `0a 0a 14 0a` sind 10.10.30.101 und 10.10.20.10.
- Ab Byte 34 beginnt der **TCP-Header**: Quellport `c9 50` (51536), Zielport `01 bb` (443), Sequenznummer, Bestätigungsnummer, dann `a0 02` – 40 Byte Header-Länge und das Flag SYN.
- Die letzten 20 Byte sind **TCP-Optionen**: MSS 1460, SACK erlaubt, Zeitstempel und Window Scaling.
| **Hex** | **Dezimal** | **Wie man rechnet** |
|---|---|---|
| **0a** | 10 | 0 × 16 + 10 (a = 10) |
| **1e** | 30 | 1 × 16 + 14 (e = 14) |
| **65** | 101 | 6 × 16 + 5 |
| **01 bb** | 443 | 1 × 256 + 11 × 16 + 11 = 256 + 187 |
| **05 b4** | 1460 | 5 × 256 + 180 |

Tabelle 107: Hexadezimal lesen – Beispiele aus dem Paket

## ICMP und Traceroute verstehen

ICMP ist das Diagnose- und Fehlerprotokoll von IP. Es überträgt keine Nutzdaten, sondern Meldungen wie »Ziel nicht erreichbar« oder »Lebensdauer abgelaufen«. Zwei Werkzeuge, die jeder in der Range braucht, beruhen darauf:

| **ICMP-Typ** | **Name** | **Bedeutung** | **Wo es in der Range auftaucht** |
|---|---|---|---|
| **0 / 8** | Echo Reply / Echo Request | Antwort / Anfrage eines Pings | Erreichbarkeitstests, Ping-Sweeps des Red Teams |
| **3** | Destination Unreachable | Ziel nicht erreichbar (Code 3 = Port, Code 13 = administrativ verboten) | abgelehnte Verbindungen, UDP-Scans |
| **5** | Redirect | besserer Router verfügbar | sollte in der Range nicht vorkommen – verdächtig |
| **11** | Time Exceeded | TTL ist auf 0 gesunken | Traceroute |

Tabelle 108: Wichtige ICMP-Meldungen

**Traceroute** nutzt einen Trick: Es sendet Pakete mit TTL 1, 2, 3 … Jeder Router verringert die TTL um eins; erreicht sie 0, verwirft der Router das Paket und meldet sich per ICMP »Time Exceeded«. So erfährt man nacheinander die Adresse jedes Routers auf dem Weg. In der Range zeigt ein Traceroute von ws01 zu web01 genau einen Zwischenschritt – die OPNsense (10.10.30.1). Ein Traceroute ins SINET zeigt zusätzlich die simulierten Provider-Router und macht die Kulisse für Teilnehmer glaubwürdig.

**Traceroute von ws01 ins simulierte Internet**

```
C:\> tracert -d 198.51.100.80
  1    <1 ms    <1 ms    <1 ms  10.10.30.1        ← OPNsense (Gateway CORP)
  2     1 ms     1 ms     1 ms  198.51.100.1      ← simulierter Provider-Router (VyOS im SINET)
  3     1 ms     1 ms     1 ms  198.51.100.80     ← Webserver der Kulissen
```

> [!INFO]
> **TEIL C**
> **Praxis & Umsetzung**
> Wie andere Organisationen ihre Ranges gebaut haben, wie die Range mit zwei Maschinen entsteht, wie sie wächst und wie eine Übung konkret abläuft.
> Kapitel 16: Wie andere Cyber Ranges aufgebaut sind
> Kapitel 17: Minimal-Setup mit 2 Maschinen
> Kapitel 18: Bauanleitung Schritt für Schritt
> Kapitel 19: Skalierung: Wie man die Range vergrößert
> Kapitel 20: Beispielszenario »Operation Nordlicht«
> Kapitel 21: Scoring und Auswertung
> Kapitel 22: Betrieb, Fehlersuche und Recht
