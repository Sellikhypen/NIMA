---
id: w-03
title: WPA-Enterprise, 802.1X und EAP
paths: wifi, specialist
order: 3
difficulty: hard
icon: person.badge.key
summary: Wie Unternehmens-WLANs mit RADIUS und individuellen Zugangsdaten arbeiten, die wichtigsten EAP-Methoden im Vergleich und warum die Zertifikatsprüfung auf den Clients entscheidend ist.
---

## Warum Enterprise?

Bei WPA2/3-Personal teilen sich alle eine Passphrase. Verlässt ein Mitarbeiter das Unternehmen, müsste man sie überall ändern. **WPA-Enterprise** authentifiziert stattdessen **jeden Benutzer oder jedes Gerät einzeln** – über [[802.1X]] und einen **RADIUS**-Server.

## Die Rollen

| Rolle | Komponente |
|---|---|
| Supplicant | der Client |
| Authenticator | Access Point bzw. WLAN-Controller |
| Authentication Server | [[RADIUS]]-Server (z. B. FreeRADIUS, Microsoft NPS), oft angebunden an Active Directory |

Der AP lässt bis zur erfolgreichen Anmeldung nur EAP-Verkehr durch. Nach Erfolg erhält jeder Client individuelles Schlüsselmaterial.

## EAP-Methoden

| Methode | Funktionsweise | Bewertung |
|---|---|---|
| **EAP-TLS** | Client und Server weisen sich mit Zertifikaten aus | sehr sicher, Goldstandard; braucht PKI und Geräteverwaltung |
| **PEAP-MSCHAPv2** | TLS-Tunnel zum Server, darin Benutzername/Passwort | verbreitet; sicher **nur**, wenn Clients das Server-Zertifikat strikt prüfen |
| **EAP-TTLS** | ähnlich PEAP, flexibler im Innenverfahren | wie PEAP |
| EAP-FAST | Cisco, mit PAC statt Zertifikat | seltener |
| LEAP, EAP-MD5 | veraltet | nicht verwenden |

> [!GEFAHR] Die häufigste Schwachstelle: fehlende Zertifikatsprüfung
> Wenn Clients bei PEAP oder TTLS das Zertifikat des RADIUS-Servers nicht prüfen (oder Benutzer Warnungen wegklicken dürfen), kann sich ein gefälschter Access Point mit derselben SSID als Unternehmensnetz ausgeben. Die Clients reden dann mit einem fremden Server und geben die Anmeldedaten in einem Verfahren preis, aus dem sich Passwörter offline ermitteln lassen.
>
> **Abhilfe:** per Gruppenrichtlinie bzw. MDM festlegen, welche CA und welcher Servername akzeptiert werden, Benutzerentscheidungen bei Zertifikatswarnungen verbieten – oder gleich auf **EAP-TLS** umstellen.

## Weitere Schutzmaßnahmen

- **WPA3-Enterprise**, PMF aktivieren
- Gast-WLAN strikt vom Firmennetz trennen (eigenes VLAN, nur Internet)
- **dynamische VLAN-Zuweisung** je nach Benutzerrolle über RADIUS-Attribute
- **NAC** (Network Access Control): Gerätezustand prüfen, bevor Zugang gewährt wird
- Zertifikats-Lebenszyklus automatisieren (Ausstellung, Erneuerung, Sperrung)
- RADIUS-Logs ins SIEM: fehlgeschlagene Anmeldungen, unbekannte Geräte

## Quiz

? Welche Rolle übernimmt der Access Point in 802.1X?
= Authenticator

? Wie heißt der Client in 802.1X?
= Supplicant

? Welches Protokoll nutzt der Authentication Server typischerweise?
= RADIUS

? Welche EAP-Methode nutzt Zertifikate auf Client- und Serverseite?
= EAP-TLS

? Was ist die wichtigste Schutzmaßnahme bei PEAP-MSCHAPv2?
+ Clients müssen das Zertifikat des RADIUS-Servers strikt prüfen
- eine längere SSID
- das 2,4-GHz-Band abschalten
- WPS aktivieren

? Welche EAP-Methoden gelten als veraltet?
+ LEAP
+ EAP-MD5
- EAP-TLS
- PEAP

? Wie heißt die Technik, Benutzer je nach Rolle automatisch in unterschiedliche VLANs zu legen?
= dynamische VLAN-Zuweisung
= Dynamic VLAN Assignment

?tf Bei WPA-Enterprise teilen sich alle Benutzer dasselbe Passwort.
= falsch
