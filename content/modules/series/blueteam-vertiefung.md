---
id: bt-01
title: Blue Team · EDR und Endpoint-Sicherheit
paths: cdsa, specialist
order: 20
difficulty: medium
icon: laptopcomputer.and.iphone
tags: blueteam
summary: Wie Endpoint Detection and Response arbeitet, Unterschied zu klassischem Virenschutz, Telemetrie, Erkennung, Reaktionsfunktionen, XDR und Betrieb im SOC.
---

## Vom Virenscanner zum EDR

| | klassischer Virenschutz | EDR |
|---|---|---|
| Erkennung | Signaturen bekannter Dateien | Verhalten, Telemetrie, Heuristik, Cloud-Analyse |
| Sicht | einzelne Datei | Prozessketten, Netzwerk, Registry, Speicher |
| Reaktion | löschen/quarantänisieren | Host isolieren, Prozess beenden, Dateien sammeln, Live-Response |
| Rückblick | kaum | Telemetrie über Wochen für Threat Hunting |

## Telemetrie

Ein EDR-Agent zeichnet u. a. Prozessstarts mit Befehlszeile und Elternprozess, Netzwerkverbindungen, Datei- und Registry-Änderungen, geladene Module und Speicherzugriffe auf – ähnlich wie Sysmon, aber zentral ausgewertet.

## Reaktionsfunktionen

- **Netzwerkisolation** eines Hosts (Verbindung nur noch zum EDR-Server)
- Prozesse beenden, Dateien in Quarantäne
- Artefakte sammeln (Speicher, Logs, Dateien)
- Live-Response-Shell für Analysten
- teils automatisches Zurücksetzen von Ransomware-Änderungen

## XDR

**Extended Detection and Response** verknüpft Endpunkt-, Identitäts-, E-Mail-, Cloud- und Netzwerkdaten in einer Plattform, damit Angriffsketten über Systemgrenzen hinweg erkannt werden.

## Betrieb

| Aufgabe | Hinweis |
|---|---|
| Abdeckung | jeder Endpunkt und Server braucht einen Agenten – Lücken sind blinde Flecken |
| Manipulationsschutz | Agenten dürfen nicht abschaltbar sein |
| Ausnahmen | so wenige wie möglich, dokumentiert |
| Alarme | Triage-Prozess, Playbooks ([[mod:bt-03|SOAR]]) |
| Tests | regelmäßige Purple-Team-Übungen ([[mod:bt-08|Purple Teaming]]) |

## Quiz

? Was kann ein EDR, was klassischer Virenschutz nicht kann?
+ Verhalten und Prozessketten analysieren und Hosts isolieren
- nur Signaturen vergleichen
- Drucker verwalten
- E-Mails schreiben

? Wofür steht XDR?
= Extended Detection and Response

? Welche Reaktionsfunktion trennt einen Host vom Netz, lässt aber die EDR-Verbindung bestehen?
= Netzwerkisolation
= Isolation

? Warum sind Hosts ohne EDR-Agent ein Problem?
+ Sie sind blinde Flecken für Erkennung und Reaktion
- Sie sind schneller
- Sie sind automatisch sicher
- Sie verbrauchen mehr Strom

@@@ MODULE @@@
---
id: bt-02
title: Blue Team · Log-Management und Aufbewahrung
paths: cdsa, specialist
order: 21
difficulty: medium
icon: externaldrive.fill.badge.checkmark
tags: blueteam
summary: Logquellen priorisieren, Datenmengen planen, Normalisierung, Aufbewahrungsfristen, Kosten, Integrität und Datenschutz bei zentraler Protokollierung.
---

## Was zuerst sammeln?

| Priorität | Quellen |
|---|---|
| 1 | Identität (AD, Entra ID, VPN, MFA), EDR, Firewall/Proxy, DNS |
| 2 | Server (Windows-Security, Sysmon, Linux auth/auditd), E-Mail-Gateway, Cloud-Audit-Logs |
| 3 | Anwendungen, Datenbanken, Netzwerkgeräte, WAF |
| 4 | Clients vollständig, NetFlow, Full PCAP für kritische Segmente |

## Datenmengen planen

Volumen pro Tag (EPS × Ereignisgröße × 86.400) bestimmt Lizenz- und Speicherkosten. Ein mittelgroßes Unternehmen erzeugt schnell zweistellige GB pro Tag. Filtern an der Quelle (z. B. Sysmon-Konfiguration) spart erheblich. Deine Range enthält dazu eine Beispielrechnung – siehe [[mod:cr-08|L5 Monitoring]].

## Normalisierung

Einheitliche Feldnamen (z. B. Elastic Common Schema, OCSF, Splunk CIM) ermöglichen Regeln über Quellen hinweg: `source.ip` ist überall `source.ip`.

## Aufbewahrung

| Stufe | Dauer (Beispiel) | Zweck |
|---|---|---|
| Hot | 30–90 Tage | schnelle Suche, Alarme |
| Warm/Cold | 6–12 Monate | Untersuchungen, Hunting |
| Archiv | Jahre | Compliance |

Fristen ergeben sich aus Sicherheitsbedarf (Angreifer bleiben oft monatelang unentdeckt), Gesetzen und Datenschutz (so kurz wie möglich, so lang wie nötig).

## Integrität

- Logs schnell vom Host wegschicken
- Schreibschutz bzw. unveränderliche Speicher (WORM)
- Zeit synchronisieren ([[mod:nw-06|NTP]])
- Ausfall einer Quelle selbst alarmieren („Heartbeat fehlt“)

## Quiz

? Welche Quellen haben höchste Priorität?
+ Identität, EDR, Firewall/Proxy, DNS
- Druckerlogs
- Bildschirmschoner
- Spiele

? Wie berechnet man das tägliche Logvolumen grob?
+ EPS × Ereignisgröße × 86.400
- Anzahl Mitarbeiter × 10
- Speicherplatz ÷ 2
- gar nicht

? Wie nennt man unveränderlichen Speicher für Logs?
= WORM

? Warum sollte der Ausfall einer Logquelle alarmieren?
+ Weil Angreifer Logging abschalten und sonst blinde Flecken entstehen
- Weil Speicher gespart wird
- Weil es schöner aussieht
- Es sollte nicht alarmieren

@@@ MODULE @@@
---
id: bt-03
title: Blue Team · SOAR und Playbooks
paths: cdsa
order: 22
difficulty: medium
icon: gearshape.arrow.triangle.2.circlepath
tags: blueteam
summary: Automatisierung im SOC – Anreicherung, Entscheidungslogik, Reaktionsschritte, Playbook-Design, Grenzen der Automatisierung und messbare Effekte.
---

## Was ist SOAR?

**Security Orchestration, Automation and Response** verbindet Werkzeuge (SIEM, EDR, Mail, Firewall, Ticketsystem, Threat Intelligence) und automatisiert wiederkehrende Schritte über **Playbooks**.

## Typische Automatisierungen

| Schritt | Beispiel |
|---|---|
| Anreichern | IP-Reputation, Geolokation, Asset-Kritikalität, Benutzerkontext |
| Prüfen | Hash in Sandbox, Domain-Alter, ähnliche Alarme |
| Entscheiden | Schwellen, Allowlists, Kritikalität |
| Reagieren | Mail aus Postfächern entfernen, IP blocken, Host isolieren, Konto sperren |
| Dokumentieren | Ticket mit allen Ergebnissen |

## Beispiel-Playbook: gemeldete Phishing-Mail

1. Mail und Header extrahieren
2. URLs und Anhänge prüfen (Reputation, Sandbox)
3. Suche nach gleicher Mail in allen Postfächern
4. bei bösartig: Mails entfernen, Domain blocken, Empfänger informieren
5. Klicks im Proxy prüfen → betroffene Konten an Analyst eskalieren
6. Rückmeldung an die meldende Person

Grundlagen: [[mod:d-09|Phishing-Analyse]].

## Grenzen

> [!WARNUNG] Automatisch, aber nicht blind
> Drastische Aktionen (Konten von Führungskräften sperren, Server isolieren) sollten eine menschliche Freigabe haben. Fehlerhafte Automatisierung kann selbst einen Ausfall verursachen – oder von Angreifern gezielt ausgelöst werden.

## Kennzahlen

Reduzierte MTTR, weniger manuelle Schritte pro Alarm, Anteil automatisch geschlossener False Positives.

## Quiz

? Wofür steht SOAR?
= Security Orchestration, Automation and Response
= Security Orchestration Automation and Response

? Was ist ein Playbook?
+ ein definierter, oft automatisierter Ablauf für einen Alarmtyp
- ein Theaterstück
- eine Firewall-Regel
- ein Backup

? Welche Aktionen sollten eine menschliche Freigabe haben?
+ Sperren wichtiger Konten und Isolieren kritischer Server
- Anreichern mit IP-Reputation
- Ticket anlegen
- Hash nachschlagen

? Welche Kennzahl verbessert SOAR typischerweise?
= MTTR

@@@ MODULE @@@
---
id: bt-04
title: Blue Team · Ransomware-Playbook
paths: cdsa, specialist
order: 23
difficulty: hard
icon: lock.trianglebadge.exclamationmark
tags: blueteam
summary: Ein vollständiges Playbook von Vorbereitung über die ersten 60 Minuten bis zur Wiederherstellung – technisch, organisatorisch, rechtlich und kommunikativ.
---

## Vorbereitung (vor dem Ernstfall)

- unveränderliche/offline Backups, getrennt authentifiziert, Wiederherstellung geübt
- Notfallkontakte offline verfügbar (Papier!), inkl. Versicherung, Forensik-Dienstleister, Behörden
- Netzwerkpläne und Asset-Liste aktuell
- Entscheidungsbefugnisse klar (Wer darf das Netz trennen?)
- Kommunikationskanal unabhängig von der eigenen IT

## Die ersten 60 Minuten

| Zeit | Aktion |
|---|---|
| 0–10 | Alarm bestätigen, Krisenteam einberufen, **betroffene Systeme isolieren** (nicht ausschalten – Speicher!) |
| 10–30 | Ausbreitung stoppen: Netzwerksegmente trennen, kompromittierte Konten sperren, Fernzugänge (VPN) prüfen |
| 30–60 | Umfang erfassen, Backups schützen (offline nehmen), Beweise sichern, Erstmeldung vorbereiten |

## Untersuchung

- Erstzugang finden (VPN, Phishing, exponierter Dienst)
- Persistenz und Werkzeuge der Angreifer identifizieren
- Datenabfluss prüfen (Double Extortion)
- Zeitleiste rekonstruieren ([[mod:d-08|Forensik]])

## Wiederherstellung

1. saubere Basis schaffen (Identität zuerst: AD prüfen oder neu aufbauen, krbtgt doppelt zurücksetzen)
2. Systeme aus sauberen Quellen neu aufbauen, Daten aus geprüften Backups
3. Härtung vor Wiederanbindung (MFA, Patches, Segmentierung)
4. verstärktes Monitoring in den Wochen danach

## Recht und Kommunikation

- Meldepflichten: DSGVO (72 h), NIS2 (24 h/72 h), ggf. weitere ([[mod:s-05|Recht]])
- Strafanzeige, Versicherung, betroffene Kunden
- interne und externe Kommunikation abgestimmt, faktenbasiert

> [!INFO] Lösegeld
> Behörden raten grundsätzlich davon ab, Lösegeld zu zahlen: Es finanziert weitere Angriffe, garantiert keine Entschlüsselung und keine Löschung gestohlener Daten.

## Quiz

? Warum sollten betroffene Systeme isoliert statt ausgeschaltet werden?
+ Damit flüchtige Beweise im Arbeitsspeicher erhalten bleiben
- Damit sie schneller verschlüsseln
- Weil Ausschalten verboten ist
- Damit Backups starten

? Was wird bei der Wiederherstellung zuerst abgesichert?
+ die Identitätsinfrastruktur (AD)
- die Drucker
- die Website
- die Kaffeemaschine

? Wo sollten Notfallkontakte zusätzlich verfügbar sein?
+ offline, z. B. auf Papier
- nur im E-Mail-Postfach
- nur auf dem Fileserver
- nirgends

? Wie heißt Erpressung mit Verschlüsselung und Datenveröffentlichung?
= Double Extortion

?tf Behörden empfehlen grundsätzlich, Lösegeld zu zahlen.
= falsch

@@@ MODULE @@@
---
id: bt-05
title: Blue Team · Insider-Bedrohungen
paths: cdsa, specialist
order: 24
difficulty: medium
icon: person.fill.viewfinder
tags: blueteam
summary: Böswillige, fahrlässige und kompromittierte Innentäter, Warnsignale, UEBA, DLP, Prozesse für Ein- und Austritte und der richtige Umgang mit Datenschutz und Mitbestimmung.
---

## Arten von Innentätern

| Art | Beispiel |
|---|---|
| böswillig | Datendiebstahl vor dem Wechsel zur Konkurrenz, Sabotage |
| fahrlässig | Daten an private Mailadresse, unsichere Cloud-Freigabe |
| kompromittiert | Konto wird von externem Angreifer genutzt |

## Warnsignale (technisch)

- ungewöhnlich große Downloads oder Exporte
- Zugriff auf Daten außerhalb der eigenen Rolle
- Aktivität zu ungewöhnlichen Zeiten
- Nutzung privater Cloud-Speicher oder USB-Medien
- Häufung kurz vor dem Austrittsdatum

## Werkzeuge

| Werkzeug | Zweck |
|---|---|
| UEBA (User and Entity Behavior Analytics) | Abweichungen vom üblichen Verhalten erkennen |
| DLP | Abfluss sensibler Daten erkennen und verhindern |
| Zugriffsprotokollierung | Nachvollziehbarkeit |
| PAM | privilegierte Aktionen aufzeichnen |

## Prozesse

- Least Privilege und Funktionstrennung
- sauberer Austrittsprozess ([[mod:bsi-02|ORP – Personal]])
- Vier-Augen-Prinzip für kritische Aktionen

> [!WARNUNG] Datenschutz und Mitbestimmung
> Überwachung von Mitarbeitenden ist in Deutschland streng geregelt (DSGVO, BDSG, Betriebsverfassungsgesetz). Maßnahmen brauchen Rechtsgrundlage, Verhältnismäßigkeit, Transparenz und meist eine Betriebsvereinbarung.

## Quiz

? Welche Arten von Innentätern gibt es?
+ böswillig
+ fahrlässig
+ kompromittiert
- zufällig fehlerfrei

? Wofür steht UEBA?
= User and Entity Behavior Analytics

? Welches Gesetz regelt in Deutschland die Mitbestimmung bei Mitarbeiterüberwachung?
= Betriebsverfassungsgesetz
= BetrVG

? Welches Warnsignal ist typisch für Datendiebstahl vor einem Wechsel?
+ große Downloads kurz vor dem Austrittsdatum
- ein Urlaubsantrag
- ein neues Hintergrundbild
- ein Passwortwechsel

@@@ MODULE @@@
---
id: bt-06
title: Blue Team · Deception und Honeypots
paths: cdsa
order: 25
difficulty: medium
icon: ant.fill
tags: blueteam
summary: Täuschung als Verteidigung – Honeypots, Honeytokens, Canary-Dateien und -Konten, wie sie präzise Alarme erzeugen und was beim Betrieb zu beachten ist.
---

## Die Idee

Legitime Benutzer haben keinen Grund, ein Köderobjekt zu berühren. **Jede** Interaktion ist deshalb verdächtig – Deception liefert Alarme mit sehr wenigen Fehlalarmen.

## Varianten

| Variante | Beispiel |
|---|---|
| Honeypot | Server oder Dienst, der echt wirkt, aber nur beobachtet |
| Honeytoken / Canary Token | Datei, URL, API-Schlüssel oder DNS-Name, der beim Benutzen meldet |
| Honey-Account | AD-Konto mit verlockendem Namen, das nie genutzt wird |
| Honey-SPN | Dienstkonto mit SPN als Köder für Ticket-Anfragen |
| Breadcrumbs | gefälschte Zugangsdaten in Skripten oder Speicher, die zu Ködern führen |

| Interaktionsgrad | Beschreibung |
|---|---|
| Low Interaction | simuliert nur Dienste, wenig Risiko |
| High Interaction | echtes System, mehr Erkenntnisse, mehr Risiko und Aufwand |

## Betrieb

- Köder glaubwürdig und in die Umgebung passend gestalten
- Alarme mit hoher Priorität ins SIEM
- Honeypots isolieren, damit sie nicht selbst zum Sprungbrett werden
- Ergebnisse für Threat Intelligence nutzen

Siehe auch [[mod:a-04|AD verteidigen]].

## Quiz

? Warum erzeugen Honeytokens sehr wenige Fehlalarme?
+ Legitime Benutzer haben keinen Grund, sie zu benutzen
- Sie sind verschlüsselt
- Sie sind unsichtbar
- Sie werden nie geprüft

? Was ist ein Honey-SPN?
+ ein Köder-Dienstkonto, dessen Ticket-Anfrage alarmiert
- ein Netzwerkprotokoll
- ein Passwortmanager
- ein Zertifikat

? Welcher Honeypot-Typ bietet mehr Erkenntnisse, aber mehr Risiko?
= High Interaction
= High-Interaction

? Was muss bei Honeypots beachtet werden?
+ Isolation, damit sie nicht zum Sprungbrett werden
- sie müssen im Produktivnetz ohne Kontrolle laufen
- sie dürfen keine Logs schreiben
- sie brauchen Admin-Rechte in der Domäne

@@@ MODULE @@@
---
id: bt-07
title: Blue Team · Threat Intelligence im Betrieb
paths: cdsa
order: 26
difficulty: medium
icon: globe.badge.chevron.backward
tags: blueteam
summary: Der Intelligence-Zyklus, Quellen bewerten, TLP, IOC-Lebenszyklus, Integration in SIEM und EDR und wie aus Berichten konkrete Erkennungen werden.
---

## Der Intelligence-Zyklus

1. **Anforderungen** – Was müssen wir wissen? (Branche, Technik, Bedrohungen)
2. **Sammlung** – Quellen
3. **Verarbeitung** – normalisieren, deduplizieren
4. **Analyse** – Relevanz, Kontext, Bewertung
5. **Verteilung** – an SOC, Management, IT
6. **Feedback** – War es nützlich?

## Quellen

| Typ | Beispiele |
|---|---|
| öffentlich | CERT-Bund/BSI, CISA, Herstellerberichte, MITRE ATT&CK |
| Communities | ISACs, MISP-Communities |
| kommerziell | Threat-Intel-Plattformen |
| intern | eigene Vorfälle, Honeypots, Phishing-Meldungen |

## Traffic Light Protocol

| Stufe | Weitergabe |
|---|---|
| TLP:RED | nur an die direkt beteiligten Personen |
| TLP:AMBER(+STRICT) | innerhalb der eigenen Organisation (und Kunden bei AMBER) nach Need-to-know |
| TLP:GREEN | innerhalb der Community |
| TLP:CLEAR | öffentlich |

## IOCs richtig verwenden

- Ablaufdatum für IP- und Domain-Indikatoren
- Kontext speichern (Quelle, Kampagne, Vertrauen)
- vor dem Blockieren auf Fehlalarme prüfen (z. B. geteilte Cloud-IPs)
- rückwirkend suchen: Waren die Indikatoren schon in unseren Logs?

## Vom Bericht zur Erkennung

Aus einem Bericht über eine Angreifergruppe werden **TTPs** extrahiert, auf ATT&CK abgebildet, mit der eigenen Erkennungsabdeckung verglichen und Lücken mit neuen Regeln geschlossen ([[mod:d-04|Threat Hunting]]).

## Quiz

? Welche TLP-Stufe bedeutet „öffentlich“?
= TLP:CLEAR
= CLEAR

? Welche TLP-Stufe beschränkt Informationen auf direkt beteiligte Personen?
= TLP:RED
= RED

? Warum brauchen IP-Indikatoren ein Ablaufdatum?
+ IPs wechseln den Besitzer und werden sonst zu Fehlalarmen
- IPs werden gelöscht
- aus Lizenzgründen
- weil IPv6 kommt

? Was ist der erste Schritt im Intelligence-Zyklus?
= Anforderungen
= Requirements

@@@ MODULE @@@
---
id: bt-08
title: Blue Team · Purple Teaming und Übungen
paths: cdsa, cyberrange, cpts
order: 27
difficulty: medium
icon: person.2.wave.2.fill
tags: blueteam
summary: Red und Blue gemeinsam – Übungsformate, Planung mit ATT&CK, Adversary Emulation, Messung der Erkennungsabdeckung und kontinuierliche Verbesserung.
---

## Was ist Purple Teaming?

Beim **Purple Teaming** arbeiten Red Team (Angriff) und Blue Team (Verteidigung) **zusammen**: Eine Technik wird ausgeführt, das Blue Team prüft sofort, ob und wie sie erkannt wurde, und beide verbessern gemeinsam Erkennung und Schutz.

## Übungsformate

| Format | Beschreibung |
|---|---|
| Tabletop | Szenario wird am Tisch durchgesprochen (Prozesse, Entscheidungen) |
| Atomic Tests | einzelne Techniken gezielt ausführen (z. B. mit Atomic Red Team in Testumgebungen) |
| Adversary Emulation | Abläufe einer realen Angreifergruppe nachstellen |
| Red Team Exercise | verdeckter, realistischer Angriff mit Zielen |
| Cyber-Range-Übung | vollständige Umgebung mit Teams und Scoring ([[mod:cr-12|Range: Teams und Spielregeln]]) |

## Ablauf einer Purple-Team-Runde

1. Techniken auswählen (Threat Intelligence, ATT&CK)
2. Erwartung festhalten: Welche Logs, welche Alarme?
3. Technik kontrolliert ausführen
4. Ergebnis: erkannt / nur protokolliert / nicht sichtbar
5. Lücken schließen (Logging, Regel, Härtung)
6. erneut testen

## Abdeckung messen

Eine **ATT&CK-Heatmap** (z. B. mit dem ATT&CK Navigator) zeigt, welche Techniken erkannt, protokolliert oder blind sind. Ziel ist keine 100 % Abdeckung, sondern Abdeckung der **relevantesten** Techniken.

## Quiz

? Was unterscheidet Purple Teaming von einer klassischen Red-Team-Übung?
+ Red und Blue arbeiten zusammen und verbessern sofort gemeinsam
- Es gibt kein Blue Team
- Es wird nichts getestet
- Es ist immer verdeckt

? Welches Format bespricht ein Szenario am Tisch?
= Tabletop
= Tabletop-Übung

? Welches Werkzeug visualisiert die ATT&CK-Abdeckung als Heatmap?
= ATT&CK Navigator
= Navigator

? Wie heißt das Nachstellen der Abläufe einer realen Angreifergruppe?
= Adversary Emulation

?tf Ziel ist eine 100-prozentige Abdeckung aller ATT&CK-Techniken.
= falsch
