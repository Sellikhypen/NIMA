---
id: f-01
title: Daten, Bits und Zahlensysteme
paths: grundlagen, cjca
order: 1
difficulty: easy
icon: number
summary: Wie Computer Informationen speichern – Bits, Bytes, Binär- und Hexadezimalsystem, Zeichenkodierung und Base64. Die Sprache, in der jedes Paket, jeder Hash und jede Speicheradresse geschrieben ist.
---

## Warum Zahlensysteme für Security wichtig sind

Wer IT-Sicherheit lernt, sieht ständig Zeichenketten wie `0x7f`, `ff:ff:ff:00`, `4d5a` oder `SGVsbG8=`. Das sind keine Geheimcodes, sondern ganz normale Darstellungen von Daten. Ein Paketmitschnitt in [[Wireshark]] zeigt Bytes in Hexadezimal, eine [[Subnetzmaske]] ist eigentlich eine Folge von Einsen und Nullen, [[Hashfunktion|Hashwerte]] werden als Hex-Strings angezeigt und viele Web-Token sind [[Base64]]-kodiert.

Wenn du diese Darstellungen sicher lesen kannst, verstehst du Werkzeuge schneller, erkennst Muster in Logdateien und lässt dich nicht von „kryptisch aussehenden“ Daten verunsichern.

> [!ANALOGIE] Zahlen sind wie Sprachen
> Die Zahl „zweihundertfünfundfünfzig“ bleibt dieselbe, egal ob du sie auf Deutsch, Englisch oder in Zahlen schreibst. Genauso sind `255`, `11111111` und `0xFF` nur drei Schreibweisen derselben Menge.

## Bits und Bytes

Ein **Bit** ist die kleinste Informationseinheit: 0 oder 1, aus oder an, Strom oder kein Strom. Acht Bits bilden ein **Byte**. Mit einem Byte lassen sich 2⁸ = 256 verschiedene Werte darstellen (0 bis 255).

| Einheit | Größe | Beispiel |
|---|---|---|
| Bit | 0 oder 1 | ein Flag in einem TCP-Header |
| Nibble | 4 Bit | eine Hex-Ziffer |
| Byte | 8 Bit | ein Zeichen in ASCII |
| Kibibyte (KiB) | 1024 Byte | eine kleine Textdatei |
| Mebibyte (MiB) | 1024 KiB | ein Foto |
| Gibibyte (GiB) | 1024 MiB | ein Betriebssystem-Image |

> [!MERKE] KB vs. KiB
> Hersteller rechnen oft dezimal (1 KB = 1000 Byte), Betriebssysteme häufig binär (1 KiB = 1024 Byte). Deshalb wirkt eine „1-TB-Festplatte“ im System kleiner.

## Das Binärsystem

Im Dezimalsystem hat jede Stelle den Wert einer Zehnerpotenz (1, 10, 100 …). Im Binärsystem ist jede Stelle eine Zweierpotenz:

| Stelle | 7 | 6 | 5 | 4 | 3 | 2 | 1 | 0 |
|---|---|---|---|---|---|---|---|---|
| Wert | 128 | 64 | 32 | 16 | 8 | 4 | 2 | 1 |

Die Binärzahl `11000000` bedeutet also 128 + 64 = **192**. Genau so liest man das erste Oktett von `192.168.1.1`.

### Umrechnen Dezimal → Binär

Ziehe von links die größte passende Zweierpotenz ab:

1. 200 − 128 = 72 → Stelle 7 = 1
2. 72 − 64 = 8 → Stelle 6 = 1
3. 32 und 16 passen nicht → 0, 0
4. 8 − 8 = 0 → Stelle 3 = 1
5. Rest 0 → Stellen 2, 1, 0 = 0

Ergebnis: `11001000` = 200.

> [!PRAXIS] Wo du das brauchst
> Beim [[Subnetting]] musst du Masken wie `/26` blitzschnell in `255.255.255.192` übersetzen. Das ist reine Binärrechnung: 26 Einsen von links, Rest Nullen.

## Das Hexadezimalsystem

Hexadezimal (Basis 16) nutzt die Ziffern `0–9` und `A–F` (A = 10 … F = 15). Eine Hex-Ziffer entspricht exakt **4 Bit**, zwei Hex-Ziffern also genau **einem Byte**. Deshalb ist Hex die bevorzugte Schreibweise für Rohdaten.

| Dezimal | Binär | Hex |
|---|---|---|
| 0 | 0000 | 0 |
| 9 | 1001 | 9 |
| 10 | 1010 | A |
| 15 | 1111 | F |
| 255 | 1111 1111 | FF |

Hex-Werte werden oft mit `0x` (Programmierung), `\x` (in Strings) oder `%` (URL-Kodierung, z. B. `%20` für ein Leerzeichen) markiert.

> [!BEISPIEL] Magic Bytes
> Viele Dateiformate beginnen mit festen Bytes, den **Magic Bytes**. PNG-Dateien starten mit `89 50 4E 47`, Windows-Programme (PE) mit `4D 5A` („MZ“), PDF mit `25 50 44 46` („%PDF“). Forensiker und Virenscanner erkennen Dateitypen daran – unabhängig von der Dateiendung.

## Zeichenkodierung: ASCII und UTF-8

Computer speichern Text als Zahlen. **ASCII** ordnet 128 Zeichen jeweils eine Zahl zu: `A` = 65 = `0x41`, `a` = 97 = `0x61`, Leerzeichen = 32 = `0x20`.

**UTF-8** erweitert das auf alle Zeichen der Welt (Umlaute, Emojis). Die ersten 128 Zeichen sind identisch mit ASCII, alles andere wird mit 2–4 Bytes kodiert. `ä` belegt zum Beispiel zwei Bytes (`C3 A4`).

> [!WARNUNG] Kodierungsfehler sind Sicherheitsfehler
> Wenn eine Anwendung Eingaben in einer Kodierung prüft, sie aber in einer anderen verarbeitet, können Filter umgangen werden. Viele Web-Schwachstellen entstehen genau an solchen Übergängen.

## Base64 – Kodierung, keine Verschlüsselung

[[Base64]] stellt beliebige Bytes mit 64 druckbaren Zeichen dar (`A–Z`, `a–z`, `0–9`, `+`, `/`). Drei Bytes werden zu vier Zeichen; fehlen Bytes am Ende, wird mit `=` aufgefüllt.

Base64 wird überall genutzt, wo Binärdaten durch textbasierte Kanäle müssen: E-Mail-Anhänge, HTTP-Basic-Authentifizierung, Teile von [[JWT|JSON Web Tokens]], Zertifikate im PEM-Format.

> [!GEFAHR] Base64 schützt nichts
> Base64 ist reversibel und braucht keinen Schlüssel. Ein Passwort, das „nur“ Base64-kodiert in einer Konfigurationsdatei steht, ist praktisch Klartext. Das ist einer der häufigsten Befunde in Sicherheitsprüfungen.

## Kodierung, Verschlüsselung, Hashing – der Unterschied

| Verfahren | Ziel | Umkehrbar? | Schlüssel? | Beispiel |
|---|---|---|---|---|
| Kodierung | Darstellung ändern | ja, für jeden | nein | Base64, URL-Encoding, Hex |
| Verschlüsselung | Vertraulichkeit | nur mit Schlüssel | ja | AES, RSA |
| Hashing | Integrität / Fingerabdruck | nein (Einwegfunktion) | nein | SHA-256 |

Diese Unterscheidung taucht in jeder Zertifizierung auf. Mehr dazu im Modul [[mod:f-08|Kryptografie]].

## Quiz

? Wie viele verschiedene Werte kann ein Byte darstellen?
= 256
! 2⁸ = 256 Werte, von 0 bis 255.

? Was ist die Binärzahl `11000000` im Dezimalsystem?
= 192

? Wie viele Bit entspricht eine Hexadezimal-Ziffer?
= 4
= vier
! Deshalb ergeben zwei Hex-Ziffern genau ein Byte.

? Welcher Hex-Wert entspricht dezimal 255?
= FF
= 0xFF

? Mit welchen Magic Bytes (ASCII) beginnen Windows-Programme im PE-Format?
+ MZ
- PK
- %PDF
- ELF

?tf Base64 ist ein Verschlüsselungsverfahren.
= falsch
! Base64 ist eine Kodierung: umkehrbar, ohne Schlüssel.

? Welches Verfahren ist eine Einwegfunktion?
+ Hashing
- Base64
- AES
- URL-Encoding

? Welches Zeichen nutzt Base64 zum Auffüllen am Ende?
= =

? Was bedeutet `%20` in einer URL?
+ Ein Leerzeichen
- Das Zeichen %
- Die Zahl 20
- Einen Zeilenumbruch
