---
id: es-00
title: Start hier · Dein Weg durch NIMA
paths: grundlagen, cjca, cpts, cwes, cdsa, cwee, cape, wifi, specialist, cyberrange
order: 0
difficulty: easy
icon: flag.checkered
tags: einstieg, orientierung
summary: Wie NIMA aufgebaut ist, wie du mit Pfaden, Lernstufen, Wissens-Checks, Lernkartei und Skill-Liga am schnellsten und nachhaltigsten lernst.
---

## Einfach erklärt

Willkommen! NIMA ist wie ein Fitnessstudio für dein Sicherheitswissen: Es gibt Trainingspläne (**Pfade**), Übungen in steigender Schwierigkeit (**Lektionen** von „Einfach erklärt“ bis „Vertiefung“), Kontrollmessungen (**Wissens-Checks**, **Prüfungen**) und einen Trainer, der dich genau dann wiederholen lässt, wenn du kurz vor dem Vergessen bist (**Lernkartei**).

## So ist jedes Modul aufgebaut

| Stufe | Farbe | Inhalt |
|---|---|---|
| Einstieg | türkis | „Einfach erklärt“ – Alltagsbild, Grundidee |
| Kern | blau | das eigentliche Wissen, Tabellen, Beispiele |
| Vertiefung | violett | Details, Sonderfälle, Experten-Wissen |

Nach jeder Lektion fragt ein kurzer **Wissens-Check** 1–3 passende Fragen – direkt nach dem Lesen zu üben, ist eine der wirksamsten Lernmethoden.

## Dein Tagesrhythmus (15–30 Minuten)

1. **Empfehlung** auf der Startseite folgen (fällige Karten oder nächste Lektion).
2. Eine Lektion lesen + Wissens-Check.
3. Fällige Karten im Training wiederholen.
4. Tagesmissionen erfüllen – die Truhe wartet.

> [!TIPP] Fehler sind Futter
> Jede falsche Antwort landet im Fehlerbuch und kommt wieder – mit Erklärung und Link zur passenden Lektion. Lies bei Problemkarten nach, statt nur zu raten.

## Zwei Arten von Fortschritt

- **Rang (XP)** zeigt deinen Fleiß – jede Lektion, jede Antwort zählt.
- **Skill-Liga (Rating)** zeigt dein Können – schwere Fragen richtig = großer Sprung, leichte falsch = Abzug.

## Tiefer eingetaucht

Für Zertifikate gibt es eigene Lernpläne (Module „Lernplan“ in jedem Zertifikatspfad). Ein **Lernplan** mit Zieldatum rechnet aus, wie viele Lektionen du pro Tag brauchst. Und wenn dir ein Begriff fehlt: Jeder grün markierte Fachbegriff öffnet das **Lexikon** – im **Begriffe-Training** kannst du die Fachsprache gezielt üben.

## Quiz

? Welche drei Lernstufen hat jedes Modul?
+ Einstieg
+ Kern
+ Vertiefung
- Prüfung
! Von einfach nach tief.

? Was zeigt die Skill-Liga im Unterschied zum Rang?
+ dein tatsächliches Können anhand der Schwierigkeit beantworteter Fragen
- wie viele Tage du gelernt hast
- wie viele Credits du hast
- deine Bildschirmzeit
! Der Rang misst Fleiß, die Skill-Liga Können.

?tf Falsche Antworten kommen über die Lernkartei gezielt wieder.
= wahr
! Mit Erklärung und Link zur Lektion.

? Was passiert direkt nach dem Lesen einer Lektion?
+ ein kurzer Wissens-Check mit passenden Fragen
- nichts
- eine Werbung
- ein Neustart
! Abrufübung direkt nach dem Lernen festigt Wissen.

@@@ MODULE @@@
---
id: fs-01
title: Fallstudie 1 · Ransomware im Mittelstand
paths: cdsa, specialist, cjca
order: 36.1
difficulty: medium
icon: building.2.fill
tags: fallstudie, ransomware
summary: Eine fiktive, realistische Geschichte von der ersten Phishing-Mail bis zur Wiederherstellung – mit allen Fehlern und Entscheidungen, die den Verlauf geprägt haben.
---

## Einfach erklärt

Die Müller Maschinenbau GmbH (fiktiv, 250 Mitarbeitende) wird an einem Montagmorgen von verschlüsselten Bildschirmen begrüßt. Diese Fallstudie erzählt, wie es dazu kam – und zeigt an jeder Station, welche Maßnahme die Kette unterbrochen hätte.

## Der Ablauf

| Tag | Ereignis | Was hätte geholfen? |
|---|---|---|
| −21 | Phishing-Mail „Lieferschein“ mit Link; Mitarbeiterin gibt VPN-Zugangsdaten ein | phishing-resistente MFA, Meldekultur |
| −20 | VPN-Login aus dem Ausland, ohne MFA | MFA am VPN, Geo-Alarm |
| −19 | Aufklärung im AD, Netzwerkscans | Erkennung ungewöhnlicher LDAP-/Scan-Aktivität |
| −15 | Dienstkonto mit schwachem Passwort per Kerberoasting geknackt; Konto ist Domain Admin | gMSA, Tiering, keine Dienstkonten in DA |
| −10 | Fernwartungstool auf mehreren Servern installiert | Application Control, Alarm bei neuen RMM-Tools |
| −3 | 300 GB Konstruktionsdaten zu Cloud-Speicher hochgeladen | Egress-Kontrolle, DLP, Upload-Alarm |
| −1 | Backups über Domänenkonto gelöscht | getrennte Backup-Identität, Immutable Storage |
| 0 | Verschlüsselung per GPO an Wochenende | GPO-Änderungsüberwachung, EDR mit Blockierung |

## Reaktion und Wiederherstellung

- Tag 0: Krisenstab, externe IR-Firma über die Cyberversicherung, Meldung an Datenschutzbehörde (72 h) und Polizei.
- Tag 1–3: Untersuchung, Erstzugang gefunden, Umfang bestimmt.
- Tag 3–14: Neuaufbau AD, Wiederherstellung aus einem glücklicherweise vorhandenen Offline-Band der Buchhaltung, Produktion im Notbetrieb mit Papier.
- Woche 3–6: schrittweiser Normalbetrieb, MFA überall, Tiering, neue Backup-Architektur.

> [!MERKE] 21 Tage Zeit
> Zwischen Erstzugang und Verschlüsselung lagen drei Wochen. Fast jeder Schritt erzeugte Spuren – niemand hat hingesehen. Erkennung in dieser Phase ist der größte Hebel.

## Tiefer eingetaucht

Die Lehren: (1) Identität ist das Hauptziel – MFA, Tiering und Dienstkonto-Hygiene hätten den Weg mehrfach blockiert. (2) Datenabfluss vor Verschlüsselung ist die Regel – Egress-Überwachung lohnt sich. (3) Backups müssen vor Admins der Produktivumgebung geschützt sein. (4) Notbetrieb ohne IT muss vorbereitet sein. (5) Eine Übung im Vorjahr hätte Kontaktlisten, Rollen und Entscheidungen geklärt.

## Quiz

? Wie viele Tage lagen in der Fallstudie zwischen Erstzugang und Verschlüsselung?
= 21
! Zeit, die man für Erkennung hätte nutzen können.

? Welche Maßnahme hätte den Erstzugang über gestohlene VPN-Zugangsdaten verhindert?
+ MFA am VPN, idealerweise phishing-resistent
- ein längeres WLAN-Passwort
- ein neuer Drucker
- ein größerer Monitor
! Gestohlene Passwörter allein reichen dann nicht.

? Warum konnten die Angreifer die Backups löschen?
+ die Backups waren mit Domänenkonten verwaltbar und nicht unveränderlich
- weil Backups immer gelöscht werden können
- weil es keine Backups gab
- weil der Drucker es erlaubte
! Getrennte Identität und Immutable Storage hätten geholfen.

?tf In der Fallstudie wurden vor der Verschlüsselung Daten abgezogen.
= wahr
! Das ist bei modernen Ransomware-Angriffen die Regel.

? Welcher Fehler ermöglichte den schnellen Aufstieg zu Domain-Admin-Rechten?
+ ein Dienstkonto mit schwachem Passwort war Domain Admin
- ein zu langes Passwort
- zu viele Firewalls
- ein deaktiviertes Gastkonto
! gMSA und Tiering hätten das verhindert.

@@@ MODULE @@@
---
id: fs-02
title: Fallstudie 2 · Der kompromittierte Webshop
paths: cwes, cdsa, specialist
order: 44.9
difficulty: medium
icon: cart.badge.questionmark
tags: fallstudie, web
summary: Wie ein veraltetes Plugin zu gestohlenen Kreditkartendaten führte – Erkennung, Untersuchung, Meldung und die Lehren für Entwicklung und Betrieb.
---

## Einfach erklärt

Ein kleiner Onlinehändler (fiktiv) bemerkt nichts – bis die Bank meldet, dass auffällig viele Karten seiner Kunden missbraucht werden. Die Spur führt zu einem kleinen Skript, das jemand in die Bezahlseite geschmuggelt hat und das jede Eingabe heimlich mitschickt.

## Ablauf

| Zeitpunkt | Ereignis |
|---|---|
| Monat −4 | Sicherheitslücke in einem Shop-Plugin veröffentlicht; Update verfügbar |
| Monat −3 | automatisierter Angriff nutzt die Lücke, legt Admin-Konto an |
| Monat −3 | Angreifer fügt der Bezahlseite ein JavaScript hinzu („Skimmer“), das Kartendaten an eine ähnlich klingende Domain sendet |
| Monat 0 | Bank meldet gehäuften Kartenmissbrauch (Common Point of Purchase) |

## Untersuchung

1. Code der Bezahlseite mit sauberem Stand verglichen → fremdes Skript gefunden.
2. Webserver-Logs: Zugriffe auf Plugin-Endpunkt, Anlage eines Admin-Kontos.
3. Datenbank: neues Admin-Konto, veränderte Einstellungen.
4. Zeitraum der Kompromittierung bestimmt → betroffene Bestellungen.

## Maßnahmen

- Skimmer entfernt, Plugin aktualisiert, Admin-Konten bereinigt, Passwörter rotiert.
- Meldungen: Zahlungsdienstleister, Datenschutzbehörde, betroffene Kunden.
- Forensik nach Vorgaben des Kartenzahlungsstandards (PCI).

> [!MERKE] Integrität der Bezahlseite
> Content Security Policy, Subresource Integrity für externe Skripte, Überwachung von Änderungen an Bezahlseiten (PCI DSS 4.0 fordert das ausdrücklich) und gehostete Zahlungsfelder des Zahlungsdienstleisters (iFrame) reduzieren das Risiko drastisch.

## Tiefer eingetaucht

Lehren: Plugins und Erweiterungen gehören ins Patch-Management (oft vergessen!). Admin-Bereiche mit MFA und IP-Einschränkung schützen. Dateiintegritätsüberwachung auf Webverzeichnissen. CSP mit Reporting meldet unerwartete Ziele für Datenabflüsse. Und: Wer Zahlungen über die Felder des Zahlungsdienstleisters abwickelt, verkleinert den eigenen Prüfumfang und das Risiko erheblich.

## Quiz

? Wie gelangten die Angreifer in den Shop?
+ über eine bekannte Lücke in einem nicht aktualisierten Plugin
- über einen Stromausfall
- über das WLAN des Lagers
- über einen Drucker
! Plugins gehören ins Patch-Management.

? Was ist ein Skimmer im Web-Kontext?
+ ein eingeschleustes Skript, das Zahlungsdaten abgreift
- ein Kartenlesegerät am Geldautomaten
- ein Virenscanner
- ein Cache-Server
! Auch „Magecart“-Angriffe genannt.

?tf Content Security Policy kann unerwartete Datenabflüsse von Bezahlseiten erschweren und melden.
= wahr
! Mit Reporting werden Verstöße sichtbar.

? Welche Technik prüft, ob externe Skripte unverändert sind?
= Subresource Integrity
= SRI
! Der Browser vergleicht einen Hash.

? Wie meldet die Bank typischerweise den Verdacht?
+ über gehäufte Missbrauchsfälle mit gemeinsamem Kaufort
- per Post an jeden Kunden
- gar nicht
- über soziale Medien
! Common Point of Purchase-Analyse.

@@@ MODULE @@@
---
id: fs-03
title: Fallstudie 3 · Das offene Cloud-Bucket
paths: specialist, cdsa
order: 70.99
difficulty: easy
icon: externaldrive.badge.exclamationmark
tags: fallstudie, cloud
summary: Ein falsch freigegebener Objektspeicher legt Kundendaten offen – wie es passiert, wie es entdeckt wird und wie man es dauerhaft verhindert.
---

## Einfach erklärt

Ein Entwickler (fiktiv) möchte einem Dienstleister schnell eine Datei bereitstellen und schaltet einen Cloud-Speicher auf „öffentlich“. Er vergisst, es wieder zurückzustellen. Monate später schreibt ein Sicherheitsforscher: „Ihr Bucket mit 80.000 Kundendatensätzen ist öffentlich lesbar.“

## Ablauf

1. Bequemlichkeitsfreigabe statt sicherer Alternative (signierte, zeitlich begrenzte URL).
2. Kein organisationsweites „Block Public Access“.
3. Kein CSPM-Alarm, weil kein CSPM im Einsatz.
4. Automatisierte Scanner im Internet finden das Bucket.
5. Meldung durch einen Forscher (Glück!) – nicht durch Kriminelle.

## Reaktion

- Zugriff sofort schließen.
- **Zugriffslogs** prüfen: Wurde von unbekannten IPs gelesen? (Ohne aktivierte Data-Access-Logs ist das schwer zu beantworten.)
- Risikobewertung → Meldung an Aufsichtsbehörde und ggf. Betroffene.
- Dem Forscher danken (Coordinated Disclosure fördern).

> [!MERKE] Leitplanken statt Hoffnung
> Organisationsweite Sperren für öffentliche Freigaben verhindern den Fehler, bevor er passiert. Ausnahmen nur über einen dokumentierten Prozess.

## Tiefer eingetaucht

Lehren: sichere Alternativen anbieten (Pre-Signed URLs, Datenaustauschplattform), Policy as Code mit Deny-Regeln, CSPM mit Alarm in Minuten statt Monaten, Datenzugriffslogs für sensible Speicher aktivieren, Datenklassifizierung (wo liegen personenbezogene Daten?). Und eine `security.txt` sowie ein Meldeweg, damit Finder sich überhaupt melden können.

## Quiz

? Was wäre eine sichere Alternative zur öffentlichen Freigabe gewesen?
+ eine signierte, zeitlich begrenzte URL
- ein noch längerer Dateiname
- ein öffentlicher Link ohne Ablauf
- das Bucket umbenennen
! Pre-Signed URLs geben nur genau diese Datei für kurze Zeit frei.

? Welche organisationsweite Einstellung hätte den Fehler verhindert?
= Block Public Access
! Öffentliche Freigaben werden zentral unterbunden.

?tf Ohne Zugriffsprotokolle lässt sich kaum feststellen, ob Unbefugte Daten gelesen haben.
= wahr
! Data-Access-Logs für sensible Speicher aktivieren.

? Wie sollte man auf die Meldung eines Sicherheitsforschers reagieren?
+ danken, Problem beheben und den Meldeweg fördern
- mit Anzeige drohen
- ignorieren
- das Bucket löschen und schweigen
! Coordinated Disclosure schützt am Ende alle.

? Welche Werkzeugklasse hätte die Fehlkonfiguration schnell gemeldet?
= CSPM
! Cloud Security Posture Management.

@@@ MODULE @@@
---
id: fs-04
title: Fallstudie 4 · Eine Phishing-Kampagne mit Session-Diebstahl
paths: cdsa, specialist
order: 36.2
difficulty: medium
icon: person.badge.clock.fill
tags: fallstudie, phishing, identität
summary: Trotz MFA übernehmen Angreifer Postfächer – wie Adversary-in-the-Middle funktioniert, wie der Vorfall erkannt und eingedämmt wird und warum Passkeys die Lösung sind.
---

## Einfach erklärt

„Wir haben doch MFA!“ – und trotzdem schreiben Angreifer (fiktiver Fall) aus dem Postfach der Finanzleiterin. Die Phishing-Seite war ein **Durchreiche-Proxy**: Sie zeigte die echte Anmeldeseite, leitete Passwort und MFA-Code weiter – und behielt das Sitzungs-Cookie.

## Ablauf

1. Mail „Neue Datei für Sie freigegeben“ an 40 Mitarbeitende.
2. Link auf eine Domain, die wie der Login-Dienst aussieht.
3. 5 Personen melden sich an, inklusive MFA-Bestätigung.
4. Angreifer nutzen das gestohlene Session-Cookie von eigener Infrastruktur.
5. Posteingangsregel: Mails mit „Rechnung“ werden in einen versteckten Ordner verschoben.
6. Von einem Postfach gehen 400 weitere Phishing-Mails an Geschäftspartner.

## Erkennung und Reaktion

- Ein Partner meldet die verdächtige Mail zurück.
- Sign-in-Logs: Anmeldungen derselben Sitzung von zwei Ländern innerhalb von Minuten.
- Reaktion: Sitzungen widerrufen, Passwörter zurücksetzen, Regeln entfernen, MFA-Registrierungen prüfen, alle 40 Empfänger prüfen, Partner informieren.

> [!MERKE] MFA ist nicht gleich MFA
> Codes und Push-Bestätigungen lassen sich durchreichen. Phishing-resistente Verfahren (Passkeys, FIDO2) und Token-Bindung an das Gerät stoppen diese Angriffsart.

## Tiefer eingetaucht

Lehren: Conditional Access mit Gerätekonformität (Zugriff nur von verwalteten Geräten macht gestohlene Cookies nutzlos), Token Protection, phishing-resistente MFA zuerst für privilegierte und exponierte Rollen (Finanzen, Assistenz der Geschäftsführung), Alarme für neue Posteingangsregeln und unmögliche Reisen, Ausgangslimits für Mails, Schulung zu „Datei freigegeben“-Ködern.

## Quiz

? Wie umgingen die Angreifer die MFA?
+ ein Proxy reichte Anmeldung und MFA durch und stahl das Session-Cookie
- sie rieten den MFA-Code
- MFA war abgeschaltet
- sie hackten das Smartphone
! Adversary-in-the-Middle-Phishing.

? Welches Signal in den Anmeldelogs deutete auf den Diebstahl hin?
+ Nutzung derselben Sitzung aus zwei Ländern innerhalb von Minuten
- eine Anmeldung am Morgen
- ein neues Profilbild
- eine lange Sitzung
! Unmögliche Reisen sind ein starkes Signal.

?tf Phishing-resistente Verfahren wie Passkeys stoppen diese Angriffsart.
= wahr
! Die Signatur ist an die echte Domain gebunden.

? Welche Maßnahme macht gestohlene Cookies weitgehend nutzlos?
+ Zugriff nur von verwalteten, konformen Geräten
- längere Passwörter
- mehr Spamfilter
- häufigere Passwortwechsel
! Conditional Access mit Gerätebedingung.

? Was muss bei der Eindämmung zusätzlich zum Passwortwechsel geschehen?
+ Sitzungen widerrufen
+ Posteingangsregeln entfernen
- nichts weiter
- das Postfach umbenennen
! Sonst bleibt der Angreifer im Konto.

@@@ MODULE @@@
---
id: fs-05
title: Fallstudie 5 · Störung im Wasserwerk
paths: specialist, cyberrange
order: 93.4
difficulty: medium
icon: drop.triangle.fill
tags: fallstudie, ot
summary: Ein Fernzugang mit schwachem Passwort führt zu einem Eingriff in die Steuerung – Erkennung durch Bediener, manueller Betrieb und Lehren für kleine Versorger.
---

## Einfach erklärt

In einem kleinen Wasserwerk (fiktiv) sieht ein Bediener, wie sich der Mauszeiger auf dem Leitstand von selbst bewegt und ein Dosierwert verändert wird. Er greift ein, stellt den Wert zurück und schaltet auf Handbetrieb. Ein Mensch mit wachem Blick verhindert Schlimmeres.

## Ablauf

1. Fernwartungssoftware auf dem Leitstand-PC, direkt aus dem Internet erreichbar.
2. Gemeinsames Passwort für alle Mitarbeitenden und den Dienstleister, seit Jahren unverändert.
3. Leitstand-PC mit veraltetem Betriebssystem, flaches Netz zur Steuerung.
4. Angreifer verbindet sich und ändert einen Sollwert.
5. Bediener bemerkt es, Plausibilitätsgrenzen der Steuerung hätten zusätzlich gegriffen.

## Reaktion

- Fernwartung sofort getrennt, Handbetrieb.
- Behörden und Aufsicht informiert.
- Untersuchung: Wie lange gab es Zugriffe? Andere Änderungen?

> [!MERKE] Grundschutz verhindert die meisten OT-Vorfälle
> Keine direkt erreichbaren Fernzugänge, persönliche Konten mit MFA, Netztrennung und Plausibilitätsgrenzen in der Steuerung – nichts davon ist teuer.

## Tiefer eingetaucht

Kleine Versorger haben oft wenig IT-Personal. Hilfreich sind Branchenleitfäden (z. B. B3S für Wasser), Unterstützung durch Verbände und Behörden, standardisierte sichere Fernwartungslösungen und regelmäßige Notfallübungen für manuellen Betrieb. Physische Sicherheitsfunktionen (mechanische Begrenzungen, unabhängige Sicherheitssysteme) sind die letzte Verteidigungslinie, wenn digitale Schutzschichten versagen.

## Quiz

? Was war der Erstzugang im Fallbeispiel?
+ eine direkt aus dem Internet erreichbare Fernwartungssoftware mit gemeinsamem Passwort
- ein Satellitenangriff
- ein USB-Stick im Rohr
- ein Stromausfall
! Grundschutz hätte das verhindert.

? Wer verhinderte im Fall Schlimmeres?
+ ein aufmerksamer Bediener
- ein Virenscanner
- der Drucker
- niemand
! Menschen sind Teil der Verteidigung.

?tf Plausibilitätsgrenzen in der Steuerung können gefährliche Sollwerte verhindern.
= wahr
! Sie sind eine zusätzliche, prozessnahe Schutzschicht.

? Welche Maßnahmen gehören zum OT-Grundschutz?
+ keine direkt erreichbaren Fernzugänge
+ persönliche Konten mit MFA
+ Netztrennung
- gemeinsame Passwörter für alle
! Nichts davon ist teuer.

? Was ist der Branchenstandard für IT-Sicherheit in der Wasserwirtschaft in Deutschland?
= B3S
= B3S Wasser
! Branchenspezifischer Sicherheitsstandard.

@@@ MODULE @@@
---
id: tm-01
title: Threat Modeling 1 · Bedrohungen systematisch finden mit STRIDE
paths: cwee, specialist, cwes
order: 45
difficulty: medium
icon: point.3.filled.connected.trianglepath.dotted
tags: threat modeling, stride, design
summary: Wie man vor dem Bauen über Bedrohungen nachdenkt – Datenflussdiagramme, Vertrauensgrenzen, STRIDE pro Element und priorisierte Gegenmaßnahmen.
---

## Einfach erklärt

Bevor man ein Haus baut, fragt man: Wo könnten Einbrecher hinein? Wo ist der Brandschutz? **Threat Modeling** stellt diese Fragen für Software und Systeme – **bevor** gebaut wird, wenn Änderungen noch billig sind.

## Vier Leitfragen

1. **Woran arbeiten wir?** → Datenflussdiagramm (DFD)
2. **Was kann schiefgehen?** → Bedrohungen finden (z. B. STRIDE)
3. **Was tun wir dagegen?** → Maßnahmen
4. **Haben wir gut genug gearbeitet?** → Überprüfen

## Das Datenflussdiagramm

| Element | Symbol (üblich) | Beispiel |
|---|---|---|
| Externe Entität | Rechteck | Nutzer, Partnersystem |
| Prozess | Kreis | Webanwendung, API |
| Datenspeicher | parallele Linien | Datenbank, Bucket |
| Datenfluss | Pfeil | HTTPS-Anfrage |
| Vertrauensgrenze | gestrichelte Linie | Internet ↔ DMZ, Anwendung ↔ Datenbank |

Bedrohungen konzentrieren sich an **Vertrauensgrenzen**.

## STRIDE

| Bedrohung | verletzt | Beispiel | Typische Maßnahme |
|---|---|---|---|
| **S**poofing | Authentizität | Anmeldung als jemand anderes | starke Authentifizierung |
| **T**ampering | Integrität | Daten unterwegs verändert | Signaturen, TLS, Validierung |
| **R**epudiation | Nichtabstreitbarkeit | „Das war ich nicht“ | Audit-Logs |
| **I**nformation Disclosure | Vertraulichkeit | Datenleck | Verschlüsselung, Zugriffskontrolle |
| **D**enial of Service | Verfügbarkeit | Überlastung | Rate Limits, Skalierung |
| **E**levation of Privilege | Autorisierung | normaler Nutzer wird Admin | Least Privilege, Prüfungen |

> [!TIPP] Klein anfangen
> Ein Whiteboard, ein DFD mit fünf Kästen und 30 Minuten STRIDE-Diskussion im Team bringen mehr als ein perfektes Dokument, das nie entsteht.

## Tiefer eingetaucht

Ergebnisse werden als Tickets mit Priorität erfasst (z. B. nach Risiko). Weitere Methoden: **PASTA** (risikozentriert), **LINDDUN** (Datenschutzbedrohungen), Angriffsbäume, Missbrauchsfälle. Threat Modeling gehört in den Entwicklungsprozess: bei neuen Features, Architekturänderungen und externen Schnittstellen – und das Modell wird gepflegt, wenn sich das System ändert.

## Quiz

? Wofür steht das E in STRIDE?
= Elevation of Privilege
! Rechteausweitung – verletzt die Autorisierung.

? Wo konzentrieren sich Bedrohungen in einem Datenflussdiagramm?
+ an Vertrauensgrenzen
- in der Mitte des Diagramms
- bei den Farben
- in der Legende
! Dort wechseln Daten zwischen Bereichen unterschiedlichen Vertrauens.

? Welche Maßnahme passt zu Repudiation?
+ Audit-Logs
- Rate Limits
- Verschlüsselung allein
- Kompression
! Nachvollziehbarkeit verhindert das Abstreiten von Aktionen.

?tf Threat Modeling sollte möglichst früh, vor dem Bauen, stattfinden.
= wahr
! Dann sind Änderungen am billigsten.

? Welche Methode konzentriert sich auf Datenschutzbedrohungen?
= LINDDUN
! Ergänzt STRIDE um Privatsphäre-Aspekte.

?order Bringe die vier Leitfragen des Threat Modeling in die richtige Reihenfolge.
> Woran arbeiten wir?
> Was kann schiefgehen?
> Was tun wir dagegen?
> Haben wir gut genug gearbeitet?
! Nach dem Threat Modeling Manifesto.

@@@ MODULE @@@
---
id: tm-02
title: Threat Modeling 2 · Angriffsbäume und Missbrauchsfälle
paths: cwee, specialist, cyberrange
order: 45.5
difficulty: medium
icon: tree
tags: threat modeling, angriffsbaum
summary: Wie man Angreiferziele in Teilschritte zerlegt, Kosten und Wahrscheinlichkeiten bewertet und daraus Tests, Erkennungen und Übungsszenarien ableitet.
---

## Einfach erklärt

Ein **Angriffsbaum** beginnt mit dem Ziel des Angreifers an der Spitze („Kundendaten stehlen“) und verzweigt nach unten in alle Wege dorthin – wie ein Stammbaum der Möglichkeiten. **Missbrauchsfälle** (Misuse Cases) sind das böse Gegenstück zu Anwendungsfällen: „Als Angreifer will ich die Bestellung eines anderen sehen.“

## Ein Angriffsbaum (gekürzt)

```text
Ziel: Kundendaten stehlen
├── ODER: Datenbank direkt angreifen
│   ├── SQL-Injection in Webanwendung
│   └── gestohlene DB-Zugangsdaten
│       ├── aus Code-Repository
│       └── aus Backup-Datei auf Webserver
├── ODER: Admin-Konto übernehmen
│   ├── Phishing + fehlende MFA
│   └── Passwort-Reset-Fehler
└── ODER: Backup stehlen
    └── öffentlich freigegebener Speicher
```

- **ODER-Knoten**: ein Weg genügt.
- **UND-Knoten**: alle Teilschritte nötig.
- Bewertung pro Blatt: Kosten, Können, Wahrscheinlichkeit, Entdeckbarkeit.

## Missbrauchsfälle schreiben

| Anwendungsfall | Missbrauchsfall | Gegenmaßnahme |
|---|---|---|
| Nutzer sieht eigene Bestellung | Angreifer ändert Bestell-ID und sieht fremde | Objektautorisierung |
| Nutzer setzt Passwort zurück | Angreifer setzt fremdes Passwort zurück | sichere Reset-Tokens |
| Nutzer lädt Profilbild hoch | Angreifer lädt Skript hoch | Upload-Härtung |

> [!MERKE] Aus Bäumen werden Tests
> Jedes Blatt eines Angriffsbaums ist ein möglicher Testfall für Pentests, eine Idee für eine Erkennungsregel und ein Kandidat für ein Übungsszenario in der Cyber Range.

## Tiefer eingetaucht

Angriffsbäume helfen auch bei Investitionsentscheidungen: Welche Maßnahme schneidet die meisten oder billigsten Wege ab? MFA zum Beispiel beendet in vielen Bäumen gleich mehrere Äste. In Kombination mit ATT&CK lassen sich Blätter konkreten Techniken zuordnen – und damit mit Erkennungsabdeckung und Threat Intelligence verknüpfen.

## Quiz

? Was steht an der Spitze eines Angriffsbaums?
+ das Ziel des Angreifers
- die Firewall
- der Administrator
- die Datenbank
! Darunter verzweigen sich alle Wege dorthin.

? Was bedeutet ein UND-Knoten?
+ alle Teilschritte müssen gelingen
- ein Teilschritt genügt
- der Knoten ist optional
- der Knoten ist gelöscht
! ODER-Knoten: ein Weg genügt.

? Was ist ein Missbrauchsfall?
+ die böswillige Variante eines Anwendungsfalls aus Angreifersicht
- ein Softwarefehler beim Kompilieren
- ein Supportticket
- ein Backup
! „Als Angreifer will ich …“

?tf Blätter eines Angriffsbaums eignen sich als Testfälle und Erkennungsideen.
= wahr
! Und als Szenarien für Übungen.

? Warum ist MFA in vielen Angriffsbäumen besonders wirksam?
+ sie schneidet gleich mehrere Äste ab
- weil sie billig aussieht
- weil sie Bäume löscht
- weil sie nur einen Weg betrifft
! Eine Maßnahme, viele blockierte Wege.

@@@ MODULE @@@
---
id: sd-01
title: Secure Design · Sicherheitsprinzipien für Architektur und Code
paths: cwee, specialist, cwes
order: 45.8
difficulty: medium
icon: building.columns.circle
tags: design, prinzipien
summary: Die bewährten Entwurfsprinzipien von Saltzer & Schroeder bis heute – Least Privilege, Fail Secure, Complete Mediation, Defense in Depth und mehr – mit Beispielen.
---

## Einfach erklärt

Gute Architekten bauen nach Prinzipien, die sich über Jahrzehnte bewährt haben: tragende Wände, Fluchtwege, Brandabschnitte. In der Sicherheit gibt es solche Prinzipien auch – viele wurden schon 1975 formuliert und gelten bis heute.

## Die Prinzipien

| Prinzip | Bedeutung | Beispiel |
|---|---|---|
| Least Privilege | nur nötige Rechte | DB-Konto der App darf nur lesen, was sie braucht |
| Fail Secure / Fail Safe Defaults | im Zweifel verweigern | Fehler bei der Autorisierungsprüfung → Zugriff verweigert |
| Complete Mediation | jeden Zugriff prüfen | Berechtigung bei jeder Anfrage, nicht nur beim Login |
| Economy of Mechanism | einfach halten | eine zentrale Autorisierungskomponente statt verstreuter Prüfungen |
| Open Design | Sicherheit nicht durch Geheimhaltung des Verfahrens | Standard-Krypto statt Eigenbau |
| Separation of Privilege | mehrere Bedingungen | Vier-Augen-Prinzip, MFA |
| Least Common Mechanism | wenig Geteiltes | getrennte Mandantendaten |
| Psychological Acceptability | benutzbar | Passkeys statt komplizierter Passwortregeln |
| Defense in Depth | mehrere Schichten | WAF + sicherer Code + Monitoring |
| Secure by Default | sichere Voreinstellungen | Admin-Oberfläche standardmäßig aus |
| Minimize Attack Surface | wenig Angriffsfläche | ungenutzte Endpunkte entfernen |

> [!MERKE] Fail Secure
> Viele Lücken entstehen in Fehlerpfaden: Eine Ausnahme bei der Rechteprüfung wird abgefangen – und der Code läuft einfach weiter. Fehler müssen zur Verweigerung führen.

## Tiefer eingetaucht

Moderne Ergänzungen: **Zero Trust** (Complete Mediation auf Netz- und Identitätsebene), **Secure by Design**-Initiativen von Behörden (Hersteller übernehmen Verantwortung für sichere Standardeinstellungen, Speichersicherheit, Abschaffung von Standardpasswörtern), **Memory Safety** als Designentscheidung bei der Sprachwahl. Prinzipien sind Werkzeuge zum Argumentieren: In Design-Reviews lässt sich jede Entscheidung daran messen.

## Quiz

? Was bedeutet Fail Secure?
+ im Fehlerfall wird der Zugriff verweigert
- bei Fehlern wird alles erlaubt
- Fehler werden ignoriert
- das System startet neu
! Viele Lücken entstehen in Fehlerpfaden.

? Was verlangt Complete Mediation?
+ jeden Zugriff erneut auf Berechtigung prüfen
- nur beim Login prüfen
- nie prüfen
- nur Admins prüfen
! Grundlage auch für Zero Trust.

?tf Open Design bedeutet, dass Sicherheit nicht auf der Geheimhaltung des Verfahrens beruhen sollte.
= wahr
! Deshalb Standard-Kryptografie statt Eigenbau.

? Welches Prinzip fordert sichere Voreinstellungen?
= Secure by Default
! Unsichere Optionen müssen bewusst aktiviert werden.

? Welches Prinzip beschreibt das Vier-Augen-Prinzip?
+ Separation of Privilege
- Economy of Mechanism
- Open Design
- Least Common Mechanism
! Mehrere Bedingungen bzw. Personen sind nötig.

@@@ MODULE @@@
---
id: la-01
title: Logging-Architektur · Von der Quelle bis zur Erkennung
paths: cdsa, specialist, cyberrange
order: 30.05
difficulty: medium
icon: point.3.connected.trianglepath.dotted
tags: logging, siem, architektur
summary: Wie eine belastbare Logging-Pipeline aufgebaut ist – Quellen, Sammlung, Normalisierung, Speicherung, Aufbewahrung, Kosten und Qualitätskontrolle.
---

## Einfach erklärt

Logs sind wie Wasser in einem Leitungsnetz: Sie entstehen an vielen Quellen, müssen gesammelt, gereinigt, gespeichert und an die richtigen Stellen geleitet werden. Leckt die Leitung irgendwo, merkt man es oft erst, wenn man Wasser braucht – also im Vorfall.

## Die Pipeline

| Stufe | Aufgabe | Beispiele |
|---|---|---|
| Quellen | Ereignisse erzeugen | Windows, Linux, Firewall, Cloud, Anwendungen |
| Sammlung | transportieren | Agenten, WEF, Syslog, APIs |
| Pufferung | Lastspitzen abfangen | Queues (z. B. Kafka) |
| Verarbeitung | parsen, normalisieren, anreichern | Feldnamen-Schema (z. B. ECS, OCSF), GeoIP, Asset-Infos |
| Speicherung | heiß (schnell, teuer), kalt (günstig, langsam) | SIEM-Index, Objektspeicher |
| Nutzung | Suche, Erkennung, Dashboards, Hunting | SIEM, Notebooks |

## Qualität sichern

- **Abdeckung**: Welche Systeme liefern? Welche fehlen? (Vergleich mit Inventar)
- **Vollständigkeit**: Sind die nötigen Ereignistypen aktiv (Audit-Richtlinien)?
- **Aktualität**: Verzögerung zwischen Ereignis und Verfügbarkeit
- **Zeit**: NTP, UTC
- **Parsing**: Werden Felder korrekt erkannt?
- **Ausfallerkennung**: Alarm, wenn eine Quelle verstummt

> [!MERKE] Ein stilles Log ist ein Alarm
> Wenn ein Domain Controller plötzlich keine Ereignisse mehr sendet, ist das entweder ein technisches Problem oder ein Angreifer, der Spuren verwischt. Beides muss auffallen.

## Tiefer eingetaucht

Kosten sind real: SIEM-Lizenzen und Speicher richten sich oft nach Datenvolumen. Strategien: Filter am Rand (Rauschen verwerfen, aber nachvollziehbar), gestufte Speicherung (30 Tage heiß, 1 Jahr kalt), Zusammenfassungen statt Rohdaten für manche Quellen. Wichtig ist, dass Filter **bewusste Entscheidungen** sind – dokumentiert und mit Blick auf Erkennungsbedarf, nicht nur Budget. Ein gemeinsames Datenschema erleichtert Regeln über Quellen hinweg (eine Regel für „Anmeldung fehlgeschlagen“, egal ob Windows, Linux oder Cloud).

## Quiz

? Warum sollte man Logs normalisieren?
+ damit Regeln und Suchen über verschiedene Quellen hinweg funktionieren
- damit sie größer werden
- damit sie verschlüsselt sind
- damit sie verschwinden
! Gemeinsame Feldnamen wie in ECS oder OCSF.

? Was bedeutet es, wenn ein Domain Controller keine Logs mehr sendet?
+ ein technisches Problem oder möglicherweise Spurenverwischung – beides muss Alarm auslösen
- alles ist in Ordnung
- der DC ist besonders sicher
- es ist Wochenende
! Ein stilles Log ist ein Alarm.

?tf Gestufte Speicherung (heiß/kalt) kann Kosten senken.
= wahr
! Schnelle Suche für aktuelle Daten, günstige Archivierung für ältere.

? Welche Komponente fängt Lastspitzen in Logging-Pipelines ab?
+ eine Queue bzw. Pufferung
- der Bildschirmschoner
- ein Drucker
- ein WLAN-Repeater
! Zum Beispiel Kafka.

? Womit prüft man die Abdeckung der Logquellen?
+ Abgleich mit dem Asset-Inventar
- Raten
- Anzahl der Monitore
- Anzahl der Mitarbeiter
! So fallen fehlende Systeme auf.

@@@ MODULE @@@
---
id: mt-01
title: Mathe für Krypto · Modulo, Primzahlen und diskrete Logarithmen
paths: grundlagen, specialist, cwee
order: 60.05
difficulty: medium
icon: x.squareroot
tags: kryptografie, mathematik
summary: Die Mathematik hinter RSA und Diffie-Hellman verständlich – Uhrenrechnen, Primzahlen, Einwegfunktionen und warum große Zahlen schützen.
---

## Einfach erklärt

Kryptografie nutzt **Einwegfunktionen**: Rechnungen, die in eine Richtung leicht und in die andere extrem schwer sind – wie Farben mischen. Blau und Gelb zu Grün mischen ist leicht; aus Grün wieder genau das ursprüngliche Blau und Gelb zu bekommen, ist schwer.

## Modulo – Uhrenrechnen

`a mod n` ist der Rest bei der Division durch `n`. Auf einer Uhr ist 15 Uhr = 3 Uhr, denn 15 mod 12 = 3.

| Rechnung | Ergebnis |
|---|---|
| 17 mod 5 | 2 |
| 3^4 mod 7 = 81 mod 7 | 4 |
| (a · b) mod n | = ((a mod n) · (b mod n)) mod n |

## Diffie-Hellman in Zahlen (winzig)

Öffentlich: Primzahl p = 23, Basis g = 5.
- Anna wählt geheim a = 6: sendet A = 5^6 mod 23 = **8**
- Ben wählt geheim b = 15: sendet B = 5^15 mod 23 = **19**
- Anna rechnet 19^6 mod 23 = **2**, Ben rechnet 8^15 mod 23 = **2** → gemeinsames Geheimnis 2

Ein Lauscher kennt 23, 5, 8 und 19 – um auf 2 zu kommen, müsste er den **diskreten Logarithmus** lösen (welches a ergibt 5^a mod 23 = 8?). Bei Zahlen mit hunderten Stellen ist das praktisch unmöglich.

## RSA in Kürze

- Zwei große Primzahlen p, q multiplizieren → n (leicht).
- n wieder in p und q zerlegen (**Faktorisieren**) ist bei großen Zahlen extrem schwer.
- Daraus werden öffentlicher Exponent e und privater Exponent d abgeleitet; Verschlüsseln: c = m^e mod n, Entschlüsseln: m = c^d mod n.

> [!MERKE] Sicherheit durch schwere Probleme
> RSA beruht auf dem Faktorisierungsproblem, Diffie-Hellman und elliptische Kurven auf dem diskreten Logarithmus. Quantencomputer könnten beide mit dem Shor-Algorithmus lösen – deshalb Post-Quanten-Kryptografie.

## Tiefer eingetaucht

Elliptische Kurven rechnen statt mit Potenzen mit „Punktaddition“ auf einer Kurve über einem endlichen Körper; der diskrete Logarithmus ist dort noch schwerer, daher genügen kürzere Schlüssel (256-Bit-ECC ≈ 3072-Bit-RSA). Praktische Fehler entstehen selten in der Mathematik, sondern in der Umsetzung: zu kleine Parameter, schlechter Zufall, fehlendes Padding (bei RSA: OAEP für Verschlüsselung, PSS für Signaturen).

## Quiz

? Was ist 17 mod 5?
= 2
! 17 = 3 · 5 + 2.

? Was ist 3^4 mod 7?
= 4
! 81 = 11 · 7 + 4.

? Auf welchem schweren Problem beruht RSA?
+ Faktorisierung großer Zahlen
- Sortieren von Listen
- Addition kleiner Zahlen
- Primzahltests
! Multiplizieren ist leicht, Zerlegen schwer.

? Auf welchem Problem beruht Diffie-Hellman?
= diskreter Logarithmus
= diskreter Logarithmus
= Diskreter Logarithmus
! Aus g^a mod p lässt sich a nur sehr schwer bestimmen.

?tf 256-Bit-ECC bietet etwa die Sicherheit von 3072-Bit-RSA.
= wahr
! Deshalb sind elliptische Kurven effizienter.

? Welcher Quantenalgorithmus bedroht RSA und Diffie-Hellman?
= Shor
= Shor-Algorithmus
! Grund für die Umstellung auf Post-Quanten-Kryptografie.

@@@ MODULE @@@
---
id: dp-04
title: Datenschutz im Alltag · Privatsphäre selbst schützen
paths: grundlagen, specialist
order: 0.24
difficulty: easy
icon: eye.slash.fill
tags: datenschutz, privat, einstieg
summary: Tracking, Datenhändler, Berechtigungen, sichere Messenger, Browser-Einstellungen und Rechte nach DSGVO – Privatsphäre praktisch für jeden.
---

## Einfach erklärt

Jede App, jede Webseite und jedes smarte Gerät sammelt ein bisschen. Einzeln wirkt das harmlos – zusammengeführt entsteht ein erstaunlich genaues Bild: wo du wohnst, wann du schläfst, was du kaufst. Privatsphäre zu schützen heißt nicht, offline zu leben, sondern **bewusst zu entscheiden**, was man teilt.

## Praktische Schritte

| Bereich | Maßnahme |
|---|---|
| Browser | Tracking-Schutz aktivieren, Drittanbieter-Cookies blockieren, Erweiterungen sparsam |
| Suchmaschine | datensparsame Alternativen nutzen |
| Smartphone | Berechtigungen prüfen, Werbe-ID zurücksetzen/deaktivieren, Standort nur „beim Verwenden“ |
| Messenger | Ende-zu-Ende-verschlüsselte Dienste |
| Konten | Datenschutzeinstellungen in sozialen Netzwerken prüfen |
| E-Mail | Alias-Adressen für Anmeldungen |
| Fotos | Standortdaten (EXIF) vor dem Teilen entfernen |
| Smart Home | Mikrofone/Kameras nur wo nötig, lokale Steuerung bevorzugen |

> [!TIPP] Deine Rechte nach DSGVO
> Du kannst Auskunft verlangen (Art. 15), Berichtigung (Art. 16), Löschung (Art. 17) und Widerspruch gegen Werbung (Art. 21). Unternehmen müssen in der Regel innerhalb eines Monats antworten.

## Tiefer eingetaucht

Tracking passiert auch ohne Cookies: **Browser-Fingerprinting** (Kombination aus Bildschirmgröße, Schriftarten, Einstellungen), Tracking-Pixel in E-Mails (Bilder nicht automatisch laden), Standortdaten aus Apps, die an Datenhändler verkauft werden. Ein VPN verbirgt die IP gegenüber Webseiten und schützt in öffentlichen WLANs – macht aber nicht anonym und verlagert das Vertrauen zum VPN-Anbieter.

Privatsphäre ist auch Sicherheit: Weniger öffentliche Informationen bedeuten weniger Material für Social Engineering und gezieltes Phishing.

## Quiz

? Welcher DSGVO-Artikel regelt das Auskunftsrecht?
= Art. 15
= 15
! Unternehmen müssen in der Regel binnen eines Monats antworten.

? Was verrät EXIF in Fotos?
+ u. a. Aufnahmeort und Gerät
- nur die Farbe
- das Passwort
- den Akkustand
! Vor dem Teilen entfernen.

?tf Ein VPN macht Nutzer im Internet vollständig anonym.
= falsch
! Es verbirgt die IP gegenüber Webseiten, verlagert aber Vertrauen zum Anbieter.

? Was ist Browser-Fingerprinting?
+ Wiedererkennung anhand einer Kombination von Geräte- und Browsermerkmalen
- ein Fingerabdrucksensor
- ein Passwortmanager
- ein Cookie-Banner
! Funktioniert auch ohne Cookies.

? Warum ist Privatsphäre auch Sicherheit?
+ weniger öffentliche Informationen bedeuten weniger Material für Social Engineering
- weil Daten dann schneller laden
- weil es Strom spart
- weil Viren Daten mögen
! Angreifer recherchieren ihre Opfer.

@@@ MODULE @@@
---
id: bc-01
title: Blockchain und Krypto-Wallets – Sicherheit verstehen
paths: specialist, grundlagen
order: 60.7
difficulty: medium
icon: bitcoinsign.circle.fill
tags: blockchain, wallets, betrug
summary: Wie Blockchains und Wallets funktionieren, warum private Schlüssel alles sind, typische Betrugsmaschen und Smart-Contract-Risiken – ohne Anlageberatung.
---

## Einfach erklärt

Eine Blockchain ist ein öffentliches Kassenbuch, das alle gemeinsam führen und das nachträglich nicht geändert werden kann. Ein **Wallet** ist kein Geldbeutel mit Münzen, sondern ein Schlüsselbund: Wer den **privaten Schlüssel** (bzw. die Wiederherstellungsphrase) hat, kann über die Werte verfügen. Es gibt keine Bank, die eine Überweisung zurückholt.

## Grundbegriffe

| Begriff | Bedeutung |
|---|---|
| Privater Schlüssel / Seed-Phrase | volle Kontrolle – nie teilen |
| Öffentliche Adresse | zum Empfangen, öffentlich |
| Hot Wallet | auf internetverbundenem Gerät |
| Cold Wallet / Hardware-Wallet | Schlüssel offline auf eigenem Gerät |
| Smart Contract | Programm auf der Blockchain, das automatisch ausgeführt wird |
| Transaktion | unwiderruflich, sobald bestätigt |

> [!GEFAHR] Niemand Seriöses fragt nach der Seed-Phrase
> Support, Börsen, „Wallet-Validierung“ – wer nach der Wiederherstellungsphrase fragt, will stehlen. Immer.

## Typische Betrugsmaschen

- **Investmentbetrug** mit „garantierten“ Renditen, oft über soziale Netzwerke oder Dating-Kontakte (Pig Butchering).
- **Phishing** gefälschter Wallet-Apps und Börsen-Logins.
- **Fake-Airdrops** und bösartige Token-Freigaben (Wallet „Drainer“).
- **Clipboard-Malware**, die kopierte Adressen austauscht.
- **Rug Pulls**: Projektbetreiber verschwinden mit dem Geld.

## Tiefer eingetaucht

Smart Contracts sind Code, der nach der Veröffentlichung oft nicht mehr geändert werden kann – Fehler wie Reentrancy, falsche Rechteprüfungen oder Preis-Manipulation über Orakel führten zu Verlusten in Milliardenhöhe. Audits, Tests, formale Verifikation und Bug-Bounties sind dort Standard.

Für Unternehmen und Ermittler relevant: Blockchains sind öffentlich – Transaktionen lassen sich verfolgen (Blockchain-Analyse), auch wenn Identitäten hinter Adressen nicht direkt sichtbar sind. Ransomware-Zahlungen werden so teilweise nachverfolgt. Hinweis: Dieses Modul erklärt Sicherheit, es ist keine Anlageberatung.

## Quiz

? Was gibt die volle Kontrolle über ein Krypto-Wallet?
+ der private Schlüssel bzw. die Seed-Phrase
- die öffentliche Adresse
- der Wallet-Name
- das App-Icon
! Wer sie hat, kann über die Werte verfügen.

?tf Seriöser Support fragt manchmal nach der Seed-Phrase.
= falsch
! Wer danach fragt, will stehlen.

? Was ist eine Cold Wallet?
+ ein Wallet, dessen Schlüssel offline gespeichert sind
- ein Wallet im Kühlschrank
- ein leeres Wallet
- ein gesperrtes Bankkonto
! Zum Beispiel ein Hardware-Wallet.

? Was macht Clipboard-Malware im Krypto-Umfeld?
+ sie tauscht kopierte Wallet-Adressen gegen die des Angreifers aus
- sie löscht Fotos
- sie verlangsamt den Rechner
- sie ändert das Hintergrundbild
! Adressen vor dem Senden immer prüfen.

? Warum ist Blockchain-Analyse möglich?
+ Transaktionen sind öffentlich einsehbar
- weil Blockchains verschlüsselt sind
- weil Banken die Daten liefern
- weil Wallets Namen enthalten
! Identitäten sind aber nicht direkt sichtbar.

@@@ MODULE @@@
---
id: dn-01
title: DNS sicher betreiben – eigener Resolver und interne Zonen
paths: specialist, cdsa, cyberrange
order: 52.7
difficulty: medium
icon: server.rack
tags: dns, betrieb, härtung
summary: Wie man Unternehmens-DNS sicher aufbaut – interne/externe Trennung, Resolver mit DNSSEC-Validierung und Filtern, Logging, Härtung von AD-DNS.
---

## Einfach erklärt

DNS ist das Navigationssystem des Netzes. Wer es kontrolliert, entscheidet, wohin alle fahren. Ein gut betriebenes DNS schützt vor bösartigen Zielen, liefert wertvolle Logs und verrät nach außen nicht mehr als nötig.

## Architektur

| Komponente | Aufgabe |
|---|---|
| Interne autoritative Zonen (oft AD-integriert) | Namen interner Systeme |
| Externe autoritative Zonen (beim Provider/eigener Server) | öffentliche Namen |
| Interne rekursive Resolver | Auflösung für Clients, mit Filter und Logging |
| Forwarder/Upstream | Protective DNS oder vertrauenswürdiger Anbieter |

**Split-Horizon**: Intern und extern unterschiedliche Antworten – interne Namen bleiben intern.

## Härtung

- Resolver nur für interne Clients (keine offenen Resolver im Internet).
- **DNSSEC-Validierung** aktiv.
- **Response Policy Zones (RPZ)** bzw. Protective DNS zum Blockieren bösartiger Domains.
- Zonentransfers nur zu berechtigten Servern.
- Direktes DNS ins Internet von Clients sperren (Port 53 nur von Resolvern), DoH zu externen Anbietern steuern.
- **Query-Logging** zentral (wer fragte wann was?).
- Für AD-DNS: sichere dynamische Updates, Rechte auf Zonen prüfen (z. B. `DnsAdmins`, Erstellen von Wildcard-Einträgen durch normale Nutzer einschränken).

> [!TIPP] DNS-Logs sind Gold
> Fast jede Malware fragt DNS. Mit Query-Logs findet man nach einem IOC-Treffer sofort alle betroffenen Clients – auch rückwirkend.

## Tiefer eingetaucht

Angriffe auf internes DNS: Wildcard- oder gezielte Einträge durch normale Domänennutzer (Standard-AD-Rechte erlauben oft das Anlegen neuer Einträge) zur Umleitung von Verkehr, Missbrauch von DnsAdmins-Rechten, Rogue-DHCPv6, das einen fremden DNS-Server verteilt. Überwachen: Änderungen an Zonen (Verzeichnisdienst-Ereignisse), neue Einträge mit auffälligen Namen (z. B. `wpad`, `*`), Anfragen an ungewöhnliche Record-Typen.

## Quiz

? Was bedeutet Split-Horizon-DNS?
+ intern und extern werden unterschiedliche Antworten geliefert
- DNS läuft auf zwei Ports
- DNS wird halbiert
- DNS nur am Horizont
! Interne Namen bleiben intern.

? Was sind Response Policy Zones?
+ Regeln im Resolver, um bösartige Domains zu blockieren oder umzuleiten
- Firewall-Zonen
- WLAN-Bereiche
- Backup-Zonen
! Grundlage vieler DNS-Filter.

?tf Clients sollten direkt beliebige DNS-Server im Internet erreichen dürfen.
= falsch
! Sonst umgehen sie Filter und Logging.

? Warum sind DNS-Query-Logs wertvoll?
+ man findet nach einem IOC sofort alle betroffenen Clients
- sie sparen Speicher
- sie beschleunigen das Internet
- sie ersetzen Backups
! Auch rückwirkend.

? Welche AD-Gruppe kann den DNS-Dienst auf DCs beeinflussen und ist daher kritisch?
= DnsAdmins
! Mitgliedschaft streng begrenzen und überwachen.
