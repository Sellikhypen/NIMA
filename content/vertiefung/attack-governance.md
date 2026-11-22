# Tiefer eingetaucht – ATT&CK, Governance, Karriere

## att-01 | Aufklärung ohne Spur
Der größte Teil passiver Aufklärung berührt dein Netz nie: Transparenz-Logs, Suchmaschinen, soziale Netze, gekaufte Datensätze. Du kannst sie nicht erkennen, nur den Ertrag senken und wissen, was sichtbar ist. Scan-Alarme am Perimeter sagen dagegen selten etwas über Zielgerichtetheit.

> [!PRAXIS] Denk weiter
> Wann wird Scan-Rauschen interessant? Wenn es dein Namensschema, nicht veröffentlichte Hosts oder anschließend gültige Kontonamen verwendet.

## att-02 | Vorbereitung sichtbar machen
Ressourcen entstehen außerhalb deiner Sicht, hinterlassen aber öffentliche Spuren: Registrierungen, Zertifikate, Nameserver. Einzeln sind sie schwach, zusammen bilden sie Cluster. Gekaperte legitime Infrastruktur unterläuft genau diese Altersheuristik.

> [!PRAXIS] Denk weiter
> Eine ähnliche Domain hat noch keine Webseite. Ignorieren? Beobachten, MX-Einträge prüfen und vorsorglich blockieren: Für Phishing genügt Mail.

## att-03 | Einstieg ist auch ein Markt
Wer eindringt und wer später verschlüsselt, sind oft Verschiedene, Initial Access Broker verkaufen Zugänge. Ein kleiner Infostealer-Fund auf einem privaten Gerät kann Wochen später zum Firmenvorfall werden, per gültiger Anmeldung ohne Exploit.

> [!PRAXIS] Denk weiter
> Das VPN-Gerät ist gepatcht. Erledigt? Nicht, wenn es vorher ausgenutzt wurde. Auf Kompromittierung prüfen, Geheimnisse und Sitzungen erneuern.

## att-04 | Die Elternkette lügt manchmal
Prozessbäume erklären viel, aber Aufgabenplanung, WMI, COM und Dienste lassen einen neutralen Systemprozess als Elternteil erscheinen. Der Auslöser steht dann in deren eigenen Logs. Ausführung braucht zudem nicht immer einen neuen Prozess.

> [!PRAXIS] Denk weiter
> PowerShell mit kodiertem Befehl: bösartig? Nicht automatisch, Softwareverteilung tut das auch. Dekodieren, Herkunft, Konto und Folgeverbindungen prüfen.

## att-05 | Persistenz ohne Datei
Die langlebigste Persistenz liegt oft in der Identität: zusätzliche MFA-Methode, App-Zustimmung, API-Schlüssel, Delegation, Zertifikat. Eine Neuinstallation des Rechners entfernt davon nichts.

> [!PRAXIS] Denk weiter
> Wie suchst du vollständig? Mit Änderungsdifferenzen seit dem frühesten bekannten Zugriff über Host, Verzeichnis, Cloud und SaaS, nicht nur mit Autostart-Listen.

## att-06 | Grenzen genau benennen
Nicht jede Erhöhung endet bei root. Benutzer zu Dienst, Container zu Host, Rolle zu Rolle in der Cloud, Workload zu Pipeline sind eigene Grenzen. Das Recht, Rechte zu vergeben oder Code eines stärkeren Kontos zu ändern, ist gleichwertig mit diesem Konto.

> [!PRAXIS] Denk weiter
> Ein Konto darf „nur“ Gruppenrichtlinien bearbeiten. Wie stark ist es? So stark wie die mächtigsten Computer und Benutzer, auf die diese GPO wirkt.

## att-07 | Umgehung hinterlässt Änderungen
Wer Sichtbarkeit reduziert, verändert etwas: Ausnahme, Audit-Richtlinie, gestoppter Sensor, Lücke im Datenstrom. Diese Änderungen sind hochwertige Signale, sofern sie an ein System gemeldet werden, das der lokale Admin nicht kontrolliert.

> [!PRAXIS] Denk weiter
> Ein Host sendet seit einer Stunde nichts. Offline oder manipuliert? Gegen DHCP, VPN, DC-Anmeldungen oder Switch prüfen: Ist er dort aktiv, ist es ein Vorfall.

## att-08 | Anmeldedaten sind mehr als Passwörter
Hashes, Tickets, Cookies, Refresh-Tokens, Schlüssel und Workload-Identitäten sind gleichwertige Ziele. Jede Art hat eine andere Gegenmaßnahme: Wechsel, Widerruf, Ablauf oder Bindung an ein Gerät. MFA schützt die Anmeldung, nicht das danach ausgestellte Token.

> [!PRAXIS] Denk weiter
> Ein Server wurde gedumpt. Welche Konten wechseln? Alle, deren Material dort liegen konnte: angemeldete Nutzer, Dienste, Aufgaben, Agenten und gespeicherte Verbindungen.

## att-09 | Normal, aber in dieser Folge
Discovery-Befehle sind einzeln alltäglich. Aussagekräftig sind Dichte, Vielfalt und Akteur: fünf verschiedene Abfragen in zwei Minuten von einem Dienstkonto. Fenster und Schwelle werden je Rolle gesetzt, Admins und Inventarsysteme sehen genauso aus.

> [!PRAXIS] Denk weiter
> Warum ist LDAP-Discovery auf dem Client oft unsichtbar? Es braucht keinen neuen Prozess. LDAP-Telemetrie von EDR, DC oder Identitätssensor ist nötig.

## att-10 | Bewegung hat zwei Enden
Jede seitliche Bewegung erzeugt Spuren an Quelle, Ziel und Authentifizierungsstelle. Erst die Paarung zeigt Richtung und Ursache. Die Frage „War dieses Paar aus Konto, Quelle und Ziel je normal?“ schlägt die Suche nach Werkzeugnamen.

> [!PRAXIS] Denk weiter
> Warum hilft Client-zu-Client-SMB zu blockieren so stark? Es fehlt fast nie ein legitimer Nutzen, aber sehr vielen Ausbreitungstechniken der Weg.

## att-11 | Die Phase vor dem Abfluss
Sammeln braucht Lesen in Breite und oft einen Zwischenspeicher. Dateiserver-Auditing, SaaS-Suchabfragen und neue große Archive zeigen das früher als der Netzverkehr. Suchbegriffe verraten außerdem das Ziel des Angreifers.

> [!PRAXIS] Denk weiter
> Was sagst du dem Management ohne Datei-Audit? Dass sich der Umfang nicht belegen lässt: erreichbare Daten sind der mögliche, beobachtete der bestätigte Umfang.

## att-12 | Kanal ist nicht Ziel
C2 kann in erlaubten Diensten liegen, dann ist das Ziel vertrauenswürdig und nur die Nutzung falsch. Statistik braucht Toleranz für Zufallsversatz, der Prozesskontext liefert die Entscheidung. Blockst du einen Kanal, folgt oft ein zweiter.

> [!PRAXIS] Denk weiter
> Beim ersten Fund sofort blocken? Bei akutem Schaden ja. Sonst kurz den Umfang klären und koordiniert alle Hosts und Kanäle zusammen eindämmen.

## att-13 | Bytes ehrlich zählen
Eine Verbindung mit 5 GB Upload beweist Transport, nicht Inhalt. Umgekehrt gehen Cloud-zu-Cloud-Freigaben nie durch deine Firewall. Beachte bei Zählern die Richtung, Kompression und den Protokolloverhead.

> [!PRAXIS] Denk weiter
> Kein Abfluss in den Proxy-Logs. Ausgeschlossen? Nein, zuerst Abdeckung prüfen: direkte Wege, DNS, SaaS-Audit, Zeitraum. „Keine Belege“ ist die korrekte Formulierung.

## att-14 | Wiederanlauf folgt Abhängigkeiten
Auswirkung bemisst sich an Geschäftsprozessen. Ein ERP kommt nicht ohne DNS, Identität, Lizenzserver und Netz zurück, die RTO einer Anwendung enthält daher die ihrer Abhängigkeiten. Bei stiller Datenmanipulation ist außerdem unklar, welches Backup noch richtig ist.

> [!PRAXIS] Denk weiter
> RTO je System vier Stunden, fünf hängen nacheinander ab. Realistisch? Bis zu 20 Stunden, wenn nichts parallel geht.

## bsi-01 | Verantwortung bleibt oben
ISMS.1 wird oft an den ISB delegiert. Delegierbar ist die Arbeit, nicht die Verantwortung der Leitung. Ob das ISMS lebt, zeigt sich daran, ob Restrisiken dort unterschrieben und Ressourcenkonflikte dort entschieden werden.

> [!PRAXIS] Denk weiter
> ISB berichtet an die IT-Leitung. Problem? Interessenkonflikt. Ein unabhängiger Berichtsweg zur Leitung ist nötig.

## bsi-02 | Prozesse greifen ineinander
ORP versagt an Übergaben: Personal kennt den Austritt, die IT die Konten, der Fachbereich die SaaS-Zugänge. Geprüft wird mit Stichproben vom Ereignis zum System und umgekehrt vom Konto zur Person.

> [!PRAXIS] Denk weiter
> Wer geht am häufigsten unter? Interne Wechsel: Neue Rechte kommen dazu, alte bleiben. Rezertifizierung muss Entzug auslösen.

## bsi-03 | Konzept gegen Wirklichkeit
Ein Konzept ist Soll. Für CON zählt die Kette Vorgabe, Umsetzung, Nachweis: Kryptokonzept, tatsächliche Cipher, Scanbericht. Ein Datensicherungskonzept ohne gemessene Wiederherstellung belegt nur Absicht.

> [!PRAXIS] Denk weiter
> Das Konzept verlangt Löschung, Backups bewahren länger. Widerspruch? Auflösen: Frist dokumentieren, Zugriff sperren, nach einem Restore erneut löschen.

## bsi-04 | Betrieb ist Privileg
OPS betrifft die mächtigsten Wege: Admins, Fernwartung, Patch- und Verteilserver. Diese Systeme erben den höchsten Schutzbedarf der von ihnen verwalteten Systeme, auch wenn sie selbst keine Fachdaten speichern.

> [!PRAXIS] Denk weiter
> Patchen und Vieraugenprinzip bei einer aktiv ausgenutzten Lücke? Vorab definierter Notfall-Change: schnelle Freigabe, Nachdokumentation, Wirksamkeitsprüfung.

## bsi-05 | Erkennen und vorbereitet sein
DER hängt an Schwellen: Wann wird ein Ereignis zum Vorfall, wann zum Notfall, wer entscheidet nachts? Ohne benannte Auslöser und Vertretung kostet die Zuständigkeitsfrage mehr Zeit als die Technik. Forensische Vorsorge geschieht vorher.

> [!PRAXIS] Denk weiter
> Wie testest du DER ohne Technik? Tischübung um 22 Uhr mit nicht erreichbarer Hauptperson und echter Kontaktliste.

## bsi-06 | Baustein trifft Realität
Eine Anwendung braucht selten nur einen Baustein: Webanwendung, Webserver, Datenbank und Betriebssystem werden gemeinsam modelliert, jede Grenze hat einen Besitzer. Für nicht abgedeckte Komponenten folgt eine Risikoanalyse.

> [!PRAXIS] Denk weiter
> SaaS: entfällt die Umsetzung? Nein. Konfiguration, Rollen, Logs und Exit bleiben bei dir, der Rest wird über Nachweise des Anbieters geprüft.

## bsi-07 | Vererbung von Schutzbedarf
Schutzbedarf vererbt sich von Anwendungen auf Systeme nach Maximumprinzip. Kumulation kann ihn erhöhen (viele normale Anwendungen auf einem Host), Verteilung bei Redundanz die Verfügbarkeit senken.

> [!PRAXIS] Denk weiter
> Ein Hypervisor mit 60 normalen VMs: normal? Wahrscheinlich höher, denn sein Ausfall oder seine Übernahme trifft alle zugleich.

## bsi-08 | Safety entscheidet mit
IND-Anforderungen dürfen Safety nicht schwächen. Kontosperren, Agenten und Neustarts, in der IT Standard, können eine Anlage gefährden. Abweichungen werden mit Betreiber, Hersteller und Ersatzmaßnahme begründet.

> [!PRAXIS] Denk weiter
> Altes HMI, kein Patch möglich. Was schreibst du? Segment, erlaubte Verbindungen, Wechseldatenträger-Regel, Monitoring, Restrisiko und Ablösetermin.

## bsi-09 | Der Plan muss stimmen
NET beginnt mit einem belegten Netzplan. Schattenwege entstehen durch LTE-Router, Wartungs-VPNs, Doppelanbindungen und Cloud-Peerings. Abgleich von Plan, Routingtabellen, Regeln und tatsächlichen Flüssen findet sie.

> [!PRAXIS] Denk weiter
> Regel seit einem Jahr ohne Treffer. Löschen? Besitzer fragen, an Jahresprozesse und Notfallwege denken, befristet deaktivieren, dann löschen.

## bsi-10 | Umgehungen im Gebäude
Perimeter sind räumlich: Doppelboden, abgehängte Decke, Fenster, Reinigungsschlüssel, Not-Ausgang. Brandschutz und Fluchtwege haben Vorrang, Türen müssen im Notfall öffnen, also braucht es dort Meldung statt Verriegelung.

> [!PRAXIS] Denk weiter
> Serverraum sicher, Etagenverteiler offen. Folge? Netzzugang, Mitschnitt oder Ausfall. Schutzbedarf gilt entlang der Kabelwege.

## iso-01 | Controls brauchen Besitzer
Die 37 organisatorischen Controls sind nur prüfbar, wenn jedes einen Verantwortlichen, einen Auslöser und einen Nachweis hat. Ein Dokument belegt Gestaltung, erst Stichproben über einen Zeitraum belegen Wirksamkeit.

> [!PRAXIS] Denk weiter
> 5.7 Threat Intelligence: Reicht ein Newsletter-Abo? Nur, wenn nachweisbar daraus bewertet und gehandelt wird.

## iso-02 | Vom ersten bis nach dem letzten Tag
Personal-Controls sind rechtlich gebunden: Überprüfungen müssen zulässig und verhältnismäßig sein, Sanktionen Arbeitsrecht folgen. Pflichten wie Vertraulichkeit überdauern das Arbeitsverhältnis, wenn sie wirksam vereinbart sind.

> [!PRAXIS] Denk weiter
> Awareness 100 % absolviert. Wirksam? Das misst Teilnahme. Melderate, Meldezeit und wiederkehrende Vorfälle messen Wirkung.

## iso-03 | Zeit als Maß
Physischer Schutz funktioniert, wenn Widerstandszeit größer ist als Erkennungs- plus Interventionszeit. Eine Kamera, die niemand sieht, verkürzt die Erkennung nicht, sie liefert nur Beweise.

> [!PRAXIS] Denk weiter
> Tür hält 3 Minuten, Wachdienst braucht 20. Maßnahme? Mehr Widerstand weiter innen, schnellere Intervention oder Daten, die bei Diebstahl wertlos sind.

## iso-04 | Auswahl folgt Risiko
Annex A ist eine Vergleichsliste, kein Pflichtkatalog. Ausschlüsse werden in der SoA begründet, eigene Controls sind erlaubt. Die 34 technologischen Controls brauchen je System eine messbare Auslegung, ISO 27002 gibt dafür Hinweise.

> [!PRAXIS] Denk weiter
> „Wir entwickeln nicht“, also 8.25 bis 8.31 ausschließen? Erst Skripte, Low-Code, Anpassungen und beauftragte Entwicklung prüfen.

## rg-01 | Scope ist die halbe Prüfung
Im Scope ist auch, was die Sicherheit der Kartendatenumgebung beeinflussen kann: AD, Patchserver, Admin-Laptops. Tokenisierung verkleinert den Scope, Segmentierung muss durch Tests belegt sein. Sensible Authentifizierungsdaten wie CVV dürfen nach der Autorisierung nicht gespeichert werden.

> [!PRAXIS] Denk weiter
> Zahlung komplett beim Dienstleister. PCI DSS vorbei? Nein, der Umfang schrumpft. Dienstleistersteuerung und Schutz der weiterleitenden Seite bleiben.

## rg-02 | Verantwortung reist nicht mit
DORA gilt seit 17. Januar 2025 unmittelbar und geht für Finanzunternehmen NIS2 als speziellere Regel vor. Auslagerung verschiebt Arbeit, nicht Verantwortung. Das Informationsregister muss Verträge, Funktionen und Unterauftragsketten sichtbar machen.

> [!PRAXIS] Denk weiter
> Zwei Anbieter, beide auf derselben Cloud-Region. Redundant? Nicht gegen deren Ausfall: verdecktes Konzentrationsrisiko.

## rg-03 | Anlage und Einrichtung
Zwei Blickwinkel überlagern sich: Schwellenwerte bestimmen kritische **Anlagen**, NIS2 betrachtet **Einrichtungen** nach Sektor und Größe. Cyber- und physische Resilienz haben getrennte Rechtsgrundlagen. Meldefristen beginnen mit Kenntnis, nicht mit Abschluss der Analyse.

> [!PRAXIS] Denk weiter
> Unter dem KRITIS-Schwellenwert, also pflichtfrei? Nein, separat prüfen, ob man wichtige oder besonders wichtige Einrichtung ist.

## rg-04 | Label statt Zertifikat
TISAX ergibt Labels für bestimmte Standorte und Prüfziele, geteilt über die ENX-Plattform. Assessment Level beschreibt die Prüftiefe, der Reifegrad die Prozessgüte. Ein ISO-Zertifikat hilft, ersetzt es aber nicht.

> [!PRAXIS] Denk weiter
> Lieferant zeigt ein Label. Was prüfst du? Standort, Prüfziele, Gültigkeit und ob sie zu den Daten passen, die er von dir bekommt.

## dp-01 | Angriffe auf Anonymität
k-Anonymität verhindert das Herausgreifen über Quasi-Identifikatoren, nicht das Lernen des Attributs: Haben alle k Personen dieselbe Diagnose, ist sie bekannt. Verknüpfung mehrerer Veröffentlichungen senkt k. Differential Privacy begrenzt stattdessen messbar den Einfluss jeder Person, verbraucht aber Genauigkeit.

> [!PRAXIS] Denk weiter
> Telefonnummern gehasht: anonym? Nein, der Suchraum ist klein und vollständig durchrechenbar.

## dp-02 | Risiko für wen?
Die DSFA bewertet Risiken für **betroffene Personen**, nicht für die Firma. Auch eine perfekt gesicherte Verarbeitung kann riskant sein, etwa durch Diskriminierung oder Überwachungsdruck. Bleibt ein hohes Restrisiko, ist vorher die Aufsicht zu konsultieren (Art. 36).

> [!PRAXIS] Denk weiter
> Wann aktualisieren? Bei neuen Daten, Zwecken, Empfängern, Techniken oder Vorfällen.

## dp-03 | Löschen in Schichten
Ein Datum lebt in Datenbank, Suchindex, Cache, Export, Log und Backup. Fristen hängen an Startereignissen, bei Handelsunterlagen oft am Ende des Kalenderjahres. Auf SSDs ist Überschreiben unzuverlässig, Crypto-Erase oder herstellerseitiges Sanitize ist besser.

> [!PRAXIS] Denk weiter
> Löschwunsch trifft Aufbewahrungspflicht. Lösung? Nur das Pflichtige behalten, für andere Zwecke sperren, Person informieren, danach löschen.

## kar-01 | Übertragbares Können
Rollen unterscheiden sich weniger im Wissen als im Produkt: Alarmentscheidung, Befund, Plattform, Risikobewertung. Wähle nach der Arbeit, die du täglich tun willst. Belege mit kleinen fertigen Produkten wie einer getesteten Regel oder einem Beispielbericht ohne echte Kundendaten.

> [!PRAXIS] Denk weiter
> Stelle verlangt drei Jahre, du hast eines. Bewerben? Ja, wenn du die Kernaufgaben mit Belegen zeigen kannst.

## kar-02 | Notizen, die man wiederfindet
Nützliche Notizen sind nach künftiger Situation benannt („Kerberos scheitert über IP“), nicht nach Quelle („Modul 7“). Schreibe in eigenen Worten mit Gültigkeitsversion. Abschreiben fühlt sich wie Lernen an, erst Abrufen prüft es.

> [!PRAXIS] Denk weiter
> Was darf nie in die private Wissensbasis? Kundendaten, Zugangsdaten und prüfungsinterne Inhalte. Verallgemeinerte Methodik schon.

## kar-03 | Hängen mit System
Hängen hat drei Ursachen: fehlende Information, falsche Annahme, fehlende Fertigkeit. Setze ein Zeitlimit, schreibe drei Annahmen auf und teste die billigste. Tunnelblick wird mit Müdigkeit schlimmer.

> [!PRAXIS] Denk weiter
> Vier Stunden Rest, ein Ziel offen, Bericht leer. Was tun? Bericht zuerst sichern, erst danach das Ziel mit festem Zeitfenster.

## kar-04 | Lösungen richtig lesen
Nach dem Lösen lehrt ein Writeup Alternativen, nach dem Scheitern nur, wenn du am ersten unbekannten Schritt stoppst und allein weitermachst. Wiederhole die Aufgabe nach einer Woche ohne Text. Echte Systeme haben keine garantierte Flag, oft ist „nicht verwundbar“ das Ergebnis.

> [!PRAXIS] Denk weiter
> Du findest eine Lücke in der CTF-Plattform selbst. Nutzen? Nein, melden. Sie ist nicht im Scope.
