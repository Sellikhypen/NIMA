---
id: b-06
title: Der Bug-Bounty-Prozess
paths: cwes
order: 20
difficulty: easy
icon: dollarsign.circle
summary: Wie Bug-Bounty- und Vulnerability-Disclosure-Programme funktionieren, Scope und Regeln lesen, Safe Harbor, einen guten Bericht schreiben, Bewertung und Kommunikation mit Unternehmen.
htb: Bug Bounty Hunting Process
---

## Was ist Bug Bounty?

In einem **Bug-Bounty-Programm** lädt ein Unternehmen Sicherheitsforschende ein, seine Systeme innerhalb klarer Regeln zu prüfen, und zahlt für gültige Meldungen eine Prämie. Ein **Vulnerability Disclosure Program (VDP)** ist das Gleiche ohne Prämie – ein offizieller Meldeweg.

| Plattform | Beispiele |
|---|---|
| Bug-Bounty-Plattformen | HackerOne, Bugcrowd, Intigriti, YesWeHack |
| eigene Programme | große Hersteller mit eigenen Seiten |
| Meldeadresse | `security.txt` unter `/.well-known/security.txt` |

## Regeln lesen – vor allem anderen

| Bestandteil | Bedeutung |
|---|---|
| **In Scope** | erlaubte Domains, Apps, APIs |
| **Out of Scope** | ausdrücklich ausgeschlossene Ziele und Schwachstellenklassen |
| erlaubte Methoden | z. B. keine automatisierten Scans, keine Denial-of-Service-Tests, kein Social Engineering |
| Test-Konten | eigene Konten verwenden, keine Daten anderer Benutzer ansehen oder verändern |
| Safe Harbor | Zusage, bei Einhaltung der Regeln keine rechtlichen Schritte einzuleiten |
| Belohnungstabelle | Prämien nach Schweregrad |

> [!GEFAHR] Außerhalb der Regeln ist es kein Bug Bounty
> Wer Ziele außerhalb des Scopes testet, Daten fremder Benutzer abruft oder Systeme stört, handelt ohne Erlaubnis – mit allen rechtlichen Folgen (siehe [[mod:s-05|Recht]]). Im Zweifel beim Programm nachfragen.

## Ein guter Bericht

| Abschnitt | Inhalt |
|---|---|
| Titel | Schwachstellenklasse + betroffene Funktion |
| Zusammenfassung | 2–3 Sätze: was, wo, welche Auswirkung |
| betroffene Ressource | genaue URL, Parameter, Version |
| Reproduktion | nummerierte, minimale Schritte, die jeder nachvollziehen kann |
| Nachweis | Screenshots, Anfragen/Antworten (ohne fremde Daten) |
| Auswirkung | realistisch und konkret – nicht übertreiben |
| Empfehlung | Vorschlag zur Behebung |

> [!TIPP] Qualität vor Menge
> Klare, reproduzierbare Berichte werden schneller bearbeitet und besser bewertet. Duplikate, Berichte ohne Auswirkung oder automatisch generierte Scanner-Ausgaben schaden dem Ruf.

## Häufig ausgeschlossene „Befunde“

Viele Programme akzeptieren ohne nachgewiesene Auswirkung u. a. nicht: fehlende Sicherheits-Header allein, Clickjacking auf Seiten ohne sensible Aktionen, Versionsangaben in Bannern, Self-XSS, Rate-Limit-Hinweise ohne Missbrauchsszenario, Ergebnisse automatischer Scanner ohne Verifikation.

## Coordinated Disclosure

1. Meldung an den Hersteller bzw. das Programm
2. Bestätigung, Bewertung, Behebung
3. vereinbarte Frist (häufig 90 Tage)
4. Veröffentlichung erst nach Behebung oder Ablauf der Frist und nur mit Zustimmung bzw. nach den Programmregeln

## Quiz

? Was ist ein VDP?
+ ein offizieller Meldeweg für Schwachstellen ohne Prämie
- ein Virenscanner
- ein Pentest-Vertrag
- eine Bug-Bounty-Plattform

? Unter welchem Pfad liegt die security.txt?
= /.well-known/security.txt

? Was bedeutet Safe Harbor?
+ Zusage, bei Einhaltung der Regeln keine rechtlichen Schritte einzuleiten
- eine Prämienstufe
- ein sicherer Server
- eine Verschlüsselungsart

? Was gehört in die Reproduktionsschritte?
+ nummerierte, minimale Schritte, die jeder nachvollziehen kann
- möglichst viele Scanner-Ausgaben
- fremde Benutzerdaten als Beweis
- Vermutungen ohne Nachweis

? Wie lang ist eine häufig vereinbarte Frist bei Coordinated Disclosure?
= 90 Tage
= 90

?tf Ziele außerhalb des Scopes darf man testen, solange man nichts kaputt macht.
= falsch
