---
id: ir-01
title: Incident Response 1 · Die ersten 60 Minuten
paths: cdsa, specialist
order: 34.1
difficulty: medium
icon: alarm.fill
tags: incident response
summary: Was in der ersten Stunde eines Sicherheitsvorfalls zählt – Lage erfassen, Team alarmieren, eindämmen ohne Beweise zu zerstören, kommunizieren und dokumentieren.
---

## Einfach erklärt

In der ersten Stunde eines Vorfalls entscheidet sich viel. Wie bei einem Unfall: **Ruhe bewahren, absichern, Hilfe rufen, Erste Hilfe leisten** – und nicht in Panik das Falsche tun (etwa alle Server sofort neu starten und damit Spuren vernichten).

## Ablauf

1. **Lage erfassen** (Minuten 0–10): Was wurde beobachtet? Wer hat es gemeldet? Welche Systeme? Seit wann?
2. **Alarmieren** (10–15): Incident-Verantwortlichen benennen, IR-Team und ggf. Dienstleister rufen, Geschäftsleitung informieren.
3. **Kommunikationskanal** festlegen: Wenn E-Mail oder AD kompromittiert sein könnten, einen **Out-of-Band-Kanal** nutzen (Telefon, separater Messenger).
4. **Eindämmen** (15–45): Betroffene Systeme isolieren (EDR-Isolation statt Ausschalten), kompromittierte Konten sperren, Ausbreitungswege schließen.
5. **Beweise sichern**: flüchtige Daten (RAM, Netzwerkverbindungen) vor dem Abschalten, Logs exportieren.
6. **Dokumentieren** ab Minute 0: Zeitleiste in UTC – wer hat wann was getan?
7. **Meldepflichten prüfen**: DSGVO (72 h), NIS2 (24 h Frühwarnung), Versicherung, Polizei.

> [!GEFAHR] Nicht vorschnell abschalten
> Ausschalten vernichtet Arbeitsspeicher-Spuren und warnt ggf. den Angreifer. Isolieren statt Ausschalten – außer, es läuft gerade eine Verschlüsselung, dann kann sofortiges Trennen den Schaden begrenzen.

## Rollen

| Rolle | Aufgabe |
|---|---|
| Incident Lead | koordiniert, entscheidet, priorisiert |
| Technik-Lead | Analyse und Eindämmung |
| Schreiber | Protokoll und Zeitleiste |
| Kommunikation | intern, extern, Behörden, Presse |
| Recht/Datenschutz | Meldepflichten, Beweisführung |

## Tiefer eingetaucht

Häufige Fehler: Angreifer zu früh „aufschrecken“ (Konten sperren, bevor man den Umfang kennt – sie wechseln dann auf andere Zugänge), keine Dokumentation, zu viele Beteiligte ohne Rollen, Kommunikation über kompromittierte Kanäle, Wiederherstellung vor Ursachenklärung.

Die Abwägung zwischen **schnell eindämmen** und **erst Umfang verstehen** ist situationsabhängig: Bei aktiver Verschlüsselung oder Datenabfluss geht Eindämmung vor; bei stiller Spionage kann es sinnvoll sein, erst den gesamten Zugang des Angreifers zu kartieren und dann koordiniert alles auf einmal zu schließen.

## Quiz

? Warum sollte man kompromittierte Systeme eher isolieren als ausschalten?
+ Ausschalten vernichtet flüchtige Spuren im Arbeitsspeicher
- isolieren ist billiger
- ausschalten ist verboten
- isolierte Systeme reparieren sich selbst
! EDR-Isolation trennt das Netz, behält aber den Zustand.

? Was ist ein Out-of-Band-Kanal?
+ ein Kommunikationsweg, der nicht über die möglicherweise kompromittierte Infrastruktur läuft
- ein VPN-Tunnel
- ein E-Mail-Verteiler
- ein Ticketsystem im Firmennetz
! Angreifer lesen sonst womöglich mit.

?tf Die Zeitleiste eines Vorfalls sollte ab der ersten Minute geführt werden.
= wahr
! Später rekonstruieren ist fehleranfällig.

? Wann kann sofortiges Trennen vom Netz trotz Spurenverlust sinnvoll sein?
+ wenn gerade eine Verschlüsselung durch Ransomware läuft
- immer
- nie
- nur am Wochenende
! Schadensbegrenzung hat dann Vorrang.

? Welche Rolle führt Protokoll und Zeitleiste?
= Schreiber
= Protokollführer
! Damit Incident Lead und Technik sich auf ihre Aufgaben konzentrieren können.

? Warum kann es riskant sein, Angreifer zu früh aufzuschrecken?
+ sie wechseln auf andere, noch unbekannte Zugänge
- weil sie sich beschweren
- weil Logs verschwinden
- weil die Versicherung dann nicht zahlt
! Erst den Umfang kennen, dann koordiniert schließen – je nach Lage.

@@@ MODULE @@@
---
id: ir-02
title: Incident Response 2 · Beweissicherung und Chain of Custody
paths: cdsa, specialist
order: 34.2
difficulty: medium
icon: archivebox.circle.fill
tags: forensik, beweissicherung
summary: Wie man digitale Beweise gerichtsfest sichert – Reihenfolge der Flüchtigkeit, Abbilder, Hashes, Dokumentation und Aufbewahrung.
---

## Einfach erklärt

Ein digitaler Beweis ist nur so viel wert wie der Nachweis, dass er **unverändert** ist und **lückenlos** nachvollzogen werden kann, wer ihn wann in der Hand hatte. Wie bei einer Blutprobe im Labor: beschriftet, versiegelt, jede Übergabe protokolliert.

## Reihenfolge der Flüchtigkeit (Order of Volatility)

1. CPU-Register, Cache
2. Arbeitsspeicher, Netzwerkverbindungen, laufende Prozesse
3. temporäre Dateien, Swap
4. Festplatten
5. entfernte Logs, Monitoring-Daten
6. Archive, Backups

Was zuerst verschwindet, wird zuerst gesichert.

## Abbilder richtig erstellen

| Art | Inhalt | Werkzeuge (Beispiele) |
|---|---|---|
| Speicherabbild | RAM | WinPmem, LiME, AVML |
| Physisches Abbild | gesamter Datenträger inkl. freiem Bereich | FTK Imager, dd/dcfldd, Guymager |
| Logisches Abbild | ausgewählte Dateien | Triage-Werkzeuge (KAPE, Velociraptor) |
| Cloud | Snapshots, Logexporte | Anbieter-APIs |

- **Schreibschutz** (Write Blocker) beim Abbilden physischer Datenträger.
- **Hash** (SHA-256) vom Original und vom Abbild – identisch = unverändert.
- Arbeiten nur an **Kopien**, nie am Original.

> [!MERKE] Chain of Custody
> Jede Übergabe wird dokumentiert: Was (mit Hash), wer, wann, wo, warum. Lücken in dieser Kette können einen Beweis vor Gericht entwerten.

## Tiefer eingetaucht

In vielen Unternehmensvorfällen ist ein vollständiges Festplattenabbild zu langsam (Terabytes, viele Systeme). **Triage-Sammlungen** (gezielte Artefakte: Logs, Registry, Prefetch, MFT) mit Werkzeugen wie KAPE oder Velociraptor liefern in Minuten die wichtigsten Spuren – über hunderte Systeme parallel.

Rechtlich: Bei möglicher Strafverfolgung früh mit Rechtsabteilung und ggf. Polizei (Zentrale Ansprechstellen Cybercrime) abstimmen; Datenschutz beachten (Beweise enthalten personenbezogene Daten); Aufbewahrung und Löschung regeln.

## Quiz

? Was sichert man nach der Order of Volatility zuerst?
+ Arbeitsspeicher und laufende Netzwerkverbindungen
- Backups
- Archive
- die Festplatte
! Flüchtiges verschwindet zuerst.

? Wie belegt man, dass ein Abbild unverändert ist?
+ Hash von Original und Abbild vergleichen
- das Abbild ausdrucken
- den Dateinamen prüfen
- die Dateigröße schätzen
! Gleiche SHA-256-Werte belegen Identität.

? Was verhindert ein Write Blocker?
+ Schreibzugriffe auf den Original-Datenträger beim Abbilden
- das Lesen von Daten
- Viren im Abbild
- Stromausfälle
! So bleibt das Original unverändert.

?tf Analysen sollten am Original-Datenträger durchgeführt werden.
= falsch
! Immer an verifizierten Kopien arbeiten.

? Welche Werkzeuge sammeln forensische Artefakte schnell über viele Systeme?
+ KAPE
+ Velociraptor
- Photoshop
- Excel
! Triage statt Vollabbild für große Umgebungen.

? Was dokumentiert die Chain of Custody?
+ jede Übergabe eines Beweisstücks mit Wer, Wann, Wo und Warum
- den Kaufpreis der Festplatte
- die Uhrzeit des Mittagessens
- das Betriebssystem des Analysten
! Lücken können Beweise entwerten.

@@@ MODULE @@@
---
id: ir-03
title: Incident Response 3 · Timelines bauen und lesen
paths: cdsa
order: 34.3
difficulty: hard
icon: calendar.day.timeline.left
tags: forensik, timeline
summary: Wie man aus Logs, Dateisystem- und Registry-Zeitstempeln eine Super-Timeline baut, filtert und zu einer belastbaren Ereigniskette verdichtet.
---

## Einfach erklärt

Ermittler legen alle Hinweise auf einen Zeitstrahl: Um 9:02 ging die Mail ein, um 9:05 wurde der Anhang geöffnet, um 9:06 startete PowerShell, um 9:30 meldete sich ein fremdes Konto an. Erst in der **richtigen Reihenfolge** ergibt sich die Geschichte des Angriffs.

## Quellen für Zeitstempel

| Quelle | Beispiele |
|---|---|
| Dateisystem | NTFS $MFT (Erstellt, Geändert, Zugriff, MFT-Änderung), $UsnJrnl |
| Ereignisprotokolle | Windows EVTX, Linux auth.log/journal |
| Registry | LastWrite-Zeiten, UserAssist, BAM |
| Programmausführung | Prefetch, Amcache |
| Browser | Verlauf, Downloads |
| Netzwerk | Firewall, Proxy, DNS, Zeek |
| Cloud | Audit-Logs |

## Vorgehen

1. Artefakte sammeln und parsen (z. B. Plaso/log2timeline, EZ-Tools).
2. In eine gemeinsame **Super-Timeline** zusammenführen.
3. **Zeitzonen normalisieren** (alles in UTC!).
4. Um **Ankerpunkte** filtern: erster Alarm, bekannte bösartige Datei, verdächtige Anmeldung.
5. Von dort vorwärts und rückwärts arbeiten („Was geschah davor/danach?“).
6. Die Kernereignisse in eine **kompakte Zeitleiste** für den Bericht übertragen.

> [!TIPP] Pivot-Punkte
> Jeder Fund liefert neue Suchbegriffe: Ein Dateiname führt zu einem Hash, der Hash zu weiteren Hosts, ein Benutzername zu Anmeldungen, eine IP zu Verbindungen.

## Tiefer eingetaucht

Stolpersteine: falsch eingestellte Systemuhren (NTP-Abweichungen dokumentieren und korrigieren), Zeitstempel-Manipulation (Timestomping – $STANDARD_INFORMATION vs. $FILE_NAME vergleichen), unterschiedliche Auflösungen und Formate, Sommerzeit, riesige Datenmengen (Super-Timelines haben schnell Millionen Zeilen – gezielt filtern).

Werkzeuge: Timeline Explorer zum Filtern großer CSVs, Timesketch für kollaborative Analyse mit Markierungen und Kommentaren. Am Ende steht eine Zeitleiste, die jemand ohne Fachwissen lesen kann – mit Belegen für jeden Eintrag.

## Quiz

? Was ist eine Super-Timeline?
+ eine zusammengeführte Zeitleiste aus vielen Artefaktquellen
- ein besonders langes Video
- ein Kalender des SOC
- ein SIEM-Dashboard
! Werkzeuge wie Plaso erstellen sie automatisch.

? In welche Zeitzone sollte man alle Zeitstempel normalisieren?
= UTC
! Sonst passen Ereignisse aus verschiedenen Quellen nicht zusammen.

? Welches Werkzeug erstellt Super-Timelines?
= Plaso
= log2timeline
! Plaso ist das Framework, log2timeline das Kommandozeilenwerkzeug.

?tf Ein Fund in der Timeline liefert oft neue Suchbegriffe für weitere Spuren.
= wahr
! Dieses Pivoting treibt die Untersuchung voran.

? Wie erkennt man Timestomping unter NTFS?
+ durch Vergleich der Zeitstempel von $STANDARD_INFORMATION und $FILE_NAME
- an der Dateigröße
- am Dateinamen
- an der Farbe des Icons
! $FILE_NAME ist schwerer zu manipulieren.

? Welches Werkzeug ermöglicht kollaborative Timeline-Analyse im Team?
= Timesketch
! Mit Markierungen, Kommentaren und Suchen.

@@@ MODULE @@@
---
id: ir-04
title: Incident Response 4 · Ransomware-Vorfall durchspielen
paths: cdsa, specialist
order: 34.4
difficulty: hard
icon: lock.trianglebadge.exclamationmark.fill
tags: ransomware, incident response
summary: Ein Ransomware-Vorfall von der ersten Meldung bis zur Wiederherstellung – technische, organisatorische und rechtliche Entscheidungen Schritt für Schritt.
---

## Einfach erklärt

Montag, 6:40 Uhr: Mitarbeitende melden, dass Dateien seltsame Endungen haben und auf jedem Bildschirm eine Lösegeldforderung steht. Was jetzt? Dieses Modul spielt den Ablauf durch – damit im Ernstfall Routine statt Chaos herrscht.

## Phase 1: Stoppen (Stunde 0–2)

- Krisenstab einberufen, Out-of-Band-Kommunikation.
- Betroffene Segmente isolieren, Internetanbindung ggf. trennen.
- Weitere Verschlüsselung stoppen: verdächtige Konten sperren, Verteilungswege (GPO, Softwareverteilung, Remote-Tools) prüfen.
- **Backups schützen**: Backup-Systeme vom Netz, Zugänge prüfen.

## Phase 2: Verstehen (Tag 1–3)

- Erstzugang finden (VPN-Lücke? Phishing? gestohlene Zugangsdaten?).
- Umfang: Welche Systeme verschlüsselt, welche Daten **abgeflossen** (Double Extortion)?
- Persistenz und Werkzeuge der Angreifer identifizieren.
- Meldepflichten, Versicherung, Polizei, ggf. Kunden.

## Phase 3: Wiederherstellen (Tage bis Wochen)

1. Saubere Umgebung aufbauen (oft zuerst AD/Identität – Forest Recovery).
2. Systeme aus geprüften Backups neu aufsetzen, nicht „reinigen“.
3. Alle Zugangsdaten zurücksetzen (inkl. krbtgt zweimal, Dienstkonten).
4. Schrittweise Wiederanbindung mit verstärkter Überwachung.
5. Ursache schließen (Patch, MFA, Segmentierung).

> [!WARNUNG] Lösegeld zahlen?
> Behörden raten davon ab: Es finanziert Kriminalität, garantiert keine funktionierende Entschlüsselung und schützt nicht vor Veröffentlichung gestohlener Daten. Zudem können Sanktionsvorschriften Zahlungen verbieten. Die Entscheidung liegt bei der Leitung – mit Rechtsberatung.

## Tiefer eingetaucht

Frühindikatoren vor der Verschlüsselung (oft Tage vorher): neue Admin-Konten, Werkzeuge zur Netzwerkaufklärung (AdFind, Netzwerk-Scanner), Remote-Management-Tools, Deaktivierung von Sicherheitssoftware, Löschen von Schattenkopien (`vssadmin delete shadows`), große Uploads zu Cloud-Speichern (rclone, MEGA). Wer diese Signale erkennt, kann den Angriff vor dem Schaden stoppen.

## Quiz

? Was sollte in den ersten Stunden besonders geschützt werden?
+ die Backup-Systeme
- die Druckerwarteschlange
- das Intranet-Design
- der Kantinenplan
! Angreifer versuchen gezielt, Backups zu zerstören.

? Was bedeutet Double Extortion?
+ Daten werden verschlüsselt und zusätzlich mit Veröffentlichung gedroht
- zweimal verschlüsselte Daten
- zwei Lösegeldforderungen pro Tag
- zwei Angreifergruppen gleichzeitig
! Deshalb muss auch Datenabfluss untersucht werden.

?tf Kompromittierte Systeme sollten bei Ransomware möglichst neu aufgesetzt statt nur gereinigt werden.
= wahr
! Hintertüren lassen sich sonst kaum sicher ausschließen.

? Welcher Befehl zum Löschen von Schattenkopien ist ein typischer Frühindikator?
= vssadmin delete shadows
! Angreifer verhindern so die einfache Wiederherstellung.

? Welche Werkzeuge deuten häufig auf Datenabfluss vor Ransomware hin?
+ rclone
+ MEGA-Client
- Taschenrechner
- Bildschirmlupe
! Große Uploads zu Cloud-Speichern sind ein Warnsignal.

? Was raten Behörden zur Lösegeldzahlung?
+ davon abzuraten
- immer sofort zu zahlen
- nur in Kryptowährung zu zahlen
- doppelt zu zahlen
! Keine Garantie, Finanzierung von Kriminalität, mögliche Sanktionsverstöße.

@@@ MODULE @@@
---
id: ir-05
title: Incident Response 5 · Velociraptor und Live-Response im großen Maßstab
paths: cdsa
order: 34.5
difficulty: hard
icon: hare.fill
tags: velociraptor, dfir, hunting
summary: Wie man mit einem Endpoint-Agenten hunderte Systeme gleichzeitig befragt, Artefakte sammelt und gezielt jagt – Konzepte von Velociraptor.
---

## Einfach erklärt

Bei einem Vorfall mit 2.000 Rechnern kann niemand jeden einzeln untersuchen. **Velociraptor** ist wie ein Funkgerät an jedem Rechner: Man stellt eine Frage („Gibt es diese Datei? Läuft dieser Prozess? Welche Autostarts gibt es?“) – und alle antworten gleichzeitig.

## Grundbegriffe

| Begriff | Bedeutung |
|---|---|
| Client | Agent auf dem Endpunkt |
| Server | sammelt Ergebnisse, Weboberfläche |
| Artifact | vorgefertigte Abfrage (z. B. `Windows.System.Pslist`, `Windows.Persistence.PermanentWMIEvents`) |
| VQL | Velociraptor Query Language – SQL-ähnlich |
| Hunt | ein Artefakt auf vielen Clients gleichzeitig ausführen |
| Collection | Ergebnisse von einem Client |

```sql
SELECT Name, Pid, CommandLine, Exe
FROM pslist()
WHERE Exe =~ "\\\\AppData\\\\" OR Exe =~ "\\\\Temp\\\\"
```

## Typische Hunts im Vorfall

- Existiert eine bestimmte Datei / ein Hash irgendwo?
- Welche Systeme haben neue Dienste oder geplante Aufgaben seit Datum X?
- Wo läuft ein bestimmtes Remote-Tool?
- Welche Hosts haben Verbindungen zu IP Y?
- Triage-Sammlung (KAPE-Ziele) auf verdächtigen Hosts.

> [!TIPP] Erst eng, dann breit
> Neue Abfragen zuerst auf wenigen Testsystemen ausführen – fehlerhafte oder teure Abfragen auf tausenden Rechnern können Last erzeugen.

## Tiefer eingetaucht

Velociraptor kann auch **überwachen** (Event-Queries, z. B. neue Prozesse in Echtzeit) und **reagieren** (Quarantäne, Prozesse beenden) – mit Vorsicht und Freigaben. Gegenüber klassischen EDRs ist es besonders flexibel für forensische Fragestellungen (Zugriff auf rohe NTFS-Strukturen, Registry-Hives gesperrter Dateien).

Sicherheitsaspekte: Ein solches Werkzeug ist mächtig – der Server ist Tier 0. Zugriffe protokollieren, Rollen trennen, Deployment-Pakete schützen.

## Quiz

? Was ist ein Hunt in Velociraptor?
+ die Ausführung eines Artefakts auf vielen Clients gleichzeitig
- ein einzelner Login
- ein Backup
- ein Firewall-Regelwerk
! So befragt man hunderte Systeme parallel.

? Wie heißt die Abfragesprache von Velociraptor?
= VQL
= Velociraptor Query Language
! SQL-ähnlich, mit Plugins wie pslist() oder glob().

?tf Neue, ungeprüfte Abfragen sollte man sofort auf allen Systemen ausführen.
= falsch
! Erst auf wenigen Testsystemen prüfen.

? Wozu dient eine Triage-Sammlung?
+ schnelles Sammeln der wichtigsten forensischen Artefakte
- Löschen von Logs
- Installieren von Updates
- Verschlüsseln von Festplatten
! Ein Kompromiss zwischen Geschwindigkeit und Vollständigkeit.

? Warum gehört der Velociraptor-Server zu Tier 0?
+ er kann auf allen Endpunkten Befehle ausführen und Daten sammeln
- weil er teuer ist
- weil er im Keller steht
- weil er kein Passwort hat
! Wer ihn kontrolliert, kontrolliert alle Clients.

@@@ MODULE @@@
---
id: na-01
title: Netzarchitektur 1 · Segmentierung und Zonenmodell planen
paths: specialist, cyberrange, cdsa
order: 52.1
difficulty: medium
icon: square.grid.3x3.middle.filled
tags: netzwerk, segmentierung, architektur
summary: Wie man ein Netz in Sicherheitszonen aufteilt, welche Kommunikation zwischen Zonen erlaubt ist und wie Segmentierung Angriffe ausbremst.
---

## Einfach erklärt

Schiffe haben wasserdichte Schotten: Wird eine Kammer geflutet, sinkt nicht das ganze Schiff. **Netzsegmentierung** ist dasselbe für IT: Fällt ein Bereich, bleibt der Rest geschützt – vorausgesetzt, die Türen zwischen den Kammern sind wirklich dicht.

## Ein typisches Zonenmodell

| Zone | Inhalt |
|---|---|
| Internet / extern | alles Unbekannte |
| DMZ | öffentlich erreichbare Dienste (Web, Mail-Relay, Reverse Proxy) |
| Client-Netz | Arbeitsplätze |
| Server-Netz | interne Anwendungen |
| Management | Verwaltungszugänge zu Servern, Netzwerkgeräten, Hypervisoren |
| Tier 0 / Identität | Domain Controller, PKI, PAM |
| Gast / IoT | getrennt, nur Internet |
| OT | Produktion, streng getrennt |
| Backup | isoliert, nur definierte Verbindungen |

## Regeln zwischen Zonen

- **Default Deny**: Nur dokumentierte, begründete Flüsse sind erlaubt.
- **Kommunikationsmatrix**: Wer spricht mit wem auf welchem Port – und warum?
- Clients sprechen nicht direkt miteinander (Client-zu-Client blockieren).
- Management nur aus dem Management-Netz (Jump-Host/PAW).
- Server initiieren Internetverbindungen nur über Proxy zu definierten Zielen.

> [!MERKE] Flaches Netz = ein Einbruch reicht
> In einem unsegmentierten Netz erreicht ein infizierter Laptop jeden Server. Viele Ransomware-Fälle wären mit Segmentierung kleiner geblieben.

## Tiefer eingetaucht

Umsetzung schrittweise: Inventar und Ist-Flüsse erfassen (Flow-Logs, Firewall-Logs), Zonen definieren, zunächst protokollieren statt blockieren, dann Regeln verschärfen. **Mikrosegmentierung** geht weiter: Regeln pro Workload oder Anwendung (Host-Firewalls, SDN, Agenten) statt nur zwischen großen Netzen – sinnvoll für Rechenzentren und Cloud.

Segmentierung muss überwacht werden: Verstöße gegen die Kommunikationsmatrix sind hervorragende Alarme, und Regelwerke verwildern ohne regelmäßige Rezertifizierung.

## Quiz

? Welche Zone enthält öffentlich erreichbare Dienste?
= DMZ
! Demilitarisierte Zone zwischen Internet und internem Netz.

? Was bedeutet Default Deny zwischen Zonen?
+ nur ausdrücklich erlaubte Verbindungen sind möglich
- alles ist erlaubt
- nur Ping ist erlaubt
- nur nachts ist Verkehr erlaubt
! Jede Regel braucht eine Begründung.

?tf In einem flachen Netz kann ein infizierter Arbeitsplatz oft jeden Server erreichen.
= wahr
! Segmentierung begrenzt die Ausbreitung.

? Von wo sollte die Verwaltung von Servern und Netzwerkgeräten erfolgen?
+ aus einem eigenen Management-Netz bzw. über Jump-Hosts
- von jedem Arbeitsplatz
- aus dem Gastnetz
- aus dem Internet
! Management-Zugänge sind hochprivilegiert.

? Wie heißt Segmentierung auf Ebene einzelner Workloads?
= Mikrosegmentierung
= Microsegmentation
! Regeln pro Anwendung statt nur zwischen Netzen.

? Was beschreibt eine Kommunikationsmatrix?
+ welche Systeme mit welchen auf welchen Ports kommunizieren dürfen und warum
- die Telefonliste der IT
- die Rechnungsadressen
- die WLAN-Kanäle
! Grundlage für Firewall-Regeln und Überwachung.

@@@ MODULE @@@
---
id: na-02
title: Netzarchitektur 2 · Network Access Control und 802.1X am Kabel
paths: specialist, wifi
order: 52.2
difficulty: medium
icon: cable.connector
tags: nac, 802.1x, netzwerk
summary: Wie man verhindert, dass beliebige Geräte im Firmennetz landen – 802.1X am Switchport, MAB, Profiling, Posture-Prüfung und Quarantänenetze.
---

## Einfach erklärt

Jede Netzwerkdose im Besprechungsraum ist eine Tür ins Firmennetz. Ohne Kontrolle kann jeder Besucher sein Gerät einstecken. **Network Access Control (NAC)** ist der Türsteher an jeder Dose: Erst wer sich ausweist, kommt ins richtige Netz – alle anderen landen im Gästebereich oder draußen.

## Bausteine

| Baustein | Funktion |
|---|---|
| 802.1X am Switchport | Gerät/Nutzer meldet sich per Zertifikat oder Konto an (RADIUS) |
| MAB (MAC Authentication Bypass) | Fallback für Geräte ohne 802.1X (Drucker, Kameras) anhand der MAC-Adresse |
| Profiling | Gerätetyp erkennen (DHCP-Fingerprint, Herstellerpräfix, Verhalten) |
| Posture | Zustand prüfen (Virenschutz aktiv, Patches, Verschlüsselung) |
| Dynamisches VLAN / ACL | je nach Ergebnis passendes Netz |
| Quarantäne | eingeschränktes Netz zur Behebung |

> [!WARNUNG] MAB ist schwach
> MAC-Adressen lassen sich leicht fälschen. MAB nur mit Profiling und stark eingeschränkten Netzen für die jeweiligen Geräteklassen nutzen.

## Einführung in Stufen

1. **Monitor-Modus**: alles erlaubt, aber protokollieren, wer sich wie anmeldet.
2. **Low Impact**: Grundzugang erlaubt, mehr nur nach Anmeldung.
3. **Closed Mode**: ohne erfolgreiche Anmeldung kein Zugang.

## Tiefer eingetaucht

Häufige Schwachstellen in NAC-Umsetzungen: Ausnahmen für „problematische“ Geräte, die nie wieder aufgeräumt werden; Hubs oder kleine Switches hinter einem authentifizierten Port (Multi-Host-Modus statt Multi-Auth); Drucker-Ports mit MAB im gleichen Netz wie Clients. **MACsec** (802.1AE) verschlüsselt zusätzlich die Verbindung zwischen Gerät und Switch und verhindert das Einschleusen hinter authentifizierte Geräte.

NAC-Protokolle sind wertvolle Inventarquelle: Welche Geräte stecken wo? Unbekannte Geräte an sensiblen Orten sind sofort sichtbar.

## Quiz

? Was macht NAC?
+ kontrolliert, welche Geräte sich mit welchem Netz verbinden dürfen
- verschlüsselt Festplatten
- sichert E-Mails
- filtert Webseiten
! Der Türsteher an jeder Netzwerkdose.

? Was ist MAB?
+ ein Fallback, der Geräte anhand ihrer MAC-Adresse zulässt
- ein Malware-Typ
- ein WLAN-Standard
- ein Backup-Verfahren
! Schwach, weil MAC-Adressen fälschbar sind.

? Mit welchem Modus führt man NAC am besten ein?
+ Monitor-Modus, dann schrittweise verschärfen
- sofort Closed Mode für alle
- gar nicht
- nur an Wochenenden
! So findet man Probleme, bevor Nutzer ausgesperrt werden.

?tf MAC-Adressen lassen sich leicht fälschen.
= wahr
! Deshalb ist MAB allein kein starker Schutz.

? Welcher Standard verschlüsselt die Verbindung zwischen Gerät und Switch?
= MACsec
= 802.1AE
! Er verhindert u. a. das Einschleusen hinter authentifizierte Geräte.

? Was prüft eine Posture-Kontrolle?
+ den Sicherheitszustand eines Geräts, z. B. Virenschutz und Patches
- die Körperhaltung des Nutzers
- die Kabellänge
- die Lautstärke des Lüfters
! Nicht konforme Geräte landen in Quarantäne.

@@@ MODULE @@@
---
id: na-03
title: Netzarchitektur 3 · Proxy, Secure Web Gateway und DNS-Filter
paths: specialist, cdsa
order: 52.3
difficulty: medium
icon: arrow.triangle.branch
tags: proxy, swg, dns
summary: Wie ausgehender Webverkehr kontrolliert wird – Proxys, TLS-Inspektion, Kategorien, DNS-Sicherheit und welche Daten das SOC daraus gewinnt.
---

## Einfach erklärt

Ein **Proxy** ist ein Pförtner für ausgehenden Verkehr: Jeder, der ins Internet will, geht an ihm vorbei. Der Pförtner kann verdächtige Ziele sperren, Downloads prüfen und notieren, wer wohin ging. Ein **DNS-Filter** setzt noch früher an – er gibt bösartigen Domains gar nicht erst eine Adresse.

## Bausteine

| Baustein | Funktion |
|---|---|
| Forward Proxy / SWG | URL-Kategorien, Malware-Scan, Richtlinien pro Nutzergruppe |
| TLS-Inspektion | verschlüsselten Verkehr entschlüsseln, prüfen, neu verschlüsseln |
| DNS-Filter / Protective DNS | bekannte bösartige und neue Domains blockieren |
| Sandboxing | unbekannte Downloads ausführen und prüfen |
| CASB | Kontrolle von Cloud-Diensten (Schatten-IT, Datenabfluss) |

> [!WARNUNG] TLS-Inspektion mit Augenmaß
> Sie verbessert die Sicht, bricht aber Ende-zu-Ende-Verschlüsselung auf. Ausnahmen für Banking, Gesundheit und Datenschutz-sensible Kategorien sind üblich; Betriebsrat und Datenschutz müssen eingebunden werden. Falsch umgesetzt schwächt sie sogar die Sicherheit (alte Protokolle, fehlende Zertifikatsprüfung).

## Was das SOC daraus gewinnt

- Welche Nutzer/Hosts riefen eine bösartige Domain auf?
- Downloads ausführbarer Dateien aus ungewöhnlichen Kategorien
- Verbindungen zu neu registrierten Domains
- Datenmengen pro Ziel (Exfiltration)
- User-Agents, die nicht zu Browsern passen (Malware, Skripte)

## Tiefer eingetaucht

**Protective DNS** ist eine der kostengünstigsten Schutzmaßnahmen: Viele Behörden (z. B. das BSI für Bundesbehörden, NCSC in UK) betreiben solche Dienste. Wichtig ist, dass Clients nicht einfach daran vorbei können – DNS-over-HTTPS zu externen Anbietern blockieren oder auf eigene Resolver lenken, direkten Port-53-Verkehr nach außen sperren.

In modernen Architekturen wandert das Gateway in die Cloud (**SSE/SASE**): Richtlinien gelten unabhängig davon, ob Nutzer im Büro oder zu Hause arbeiten.

## Quiz

? Was macht ein Secure Web Gateway?
+ kontrolliert und prüft ausgehenden Webverkehr nach Richtlinien
- verwaltet E-Mail-Postfächer
- sichert Datenbanken
- verteilt IP-Adressen
! Mit Kategorien, Malware-Scan und Protokollierung.

? Was blockiert Protective DNS?
+ die Namensauflösung bekannter bösartiger Domains
- alle Webseiten
- nur Werbung
- interne Server
! Eine sehr kostengünstige Schutzschicht.

?tf TLS-Inspektion sollte ohne Ausnahmen für alle Kategorien gelten.
= falsch
! Ausnahmen für sensible Kategorien und Datenschutz sind üblich und sinnvoll.

? Wofür steht CASB?
= Cloud Access Security Broker
! Er kontrolliert die Nutzung von Cloud-Diensten.

? Welches Signal im Proxy-Log kann auf Malware hindeuten?
+ ein User-Agent, der zu keinem Browser passt
- ein Aufruf der Firmenwebseite
- ein Download eines PDF-Handbuchs vom Hersteller
- eine Suche nach dem Wetter
! Skripte und Malware nutzen oft eigene User-Agents.

? Wie heißt das Architekturkonzept, Netzwerk- und Sicherheitsfunktionen aus der Cloud bereitzustellen?
= SASE
= Secure Access Service Edge
! SSE bezeichnet den reinen Sicherheitsteil.
