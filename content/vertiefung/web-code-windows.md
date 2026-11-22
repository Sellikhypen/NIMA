# Tiefer eingetaucht – OT, Web, Code, Windows

## ot-01 | Sicher nur, wenn eingeschaltet
Für viele Protokolle gibt es abgesicherte Varianten: OPC UA mit SignAndEncrypt, DNP3 Secure Authentication, Modbus/TCP Security, S7 in neueren Versionen. Entscheidend ist, ob Geräte sie können und ob `None` als Rückfall abgeschaltet ist. Verschlüsselung nimmt dem passiven Monitoring zugleich Sicht.

> [!PRAXIS] Denk weiter
> Port 502 nur von der Leitwarte. Genug? Die Leitwarte darf dann alles schreiben. Funktionscodes und Register begrenzen.

## ot-02 | Stabil heißt nicht gesund
OT-Verkehr ist regelmäßig, Baselines funktionieren daher gut, lernen aber auch eine vorhandene Kompromittierung mit. Seltene legitime Zustände wie Anfahren und Wartung fehlen in kurzen Lernphasen. Ein Sensor am Kernswitch sieht Verkehr innerhalb der Zelle nicht.

> [!PRAXIS] Denk weiter
> Programm-Download nachts. Alarm? Ja, bis ein Wartungsauftrag, Engineering-Station und Person dazu passen.

## ot-03 | Trennen kann schaden
Vor dem Vorfall muss feststehen, welche Verbindungen gefahrlos trennbar sind und wie lange Inselbetrieb trägt. Wiederanlauf braucht verifizierte Projektdateien und Firmware, ein Vergleich des Programms in der SPS mit dem Master und die Freigabe des Betriebs.

> [!PRAXIS] Denk weiter
> Ransomware nur in der IT. OT abschalten? Nicht reflexhaft: Übergänge trennen, Abhängigkeiten wie MES prüfen, Safety entscheidet mit.

## ow-01 | Das richtige Objekt prüfen
Viele Anwendungen prüfen Rolle, aber nicht Beziehung: Darf diese Person **dieses** Objekt in **diesem** Zustand bearbeiten? Am robustesten steckt die Bedingung in der Abfrage (`WHERE id=? AND tenant=?`). Nebenwege wie Export, Suche und Batch werden oft vergessen.

> [!PRAXIS] Denk weiter
> UUIDs statt Zahlen: IDOR behoben? Nein, nur schwerer zu raten. IDs tauchen in Links und Antworten auf.

## ow-02 | Gegen welchen Angreifer?
Verschlüsselung at rest schützt gegen Diebstahl von Platten, nicht gegen SQL-Injection, denn die Datenbank entschlüsselt für die Anwendung. Feldverschlüsselung hilft nur, wenn der Schlüssel außerhalb des kompromittierten Teils liegt.

> [!PRAXIS] Denk weiter
> Passwörter mit AES verschlüsselt. Befund? Ja, umkehrbar. Argon2id, scrypt oder bcrypt verwenden.

## ow-03 | Was Platzhalter nicht können
Parameter binden Werte, keine Tabellen, Spalten oder Sortierrichtungen. Dafür braucht es Allowlists. ORMs haben Roh-Schnittstellen, gespeicherte Prozeduren können selbst SQL zusammensetzen, NoSQL nimmt Operatoren aus JSON an.

> [!PRAXIS] Denk weiter
> Sortierfeld aus der URL: sicher wie? Eingabe auf feste Spaltennamen abbilden, Unbekanntes ablehnen.

## ow-04 | Design mit Gegnern testen
Schreibe zu jeder User Story eine Abuse Story samt Invariante: „Ein Gutschein senkt den Gesamtpreis je Bestellung höchstens einmal.“ Invarianten lassen sich testen, „sicher gestalten“ nicht. Scanner finden solche Fehler kaum.

> [!PRAXIS] Denk weiter
> Kennwort-Reset per SMS, korrekt programmiert. Trotzdem A04? Ja, wenn das Risiko SIM-Swap für den Schutzbedarf zu hoch ist.

## ow-05 | Die Summe der Schichten
Fehlkonfiguration entsteht zwischen Schichten: Proxy blockt /admin, die App ist zusätzlich direkt erreichbar. Maßgeblich ist das Außenverhalten, nicht die Datei. Reproduzierbare Umgebungen und automatische Prüfungen von außen halten es stabil.

> [!PRAXIS] Denk weiter
> Security-Header doppelt mit anderem Wert. Was gilt? Je Header verschieden, teils wird er ungültig. An genau einer Stelle setzen.

## ow-06 | Vorhanden oder erreichbar?
Eine CVE in einer Abhängigkeit ist erst ausnutzbar, wenn der betroffene Code erreichbar und konfiguriert ist. VEX drückt das maschinenlesbar aus. Umgekehrt übersehen Scanner kopierten Code, statisch gelinkte Bibliotheken und Ende des Supports ohne CVE.

> [!PRAXIS] Denk weiter
> Transitive Lücke ohne Update der Hauptbibliothek. Optionen? Version überschreiben und testen, Funktion abschalten, ersetzen oder befristet begründen.

## ow-07 | Die schwächste Tür
Die Stärke eines Kontos entspricht dem schwächsten Anmelde- **oder Wiederherstellungsweg**. Passkeys binden an die Domain und widerstehen Phishing, ein SMS-Reset daneben hebt das auf. Auch Timing und Fehlermeldungen verraten Konten.

> [!PRAXIS] Denk weiter
> Passwortwechsel alle 90 Tage? NIST und BSI raten ohne Anlass davon ab. Bei Verdacht wechseln, kompromittierte Passwörter sperren.

## ow-08 | Herkunft statt nur Hash
Ein Hash von derselben Seite wie der Download belegt nur Unversehrtheit. Signaturen belegen einen Schlüsselinhaber, Provenance (SLSA) den Build aus einer bestimmten Quelle. Keins belegt gutartigen Code.

> [!PRAXIS] Denk weiter
> CI-Action auf @v3 festgelegt. Stabil? Nein, Tags lassen sich verschieben. Auf vollständigen Commit-Hash pinnen.

## ow-09 | Logs sind ebenfalls ein Ziel
Logeinträge enthalten fremde Eingaben. Zeilenumbrüche fälschen Einträge, HTML trifft die Admin-Oberfläche. Strukturiert schreiben, kodiert anzeigen, Geheimnisse maskieren, Korrelations-ID über alle Dienste führen.

> [!PRAXIS] Denk weiter
> Alle 403 werden geloggt. Fehlt etwas? Die erfolgreichen kritischen Aktionen. Ein gelungener Angriff bekommt 200.

## ow-10 | Prüfen und Verbinden
SSRF-Filter scheitern am Abstand zwischen Prüfung und Verbindung: DNS kann danach anders antworten, Redirects führen weiter. Robust ist, aufzulösen, die IP zu prüfen, genau zu ihr zu verbinden, Redirects erneut zu prüfen und das Netz zusätzlich zu sperren.

> [!PRAXIS] Denk weiter
> Antwort wird nicht angezeigt. Harmlos? Nein, blindes SSRF kann Aktionen auslösen und über Timing informieren.

## py-01 | Fallen der Sprache
Veränderliche Standardargumente (`def f(x=[])`) werden zwischen Aufrufen geteilt. `assert` verschwindet mit `-O` und taugt nicht als Prüfung. Für Geheimnisse `secrets` statt `random`, für Vergleiche `hmac.compare_digest`. pickle fremder Daten führt Code aus.

> [!PRAXIS] Denk weiter
> Warum `is` nicht für Zahlenvergleiche? Es vergleicht Identität. Kleine Werte sind zufällig zwischengespeichert, große nicht zuverlässig.

## py-02 | Große Logs ehrlich auswerten
Iteriere zeilenweise statt `read()`, zähle verworfene Zeilen und gib sie aus. Rechne in UTC mit Zeitzone: Bei der Umstellung auf Winterzeit existiert 02:30 lokal zweimal. Schreibe Ergebnisse für Excel so, dass `=`, `+`, `-`, `@` am Anfang nicht zu Formeln werden.

> [!PRAXIS] Denk weiter
> Skript findet 40 IPs. Vertrauen? Mit Testdatei bekannter Lösung und der Zahl nicht geparster Zeilen.

## py-03 | Fehler im Netz
requests wartet ohne timeout unbegrenzt. Der Timeout gilt je Socket-Operation, nicht insgesamt. Wiederholen nur Idempotentes, mit Backoff und Beachtung von Retry-After. `recv` liefert Teile, nicht Nachrichten.

> [!PRAXIS] Denk weiter
> POST läuft in Timeout. Wiederholen? Es kann schon gewirkt haben. Status abfragen oder Idempotency-Key nutzen.

## py-04 | Regex hat Grenzen
Backtracking-Engines erkennen mit Rückverweisen mehr, können aber exponentiell laufen. RE2 garantiert lineare Zeit und verzichtet darauf. In Python matcht `$` auch vor einem Schlusszeilenumbruch, für Validierung `fullmatch`. `\d` umfasst Unicode-Ziffern.

> [!PRAXIS] Denk weiter
> Sollte Regex HTML prüfen? Nein, verschachtelte Sprachen brauchen einen Parser.

## py-05 | Parser sind uneinig
Doppelte JSON-Schlüssel, große Zahlen über 2⁵³ und YAML-1.1-Werte wie `no` werden je Parser verschieden gelesen. Prüft Komponente A und nutzt B, entsteht eine Lücke. YAML mit safe_load, XML ohne externe Entitäten.

> [!PRAXIS] Denk weiter
> Warum Schema nach dem Parsen? Gültige Syntax sagt nichts über Typen, erlaubte Felder, Längen und Grenzen.

## wd-01 | Vererbung der Konfiguration
In Nginx ersetzt ein `add_header` in location üblicherweise alle geerbten, außerdem gewinnen Regex-Locations gegen manche Präfixe. `alias` ohne passenden Schrägstrich kann aus dem Verzeichnis führen. Nach Änderungen jeden Pfadtyp und Fehlerseiten abfragen.

> [!PRAXIS] Denk weiter
> server_tokens off: sicher? Nur weniger Information. Updates und Rechte tun die Arbeit.

## wd-02 | Das Ende einer Sitzung
Cookie löschen beendet die Sitzung nur im Browser. Serverseitig invalidieren, bei Rechtewechsel die ID erneuern. Das Präfix `__Host-` erzwingt Secure, Path=/ und kein Domain-Attribut. SameSite meint Site, nicht Origin: Subdomains zählen als gleich.

> [!PRAXIS] Denk weiter
> HttpOnly gesetzt, XSS harmlos? Nein, das Skript handelt in der Sitzung, ohne das Cookie zu lesen.

## wd-03 | CORS ist keine Firewall
CORS regelt, ob fremde Skripte Antworten **lesen**. Einfache Anfragen werden trotzdem gesendet, daher schützt es nicht vor CSRF, und curl ignoriert es. Bei reflektiertem Origin gehört `Vary: Origin` dazu.

> [!PRAXIS] Denk weiter
> `*` auf einer öffentlichen, cookielosen API: Befund? Meist nein. Kritisch wird es bei Daten, deren Schutz nur an der Netzposition hängt.

## wd-04 | Die zweite Meinung
WAF und Anwendung parsen getrennt, Unterschiede bei Kodierung, Größe oder Multipart sind Umgehungen. Größenlimits müssen bewusst blocken oder weiterleiten. Ausnahmen immer auf Regel, Pfad und Parameter begrenzen.

> [!PRAXIS] Denk weiter
> Virtueller Patch aktiv. Ticket schließen? Nein, er überbrückt bis zum Fix.

## wd-05 | Von 200 zur Wirkung
Das Access-Log zeigt Anfrage und Status, selten Body und nie die fachliche Wirkung. Anfrage-ID verbindet es mit App- und Datenbanklogs. Kampagnen verteilen sich über IPs, gruppiere deshalb auch nach Konto, Objekt und Muster.

> [!PRAXIS] Denk weiter
> Client-IP ist immer der Proxy. X-Forwarded-For nehmen? Nur den Teil, den eigene Proxys anfügten.

## wd-06 | Zurückrollen können
Deployments sind unveränderliche Artefakte, identisch über alle Stufen, nur Konfiguration wechselt. Datenbankmigrationen machen Rollback schwer: erst erweitern, umstellen, später entfernen. Staging ohne echte Daten und Schlüssel.

> [!PRAXIS] Denk weiter
> Webshell gefunden und gelöscht. Fertig? Nein: sichern, Einstieg klären, neu deployen, Geheimnisse rotieren.

## wp-01 | cmd denkt zweimal
`%VAR%` wird beim Lesen der Zeile ersetzt, darum braucht es in Blöcken verzögerte Expansion (`!VAR!`). Programme zerlegen ihre Argumente selbst. Ausgaben sind lokalisiert: Nach deutschen Gruppennamen zu filtern bricht, SIDs sind stabil (Administratoren: S-1-5-32-544).

> [!PRAXIS] Denk weiter
> `whoami /groups` zeigt Administratoren „nur verweigern“. Bedeutung? UAC-gefiltertes Token, nicht erhöht.

## wp-02 | Objekte bis zum Schluss
`Format-Table` erzeugt Anzeigeobjekte, danach nicht mehr exportieren. Viele Fehler sind nicht terminierend, `catch` greift erst mit `-ErrorAction Stop`. `$null` gehört beim Vergleich nach links. ExecutionPolicy ist keine Sicherheitsgrenze.

> [!PRAXIS] Denk weiter
> Export-Csv enthält `System.Object[]`. Warum? Array-Feld, vorher mit `-join` auflösen.

## wp-03 | Abfragen richtig lesen
Filtere serverseitig mit `-Filter`. `lastLogonTimestamp` repliziert absichtlich bis zu 14 Tage verzögert, `lastLogon` gar nicht. Gruppenabfragen müssen Verschachtelung und die Primärgruppe beachten.

> [!PRAXIS] Denk weiter
> Inaktive nach 30 Tagen deaktivieren? Mit 14 Tagen Ungenauigkeit knapp: alle DCs abfragen oder Schwelle erhöhen, Dienstkonten ausnehmen.

## wp-04 | Mehrere Ansichten
32-Bit-Prozesse sehen Registry und System32 umgeleitet. HKCU gehört dem ausführenden Konto, als SYSTEM findest du Benutzer-Persistenz unter HKU oder in den Hives. Get-WinEvent mit FilterHashtable filtert an der Quelle.

> [!PRAXIS] Denk weiter
> Dienstpfad mit Leerzeichen ohne Anführungszeichen: immer ausnutzbar? Nur mit Schreibrecht an einer Zwischenstelle und Auslösemöglichkeit.

## wp-05 | Der zweite Sprung
Remoting meldet per Netzwerkanmeldung an, ohne wiederverwendbare Daten am Ziel. Darum scheitert der Zugriff von dort weiter. CredSSP löst das, indem es Anmeldedaten übergibt, besser sind eingeschränkte ressourcenbasierte Delegation oder direkter Zugriff.

> [!PRAXIS] Denk weiter
> TrustedHosts auf `*`: Folge? NTLM zu beliebigen Zielen ohne Serveridentität. Kerberos oder HTTPS nutzen.

## wp-06 | Grenzen benennen
Credential Guard schützt abgeleitete Domänengeheimnisse im LSASS, nicht Tippen, lokale Konten oder Sitzungsmissbrauch. BitLocker schützt ausgeschaltete Geräte. App Control ist nur so gut wie seine Regeln. UAC ist keine vollwertige Sicherheitsgrenze.

> [!PRAXIS] Denk weiter
> Einstellung konfiguriert = aktiv? Nein. VBS etwa meldet konfigurierte und laufende Dienste getrennt.
