---
id: cr-23
title: Detection Engineering und Purple Teaming
paths: cyberrange
order: 23
difficulty: hard
icon: eye
summary: Kapitel 23 deiner Cyber-Range-Dokumentation: Detection Engineering und Purple Teaming.
source: Cyber_Range_Dokumentation.docx
htb: 
---

## Überblick

Eine Range ist der ideale Ort, um Erkennung **systematisch** zu verbessern: Angriffe lassen sich beliebig oft, kontrolliert und ohne Risiko wiederholen. Daraus entstehen zwei eng verwandte Arbeitsweisen: **Detection Engineering** – die ingenieurmäßige Entwicklung von Detektionsregeln – und **Purple Teaming** – die offene Zusammenarbeit von Angreifern und Verteidigern.

## Vom Wettkampf zur Zusammenarbeit

In einer klassischen Red-vs.-Blue-Übung arbeiten beide Seiten gegeneinander und erfahren erst im AAR, was die andere getan hat. Das ist gut, um Stress und Entscheidungen zu üben – aber ineffizient, um Erkennungslücken zu schließen. Beim Purple Teaming sitzen beide Seiten zusammen: Das Red Team führt **eine** Technik aus, nennt den genauen Zeitpunkt, und das Blue Team prüft sofort, ob und wie sie sichtbar war.

![Abbildung 62: Purple-Teaming-Schleife zwischen Red, Blue und gemeinsamer Auswertung](asset:cyberrange/cr-23-062.png)

**So liest man die Abbildung:**

- Die drei Zeilen sind **Red**, **Gemeinsam** und **Blue**; jede Spalte ist ein Arbeitsschritt, der von allen gleichzeitig bearbeitet wird.
- Zuerst wird eine Technik gewählt und ein **Erfolgskriterium** vereinbart (z. B. »Alarm innerhalb von 5 Minuten mit korrektem Host«).
- Nach der Ausführung prüft das Blue Team live, ob ein Alarm entstand – **ja, nein oder zu spät**.
- Lücken werden analysiert, die Regel wird angepasst und als **Regressionstest** automatisiert. Das Ergebnis fließt in die Abdeckungsmatrix.
| **Merkmal** | **Red vs. Blue** | **Purple Teaming** |
|---|---|---|
| **Ziel** | Leistung unter realistischen Bedingungen prüfen | Erkennungslücken finden und schließen |
| **Informationsfluss** | verdeckt bis zum AAR | offen, in Echtzeit |
| **Tempo** | durch Szenario vorgegeben | Technik für Technik, beliebig wiederholbar |
| **Ergebnis** | Bewertung der Teams, Lessons Learned | neue/verbesserte Regeln, Abdeckungsmatrix |
| **Geeignet für** | Ausbildung, Leistungsnachweis, Stresstraining | SOC-Weiterentwicklung, Tool-Evaluierung |

Tabelle 148: Red vs. Blue und Purple Teaming im Vergleich

## Detection as Code

Detektionsregeln werden wie Software behandelt: Sie liegen versioniert in Git, werden per Pull Request geprüft, automatisch getestet und über eine Pipeline in die SIEM-Systeme verteilt. Das Format der Wahl ist Sigma, weil es herstellerneutral ist und in die Abfragesprachen von Elasticsearch, Wazuh, Splunk und anderen übersetzt werden kann.

**Struktur eines Detection-as-Code-Repositorys**

```
detections/
├── rules/
│   ├── windows/
│   │   ├── cred_access_kerberoast_rc4.yml
│   │   ├── cred_access_lsass_access.yml
│   │   └── persistence_new_service.yml
│   ├── network/
│   │   └── exfil_dns_long_labels.yml
│   └── linux/
│       └── webshell_spawn_shell.yml
├── tests/
│   ├── positive/            # Beispiel-Logs, bei denen die Regel anschlagen MUSS
│   └── negative/            # Beispiel-Logs aus Normalbetrieb, die NICHT anschlagen dürfen
├── mappings/
│   └── attack_coverage.csv  # Regel → ATT&CK-Technik → Datenquelle
└── .gitea/workflows/detections.yaml   # Lint, Konvertierung, Tests, Deployment
```

**Sigma-Regel mit Ausnahmen (Filter) gegen Fehlalarme**

```
title: Kerberos-Dienstticket mit RC4-Verschlüsselung (mögliches Kerberoasting)
id: 0f5c2a7e-6b1d-4f0a-9e1b-2c3d4e5f6a7b
status: test
description: Erkennt Dienstticket-Anfragen mit RC4 (0x17) für Benutzerkonten mit SPN.
references:
  - https://attack.mitre.org/techniques/T1558/003/
tags:
  - attack.credential-access
  - attack.t1558.003
logsource:
  product: windows
  service: security
detection:
  selection:
    EventID: 4769
    TicketEncryptionType: '0x17'
    Status: '0x0'
  filter_machine_accounts:
    ServiceName|endswith: '$'
  filter_krbtgt:
    ServiceName: 'krbtgt'
  condition: selection and not 1 of filter_*
falsepositives:
  - Altanwendungen, die nur RC4 unterstützen
level: high
```

Die Konvertierung in die Zielsysteme übernimmt das Werkzeug **sigma-cli** (Projekt pySigma) mit passenden Backends und Pipelines. In der Pipeline wird jede Regel gegen die Beispiel-Logs in `tests/` geprüft: Eine Regel, die ihre positiven Beispiele nicht erkennt oder bei negativen anschlägt, wird nicht ausgerollt.

## Abdeckung messen

Die zentrale Frage des Detection Engineerings lautet: **Welche Angriffstechniken würden wir bemerken – und welche nicht?** Die Antwort liefert eine Abdeckungsmatrix, die nach jeder Purple-Teaming-Runde aktualisiert wird.

![Abbildung 63: Detektionsabdeckung je ATT&CK-Taktik und Datenquelle (Beispiel)](asset:cyberrange/cr-23-063.png)

**So liest man die Abbildung:**

- **Spalten** sind die Taktiken von ATT&CK – also die Ziele eines Angreifers vom Erstzugriff bis zur Wirkung.
- **Zeilen** sind die Datenquellen und Regelwerke der Range.
- Die **Farbe** zeigt, wie gut Techniken dieser Taktik mit dieser Quelle erkannt werden: von »keine« (grau) bis »gut« (grün).
- Lücken sind deutlich: »Collection« und »Exfiltration« sind auf Host-Ebene schwach abgedeckt – dort setzt die nächste Runde an.
> [!INFO] Was sich mit ATT&CK v18 geändert hat
> Seit Version 18 (Oktober 2025) beschreibt ATT&CK die Erkennung nicht mehr als Freitext in den Techniken, sondern über eigene Objekte: **Detection Strategies** (grundsätzlicher Ansatz) und **Analytics** (plattformspezifische Logik), verknüpft mit **Data Components**. Die bisherigen »Data Sources« wurden abgekündigt. Laut Release Notes enthält Enterprise ATT&CK v18 u. a. 14 Taktiken, 216 Techniken, 475 Sub-Techniken, 691 Detection Strategies und 1.739 Analytics. Für die Range bedeutet das: Die Abdeckungsmatrix sollte auf Data Components aufbauen, weil sie direkt zeigen, welche Telemetrie fehlt.

| **Kennzahl** | **Definition** | **Ziel (Beispiel)** |
|---|---|---|
| **Technik-Abdeckung** | Anteil der Szenario-Techniken mit mindestens einer getesteten Regel | > 80 % |
| **Erkennungsrate** | Anteil der ausgeführten Tests, die einen Alarm erzeugten | > 90 % (Regressionstests) |
| **MTTD in Übungen** | Zeit von Ausführung bis Alarm bzw. Meldung | < 15 Min. für kritische Techniken |
| **Fehlalarmquote** | Fehlalarme pro Regel und Woche im Grundrauschen der NPCs | < 1 |
| **Verpasste Angriffe** | Ausgeführte Techniken ohne jede Spur in den Daten | 0 (sonst Datenquelle ergänzen) |
| **Regel-Alter** | Zeit seit letzter Überprüfung einer Regel | < 12 Monate |

Tabelle 149: Kennzahlen des Detection Engineerings

## Werkzeuge für das Nachstellen von Techniken

Damit Purple-Teaming-Runden reproduzierbar sind, werden Techniken nicht von Hand, sondern mit Werkzeugen ausgeführt, die genau protokollieren, was wann geschah. Alle Werkzeuge laufen ausschließlich innerhalb der Range und werden vom White Team freigegeben.

| **Werkzeug** | **Ansatz** | **Stärken** | **Einsatz in der Range** |
|---|---|---|---|
| **Atomic Red Team** | Bibliothek kleiner Einzeltests je ATT&CK-Technik | sehr breite Abdeckung, einfach, gut dokumentiert | Regressionstests für Regeln |
| **Caldera (MITRE)** | Agenten und Operationen nach Angreiferprofilen | Ketten mehrerer Techniken, Automatisierung | Szenario-Automatisierung (Kapitel 20.4) |
| **Eigene Szenario-Skripte** | für das Szenario geschriebene, harmlose Simulationen | volle Kontrolle, ungefährlich (z. B. simulierte Verschlüsselung) | Impact-Phasen |
| **Log-Replay** | Abspielen aufgezeichneter Ereignisse ins SIEM | kein Angriff nötig, deterministisch | Unit-Tests für Regeln |

Tabelle 150: Werkzeuge für Purple Teaming

> [!TIPP] Ergebnis jeder Runde festhalten
> Pro getesteter Technik wird ein Datensatz gespeichert: Technik-ID, Werkzeug und Testvariante, Ausführungszeitpunkt, erzeugte Telemetrie (welche Data Components), Alarm ja/nein/spät, verantwortliche Regel, offene Maßnahme. Aus diesen Datensätzen entsteht automatisch die Abdeckungsmatrix.

## Threat Hunting in der Range

Threat Hunting ist die Suche nach Angreifern, die von Regeln **noch nicht** erkannt werden. In der Range wird es als eigene Übungsform trainiert: Das Red Team hinterlässt vorab (ohne Alarm) Spuren im System, das Blue Team erhält nur eine Hypothese und einen Zeitraum.

| **Hypothese (Beispiel)** | **Datenbasis** | **Mögliche Suchansätze** |
|---|---|---|
| **Ein Angreifer nutzt geplante Aufgaben zur Persistenz.** | Sysmon 1, Security 4698, Registry | Neue Aufgaben außerhalb von Software-Verteilungszeiten, ungewöhnliche Pfade (Benutzerprofile, Temp) |
| **Es gibt einen verdeckten C2-Kanal.** | Zeek conn.log, ssl.log, dns.log | Verbindungen mit sehr regelmäßigen Intervallen, seltene Ziele, kleine gleichförmige Datenmengen |
| **Zugangsdaten wurden missbraucht.** | Security 4624/4648, Kerberos-Logs | Anmeldungen zu untypischen Zeiten, von untypischen Hosts, neue Kombinationen Benutzer–Host |
| **Daten wurden gesammelt.** | SMB-Logs, Sysmon 11 | Ungewöhnlich viele Dateizugriffe, Archive in Temp-Verzeichnissen |

Tabelle 151: Hypothesen für Hunting-Übungen

## Reifegrad der Erkennung bestimmen

Bevor neue Regeln geschrieben werden, lohnt sich eine ehrliche Standortbestimmung: Wie weit ist die Erkennungsfähigkeit des Blue Teams entwickelt? Ein einfaches **Reifegradmodell** mit fünf Stufen hilft, das nächste sinnvolle Ziel zu wählen – und verhindert, dass ein Team an ausgefeilten Regeln arbeitet, während grundlegende Datenquellen fehlen.

| **Stufe** | **Bezeichnung** | **Merkmale** | **Nächster Schritt** |
|---|---|---|---|
| **0** | Blind | keine zentrale Sammlung von Logs, keine Netzsicht | Wazuh-Agenten und Mirror einrichten |
| **1** | Sammeln | Logs und Netzdaten zentral vorhanden, aber kaum Regeln | Audit-Richtlinien und Sysmon vervollständigen, Standardregeln aktivieren |
| **2** | Erkennen | Standardregeln aktiv, viele Fehlalarme, wenig Abdeckungswissen | Abdeckungsmatrix erstellen, Fehlalarme reduzieren |
| **3** | Gezielt erkennen | eigene Regeln für Szenario-Techniken, Tests vorhanden | Detection as Code, Regressionstests |
| **4** | Messen und verbessern | Kennzahlen (MTTD, Abdeckung) werden regelmäßig erhoben und verbessert | Purple Teaming als fester Rhythmus, Hunting |

Tabelle 152: Reifegradmodell der Erkennung

> [!TIPP] Ehrlichkeit vor Ehrgeiz
> Ein Team auf Stufe 1 profitiert mehr von einer vollständigen Datenbasis als von zehn neuen Regeln. Die Range macht den Reifegrad messbar: Wenn eine Technik ausgeführt wird und **keinerlei** Spuren in den Daten hinterlässt, fehlt eine Datenquelle – keine Regel.
