# Tiefer eingetaucht – Grundlagen und Pentest-Kern

## f-01 | Eine Zahl, viele Bedeutungen
Bytes haben keine eingebaute Bedeutung. `0xFF` ist 255 ohne Vorzeichen und −1 mit Vorzeichen. `78 56 34 12` ergibt in Little Endian 0x12345678. In UTF-8 belegt ein Zeichen 1 bis 4 Bytes, darum sind Zeichen- und Bytelänge verschieden. Viele Sicherheitslücken entstehen, wenn Prüfer und Verarbeiter dieselben Bytes verschieden deuten.

> [!PRAXIS] Denk weiter
> Ein 8-Bit-Zähler steht auf 250, du addierst 10. Ergebnis? 4, denn 260 mod 256 = 4. Eine Längenprüfung nach dieser Addition wäre wirkungslos.

## f-02 | Das Modell hat Risse
Reale Protokolle halten sich nicht an Schichten. TLS liegt zwischen Transport und Anwendung, QUIC baut Transport und Verschlüsselung auf UDP, VXLAN packt Schicht 2 in Schicht 4. Für die Fehlersuche zählt: Welcher Header ist außen, welcher innen, und welches Gerät liest welchen?

> [!PRAXIS] Denk weiter
> Eine Firewall erlaubt UDP 4789 zwischen zwei Hosts. Was erlaubt sie wirklich? Beliebige Ethernet-Netze im VXLAN-Tunnel, deren Inhalt sie ohne Entkapselung nicht sieht.

## f-03 | Die Maske entscheidet lokal
Jeder Host entscheidet mit **seiner** Maske, ob ein Ziel lokal ist. Bei mehreren passenden Routen gewinnt das längste Präfix, unabhängig von der Reihenfolge. In /31 sind beide Adressen auf Punkt-zu-Punkt-Strecken nutzbar, die Minus-2-Regel gilt dort nicht.

> [!PRAXIS] Denk weiter
> A ist 10.0.0.10/24, B ist 10.0.0.200/25. Geht Kommunikation? A fragt per ARP direkt. B hält A (Bereich 0–127) für fremd und schickt zum Gateway. Es hängt also vom Router ab.

## f-04 | Durchsatz hängt an der Laufzeit
TCP darf nur ein Fenster unbestätigter Daten unterwegs haben: Durchsatz ≤ Fenster/RTT. 64 KiB bei 100 ms ergeben nur rund 5 Mbit/s, deshalb gibt es Window Scaling. TCP liefert einen Bytestrom, keine Nachrichten. Anwendungen müssen Grenzen selbst markieren.

> [!PRAXIS] Denk weiter
> Ein Scan meldet UDP „open|filtered“. Warum so unklar? Schweigen kann offener Dienst, Filter oder Paketverlust sein. Eindeutig sind nur eine Antwort oder ICMP Port Unreachable.

## f-05 | Caches bestimmen die Wahrheit
Zwischen Änderung und Wirkung stehen Caches in Browser, Betriebssystem, Resolver und CDN. Eine TTL begrenzt DNS-Caching, auch das Nichtvorhandensein wird zwischengespeichert. Vor einem Umzug senkt man die TTL mindestens eine alte TTL-Dauer vorher.

> [!PRAXIS] Denk weiter
> `dig` zeigt die neue IP, der Browser nutzt die alte. Warum? dig fragt DNS direkt. Der Browser hat eigene Caches, nutzt eventuell DoH oder eine bestehende Verbindung, das System außerdem die hosts-Datei.

## f-06 | Rechte hängen am Pfad und am Prozess
Zum Öffnen braucht es `x` auf jedem Verzeichnis des Pfads. Löschen hängt am Verzeichnis, nicht an der Datei. Offene Dateien bleiben nach dem Löschen benutzbar, bis der letzte Deskriptor schließt. Root ist zudem teilbar: Capabilities vergeben Teilrechte, SELinux und AppArmor können auch Root begrenzen.

> [!PRAXIS] Denk weiter
> `df` meldet voll, `du` findet wenig. Ursache? Oft gelöschte, noch offene Logs. `lsof +L1` zeigt sie, ein Neustart des Dienstes gibt den Platz frei.

## f-07 | Das Token entscheidet
Beim Zugriff vergleicht Windows das Access Token mit der ACL. Das Token entsteht bei der Anmeldung, neue Gruppen wirken daher erst nach neuer Anmeldung. Unter UAC besitzt ein Admin ein gefiltertes und ein erhöhtes Token. Geprüft wird auch die Integritätsstufe.

> [!PRAXIS] Denk weiter
> Über die Freigabe nur lesen, lokal ändern. Warum? Über das Netz gilt das Restriktivere aus Freigabe- und NTFS-Recht, lokal nur NTFS.

## f-08 | Verfahren richtig zusammensetzen
Sichere Bausteine ergeben nicht automatisch ein sicheres System. Verschlüsselung ohne Authentizität erlaubt Manipulation, Signatur ohne geprüfte Identität beweist nur den Besitz irgendeines Schlüssels, Forward Secrecy braucht flüchtige Schlüssel. Deshalb nutzt man fertige Protokolle.

> [!PRAXIS] Denk weiter
> Nachricht und SHA-256 kommen gemeinsam an. Integrität gesichert? Nur gegen Zufall. Ein Angreifer ersetzt beides. Nötig sind MAC, Signatur oder ein getrennt vertrauenswürdig übertragener Hash.

## f-09 | Wo Vertrauen wechselt
Eine Anfrage durchläuft CDN, Proxy, Framework, Cache und Datenbank. Jede Stufe liest sie selbst. Lücken entstehen an den Übergängen: Die eine prüft `/admin`, die nächste normalisiert `/Admin/../admin`. Prüfungen gehören dorthin, wo die endgültige Bedeutung feststeht.

> [!PRAXIS] Denk weiter
> Der Admin-Knopf ist ausgeblendet. Schutz? Nein. Alles im Browser ist Vorschlag, der Server entscheidet bei jeder Anfrage über Objekt und Aktion.

## f-10 | Daten dürfen nie Code werden
Sichere Skripte übergeben Argumente als Liste, zitieren Variablen und trennen Optionen mit `--`. In Python also `subprocess.run([...], check=True)` ohne `shell=True`. Zweite Regel: wiederholbar schreiben, also prüfen, temporär schreiben, atomar umbenennen.

> [!PRAXIS] Denk weiter
> Was löscht `rm -rf "$DIR/"*` bei leerem DIR? Den Inhalt von `/`. `${DIR:?}` bricht stattdessen mit Fehler ab.

## f-11 | Container sind Prozesse
Namespaces begrenzen, was ein Prozess sieht, cgroups, was er verbraucht, Capabilities und seccomp, was er darf. Alle teilen einen Kernel. Der Docker-Socket oder `--privileged` heben die Grenze praktisch auf.

> [!PRAXIS] Denk weiter
> Du löschst ein Geheimnis in einer späteren Image-Schicht. Ist es weg? Nein, die frühere Schicht enthält es. Wechseln und per Secret-Mount bauen.

## f-12 | Kein einzelner Chef
Jeder beschreibbare DC nimmt Änderungen an und repliziert sie, Konflikte werden pro Attribut anhand von Version, Zeit und Quelle gelöst. Nur fünf FSMO-Rollen sind je einmalig vergeben. Clients finden DCs über DNS-SRV-Einträge und ihren Standort, deshalb sind AD-Probleme oft DNS-Probleme.

> [!PRAXIS] Denk weiter
> Passwort geändert, Anmeldung am anderen Standort klappt sofort. Wieso vor der Replikation? Der DC fragt bei Fehlschlag den PDC-Emulator, der Änderungen bevorzugt erhält.

## f-13 | Ein Tunnel verschiebt Vertrauen
Ein VPN verbirgt Verkehr vor dem lokalen Netz und zeigt ihn dem Betreiber des Endpunkts. Es prüft nicht, ob das Gerät sauber ist. Bei WireGuard wirken AllowedIPs zugleich als Route und als Filter für erlaubte Quelladressen des Peers.

> [!PRAXIS] Denk weiter
> VPN an, DNS-Anfragen sieht trotzdem das Hotel. Warum? Split Tunneling, lokaler Resolver oder IPv6 außerhalb des Tunnels.

## f-14 | Gleichzeitigkeit und NULL
SQL rechnet dreiwertig: `NULL = NULL` ist unbekannt, es braucht `IS NULL`. `NOT IN` mit einem NULL in der Liste liefert keine Zeile. Transaktionen schützen nicht automatisch vor Races, entscheidend sind Isolationsstufe, Constraints und atomare Anweisungen.

> [!PRAXIS] Denk weiter
> Wie verhinderst du negatives Guthaben bei parallelen Abbuchungen? `UPDATE … SET saldo=saldo-50 WHERE id=? AND saldo>=50` und die Zahl geänderter Zeilen prüfen.

## f-15 | Zwei Absender
SMTP kennt den Umschlag (MAIL FROM) und den sichtbaren From-Header. SPF prüft den Umschlag und bricht bei Weiterleitung, DKIM signiert Inhalt und bricht bei Veränderung. DMARC braucht eines von beiden, ausgerichtet am sichtbaren Absender. SPF erlaubt zudem höchstens zehn DNS-auslösende Mechanismen.

> [!PRAXIS] Denk weiter
> Sofort `p=reject` setzen? Erst Berichte mit `p=none` auswerten, legitime Versender ausrichten, dann verschärfen.

## f-16 | Was Git wirklich speichert
Git speichert Schnappschüsse als über Hashes verkettete Objekte. Autor und E-Mail sind frei setzbar, erst Signaturen belegen Herkunft. Ein gelöschtes Geheimnis bleibt in Historie, Klonen und Forks.

> [!PRAXIS] Denk weiter
> Schlüssel öffentlich gepusht. Erster Schritt? Widerrufen und Nutzung prüfen. Die Historie umschreiben kommt danach und holt nichts zurück.

## c-01 | Was ein Test nicht beweist
Ein Pentest ist eine Stichprobe unter Grenzen von Zeit, Scope und Zugang. „Keine kritischen Funde“ heißt: unter diesen Bedingungen keine gefunden. Gute Tester führen Abdeckung und Ausgelassenes mit und erteilen sich keine Freigaben selbst.

> [!PRAXIS] Denk weiter
> Du findest einen Weg zu einem System eines Dienstleisters. Weiter? Nein. Anhalten, dokumentieren, schriftliche Freigabe auch des Eigentümers einholen.

## c-02 | Zustände sind Deutungen
Ein Scanner sieht nur Antworten. „closed“ heißt meist RST, das kann auch eine Firewall senden. „filtered“ heißt keine verwertbare Antwort. Versionsangaben stammen aus Bannern und Mustern. Rückportierte Patches ändern die Versionsnummer oft nicht.

> [!PRAXIS] Denk weiter
> Alle Ports eines Hosts erscheinen offen. Erklärung? Ein Proxy oder Schutzgerät nimmt jeden Handshake an. Vergleiche Anwendungsantworten und einen zweiten Standort.

## c-03 | Beziehungen statt Dienstliste
Tiefe entsteht durch Verknüpfen: Ein Zertifikat nennt Hostnamen, der Hostname ein Namensschema, SMB die Domäne, NTP die Rolle. Halte je Fund Quelle, Sicherheit und daraus folgende Frage fest. Leere Antworten sind abhängig vom verwendeten Konto.

> [!PRAXIS] Denk weiter
> Anonym ist keine Freigabe sichtbar. SMB erledigt? Nein, mit jeder erlaubten neuen Identität wiederholt sich die Enumeration.

## c-04 | Baselines gegen Täuschung
Entdeckung braucht einen Vergleichswert. Manche Server beantworten jede Subdomain (Wildcard) oder jeden Pfad mit 200. Erst die Antwort auf einen sicher nicht existierenden Namen zeigt, welche Größe, welcher Titel und Code „nicht vorhanden“ bedeuten.

> [!PRAXIS] Denk weiter
> Der Proxy zeigt weniger als die App kann. Warum? WebSockets, Service Worker, mobile Endpunkte und Rollenfunktionen. Nutze jede Rolle und lies die Skripte.

## c-05 | Eine Wurzel, zwei Familien
Die meisten Klassen lassen sich auf zwei Fragen zurückführen: **Wird Eingabe als Struktur gedeutet?** (Injection, XSS, SSTI, XXE) und **Darf dieser Aufrufer das?** (IDOR, CSRF, teils SSRF). Die erste löst man mit Trennung von Daten und Code, die zweite mit Prüfung am Objekt. Filterlisten lösen keine von beiden.

> [!PRAXIS] Denk weiter
> Eine Eingabe wird harmlos gespeichert und später in einem Admin-Bericht ausgewertet. Wo ist die Lücke? Bei der späteren Verwendung. Das heißt Injection zweiter Ordnung.

## c-06 | Rechnen statt raten
Der Aufwand ist Suchraum geteilt durch Rate. Acht zufällige Kleinbuchstaben sind 2,1·10¹¹ Möglichkeiten: bei 10¹⁰ schnellen Hashes pro Sekunde rund 21 Sekunden, bei 10⁴ langsamen rund acht Monate. Menschliche Muster verkleinern den Raum drastisch, ein Salt verhindert nur gemeinsames Rechnen.

> [!PRAXIS] Denk weiter
> Warum hilft ein langsamer Hash nicht gegen Password Spraying? Es sind wenige Online-Versuche gegen viele Konten. Dagegen helfen Sperrlisten, MFA und Erkennung über Konten hinweg.

## c-07 | Das gemeinsame Muster
Fast jede Rechteausweitung lautet: Ein stärker berechtigter Prozess benutzt etwas, das ein schwächerer kontrolliert, etwa Datei, Pfad, Umgebungsvariable, Token oder Kommandoargument. Prüfe also jede Vertrauenskante, nicht nur Listen bekannter Tricks.

> [!PRAXIS] Denk weiter
> Ein Root-Cronjob ruft ein Root-eigenes Skript auf. Sicher? Nur, wenn auch Elternverzeichnisse, eingebundene Dateien, aufgerufene Programme und deren Konfiguration nicht beschreibbar sind.

## c-08 | Design von Fehler trennen
Vieles Riskante ist normales Protokollverhalten: Jeder Nutzer darf Service-Tickets anfordern und viel lesen. Das lässt sich nicht patchen, nur entwerten: lange gMSA-Passwörter, AES, Signierung, Channel Binding, Tiering. Priorisiere, was Pfade zu Tier 0 schließt.

> [!PRAXIS] Denk weiter
> NTLM sofort abschalten? Erst Nutzung protokollieren. IP-Zugriffe, Altgeräte und fehlende SPNs fallen darauf zurück und würden ausfallen.

## c-09 | Wer sieht welche Quelle?
Hinter einem Pivot erscheint Verkehr mit der Adresse des Zwischenhosts. Ein TCP-Proxy überträgt weder ICMP noch rohe Pakete, Ergebnisse sehen dadurch anders aus. Verteidiger finden Pivots an Hosts, die plötzlich zugleich Server und Client sind und neue Segmentpaare verbinden.

> [!PRAXIS] Denk weiter
> Datenbank nur vom Webserver erreichbar. Segmentiert? Gegen Direktzugriff ja. Bei übernommenem Webserver zählen dann Rechte des DB-Kontos, Protokollierung und Ausgangsregeln.

## c-10 | Schwere ist nicht Risiko
CVSS Base beschreibt die technische Schwere, nicht die Folgen für diesen Kunden. Ketten machen aus zwei mittleren Befunden einen kritischen Pfad. Gute Berichte zeigen Basiswert, begründete Priorität, Beleg, Ursache und einen Nachtest, mit geschwärzten Geheimnissen.

> [!PRAXIS] Denk weiter
> 80 Server haben denselben Fehler. 80 Befunde? Einer mit betroffener Liste und systemischer Ursache, etwa einem fehlerhaften Grundabbild.

## c-11 | Kontext einer Shell
Eine Shell besteht aus Prozess, Identität, Umgebung und Ein-/Ausgabe. Ohne TTY scheitern Passwortabfragen und Jobkontrolle, ein Dienstkonto hat anderen PATH und andere Rechte. Viele „kaputte Werkzeuge“ sind ein anderer Kontext.

> [!PRAXIS] Denk weiter
> Was gehört bei jeder übertragenen Testdatei ins Protokoll? Host, Pfad, Hash, Zeit und die bestätigte Entfernung. So trennt das Blue Team dich vom echten Angreifer.

## c-12 | Kompetenz schlägt Abschluss
Modulprozente messen Kontakt mit Stoff. Prüfungsreif bist du, wenn du fremde Ziele ohne Anleitung enumerierst, Sackgassen nach Zeit abbrichst und den Bericht rechtzeitig schreibst. Umfang und Regeln der Zertifikate ändern sich, maßgeblich ist die aktuelle Anbieterseite.

> [!PRAXIS] Denk weiter
> Wie testest du deine Reife ehrlich? Ein unbekanntes Lab unter Prüfungszeit, ohne Lösungen, mit vollständigem Bericht. Danach die Ursachen der Hänger zählen.

## c-13 | Fehlalarme und Übersehenes
Authentifizierte Scans lesen Paketstände und sind meist genauer, finden aber keine Logikfehler. Ein fehlgeschlagener Login kann unbemerkt einen scheinbar sauberen Bericht ergeben. Prüfe deshalb die Scan-Gesundheit vor den Funden.

> [!PRAXIS] Denk weiter
> CVSS 9,8 intern oder 7,5 am Internet mit KEV-Eintrag: was zuerst? Meist die 7,5, denn Ausnutzung ist belegt und das System exponiert. Kritikalität des Assets prüfen.

## c-14 | Ein Dienst ist mehr als sein Port
Das Risiko ergibt sich aus Dienstkonto, Vertrauensbeziehungen und Daten. Eine Datenbank als lokaler Admin, mit Verknüpfung zu weiteren Servern, ist ein anderes Ziel als dieselbe Version mit Minimalrechten. Härtung prüft daher auch, wohin der Dienst **selbst** verbinden darf.

> [!PRAXIS] Denk weiter
> SSH auf Port 2222 verlegt. Sicherer? Weniger Rauschen, gleicher Schutz. Schlüssel, MFA, Quellbeschränkung und Updates entscheiden.

## c-15 | Was C2 nicht vermeiden kann
Profile verändern Header, Namen und Takt. Unvermeidbar bleibt: Ein Prozess muss laufen, kommunizieren und für Aufgaben das Betriebssystem benutzen. Dauerhafte Erkennung verbindet Prozessherkunft, seltene Ziele und Folgeaktionen.

> [!PRAXIS] Denk weiter
> Ein autorisiertes C2 in der Übung: Was braucht es zusätzlich? Zugriffsschutz, Laufzeitende, Scope-Grenzen, Protokoll und Abbau. Die eigene Infrastruktur ist sonst eine echte Hintertür.

## c-16 | Die billigste Bruchstelle
Lies die Fallstudie rückwärts: Welche Voraussetzung hatte jeder Schritt? Dann bewerte, wo eine Maßnahme die meisten Wege schließt. Einzelne gepatchte Einstiege tauschen nur den Anfang, Tiering und getrennte Anmeldedaten brechen ganze Familien von Ketten.

> [!PRAXIS] Denk weiter
> Das Budget reicht für eine Empfehlung. Wie begründen? Mit Wirkung auf die Kette, Aufwand, Nebenwirkung und einem messbaren Nachweis, dass der Pfad geschlossen ist.
