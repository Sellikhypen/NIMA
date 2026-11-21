---
id: w-04
title: WLAN-Bedrohungen erkennen und abwehren
paths: wifi
order: 4
difficulty: medium
icon: exclamationmark.shield
summary: Rogue Access Points, Evil Twins, Abmelde-Störungen, Jamming, unsichere Gastnetze und Client-Risiken – wie sie funktionieren, woran man sie erkennt und wie ein Wireless-IDS hilft.
---

> [!INFO] Ausrichtung dieses Moduls
> Hier geht es darum, Bedrohungsklassen zu verstehen, um sie zu erkennen, zu bewerten und zu verhindern. Praktische Prüfungen von Funknetzen sind nur mit schriftlicher Beauftragung erlaubt – siehe [[mod:w-05|Prüfmethodik]].

## Rogue Access Points

Ein **Rogue AP** ist ein nicht genehmigter Access Point im Unternehmensnetz – oft gut gemeint (ein Mitarbeiter bringt einen eigenen Router mit), aber ein Loch an der Firewall vorbei.

**Erkennung:** Abgleich der gesehenen BSSIDs mit dem Inventar, Switch-Port-Überwachung (unbekannte MAC-Adressen), 802.1X auf allen kabelgebundenen Ports, Wireless-IDS.

## Evil Twin

Ein **[[Evil Twin]]** ist ein fremder AP, der dieselbe SSID wie ein legitimes Netz ausstrahlt, um Clients anzulocken – häufig mit gefälschten Anmeldeseiten („Captive Portal“) in öffentlichen oder Gastnetzen oder gegen Enterprise-Netze mit unsauberer Zertifikatsprüfung (siehe [[mod:w-03|802.1X]]).

| Schutz | Wirkung |
|---|---|
| WPA3 / PMF | erschwert das Abwerben verbundener Clients |
| strikte Zertifikatsprüfung (Enterprise) | Clients verbinden sich nicht mit fremden Servern |
| keine automatische Verbindung zu offenen Netzen | weniger Angriffsfläche unterwegs |
| VPN / durchgängiges TLS | mitgeschnittener Verkehr bleibt geschützt |
| WIDS | erkennt doppelte SSIDs mit fremden BSSIDs |

## Abmelde-Störungen (Deauthentication)

Ohne PMF lassen sich gefälschte Deauthentication-Frames senden, die Clients vom Netz trennen. Das wird als Störung (Denial of Service) und als Hilfsmittel für andere Angriffe missbraucht.

**Erkennung:** auffällige Häufung von Deauth-/Disassoc-Frames im WIDS. **Abhilfe:** PMF (802.11w) bzw. WPA3.

## Jamming

Gezieltes Stören der Frequenz durch starke Funksignale. Dagegen helfen nur physikalische Mittel und Redundanz (kabelgebundene Alternativen für kritische Systeme). Störsender sind in Deutschland verboten.

## Risiken auf Client-Seite

- automatische Verbindung zu bekannten offenen SSIDs („Hotel-WLAN“, „Free WiFi“)
- veraltete WLAN-Treiber und Firmware
- gespeicherte Unternehmensprofile ohne Zertifikats-Pinning
- Hotspot-Funktion des Smartphones am Firmenlaptop (Umgehung der Netzkontrollen)

## Wireless Intrusion Detection

Ein **WIDS/WIPS** besteht aus Sensoren (oft in den APs integriert), die Funkverkehr auswerten:

| Erkennt | Beispiel |
|---|---|
| unbekannte APs | Rogue AP, Evil Twin |
| Protokollanomalien | Deauth-Fluten, auffällige Probe-Muster |
| Fehlkonfigurationen | offene SSIDs, WEP, WPS aktiv |
| Ortung | Position eines Störers per Signalstärke |

> [!TIPP] Regelmäßige Funk-Surveys
> Ein Funk-Survey (Begehung mit Messgerät oder App) zeigt Ausleuchtung, Störquellen, fremde Netze und Reichweite über die Gebäudegrenze hinaus. Er ist Grundlage jeder WLAN-Planung und -Prüfung.

## Quiz

? Was ist ein Rogue Access Point?
+ ein nicht genehmigter AP im Unternehmensnetz
- ein AP mit WPA3
- ein besonders schneller AP
- ein Gast-WLAN

? Wie nennt man einen fremden AP, der die SSID eines legitimen Netzes imitiert?
= Evil Twin

? Welche Maßnahme macht gefälschte Abmelde-Frames wirkungslos?
= PMF
= 802.11w
= Protected Management Frames

? Wofür steht WIDS?
= Wireless Intrusion Detection System

? Welche Maßnahmen schützen Clients vor Evil Twins?
+ strikte Zertifikatsprüfung bei Enterprise-WLAN
+ keine automatische Verbindung zu offenen Netzen
- längere SSID
- WPS aktivieren

?tf Störsender (Jammer) dürfen in Deutschland zu Testzwecken frei betrieben werden.
= falsch

? Wie heißt die Begehung zur Messung von Ausleuchtung und fremden Netzen?
= Funk-Survey
= Site Survey
= Survey
