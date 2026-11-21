---
id: w-06
title: Bluetooth, RFID und IoT-Funk
paths: wifi
order: 6
difficulty: medium
icon: dot.radiowaves.left.and.right
summary: Bluetooth Classic und BLE, Pairing-Verfahren, typische Schwachstellenklassen, RFID/NFC bei Zutrittskarten sowie Zigbee und LoRaWAN im IoT – mit Schutzmaßnahmen.
---

## Bluetooth

| Variante | Einsatz | Besonderheit |
|---|---|---|
| Bluetooth Classic (BR/EDR) | Audio, Dateiübertragung | höhere Datenrate |
| Bluetooth Low Energy (BLE) | Wearables, Sensoren, Beacons, Smart Home | sehr sparsam, Daten in „Services“ und „Characteristics“ (GATT) |

### Pairing

| Verfahren | Schutz gegen Mitlauschen beim Pairing |
|---|---|
| Just Works | kein Schutz gegen Man-in-the-Middle |
| Passkey Entry | gut, wenn die Nummer nicht erraten werden kann |
| Numeric Comparison | gut – beide Geräte zeigen denselben Code |
| Out of Band (z. B. NFC) | gut |

> [!WARNUNG] Schwachstellenklassen
> Bekannte Lückenserien wie **BlueBorne** (2017) oder **KNOB** (2019, Aushandlung zu kurzer Schlüssel) betrafen die Implementierungen in Betriebssystemen und Chips. Schutz bieten vor allem **Updates**, das Abschalten von Bluetooth, wenn es nicht gebraucht wird, und das Vermeiden von „Just Works“ bei sensiblen Geräten.

## RFID und NFC

| Technik | Frequenz | Reichweite | Beispiele |
|---|---|---|---|
| LF-RFID | 125 kHz | wenige cm | ältere Zutrittskarten (oft ohne Kryptografie) |
| HF-RFID / NFC | 13,56 MHz | wenige cm | MIFARE, Bezahlkarten, Ausweise |
| UHF-RFID | 860–960 MHz | Meter | Logistik |

> [!GEFAHR] Alte Zutrittskarten
> Viele 125-kHz-Karten senden nur eine feste Nummer ohne Verschlüsselung und lassen sich deshalb kopieren. Auch die ältere MIFARE-Classic-Familie gilt als gebrochen. Empfehlung für Zutrittssysteme: moderne Karten mit starker Kryptografie (z. B. MIFARE DESFire EV2/EV3), ergänzt um PIN oder Biometrie für sensible Bereiche.

## IoT-Funkprotokolle

| Protokoll | Einsatz | Sicherheitsaspekte |
|---|---|---|
| Zigbee | Smart Home, Gebäudeautomation | Netzwerkschlüssel-Verteilung beim Anlernen ist ein kritischer Moment |
| Z-Wave | Smart Home | ältere Geräte ohne S2-Sicherheit |
| LoRaWAN | Sensoren über Kilometer | Schlüsselverwaltung, Join-Verfahren |
| Thread / Matter | neuer Smart-Home-Standard | moderne Kryptografie, zertifikatsbasiert |

## Schutzmaßnahmen für IoT

- eigenes Netzsegment (VLAN/SSID) ohne Zugriff auf das interne Netz
- Standardpasswörter ändern, Firmware-Updates
- nur Geräte mit Update-Zusage des Herstellers kaufen (Cyber Resilience Act)
- Funkmodule abschalten, die nicht gebraucht werden
- Inventar aller Funkgeräte führen

## Quiz

? Welche Bluetooth-Variante nutzt GATT mit Services und Characteristics?
= BLE
= Bluetooth Low Energy

? Welches Pairing-Verfahren bietet keinen Schutz gegen Man-in-the-Middle?
= Just Works

? Auf welcher Frequenz arbeitet NFC?
= 13,56 MHz
= 13.56 MHz
= 13,56

? Warum sind viele 125-kHz-Zutrittskarten unsicher?
+ Sie senden eine feste Nummer ohne Verschlüsselung
- Sie haben eine zu große Reichweite
- Sie benötigen WLAN
- Sie sind zu teuer

? Wie hieß die Lückenserie von 2019, bei der zu kurze Bluetooth-Schlüssel ausgehandelt wurden?
= KNOB

? Welche Maßnahme ist für IoT-Geräte im Unternehmen am wichtigsten?
+ eigenes Netzsegment ohne Zugriff auf das interne Netz
- maximale Sendeleistung
- WPS aktivieren
- Geräte ohne Updates kaufen
