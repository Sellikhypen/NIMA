---
id: cr-08
title: L5 – Monitoring, Telemetrie und Erkennung
paths: cyberrange
order: 8
difficulty: medium
icon: waveform.path.ecg
summary: Kapitel 8 deiner Cyber-Range-Dokumentation: L5 – Monitoring, Telemetrie und Erkennung.
source: Cyber_Range_Dokumentation.docx
htb: Cyber Range 08 · L5 Monitoring & Erkennung
---

## Überblick

Schicht L5 macht die Range **beobachtbar**. Sie erfüllt zwei Aufgaben gleichzeitig: Sie ist das Werkzeug des Blue Teams (Angriffe erkennen) und das Messinstrument des White Teams (Leistung bewerten, Übung rekonstruieren).

## Die Telemetrie-Pipeline

![Abbildung 27: Telemetrie-Pipeline von der Quelle bis zur Auswertung](asset:cyberrange/cr-08-027.png)

**So liest man die Abbildung:**

- **Quellen** (links): Windows-Ereignisse, Linux-Logs, Firewall-Entscheidungen und der gespiegelte Netzwerkverkehr.
- **Sammlung:** Agenten auf den Systemen bzw. der Sensor für den Netzwerkverkehr.
- **Transport:** verschlüsselt über definierte Ports ins SVC-Netz – nur diese Ports lässt die Firewall zu.
- **Speicherung:** Such-Indizes (Wazuh Indexer, Elasticsearch) und der Paketmitschnitt (PCAP).
- **Nutzung:** Alarme und Dashboards für das Blue Team, Detektionspunkte und Zeitstrahl für das White Team.
## Netzwerk-Sensorik: Zeek, Suricata, PCAP

| **Werkzeug** | **Arbeitsweise** | **Ergebnis** | **Stärke** |
|---|---|---|---|
| **Zeek** | Analysiert Protokolle und schreibt für jede Verbindung strukturierte Logs | conn.log, dns.log, http.log, ssl.log, smb_files.log, kerberos.log … | Zusammenhänge, Hunting, Statistik |
| **Suricata** | Vergleicht Verkehr mit Tausenden Signaturen (z. B. ET Open) | Alarme im EVE-JSON-Format, zusätzlich Flow-/Protokollereignisse | Bekannte Angriffsmuster |
| **Stenographer / PCAP** | Speichert Pakete vollständig im Ringpuffer | Rohdaten zum Nachanalysieren in Wireshark | Beweissicherung, Detailanalyse |

Tabelle 52: Netzwerk-Sensoren

Alle drei sind in **Security Onion 3** integriert – einer Linux-Distribution für NSM und Threat Hunting mit eigener Analyseoberfläche, Elasticsearch als Speicher und Detektions-Engine. Im Standalone-Modus läuft alles auf einer VM; laut Herstellerdoku sind dafür **mindestens 24 GB RAM, 4 Kerne und 200 GB** nötig (empfohlen 32 GB+). Version 2.4 hat am 01.10.2026 ihr Lebensende erreicht – neu installiert wird nur noch Version 3.

## Host-Telemetrie: Sysmon und Wazuh

Netzwerkdaten zeigen, **wer mit wem** spricht – aber nicht, **welcher Prozess** auf einem Rechner was getan hat. Dafür sorgt Host-Telemetrie:

- **Sysmon** (Microsoft Sysinternals) protokolliert auf Windows detailliert Prozessstarts mit Kommandozeile und Hashes, Netzwerkverbindungen pro Prozess, Zugriffe auf andere Prozesse (z. B. auf lsass.exe), Registry-Änderungen und DNS-Abfragen. Welche Ereignisse erfasst werden, steuert eine XML-Konfiguration (z. B. »sysmon-modular« von Olaf Hartong).
- **Wazuh** besteht aus Agenten, einem Manager (Analyse und Regeln), einem Indexer (OpenSearch-basiert) und einem Dashboard. Der Agent liest Windows-Ereigniskanäle und Linux-Logs, überwacht Dateiänderungen (FIM) und prüft Konfigurationen (SCA); der Manager wendet Regeln an und erzeugt Alarme.
![Abbildung 28: Wazuh 4.x – Registrierung eines Agenten und Weg eines Ereignisses bis zum Alarm](asset:cyberrange/cr-08-028.png)

**So liest man die Abbildung:**

- Schritte 1–3: Der Agent registriert sich einmalig über TLS bei `authd` (Port 1515) und erhält einen eigenen Schlüssel.
- Schritte 4–5: Danach sendet er dauerhaft über Port 1514, AES-verschlüsselt, an `remoted`; die Firewall (OPNsense) muss genau diese Verbindung erlauben.
- Schritte 6–10: Ein Sysmon-Ereignis (Zugriff auf lsass.exe) wird dekodiert, eine Regel trifft, ein Alarm landet im Index und erscheint im Dashboard des Blue Teams.
## Detektionsregeln mit Sigma

Sigma ist ein herstellerneutrales Format für Detektionsregeln. Eine Regel wird einmal geschrieben und in die Abfragesprache des jeweiligen SIEM übersetzt. Für die Range werden zu jedem Szenario-Schritt passende Regeln gepflegt – so wird messbar, ob das Blue Team die **erwarteten** Erkennungen auch umsetzt.

**Sigma-Regel (vereinfachtes Beispiel)**

```
title: Mögliches Kerberoasting – Service-Ticket mit RC4 angefordert
id: 3c2f6d2e-0000-4000-8000-000000000001        # Beispiel-UUID
status: experimental
logsource:
  product: windows
  service: security
detection:
  selection:
    EventID: 4769
    TicketEncryptionType: '0x17'                  # RC4-HMAC
    TicketOptions: '0x40810000'
  filter:
    ServiceName|endswith: '$'                     # Computerkonten ausschließen
  condition: selection and not filter
level: high
tags: [attack.credential_access, attack.t1558.003]
```

## Scoring und Lagebild

Die Scoring-Engine prüft aus dem SVC-Netz in festen Intervallen (z. B. 60 Sekunden), ob die Dienste der Blue Teams funktionieren: Webshop liefert HTTP 200 mit erwartetem Inhalt, Mailserver antwortet mit SMTP-Banner, DNS löst auf, Anmeldung am Dateiserver gelingt. Ergebnisse fließen in eine Datenbank und werden zusammen mit Detektionen, Berichten und Flaggen in Grafana bzw. CTFd angezeigt (Details: Kapitel 21).

## Zeit als gemeinsame Basis

> [!WARNUNG] Ohne synchrone Uhren keine Auswertung
> Alle Systeme der Range beziehen ihre Zeit über NTP von einer gemeinsamen Quelle (OPNsense bzw. dc01). Abweichungen von wenigen Sekunden machen die Korrelation von Netzwerk- und Host-Ereignissen bereits schwierig; Kerberos verweigert standardmäßig ab 5 Minuten Abweichung die Anmeldung.

## Security Onion im Detail

Security Onion ist eine Distribution, die mehrere Werkzeuge der Netzwerk-Sicherheitsüberwachung (NSM) zu einer Plattform verbindet. Für die Range ist entscheidend zu verstehen, wie ein gespiegeltes Paket zu einem Alarm im Analysten-Portal wird.

![Abbildung 29: Datenfluss in Security Onion vom Mirror-Port bis zur Oberfläche](asset:cyberrange/cr-08-029.png)

**So liest man die Abbildung:**

- Der **Mirror-Port** liefert eine Kopie aller Frames. Die Netzwerkkarte hat keine IP-Adresse und sendet nichts.
- Über **AF_PACKET** mit Fanout werden die Frames auf mehrere Prozesse verteilt.
- **Zeek** schreibt Protokoll-Logs, **Suricata** prüft Signaturen und speichert PCAP, **Strelka** untersucht extrahierte Dateien.
- **Elastic Agent / Logstash** normalisieren alles in das **ECS**-Schema und schreiben es in **Elasticsearch**.
- Analysten arbeiten in der **SOC-Oberfläche**: Alerts, Hunt, Dashboards, Cases und PCAP-Ansicht.

Für die Range hat Security Onion einen großen didaktischen Vorteil: Das Blue Team kann von einem Alarm per Klick in die zugehörigen Zeek-Logs und bis zum Rohpaket springen (»Pivot to PCAP«). Diese Arbeitsweise – vom Verdacht zum Beweis – ist genau die Fähigkeit, die trainiert werden soll.

## Wazuh im Detail: Agent, Manager und eigene Regeln

![Abbildung 30: Module des Wazuh-Agenten und Verarbeitung im Manager](asset:cyberrange/cr-08-030.png)

**So liest man die Abbildung:**

- Links die **Module des Agenten**: Log-Sammlung (u. a. Windows-Eventlog), FIM, SCA, Inventar, Rootcheck und Active Response.
- Der Agent registriert sich einmalig über **Port 1515** und sendet danach verschlüsselt über **Port 1514**.
- Im Manager zerlegen **Decoder** die Rohdaten in Felder, **Regeln** bewerten sie mit einem Level von 0 bis 15.
- Alarme landen über Filebeat im **Indexer** und werden im **Dashboard** angezeigt. Die **API** (Port 55000) erlaubt Automatisierung.
**Wazuh-Agent: Manager-Adresse und zusätzliche Ereigniskanäle**

```
<!-- /var/ossec/etc/ossec.conf auf einem Windows-Agenten (Auszug) -->
<client>
  <server>
    <address>10.99.0.10</address>
    <port>1514</port>
    <protocol>tcp</protocol>
  </server>
  <enrollment>
    <enabled>yes</enabled>
    <groups>windows,corp</groups>
  </enrollment>
</client>
<localfile>
  <location>Microsoft-Windows-Sysmon/Operational</location>
  <log_format>eventchannel</log_format>
</localfile>
<localfile>
  <location>Microsoft-Windows-PowerShell/Operational</location>
  <log_format>eventchannel</log_format>
</localfile>
```

**Eigene Wazuh-Regel (vor dem Einsatz mit wazuh-logtest prüfen)**

```
<!-- /var/ossec/etc/rules/local_rules.xml – eigene Regeln (IDs ab 100000) -->
<group name="range,sysmon,">
  <rule id="100110" level="12">
    <if_group>windows</if_group>
    <field name="win.system.providerName">^Microsoft-Windows-Sysmon$</field>
    <field name="win.system.eventID">^10$</field>
    <field name="win.eventdata.targetImage" type="pcre2">(?i)\\lsass\.exe$</field>
    <description>Range: Prozess greift auf LSASS zu (mögliches Credential Dumping)</description>
    <mitre><id>T1003.001</id></mitre>
  </rule>
</group>
```

> [!TIPP] Regeln testen, bevor sie live gehen
> Mit `/var/ossec/bin/wazuh-logtest` kann man eine Beispiel-Logzeile einfügen und sehen, welcher Decoder und welche Regel greifen. Jede neue Regel wird so mit einer **positiven** (soll anschlagen) und einer **negativen** Probe (soll nicht anschlagen) geprüft – das ist Detection Engineering im Kleinen.

## Lebenszyklus einer Detektionsregel

Eine Detektionsregel ist kein einmaliges Werk, sondern ein Produkt mit Lebenszyklus. Die Range ist der ideale Ort, diesen Zyklus zu üben, weil Angriffe beliebig oft und gefahrlos wiederholt werden können.

![Abbildung 31: Lebenszyklus einer Detektionsregel](asset:cyberrange/cr-08-031.png)

**So liest man die Abbildung:**

- Am Anfang steht eine **Hypothese** auf Basis einer ATT&CK-Technik: »Wenn jemand Kerberoasting betreibt, sehen wir viele TGS-Anfragen mit RC4.«
- Dann wird geprüft, ob die **Datenquelle** überhaupt vorhanden ist (z. B. Auditing für EID 4769 aktiv).
- Die Regel wird geschrieben (Sigma), der Angriff in der Range **nachgestellt**, das Ergebnis **gemessen**.
- Nach dem **Ausrollen** folgt das **Tuning** gegen Fehlalarme und regelmäßige **Reviews** – der Kreis schließt sich.
## Referenz: die wichtigsten Zeek-Logs

| **Log** | **Inhalt** | **Typische Fragestellung im Szenario** |
|---|---|---|
| **conn.log** | Jede Verbindung: Quelle, Ziel, Ports, Dauer, Bytes, conn_state | Wer hat mit dem C2-Server gesprochen? Beacon-Intervalle? |
| **dns.log** | Anfragen und Antworten, Typ, RCODE | Welche Domains wurden aufgelöst? DNS-Tunneling? |
| **http.log** | Methode, Host, URI, User-Agent, Statuscode | Webshell-Aufrufe, SQL-Injection-Muster |
| **ssl.log / x509.log** | TLS-Version, SNI, Zertifikate, JA3/JA4 (Paket) | Selbstsignierte C2-Zertifikate, ungewöhnliche Clients |
| **files.log** | Übertragene Dateien mit Hashes und MIME-Typ | Welche Datei kam per Mail oder Download? |
| **smtp.log** | Absender, Empfänger, Betreff, Mail-Server | Phishing-Welle nachvollziehen |
| **kerberos.log** | AS/TGS-Anfragen, Verschlüsselungstyp, Konten | Kerberoasting im Netz erkennen |
| **ntlm.log** | NTLM-Anmeldungen mit Benutzer und Domäne | Relay- und Pass-the-Hash-Spuren |
| **smb_files.log / smb_mapping.log** | Freigaben und Dateizugriffe über SMB | Lateral Movement, Datensammlung |
| **dce_rpc.log** | RPC-Aufrufe (z. B. DRSUAPI, SVCCTL) | DCSync, entfernte Dienstinstallation |
| **rdp.log / ssh.log** | Remote-Sitzungen, Erfolg, Client-Version | Zugriffe von ungewöhnlichen Quellen |
| **notice.log / weird.log** | Zeek-eigene Hinweise und Protokollanomalien | Port-Scans, kaputte Protokolle |

Tabelle 53: Zeek-Logs und ihre Verwendung

## Referenz: Windows-Ereignis-IDs für die Range

| **EID** | **Protokoll** | **Bedeutung** | **Bezug im Szenario** |
|---|---|---|---|
| **4624 / 4625** | Security | Anmeldung erfolgreich / fehlgeschlagen (mit Anmeldetyp) | Typ 3 = Netzwerk, Typ 10 = RDP |
| **4648** | Security | Anmeldung mit expliziten Anmeldedaten | runas, Lateral Movement |
| **4672** | Security | Sonderrechte bei Anmeldung zugewiesen | Admin-Anmeldungen |
| **4688** | Security | Prozess erstellt (mit Kommandozeile, falls aktiviert) | Ergänzung zu Sysmon 1 |
| **4697 / 7045** | Security / System | Dienst installiert | PsExec, Persistenz |
| **4720 / 4738** | Security | Benutzer angelegt / geändert | Persistenz durch neue Konten |
| **4728 / 4732 / 4756** | Security | Mitglied zu globaler / lokaler / universeller Gruppe hinzugefügt | Rechteausweitung |
| **4768 / 4769** | Security (DC) | Kerberos-TGT / Dienstticket angefordert | AS-REP-Roasting, Kerberoasting |
| **4771 / 4776** | Security (DC) | Kerberos-Vorauth. fehlgeschlagen / NTLM-Prüfung | Passwort-Spraying |
| **4662** | Security (DC) | Operation auf AD-Objekt | DCSync (Replikations-GUIDs) |
| **5140 / 5145** | Security | Zugriff auf Freigabe / Datei in Freigabe | SYSVOL-Zugriffe, Datensammlung |
| **1102** | Security | Sicherheitsprotokoll gelöscht | Spurenverwischung |
| **4104** | PowerShell/Operational | Script-Block-Protokollierung | Verschleierte PowerShell |

Tabelle 54: Wichtige Windows-Ereignisse

## Referenz: Sysmon-Ereignisse

| **ID** | **Ereignis** | **ID** | **Ereignis** |
|---|---|---|---|
| **1** | Prozess erstellt (mit Hash, Eltern, Kommandozeile) | 12–14 | Registry: Schlüssel/Wert angelegt, gesetzt, umbenannt |
| **2** | Datei-Zeitstempel geändert (Timestomping) | 15 | Alternate Data Stream erstellt |
| **3** | Netzwerkverbindung | 17 / 18 | Named Pipe erstellt / verbunden |
| **5** | Prozess beendet | 19–21 | WMI-Ereignisfilter, -Consumer, -Bindung |
| **6** | Treiber geladen | 22 | DNS-Anfrage |
| **7** | Image (DLL) geladen | 23 / 26 | Datei gelöscht (archiviert / nur erkannt) |
| **8** | CreateRemoteThread (Injektion) | 24 | Zwischenablage geändert |
| **10** | Zugriff auf anderen Prozess (z. B. LSASS) | 25 | Prozess-Manipulation (Hollowing) |
| **11** | Datei erstellt | 27–29 | Blockierte bzw. erkannte ausführbare Dateien |

Tabelle 55: Sysmon-Ereignis-IDs (Auszug)

## Audit-Richtlinien: ohne Protokoll keine Erkennung

Windows protokolliert viele sicherheitsrelevante Ereignisse nur, wenn die passende **Audit-Richtlinie** aktiviert ist. Fehlt sie, kann auch das beste SIEM nichts erkennen. Die folgenden Einstellungen werden per Gruppenrichtlinie für die gesamte Domäne gesetzt (Erweiterte Überwachungsrichtlinienkonfiguration).

| **Unterkategorie** | **Einstellung** | **Liefert Ereignisse** | **Wofür** |
|---|---|---|---|
| **Prozesserstellung** | Erfolg + Kommandozeile einschließen | 4688 | Prozessketten (ergänzend zu Sysmon) |
| **Anmelden / Abmelden** | Erfolg und Fehler | 4624, 4625, 4634 | Anmeldungen, Passwort-Spraying |
| **Spezielle Anmeldung** | Erfolg | 4672 | Admin-Anmeldungen |
| **Kerberos-Authentifizierungsdienst** | Erfolg und Fehler | 4768, 4771 | TGT-Anfragen, AS-REP-Roasting |
| **Kerberos-Diensttickets** | Erfolg und Fehler | 4769 | Kerberoasting |
| **Überprüfung der Anmeldeinformationen** | Erfolg und Fehler | 4776 | NTLM-Prüfungen am DC |
| **Sicherheitsgruppenverwaltung** | Erfolg | 4728, 4732, 4756 | Rechteausweitung über Gruppen |
| **Benutzerkontenverwaltung** | Erfolg und Fehler | 4720, 4722, 4738 | neue/aktivierte Konten |
| **Verzeichnisdienstzugriff** | Erfolg (+ SACL auf dem Domänenobjekt) | 4662 | Replikationsanfragen (DCSync) |
| **Dateifreigabe / detaillierte Dateifreigabe** | Erfolg und Fehler | 5140, 5145 | SYSVOL- und Dateizugriffe |
| **Andere Objektzugriffsereignisse** | Erfolg | 4698, 4702 | geplante Aufgaben (Persistenz) |
| **Sicherheitssystemerweiterung** | Erfolg | 4697 | Dienstinstallation |

Tabelle 56: Empfohlene Audit-Richtlinien für Domänencontroller und Server

Zusätzlich wird für PowerShell die **Skriptblockprotokollierung** aktiviert (Administrative Vorlagen → Windows-Komponenten → Windows PowerShell → »PowerShell-Skriptblockprotokollierung aktivieren«). Sie schreibt auch verschleierte Befehle nach der Entschleierung ins Protokoll (Ereignis 4104) und ist eine der wertvollsten Datenquellen überhaupt.

> [!WARNUNG] Protokollgröße anpassen
> Das Sicherheitsprotokoll ist unter Windows standardmäßig klein und wird bei viel Aktivität schnell überschrieben. Auf Domänencontrollern sollte es auf mindestens 1 GB vergrößert werden – auch wenn die Ereignisse ohnehin an Wazuh weitergeleitet werden, hilft das bei Ausfällen der Weiterleitung.

## Wie viele Daten entstehen?

Wer die Speicher für Security Onion und Wazuh plant, muss wissen, wie viele Daten an einem Übungstag anfallen. Die wichtigste Größe ist der Netzmitschnitt: Er wächst direkt mit dem Datenverkehr. Logs sind im Vergleich klein, aber zahlreich.

![Abbildung 32: Datenvolumen eines Übungstags (Beispielrechnung)](asset:cyberrange/cr-08-032.png)

**So liest man die Abbildung:**

- Der **Vollmitschnitt (PCAP)** dominiert: Bei durchschnittlich 20 Mbit/s gespiegeltem Verkehr entstehen in acht Stunden rund 72 GB.
- **Zeek-Logs** sind deutlich kleiner, weil sie nur Metadaten speichern (wer, wann, wie viel, welches Protokoll).
- **Host-Logs** (Windows, Sysmon, Linux) liegen zusammen im einstelligen Gigabyte-Bereich.
- Für die Indizes im SIEM kommt ein Aufschlag für Replikate und Verwaltungsdaten hinzu.
| **Größe** | **Formel** | **Beispiel** |
|---|---|---|
| **PCAP pro Tag** | Datenrate (Mbit/s) ÷ 8 × Sekunden | 20 ÷ 8 × 28.800 s ≈ 72.000 MB ≈ 72 GB |
| **PCAP-Aufbewahrung** | PCAP pro Tag × Tage | 72 GB × 5 Übungstage ≈ 360 GB |
| **Log-Ereignisse pro Sekunde (EPS)** | Summe aller Quellen | 25 Windows × 3 EPS + 10 Linux × 1 EPS + Firewall 20 EPS ≈ 105 EPS |
| **Logs pro Tag** | EPS × Ø Ereignisgröße × Sekunden | 105 × 1 KB × 28.800 s ≈ 3 GB |
| **Indexspeicher** | Rohdaten × 1,5 (Faustwert) | ≈ 4,5 GB pro Tag |

Tabelle 57: Formeln für die Speicherplanung (Annahmen vor Ort messen)

## Vom Alarm zum Vorfall: der Triage-Prozess

Das Blue Team wird in einer Übung mit Alarmen überschüttet – echten und falschen. Ohne festen Ablauf gehen wichtige Alarme unter. Der folgende Prozess stammt aus dem SOC-Alltag und wird in der Range genau so geübt.

![Abbildung 33: Triage-Prozess vom Alarm bis zum Vorfall](asset:cyberrange/cr-08-033.png)

**So liest man die Abbildung:**

- Jeder **Alarm** wird zuerst **angereichert**: Welcher Host, welcher Benutzer, was ist normal für dieses System?
- Dann wird er **bewertet**: echter Angriff, harmloser Vorgang oder Fehlalarm. Fehlalarme führen zu Regel-Tuning, harmlose Vorgänge werden dokumentiert.
- Echte Funde werden **priorisiert** (Kritikalität des Systems × Ausmaß) und an die nächste Stufe **eskaliert**.
- Rechts sind die drei **Stufen** eines SOC dargestellt; in kleinen Blue Teams übernimmt eine Person oft mehrere Stufen.
| **Priorität** | **Kriterium (Beispiel)** | **Reaktionsziel in der Übung** |
|---|---|---|
| **Kritisch** | Domänencontroller betroffen, Hinweis auf Rechteausweitung oder Datenabfluss | sofort, Eskalation an Incident Lead |
| **Hoch** | Server betroffen oder Schadcode auf einem Client ausgeführt | < 15 Minuten |
| **Mittel** | verdächtiges Verhalten ohne Bestätigung | < 60 Minuten |
| **Niedrig** | Richtlinienverstoß, Aufklärungsversuch ohne Wirkung | im Lagebericht sammeln |

Tabelle 58: Prioritäten in der Triage

## Dashboards für das Lagebild

Ein **Lagebild** verdichtet tausende Ereignisse zu wenigen Aussagen, die Entscheider verstehen. In der Range gibt es drei Sichten für unterschiedliche Zielgruppen:

| **Sicht** | **Zielgruppe** | **Inhalt** |
|---|---|---|
| **Analysten-Sicht** | Blue Team | offene Alarme nach Priorität, Top-Hosts, Top-Regeln, neue Verbindungen ins SINET, Anmeldefehler |
| **Lagebild-Sicht** | Blue Lead, Geschäftsführung (Inject) | Anzahl Vorfälle nach Status, betroffene Systeme, Dienstverfügbarkeit, getroffene Maßnahmen |
| **Leitungs-Sicht** | White Team | Stand jedes Teams: erkannte Phasen, Punkteverlauf, offene Injects, technische Störungen |

Tabelle 59: Drei Sichten auf dieselben Daten
