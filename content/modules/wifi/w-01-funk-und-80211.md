---
id: w-01
title: Funkgrundlagen und IEEE 802.11
paths: wifi
order: 1
difficulty: easy
icon: antenna.radiowaves.left.and.right
summary: Frequenzbänder, Kanäle, Wi-Fi-Generationen, SSID und BSSID, Frame-Typen, Beacons, Probe Requests und der Verbindungsablauf eines WLAN-Clients.
---

## Warum WLAN besonders ist

Kabel enden an der Wand, Funk nicht. Ein WLAN reicht oft über Gebäudegrenzen hinaus, und jeder in Reichweite kann die Signale empfangen. Deshalb hängt die Sicherheit eines WLANs fast vollständig an Verschlüsselung und Authentifizierung – und an ihrer korrekten Konfiguration.

## Frequenzbänder und Kanäle

| Band | Eigenschaften | Kanäle (EU) |
|---|---|---|
| 2,4 GHz | große Reichweite, gute Durchdringung, wenig Kanäle, viele Störungen (Bluetooth, Mikrowelle) | 1–13, überlappungsfrei nur 1, 5, 9, 13 bzw. 1, 6, 11 |
| 5 GHz | mehr Kanäle, höhere Datenraten, geringere Reichweite; teils DFS (Radar-Erkennung) | 36–140 |
| 6 GHz | Wi-Fi 6E/7, sehr viele Kanäle, nur WPA3 erlaubt | 1–233 |

## Wi-Fi-Generationen

| Name | Standard | Jahr | Besonderheit |
|---|---|---|---|
| Wi-Fi 4 | 802.11n | 2009 | MIMO, 2,4/5 GHz |
| Wi-Fi 5 | 802.11ac | 2013 | 5 GHz, breite Kanäle |
| Wi-Fi 6 / 6E | 802.11ax | 2019/2021 | OFDMA, 6 GHz (6E) |
| Wi-Fi 7 | 802.11be | 2024 | Multi-Link Operation, 320-MHz-Kanäle |

## Begriffe

| Begriff | Bedeutung |
|---|---|
| [[SSID]] | Name des Netzes |
| BSSID | MAC-Adresse eines Access Points (einer Funkzelle) |
| ESS | mehrere APs mit derselben SSID (Roaming) |
| Station (STA) | ein Client |
| Access Point (AP) | Basisstation |
| Monitor Mode | Funkkarte empfängt alle Frames auf einem Kanal, nicht nur eigene |
| RSSI | Signalstärke |

## Frame-Typen

802.11 kennt drei Arten von Frames:

| Typ | Beispiele | Zweck |
|---|---|---|
| Management | Beacon, Probe Request/Response, Authentication, Association, Deauthentication | Netz finden und verwalten |
| Control | RTS, CTS, ACK | Zugriff auf das Medium |
| Data | Nutzdaten | eigentliche Kommunikation |

> [!INFO] Beacons und Probe Requests
> APs senden mehrmals pro Sekunde **Beacons** mit SSID, unterstützten Raten und Sicherheitsfähigkeiten. Clients senden **Probe Requests**, um Netze zu finden – ältere Geräte nannten dabei die Namen aller gespeicherten Netze und verrieten so, wo ihr Besitzer schon war. Moderne Betriebssysteme reduzieren das und nutzen zufällige MAC-Adressen.

## Ablauf einer Verbindung

1. **Scannen** – passiv (Beacons hören) oder aktiv (Probe Requests)
2. **Authentication** – bei modernen Verfahren nur ein formaler Schritt (Open System) bzw. SAE bei WPA3
3. **Association** – Client meldet sich beim AP an
4. **Schlüsselaushandlung** – bei WPA2/WPA3 der **4-Way-Handshake** (siehe [[mod:w-02|Verschlüsselung]])
5. **Datenverkehr**, verschlüsselt mit dem ausgehandelten Schlüssel

> [!WARNUNG] Management-Frames waren ungeschützt
> Bis zur Einführung von **Protected Management Frames (PMF, 802.11w)** konnte jeder gefälschte Management-Frames senden – etwa Abmeldungen. PMF ist bei WPA3 Pflicht und sollte auch bei WPA2 aktiviert werden, wo die Geräte es unterstützen.

## Quiz

? Welche Kanäle sind im 2,4-GHz-Band in Europa überlappungsfrei (klassische Empfehlung)?
+ 1, 6, 11
- 1, 2, 3
- 36, 40, 44
- 2, 7, 12

? Was ist die BSSID?
+ die MAC-Adresse eines Access Points
- der Name des Netzes
- das WLAN-Passwort
- die Kanalnummer

? Welcher Frame-Typ dient dazu, Netze zu finden und zu verwalten?
= Management
= Management-Frames

? Wie heißen die Frames, die ein AP regelmäßig mit seiner SSID aussendet?
= Beacon
= Beacons

? Welcher Standard schützt Management-Frames?
= 802.11w
= PMF

? Welcher Wi-Fi-Name gehört zu 802.11ax?
= Wi-Fi 6

?tf Im 6-GHz-Band ist WPA3 Pflicht.
= wahr

? Welcher Kartenmodus empfängt alle Frames eines Kanals?
= Monitor Mode
= Monitor
