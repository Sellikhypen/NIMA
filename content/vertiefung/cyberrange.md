# Tiefer eingetaucht – Cyber Range

## cr-01 | Wie realistisch muss eine Range sein?
Realismus ist kein Selbstzweck. Jede Nachbildung kostet Bau, Pflege und Lastreserven. Entscheidend ist die **funktionale Treue**: Verhält sich die Umgebung bei den geübten Entscheidungen wie das Original? Für Log-Triage zählt echtes Rauschen mehr als eine detailgetreue Firmenwebsite.

> [!PRAXIS] Denk weiter
> Du kannst zehn Server ergänzen oder simulierte Benutzer. Was bringt mehr für ein SOC-Training? Meist die Benutzer, denn ohne normales Verhalten ist jedes Ereignis der Angriff und die Übung zu leicht.

## cr-02 | Planes sind Vertrauensgrenzen
Die Trennung der Ebenen trägt nur, wenn sie auch bei Komfortfunktionen hält. Ein Monitoring-Server mit je einem Bein in Spiel- und Management-Netz ist eine Brücke, ebenso geteilte Passwörter, gemeinsames DNS oder die Zwischenablage. Frag bei jedem Datenfluss: Wer baut die Verbindung auf, und wer verarbeitet fremdbestimmte Eingaben?

> [!PRAXIS] Denk weiter
> Telemetrie muss aus dem Spiel heraus. Wie bleibt die Grenze heil? Schmale Einbahn-Wege mit festem Ziel und Port, ein isolierter Empfänger, der Spiel-Daten als feindlich behandelt, und kein Rückweg zur Steuerung.

## cr-03 | Der Engpass wandert
Hardware wird nach der Spitze dimensioniert, nicht nach dem Mittelwert. Beim gleichzeitigen Start limitieren zufällige Speicherzugriffe, im Betrieb der RAM, bei Mitschnitten die Schreibrate. Bei NVMe ohne Schutz gegen Stromausfall brechen synchrone Schreibvorgänge oft drastisch ein, obwohl das Datenblatt hohe Werte nennt.

> [!PRAXIS] Denk weiter
> 1 Gbit/s wird acht Stunden voll mitgeschnitten. Wie viel Speicher? 125 MB/s × 28.800 s = 3,6 TB, vor Overhead und Kompression.

## cr-04 | Was ein Klon mitbringt
Ein Klon kopiert Identität: Maschinen-ID, SSH-Hostschlüssel, Agenten-Kennungen. Templates werden deshalb generalisiert (Sysprep, cloud-init). Copy-on-Write spart nur anfangs, jeder veränderte Block belegt eigenen Platz. Ein Windows-Update in 30 Klonen speichert praktisch 30-mal.

> [!PRAXIS] Denk weiter
> Darf man einen Domänencontroller aus einem Snapshot zurücksetzen? Allein riskant, weil Replikation und RID-Vergabe zurückspringen. In der Range setzt man die gesamte Umgebung konsistent zurück.

## cr-05 | Isolation gibt es auf mehreren Wegen
„Keine Route ins Internet“ beweist keine Isolation. Auswege sind auch rekursives DNS, NTP, IPv6 mit Autokonfiguration, Proxys, die Zwischenablage und Management-Dienste des Hypervisors, der im Bridge-Netz eine Adresse hat. Getestet wird aus jeder Zone, für IPv4 und IPv6.

> [!PRAXIS] Denk weiter
> Ping nach außen scheitert. Test bestanden? Nein, das prüft ein Protokoll. Teste TCP, UDP, DNS mit zufälligem Namen und IPv6, und beobachte gleichzeitig außen, ob etwas ankommt.

## cr-06 | Zustand ist die heikle Stelle
Der OpenTofu-State verknüpft Code mit echten Objekten und enthält oft Geheimnisse im Klartext. Er braucht Sperren, Versionierung, Verschlüsselung und enge Rechte. Reproduzierbar ist ein Bau erst mit festgelegten Versionen von Providern, Abbildern und Paketen.

> [!PRAXIS] Denk weiter
> Der Plan will eine VM „ersetzen“, du hast nur ein Feld geändert. Warum? Manche Attribute sind unveränderlich. Lies den Plan bis zum auslösenden Feld, bevor du anwendest.

## cr-07 | Schwachstellen brauchen Nachbarschaft
Eine eingebaute Schwachstelle beeinflusst die anderen. Ein zu mächtiges Dienstkonto kann das ganze geplante Szenario abkürzen. Deshalb modelliert man Angriffspfade als Graph und prüft nach jedem Bau, dass die vorgesehenen Wege existieren und die ungewollten nicht.

> [!PRAXIS] Denk weiter
> Teams lösen das Szenario in 20 statt 180 Minuten. Was tun? Den gefundenen Weg nachvollziehen und bewusst entscheiden: als legitime Lösung aufnehmen oder schließen. Nicht bestrafen.

## cr-08 | Die Pipeline muss sich selbst beweisen
Telemetrie verschwindet leise: volle Puffer, gestoppte Agenten, Parserfehler, falsche Uhren. Ein synthetisches Markerereignis je Quelle, das regelmäßig bis zum Dashboard verfolgt wird, prüft die ganze Kette. Gemessen wird auch die Verzögerung.

> [!PRAXIS] Denk weiter
> Das Blue Team meldet einen Angriff nicht. Fehler des Teams? Erst prüfen, ob die Ereignisse für das Team sichtbar waren. Sonst bewertest du die Pipeline und nennst es Kompetenz.

## cr-09 | Anmeldung ist nicht Berechtigung
Keycloak bestätigt Identität und liefert Rollen. Ob eine Person **diese** VM öffnen darf, entscheidet die Anwendung bei jedem Zugriff. Token bleiben nach Rollenentzug bis zum Ablauf gültig, laufende Guacamole-Verbindungen enden nicht automatisch.

> [!PRAXIS] Denk weiter
> Wie testest du Mandantentrennung? Mit zwei echten Testkonten: Konto A ruft gezielt die Kennungen von Team B auf. Unsichtbare Schaltflächen sind keine Zugriffskontrolle.

## cr-10 | Verwundbar, aber nur innen
Die Range mischt absichtlich unsichere und bewusst gehärtete Komponenten. Die Update-Regel ist daher gespalten: Plattform aktuell halten, Szenario-Versionen einfrieren. Das eingefrorene Material braucht Kennzeichnung, Hashes und eine Lizenzprüfung, Windows-Evaluierungen laufen zudem ab.

> [!PRAXIS] Denk weiter
> Ein Scanner meldet 400 Schwachstellen. Wie trennst du sie? Gegen den Katalog beabsichtigter Schwachstellen. Alles außerhalb davon und alles in der Management-Ebene ist ein echter Befund.

## cr-11 | Übertragung ist das eigentliche Ziel
Gute Werte in der Range belegen zunächst nur Können in der Range. Transfer entsteht, wenn Werkzeuge, Abläufe und Zeitdruck dem Arbeitsplatz ähneln und das Gelernte in **veränderten** Szenarien abgefragt wird. Wer dieselbe Übung wiederholt, misst auch Erinnerung.

> [!PRAXIS] Denk weiter
> Die zweite Übung läuft 40 % schneller. Lernerfolg? Belastbar erst mit einer gleich schweren Variante oder einer Vergleichsgruppe.

## cr-12 | Wissen der Teams steuern
Rollen unterscheiden sich vor allem darin, wer was weiß. Das White Team kennt alles, das Blue Team nur seine Lage. Informationslecks zerstören die Messung: gemeinsame Chats, sprechende Hostnamen, sichtbare Automatisierungs-Logs.

> [!PRAXIS] Denk weiter
> Red verursacht versehentlich einen Ausfall außerhalb der Regeln. Wer entscheidet? Die Übungsleitung: anhalten, klar als echtes Ereignis kennzeichnen (etwa „NO PLAY“), beheben, dokumentieren, fortsetzen.

## cr-13 | Zustände statt Annahmen
Eine Zustandsmaschine ist nur nützlich mit Fehlerzuständen: teilweise gebaut, Zeitüberschreitung, Löschen fehlgeschlagen. Jeder Übergang sollte wiederholbar sein. Sonst erzeugt ein zweiter Startversuch doppelte VMs oder verwaiste Netze.

> [!PRAXIS] Denk weiter
> Ein Inject setzt voraus, dass Blue den ersten Angriff fand. Und wenn nicht? Jeder kritische Inject braucht einen Ersatzweg, etwa einen Hinweis von außen, damit die folgenden Lernziele erreichbar bleiben.

## cr-14 | Richtung schlägt Portnummer
Eine Kommunikationsmatrix ist erst vollständig mit **Initiator**, Authentifizierung und Verschlüsselung. Ein Agent, der zum Manager verbindet, braucht keinen eingehenden Port am Client. Windows-RPC handelt nach Port 135 dynamische Ports aus, eine Einzelregel reicht daher nicht.

> [!PRAXIS] Denk weiter
> Kerberos scheitert, NTLM klappt. Wo prüfen? Zeitabweichung (Standard maximal 5 Minuten), DNS-Name statt IP, SPN und Port 88 über TCP und UDP.

## cr-15 | Der Mitschnitt zeigt nicht immer die Leitung
tcpdump auf dem sendenden Host sieht Pakete vor dem Offloading: Segmente über der MTU und scheinbar falsche Prüfsummen sind dort normal. VXLAN kostet über IPv4 rund 50 Byte, aus 1500 werden 1450 nutzbare Byte, sofern das Transportnetz nicht größere Rahmen kann.

> [!PRAXIS] Denk weiter
> Ping klappt, große Downloads hängen. Verdacht? MTU. Teste mit gesetztem DF-Bit schrittweise größer (1472 Byte Nutzlast ergeben 1500) und prüfe, ob ICMP „Fragmentation Needed“ gefiltert wird.

## cr-16 | Vorbilder richtig übernehmen
Große Übungen und Open-Source-Projekte optimieren Verschiedenes: Wettkampf mit Personal, wiederholbare Lehre, schnelles Labor für Einzelne. Übertragbar sind Prinzipien wie Automatisierung, Trennung und Nachbesprechung, nicht Größe oder Werkzeugliste.

> [!PRAXIS] Denk weiter
> Woran erkennst du, ob ein Projekt noch trägt? An Releases, Reaktion auf Issues, unterstützten Versionen und einem eigenen Testaufbau von Null, nicht an Sternen oder Präsentationen.

## cr-17 | Zwei Maschinen sind keine Redundanz
Rollentrennung auf zwei Hosts isoliert Last und Risiko, macht aber beide zu Einzelausfallpunkten. Ein Cluster mit zwei Stimmen verliert bei einem Ausfall das Quorum, denn die Mehrheit von zwei ist zwei. Erst eine dritte Stimme (QDevice) ändert das, kopiert aber noch keine Daten.

> [!PRAXIS] Denk weiter
> Was ist beim Ausfall wichtiger als HA? Für einen Piloten: ein getestetes Backup außerhalb beider Hosts und eine gemessene Wiederanlaufzeit.

## cr-18 | Abnahme nach jeder Phase
Fehler aus frühen Phasen zeigen sich spät und wirken dann wie Anwendungsprobleme: falsche MTU, Uhrzeit, DNS. Jede Phase endet deshalb mit einem automatischen Test, der auch **negativ** prüft, also was nicht funktionieren darf.

> [!PRAXIS] Denk weiter
> Wann ist die Bauanleitung fertig? Wenn eine zweite Person sie auf leerer Hardware ohne Rückfragen schafft. Jede Rückfrage ist ein Dokumentationsfehler.

## cr-19 | Skalierung ist nicht linear
Ceph mit drei Replikaten macht aus 30 TB roh rechnerisch 10 TB, mit Reserve für Ausfall und Füllgrenzen deutlich weniger. Jeder Schreibvorgang geht mehrfach übers Netz. Gemeinsame Dienste wie API, SIEM und Zugangsportal kippen oft vor den Hypervisoren.

> [!PRAXIS] Denk weiter
> Vier Knoten je 512 GB, N+1: Planungsgröße? Drei Knoten, also 1.536 GB abzüglich Host- und Speicherdiensten, nicht 2.048 GB.

## cr-20 | Eine Kette hat Sollbruchstellen
In „Operation Nordlicht“ liefert jeder Schritt zwei Dinge: eine Voraussetzung für den nächsten und eine Chance zur Erkennung. Gute Drehbücher halten je Schritt fest, welche Beobachtung erwartet wird und was geschieht, wenn Blue ihn wirksam unterbricht.

> [!PRAXIS] Denk weiter
> Blue isoliert früh den ersten Rechner. Lernziel erreicht, Tag vorbei? Den Erfolg werten, dann über einen angekündigten zweiten Zugang die späteren Lernziele öffnen.

## cr-21 | Jede Formel erzeugt Verhalten
Teams optimieren, was Punkte bringt. Zählt nur Verfügbarkeit, isoliert niemand. Zählt die Zahl der Meldungen, kommt Spam. Deshalb kombiniert man Verfügbarkeit, Qualität der Meldungen und Zeit, deckelt Wiederholungen und testet die Formel mit absichtlich unfairen Strategien.

> [!PRAXIS] Denk weiter
> Ein Check meldet Port 443 offen. Dienst verfügbar? Nicht sicher. Ein guter Check meldet sich an und prüft eine fachliche Funktion mit wechselndem Inhalt.

## cr-22 | Übung oder Ernstfall?
Das schwierigste Runbook beschreibt die Grenze: Ein echter Angriff auf die Range sieht zuerst wie Teil der Übung aus. Es braucht ein Stoppwort, eine Liste geplanter Aktionen zum Abgleich und eine Person, die die Range trennen darf.

> [!PRAXIS] Denk weiter
> Aufzeichnungen der Teilnehmenden sind nützlich. Alles behalten? Nein: personenbezogene Leistungsdaten brauchen Zweck, Frist und Zugriffskonzept, für Übungsforschung meist eine gesonderte Grundlage.

## cr-23 | Vom Test zur Regression
Purple Teaming wird dauerhaft wirksam, wenn jeder bestandene Test ins Repository wandert und nach Änderungen erneut läuft. Dazu gehören Angriffssimulation, erwartetes Ereignis und erwarteter Alarm. Getrennte Regeltests auf gespeicherten Logs sind schneller, prüfen aber die Sensorik nicht.

> [!PRAXIS] Denk weiter
> Eine Regel besteht den Log-Test, aber nicht den Live-Test. Wo liegt es? Vor der Regel: Audit-Einstellung, Agent, Transport oder Feldzuordnung.

## cr-24 | Schwierigkeit hat mehrere Regler
Ein Szenario wird schwerer durch Rauschen, Zeitdruck, fehlende Telemetrie, längere Ketten oder mehrdeutige Entscheidungen. Verstelle je Stufe nur einen oder zwei Regler, sonst weißt du beim Scheitern nicht, woran es lag.

> [!PRAXIS] Denk weiter
> Wie wird „Phishing-Kampagne“ schwerer ohne neue Technik? Mehr legitime ähnliche Mails, ein betroffenes VIP-Postfach und eine Entscheidung über externe Meldung mit unvollständigen Fakten.

## cr-25 | Der Prozess ist die Wahrheit
In OT kann jedes Paket gültig und die Wirkung trotzdem gefährlich sein. Modbus kennt in der klassischen Form keine Anmeldung, Erkennung braucht daher Prozesswissen: Darf dieser Master diesen Wert in diesem Zustand schreiben? Adressen werden je nach Werkzeug ab 0 oder 1 gezählt.

> [!PRAXIS] Denk weiter
> Die Anzeige zeigt normale Temperatur. Glaubst du ihr? Nur mit unabhängiger Quelle: zweiter Sensor oder physikalisch abhängige Größe wie Druck und Energieaufnahme.

## cr-26 | Emulation hat Grenzen
Lokale Cloud-Emulatoren bilden APIs nach, aber selten die vollständige Rechteauswertung, Protokollierung und Nebenläufigkeit des Originals. Container teilen den Kernel des Hosts. Absichtlich unsichere, privilegierte Container gehören daher in eine eigene VM.

> [!PRAXIS] Denk weiter
> Eine IAM-Policy wirkt im Emulator korrekt. Produktionsreif? Nein, prüfe sie mit den Werkzeugen des Anbieters und negativen Tests in einem abgegrenzten echten Testkonto.

## cr-27 | Verteilte Abläufe scheitern halb
Die Proxmox-API bestätigt lange Aktionen zuerst mit einer Task-Kennung. „Angenommen“ ist nicht „fertig“. Der Orchestrator fragt den Status ab, speichert ihn und gleicht nach einem Absturz Soll und Ist ab. Vergabe von VM-IDs und Netzen braucht eine Sperre oder Transaktion.

> [!PRAXIS] Denk weiter
> Klonen läuft in den Timeout. Einfach wiederholen? Erst nachsehen, ob der erste Auftrag noch läuft oder fertig ist, sonst entstehen Duplikate oder Kollisionen.

## cr-28 | Mittelwerte verstecken Schmerz
Nutzer spüren die langsamsten Anfragen, also p95 und p99. Bei Auslastung nahe 100 % wachsen Warteschlangen stark nichtlinear. Für vCPU zählt am Host die Wartezeit auf physische Kerne, im Gast als Steal Time sichtbar.

> [!PRAXIS] Denk weiter
> CPU 40 %, trotzdem zäh. Was prüfen? Speicherlatenz, Swap, einzelne volle Kerne und Pressure Stall Information, bevor du Kerne kaufst.

## cr-29 | Ein Backup ist erst nach dem Restore eines
Verifikation der Blöcke beweist Lesbarkeit, nicht Startfähigkeit. Mehrere VMs brauchen einen gemeinsamen Zeitpunkt. Bei verschlüsselten Backups muss der Schlüssel außerhalb der gesicherten Umgebung liegen, sonst sperrt der Totalausfall ihn mit ein.

> [!PRAXIS] Denk weiter
> Ein übernommener Host kennt das Backup-Passwort. Wie überleben Sicherungen? Host darf nur schreiben, nicht löschen. Aufräumen läuft auf dem Backup-Server, eine Kopie liegt getrennt.

## cr-30 | Wer ist hier der Angreifer?
Teilnehmende haben auftragsgemäß Administratorrechte in VMs, das Modell muss also mit feindlichem Root im Gast beginnen. Dann zählen VM-Ausbruch, Agenten-Kanal, Zwischenablage, Parser im SIEM und der Browser der Übungsleitung, die Spielinhalte öffnet.

> [!PRAXIS] Denk weiter
> Eine Abmeldung „Risiko akzeptiert“ genügt wann? Wenn benannte Verantwortliche das Restrisiko kennen, es befristen und einen Auslöser für die Neubewertung festlegen.

## cr-31 | Hilfe abbauen
Anfänger lernen aus ausgearbeiteten Beispielen, bei Fortgeschrittenen stört dieselbe Hilfe (Expertise-Umkehr-Effekt). Gute Pfade blenden Hilfen aus: vormachen, gemeinsam, mit Hinweis, allein, in fremdem Kontext. Wissen festigt sich durch Abrufen mit Abstand.

> [!PRAXIS] Denk weiter
> Ein Team hängt seit 30 Minuten. Lösung verraten? Gestuft helfen: erst die Frage, dann die Datenquelle, dann die Methode, zuletzt das Ergebnis.

## cr-32 | Vom Rezept zur Methode
Ein Labor sitzt erst, wenn es ohne Anleitung an veränderten Daten gelingt. Notiere bei jedem Labor Hypothese, Beleg, Gegenprobe und Grenze der Aussage. Beispiel Beacons: Regelmäßigkeit ist der Beleg, die Suche nach legitimen Updatern die Gegenprobe.

> [!PRAXIS] Denk weiter
> Wie machst du Labor 9 schwerer? Gleiche Kerberos-Aufgabe ohne Zeitangabe, mit zusätzlichen normalen Dienstkonten und einem fehlenden DC-Log.

## cr-33 | Der kritische Pfad
Nicht die Summe der Arbeit bestimmt das Ende, sondern die längste Kette von Abhängigkeiten. Lieferzeit, Templates und Isolationstest liegen meist darauf. Plane Spannen statt Punktwerte und zähle Betrieb und Pflege mit, sie übersteigen den Bau oft.

> [!PRAXIS] Denk weiter
> Das Projekt ist zu spät. Was streichst du? Szenarien oder Komfort, nicht Isolation, Wiederherstellung und Generalprobe.

## cr-34 | Wann Checklisten schützen
Listen verhindern Vergessen, nicht Fehlurteile. Wirksame Punkte sind beobachtbar („Testpaket außen nicht angekommen“) statt gefühlt („Isolation geprüft“). Was sich testen lässt, wird automatisiert, menschlich bleiben Entscheidungen.

> [!PRAXIS] Denk weiter
> Alle Haken in zwei Minuten gesetzt, sonst dauert es zwanzig. Was heißt das? Die Liste ist Ritual. Verlange Belege für wenige kritische Punkte und streiche tote Einträge.

## cr-36 | Was „geprüft“ bedeutet
Ein Prüfvermerk gilt für Behauptung, Quelle, Version und Datum. Herstellerdokumentation belegt vorgesehenes Verhalten, ein eigener Test das Verhalten in einer Umgebung. Beides altert, besonders Versionen, Standardwerte und Rechtslage.

> [!PRAXIS] Denk weiter
> Drei Blogs nennen denselben Standardwert. Belegt? Nur wenn sie unabhängig sind. Besser sind Primärdokumentation oder Quellcode der eingesetzten Version und ein kurzer Test.
