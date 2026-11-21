---
id: cr-05
title: L2 – Netzwerk, Zonen und Firewall
paths: cyberrange
order: 5
difficulty: medium
icon: network
summary: Kapitel 5 deiner Cyber-Range-Dokumentation: L2 – Netzwerk, Zonen und Firewall.
source: Cyber_Range_Dokumentation.docx
htb: Cyber Range 05 · L2 Netzwerk & Firewall
---

## Überblick

Das Netzwerk ist das **Herz** der Cyber Range. Es entscheidet, wer wen erreichen kann, und damit, was überhaupt angegriffen und verteidigt wird. Gleichzeitig ist es die wichtigste Sicherheitsgrenze: Ein Fehler hier kann dazu führen, dass Übungsverkehr in reale Netze gelangt.

## Bausteine: Bridge, VLAN, Trunk und Router

| **Baustein** | **Vergleich aus der realen Welt** | **Umsetzung in der Range** |
|---|---|---|
| **Bridge (vmbr)** | Ein Switch | Linux-Bridge `vmbr1` im Kernel von Maschine A |
| **VLAN (802.1Q)** | Getrennte Switches in einem Gerät | VLAN 10 RED, 20 DMZ, 30 CORP, 40 SINET, 50 BLUE-SOC, 90 NPC |
| **Access-Port** | Switch-Port für einen PC, gehört zu genau einem VLAN | VM-Netzwerkkarte mit `tag=20` (PVID 20) |
| **Trunk-Port** | Switch-Port, der mehrere VLANs getaggt überträgt | Netzwerkkarte der Router-VM ohne Tag (alle VLANs) |
| **Router / Firewall** | Verbindet Netze und filtert | OPNsense-VM »rtr-01« mit einem VLAN-Interface pro Zone |

Tabelle 30: Netzwerkbausteine

Eine **VLAN-aware Bridge** verhält sich wie ein managebarer Switch: Sie ordnet jeden Frame anhand des Ports bzw. des Tags einem VLAN zu und leitet ihn nur an Ports desselben VLANs weiter. Zwei VMs in unterschiedlichen VLANs können sich deshalb **nicht direkt** erreichen – jeder Verkehr zwischen Zonen muss über die Router-VM und damit durch das Firewall-Regelwerk.

## Netzzonen

| **Zone** | **Zweck** | **Wer darf hinein?** | **Wer darf hinaus?** |
|---|---|---|---|
| **MGMT** | Hypervisor-Management, APIs, OOB | Nur Admins über Admin-VPN | Updates via Proxy ins Internet |
| **SVC / TRANSFER (VLAN 99)** | Telemetrie, Guacamole → VMs, Ansible im Build-Fenster | Agenten aus der Range (nur definierte Ports) | Guacamole/Ansible gezielt in die Range |
| **SPAN / SNIFF** | Gespiegelte Frames zum Sensor | Nur Spiegelquelle | Niemand (keine IP, nur Empfang) |
| **RED (VLAN 10)** | Angreifer-Arbeitsplätze | Red Team via Guacamole | SINET, DMZ, CORP je nach Phase |
| **DMZ (VLAN 20)** | Öffentlich erreichbare Dienste des fiktiven Unternehmens | SINET/RED auf 25/80/443 | CORP nur definierte Ports |
| **CORP (VLAN 30)** | Internes Firmennetz mit Active Directory | Nur über Firewall-Regeln | SINET über Proxy, DMZ |
| **SINET (VLAN 40)** | Simuliertes Internet | Alle Übungszonen | Alle Übungszonen |
| **BLUE-SOC (VLAN 50)** | Analysten-Arbeitsplätze, SIEM-Zugriff | Blue Team via Guacamole | SIEM-Weboberflächen, CORP-Administration |
| **NPC (VLAN 90)** | GHOSTS-API und NPC-Clients | GHOSTS-Clients | CORP/DMZ/SINET |

Tabelle 31: Netzzonen

![Abbildung 12: Zonenmatrix – welche Zone welche Zone erreichen darf](asset:cyberrange/cr-05-012.png)

**So liest man die Abbildung:**

- Jede **Zeile** ist die Quelle, jede **Spalte** das Ziel. Grün = Verkehr ist Teil des Szenarios (Angriffsfläche), gelb = nur bestimmte Ports zu bestimmten Zielen, rot = verboten.
- Die Zeile **MGMT** und die Spalte **MGMT** sind vollständig rot: Die Steuerungsebene ist aus der Übung heraus unerreichbar und greift selbst nicht über das Übungsnetz zu.
- **SVC** ist eine Einbahnstraße mit Ausnahmen: Agenten melden hinein, Guacamole und Ansible greifen gezielt heraus.
## IP- und VLAN-Plan

| **VLAN / Netz** | **Subnetz** | **Gateway** | **Wichtige Hosts** |
|---|---|---|---|
| **MGMT (untagged, vmbr0)** | 10.0.0.0/24 | 10.0.0.1 | range-01 .11, ops-01 .12, Admin-Jump .20 |
| **99 SVC/TRANSFER (vmbr2)** | 10.99.0.0/24 | 10.99.0.1 (OPNsense) | Wazuh .10, Security Onion .11, Guacamole .20, IaC .30, CTFd .40 |
| **10 RED** | 10.10.10.0/24 | 10.10.10.1 | kali01 .50, kali02 .51, c2-01 .60 |
| **20 DMZ** | 10.10.20.0/24 | 10.10.20.1 | web01 .10, mail01 .25, vpn-gw .30 |
| **30 CORP** | 10.10.30.0/24 | 10.10.30.1 | dc01 .10, fs01 .20, ws01-ws03 .101-.103 |
| **40 SINET** | 10.10.40.0/24 (+ »öffentliche« Präfixe) | 10.10.40.1 | inet-dns .53, inet-web .80, inet-mail .25, redirector .66 |
| **50 BLUE-SOC** | 10.10.50.0/24 | 10.10.50.1 | soc01 .10, soc02 .11 |
| **90 NPC** | 10.10.90.0/24 | 10.10.90.1 | ghosts-api .5 |

Tabelle 32: IP-/VLAN-Plan der Pilot-Range

> [!TIPP] Adressschema für spätere Erweiterung
> Das Open-Source-Werkzeug Ludus verwendet das Schema **10.<Range-Nr>.<VLAN>.<Host>** – jede Range (jedes Team) bekommt ein eigenes zweites Oktett. Dieses Schema wird für die Erweiterung übernommen: Team 1 = 10.11.x.x, Team 2 = 10.12.x.x usw. Sollen alle Teams **identische** Adressen sehen (»Klon-Ranges«), kommen stattdessen getrennte VRFs/SDN-Zonen zum Einsatz (Kapitel 19).

## Die Firewall: OPNsense als zentrale Kontrollinstanz

OPNsense ist eine FreeBSD-basierte Firewall-Distribution. Ihr Paketfilter pf ist eine **Stateful Firewall**: Er merkt sich jede erlaubte Verbindung in einer Zustandstabelle (States) und lässt die Antwortpakete automatisch passieren. OPNsense bündelt in der Range mehrere Funktionen:

- **Routing** zwischen allen Übungszonen (ein VLAN-Interface je Zone, jeweils `.1` als Gateway).
- **Filterung** nach Regelwerk (Default Deny) – jede Regel mit Protokollierung, damit das Firewall-Log als Telemetrie dient.
- **DNS** über den integrierten Resolver Unbound, der als Wurzel das simulierte Internet verwendet.
- **DHCP** für Zonen mit dynamischen Clients (optional; Server erhalten feste Adressen).
- **NAT** für Szenarien, in denen »öffentliche« SINET-Adressen auf DMZ-Server abgebildet werden.
- **Syslog-Export** aller Firewall-Entscheidungen an das SIEM.
## Firewall-Regelwerk (Auszug)

Regeln werden in OPNsense **pro Interface in Eingangsrichtung** ausgewertet; die Oberfläche erzeugt `quick`-Regeln, bei denen der **erste Treffer** gilt. Die Reihenfolge ist daher entscheidend: spezifische Verbote zuerst, dann Erlaubnisse, am Ende Default Deny.

| **#** | **Quelle** | **Ziel** | **Protokoll/Port** | **Aktion** | **Begründung** |
|---|---|---|---|---|---|
| **1** | RED net | MGMT, SVC (alles) | any | BLOCK + log | Schutz der Control/Observation Plane |
| **2** | Alle Range-Zonen | 10.99.0.10 (Wazuh) | TCP 1514, 1515 | PASS | Wazuh-Agent-Kommunikation / Enrollment (4.x) |
| **3** | Alle Range-Zonen | 10.99.0.11 (Security Onion) | TCP 5055, 8220, 8443 | PASS | Elastic Agent: Daten, Fleet, Updates |
| **4** | 10.99.0.20 (Guacamole) | Ziel-VMs | TCP 3389, 22 | PASS | Benutzerzugang |
| **5** | 10.99.0.30 (Ansible) | Range-Netze | TCP 22, 5986 | PASS (nur im Build-Fenster) | Provisionierung; zur Übung deaktivieren |
| **6** | RED net | SINET, DMZ | any | PASS | Angriffsfläche des Szenarios |
| **7** | SINET | DMZ | TCP 25, 80, 443 | PASS | »Internet« erreicht öffentliche Dienste |
| **8** | CORP | SINET | TCP 80/443 via Proxy, UDP 53 via DC | PASS | Realistischer Unternehmens-Ausgang |
| **9** | DMZ | CORP | TCP 1433/3306 nur web01→db | PASS | Bewusst schmale Lücke (Szenario) |
| **10** | any | any | any | BLOCK + log | Default Deny |

Tabelle 33: Auszug aus dem Firewall-Regelwerk

## Das simulierte Internet (SINET)

Teilnehmer, Programme und Schadsoftware erwarten ein Internet: DNS-Auflösung, Webseiten, gültige Zertifikate, Mailserver, Update-Server. Ein echter Internetzugang ist aus Sicherheitsgründen ausgeschlossen. Stattdessen wird ein **simuliertes Internet** gebaut – bei der NATO-Übung Locked Shields »SINET«, in der Literatur auch »Grey Space« genannt.

![Abbildung 13: Aufbau des simulierten Internets](asset:cyberrange/cr-05-013.png)

- **DNS-Hierarchie:** eigener Root-Server (BIND/CoreDNS) mit eigenen Top-Level-Domains bzw. nachgebauten realen Zonen; alle Resolver der Range verwenden ihn als Wurzel.
- **Web:** nachgebaute Webseiten (Nginx), eine Suchmaschinen-Attrappe, ein Pastebin-Klon, von dem das Red Team Nutzlasten lädt.
- **PKI:** eine eigene Root-Zertifizierungsstelle (z. B. step-ca), deren Zertifikat in allen Clients installiert ist → HTTPS funktioniert wie im echten Internet.
- **Mail:** Postfix/Dovecot als »Freemail-Provider« und für Phishing-Absenderdomains.
- **Fallback:** INetSim beantwortet beliebige unbekannte Anfragen (DNS, HTTP, SMTP …) – Schadsoftware »glaubt«, online zu sein, und zeigt ihr Verhalten.
- **Öffentliche Adressbereiche:** Im SINET dürfen auch echte öffentliche Präfixe verwendet werden (z. B. Red-Team-Server auf 185.x.x.x), weil sie die Range nie verlassen – das erhöht den Realismus erheblich.
## Isolation und Ausgangskontrolle

> [!GEFAHR] Goldene Regel der Isolation
> Die Übungs-Bridge `vmbr1` hat **keinen physischen Port** und **keine IP-Adresse** auf dem Hypervisor. Der einzige Übergang aus dem Übungsnetz ist die OPNsense-VM – und deren Übergang ins SVC-Netz ist auf wenige, ausdrücklich freigegebene Ports zu festen Zielen beschränkt. Es gibt **keine Route** von der Range ins MGMT-Netz oder ins Internet.

- Proxmox-Datacenter-Firewall aktivieren: Zugriff auf 8006/22 des Hypervisors nur aus dem Admin-Netz.
- Spoofing-Schutz (Proxmox-Optionen `ipfilter`/`macfilter`) dort aktivieren, wo das Szenario kein Spoofing vorsieht.
- Keine geteilten Ordner, Zwischenablage-Freigaben oder USB-Durchreichungen in Malware-Szenarien.
- Vor jeder Übung Egress-Test: aus jeder Zone `curl https://example.com` und `ping 8.8.8.8` – beides **muss** scheitern bzw. im SINET landen.
## Proxmox SDN – Netz als Software

Für den Pilot mit einem Range-Host genügen klassische Linux-Bridges. Sobald die Range auf mehrere Hosts wächst, übernimmt **Proxmox SDN** (Software-Defined Networking) die Netzkonfiguration zentral für den ganzen Cluster:

| **SDN-Objekt** | **Bedeutung** | **Beispiel** |
|---|---|---|
| **Zone** | Art des Overlays bzw. der Trennung | Simple, VLAN, QinQ, VXLAN, EVPN |
| **VNet** | Ein virtuelles Netz in einer Zone (entspricht einem VLAN bzw. einer VNI) | »t1corp« mit VNI 11030 |
| **Subnetz** | IP-Bereich mit Gateway eines VNets | 10.11.30.0/24, Gateway 10.11.30.1 |
| **IPAM** | Verwaltung der vergebenen Adressen | PVE-IPAM, NetBox, phpIPAM |
| **Fabric (ab PVE 9)** | Routing im Underlay zwischen den Hosts | OpenFabric oder OSPF |

Tabelle 34: Objekte in Proxmox SDN

## Der Weg eines Pakets durch die VLANs

Wie kommt ein Paket von einer Workstation im CORP-Netz zu einem Webserver in der DMZ? Die folgende Abbildung zeigt jede Station und jeweils, ob das Paket ein 802.1Q-Tag trägt.

![Abbildung 14: Wo das VLAN-Tag hinzukommt und wieder verschwindet](asset:cyberrange/cr-05-014.png)

**So liest man die Abbildung:**

- Die VM `ws01` sendet ein **normales Ethernet-Frame ohne Tag** – sie weiß nichts von VLANs.
- Das tap-Interface ist ein **Access-Port** der Bridge mit der Port-VLAN-ID 30. Die Bridge ordnet das Frame intern VLAN 30 zu.
- Zur OPNsense geht das Frame über den **Trunk** mit Tag 30. OPNsense empfängt es auf dem VLAN-Interface `vtnet1.30`.
- OPNsense **routet** (neue Quell-MAC, TTL − 1) und prüft das Regelwerk. Ist der Zugriff erlaubt, sendet sie das Paket mit **Tag 20** zurück auf den Trunk.
- Die Bridge entfernt das Tag am Access-Port des Webservers – `web01` erhält wieder ein Frame ohne Tag.
- Unten ist das 802.1Q-Frame im Detail zu sehen: TPID 0x8100, dann 3 Bit Priorität, 1 Bit DEI und 12 Bit VLAN-ID.

Wichtig für die Sicherheit: Weil die VMs nur an Access-Ports hängen, können sie **keine eigenen Tags** einschleusen (»VLAN-Hopping« per Double-Tagging). In Proxmox wird das sichergestellt, indem jede VM-Netzwerkkarte ein festes `tag=` erhält und die Bridge nur die erlaubten VLANs durchlässt (`bridge-vids 10 20 30 40 50 90`).

## DNS im simulierten Internet

Ohne funktionierende Namensauflösung ist keine Übung realistisch: Phishing-Mails brauchen Absender-Domains, Schadsoftware ruft C2-Domains auf, Benutzer surfen »im Internet«. Das SINET bildet deshalb die **komplette DNS-Hierarchie** nach – mit eigenem Root-Server, eigenen Top-Level-Domains und autoritativen Servern.

![Abbildung 15: Rekursive Namensauflösung im SINET](asset:cyberrange/cr-05-015.png)

**So liest man die Abbildung:**

- Der Client fragt den **rekursiven Resolver** (Unbound auf OPNsense) mit gesetztem RD-Bit (»Recursion Desired«).
- Unbound beginnt bei den **Root-Hints** – im SINET zeigen sie nicht auf die echten Root-Server, sondern auf einen simulierten Root-Server.
- Root- und TLD-Server antworten mit **Verweisen (Referrals)**, der **autoritative Server** liefert die eigentliche Antwort.
- Jede dieser Anfragen erscheint im Zeek-`dns.log` und kann vom Blue Team ausgewertet werden.
**SINET – Root-Zone (BIND 9)**

```
; Zone "." auf dem simulierten Root-Server (BIND 9), Auszug
$TTL 86400
.            IN SOA  a.root-sim. hostmaster.root-sim. 2026112001 3600 900 604800 86400
.            IN NS   a.root-sim.
a.root-sim.  IN A    198.51.100.53
; Delegationen an simulierte TLD-Server
com.         IN NS   ns.tld-sim.
net.         IN NS   ns.tld-sim.
de.          IN NS   ns.tld-sim.
ns.tld-sim.  IN A    198.51.100.54
```

**Unbound – eigene Root-Hints**

```
# Unbound (OPNsense → Dienste → Unbound DNS → Erweitert / benutzerdefinierte Optionen)
server:
  root-hints: "/var/unbound/root-sim.hints"   # verweist auf a.root-sim. 198.51.100.53
  harden-dnssec-stripped: no                  # kein echtes DNSSEC im SINET
  module-config: "iterator"                   # Validierung abschalten
```

> [!TIPP] Domains für das Szenario
> Firmen-Domain intern: `nordwind.lab` (AD) und extern `nordwind-logistik.de` (im SINET)
> Angreifer-Domains: optisch ähnlich (`nordwind-logistlk.de`), »Cloud«-Domains (`nordwind-cloud.com`) und zufällig wirkende C2-Domains
> Populäre echte Domains (z. B. Suchmaschinen) werden im SINET als harmlose Platzhalterseiten nachgebildet, damit GHOSTS-Benutzer »normal« surfen können

## Portweiterleitung in die DMZ und NAT

Aus Sicht des Red Teams sitzt die Firma »hinter« einer öffentlichen Adresse im SINET. Damit der Webshop erreichbar ist, leitet OPNsense Verbindungen auf 198.51.100.10:443 per DNAT an den Webserver in der DMZ weiter. Der Rückweg wird über das Connection Tracking automatisch zurückübersetzt.

![Abbildung 16: Portweiterleitung (DNAT) und Rückweg über die Zustandstabelle](asset:cyberrange/cr-05-016.png)

**So liest man die Abbildung:**

- Das erste SYN-Paket trifft auf die **Weiterleitungsregel** (rdr). OPNsense ersetzt die Zieladresse und legt einen **State** an.
- Die Antwort des Webservers wird anhand des States **zurückübersetzt** – der Angreifer sieht nur die öffentliche Adresse.
- Alle weiteren Pakete der Verbindung werden über den State zugeordnet, ohne das Regelwerk erneut zu durchlaufen. Das macht Stateful Firewalls schnell.
**pf – Weiterleitung und Quell-NAT**

```
# Prinzip der von OPNsense erzeugten pf-Regeln (vereinfacht, zum Verständnis)
rdr on vtnet1.40 inet proto tcp from any to 198.51.100.10 port 443 -> 10.10.20.10 port 443
nat on vtnet1.40 inet from 10.10.30.0/24 to any -> 198.51.100.10        # SNAT für CORP-Clients
pass in quick on vtnet1.40 inet proto tcp from any to 10.10.20.10 port 443 keep state
```

Ausgehend nutzt das CORP-Netz SNAT: Alle Clients erscheinen im SINET mit der Adresse 198.51.100.10. Für das Blue Team ist das realistisch – und es zwingt die Analysten, Firewall-Logs und Zeek-Daten **vor** und **hinter** der NAT zu korrelieren.

## Vollständiges Zonenregelwerk

| **Von \ Nach** | **RED** | **DMZ** | **CORP** | **SINET** | **BLUE-SOC** | **NPC** | **SVC** |
|---|---|---|---|---|---|---|---|
| **RED** | – | über SINET-NAT: 80, 443, 25 | ✖ | ✔ alles | ✖ | ✖ | ✖ |
| **DMZ** | ✖ | – | nur db: 5432, ldap: 636 | ✔ 80/443 (Updates im SINET) | ✖ | ✖ | Agent 1514, Syslog |
| **CORP** | ✖ | ✔ 80/443/25 | – | ✔ über SNAT | ✖ | ✖ | Agent 1514 |
| **SINET** | ✔ | ✔ 80/443/25 (DNAT) | ✖ | – | ✖ | ✖ | ✖ |
| **BLUE-SOC** | ✖ | ✔ Admin (SSH/RDP) | ✔ Admin (RDP/WinRM) | ✖ | – | ✖ | SIEM 443 |
| **NPC** | ✖ | ✔ wie CORP | ✔ wie Benutzer | ✔ | ✖ | – | Agent 1514 |
| **SVC** | ✖ | ✔ Checks, Guacamole | ✔ Checks, Guacamole | ✔ Checks | ✔ Guacamole | ✔ Ansible | – |

Tabelle 35: Zonenmatrix: erlaubte Richtungen (✔), verboten (✖); Antworten über States

> [!INFO] Wie man die Matrix liest
> Zeile = Quelle, Spalte = Ziel. Ein Eintrag beschreibt nur den **Verbindungsaufbau**; Antwortpakete laufen automatisch über die Zustandstabelle zurück. Eine Lücke in der Matrix ist **Absicht**: Das Szenario sieht z. B. vor, dass die DMZ auf die Datenbank im CORP zugreift – genau dieser Pfad ist später der Sprungbrett-Weg des Red Teams.

## Typische Netzwerkfehler und ihre Ursache

| **Symptom** | **Wahrscheinliche Ursache** | **Prüfung** |
|---|---|---|
| **VM bekommt keine DHCP-Adresse** | falsches `tag=` an der VM-NIC oder VLAN fehlt in `bridge-vids` | `bridge vlan show` auf range-01 |
| **Ping zum Gateway geht, sonst nichts** | Regel auf OPNsense fehlt oder falsche Reihenfolge | OPNsense → Firewall → Live View |
| **Große Downloads hängen, kleine gehen** | MTU-Problem (z. B. VXLAN ohne angepasste MTU) | `ping -M do -s 1472 <Ziel>` |
| **Security Onion sieht keinen Verkehr** | Hookscript nicht ausgeführt oder falsches Interface | `tc filter show dev tapXXXi0 ingress` |
| **Namen im SINET werden nicht aufgelöst** | Root-Hints nicht geladen, Root-Server-VM aus | `dig @10.10.30.1 +trace nordwind-cloud.com` |
| **Teilnehmer erreicht Proxmox-GUI** | **schwerer Fehler**: Bridge-Zuordnung oder Regel falsch | sofort ENDEX, Egress-/Isolationstest wiederholen |

Tabelle 36: Fehlerbilder im Netzwerk

## OPNsense Schritt für Schritt einrichten

Die Firewall ist das Herzstück der Netztrennung. Die folgende Abbildung zeigt, wie die virtuellen Netzwerkkarten von rtr-01 mit den Bridges verbunden sind und welche Schnittstellen daraus in OPNsense entstehen.

![Abbildung 17: Netzwerkkarten, VLAN-Schnittstellen und Adressen der OPNsense rtr-01](asset:cyberrange/cr-05-017.png)

**So liest man die Abbildung:**

- Die VM hat nur **zwei** virtuelle Netzwerkkarten: `vtnet0` im SVC-Netz und `vtnet1` am Trunk `vmbr1`.
- Auf `vtnet1` entstehen in OPNsense **sechs VLAN-Geräte** – eines pro Zone. Jedes wird als eigene Schnittstelle mit eigener Gateway-Adresse zugewiesen.
- Die SINET-Schnittstelle trägt zusätzlich die öffentliche Adresse 198.51.100.10 als virtuelle IP für NAT und Portweiterleitung.
- Links steht die **Reihenfolge der Einrichtung**; der rote Hinweis unten ist die wichtigste Sicherheitsregel.
| **Schritt** | **Menüpfad in OPNsense (sinngemäß)** | **Einstellung** |
|---|---|---|
| **1 VLAN-Geräte** | Interfaces → Devices → VLAN | Parent `vtnet1`, Tag 10/20/30/40/50/90, Beschreibung = Zonenname |
| **2 Zuweisung** | Interfaces → Assignments | jedes VLAN-Gerät als neue Schnittstelle hinzufügen und umbenennen (RED, DMZ …) |
| **3 Adressen** | Interfaces → [Zone] | aktivieren, IPv4 statisch, z. B. 10.10.30.1/24 |
| **4 Aliase** | Firewall → Aliases | z. B. `NET_CORP`, `HOST_DC01`, `PORTS_AD` (88, 389, 445 …) |
| **5 Regeln** | Firewall → Rules → [Zone] | nach Zonenmatrix (Kapitel 5.12); letzte Regel: alles verwerfen mit Protokollierung |
| **6 DHCP** | Services → DHCPv4 (Kea bzw. je nach Version) | Bereiche je Client-Netz, feste Zuordnungen für Server |
| **7 DNS** | Services → Unbound DNS | Resolver für alle Zonen, eigene Root-Hints (Kapitel 5.10), Domänen-Weiterleitung `nordwind.lab` an dc01 |
| **8 NTP** | Services → Network Time | Zeitquelle im SVC-Netz, Bereitstellung in allen Zonen |
| **9 Remote-Logging** | System → Settings → Logging → Remote | Ziel: Security Onion bzw. Wazuh im SVC-Netz, Port 514, Firewall- und DNS-Protokolle |
| **10 Sicherung** | System → Configuration → Backups | Konfiguration als XML exportieren und ins Git-Repository legen |

Tabelle 37: Einrichtung von OPNsense in zehn Schritten

> [!TIPP] Konfiguration als Code
> OPNsense speichert die gesamte Konfiguration in einer XML-Datei (`/conf/config.xml`). Diese Datei wird nach jeder Änderung versioniert. Für vollständige Automatisierung gibt es eine REST-API und Ansible-Sammlungen der Community; im Pilot genügt es, eine geprüfte `config.xml` beim Aufbau einzuspielen.

## Eine eigene Zertifizierungsstelle für die Range

Fast alle Dienste nutzen heute verschlüsselte Verbindungen (HTTPS, LDAPS, RDP, SMTP mit STARTTLS). Damit Browser und Programme in der Range diesen Verbindungen vertrauen – und damit Teilnehmer nicht lernen, Zertifikatswarnungen wegzuklicken –, betreibt die Range eine eigene **PKI**.

![Abbildung 18: Vertrauenskette der Range-PKI](asset:cyberrange/cr-05-018.png)

**So liest man die Abbildung:**

- Ganz links steht die **Root-CA**. Sie signiert nur zwei Zertifikate – die der beiden **Zwischen-CAs** – und wird danach offline aufbewahrt.
- Die Zwischen-CA »SINET« stellt Zertifikate für die Kulissen-Webseiten und Mailserver im simulierten Internet aus, die Zwischen-CA »Firma« für interne Dienste der Firma.
- Das Root-Zertifikat wird in den **Vertrauensspeicher** aller Clients verteilt. Dadurch zeigen Browser ein gültiges Schloss – genau wie im echten Internet.
- Beim Verbindungsaufbau prüft der Client die Kette von unten nach oben: Server-Zertifikat → Zwischen-CA → Root-CA, außerdem Name und Gültigkeit.
**PKI mit OpenSSL (Prinzip; alternativ step-ca oder AD CS)**

```
# 1) Root-CA (einmalig, auf einem Offline-Rechner; Schlüssel mit Passphrase)
openssl req -x509 -newkey rsa:4096 -sha256 -days 3650 \
  -keyout root.key -out root.crt -subj "/O=Range/CN=Range Root CA"

# 2) Zwischen-CA »SINET«: Schlüssel + Antrag, dann von der Root-CA signieren
openssl req -newkey rsa:3072 -keyout sinet-ca.key -out sinet-ca.csr -subj "/O=Range/CN=Range SINET CA"
printf "basicConstraints=critical,CA:TRUE,pathlen:0\nkeyUsage=critical,keyCertSign,cRLSign\n" > ca.ext
openssl x509 -req -in sinet-ca.csr -CA root.crt -CAkey root.key -CAcreateserial \
  -days 730 -sha256 -extfile ca.ext -out sinet-ca.crt

# 3) Serverzertifikat mit Subject Alternative Name (Pflicht für moderne Browser)
openssl req -newkey rsa:2048 -nodes -keyout www.key -out www.csr -subj "/CN=www.nordwind-logistik.de"
printf "subjectAltName=DNS:www.nordwind-logistik.de,DNS:nordwind-logistik.de\nextendedKeyUsage=serverAuth\n" > srv.ext
openssl x509 -req -in www.csr -CA sinet-ca.crt -CAkey sinet-ca.key -CAcreateserial \
  -days 397 -sha256 -extfile srv.ext -out www.crt
```

| **System** | **Wie das Root-Zertifikat verteilt wird** |
|---|---|
| **Windows (Domäne)** | Gruppenrichtlinie: Computerkonfiguration → Richtlinien → Windows-Einstellungen → Sicherheitseinstellungen → Richtlinien für öffentliche Schlüssel → Vertrauenswürdige Stammzertifizierungsstellen |
| **Linux (Debian/Ubuntu)** | Datei nach `/usr/local/share/ca-certificates/range-root.crt` kopieren, dann `update-ca-certificates` (per Ansible) |
| **Firefox** | eigener Zertifikatsspeicher: per Richtlinie den Windows-Speicher übernehmen oder das Zertifikat über eine Unternehmensrichtlinie importieren |
| **Java-Anwendungen** | eigener Keystore (`keytool -importcert`) |

Tabelle 38: Verteilung des Root-Zertifikats

> [!WARNUNG] Nur erfundene Domains zertifizieren
> Die Range-PKI stellt Zertifikate ausschließlich für erfundene Domains aus (z. B. `nordwind-logistik.de` als fiktive Firma, `news-sim.com`). Das Root-Zertifikat der Range wird **nie** auf Rechnern außerhalb der Range installiert – sonst könnte ein Leck dieser CA echte Verbindungen gefährden.

## Die Dienste des simulierten Internets im Detail

| **Dienst** | **Software (Beispiel)** | **Adresse im SINET** | **Zweck in der Übung** |
|---|---|---|---|
| **Root- und TLD-DNS** | BIND 9 | 198.51.100.53/.54 | vollständige DNS-Hierarchie (Kapitel 5.10) |
| **Autoritative DNS der Kulissen** | BIND 9 oder PowerDNS | 198.51.100.55 | Zonen der fiktiven Firmen und Nachrichtenseiten |
| **Webserver der Kulissen** | nginx mit vielen virtuellen Hosts | 198.51.100.80 | Nachrichten, Suchseite, Lieferanten, Cloud-Dienst |
| **Mail-Provider** | Postfix + Dovecot + Webmail | 198.51.100.25 | externe Mail-Partner, Absender von Phishing-Kampagnen |
| **Update-Spiegel** | nginx / apt-Spiegel | 198.51.100.90 | »Updates aus dem Internet« für DMZ-Server |
| **Zeitserver** | chrony | 198.51.100.123 | öffentlicher NTP-Server aus Sicht der Firma |
| **Allzweck-Simulator** | INetSim | Standardroute im SINET | beantwortet alle sonst unbekannten Anfragen (HTTP, DNS, SMTP …) harmlos |
| **Angreifer-Infrastruktur** | VMs des Red Teams | 203.0.113.0/24 | Umleiter, Server für Rückverbindungen |

Tabelle 39: Dienste im SINET (Adressen aus den Dokumentationsbereichen nach RFC 5737)

> [!INFO] Warum 198.51.100.0/24 und 203.0.113.0/24?
> Diese Adressbereiche sind in RFC 5737 ausdrücklich **für Dokumentation und Beispiele** reserviert und werden im echten Internet nie geroutet. Sie wirken für Teilnehmer wie »öffentliche« Adressen, können aber niemals mit echten Systemen kollidieren.

## Zeit für alle: NTP in der Range

Ohne gemeinsame Zeit lassen sich Ereignisse verschiedener Systeme nicht zu einem Zeitstrahl verbinden, und Kerberos verweigert Anmeldungen bei mehr als fünf Minuten Abweichung. Die Range baut deshalb eine eigene, saubere Zeithierarchie auf:

| **Ebene** | **System** | **Bezieht Zeit von** | **Verteilt an** |
|---|---|---|---|
| **Quelle** | Firmen-NTP oder GPS-Empfänger im MGMT-Netz | – | range-01, ops-01 (Hosts) |
| **Betrieb** | iac-01 (chrony als Server, 10.99.0.30) | Hosts bzw. MGMT-Quelle | OPNsense, Betriebs-VMs |
| **Übungsnetz** | OPNsense rtr-01 | iac-01 über SVC | alle VLANs (jeweils .1-Adresse) |
| **Windows-Domäne** | dc01 (PDC-Emulator) | OPNsense | alle Domänenmitglieder (Windows-Zeitdienst) |
| **Linux-VMs** | chrony | OPNsense im eigenen VLAN | – |

Tabelle 40: Zeithierarchie der Range

Jede Stufe erhöht das Stratum um eins. Wichtig ist nicht die absolute Genauigkeit auf die Millisekunde, sondern dass **alle Systeme dieselbe Zeit** haben. Alle Protokolle werden zudem in UTC gespeichert und erst in der Anzeige in Ortszeit umgerechnet – so gibt es keine Verwirrung bei der Sommerzeitumstellung.
