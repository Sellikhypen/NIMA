---
id: wl-01
title: WLAN-Betrieb · Planung und Architektur
paths: wifi, specialist
order: 20
difficulty: medium
icon: wifi.router.fill
tags: wifi
summary: Abdeckung und Kapazität planen, Kanäle und Bänder, Controller- und Cloud-Architekturen, SSID-Konzept, Segmentierung und Sicherheitsanforderungen schon in der Planung.
---

## Abdeckung vs. Kapazität

Früher wurde auf **Abdeckung** geplant (überall Empfang). Heute entscheidet **Kapazität**: Wie viele Geräte mit welchem Durchsatz pro Raum? Hörsäle, Lager mit Scannern und Büros brauchen unterschiedliche Dichten.

| Kennwert | Richtwert für Büros |
|---|---|
| Signalstärke (RSSI) | ≥ −67 dBm für Sprache/Video |
| Signal-Rausch-Abstand (SNR) | ≥ 25 dB |
| Überlappung | ausreichend für Roaming, aber nicht zu viel Co-Channel-Interferenz |

## Bänder und Kanäle

| Band | Eigenschaft |
|---|---|
| 2,4 GHz | große Reichweite, nur 3 überlappungsfreie Kanäle (1, 6, 11), viele Störquellen |
| 5 GHz | viele Kanäle, DFS-Kanäle teils mit Radarerkennung |
| 6 GHz (Wi-Fi 6E/7) | viel Spektrum, **nur WPA3**, kürzere Reichweite |

## Architekturen

| Modell | Beschreibung |
|---|---|
| autonome APs | einzeln konfiguriert, nur sehr kleine Umgebungen |
| Controller-basiert | zentrale Steuerung, Tunnel zu Controller |
| Cloud-verwaltet | Verwaltung über Cloud-Portal |

## SSID-Konzept

So wenige SSIDs wie möglich (jede kostet Sendezeit durch Beacons), z. B.:

| SSID | Sicherheit | Netz |
|---|---|---|
| Firma | WPA3-Enterprise/802.1X, dynamische VLANs | intern |
| Gäste | Captive Portal/OWE, nur Internet | isoliert ([[mod:wl-03|Gästenetze]]) |
| IoT | WPA2/3-Personal mit PSK pro Gerätegruppe | eigenes Segment |

Sicherheitsgrundlagen: [[mod:w-03|WPA2/WPA3]].

## Quiz

? Welche drei Kanäle sind im 2,4-GHz-Band überlappungsfrei?
+ 1, 6 und 11
- 1, 2 und 3
- 5, 10 und 15
- 36, 40 und 44

? Welche Sicherheit ist im 6-GHz-Band Pflicht?
= WPA3

? Warum sollte man wenige SSIDs nutzen?
+ Jede SSID kostet Sendezeit durch Beacons
- SSIDs sind teuer
- mehr SSIDs sind sicherer
- Clients können nur eine sehen

? Welcher RSSI-Wert ist ein Richtwert für Sprache und Video?
= -67 dBm
= −67 dBm
= -67

@@@ MODULE @@@
---
id: wl-02
title: WLAN-Betrieb · Funkmessung und Spektrum
paths: wifi
order: 21
difficulty: medium
icon: waveform.path.ecg
tags: wifi
summary: Site Surveys (prädiktiv, passiv, aktiv), Spektrumanalyse, Störquellen, Kanal- und Sendeleistungsplanung und wie man Messergebnisse richtig interpretiert.
---

## Arten von Site Surveys

| Art | Vorgehen | Zweck |
|---|---|---|
| prädiktiv | Grundriss mit Wandmaterialien in Planungssoftware | Planung vor Installation |
| passiv | Begehung, Empfang aller APs messen | Abdeckung, Interferenz |
| aktiv | mit Verbindung, Durchsatz und Roaming messen | Leistung aus Nutzersicht |
| Validierung | nach Installation/Änderungen | Abnahme |

## Spektrumanalyse

Ein WLAN-Adapter sieht nur WLAN-Rahmen. Ein **Spektrumanalysator** sieht die gesamte Funkenergie – auch Mikrowellen, Bluetooth, Funkkameras, Störsender.

| Darstellung | zeigt |
|---|---|
| FFT | aktuelle Energie pro Frequenz |
| Wasserfall | Verlauf über die Zeit |
| Duty Cycle | wie lange ein Frequenzbereich belegt ist |

## Typische Probleme

| Problem | Ursache | Lösung |
|---|---|---|
| Co-Channel Interference | zu viele APs auf demselben Kanal hören sich | Sendeleistung senken, Kanäle verteilen, 20-MHz-Kanäle |
| Sticky Clients | Gerät bleibt an fernem AP | Minimum-RSSI, 802.11k/v/r |
| Hidden Node | Clients hören sich nicht gegenseitig | AP-Dichte, RTS/CTS |
| Fremdstörer | Nicht-WLAN-Geräte | Spektrumanalyse, Kanalwechsel, Störer entfernen |

## Messwerte interpretieren

dBm ist logarithmisch: −3 dB ≈ halbe Leistung, −10 dB = ein Zehntel. Die Messung hängt vom Messgerät ab – Smartphones haben oft schwächere Antennen als Laptops, deshalb mit dem schwächsten relevanten Client planen.

## Quiz

? Welche Survey-Art misst Durchsatz und Roaming mit Verbindung?
= aktiv
= aktiver Survey

? Was sieht ein Spektrumanalysator, was ein WLAN-Adapter nicht sieht?
+ Funkenergie von Nicht-WLAN-Geräten wie Mikrowellen
- nur SSIDs
- Passwörter
- IP-Adressen

? Wie viel Leistung bedeuten −3 dB ungefähr?
+ die Hälfte
- das Doppelte
- ein Zehntel
- gleich viel

? Welche Standards helfen gegen Sticky Clients?
= 802.11k/v/r
= 802.11r

@@@ MODULE @@@
---
id: wl-03
title: WLAN-Betrieb · Gästenetze und Captive Portals
paths: wifi, specialist
order: 22
difficulty: easy
icon: person.crop.circle.badge.questionmark
tags: wifi
summary: Isolation von Gästen, Client Isolation, Captive Portals und ihre Grenzen, OWE für verschlüsselte offene Netze, Bandbreitenbegrenzung und rechtliche Aspekte.
---

## Ziele eines Gästenetzes

1. Gäste erreichen das Internet, **nichts** Internes
2. Gäste sehen sich nicht gegenseitig
3. Missbrauch ist begrenzt und nachvollziehbar
4. Funkverkehr ist möglichst verschlüsselt

## Technische Bausteine

| Baustein | Funktion |
|---|---|
| eigenes VLAN/Tunnel | Trennung vom Firmennetz |
| Firewall-Regeln | nur Internet, DNS; interne Netze explizit blockieren |
| Client Isolation | keine Kommunikation zwischen Gästen |
| Bandbreitenlimits | Fairness, Missbrauchsbegrenzung |
| Inhaltsfilter (optional) | DNS-Filter gegen Malware-Domains |

## Captive Portals

Ein **Captive Portal** fängt die erste Webanfrage ab und zeigt Anmeldung oder Nutzungsbedingungen.

> [!WARNUNG] Captive Portal ist keine Verschlüsselung
> In einem offenen Netz mit Portal ist der Funkverkehr unverschlüsselt. Andere in Reichweite können unverschlüsselte Inhalte mitlesen. Abhilfe schafft **OWE**.

## OWE – Enhanced Open

**Opportunistic Wireless Encryption** (Wi-Fi CERTIFIED Enhanced Open) verschlüsselt offene Netze per Diffie-Hellman pro Client – ohne Passwort. Schützt gegen passives Mitlesen, nicht gegen gefälschte Access Points.

## Rechtliches (Deutschland)

Seit der Abschaffung der Störerhaftung für WLAN-Anbieter (TMG-Änderung 2017, heute DDG) haften Betreiber offener WLANs grundsätzlich nicht als Störer für Rechtsverletzungen der Nutzer. Datenschutz bei Portalen mit Registrierung beachten.

## Quiz

? Was verhindert Client Isolation?
+ Kommunikation zwischen Gästen im selben WLAN
- Internetzugang
- DNS
- Anmeldung am Portal

? Verschlüsselt ein Captive Portal den Funkverkehr?
+ Nein
- Ja, immer
- Ja, mit WPA3
- Nur bei HTTPS-Portalen

? Wofür steht OWE?
= Opportunistic Wireless Encryption

? Wogegen schützt OWE nicht?
+ gefälschte Access Points
- passives Mitlesen
- Mitlesen von Nachbarn
- unverschlüsselten Funkverkehr

@@@ MODULE @@@
---
id: wl-04
title: WLAN-Betrieb · Wireless IDS/IPS und Überwachung
paths: wifi, cdsa
order: 23
difficulty: medium
icon: antenna.radiowaves.left.and.right.circle.fill
tags: wifi
summary: Rogue APs und Evil Twins erkennen, Deauthentication-Angriffe und Protected Management Frames, WIDS/WIPS-Funktionen, Klassifizierung von Fremdgeräten und Reaktionsprozesse.
---

## Bedrohungen, die überwacht werden müssen

| Bedrohung | Beschreibung |
|---|---|
| Rogue AP | nicht genehmigter AP **im Firmennetz** (z. B. Mitarbeiter steckt eigenen Router an) |
| Evil Twin | fremder AP mit gleicher SSID, um Clients anzulocken ([[mod:w-05|Angriffe verstehen]]) |
| Deauthentication-Flut | gefälschte Abmelderahmen trennen Clients |
| Ad-hoc-/Hotspot-Netze | Firmengeräte bauen Brücken nach außen |
| Störsender | Funk wird unbrauchbar |

## Protected Management Frames

**802.11w / PMF** schützt Management-Rahmen wie Deauthentication kryptografisch. Bei WPA3 ist PMF Pflicht, bei WPA2 optional – wo möglich auf „required“ stellen.

## WIDS und WIPS

| Funktion | Beschreibung |
|---|---|
| WIDS | erkennt verdächtige Geräte und Rahmen |
| WIPS | kann zusätzlich eingreifen (z. B. Rogue-AP über Switchport sperren) |
| Sensoren | dedizierte Sensoren oder APs mit Scan-Funktion |
| Lokalisierung | Triangulation über mehrere APs |

## Klassifizierung

| Klasse | Behandlung |
|---|---|
| autorisiert | eigene APs |
| Nachbar | fremd, aber nicht im eigenen Netz – ignorieren |
| Rogue | im eigenen kabelgebundenen Netz erkannt – sofort handeln |
| Spoof | nutzt eigene SSID oder BSSID – Alarm |

> [!WARNUNG] Recht beachten
> Aktive Abwehr gegen fremde Netze (z. B. Clients von Nachbar-APs trennen) kann rechtswidrig sein und Funkregeln verletzen. Aktive Maßnahmen nur gegen eindeutig eigene Infrastruktur-Missbräuche und nach rechtlicher Klärung.

## Quiz

? Was ist ein Rogue AP?
+ ein nicht genehmigter Access Point im eigenen Firmennetz
- der Firmen-AP
- ein AP des Nachbarn
- ein Switch

? Welcher Standard schützt Management-Rahmen?
= 802.11w
= PMF

? Bei welchem Sicherheitsstandard ist PMF Pflicht?
= WPA3

? Was unterscheidet WIPS von WIDS?
+ WIPS kann zusätzlich eingreifen
- WIPS sieht weniger
- WIDS ist neuer
- kein Unterschied

?tf Aktive Abwehr gegen Nachbarnetze ist immer erlaubt.
= falsch
