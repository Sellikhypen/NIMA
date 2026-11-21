---
id: w-02
title: WLAN-Verschlüsselung von WEP bis WPA3
paths: wifi
order: 2
difficulty: medium
icon: lock.rectangle.stack
summary: Warum WEP und WPA gebrochen sind, wie WPA2-PSK mit dem 4-Way-Handshake funktioniert, warum schwache Passphrasen das Hauptproblem sind und was WPA3 mit SAE verbessert.
---

## Die Generationen im Überblick

| Verfahren | Jahr | Verschlüsselung | Status |
|---|---|---|---|
| WEP | 1999 | RC4 mit 24-Bit-IV | gebrochen, in Minuten zu überwinden – nicht mehr verwenden |
| WPA | 2003 | TKIP (RC4-basiert) | Übergangslösung, veraltet |
| [[WPA2]] | 2004 | CCMP (AES) | noch verbreitet, sicher mit starker Passphrase und aktuellem Patchstand |
| [[WPA3]] | 2018 | SAE, GCMP/CCMP, PMF Pflicht | aktueller Standard |

> [!INFO] Warum WEP scheiterte
> Der Initialisierungsvektor war nur 24 Bit lang und wiederholte sich schnell. Zusammen mit Schwächen von RC4 ließ sich der Schlüssel aus genügend mitgeschnittenem Verkehr berechnen – unabhängig von seiner Länge.

## WPA2-Personal (PSK)

Alle Teilnehmer teilen eine Passphrase. Daraus und aus der SSID wird der **Pairwise Master Key (PMK)** berechnet (PBKDF2 mit 4096 Runden). Beim Verbinden leiten Client und AP im **4-Way-Handshake** daraus frische Sitzungsschlüssel ab:

1. AP → Client: ANonce (Zufallszahl des AP)
2. Client → AP: SNonce + MIC (Integritätsprüfung)
3. AP → Client: Gruppenschlüssel (GTK, verschlüsselt) + MIC
4. Client → AP: Bestätigung

Aus PMK, beiden Nonces und beiden MAC-Adressen entsteht der **Pairwise Transient Key (PTK)**.

> [!WARNUNG] Die eigentliche Schwachstelle: die Passphrase
> Wer einen Handshake mitschneidet, kann offline Passwortkandidaten prüfen – der MIC verrät, ob ein Kandidat stimmt. Dagegen hilft nur eine **lange, zufällige Passphrase** (mindestens 16–20 Zeichen, nicht aus Wörterbüchern). Kurze oder vorhersagbare Passphrasen (Firmenname + Jahr, Telefonnummern, Standardpasswörter der Router) sind das Hauptrisiko von WPA2-PSK.

### PMKID

Manche APs senden im ersten Handshake-Frame eine **PMKID**, die ebenfalls aus dem PMK abgeleitet ist. Sie ermöglicht dieselbe Offline-Prüfung von Passphrasen, ohne dass ein Client verbunden sein muss. Auch hier schützt nur eine starke Passphrase – und aktuelle Firmware.

### KRACK

2017 zeigte die **Key Reinstallation Attack (KRACK)**, dass Implementierungen durch erneutes Einspielen von Handshake-Nachrichten Schlüssel wiederverwendeten. Die Lösung waren Patches für Clients und APs – ein Beispiel dafür, dass auch ein korrektes Protokoll an fehlerhaften Implementierungen scheitern kann.

## WPS

**Wi-Fi Protected Setup** sollte das Verbinden vereinfachen. Die PIN-Methode prüft die achtstellige PIN in zwei Hälften, was die Zahl der möglichen Kombinationen drastisch verringert. Manche Geräte erzeugen PINs zudem vorhersagbar.

> [!GEFAHR] Empfehlung
> WPS (insbesondere die PIN-Methode) deaktivieren. Prüfe nach Firmware-Updates, ob es wieder aktiv ist.

## WPA3

| Neuerung | Wirkung |
|---|---|
| **SAE** (Simultaneous Authentication of Equals, „Dragonfly“) ersetzt PSK-Handshake | Offline-Wörterbuchangriffe auf mitgeschnittene Handshakes sind nicht mehr möglich, Forward Secrecy |
| PMF Pflicht | gefälschte Abmelde-Frames wirkungslos |
| WPA3-Enterprise 192-Bit-Modus | stärkere Kryptografie für Hochsicherheitsumgebungen |
| **OWE** (Enhanced Open) | Verschlüsselung auch in offenen Netzen ohne Passwort |

> [!INFO] Dragonblood und Transition Mode
> Frühe WPA3-Implementierungen hatten Seitenkanal-Schwächen („Dragonblood“), die per Update behoben wurden. Im **WPA3-Transition-Mode** (WPA2 und WPA3 parallel) können Geräte weiter WPA2 nutzen – die Schutzwirkung von WPA3 greift dann nur für WPA3-Clients.

## Quiz

? Welche Verschlüsselung nutzt WPA2?
+ CCMP (AES)
- TKIP
- RC4 mit 24-Bit-IV
- DES

? Wie viele Nachrichten hat der WPA2-Handshake?
= 4

? Was ist bei WPA2-PSK das Hauptrisiko?
+ eine schwache oder vorhersagbare Passphrase
- die Kanalbreite
- die SSID-Länge
- das 5-GHz-Band

? Welches Verfahren ersetzt bei WPA3 den PSK-Handshake?
= SAE
= Simultaneous Authentication of Equals

? Wie heißt die Schwachstelle von 2017, bei der Schlüssel erneut eingespielt wurden?
= KRACK

? Welche Funktion sollte man auf Routern deaktivieren, weil ihre PIN-Methode unsicher ist?
= WPS

? Wie heißt der WPA3-Modus für verschlüsselte offene Netze?
= OWE
= Enhanced Open

?tf WEP ist mit einem langen Schlüssel noch sicher.
= falsch
