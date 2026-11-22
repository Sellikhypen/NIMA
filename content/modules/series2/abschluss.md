---
id: fs-06
title: Fallstudie 6 · Seitwärtsbewegung im Krankenhausnetz
paths: cdsa, cape, specialist
order: 36.3
difficulty: hard
icon: cross.case.fill
tags: fallstudie, lateral movement, ad
summary: Ein fiktiver Vorfall Schritt für Schritt – vom kompromittierten Arbeitsplatz über gestohlene Anmeldedaten bis zur Domäne – und wie Tiering, LAPS und Erkennung die Kette gebrochen hätten.
---

## Einfach erklärt

Ein Krankenhaus (fiktiv) mit 2.000 Arbeitsplätzen. Ein Mitarbeiter öffnet einen präparierten Anhang. Sechs Tage später kontrollieren die Angreifer die gesamte Domäne. Diese Fallstudie zeigt jede Station – und an jeder Station die Maßnahme, die den Weg versperrt hätte.

## Station 1 – der erste Rechner

Ein Office-Dokument startet ein Skript, das eine Verbindung nach außen aufbaut. Der Angreifer hat nun eine Sitzung als normaler Benutzer auf PC-0815.

- **Erkennbar**: Office → Skript-Interpreter (Sysmon 1), neue ausgehende Verbindung eines ungewöhnlichen Prozesses.
- **Verhinderbar**: ASR-Regel „Office darf keine Kindprozesse starten“, Makros aus dem Internet blockiert.

## Station 2 – lokale Admin-Rechte

Auf PC-0815 läuft ein alter Dienst mit beschreibbarem Programmpfad. Der Angreifer wird lokaler Administrator.

- **Erkennbar**: Änderung an Dienst-Binärdateien, neue Dienste.
- **Verhinderbar**: Dateirechte prüfen, Application Control, Härtung der Images.

## Station 3 – Anmeldedaten im Speicher

Als Admin liest der Angreifer den LSASS-Speicher. Darin: der Hash des lokalen Administrators – **auf allen 2.000 Rechnern identisch** – und Anmeldedaten eines Helpdesk-Mitarbeiters, der sich am Vortag per RDP auf PC-0815 angemeldet hatte.

- **Erkennbar**: Zugriff auf LSASS (Sysmon 10, EDR).
- **Verhinderbar**: Credential Guard, LSA-Schutz, **LAPS** (einzigartige lokale Admin-Passwörter), Remote Credential Guard für Helpdesk-RDP.

## Station 4 – Ausbreitung

Mit dem identischen lokalen Admin-Hash meldet sich der Angreifer per SMB auf Dutzenden weiteren Arbeitsplätzen an und sucht dort nach weiteren Anmeldedaten.

- **Erkennbar**: Workstation-zu-Workstation-Anmeldungen (4624 Typ 3) mit lokalem Konto, viele in kurzer Zeit.
- **Verhinderbar**: LAPS, Host-Firewall gegen SMB zwischen Clients, „Deny access from network“ für lokale Konten.

## Station 5 – der Domänen-Admin

Auf einem der Rechner war am Morgen ein Domänen-Admin angemeldet – er hatte „nur schnell“ einen Drucker installiert. Seine Anmeldedaten liegen im Speicher. Der Angreifer übernimmt die Domäne und repliziert die Hashes (DCSync).

- **Erkennbar**: DA-Anmeldung auf Arbeitsplatz (Tiering-Verstoß), DCSync von einem Nicht-DC.
- **Verhinderbar**: **Tiering** – Domänen-Admins melden sich nie an Arbeitsplätzen an; Protected Users; Alarm bei DCSync außerhalb von DCs.

> [!MERKE] Drei Maßnahmen, die die Kette gebrochen hätten
> LAPS (keine identischen lokalen Passwörter), Tiering (keine Domänen-Admins auf Arbeitsplätzen) und Host-Firewalls zwischen Clients. Keine davon ist teuer – alle drei sind Organisation und Konfiguration.

## Tiefer eingetaucht

Die Untersuchung rekonstruierte die Kette über eine Super-Timeline aus EDR-Daten, Windows-Ereignissen und DC-Logs. Die Wiederherstellung erforderte eine Forest-Recovery, das zweimalige Zurücksetzen von krbtgt und das Neusetzen aller privilegierten Passwörter. Medizinische Geräte im selben Netz mussten einzeln geprüft werden – ein Argument für die Segmentierung von Medizintechnik. Lehre für das SOC: Mehrere Signale (Office-Kindprozess, LSASS-Zugriff, Client-zu-Client-SMB, DA auf Arbeitsplatz) waren sichtbar – aber jedes allein lag unter der Alarmschwelle. Risk-based Alerting hätte sie zusammengeführt.

## Quiz

? Welche Maßnahme hätte die Ausbreitung über identische lokale Admin-Passwörter verhindert?
= LAPS
! Einzigartige, rotierende lokale Admin-Passwörter pro Gerät.

? Welcher Fehler ermöglichte die Übernahme der Domäne?
+ ein Domänen-Admin war an einem Arbeitsplatz angemeldet
- ein zu langes Passwort
- ein deaktiviertes Gastkonto
- ein neuer Drucker an sich
! Tiering hätte das verhindert.

? Woran erkennt man DCSync von einem Nicht-DC?
+ Replikationsanfragen von einem System, das kein Domain Controller ist
- an einer neuen Bildschirmauflösung
- an einem Neustart
- an einem leeren Papierkorb
! Ein starkes Alarmsignal.

?tf In der Fallstudie lagen mehrere Signale einzeln unter der Alarmschwelle.
= wahr
! Risk-based Alerting hätte sie zusammengeführt.

? Welche Maßnahme schützt Helpdesk-Anmeldedaten bei RDP-Sitzungen?
= Remote Credential Guard
! Die Anmeldedaten bleiben nicht auf dem Zielsystem.

? Welche ASR-Regel hätte den ersten Schritt erschwert?
+ Office-Apps dürfen keine Kindprozesse erstellen
- USB-Geräte blockieren
- Bildschirmschoner erzwingen
- Druckaufträge protokollieren
! Das Dokument hätte kein Skript starten können.

@@@ MODULE @@@
---
id: gt-09
title: Grundlagen-Training 9 · Reguläre Ausdrücke für Logs
paths: cdsa, grundlagen, cjca
order: 32.7
difficulty: medium
icon: textformat.characters
tags: regex, logs, training
summary: Praktische Regex-Muster für IP-Adressen, Zeitstempel, Benutzer, URLs und Hashes – mit Übungen für grep, SIEM-Feldextraktion und Python.
---

## Einfach erklärt

Ein regulärer Ausdruck ist ein **Suchmuster** statt eines festen Suchworts. Statt „finde 10.0.0.5“ sagt man „finde alles, was wie eine IP-Adresse aussieht“. Für Analysten ist das wie eine Lupe, die nur bestimmte Formen hervorhebt.

## Bausteine

| Zeichen | Bedeutung | Beispiel |
|---|---|---|
| `.` | beliebiges Zeichen | `a.c` → abc, a7c |
| `\d` | Ziffer | `\d\d` → 42 |
| `\w` | Wortzeichen | `\w+` → admin_1 |
| `\s` | Leerraum | |
| `+` / `*` / `?` | 1+, 0+, 0 oder 1 | `\d+` |
| `{n,m}` | n bis m Wiederholungen | `\d{1,3}` |
| `[ ]` | Zeichenklasse | `[a-f0-9]` |
| `^` / `$` | Zeilenanfang / -ende | `^Failed` |
| `( )` | Gruppe | `(GET|POST)` |
| `(?<name>…)` / `(?P<name>…)` | benannte Gruppe | Feld extrahieren |

## Muster für den Alltag

| Was | Muster (vereinfacht) |
|---|---|
| IPv4-Adresse | `\b(?:\d{1,3}\.){3}\d{1,3}\b` |
| SHA-256 | `\b[a-fA-F0-9]{64}\b` |
| MD5 | `\b[a-fA-F0-9]{32}\b` |
| E-Mail | `[\w.+-]+@[\w-]+\.[\w.-]+` |
| ISO-Zeitstempel | `\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}` |
| SSH-Fehlanmeldung | `Failed password for (?:invalid user )?(\S+) from (\S+)` |

> [!TIPP] Vereinfacht ist oft genug
> Das IPv4-Muster oben akzeptiert auch 999.999.999.999 – für die Suche in Logs ist das meist egal. Für Validierung von Eingaben nutzt man besser fertige Bibliotheken.

## In der Praxis

```bash
grep -Eo '\b([0-9]{1,3}\.){3}[0-9]{1,3}\b' access.log | sort | uniq -c | sort -rn | head
```

```spl
index=linux "Failed password" | rex "for (invalid user )?(?<user>\S+) from (?<src>\S+)" | stats count by src user
```

```python
import re
muster = re.compile(r"Failed password for (?:invalid user )?(?P<user>\S+) from (?P<ip>\S+)")
for zeile in open("auth.log", encoding="utf-8", errors="replace"):
    if m := muster.search(zeile):
        print(m["ip"], m["user"])
```

## Tiefer eingetaucht

Gierig vs. genügsam: `.*` nimmt so viel wie möglich, `.*?` so wenig wie möglich – oft der Grund, warum ein Muster „zu viel“ trifft. Performance: verschachtelte Quantoren wie `(a+)+` können zu katastrophalem Backtracking führen (ReDoS) – in SIEM-Regeln und Anwendungen vermeiden. Zum Testen eignen sich interaktive Regex-Werkzeuge mit Erklärung jedes Bausteins; im Zweifel immer an echten Beispielzeilen prüfen, auch an Zeilen, die **nicht** treffen sollen.

## Quiz

? Wofür steht \d in einem regulären Ausdruck?
+ eine Ziffer
- ein beliebiges Zeichen
- ein Leerzeichen
- ein Buchstabe
! \w steht für Wortzeichen, \s für Leerraum.

? Welches Muster passt auf einen SHA-256-Hash?
+ [a-fA-F0-9]{64}
- [a-z]{8}
- \d{3}
- .{2}
! 64 Hexadezimalzeichen.

? Was bedeutet ^ am Anfang eines Musters?
+ Zeilenanfang
- Zeilenende
- beliebiges Zeichen
- Negation in jedem Kontext
! Innerhalb von [ ] am Anfang bedeutet ^ dagegen Negation.

? Wie extrahiert man in Splunk Felder per Regex?
= rex
! Mit benannten Gruppen (?<name>...).

?tf .*? ist genügsam und trifft so wenig Zeichen wie möglich.
= wahr
! .* ist gierig und trifft so viel wie möglich.

? Welches Risiko bergen verschachtelte Quantoren wie (a+)+?
= ReDoS
= katastrophales Backtracking
! Sie können Systeme durch extreme Rechenzeit blockieren.
