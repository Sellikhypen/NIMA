# Einfach erklärt – Serien Teil A (ATT&CK, OWASP, Linux, Windows, Netzwerk, Python)

## att-01
Bevor ein Einbrecher zuschlägt, beobachtet er: Wann ist niemand zu Hause, wo hängt die Kamera? **Reconnaissance** ist diese Erkundungsphase im Cyberangriff – Mitarbeiter, Technik und erreichbare Systeme werden ausgekundschaftet, oft ohne das Ziel überhaupt zu berühren.

Für Verteidiger heißt das: Was öffentlich über uns bekannt ist, ist Teil unserer Angriffsfläche.

## att-02
Angreifer brauchen Ausrüstung: Server, Domains, E-Mail-Konten, Werkzeuge, manchmal gekaufte Zugänge. **Resource Development** ist das Einkaufen und Bauen dieser Infrastruktur – wie ein Bankräuber, der Fluchtwagen und Masken besorgt.

Diese Vorbereitung passiert außerhalb unseres Netzes, hinterlässt aber Spuren: frisch registrierte, ähnlich klingende Domains sind oft ein frühes Warnsignal.

## att-03
**Initial Access** ist der erste Fuß in der Tür: eine Phishing-Mail, ein ungepatchter VPN-Server, ein gestohlenes Passwort, ein manipuliertes Update. Hier entscheidet sich, ob ein Angriff überhaupt beginnt.

Darum lohnt sich hier jede Maßnahme besonders: Patchen, MFA, E-Mail-Schutz und geschulte Mitarbeitende halten die Tür zu.

## att-04
Ist der Angreifer drin, will er Befehle ausführen: über Skriptsprachen, Systemwerkzeuge, geplante Aufgaben oder Dienste. **Execution** ist der Moment, in dem fremder Code auf dem System läuft.

Verteidiger achten auf ungewöhnliche Prozessketten – etwa wenn Word plötzlich PowerShell startet.

## att-05
Ein Angreifer will nicht nach jedem Neustart von vorn anfangen. **Persistence** heißt, sich dauerhaft einzunisten: Autostart-Einträge, neue Konten, geplante Aufgaben, Dienste – wie ein Einbrecher, der sich einen Zweitschlüssel nachmacht.

Wer weiß, wo solche „Zweitschlüssel“ versteckt werden können, findet sie gezielt.

## att-06
Wer mit einfachen Rechten startet, will mehr. **Privilege Escalation** ist der Aufstieg zu Administrator- oder Systemrechten – über Fehlkonfigurationen, Schwachstellen oder gestohlene Anmeldedaten.

Je weniger Rechte jedes Konto hat und je sauberer Systeme konfiguriert sind, desto steiler wird diese Treppe.

## att-07
Angreifer wollen unsichtbar bleiben: Virenscanner abschalten, Logs löschen, Code verschleiern, sich als legitime Programme tarnen. **Defense Evasion** war bis v18 die umfangreichste Taktik in ATT&CK, seit v19 ist sie in Stealth und Defense Impairment aufgeteilt.

Die Gegenstrategie: Auch das Verschwinden von Daten ist ein Signal. Wenn ein Log plötzlich verstummt, ist das verdächtig.

## att-08
Passwörter, Hashes, Tickets, Tokens – **Credential Access** ist das Stehlen von Anmeldedaten. Mit fremden Zugangsdaten sieht ein Angreifer aus wie ein normaler Mitarbeiter.

Schutz bieten MFA, geschützter Speicher für Anmeldedaten (Credential Guard) und Überwachung von Zugriffen auf Stellen wie LSASS.

## att-09
Ein Einbrecher, der im Haus steht, schaut sich um: Welche Räume gibt es, wo ist der Tresor? **Discovery** ist diese Orientierung im Netz – Benutzer, Gruppen, Freigaben, Server werden erkundet.

Viele dieser Abfragen sind auch für Admins normal. Auffällig wird es, wenn ein normaler Arbeitsplatz plötzlich das ganze Netz kartiert.

## att-10
**Lateral Movement** ist das Wandern von Rechner zu Rechner – mit gestohlenen Anmeldedaten und legitimen Werkzeugen wie RDP oder Remote-PowerShell.

Segmentierung und Tiering machen diese Wege lang und laut; gute Überwachung erkennt ungewöhnliche Verbindungen zwischen Arbeitsplätzen.

## att-11
Bevor Daten gestohlen werden, werden sie eingesammelt: aus Postfächern, Freigaben, Datenbanken, Screenshots, Zwischenablage. **Collection** ist das Packen der Beute.

Auffällig sind große Mengen an Zugriffen in kurzer Zeit und das Anlegen von Archiven an ungewöhnlichen Orten.

## att-12
Ein Angreifer steuert kompromittierte Systeme aus der Ferne – über einen **Command-and-Control**-Kanal (C2). Oft getarnt als normaler Web- oder DNS-Verkehr.

Verteidiger erkennen C2 an Regelmäßigkeit (Beaconing), seltenen Zielen und ungewöhnlichen Prozessen mit Netzwerkverbindungen.

## att-13
**Exfiltration** ist der eigentliche Diebstahl: Daten verlassen das Unternehmen – über das Internet, Cloud-Speicher, E-Mail oder versteckt in anderen Protokollen.

Egress-Kontrollen, DLP und das Beobachten von Datenmengen machen es schwerer, unbemerkt Daten hinauszutragen.

## att-14
Am Ende steht oft der **Impact**: Daten werden verschlüsselt (Ransomware), gelöscht oder verändert, Systeme lahmgelegt. Hier wird aus einem Einbruch ein Schaden.

Die beste Vorbereitung: getestete Backups, Notfallpläne und Erkennung, die früher in der Kette greift.

## ow-01
Stell dir ein Hotel vor, in dem jede Schlüsselkarte jede Tür öffnet, wenn man nur die Zimmernummer kennt. **Broken Access Control** heißt: Die Anwendung prüft nicht richtig, ob du etwas **darfst** – und steht deshalb auf Platz 1 der OWASP Top 10.

## ow-02
Sensible Daten müssen verschlüsselt übertragen und gespeichert werden – mit modernen Verfahren und gutem Schlüsselmanagement. **Cryptographic Failures** passieren, wenn das fehlt: Klartext-Passwörter, veraltete Algorithmen, Schlüssel im Code.

## ow-03
Bei **Injection** wird eine Eingabe als Befehl verstanden – in SQL, im Betriebssystem, in Vorlagen oder im Browser. Wie ein Formular, in das jemand statt seines Namens eine Anweisung an den Sachbearbeiter schreibt, und der führt sie aus.

## ow-04
Manche Fehler stecken nicht im Code, sondern schon im **Entwurf**: kein Limit für Passwort-Resets, keine Prüfung von Geschäftsregeln, fehlende Bedrohungsanalyse. **Insecure Design** erinnert daran, Sicherheit schon beim Planen mitzudenken.

## ow-05
Standardpasswörter, offene Admin-Oberflächen, ausführliche Fehlermeldungen, unnötige Dienste: **Security Misconfiguration** ist die Unordnung im Betrieb – häufig, leicht zu finden, leicht zu beheben.

## ow-06
Moderne Software besteht großteils aus fremden Bibliotheken. Ist eine davon veraltet und verwundbar, ist es die ganze Anwendung. **Vulnerable and Outdated Components** dreht sich um Inventar, Updates und SCA-Werkzeuge.

## ow-07
Anmeldung und Sitzungen sind die Tür zur Anwendung. **Identification and Authentication Failures** sind schwache Passwortregeln, fehlende MFA, unsichere Sitzungen oder Brute-Force ohne Bremse.

## ow-08
Updates, Pakete und Daten müssen echt und unverändert sein. **Software and Data Integrity Failures** entstehen, wenn Updates ohne Signatur akzeptiert, CI/CD-Pipelines manipuliert oder unsichere Objekte deserialisiert werden.

## ow-09
Ohne Logs bemerkt man Angriffe nicht – oder viel zu spät. **Security Logging and Monitoring Failures** heißt: Wichtige Ereignisse werden nicht protokolliert, nicht ausgewertet oder niemand reagiert auf Alarme.

## ow-10
Bei **SSRF** bringt ein Angreifer den Server dazu, in seinem Namen Anfragen zu stellen – auch an interne Systeme, die von außen unerreichbar sind. Wie ein Pförtner, der auf Zuruf jede beliebige Tür im Haus öffnet.

## lx-01
Die Linux-Kommandozeile ist wie ein Gespräch mit dem Dateisystem: „Wo bin ich?“ (`pwd`), „Was liegt hier?“ (`ls`), „Geh dorthin“ (`cd`). Mit wenigen Befehlen bewegst du dich sicher durch jedes System.

## lx-02
Logs und Ausgaben sind oft riesig. Mit `grep`, `sed`, `awk` und Pipes filterst und formst du Text wie mit einem Fließband: Jeder Befehl erledigt einen kleinen Schritt und reicht das Ergebnis weiter.

## lx-03
Unter Linux hat jede Datei einen Besitzer, eine Gruppe und Rechte: lesen, schreiben, ausführen – für Besitzer, Gruppe und alle anderen. Wer diese neun Häkchen versteht, versteht die meisten Linux-Sicherheitsfragen.

## lx-04
Auf einem Linux-System laufen ständig Programme im Hintergrund: Dienste, Cronjobs, Timer. Wer weiß, wie man sie anzeigt, startet, stoppt und plant, kann Systeme verwalten – und verdächtige Prozesse finden.

## lx-05
Welche Adresse habe ich? Welche Ports sind offen? Mit wem bin ich verbunden? Mit `ip`, `ss`, `curl` und `dig` beantwortest du Netzwerkfragen direkt auf der Kommandozeile.

## lx-06
Paketmanager sind die App-Stores von Linux: Sie installieren, aktualisieren und entfernen Software mitsamt Abhängigkeiten. Regelmäßige Updates sind die einfachste und wirksamste Sicherheitsmaßnahme.

## lx-07
Linux protokolliert, was passiert – in Dateien unter `/var/log` und im systemd-Journal. Wer Logs lesen kann, findet Fehler, Anmeldeversuche und Angriffsspuren.

## lx-08
Bash-Skripte automatisieren Routinearbeit: Backups, Prüfungen, Auswertungen. Mit Variablen, Schleifen und Bedingungen wird aus einer Befehlsfolge ein kleines Programm.

## wp-01
Die Windows-Eingabeaufforderung (cmd) ist der Klassiker: Dateien, Netzwerk, Benutzer und Dienste lassen sich mit kurzen Befehlen verwalten – auch dort, wo keine grafische Oberfläche zur Verfügung steht.

## wp-02
PowerShell ist die moderne Windows-Kommandozeile – und mehr: Sie arbeitet nicht mit Text, sondern mit **Objekten**, die man filtern, sortieren und weiterreichen kann. Für Admins und Analysten das wichtigste Windows-Werkzeug.

## wp-03
Wer bin ich, in welchen Gruppen bin ich, welche Rechte habe ich? Unter Windows und im Active Directory lassen sich diese Fragen mit Bordmitteln beantworten – die Grundlage für Verwaltung und Sicherheitsprüfung.

## wp-04
Dienste, Prozesse, Registry und Ereignisprotokolle sind die vier Orte, an denen man unter Windows nachsieht, was läuft, was eingestellt ist und was passiert ist.

## wp-05
Windows-Rechner reden miteinander: über Freigaben, Remote-PowerShell, RDP. Wer diese Wege kennt, kann aus der Ferne verwalten – und weiß, welche Wege Angreifer für Seitwärtsbewegungen nutzen.

## wp-06
Windows bringt viele Schutzfunktionen mit: Defender, Firewall, BitLocker, Credential Guard, Attack Surface Reduction. Man muss sie nur einschalten und richtig konfigurieren.

## nw-01
In einem lokalen Netz verbindet ein **Switch** Geräte wie eine Telefonzentrale: Er lernt, welche Hardwareadresse an welchem Anschluss hängt, und stellt Pakete gezielt zu, statt sie an alle zu schicken.

## nw-02
**VLANs** teilen einen physischen Switch in mehrere logische Netze – wie unsichtbare Wände in einem Großraumbüro. So bleiben Gäste, Server und Büro getrennt, obwohl sie dieselbe Hardware nutzen.

## nw-03
**Router** verbinden Netze und entscheiden, welchen Weg ein Paket nimmt – wie Wegweiser an Kreuzungen. Routingprotokolle sorgen dafür, dass diese Wegweiser sich automatisch abstimmen.

## nw-04
**IPv6** bringt nahezu unbegrenzt viele Adressen und neue Mechanismen – aber auch neue Sicherheitsfragen: Viele Netze haben IPv6 aktiv, ohne es zu überwachen.

## nw-05
Eine **Firewall** ist ein Türsteher mit Gästeliste: Sie entscheidet anhand von Regeln, welcher Verkehr passieren darf. Moderne Firewalls erkennen zusätzlich Anwendungen und Angriffe.

## nw-06
Zeit (NTP), Protokollsammlung (Syslog) und Überwachung (SNMP) sind die unscheinbaren Helfer eines Netzes. Ohne sie gibt es keine verlässlichen Logs, keine Alarme und keine Übersicht.

## nw-07
Wenn „das Netz nicht geht“, hilft System statt Raten: von unten nach oben prüfen – Kabel, Adresse, Gateway, Namensauflösung, Dienst. So findet man Fehler schnell und nachvollziehbar.

## nw-08
Bei einem **DDoS**-Angriff wird ein Dienst mit Anfragen überflutet, bis er zusammenbricht – wie tausende Leute, die gleichzeitig durch eine Tür wollen. Abwehr gelingt meist nur mit Partnern und Vorbereitung.

## py-01
Python ist die Allzweck-Sprache der Security: leicht zu lesen, mit Bibliotheken für fast alles. Variablen, Listen, Schleifen und Funktionen reichen für die ersten nützlichen Skripte.

## py-02
Tausende Logzeilen per Hand durchsehen? Nein danke. Mit Python liest, filtert und zählt man Daten automatisch – und erkennt Muster, die mit bloßem Auge untergehen.

## py-03
Webseiten und APIs lassen sich mit Python ansprechen wie mit einem Browser – nur automatisiert. So testet man Schnittstellen, sammelt Daten oder baut kleine Werkzeuge.

## py-04
Reguläre Ausdrücke sind Suchmuster für Text: „Finde alles, das wie eine IP-Adresse aussieht.“ Einmal verstanden, sind sie in Logs, SIEMs und Skripten unverzichtbar.

## py-05
JSON, YAML, XML, CSV – Daten reisen in verschiedenen Formaten. Wer sie lesen, umwandeln und sicher verarbeiten kann, kommt mit jedem System ins Gespräch.
