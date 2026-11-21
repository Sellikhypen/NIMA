---
id: cr-24
title: Szenario-Katalog
paths: cyberrange
order: 24
difficulty: hard
icon: list.bullet.rectangle
summary: Kapitel 24 deiner Cyber-Range-Dokumentation: Szenario-Katalog.
source: Cyber_Range_Dokumentation.docx
htb: 
---

## Überblick

Ein einziges Szenario nutzt sich schnell ab: Teams kennen nach der zweiten Übung den Ablauf. Eine Range braucht daher einen **Katalog** von Szenarien, die dieselbe Infrastruktur unterschiedlich nutzen. Dieses Kapitel beschreibt Szenarien bewusst auf **Planungsebene** – Ziel, Umgebung, Lernziele, erwartete Spuren, Injects. Die konkrete Ausgestaltung der Angriffsseite liegt im vertraulichen Szenario-Handbuch des White Teams und wird nicht in allgemeine Dokumentation übernommen.

## Aufbau eines Szenario-Steckbriefs

| **Feld** | **Inhalt** |
|---|---|
| **Name und Version** | eindeutige Bezeichnung, Versionsnummer, Autor, Datum |
| **Zielgruppe und Niveau** | z. B. SOC-Analysten Stufe 1–2, Dauer, Teamgröße |
| **Lernziele** | messbar, mit Bloom-Stufe (Kapitel 31) |
| **Bedrohungsakteur** | fiktives Profil: Motivation, Fähigkeiten, typische Taktiken |
| **Umgebung** | benötigte VMs, Netze, Artefakte, NPC-Profile |
| **Phasen** | Taktiken und ATT&CK-Techniken je Phase (ohne Ausführungsdetails) |
| **Erwartete Telemetrie** | welche Data Components, Logs und Alarme jede Phase erzeugt |
| **Injects** | nicht-technische Ereignisse mit Zeitpunkt |
| **Bewertung** | Rubrik, Musterlösung, Zeitziele |
| **Sicherheitsaspekte** | harmlose Simulation von Schadwirkungen, Reset-Verfahren |

Tabelle 153: Pflichtfelder eines Szenario-Steckbriefs

## Szenario »Ransomware im Mittelstand«

**Lage:** Eine finanziell motivierte Gruppe dringt über eine Phishing-Mail ein, verschafft sich Administratorrechte und verschlüsselt die Dateiserver. **Schwerpunkt** ist die frühzeitige Erkennung und die Entscheidung unter Zeitdruck.

![Abbildung 64: Szenario »Ransomware« mit Erkennungspunkten je Phase](asset:cyberrange/cr-24-064.png)

**So liest man die Abbildung:**

- Die **obere Reihe** zeigt die Phasen des Angriffs mit ihrer ATT&CK-Technik.
- Die **untere Reihe** zeigt für jede Phase den **Erkennungspunkt** – die Datenquelle, in der das Blue Team die Phase sehen kann.
- Je weiter links eine Phase erkannt wird, desto geringer ist der Schaden. Ziel des Blue Teams ist die Eindämmung vor der Verschlüsselung.
- Die Verschlüsselung wird in der Range **nur simuliert** (Dateien umbenennen, Erpresserbrief ablegen) und per Snapshot rückgängig gemacht.
| **Lernziel** | **Nachweis** |
|---|---|
| **Erstzugriff über Mail und Prozesskette erkennen** | Ticket mit Absender, Anhangstyp, betroffenem Host, Zeitpunkt |
| **Verdächtigen Zugriff auf Anmeldedaten erkennen** | Alarm oder Hunting-Fund zu LSASS-Zugriffen, betroffenes Konto benannt |
| **Ausbreitung eindämmen** | Isolierte Hosts, gesperrte Konten, ohne Ausfall unbeteiligter Dienste |
| **Wiederherstellung planen und durchführen** | Dienst wieder grün, Datenstand dokumentiert |
| **Entscheidungsvorlage für die Geschäftsführung** | Inject-Antwort mit Optionen, Risiken, Meldepflichten |

Tabelle 154: Lernziele des Ransomware-Szenarios

## Szenario »Webshop unter Beschuss«

**Lage:** Der Webshop in der DMZ wird über eine Schwachstelle in der Web-Anwendung kompromittiert; der Angreifer versucht, von dort ins interne Netz zu gelangen. **Schwerpunkt** sind Web-Logs, Netzwerkanalyse und Segmentierung.

![Abbildung 65: Szenario »Webshop« mit Spuren und Gegenmaßnahmen](asset:cyberrange/cr-24-065.png)

**So liest man die Abbildung:**

- Oben die **Phasen** vom Erkunden der Anwendung bis zum Zugriff auf interne Daten.
- Links unten die **Spuren**, die das Blue Team in Web-Logs, Suricata, Zeek und auf dem Host findet.
- Rechts unten die **Gegenmaßnahmen**, die im AAR besprochen und in einer Folgeübung geprüft werden.
> [!TIPP] Besonderer Lerneffekt: Segmentierung
> Das Szenario zeigt eindrücklich, warum die Zonenmatrix (Kapitel 5.12) wichtig ist: Ein kompromittierter Webserver ist nur so gefährlich wie die Wege, die von der DMZ ins interne Netz offen sind. Eine gute Blue-Team-Antwort beschränkt diese Wege, ohne den Shop vom Netz zu nehmen.

## Szenario »Phishing-Kampagne«

**Lage:** Eine breit gestreute Phishing-Kampagne erreicht viele Postfächer. **Schwerpunkt** sind E-Mail-Analyse, Zusammenarbeit mit Benutzern (gespielt von NPCs und Injects) und schnelle Bereinigung. Das Szenario eignet sich gut für Einsteiger und für gemischte Teams aus IT und Fachabteilung.

![Abbildung 66: Weg einer Phishing-Mail innerhalb der Range – alles bleibt im SINET](asset:cyberrange/cr-24-066.png)

**So liest man die Abbildung:**

- Die Kampagne wird im **SINET** erzeugt; Absender-Domain und Infrastruktur sind simuliert.
- Der Mailserver der Firma prüft **SPF**, **DKIM** und **DMARC** – das Blue Team kann diese Ergebnisse in den Logs nachvollziehen.
- NPCs öffnen die Mail gemäß ihrer GHOSTS-Timeline mit einer festgelegten Klickquote; daraus entstehen realistische, aber kontrollierte Treffer.
- Eine Rückverbindung erfolgt ausschließlich zu einem Server im SINET. Sie verlässt nie die Range.
| **Aufgabe des Blue Teams** | **Hilfsmittel** |
|---|---|
| **Header-Analyse: Absender, Return-Path, Received-Kette, Authentisierungsergebnisse** | Mail-Client, Zeek smtp.log |
| **Umfang feststellen: Wer hat die Mail erhalten, wer hat geklickt?** | Mail-Logs, Proxy-/Zeek-http.log |
| **Indikatoren sammeln und blockieren (Domain, IP, Hash)** | Firewall, DNS, Mail-Gateway |
| **Betroffene Postfächer bereinigen, Benutzer informieren** | Inject-Kanal, Ticketsystem |
| **Kurzbericht an die Geschäftsführung** | Vorlage, Rubrik (Kapitel 21.1) |

Tabelle 155: Aufgaben im Phishing-Szenario

## Weitere Szenario-Ideen

| **Szenario** | **Kern** | **Besonders geeignet für** |
|---|---|---|
| **Insider** | Ein Mitarbeiter sammelt und entwendet Daten mit legitimen Rechten | Verhaltensanalyse, Datenschutzfragen, HR-Zusammenarbeit |
| **Lieferkette** | Ein kompromittiertes Software-Update eines Dienstleisters | Vertrauensbeziehungen, Netzwerk-Baselines |
| **Cloud-Konto-Übernahme** | Gestohlene Zugangsdaten zu einem (simulierten) Cloud-Dienst | Identitäts-Logs, MFA, Kapitel 26 |
| **Industrie-Störung** | Manipulation einer Steuerung in der OT-Umgebung | OT-Monitoring, Kapitel 25 |
| **DDoS auf den Webshop** | Überlast durch simulierten Verkehr aus dem SINET (nur innerhalb der Range) | Verfügbarkeit, Kommunikation, Priorisierung |
| **Wiederherstellung nach Totalausfall** | Kein Angriff mehr sichtbar, aber alle Server verschlüsselt | Backup, Notbetrieb, Priorisierung |
| **Krisenstab (Table-Top)** | Rein organisatorisch: Entscheidungen, Recht, Presse | Führungskräfte, NIS2-Schulungspflicht |

Tabelle 156: Weitere Szenarien für den Katalog
