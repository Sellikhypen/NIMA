---
id: de-01
title: Detection Engineering 1 · Der Lebenszyklus einer Erkennung
paths: cdsa, specialist, cyberrange
order: 32.1
difficulty: medium
icon: sensor.tag.radiowaves.forward.fill
tags: detection engineering, soc
summary: Von der Idee zur produktiven Regel – Anforderungen, Datenquellen, Logik, Tests, Tuning, Dokumentation und Wartung als wiederholbarer Prozess.
---

## Einfach erklärt

Eine Erkennungsregel ist wie ein Rauchmelder: Er muss an der richtigen Stelle hängen (Datenquelle), auf das Richtige reagieren (Logik), darf nicht bei jedem Toast losgehen (Tuning) und muss regelmäßig getestet werden. **Detection Engineering** macht aus dem Aufhängen von Rauchmeldern einen sauberen Ingenieursprozess.

## Der Lebenszyklus

1. **Anforderung**: Welche Technik/welches Risiko soll erkannt werden? (z. B. ATT&CK T1003.001 LSASS-Zugriff)
2. **Datenquellen prüfen**: Haben wir die nötige Telemetrie? (Sysmon 10, EDR)
3. **Logik entwickeln**: Abfrage oder Sigma-Regel.
4. **Testen**: Technik im Labor ausführen (z. B. mit Atomic Red Team) – feuert die Regel? Auch gegen Normalbetrieb prüfen – wie viele Fehlalarme?
5. **Dokumentieren**: Zweck, Annahmen, bekannte Fehlalarme, Reaktionsschritte (Triage-Anleitung).
6. **Ausrollen**: zuerst als „Hunting“/niedrige Priorität, dann produktiv.
7. **Überwachen und tunen**: Fehlalarmrate, Trefferqualität.
8. **Regelmäßig revalidieren**: Funktioniert sie nach Updates noch?

> [!MERKE] Detection as Code
> Regeln in Git, mit Review, automatischen Tests und Deployment per Pipeline – wie Software. So bleiben sie nachvollziehbar und wartbar.

## Qualitätsmerkmale

| Merkmal | Frage |
|---|---|
| Präzision | Wie viele Alarme sind echt? |
| Abdeckung | Welche Varianten der Technik werden erkannt? |
| Robustheit | Umgeht ein einfacher Namenswechsel die Regel? |
| Handlungsfähigkeit | Weiß der Analyst, was zu tun ist? |
| Kosten | Wie teuer ist die Abfrage? |

## Tiefer eingetaucht

Robuste Regeln setzen auf **Verhalten**, nicht auf leicht änderbare Merkmale: Statt `Image endswith "mimikatz.exe"` lieber „Prozess mit ungewöhnlichem Pfad öffnet LSASS mit Lesezugriff“. Mehrere schwache Signale lassen sich zu einem starken kombinieren (**Risk-based Alerting**: jedes Signal erhöht einen Risikowert pro Nutzer/Host, erst über einer Schwelle entsteht ein Alarm).

Abdeckung visualisieren: ATT&CK-Navigator-Layer mit getesteten Erkennungen zeigt Lücken. Wichtig ist Ehrlichkeit: „Regel vorhanden“ ist nicht „Technik erkannt“ – nur getestete Regeln zählen.

## Quiz

? Was ist der erste Schritt im Lebenszyklus einer Erkennung?
+ die Anforderung klären, welche Technik erkannt werden soll
- die Regel sofort produktiv schalten
- Logs löschen
- ein neues SIEM kaufen
! Ohne klares Ziel entsteht keine gute Regel.

? Wie testet man, ob eine Regel bei einer Technik auslöst?
+ die Technik kontrolliert im Labor ausführen, z. B. mit Atomic Red Team
- abwarten, bis ein echter Angriff kommt
- die Regel ausdrucken
- den Hersteller fragen
! Nur getestete Regeln zählen als Abdeckung.

? Wie nennt man es, Erkennungsregeln wie Software in Git mit Review und Tests zu verwalten?
= Detection as Code
! So bleiben Regeln nachvollziehbar und wartbar.

?tf Regeln, die nur auf Dateinamen basieren, sind besonders robust.
= falsch
! Dateinamen lassen sich trivial ändern – Verhalten ist robuster.

? Was macht Risk-based Alerting?
+ es summiert schwache Signale pro Entität und alarmiert erst über einer Schwelle
- es löscht alle Alarme mit niedrigem Risiko
- es alarmiert bei jedem Ereignis
- es bewertet nur Schwachstellen
! So entstehen weniger, aber aussagekräftigere Alarme.

? Was gehört in die Dokumentation einer Regel?
+ Zweck und Annahmen
+ bekannte Fehlalarme
+ Triage-Anleitung
- das Lieblingsessen des Autors
! Analysten brauchen Kontext, um schnell zu entscheiden.

@@@ MODULE @@@
---
id: de-02
title: Detection Engineering 2 · Sigma-Regeln schreiben
paths: cdsa
order: 32.2
difficulty: medium
icon: doc.badge.ellipsis
tags: sigma, detection engineering
summary: Aufbau einer Sigma-Regel, Logsource, Selection und Condition, Modifier, Fehlalarm-Filter und Konvertierung in SIEM-Abfragen.
---

## Einfach erklärt

Jedes SIEM hat seine eigene Abfragesprache – SPL, KQL, EQL … **Sigma** ist ein gemeinsames Format für Erkennungsregeln, das man einmal schreibt und in viele Sprachen übersetzen kann. Wie eine Rezeptkarte, die jede Küche nachkochen kann.

## Aufbau

```yaml
title: Office-Anwendung startet Skript-Interpreter
id: 3f1c8a2e-0000-4000-8000-000000000001
status: experimental
description: Erkennt Word/Excel/PowerPoint, die PowerShell, cmd oder wscript starten
references:
  - https://attack.mitre.org/techniques/T1204/002/
tags:
  - attack.execution
  - attack.t1204.002
logsource:
  category: process_creation
  product: windows
detection:
  selection_parent:
    ParentImage|endswith:
      - '\winword.exe'
      - '\excel.exe'
      - '\powerpnt.exe'
  selection_child:
    Image|endswith:
      - '\powershell.exe'
      - '\cmd.exe'
      - '\wscript.exe'
      - '\mshta.exe'
  condition: selection_parent and selection_child
falsepositives:
  - Legitime Makros in Fachabteilungen
level: high
```

## Wichtige Elemente

| Element | Bedeutung |
|---|---|
| `logsource` | welche Daten (Kategorie, Produkt, Dienst) |
| `detection` | benannte Auswahlblöcke |
| Modifier | `contains`, `startswith`, `endswith`, `re`, `all`, `base64offset` |
| `condition` | Verknüpfung: `and`, `or`, `not`, `1 of selection_*` |
| `level` | informational bis critical |

> [!TIPP] Fehlalarme ausdrücklich filtern
> Bekannte, legitime Fälle als eigenen Block (`filter_…`) definieren und mit `and not filter_…` ausschließen – so bleibt sichtbar, was warum ausgenommen wurde.

## Tiefer eingetaucht

Konvertierung mit **pySigma**/`sigma-cli` in das Zielformat (Splunk, Elastic, Microsoft Sentinel u. a.), passend zum eigenen Feld-Mapping (Pipelines). Die öffentliche Sigma-Regelsammlung enthält tausende Regeln – ein guter Startpunkt, aber jede Regel muss an die eigene Umgebung angepasst und getestet werden.

Neuere Sigma-Funktionen: **Correlation Rules** (z. B. „mehr als 10 Fehlanmeldungen gefolgt von einer erfolgreichen in 5 Minuten“) und **Filters** als separate Dateien für umgebungsspezifische Ausnahmen.

## Quiz

? Wozu dient Sigma?
+ ein einheitliches Format für Erkennungsregeln, das in viele SIEM-Sprachen übersetzt wird
- ein Virenscanner
- eine Programmiersprache für Malware
- ein Backup-Format
! Einmal schreiben, überall nutzen.

? Welches Feld beschreibt, aus welchen Daten eine Sigma-Regel liest?
= logsource
! Kategorie, Produkt und Dienst.

? Welcher Modifier prüft, ob ein Wert mit einer Zeichenfolge endet?
= endswith
= |endswith
! Weitere: contains, startswith, re.

?tf Bekannte Fehlalarme sollten als eigener Filterblock ausgeschlossen werden.
= wahr
! So bleibt nachvollziehbar, was warum ausgenommen ist.

? Mit welchem Werkzeug konvertiert man Sigma-Regeln in SIEM-Abfragen?
= sigma-cli
= pySigma
! Mit Pipelines für das eigene Feld-Mapping.

? Was bedeutet `1 of selection_*` in einer Condition?
+ mindestens einer der Blöcke, deren Name mit selection_ beginnt, muss zutreffen
- genau ein Ereignis
- alle Blöcke müssen zutreffen
- die Regel feuert nur einmal
! Praktisch für alternative Muster.

@@@ MODULE @@@
---
id: de-03
title: Detection Engineering 3 · Adversary Emulation und Atomic Tests
paths: cdsa, cyberrange
order: 32.3
difficulty: medium
icon: figure.fencing
tags: purple team, emulation, testing
summary: Wie man Angreifertechniken kontrolliert nachstellt, um Erkennungen zu prüfen – Atomic Red Team, Caldera, Testpläne und sichere Durchführung.
---

## Einfach erklärt

Einen Rauchmelder testet man mit Testspray, nicht mit einem echten Brand. **Adversary Emulation** ist das Testspray der IT-Sicherheit: Angreifertechniken werden kontrolliert und harmlos nachgestellt, um zu prüfen, ob die Verteidigung reagiert.

## Werkzeuge

| Werkzeug | Ansatz |
|---|---|
| Atomic Red Team | kleine Einzeltests pro ATT&CK-Technik („Atomics“) |
| MITRE Caldera | automatisierte Abläufe mehrerer Techniken (Operationen) |
| Emulationspläne (z. B. MITRE CTID) | realistische Abläufe bekannter Gruppen |
| Eigene Skripte | genau zugeschnitten auf die Umgebung |

## Ein Testplan

| Feld | Beispiel |
|---|---|
| Technik | T1003.001 – LSASS Memory |
| Test | Zugriff auf LSASS mit Lesedurchgriff über ein Testwerkzeug |
| Erwartete Telemetrie | Sysmon 10, EDR-Ereignis |
| Erwartete Erkennung | Regel „Ungewöhnlicher LSASS-Zugriff“ |
| Ergebnis | erkannt / nur protokolliert / nicht sichtbar |
| Maßnahme | Regel anpassen, Logquelle ergänzen |

> [!GEFAHR] Sicher durchführen
> Tests nur mit Freigabe, in definierten Systemen und Zeitfenstern, mit Aufräumschritten. Das SOC muss wissen, dass getestet wird – oder es ist ausdrücklich ein unangekündigter Test mit eingeweihter Leitung.

## Ergebnisse auswerten

Drei mögliche Ergebnisse pro Test:

1. **Nicht sichtbar** → Datenquelle fehlt (Logging/Sensor nachrüsten).
2. **Sichtbar, kein Alarm** → Erkennungslogik fehlt (Regel bauen).
3. **Alarm** → Qualität prüfen (Priorität, Kontext, Reaktion).

## Tiefer eingetaucht

Regelmäßige, automatisierte Tests (**Breach and Attack Simulation** oder eigene Pipelines) erkennen, wenn Erkennungen durch Änderungen still kaputtgehen – etwa wenn ein Agent-Update Feldnamen ändert. Ein gepflegtes Ergebnis-Dashboard (pro Technik: getestet am, Ergebnis) macht den Reifegrad sichtbar und ist eine hervorragende Grundlage für Gespräche mit der Leitung.

## Quiz

? Was ist Adversary Emulation?
+ kontrolliertes Nachstellen von Angreifertechniken zur Prüfung der Verteidigung
- ein echter Angriff ohne Erlaubnis
- ein Virenscan
- eine Firewall-Regel
! Wie Testspray für Rauchmelder.

? Welches Werkzeug bietet kleine Einzeltests pro ATT&CK-Technik?
= Atomic Red Team
! Jeder Test heißt „Atomic“.

? Welches MITRE-Werkzeug automatisiert Abläufe mehrerer Techniken?
= Caldera
= MITRE Caldera
! Es führt sogenannte Operationen aus.

? Was bedeutet das Ergebnis „sichtbar, aber kein Alarm“?
+ die Telemetrie ist da, es fehlt die Erkennungslogik
- die Datenquelle fehlt
- die Erkennung ist perfekt
- der Test war illegal
! Nächster Schritt: Regel bauen.

?tf Emulationstests sollten nur mit Freigabe und in definierten Zeitfenstern stattfinden.
= wahr
! Sonst drohen Fehlalarme oder Betriebsstörungen.

? Warum sollte man Erkennungen regelmäßig automatisiert testen?
+ weil Änderungen sie unbemerkt unwirksam machen können
- weil Tests Lizenzkosten senken
- weil Regeln sonst verfallen wie Lebensmittel
- weil es gesetzlich verboten ist, es nicht zu tun
! Z. B. geänderte Feldnamen nach Agent-Updates.

@@@ MODULE @@@
---
id: de-04
title: Detection Engineering 4 · Baselines und Anomalieerkennung
paths: cdsa
order: 32.4
difficulty: hard
icon: chart.xyaxis.line
tags: anomalie, statistik, hunting
summary: Wie man „normal“ beschreibt, um Ungewöhnliches zu finden – Häufigkeit, Seltenheit, Zeitmuster, Peer-Gruppen und die Grenzen von Machine Learning.
---

## Einfach erklärt

Ein Nachbar, der jeden Morgen um 7 Uhr joggt, fällt niemandem auf. Läuft er plötzlich um 3 Uhr nachts mit einem Fernseher unter dem Arm los, schon. **Anomalieerkennung** lernt, was normal ist, und meldet Abweichungen. Das Schwierige: „Ungewöhnlich“ heißt nicht automatisch „bösartig“.

## Arten von Baselines

| Ansatz | Beispiel |
|---|---|
| Seltenheit (Stack Counting) | Prozess läuft nur auf 1 von 5.000 Rechnern |
| Erstmaligkeit | Nutzer meldet sich zum ersten Mal an Server X an |
| Volumen | Upload 50× größer als der Durchschnitt des Nutzers |
| Zeit | Admin-Aktivität um 3 Uhr bei sonst reinen Bürozeiten |
| Peer-Gruppe | Buchhalterin greift auf Entwickler-Repositories zu |
| Sequenz | ungewöhnliche Reihenfolge von Aktionen |

## Stack Counting in der Praxis

```spl
index=sysmon EventCode=1 earliest=-7d
| stats dc(host) as hosts count by Image
| where hosts <= 2
| sort hosts
```

Programme, die nur auf ein, zwei Rechnern laufen, sind seltene Ausreißer – ideal für Hunting.

> [!MERKE] Anomalie ≠ Angriff
> Neue Software, Projektarbeit, Urlaubsvertretung: Vieles ist ungewöhnlich und harmlos. Anomalien sind **Hinweise für Hunting** oder Bausteine für Risk-based Alerting – selten allein ein guter Alarm.

## Tiefer eingetaucht

UEBA-Systeme (User and Entity Behavior Analytics) automatisieren Baselines pro Nutzer und Gerät mit statistischen Verfahren und Machine Learning. Fallstricke:

- **Vergiftete Baseline**: Ist ein Angreifer schon lange aktiv, ist sein Verhalten „normal“.
- **Konzeptdrift**: Normalität ändert sich (neue Tools, Homeoffice).
- **Erklärbarkeit**: Analysten müssen verstehen, warum etwas auffällig ist.

Pragmatisch funktionieren oft einfache Statistiken (Median, Perzentile, Häufigkeiten) mit gutem Kontext besser als komplexe Modelle ohne Erklärung.

## Quiz

? Was ist Stack Counting?
+ Häufigkeiten über viele Systeme zählen, um seltene Ausreißer zu finden
- Stapelspeicher analysieren
- Passwörter zählen
- Server stapeln
! Seltenes ist oft interessant.

?tf Jede Anomalie ist ein Angriff.
= falsch
! Anomalien sind Hinweise, die Kontext und Prüfung brauchen.

? Was ist eine vergiftete Baseline?
+ eine Baseline, die bereits Angreiferverhalten als normal gelernt hat
- eine Baseline mit zu wenig Daten
- eine verschlüsselte Baseline
- eine Baseline in einer falschen Zeitzone
! Lang andauernde Kompromittierungen werden so unsichtbar.

? Wofür steht UEBA?
= User and Entity Behavior Analytics
! Verhaltensanalyse von Nutzern und Geräten.

? Was beschreibt eine Peer-Gruppen-Analyse?
+ Vergleich eines Nutzers mit Kollegen in ähnlicher Rolle
- Vergleich von zwei Servern im gleichen Rack
- Vergleich von Passwortlängen
- Vergleich von Logformaten
! Eine Buchhalterin, die wie ein Entwickler agiert, fällt auf.

@@@ MODULE @@@
---
id: ti-01
title: Threat Intelligence 1 · Arten, Quellen und der Intelligence-Zyklus
paths: cdsa, specialist
order: 33.1
difficulty: easy
icon: globe.americas.fill
tags: threat intelligence
summary: Strategische, operative, taktische und technische Threat Intelligence, gute Quellen und der Zyklus von der Anforderung bis zum Feedback.
---

## Einfach erklärt

Threat Intelligence ist wie der Wetterbericht für Cyberangriffe: Welche „Unwetter“ ziehen auf, welche Regionen (Branchen) sind betroffen, und wie schützt man sich? Ein Wetterbericht ist nur nützlich, wenn er für **deinen Ort** gilt und rechtzeitig kommt – genau so muss Threat Intelligence **relevant** und **handlungsorientiert** sein.

## Vier Ebenen

| Ebene | Publikum | Beispiel |
|---|---|---|
| Strategisch | Geschäftsleitung | „Ransomware-Gruppen zielen verstärkt auf Maschinenbau in der DACH-Region.“ |
| Operativ | Sicherheitsleitung, IR | „Gruppe X nutzt aktuell VPN-Lücken als Einstieg.“ |
| Taktisch | SOC, Detection Engineers | TTPs: „Nutzt geplante Aufgaben zur Persistenz, rclone zur Exfiltration.“ |
| Technisch | Werkzeuge | IOCs: Hashes, IPs, Domains |

## Der Intelligence-Zyklus

1. **Anforderungen** – Welche Fragen soll TI beantworten? (Priority Intelligence Requirements)
2. **Sammlung** – Quellen anzapfen.
3. **Verarbeitung** – normalisieren, deduplizieren.
4. **Analyse** – bewerten, einordnen, Schlussfolgerungen.
5. **Verteilung** – passend fürs Publikum.
6. **Feedback** – War es nützlich? Anforderungen anpassen.

## Quellen

- Öffentliche Berichte von Herstellern und Behörden (z. B. BSI, CISA, ENISA)
- CERT-Warnungen, Branchen-ISACs
- Open-Source-Feeds, Communitys (z. B. MISP-Communitys)
- Kommerzielle Anbieter
- **Eigene Vorfälle** – die wertvollste und am meisten unterschätzte Quelle

> [!MERKE] Relevanz vor Menge
> Hunderttausende IOCs ohne Kontext erzeugen nur Rauschen. Eine gut begründete Aussage zu einer relevanten Gruppe ist mehr wert.

## Tiefer eingetaucht

Bewertung von Informationen: Zuverlässigkeit der Quelle und Glaubwürdigkeit der Information (z. B. Admiralty Code A1–F6). Weitergabe mit dem **Traffic Light Protocol** (TLP:CLEAR, GREEN, AMBER, AMBER+STRICT, RED) regelt, mit wem man teilen darf. Werkzeuge: Threat-Intelligence-Plattformen (z. B. MISP, OpenCTI), Formate wie **STIX/TAXII** für den automatisierten Austausch.

## Quiz

? Welche TI-Ebene richtet sich an die Geschäftsleitung?
= strategisch
= strategische
! Sie beschreibt Trends und Risiken auf Geschäftsebene.

? Was sind IOCs?
+ technische Indikatoren wie Hashes, IPs und Domains
- Abkürzung für Informationssicherheitsleitlinien
- Firewall-Regeln
- Organigramme
! Indicators of Compromise.

?order Bringe den Intelligence-Zyklus in die richtige Reihenfolge.
> Anforderungen
> Sammlung
> Verarbeitung
> Analyse
> Verteilung
> Feedback
! Danach beginnt der Zyklus erneut.

? Wofür steht TLP?
= Traffic Light Protocol
! Es regelt die erlaubte Weitergabe von Informationen.

?tf Eigene Vorfälle sind eine wertvolle Quelle für Threat Intelligence.
= wahr
! Sie sind garantiert relevant für die eigene Umgebung.

? Welche Formate dienen dem automatisierten Austausch von Threat Intelligence?
+ STIX
+ TAXII
- PDF
- DOCX
! STIX beschreibt die Inhalte, TAXII den Transport.

@@@ MODULE @@@
---
id: ti-02
title: Threat Intelligence 2 · Akteure und Kampagnen analysieren
paths: cdsa, specialist
order: 33.2
difficulty: medium
icon: person.crop.square.filled.and.at.rectangle
tags: threat intelligence, apt, ransomware
summary: Wie man Angreifergruppen beschreibt, Kampagnen über Infrastruktur und Werkzeuge verbindet und warum Attribution schwierig ist.
---

## Einfach erklärt

Ermittler erkennen Serientäter an ihrer Handschrift: gleiches Werkzeug, gleicher Ablauf, gleiche Tageszeit. Threat-Intelligence-Analysten tun dasselbe mit Angreifergruppen: Sie verbinden Vorfälle über gemeinsame **Infrastruktur**, **Werkzeuge** und **Vorgehensweisen** zu Kampagnen und Akteuren.

## Ein Akteurprofil

| Aspekt | Inhalt |
|---|---|
| Namen / Aliase | verschiedene Hersteller vergeben verschiedene Namen |
| Motivation | Spionage, Geld, Sabotage, Aktivismus |
| Ziele | Branchen, Regionen, Organisationsgrößen |
| Erstzugang | Phishing, Edge-Geräte, gestohlene Zugangsdaten |
| TTPs | in ATT&CK-Techniken beschrieben |
| Werkzeuge | eigene Malware, legitime Tools |
| Infrastruktur | Hosting-Muster, Domainnamen-Muster, Zertifikate |
| Aktivitätszeitraum | wann aktiv, saisonale Muster |

## Kampagnen verbinden (Pivoting)

Ausgehend von einem Indikator sucht man Verbindungen: Dieselbe IP hostete andere Domains → diese Domains nutzen dasselbe TLS-Zertifikat → das Zertifikat taucht bei weiteren Servern auf → ein dort gefundenes Malware-Sample hat dieselbe Konfigurationsstruktur. Werkzeuge: passive DNS, Zertifikatsdatenbanken, Malware-Datenbanken, Scan-Daten.

> [!WARNUNG] Attribution ist schwer
> Angreifer nutzen gemeinsame Werkzeuge, mieten Infrastruktur, legen falsche Fährten (False Flags). Für die Verteidigung ist meist wichtiger **wie** angegriffen wird, nicht **wer** genau dahintersteckt.

## Tiefer eingetaucht

Für den Alltag im SOC sind Akteurprofile nützlich, wenn sie zu Maßnahmen führen: „Gruppen, die unsere Branche angreifen, nutzen Technik X → Haben wir dafür Erkennung und Prävention?“ Diese **bedrohungsgeleitete Priorisierung** verbindet TI direkt mit Detection Engineering, Härtung und Red-Team-Szenarien.

Ransomware-Ökosysteme sind besonders dynamisch: Gruppen benennen sich um, Affiliates wechseln zwischen Programmen, Werkzeuge werden geteilt. Darum sind TTPs (z. B. typische Exfiltrationswerkzeuge, Löschung von Schattenkopien) stabilere Erkennungsmerkmale als Gruppennamen.

## Quiz

? Was bedeutet Pivoting in der Threat Intelligence?
+ von einem Indikator ausgehend verwandte Infrastruktur und Artefakte finden
- im Netzwerk von Host zu Host springen
- ein Diagramm drehen
- Passwörter ändern
! Z. B. über passive DNS oder gemeinsame Zertifikate.

?tf Attribution zu einem konkreten Akteur ist meist einfach und eindeutig.
= falsch
! Gemeinsame Werkzeuge und False Flags erschweren sie.

? Was ist für die Verteidigung meist wichtiger als die genaue Attribution?
+ die Vorgehensweise (TTPs) des Angriffs
- der Name der Gruppe
- das Herkunftsland
- die Lieblingsfarbe des Angreifers
! Aus TTPs folgen konkrete Schutz- und Erkennungsmaßnahmen.

? Warum haben Angreifergruppen oft mehrere Namen?
+ verschiedene Sicherheitsanbieter vergeben eigene Bezeichnungen
- sie benennen sich täglich um
- Namen sind gesetzlich vorgeschrieben
- weil sie keine Namen haben
! Mappings zwischen Aliasen helfen beim Vergleich von Berichten.

? Wie nennt man Täuschungsmanöver, die auf einen falschen Urheber hindeuten sollen?
= False Flag
= False Flags
! Ein bekanntes Problem bei der Attribution.

@@@ MODULE @@@
---
id: ti-03
title: Threat Intelligence 3 · MISP und IOC-Management
paths: cdsa
order: 33.3
difficulty: medium
icon: square.and.arrow.down.on.square.fill
tags: misp, ioc, threat intelligence
summary: Wie man Indikatoren sammelt, bewertet, mit Ablaufdaten versieht, teilt und in SIEM, EDR und Firewall nutzt, ohne in Fehlalarmen zu ertrinken.
---

## Einfach erklärt

IOCs sind wie Fahndungsfotos: nützlich, aber nur, wenn sie aktuell sind und man weiß, wofür die Person gesucht wird. Eine Plattform wie **MISP** ist die Fahndungszentrale: Sie sammelt Indikatoren, versieht sie mit Kontext und verteilt sie an die Stellen, die danach suchen.

## Lebenszyklus eines IOCs

1. **Aufnahme** – aus Vorfall, Bericht, Feed.
2. **Anreicherung** – Kontext: Welche Kampagne, welcher Malware-Typ, Erstes/Letztes Sehen?
3. **Bewertung** – Vertrauen, Relevanz, Fehlalarmrisiko (z. B. geteilte Hosting-IPs, CDN-Adressen).
4. **Verteilung** – an SIEM (Suche/Alarm), EDR (Blockieren), Proxy/Firewall/DNS (Blocken).
5. **Ablauf** – IPs nach Wochen, Domains nach Monaten, Hashes länger. Veraltete IOCs entfernen.

> [!WARNUNG] Fehlalarme durch schlechte IOCs
> Eine Liste mit großen Cloud- oder CDN-IP-Adressen kann halbe Internetdienste blockieren. Jede automatische Blockierung braucht Qualitätsprüfung und Allowlists.

## MISP-Grundbegriffe

| Begriff | Bedeutung |
|---|---|
| Event | Bündel zusammengehöriger Informationen (z. B. eine Kampagne) |
| Attribute | einzelner Indikator mit Typ (ip-dst, domain, sha256 …) |
| Object | strukturierte Gruppe von Attributen (z. B. Datei mit Namen und Hashes) |
| Tag / Taxonomy | Klassifizierung (z. B. TLP, Kill-Chain-Phase) |
| Galaxy | Wissen über Akteure, Malware, Techniken |
| Sharing Group | mit wem geteilt wird |
| Sighting | Rückmeldung „gesehen“ oder „Fehlalarm“ |

## Tiefer eingetaucht

**Retro-Hunting**: Neue IOCs werden nicht nur für die Zukunft genutzt, sondern auch rückwirkend gegen historische Logs gesucht – vielleicht war der Angreifer schon vor Wochen da. Dafür braucht es ausreichend lange Logaufbewahrung.

Messbarkeit: Wie viele IOCs führten zu echten Treffern? Welche Feeds erzeugen nur Fehlalarme? Diese Rückmeldungen (Sightings) verbessern die Feed-Auswahl.

## Quiz

? Was ist MISP?
+ eine Plattform zum Sammeln und Teilen von Threat Intelligence
- ein Virenscanner
- ein Betriebssystem
- eine Programmiersprache
! Malware Information Sharing Platform.

? Warum brauchen IOCs ein Ablaufdatum?
+ weil Infrastruktur wechselt und alte IOCs Fehlalarme erzeugen
- weil sie sonst gelöscht werden müssen
- weil MISP es verlangt
- weil Hashes verfallen
! IPs sind oft schon nach Tagen bis Wochen nicht mehr aussagekräftig.

? Wie nennt man die rückwirkende Suche nach neuen IOCs in alten Logs?
= Retro-Hunting
= Retrohunting
= Retro Hunting
! Setzt ausreichende Logaufbewahrung voraus.

?tf Automatisches Blockieren aller IOCs aus jedem Feed ist ohne Prüfung unbedenklich.
= falsch
! CDN- und Cloud-Adressen können massive Störungen verursachen.

? Wie heißt in MISP die Rückmeldung, dass ein Indikator gesehen wurde?
= Sighting
! Auch Fehlalarme lassen sich so zurückmelden.

@@@ MODULE @@@
---
id: ti-04
title: Threat Intelligence 4 · Schwachstellen-Intelligence und Priorisierung
paths: cdsa, specialist
order: 33.4
difficulty: medium
icon: exclamationmark.bubble.fill
tags: schwachstellen, priorisierung, kev, epss
summary: Wie man aus täglich hunderten neuen CVEs die wenigen herausfiltert, die sofort zählen – KEV, EPSS, Exploit-Status, Exposition und Asset-Kritikalität.
---

## Einfach erklärt

Jeden Tag werden über hundert neue Schwachstellen veröffentlicht. Alle sofort zu patchen ist unmöglich. Die Kunst ist zu erkennen, welche **heute** wichtig sind – wie ein Notarzt, der entscheidet, wer zuerst behandelt wird.

## Die Priorisierungsfragen

1. **Betrifft sie uns?** (Inventar!)
2. **Wird sie aktiv ausgenutzt?** → CISA **KEV**-Katalog, Herstellerhinweise, Threat-Intel-Berichte.
3. **Wie wahrscheinlich ist Ausnutzung?** → **EPSS** (Wahrscheinlichkeit der Ausnutzung in den nächsten 30 Tagen).
4. **Ist das System exponiert?** Internet, Edge-Gerät, VPN, E-Mail-Gateway?
5. **Wie kritisch ist das System?** Kronjuwelen, Identitätssysteme, viele Nutzer?
6. **Gibt es Workarounds**, falls ein Patch nicht sofort möglich ist?

## Beispielhafte Matrix

| Situation | Priorität |
|---|---|
| In KEV + internetexponiert | sofort (Stunden bis wenige Tage) |
| Hoher EPSS + exponiert | sehr hoch |
| Kritischer CVSS, intern, kein Exploit bekannt | hoch, regulärer Zyklus |
| Niedriger CVSS, intern | normaler Patchzyklus |

> [!MERKE] Edge-Geräte zuerst
> Firewalls, VPN-Gateways, Load Balancer und Datei-Transfer-Lösungen werden nach Veröffentlichung von Lücken oft binnen Tagen massenhaft angegriffen.

## Tiefer eingetaucht

**SSVC** (Stakeholder-Specific Vulnerability Categorization) ist ein Entscheidungsbaum, der statt einer Zahl eine Handlungsempfehlung liefert (Track, Track*, Attend, Act) – basierend auf Ausnutzung, Automatisierbarkeit, technischer Auswirkung und Missionsrelevanz.

Wenn ein Patch nicht sofort möglich ist: virtuelles Patchen (WAF/IPS-Regel), Dienst vom Internet nehmen, Funktion deaktivieren, verstärkte Überwachung (Hunting nach bekannten Ausnutzungsspuren). Und: Nach dem Patchen prüfen, ob vorher schon eine Kompromittierung stattfand – viele Massenausnutzungen hinterlassen Webshells oder Hintertüren, die ein Patch nicht entfernt.

## Quiz

? Welcher Katalog listet aktiv ausgenutzte Schwachstellen?
= KEV
= CISA KEV
= Known Exploited Vulnerabilities
! Gepflegt von der US-Behörde CISA.

? Was schätzt EPSS?
+ die Wahrscheinlichkeit, dass eine Schwachstelle bald ausgenutzt wird
- den finanziellen Schaden
- die Anzahl betroffener Systeme weltweit
- die Patchdauer
! Exploit Prediction Scoring System.

? Welche Systeme sollten bei neuen Lücken meist zuerst gepatcht werden?
+ internetexponierte Edge-Geräte wie VPN-Gateways
- Testdrucker im Keller
- abgeschaltete Rechner
- Bildschirmschoner
! Sie werden oft binnen Tagen massenhaft angegriffen.

?tf Nach dem Patchen einer massenhaft ausgenutzten Lücke sollte man nach Spuren einer vorherigen Kompromittierung suchen.
= wahr
! Ein Patch entfernt keine bereits installierten Hintertüren.

? Was liefert SSVC statt einer Zahl?
+ eine Handlungsempfehlung wie Track oder Act
- einen Preis
- eine Farbe
- einen Hash
! Entscheidungsbaum statt Score.

? Was ist virtuelles Patchen?
+ eine Schutzregel (z. B. WAF/IPS), die Ausnutzung blockiert, bis gepatcht ist
- ein Patch in einer virtuellen Maschine
- ein gefälschter Patch
- ein Patch ohne Neustart
! Eine Übergangslösung, kein Ersatz.

@@@ MODULE @@@
---
id: ti-05
title: Threat Intelligence 5 · Lagebilder schreiben und kommunizieren
paths: cdsa, specialist
order: 33.5
difficulty: easy
icon: newspaper.fill
tags: threat intelligence, kommunikation
summary: Wie man aus Informationen ein verständliches Lagebild macht – Struktur, Einschätzungssprache, Quellenangaben und Handlungsempfehlungen.
---

## Einfach erklärt

Ein Lagebild ist wie ein guter Wetterbericht: kurz, verständlich, mit klarer Aussage („Morgen Sturm – Gartenmöbel sichern“) und ehrlich darüber, wie sicher die Vorhersage ist. Niemand liest gern einen 40-seitigen Bericht ohne Empfehlung.

## Struktur eines Lagebilds

1. **Kernaussage (BLUF – Bottom Line Up Front)**: zwei, drei Sätze.
2. **Relevanz**: Warum betrifft uns das?
3. **Details**: Was ist bekannt? Was nicht?
4. **Einschätzung**: Wie wahrscheinlich, wie schwerwiegend?
5. **Empfehlungen**: konkret, priorisiert, mit Zuständigkeit.
6. **Quellen**: mit Bewertung.

## Einschätzungssprache

| Formulierung | ungefähre Wahrscheinlichkeit |
|---|---|
| fast sicher | > 90 % |
| sehr wahrscheinlich | 75–90 % |
| wahrscheinlich | 55–75 % |
| etwa gleich wahrscheinlich | 45–55 % |
| unwahrscheinlich | 20–45 % |
| sehr unwahrscheinlich | < 20 % |

> [!TIPP] Fakten und Einschätzungen trennen
> „Die Domain wurde am 3. März registriert“ ist ein Fakt. „Die Kampagne richtet sich wahrscheinlich gegen Zulieferer“ ist eine Einschätzung – und sollte als solche erkennbar sein.

## Tiefer eingetaucht

Kognitive Verzerrungen bedrohen jede Analyse: **Bestätigungsfehler** (nur suchen, was die eigene Hypothese stützt), **Verankerung** (an der ersten Information festhalten), **Spiegeln** (annehmen, der Gegner denke wie man selbst). Methoden dagegen: Analysis of Competing Hypotheses (mehrere Erklärungen systematisch gegeneinander prüfen), Gegenlesen durch Kollegen, bewusste „Was, wenn ich falsch liege?“-Frage.

Verteilung nach Publikum: Für die Leitung eine Seite mit Kernaussage und Entscheidungsbedarf, für das SOC technische Details und Erkennungsideen, für die IT konkrete Patch- und Härtungsschritte.

## Quiz

? Wofür steht BLUF?
= Bottom Line Up Front
! Die Kernaussage gehört an den Anfang.

? Was sollte ein Lagebild klar trennen?
+ Fakten und Einschätzungen
- Groß- und Kleinschreibung
- Tabellen und Bilder
- Absätze und Listen
! So kann der Leser die Belastbarkeit beurteilen.

? Welche Wahrscheinlichkeit beschreibt „sehr wahrscheinlich“ ungefähr?
+ 75–90 %
- unter 20 %
- 45–55 %
- genau 100 %
! Einheitliche Einschätzungssprache verhindert Missverständnisse.

?tf Der Bestätigungsfehler führt dazu, dass man bevorzugt Belege für die eigene Hypothese sucht.
= wahr
! Methoden wie ACH helfen dagegen.

? Wie heißt die Methode, mehrere Erklärungen systematisch gegeneinander zu prüfen?
= Analysis of Competing Hypotheses
= ACH
! Sie reduziert kognitive Verzerrungen.
