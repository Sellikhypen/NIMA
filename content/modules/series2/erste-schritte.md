---
id: es-01
title: Erste Schritte 1 · Was ist Cybersicherheit?
paths: grundlagen, cjca, specialist
order: 0.11
difficulty: easy
icon: shield.lefthalf.filled
tags: einstieg, grundbegriffe
summary: Worum es in der Cybersicherheit eigentlich geht – Schutzziele, Bedrohungen und warum jede Person Teil der Verteidigung ist.
---

## Einfach erklärt

Stell dir dein Zuhause vor. Du schließt die Tür ab (niemand Fremdes soll hinein), du willst, dass niemand deine Möbel heimlich umstellt, und du möchtest jederzeit hineinkommen können. Genau diese drei Wünsche hat auch jede IT:

- **Vertraulichkeit** – nur Berechtigte sehen die Daten (die abgeschlossene Tür).
- **Integrität** – Daten werden nicht unbemerkt verändert (niemand stellt die Möbel um).
- **Verfügbarkeit** – Systeme funktionieren, wenn man sie braucht (du kommst jederzeit hinein).

Cybersicherheit ist alles, was diese drei Ziele für Computer, Netze und Daten schützt.

> [!MERKE] Die CIA-Triade
> Confidentiality, Integrity, Availability – auf Deutsch Vertraulichkeit, Integrität, Verfügbarkeit. Fast jede Sicherheitsmaßnahme lässt sich einem dieser Ziele zuordnen.

## Wer greift an – und warum?

Angreifer sind nicht nur „Hacker im Kapuzenpulli“. Typische Gruppen:

| Gruppe | Motiv | Beispiel |
|---|---|---|
| Kriminelle | Geld | Ransomware, Kontobetrug |
| Staatliche Akteure | Spionage, Sabotage | gezielte Angriffe auf Behörden |
| Hacktivisten | politische Botschaft | Website-Verunstaltung, DDoS |
| Innentäter | Rache, Geld, Fahrlässigkeit | Datendiebstahl beim Jobwechsel |
| Gelegenheitstäter | Neugier, Ruhm | automatisierte Scans nach alten Lücken |

Die meisten Angriffe sind **nicht gezielt**: Automatische Werkzeuge suchen rund um die Uhr nach ungepatchten Systemen und schwachen Passwörtern. Deshalb lohnt sich Grundschutz für alle.

## Wie Verteidigung funktioniert

Verteidigung besteht aus mehreren Schichten – wie bei einer Burg mit Graben, Mauer, Tor und Wache. Man nennt das **Defense in Depth**:

1. **Vorbeugen** – Updates, starke Anmeldung, Firewalls, Schulung.
2. **Erkennen** – Protokolle auswerten, Alarme, Virenschutz.
3. **Reagieren** – Vorfall eindämmen, bereinigen, wiederherstellen.
4. **Lernen** – Ursachen beheben, damit es nicht erneut passiert.

> [!TIPP] Menschen sind Teil der Abwehr
> Viele Angriffe beginnen mit einer E-Mail. Wer eine verdächtige Nachricht meldet statt anklickt, ist ein Sensor im Verteidigungssystem.

## Tiefer eingetaucht

Zur CIA-Triade kommen in der Praxis weitere Ziele hinzu:

- **Authentizität** – ist der Kommunikationspartner wirklich der, für den er sich ausgibt?
- **Nichtabstreitbarkeit** – eine Aktion kann später nicht geleugnet werden (z. B. durch digitale Signaturen).
- **Zurechenbarkeit** – Aktionen lassen sich einer Person zuordnen (Protokollierung).

Sicherheit ist immer eine **Abwägung**: Mehr Schutz kostet Geld, Zeit oder Komfort. Deshalb arbeitet man mit **Risiken**: Wie wahrscheinlich ist ein Schaden, und wie hoch wäre er? Maßnahmen setzt man dort, wo das Risiko am größten ist – das ist der Kern jedes Informationssicherheits-Managements.

## Quiz

? Wofür steht das „I“ in der CIA-Triade?
+ Integrität
- Identität
- Information
- Isolation
! Integrität bedeutet, dass Daten nicht unbemerkt verändert werden.

? Ein Server ist wegen Überlastung nicht erreichbar. Welches Schutzziel ist verletzt?
+ Verfügbarkeit
- Vertraulichkeit
- Integrität
- Nichtabstreitbarkeit
! Wenn ein System nicht nutzbar ist, ist die Verfügbarkeit verletzt – typisch bei DDoS-Angriffen.

? Jemand liest ohne Erlaubnis fremde E-Mails. Welches Schutzziel ist betroffen?
= Vertraulichkeit
! Unbefugtes Lesen verletzt die Vertraulichkeit.

?tf Die meisten Angriffe im Internet sind gezielt gegen eine bestimmte Person gerichtet.
= falsch
! Ein Großteil läuft automatisiert: Werkzeuge suchen massenhaft nach bekannten Schwachstellen und schwachen Passwörtern.

? Wie heißt das Prinzip, mehrere Schutzschichten hintereinander aufzubauen?
= Defense in Depth
= Defense-in-Depth
~ Englisch, wörtlich „Verteidigung in der Tiefe“
! Fällt eine Schicht, hält die nächste – wie Graben, Mauer und Wache einer Burg.

?order Bringe die Phasen der Verteidigung in eine sinnvolle Reihenfolge.
> Vorbeugen
> Erkennen
> Reagieren
> Lernen
! Erst verhindern, dann erkennen, was trotzdem passiert, reagieren und daraus lernen.

? Welches Schutzziel stellen digitale Signaturen besonders sicher?
+ Nichtabstreitbarkeit
- Verfügbarkeit
- Vertraulichkeit
- Anonymität
! Wer signiert hat, kann es später nicht glaubhaft abstreiten.

? Was beschreibt ein Risiko am besten?
+ Kombination aus Eintrittswahrscheinlichkeit und Schadenshöhe
- jede bekannte Schwachstelle
- ein laufender Angriff
- eine fehlende Firewall
! Risiko = Wahrscheinlichkeit × Auswirkung. Eine Schwachstelle allein ist noch kein Risiko, wenn sie nicht ausnutzbar ist.

@@@ MODULE @@@
---
id: es-02
title: Erste Schritte 2 · Die Reise eines Datenpakets
paths: grundlagen, cjca
order: 0.12
difficulty: easy
icon: paperplane.fill
tags: einstieg, netzwerk
summary: Was passiert, wenn du eine Website aufrufst? Eine Reise vom Browser über DNS, Router und Internet bis zum Server und zurück.
---

## Einfach erklärt

Eine Website aufzurufen ist wie einen Brief zu verschicken:

- Du kennst nur den **Namen** des Empfängers (`example.com`), brauchst aber seine **Adresse**. Dafür gibt es das Telefonbuch des Internets: **DNS**.
- Den Brief steckst du in einen Umschlag mit Absender und Empfänger – das ist ein **IP-Paket**.
- Die Post (die **Router**) reicht den Brief von Verteilzentrum zu Verteilzentrum weiter, bis er ankommt.
- Der Empfänger antwortet mit einem eigenen Brief: der Website.

## Schritt für Schritt

1. Du tippst `https://example.com` in den Browser.
2. Der Rechner fragt einen **DNS-Resolver**: „Welche IP-Adresse hat example.com?“
3. Der Browser baut eine **TCP-Verbindung** zum Server auf (Port 443) – den Drei-Wege-Handshake.
4. Darüber wird mit **TLS** eine verschlüsselte Verbindung ausgehandelt.
5. Der Browser sendet eine **HTTP-Anfrage** (`GET /`).
6. Der Server antwortet mit HTML; der Browser lädt Bilder, Skripte und Stylesheets nach.

> [!INFO] Dein Router ist das Tor nach draußen
> Im Heimnetz haben Geräte private Adressen (z. B. `192.168.1.20`). Der Router übersetzt sie per **NAT** in seine eine öffentliche Adresse.

## Schichten: Wer macht was?

| Schicht | Aufgabe | Beispiel |
|---|---|---|
| Anwendung | Was wird gesagt? | HTTP, DNS, SMTP |
| Transport | Zuverlässig zustellen, Ports | TCP, UDP |
| Internet | Weg durchs Netz finden | IP, ICMP |
| Netzzugang | Bits auf das Kabel/Funk bringen | Ethernet, WLAN |

Jede Schicht packt die Daten der Schicht darüber in einen eigenen „Umschlag“ (**Kapselung**). Beim Empfänger wird wieder ausgepackt.

## Tiefer eingetaucht

Wo kann ein Angreifer auf dieser Reise eingreifen?

- **DNS-Manipulation** – falsche Adresse, du landest auf einer gefälschten Seite.
- **Mitlesen im WLAN** – ohne Verschlüsselung sind Inhalte sichtbar; TLS schützt davor.
- **Man-in-the-Middle** – jemand schaltet sich zwischen dich und den Server. Zertifikate helfen, das zu erkennen.
- **Server-Schwachstellen** – die Website selbst kann fehlerhaft sein.

Deshalb ist HTTPS so wichtig: Es sorgt für Vertraulichkeit (verschlüsselt), Integrität (unverändert) und Authentizität (Zertifikat bestätigt den Server).

## Quiz

? Welcher Dienst übersetzt Namen wie example.com in IP-Adressen?
= DNS
! Das Domain Name System ist das „Telefonbuch“ des Internets.

? Welcher Port wird standardmäßig für HTTPS verwendet?
= 443
! HTTP nutzt Port 80, HTTPS Port 443.

?order Bringe die Schritte beim Aufruf einer Website in die richtige Reihenfolge.
> DNS-Auflösung
> TCP-Verbindung aufbauen
> TLS aushandeln
> HTTP-Anfrage senden
! Erst die Adresse finden, dann verbinden, dann verschlüsseln, dann anfragen.

? Was macht NAT im Heimrouter?
+ übersetzt private Adressen in die öffentliche Adresse des Routers
- verschlüsselt den Datenverkehr
- löst Namen in Adressen auf
- blockiert alle Angriffe
! Network Address Translation lässt viele Geräte über eine öffentliche IP-Adresse ins Internet.

? Wie nennt man das Einpacken der Daten jeder Schicht in einen eigenen Umschlag?
= Kapselung
= Encapsulation
! Jede Schicht fügt ihren Header hinzu; der Empfänger entfernt sie in umgekehrter Reihenfolge.

?tf HTTPS schützt auch davor, dass die Website selbst Sicherheitslücken hat.
= falsch
! HTTPS schützt nur den Transportweg. Fehler in der Anwendung bleiben bestehen.

? Auf welcher Schicht arbeiten Router hauptsächlich?
+ Internet-/Vermittlungsschicht (IP)
- Anwendungsschicht
- Transportschicht
- Darstellungsschicht
! Router entscheiden anhand der IP-Zieladresse, wohin ein Paket weitergeleitet wird.

? Welche drei Dinge stellt HTTPS sicher?
+ Vertraulichkeit
+ Integrität
+ Authentizität des Servers
- Verfügbarkeit
! Verfügbarkeit kann HTTPS nicht garantieren – ein überlasteter Server bleibt unerreichbar.

@@@ MODULE @@@
---
id: es-03
title: Erste Schritte 3 · Computer von innen
paths: grundlagen, cjca
order: 0.13
difficulty: easy
icon: cpu
tags: einstieg, hardware
summary: CPU, Arbeitsspeicher, Festplatte, Betriebssystem und Prozesse – was in einem Computer passiert und warum das für Sicherheit wichtig ist.
---

## Einfach erklärt

Ein Computer ist wie eine Küche:

- Die **CPU** ist der Koch – sie führt Anweisungen aus, sehr schnell, aber immer nur das, was im Rezept steht.
- Der **Arbeitsspeicher (RAM)** ist die Arbeitsfläche – schnell erreichbar, aber nach Feierabend (Ausschalten) leer.
- Die **Festplatte/SSD** ist die Speisekammer – langsamer, aber der Inhalt bleibt.
- Das **Betriebssystem** ist der Küchenchef – es entscheidet, wer wann an den Herd darf.

## Programme und Prozesse

Ein **Programm** ist eine Datei auf der Festplatte. Wird es gestartet, lädt das Betriebssystem es in den RAM – jetzt ist es ein **Prozess** mit eigener Kennung (PID), eigenem Speicherbereich und den Rechten des Benutzers, der es gestartet hat.

> [!MERKE] Rechte vererben sich
> Ein Prozess darf grundsätzlich das, was sein Benutzer darf. Läuft ein Browser als Administrator, hat auch eine bösartige Webseite im Erfolgsfall Administratorrechte. Deshalb arbeitet man im Alltag als normaler Benutzer.

## Kernel und Benutzermodus

Das Betriebssystem trennt zwei Bereiche:

| Bereich | Wer läuft dort | Darf |
|---|---|---|
| Kernel-Modus | Kern des Betriebssystems, Treiber | alles: Hardware, gesamter Speicher |
| Benutzermodus | normale Programme | nur eigenen Speicher, Hardware über Systemaufrufe |

Will ein Programm eine Datei lesen, bittet es den Kernel per **Systemaufruf**. Der Kernel prüft die Berechtigungen und führt die Aktion aus.

## Tiefer eingetaucht

Warum das für Sicherheit zählt:

- **Speicherforensik**: Was nur im RAM liegt (laufende Schadsoftware, entschlüsselte Schlüssel), ist nach dem Ausschalten weg. Ermittler sichern deshalb oft zuerst den Arbeitsspeicher.
- **Rootkits** versuchen, sich im Kernel einzunisten, weil sie dort alles sehen und sich vor Virenscannern verstecken können.
- **Speicherfehler** in Programmen (z. B. Pufferüberläufe) können dazu führen, dass fremder Code ausgeführt wird. Schutzmechanismen wie ASLR und DEP erschweren das.
- **Firmware** (UEFI/BIOS) startet noch vor dem Betriebssystem. Secure Boot prüft, ob der Startvorgang unverändert ist.

## Quiz

? Welche Komponente verliert ihren Inhalt beim Ausschalten?
+ Arbeitsspeicher (RAM)
- SSD
- Festplatte
- Firmware-Chip
! RAM ist flüchtig – deshalb ist er für die Forensik so wertvoll und so vergänglich.

? Wie nennt man ein laufendes Programm?
= Prozess
! Ein Prozess hat eine PID, eigenen Speicher und die Rechte seines Benutzers.

?tf Ein Prozess hat grundsätzlich die Rechte des Benutzers, der ihn gestartet hat.
= wahr
! Deshalb sollte man im Alltag nicht als Administrator arbeiten.

? In welchem Modus laufen Gerätetreiber?
+ Kernel-Modus
- Benutzermodus
- Gastmodus
- Sandbox-Modus
! Treiber brauchen Hardwarezugriff und laufen daher privilegiert – Fehler dort sind besonders kritisch.

? Wie fragt ein normales Programm beim Kernel z. B. nach dem Öffnen einer Datei?
= Systemaufruf
= Syscall
= system call
! Über Systemaufrufe wechselt die Kontrolle kontrolliert in den Kernel, der die Rechte prüft.

? Was prüft Secure Boot?
+ ob der Startvorgang mit signierter, unveränderter Software erfolgt
- ob das Passwort sicher ist
- ob Updates installiert sind
- ob die Festplatte verschlüsselt ist
! Secure Boot verhindert, dass manipulierte Bootloader oder Kernel unbemerkt starten.

? Warum sichern Forensiker oft zuerst den Arbeitsspeicher?
+ weil flüchtige Spuren beim Ausschalten verloren gehen
- weil RAM größer als die Festplatte ist
- weil Festplatten nicht kopiert werden dürfen
- weil RAM verschlüsselt ist
! Laufende Prozesse, Netzwerkverbindungen und Schlüssel existieren oft nur im RAM.

@@@ MODULE @@@
---
id: es-04
title: Erste Schritte 4 · Benutzer, Rechte und das Prinzip der geringsten Rechte
paths: grundlagen, cjca, specialist
order: 0.14
difficulty: easy
icon: person.badge.key.fill
tags: einstieg, berechtigungen
summary: Warum nicht jeder alles darf – Benutzerkonten, Gruppen, Administratoren und Least Privilege verständlich erklärt.
---

## Einfach erklärt

In einem Hotel bekommt jeder Gast eine Schlüsselkarte, die nur sein Zimmer öffnet. Das Reinigungspersonal hat Karten für mehrere Zimmer, der Hausmeister für die Technikräume, und nur die Direktion hat einen Generalschlüssel.

Genau so funktionieren Rechte in der IT: **Jeder bekommt nur die Zugänge, die er für seine Aufgabe braucht.** Das nennt man das **Prinzip der geringsten Rechte** (Least Privilege).

## Konten, Gruppen, Rechte

- **Benutzerkonto** – eine Identität (Person oder Dienst) mit Anmeldedaten.
- **Gruppe** – Sammlung von Konten, damit man Rechte nicht einzeln vergeben muss („Buchhaltung“, „Admins“).
- **Berechtigung** – was ein Konto mit einer Ressource tun darf: lesen, schreiben, ausführen, löschen.

> [!TIPP] Rechte über Gruppen vergeben
> Wer Rechte direkt an Einzelpersonen vergibt, verliert schnell den Überblick. Rollen bzw. Gruppen machen Rechte nachvollziehbar und leicht entziehbar.

## Administratoren

Admin-Konten (Windows: Administrator, Linux: `root`) dürfen fast alles. Gute Praxis:

1. Getrennte Konten: ein normales für E-Mail und Web, ein Admin-Konto nur für Verwaltung.
2. Admin-Rechte nur bei Bedarf und zeitlich begrenzt (**Just-in-Time**).
3. Admin-Konten besonders schützen: starke MFA, keine Nutzung auf unsicheren Geräten.
4. Regelmäßig prüfen, wer welche Rechte hat (**Rezertifizierung**).

## Tiefer eingetaucht

Rechte sammeln sich mit der Zeit an – man spricht von **Rechte-Akkumulation**: Wer die Abteilung wechselt, behält oft alte Zugänge. Saubere Prozesse dafür heißen **Joiner – Mover – Leaver**: Rechte beim Eintritt vergeben, beim Wechsel anpassen, beim Austritt sofort entziehen.

Angreifer nutzen genau diese Lücken: Nach dem Einbruch in ein normales Konto suchen sie nach Wegen zu mehr Rechten (**Rechteausweitung**). Je weniger Rechte jedes Konto hat, desto schwerer wird das.

Weitere Konzepte:

- **Need-to-know** – Zugriff auf Informationen nur, wenn man sie für die Aufgabe kennen muss.
- **Funktionstrennung** (Separation of Duties) – kritische Vorgänge brauchen zwei Personen (z. B. Zahlung anlegen und freigeben).
- **Dienstkonten** – Konten für Programme; sie sollten ebenfalls minimal berechtigt und nicht interaktiv nutzbar sein.

## Quiz

? Wie heißt das Prinzip, nur die nötigsten Rechte zu vergeben?
= Least Privilege
= Prinzip der geringsten Rechte
= geringste Rechte
! Least Privilege begrenzt den Schaden, wenn ein Konto kompromittiert wird.

? Warum sollten Administratoren ein separates Konto für den Alltag nutzen?
+ damit Schadsoftware aus E-Mail oder Web nicht sofort Admin-Rechte erhält
- weil Admin-Konten kein Internet haben
- weil es Lizenzkosten spart
- weil Admin-Konten keine E-Mails empfangen können
! Prozesse erben die Rechte des Benutzers. Ein Klick als Admin kann das ganze System kosten.

?order Bringe den Lebenszyklus von Zugriffsrechten in die richtige Reihenfolge.
> Joiner
> Mover
> Leaver
! Eintritt, Wechsel, Austritt – bei jedem Schritt müssen Rechte angepasst werden.

?tf Funktionstrennung bedeutet, dass kritische Vorgänge von mehr als einer Person durchgeführt werden.
= wahr
! Beispiel: Eine Person legt die Zahlung an, eine andere gibt sie frei.

? Was ist der Vorteil, Rechte über Gruppen zu vergeben?
+ Rechte bleiben nachvollziehbar und lassen sich zentral ändern
- Gruppen brauchen kein Passwort
- Gruppen sind immer Administratoren
- Gruppen verhindern Phishing
! Rollenbasierte Vergabe (RBAC) ist übersichtlicher als Einzelrechte.

? Wie nennt man Admin-Rechte, die nur bei Bedarf und zeitlich begrenzt vergeben werden?
= Just-in-Time
= JIT
= Just in Time
! JIT-Zugriff verkürzt die Zeit, in der mächtige Rechte missbraucht werden können.

? Wie heißt das Linux-Konto mit allen Rechten?
= root
! root hat die UID 0 und unterliegt praktisch keinen Beschränkungen.

@@@ MODULE @@@
---
id: es-05
title: Erste Schritte 5 · Passwörter, Passkeys und MFA
paths: grundlagen, cjca, specialist
order: 0.15
difficulty: easy
icon: key.fill
tags: einstieg, authentifizierung
summary: Wie Anmeldung funktioniert, warum lange Passwörter besser als komplizierte sind, was MFA bringt und warum Passkeys Phishing ausbremsen.
---

## Einfach erklärt

Anmelden heißt beweisen, wer du bist. Dafür gibt es drei Arten von Beweisen:

- **Etwas, das du weißt** – Passwort, PIN.
- **Etwas, das du hast** – Smartphone, Sicherheitsschlüssel, Chipkarte.
- **Etwas, das du bist** – Fingerabdruck, Gesicht.

Kombiniert man zwei verschiedene Arten, spricht man von **Zwei-Faktor-** oder **Multi-Faktor-Authentifizierung (MFA)**. Ein gestohlenes Passwort allein reicht dann nicht mehr.

## Gute Passwörter

- **Länge schlägt Komplexität**: `Kaffee-Fahrrad-Wolke-Tisch` ist stärker und merkbarer als `P@ssw0rt1`.
- **Einzigartig pro Dienst**: Wird ein Dienst gehackt, probieren Angreifer die Daten überall (**Credential Stuffing**).
- **Passwortmanager** erzeugen und speichern zufällige Passwörter – man merkt sich nur noch ein Masterpasswort.

> [!WARNUNG] Wiederverwendung ist das größte Risiko
> Nicht das „zu einfache“ Passwort ist meist das Problem, sondern dasselbe Passwort für viele Dienste.

## MFA-Varianten im Vergleich

| Verfahren | Sicherheit | Bemerkung |
|---|---|---|
| SMS-Code | gering bis mittel | abfangbar, SIM-Swapping |
| App-Code (TOTP) | mittel | phishbar, wenn man den Code auf einer Fake-Seite eingibt |
| Push mit Zahlenabgleich | mittel bis hoch | schützt gegen „Push-Bombing“ |
| FIDO2-Schlüssel / Passkey | hoch | phishing-resistent |

## Tiefer eingetaucht

Warum sind **Passkeys** (FIDO2/WebAuthn) phishing-resistent? Beim Registrieren erzeugt das Gerät ein Schlüsselpaar **nur für genau diese Website**. Bei der Anmeldung signiert es eine Herausforderung des Servers – und der Browser bindet diese an die echte Domain. Eine gefälschte Seite mit anderer Domain bekommt keine gültige Signatur. Es gibt kein Geheimnis, das man abtippen und weitergeben könnte.

Server speichern Passwörter idealerweise nie im Klartext, sondern als **gesalzenen, langsamen Hash** (z. B. Argon2, bcrypt). So sind sie bei einem Datenleck nicht direkt nutzbar.

Typische Angriffe auf Anmeldungen: **Password Spraying** (ein häufiges Passwort gegen viele Konten), **Brute Force**, **Phishing**, **MFA-Fatigue**. Abwehr: Kontosperren mit Bedacht, Rate-Limits, Anmeldeüberwachung, phishing-resistente MFA.

## Quiz

? Welche drei Faktor-Kategorien gibt es bei der Authentifizierung?
+ Wissen
+ Besitz
+ Biometrie (Sein)
- Standort
! Wissen, Besitz, Inhärenz. Standort ist höchstens ein zusätzliches Risikosignal.

? Was ist meist das größere Risiko?
+ dasselbe Passwort bei vielen Diensten
- ein langes Passwort ohne Sonderzeichen
- ein Passwortmanager
- ein Passkey
! Wiederverwendete Passwörter werden durch Credential Stuffing massenhaft ausgenutzt.

? Wie heißt der Angriff, bei dem geleakte Zugangsdaten automatisiert bei anderen Diensten ausprobiert werden?
= Credential Stuffing
! Einzigartige Passwörter pro Dienst machen diesen Angriff wirkungslos.

?tf Passkeys sind phishing-resistent, weil die Signatur an die echte Domain gebunden ist.
= wahr
! Eine gefälschte Domain erhält keine gültige Anmeldung.

? Welche MFA-Methode gilt als am wenigsten sicher?
+ SMS-Code
- FIDO2-Sicherheitsschlüssel
- Passkey
- Push mit Zahlenabgleich
! SMS kann abgefangen oder per SIM-Swapping umgeleitet werden.

? Wie heißt der Angriff, bei dem ein Passwort gegen viele Konten getestet wird?
= Password Spraying
! Er umgeht Kontosperren, weil pro Konto nur wenige Versuche erfolgen.

? Welches Verfahren eignet sich zum Speichern von Passwörtern auf einem Server?
+ Argon2
- MD5
- Base64
- AES ohne Schlüsselverwaltung
! Argon2 ist ein absichtlich langsamer, gesalzener Passwort-Hash. MD5 ist zu schnell, Base64 ist gar kein Schutz.

? Was ist ein Passwortmanager?
+ Programm, das zufällige Passwörter erzeugt und verschlüsselt speichert
- ein Dienst, der Passwörter per SMS verschickt
- eine Regel für Sonderzeichen
- eine Liste aller gehackten Passwörter
! Man merkt sich nur noch das Masterpasswort – idealerweise mit MFA geschützt.

@@@ MODULE @@@
---
id: es-06
title: Erste Schritte 6 · Schadsoftware-Arten einfach erklärt
paths: grundlagen, cjca, cdsa
order: 0.16
difficulty: easy
icon: ladybug.fill
tags: einstieg, malware
summary: Virus, Wurm, Trojaner, Ransomware, Spyware, Rootkit und Botnetz – was sie unterscheidet, wie sie sich verbreiten und wie man sich schützt.
---

## Einfach erklärt

Schadsoftware (**Malware**) ist ein Sammelbegriff für Programme, die etwas tun, das der Besitzer des Geräts nicht will. Man unterscheidet sie vor allem danach, **wie sie sich verbreiten** und **was sie anrichten**:

- Ein **Virus** hängt sich an andere Dateien – wie eine Grippe, die Wirtszellen braucht.
- Ein **Wurm** verbreitet sich selbstständig übers Netz – wie ein Lauffeuer.
- Ein **Trojaner** tarnt sich als nützliches Programm – wie das Holzpferd vor Troja.

## Die wichtigsten Arten

| Art | Was sie tut |
|---|---|
| Ransomware | verschlüsselt Daten und erpresst Lösegeld, oft zusätzlich mit Veröffentlichung gestohlener Daten |
| Spyware / Infostealer | spioniert aus: Passwörter, Cookies, Krypto-Wallets |
| Keylogger | zeichnet Tastatureingaben auf |
| Rootkit | versteckt sich und andere Malware tief im System |
| Backdoor / RAT | verschafft dauerhaften Fernzugriff |
| Bot | macht das Gerät zum Teil eines **Botnetzes**, das z. B. DDoS-Angriffe ausführt |
| Adware | zwingt Werbung auf, oft Einfallstor für Schlimmeres |
| Cryptominer | nutzt fremde Rechenleistung zum Schürfen von Kryptowährung |

## Wie Malware hereinkommt

1. **E-Mail-Anhänge und Links** (Phishing) – der häufigste Weg.
2. **Ausnutzen von Sicherheitslücken** in ungepatchter Software.
3. **Raubkopien und manipulierte Downloads**.
4. **USB-Sticks** und andere Datenträger.
5. **Gestohlene Zugangsdaten** für Fernzugänge.

> [!MERKE] Schutz in drei Sätzen
> Updates zeitnah installieren. Nicht auf Unerwartetes klicken. Offline-Backups haben – dann ist auch Ransomware kein Weltuntergang.

## Tiefer eingetaucht

Moderne Angriffe nutzen oft **keine klassische Schadsoftware-Datei** mehr, sondern Bordmittel des Systems (PowerShell, WMI) – man spricht von **Living off the Land**. Virenscanner, die nur Dateisignaturen vergleichen, sehen davon wenig. Deshalb setzen Unternehmen **EDR** ein: Es beobachtet Verhalten (welcher Prozess startet welchen, wer greift auf LSASS zu) statt nur Dateien.

Ransomware-Gruppen arbeiten heute arbeitsteilig: **Initial Access Broker** verkaufen Zugänge, Affiliates führen den Angriff aus, Betreiber stellen die Software (**Ransomware as a Service**). Vor der Verschlüsselung werden Daten gestohlen (**Double Extortion**) und Backups gezielt gelöscht.

## Quiz

? Welche Malware verbreitet sich selbstständig über das Netzwerk?
+ Wurm
- Trojaner
- Adware
- Keylogger
! Würmer brauchen keinen Wirt und keine Nutzerinteraktion.

? Welche Malware tarnt sich als nützliches Programm?
= Trojaner
= Trojanisches Pferd
! Der Name stammt vom Trojanischen Pferd der griechischen Sage.

? Was tut Ransomware?
+ verschlüsselt Daten und fordert Lösegeld
- zeigt nur Werbung an
- beschleunigt den Rechner
- repariert Systemdateien
! Moderne Ransomware stiehlt zusätzlich Daten (Double Extortion).

? Wie nennt man ein Netz aus ferngesteuerten, infizierten Geräten?
= Botnetz
= Botnet
! Botnetze werden für DDoS, Spam und weitere Angriffe vermietet.

?tf Living-off-the-Land-Angriffe nutzen vorhandene Systemwerkzeuge statt eigener Schadsoftware-Dateien.
= wahr
! Beispiele sind PowerShell, WMI oder certutil – deshalb ist Verhaltensanalyse so wichtig.

? Was ist der häufigste Infektionsweg?
+ Phishing-E-Mails
- Bluetooth
- Druckertreiber
- Bildschirmschoner
! Die meisten Angriffe beginnen mit einer E-Mail oder einem Link.

? Welche Maßnahme macht Ransomware am wenigsten bedrohlich?
+ getestete Offline-Backups
- ein langes WLAN-Passwort
- ein Bildschirmschoner mit Passwort
- Inkognito-Modus im Browser
! Mit einem unveränderlichen Backup lassen sich Daten ohne Lösegeld wiederherstellen.

? Was beobachtet ein EDR im Unterschied zu einem klassischen Virenscanner vor allem?
+ das Verhalten von Prozessen
- nur die Dateigröße
- die Bildschirmhelligkeit
- ausschließlich E-Mail-Anhänge
! EDR erkennt verdächtige Abläufe, auch wenn keine bekannte Schaddatei beteiligt ist.

@@@ MODULE @@@
---
id: es-07
title: Erste Schritte 7 · Phishing und Social Engineering erkennen
paths: grundlagen, cjca, cdsa, specialist
order: 0.17
difficulty: easy
icon: envelope.badge.shield.half.filled
tags: einstieg, phishing
summary: Wie Betrüger Menschen manipulieren, woran man Phishing erkennt und was man tut, wenn man doch geklickt hat.
---

## Einfach erklärt

Beim **Social Engineering** wird nicht der Computer gehackt, sondern der Mensch. Betrüger nutzen Gefühle, die uns schnell handeln lassen:

- **Druck**: „Ihr Konto wird in 24 Stunden gesperrt!“
- **Autorität**: „Hier ist der Geschäftsführer, ich brauche sofort eine Überweisung.“
- **Neugier**: „Gehaltsliste 2026.xlsx“
- **Hilfsbereitschaft**: „Ich bin vom IT-Support, können Sie mir kurz Ihren Code nennen?“

**Phishing** ist die bekannteste Form: gefälschte E-Mails, SMS (Smishing) oder Anrufe (Vishing), die zu Klicks, Downloads oder Datenpreisgabe verleiten.

## Woran man Phishing erkennt

1. **Absender prüfen** – nicht den Anzeigenamen, sondern die echte Adresse (`service@paypa1-secure.com`).
2. **Link prüfen** – vor dem Klick mit der Maus darüberfahren bzw. lange drücken: Wohin führt er wirklich?
3. **Ungewöhnliche Bitte** – Passwort, Code, Geschenkkarten, Kontoänderung?
4. **Zeitdruck oder Drohung**.
5. **Kontext** – erwarte ich diese Nachricht überhaupt?

> [!TIPP] Zweiter Kanal
> Bei Zweifeln den Absender über einen **bekannten** Weg kontaktieren – nicht über die Nummer oder den Link in der Nachricht.

## Ich habe geklickt – was jetzt?

- Ruhe bewahren und **sofort melden** (IT-Sicherheit, Vorgesetzte). Schnelligkeit zählt mehr als Scham.
- Wurde ein Passwort eingegeben: **sofort ändern**, überall wo es genutzt wurde.
- Wurde etwas heruntergeladen oder ausgeführt: Gerät vom Netz trennen, nicht weiterarbeiten.
- Bei Bankdaten: Bank informieren.

## Tiefer eingetaucht

Professionelle Varianten:

- **Spear Phishing** – zielgerichtet, mit recherchierten Details (Name des Chefs, aktuelle Projekte).
- **Business E-Mail Compromise (BEC)** – Betrug über echte, übernommene Postfächer oder täuschend ähnliche Domains; oft geht es um geänderte Bankverbindungen.
- **Adversary-in-the-Middle-Phishing** – ein Proxy zwischen Opfer und echter Login-Seite stiehlt das Sitzungs-Cookie und umgeht damit klassische MFA. Abwehr: phishing-resistente Verfahren wie Passkeys.
- **QR-Code-Phishing (Quishing)** – der Link steckt im Bild und umgeht Link-Filter.

Technische Gegenmaßnahmen: SPF, DKIM und DMARC gegen Absenderfälschung, Link-Umschreibung und Sandboxing im Mail-Gateway, Markierung externer Absender – und eine Meldekultur ohne Schuldzuweisung.

## Quiz

? Welche Manipulationstechnik nutzt „Ihr Konto wird in 24 Stunden gesperrt“?
+ Zeitdruck
- Neugier
- Gegenseitigkeit
- Sympathie
! Druck soll verhindern, dass man in Ruhe prüft.

? Wie nennt man Phishing per Telefonanruf?
= Vishing
! Voice Phishing – oft als angeblicher Support oder Bank.

? Was solltest du tun, wenn du auf einen Phishing-Link geklickt und dein Passwort eingegeben hast?
+ sofort melden und das Passwort überall ändern
- abwarten, ob etwas passiert
- die E-Mail löschen und vergessen
- den Rechner neu starten und weiterarbeiten
! Schnelles Melden begrenzt den Schaden.

?tf Der angezeigte Absendername einer E-Mail beweist, wer sie geschickt hat.
= falsch
! Anzeigenamen sind frei wählbar. Entscheidend ist die tatsächliche Adresse und Domain.

? Wie heißt zielgerichtetes Phishing mit recherchierten persönlichen Details?
= Spear Phishing
= Spear-Phishing
! Je persönlicher, desto glaubwürdiger – und gefährlicher.

? Welche Methode hilft gegen Adversary-in-the-Middle-Phishing am besten?
+ Passkeys / FIDO2
- längere Passwörter
- SMS-Codes
- häufigeres Passwortwechseln
! AiTM-Proxys können Codes und Cookies abgreifen, aber keine domain-gebundene FIDO2-Signatur.

? Welche Verfahren schützen gegen gefälschte Absenderdomains?
+ SPF
+ DKIM
+ DMARC
- NTP
! SPF, DKIM und DMARC prüfen, ob eine E-Mail wirklich von der angegebenen Domain stammen darf.

? Was ist bei Business E-Mail Compromise typischerweise das Ziel?
+ eine Überweisung auf ein falsches Konto auszulösen
- den Mailserver zu verschlüsseln
- Werbung zu verschicken
- das WLAN zu stören
! BEC-Betrug verursacht weltweit enorme Schäden, oft ganz ohne Schadsoftware.

@@@ MODULE @@@
---
id: es-08
title: Erste Schritte 8 · Updates, Backups und die 3-2-1-Regel
paths: grundlagen, cjca, specialist
order: 0.18
difficulty: easy
icon: arrow.triangle.2.circlepath.circle.fill
tags: einstieg, betrieb
summary: Warum Updates die wichtigste Schutzmaßnahme sind und wie ein Backup aussieht, das auch einen Ransomware-Angriff übersteht.
---

## Einfach erklärt

Software ist nie fehlerfrei. Wird ein Fehler entdeckt, veröffentlicht der Hersteller ein **Update** (Patch) – wie eine Reparatur am Türschloss. Ab dem Moment, in dem die Reparatur veröffentlicht ist, wissen aber auch Angreifer, wo das Schloss schwach war. Wer nicht aktualisiert, hat also eine **öffentlich bekannte** Schwachstelle.

Ein **Backup** ist die Versicherung für den Fall, dass trotzdem etwas schiefgeht: Festplatte kaputt, Laptop gestohlen, Ransomware.

## Die 3-2-1-Regel

- **3** Kopien der Daten (Original + 2 Sicherungen),
- auf **2** verschiedenen Medien,
- davon **1** außer Haus bzw. offline.

Moderne Erweiterung: **3-2-1-1-0** – zusätzlich eine **unveränderliche** (immutable) Kopie und **0** Fehler beim Wiederherstellungstest.

> [!GEFAHR] Ein Backup, das nie getestet wurde, ist eine Hoffnung
> Viele merken erst im Ernstfall, dass Sicherungen unvollständig oder nicht wiederherstellbar sind.

## Arten von Backups

| Art | Was wird gesichert | Vorteil | Nachteil |
|---|---|---|---|
| Vollsicherung | alles | einfache Wiederherstellung | groß, langsam |
| Inkrementell | Änderungen seit der letzten Sicherung | schnell, klein | Wiederherstellung braucht die ganze Kette |
| Differenziell | Änderungen seit der letzten Vollsicherung | Kompromiss | wächst mit der Zeit |

## Tiefer eingetaucht

**Patch-Management** in Unternehmen ist ein Prozess: Inventar kennen → Schwachstellen bewerten → priorisieren → testen → verteilen → kontrollieren. Priorisiert wird nicht nur nach CVSS-Wert, sondern danach, ob eine Lücke **aktiv ausgenutzt** wird (z. B. CISA-KEV-Liste) oder wie wahrscheinlich das ist (EPSS).

Für Backups zählen zwei Kennzahlen:

- **RPO** (Recovery Point Objective) – wie viel Datenverlust ist tolerierbar? (z. B. maximal 4 Stunden)
- **RTO** (Recovery Time Objective) – wie schnell muss das System wieder laufen?

Ransomware-Angreifer suchen gezielt Backup-Server und löschen Sicherungen. Schutz: getrennte Anmeldedaten, Offline- oder WORM-Speicher, Backup-Netz segmentieren, Alarm bei Massenlöschungen.

## Quiz

? Was bedeutet die „1“ in der 3-2-1-Regel?
+ eine Kopie außer Haus bzw. offline
- ein Backup pro Tag
- ein Medium reicht
- eine Person ist verantwortlich
! Eine räumlich getrennte oder offline Kopie übersteht Brand, Diebstahl und Ransomware.

? Welche Backup-Art sichert nur die Änderungen seit der letzten Sicherung (egal welcher Art)?
= inkrementell
= inkrementelles Backup
! Inkrementell ist schnell, die Wiederherstellung braucht aber alle Teilsicherungen.

?tf Sobald ein Patch veröffentlicht ist, sinkt das Risiko für ungepatchte Systeme.
= falsch
! Im Gegenteil: Die Lücke ist jetzt öffentlich bekannt und wird oft schnell ausgenutzt.

? Welche Kennzahl beschreibt den maximal tolerierbaren Datenverlust?
= RPO
= Recovery Point Objective
! RPO = wie weit man zurückfallen darf; RTO = wie lange der Ausfall dauern darf.

? Was bedeutet „immutable“ bei Backups?
+ die Sicherung kann für eine Zeit nicht verändert oder gelöscht werden
- die Sicherung ist komprimiert
- die Sicherung ist unverschlüsselt
- die Sicherung liegt in der Cloud
! Unveränderliche Backups schützen davor, dass Angreifer die Sicherungen löschen.

? Wonach sollte man Patches zusätzlich zum CVSS-Wert priorisieren?
+ ob die Lücke aktiv ausgenutzt wird
- nach dem Alphabet
- nach der Dateigröße des Updates
- nach dem Erscheinungsdatum des Produkts
! Listen wie CISA KEV zeigen, welche Lücken tatsächlich angegriffen werden.

?order Bringe den Patch-Management-Prozess in die richtige Reihenfolge.
> Inventar erfassen
> Schwachstellen bewerten
> Patches testen
> Patches verteilen
> Erfolg kontrollieren
! Ohne Inventar weiß man nicht, was zu patchen ist; ohne Kontrolle nicht, ob es geklappt hat.

@@@ MODULE @@@
---
id: es-09
title: Erste Schritte 9 · Schwachstelle, Exploit, Risiko – Begriffe sauber trennen
paths: grundlagen, cjca, cpts, specialist
order: 0.19
difficulty: easy
icon: exclamationmark.shield.fill
tags: einstieg, begriffe
summary: Bedrohung, Schwachstelle, Exploit, Angriff, Vorfall, Risiko – die Grundbegriffe, die in jedem Bericht und jeder Prüfung auftauchen.
---

## Einfach erklärt

Bleiben wir beim Haus:

- Ein **Einbrecher** in der Gegend ist die **Bedrohung**.
- Ein gekipptes Fenster ist die **Schwachstelle**.
- Die Technik, das gekippte Fenster von außen zu öffnen, ist der **Exploit**.
- Wenn er es tatsächlich versucht, ist das ein **Angriff**.
- Wenn er drin war, ist es ein **Sicherheitsvorfall**.
- Wie wahrscheinlich und wie teuer das wäre, beschreibt das **Risiko**.

## Die Begriffe im Detail

| Begriff | Bedeutung |
|---|---|
| Asset | etwas Schützenswertes: Daten, Systeme, Ruf |
| Bedrohung | mögliche Ursache eines Schadens (Angreifer, Feuer, Fehler) |
| Schwachstelle | Schwäche, die eine Bedrohung ausnutzen kann |
| Exploit | konkreter Code oder Technik zum Ausnutzen einer Schwachstelle |
| Angriff | Versuch, eine Schwachstelle auszunutzen |
| Vorfall | Ereignis, das Schutzziele tatsächlich verletzt |
| Risiko | Wahrscheinlichkeit × Auswirkung |
| Maßnahme | Vorkehrung, die Risiko senkt |

> [!EXAM] Typische Prüfungsfalle
> Eine Schwachstelle ohne passende Bedrohung oder ohne Erreichbarkeit ergibt ein **geringes** Risiko. Ein Risiko entsteht erst aus dem Zusammenspiel.

## Zero-Day und CVE

- **CVE** – eine eindeutige Nummer für eine öffentlich bekannte Schwachstelle, z. B. `CVE-2021-44228` (Log4Shell).
- **CVSS** – Bewertung der Schwere von 0 bis 10.
- **Zero-Day** – eine Schwachstelle, für die es noch keinen Patch gibt (der Hersteller hatte „null Tage“ Zeit).

## Tiefer eingetaucht

Mit Risiken kann man vier Dinge tun:

1. **Vermeiden** – die riskante Tätigkeit lassen.
2. **Vermindern** – Maßnahmen umsetzen.
3. **Übertragen** – z. B. Versicherung oder Dienstleister (die Verantwortung bleibt trotzdem!).
4. **Akzeptieren** – bewusst und dokumentiert durch die Leitung.

Das verbleibende Risiko nach allen Maßnahmen heißt **Restrisiko**. Im Pentest-Bericht wird jede gefundene Schwachstelle mit Risiko, Nachweis und Empfehlung beschrieben – deshalb ist saubere Begriffsarbeit wichtig: „Kritische Schwachstelle“ und „hohes Risiko“ sind nicht automatisch dasselbe.

## Quiz

? Ein gekipptes Fenster entspricht in der Analogie …
+ einer Schwachstelle
- einer Bedrohung
- einem Exploit
- einem Vorfall
! Die Schwachstelle ist die Schwäche selbst, unabhängig davon, ob jemand sie ausnutzt.

? Wie nennt man eine Schwachstelle, für die es noch keinen Patch gibt?
= Zero-Day
= Zero Day
= 0-Day
! Der Hersteller hatte „null Tage“, um zu reagieren.

? Was ist ein Exploit?
+ Code oder Technik, die eine Schwachstelle ausnutzt
- ein Sicherheitsupdate
- ein Virenscanner
- ein Risiko-Bericht
! Exploits machen aus einer theoretischen Schwäche einen praktischen Angriff.

? Welche Skala bewertet die Schwere einer Schwachstelle von 0 bis 10?
= CVSS
! Common Vulnerability Scoring System.

?tf Wer ein Risiko an eine Versicherung überträgt, gibt damit auch die Verantwortung vollständig ab.
= falsch
! Der finanzielle Schaden wird geteilt, die Verantwortung bleibt beim Unternehmen.

? Wie heißt das Risiko, das nach allen Maßnahmen übrig bleibt?
= Restrisiko
! Restrisiken müssen von der Leitung bewusst akzeptiert werden.

? Welche Strategien gibt es im Umgang mit Risiken?
+ vermeiden
+ vermindern
+ übertragen
+ akzeptieren
- ignorieren
! Ignorieren ist keine Strategie – Akzeptieren geschieht bewusst und dokumentiert.

? Wann spricht man von einem Sicherheitsvorfall?
+ wenn Schutzziele tatsächlich verletzt wurden
- sobald eine Schwachstelle existiert
- wenn ein Update verfügbar ist
- wenn ein Pentest geplant wird
! Nicht jeder Angriffsversuch ist ein Vorfall – erst die tatsächliche Verletzung.

@@@ MODULE @@@
---
id: es-10
title: Erste Schritte 10 · Logs – das Gedächtnis der Systeme
paths: grundlagen, cjca, cdsa
order: 0.2
difficulty: easy
icon: list.bullet.rectangle.portrait.fill
tags: einstieg, logging
summary: Was Protokolle sind, was darin steht, warum zentrale Sammlung und genaue Zeit wichtig sind und wie Analysten Logs lesen.
---

## Einfach erklärt

Ein **Log** ist ein Tagebuch, das ein System selbst schreibt: „Um 09:14 hat sich Anna angemeldet“, „Um 09:15 wurde die Datei bericht.docx gelöscht“, „Um 09:16 schlug eine Anmeldung von 203.0.113.5 fehl“.

Ohne Logs weiß man nach einem Vorfall nicht, **was passiert ist**. Mit Logs kann man den Ablauf rekonstruieren – wie Ermittler, die Überwachungskameras auswerten.

## Was in einem guten Logeintrag steht

| Feld | Beispiel |
|---|---|
| Zeit (am besten UTC) | 2026-11-22T09:14:03Z |
| Quelle | Server `web01` |
| Wer | Benutzer `anna` |
| Was | Anmeldung |
| Ergebnis | erfolgreich |
| Woher | IP `10.0.4.17` |

```text
Nov 22 09:14:03 web01 sshd[2231]: Accepted publickey for anna from 10.0.4.17 port 51022
Nov 22 09:16:44 web01 sshd[2290]: Failed password for root from 203.0.113.5 port 40112
```

## Warum zentral sammeln?

- Angreifer löschen lokale Logs, um Spuren zu verwischen.
- Ein Vorfall betrifft oft viele Systeme – erst zusammen ergibt sich ein Bild.
- Zentral kann man suchen, korrelieren und alarmieren. Das macht ein **SIEM**.

> [!MERKE] Zeit ist alles
> Alle Systeme brauchen synchronisierte Uhren (NTP). Sonst passen die Ereignisse verschiedener Systeme nicht zusammen.

## Tiefer eingetaucht

Analysten lesen Logs mit Fragen im Kopf: **Wer? Was? Wann? Wo? Wie oft? Ist das normal?** Ein einzelner Fehlversuch ist harmlos; 500 Fehlversuche in einer Minute von einer IP sind ein Angriffsmuster.

Wichtige Logquellen:

- **Windows-Ereignisprotokolle** (z. B. 4624 erfolgreiche, 4625 fehlgeschlagene Anmeldung)
- **Linux**: `/var/log/auth.log`, journald
- **Firewall- und Proxy-Logs**
- **Webserver-Zugriffslogs**
- **Cloud-Audit-Logs** (z. B. AWS CloudTrail)

Logs enthalten oft personenbezogene Daten – deshalb gelten Aufbewahrungsfristen und Zugriffsbeschränkungen (Datenschutz). Und: Logs müssen vor Manipulation geschützt werden, z. B. durch Weiterleitung an einen separaten, schreibgeschützten Speicher.

## Quiz

? In welcher Zeitzone sollten Logs idealerweise gespeichert werden?
= UTC
! UTC vermeidet Verwirrung durch Zeitzonen und Sommerzeit beim Vergleichen.

? Welches System sammelt und korreliert Logs zentral?
= SIEM
! Security Information and Event Management.

?tf Angreifer versuchen häufig, lokale Logs zu löschen.
= wahr
! Deshalb leitet man Logs zeitnah an ein zentrales, geschütztes System weiter.

? Welche Windows-Ereignis-ID steht für eine fehlgeschlagene Anmeldung?
= 4625
! 4624 = erfolgreich, 4625 = fehlgeschlagen.

? Warum ist NTP für die Loganalyse wichtig?
+ damit Zeitstempel verschiedener Systeme zusammenpassen
- weil es Logs verschlüsselt
- weil es Logs komprimiert
- weil es Angriffe blockiert
! Ohne synchrone Zeit lässt sich der Ablauf eines Vorfalls nicht rekonstruieren.

? Welche Datei enthält auf Debian/Ubuntu typischerweise SSH-Anmeldungen?
= /var/log/auth.log
= auth.log
! Unter RHEL-basierten Systemen heißt die Datei /var/log/secure.

? Was ist ein Hinweis auf einen Brute-Force-Angriff?
+ sehr viele fehlgeschlagene Anmeldungen in kurzer Zeit von einer Quelle
- eine erfolgreiche Anmeldung am Morgen
- ein Neustart nach Updates
- ein geänderter Bildschirmhintergrund
! Muster und Häufung sind wichtiger als Einzelereignisse.

@@@ MODULE @@@
---
id: es-11
title: Erste Schritte 11 · Sicher im Heimnetz
paths: grundlagen, wifi
order: 0.21
difficulty: easy
icon: house.fill
tags: einstieg, heimnetz
summary: Router, WLAN, smarte Geräte und Gastnetz – ein sicheres Heimnetz in einer Stunde einrichten und verstehen, warum jede Einstellung zählt.
---

## Einfach erklärt

Dein Router ist die Haustür deines digitalen Zuhauses. Alles, was ins Internet will, geht durch ihn. Deshalb lohnt es sich, ihn gut einzustellen – einmal gemacht, schützt er jahrelang.

## Die Checkliste

1. **Router-Passwort ändern** – das Standardpasswort steht oft auf dem Gehäuse oder im Internet.
2. **Firmware aktuell halten** – automatische Updates einschalten.
3. **WLAN mit WPA3** (oder mindestens WPA2-AES) und einem langen Passwort.
4. **WPS ausschalten** – die PIN-Methode ist angreifbar.
5. **Fernzugriff auf die Router-Oberfläche** aus dem Internet deaktivieren.
6. **UPnP** prüfen – es erlaubt Geräten, selbstständig Ports zu öffnen.
7. **Gastnetz** für Besucher und smarte Geräte nutzen.

> [!TIPP] Gastnetz für das smarte Zuhause
> Glühbirnen, Kameras und Fernseher bekommen selten lange Updates. Im Gastnetz können sie bei einer Kompromittierung nicht auf Laptops oder NAS zugreifen.

## Smarte Geräte

- Standardpasswörter immer ändern.
- Nur Geräte von Herstellern kaufen, die Updates garantieren.
- Funktionen abschalten, die man nicht braucht (Fernzugriff, Mikrofon).
- Alte Geräte ohne Updates ersetzen oder vom Netz nehmen.

## Tiefer eingetaucht

Was passiert technisch? Der Router macht **NAT**: Von außen ist zunächst nur der Router erreichbar; eingehende Verbindungen werden verworfen, solange keine **Portweiterleitung** besteht. Jede Portweiterleitung (z. B. für eine Kamera) macht ein Gerät direkt aus dem Internet angreifbar – Suchmaschinen wie Shodan finden solche Geräte in Minuten.

Bei IPv6 gibt es kein NAT im klassischen Sinn: Geräte haben global eindeutige Adressen. Der Schutz kommt hier von der **Firewall des Routers**, die eingehende Verbindungen standardmäßig blockieren sollte.

Wer mehr will: eigenes DNS mit Werbe- und Malware-Filter (z. B. Pi-hole), VLANs für Gerätegruppen, VPN für den sicheren Zugriff von unterwegs statt offener Ports.

## Quiz

? Welche WLAN-Verschlüsselung ist aktuell empfohlen?
+ WPA3
- WEP
- WPA (TKIP)
- offenes WLAN
! WPA3 nutzt SAE und schützt besser gegen Offline-Angriffe auf das Passwort.

? Warum sollte WPS deaktiviert werden?
+ die PIN-Methode ist angreifbar
- es verlangsamt das Internet
- es verbraucht Strom
- es verhindert Updates
! Die WPS-PIN lässt sich in vielen Implementierungen in kurzer Zeit erraten.

? Wie heißt die Funktion, mit der Geräte selbst Ports am Router öffnen können?
= UPnP
= Universal Plug and Play
! UPnP ist bequem, kann aber ungewollt Dienste ins Internet stellen.

?tf Eine Portweiterleitung macht das Zielgerät direkt aus dem Internet erreichbar.
= wahr
! Deshalb besser VPN statt offener Ports für den Fernzugriff.

? Wofür eignet sich das Gastnetz besonders?
+ für Besucher und smarte Geräte
- für das NAS mit Familienfotos
- für den Arbeitslaptop mit Firmendaten
- für die Router-Verwaltung
! So bleiben unsichere Geräte von wichtigen Daten getrennt.

? Welche Suchmaschine findet aus dem Internet erreichbare Geräte?
= Shodan
! Shodan indexiert offene Dienste weltweit – auch Webcams und Router.

? Was schützt Geräte bei IPv6, wenn es kein klassisches NAT gibt?
+ die Firewall des Routers
- die MAC-Adresse
- das WLAN-Passwort allein
- die SSID
! Eine Stateful Firewall blockiert unaufgeforderte eingehende Verbindungen.

@@@ MODULE @@@
---
id: es-12
title: Erste Schritte 12 · Hacking lernen – legal, ethisch, strukturiert
paths: grundlagen, cjca, cpts
order: 0.22
difficulty: easy
icon: graduationcap.fill
tags: einstieg, ethik, lernen
summary: Wie man Hacking und Verteidigung legal übt – eigene Labore, Plattformen, Recht, Ethik und eine Lernstrategie, die wirklich trägt.
---

## Einfach erklärt

Hacking zu lernen ist wie Kampfsport: Man trainiert im **Dojo** mit Partnern, die zugestimmt haben – nicht auf der Straße. In der IT heißt das: **nur Systeme angreifen, die dir gehören oder für die du eine schriftliche Erlaubnis hast.**

## Wo man legal übt

- **Eigenes Labor**: virtuelle Maschinen auf dem eigenen Rechner (z. B. ein absichtlich verwundbares System), getrennt vom Heimnetz.
- **Lernplattformen**: Hack The Box, TryHackMe und ähnliche stellen Übungsziele mit Erlaubnis bereit.
- **CTFs** (Capture the Flag): Wettbewerbe mit Rätseln aus Web, Krypto, Forensik.
- **Bug-Bounty-Programme**: Unternehmen erlauben Tests nach klaren Regeln (Scope beachten!).

> [!GEFAHR] Recht
> In Deutschland stellen u. a. §§ 202a–202c und § 303a/b StGB das unbefugte Eindringen, Abfangen von Daten und Computersabotage unter Strafe. „Nur mal schauen“ ist keine Ausrede.

## Ethik

- Erlaubnis vor Aktion – schriftlich, mit klarem Umfang.
- Keine Daten mitnehmen, die man nicht braucht; Funde vertraulich behandeln.
- Gefundene Lücken verantwortungsvoll melden (**Responsible/Coordinated Disclosure**).
- Keine Schäden verursachen: kein DoS, keine Datenzerstörung.

## Eine Lernstrategie, die trägt

1. **Grundlagen zuerst**: Netzwerke, Linux, Windows, Web. Ohne sie bleibt Hacking Rezepte-Nachkochen.
2. **Verstehen statt auswendig lernen**: Warum funktioniert eine Technik? Wie würde man sie erkennen und verhindern?
3. **Notizen**: Eigene Wissensdatenbank aufbauen.
4. **Wiederholen**: Spaced Repetition – genau dafür gibt es die Lernkartei in NIMA.
5. **Beide Seiten üben**: Wer Angriffe versteht, verteidigt besser – und umgekehrt.

## Tiefer eingetaucht

Professionelle Tests folgen festen Rahmenwerken: **Rules of Engagement** (was ist erlaubt, wann, wie wird kommuniziert), **Scope** (welche Systeme), Notfallkontakte und eine saubere Dokumentation jeder Aktion. Auch im eigenen Labor lohnt es sich, so zu arbeiten – das ist später im Job und in praktischen Prüfungen (z. B. CPTS) genau das, was zählt.

Ein häufiger Fehler beim Lernen ist das „Tutorial-Hopping“: Viele Anleitungen konsumieren, wenig selbst lösen. Besser: eine Aufgabe zuerst allein versuchen, festhängen, recherchieren, dann erst eine Lösung lesen – und danach aufschreiben, was man gelernt hat.

## Quiz

? Wann ist ein Sicherheitstest an einem fremden System erlaubt?
+ nur mit ausdrücklicher, am besten schriftlicher Erlaubnis
- wenn das System öffentlich erreichbar ist
- wenn man nichts kaputt macht
- wenn man die Lücke danach meldet
! Ohne Erlaubnis ist auch ein vorsichtiger Test strafbar.

? Wie heißt das geordnete Melden gefundener Schwachstellen an den Hersteller?
= Coordinated Disclosure
= Responsible Disclosure
! Hersteller bekommen Zeit für einen Patch, bevor Details veröffentlicht werden.

? Was legen die „Rules of Engagement“ fest?
+ was im Test erlaubt ist, Zeiten und Kommunikationswege
- die Preise für den Pentest
- die Programmiersprache des Kunden
- die Farben des Berichts
! RoE und Scope definieren den rechtlichen und praktischen Rahmen.

?tf CTF steht für Capture the Flag.
= wahr
! In CTFs findet man „Flags“ als Beweis für gelöste Aufgaben.

? Welcher Paragraf des StGB betrifft das Ausspähen von Daten?
= 202a
= § 202a
= §202a
! § 202a StGB: Ausspähen von Daten, § 202b: Abfangen, § 202c: Vorbereiten.

? Was ist der wichtigste Grundstein vor fortgeschrittenen Hacking-Techniken?
+ solide Grundlagen in Netzwerk, Betriebssystemen und Web
- möglichst viele Tools installieren
- teure Hardware
- ein eigener Hacker-Alias
! Ohne Grundlagen versteht man nicht, warum eine Technik funktioniert.

? Wie nennt man Programme, in denen Unternehmen zur Suche nach Lücken einladen und Funde belohnen?
= Bug Bounty
= Bug-Bounty-Programm
! Wichtig ist, sich strikt an den Scope und die Regeln des Programms zu halten.
