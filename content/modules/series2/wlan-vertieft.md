---
id: wf-01
title: WLAN vertieft 1 · Funkphysik, dBm und Antennen
paths: wifi
order: 0.5
difficulty: easy
icon: antenna.radiowaves.left.and.right
tags: wlan, funk
summary: Wie sich Funkwellen ausbreiten, was dBm, RSSI und SNR bedeuten und warum Antennen und Hindernisse über Reichweite und Angriffsfläche entscheiden.
---

## Einfach erklärt

WLAN ist Radio. Ein Access Point „ruft“ in alle Richtungen, und je weiter man weg ist, desto leiser wird er. Wände, Wasser (auch Menschen!) und Metall dämpfen das Signal. Und: Funk hält sich nicht an Grundstücksgrenzen – wer auf dem Parkplatz steht, kann dein WLAN oft noch empfangen.

## Signalstärke in dBm

dBm ist ein logarithmisches Maß. Faustregeln:

| Wert | Bedeutung |
|---|---|
| −30 dBm | direkt neben dem AP |
| −50 dBm | sehr gut |
| −67 dBm | gut genug für Sprache/Video |
| −70 dBm | ok für Daten |
| −80 dBm | grenzwertig |
| −90 dBm | kaum nutzbar |

**+3 dB = doppelte Leistung, −3 dB = halbe Leistung.** −10 dB entspricht einem Zehntel.

- **RSSI** – vom Gerät gemessene Empfangsstärke.
- **Rauschen** (Noise Floor) – Grundrauschen, typisch um −90 bis −95 dBm.
- **SNR** – Abstand Signal zu Rauschen; mindestens ~25 dB für gute Datenraten.

## Antennen

| Typ | Abstrahlung | Einsatz |
|---|---|---|
| Rundstrahler (omnidirektional) | ringsum | Büro, Decke |
| Sektor/Patch | gerichtet, breit | Hallen, Flure |
| Yagi/Richtfunk | stark gebündelt, große Reichweite | Punkt-zu-Punkt – auch für Angreifer aus großer Entfernung |

> [!MERKE] Reichweite ist Angriffsfläche
> Mit Richtantennen lässt sich ein WLAN aus mehreren hundert Metern empfangen. Sicherheit darf nie auf „zu weit weg“ beruhen – nur auf Kryptografie.

## Tiefer eingetaucht

Frequenzen: 2,4 GHz reicht weiter und durchdringt Wände besser, hat aber nur drei überlappungsfreie Kanäle (1, 6, 11) und viele Störer. 5 GHz bietet mehr Kanäle und Bandbreite, geringere Reichweite. 6 GHz (Wi-Fi 6E/7) bringt viel neues Spektrum – und verlangt WPA3.

Weitere Effekte: **Mehrwegeausbreitung** (Reflexionen; MIMO nutzt sie sogar), **Fresnel-Zone** bei Richtfunk, **Sendeleistung** muss zum Client passen (ein laut sendender AP nützt nichts, wenn das Smartphone nicht zurückkommt). Eine gute Planung hält die Zellen klein, damit das Signal nicht unnötig weit nach draußen strahlt.

## Quiz

? Welcher dBm-Wert ist das stärkere Signal?
+ −50 dBm
- −70 dBm
- −85 dBm
- −95 dBm
! Näher an 0 ist stärker.

? Was bedeutet eine Änderung um +3 dB?
+ ungefähr doppelte Leistung
- dreifache Leistung
- halbe Leistung
- keine Änderung
! dB ist logarithmisch.

? Wofür steht SNR?
= Signal-to-Noise Ratio
= Signal-Rausch-Abstand
! Der Abstand zwischen Nutzsignal und Grundrauschen.

? Welche Kanäle überlappen im 2,4-GHz-Band nicht?
+ 1, 6 und 11
- 1, 2 und 3
- 3, 7 und 13
- alle Kanäle
! Die übrigen überlappen sich teilweise.

?tf Mit Richtantennen kann ein WLAN aus großer Entfernung empfangen werden.
= wahr
! Deshalb ist Kryptografie die einzige verlässliche Grenze.

? Welches Band verlangt grundsätzlich WPA3?
= 6 GHz
= 6
! Im 6-GHz-Band sind nur WPA3 und OWE vorgesehen.

@@@ MODULE @@@
---
id: wf-02
title: WLAN vertieft 2 · 802.11-Frames lesen
paths: wifi
order: 1.5
difficulty: medium
icon: rectangle.stack.fill
tags: wlan, 802.11, frames
summary: Management-, Control- und Data-Frames, Beacons, Probes, Association und Deauthentication – was im Funk passiert und was man in einem Mitschnitt sieht.
---

## Einfach erklärt

Im WLAN-Funk gibt es drei Sorten von Nachrichten:

- **Management-Frames** – Organisation: „Hier bin ich“ (Beacon), „Wer ist da?“ (Probe), „Darf ich rein?“ (Association).
- **Control-Frames** – Verkehrsregelung: „Ich will senden“ (RTS), „Leg los“ (CTS), „Angekommen“ (ACK).
- **Data-Frames** – die eigentlichen Daten (verschlüsselt).

## Verbindungsaufbau

1. **Beacon** – der AP kündigt SSID, Fähigkeiten und Sicherheitsmodus an (ca. 10× pro Sekunde).
2. **Probe Request/Response** – der Client fragt aktiv nach Netzen (ggf. nach bekannten SSIDs!).
3. **Authentication** – bei WPA2/WPA3-Personal nur formal (Open System) bzw. bei WPA3 der SAE-Austausch.
4. **Association** – Aufnahme ins Netz.
5. **4-Way-Handshake** – Schlüssel für die Sitzung werden abgeleitet.

## Interessante Felder

| Feld | Bedeutung |
|---|---|
| BSSID | MAC-Adresse des APs |
| SSID | Netzname |
| RSN-Element | Sicherheitsmodus (WPA2/WPA3, AKM, Cipher, PMF) |
| Kanal | Funkkanal |
| Reason Code | Grund bei Deauth/Disassoc |

> [!WARNUNG] Probe Requests verraten viel
> Clients, die aktiv nach bekannten SSIDs fragen, verraten, wo ihr Besitzer schon war („Hotel-XY-WLAN“). Moderne Betriebssysteme nutzen dafür zufällige MAC-Adressen.

## Tiefer eingetaucht

**Deauthentication**-Frames waren vor 802.11w unverschlüsselt und unauthentifiziert – jeder konnte Clients „rauswerfen“. Das wurde für DoS und zum Erzwingen erneuter Handshakes missbraucht. **PMF (802.11w)** schützt Management-Frames; bei WPA3 ist es Pflicht.

Mitschneiden erfordert eine WLAN-Karte im **Monitor-Modus** (alle Frames auf einem Kanal, nicht nur die eigenen). In Wireshark helfen Filter wie `wlan.fc.type_subtype == 0x08` (Beacons), `wlan.fc.type_subtype == 0x0c` (Deauth), `eapol` (Handshakes). Für die Überwachung eigener Netze erkennen **WIDS/WIPS** Auffälligkeiten wie Deauth-Fluten oder unbekannte APs mit bekannter SSID.

## Quiz

? Welcher Frame-Typ kündigt ein WLAN regelmäßig an?
= Beacon
! Beacons enthalten SSID, Fähigkeiten und Sicherheitsinformationen.

? Zu welcher Kategorie gehören Beacons und Probes?
+ Management-Frames
- Control-Frames
- Data-Frames
- Ethernet-Frames
! Control-Frames sind z. B. RTS, CTS, ACK.

? Was ist die BSSID?
+ die MAC-Adresse des Access Points
- der Name des WLANs
- das WLAN-Passwort
- die IP des Routers
! Die SSID ist der Name, die BSSID die Hardwareadresse.

?tf Vor 802.11w konnten Deauthentication-Frames von jedem gefälscht werden.
= wahr
! PMF schützt Management-Frames kryptografisch.

? In welchem Modus muss eine WLAN-Karte sein, um alle Frames eines Kanals mitzuschneiden?
= Monitor-Modus
= Monitor Mode
= Monitor
! Im normalen Modus sieht die Karte nur eigene Frames.

?order Bringe den Verbindungsaufbau in die richtige Reihenfolge.
> Beacon oder Probe
> Authentication
> Association
> 4-Way-Handshake
! Danach werden verschlüsselte Daten übertragen.

? Welcher Wireshark-Filter zeigt WPA-Handshake-Nachrichten?
= eapol
! EAP over LAN transportiert den 4-Way-Handshake.

@@@ MODULE @@@
---
id: wf-03
title: WLAN vertieft 3 · WPA3-SAE und PMF im Detail
paths: wifi, specialist
order: 2.5
difficulty: hard
icon: lock.shield.fill
tags: wlan, wpa3, sae
summary: Warum WPA3-Personal Offline-Angriffe auf das Passwort verhindert, was Forward Secrecy bringt, welche Übergangsmodi riskant sind und wie PMF wirkt.
---

## Einfach erklärt

Bei WPA2-Personal kann jemand, der einen Verbindungsaufbau mitschneidet, das WLAN-Passwort **zu Hause in Ruhe raten** – so oft er will. Bei WPA3-Personal geht das nicht mehr: Jeder Rateversuch erfordert einen echten Austausch mit dem Access Point. Das ist, als müsste man jeden Schlüssel einzeln an der echten Tür ausprobieren statt an einem Abdruck.

## SAE – Simultaneous Authentication of Equals

- Basiert auf dem **Dragonfly**-Schlüsselaustausch (passwortbasierte authentifizierte Schlüsselvereinbarung).
- Beide Seiten beweisen Kenntnis des Passworts, **ohne** dass ein Mitschnitt das Offline-Raten erlaubt.
- **Forward Secrecy**: Wer später das Passwort erfährt, kann alte Mitschnitte trotzdem nicht entschlüsseln.

## PMF – Protected Management Frames (802.11w)

| Modus | Wirkung |
|---|---|
| deaktiviert | Deauth-Spoofing möglich |
| optional (capable) | geschützt, wenn beide können |
| erforderlich (required) | nur Clients mit PMF; bei WPA3 Pflicht |

## Übergangsmodus

**WPA2/WPA3-Transition** erlaubt alte und neue Clients im selben Netz. Nachteil: Ein Angreifer kann Clients ggf. in WPA2 locken (Downgrade) und dann einen WPA2-Handshake angreifen. Wo möglich: reines WPA3 oder getrennte SSIDs.

> [!MERKE] Passwortqualität bleibt wichtig
> SAE verhindert Offline-Raten, aber nicht Online-Raten oder Weitergabe. Lange, zufällige Passphrasen bleiben Pflicht.

## Tiefer eingetaucht

Frühe Implementierungen hatten Schwächen (**Dragonblood**, 2019): Seitenkanäle bei der Passwortableitung und Downgrades. Gegenmittel sind aktuelle Firmware und die Methode **Hash-to-Element (H2E)**, die bei 6 GHz vorgeschrieben ist.

Für Unternehmen gibt es **WPA3-Enterprise** inklusive einer 192-Bit-Suite für besonders schutzbedürftige Umgebungen. Für offene Netze (Café, Gäste) bietet **OWE** (Opportunistic Wireless Encryption, „Enhanced Open“) Verschlüsselung ohne Passwort – schützt gegen passives Mitlesen, aber nicht gegen einen gefälschten AP.

## Quiz

? Welchen Angriff verhindert WPA3-SAE im Vergleich zu WPA2-PSK?
+ Offline-Raten des Passworts aus einem Mitschnitt
- Online-Raten am AP
- Störsender
- schwache Passwörter an sich
! Jeder Versuch braucht einen echten Austausch mit dem AP.

? Auf welchem Schlüsselaustausch basiert SAE?
= Dragonfly
! Eine passwortbasierte, authentifizierte Schlüsselvereinbarung.

? Was bedeutet Forward Secrecy?
+ ein später bekannt gewordenes Passwort entschlüsselt alte Mitschnitte nicht
- Passwörter laufen automatisch ab
- der AP sendet schneller
- Clients werden vorwärts sortiert
! Jede Sitzung hat unabhängige Schlüssel.

?tf Der WPA2/WPA3-Übergangsmodus kann Downgrade-Angriffe ermöglichen.
= wahr
! Clients lassen sich ggf. in den schwächeren Modus locken.

? Welcher Standard schützt Management-Frames?
= 802.11w
= PMF
! Protected Management Frames.

? Welche Methode der Passwortableitung ist bei 6 GHz vorgeschrieben?
= Hash-to-Element
= H2E
! Sie schließt Seitenkanäle älterer SAE-Implementierungen.

? Was bietet OWE in offenen Netzen?
+ Verschlüsselung ohne Passwort gegen passives Mitlesen
- Schutz vor gefälschten Access Points
- Anmeldung mit Benutzername
- ein Captive Portal
! OWE authentifiziert den AP nicht.

@@@ MODULE @@@
---
id: wf-04
title: WLAN vertieft 4 · Rogue APs und Evil Twins erkennen
paths: wifi, cdsa
order: 4.5
difficulty: medium
icon: wifi.exclamationmark
tags: wlan, erkennung, wids
summary: Wie gefälschte und nicht genehmigte Access Points funktionieren, woran man sie erkennt und wie WIDS/WIPS und 802.1X schützen.
---

## Einfach erklärt

Ein **Evil Twin** ist ein gefälschter Access Point mit demselben Namen wie das echte Netz – wie ein falscher Geldautomat, der echt aussieht. Geräte verbinden sich, weil sie den Namen kennen, und der Betreiber sitzt in der Mitte.

Ein **Rogue AP** ist ein nicht genehmigter Access Point im Firmennetz – oft gut gemeint („Ich hab mir einen kleinen Router ins Büro gestellt“), aber eine offene Hintertür am Netzwerkkabel.

## Abgrenzung

| Begriff | Was | Risiko |
|---|---|---|
| Rogue AP | unerlaubter AP, am Firmen-LAN angeschlossen | Umgehung von Firewall und NAC |
| Evil Twin | gefälschter AP mit bekannter SSID | Abfangen von Anmeldungen und Verkehr |
| Neighbor AP | fremder, harmloser AP (Nachbar) | keins, nur Störung |
| Karma/Mana-artige APs | antworten auf beliebige Probe Requests | Clients verbinden sich mit „bekannten“ Netzen |

## Erkennung

- **WIDS/WIPS**: Sensoren vergleichen gesehene APs mit der Liste genehmigter BSSIDs.
- Gleiche SSID, aber **unbekannte BSSID**, anderer Kanal oder andere Sicherheitseinstellungen (z. B. offen statt WPA2-Enterprise).
- **Wired-Side-Erkennung**: unbekannte MAC-Präfixe von Consumer-Routern am Switchport; NAC/802.1X am Kabel.
- Ungewöhnlich hohe Signalstärke eines „bekannten“ APs an einem Ort, wo er nicht steht.

> [!MERKE] 802.1X mit Zertifikatsprüfung ist der stärkste Schutz
> Prüft der Client das Server-Zertifikat des RADIUS-Servers streng, scheitert ein Evil Twin bei Enterprise-WLANs an der Anmeldung.

## Tiefer eingetaucht

Bei WPA2/3-Enterprise ist die häufigste Schwäche die **fehlende Zertifikatsprüfung** auf den Clients (z. B. „Zertifikat nicht überprüfen“ in der Konfiguration oder Nutzer, die Warnungen wegklicken). Dann kann ein Evil Twin die innere Anmeldung (bei PEAP-MSCHAPv2) abgreifen. Abhilfe: Profile zentral per MDM/GPO verteilen, CA und Servername fest vorgeben, EAP-TLS statt Passwörtern.

Für Personal-Netze hilft WPA3: Ohne Kenntnis des Passworts kann ein Evil Twin den SAE-Austausch nicht erfolgreich abschließen. Für Nutzer gilt: keine automatischen Verbindungen zu offenen Netzen, alte Netzprofile löschen.

## Quiz

? Was ist ein Evil Twin?
+ ein gefälschter Access Point mit derselben SSID wie ein echtes Netz
- ein doppelt verbauter Router
- ein WLAN mit zwei Passwörtern
- ein redundantes Rechenzentrum
! Clients verbinden sich, weil sie den Namen kennen.

? Was ist ein Rogue AP?
+ ein nicht genehmigter Access Point im Firmennetz
- ein AP des Nachbarn
- ein besonders schneller AP
- ein AP ohne Antenne
! Er umgeht oft Firewall und Netzzugangskontrolle.

? Welche Systeme erkennen nicht genehmigte Access Points im Funk?
= WIDS
= WIPS
= Wireless IDS
! Wireless Intrusion Detection/Prevention Systems.

?tf Bei WPA2-Enterprise schützt die strenge Prüfung des RADIUS-Server-Zertifikats vor Evil Twins.
= wahr
! Ohne passendes Zertifikat bricht der Client die Anmeldung ab.

? Was ist die häufigste Schwäche bei Enterprise-WLAN-Clients?
+ fehlende oder deaktivierte Zertifikatsprüfung
- zu lange Passwörter
- zu viele Access Points
- zu schnelles Roaming
! Profile sollten zentral mit fester CA und Servername verteilt werden.

? Welches EAP-Verfahren nutzt Zertifikate auf beiden Seiten statt Passwörtern?
= EAP-TLS
! Sehr robust gegen Evil Twins und Passwortdiebstahl.

@@@ MODULE @@@
---
id: wf-05
title: WLAN vertieft 5 · Kanalplanung und Wi-Fi 6/6E/7
paths: wifi, specialist
order: 20.5
difficulty: medium
icon: wifi
tags: wlan, planung, wifi6
summary: Wie man Kanäle und Sendeleistung plant, was OFDMA, BSS-Coloring, 6 GHz und Multi-Link Operation bringen und was das für Sicherheit bedeutet.
---

## Einfach erklärt

Viele WLANs auf demselben Kanal sind wie viele Leute, die in einem Raum gleichzeitig reden: Jeder muss warten, bis Ruhe ist. Gute **Kanalplanung** verteilt die Gespräche auf verschiedene Räume. Neue Standards (Wi-Fi 6, 6E, 7) helfen zusätzlich, mehr Gespräche gleichzeitig zu führen.

## Kanalplanung

- **2,4 GHz**: nur Kanäle 1, 6, 11 (20 MHz) – nie 40 MHz in dichten Umgebungen.
- **5 GHz**: viele Kanäle; DFS-Kanäle (Radar) beachten; Kanalbreite 20/40 MHz in dichten Büros, 80 MHz nur bei wenig Nachbarn.
- **6 GHz**: sehr viel Spektrum, kaum Altgeräte, nur WPA3/OWE.
- **Sendeleistung** passend zu Clients – lieber mehr APs mit geringerer Leistung als wenige laute.
- Regelmäßige **Site Surveys** (Planung, Validierung, Störungssuche).

## Standards im Überblick

| Generation | Standard | Neu (Auswahl) |
|---|---|---|
| Wi-Fi 4 | 802.11n | MIMO, 40 MHz |
| Wi-Fi 5 | 802.11ac | 5 GHz, MU-MIMO (Downlink), 80/160 MHz |
| Wi-Fi 6 | 802.11ax | OFDMA, BSS-Coloring, Target Wake Time |
| Wi-Fi 6E | 802.11ax | zusätzlich 6 GHz |
| Wi-Fi 7 | 802.11be | 320 MHz, 4096-QAM, Multi-Link Operation (MLO) |

> [!INFO] OFDMA
> Ein Kanal wird in kleine Ressourceneinheiten aufgeteilt, sodass mehrere Clients gleichzeitig kleine Datenmengen senden können – ideal für viele IoT-Geräte und Sprache.

## Tiefer eingetaucht

Sicherheitsaspekte neuer Standards:

- 6 GHz erzwingt **WPA3/OWE** und **PMF** – Altlasten-Modi entfallen.
- **MLO** (Wi-Fi 7) verbindet Clients über mehrere Bänder gleichzeitig; Sicherheitsparameter müssen auf allen Links konsistent sein.
- **Target Wake Time** spart Akku bei IoT – bedeutet aber auch: IoT-Geräte werden langlebige, schlecht gewartete Netzteilnehmer. Segmentierung ist Pflicht.
- Mehr Bandbreite heißt auch: Exfiltration oder Störungen fallen schneller ins Gewicht – Monitoring mitwachsen lassen.

Ein sauber geplantes WLAN ist leichter zu überwachen: Wer weiß, welche APs wo auf welchem Kanal senden sollen, erkennt Abweichungen (Rogue, Störer) sofort.

## Quiz

? Welche Kanalbreite sollte im 2,4-GHz-Band in dichten Umgebungen genutzt werden?
= 20 MHz
= 20
! 40 MHz würde zwei der drei überlappungsfreien Kanäle belegen.

? Welche Technik teilt einen Kanal in Ressourceneinheiten für mehrere Clients gleichzeitig?
= OFDMA
! Eingeführt mit Wi-Fi 6.

? Welche Wi-Fi-Generation führt Multi-Link Operation ein?
= Wi-Fi 7
= 802.11be
! MLO nutzt mehrere Bänder gleichzeitig.

?tf Im 6-GHz-Band ist WPA2-PSK erlaubt.
= falsch
! Nur WPA3 und OWE sind vorgesehen.

? Was müssen APs auf DFS-Kanälen beachten?
+ sie müssen bei erkanntem Radar den Kanal wechseln
- sie dürfen keine Verschlüsselung nutzen
- sie senden nur nachts
- sie brauchen eine Richtantenne
! Dynamic Frequency Selection schützt Radaranlagen.

? Was ist meist besser für Abdeckung und Kapazität?
+ mehr APs mit angepasster, geringerer Sendeleistung
- wenige APs mit maximaler Leistung
- alle APs auf demselben Kanal
- nur 2,4 GHz verwenden
! Kleinere Zellen verringern Konkurrenz und Abstrahlung nach außen.

@@@ MODULE @@@
---
id: wf-06
title: WLAN vertieft 6 · RADIUS und EAP-TLS betreiben
paths: wifi, specialist
order: 3.5
difficulty: hard
icon: server.rack
tags: wlan, 802.1x, radius, pki
summary: Wie ein RADIUS-Server Anmeldungen prüft, wie EAP-TLS mit Gerätezertifikaten aufgesetzt wird und welche Betriebsfehler Enterprise-WLANs schwächen.
---

## Einfach erklärt

Bei WPA2/3-Enterprise gibt es kein gemeinsames WLAN-Passwort. Jedes Gerät oder jeder Nutzer meldet sich einzeln an – geprüft von einem **RADIUS-Server** im Hintergrund. Der Access Point ist nur der Türsteher, der die Ausweise an die Zentrale weiterreicht.

## Rollen bei 802.1X

| Rolle | Wer |
|---|---|
| Supplicant | Client (Laptop, Smartphone) |
| Authenticator | Access Point bzw. Switch |
| Authentication Server | RADIUS-Server (z. B. NPS, FreeRADIUS, Cloud-RADIUS) |

## EAP-Verfahren im Vergleich

| Verfahren | Anmeldung mit | Bewertung |
|---|---|---|
| EAP-TLS | Client- und Serverzertifikat | sehr sicher, Aufwand für PKI |
| PEAP-MSCHAPv2 | Benutzername/Passwort im TLS-Tunnel | verbreitet; ohne Zertifikatsprüfung angreifbar |
| EAP-TTLS | flexibel, inneres Verfahren wählbar | abhängig vom inneren Verfahren |
| EAP-TEAP | moderner Tunnel, Maschine + Nutzer | gut, wachsende Unterstützung |

## EAP-TLS aufsetzen (Überblick)

1. **PKI**: Root-CA (offline) und ausstellende CA.
2. **Serverzertifikat** für den RADIUS-Server.
3. **Clientzertifikate** automatisch verteilen (AD-Autoenrollment, MDM per SCEP/PKCS).
4. **WLAN-Profil** zentral verteilen: SSID, EAP-TLS, vertrauenswürdige CA, erwarteter Servername.
5. **Richtlinien** im RADIUS: welche Zertifikate/Gruppen in welches VLAN (dynamische VLAN-Zuweisung).
6. **Widerruf**: CRL/OCSP prüfen, damit gestohlene Geräte ausgesperrt werden.

> [!WARNUNG] Häufige Betriebsfehler
> Abgelaufenes RADIUS-Zertifikat (plötzlich kann sich niemand verbinden), Clients ohne Servernamensprüfung, nicht geprüfte Sperrlisten, ein einziger RADIUS-Server ohne Redundanz.

## Tiefer eingetaucht

RADIUS selbst nutzt ein gemeinsames Geheimnis zwischen AP und Server und ältere Kryptografie (MD5-basiert) – die Verbindung AP↔RADIUS sollte in einem geschützten Management-Netz liegen oder über **RadSec** (RADIUS over TLS) laufen. Die 2024 bekannt gewordene „Blast-RADIUS“-Schwachstelle zeigte, warum: Ohne Message-Authenticator-Prüfung ließen sich Antworten fälschen.

Protokolle des RADIUS-Servers sind Gold für das SOC: Wer meldet sich wann, mit welchem Gerät, an welchem AP an? Fehlgeschlagene Anmeldungen mit unbekannten Zertifikaten können auf Angriffsversuche hindeuten.

## Quiz

? Welche Rolle übernimmt der Access Point bei 802.1X?
+ Authenticator
- Supplicant
- Authentication Server
- Certificate Authority
! Der AP leitet Anmeldungen an den RADIUS-Server weiter.

? Welches EAP-Verfahren gilt als besonders sicher?
= EAP-TLS
! Gegenseitige Zertifikatsauthentifizierung, keine Passwörter.

? Was passiert, wenn das RADIUS-Serverzertifikat abläuft?
+ Clients können sich nicht mehr anmelden
- nichts
- das WLAN wird automatisch offen
- alle Clients erhalten Admin-Rechte
! Ablaufdaten überwachen!

?tf Die Verbindung zwischen AP und RADIUS-Server sollte in einem geschützten Netz liegen oder per RadSec abgesichert sein.
= wahr
! RADIUS nutzt teils veraltete Kryptografie.

? Wie können Geräte im RADIUS je nach Zertifikat oder Gruppe in unterschiedliche Netze gelangen?
+ dynamische VLAN-Zuweisung
- MAC-Spoofing
- DHCP-Snooping
- Kanalwechsel
! Der RADIUS-Server liefert das VLAN als Attribut zurück.

? Wie wird ein gestohlenes Gerät mit Zertifikat ausgesperrt?
+ Zertifikat widerrufen und CRL/OCSP-Prüfung im RADIUS
- WLAN umbenennen
- Access Point neu starten
- Passwort des Nutzers ändern
! Ohne Widerrufsprüfung bleibt das Zertifikat gültig.

@@@ MODULE @@@
---
id: wf-07
title: WLAN vertieft 7 · IoT und Smart Devices im Funknetz
paths: wifi, specialist
order: 7.5
difficulty: medium
icon: lightbulb.led.fill
tags: iot, wlan, segmentierung
summary: Warum IoT-Geräte besondere Risiken tragen und wie man sie mit eigenen SSIDs, PSK pro Gerät, Segmentierung und Monitoring beherrscht.
---

## Einfach erklärt

Smarte Glühbirnen, Kameras, Drucker, Sensoren – kleine Computer, die selten Updates bekommen, oft unsichere Standards nutzen und jahrelang im Netz bleiben. Man kann sie nicht wie Laptops absichern. Man kann sie aber **einsperren**: eigenes Netz, nur die nötigen Verbindungen erlaubt.

## Typische Schwächen

- Standard- oder fest einprogrammierte Passwörter
- keine oder seltene Firmware-Updates, kurzer Supportzeitraum
- unverschlüsselte Protokolle (Telnet, HTTP, MQTT ohne TLS)
- kein 802.1X-Support, oft nur WPA2-Personal und 2,4 GHz
- Cloud-Abhängigkeit mit unklarem Datenschutz

## Schutzkonzept

| Maßnahme | Wirkung |
|---|---|
| eigene SSID/VLAN für IoT | Trennung von Arbeitsgeräten |
| **Private/Identity PSK** | eigenes Passwort pro Gerät oder Gerätegruppe – einzeln widerrufbar |
| Firewall-Regeln | nur benötigte Ziele (Hersteller-Cloud, Controller) |
| Client-Isolation | IoT-Geräte sehen sich nicht gegenseitig |
| Inventar | was ist wo, mit welcher Firmware |
| Monitoring | ungewöhnlicher Verkehr (Scans, neue Ziele) |
| Beschaffungsregeln | Updates, Support-Dauer, Sicherheitsmerkmale vertraglich |

> [!TIPP] Private PSK statt einem Passwort für alle
> Wird bei einem gemeinsamen Passwort ein Gerät kompromittiert oder ein Mitarbeiter verlässt die Firma, müsste man alle Geräte umkonfigurieren. Mit gerätebezogenen Schlüsseln widerruft man nur einen.

## Tiefer eingetaucht

Gesetzliche Entwicklung: Der **Cyber Resilience Act** der EU verpflichtet Hersteller vernetzter Produkte schrittweise zu Sicherheitsupdates, Schwachstellenmanagement und sicheren Standardeinstellungen; in Großbritannien gilt bereits ein Verbot von Standardpasswörtern (PSTI). Für Käufer bedeutet das künftig mehr Transparenz über Supportzeiträume.

In Unternehmen kommen **NAC**-Lösungen mit Profiling zum Einsatz: Sie erkennen Gerätetypen am Verhalten (DHCP-Fingerprint, Herstellerpräfix) und weisen sie automatisch dem passenden Segment zu. Matter/Thread im Smart Home bringen bessere Standards (lokale Steuerung, Zertifikate), lösen aber nicht das Update-Problem alter Geräte.

## Quiz

? Was ist ein wirksamer Grundschutz für IoT-Geräte im WLAN?
+ eigene SSID bzw. eigenes VLAN mit restriktiven Firewall-Regeln
- IoT-Geräte ins Admin-Netz stellen
- Updates deaktivieren
- das WLAN-Passwort auf das Gerät drucken
! Einsperren, wenn man nicht härten kann.

? Was ist der Vorteil von Private PSK (PSK pro Gerät)?
+ einzelne Geräte lassen sich widerrufen, ohne alle neu zu konfigurieren
- es braucht keine Verschlüsselung
- es ist schneller
- Geräte brauchen keine IP-Adresse
! Ein kompromittierter Schlüssel betrifft nur ein Gerät.

?tf Client-Isolation verhindert, dass IoT-Geräte im selben WLAN direkt miteinander kommunizieren.
= wahr
! Das erschwert die Ausbreitung von Schadsoftware.

? Welche EU-Verordnung verpflichtet Hersteller vernetzter Produkte zu Sicherheitsupdates?
= Cyber Resilience Act
= CRA
! Sie wird schrittweise verbindlich.

? Welche Lösung erkennt Gerätetypen automatisch und weist sie Netzsegmenten zu?
= NAC
= Network Access Control
! Profiling anhand von Verhalten und Fingerprints.

? Welche Schwächen sind bei IoT-Geräten typisch?
+ Standardpasswörter
+ seltene Updates
+ unverschlüsselte Protokolle
- zu starke Verschlüsselung
! Deshalb ist Segmentierung so wichtig.

@@@ MODULE @@@
---
id: wf-08
title: WLAN vertieft 8 · Bluetooth Low Energy, Zigbee, LoRa und NFC
paths: wifi
order: 6.5
difficulty: medium
icon: dot.radiowaves.left.and.right
tags: funk, bluetooth, iot
summary: Die wichtigsten Nahfunk- und IoT-Funktechniken, ihre Sicherheitsmechanismen und typischen Schwächen – vom Fitnessarmband bis zum Smart Meter.
---

## Einfach erklärt

Neben WLAN funken viele weitere Techniken um uns herum: Kopfhörer und Uhren (Bluetooth), Lichtschalter und Sensoren (Zigbee, Z-Wave, Thread), Zähler und Umweltsensoren über Kilometer (LoRaWAN), Bezahlkarten (NFC). Jede hat eigene Sicherheitsmechanismen – und eigene Schwächen.

## Überblick

| Technik | Reichweite | Typisch für | Sicherheitsthemen |
|---|---|---|---|
| Bluetooth Classic | ~10 m | Audio | Pairing-Verfahren, alte Stacks |
| Bluetooth Low Energy | ~10–100 m | Wearables, Tracker, Beacons | Pairing ohne Schutz („Just Works“), Tracking |
| Zigbee / Thread | Mesh im Haus | Smart Home | Netzwerkschlüssel bei Einbindung, Updates |
| Z-Wave | Mesh im Haus | Smart Home | S2-Security vs. alte Geräte |
| LoRaWAN | km | Sensorik, Zähler | Schlüsselverwaltung, Replay |
| NFC/RFID | cm | Bezahlen, Zutritt | Relay, Klonen alter Karten |

## BLE-Pairing-Verfahren

| Verfahren | Schutz gegen Man-in-the-Middle |
|---|---|
| Just Works | nein |
| Passkey Entry | ja |
| Numeric Comparison | ja |
| Out of Band (z. B. NFC) | ja |

**LE Secure Connections** (ECDH) sollte genutzt werden; Legacy Pairing ist abhörbar.

> [!WARNUNG] Zutrittskarten
> Viele ältere 125-kHz-Karten haben keinerlei Kryptografie und lassen sich in Sekunden kopieren. Moderne Systeme nutzen kryptografisch gesicherte Karten (z. B. mit AES).

## Tiefer eingetaucht

Bekannte Schwachstellenklassen: Fehler in Bluetooth-Stacks (z. B. BlueBorne, 2017), Downgrade der Schlüssellänge (KNOB), Tracking über BLE-Adressen (deshalb rotierende, zufällige Adressen), Relay-Angriffe auf schlüssellose Autos und NFC-Zahlungen (Distance Bounding als Gegenmittel).

Für Unternehmen relevant: Bluetooth auf verwalteten Geräten per MDM einschränken, Beacons und Funk-Sensoren inventarisieren, physische Zutrittssysteme auf moderne Kartentechnik migrieren. Für Forensik und Tests braucht man passende Hardware (SDR, BLE-Sniffer) – und wie immer eine Erlaubnis.

## Quiz

? Welches BLE-Pairing-Verfahren bietet keinen Schutz gegen Man-in-the-Middle?
= Just Works
! Es gibt keinen Vergleich oder Code zur Bestätigung.

? Welche Funktechnik erreicht typischerweise Kilometer bei geringer Datenrate?
= LoRaWAN
= LoRa
! Ideal für Sensoren mit langer Batterielaufzeit.

? Welche Technik wird für kontaktloses Bezahlen genutzt?
= NFC
! Near Field Communication, Reichweite wenige Zentimeter.

?tf Viele ältere 125-kHz-Zutrittskarten lassen sich leicht kopieren.
= wahr
! Sie haben meist keine kryptografische Absicherung.

? Welche Bluetooth-Funktion sollte statt Legacy Pairing genutzt werden?
= LE Secure Connections
! Basierend auf ECDH-Schlüsselaustausch.

? Was schützt gegen Tracking über Bluetooth-Adressen?
+ rotierende zufällige Adressen
- feste MAC-Adressen
- höhere Sendeleistung
- längere Gerätenamen
! Private Resolvable Addresses wechseln regelmäßig.

@@@ MODULE @@@
---
id: wf-09
title: WLAN vertieft 9 · Ein WLAN-Sicherheitsaudit durchführen
paths: wifi, specialist
order: 5.5
difficulty: hard
icon: checklist
tags: wlan, audit, methodik
summary: Vom Auftrag bis zum Bericht – wie ein WLAN-Audit strukturiert wird, welche Prüfpunkte es gibt und welche Werkzeuge in welcher Phase helfen.
---

## Einfach erklärt

Ein WLAN-Audit prüft nicht nur das Passwort, sondern das ganze System: Planung, Konfiguration, Clients, Infrastruktur, Überwachung und die physische Umgebung. Wie bei jedem Test gilt zuerst: **schriftlicher Auftrag**, klarer Scope und Rücksicht auf den Betrieb (Störungen vermeiden).

## Phasen

1. **Vorbereitung**: Scope (Standorte, SSIDs, Zeiten), Unterlagen (Planung, Controller-Konfiguration), Erlaubnis, Hardware (Adapter mit Monitor-Modus, ggf. Richtantenne).
2. **Passive Erfassung**: SSIDs, BSSIDs, Kanäle, Sicherheitsmodi, PMF, Clients, Abstrahlung nach außen.
3. **Konfigurationsprüfung**: WPA-Modus, Übergangsmodi, WPS, Management-Zugriff, Firmware, Gastnetz-Trennung.
4. **Client-Prüfung**: Profile, Zertifikatsprüfung bei Enterprise, automatische Verbindungen.
5. **Segmentierung**: Was erreicht man aus Gast-/IoT-Netz? (Firewall-Regeln testen)
6. **Erkennung**: Löst ein simulierter Rogue AP einen WIDS-Alarm aus?
7. **Bericht**: Funde, Risiken, Empfehlungen, Karte der Abstrahlung.

## Prüfpunkte (Auszug)

| Bereich | Prüfpunkt |
|---|---|
| Verschlüsselung | WPA3 bzw. WPA2-AES, kein TKIP/WEP, PMF aktiv |
| Personal-Netze | Passphrase lang und zufällig, Rotation bei Personalwechsel |
| Enterprise | EAP-TLS bzw. Zertifikatsprüfung erzwungen |
| WPS | deaktiviert |
| Gastnetz | Client-Isolation, kein Zugriff auf internes Netz |
| Management | Controller/AP-Verwaltung nicht aus Nutzer-/Gastnetzen erreichbar |
| Firmware | aktuell, Support-Ende bekannt |
| Abstrahlung | Signal außerhalb des Gebäudes minimiert |
| Monitoring | WIDS aktiv, Alarme werden bearbeitet |

> [!MERKE] Keine Störungen im Produktivbetrieb
> Aktive Tests (z. B. Deauth zur Prüfung von PMF) nur nach Absprache, in Wartungsfenstern und so begrenzt wie möglich.

## Tiefer eingetaucht

Werkzeuge: Site-Survey-Software (Planung und Heatmaps), Wireshark mit Monitor-Modus, die aircrack-ng-Suite zur Erfassung und Analyse, Kismet als passiver Sensor, hcxdumptool/hcxtools für die Analyse von Handshake-Material zur Prüfung der Passphrase-Stärke im Labor. Ergebnisse werden wie im Pentest bewertet – mit Nachweis, Risiko und konkreter Empfehlung.

## Quiz

? Was steht vor jedem WLAN-Audit?
+ ein schriftlicher Auftrag mit klarem Scope
- ein Deauth-Angriff auf alle Clients
- das Abschalten des Controllers
- der Kauf neuer Access Points
! Auch Funktests brauchen Erlaubnis.

? Was wird bei der passiven Erfassung ermittelt?
+ SSIDs, BSSIDs, Kanäle und Sicherheitsmodi
- die Passwörter aller Nutzer
- die Firewall-Konfiguration
- die Gehälter der Mitarbeiter
! Passiv heißt: nur zuhören.

?tf Aktive Tests wie Deauthentication sollten nur nach Absprache und begrenzt erfolgen.
= wahr
! Sie stören den Betrieb.

? Welches Werkzeug eignet sich als passiver WLAN-Sensor?
= Kismet
! Kismet erkennt Netze, Clients und Auffälligkeiten.

? Was sollte aus dem Gastnetz nicht erreichbar sein?
+ das interne Netz und die WLAN-Verwaltung
- das Internet
- der DHCP-Server des Gastnetzes
- der DNS-Resolver des Gastnetzes
! Segmentierung wird im Audit aktiv geprüft.

? Wie prüft man, ob die Erkennung funktioniert?
+ einen Rogue AP simulieren und prüfen, ob ein WIDS-Alarm entsteht
- das WLAN umbenennen
- alle APs neu starten
- die Kanäle wechseln
! Ein Audit prüft auch Detektion und Reaktion.
