---
id: kar-01
title: Karriere · Wege in die Cybersicherheit
paths: grundlagen, specialist
order: 90
difficulty: easy
icon: figure.walk.motion
tags: karriere
summary: Rollen im Überblick, typische Einstiege, Zertifikate als Wegweiser, Ausbildung und Studium in Deutschland, Portfolio und wie HTB-Zertifikate einzuordnen sind.
---

## Rollen

| Bereich | Rollen | Schwerpunkt |
|---|---|---|
| Verteidigung | SOC-Analyst, Incident Responder, Threat Hunter, Detection Engineer | Erkennen und Reagieren |
| Angriff (autorisiert) | Penetration Tester, Red Teamer, Bug-Bounty-Hunter | Schwachstellen finden und berichten |
| Engineering | Security Engineer, Cloud Security, AppSec/DevSecOps | Schutz bauen |
| Governance | ISB/CISO, Auditor, GRC-Berater, Datenschutz | Steuern, Prüfen |
| Spezialisierung | Forensik, Malware-Analyse, OT-Security, Kryptografie | Tiefe |

## Typische Einstiege

- aus der IT-Administration oder dem Netzwerkbetrieb (häufigster Weg)
- Ausbildung **Fachinformatiker/in** (z. B. Systemintegration, Daten- und Prozessanalyse) bzw. IT-Studium mit Sicherheitsschwerpunkt
- Weiterbildung **Cyber Security Specialist** ([[mod:cr-01|Cyber Range]]) bzw. IHK-Fortbildungen
- Quereinstieg mit Portfolio und Zertifikaten

## Zertifikate einordnen

| Ebene | Beispiele |
|---|---|
| Einstieg | CompTIA Security+, HTB CJCA |
| praxisnahe Fachzertifikate | HTB CPTS, CDSA, CWES; OSCP; GIAC-Zertifikate |
| Experte | HTB CWEE, CAPE; OSEP/OSWE |
| Management | CISSP, CISM, ISO-27001-Lead-Auditor |

Praktische Prüfungen wie die von HTB zeigen Können; Management-Zertifikate zeigen Breite und Erfahrung.

## Portfolio

- Writeups zu **retired** Maschinen und eigenen Labs (keine aktiven Lösungen veröffentlichen)
- eigene Werkzeuge oder Skripte auf GitHub
- Homelab-Dokumentation (SIEM, AD-Lab, Detection Rules)
- Vorträge, Blogartikel, CTF-Teilnahmen

## Quiz

? Was ist der häufigste Einstiegsweg in die Cybersicherheit?
+ aus IT-Administration oder Netzwerkbetrieb
- direkt als CISO
- ohne jede IT-Erfahrung als Red-Team-Leiter
- über Marketing

? Welches HTB-Zertifikat richtet sich an Einsteiger?
= CJCA

? Welche Writeups dürfen veröffentlicht werden?
+ zu retired Maschinen und eigenen Labs
- zu aktiven Maschinen
- zu Prüfungsaufgaben
- zu Kundenprojekten mit Namen

? Welche Rolle gehört zur Governance?
+ Informationssicherheitsbeauftragte/r
- Malware-Analyst
- Red Teamer
- Threat Hunter

@@@ MODULE @@@
---
id: kar-02
title: Karriere · Notizen und Wissensmanagement
paths: grundlagen, cpts, cyberrange
order: 91
difficulty: easy
icon: note.text
tags: karriere
summary: Warum gute Notizen über Bestehen entscheiden, Werkzeuge, Struktur pro Ziel und Thema, Vorlagen, Screenshots, Befehlsbibliothek und Wiederholung mit Spaced Repetition.
---

## Warum Notizen entscheidend sind

In praktischen Prüfungen wie CPTS hast du Tage Zeit, aber am Ende musst du einen **vollständigen Bericht** abgeben. Wer während der Arbeit sauber dokumentiert, schreibt den Bericht fast nebenbei ([[mod:s-07|Berichte]]).

## Werkzeuge

| Werkzeug | Stärke |
|---|---|
| Obsidian | lokale Markdown-Dateien, Verlinkung |
| CherryTree | hierarchisch, beliebt in Prüfungen |
| Joplin / Notion / OneNote | Synchronisation, Teamfunktionen |
| Sysreptor / Ghostwriter | spezialisierte Berichtswerkzeuge |

## Struktur pro Ziel

```text
Ziel-10.10.10.5/
  00-Überblick.md      # Host, OS, Rolle, Status
  01-Enumeration.md    # Dienste, Versionen, Auffälligkeiten
  02-Befunde.md        # je Befund: Beschreibung, Beleg, Risiko, Empfehlung
  03-Zugangsdaten.md   # gefundene Konten (nur Prüfungs-/Lab-Umgebung)
  screenshots/
```

## Gute Gewohnheiten

- Zeitstempel und Quelle bei jedem Schritt
- Screenshots mit sichtbarem Kontext (Host, Benutzer, Uhrzeit)
- Befehle mit Ausgabe kopieren, nicht abtippen
- „Sackgassen“ ebenfalls notieren – sie sparen später Zeit
- am Ende jedes Tages eine Zusammenfassung

## Wissensbasis

Eine persönliche **Befehls- und Methodenbibliothek** nach Thema (z. B. „SMB-Enumeration“, „Windows-Rechteprüfung“) wächst mit jedem Lab. Kombiniert mit **Spaced Repetition** – genau das, was NIMAs Training-Tab macht – bleibt Wissen langfristig.

## Quiz

? Warum sind gute Notizen in CPTS so wichtig?
+ Am Ende muss ein vollständiger Bericht abgegeben werden
- Notizen werden bewertet statt der Prüfung
- ohne Notizen startet die VPN nicht
- sie sind unwichtig

? Welches Werkzeug ist ein spezialisiertes Berichtswerkzeug?
+ Sysreptor
- Paint
- Excel
- Wireshark

? Warum sollten auch Sackgassen notiert werden?
+ Sie sparen später Zeit und zeigen den Prüfweg
- Sie zählen extra Punkte
- Sie sind Pflicht laut Gesetz
- Sie sollten nicht notiert werden

? Welche Lernmethode hilft, Wissen langfristig zu behalten?
= Spaced Repetition

@@@ MODULE @@@
---
id: kar-03
title: Karriere · Prüfungsstrategie für praktische Zertifikate
paths: cpts, cwes, cdsa, cwee, cape, cjca
order: 92
difficulty: medium
icon: timer
tags: karriere
summary: Vorbereitung, Zeitplanung über mehrere Tage, Methodik statt Raten, Umgang mit Blockaden, Pausen und Schlaf, Bericht als Prüfungsleistung und typische Fehler.
---

## Vorbereitung

1. **Pfad vollständig** abschließen – Prüfungen setzen die Module voraus
2. Skills Assessments ohne Lösungen wiederholen
3. Labs und retired Maschinen passend zum Pfad (z. B. ProLabs für AD)
4. Berichtsvorlage vorbereiten und einmal üben
5. Notizsystem einrichten ([[mod:kar-02|Notizen]])

## Zeitplanung

| Phase | Anteil (Beispiel bei 10 Tagen) |
|---|---|
| Enumeration und Überblick | Tag 1–2 |
| Hauptarbeit | Tag 3–7 |
| Lücken, Nachprüfung | Tag 8 |
| Bericht fertigstellen | Tag 9–10 |

> [!MERKE] Der Bericht ist Teil der Prüfung
> Bei HTB-Zertifikaten zählt ein professioneller Bericht. Ein fehlender oder schwacher Bericht kann trotz vieler Flags zum Nichtbestehen führen.

## Methodik statt Raten

- Checklisten pro Dienst und Phase abarbeiten
- jede Annahme prüfen – „es sollte funktionieren“ ist kein Befund
- nach 60–90 Minuten ohne Fortschritt: Perspektive wechseln, zurück zur Enumeration
- alles dokumentieren, was gefunden wurde, auch scheinbar Unwichtiges

## Körper und Kopf

Schlaf, Pausen, Essen und Bewegung sind keine verlorene Zeit. Müdigkeit führt zu übersehenen Details. Viele lösen Blockaden nach einer Nacht Schlaf in Minuten.

## Typische Fehler

- zu früh in die Tiefe statt Breite in der Enumeration
- Screenshots fehlen für den Bericht
- Regeln der Prüfung nicht gelesen (erlaubte Werkzeuge, Umfang)
- letzter Tag für den Bericht zu knapp

## Quiz

? Was kann trotz vieler Flags zum Nichtbestehen führen?
+ ein fehlender oder schwacher Bericht
- zu viele Notizen
- zu viel Schlaf
- ein ordentlicher Bericht

? Was tun nach 60–90 Minuten ohne Fortschritt?
+ Perspektive wechseln und zur Enumeration zurückkehren
- aufgeben
- zufällig Werkzeuge ausprobieren
- die Prüfung neu starten

? Was sollte man vor der Prüfung vorbereiten?
+ eine Berichtsvorlage
+ ein Notizsystem
- nichts
- eine Ausrede

?tf Schlaf während einer mehrtägigen Prüfung ist verlorene Zeit.
= falsch

@@@ MODULE @@@
---
id: kar-04
title: Karriere · CTFs verstehen und sinnvoll nutzen
paths: grundlagen, cjca
order: 93
difficulty: easy
icon: flag.2.crossed.fill
tags: karriere
summary: Jeopardy- und Attack-Defense-Formate, Kategorien, Teams, wie CTFs Fähigkeiten aufbauen, Regeln und Ethik und wie man vom CTF zur Berufspraxis kommt.
---

## Formate

| Format | Ablauf |
|---|---|
| Jeopardy | Aufgaben in Kategorien mit Punkten, jede liefert eine Flag |
| Attack-Defense | Teams verteidigen eigene Dienste und greifen die der anderen an (in der Spielumgebung) |
| King of the Hill | Kontrolle über ein Ziel möglichst lange halten |
| Blue-Team-CTF | Logs, PCAPs, Images analysieren (z. B. HTB Sherlocks) |

## Kategorien

| Kategorie | Inhalt |
|---|---|
| Web | Webanwendungen |
| Pwn | Binäre Programme und Speicherfehler |
| Reversing | Programme verstehen ohne Quellcode |
| Crypto | fehlerhafte Kryptografie |
| Forensics | Datenträger, Speicher, Netzwerkmitschnitte |
| OSINT | öffentliche Informationen |
| Misc | alles andere |

## Was CTFs bringen – und was nicht

| bringen | bringen weniger |
|---|---|
| Problemlösen unter Zeitdruck | Berichtsschreiben |
| Tiefe in Spezialthemen | Kundenkommunikation |
| Teamarbeit | realistische Unternehmensnetze |
| Spaß und Motivation | Umgang mit Rechtsrahmen und Scope |

Deshalb: CTFs **ergänzen** strukturierte Pfade und Prüfungen, ersetzen sie nicht.

## Regeln und Ethik

- nur die freigegebene Infrastruktur angreifen – nie die Plattform selbst oder andere Teams außerhalb der Spielregeln
- keine Flags teilen während laufender Wettbewerbe
- Writeups erst nach Ende veröffentlichen

## Einstieg

HTB Challenges und Sherlocks, picoCTF für Einsteiger, CTFtime.org für Termine, lokale Teams an Hochschulen. Das Prinzip „Flag finden“ kennst du auch aus [[mod:cr-12|der Cyber Range]].

## Quiz

? Welches CTF-Format hat Aufgaben in Kategorien mit Punkten?
= Jeopardy

? In welcher Kategorie geht es um Programme ohne Quellcode?
= Reversing
= Reverse Engineering

? Wann dürfen Writeups veröffentlicht werden?
+ nach Ende des Wettbewerbs
- während des Wettbewerbs
- nie
- vor dem Start

? Welche Website listet CTF-Termine?
= CTFtime
= CTFtime.org

?tf CTFs ersetzen strukturierte Lernpfade vollständig.
= falsch
