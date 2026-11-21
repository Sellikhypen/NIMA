---
id: b-04
title: Dateipfade, Inclusion und Uploads
paths: cwes, cpts, cwee
order: 9
difficulty: medium
icon: doc.badge.arrow.up
summary: Path Traversal, Local und Remote File Inclusion, unsichere Datei-Uploads und Downloads – Ursachen, typische Fundstellen, Auswirkungen und eine robuste Architektur für Dateiverarbeitung.
htb: File Inclusion
---

## Path Traversal

Eine Anwendung liest eine Datei, deren Name aus einer Eingabe stammt, z. B. `download?file=rechnung.pdf`. Prüft sie nicht, dass der Pfad im vorgesehenen Verzeichnis bleibt, lassen sich mit Pfadbestandteilen wie `..` andere Dateien des Servers erreichen – Konfigurationen, Schlüssel, Quellcode.

> [!MERKE] Warum Filter oft scheitern
> Pfade lassen sich auf viele Arten schreiben: unterschiedliche Kodierungen, doppelte Kodierung, Schrägstriche in beide Richtungen, absolute Pfade, Symlinks. Eine Prüfung per Zeichenersetzung ist deshalb unzuverlässig. Richtig ist, den **kanonischen** Pfad zu bilden und zu prüfen, ob er im erlaubten Basisverzeichnis liegt – oder besser gar keine Pfade aus Eingaben zu bilden.

## File Inclusion

Bei **Inclusion** wird eine Datei nicht nur gelesen, sondern von der Programmiersprache **eingebunden** (z. B. PHP `include`). Dann kann ihr Inhalt als Code ausgeführt werden.

| Art | Beschreibung |
|---|---|
| LFI (Local File Inclusion) | Einbinden lokaler Dateien; kann zu Informationspreisgabe und – in Kombination mit beschreibbaren Dateien wie Logs oder Uploads – zu Codeausführung führen |
| RFI (Remote File Inclusion) | Einbinden von Dateien über URLs; in PHP standardmäßig abgeschaltet (`allow_url_include`) |

Ein besonderer Aspekt in PHP sind **Stream-Wrapper** (`php://`, `data://`, `file://` …), mit denen Dateiinhalte umgewandelt oder Daten direkt eingebettet werden können. Sie vergrößern die Angriffsfläche von Inclusion-Lücken erheblich.

## Unsichere Uploads

| Fehler | Folge |
|---|---|
| Prüfung nur der Dateiendung oder des `Content-Type` | ausführbare Dateien werden als Bild ausgegeben |
| Ablage im Webroot mit Ausführungsrechten | hochgeladene Skripte laufen auf dem Server |
| Originaldateiname wird übernommen | Überschreiben vorhandener Dateien, Path Traversal im Namen |
| keine Größen- oder Mengenbegrenzung | Speicher läuft voll |
| ungeprüfte Bild- und Dokumentverarbeitung | Lücken in Bibliotheken (Bildkonverter, XML in Office-Dateien, SVG mit Skripten) |

## Sichere Dateiverarbeitung

1. **Keine Pfade aus Eingaben** – Dateien über eine ID referenzieren, Zuordnung ID → Speicherort in der Datenbank
2. Uploads **außerhalb des Webroots** oder in Objektspeicher (S3, Blob) ablegen
3. **Zufällige Dateinamen** vergeben, Originalnamen nur als Metadaten speichern
4. Dateityp anhand des **Inhalts** prüfen (Magic Bytes) und auf erlaubte Typen beschränken
5. Bilder neu kodieren (entfernt eingebettete Inhalte), SVG nicht inline ausliefern
6. Ausgabe mit `Content-Disposition: attachment` und korrektem `Content-Type`, `X-Content-Type-Options: nosniff`
7. Uploads auf Schadsoftware scannen, Größenlimits setzen
8. Anwendung mit minimalen Dateisystemrechten betreiben

> [!TIPP] Eigene Domain für Benutzerinhalte
> Große Plattformen liefern hochgeladene Inhalte von einer separaten Domain aus. So kann selbst eine bösartige Datei keine Cookies der Hauptanwendung erreichen.

## Erkennung

- Pfadfragmente wie `..`, `/etc/`, `C:\Windows`, `php://` in Parametern (Webserver-Logs, WAF)
- Zugriffe auf ungewöhnliche Dateien durch den Webserver-Prozess (File Integrity Monitoring, auditd)
- neue ausführbare Dateien in Upload-Verzeichnissen
- Prozesse, die vom Webserver gestartet werden (EDR)

## Quiz

? Was ist die zuverlässigste Maßnahme gegen Path Traversal?
+ keine Dateipfade aus Eingaben bilden, sondern Dateien über IDs referenzieren
- Punkte aus der Eingabe entfernen
- die Seite per HTTPS ausliefern
- Dateinamen in Großbuchstaben umwandeln

? Was unterscheidet File Inclusion von reinem Datei-Lesen?
+ Die Datei wird eingebunden und kann als Code ausgeführt werden
- Die Datei wird gelöscht
- Die Datei wird verschlüsselt
- Es gibt keinen Unterschied

? Welche PHP-Einstellung erlaubt Remote File Inclusion?
= allow_url_include

? Woran sollte ein Upload-Filter den Dateityp prüfen?
+ am Inhalt (Magic Bytes)
- nur an der Endung
- nur am Content-Type-Header
- am Dateinamen

? Wo sollten Uploads gespeichert werden?
+ außerhalb des Webroots bzw. in Objektspeicher
- im Webroot mit Ausführungsrechten
- im Systemverzeichnis
- im Cookie

? Welcher Header sorgt dafür, dass eine Datei heruntergeladen statt angezeigt wird?
= Content-Disposition
= Content-Disposition: attachment

?tf SVG-Dateien können Skripte enthalten.
= wahr
