# Tiefer eingetaucht – Specialist, Web, WLAN

## s-01 | Ziele widersprechen sich
Schutzziele konkurrieren: Kontosperren schützen Vertraulichkeit und schaden Verfügbarkeit, mehr Kopien umgekehrt. Sicherheit ist daher eine begründete Entscheidung für einen Wert gegen eine Bedrohung. Mehrere Maßnahmen sind nur Verteidigung in der Tiefe, wenn sie unabhängig versagen.

> [!PRAXIS] Denk weiter
> Drei Kontrollen hängen am selben AD. Wie viele Schichten? Bei AD-Übernahme keine.

## s-02 | Scope und Wirksamkeit
Ein Zertifikat gilt für einen Geltungsbereich und bescheinigt ein funktionierendes Managementsystem, nicht die Abwesenheit von Lücken. Abweichungen brauchen Ursache und Korrektur der Ursache. Das interne Audit darf eigene Arbeit nicht prüfen.

> [!PRAXIS] Denk weiter
> Lieferant zeigt ISO 27001. Deine zwei Fragen? Deckt der Scope meine Leistung, und was schließt die SoA aus?

## s-03 | Matrizen rechnen nicht
Ordinale Stufen sind keine Mengen: 1×5 und 5×1 sind nicht gleich schlimm. Seltene katastrophale Risiken brauchen eigene Regeln. Quantitativ hilft die Spanne aus Häufigkeit mal Schaden, ehrlich als Bandbreite.

> [!PRAXIS] Denk weiter
> Alle 5 Jahre 200.000 € ergeben 40.000 € jährlich. Maßnahme 15.000 €, halbiert die Häufigkeit. Lohnt sie? Ja, 20.000 € Minderung, bei dieser Schätzgüte.

## s-04 | Wo Pauschalen enden
Die Bausteine enthalten eine vorgerechnete Risikoanalyse für normalen Schutzbedarf und typische Nutzung. Bei hohem Bedarf, fehlendem Baustein oder untypischem Einsatz folgt BSI 200-3. Das BSI entwickelt die Methodik weiter, prüfe den Stand.

> [!PRAXIS] Denk weiter
> Basis-Absicherung vollständig: fertig? Es ist ein Einstieg, kein Nachweis der Standard-Absicherung.

## s-05 | Uhren laufen parallel
Ein Vorfall kann DSGVO (72 Stunden ab Kenntnis), NIS2 (24 Stunden Frühwarnung, 72 Stunden Meldung, Abschlussbericht binnen eines Monats danach), Verträge und Versicherung gleichzeitig auslösen. Eine Meldung ersetzt die andere nicht. Das ist keine Rechtsberatung.

> [!PRAXIS] Denk weiter
> Auftrag vom IT-Leiter, System beim Hoster. Testen? Erst Vertretungsbefugnis und Bedingungen oder Zustimmung des Hosters.

## s-06 | Vertrauen konzentriert sich
Zero Trust verlagert Vertrauen in Identitätsanbieter, Policy Engine und Gerätesignale. Diese werden Tier 0. Fällt die Entscheidungsstelle aus, muss vorher feststehen, was geschlossen und was offen scheitert, mit überwachtem Notzugang.

> [!PRAXIS] Denk weiter
> MFA überall, ist das Zero Trust? Nein, es fehlen Minimalrechte je Ressource, Gerätezustand, laufende Bewertung und Segmentierung.

## s-07 | Entscheiden unter Unsicherheit
Trenne stets Fakten, Annahmen und offene Fragen im Lageprotokoll. Eindämmung braucht vorab vergebene Befugnisse. NIST SP 800-61 Rev. 3 (2025) ordnet Incident Response den sechs Funktionen des CSF 2.0 zu, das bekannte Vier-Phasen-Modell stammt aus Rev. 2.

> [!PRAXIS] Denk weiter
> Backups reichen 48 Stunden zurück, RPO 4 Stunden. Erfüllt? Nur wenn die Sicherungen höchstens 4 Stunden auseinanderliegen. Tiefe ist nicht RPO.

## s-08 | Systeme statt Schuld
Klickquoten hängen an der Schwierigkeit des Köders und sind kaum vergleichbar. Melderate und Zeit bis zur ersten Meldung zeigen Abwehrfähigkeit. Strafen senken die Meldungen. Entwirf Prozesse so, dass ein Klick oder Anruf allein keinen Schaden auslöst.

> [!PRAXIS] Denk weiter
> Geänderte Bankdaten per Mail: wirksame Kontrolle? Rückruf über die **bereits bekannte** Nummer und zweite Freigabe.

## s-09 | Kennzahlen mit Haken
EPSS schätzt die Wahrscheinlichkeit von Ausnutzung in 30 Tagen, CVSS die Schwere, KEV belegte Ausnutzung. Keins kennt dein Asset. MTTR nur über geschlossene Funde sieht besser aus, wenn schwere Altfälle offen bleiben.

> [!PRAXIS] Denk weiter
> Patch installiert. Fund zu? Erst nach Neustart, Wiederholungsscan und bei Vorausnutzung nach Kompromittierungsprüfung.

## s-10 | Nichtmenschliche Identitäten
Workloads, Apps und Schlüssel übersteigen Menschen oft vielfach, haben kein MFA und selten Besitzer. Bevorzuge föderierte, kurzlebige Anmeldedaten. Bei OIDC aus CI entscheidet die Trust-Bedingung auf Repository und Branch.

> [!PRAXIS] Denk weiter
> Conditional Access blockt Altprotokolle. Alle Logins geschützt? Prüfe Ausnahmen, Service Principals und Gastkonten.

## s-11 | Zonen nach Folgen
IEC 62443 leitet Zonen und Conduits aus Risiko ab, Purdue ist nur ein Ordnungsbild. Security Level unterscheidet Ziel (SL-T), Fähigkeit (SL-C) und erreichten Wert (SL-A). Ein SL-3-fähiges Gerät macht keine SL-3-Zone.

> [!PRAXIS] Denk weiter
> „Air Gap“ behauptet. Was prüfen? Wartungslaptops, USB, Modems, Funk und Historian.

## s-12 | Beides kombinieren
Physischer Zugriff umgeht Logisches, Logisches kann Physisches mildern: 802.1X an Buchsen, Verschlüsselung gegen Diebstahl. Zutrittssysteme sind selbst IT mit Netz, Updates und Admins. Art. 32 DSGVO verlangt Angemessenheit, keine feste Liste.

> [!PRAXIS] Denk weiter
> Vereinzelungsanlage hält alle auf, Anlieferung offen. Stark? Nein, der schwächste Weg zählt.

## s-13 | Fragebogen sind Behauptungen
Stufe Lieferanten nach Zugriff, Daten und Ersetzbarkeit. Nachweise haben Grade: Selbstauskunft, Zertifikat, Prüfbericht, eigene Tests. Bei SOC-2-Berichten stehen Ausnahmen und deine Pflichten (Complementary User Entity Controls) im Text.

> [!PRAXIS] Denk weiter
> Anbieter insolvent morgen. Was muss existieren? Datenexport in nutzbarem Format, Schlüssel, Dokumentation, getesteter Exit.

## b-01 | Nachrichtengrenzen und 0-RTT
HTTP/1.1 markiert Grenzen mit Längenangaben, HTTP/2 mit Frames, Übersetzung dazwischen ist die Wurzel vieler Smuggling-Fälle. TLS-1.3-0-RTT ist wiederholbar und hat keine eigene Forward Secrecy gegenüber dem PSK, daher nur für sichere Anfragen.

> [!PRAXIS] Denk weiter
> no-cache = nicht speichern? Nein, vor Nutzung validieren. Nicht speichern heißt no-store.

## b-02 | Zweite Ordnung und Wirkung
Gespeicherte Werte werden später unsicher, wenn sie erneut in SQL fließen. Das Ausmaß bestimmt das DB-Konto: getrennte Konten je Aufgabe, keine DDL-Rechte, Row-Level Security wo sinnvoll. Pools dürfen Mandantenkontext nicht weiterreichen.

> [!PRAXIS] Denk weiter
> Keine Fehlermeldungen mehr. Lücke zu? Nein, nur blind. Inhalt und Zeit bleiben Kanäle.

## b-03 | CSP, die wirklich wirkt
Allowlist-CSPs werden über JSONP und fremde Skripte auf erlaubten Domains umgangen. Stärker sind Nonce oder Hash mit strict-dynamic, object-src und base-uri none. Trusted Types schließt DOM-Senken. Kontextgerechte Kodierung bleibt Grundlage.

> [!PRAXIS] Denk weiter
> `javascript:`-Link HTML-kodiert. Sicher? Nein, der URL-Kontext braucht eine Schema-Allowlist.

## b-04 | Pfad und Parser
Prüfe nach Kanonisierung und komponentenweise: `/srv/app2` beginnt auch mit `/srv/app`. Symlinks können zwischen Prüfung und Öffnen wechseln. Beim Upload deuten mehrere Parser dieselbe Datei, am sichersten sind zufälliger Name, eigene Origin und Neukodierung.

> [!PRAXIS] Denk weiter
> ZIP-Import: zwei Risiken? Einträge außerhalb des Ziels (Zip Slip) und entpackte Größe.

## b-05 | Autorisierung pro Feld
OpenAPI beschreibt, es erzwingt nichts. Prüfe Funktion, Objekt und Feld, lesend und schreibend. GraphQL braucht Prüfung je Resolver und Kostenlimits, Aliase und Batching umgehen Limits pro HTTP-Anfrage.

> [!PRAXIS] Denk weiter
> v2 ist gefixt. Risiko weg? Erst, wenn v1, Mobil- und Partnerendpunkte inventarisiert oder abgeschaltet sind.

## b-06 | Wirkung minimal belegen
Der kleinste Beweis gewinnt: zwei eigene Konten statt fremder Daten, Schreibprobe nur an eigenen Objekten. Safe Harbor gilt innerhalb der Regeln und bindet weder Dritte noch jede Behörde. Veröffentlichung nach Absprache.

> [!PRAXIS] Denk weiter
> Versehentlich fremde Daten gesehen. Was tun? Stoppen, nicht speichern, sofort melden, offen beschreiben.

## b-07 | Die Erweiterung ist das Risiko
Beim CMS kommt das Risiko meist aus Plugins, Integrationen und Admin-Funktionen, die bestimmungsgemäß Code ändern. Deaktivierte Dateien können erreichbar bleiben. Admin-Zugang ist dort Codeausführung und so zu schützen.

> [!PRAXIS] Denk weiter
> Version versteckt. Schutz? Kaum, Massenscans probieren ohne Erkennung. Besitzer und Updateprozess schützen.

## b-08 | Gleiche Wurzel, harte Grenzen
Alle vier übergeben Eingaben an mächtige Interpreter oder Clients. Die Reihenfolge der Abwehr: Fähigkeit entfernen, Struktur trennen, erlaubte Werte begrenzen, Prozess isolieren. Auch ohne Shell bleiben Optionen gefährlich (Argument Injection).

> [!PRAXIS] Denk weiter
> Argumentliste, Nutzer liefert Dateiname `--output=…`. Problem? Ja, `--` nutzen oder Pfad absolut machen.

## x-01 | Wo Analyse blind wird
Taint-Analyse verliert Flüsse an Reflexion, Dependency Injection, Datenbanken und Queues. Ein Sanitizer gilt nur für einen Kontext. Suche Autorisierung umgekehrt: alle Einstiege auflisten und die markieren, denen eine Prüfung **fehlt**.

> [!PRAXIS] Denk weiter
> Einen Fehler gefunden. Nächster Schritt? Variantenanalyse: dasselbe Muster überall, dann Regel für CI.

## x-02 | Tokens für den richtigen Empfänger
Eine gültige Signatur reicht nicht: iss, aud, exp und Algorithmus prüfen. ID-Token sind für den Client, Access-Token für die API. Konten über iss plus sub verknüpfen, nicht über E-Mail. Öffentliche Clients nutzen Code Flow mit PKCE.

> [!PRAXIS] Denk weiter
> Logout, JWT geht noch 15 Minuten. Fehler? Eigenschaft zustandsloser Tokens. Kurze Laufzeit oder Sperrliste.

## x-03 | Zwischenzustände
Moderne Fehler liegen zwischen Schritten und Komponenten: prüfen und nutzen, Cache und App, Client-Objekt und Modell. Methode: Invariante formulieren, dann parallel, wiederholt, in anderer Reihenfolge und mit zusätzlichen Feldern testen, an eigenen Daten.

> [!PRAXIS] Denk weiter
> Transaktion gesetzt, Gutschein doppelt. Warum? Read Committed lässt beide lesen. Unique Constraint oder Sperre.

## x-04 | Pipeline ist Produktion
Wer Build-Schritte ändert, kann signieren und deployen. Ungeprüfte Pull Requests nie mit Secrets bauen, Runner kurzlebig, Deployment aus geschützten Branches. Gates nur auf neue, sichere Funde, sonst werden sie umgangen.

> [!PRAXIS] Denk weiter
> SAST grün, Pentest findet IDOR. Versagen? Erwartbar: Werkzeuge kennen die Besitzregel nicht, Tests mit zwei Konten schon.

## w-01 | Sendezeit ist die Währung
Alle auf einem Kanal teilen Sendezeit, langsame Clients und viele SSIDs (Beacons mit niedriger Rate) verbrauchen überproportional. 3 dB mehr ist doppelte Leistung, 10 dB zehnfache. Wichtiger als Pegel ist der Abstand zum Rauschen.

> [!PRAXIS] Denk weiter
> −65 dBm Signal, −90 Rauschen: SNR? 25 dB, meist brauchbar, sofern die Auslastung passt.

## w-02 | Was Übergänge kosten
WPA2-PSK erlaubt Offline-Raten aus einem Handshake und kennt keine Forward Secrecy. SAE behebt beides. Der Übergangsmodus hält WPA2 offen und damit den schwächeren Weg samt gleichem Passwort. Für 6 GHz sind WPA3 oder OWE und PMF Pflicht.

> [!PRAXIS] Denk weiter
> WPA3 mit Passwort, das alle kennen. Grenze? Wer es kennt, kann einen gleichnamigen AP stellen. SAE-PK oder Enterprise.

## w-03 | Der Client muss prüfen
EAP-TLS und PEAP stehen und fallen mit der Serverprüfung: feste CA **und** Servername, keine Nachfrage an Nutzer. Bei öffentlicher CA ohne Namen genügt irgendein Zertifikat. RADIUS selbst gehört per IPsec oder RadSec geschützt.

> [!PRAXIS] Denk weiter
> EAP-TLS, Laptop gestohlen. Passwort ändern? Nützt nichts, Zertifikat sperren und Prüfung am RADIUS sicherstellen.

## w-04 | Zuordnen vor Handeln
SSID und BSSID sind fälschbar, fremde APs legitim. Ein Rogue ist erst belegt, wenn er am eigenen Netz hängt (Switchport, MAC-Korrelation). Aktives Stören fremder Netze ist rechtlich riskant, reagiert wird kabelseitig oder vor Ort.

> [!PRAXIS] Denk weiter
> Deauth-Flut trotz PMF. Möglich? Frames sichtbar, aber verworfen. Verbindungen brechen eher durch Jamming, Roaming oder Clients ohne PMF.

## w-05 | Abdeckung belegen
Ein Funktest sieht nur Ort, Zeit, Band und Adapter. Ein 2,4-GHz-Adapter findet kein 6-GHz-Netz, Channel Hopping verpasst Frames. Dokumentiere Strecke und Fähigkeiten, prüfe Client-Profile und Segmentierung zusätzlich mit Konfiguration.

> [!PRAXIS] Denk weiter
> BSSID des Nachbarn im Mitschnitt. Was tun? Filtern, nicht testen, Daten nicht behalten: außerhalb der Freigabe.

## w-06 | Kopplung ist der Moment
BLE „Just Works“ schützt nicht vor Mittelsleuten, LE Secure Connections mit Bestätigung schon. Nähe ist kein Beweis: Relay verlängert RFID und Bluetooth, dagegen hilft Laufzeitmessung wie UWB. Bei RFID ist die UID keine Anmeldung.

> [!PRAXIS] Denk weiter
> Funk verschlüsselt, ein Schlüssel für alle Geräte. Problem? Ein geöffnetes Gerät verrät die Flotte.

## w-07 | Das Gerät gehört dem Nutzer
Alles in der App ist lesbar und änderbar: Schlüssel, Premium-Prüfung, Zertifikat-Pinning. Pinning und Root-Erkennung erhöhen Aufwand, Entscheidungen trifft der Server. Keychain und Keystore brauchen passende Zugriffsklassen, Backups und Logs mitdenken.

> [!PRAXIS] Denk weiter
> API-Schlüssel verschleiert im IPA. Sicher? Nein, er gilt als öffentlich. Über eigenes Backend gehen.

## wl-01 | Kapazität wird in Sendezeit geplant
Mehr APs helfen nur mit freien Kanälen, sonst teilen sie dieselbe Sendezeit. Breite Kanäle erhöhen die Spitze und verkleinern die Zahl überlappungsfreier Kanäle. Geplant wird für das schwächste wichtige Gerät und für die Rückrichtung: Das Telefon sendet schwächer als der AP.

> [!PRAXIS] Denk weiter
> Voller Empfang, Upload bricht ab. Verdacht? Asymmetrische Leistung: Der AP hört den Client nicht. Sendeleistung senken und Zellen angleichen.

## wl-02 | Was der Adapter nicht misst
Ein WLAN-Scan sieht nur dekodierbare Frames. Mikrowelle, Video-Sender und Störer erscheinen nur im Spektrum oder indirekt als Auslastung und Wiederholungen. Adapter melden Pegel verschieden, Messreihen vergleicht man daher nur mit demselben Gerät.

> [!PRAXIS] Denk weiter
> Survey im leeren Büro gut, voll besetzt schlecht. Warum? Menschen dämpfen, Geräte belegen Sendezeit. Unter Last nachmessen.

## wl-03 | Ein Portal ist keine Verschlüsselung
Das Portal autorisiert meist eine MAC-Adresse, die sich kopieren lässt, und schützt keinen Funkverkehr. OWE verschlüsselt gegen Mitlesen, authentifiziert den AP aber nicht. Entscheidend bleiben Client-Isolation, eigenes Segment und Filter zu internen Netzen, auch für IPv6.

> [!PRAXIS] Denk weiter
> Portal leitet HTTPS-Seiten um, Nutzer sehen Warnungen. Richtig? Nein, HTTP-Erkennung des Systems oder die Captive-Portal-API (RFC 8908/8910) verwenden.

## wl-04 | Sensoren haben Dienstpläne
Ein AP, der nebenbei scannt, hört andere Kanäle nur Bruchteile der Zeit, kurze Angriffe entgehen ihm. Dedizierte Sensoren sehen mehr, kosten aber. Schwellen lernt man je Standort, und jedes neue Band braucht passende Sensor-Hardware.

> [!PRAXIS] Denk weiter
> Null Alarme seit Einführung. Gut? Unbelegt. Mit einem eigenen angekündigten Test-AP die Kette bis zum Ticket prüfen.
