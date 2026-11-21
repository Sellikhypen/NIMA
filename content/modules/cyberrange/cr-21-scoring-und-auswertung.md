---
id: cr-21
title: Scoring und Auswertung
paths: cyberrange
order: 21
difficulty: medium
icon: trophy
summary: Kapitel 21 deiner Cyber-Range-Dokumentation: Scoring und Auswertung.
source: Cyber_Range_Dokumentation.docx
htb: 
---

## Überblick

| **Kategorie** | **Messung** | **Gewichtung (Vorschlag)** |
|---|---|---|
| **Verfügbarkeit (SLA)** | Service-Checks alle 60 s: HTTP 200 + Inhalts-Hash (Webshop), SMTP-Banner, DNS-Antwort, SMB-Login mit Testkonto | 30 % |
| **Detektion** | Erkannte ATT&CK-Techniken mit Zeitstempel (Ticket/Bericht), Bonus für frühe Erkennung (MTTD) | 30 % |
| **Reaktion** | Eindämmung, Wiederherstellung, Härtung (MTTR); Abzug bei unnötigen Ausfällen | 20 % |
| **Berichte & Injects** | Qualität von Lagebericht, Meldung, Kommunikation (Bewertung nach Rubrik) | 15 % |
| **Flaggen (optional)** | CTFd-Aufgaben (Forensik-Fragen) | 5 % |

Tabelle 135: Scoring-Modell

**Technische Umsetzung:** Ein Python-Dienst (oder das Open-Source-Projekt ScoringEngine im CCDC-Stil) führt pro Takt Checks aus dem SVC-Netz durch, schreibt Ergebnisse in eine Datenbank und visualisiert sie in Grafana. Die Check-Quelle muss für das Red Team unangreifbar sein (RoE) und für das Blue Team als legitimer Verkehr dokumentiert werden – sonst blockieren Verteidiger versehentlich die eigene Bewertung.

**Service-Check (Pseudocode)**

```
# Pseudocode eines Service-Checks
for team in teams:
    r = http_get(f"https://10.{team}.20.10/", timeout=5, verify=ca_bundle)
    ok = r.status == 200 and sha256(r.body_fragment) == expected_hash
    store(team, check="webshop", ok=ok, ts=now())
    score[team] += 1 if ok else 0
```

## Bewertungsrubrik für Berichte

| **Kriterium** | **0 Punkte** | **1 Punkt** | **2 Punkte** |
|---|---|---|---|
| **Zeitbezug** | keine Zeiten | ungefähre Zeiten | exakte Zeitstempel aus Logs |
| **Betroffene Systeme** | nicht genannt | teilweise | vollständig mit IP/Hostname |
| **Technik** | nicht benannt | beschrieben | korrekt mit ATT&CK-ID |
| **Belege** | keine | Screenshot | Abfrage/Log-Auszug reproduzierbar |
| **Maßnahme** | keine | allgemein | konkret, wirksam, ohne Kollateralschaden |

Tabelle 136: Rubrik zur Bewertung von Vorfallsberichten

## After-Action-Review

Aus den gesicherten Daten (Zeek, Sysmon, SIEM-Alarme, Guacamole-Aufzeichnungen, Tickets) wird ein gemeinsamer Zeitstrahl erstellt: Wann hat das Red Team welche Technik ausgeführt, wann hat das Blue Team sie erkannt (MTTD) und wann eingedämmt (MTTR)? Die Abdeckung wird als Ebene im ATT&CK Navigator dargestellt. Die Nachbesprechung ist ausdrücklich **kein Tribunal**: Ziel ist Lernen, nicht Schuldzuweisung.

## Wie sich der Punktestand über den Tag entwickelt

![Abbildung 61: Beispiel eines Punkteverlaufs für vier Blue Teams](asset:cyberrange/cr-21-061.png)

**So liest man die Abbildung:**

- Die Linien steigen gleichmäßig, solange die **Dienste verfügbar** sind – jeder erfolgreiche Service-Check bringt Punkte.
- **Einbrüche** entstehen durch Dienstausfälle oder erfolgreiche Angriffsziele des Red Teams (z. B. Verschlüsselung bei Blue 3 um 15 Uhr).
- **Sprünge nach oben** folgen auf gute Inject-Antworten und Incident-Berichte (kurz nach den gestrichelten Inject-Linien).
- Für den AAR ist der Verlauf aufschlussreicher als der Endstand: Er zeigt, **wann** ein Team die Kontrolle verloren oder zurückgewonnen hat.
## Die Punkteformel im Detail

| **Komponente** | **Berechnung** | **Anteil (Richtwert)** |
|---|---|---|
| **Verfügbarkeit** | Je Dienst und Check-Intervall (60 s): Punkte bei Erfolg; gewichtet nach Wichtigkeit (Webshop ×3, Mail ×2, Fileserver ×2, Intranet ×1) | 40 % |
| **Incident-Berichte** | Bewertung nach Rubrik (Kapitel 21.1): Vollständigkeit, Richtigkeit, Zeitpunkt | 25 % |
| **Inject-Antworten** | Qualität und Rechtzeitigkeit der Antworten auf White-Team-Injects | 20 % |
| **Abgewehrte Angriffsziele** | Für jedes Red-Team-Ziel, das nicht erreicht wurde (z. B. DCSync verhindert) | 15 % |
| **Abzüge** | Regelverstöße (RoE), abgeschaltete Pflichtdienste, Hinweis-Nutzung | variabel |

Tabelle 137: Bestandteile der Punktewertung

> [!WARNUNG] Fehlanreize vermeiden
> Wenn Verfügbarkeit zu stark gewichtet wird, lassen Teams kompromittierte Systeme lieber laufen; wird sie zu schwach gewichtet, schalten sie einfach alles ab. Deshalb ist das Abschalten eines Pflichtdienstes **teurer** als ein erfolgreicher Angriff – realistische Unternehmen können ihren Webshop auch nicht einfach vom Netz nehmen.

## Service-Checks programmieren

Ein Service-Check prüft nicht nur, ob ein Port offen ist, sondern ob der Dienst **funktioniert** – also die richtige Seite ausliefert, Mails annimmt oder Namen auflöst. Ein minimaler Check in Python (Standardbibliothek):

**service_check.py (Beispiel)**

```
#!/usr/bin/env python3
"""Minimaler Service-Check für score-01 – Ergebnis als JSON für das Scoring."""
import json, smtplib, socket, ssl, time, urllib.request

def check_http(url, needle):
    ctx = ssl.create_default_context(); ctx.check_hostname = False; ctx.verify_mode = ssl.CERT_NONE
    with urllib.request.urlopen(url, timeout=5, context=ctx) as r:
        return r.status == 200 and needle in r.read().decode(errors="ignore")

def check_smtp(host):
    with smtplib.SMTP(host, 25, timeout=5) as s:
        return s.noop()[0] == 250

def check_tcp(host, port):
    with socket.create_connection((host, port), timeout=3):
        return True

CHECKS = {
    "webshop": lambda: check_http("https://10.10.20.10/", "Nordwind Shop"),
    "mail":    lambda: check_smtp("10.10.20.25"),
    "fileserver": lambda: check_tcp("10.10.30.20", 445),
}
result = {"team": 1, "ts": int(time.time())}
for name, fn in CHECKS.items():
    try:
        result[name] = bool(fn())
    except Exception:
        result[name] = False
print(json.dumps(result))
```

## Vorlage für den After-Action-Review

| **Abschnitt** | **Leitfragen** | **Dauer** |
|---|---|---|
| **1. Ziele** | Welche Lernziele hatte die Übung? Was war der Plan? | 5 Min. |
| **2. Was ist passiert?** | Zeitstrahl: Angriffsphasen (Red) neben Erkennungen und Reaktionen (Blue) | 20 Min. |
| **3. Was lief gut?** | Welche Erkennungen und Entscheidungen waren stark? Warum? | 10 Min. |
| **4. Was lief nicht gut?** | Wo gab es Lücken? Fehlende Daten, unklare Rollen, falsche Annahmen? | 15 Min. |
| **5. Warum?** | Ursachen statt Schuldige (Werkzeuge, Prozesse, Wissen, Zeit) | 10 Min. |
| **6. Was ändern wir?** | Konkrete Maßnahmen mit Verantwortlichen und Termin (neue Regel, neues Playbook, Training) | 15 Min. |
| **7. Feedback zur Übung** | Realismus, Schwierigkeit, Organisation, Technik | 5 Min. |

Tabelle 138: Ablauf des After-Action-Reviews (ca. 80 Minuten)

> [!TIPP] Die Red-Team-Perspektive zeigen
> Der wertvollste Teil des AAR ist oft, wenn das Red Team seinen Weg Schritt für Schritt zeigt – inklusive der Stellen, an denen es fast entdeckt worden wäre. Die Gegenüberstellung »Red-Zeitstrahl neben Blue-Zeitstrahl« macht Lücken sofort sichtbar.

## Inject-Antworten bewerten

Nicht-technische Leistungen – Lageberichte, Entscheidungsvorlagen, Meldungen – sind in vielen Übungen der Teil, in dem Teams am meisten lernen. Ihre Bewertung muss genauso nachvollziehbar sein wie die technische. Dafür gibt es eine eigene Rubrik:

| **Kriterium** | **0 Punkte** | **1 Punkt** | **2 Punkte** |
|---|---|---|---|
| **Rechtzeitigkeit** | nach Frist oder gar nicht | knapp in der Frist | deutlich vor der Frist |
| **Adressatengerecht** | Fachjargon, unverständlich für Leitung | teilweise verständlich | klar, kurz, ohne unnötige Fachbegriffe |
| **Lagedarstellung** | fehlt oder falsch | unvollständig | was ist passiert, was ist betroffen, was ist unklar |
| **Optionen und Empfehlung** | keine | eine Option ohne Abwägung | mehrere Optionen mit Vor- und Nachteilen und klarer Empfehlung |
| **Rechtliche Aspekte** | nicht erwähnt | erwähnt | konkret mit Frist (z. B. Datenschutzmeldung binnen 72 Stunden, NIS2-Frühwarnung) |

Tabelle 139: Rubrik für Inject-Antworten

> [!TIPP] Bewertung im Vier-Augen-Prinzip
> Inject-Antworten werden von zwei Evaluatoren unabhängig bewertet. Weichen die Punkte um mehr als zwei voneinander ab, wird die Antwort gemeinsam besprochen. So bleiben Bewertungen auch zwischen Übungen vergleichbar.
