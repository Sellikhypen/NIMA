---
id: cr-32
title: Praxislabore für das Blue Team
paths: cyberrange
order: 32
difficulty: hard
icon: shield.lefthalf.filled
summary: Kapitel 32 deiner Cyber-Range-Dokumentation: Praxislabore für das Blue Team.
source: Cyber_Range_Dokumentation.docx
htb: 
---

## Überblick

Die folgenden sechzehn Labore bilden die erste Stufe des Ausbildungspfads. Sie laufen auf einer kleinen Sandbox (»Nordlicht-Mini«) und trainieren gezielt die Fähigkeiten, die in den großen Übungen gebraucht werden: Umgebung verstehen, Daten lesen, Regeln schreiben, härten, wiederherstellen und berichten. Angriffsaktivitäten, die für einzelne Labore nötig sind, werden ausschließlich von **vorbereiteten, vom White Team freigegebenen Szenario-Skripten** erzeugt – die Labore selbst sind reine Verteidigungsübungen.

## Die Lab-Umgebung »Nordlicht-Mini«

![Abbildung 79: Topologie der Praxislabore mit sechs VMs](asset:cyberrange/cr-32-079.png)

**So liest man die Abbildung:**

- Die Sandbox besteht aus **sechs VMs**: eine Linux-Maschine in der RED-Zone (nur für die Szenario-Skripte), ein Webserver in der DMZ, ein Domänencontroller und eine Workstation im CORP-Netz, ein Analysten-Arbeitsplatz und ein Sensor.
- Alle Netze laufen über die Firewall in der Mitte; der Sensor erhält eine Kopie des Verkehrs (gelb gestrichelt).
- Die Sandbox benötigt rund 26 GB RAM – die Pilot-Range kann mehrere davon parallel betreiben.
| **Nr.** | **Labor** | **Dauer** | **Fähigkeit** | **Bloom-Stufe** |
|---|---|---|---|---|
| **1** | Range aus Code aufbauen und zurücksetzen | 60 Min. | IaC verstehen, Lebenszyklus | Anwenden |
| **2** | Zonenmatrix überprüfen | 45 Min. | Netzsegmentierung, Firewall-Logs | Analysieren |
| **3** | Zeek-Logs lesen | 60 Min. | Netzwerkverkehr verstehen | Verstehen / Anwenden |
| **4** | Sysmon-Prozessketten auswerten | 60 Min. | Host-Telemetrie | Analysieren |
| **5** | Eine Sigma-Regel entwickeln und testen | 90 Min. | Detection Engineering | Erschaffen |
| **6** | Eine Wazuh-Regel mit wazuh-logtest prüfen | 60 Min. | SIEM-Regeln | Anwenden |
| **7** | Eine Phishing-Mail analysieren | 45 Min. | Header, SPF/DKIM/DMARC | Analysieren |
| **8** | Beacons im Verbindungsprotokoll finden | 60 Min. | Threat Hunting | Analysieren |
| **9** | Kerberos-Ereignisse auswerten | 60 Min. | AD-Überwachung | Analysieren |
| **10** | Windows-Netz härten und Wirkung prüfen | 90 Min. | Härtung per GPO | Anwenden / Bewerten |
| **11** | Wiederherstellung aus Backup | 60 Min. | Business Continuity | Anwenden |
| **12** | Incident-Bericht schreiben | 60 Min. | Kommunikation | Bewerten |
| **13** | Firewall-Protokolle auswerten | 45 Min. | Netzsegmentierung, Log-Analyse | Analysieren |
| **14** | DNS-Protokolle untersuchen | 60 Min. | Anomalien im DNS | Analysieren |
| **15** | Einen Linux-Webserver härten | 90 Min. | Härtung, SCA | Anwenden / Bewerten |
| **16** | Einen Zeitstrahl aus mehreren Quellen erstellen | 60 Min. | Korrelation, Zeitbasis | Analysieren / Bewerten |

Tabelle 181: Übersicht der Praxislabore

> [!INFO] Aufbau jedes Labors
> Jedes Labor hat dieselbe Struktur: **Ziel**, **Voraussetzungen**, **Ablauf** in wenigen Schritten, **Erfolgskriterium** (automatisch prüfbar, wo möglich) und **Vertiefung** für schnelle Teilnehmer. Die Erfolgskriterien prüft ein kleines Skript im Portal, sodass Labore auch ohne Trainer durchgeführt werden können.

## Labor 1: Range aus Code aufbauen und zurücksetzen

| **Ziel** | **Voraussetzungen** |
|---|---|
| **Den Lebenszyklus einer Sandbox verstehen: aufbauen, Snapshot »clean«, verändern, zurücksetzen.** | Zugang zum Lab-Repository und zur Pipeline (nur lesend für Proxmox) |

**Ablauf:**

1. Repository klonen und die Topologie-Datei lesen: Welche Hosts und Netze gibt es?
1. Pipeline für die eigene Sandbox starten und den `tofu plan` im Protokoll nachvollziehen.
1. Nach dem Aufbau eine Datei auf ws01 anlegen.
1. Reset über das Portal auslösen und prüfen, dass die Datei verschwunden ist.
> [!ERGEBNIS] Erfolgskriterium
> Die Teilnehmenden erklären, warum der Reset nur Sekunden dauert (Copy-on-Write, Kapitel 4.8), und die Datei ist nach dem Reset nicht mehr vorhanden.

**Vertiefung:** Messen, wie lange ein vollständiger Neuaufbau im Vergleich zum Snapshot-Reset dauert.

## Labor 2: Zonenmatrix überprüfen

| **Ziel** | **Voraussetzungen** |
|---|---|
| **Prüfen, ob die tatsächlichen Netzwege der dokumentierten Zonenmatrix entsprechen.** | Analysten-Arbeitsplatz, Lesezugriff auf Firewall-Logs |

**Ablauf:**

1. Von ws01 aus mit einem einfachen Port-Check (z. B. `Test-NetConnection`) die freigegebenen Dienste in der DMZ prüfen.
1. Einen nicht freigegebenen Weg testen (z. B. CORP → RED) und den verworfenen Versuch im Firewall-Log finden.
1. Ergebnisse in eine Tabelle »Soll / Ist« eintragen.
1. Jede Abweichung als Befund mit Empfehlung formulieren.
> [!ERGEBNIS] Erfolgskriterium
> Alle erlaubten Wege funktionieren, alle verbotenen sind im Firewall-Log als blockiert nachgewiesen; die Tabelle ist vollständig.

**Vertiefung:** Eine automatische Prüfung als Skript formulieren, die vor jeder Übung läuft.

## Labor 3: Zeek-Logs lesen

| **Ziel** | **Voraussetzungen** |
|---|---|
| **Die wichtigsten Zeek-Logs kennen und Fragen zum Netzverkehr beantworten.** | Zugriff auf Security Onion (Hunt), Kapitel 8.10 |

**Ablauf:**

1. Im `conn.log` die zehn Verbindungen mit den meisten übertragenen Bytes finden.
1. Im `dns.log` alle aufgelösten Domains der letzten Stunde auflisten und ungewöhnliche markieren.
1. Im `http.log` die User-Agents zählen und Ausreißer bestimmen.
1. Zu einer auffälligen Verbindung per »Pivot to PCAP« das Rohpaket öffnen.
> [!ERGEBNIS] Erfolgskriterium
> Drei vorgegebene Fragen (z. B. »Welcher Host hat die meisten DNS-Anfragen gestellt?«) sind richtig beantwortet und mit der verwendeten Abfrage belegt.

**Vertiefung:** Ein eigenes Dashboard mit den drei wichtigsten Übersichten anlegen.

## Labor 4: Sysmon-Prozessketten auswerten

| **Ziel** | **Voraussetzungen** |
|---|---|
| **Aus Sysmon-Ereignissen nachvollziehen, welcher Prozess welchen gestartet hat, und Auffälligkeiten erkennen.** | Wazuh- oder Security-Onion-Zugang, Kapitel 8.12 |

**Ablauf:**

1. Das White-Team-Skript erzeugt auf ws01 eine Folge von Prozessstarts (Büroanwendung startet Skriptinterpreter).
1. Alle Sysmon-Ereignisse mit ID 1 des Hosts im Zeitraum filtern.
1. Die Eltern-Kind-Kette als Baum aufzeichnen (ParentImage → Image → CommandLine).
1. Bewerten, welcher Schritt in einem normalen Büroalltag unüblich ist.
> [!ERGEBNIS] Erfolgskriterium
> Die Prozesskette ist vollständig und in der richtigen Reihenfolge dokumentiert; der unübliche Schritt ist begründet benannt.

**Vertiefung:** Prüfen, welche weiteren Sysmon-Ereignisse (3, 11, 22) zur selben Kette gehören.

## Labor 5: Eine Sigma-Regel entwickeln und testen

| **Ziel** | **Voraussetzungen** |
|---|---|
| **Eine Detektionsregel nach dem Prinzip Detection as Code entwickeln.** | Repository »detections«, sigma-cli, Beispiel-Logs |

**Ablauf:**

1. Für die Prozesskette aus Labor 4 eine Hypothese formulieren.
1. Eine Sigma-Regel mit Auswahl und mindestens einem Filter gegen Fehlalarme schreiben.
1. Die Regel in die Abfragesprache des SIEM konvertieren.
1. Mit positiven und negativen Beispiel-Logs testen; Pull Request mit Testergebnis erstellen.
> [!ERGEBNIS] Erfolgskriterium
> Die Regel erkennt alle positiven Beispiele, schlägt bei keinem negativen an und besteht die Pipeline-Prüfung.

**Vertiefung:** Die Fehlalarmquote im NPC-Grundrauschen einer Stunde messen.

## Labor 6: Eine Wazuh-Regel mit wazuh-logtest prüfen

| **Ziel** | **Voraussetzungen** |
|---|---|
| **Verstehen, wie Decoder und Regeln in Wazuh zusammenwirken.** | Lesezugriff auf den Wazuh-Manager (Lab-Instanz), Kapitel 8.8 |

**Ablauf:**

1. Eine Beispiel-Logzeile in `wazuh-logtest` einfügen und Decoder sowie Regel bestimmen.
1. Eine eigene Regel mit ID ab 100000 in einer Lab-Kopie von `local_rules.xml` ergänzen.
1. Mit derselben Logzeile prüfen, dass die eigene Regel greift.
1. Eine ähnliche, harmlose Zeile prüfen, die nicht greifen darf.
> [!ERGEBNIS] Erfolgskriterium
> Die eigene Regel greift für die positive und nicht für die negative Probe; Level und Beschreibung sind sinnvoll gewählt.

**Vertiefung:** Die Regel mit einer ATT&CK-Technik verknüpfen und im Dashboard prüfen.

## Labor 7: Eine Phishing-Mail analysieren

| **Ziel** | **Voraussetzungen** |
|---|---|
| **Die Echtheit einer E-Mail anhand ihres Headers bewerten.** | Mail-Client auf dem Analysten-Arbeitsplatz, Beispiel-Mail aus dem SINET |

**Ablauf:**

1. Den vollständigen Header anzeigen und die Received-Kette von unten nach oben lesen.
1. Die Ergebnisse von SPF, DKIM und DMARC aus dem Header ablesen.
1. Absender-Domain mit der echten Firmen-Domain vergleichen (Schreibweise, Alter im SINET-DNS).
1. Indikatoren (Domain, IP, Anhang-Hash) zusammenstellen.
> [!ERGEBNIS] Erfolgskriterium
> Die Mail ist begründet als Phishing eingestuft; alle drei Authentisierungsergebnisse sind korrekt benannt; die Indikatorenliste ist vollständig.

**Vertiefung:** Eine Blockierregel für die Domain vorschlagen und ihre Nebenwirkungen bewerten.

## Labor 8: Beacons im Verbindungsprotokoll finden

| **Ziel** | **Voraussetzungen** |
|---|---|
| **Regelmäßige Rückverbindungen in großen Datenmengen erkennen.** | Zeek-`conn.log` einer Stunde mit NPC-Grundrauschen und einem simulierten Beacon |

**Ablauf:**

1. Verbindungen nach Ziel gruppieren und die Anzahl je Ziel bestimmen.
1. Für die Top-Ziele die zeitlichen Abstände zwischen Verbindungen berechnen.
1. Ziele mit sehr gleichmäßigen Abständen (trotz kleiner Schwankung) markieren.
1. Den verdächtigen Host und den Zeitpunkt der ersten Verbindung bestimmen.
> [!ERGEBNIS] Erfolgskriterium
> Der simulierte Beacon ist mit Host, Ziel, Intervall und Startzeit identifiziert; legitime regelmäßige Verbindungen (z. B. Updates, NTP) sind als solche erkannt.

**Vertiefung:** Die Analyse als wiederverwendbare Abfrage oder kleines Skript festhalten.

## Labor 9: Kerberos-Ereignisse auswerten

| **Ziel** | **Voraussetzungen** |
|---|---|
| **Auffällige Muster in Kerberos-Ereignissen eines Domänencontrollers erkennen.** | Security-Log von dc01 im SIEM, Kapitel 14.7 |

**Ablauf:**

1. Alle Ereignisse 4768 und 4769 des Zeitraums filtern.
1. Nach Verschlüsselungstyp gruppieren und Abweichungen vom Normalfall (AES) suchen.
1. Prüfen, welches Konto ungewöhnlich viele Diensttickets angefordert hat.
1. Das betroffene Dienstkonto benennen und eine Empfehlung formulieren.
> [!ERGEBNIS] Erfolgskriterium
> Das auffällige Muster und das betroffene Dienstkonto sind korrekt benannt; die Empfehlung umfasst ein langes, zufälliges Passwort bzw. ein verwaltetes Dienstkonto (gMSA).

**Vertiefung:** Die Sigma-Regel aus Kapitel 23.2 gegen die Daten testen.

## Labor 10: Windows-Netz härten und Wirkung prüfen

| **Ziel** | **Voraussetzungen** |
|---|---|
| **Typische Schwachstellen im Windows-Netz per Gruppenrichtlinie schließen und die Wirkung nachweisen.** | Administrativer Zugang zur Lab-Domäne |

**Ablauf:**

1. Per Gruppenrichtlinie LLMNR und NetBIOS über TCP/IP deaktivieren.
1. SMB-Signing für Server und Clients erzwingen.
1. Richtlinie anwenden (`gpupdate /force`) und mit `gpresult` prüfen.
1. Das White-Team-Prüfskript erneut ausführen lassen und das Ergebnis vergleichen.
> [!ERGEBNIS] Erfolgskriterium
> Das Prüfskript meldet die zuvor offenen Punkte als geschlossen; die Dienste der Lab-Domäne funktionieren weiterhin.

**Vertiefung:** Bewerten, welche Altanwendungen in einer echten Umgebung durch diese Härtung betroffen sein könnten.

## Labor 11: Wiederherstellung aus Backup

| **Ziel** | **Voraussetzungen** |
|---|---|
| **Einen Dienst aus einer Sicherung wiederherstellen und die Wiederherstellungszeit messen.** | Zugriff auf eine Lab-Instanz des Backup-Servers |

**Ablauf:**

1. Den simulierten Ausfall des Webservers feststellen (Service-Check rot).
1. Den letzten konsistenten Sicherungsstand auswählen und eine Wiederherstellung in eine neue VM durchführen.
1. Netzwerk und Funktion prüfen, Service-Check grün.
1. Dauer vom Ausfall bis zur Wiederherstellung dokumentieren.
> [!ERGEBNIS] Erfolgskriterium
> Der Dienst ist wiederhergestellt; die gemessene Zeit liegt unter dem vereinbarten RTO; der Ablauf ist protokolliert.

**Vertiefung:** Prüfen, welche Daten zwischen letzter Sicherung und Ausfall verloren gegangen wären (RPO).

## Labor 12: Incident-Bericht schreiben

| **Ziel** | **Voraussetzungen** |
|---|---|
| **Die Ergebnisse der Labore 4, 8 und 9 in einem verständlichen Bericht zusammenführen.** | Ergebnisse der vorherigen Labore, Berichtsvorlage, Rubrik (Kapitel 21.1) |

**Ablauf:**

1. Einen Zeitstrahl aller Funde erstellen.
1. Betroffene Systeme, Konten und Techniken (mit ATT&CK-IDs) benennen.
1. Getroffene und empfohlene Maßnahmen beschreiben.
1. Eine Zusammenfassung von höchstens fünf Sätzen für die Geschäftsführung schreiben.
> [!ERGEBNIS] Erfolgskriterium
> Der Bericht erreicht mindestens 8 von 10 Punkten der Rubrik; die Management-Zusammenfassung ist ohne Fachbegriffe verständlich.

**Vertiefung:** Den Bericht von einer zweiten Person gegenlesen lassen und Rückmeldungen einarbeiten.

## Labor 13: Firewall-Protokolle auswerten

| **Ziel** | **Voraussetzungen** |
|---|---|
| **Aus den Protokollen der OPNsense Muster erkennen: Wer versucht, wohin zu gelangen, und was wird blockiert?** | Zugriff auf die Firewall-Protokolle im SIEM, Kapitel 5.12 und 14.10 |

**Ablauf:**

1. Alle blockierten Verbindungen der letzten Stunde nach Quell-Zone und Ziel-Zone gruppieren.
1. Die drei häufigsten Kombinationen bestimmen und mit der Zonenmatrix vergleichen.
1. Für eine auffällige Quelle die zeitliche Verteilung der Versuche darstellen.
1. Bewerten, ob es sich um Fehlkonfiguration, normales Verhalten oder einen möglichen Angriff handelt.
> [!ERGEBNIS] Erfolgskriterium
> Die häufigsten blockierten Verbindungen sind korrekt eingeordnet; mindestens eine Auffälligkeit ist mit Begründung bewertet.

**Vertiefung:** Eine Dashboard-Kachel »blockierte Verbindungen nach Zonenpaar« anlegen.

## Labor 14: DNS-Protokolle untersuchen

| **Ziel** | **Voraussetzungen** |
|---|---|
| **Normales und ungewöhnliches DNS-Verhalten unterscheiden lernen.** | Zeek-`dns.log` mit Grundrauschen und einem vom White Team eingespielten auffälligen Muster, Kapitel 15.13 |

**Ablauf:**

1. Die am häufigsten abgefragten Domains bestimmen und als »bekannt« markieren.
1. Die Länge der abgefragten Namen berechnen und die längsten 20 betrachten.
1. Antwortcodes auswerten: Welche Hosts erhalten auffällig viele NXDOMAIN-Antworten?
1. Ein auffälliges Muster beschreiben: betroffener Host, Zielzone, Zeitraum, Anfragetypen.
> [!ERGEBNIS] Erfolgskriterium
> Das eingespielte Muster ist gefunden und vollständig beschrieben; normale Anfragen (z. B. Updates, Intranet) sind korrekt als harmlos erkannt.

**Vertiefung:** Eine Sigma-Regel für sehr lange DNS-Namen entwerfen und auf Fehlalarme prüfen.

## Labor 15: Einen Linux-Webserver härten

| **Ziel** | **Voraussetzungen** |
|---|---|
| **Einen Webserver in der DMZ nach bewährten Regeln absichern und die Wirkung überprüfen.** | Administrativer Zugang zu einer Kopie von web01, Wazuh-SCA-Ergebnisse |

**Ablauf:**

1. Den SCA-Bericht von Wazuh für den Server lesen und die fünf wichtigsten Befunde auswählen.
1. Nicht benötigte Dienste deaktivieren, SSH-Anmeldung nur per Schlüssel erlauben, root-Login verbieten.
1. Dateirechte im Web-Verzeichnis prüfen: Der Webserver-Benutzer darf keine Programmdateien verändern können.
1. SCA-Prüfung erneut ausführen und das Ergebnis vergleichen; Funktion des Shops testen.
> [!ERGEBNIS] Erfolgskriterium
> Die SCA-Bewertung hat sich messbar verbessert, der Shop funktioniert weiterhin, alle Änderungen sind dokumentiert.

**Vertiefung:** Die Änderungen als Ansible-Rolle formulieren, damit sie in künftigen Templates enthalten sind.

## Labor 16: Einen Zeitstrahl aus mehreren Quellen erstellen

| **Ziel** | **Voraussetzungen** |
|---|---|
| **Ereignisse aus Netz- und Hostdaten zu einem gemeinsamen Zeitstrahl verbinden.** | Zeek-, Sysmon- und Windows-Ereignisse eines vorbereiteten Zeitraums, Kapitel 5.17 |

**Ablauf:**

1. Aus jeder Quelle die Ereignisse zum betroffenen Host exportieren.
1. Alle Zeitstempel in UTC umrechnen und prüfen, ob die Uhren der Systeme übereinstimmen.
1. Die Ereignisse in eine gemeinsame Tabelle sortieren (Zeit, Quelle, Host, Ereignis, Bedeutung).
1. Den Ablauf in fünf bis zehn Sätzen zusammenfassen.
> [!ERGEBNIS] Erfolgskriterium
> Der Zeitstrahl ist vollständig, chronologisch korrekt und die Zusammenfassung stimmt mit der Musterlösung überein.

**Vertiefung:** Prüfen, welche Lücken im Zeitstrahl durch fehlende Datenquellen entstehen, und Abhilfe vorschlagen.

> [!INFO]
> **TEIL E**
> **Projekt & Anhang**
> Vom Konzept zum umgesetzten Projekt: Zeitplan, Rollen, Risiken, Budget, Checklisten – und zum Nachschlagen Glossar, Quellen und Prüfprotokoll.
> Kapitel 33: Projektplan
> Kapitel 34: Checklisten
> Kapitel 35: Glossar
> Kapitel 36: Quellen und Verifikationsprotokoll
