---
id: c-12
title: HTB-Zertifikate im Überblick und Prüfungsstrategie
paths: cjca, cpts, cwes, cdsa, cwee, cape
order: 0.1
difficulty: easy
icon: rosette
summary: Welche HTB-Zertifizierung wofür steht, wie die Prüfungen aufgebaut sind, welche Reihenfolge sinnvoll ist und wie du dich mit NIMA strukturiert vorbereitest.
---

## Die Zertifikate

| Zertifikat | Schwerpunkt | Niveau | Prüfungsform (allgemein) |
|---|---|---|---|
| **CJCA** – Junior Cybersecurity Associate | breiter Einstieg Offensive und Defensive | Einstieg | praktische Aufgaben in einer Lab-Umgebung |
| **CPTS** – Penetration Testing Specialist | interner und externer Pentest inkl. Active Directory | mittel bis fortgeschritten | mehrtägiger realistischer Pentest + kommerzieller Bericht |
| **CWES** (früher CBBH) – Web Exploitation Specialist | Web-Anwendungen | mittel | Web-Pentest + Bericht |
| **CDSA** – Defensive Security Analyst | SOC, SIEM, Incident Response, Forensik | mittel | Untersuchung von Vorfällen + Bericht |
| **CWEE** – Web Exploitation Expert | fortgeschrittene Web-Exploitation, Whitebox, Code-Review | fortgeschritten | anspruchsvolle Web-Ziele + Bericht |
| **CAPE** – Active Directory Pentesting Expert | Active Directory in der Tiefe | fortgeschritten | komplexe AD-Umgebung + Bericht |

> [!WARNUNG] Details ändern sich
> Prüfungsdauer, Voraussetzungen, Preise und Bezeichnungen passt Hack The Box regelmäßig an. Prüfe vor der Buchung immer die aktuelle Beschreibung in der HTB Academy.

## Gemeinsamkeiten der Prüfungen

- Voraussetzung ist der Abschluss des zugehörigen **Job-Role-Paths** in der Academy.
- Die Prüfungen sind **praktisch**: Man arbeitet in einer realistischen Umgebung, nicht mit Multiple Choice.
- Ein **professioneller Bericht** ist Pflicht – siehe [[mod:c-10|Reporting]].
- Es gibt in der Regel einen kostenlosen Wiederholungsversuch mit Feedback.

## Sinnvolle Reihenfolge

1. **Fundament** in NIMA → Netzwerke, Linux, Windows, Web, Kryptografie
2. **CJCA** als Einstieg
3. Spezialisieren: **CPTS** (Offensive allgemein) oder **CDSA** (Defensive) oder **CWES** (Web)
4. Expertenstufe: **CWEE** (Web) oder **CAPE** (Active Directory)

## Lernstrategie mit NIMA

| Woche | Fokus |
|---|---|
| jeden Tag | Tagesziel erfüllen (Streak), fällige Karten im Training wiederholen |
| neues Modul | Lektionen lesen → Karteikarten → Quiz → Begriffe im Lexikon nachschlagen |
| am Wochenende | Pfad-Prüfung als Simulation, Schwachstellen-Modus für Fehler |
| parallel | in der HTB Academy die Labs praktisch lösen und **eigene Notizen** schreiben |

> [!TIPP] Spaced Repetition nutzen
> Karten, die du richtig beantwortest, kommen in immer größeren Abständen wieder (4 Stunden, 1 Tag, 3, 7, 16, 35, 90 Tage). Falsche kommen sofort zurück. So landet Wissen im Langzeitgedächtnis – mit wenigen Minuten pro Tag.

## Prüfungstag

- ausgeschlafen und mit Plan: Zeitbudget pro Phase
- von Anfang an dokumentieren, Screenshots mit Zeitstempel
- regelmäßige Pausen; wer feststeckt, zurück zur Enumeration
- Berichtsvorlage vorher vorbereiten
- Prüfungsregeln (erlaubte Hilfsmittel, Umgang mit Ergebnissen) genau lesen

## Quiz

? Welches HTB-Zertifikat ist der breite Einstieg?
= CJCA

? Welches HTB-Zertifikat ist auf Active Directory auf Expertenniveau spezialisiert?
= CAPE

? Welches HTB-Zertifikat richtet sich an SOC-Analysten?
= CDSA

? Unter welchem Namen führt HTB das CBBH weiter?
= CWES

? Was ist bei allen HTB-Profi-Prüfungen Pflicht?
+ ein professioneller Bericht
- ein Multiple-Choice-Test
- eine mündliche Prüfung
- ein Programmierprojekt

?order Bringe den empfohlenen Lernweg in Reihenfolge
> Fundament
> CJCA
> CPTS, CDSA oder CWES
> CWEE oder CAPE
