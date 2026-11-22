---
id: ot-04
title: OT-Praxis 1 · SPS, HMI und Feldbusse verstehen
paths: specialist, cyberrange
order: 93
difficulty: easy
icon: cpu
tags: ot, ics, grundlagen
summary: Wie eine speicherprogrammierbare Steuerung arbeitet, was HMI und SCADA tun und warum klassische Feldbusse keine Sicherheit kennen.
---

## Einfach erklärt

In einer Fabrik denkt nicht der Büro-PC, sondern die **SPS** (speicherprogrammierbare Steuerung, engl. PLC): ein robuster Kleincomputer, der in einer endlosen Schleife Sensoren liest, sein Programm abarbeitet und Aktoren schaltet – hunderte Male pro Sekunde, jahrelang ohne Neustart. Die **HMI** ist das Bedienfeld, über das Menschen zuschauen und eingreifen.

## Der SPS-Zyklus

1. Eingänge lesen (Sensoren: Temperatur, Druck, Endschalter)
2. Programm ausführen (Logik, z. B. „wenn Druck > X, Ventil auf“)
3. Ausgänge schreiben (Aktoren: Motoren, Ventile)
4. Kommunikation, Diagnose – dann von vorn

## Komponenten

| Komponente | Aufgabe |
|---|---|
| SPS/PLC | Steuerlogik |
| HMI | lokale Bedienung |
| SCADA | Überwachung und Steuerung vieler Anlagen, Leitwarte |
| Historian | Prozessdaten-Archiv |
| Engineering-Workstation | Programmierung der SPS – hochkritisch |
| Safety-SPS (SIS) | unabhängige Sicherheitsabschaltung |

## Protokolle

| Protokoll | Eigenschaft |
|---|---|
| Modbus (RTU/TCP) | einfach, keine Authentifizierung |
| PROFINET/PROFIBUS | Siemens-Umfeld, Echtzeit |
| EtherNet/IP (CIP) | Rockwell-Umfeld |
| S7comm | Siemens-SPS-Kommunikation |
| OPC UA | modern, mit Sicherheitsfunktionen (Signatur, Verschlüsselung) |

> [!MERKE] Wer schreiben darf, steuert
> Bei Protokollen ohne Authentifizierung kann jeder im Netz, der die Steuerung erreicht, Werte lesen und **schreiben**. Netztrennung ist deshalb die wichtigste Schutzmaßnahme.

## Tiefer eingetaucht

Die **Engineering-Workstation** ist das Kronjuwel: Von dort wird SPS-Code geladen. Wer sie kontrolliert, kann die Logik unbemerkt ändern (wie bei Stuxnet). Schutz: isoliert, gehärtet, Zugriff protokolliert, Projektdateien versioniert und mit Prüfsummen verglichen. Viele moderne SPSen bieten Zugriffsschutz (Passwort, Schreibschutz, Schlüsselschalter RUN/PROG) – oft ist er nur nicht aktiviert.

## Quiz

? Was macht eine SPS in ihrem Zyklus zuerst?
+ Eingänge lesen
- Ausgänge schreiben
- Neustart
- E-Mails senden
! Danach Programm ausführen und Ausgänge schreiben.

? Welches Protokoll hat keine eingebaute Authentifizierung?
+ Modbus
- OPC UA mit Security Policy
- TLS
- SSH
! Jeder mit Netzzugang kann lesen und schreiben.

? Welches System gilt als Kronjuwel in OT-Netzen, weil von dort SPS-Code geladen wird?
= Engineering-Workstation
= Engineering Workstation
! Ihre Kompromittierung erlaubt Logikänderungen.

?tf OPC UA bietet Sicherheitsfunktionen wie Signatur und Verschlüsselung.
= wahr
! Sie müssen aber konfiguriert und genutzt werden.

? Was ist ein SIS?
+ ein unabhängiges Sicherheitssystem für Notabschaltungen
- ein Netzwerkswitch
- eine Datenbank
- ein Virenscanner
! Safety Instrumented System – schützt Menschen und Anlage.

@@@ MODULE @@@
---
id: ot-05
title: OT-Praxis 2 · Fernwartung in Industrieanlagen absichern
paths: specialist, cyberrange
order: 93.1
difficulty: medium
icon: antenna.radiowaves.left.and.right.circle.fill
tags: ot, fernwartung
summary: Warum Hersteller-Fernzugänge eines der größten OT-Risiken sind und wie man sie mit Jump-Servern, Freigaben, MFA und Aufzeichnung kontrolliert.
---

## Einfach erklärt

Viele Maschinenhersteller warten ihre Anlagen aus der Ferne. Bequem – aber jede dauerhaft offene Verbindung ist eine Hintertür in die Produktion. Oft steckt im Schaltschrank ein kleiner Router mit Mobilfunk, von dem die IT nichts weiß.

## Typische Probleme

- dauerhaft verbundene Fernwartungsboxen (Mobilfunk, VPN) am Firewall vorbei
- gemeinsame Zugangsdaten für alle Techniker eines Herstellers
- kein MFA, keine Protokollierung
- direkte Verbindung bis zur SPS
- veraltete Fernwartungssoftware

## Sicheres Muster

1. **Zentraler Fernwartungszugang** in der Industrie-DMZ (Ebene 3.5).
2. **Freigabe pro Sitzung**: Der Betreiber schaltet den Zugang zeitlich begrenzt frei.
3. **Persönliche Konten** für jeden Techniker, mit **MFA**.
4. **Jump-Server** mit **Sitzungsaufzeichnung**; Techniker erreichen nur die freigegebenen Zielsysteme.
5. **Vier-Augen-Prinzip** bei kritischen Änderungen (Mitarbeiter des Betreibers schaut zu).
6. **Inventar** aller Fernwartungswege – inklusive versteckter Mobilfunkrouter.

> [!GEFAHR] Schattenzugänge
> Ein einziger vergessener Mobilfunkrouter im Schaltschrank kann die gesamte Netzsegmentierung aushebeln. Regelmäßig nach solchen Zugängen suchen (Begehung, Funkscans, Netzwerkanalyse).

## Tiefer eingetaucht

Verträge mit Herstellern sollten Sicherheitsanforderungen an Fernwartung enthalten (persönliche Konten, MFA, Meldung von Vorfällen, Patch-Zusagen). Für die Überwachung: Fernwartungssitzungen als Ereignisse ins SIEM, Alarm bei Sitzungen außerhalb freigegebener Fenster. IEC 62443 und der BSI-Baustein IND.3.2 (Fernwartung im industriellen Umfeld) geben detaillierte Anforderungen.

## Quiz

? Warum sind dauerhaft verbundene Fernwartungsboxen riskant?
+ sie können die Firewall umgehen und bieten einen ständigen Zugang
- sie verbrauchen zu viel Strom
- sie sind zu langsam
- sie stören das WLAN
! Jede dauerhafte Verbindung ist eine Hintertür.

? Wie sollte Fernwartung freigegeben werden?
+ zeitlich begrenzt pro Sitzung durch den Betreiber
- dauerhaft für alle
- per E-Mail-Bestätigung des Herstellers allein
- gar nicht kontrolliert
! Zugang nur, wenn er gebraucht wird.

?tf Jeder Techniker sollte ein persönliches Konto mit MFA haben.
= wahr
! Gemeinsame Zugangsdaten verhindern Zurechenbarkeit.

? Wo sollte der zentrale Fernwartungszugang liegen?
+ in der Industrie-DMZ
- direkt im Steuerungsnetz
- im Gäste-WLAN
- im Internet ohne Firewall
! Ebene 3.5 trennt IT und OT.

? Welcher BSI-Baustein behandelt Fernwartung im industriellen Umfeld?
= IND.3.2
! Mit konkreten Anforderungen für Betreiber.

@@@ MODULE @@@
---
id: ot-06
title: OT-Praxis 3 · Asset-Inventar und Schwachstellen in OT
paths: specialist, cdsa
order: 93.2
difficulty: medium
icon: list.bullet.clipboard.fill
tags: ot, inventar, schwachstellen
summary: Wie man OT-Komponenten ohne Betriebsrisiko erfasst, Schwachstellen bewertet, wenn Patchen schwierig ist, und kompensierende Maßnahmen plant.
---

## Einfach erklärt

In der Büro-IT scannt man ein Netz einfach durch. In einer Fabrik kann ein zu aggressiver Scan eine alte Steuerung zum Absturz bringen – und damit die Produktion stoppen. OT-Inventarisierung braucht deshalb **Fingerspitzengefühl**.

## Methoden der Erfassung

| Methode | Risiko | Ergebnis |
|---|---|---|
| Passive Netzwerkanalyse (Mitlesen per SPAN/TAP) | sehr gering | Geräte, Protokolle, Kommunikationsbeziehungen |
| Abfrage über Engineering-Software/Projektdateien | gering | exakte Konfiguration |
| Selektive aktive Abfrage (herstellerspezifisch, langsam) | mittel | Firmware-Stände |
| Begehung, Typenschilder, Schaltpläne | keins | Hardware, Standort |
| Klassischer IT-Scan (Nmap mit Standardoptionen) | hoch | nur in Abstimmung / Testanlage |

## Schwachstellen bewerten

Patchen ist in OT oft schwierig: Wartungsfenster nur alle paar Monate, Herstellerfreigaben nötig, Zertifizierungen der Anlage. Deshalb:

1. **Erreichbarkeit** prüfen: Ist die Komponente überhaupt aus kritischen Zonen erreichbar?
2. **Ausnutzbarkeit** im Kontext: Braucht es lokalen Zugriff? Gibt es Exploits?
3. **Auswirkung** auf Prozess und Safety.
4. **Kompensierende Maßnahmen**, bis gepatcht wird: Segmentierung, Protokoll-Firewall, Deaktivieren ungenutzter Dienste, Überwachung.

> [!MERKE] Erst trennen, dann patchen
> Gute Segmentierung reduziert das Risiko vieler OT-Schwachstellen so stark, dass Patches geplant im nächsten Wartungsfenster eingespielt werden können.

## Tiefer eingetaucht

Quellen für OT-Schwachstellen: Hersteller-Advisories (PSIRTs), CISA ICS Advisories, CERT@VDE. Spezialisierte OT-Monitoring-Lösungen erstellen passiv Inventar und gleichen Firmwarestände mit Advisories ab. Wichtig ist die Zusammenarbeit von IT-Sicherheit, Produktion und Instandhaltung – ohne die Menschen, die die Anlage kennen, entstehen falsche Prioritäten.

## Quiz

? Welche Methode der OT-Inventarisierung hat das geringste Betriebsrisiko?
+ passive Netzwerkanalyse
- aggressiver Portscan
- Stresstest der Steuerungen
- Neustart aller Geräte
! Nur mithören, nichts senden.

?tf Ein Standard-Nmap-Scan ist in OT-Netzen immer unbedenklich.
= falsch
! Alte Steuerungen können dadurch abstürzen.

? Was sind kompensierende Maßnahmen?
+ Schutzmaßnahmen wie Segmentierung, bis ein Patch eingespielt werden kann
- Geldzahlungen an den Hersteller
- Ausschalten der Anlage
- Ignorieren der Lücke
! Sie überbrücken die Zeit bis zum Wartungsfenster.

? Welche Stelle veröffentlicht in Deutschland Advisories für Industriekomponenten?
= CERT@VDE
! Ergänzend: CISA ICS Advisories und Hersteller-PSIRTs.

? Wer muss bei OT-Schwachstellenbewertung eingebunden werden?
+ Produktion und Instandhaltung
- nur die IT
- nur der Einkauf
- niemand
! Sie kennen Prozess und Auswirkungen.

@@@ MODULE @@@
---
id: ot-07
title: OT-Praxis 4 · Bekannte Angriffe auf Industrieanlagen und ihre Lehren
paths: specialist, cdsa, cyberrange
order: 93.3
difficulty: medium
icon: bolt.trianglebadge.exclamationmark.fill
tags: ot, fallstudien
summary: Stuxnet, Angriffe auf Stromnetze, Triton und Ransomware in der Produktion – was passiert ist und welche Schutzmaßnahmen daraus folgen.
---

## Einfach erklärt

Aus großen Vorfällen lernt die ganze Branche. In der Industrie zeigten einige Angriffe, dass Cyberangriffe physische Folgen haben können – zerstörte Anlagen, Stromausfälle, gefährdete Sicherheitssysteme. Die Lehren daraus prägen heutige Schutzkonzepte.

## Fallbeispiele (vereinfacht)

| Vorfall | Was geschah | Lehre |
|---|---|---|
| Stuxnet (entdeckt 2010) | manipulierte SPS-Logik, Zentrifugen beschädigt, Bediener sahen „normale“ Werte | Air-Gap ist nicht absolut (USB); Engineering-Systeme und Integrität der Logik schützen |
| Ukraine Stromnetz (2015/2016) | Fernzugriff auf Leitstellen, Schalter geöffnet, Hunderttausende ohne Strom | Fernzugänge und IT/OT-Übergänge sind Haupteinfallstore; manueller Notbetrieb wichtig |
| Triton/Trisis (2017) | Angriff auf Safety-Steuerung einer Anlage | Safety-Systeme isolieren, Schlüsselschalter, Integritätsprüfung |
| Ransomware in der Produktion (viele Fälle) | IT verschlüsselt, Produktion stoppt aus Vorsicht oder Abhängigkeit | Abhängigkeiten der OT von IT-Diensten (AD, ERP) kennen und reduzieren |
| Wasserversorgung (diverse) | Fernzugriffssoftware mit schwachen Zugangsdaten | Grundschutz: MFA, keine öffentlichen Fernzugänge |

> [!MERKE] Oft fällt die Produktion wegen der IT aus
> Viele Unternehmen mussten nicht stoppen, weil die OT angegriffen wurde, sondern weil Planung, Aufträge oder Anmeldung in der IT lagen. Abhängigkeiten zu kennen ist Teil der Resilienz.

## Tiefer eingetaucht

Gemeinsame Muster: Erstzugang über die IT (Phishing, VPN), lange unentdeckte Aufklärung, Übergang in die OT über schwache Trennung oder Fernwartung, gezielte Wirkung. Gegenmittel: starke IT/OT-Trennung, Überwachung der Übergänge, Integritätsprüfung von SPS-Programmen, getestete manuelle Betriebsverfahren und gemeinsame Übungen von IT, OT und Produktion – idealerweise in einer OT-Range.

## Quiz

? Was manipulierte Stuxnet?
+ die Logik von SPSen, während Bediener normale Werte sahen
- E-Mail-Server
- Webseiten
- Kassensysteme
! Ein Lehrstück für die Integrität von Steuerungslogik.

? Was zeigte der Triton-Angriff?
+ dass auch Safety-Steuerungen angegriffen werden können
- dass OT immer sicher ist
- dass Passwörter unnötig sind
- dass USB-Sticks harmlos sind
! Safety-Systeme müssen besonders isoliert werden.

?tf Produktionsausfälle durch Ransomware entstehen oft, weil die OT von IT-Diensten abhängt.
= wahr
! Abhängigkeiten kennen und reduzieren.

? Welche Lehre zieht man aus Stuxnet bezüglich Air-Gaps?
+ ein Air-Gap ist nicht absolut, z. B. wegen Wechseldatenträgern
- Air-Gaps sind immer perfekt
- Air-Gaps sind verboten
- Air-Gaps machen Updates überflüssig
! Datenträger und Engineering-Systeme sind Übertragungswege.

? Was ist ein häufiger Erstzugang bei Angriffen auf Wasserversorger?
+ Fernzugriffssoftware mit schwachen Zugangsdaten
- Satellitenhacks
- physischer Einbruch in Rohre
- defekte Wasserzähler
! Grundschutz wie MFA hätte viele Fälle verhindert.

@@@ MODULE @@@
---
id: pg-11
title: Programmierung 11 · Daten analysieren mit pandas
paths: cdsa, grundlagen
order: 22.9
difficulty: medium
icon: chart.bar.xaxis
tags: python, pandas, analyse
summary: Logs und CSV-Exporte mit pandas laden, filtern, gruppieren, zeitlich auswerten und Auffälligkeiten finden – wenn das SIEM nicht reicht.
---

## Einfach erklärt

Manchmal bekommt man im Vorfall einen Export mit 2 Millionen Zeilen – zu viel für Excel, kein SIEM zur Hand. **pandas** ist eine Python-Bibliothek, die Tabellen wie eine Tabellenkalkulation behandelt, aber mit der Kraft einer Programmiersprache.

## Grundlagen

```python
import pandas as pd

df = pd.read_csv("signins.csv", parse_dates=["time"])
df.head()
df.info()

fehl = df[df["result"] == "failure"]
pro_ip = fehl.groupby("ip").agg(versuche=("user", "size"), konten=("user", "nunique"))
verdacht = pro_ip[(pro_ip.versuche > 50) & (pro_ip.konten > 10)].sort_values("versuche", ascending=False)
```

| Funktion | Zweck |
|---|---|
| `read_csv`, `read_json` | laden |
| Filter `df[bedingung]` | auswählen |
| `groupby().agg()` | gruppieren und zählen |
| `value_counts()` | Häufigkeiten |
| `resample("1h")` | Zeitreihen |
| `merge()` | Tabellen verbinden (z. B. mit Asset-Liste) |
| `to_csv`, `to_excel` | Ergebnisse exportieren |

## Zeitreihen

```python
df.set_index("time").resample("10min")["user"].count().plot()
```

> [!TIPP] Zeitzonen prüfen
> `pd.to_datetime(..., utc=True)` verwenden, damit alle Zeitstempel in UTC vorliegen – sonst passen Quellen nicht zusammen.

## Tiefer eingetaucht

Notebooks (Jupyter) eignen sich hervorragend für nachvollziehbare Analysen: Jeder Schritt mit Code, Ergebnis und Erklärung – direkt als Anhang zum Bericht. Für sehr große Daten helfen Polars oder DuckDB (SQL direkt auf CSV/Parquet). Vorsicht bei Daten mit personenbezogenen Inhalten: Analysen in kontrollierter Umgebung, keine Kopien auf privaten Geräten.

## Quiz

? Mit welcher pandas-Funktion lädt man eine CSV-Datei?
= read_csv
= pd.read_csv
! Mit parse_dates werden Zeitspalten direkt erkannt.

? Welche Funktion gruppiert und aggregiert Daten?
= groupby
= groupby().agg()
! Zum Beispiel Versuche pro IP zählen.

? Welche Funktion fasst Zeitreihen in Intervalle zusammen?
= resample
! Zum Beispiel resample("1h").

?tf Notebooks eignen sich für nachvollziehbare Analysen mit Code, Ergebnis und Erklärung.
= wahr
! Ideal als Anhang zu Untersuchungsberichten.

? Welches Werkzeug erlaubt SQL direkt auf großen CSV- oder Parquet-Dateien?
= DuckDB
! Eine Alternative für sehr große Datenmengen.

@@@ MODULE @@@
---
id: pg-12
title: Programmierung 12 · APIs automatisieren – SOAR-Grundlagen mit Python
paths: cdsa, specialist
order: 23
difficulty: medium
icon: arrow.triangle.2.circlepath.doc.on.clipboard
tags: python, automatisierung, soar
summary: Wie man Sicherheitswerkzeuge per REST-API verbindet – Authentifizierung, Fehlerbehandlung, Rate Limits, Idempotenz und ein kleines Anreicherungs-Playbook.
---

## Einfach erklärt

Ein SOC-Analyst kopiert eine IP aus dem SIEM, sucht sie in drei Threat-Intel-Diensten, prüft das Asset-Inventar und schreibt alles ins Ticket – zehnmal am Tag. Genau solche Routine erledigt ein **Automatisierungsskript** in Sekunden. SOAR-Plattformen tun das im großen Stil; die Grundlagen kann man mit Python verstehen.

## Ein Anreicherungs-Playbook (vereinfacht)

```python
import os, time, requests

SESSION = requests.Session()
SESSION.headers["Authorization"] = f"Bearer {os.environ['TI_TOKEN']}"

def hole(url, versuche=3):
    for i in range(versuche):
        r = SESSION.get(url, timeout=10)
        if r.status_code == 429:
            time.sleep(int(r.headers.get("Retry-After", 2 ** i)))
            continue
        r.raise_for_status()
        return r.json()
    raise RuntimeError("Rate Limit dauerhaft überschritten")

def anreichern(ip):
    ti = hole(f"https://ti.example.local/api/ip/{ip}")
    asset = hole(f"https://cmdb.example.local/api/assets?ip={ip}")
    return {"ip": ip, "reputation": ti.get("score"), "owner": (asset or [{}])[0].get("owner")}
```

## Prinzipien

| Prinzip | Warum |
|---|---|
| Secrets aus Umgebung/Vault | nie im Code |
| Timeouts | Skript hängt nicht ewig |
| Retry mit Backoff, 429 beachten | Rate Limits respektieren |
| Idempotenz | doppelte Ausführung richtet keinen Schaden an |
| Logging | nachvollziehbar, was automatisch passiert ist |
| Mensch entscheidet bei folgenreichen Aktionen | z. B. Konten sperren nur nach Bestätigung |

> [!WARNUNG] Automatisierung mit Bremse
> Eine fehlerhafte Regel, die automatisch Konten sperrt oder Hosts isoliert, kann mehr Schaden anrichten als ein Angreifer. Kritische Aktionen mit Freigabe und Limits versehen.

## Tiefer eingetaucht

Typische SOAR-Abläufe: Phishing-Analyse, Anreicherung von Alarmen, Benutzer-Rückfrage („Waren Sie das?“), Eindämmung mit Freigabe, Ticket- und Kommunikationsschritte. Erfolg misst man an eingesparter Analystenzeit und schnellerer Reaktion (MTTR). Automatisierung ist Code: versionieren, testen, reviewen.

## Quiz

? Was bedeutet HTTP 429 für ein Automatisierungsskript?
+ zu viele Anfragen – warten und später erneut versuchen
- Anfrage erfolgreich
- Seite nicht gefunden
- Serverfehler
! Retry-After-Header beachten.

? Woher sollten API-Tokens in Skripten kommen?
+ aus Umgebungsvariablen oder einem Vault
- fest im Quellcode
- aus einem öffentlichen Repository
- aus dem Dateinamen
! Secrets gehören nicht in den Code.

?tf Automatisches Sperren von Konten sollte ohne Limits und Freigabe laufen.
= falsch
! Fehlerhafte Automatisierung kann großen Schaden anrichten.

? Was bedeutet Idempotenz bei Automatisierung?
+ mehrfaches Ausführen richtet keinen zusätzlichen Schaden an
- das Skript läuft nur einmal
- das Skript ist verschlüsselt
- das Skript braucht kein Netzwerk
! Wichtig bei Wiederholungen nach Fehlern.

? Woran misst man den Erfolg von SOAR?
+ eingesparte Analystenzeit und schnellere Reaktion
- Anzahl der Codezeilen
- Anzahl der Plugins
- Farbe der Oberfläche
! Zum Beispiel sinkende MTTR.

@@@ MODULE @@@
---
id: na-04
title: Netzarchitektur 4 · Zero Trust praktisch umsetzen
paths: specialist, cdsa
order: 52.4
difficulty: medium
icon: checkmark.shield
tags: zero trust, architektur
summary: Von der Idee zur Umsetzung – Identität, Gerät, Anwendung, Daten und Netz Schritt für Schritt nach dem Zero-Trust-Reifegradmodell.
---

## Einfach erklärt

Zero Trust heißt nicht „niemandem vertrauen“, sondern **Vertrauen nie automatisch, sondern immer begründet** vergeben: Wer bist du (Identität)? Ist dein Gerät in Ordnung? Brauchst du das wirklich (Least Privilege)? Und das bei **jedem** Zugriff, nicht nur einmal am Eingang.

## Die Säulen (nach CISA-Reifegradmodell)

| Säule | Beispiele |
|---|---|
| Identität | starke MFA, Single Sign-on, risikobasierte Anmeldung |
| Geräte | Inventar, Konformität (Patches, EDR, Verschlüsselung) als Zugriffsbedingung |
| Netzwerk | Segmentierung, verschlüsselter Verkehr, kein „vertrautes Intranet“ |
| Anwendungen | Zugriff pro App (ZTNA), keine pauschale Netzfreigabe |
| Daten | Klassifizierung, Verschlüsselung, Zugriff nach Bedarf |
| Querschnitt | Sichtbarkeit (Logs), Automatisierung, Governance |

## Schritt für Schritt

1. **Schutzflächen** bestimmen: Was ist am wichtigsten? (Kronjuwelen)
2. **Zugriffswege** kartieren: Wer greift wie darauf zu?
3. **Identität stärken**: MFA überall, phishing-resistent für Admins.
4. **Gerätezustand** in Zugriffsentscheidungen einbeziehen.
5. **Anwendungszugriff statt Netzzugang**: ZTNA/Proxy für interne Apps.
6. **Segmentieren** und Ost-West-Verkehr kontrollieren.
7. **Überwachen und anpassen**.

> [!MERKE] Zero Trust ist ein Weg, kein Produkt
> Kein einzelnes Produkt „macht“ Zero Trust. Es ist eine Architekturhaltung, die man schrittweise umsetzt – meist beginnend bei Identität.

## Tiefer eingetaucht

Die Policy-Entscheidung wird in Zero-Trust-Architekturen (NIST SP 800-207) von einem **Policy Decision Point** getroffen und vom **Policy Enforcement Point** (Proxy, Gateway, Agent) durchgesetzt – auf Basis von Signalen aus Identitätsanbieter, MDM, EDR und Threat Intelligence. Je mehr Signale, desto feiner die Entscheidung („Zugriff erlaubt, aber nur lesend, weil Gerät nicht verwaltet“).

## Quiz

? Was bedeutet Zero Trust?
+ Vertrauen wird nie automatisch, sondern bei jedem Zugriff begründet vergeben
- niemand darf irgendetwas
- das interne Netz ist automatisch vertrauenswürdig
- Passwörter werden abgeschafft
! Identität, Gerät und Kontext entscheiden.

? Womit beginnen die meisten Zero-Trust-Projekte sinnvollerweise?
+ mit der Stärkung der Identität (MFA, SSO)
- mit dem Kauf eines Produkts namens Zero Trust
- mit dem Abschalten der Firewall
- mit dem Löschen aller Konten
! Identität ist die neue Grenze.

?tf Zero Trust ist ein einzelnes Produkt, das man kaufen kann.
= falsch
! Es ist eine Architekturhaltung.

? Welche NIST-Publikation beschreibt Zero-Trust-Architektur?
= SP 800-207
= 800-207
! Mit Policy Decision Point und Policy Enforcement Point.

? Was setzt eine Zugriffsentscheidung in Zero Trust technisch durch?
= Policy Enforcement Point
= PEP
! Zum Beispiel ein Proxy oder Gateway.

@@@ MODULE @@@
---
id: na-05
title: Netzarchitektur 5 · Reverse Proxy, Load Balancer und WAF richtig kombinieren
paths: specialist, cwes
order: 52.5
difficulty: medium
icon: arrow.left.and.right.square.fill
tags: reverse proxy, load balancer, waf
summary: Wie Anfragen von außen zur Anwendung gelangen, welche Komponente welche Aufgabe übernimmt und welche Fehler bei Headern, TLS und IP-Weitergabe entstehen.
---

## Einfach erklärt

Zwischen Internet und Anwendung stehen oft mehrere Helfer: Ein **Load Balancer** verteilt Besucher auf mehrere Server (wie Kassen im Supermarkt), ein **Reverse Proxy** nimmt Anfragen stellvertretend an (wie ein Empfang), und eine **WAF** filtert Bösartiges heraus (wie eine Sicherheitskontrolle). Jeder Helfer muss wissen, was die anderen tun.

## Aufgaben

| Komponente | Typische Aufgaben |
|---|---|
| Load Balancer | Verteilung, Health Checks, Ausfallsicherheit |
| Reverse Proxy | TLS-Terminierung, Routing, Caching, Header setzen |
| WAF | Angriffsmuster blockieren, virtuelles Patchen, Rate Limits |
| CDN | weltweites Caching, DDoS-Abwehr |

## Typische Fehler

- **Echte Client-IP**: Die Anwendung sieht nur die IP des Proxys. Lösung: `X-Forwarded-For`/`Forwarded` – aber **nur** von vertrauenswürdigen Proxys auswerten, sonst kann jeder seine IP fälschen (Rate-Limit-Umgehung, falsche Logs).
- **Direktzugriff** auf Backends vorbei an WAF/CDN (Ursprungs-IP öffentlich bekannt).
- **TLS nur bis zum Proxy**, dahinter Klartext über unsichere Netze.
- **Uneinheitliches Parsen** von Anfragen → Request Smuggling.
- **Header-Wildwuchs**: Proxy entfernt Security-Header oder setzt sie doppelt.
- **Admin-Pfade** über den Proxy erreichbar.

> [!TIPP] Ursprung schützen
> Backends sollten nur Verbindungen vom Proxy/CDN annehmen (Firewall-Allowlist, mTLS oder geheimer Header), damit niemand die Schutzschichten umgeht.

## Tiefer eingetaucht

Logging über alle Schichten mit einer gemeinsamen **Request-ID** macht Untersuchungen möglich: Welche Anfrage kam am CDN an, was hat die WAF entschieden, was hat die Anwendung geantwortet? Ohne gemeinsame ID ist Korrelation mühsam. Health-Check-Endpunkte sollten keine sensiblen Informationen preisgeben, und Konfigurationen der Proxys gehören wie Code versioniert und geprüft.

## Quiz

? Welcher Header überträgt die ursprüngliche Client-IP hinter einem Proxy?
= X-Forwarded-For
= Forwarded
! Nur von vertrauenswürdigen Proxys auswerten.

? Warum sollte ein Backend nur Verbindungen vom Proxy annehmen?
+ damit niemand WAF und CDN umgehen kann
- damit es schneller ist
- weil Proxys billiger sind
- damit Logs kleiner werden
! Direktzugriffe umgehen alle Schutzschichten.

?tf X-Forwarded-For kann von Angreifern gefälscht werden, wenn die Anwendung ihm blind vertraut.
= wahr
! Damit lassen sich Rate Limits umgehen und Logs verfälschen.

? Was hilft bei der Korrelation von Logs über CDN, WAF und Anwendung?
+ eine gemeinsame Request-ID
- verschiedene Zeitzonen
- deaktiviertes Logging
- längere URLs
! So lässt sich eine Anfrage durch alle Schichten verfolgen.

? Welche Komponente verteilt Anfragen auf mehrere Server?
= Load Balancer
! Mit Health Checks für Ausfallsicherheit.

@@@ MODULE @@@
---
id: na-06
title: Netzarchitektur 6 · IPv6-Sicherheit im Betrieb
paths: specialist, grundlagen, cdsa
order: 52.6
difficulty: hard
icon: network
tags: ipv6, netzwerk, härtung
summary: Warum IPv6 oft unbemerkt aktiv ist, welche Angriffe auf Router Advertisements und Nachbarermittlung zielen und wie man IPv6 sicher betreibt oder kontrolliert.
---

## Einfach erklärt

Viele Netze „haben kein IPv6“ – dabei sprechen fast alle modernen Betriebssysteme es standardmäßig und bevorzugen es sogar. Wenn niemand IPv6 plant und überwacht, kann ein Angreifer es für sich nutzen: Er spielt einfach den IPv6-Router und lenkt Verkehr über sich.

## Wichtige Mechanismen

| Mechanismus | Aufgabe | Missbrauch |
|---|---|---|
| Router Advertisement (RA) | Router kündigt Präfix und Gateway an | Rogue RA: Angreifer wird zum Gateway |
| SLAAC | Clients bilden Adressen selbst | — |
| DHCPv6 | Adressen/DNS vergeben | Rogue DHCPv6: Angreifer setzt DNS-Server |
| Neighbor Discovery (NDP) | ersetzt ARP | NDP-Spoofing (wie ARP-Spoofing) |
| Erweiterungsheader | optionale Zusatzinformationen | Umgehung von Filtern |

> [!WARNUNG] Rogue DHCPv6 in Windows-Netzen
> Windows bevorzugt IPv6. Ein Angreifer, der per DHCPv6 einen eigenen DNS-Server verteilt, kann Namensauflösungen umleiten – ein bekannter Baustein für Relay-Angriffe in AD-Umgebungen.

## Schutzmaßnahmen

- IPv6 **bewusst** betreiben oder kontrolliert einschränken – nicht ignorieren.
- **RA Guard** und **DHCPv6 Guard** auf Switches.
- Firewall-Regeln für IPv6 genauso pflegen wie für IPv4 (oft vergessen!).
- Monitoring: IDS/Logs müssen IPv6 sehen.
- Wo IPv6 nicht genutzt wird: per Richtlinie Präferenzen setzen bzw. unerwünschte Mechanismen auf Netzwerkebene blockieren (Microsoft rät von vollständiger Deaktivierung auf Windows ab, empfiehlt stattdessen Präferenz-Einstellungen).

## Tiefer eingetaucht

IPv6 hat keinen NAT-„Nebeneffekt“: Geräte sind global adressierbar – Schutz kommt allein von der Firewall. Die riesigen Subnetze (/64) machen klassisches Scannen unpraktisch, aber Angreifer finden Adressen über DNS, Logs, Muster (`::1`, EUI-64 aus MAC) und Multicast im lokalen Netz. Privacy Extensions erschweren Tracking von Clients.

## Quiz

? Was macht ein Rogue Router Advertisement?
+ ein Angreifer gibt sich als IPv6-Router aus und lenkt Verkehr über sich
- es verschlüsselt den Verkehr
- es blockiert DNS
- es löscht IP-Adressen
! RA Guard verhindert das auf Switches.

? Welches IPv6-Protokoll ersetzt ARP?
= Neighbor Discovery
= NDP
! Es ist ähnlich anfällig für Spoofing.

?tf Firewall-Regeln für IPv6 müssen genauso gepflegt werden wie für IPv4.
= wahr
! Oft wird IPv6 dabei vergessen.

? Welche Switch-Funktion blockiert gefälschte Router Advertisements?
= RA Guard
! Zusammen mit DHCPv6 Guard.

? Warum ist Rogue DHCPv6 in Windows-Netzen gefährlich?
+ Windows bevorzugt IPv6, ein Angreifer kann so einen eigenen DNS-Server verteilen
- weil Windows kein IPv6 kann
- weil DHCPv6 verschlüsselt ist
- weil es Drucker abschaltet
! Ein Baustein für Relay-Angriffe.

? Was schützt Geräte bei IPv6, da es kein klassisches NAT gibt?
= Firewall
= die Firewall
! Global adressierbare Geräte brauchen konsequente Filterregeln.
