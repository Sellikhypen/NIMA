---
id: soc-01
title: SOC-Praxis 1 · Der Alltag eines SOC-Analysten und Alert-Triage
paths: cdsa, cjca, specialist
order: 30.1
difficulty: easy
icon: person.badge.shield.checkmark.fill
tags: soc, triage
summary: Wie ein SOC arbeitet, welche Stufen es gibt und wie man einen Alarm in wenigen Minuten strukturiert bewertet.
---

## Einfach erklärt

Ein **SOC** (Security Operations Center) ist die Feuerwache der IT. Rauchmelder (Sensoren, Logs, EDR) lösen Alarme aus. Die Analysten entscheiden: Fehlalarm, Kerze, oder brennt das Haus? Diese erste Bewertung heißt **Triage** – wie in der Notaufnahme.

## Stufen im SOC

| Stufe | Aufgabe |
|---|---|
| L1 – Triage | Alarme sichten, Fehlalarme schließen, Echtes eskalieren |
| L2 – Untersuchung | Umfang klären, Zusammenhänge finden, Eindämmung einleiten |
| L3 – Experten | Threat Hunting, Malware-Analyse, Detection Engineering |
| SOC-Leitung | Prozesse, Kennzahlen, Kommunikation |

## Triage in fünf Fragen

1. **Was** hat ausgelöst? Regel lesen und verstehen, was sie erkennen soll.
2. **Wer und wo?** Benutzer, Host, IP – wie kritisch ist das Asset?
3. **Ist das normal?** Gab es das schon öfter? Passt es zur Rolle des Nutzers?
4. **Gibt es Begleitereignisse?** Was passierte 15 Minuten davor und danach auf diesem Host?
5. **Entscheidung**: False Positive (schließen und dokumentieren), Benign True Positive (erwartet, z. B. Admin-Tätigkeit) oder True Positive (eskalieren).

> [!MERKE] Dokumentation ist Teil der Arbeit
> Jede Entscheidung braucht eine kurze, nachvollziehbare Begründung im Ticket. Wer später sucht, muss verstehen, warum ein Alarm geschlossen wurde.

## Tiefer eingetaucht

Kennzahlen eines SOC:

- **MTTD** – mittlere Zeit bis zur Erkennung
- **MTTR** – mittlere Zeit bis zur Reaktion/Behebung
- **False-Positive-Rate** pro Regel – Grundlage für Tuning
- **Abdeckung** – welche ATT&CK-Techniken werden überhaupt erkannt?

**Alert Fatigue** ist die größte Gefahr: Wer täglich hunderte unwichtige Alarme schließt, übersieht den einen echten. Gegenmittel: Regeln tunen, Kontext automatisch anreichern (Asset-Kritikalität, Nutzerrolle, Threat Intel), Fälle bündeln statt Einzelalarme, und Routine mit SOAR automatisieren.

## Quiz

? Wie nennt man die erste Bewertung eines Alarms?
= Triage
! Wie in der Notaufnahme: schnell einordnen, was dringend ist.

? Was ist ein „Benign True Positive“?
+ die Regel hat korrekt ausgelöst, die Aktivität ist aber erwartet und harmlos
- ein Alarm ohne Ursache
- ein echter Angriff
- ein Alarm, der nie ausgelöst wurde
! Beispiel: ein Admin nutzt erlaubterweise ein Werkzeug, das die Regel erkennt.

? Wofür steht MTTD?
= Mean Time to Detect
! Die mittlere Zeit von Beginn eines Vorfalls bis zur Erkennung.

?tf Alert Fatigue erhöht das Risiko, echte Angriffe zu übersehen.
= wahr
! Zu viele unwichtige Alarme stumpfen ab.

? Welche Stufe kümmert sich typischerweise um Threat Hunting und Detection Engineering?
+ L3
- L1
- Helpdesk
- Einkauf
! L3 arbeitet proaktiv und verbessert die Erkennung.

?order Bringe die Triage-Schritte in eine sinnvolle Reihenfolge.
> Auslösende Regel verstehen
> Betroffene Nutzer und Systeme einordnen
> Begleitereignisse prüfen
> Entscheidung treffen und dokumentieren
! Erst verstehen, dann einordnen, dann Kontext, dann entscheiden.

? Was hilft gegen Alert Fatigue?
+ Regeln tunen
+ Alarme automatisch mit Kontext anreichern
+ Routinefälle automatisieren
- alle Alarme ignorieren
! Qualität vor Quantität.

@@@ MODULE @@@
---
id: soc-02
title: SOC-Praxis 2 · Splunk SPL Schritt für Schritt
paths: cdsa
order: 30.2
difficulty: medium
icon: magnifyingglass
tags: soc, splunk, spl
summary: Die Splunk Search Processing Language von der ersten Suche bis zu stats, eval, timechart und Ausreißer-Erkennung.
---

## Einfach erklärt

Splunk ist eine riesige Bibliothek aller Logs. **SPL** ist die Sprache, mit der du den Bibliothekar fragst. Eine Suche ist wie ein Fließband: Erst holt man Ereignisse, dann reicht man sie mit `|` an den nächsten Arbeitsschritt weiter.

```spl
index=windows EventCode=4625 | stats count by user | sort -count
```

„Hole alle fehlgeschlagenen Windows-Anmeldungen, zähle sie pro Benutzer, sortiere absteigend.“

## Die wichtigsten Befehle

| Befehl | Zweck | Beispiel |
|---|---|---|
| `search` (implizit) | filtern | `index=proxy status=403` |
| `table` | Spalten auswählen | `table _time user src_ip` |
| `stats` | zählen, gruppieren | `stats count dc(user) by src_ip` |
| `eval` | Felder berechnen | `eval kb=bytes/1024` |
| `where` | Bedingungen auf Felder | `where count > 20` |
| `timechart` | Zeitreihe | `timechart span=1h count by status` |
| `rex` | Felder per Regex extrahieren | `rex field=_raw "user=(?<u>\w+)"` |
| `dedup` | Duplikate entfernen | `dedup user` |
| `top`/`rare` | häufigste/seltenste Werte | `rare process_name` |

> [!TIPP] Zuerst eingrenzen
> Index, Zeitraum und Sourcetype zuerst angeben. Das macht Suchen schneller und Ergebnisse übersichtlicher.

## Typische Analysen

```spl
index=windows EventCode=4625 earliest=-24h
| stats count dc(user) as users by src_ip
| where count > 50 AND users > 10
```

Viele Fehlversuche auf viele Konten von einer Quelle → Password Spraying.

```spl
index=sysmon EventCode=1 ParentImage="*\\winword.exe"
| table _time host user Image CommandLine
```

Office startet Prozesse → klassischer Hinweis auf bösartige Makros.

## Tiefer eingetaucht

Fortgeschrittene Werkzeuge:

- `eventstats`/`streamstats` – Statistik hinzufügen, ohne Ereignisse zu verlieren (z. B. Durchschnitt pro Nutzer neben jedem Ereignis).
- `transaction` – zusammengehörige Ereignisse bündeln (teuer, sparsam nutzen).
- `lookup` – Kontext anreichern (Asset-Listen, Threat-Intel-Listen).
- **Ausreißer-Erkennung**: Mittelwert und Standardabweichung pro Entität berechnen und Werte weit darüber markieren.

```spl
index=proxy | bin _time span=1h | stats sum(bytes_out) as out by _time user
| eventstats avg(out) as avg stdev(out) as sd by user
| where out > avg + 3*sd
```

Performance: `tstats` über beschleunigte Datenmodelle ist um Größenordnungen schneller als Rohsuchen – wichtig für Dashboards und Korrelationsregeln.

## Quiz

? Mit welchem Zeichen werden SPL-Befehle verkettet?
= |
! Die Pipe reicht Ergebnisse an den nächsten Befehl weiter.

? Welcher Befehl zählt Ereignisse gruppiert nach einem Feld?
= stats
= stats count by
! Beispiel: stats count by user.

? Welche Windows-EventCode-Suche liefert fehlgeschlagene Anmeldungen?
= EventCode=4625
= 4625
! 4625 = An account failed to log on.

? Welcher Befehl erstellt eine Zeitreihe?
= timechart
! timechart span=1h count ist ein Klassiker für Verläufe.

?tf `eventstats` entfernt die ursprünglichen Ereignisse aus der Ergebnisliste.
= falsch
! eventstats fügt Statistiken hinzu und behält die Ereignisse; stats fasst zusammen.

? Was deutet „viele Fehlversuche auf viele verschiedene Konten von einer IP“ an?
+ Password Spraying
- Kerberoasting
- DNS-Tunneling
- Datenexfiltration
! Spraying testet wenige Passwörter gegen viele Konten.

? Mit welchem Befehl extrahiert man Felder per regulärem Ausdruck?
= rex
! Benannte Gruppen (?<name>...) werden zu Feldern.

? Welcher Befehl ist deutlich schneller auf beschleunigten Datenmodellen?
= tstats
! tstats arbeitet auf indizierten Zusammenfassungen statt Rohdaten.

@@@ MODULE @@@
---
id: soc-03
title: SOC-Praxis 3 · KQL für Microsoft Sentinel und Defender
paths: cdsa, specialist
order: 30.3
difficulty: medium
icon: text.magnifyingglass
tags: soc, kql, microsoft
summary: Kusto Query Language – Tabellen, where, summarize, join und typische Hunting-Abfragen in Sentinel und Defender XDR.
---

## Einfach erklärt

KQL funktioniert wie SPL, nur mit Tabellen: Man beginnt mit einer **Tabelle** und schickt sie mit `|` durch Filter und Umformungen.

```kql
SigninLogs
| where ResultType != 0
| summarize Fehlversuche = count() by UserPrincipalName
| top 10 by Fehlversuche
```

## Wichtige Operatoren

| Operator | Zweck |
|---|---|
| `where` | filtern |
| `project` | Spalten auswählen/umbenennen |
| `extend` | neue Spalte berechnen |
| `summarize` | aggregieren (`count()`, `dcount()`, `make_set()`) |
| `bin()` | Zeit in Intervalle einteilen |
| `join` | Tabellen verbinden |
| `parse` / `extract()` | Felder aus Text gewinnen |
| `render` | Diagramm |
| `ago()` | relative Zeit, z. B. `ago(1d)` |

## Typische Tabellen

| Tabelle | Inhalt |
|---|---|
| `SigninLogs` | Entra-ID-Anmeldungen |
| `AuditLogs` | Änderungen in Entra ID |
| `SecurityEvent` | Windows-Sicherheitsereignisse |
| `DeviceProcessEvents` | Prozessstarts (Defender for Endpoint) |
| `DeviceNetworkEvents` | Netzwerkverbindungen von Endgeräten |
| `OfficeActivity` | Exchange, SharePoint, Teams |

> [!TIPP] Zeitraum zuerst
> `| where TimeGenerated > ago(24h)` an den Anfang – spart Kosten und Zeit.

## Tiefer eingetaucht

Hunting-Beispiele:

```kql
// Anmeldung aus vielen Ländern in kurzer Zeit
SigninLogs
| where TimeGenerated > ago(1d) and ResultType == 0
| summarize Laender = dcount(Location), Liste = make_set(Location) by UserPrincipalName
| where Laender > 2
```

```kql
// Kodierte PowerShell-Befehle
DeviceProcessEvents
| where FileName =~ "powershell.exe" and ProcessCommandLine has_any ("-enc", "-EncodedCommand")
| project Timestamp, DeviceName, AccountName, ProcessCommandLine
```

Feinheiten: `has` sucht ganze Begriffe (schnell, indexiert), `contains` Teilstrings (langsamer); `=~` vergleicht ohne Groß-/Kleinschreibung. In Sentinel werden aus Abfragen **Analytics Rules** mit Zeitplan, Schwellenwert und Entitätszuordnung – die Basis für Incidents.

## Quiz

? Mit welchem KQL-Operator wird aggregiert?
= summarize
! Beispiel: summarize count() by UserPrincipalName.

? Welche Funktion gibt einen relativen Zeitpunkt wie „vor einem Tag“ an?
= ago
= ago(1d)
! ago(1d) entspricht jetzt minus 24 Stunden.

? Welche Tabelle enthält Entra-ID-Anmeldungen?
= SigninLogs
! AuditLogs enthält dagegen Konfigurationsänderungen.

?tf `has` ist in KQL meist schneller als `contains`.
= wahr
! has nutzt den Begriffsindex, contains sucht Teilstrings.

? Welcher Operator fügt eine berechnete Spalte hinzu?
= extend
! project wählt dagegen Spalten aus.

? Welche Tabelle zeigt Prozessstarts auf Endgeräten in Defender?
= DeviceProcessEvents
! Ideal für Hunting nach verdächtigen Kommandozeilen.

? Woran erkennt man oft verschleierte PowerShell?
+ Parameter wie -enc oder -EncodedCommand
- die Endung .txt
- ein grünes Fenster
- Netzwerkdrucker
! Base64-kodierte Befehle verstecken den Inhalt vor einfachen Filtern.

@@@ MODULE @@@
---
id: soc-04
title: SOC-Praxis 4 · Windows-Event-IDs, die man kennen muss
paths: cdsa, cjca, cape
order: 30.4
difficulty: medium
icon: list.number
tags: soc, windows, logs
summary: Der Spickzettel der wichtigsten Windows-Sicherheitsereignisse – Anmeldungen, Kerberos, Konten, Dienste, Aufgaben und Log-Löschung – mit Interpretation.
---

## Einfach erklärt

Windows schreibt für fast jede sicherheitsrelevante Aktion ein Ereignis mit einer **Nummer**. Wer die wichtigsten Nummern kennt, liest Windows-Logs so schnell wie ein Arzt Laborwerte.

## Anmeldungen

| ID | Bedeutung |
|---|---|
| 4624 | erfolgreiche Anmeldung (Logon Type beachten!) |
| 4625 | fehlgeschlagene Anmeldung |
| 4634 / 4647 | Abmeldung |
| 4648 | Anmeldung mit expliziten Anmeldedaten (z. B. `runas`) |
| 4672 | Anmeldung mit Admin-Privilegien |

**Logon Types**: 2 = interaktiv, 3 = Netzwerk (z. B. SMB), 4 = Batch, 5 = Dienst, 7 = Entsperren, 10 = RDP, 11 = zwischengespeichert.

## Kerberos und NTLM (auf Domain Controllern)

| ID | Bedeutung |
|---|---|
| 4768 | TGT angefordert |
| 4769 | Service-Ticket angefordert – Verschlüsselung RC4 (0x17) kann auf Kerberoasting deuten |
| 4771 | Kerberos-Vorauthentifizierung fehlgeschlagen |
| 4776 | NTLM-Authentifizierung geprüft |

## Konten und Gruppen

| ID | Bedeutung |
|---|---|
| 4720 | Benutzer angelegt |
| 4722 / 4725 | Konto aktiviert / deaktiviert |
| 4724 | Passwort zurückgesetzt |
| 4728 / 4732 / 4756 | Mitglied zu globaler / lokaler / universeller Gruppe hinzugefügt |
| 4740 | Konto gesperrt |

## Persistenz und Spurenverwischung

| ID | Bedeutung |
|---|---|
| 4697 / 7045 | Dienst installiert (Security / System) |
| 4698 | geplante Aufgabe erstellt |
| 4688 | Prozess erstellt (mit Kommandozeile, wenn aktiviert) |
| 1102 | Sicherheitsprotokoll gelöscht |
| 4719 | Überwachungsrichtlinie geändert |

> [!EXAM] Klassiker
> 1102 (Log gelöscht) ist fast immer verdächtig. 4624 mit Logon Type 10 bedeutet RDP. 4769 mit RC4 deutet auf Kerberoasting.

## Tiefer eingetaucht

Viele Ereignisse erscheinen nur, wenn die passende **Advanced Audit Policy** aktiv ist – z. B. 4688 mit Kommandozeile oder 5145 (Zugriff auf Netzwerkfreigaben). Ein häufiger Befund im Incident: Die Logs, die man bräuchte, wurden nie aufgezeichnet.

Ergänzende Quellen: **Sysmon** (Prozessbäume, Hashes, Netzwerkverbindungen), **PowerShell Operational** (4104 Script Block Logging) und die **TaskScheduler**-, **RDP**- und **WinRM**-Kanäle. Korrelation über die **Logon ID**: Sie verbindet die Anmeldung (4624) mit allen Aktionen dieser Sitzung.

## Quiz

? Welche Event-ID steht für eine erfolgreiche Anmeldung?
= 4624
! Den Logon Type immer mit auswerten.

? Welcher Logon Type steht für RDP?
= 10
! Type 10 = RemoteInteractive.

? Welche Event-ID zeigt, dass das Sicherheitsprotokoll gelöscht wurde?
= 1102
! Ein typisches Zeichen für Spurenverwischung.

? Welche Event-ID betrifft angeforderte Kerberos-Service-Tickets?
= 4769
! Bei RC4-Verschlüsselung (0x17) und vielen SPNs an Kerberoasting denken.

? Welche Event-IDs zeigen die Installation eines Dienstes?
+ 7045
+ 4697
- 4624
- 4740
! 7045 steht im System-Log, 4697 im Security-Log (bei aktivierter Überwachung).

?tf Event 4688 enthält standardmäßig immer die vollständige Kommandozeile.
= falsch
! Dafür muss die entsprechende Richtlinie aktiviert sein.

? Welche Event-ID steht für eine erstellte geplante Aufgabe?
= 4698
! Geplante Aufgaben sind ein beliebter Persistenzmechanismus.

? Welche ID protokolliert PowerShell-Skriptblöcke?
= 4104
! Script Block Logging zeigt auch entschleierten Code.

@@@ MODULE @@@
---
id: soc-05
title: SOC-Praxis 5 · Sysmon konfigurieren und auswerten
paths: cdsa
order: 30.5
difficulty: medium
icon: waveform.path.ecg
tags: soc, sysmon, windows
summary: Was Sysmon zusätzlich zu Windows-Logs liefert, die wichtigsten Event-IDs, eine gute Konfiguration und typische Erkennungen.
---

## Einfach erklärt

Windows-Logs sind wie ein Pförtner, der notiert, wer das Gebäude betritt. **Sysmon** ist eine Überwachungskamera in jedem Flur: Sie zeigt, welcher Prozess welchen anderen gestartet hat, welche Netzwerkverbindungen er aufbaut und welche Dateien er anlegt.

## Die wichtigsten Sysmon-Ereignisse

| ID | Ereignis | Nutzen |
|---|---|---|
| 1 | Prozess erstellt (mit Hash, Eltern, Kommandozeile) | Prozessbäume, verdächtige Starts |
| 3 | Netzwerkverbindung | Beaconing, Lateral Movement |
| 7 | Image/DLL geladen | DLL-Sideloading |
| 8 | CreateRemoteThread | Code-Injektion |
| 10 | Prozesszugriff | Zugriff auf LSASS (Credential Dumping) |
| 11 | Datei erstellt | Droppers, Payloads |
| 12–14 | Registry-Änderungen | Persistenz über Run-Keys |
| 22 | DNS-Abfrage | C2-Domains, DNS-Tunneling |
| 23/26 | Datei gelöscht | Spurenverwischung |

## Eine gute Konfiguration

Ohne Konfiguration protokolliert Sysmon zu wenig oder zu viel. Bewährt haben sich Community-Vorlagen (z. B. von SwiftOnSecurity oder Olaf Hartong), die:

- Rauschen ausfiltern (bekannte, häufige, harmlose Prozesse),
- wichtige Bereiche gezielt einschließen (Run-Keys, Autostart-Ordner, LSASS-Zugriffe),
- Hashes (SHA256, IMPHASH) für die Bedrohungssuche mitschreiben.

```xml
<ProcessAccess onmatch="include">
  <TargetImage condition="is">C:\Windows\system32\lsass.exe</TargetImage>
</ProcessAccess>
```

> [!MERKE] Elternprozess ist Gold wert
> `winword.exe → powershell.exe`, `w3wp.exe → cmd.exe` (Webshell!) oder `services.exe → unbekannte.exe` erzählen eine Geschichte, die ein einzelnes Ereignis nicht erzählt.

## Tiefer eingetaucht

Erkennungsideen:

- **LSASS-Zugriff** (ID 10) von ungewöhnlichen Prozessen mit Zugriffsrechten wie `0x1010` oder `0x1410`.
- **Office startet Skript-Interpreter** (ID 1, ParentImage Office).
- **Prozess aus Benutzerverzeichnis** (`\AppData\`, `\Temp\`) baut Netzwerkverbindung auf (ID 1 + 3).
- **Neue Run-Key-Einträge** (ID 13) auf Programme in ungewöhnlichen Pfaden.
- **DNS-Abfragen** (ID 22) mit sehr langen, zufällig wirkenden Subdomains.

Sysmon ist kein EDR – es blockiert nichts. Seine Stärke ist hochwertige Telemetrie für SIEM und Hunting. Angreifer mit Admin-Rechten können Sysmon stoppen oder die Konfiguration ändern; deshalb das Verschwinden von Sysmon-Ereignissen selbst überwachen (**Heartbeat**).

## Quiz

? Welche Sysmon-Event-ID protokolliert Prozessstarts?
= 1
! Inklusive Elternprozess, Kommandozeile und Hashes.

? Welche Sysmon-ID zeigt Zugriffe auf andere Prozesse, z. B. auf LSASS?
= 10
! ProcessAccess ist zentral für die Erkennung von Credential Dumping.

? Welche Sysmon-ID protokolliert DNS-Abfragen?
= 22
! Hilfreich gegen C2 und DNS-Tunneling.

?tf Sysmon blockiert schädliche Prozesse automatisch.
= falsch
! Sysmon protokolliert nur; Blockieren übernehmen EDR oder Richtlinien.

? Welcher Prozessbaum ist ein typischer Hinweis auf eine Webshell?
+ w3wp.exe startet cmd.exe
- explorer.exe startet notepad.exe
- svchost.exe startet svchost.exe
- winlogon.exe startet userinit.exe
! Der IIS-Worker sollte keine Shell starten.

? Warum nutzt man Vorlagen wie die von SwiftOnSecurity?
+ sie filtern Rauschen und erfassen wichtige Bereiche gezielt
- sie machen Sysmon kostenlos
- sie ersetzen das SIEM
- sie verschlüsseln die Logs
! Eine gute Konfiguration entscheidet über die Qualität der Daten.

? Welche Sysmon-IDs betreffen Registry-Änderungen?
+ 12
+ 13
+ 14
- 3
! Run-Keys sind ein klassischer Persistenzort.

@@@ MODULE @@@
---
id: soc-06
title: SOC-Praxis 6 · PowerShell- und Linux-auditd-Logging
paths: cdsa, specialist
order: 30.6
difficulty: medium
icon: terminal
tags: soc, powershell, linux, auditd
summary: Script Block Logging, Module Logging und Transcription unter Windows sowie auditd-Regeln unter Linux – damit Befehle sichtbar werden.
---

## Einfach erklärt

Angreifer lieben Kommandozeilen, weil sie mächtig und schon vorhanden sind. Verteidiger brauchen deshalb Logs, die zeigen, **was genau** eingetippt oder ausgeführt wurde – unter Windows über PowerShell-Logging, unter Linux über **auditd**.

## PowerShell-Logging

| Art | Was | Event |
|---|---|---|
| Script Block Logging | ausgeführte Skriptblöcke, auch nach Entschleierung | 4104 |
| Module Logging | Pipeline-Ausführung einzelner Befehle | 4103 |
| Transcription | vollständige Ein-/Ausgabe als Textdatei | Datei |

Aktivierung per Gruppenrichtlinie (Administrative Vorlagen → Windows PowerShell). Zusätzlich sinnvoll:

- **PowerShell v2 entfernen** – sie kennt kein Script Block Logging und wird für Downgrade-Angriffe genutzt.
- **Constrained Language Mode** über Application Control (WDAC/AppLocker) für normale Nutzer.
- **AMSI** – lässt Virenscanner Skriptinhalte vor der Ausführung prüfen.

> [!TIPP] Entschleierung gratis
> Script Block Logging protokolliert den Code so, wie PowerShell ihn ausführt – Base64- und Verkettungs-Tricks sind dann oft schon aufgelöst.

## Linux: auditd

auditd ist das Kernel-Audit-System. Regeln legen fest, was protokolliert wird:

```bash
# Ausführung aller Programme (64-Bit) protokollieren
-a always,exit -F arch=b64 -S execve -k exec
# Änderungen an sensiblen Dateien
-w /etc/passwd -p wa -k identity
-w /etc/sudoers -p wa -k privesc
-w /root/.ssh/ -p wa -k root_ssh
```

Auswerten mit `ausearch -k identity` oder `aureport --summary`; für SIEMs per Laurel oder Agent in strukturiertes Format bringen.

## Tiefer eingetaucht

Gute auditd-Regelwerke (z. B. Community-Vorlagen von Florian Roth/Neo23x0) setzen Schwerpunkte: Ausführung aus `/tmp` und `/dev/shm`, Änderungen an Cron, Systemd-Units und SSH-Schlüsseln, Kernel-Modul-Laden, Nutzung von Netzwerktools. Zu breite `execve`-Regeln erzeugen enorme Datenmengen – filtern nach Nutzer (`-F auid>=1000`) oder Pfaden.

Wichtig ist die **auid** (Audit-User-ID): Sie bleibt auch nach `sudo` oder `su` erhalten und zeigt, welche Person ursprünglich angemeldet war.

Auf beiden Plattformen gilt: Angreifer mit Admin-/Root-Rechten können Logging abschalten. Darum Logs sofort weiterleiten und das **Ausbleiben** von Logs überwachen.

## Quiz

? Welche Event-ID enthält PowerShell-Script-Block-Logs?
= 4104
! Im Kanal Microsoft-Windows-PowerShell/Operational.

? Warum sollte PowerShell v2 entfernt werden?
+ sie unterstützt kein Script Block Logging und wird für Downgrades genutzt
- sie ist kostenpflichtig
- sie ist zu langsam
- sie läuft nur unter Linux
! `powershell -version 2` umgeht sonst moderne Schutzmechanismen.

? Welche Schnittstelle lässt Virenscanner Skriptinhalte vor der Ausführung prüfen?
= AMSI
= Antimalware Scan Interface
! AMSI sieht den Inhalt nach Entschleierung zur Laufzeit.

? Was bedeutet `-w /etc/passwd -p wa` in auditd?
+ Schreib- und Attributänderungen an /etc/passwd überwachen
- /etc/passwd löschen
- /etc/passwd nur lesen
- alle Prozesse beenden
! w = write, a = attribute change.

? Mit welchem Befehl sucht man auditd-Ereignisse nach Schlüssel?
= ausearch -k
= ausearch
! Beispiel: ausearch -k identity.

?tf Die auid zeigt auch nach sudo noch, welcher Benutzer ursprünglich angemeldet war.
= wahr
! Deshalb ist sie für die Zurechnung von Aktionen so wertvoll.

? Welcher Systemaufruf wird für die Protokollierung von Programmausführungen überwacht?
= execve
! execve startet ein neues Programm im Prozess.

@@@ MODULE @@@
---
id: soc-07
title: SOC-Praxis 7 · Windows-Artefakte in der Forensik
paths: cdsa, specialist
order: 30.7
difficulty: hard
icon: archivebox.fill
tags: forensik, windows, artefakte
summary: Prefetch, Amcache, Shimcache, LNK, Jump Lists, ShellBags, SRUM und Registry – welche Spuren Programme und Nutzer hinterlassen.
---

## Einfach erklärt

Auch wenn Angreifer ihre Werkzeuge löschen, hinterlassen sie **Fußabdrücke**: Windows merkt sich für Komfort und Leistung eine Menge – welche Programme liefen, welche Dateien geöffnet wurden, welche USB-Sticks steckten. Forensiker lesen diese „Nebenprodukte“ aus.

## Programmausführung

| Artefakt | Ort | Zeigt |
|---|---|---|
| Prefetch | `C:\Windows\Prefetch\*.pf` | Programm lief; Anzahl, letzte Ausführungszeiten |
| Amcache | `C:\Windows\AppCompat\Programs\Amcache.hve` | Programme mit SHA1-Hash, Pfad |
| Shimcache (AppCompatCache) | Registry SYSTEM | Programme, die Windows gesehen hat (nicht zwingend ausgeführt) |
| UserAssist | Registry NTUSER.DAT | per Explorer gestartete Programme, ROT13-kodiert |
| BAM/DAM | Registry SYSTEM | letzte Ausführung pro Nutzer |
| SRUM | `C:\Windows\System32\sru\SRUDB.dat` | Ressourcen- und Netzwerknutzung pro Programm, ca. 30 Tage |

## Dateien und Ordner

| Artefakt | Zeigt |
|---|---|
| LNK-Dateien (Recent) | geöffnete Dateien, Originalpfad, Datenträger, Zeitstempel |
| Jump Lists | zuletzt geöffnete Dateien pro Anwendung |
| ShellBags | angesehene Ordner – auch auf entfernten oder gelöschten Laufwerken |
| `$MFT`, `$UsnJrnl`, `$LogFile` | NTFS-Metadaten, Änderungsjournal |
| Papierkorb (`$I`/`$R`) | gelöschte Dateien mit Originalpfad und Löschzeit |

## Geräte und Netz

- **USB**: Registry `USBSTOR`, `MountedDevices`, `setupapi.dev.log`
- **WLAN-Profile**: bekannte Netze mit Verbindungszeiten
- **RDP-Bitmap-Cache**: Bildschirmkacheln entfernter Sitzungen

> [!MERKE] Ein Artefakt ist ein Indiz, mehrere sind ein Beweis
> Shimcache allein beweist keine Ausführung. Prefetch + Amcache + Event 4688 zusammen ergeben ein belastbares Bild.

## Tiefer eingetaucht

Werkzeuge: Eric Zimmermans Tools (PECmd, AmcacheParser, AppCompatCacheParser, LECmd, JLECmd, SBECmd, MFTECmd, EvtxECmd, Timeline Explorer), KAPE zur schnellen Sammlung, Plaso/log2timeline für Super-Timelines.

Typischer Ablauf einer Untersuchung: Artefakte sicher sammeln (Triage-Image oder Vollabbild) → parsen → in eine gemeinsame **Timeline** bringen → um bekannte Zeitpunkte (erster Alarm, verdächtige Anmeldung) herum filtern → Hypothesen prüfen. Achtung bei Zeitstempeln: Prefetch speichert bis zu acht letzte Ausführungen; NTFS kennt pro Datei mehrere Zeitstempelsätze ($STANDARD_INFORMATION lässt sich leichter manipulieren – „Timestomping“ – als $FILE_NAME).

Auf neueren Windows-Servern ist Prefetch standardmäßig oft deaktiviert – dann gewinnen Amcache, SRUM und Ereignisprotokolle an Bedeutung.

## Quiz

? Wo liegen Prefetch-Dateien?
= C:\Windows\Prefetch
! Endung .pf, Name enthält Programmname und Pfad-Hash.

? Welches Artefakt speichert Programme mit SHA1-Hash?
= Amcache
= Amcache.hve
! Sehr nützlich, um Werkzeuge per Hash zu identifizieren.

?tf Ein Eintrag im Shimcache beweist sicher, dass ein Programm ausgeführt wurde.
= falsch
! Shimcache zeigt, dass Windows die Datei gesehen hat – Ausführung muss bestätigt werden.

? Welches Artefakt zeigt angesehene Ordner, auch auf nicht mehr vorhandenen Laufwerken?
= ShellBags
! ShellBags speichern Ansichtseinstellungen von Ordnern.

? Welche Datenbank zeigt Netzwerknutzung pro Programm über etwa 30 Tage?
= SRUM
! System Resource Usage Monitor – hilfreich bei Exfiltrationsverdacht.

? Wie heißt die Manipulation von Datei-Zeitstempeln durch Angreifer?
= Timestomping
! Der Vergleich von $SI- und $FN-Zeitstempeln kann sie entlarven.

? Welche Registry-Schlüssel helfen bei der USB-Analyse?
+ USBSTOR
+ MountedDevices
- Run
- Winlogon
! Zusammen mit setupapi.dev.log ergibt sich, welches Gerät wann angeschlossen war.

? Wie ist UserAssist kodiert?
= ROT13
! Die Programmnamen sind mit ROT13 verschleiert.

@@@ MODULE @@@
---
id: soc-08
title: SOC-Praxis 8 · Speicherforensik mit Volatility
paths: cdsa
order: 30.8
difficulty: hard
icon: memorychip.fill
tags: forensik, speicher, volatility
summary: Warum der Arbeitsspeicher die Wahrheit enthält, wie man ihn sichert und mit Volatility 3 Prozesse, Verbindungen und Injektionen findet.
---

## Einfach erklärt

Die Festplatte zeigt, was gespeichert wurde. Der **Arbeitsspeicher** zeigt, was **gerade passiert**: laufende Prozesse, offene Verbindungen, entschlüsselte Daten, eingeschleuster Code, der nie eine Datei war. Speicherforensik ist wie ein Foto vom Tatort im Moment der Tat.

## RAM sichern

- Werkzeuge: WinPmem, DumpIt, Magnet RAM Capture (Windows), LiME/AVML (Linux).
- Vor dem Herunterfahren sichern – danach ist alles weg (**Order of Volatility**).
- Hash des Abbilds bilden und dokumentieren (**Chain of Custody**).
- Bei virtuellen Maschinen: Snapshot inkl. Speicher (z. B. `.vmem`) nutzen.

## Volatility 3 – wichtige Plugins

| Plugin | Zeigt |
|---|---|
| `windows.info` | Betriebssystemversion des Abbilds |
| `windows.pslist` / `pstree` | Prozessliste / Prozessbaum |
| `windows.psscan` | auch versteckte/beendete Prozesse |
| `windows.cmdline` | Kommandozeilen |
| `windows.netscan` | Netzwerkverbindungen |
| `windows.malfind` | verdächtige ausführbare Speicherbereiche (Injection) |
| `windows.dlllist` | geladene DLLs |
| `windows.handles` | offene Handles (Dateien, Mutexe) |
| `windows.svcscan` | Dienste |

```bash
vol -f speicher.raw windows.pstree
vol -f speicher.raw windows.netscan
vol -f speicher.raw windows.malfind --pid 4321
```

> [!TIPP] Vergleichen, was nicht passt
> Ein Prozess, der in `psscan` auftaucht, aber nicht in `pslist`, wurde womöglich versteckt (DKOM).

## Tiefer eingetaucht

Worauf man achtet:

- **Falsche Eltern**: `svchost.exe` muss von `services.exe` gestartet sein; `lsass.exe` gibt es genau einmal.
- **Falsche Pfade**: `svchost.exe` aus `C:\Users\…` statt `System32`.
- **Tippfehler-Namen**: `scvhost.exe`, `lsas.exe`.
- **malfind-Treffer**: Speicher mit `PAGE_EXECUTE_READWRITE` und einem PE-Header (`MZ`) – klassische Injektion.
- **Netzwerk**: Verbindungen ungewöhnlicher Prozesse (z. B. `notepad.exe`) nach außen.

Volatility 3 braucht passende **Symboltabellen** für das Betriebssystem (werden für Windows meist automatisch geladen). Ergänzend lassen sich verdächtige Speicherbereiche extrahieren und mit YARA scannen (`yarascan`). Auch Speicherauszüge von Hibernation-Dateien (`hiberfil.sys`) und Auslagerungsdateien (`pagefile.sys`) enthalten wertvolle Reste.

## Quiz

? Welches Volatility-Plugin zeigt den Prozessbaum?
= windows.pstree
= pstree
! Eltern-Kind-Beziehungen zeigen ungewöhnliche Starts.

? Welches Plugin findet verdächtige, ausführbare Speicherbereiche?
= windows.malfind
= malfind
! Typisch für Code-Injektion.

?tf Ein Prozess, der in psscan, aber nicht in pslist erscheint, kann versteckt worden sein.
= wahr
! psscan durchsucht den Speicher nach Prozessstrukturen statt der verketteten Liste.

? Wie oft sollte lsass.exe auf einem Windows-System laufen?
= einmal
= 1
! Mehrere lsass-Prozesse sind ein starkes Warnsignal.

? Von welchem Prozess wird svchost.exe normalerweise gestartet?
= services.exe
! Andere Eltern deuten auf Tarnung hin.

? Welches Plugin listet Netzwerkverbindungen auf?
= windows.netscan
= netscan
! Auch geschlossene Verbindungen können noch sichtbar sein.

? Welche Werkzeuge eignen sich zur RAM-Sicherung unter Windows?
+ WinPmem
+ DumpIt
- Wireshark
- Nmap
! Für Linux nutzt man z. B. LiME oder AVML.

@@@ MODULE @@@
---
id: soc-09
title: SOC-Praxis 9 · Malware-Triage statisch und dynamisch
paths: cdsa
order: 30.9
difficulty: hard
icon: ladybug.circle.fill
tags: malware, analyse
summary: In 30 Minuten zu einer belastbaren Einschätzung einer verdächtigen Datei – Hashes, Strings, PE-Header, Sandbox und IOCs, sicher und methodisch.
---

## Einfach erklärt

Bei einer verdächtigen Datei will das SOC schnell wissen: **Ist das bösartig? Was tut es? Woran erkenne ich es anderswo?** Malware-Triage ist keine vollständige Rückentwicklung, sondern eine strukturierte Erstuntersuchung – wie ein Sanitäter, nicht wie ein Chirurg.

## Sicherheit zuerst

- Nur in einer **isolierten Analyse-VM** ohne Verbindung zum Firmennetz arbeiten (Snapshots!).
- Dateien entschärft transportieren (z. B. als passwortgeschütztes ZIP mit dem Passwort `infected`).
- Keine Uploads vertraulicher Firmendateien in öffentliche Dienste – Hash-Suche ist unkritischer als Datei-Upload.

## Statische Analyse (ohne Ausführen)

1. **Hashes** (SHA256) bilden und in Threat-Intel-Quellen nachschlagen.
2. **Dateityp** prüfen (`file`, Magic Bytes) – stimmt die Endung?
3. **Strings** extrahieren (`strings`, FLOSS): URLs, IPs, Registry-Pfade, Befehle.
4. **PE-Header** ansehen: Kompilierzeit, Sektionen, Importe (`VirtualAlloc`, `CreateRemoteThread` sind auffällig), Signatur.
5. **Entropie**: sehr hohe Entropie deutet auf Packer oder Verschlüsselung.
6. **YARA**-Regeln laufen lassen.

## Dynamische Analyse (kontrolliert ausführen)

In einer Sandbox (lokal oder Dienst) beobachtet man:

| Bereich | Werkzeuge/Beobachtung |
|---|---|
| Prozesse | Process Monitor, Process Explorer, Sysmon |
| Dateien/Registry | angelegte Dateien, Run-Keys, Dienste |
| Netzwerk | DNS-Anfragen, HTTP-Verbindungen (INetSim/FakeNet simulieren das Internet) |
| Speicher | entpackte Payloads, Injektionen |

> [!WARNUNG] Malware kann Sandboxen erkennen
> Manche Proben prüfen auf VM-Artefakte, wenige CPU-Kerne, fehlende Nutzeraktivität oder warten einfach lange. „Nichts passiert“ heißt nicht „harmlos“.

## Tiefer eingetaucht

Ergebnis der Triage ist ein kurzer Bericht:

- Einschätzung (bösartig / verdächtig / unauffällig) mit Begründung
- Familie, falls bekannt
- Verhalten in ATT&CK-Techniken
- **IOCs**: Hashes, Domains, IPs, Pfade, Mutexe, Registry-Schlüssel
- Empfehlungen: Blockieren, Suchen in der Umgebung (Hunting nach den IOCs), Erkennungsregeln

Die nachhaltigsten Erkenntnisse sind **Verhaltensmerkmale** (z. B. „legt Dienst mit zufälligem Namen an und startet rundll32 mit Export X“), weil Hashes und Domains schnell wechseln – siehe Pyramid of Pain.

## Quiz

? Was sollte man vor jeder dynamischen Analyse sicherstellen?
+ eine isolierte VM mit Snapshot ohne Zugang zum Firmennetz
- Administratorrechte im Firmennetz
- einen schnellen Internetzugang ohne Filter
- dass der Virenscanner deinstalliert ist
! Malware darf nicht entkommen; der Snapshot ermöglicht die Rückkehr zum sauberen Zustand.

? Welches Passwort wird traditionell für Malware-ZIP-Archive verwendet?
= infected
! Konvention, damit Virenscanner und Mailfilter die Datei nicht versehentlich anfassen.

? Was deutet eine sehr hohe Entropie einer Datei an?
+ Packer oder Verschlüsselung
- viele Kommentare
- eine Textdatei
- ein leeres Programm
! Komprimierte/verschlüsselte Daten wirken zufällig.

? Welches Werkzeug extrahiert auch verschleierte Strings aus Malware?
= FLOSS
! FireEye Labs Obfuscated String Solver.

?tf Wenn Malware in der Sandbox nichts tut, ist sie harmlos.
= falsch
! Viele Proben erkennen Sandboxen oder verzögern ihr Verhalten.

? Welche Importe einer PE-Datei sind auffällig für Code-Injektion?
+ VirtualAlloc
+ CreateRemoteThread
+ WriteProcessMemory
- GetSystemTime
! Diese Kombination ist typisch für Injektionstechniken.

? Welche Werkzeuge simulieren Internetdienste in einem isolierten Labor?
+ INetSim
+ FakeNet
- Nessus
- BloodHound
! So sieht man Anfragen, ohne echte Verbindungen zuzulassen.

@@@ MODULE @@@
---
id: soc-10
title: SOC-Praxis 10 · Pyramid of Pain, Kill Chain und Diamond Model
paths: cdsa, specialist
order: 31
difficulty: medium
icon: triangle.fill
tags: threat intelligence, modelle
summary: Drei Denkmodelle, mit denen Analysten Angriffe einordnen, Erkennungen priorisieren und Zusammenhänge zwischen Vorfällen herstellen.
---

## Einfach erklärt

Modelle sind Landkarten: Sie sind nicht die Wirklichkeit, helfen aber, sich zu orientieren. Drei Karten benutzen Analysten ständig:

- **Pyramid of Pain** – welche Erkennungen tun Angreifern am meisten weh?
- **Cyber Kill Chain** – in welcher Phase steckt ein Angriff?
- **Diamond Model** – wie hängen Angreifer, Werkzeug, Infrastruktur und Opfer zusammen?

## Pyramid of Pain

Von unten (leicht für Angreifer zu ändern) nach oben (schmerzhaft):

1. **Hash-Werte** – eine Änderung an der Datei, neuer Hash.
2. **IP-Adressen** – schnell gewechselt.
3. **Domainnamen** – etwas aufwendiger.
4. **Netzwerk-/Host-Artefakte** – z. B. User-Agent, Pfade, Registry-Schlüssel.
5. **Werkzeuge** – Angreifer müssen neue Tools finden oder bauen.
6. **TTPs** – Taktiken, Techniken, Vorgehen: die Arbeitsweise selbst.

> [!MERKE] Nach oben arbeiten
> IOC-Blocklisten sind nützlich, aber kurzlebig. Erkennungen auf TTP-Ebene (z. B. „Zugriff auf LSASS durch unbekannte Prozesse“) bleiben lange wirksam.

## Cyber Kill Chain (Lockheed Martin)

1. Reconnaissance – Aufklärung
2. Weaponization – Waffe bauen
3. Delivery – Zustellung
4. Exploitation – Ausnutzung
5. Installation – Persistenz
6. Command & Control – Fernsteuerung
7. Actions on Objectives – eigentliches Ziel

Je früher man die Kette unterbricht, desto geringer der Schaden. Kritik: Das Modell ist sehr auf Malware und Perimeter ausgerichtet; für interne Bewegungen ist **MITRE ATT&CK** detaillierter.

## Diamond Model

Jedes Ereignis hat vier Ecken: **Adversary** (Angreifer), **Capability** (Werkzeug/Fähigkeit), **Infrastructure** (Server, Domains), **Victim** (Opfer). Kennt man zwei Ecken, kann man über die Verbindungen die anderen suchen („Pivoting“ in der Threat Intelligence): Dieselbe Infrastruktur taucht bei einem anderen Opfer auf → derselbe Akteur?

## Tiefer eingetaucht

In der Praxis kombiniert man die Modelle: ATT&CK beschreibt die **Techniken**, die Kill Chain die grobe **Phase**, das Diamond Model die **Zusammenhänge** über Vorfälle hinweg, die Pyramid of Pain die **Priorisierung** von Erkennungen. Für die Verteidigung gibt es mit **MITRE D3FEND** ein Gegenstück, das Abwehrtechniken systematisch beschreibt.

## Quiz

? Was steht ganz oben auf der Pyramid of Pain?
= TTPs
= Taktiken, Techniken und Prozeduren
! Die Arbeitsweise eines Angreifers zu ändern kostet ihn am meisten.

? Welche Indikatoren sind für Angreifer am leichtesten zu ändern?
+ Hash-Werte
- TTPs
- Werkzeuge
- Netzwerk-Artefakte
! Ein Byte ändern genügt für einen neuen Hash.

?order Bringe die ersten Phasen der Cyber Kill Chain in die richtige Reihenfolge.
> Reconnaissance
> Weaponization
> Delivery
> Exploitation
> Installation
! Danach folgen Command & Control und Actions on Objectives.

? Welche vier Ecken hat das Diamond Model?
+ Adversary
+ Capability
+ Infrastructure
+ Victim
- Firewall
! Die Verbindungen zwischen den Ecken ermöglichen Pivoting.

?tf Je später man die Kill Chain unterbricht, desto geringer ist meist der Schaden.
= falsch
! Je früher, desto besser.

? Wie heißt das MITRE-Framework, das Abwehrtechniken beschreibt?
= D3FEND
= MITRE D3FEND
! Gegenstück zu ATT&CK auf Verteidigerseite.

@@@ MODULE @@@
---
id: soc-11
title: SOC-Praxis 11 · Beaconing, DNS-Tunneling und Exfiltration erkennen
paths: cdsa
order: 31.1
difficulty: hard
icon: antenna.radiowaves.left.and.right
tags: netzwerk, erkennung, c2
summary: Wie Command-and-Control-Verkehr und Datenabfluss im Netzwerk auffallen – Periodizität, Datenmengen, seltene Ziele und DNS-Muster.
---

## Einfach erklärt

Eine infizierte Maschine „telefoniert nach Hause“ – oft in regelmäßigen Abständen, wie ein Herzschlag: alle 60 Sekunden eine kurze Anfrage. Das nennt man **Beaconing**. Menschen surfen unregelmäßig; Maschinen, die exakt rhythmisch Kontakt aufnehmen, fallen auf.

## Merkmale von Beaconing

- **Regelmäßigkeit**: ähnliche Abstände zwischen Verbindungen (mit etwas „Jitter“ zur Tarnung).
- **Gleichförmigkeit**: ähnliche Paketgrößen, gleicher Pfad, gleicher User-Agent.
- **Seltenes Ziel**: Nur ein oder wenige Hosts im Unternehmen sprechen mit dieser Domain.
- **Junge Domain**: erst vor wenigen Tagen registriert.
- **Ungewöhnlicher Prozess**: ein Programm, das normalerweise keine Internetverbindungen aufbaut.

> [!TIPP] Seltenheit ist ein starkes Signal
> „Wie viele Hosts im Unternehmen haben diese Domain in den letzten 30 Tagen kontaktiert?“ – Ist die Antwort „einer“, lohnt der Blick.

## DNS-Tunneling

Daten werden in DNS-Anfragen versteckt, z. B. als Subdomain: `aGVsbG8gd29ybGQ.exfil.example.net`. Hinweise:

- sehr lange oder zufällig wirkende Subdomains (hohe Entropie)
- viele unterschiedliche Subdomains unter einer Domain
- ungewöhnliche Record-Typen (TXT, NULL) in großer Zahl
- hohe Abfragerate eines einzelnen Hosts

## Exfiltration

| Hinweis | Beispiel |
|---|---|
| ungewöhnliche Uploadmengen | Host sendet nachts 20 GB ins Internet |
| ungewöhnliche Ziele | Cloud-Speicher, die im Unternehmen nicht genutzt werden |
| Archivierung vorab | `7z`/`rar` mit Passwort kurz vor dem Upload |
| ungewöhnliche Protokolle | ICMP mit großen Nutzlasten, DNS |

## Tiefer eingetaucht

Werkzeuge und Methoden: Zeek-Logs (`conn.log`, `dns.log`, `ssl.log`) sind ideal, weil sie kompakt Metadaten liefern. RITA (Real Intelligence Threat Analytics) bewertet Beaconing statistisch. TLS-Fingerprints (JA3/JA4) helfen, bekannte Malware-Clients trotz Verschlüsselung zu erkennen.

Statistik in der Praxis: Abstände zwischen Verbindungen pro (Quelle, Ziel) berechnen, Median und Streuung bestimmen – kleine Streuung bei vielen Verbindungen ist verdächtig. Aber Vorsicht: Updater, Telemetrie und Monitoring-Agenten beaconen auch. Darum mit **Allowlists** bekannter, legitimer Ziele arbeiten.

Gegenmaßnahmen: ausgehenden Verkehr nur über Proxy erlauben, DNS nur über interne Resolver, Kategorie-Filter für neue Domains, DLP für sensible Daten.

## Quiz

? Was ist Beaconing?
+ regelmäßige Kontaktaufnahme einer infizierten Maschine mit ihrem C2-Server
- ein WLAN-Signal
- ein Backup-Verfahren
- ein Lastverteilungsalgorithmus
! Die Regelmäßigkeit macht Beaconing statistisch erkennbar.

? Wie nennt man die zufällige Variation der Abstände beim Beaconing?
= Jitter
! Jitter soll die Erkennung erschweren.

? Welche Merkmale deuten auf DNS-Tunneling hin?
+ sehr lange, zufällig wirkende Subdomains
+ viele TXT-Abfragen
+ hohe Abfragerate eines einzelnen Hosts
- eine einzelne Abfrage nach google.com
! Daten werden in DNS-Anfragen und -Antworten kodiert.

?tf Legitime Software wie Updater kann ebenfalls Beaconing-ähnliches Verhalten zeigen.
= wahr
! Deshalb braucht man Allowlists und Kontext.

? Welche Zeek-Logdatei enthält Verbindungsmetadaten?
= conn.log
! dns.log, http.log und ssl.log ergänzen sie.

? Welches Open-Source-Werkzeug bewertet Beaconing statistisch auf Basis von Zeek-Logs?
= RITA
! Real Intelligence Threat Analytics.

? Was ist ein typischer Vorbote von Exfiltration auf einem Host?
+ Daten werden mit Passwort archiviert
- der Bildschirmschoner startet
- ein Drucker wird installiert
- Updates werden installiert
! Archivierung bündelt und verschleiert Daten vor dem Upload.

@@@ MODULE @@@
---
id: soc-12
title: SOC-Praxis 12 · Lateral Movement erkennen
paths: cdsa, cape
order: 31.2
difficulty: hard
icon: arrow.left.arrow.right.circle.fill
tags: erkennung, windows, ad
summary: Wie sich Angreifer von System zu System bewegen (RDP, SMB/PsExec, WinRM, WMI, DCOM) und welche Spuren das auf Quelle und Ziel hinterlässt.
---

## Einfach erklärt

Nach dem ersten Einbruch sitzt ein Angreifer selten schon am Ziel. Er zieht von Raum zu Raum – von einem Arbeitsplatz zum Server, vom Server zum Domain Controller. Diese Bewegung heißt **Lateral Movement**. Gute Nachricht: Jeder Schritt erzeugt Spuren auf der **Quelle** und dem **Ziel**.

## Techniken und Spuren

| Technik | Auf dem Ziel sichtbar |
|---|---|
| RDP | 4624 Logon Type 10, TerminalServices-Logs (1149, 21, 24, 25) |
| SMB + Dienst (PsExec-artig) | 4624 Type 3, 7045/4697 Dienstinstallation, Zugriff auf `ADMIN$` (5145) |
| WinRM / PowerShell Remoting | 4624 Type 3, `wsmprovhost.exe`, WinRM-Logs (91, 168) |
| WMI | `WmiPrvSE.exe` startet Prozesse, WMI-Activity-Logs |
| Geplante Aufgaben remote | 4698, TaskScheduler-Logs |
| DCOM | `mmc.exe`/`excel.exe` als Elternprozess ungewöhnlicher Befehle |

Auf der **Quelle**: 4648 (explizite Anmeldedaten), Prozessstarts von `mstsc.exe`, `psexec.exe`, `wmic.exe /node:`, `Enter-PSSession`.

> [!MERKE] Ungewöhnliche Wege sind das Signal
> Dass sich Admins per RDP auf Server verbinden, ist normal. Dass sich ein Buchhaltungs-PC per SMB-Dienstinstallation auf einen anderen Arbeitsplatz verbindet, nicht.

## Erkennungsstrategien

1. **Workstation-zu-Workstation-Verkehr** über SMB, RDP, WinRM: in den meisten Netzen selten – ein starkes Signal.
2. **Erstmalige Verbindungen**: Konto X meldet sich zum ersten Mal an Host Y an.
3. **Admin-Konten an ungewöhnlichen Orten**: Domain-Admin auf einem normalen Arbeitsplatz.
4. **Pass-the-Hash-Muster**: 4624 Type 3 mit NTLM, Logon Process `NtLmSsp`, aber ohne vorherige interaktive Anmeldung.
5. **Werkzeugspuren**: Dienstnamen wie `PSEXESVC` oder zufällig benannte Dienste.

## Tiefer eingetaucht

Prävention macht Erkennung leichter:

- Host-Firewalls: SMB/RDP/WinRM zwischen Arbeitsplätzen blockieren.
- **Tiering**: Admin-Konten einer Ebene melden sich nie an Systemen einer niedrigeren Ebene an.
- **LAPS**: einzigartige lokale Admin-Passwörter verhindern Wiederverwendung.
- Lokale Konten für Netzwerkanmeldungen sperren (Richtlinie „Deny access from network“ für lokale Konten).
- **Protected Users** und Credential Guard erschweren das Abgreifen von Anmeldedaten.

Mit diesen Maßnahmen wird jede Abweichung zu einem lauten Alarm statt zu Hintergrundrauschen.

## Quiz

? Welcher Logon Type entsteht bei einer SMB-Netzwerkanmeldung?
= 3
! Type 3 = Network.

? Welche Event-ID kann auf eine PsExec-artige Dienstinstallation hindeuten?
= 7045
! Dienstinstallation im System-Log; oft mit ungewöhnlichem Dienstnamen.

? Welcher Prozess erscheint auf dem Ziel bei PowerShell Remoting?
= wsmprovhost.exe
! Der WinRM-Plugin-Host führt die entfernte Sitzung aus.

?tf Direkte SMB- oder RDP-Verbindungen zwischen normalen Arbeitsplätzen sind in vielen Netzen selten und daher verdächtig.
= wahr
! Ein starkes, oft rauscharmes Erkennungssignal.

? Welche Maßnahme verhindert die Wiederverwendung lokaler Admin-Passwörter?
= LAPS
! Local Administrator Password Solution vergibt einzigartige Passwörter pro Gerät.

? Welche Prozess-Elternbeziehung deutet auf WMI-basierte Ausführung hin?
+ WmiPrvSE.exe startet cmd.exe oder powershell.exe
- explorer.exe startet chrome.exe
- services.exe startet svchost.exe
- winlogon.exe startet logonui.exe
! Der WMI-Provider-Host ist der Elternprozess entfernter WMI-Befehle.

? Welches Prinzip verhindert, dass Domain-Admins sich an Arbeitsplätzen anmelden?
= Tiering
= Tier-Modell
! Admin-Anmeldedaten bleiben in ihrer Ebene.

@@@ MODULE @@@
---
id: soc-13
title: SOC-Praxis 13 · Cloud-Logs untersuchen – CloudTrail, Entra ID, M365
paths: cdsa, specialist
order: 31.3
difficulty: medium
icon: cloud.fill
tags: cloud, logs, incident response
summary: Welche Logs Cloud-Plattformen liefern, welche Ereignisse auf Kompromittierung hindeuten und welche Fallstricke es bei Aufbewahrung und Aktivierung gibt.
---

## Einfach erklärt

In der Cloud gibt es keinen Server-Keller, in dem man Festplatten sichern könnte. Die wichtigste Spurenquelle sind die **Audit-Logs** des Anbieters: Wer hat wann über welche Schnittstelle was getan? Wer sie nicht aktiviert und lange genug aufbewahrt, ist nach einem Vorfall blind.

## AWS CloudTrail

- protokolliert API-Aufrufe (Konsole, CLI, SDK): `eventName`, `userIdentity`, `sourceIPAddress`, `userAgent`.
- **Management Events** standardmäßig; **Data Events** (z. B. S3-Objektzugriffe) separat aktivieren.
- Verdächtig: `ConsoleLogin` ohne MFA, `CreateAccessKey` für fremde Nutzer, `StopLogging`/`DeleteTrail`, `PutBucketPolicy` mit öffentlichem Zugriff, `AssumeRole` in ungewöhnliche Rollen, `GetSecretValue` in großer Zahl.

## Microsoft Entra ID und Microsoft 365

| Quelle | Inhalt |
|---|---|
| Sign-in Logs | Anmeldungen inkl. Ort, Gerät, Conditional-Access-Ergebnis |
| Audit Logs | Änderungen: Rollen, Apps, Richtlinien |
| Unified Audit Log | Exchange, SharePoint, OneDrive, Teams |
| MailItemsAccessed | welche Mails gelesen wurden (Lizenz/Konfiguration beachten) |

Verdächtig: neue **Posteingangsregeln** (Weiterleitung nach extern, Löschen von Mails mit „Rechnung“), neue **App-Registrierungen** oder Zustimmungen zu Apps mit weitreichenden Rechten (**Consent Phishing**), neue MFA-Methoden kurz nach einer verdächtigen Anmeldung, Rollenzuweisungen.

> [!WARNUNG] Aufbewahrung prüfen – vor dem Vorfall
> Standard-Aufbewahrungszeiten sind oft kurz (z. B. 30–90 Tage je nach Lizenz). Logs in ein SIEM oder einen Speicher mit längerer Aufbewahrung exportieren.

## Tiefer eingetaucht

Typischer Ablauf bei einem kompromittierten Cloud-Konto:

1. Sitzungen widerrufen, Passwort zurücksetzen, MFA-Methoden prüfen.
2. Zugriffsschlüssel und Tokens des Kontos deaktivieren.
3. Logs ab dem ersten verdächtigen Ereignis auswerten: Was wurde gelesen, geändert, angelegt?
4. Persistenz suchen: neue Nutzer, Schlüssel, Rollen, App-Secrets, Weiterleitungsregeln, Föderations-Einstellungen.
5. Ursache klären (Phishing? geleakter Schlüssel?) und schließen.

Wichtig: Angreifer nutzen gestohlene **Tokens** (z. B. Session-Cookies, Refresh-Tokens). Ein Passwortwechsel allein beendet solche Sitzungen nicht immer – Sitzungen explizit widerrufen.

## Quiz

? Welcher AWS-Dienst protokolliert API-Aufrufe?
= CloudTrail
= AWS CloudTrail
! CloudTrail ist die zentrale Audit-Quelle in AWS.

? Welches CloudTrail-Ereignis deutet auf Spurenverwischung hin?
+ StopLogging
- DescribeInstances
- ListBuckets
- GetCallerIdentity
! Das Abschalten der Protokollierung ist ein klassisches Warnsignal.

? Was ist Consent Phishing?
+ Nutzer werden verleitet, einer bösartigen App weitreichende Rechte zu gewähren
- Phishing per SMS
- ein Angriff auf Cookie-Banner
- eine Spam-Variante ohne Links
! Die App erhält per OAuth-Zustimmung dauerhaften Zugriff, unabhängig vom Passwort.

?tf Ein Passwortwechsel beendet immer alle Sitzungen und Tokens eines Angreifers.
= falsch
! Sitzungen und Refresh-Tokens müssen explizit widerrufen werden.

? Welche M365-Änderung ist nach einer Kontoübernahme besonders verdächtig?
+ neue Posteingangsregel, die Mails nach extern weiterleitet
- ein neues Profilbild
- eine geänderte Signatur
- ein neuer Kalendertermin
! Weiterleitungsregeln sind typische Persistenz bei BEC.

? Welche Art von CloudTrail-Ereignissen muss für S3-Objektzugriffe separat aktiviert werden?
= Data Events
! Management Events zeigen nur Verwaltungsaktionen.

? Welche Logquelle enthält Änderungen an Rollen und App-Registrierungen in Entra ID?
= Audit Logs
= AuditLogs
! Sign-in Logs enthalten dagegen Anmeldungen.

@@@ MODULE @@@
---
id: soc-14
title: SOC-Praxis 14 · Incident-Bericht und Lessons Learned
paths: cdsa, specialist
order: 31.4
difficulty: medium
icon: doc.text.fill
tags: incident response, reporting
summary: Wie man einen Vorfall verständlich für Technik und Management dokumentiert und eine Nachbesprechung moderiert, die wirklich etwas verbessert.
---

## Einfach erklärt

Ein Vorfall ist erst vorbei, wenn man daraus gelernt hat. Der **Incident-Bericht** erzählt, was passiert ist; die **Lessons-Learned-Runde** sorgt dafür, dass es nicht wieder passiert. Beides ist so wichtig wie das Löschen des Feuers selbst.

## Aufbau eines Incident-Berichts

1. **Management-Zusammenfassung** – fünf Sätze: Was, wann, Auswirkung, Status, wichtigste Empfehlungen.
2. **Zeitleiste** – vom ersten Ereignis bis zur Wiederherstellung, in UTC.
3. **Umfang** – betroffene Systeme, Konten, Daten.
4. **Ursache** (Root Cause) und Angriffsweg, z. B. in ATT&CK-Techniken.
5. **Maßnahmen** – Eindämmung, Beseitigung, Wiederherstellung.
6. **IOCs** – im Anhang, maschinenlesbar.
7. **Empfehlungen** – priorisiert, mit Verantwortlichen.
8. **Meldepflichten** – z. B. Datenschutzbehörde (72 Stunden nach DSGVO), BSI/NIS2-Meldungen.

> [!TIPP] Schreiben für zwei Publika
> Die Zusammenfassung muss ohne Fachwissen verständlich sein. Details gehören in die technischen Abschnitte.

## Lessons Learned

Ziel: Verbesserungen, keine Schuldigen. Fragen für die Runde (**blameless Post-Mortem**):

- Was ist passiert? (Fakten, Zeitleiste)
- Was lief gut?
- Was lief schlecht oder langsam?
- Wo hatten wir Glück?
- Was ändern wir – konkret, mit Owner und Termin?

## Tiefer eingetaucht

Gute Maßnahmen aus Lessons Learned sind **messbar**: „MFA für alle externen Zugänge bis 31.03.“ statt „Sicherheit verbessern“. Sie betreffen oft Prozesse (Eskalationswege, Erreichbarkeit, Freigaben) mehr als Technik.

Rechtliche Seite: Berichte können später Beweismittel sein. Sachlich bleiben, Fakten von Annahmen trennen („wahrscheinlich“, „bestätigt“), Quellen benennen. Bei möglichem Rechtsstreit die Rechtsabteilung früh einbinden; teilweise wird die Untersuchung über Anwälte beauftragt, um Vertraulichkeit zu sichern.

Kennzahlen aus dem Vorfall (Zeit bis Erkennung, bis Eindämmung, bis Wiederherstellung) fließen in die SOC-Metriken und zeigen, ob Verbesserungen wirken.

## Quiz

? Was gehört an den Anfang eines Incident-Berichts?
+ eine verständliche Management-Zusammenfassung
- die vollständige IOC-Liste
- Rohdaten aus dem SIEM
- Screenshots der Konsole
! Entscheider lesen oft nur die ersten Absätze.

? Innerhalb welcher Frist muss eine meldepflichtige Datenschutzverletzung nach DSGVO in der Regel gemeldet werden?
= 72 Stunden
= 72
! Art. 33 DSGVO: möglichst binnen 72 Stunden nach Bekanntwerden.

? Was ist das Ziel eines „blameless Post-Mortem“?
+ Verbesserungen finden, ohne Schuldige zu suchen
- die verantwortliche Person ermitteln
- Kosten berechnen
- den Vorfall geheim halten
! Ohne Angst werden Fehler offen benannt – nur so lernt die Organisation.

?tf Empfehlungen aus Lessons Learned sollten konkret, mit Verantwortlichen und Terminen formuliert sein.
= wahr
! Nur messbare Maßnahmen werden umgesetzt und überprüfbar.

? In welcher Zeitzone sollte die Zeitleiste geführt werden?
= UTC
! So lassen sich Ereignisse aus verschiedenen Systemen sauber zusammenführen.

? Warum sollte man im Bericht Fakten und Annahmen klar trennen?
+ der Bericht kann später als Beweismittel dienen
- weil es kürzer ist
- weil Annahmen verboten sind
- damit das Management nichts versteht
! Begriffe wie „bestätigt“ und „wahrscheinlich“ schaffen Klarheit.
