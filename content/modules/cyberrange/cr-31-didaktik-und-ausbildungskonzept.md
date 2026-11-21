---
id: cr-31
title: Didaktik und Ausbildungskonzept
paths: cyberrange
order: 31
difficulty: hard
icon: graduationcap
summary: Kapitel 31 deiner Cyber-Range-Dokumentation: Didaktik und Ausbildungskonzept.
source: Cyber_Range_Dokumentation.docx
htb: Cyber Range 12 · Übungsbetrieb & Didaktik
---

## Überblick

Technik allein macht noch keine gute Ausbildung. Eine Range entfaltet ihren Wert erst, wenn Übungen didaktisch geplant sind: mit klaren Lernzielen, passenden Formaten, sinnvoller Reihenfolge und ehrlicher Auswertung.

## Lernziele nach der Bloom-Taxonomie

![Abbildung 77: Lernziel-Stufen nach Bloom und passende Übungsformen](asset:cyberrange/cr-31-077.png)

**So liest man die Abbildung:**

- Die **Bloom-Taxonomie** ordnet Lernziele von »Erinnern« (unten) bis »Erschaffen« (oben).
- Untere Stufen werden mit Quiz, Erklärungen und geführten Labs trainiert, obere mit offenen Übungen, Analysen und eigenen Entwicklungen.
- Live-Fire-Übungen verlangen vor allem Analysieren, Bewerten und Erschaffen – sie setzen voraus, dass die unteren Stufen sitzen.
| **Schlechtes Lernziel** | **Gutes Lernziel (messbar)** |
|---|---|
| **»Die Teilnehmer kennen Kerberos.«** | »Die Teilnehmer erklären den Ablauf von AS- und TGS-Austausch anhand eines Mitschnitts.« (Verstehen) |
| **»Die Teilnehmer können Phishing erkennen.«** | »Die Teilnehmer identifizieren in 20 Minuten Absender, Empfänger und betroffene Hosts einer Phishing-Welle.« (Analysieren) |
| **»Die Teilnehmer schreiben Regeln.«** | »Die Teilnehmer entwickeln eine Sigma-Regel, die den Testfall erkennt und im Grundrauschen höchstens einen Fehlalarm pro Stunde erzeugt.« (Erschaffen) |

Tabelle 177: Lernziele messbar formulieren

## Bezug zu Kompetenzrahmen: NICE und ECSF

Damit Übungen zu Stellenprofilen und Karrierepfaden passen, werden sie auf anerkannte Kompetenzrahmen abgebildet. In Europa ist das vor allem das **ECSF** der ENISA mit 12 Rollenprofilen, international das **NICE Framework** des NIST (Version 2.0.0 vom März 2025, u. a. mit neuer Rolle für OT-Cybersecurity-Engineering).

| **ECSF-Rollenprofil** | **Passende Range-Formate** |
|---|---|
| **Cyber Incident Responder** | Red vs. Blue, Ransomware- und Phishing-Szenarien, Labs 3–9 |
| **Cyber Threat Intelligence Specialist** | Hunting-Übungen, Auswertung von Indikatoren, AAR-Berichte |
| **Digital Forensics Investigator** | Forensik-Aufgaben nach Übungen (Speicherabbilder, PCAP, Zeitlinien) |
| **Penetration Tester** | Red-Team-Rolle (in eigener, vom White Team betreuter Ausbildung) |
| **Cybersecurity Architect** | Zonenmodell, Härtung, Szenario »Webshop« mit Segmentierungsfrage |
| **Cybersecurity Implementer** | Härtungs-Labs, Detection as Code, Konfiguration von Sensoren |
| **Chief Information Security Officer (CISO)** | Table-Top-Übungen, Krisenstab, Entscheidungs-Injects |
| **Cyber Legal, Policy and Compliance Officer** | Injects zu Meldepflichten (DSGVO, NIS2), Datenschutzfragen |
| **Cybersecurity Risk Manager** | Bewertung von Szenario-Auswirkungen, Risikomatrix |
| **Cybersecurity Auditor** | Prüfung der Range-Härtung, Abnahmeprotokolle |
| **Cybersecurity Educator** | Szenario-Design, Moderation von AARs |
| **Cybersecurity Researcher** | Neue Techniken in der Range erproben, Abdeckungsmatrix erweitern |

Tabelle 178: ECSF-Rollenprofile und passende Übungsformate

## Ausbildungspfad

![Abbildung 78: Ausbildungspfad vom Einzel-Lab zur Großübung](asset:cyberrange/cr-31-078.png)

**So liest man die Abbildung:**

- Der Pfad beginnt mit **geführten Einzel-Labs** und steigert sich über CTF und Table-Top bis zur **Red-vs.-Blue-Übung** und schließlich zur organisationsweiten **Großübung**.
- Jede Stufe nutzt dieselbe Plattform – nur Größe, Teilnehmerzahl und Automatisierung ändern sich.
- Wer eine Stufe überspringt, ist in der nächsten oft überfordert; Einstufungstests helfen, Teilnehmer richtig zuzuordnen.
| **Format** | **Dauer** | **Gruppengröße** | **Schwerpunkt** | **Range-Bedarf** |
|---|---|---|---|---|
| **Geführtes Lab** | 1–2 h | 1–2 Personen | eine Fähigkeit üben | kleine Sandbox (3–6 VMs) |
| **Jeopardy-CTF** | 4–8 h | Teams 2–5 | breites Wissen, spielerisch | CTFd + einzelne Aufgaben-VMs |
| **Attack-Defense-CTF** | 6–8 h | Teams 3–6 | Dienste verteidigen und verstehen | je Team identische Dienste |
| **Table-Top** | 2–3 h | 6–15 Personen | Entscheidungen, Kommunikation | keine Technik nötig |
| **Red vs. Blue** | 1–2 Tage | Teams 4–8 | Erkennen und Reagieren unter Druck | vollständiges Szenario je Team |
| **Purple-Teaming-Runde** | 0,5–1 Tag | Red + Blue gemeinsam | Erkennungslücken schließen | ein Szenario |

Tabelle 179: Übungsformate im Überblick

## Gute Nachbesprechung

- **Psychologische Sicherheit:** Fehler in der Übung sind erwünscht – sie zeigen, wo Lernbedarf besteht. Einzelpersonen werden nicht bloßgestellt.
- **Fakten vor Meinungen:** Der gemeinsame Zeitstrahl (Red neben Blue) ist die Grundlage jeder Diskussion.
- **Ursachen statt Schuld:** Fehlte Wissen, ein Werkzeug, eine Datenquelle, Zeit oder eine klare Rolle?
- **Maßnahmen mit Verantwortlichen:** Jede Erkenntnis endet in einer konkreten Aufgabe mit Termin.
- **Hot-Wash sofort, AAR später:** Direkt nach der Übung kurz Eindrücke sammeln, den ausführlichen AAR mit aufbereiteten Daten ein bis drei Tage später.
## Einstufung und Bewertung von Teilnehmern

Damit Teilnehmer in passende Gruppen kommen und der Lernerfolg messbar wird, kombiniert die Range drei Instrumente. Sie dienen der **Entwicklung**, nicht der Personalbeurteilung (siehe Datenschutz, Kapitel 22.8).

| **Instrument** | **Zeitpunkt** | **Form** | **Nutzen** |
|---|---|---|---|
| **Einstufungstest** | vor dem ersten Kurs | 20–30 Minuten: Quiz + kleine praktische Aufgabe in einer Sandbox | Zuordnung zu Stufe 1–5 des Ausbildungspfads |
| **Lab-Erfolgskriterien** | nach jedem Labor | automatische Prüfung (Kapitel 32) | Fortschritt pro Fähigkeit |
| **Übungsrubriken** | nach Übungen | Berichte und Inject-Antworten nach Rubrik (Kapitel 21.1, 21.7) | Teamleistung, Entwicklungsfelder |
| **Selbsteinschätzung** | vor und nach einem Kurs | Fragebogen je Lernziel (1–5) | zeigt Lernzuwachs aus Teilnehmersicht |

Tabelle 180: Instrumente zur Einstufung und Bewertung

> [!INFO] Lernzuwachs sichtbar machen
> Der aussagekräftigste Wert ist der **Unterschied** zwischen Vorher und Nachher – etwa: Vor dem Kurs fanden 3 von 10 Teilnehmern den Beacon in Labor 8 innerhalb von 60 Minuten, danach 8 von 10. Solche Zahlen überzeugen Entscheider mehr als jede Teilnehmerzufriedenheit.
