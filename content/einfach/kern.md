# Einfach erklärt – Einstiege für Fundament, Offensive, Blue Team, AD

## f-01
Computer kennen nur zwei Zustände: Strom an oder aus – **1 oder 0**. Wie ein Lichtschalter. Mit acht Schaltern (einem **Byte**) kann man 256 verschiedene Muster bilden – genug für alle Buchstaben, Ziffern und Satzzeichen.

Zahlensysteme sind nur verschiedene Schreibweisen derselben Menge: Wir zählen dezimal mit zehn Fingern, Computer binär mit zwei Zuständen, und Menschen schreiben Binärzahlen gern **hexadezimal** ab, weil vier Bits genau eine Hex-Ziffer ergeben (`1111` = `F`). Wer das einmal verstanden hat, liest IP-Adressen, Rechte (`chmod 755`) und Speicherauszüge viel leichter.

## f-02
Netzwerkkommunikation funktioniert wie ein Paketdienst mit Abteilungen: Die eine kümmert sich um den **Inhalt** (Anwendung), die nächste darum, dass alles **vollständig ankommt** (Transport), eine weitere um den **Weg** (Vermittlung) und die letzte um das **Auto auf der Straße** (Leitung, Funk).

Das **OSI-Modell** teilt diese Arbeit in sieben Schichten, das praxisnähere **TCP/IP-Modell** in vier. Jede Schicht verpackt die Daten der darüberliegenden in einen eigenen Umschlag. Wer die Schichten kennt, kann Fehler und Angriffe zuordnen: Ein ARP-Problem ist „unten“, eine SQL-Injection „ganz oben“.

## f-03
Eine **IP-Adresse** ist wie eine Postanschrift: Ein Teil sagt, in welcher **Straße** (Netz) jemand wohnt, der andere, in welchem **Haus** (Host). Die **Subnetzmaske** legt fest, wo die Grenze zwischen Straße und Hausnummer liegt.

`192.168.1.20/24` heißt: Die ersten 24 Bit sind die Straße `192.168.1`, die letzte Zahl ist das Haus. **Subnetting** teilt große Straßen in kleinere – das spart Adressen und trennt Bereiche voneinander, was für die Sicherheit wichtig ist. **IPv6** löst die Adressknappheit mit 128 statt 32 Bit.

## f-04
**TCP** ist wie ein Einschreiben mit Rückschein: Erst wird per Handschlag geklärt, dass beide bereit sind, dann wird jedes Stück bestätigt und Verlorenes neu geschickt. **UDP** ist wie eine Postkarte: schnell, ohne Bestätigung – gut für Video, DNS oder Spiele.

**Ports** sind die Zimmernummern im Haus: Die IP-Adresse bringt das Paket zum richtigen Rechner, der Port zum richtigen Programm – 22 für SSH, 80/443 fürs Web, 445 für Windows-Freigaben. Wer weiß, welcher Dienst hinter welchem Port wohnt, versteht Scans und Firewall-Regeln sofort.

## f-05
Vier Helfer arbeiten in jedem Netz im Hintergrund:

- **DNS** ist das Telefonbuch: Name → Adresse.
- **DHCP** ist der Empfang im Hotel, der jedem Gast beim Ankommen eine Zimmernummer (IP-Adresse) gibt.
- **ARP** ist der Ruf im Flur: „Wer hat die Adresse 192.168.1.1? Melde dich mit deiner Hardware-Adresse!“
- **HTTP** ist die Sprache, in der Browser und Webserver sich unterhalten.

Weil diese Helfer oft anderen Teilnehmern blind vertrauen, sind sie auch beliebte Ziele für Täuschungen.

## f-06
Linux ist das Betriebssystem der Server, Router, Container und Hacker-Werkzeuge. Statt Fenster gibt es vor allem die **Kommandozeile** – wie ein Gespräch mit dem Computer in kurzen, präzisen Sätzen.

Zwei Grundideen tragen fast alles: **Alles ist eine Datei** (auch Geräte und Prozessinformationen), und **Rechte** regeln, wer lesen, schreiben oder ausführen darf. Wer diese beiden Ideen verinnerlicht, findet sich auf jedem Linux-System zurecht – und versteht, wo Fehlkonfigurationen gefährlich werden.

## f-07
Windows ist das Betriebssystem der meisten Büroarbeitsplätze und vieler Server. Für die Sicherheit zählen vor allem vier Dinge: **Benutzer und Gruppen** (wer darf was), die **Registry** (die zentrale Einstellungsdatenbank), **Dienste und Prozesse** (was läuft im Hintergrund) und die **Ereignisprotokolle** (was ist passiert).

Stell dir Windows wie ein großes Bürogebäude vor: Ausweise (Konten), ein Hausverwaltungsordner (Registry), Hausmeister im Hintergrund (Dienste) und ein Pförtnerbuch (Logs). Angreifer und Verteidiger arbeiten mit genau diesen vier Bereichen.

## f-08
Kryptografie ist die Kunst, Nachrichten so zu verwandeln, dass nur der richtige Empfänger sie lesen kann – und dass man merkt, wenn jemand sie verändert hat.

Drei Werkzeuge reichen für den Anfang: **Symmetrische Verschlüsselung** ist ein Schloss mit einem gemeinsamen Schlüssel. **Asymmetrische Verschlüsselung** ist ein Briefkasten: Jeder kann etwas einwerfen (öffentlicher Schlüssel), nur der Besitzer kann ihn leeren (privater Schlüssel). Und **Hashfunktionen** sind Fingerabdrücke: Aus beliebigen Daten entsteht ein kurzer, eindeutiger Wert.

## f-09
Eine Webanwendung ist ein Gespräch zwischen **Browser** und **Server**. Der Browser stellt Fragen (Anfragen), der Server antwortet mit Seiten oder Daten. Dazwischen stehen oft Datenbanken, Login-Systeme und Schnittstellen (APIs).

Das Grundproblem der Web-Sicherheit: Der Server muss **jeder Eingabe misstrauen**, denn der Nutzer kontrolliert alles, was sein Browser sendet – Formulare, Cookies, Header, sogar versteckte Felder. Fast alle Web-Schwachstellen entstehen, weil eine Anwendung einer Eingabe zu sehr vertraut.

## f-10
Skripte sind Kochrezepte für den Computer: Statt zehnmal dieselben Befehle zu tippen, schreibt man sie einmal auf und lässt sie ausführen. **Bash** ist die Sprache der Linux-Kommandozeile, **PowerShell** die von Windows, **Python** die Allzweck-Sprache der Security-Welt.

Für Sicherheitsleute bedeutet Scripting: Logs automatisch auswerten, wiederkehrende Prüfungen erledigen, Daten umformen. Und wer Skripte lesen kann, versteht auch, was Angreifer-Skripte auf einem System getan haben.

## f-11
**Virtualisierung** ist wie ein Haus, in dem man beliebig viele Wohnungen einrichten kann: Ein physischer Server beherbergt viele virtuelle Maschinen, jede mit eigenem Betriebssystem. **Container** sind noch leichter – eher wie Zimmer in einer WG, die sich Küche und Bad (den Kernel) teilen.

Die **Cloud** ist dann das Mieten solcher Wohnungen bei einem großen Anbieter. Wichtig für die Sicherheit: Der Anbieter schützt das Gebäude, aber für das Abschließen der eigenen Wohnung ist man selbst verantwortlich (**Shared Responsibility**).

## f-12
Active Directory ist das zentrale **Adress- und Ausweisbuch** eines Windows-Netzes. Es weiß, wer im Unternehmen arbeitet, welche Computer dazugehören, wer in welcher Gruppe ist und welche Regeln gelten.

Statt sich auf jedem Rechner einzeln anzumelden, meldet man sich einmal an der **Domäne** an – wie mit einem Firmenausweis, der viele Türen öffnet. Genau deshalb ist AD für Angreifer so attraktiv: Wer das Ausweisbüro übernimmt, hat Zugang zu allem.

## f-13
Ein **VPN** ist ein blickdichter Tunnel durch das öffentliche Internet: Von außen sieht man nur, dass Daten fließen, aber nicht, was. Ein **Proxy** ist ein Stellvertreter, der Anfragen in deinem Namen stellt – wie ein Assistent, der für dich anruft.

Fernzugriff (VPN, RDP, SSH, Fernwartung) ist bequem, aber jede Tür von außen ist auch eine Einladung. Darum gilt: so wenige Türen wie möglich, und jede mit starkem Schloss (MFA) und Kamera (Protokollierung).

## f-14
Eine **Datenbank** ist ein riesiger, gut sortierter Aktenschrank mit Tabellen – wie Excel, nur für Millionen Zeilen und viele gleichzeitige Nutzer. **SQL** ist die Sprache, mit der man Fragen stellt: „Zeige alle Kunden aus Berlin.“

Gefährlich wird es, wenn eine Anwendung Nutzereingaben direkt in solche Fragen einbaut. Dann kann ein Angreifer die Frage umschreiben („… oder zeig einfach alle Passwörter“) – das ist **SQL-Injection**, eine der bekanntesten Schwachstellen überhaupt.

## f-15
E-Mail funktioniert wie die Briefpost des Internets – nur dass die ursprünglichen Briefe **keinen geprüften Absender** hatten. Jeder konnte „Von: Bank“ auf den Umschlag schreiben.

Deshalb wurden nachträglich Prüfverfahren erfunden (SPF, DKIM, DMARC), und deshalb ist E-Mail bis heute der häufigste Weg für Angriffe: Phishing, Schadsoftware im Anhang, gefälschte Rechnungen. Wer versteht, wie eine Mail ihren Weg nimmt und was im Header steht, erkennt Fälschungen viel schneller.

## f-16
**Git** ist eine Zeitmaschine für Dateien: Jede Änderung wird gespeichert, man kann zurückspringen, parallel arbeiten und Änderungen zusammenführen. **Infrastructure as Code** überträgt das auf ganze Server und Netze: Statt per Hand zu klicken, beschreibt man die gewünschte Umgebung in Dateien – nachvollziehbar, wiederholbar, prüfbar.

Für die Sicherheit heißt das: Fehlkonfigurationen lassen sich schon im Code finden, bevor sie live gehen. Und: Geheimnisse haben in solchen Dateien nichts zu suchen.

## c-01
Ein Penetrationstest ist ein **beauftragter Einbruchsversuch**: Profis versuchen mit Erlaubnis, in Systeme einzudringen, damit die Lücken geschlossen werden, bevor echte Angreifer sie finden.

Wie ein guter Arzt folgt ein Pentest einem festen Ablauf: Auftrag klären, Informationen sammeln, Schwachstellen suchen, vorsichtig nachweisen, alles dokumentieren und am Ende verständlich berichten. Der wichtigste Unterschied zum echten Angriff: **Erlaubnis, Methodik und ein Bericht, der hilft.**

## c-02
Bevor man ein Gebäude prüft, macht man eine Bestandsaufnahme: Welche Türen gibt es, welche sind offen, was steht dahinter? **Netzwerk-Enumeration** ist genau das für Rechnernetze: Welche Hosts sind erreichbar, welche Ports offen, welche Dienste und Versionen laufen dort?

Werkzeuge wie Nmap klopfen höflich an jede Tür und notieren die Antworten. Die Ergebnisse bilden die Landkarte für alles Weitere – im Pentest genauso wie für Admins, die wissen wollen, was in ihrem Netz eigentlich alles läuft.

## c-03
Jeder Dienst – FTP, SMB, Mail, Datenbank – hat seine eigene Sprache und eigene typische Schwächen. **Footprinting** heißt, jeden gefundenen Dienst genau kennenzulernen: Welche Version? Welche Konfiguration? Erlaubt er anonymen Zugriff? Verrät er Benutzernamen?

Stell dir vor, du stehst vor vielen verschiedenen Türen: eine mit Zahlenschloss, eine mit Schlüssel, eine mit Klingel. Für jede brauchst du ein anderes Vorgehen. Footprinting ist das genaue Ansehen jeder einzelnen Tür.

## c-04
Bevor man eine Webanwendung prüft, muss man sie kennen: Welche Seiten, Funktionen, Parameter und Schnittstellen gibt es? Welche Technik steckt dahinter? **Web-Recon** ist das Kartografieren der Anwendung.

Das wichtigste Werkzeug dafür ist ein **Proxy** wie Burp Suite oder ZAP: Er sitzt zwischen Browser und Server und zeigt jede Anfrage und Antwort – wie ein Lauschposten, an dem man Nachrichten auch anhalten und verändern kann. So sieht man, was die Anwendung wirklich tut, nicht nur, was die Oberfläche zeigt.

## c-05
Web-Schwachstellen wirken anfangs wie ein Zoo aus Abkürzungen: SQLi, XSS, CSRF, SSRF, IDOR … Dahinter stecken aber nur wenige Grundmuster:

- **Eingaben werden als Befehle verstanden** (Injection).
- **Prüfungen fehlen** (wer darf was?).
- **Der Browser wird ausgetrickst** (XSS, CSRF).
- **Der Server wird zum Werkzeug** (SSRF).

Wer diese Muster versteht, erkennt neue Schwachstellen als Varianten von Bekanntem.

## c-06
Passwörter sind die häufigsten Schlüssel – und oft die schwächsten. Probleme entstehen, wenn sie **kurz**, **wiederverwendet**, **erratbar** oder **schlecht gespeichert** sind.

Angreifer probieren entweder online an der Tür (Raten, Spraying) oder offline an einem gestohlenen Abdruck (Hashes knacken). Verteidiger antworten mit Länge statt Komplexität, Passwortmanagern, langsamen Hashverfahren und vor allem **MFA**, damit ein gestohlenes Passwort allein nicht reicht.

## c-07
Wer in ein System eindringt, landet meist mit wenig Rechten – wie ein Besucher im Foyer. **Rechteausweitung** ist der Weg vom Foyer in die Chefetage: über eine offene Tür (Fehlkonfiguration), einen herumliegenden Schlüssel (Passwort in einer Datei) oder einen hilfsbereiten Mitarbeiter (ein Programm mit zu vielen Rechten).

Fast immer sind es keine Wunder-Exploits, sondern **Unordnung**. Deshalb ist dieses Thema für Angreifer und Verteidiger gleich wertvoll: Die Prüfliste des einen ist die Härtungsliste des anderen.

## c-08
Active Directory ist das Herz eines Windows-Netzes. Angriffe darauf folgen einem Muster: **Informationen sammeln** (Wer ist wer, wer darf was?), **Anmeldedaten erlangen**, sich **seitwärts bewegen** und **Rechte ausweiten**, bis das Ziel – meist die Domänen-Admin-Rechte – erreicht ist.

Die gute Nachricht: Die meisten dieser Wege beruhen auf bekannten Schwächen wie schwachen Dienstkonto-Passwörtern, zu weiten Rechten oder alten Protokollen. Wer die Angriffsklassen versteht, weiß genau, wo er abdichten muss.

## c-09
Netze sind wie Gebäude mit verschiedenen Bereichen: Lobby, Büros, Serverraum. Zwischen den Bereichen stehen Türen (Firewalls). **Pivoting** heißt, einen bereits übernommenen Rechner als Sprungbrett in einen Bereich zu nutzen, den man von außen nicht erreicht. **Tunneling** heißt, Verkehr in erlaubten Verbindungen zu verstecken.

Für Verteidiger ist das die Erinnerung: Segmentierung funktioniert nur, wenn auch die Systeme an den Grenzen gut geschützt und überwacht sind.

## c-10
Ein Pentest ist nur so gut wie sein Bericht. Niemand behebt eine Lücke, die er nicht versteht. **Dokumentation** beginnt deshalb schon während des Tests: Jeder Schritt wird mit Zeit, Befehl und Ergebnis notiert.

Der Bericht übersetzt diese Notizen für zwei Publika: Die Geschäftsleitung braucht eine klare Zusammenfassung der Risiken, die Technik braucht genaue Schritte zum Nachstellen und konkrete Empfehlungen. Ein guter Bericht ist wie ein Arztbrief – verständlich, präzise und mit Therapieplan.

## c-11
Ein Handwerker ist nur so gut wie seine Werkstatt. Für Sicherheitsarbeit heißt das: eine **saubere, getrennte Arbeitsumgebung** (z. B. eine virtuelle Maschine mit Kali oder Parrot), gut organisierte Werkzeuge, ein Notizsystem und ein Plan, wie man Ergebnisse speichert.

Werkzeuge sind aber nur Hilfsmittel. Wichtiger ist zu verstehen, **was** ein Werkzeug tut – sonst weiß man nicht, wann es sich irrt, was es auf dem Zielsystem verändert oder welche Spuren es hinterlässt.

## c-12
Hack The Box bietet praxisnahe Zertifikate für verschiedene Rollen: vom Einstieg (CJCA) über Penetration Testing (CPTS), Web (CWES, CWEE) und SOC-Analyse (CDSA) bis zu Active-Directory-Experten (CAPE).

Allen gemeinsam: Man muss in einer echten Umgebung **praktisch arbeiten** und am Ende einen **professionellen Bericht** abgeben. Multiple-Choice-Wissen allein reicht nicht. Dieses Modul hilft, den passenden Weg zu wählen und sich realistisch vorzubereiten.

## c-13
Ein **Vulnerability Assessment** ist eine Bestandsaufnahme der Schwachstellen – breit, systematisch, oft mit Scannern. Wie ein TÜV-Check: Viele Punkte werden geprüft, Mängel notiert und nach Dringlichkeit sortiert.

Der Unterschied zum Pentest: Ein Assessment findet und bewertet Schwachstellen, ein Pentest zeigt zusätzlich, **was ein Angreifer damit tatsächlich erreichen kann**. Beide ergänzen sich – das eine liefert Breite, das andere Tiefe.

## c-14
Jeder Dienst, der im Netz läuft, ist eine Tür: Dateifreigaben, Mailserver, Datenbanken, Fernzugänge, Verzeichnisdienste. Viele Vorfälle beginnen nicht mit raffinierten Exploits, sondern mit **Standardeinstellungen**, alten Versionen oder Diensten, die gar nicht laufen müssten.

Dieses Modul betrachtet die häufigsten Dienste von beiden Seiten: Welche Risiken bringen sie mit, und welche Handgriffe machen sie sicher?

## c-15
Angreifer arbeiten selten mit losen Einzelwerkzeugen, sondern mit **Frameworks**: Werkzeugkästen, die Ausnutzung, Fernsteuerung (Command & Control) und Weiterbewegung bündeln. Für Verteidiger ist das eine Chance: Frameworks hinterlassen typische Muster – Prozessketten, Netzwerkverhalten, Speicherartefakte.

Wer versteht, wie solche Werkzeuge grundsätzlich aufgebaut sind, kann gezielt nach ihren Spuren suchen, statt nur nach einzelnen Dateien.

## c-16
Theorie wird erst durch einen zusammenhängenden Fall greifbar. Diese Fallstudie verfolgt einen Pentest in einem fiktiven Unternehmensnetz vom ersten Scan bis zur Domänenübernahme – Schritt für Schritt, mit Begründung jeder Entscheidung.

Achte beim Lesen darauf, **wie sich kleine Schwächen zu einer Kette verbinden**: Keine einzelne war dramatisch, zusammen führten sie zum vollständigen Zugriff. Genau diese Denkweise brauchst du in Prüfungen und in der Verteidigung.

## d-01
Ein **SOC** ist die Leitstelle der IT-Sicherheit: Hier laufen alle Alarme zusammen, hier entscheiden Analysten, ob etwas harmlos ist oder ein Angriff läuft. Das wichtigste Werkzeug ist das **SIEM** – ein System, das Protokolle aus allen Quellen sammelt, durchsuchbar macht und bei verdächtigen Mustern Alarm schlägt.

Stell es dir wie eine Videoüberwachungszentrale vor: Viele Kameras (Logquellen), ein großer Bildschirm (SIEM) und Menschen, die wissen, worauf sie achten müssen.

## d-02
Splunk und Elastic sind zwei der bekanntesten Werkzeuge, um riesige Mengen an Protokollen zu durchsuchen – wie eine Suchmaschine nur für Logs. Mit ihren Abfragesprachen (SPL, KQL/EQL) stellt man Fragen wie: „Welche Konten hatten heute mehr als 20 Fehlanmeldungen?“

Die Kunst liegt darin, die richtigen Fragen zu stellen: vom Großen ins Kleine, erst zählen und gruppieren, dann einzelne Ereignisse genau ansehen.

## d-03
Windows schreibt für fast jede sicherheitsrelevante Aktion einen Eintrag ins Protokoll – mit einer Nummer, der **Event-ID**. **Sysmon** ist ein kostenloses Zusatzwerkzeug, das noch genauer hinschaut: Welcher Prozess hat welchen gestartet, welche Netzwerkverbindung aufgebaut, welche Datei angelegt?

Zusammen sind sie wie Pförtnerbuch und Überwachungskamera: Das eine sagt, wer kam und ging, das andere zeigt, was drinnen passiert ist.

## d-04
Klassische Sicherheit wartet auf Alarme. **Threat Hunting** dreht das um: Man geht aktiv auf die Suche, mit einer Vermutung im Kopf („Wenn ein Angreifer hier wäre, würde er X tun – sehen wir X?“).

**Threat Intelligence** liefert dafür das Wissen: Welche Gruppen greifen unsere Branche an, mit welchen Methoden und Werkzeugen? Wie ein Kommissar, der die Vorgehensweise bekannter Täter studiert, um ihre Spuren schneller zu erkennen.

## d-05
Im Netzwerk hinterlässt jede Kommunikation Spuren – wer mit wem, wann, wie viel, über welches Protokoll. **Netzwerkverkehrsanalyse** liest diese Spuren. **Zeek** fasst den Verkehr in übersichtliche Protokolle zusammen, **Suricata** prüft ihn gegen Regeln für bekannte Angriffe.

Auch verschlüsselter Verkehr verrät viel: Ziele, Zeitpunkte, Datenmengen, Regelmäßigkeit. Wie bei einem Brief, dessen Inhalt man nicht lesen kann, dessen Umschlag aber Absender, Empfänger und Gewicht zeigt.

## d-06
Eine verdächtige Datei ist wie ein unbekanntes Paket vor der Tür: Man öffnet es nicht einfach im Wohnzimmer. **Malware-Analyse** untersucht solche Dateien sicher – zuerst von außen (statisch: Was steht drin, welche Merkmale hat sie?), dann kontrolliert in einer abgeschotteten Umgebung (dynamisch: Was tut sie, wenn sie läuft?).

Das Ziel ist nicht immer, alles bis ins Letzte zu verstehen, sondern schnell genug zu wissen: Was richtet sie an, und woran erkennen wir sie anderswo?

## d-07
Erkennungsregeln sind Steckbriefe: **YARA** beschreibt, wie eine schädliche **Datei** aussieht (bestimmte Zeichenfolgen, Merkmale), **Sigma** beschreibt, wie ein verdächtiges **Ereignis in Logs** aussieht – unabhängig vom eingesetzten SIEM.

Wer Regeln schreiben kann, verwandelt Erkenntnisse aus einem Vorfall in dauerhaften Schutz: Was einmal gesehen wurde, wird beim nächsten Mal automatisch erkannt.

## d-08
Digitale Forensik ist Spurensicherung am digitalen Tatort. Wie bei der Polizei gilt: **Erst sichern, dann untersuchen** – und zwar so, dass nichts verändert wird und jeder Schritt nachvollziehbar dokumentiert ist (Beweiskette).

Untersucht werden Festplatten, Arbeitsspeicher, Logs und Netzwerkmitschnitte. Am Ende steht eine **Zeitleiste**: Was ist wann in welcher Reihenfolge passiert? Diese Rekonstruktion ist die Grundlage für Aufräumen, Lernen und – falls nötig – rechtliche Schritte.

## d-09
Phishing ist der häufigste Einstieg für Angriffe. Die **Phishing-Analyse** im SOC beantwortet für jede gemeldete Mail: Ist sie bösartig? Wer hat sie noch bekommen? Hat jemand geklickt oder Daten eingegeben?

Dafür liest man den **Header** (den „Briefumschlag“ mit allen Stationen), prüft Links und Anhänge sicher und sucht nach weiteren Empfängern. Schnelligkeit zählt: Je früher eine Kampagne gestoppt wird, desto weniger Opfer.

## d-10
Jede Angriffstechnik hinterlässt typische Spuren in Windows-Logs – wie Fußabdrücke im Schnee. Wer weiß, welche Abdrücke zu welcher Technik gehören, erkennt Angriffe, auch wenn keine einzelne Datei verdächtig ist.

Dieses Modul verbindet beides: die Technik des Angreifers und die konkreten Ereignisse, die sie im Log erzeugt. So entstehen gezielte Suchanfragen und Erkennungsregeln.

## d-11
Vorfälle passieren nicht nur auf Windows-Rechnern. Linux-Server und Cloud-Umgebungen haben eigene Spuren, eigene Werkzeuge und eigene Fallstricke: Auf Linux zählen Shell-History, auth.log, Cronjobs und laufende Prozesse; in der Cloud fast nur die **Audit-Logs** des Anbieters, denn eine Festplatte zum Mitnehmen gibt es nicht.

Das Vorgehen bleibt gleich: eindämmen, Spuren sichern, verstehen, bereinigen, lernen – nur die Orte, an denen man sucht, unterscheiden sich.

## a-01
Kerberos funktioniert wie ein Freizeitpark mit Armbändern: Am Eingang zeigt man einmal den Ausweis und bekommt ein Tagesarmband (TGT). An jeder Attraktion tauscht man das Armband gegen eine Fahrkarte für genau diese Attraktion (Service-Ticket).

In diesem Expertenmodul schauen wir genauer hin: Was steht in den Tickets (PAC), wer verschlüsselt sie womit, und wie funktioniert Delegation, bei der ein Dienst im Namen eines Nutzers weitere Fahrkarten holen darf? Genau dort liegen die interessantesten Schwachstellen.

## a-02
Eine Zertifizierungsstelle im Unternehmen ist wie ein Passamt: Sie stellt digitale Ausweise aus, mit denen man sich anmelden, verschlüsseln oder signieren kann. Ist das Passamt zu großzügig konfiguriert – etwa, wenn jeder selbst eintragen darf, für wen der Ausweis gilt –, kann man sich einen Ausweis des Chefs ausstellen lassen.

Dieses Modul zeigt, welche Einstellungen der **ADCS** gefährlich sind, wie man sie findet und wie man sie abdichtet.

## a-03
Mehrere Domänen oder Forests können sich gegenseitig **vertrauen** – wie zwei Firmen, die die Mitarbeiterausweise der jeweils anderen akzeptieren. Das ist praktisch für Zusammenarbeit, kann aber auch einen Weg öffnen: Wer eine Seite übernimmt, versucht, über das Vertrauen auf die andere zu gelangen.

Das Modul erklärt Vertrauensrichtungen, -arten und Filtermechanismen (wie SID-Filterung) und zeigt, wo Grenzen wirklich halten und wo nicht.

## a-04
Nach all den Angriffswegen kommt die wichtigste Frage: **Wie verteidigt man Active Directory?** Drei Säulen tragen: **Erkennen** (welche Ereignisse verraten Angriffe?), **Härten** (Tiering, schwache Protokolle abschalten, Rechte bereinigen) und **Wiederherstellen** (was tun, wenn die Domäne übernommen wurde?).

Ein gut verteidigtes AD macht jeden Angriffsschritt laut und mühsam – und genau das ist das Ziel.
