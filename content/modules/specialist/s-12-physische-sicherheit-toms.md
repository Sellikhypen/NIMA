---
id: s-12
title: Physische Sicherheit und technisch-organisatorische Maßnahmen
paths: specialist
order: 12
difficulty: easy
icon: building.columns.circle
summary: Zonenkonzept für Gebäude, Zutritts-, Zugangs- und Zugriffskontrolle, Rechenzentren, sichere Entsorgung, Clean Desk und die TOMs nach DSGVO als Brücke zwischen Technik und Organisation.
---

## Warum physische Sicherheit?

Die beste Firewall nützt nichts, wenn jemand den Server aus dem Rack tragen, einen USB-Stick einstecken oder Akten aus dem Papiermüll ziehen kann.

## Zonenkonzept

| Zone | Beispiel | Schutz |
|---|---|---|
| öffentlich | Empfang, Besucherbereich | Sichtkontrolle |
| intern | Büros | Ausweis, Besucherbegleitung |
| vertraulich | Personalabteilung, Archiv | zusätzliche Zutrittsberechtigung |
| hochsicher | Serverraum, Rechenzentrum | Mehrfaktor-Zutritt, Protokollierung, Videoüberwachung |

## Die drei Kontrollen

| Kontrolle | Frage | Beispiel |
|---|---|---|
| **Zutrittskontrolle** | Wer darf in den Raum? | Ausweisleser, Schlüsselverwaltung |
| **Zugangskontrolle** | Wer darf das System benutzen? | Anmeldung, MFA, Bildschirmsperre |
| **Zugriffskontrolle** | Wer darf welche Daten sehen? | Rechtekonzept, Verschlüsselung |

## Rechenzentrum und Serverraum

- Brandschutz (Früherkennung, Löschanlage), Klimatisierung, Wassermelder
- unterbrechungsfreie Stromversorgung und Notstrom
- abgeschlossene Racks, keine Fenster, keine Fremdleitungen
- Zutrittsprotokoll, Begleitung von Dienstleistern
- georedundanter Zweitstandort für kritische Systeme

## Arbeitsplatz

- **Clean Desk / Clear Screen**: keine Unterlagen offen liegen lassen, Bildschirm sperren (Win+L)
- Datenträgerverschlüsselung (BitLocker, FileVault, LUKS)
- USB-Ports per Richtlinie beschränken
- Diebstahlschutz und Inventar für mobile Geräte

## Sichere Entsorgung

| Medium | Verfahren |
|---|---|
| Papier | Aktenvernichter nach DIN 66399 (Schutzklasse passend zum Inhalt) |
| Festplatten (HDD) | Überschreiben oder physische Zerstörung |
| SSDs | Secure Erase des Herstellers bzw. Kryptolöschung (verschlüsselte Platte, Schlüssel vernichten) oder Zerstörung |
| Smartphones | Werksreset bei verschlüsseltem Gerät, MDM-Löschung |

> [!MERKE] Verschlüsselung erleichtert die Entsorgung
> Wenn ein Datenträger von Anfang an verschlüsselt war, genügt es, den Schlüssel sicher zu vernichten, um die Daten unbrauchbar zu machen.

## Technisch-organisatorische Maßnahmen (TOMs)

Art. 32 DSGVO verlangt angemessene **TOMs**. Typische Gliederung:

| Bereich | Beispiele |
|---|---|
| Vertraulichkeit | Zutritts-, Zugangs-, Zugriffskontrolle, Trennung, Pseudonymisierung |
| Integrität | Weitergabekontrolle (Verschlüsselung), Eingabekontrolle (Protokollierung) |
| Verfügbarkeit und Belastbarkeit | Backups, Redundanz, Notfallpläne |
| Wiederherstellbarkeit | getestete Wiederherstellung |
| Überprüfung | regelmäßige Audits, Pentests, Datenschutz-Management |

## Quiz

? Welche Kontrolle regelt, wer einen Raum betreten darf?
= Zutrittskontrolle

? Welche Kontrolle regelt, wer welche Daten sehen darf?
= Zugriffskontrolle

? Welche DIN-Norm regelt die Aktenvernichtung?
= DIN 66399
= 66399

? Wie löscht man SSDs zuverlässig?
+ Secure Erase oder Kryptolöschung bzw. Zerstörung
- einmal formatieren
- Dateien in den Papierkorb verschieben
- umbenennen

? Wofür steht TOMs?
= technisch-organisatorische Maßnahmen

? Welcher DSGVO-Artikel verlangt TOMs?
= Art. 32
= 32

?tf Clean Desk bedeutet, dass vertrauliche Unterlagen nicht offen liegen bleiben.
= wahr
