---
id: d-05
title: Netzwerkverkehrsanalyse, Zeek und Suricata
paths: cdsa
order: 5
difficulty: medium
icon: waveform.path.ecg
summary: Mitschnitte mit tcpdump und Wireshark lesen, Filter, Flow-Daten, Zeek-Logs, Suricata-Regeln, IDS vs. IPS und typische Auffälligkeiten im Verkehr.
htb: Intro to Network Traffic Analysis
---

## Warum Netzwerkanalyse?

Endpunkte lassen sich manipulieren, das Netzwerk lügt seltener. Jeder Angriff, der über das Netz kommuniziert, hinterlässt dort Spuren – Verbindungsaufbau, DNS-Abfragen, Datenmengen, Zeitmuster.

## Datenarten

| Art | Inhalt | Speicherbedarf |
|---|---|---|
| Full Packet Capture (PCAP) | jedes Byte | sehr hoch |
| Flow-Daten (NetFlow/IPFIX) | wer mit wem, wann, wie viel | gering |
| Protokoll-Logs ([[Zeek]]) | strukturierte Metadaten pro Protokoll | mittel |
| IDS-Alarme ([[Suricata]]) | Regel-Treffer | gering |

## tcpdump und Wireshark

```bash
sudo tcpdump -i eth0 -n host 10.10.20.10 and port 443 -w web.pcap
sudo tcpdump -r web.pcap -nn 'tcp[tcpflags] & tcp-syn != 0'
```

**Wireshark**-Anzeigefilter (Display Filter):

| Filter | Zeigt |
|---|---|
| `ip.addr == 10.0.0.5` | Verkehr von/zu einer IP |
| `tcp.port == 445` | SMB |
| `dns.qry.name contains "example"` | bestimmte DNS-Abfragen |
| `http.request.method == "POST"` | HTTP-POST-Anfragen |
| `tcp.flags.syn == 1 && tcp.flags.ack == 0` | Verbindungsversuche |
| `tls.handshake.type == 1` | TLS Client Hello |
| `!(arp or dns or icmp)` | Rauschen ausblenden |

> [!TIPP] Statistik-Menüs nutzen
> *Statistics → Conversations*, *Protocol Hierarchy* und *Endpoints* zeigen in Sekunden, wer am meisten spricht und welche Protokolle vorkommen. *Follow TCP Stream* rekonstruiert eine Unterhaltung.

## Zeek

[[Zeek]] wandelt Verkehr in übersichtliche Logs:

| Log | Inhalt |
|---|---|
| `conn.log` | jede Verbindung mit Dauer, Bytes, Zustand |
| `dns.log` | Abfragen und Antworten |
| `http.log` | Methoden, Hosts, URIs, User-Agents |
| `ssl.log` | TLS-Versionen, Servernamen (SNI), Zertifikate |
| `files.log` | übertragene Dateien mit Hashes |
| `notice.log` | Hinweise auf Auffälligkeiten |
| `x509.log` | Zertifikatsdetails |

## Suricata und Signaturen

[[Suricata]] ist ein IDS/IPS. Regeln haben die Form *Aktion – Header – Optionen*:

```text
alert http $HOME_NET any -> $EXTERNAL_NET any (msg:"Verdächtiger User-Agent"; http.user_agent; content:"curl"; nocase; sid:1000001; rev:1;)
```

| | IDS | IPS |
|---|---|---|
| Position | passiv, an einem Spiegelport/TAP | inline im Verkehrsweg |
| Reaktion | alarmiert | blockiert zusätzlich |
| Risiko | verpasst nichts am Verkehr | Fehlalarme blockieren legitimen Verkehr |

> [!INFO] Signatur vs. Anomalie
> Signaturbasierte Erkennung findet Bekanntes zuverlässig, aber nichts Neues. Anomalieerkennung findet Ungewöhnliches, produziert aber mehr Fehlalarme. Gute Teams kombinieren beides.

## Auffälligkeiten im Verkehr

- Verbindungen zu seltenen Ländern oder frisch registrierten Domains
- sehr lange oder zufällig wirkende Subdomains (DNS-Tunneling, DGA)
- große ausgehende Datenmengen außerhalb der Geschäftszeiten
- Klartextprotokolle (FTP, Telnet, HTTP-Basic-Auth) im internen Netz
- interne Hosts, die viele andere interne Hosts auf denselben Port ansprechen (Scan oder Wurm)
- ungewöhnliche TLS-Fingerprints (JA3/JA4) oder selbstsignierte Zertifikate

## Quiz

? Welcher Wireshark-Filter zeigt nur SMB-Verkehr über Port 445?
= tcp.port == 445
= tcp.port==445

? Welches Zeek-Log enthält jede Verbindung mit Dauer und Bytes?
= conn.log

? Welches Zeek-Log zeigt TLS-Servernamen und Zertifikate?
= ssl.log

? Was unterscheidet ein IPS von einem IDS?
+ Ein IPS steht inline und kann blockieren
- Ein IPS speichert alle Pakete
- Ein IPS ist immer signaturfrei
- Es gibt keinen Unterschied

? Welche Datenart enthält jedes übertragene Byte?
+ Full Packet Capture
- NetFlow
- conn.log
- IDS-Alarme

? Was deuten sehr lange, zufällig wirkende Subdomains an?
+ DNS-Tunneling oder DGA-Schadsoftware
- normale Webnutzung
- einen DHCP-Fehler
- ein abgelaufenes Zertifikat

? Wie heißt die Wireshark-Funktion, die eine TCP-Unterhaltung rekonstruiert?
= Follow TCP Stream
