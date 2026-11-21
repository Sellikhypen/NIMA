---
id: w-05
title: WLAN prüfen und härten – Methodik
paths: wifi, specialist
order: 5
difficulty: medium
icon: checklist.checked
summary: Wie ein autorisiertes WLAN-Assessment aufgebaut ist – Recht, Scope, Ausrüstung, Prüfpunkte, Dokumentation – und eine Härtungs-Checkliste für Unternehmens- und Heimnetze.
---

## Rechtlicher Rahmen

Funkwellen machen nicht an Grundstücksgrenzen halt. Umso wichtiger sind klare Regeln:

> [!GEFAHR] Nur mit Auftrag
> Das Abhören fremder Funkkommunikation, das Eindringen in fremde Netze und das Stören von Funk sind strafbar (u. a. §§ 202a ff. StGB, Telekommunikationsrecht). Prüfe nur eigene Netze oder Netze, für die eine schriftliche Beauftragung des Betreibers vorliegt, und achte darauf, keine Netze von Nachbarn zu berühren.

## Scope festlegen

- welche SSIDs und BSSIDs gehören zum Auftrag (Liste vom Kunden)
- welche Standorte, Gebäude, Etagen
- welche Prüfungen erlaubt sind (passiv beobachten, Konfiguration prüfen, Gastnetz-Trennung testen, Zertifikatsprüfung der Clients testen …)
- welche ausgeschlossen sind (z. B. jegliche Störung des Betriebs)
- Zeitfenster und Notfallkontakte

## Ausrüstung (Überblick)

- WLAN-Adapter, die Monitor-Mode für die benötigten Bänder unterstützen
- Laptop mit Analysesoftware (z. B. Wireshark, Kismet für passive Erfassung)
- für Surveys: App oder Messsystem für Signalstärke und Kanalbelegung
- Dokumentation: Grundriss, Fotos der Messpunkte

## Prüfpunkte einer WLAN-Bewertung

| Bereich | Prüffrage |
|---|---|
| Verschlüsselung | Wird WPA3 oder mindestens WPA2-AES genutzt? Sind WEP/TKIP abgeschaltet? |
| Passphrase (PSK-Netze) | Ist sie lang, zufällig, nicht im Wörterbuch, regelmäßig geändert? |
| WPS | deaktiviert? |
| PMF | aktiviert bzw. erforderlich? |
| Enterprise | Welche EAP-Methode? Prüfen Clients das Serverzertifikat strikt? |
| Segmentierung | Ist das Gastnetz vom internen Netz getrennt? Sind Clients untereinander isoliert? |
| Management | Ist die Verwaltungsoberfläche der APs nur aus dem Management-Netz erreichbar? Standardpasswörter geändert? Firmware aktuell? |
| Ausleuchtung | Reicht das Netz unnötig weit nach draußen? |
| Rogue APs | Gibt es nicht genehmigte APs im Firmennetz? |
| Monitoring | Werden WIDS-Alarme und RADIUS-Logs ausgewertet? |

## Dokumentation

Jeder Befund enthält Beschreibung, betroffene SSID/BSSID, Ort, Nachweis (z. B. Screenshot der Konfiguration oder des beobachteten Frames), Risikobewertung und konkrete Empfehlung – genau wie in jedem Pentest-Bericht (siehe [[mod:c-10|Dokumentation und Reporting]]).

## Härtungs-Checkliste

**Unternehmen**

- WPA3-Enterprise mit EAP-TLS, PMF erforderlich
- getrennte SSIDs/VLANs für Mitarbeitende, Gäste, IoT
- Client-Isolation im Gastnetz
- WIDS aktiv, Alarme im SIEM
- AP-Management nur aus dem Management-Netz, Firmware-Updates
- Zertifikatsprofile per MDM/GPO verteilen, Benutzer dürfen Warnungen nicht übergehen

**Zuhause / kleine Büros**

- WPA3 oder WPA2-AES mit langer, zufälliger Passphrase
- WPS aus, Fernverwaltung aus
- Router-Admin-Passwort ändern, Firmware automatisch aktualisieren
- Gastnetz für Besucher und Smart-Home-Geräte

## Quiz

? Was muss vor jeder WLAN-Prüfung vorliegen?
+ eine schriftliche Beauftragung des Betreibers
- ein starker WLAN-Adapter
- ein Funk-Survey
- ein Gastnetz

? Welche Prüfung stellt sicher, dass Gäste das interne Netz nicht erreichen?
+ Test der Segmentierung zwischen Gast- und internem Netz
- Prüfung der SSID-Länge
- Prüfung der Kanalbreite
- Messung der Signalstärke

? Welches Werkzeug eignet sich zur passiven Erfassung von WLANs?
= Kismet

?tf Client-Isolation verhindert, dass sich Geräte im Gastnetz gegenseitig erreichen.
= wahr

? Welche Kombination ist für Unternehmen empfohlen?
+ WPA3-Enterprise mit EAP-TLS und erforderlichem PMF
- WPA2-PSK mit WPS
- WEP mit langem Schlüssel
- offenes Netz mit Captive Portal
