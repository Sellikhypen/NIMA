# Tiefer eingetaucht – Active Directory und Detection

## a-01 | Wer prüft eigentlich ein Ticket?
Ein Dienst fragt beim Empfang eines Service-Tickets normalerweise **nicht** beim KDC nach. Er entschlüsselt es mit seinem eigenen Schlüssel und vertraut dem Inhalt. Daraus folgt fast alles Schwierige an Kerberos: Wer den Schlüssel eines Dienstkontos kennt, kann diesem Dienst eine Identität vorspielen, ohne dass der Domänencontroller ein Ereignis 4769 schreibt.

Ebenso wirken Änderungen verzögert. Gruppen stehen im PAC und damit im Ticket. Wer aus einer Gruppe entfernt wird, behält diese Mitgliedschaft in vorhandenen Tickets bis zu deren Ablauf.

> [!PRAXIS] Denk weiter
> Ein Konto wird um 9 Uhr aus der Admin-Gruppe entfernt und greift um 11 Uhr noch zu. Ein Fehler? Nicht zwingend: Das Ticket von 8 Uhr gilt noch. Bei einem Vorfall gehören deshalb das Sperren des Kontos, das Beenden der Sitzungen und der Schlüsselwechsel zusammen.

## a-02 | Ein Zertifikat überlebt das Passwort
Bei der Anmeldung per Zertifikat (PKINIT) zählt der private Schlüssel, nicht das Passwort. Ein Passwortwechsel entwertet ein fremd ausgestelltes Zertifikat **nicht**. Es muss gesperrt werden, und die Sperrliste muss die Domänencontroller auch erreichen.

Der zweite Knackpunkt ist die Zuordnung von Zertifikat zu Konto. Namen wie der UPN sind änderbar, deshalb bindet die starke Zuordnung das Zertifikat an unveränderliche Merkmale wie die SID oder an Aussteller und Seriennummer.

> [!PRAXIS] Denk weiter
> Nach einem Vorfall wurden alle Passwörter gewechselt. Welche Frage fehlt? „Welche Zertifikate wurden im fraglichen Zeitraum ausgestellt?“ Die Datenbank der CA beantwortet sie. War der CA-Schlüssel selbst betroffen, reicht Sperren nicht, dann muss die PKI neu aufgebaut werden.

## a-03 | Der Forest ist die Sicherheitsgrenze
Eine Domäne wirkt wie eine Grenze, ist aber vor allem eine Verwaltungseinheit. Alle Domänen eines Forests teilen Schema und Konfigurationspartition und vertrauen einander. Die Kompromittierung einer Kinddomäne muss deshalb als Gefahr für den ganzen Forest behandelt werden.

Zwischen Forests begrenzt SID-Filtering, was die fremde Seite behaupten darf. Selektive Authentifizierung begrenzt zusätzlich, an welchen Rechnern sich fremde Identitäten überhaupt anmelden dürfen.

> [!PRAXIS] Denk weiter
> Eine zugekaufte Firma soll auf zwei Server zugreifen. Kinddomäne oder eigener Forest? Eigener Forest mit einseitigem Trust und selektiver Authentifizierung: Die vertrauende Seite stellt die Server, die vertraute Seite die Konten.

## a-04 | Die Reihenfolge der Wiederherstellung
Nach einer AD-Kompromittierung zählt die Reihenfolge mehr als die Menge der Maßnahmen. Wer Passwörter von einem noch kontrollierten Gerät aus ändert, liefert die neuen gleich mit aus. Zuerst braucht es eine saubere Administrationsumgebung, dann das Schließen aller Rückwege, dann den Wechsel der Geheimnisse.

Das Konto krbtgt speichert aktuelles und vorheriges Passwort, daher wird es zweimal zurückgesetzt. Dazwischen muss die Replikation abgeschlossen sein. Geplant wartet man zusätzlich die maximale Ticket-Laufzeit ab, im akuten Notfall nimmt man Störungen in Kauf.

> [!PRAXIS] Denk weiter
> Warum genügt das Backup von gestern nicht? Angreifer sind oft Wochen vorher im Netz. Das Backup kann die Hintertür enthalten und wird isoliert geprüft, bevor es produktiv wird.

## d-01 | Die Falle der Basisrate
Eine Regel mit 99 % Genauigkeit klingt hervorragend. Bei einer Million Ereignissen pro Tag, davon zehn bösartig, erzeugt 1 % Fehlalarmquote rund 10.000 Fehlalarme für höchstens zehn Treffer. Über 99,9 % der Alarme sind dann falsch.

Deshalb gewinnt ein SOC selten durch empfindlichere Regeln, sondern durch Kontext: Wert des Systems, Rolle des Kontos, Seltenheit des Prozesses und das Zusammentreffen schwacher Signale auf derselben Entität.

> [!PRAXIS] Denk weiter
> Die mittlere Bearbeitungszeit halbiert sich. Ein Erfolg? Nur, wenn die Qualität bleibt. Werden Alarme schneller ungeprüft geschlossen, sieht die Kennzahl genauso aus. Stichproben geschlossener Alarme decken das auf.

## d-02 | Warum Suchen langsam sind
In Splunk entscheidet der erste Suchabschnitt über die Kosten. Index, Zeitraum und seltene Begriffe nach vorn. Ein führender Platzhalter wie `*admin` kann den Wortindex kaum nutzen. `stats` lässt sich auf die Indexer verteilen, `transaction` und große `join` sammeln dagegen viel an einer Stelle und stoßen an Grenzen.

In Elastic entscheidet das Mapping: `keyword` speichert den exakten Wert, `text` zerlegt ihn in Wörter. Exakte Filter und Gruppierungen gehören auf `keyword`.

> [!PRAXIS] Denk weiter
> Eine Suche liefert null Treffer. Ist nichts passiert? Erst eine Positivkontrolle: Findet dieselbe Suche ein bekanntes, harmloses Ereignis? Falscher Index, anderer Feldname und Zeitzone sind häufige Ursachen für leere Ergebnisse.

## d-03 | Prozesse eindeutig verfolgen
Prozess-IDs werden wiederverwendet, für Zeitleisten taugen sie allein nicht. Sysmon vergibt eine **ProcessGuid**, die eindeutig bleibt und Prozessstart, Netzwerkverbindung und Dateierzeugung verbindet.

Bei Anmeldungen verbindet die **Logon-ID** das Ereignis 4624 mit späteren Ereignissen derselben Sitzung. Sie gilt nur auf diesem Rechner und bis zum Neustart. Außerdem entsteht 4624 dort, wo zugegriffen wird, 4768, 4769 und 4776 dagegen dort, wo die Anmeldedaten geprüft werden.

> [!PRAXIS] Denk weiter
> Anmeldung Typ 3 auf dem Dateiserver: Wo suchst du weiter? Logon-ID auf dem Server für die Aktionen, Quelladresse für den Ursprungsrechner, Domänencontroller für die Ticketanforderung.

## d-04 | Hypothesen, die scheitern können
Eine gute Hunting-Hypothese ist widerlegbar: Technik, Datenquelle, Zeitraum und erwartete Spur sind benannt. „Wir suchen Auffälliges“ kann nie scheitern und belegt deshalb nichts.

Das stärkste einfache Werkzeug ist **Stacking**: gleiche Werte zählen und die seltenen ansehen. Seltenheit funktioniert aber nur in vergleichbaren Gruppen. Auf einem Entwickler-Laptop ist ein Compiler normal, an der Kasse nicht.

> [!PRAXIS] Denk weiter
> Ein Hunt findet nichts. Was ist das Ergebnis? Die dokumentierte Aussage, wonach mit welchen Daten gesucht wurde, welche Systeme keine Daten lieferten und welche Suche sich als Regel automatisieren lässt.

## d-05 | Was trotz Verschlüsselung sichtbar bleibt
TLS verbirgt Inhalte, nicht das Verhalten. Sichtbar bleiben Adressen, Zeitpunkte, Dauer, Größen, meist der Servername und Merkmale des ClientHello, aus denen Fingerprints wie JA4 entstehen. Das Serverzertifikat ist ab TLS 1.3 allerdings verschlüsselt.

Jeder Sensor hat blinde Flecken: Der Spiegelport verwirft bei Überlast, Verkehr im selben Segment kommt nie vorbei, NAT verdeckt den Client. Zeek protokolliert Lücken, diese Daten gehören überwacht.

> [!PRAXIS] Denk weiter
> Ein Host verbindet sich exakt alle 60 Sekunden. C2? Vielleicht, aber Updater und Monitoring tun dasselbe. Erst Prozess auf dem Host, Alter und Seltenheit des Ziels machen daraus einen Befund.

## d-06 | Wenn die Sandbox nichts zeigt
„Kein Verhalten“ heißt nicht „harmlos“. Schadsoftware kann auf Zeit, Benutzeraktionen, Parameter, eine Domäne oder einen erreichbaren Server warten. Eine Sandbox zeigt einen einzigen Ausführungspfad unter ihren Bedingungen.

Statische Analyse zeigt dagegen Möglichkeiten: Importe belegen Fähigkeiten, nicht deren Nutzung. Hohe Entropie spricht für Packen oder Verschlüsselung, kommt aber auch bei legitimen komprimierten Installern vor.

> [!PRAXIS] Denk weiter
> Warum lädt man eine verdächtige Datei nicht sofort in einen öffentlichen Dienst? Sie kann vertrauliche Daten enthalten, und ein gezielter Angreifer erfährt von der Entdeckung. Zuerst nur den Hash abfragen.

## d-07 | Regeln sind Software
Eine Regel braucht Testfälle, einen Besitzer und eine Versionsgeschichte. YARA sucht zuerst kurze Teilstücke (Atome) der Muster. Kurze oder sehr häufige Muster machen Scans langsam, eine billige Bedingung wie die Dateigröße hilft zusätzlich.

Bei Sigma entscheidet die Übersetzung: Feldnamen, Groß- und Kleinschreibung und Platzhalter unterscheiden sich je Zielsystem. Eine fehlerfrei konvertierte Regel kann trotzdem nie auslösen.

> [!PRAXIS] Denk weiter
> Welche zwei Tests braucht jede Regel mindestens? Ein Ereignis, das treffen **muss**, und ein ähnliches legitimes, das **nicht** treffen darf. Beide laufen bei jeder Änderung automatisch.

## d-08 | Was ein Artefakt wirklich beweist
Jedes Artefakt beantwortet eine enge Frage. Ein Amcache-Eintrag belegt, dass Windows eine Datei erfasst hat, nicht sicher deren Ausführung. Prefetch ist ein stärkerer Ausführungshinweis, fehlt aber auf Servern meist. Ein Dateisystem-Zeitstempel sagt, was im Feld steht, und lässt sich verändern.

Gute Befunde trennen Beobachtung, Schlussfolgerung und Sicherheit der Aussage. Zwei unabhängige Quellen schlagen ein spektakuläres Einzelartefakt.

> [!PRAXIS] Denk weiter
> Eine Datei ist angeblich älter als die Installation des Systems. Manipulation? Möglich, aber Kopieren und Entpacken übernehmen Zeitstempel. Vergleiche mit $FILE_NAME in der MFT und mit dem USN-Journal.

## d-09 | Was „DMARC bestanden“ bedeutet
DMARC prüft, ob die sichtbare Absenderdomain durch SPF oder DKIM **ausgerichtet** bestätigt wird. Es sagt nichts über die Absicht. Eine frisch registrierte Doppelgänger-Domain besteht mühelos, ein gekapertes echtes Postfach ebenfalls.

Received-Header liest man von oben nach unten rückwärts in der Zeit. Verlässlich sind nur die Zeilen der eigenen oder vertrauten Server, alles darunter kann erfunden sein.

> [!PRAXIS] Denk weiter
> Ein Opfer hat bei einer Phishing-Seite mit MFA bestätigt. Reicht ein Passwortwechsel? Nein: Bei Adversary-in-the-Middle ist das Sitzungstoken weg. Sitzungen widerrufen, neue MFA-Methoden, Postfachregeln und App-Zustimmungen prüfen.

## d-10 | Verhalten statt Werkzeugname
Regeln auf Dateinamen und Schlüsselwörter treffen Werkzeuge, nicht Techniken. Robuster ist, was die Technik zwingend braucht: Zugriff auf LSASS, einen neuen Dienst, eine Anmeldung am Ziel. Solche Merkmale treffen aber auch legitime Software und brauchen Kontext.

Abdeckung ist dreistufig: Daten **vorhanden**, Regel **vorhanden**, Regel **nachweislich ausgelöst**. Erst die dritte Stufe darf grün sein.

> [!PRAXIS] Denk weiter
> Deine LSASS-Regel meldet täglich den Virenscanner. Ausnahme auf den Dateinamen? Nein, der ist kopierbar. Auf signierten Herausgeber, geschützten Pfad und erwartete Zugriffsrechte gemeinsam einschränken.

## d-11 | Flüchtiges zuerst
Container und Cloud-Instanzen verschwinden beim Skalieren oder Neustarten, mit ihnen das Dateisystem. Vor dem Bereinigen werden Snapshot, Metadaten und Logs gesichert. Ein gelöschtes, noch laufendes Programm lässt sich unter Linux über `/proc/<pid>/exe` sichern.

In der Cloud ist der Schlüssel oft wichtiger als die Maschine. Das Löschen eines Zugriffsschlüssels beendet daraus erzeugte temporäre Sitzungen nicht automatisch, sie müssen gesondert gesperrt werden.

> [!PRAXIS] Denk weiter
> CloudTrail zeigt keinen Abruf aus dem S3-Bucket. Entwarnung? Nein: Objektzugriffe sind Datenereignisse und werden standardmäßig nicht aufgezeichnet.

## adv-01 | Warum eine Richtlinie nicht wirkt
Die Reihenfolge Lokal, Standort, Domäne, OU erklärt nur den Normalfall. Erzwungene Links schlagen blockierte Vererbung, Sicherheits- und WMI-Filter nehmen Objekte heraus, der Loopback-Modus ersetzt oder ergänzt Benutzerrichtlinien je nach Computer. Maßgeblich ist deshalb das Ergebnis am Client (`gpresult /h`).

Eine GPO besteht aus AD-Objekt und SYSVOL-Dateien. Beide replizieren auf verschiedenen Wegen und haben eigene Rechte.

> [!PRAXIS] Denk weiter
> Du entfernst eine Härtungseinstellung aus der GPO. Ist sie am Client weg? Nicht immer: Manche Einstellungen außerhalb der Policies-Schlüssel bleiben stehen, bis sie ausdrücklich zurückgesetzt werden.

## adv-02 | Wirksame Rechte sind ein Graph
Gefährliche Rechte stehen selten direkt an einer Admin-Gruppe. Sie entstehen als Kette: Ein Helpdesk darf ein Kennwort setzen, dieses Konto verwaltet eine Gruppe, die Gruppe eine GPO. Jeder Schritt ist für sich plausibel.

AdminSDHolder überschreibt die ACLs geschützter Konten regelmäßig. Nach dem Austritt aus der geschützten Gruppe bleiben `adminCount=1` und abgeschaltete Vererbung jedoch zurück, das erklärt viele rätselhafte Altrechte.

> [!PRAXIS] Denk weiter
> Es gibt 500 riskante Pfade. Wo anfangen? An Kanten, durch die viele Pfade laufen, und rückwärts von Tier 0. Eine entfernte Berechtigung kann hunderte Pfade schließen.

## adv-03 | Die Gefahr läuft in beide Richtungen
Hybrid heißt: Das schwächere Verzeichnis kann das stärkere mitreißen. Der Synchronisationsserver und Föderationsserver gehören zu Tier 0. Cloud-Administratoren sollten reine Cloud-Konten sein, sonst genügt die Übernahme des lokalen AD für den Mandanten.

Umgekehrt können Cloud-Rollen über Geräteverwaltung Skripte auf lokalen Rechnern ausführen, auch auf Admin-Arbeitsplätzen.

> [!PRAXIS] Denk weiter
> Ein synchronisiertes Konto wird lokal deaktiviert. Ist es sofort draußen? Nein: Die Synchronisation braucht Zeit, ausgestellte Tokens leben weiter. Zusätzlich in der Cloud sperren und Sitzungen widerrufen.

## adv-04 | Audit braucht zwei Schalter
Viele DC-Ereignisse entstehen erst, wenn **Audit-Richtlinie und SACL** passen. Directory Service Changes (5136) bleibt stumm, solange am Objekt keine Überwachung eingetragen ist. 4662 ohne gezielte SACL fehlt, mit zu breiter SACL flutet es das SIEM.

Jeder DC protokolliert nur, was er selbst verarbeitet. Fehlt einer in der Sammlung, fehlt ein zufälliger Teil der Wahrheit.

> [!PRAXIS] Denk weiter
> Wie erkennst du einen verstummten DC? Mit einem Alarm auf ausbleibende Daten je DC. Eine Regel auf Ereignisinhalte kann prinzipiell nicht melden, dass keine Ereignisse kommen.

## bt-01 | Was EDR nicht sieht
EDR sieht, was sein Sensor beobachtet. Geräte ohne Agent (Drucker, Firewalls, Hypervisoren, Appliances) sind blinde Flecken und deshalb beliebte Rückzugsorte. Auch Ausnahmen für Pfade oder Prozesse sind Lücken mit Genehmigung.

„Blockiert“ beendet die Untersuchung nicht. Ein gestoppter Credential-Zugriff beweist, dass jemand bereits mit passenden Rechten auf dem System war.

> [!PRAXIS] Denk weiter
> Die Konsole zeigt 100 % gesunde Agenten. Vollständige Abdeckung? Nur für bekannte Agenten. Der Abgleich mit DHCP, AD und Asset-Inventar findet die Geräte, die in der Konsole nie auftauchen.

## bt-02 | Ereigniszeit und Ankunftszeit
Jedes Log hat mindestens zwei Zeiten: Entstehung und Aufnahme ins SIEM. Eine Regel, die alle fünf Minuten die letzten fünf Minuten der Ereigniszeit prüft, verpasst alles, was später ankommt. Abhilfe schaffen Überlappung mit Deduplizierung oder Suchen nach Aufnahmezeit.

Filtern spart Geld, vernichtet aber unbekannte künftige Beweise. Ein Rohdatenarchiv mit billigem Speicher ist der übliche Kompromiss.

> [!PRAXIS] Denk weiter
> 90 Tage Aufbewahrung, Einbruch vor 120 Tagen: Was bleibt? Host-Artefakte, Backups, Anbieter-Logs. Deshalb richtet sich die Frist für Identitäts- und Perimeterlogs nach realistischen Verweildauern.

## bt-03 | Automatisierung als Angriffsfläche
Ein Playbook handelt mit hohen Rechten auf Eingaben, die Angreifer beeinflussen. Wer automatisches Sperren auslösen kann, kann damit den Geschäftsführer oder das DNS aussperren. Deshalb gibt es Schutzlisten, Obergrenzen pro Stunde und Freigaben für Unumkehrbares.

Aktionen sollten **idempotent** sein: Zweimal ausgeführt ergibt dasselbe Ergebnis. Sonst machen Wiederholungen nach Zeitüberschreitungen Schaden.

> [!PRAXIS] Denk weiter
> Was automatisierst du zuerst? Anreicherung, denn sie ist häufig und risikoarm. Danach umkehrbare Aktionen mit hoher Treffsicherheit, jeweils erst eine Zeit lang im Vorschlagsmodus.

## bt-04 | Verschlüsselung ist das Ende
Die Verschlüsselung ist meist der letzte Schritt nach Zugang, Rechteausweitung, Datenabfluss und Angriff auf die Backups. Wiederherstellen ohne Klärung des Einstiegs baut das Opfer für die zweite Runde auf.

Die Dauer der Rückkehr bestimmt oft die Datenrate: 50 TB über effektiv 500 MB/s brauchen rund 28 Stunden, noch ohne Prüfung, Neuinstallation und Anwendungsstart.

> [!PRAXIS] Denk weiter
> Ein Entschlüsselungswerkzeug liegt vor. Reicht das? Nein: Es kann langsam oder fehlerhaft sein, entfernt keine Hintertür und ändert nichts an abgeflossenen Daten. Arbeite auf Kopien.

## bt-05 | Verhalten bewerten, nicht Menschen
Auffälligkeit ist kein Motiv. Große Downloads kommen von Projektwechseln, Backups und Diebstahl gleichermaßen, und ein gekapertes Konto sieht wie ein Innentäter aus. Hypothesen werden in beide Richtungen geprüft, bevor eine Person beschuldigt wird.

Überwachung von Beschäftigten braucht Zweckbindung, Verhältnismäßigkeit und in Deutschland meist die Mitbestimmung des Betriebsrats.

> [!PRAXIS] Denk weiter
> Eine Person hat gekündigt und lädt viel herunter. Erster Schritt? Nicht konfrontieren: Daten sichern, legitimen Grund über einen festgelegten kleinen Kreis aus HR, Recht und Datenschutz klären.

## bt-06 | Glaubwürdigkeit gegen Risiko
Ein Köder wirkt nur, wenn er zur Umgebung passt: Namensschema, Alter, letzte Änderungen, plausible Rechte. Je echter und interaktiver er ist, desto größer das Risiko, dass er selbst zum Sprungbrett wird.

Die Stärke von Deception ist die niedrige Basisrate legitimer Nutzung. Sie geht verloren, wenn Inventar-Scanner, Backup und Suche den Köder anfassen.

> [!PRAXIS] Denk weiter
> Warum muss ein Honeytoken nie einen echten Zugriff erlauben? Sein Zweck ist die Meldung der Benutzung. Ein Schlüssel ohne Rechte alarmiert genauso, ohne Schaden zu ermöglichen.

## bt-07 | Wahrscheinlichkeit sauber ausdrücken
Gute Intelligence trennt **Wahrscheinlichkeit** der Aussage und **Vertrauen** in die Grundlage. „Wahrscheinlich, bei geringem Vertrauen“ ist sinnvoll: Es spricht mehr dafür als dagegen, aber die Belege sind dünn.

Vier Berichte sind nicht vier Quellen, wenn alle denselben Ursprungsbericht zitieren. Dieser Zirkelbezug lässt schwache Aussagen stark aussehen.

> [!PRAXIS] Denk weiter
> Ein Feed enthält die IP eines großen CDN. Blockieren? Nein: Hinter ihr liegen tausende legitime Dienste. Relevant sind Domain, URL, Zeitraum der Nutzung und ein Ablaufdatum des Indikators.

## bt-08 | Eine Technik, viele Prozeduren
Eine ATT&CK-Technik ist eine Sammelkategorie. Wer eine von zehn Ausführungsarten erkennt, hat die Technik nicht abgedeckt. Aussagekräftig ist die Liste getesteter Prozeduren mit Ergebnis: verhindert, alarmiert, nur protokolliert, unsichtbar.

Die Wiederholung macht den Wert aus. Regeln zerfallen durch Updates, Parseränderungen und neue Ausnahmen.

> [!PRAXIS] Denk weiter
> Der Test löst keinen Alarm aus. Wer ist schuld? Niemand, bevor die Kette geprüft ist: Ausgeführt? Ereignis erzeugt? Transportiert? Geparst? Regel getroffen? Alarm zugestellt? Genau eine Stelle ist der Befund.
