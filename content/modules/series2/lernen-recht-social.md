---
id: kl-01
title: Besser lernen 1 · Wie das Gedächtnis funktioniert
paths: grundlagen, cjca
order: 0.01
difficulty: easy
icon: brain.head.profile
tags: lernen, gedächtnis
summary: Vergessenskurve, Abrufübung, verteiltes Lernen, Interleaving und Schlaf – die Lernforschung hinter NIMA und wie du sie für dich nutzt.
---

## Einfach erklärt

Das Gehirn ist kein Speicher, in den man Dinge einmal hineinlegt. Es ist eher ein Trampelpfad im Wald: Je öfter man ihn geht, desto deutlicher wird er. Geht man ihn lange nicht, wächst er wieder zu. Gutes Lernen heißt: den Pfad **im richtigen Abstand** wieder begehen.

## Die vier wirksamsten Methoden

| Methode | Was | Wie NIMA hilft |
|---|---|---|
| **Abrufübung** (Retrieval Practice) | aktiv erinnern statt nur wieder lesen | Quiz, Karteikarten, Wissens-Checks nach jeder Lektion |
| **Verteiltes Lernen** (Spacing) | Wiederholung über Tage verteilt | Spaced Repetition plant jede Karte |
| **Vermischtes Üben** (Interleaving) | Themen mischen statt blockweise | Training über ganze Pfade |
| **Elaboration** | Erklären, warum etwas so ist | „Warum?“-Erklärungen, eigene Notizen |

## Die Vergessenskurve

Ohne Wiederholung vergessen wir einen großen Teil neuer Informationen innerhalb weniger Tage. Jede erfolgreiche Wiederholung flacht die Kurve ab – deshalb werden die Abstände in NIMA nach jeder richtigen Antwort länger (1 Tag, 3 Tage, eine Woche, …).

> [!TIPP] Ehrlich bewerten
> Bei Karteikarten ist „Nochmal“ keine Niederlage, sondern die wichtigste Information für die Lernkartei. Wer sich selbst belügt, wiederholt zu selten.

## Tiefer eingetaucht

Weitere Faktoren:

- **Schlaf** festigt Gelerntes – kurz vor dem Schlafen wiederholen ist effektiv.
- **Wünschenswerte Erschwernisse**: Lernen, das sich etwas anstrengend anfühlt (Abruf statt Wiederlesen), bleibt besser hängen.
- **Illusion des Wissens**: Wiederlesen fühlt sich gut an, bringt aber wenig. Sich selbst testen deckt Lücken auf.
- **Feynman-Technik**: Ein Thema so erklären, als würde man es einem Kind beibringen – wo es hakt, ist die Lücke.
- **Pausen**: Konzentration nimmt nach 25–50 Minuten ab; kurze Pausen helfen.

## Quiz

? Welche Lernmethode ist wirksamer als erneutes Lesen?
+ Abrufübung (sich selbst testen)
- Markieren mit Textmarker
- Abschreiben
- Hintergrundmusik
! Aktives Erinnern stärkt den „Trampelpfad“.

? Was bedeutet verteiltes Lernen?
+ Wiederholungen über mehrere Tage mit wachsenden Abständen
- alles an einem Tag lernen
- in Gruppen lernen
- nur am Wochenende lernen
! Das ist der Kern von Spaced Repetition.

?tf Bei Karteikarten sollte man sich lieber zu gut als zu schlecht bewerten.
= falsch
! Ehrliche Bewertung steuert die Wiederholungen richtig.

? Wie heißt die Methode, ein Thema so einfach zu erklären, dass Lücken sichtbar werden?
= Feynman-Technik
= Feynman
! Wo die Erklärung hakt, fehlt Verständnis.

? Was festigt Gelerntes über Nacht?
= Schlaf
! Wiederholen vor dem Schlafen ist besonders wirksam.

? Was ist Interleaving?
+ verschiedene Themen beim Üben mischen
- ein Thema blockweise üben
- nur neue Inhalte lernen
- Lernen mit Musik
! Fördert das Unterscheiden und Anwenden.

@@@ MODULE @@@
---
id: kl-02
title: Besser lernen 2 · Ein Homelab bauen
paths: grundlagen, cjca, cyberrange
order: 0.02
difficulty: easy
icon: desktopcomputer.and.arrow.down
tags: lernen, labor, homelab
summary: Wie man mit vorhandener Hardware ein sicheres Übungslabor aufbaut – Virtualisierung, Netztrennung, Snapshots und sinnvolle erste Projekte.
---

## Einfach erklärt

Ein Homelab ist dein eigener Trainingsplatz: ein paar virtuelle Maschinen auf deinem Rechner oder einem alten PC, in denen du alles ausprobieren darfst – angreifen, verteidigen, kaputt machen, wiederherstellen. Ohne Risiko für echte Systeme und ohne Erlaubnis von anderen.

## Einstieg in drei Stufen

| Stufe | Hardware | Software |
|---|---|---|
| Laptop-Labor | 16 GB RAM | VirtualBox/VMware Workstation/Hyper-V, 2–3 VMs |
| Alter PC/Mini-PC | 32–64 GB RAM | Proxmox VE als Hypervisor |
| Fortgeschritten | Server oder mehrere Mini-PCs | Proxmox-Cluster, eigene Firewall-VM, Monitoring |

## Erste Projekte

1. **Angreifer-VM** (Kali/Parrot) + **absichtlich verwundbare VM** in einem **isolierten Netz**.
2. **Windows-Domäne**: Windows Server (Evaluierungsversion) als DC + Windows-Client.
3. **Monitoring**: Wazuh oder Security Onion beobachtet die Domäne.
4. **Firewall-VM** (OPNsense) trennt Netze.
5. **Purple-Projekt**: Technik ausführen → Logs ansehen → Erkennung bauen.

> [!WARNUNG] Labor isolieren
> Verwundbare Systeme niemals direkt ins Heimnetz oder Internet stellen. Ein internes/Host-only-Netz oder eine Firewall-VM trennt das Labor.

## Tiefer eingetaucht

**Snapshots** vor jedem Experiment machen Fehler folgenlos. **Dokumentation** im Labor (Netzplan, Zugangsdaten, was wurde wie gebaut) übt genau das, was im Beruf gefragt ist. Automatisierung (Ansible, Terraform) kommt später – sie macht das Labor reproduzierbar und ist selbst eine gefragte Fähigkeit.

Für Bewerbungen ist ein dokumentiertes Homelab (z. B. als Blog oder Repository mit Aufbau, Erkenntnissen, eigenen Erkennungsregeln) oft überzeugender als eine weitere Zertifikatszeile.

## Quiz

? Welcher Hypervisor eignet sich gut für einen alten PC als Laborserver?
= Proxmox VE
= Proxmox
! Kostenlos, webbasiert, mit Snapshots und Clustern.

? Warum sollten verwundbare Labor-VMs isoliert werden?
+ damit sie nicht aus dem Heimnetz oder Internet angreifbar sind
- weil sie sonst langsamer sind
- weil sie sonst keine IP bekommen
- damit sie mehr Speicher haben
! Ein internes Netz oder eine Firewall-VM trennt das Labor.

?tf Snapshots ermöglichen es, nach einem fehlgeschlagenen Experiment zum sauberen Zustand zurückzukehren.
= wahr
! Vor jedem Experiment anlegen.

? Was ist ein sinnvolles Purple-Projekt im Homelab?
+ Technik ausführen, Logs ansehen, Erkennung bauen
- nur Angriffe ausführen
- nur Updates installieren
- Server dauerhaft ausschalten
! Verbindet Angriff und Verteidigung.

? Wie viel RAM ist für ein einfaches Laptop-Labor mit 2–3 VMs ein sinnvoller Start?
= 16 GB
= 16
! Mehr ist besser, aber 16 GB reichen für den Anfang.

@@@ MODULE @@@
---
id: kl-03
title: Besser lernen 3 · Bewerbung, Interview und erster Job
paths: grundlagen, specialist
order: 92.5
difficulty: easy
icon: briefcase.fill
tags: karriere, bewerbung
summary: Wie man sich für Einstiegsrollen in der Cybersicherheit bewirbt – Lebenslauf, Portfolio, typische Interviewfragen und die ersten 90 Tage.
---

## Einfach erklärt

Arbeitgeber in der Cybersicherheit suchen nicht nur Zertifikate, sondern Menschen, die **lernen wollen**, **strukturiert denken** und **verständlich kommunizieren**. Wer das zeigen kann, hat auch ohne jahrelange Erfahrung gute Chancen.

## Bewerbungsunterlagen

- **Lebenslauf**: Projekte und Ergebnisse statt Werkzeuglisten („Wazuh-Labor mit 8 Systemen aufgebaut, 15 eigene Erkennungsregeln geschrieben“).
- **Portfolio**: GitHub mit Skripten/Regeln, Blogartikel zu gelösten Laboren (ohne Lösungen aktiver Prüfungen zu verraten!), Homelab-Dokumentation.
- **Zertifikate**: passend zur Rolle (SOC → CDSA, Pentest → CPTS/CJCA).

## Typische Interviewfragen

| Frage | Worauf es ankommt |
|---|---|
| „Was passiert, wenn du eine URL im Browser eingibst?“ | Grundlagen in der richtigen Reihenfolge |
| „Erkläre den Unterschied zwischen Authentifizierung und Autorisierung.“ | klare Begriffe |
| „Du siehst 200 Fehlanmeldungen eines Kontos – was tust du?“ | strukturiertes Vorgehen, Fragen stellen |
| „Wie erklärst du Phishing deiner Großmutter?“ | Kommunikation |
| „Woran arbeitest du gerade privat?“ | Neugier, Eigeninitiative |
| „Was weißt du nicht?“ | Ehrlichkeit, Lernbereitschaft |

> [!TIPP] Laut denken
> Bei technischen Fragen ist der Weg wichtiger als die perfekte Antwort. Sag, wie du vorgehen würdest, und welche Informationen du noch bräuchtest.

## Die ersten 90 Tage

1. Umgebung kennenlernen: Netzplan, wichtigste Systeme, Prozesse, Ansprechpartner.
2. Fragen stellen und notieren – eigene Wissensdatenbank aufbauen.
3. Kleine Verbesserungen liefern (eine Abfrage, eine Dokumentation, ein Skript).
4. Feedback aktiv einholen.

## Tiefer eingetaucht

Einstiegsrollen: SOC-Analyst (L1), IT-Administrator mit Sicherheitsfokus, Junior-Pentester, GRC/ISMS-Assistenz, Vulnerability-Management. Quereinsteiger aus IT-Betrieb, Entwicklung oder Netzwerktechnik bringen wertvolles Wissen mit – Sicherheit lebt von genau diesem Systemverständnis.

## Quiz

? Was überzeugt im Lebenslauf mehr als eine reine Werkzeugliste?
+ konkrete Projekte mit Ergebnissen
- möglichst viele Abkürzungen
- ein buntes Layout
- Hobbys ohne Bezug
! Zeigt, was man tatsächlich kann.

? Wie geht man im Interview mit einer schwierigen technischen Frage um?
+ laut denken und das Vorgehen erklären
- schweigen
- irgendetwas raten
- das Thema wechseln
! Der Lösungsweg zählt mehr als die perfekte Antwort.

?tf Lösungen zu aktiven Prüfungsaufgaben öffentlich zu posten ist eine gute Portfolio-Idee.
= falsch
! Das verstößt meist gegen Regeln der Plattformen und Prüfungen.

? Was ist in den ersten 90 Tagen sinnvoll?
+ Umgebung kennenlernen und eigene Wissensdatenbank aufbauen
+ kleine Verbesserungen liefern
- sofort alle Prozesse umwerfen
- keine Fragen stellen
! Verstehen vor Verändern.

? Welche Einstiegsrolle passt zum Zertifikat CDSA?
+ SOC-Analyst
- Webdesigner
- Netzwerkkabel-Verleger
- Buchhalter
! CDSA ist auf Analyse und Verteidigung ausgerichtet.

@@@ MODULE @@@
---
id: dr-01
title: Recht & Datenschutz 1 · Hackerparagrafen und Grenzen der Sicherheitsforschung
paths: specialist, cpts, cjca
order: 5.5
difficulty: medium
icon: building.columns
tags: recht, strafrecht
summary: §§ 202a–c, 303a/b StGB verständlich erklärt, was Sicherheitsforschung darf, wie Verträge schützen und wie man verantwortungsvoll meldet.
---

## Einfach erklärt

Im Strafgesetzbuch gibt es Regeln, die unbefugtes Eindringen in Computer, Abfangen von Daten und Sabotage unter Strafe stellen. Für Sicherheitsleute heißt das: **Die Erlaubnis macht den Unterschied** zwischen Beruf und Straftat. Ohne Auftrag ist auch gut gemeintes Testen riskant.

## Die wichtigsten Normen (Deutschland, vereinfacht)

| Norm | Inhalt |
|---|---|
| § 202a StGB | Ausspähen von Daten: Zugang zu besonders gesicherten Daten unter Überwindung der Sicherung |
| § 202b StGB | Abfangen von Daten aus nichtöffentlicher Übermittlung |
| § 202c StGB | Vorbereiten: Herstellen/Verschaffen von Passwörtern oder Programmen zur Begehung von 202a/b |
| § 202d StGB | Datenhehlerei |
| § 303a StGB | Datenveränderung |
| § 303b StGB | Computersabotage |

> [!MERKE] Werkzeuge an sich
> § 202c richtet sich nach der Rechtsprechung gegen Werkzeuge, deren **Zweck** die Begehung von Straftaten ist. Sicherheitswerkzeuge für erlaubte Tests sind in der Praxis nicht verboten – entscheidend ist der Einsatz.

## Schutz durch Verträge

- Schriftlicher Auftrag mit Scope, Zeitraum, erlaubten Methoden.
- Erklärung des Verfügungsberechtigten (Eigentümer, ggf. Hoster/Cloud-Anbieter).
- Haftungsregelung, Vertraulichkeit, Umgang mit gefundenen Daten.

## Verantwortungsvolle Meldung

Findet man zufällig eine Schwachstelle (ohne Test, z. B. beim normalen Nutzen):

1. Nicht weiter ausnutzen, keine Daten abrufen oder verändern.
2. Kontakt über offizielle Wege suchen (`security.txt`, Bug-Bounty, CERT).
3. Sachlich beschreiben, Zeit zur Behebung geben.
4. Im Zweifel über eine vermittelnde Stelle (z. B. CERT) melden.

## Tiefer eingetaucht

Die Rechtslage zur Sicherheitsforschung wird in Deutschland seit Jahren diskutiert (Forderungen nach klarer Straffreiheit für gutgläubige Forschung). Bis dahin gilt: Vorsicht, Dokumentation, Erlaubnis. Andere Länder haben eigene Regeln (z. B. Computer Fraud and Abuse Act in den USA) – bei internationalen Aufträgen ist Rechtsberatung sinnvoll.

## Quiz

? Welche Norm betrifft das Ausspähen von Daten unter Überwindung einer Zugangssicherung?
= § 202a StGB
= 202a
! Der Kern des sogenannten „Hackerparagrafen“-Komplexes.

? Was unterscheidet einen legalen Pentest von einer Straftat am deutlichsten?
+ die Erlaubnis des Verfügungsberechtigten
- die eingesetzten Werkzeuge
- die Tageszeit
- die Dauer des Tests
! Ohne Auftrag ist auch gut gemeintes Testen riskant.

? Welche Norm betrifft Computersabotage?
= § 303b StGB
= 303b
! § 303a betrifft Datenveränderung.

?tf Wer zufällig eine Schwachstelle entdeckt, sollte sie weiter ausnutzen, um den Schweregrad zu beweisen.
= falsch
! Nicht weiter ausnutzen, sondern verantwortungsvoll melden.

? Welche Datei auf Webseiten nennt Kontaktwege für Sicherheitsmeldungen?
= security.txt
! Liegt typischerweise unter /.well-known/security.txt.

@@@ MODULE @@@
---
id: dr-02
title: Recht & Datenschutz 2 · DSGVO für Sicherheitsteams
paths: specialist, cdsa
order: 5.6
difficulty: medium
icon: person.badge.shield.checkmark.fill
tags: dsgvo, datenschutz
summary: Was die DSGVO für Logging, Monitoring, Forensik und Vorfälle bedeutet – Rechtsgrundlagen, Zweckbindung, Speicherdauer und Meldepflichten.
---

## Einfach erklärt

Sicherheitsteams verarbeiten ständig personenbezogene Daten: Logs mit Benutzernamen und IP-Adressen, E-Mails bei Phishing-Analysen, Bildschirmaufnahmen in der Forensik. Die DSGVO verbietet das nicht – sie verlangt aber, dass es **begründet, begrenzt und transparent** geschieht.

## Grundsätze (Art. 5)

| Grundsatz | Bedeutung für Security |
|---|---|
| Rechtmäßigkeit | Rechtsgrundlage, oft berechtigtes Interesse (Art. 6 Abs. 1 f) bzw. Pflicht zur Sicherheit (Art. 32) |
| Zweckbindung | Sicherheitslogs nicht zur Leistungskontrolle missbrauchen |
| Datenminimierung | nur erheben, was für die Sicherheit nötig ist |
| Speicherbegrenzung | Aufbewahrungsfristen festlegen und einhalten |
| Integrität/Vertraulichkeit | Logs selbst schützen (Zugriff, Verschlüsselung) |
| Rechenschaftspflicht | dokumentieren, warum und wie |

## Typische Fragen

- **Wie lange Logs aufbewahren?** So lange wie für Erkennung und Untersuchung nötig – häufig wenige Monate bis ein Jahr; begründen und dokumentieren.
- **Darf das SOC E-Mails lesen?** Für konkrete Sicherheitsvorfälle mit klaren Regeln, Protokollierung und Vier-Augen-Prinzip; Betriebsvereinbarung beachten.
- **Pseudonymisierung**: Analysten sehen zunächst pseudonyme Kennungen, Aufdeckung nur bei Verdacht.

> [!GEFAHR] Meldepflicht bei Datenpannen
> Verletzungen des Schutzes personenbezogener Daten sind binnen **72 Stunden** der Aufsichtsbehörde zu melden (Art. 33), wenn ein Risiko für Betroffene besteht; bei hohem Risiko auch den Betroffenen (Art. 34).

## Tiefer eingetaucht

Ein **Verzeichnis der Verarbeitungstätigkeiten** sollte SIEM, EDR, DLP und Forensikwerkzeuge enthalten; für umfangreiches Monitoring kann eine **Datenschutz-Folgenabschätzung** nötig sein. Der **Betriebsrat** hat in Deutschland bei technischen Einrichtungen zur Leistungs- und Verhaltenskontrolle ein Mitbestimmungsrecht (§ 87 Abs. 1 Nr. 6 BetrVG) – frühe Einbindung schafft Akzeptanz und Rechtssicherheit.

Auch Dienstleister (MSSP, Cloud-SIEM) brauchen einen **Auftragsverarbeitungsvertrag** und ggf. Regeln für Drittlandübermittlungen.

## Quiz

? Innerhalb welcher Frist muss eine meldepflichtige Datenpanne der Aufsichtsbehörde gemeldet werden?
= 72 Stunden
= 72
! Art. 33 DSGVO.

? Welcher Grundsatz verbietet, Sicherheitslogs für Leistungskontrolle zu missbrauchen?
= Zweckbindung
! Daten nur für den festgelegten Zweck verwenden.

? Welches Mitbestimmungsrecht hat der Betriebsrat bei Überwachungstechnik?
+ § 87 Abs. 1 Nr. 6 BetrVG
- § 202a StGB
- Art. 17 DSGVO
- § 1 BGB
! Technische Einrichtungen zur Leistungs- und Verhaltenskontrolle sind mitbestimmungspflichtig.

?tf Pseudonymisierung kann helfen, Monitoring datenschutzfreundlicher zu gestalten.
= wahr
! Aufdeckung nur bei begründetem Verdacht.

? Welcher Vertrag ist mit einem externen SOC-Dienstleister nötig?
= Auftragsverarbeitungsvertrag
= AVV
! Er regelt die Verarbeitung personenbezogener Daten im Auftrag.

@@@ MODULE @@@
---
id: dr-03
title: Recht & Datenschutz 3 · Verträge mit Dienstleistern und Cloud-Anbietern
paths: specialist
order: 5.7
difficulty: medium
icon: signature
tags: verträge, lieferkette, cloud
summary: Was in Verträge mit IT-Dienstleistern gehört – Sicherheitsanforderungen, Audit- und Meldepflichten, Subunternehmer, Exit-Strategie.
---

## Einfach erklärt

Wer IT auslagert, lagert die Verantwortung nicht mit aus. Der Vertrag ist das wichtigste Werkzeug, um sicherzustellen, dass der Dienstleister so sorgfältig arbeitet, wie man es selbst müsste – und dass man im Ernstfall informiert wird.

## Vertragsbausteine

| Baustein | Inhalt |
|---|---|
| Sicherheitsanforderungen | Mindeststandards (z. B. ISO 27001, BSI C5, MFA, Verschlüsselung, Patchfristen) |
| Nachweise | Zertifikate, Prüfberichte (SOC 2, C5-Testat), Penetrationstests |
| Auditrechte | eigene Prüfungen oder durch Dritte |
| Meldepflichten | Sicherheitsvorfälle binnen festgelegter Frist (z. B. 24 h) |
| Subunternehmer | Zustimmung, gleiche Pflichten weitergeben |
| Datenstandort | Regionen, Drittländer |
| Verfügbarkeit (SLA) | Zusagen und Konsequenzen |
| Exit-Strategie | Datenrückgabe, Formate, Löschung, Übergangszeit |
| Haftung und Versicherung | Begrenzungen, Cyberversicherung |

> [!TIPP] Fragebögen allein reichen nicht
> Selbstauskünfte sind ein Anfang. Für kritische Dienstleister zusätzlich Nachweise anfordern, technische Schnittstellen prüfen (Zugänge, Fernwartung) und regelmäßig neu bewerten.

## Tiefer eingetaucht

Regulierungen verschärfen die Anforderungen: **NIS2** verlangt Lieferkettensicherheit, **DORA** im Finanzsektor detaillierte Verträge mit IKT-Dienstleistern inklusive Exit-Plänen und Register aller Vereinbarungen. Für Cloud-Dienste in Deutschland ist der **BSI C5**-Katalog ein verbreiteter Nachweis.

Technisch wichtig: Fernwartungszugänge von Dienstleistern sind häufige Einfallstore. Sie gehören in PAM, mit MFA, Freigabe pro Sitzung und Aufzeichnung.

## Quiz

? Was sollte ein Vertrag mit einem IT-Dienstleister zu Sicherheitsvorfällen regeln?
+ eine Meldepflicht mit fester Frist
- nichts
- nur die Rechnungsadresse
- die Bürogröße
! Ohne Meldung erfährt man von Vorfällen beim Dienstleister womöglich zu spät.

? Welcher BSI-Katalog ist ein verbreiteter Nachweis für Cloud-Dienste?
= C5
= BSI C5
! Cloud Computing Compliance Criteria Catalogue.

?tf Wer IT auslagert, gibt die Verantwortung für die Sicherheit vollständig ab.
= falsch
! Die Verantwortung bleibt beim Auftraggeber.

? Was regelt eine Exit-Strategie im Vertrag?
+ Datenrückgabe, Formate, Löschung und Übergangszeit beim Vertragsende
- die Notausgänge im Rechenzentrum
- den Feierabend des Dienstleisters
- die Firewall-Regeln
! Wichtig, um nicht abhängig zu werden.

? Wie sollten Fernwartungszugänge von Dienstleistern abgesichert sein?
+ über PAM mit MFA, Freigabe pro Sitzung und Aufzeichnung
- mit einem gemeinsamen Passwort für alle
- dauerhaft offen
- ohne Protokollierung
! Fernwartung ist ein häufiges Einfallstor.

@@@ MODULE @@@
---
id: mx-01
title: Social Engineering 1 · Pretexting, Vishing und Deepfakes
paths: specialist, cjca
order: 8.5
difficulty: easy
icon: person.wave.2.fill
tags: social engineering, awareness
summary: Wie professionelle Täuschung funktioniert – vorgetäuschte Rollen, Telefonbetrug, KI-Stimmen und Videos – und welche Prozesse zuverlässig schützen.
---

## Einfach erklärt

Beim **Pretexting** erfindet der Angreifer eine glaubwürdige Geschichte: „Hier ist Müller vom IT-Support, wir haben ein Problem mit Ihrem Konto …“ Mit Wissen aus sozialen Netzwerken und einem selbstsicheren Auftreten wirkt das echt. Heute kommen KI-Stimmen und Videos (Deepfakes) dazu: Der „Chef“ ruft an und klingt genau wie der Chef.

## Typische Szenarien

| Szenario | Ziel |
|---|---|
| falscher IT-Support | Passwort, MFA-Code, Fernwartung installieren |
| CEO-Fraud | eilige, vertrauliche Überweisung |
| Lieferant mit neuer Bankverbindung | Zahlungen umleiten |
| Helpdesk-Angriff | Passwort-Reset oder neue MFA-Registrierung für fremdes Konto |
| Bewerber mit präpariertem Anhang | Malware einschleusen |

> [!MERKE] Prozesse schlagen Bauchgefühl
> Gegen perfekte Täuschung hilft nicht „besser aufpassen“, sondern ein Prozess, der unabhängig vom Gefühl gilt: Rückruf über bekannte Nummer, Vier-Augen-Prinzip bei Zahlungen, feste Verifizierung am Helpdesk.

## Schutzmaßnahmen

1. **Rückruf** über eine bekannte, nicht in der Nachricht genannte Nummer.
2. **Codewörter** für außergewöhnliche Anweisungen (z. B. im Vorstand).
3. **Helpdesk-Verifizierung**: Identität prüfen, bevor Passwörter oder MFA zurückgesetzt werden (z. B. Video-Ident, Vorgesetzten-Bestätigung).
4. **Zahlungsprozess**: Änderungen von Bankverbindungen nur nach unabhängiger Prüfung.
5. **Kultur**: Nachfragen ist erwünscht – auch beim Chef.

## Tiefer eingetaucht

Große Vorfälle der letzten Jahre begannen mit Anrufen beim Helpdesk, bei denen sich Angreifer als Mitarbeitende ausgaben und eine neue MFA-Registrierung erreichten. Der Helpdesk ist damit Tier-0-nah: Wer dort Identitäten zurücksetzen kann, braucht strenge Verifizierungsprozesse.

Deepfake-Erkennung per Auge ist unzuverlässig. Wirksamer sind Prozesse, die nicht auf Stimme oder Bild vertrauen, und technische Kontrollen (z. B. phishing-resistente MFA, die sich nicht per Telefon „weitergeben“ lässt).

## Quiz

? Was ist Pretexting?
+ eine erfundene, glaubwürdige Geschichte zur Täuschung
- ein Verschlüsselungsverfahren
- ein Firewall-Typ
- ein Backup-Format
! Der Angreifer gibt sich z. B. als IT-Support aus.

? Was schützt am besten gegen CEO-Fraud?
+ ein verbindlicher Prozess mit Rückruf und Vier-Augen-Prinzip
- längere E-Mail-Signaturen
- ein schnellerer Zahlungsprozess
- Vertrauen in die Stimme des Anrufers
! Prozesse gelten unabhängig vom Bauchgefühl.

?tf Deepfakes lassen sich mit bloßem Auge zuverlässig erkennen.
= falsch
! Deshalb nicht auf Stimme oder Bild allein vertrauen.

? Warum ist der Helpdesk ein beliebtes Ziel?
+ er kann Passwörter und MFA zurücksetzen
- er hat die meisten Computer
- er arbeitet nachts
- er hat kein Telefon
! Strenge Identitätsprüfung ist dort Pflicht.

? Wie sollte man bei einem verdächtigen Anruf vom „IT-Support“ reagieren?
+ auflegen und über eine bekannte Nummer zurückrufen
- sofort den MFA-Code nennen
- die Fernwartung installieren
- das Passwort per Mail schicken
! Echter Support fragt nie nach Passwörtern oder Codes.

@@@ MODULE @@@
---
id: mx-02
title: Social Engineering 2 · Ein Awareness-Programm, das wirkt
paths: specialist
order: 8.6
difficulty: easy
icon: megaphone.fill
tags: awareness, schulung
summary: Wie man Sicherheitsbewusstsein nachhaltig aufbaut – Zielgruppen, kurze Formate, Phishing-Simulationen mit Augenmaß, Meldekultur und Messung.
---

## Einfach erklärt

Eine jährliche Pflichtschulung mit 60 Folien ändert kaum Verhalten. Wirksam ist, was **regelmäßig, kurz, relevant und positiv** ist – wie Zähneputzen statt einmal jährlich zum Zahnarzt.

## Bausteine

| Baustein | Beispiel |
|---|---|
| Kurze Lerneinheiten | 5-Minuten-Videos, Quiz, Newsletter |
| Zielgruppenspezifisch | Buchhaltung: Rechnungsbetrug; Entwickler: Secrets; Vorstand: CEO-Fraud |
| Phishing-Simulationen | realistisch, mit sofortigem Lernmoment |
| Meldebutton | ein Klick zum Melden verdächtiger Mails |
| Rückmeldung | „Danke für deine Meldung – das war echt/eine Übung“ |
| Champions | Ansprechpartner in den Abteilungen |
| Aktionen | Security-Woche, Escape Room, Live-Hacking-Vortrag |

> [!MERKE] Melden belohnen, nicht Klicken bestrafen
> Wer Angst vor Strafe hat, verschweigt Fehler. Die wichtigste Kennzahl ist die **Melderate**, nicht die Klickrate.

## Phishing-Simulationen mit Augenmaß

- Ankündigen, dass simuliert wird (nicht wann).
- Keine Themen, die Vertrauen zerstören (z. B. falsche Gehaltserhöhung, Pandemie-Notfälle).
- Sofortige, freundliche Lernseite statt Bloßstellung.
- Ergebnisse nur aggregiert auswerten; Betriebsrat einbinden.
- Schwierigkeitsgrad steigern.

## Tiefer eingetaucht

Messung: Melderate, Zeit bis zur ersten Meldung bei echten Kampagnen (wie schnell weiß das SOC Bescheid?), Wiederholungstäter-Quote, Teilnahme an Lerneinheiten, Ergebnisse von Kurz-Quiz. Gute Programme verbinden Awareness mit Technik: Der Meldebutton landet direkt im SOC-Workflow, gemeldete Mails werden automatisch analysiert und bei echten Funden aus allen Postfächern entfernt.

## Quiz

? Welche Kennzahl ist bei Phishing-Simulationen am aussagekräftigsten?
+ die Melderate
- die Anzahl versendeter Mails
- die Farbe der Mails
- die Anzahl der Folien
! Melden ist das gewünschte Verhalten.

? Was macht Awareness-Maßnahmen wirksam?
+ regelmäßig, kurz und zielgruppenspezifisch
- einmal jährlich, lang und allgemein
- nur per Aushang
- ohne Rückmeldung
! Wie Zähneputzen statt einmal jährlich zum Zahnarzt.

?tf Mitarbeitende, die bei einer Simulation klicken, sollten öffentlich bloßgestellt werden.
= falsch
! Das zerstört Vertrauen und verhindert das Melden echter Fehler.

? Was sollte nach dem Klick auf einen simulierten Phishing-Link erscheinen?
+ eine freundliche Lernseite mit Erklärung
- eine Abmahnung
- ein Virus
- nichts
! Der Lernmoment ist am wirksamsten, wenn er sofort kommt.

? Wohin sollten gemeldete Mails idealerweise gelangen?
+ direkt in den SOC-Workflow zur Analyse
- in den Papierkorb
- an den Absender zurück
- an alle Mitarbeitenden
! So wird aus Meldungen schnelle Abwehr.

@@@ MODULE @@@
---
id: mx-03
title: Physische Sicherheit · Zutritt, Tailgating und Rechenzentren
paths: specialist
order: 12.5
difficulty: easy
icon: door.left.hand.closed
tags: physische sicherheit, zutritt
summary: Wie physischer Zugang IT-Sicherheit aushebeln kann und welche Maßnahmen – von Zonen über Ausweise bis Clean Desk – wirklich schützen.
---

## Einfach erklärt

Die stärkste Verschlüsselung hilft nichts, wenn jemand einfach in den Serverraum spaziert oder einen USB-Stick in einen unbeaufsichtigten Rechner steckt. **Physische Sicherheit** ist die erste Verteidigungslinie – und wird oft unterschätzt.

## Typische Schwächen

| Schwäche | Beispiel |
|---|---|
| Tailgating / Piggybacking | jemand folgt einem Mitarbeitenden durch die Tür |
| Kopierbare Ausweise | alte 125-kHz-Karten |
| Offene Netzwerkdosen | in Besprechungsräumen, Empfang |
| Unbeaufsichtigte Geräte | entsperrte Rechner, Laptops im Auto |
| Ausgedruckte Daten | Passwörter auf Zetteln, Dokumente im Drucker |
| Entsorgung | Festplatten und Akten im normalen Müll |

## Schutzmaßnahmen

- **Zonenkonzept**: öffentlich – Büro – Sicherheitsbereich – Rechenzentrum, mit steigender Kontrolle.
- **Zutrittskontrolle** mit sicheren Karten, ggf. zweiter Faktor (PIN, Biometrie) für kritische Bereiche.
- **Besucherregeln**: Anmeldung, Ausweis, Begleitung.
- **Vereinzelungsanlagen** (Drehkreuze, Schleusen) gegen Tailgating.
- **Clean Desk / Clear Screen**: Bildschirm sperren, nichts Vertrauliches liegen lassen.
- **NAC** an Netzwerkdosen.
- **Sichere Entsorgung** (Datenträgervernichtung nach DIN 66399).
- **Video und Protokollierung** – datenschutzkonform.

> [!TIPP] Freundlich nachfragen
> „Kann ich Ihnen helfen, wen besuchen Sie?“ ist die wirksamste Maßnahme gegen Tailgating – wenn die Kultur es erlaubt.

## Tiefer eingetaucht

Rechenzentren kommen hinzu: Brandschutz, Klimatisierung, unterbrechungsfreie Stromversorgung, Wasserschutz, Zugang nur für berechtigtes Personal mit Protokoll. Physische Penetrationstests (mit Erlaubnis!) prüfen, ob Prozesse wirklich gelebt werden – oft mit überraschenden Ergebnissen.

## Quiz

? Was ist Tailgating?
+ einer berechtigten Person unbemerkt durch eine gesicherte Tür folgen
- ein Netzwerkangriff
- ein Backup-Verfahren
- eine Verschlüsselung
! Vereinzelungsanlagen und Nachfragen helfen dagegen.

? Was bedeutet Clean Desk?
+ keine vertraulichen Unterlagen offen liegen lassen
- den Schreibtisch täglich putzen
- keinen Computer benutzen
- nur Laptops verwenden
! Ergänzt durch Clear Screen – Bildschirm sperren.

?tf Alte 125-kHz-Zutrittskarten lassen sich oft leicht kopieren.
= wahr
! Moderne Karten nutzen Kryptografie.

? Welche Norm beschreibt die sichere Vernichtung von Datenträgern?
= DIN 66399
= 66399
! Mit Schutzklassen und Sicherheitsstufen.

? Was hilft gegen offene Netzwerkdosen in Besprechungsräumen?
= NAC
= Network Access Control
! Nur authentifizierte Geräte erhalten Zugang.

@@@ MODULE @@@
---
id: mx-04
title: Sicherheit für Privatpersonen und Familien
paths: grundlagen
order: 0.23
difficulty: easy
icon: figure.2.and.child.holdinghands
tags: privat, einstieg, awareness
summary: Die wichtigsten Schutzmaßnahmen für zu Hause – Konten, Geräte, Kinder, Betrugsmaschen und was im Ernstfall zu tun ist.
---

## Einfach erklärt

Cybersicherheit beginnt zu Hause. Die gute Nachricht: Mit wenigen Gewohnheiten ist man deutlich sicherer als die meisten – ähnlich wie beim Abschließen der Haustür.

## Die Top 10 für zu Hause

1. **Passwortmanager** und einzigartige Passwörter.
2. **MFA** (am besten Passkeys) für E-Mail, Bank, soziale Netzwerke.
3. **Updates** automatisch für Handy, Computer, Router.
4. **Backups** von Fotos und Dokumenten (Cloud + externe Platte).
5. **E-Mail-Konto besonders schützen** – es ist der Generalschlüssel für Passwort-Resets.
6. **Bei Druck misstrauisch werden**: „Ihr Paket“, „Ihr Konto“, „Ihr Enkel braucht Geld“.
7. **Router absichern** (siehe Modul Heimnetz).
8. **App-Berechtigungen** regelmäßig prüfen.
9. **Kinder begleiten**: Regeln, altersgerechte Einstellungen, offenes Gespräch statt Verbote.
10. **Im Zweifel Familie fragen** – zweite Meinung vor dem Klick oder der Überweisung.

## Häufige Betrugsmaschen

| Masche | Erkennungsmerkmal |
|---|---|
| „Hallo Mama, das ist meine neue Nummer“ | neue Nummer + Geldbitte → alte Nummer anrufen |
| Paket-SMS | Link + kleine Gebühr |
| Falsche Bank-Mitarbeiter | Druck, Bitte um TAN oder Freigabe in der App |
| Fake-Shops | sehr günstige Preise, nur Vorkasse |
| Investment-Betrug | „garantierte“ hohe Renditen, Krypto |

> [!TIPP] Familien-Codewort
> Ein vereinbartes Codewort hilft bei Anrufen oder Nachrichten, in denen angeblich Angehörige in Not sind – auch gegen KI-Stimmen.

## Tiefer eingetaucht

Im Ernstfall: Passwörter ändern (zuerst E-Mail!), Bank sperren lassen (Sperr-Notruf 116 116), Anzeige bei der Polizei (Onlinewache), Beweise sichern (Screenshots, Nachrichten). Bei Identitätsdiebstahl: Auskunfteien informieren, Konten prüfen. Verbraucherzentralen und das BSI bieten verständliche Hilfen für Privatpersonen.

## Quiz

? Welches Konto sollte man besonders gut schützen, weil es Passwort-Resets ermöglicht?
= E-Mail
= E-Mail-Konto
! Wer das Postfach kontrolliert, kann viele andere Konten übernehmen.

? Was ist ein typisches Merkmal der „Hallo Mama“-Masche?
+ eine angeblich neue Nummer und eine Bitte um Geld
- ein Brief per Post
- ein persönlicher Besuch
- eine Rechnung vom Finanzamt
! Immer über die bekannte alte Nummer zurückrufen.

?tf Ein Familien-Codewort kann gegen Betrug mit KI-Stimmen helfen.
= wahr
! Die Stimme kann gefälscht sein, das Codewort kennt nur die Familie.

? Welche Nummer ist in Deutschland der zentrale Sperr-Notruf?
= 116 116
= 116116
! Für Bank- und Kreditkarten sowie viele weitere Karten.

? Was sollte man zuerst ändern, wenn Konten kompromittiert sind?
+ das E-Mail-Passwort
- das WLAN-Passwort des Nachbarn
- den Bildschirmhintergrund
- den Gerätenamen
! Über E-Mail laufen die Resets anderer Konten.

@@@ MODULE @@@
---
id: mx-05
title: OT vertieft · Purdue-Modell und IEC 62443 einfach erklärt
paths: specialist, cyberrange
order: 90.5
difficulty: medium
icon: gearshape.circle.fill
tags: ot, iec 62443, industrie
summary: Ebenen industrieller Netze, Zonen und Conduits, Security Levels und die Rollen von Betreiber, Integrator und Hersteller nach IEC 62443.
---

## Einfach erklärt

Eine Fabrik ist wie ein Gebäude mit Stockwerken: Ganz unten die Maschinen (Sensoren, Motoren), darüber die Steuerungen, darüber die Leitwarte, darüber die Büro-IT, ganz oben das Internet. Das **Purdue-Modell** beschreibt diese Stockwerke, **IEC 62443** sagt, wie man die Treppenhäuser dazwischen absichert.

## Das Purdue-Modell

| Ebene | Inhalt |
|---|---|
| 0 | physischer Prozess: Sensoren, Aktoren |
| 1 | Steuerungen: SPS/PLC, RTU |
| 2 | Bedienen und Beobachten: HMI, SCADA |
| 3 | Betriebsführung: Historian, MES |
| 3.5 | Industrie-DMZ |
| 4–5 | Unternehmens-IT, Internet |

## IEC 62443 – Grundideen

- **Zonen** fassen Komponenten mit gleichem Schutzbedarf zusammen.
- **Conduits** sind die kontrollierten Verbindungen zwischen Zonen.
- **Security Levels (SL 1–4)**: Schutz gegen zufällige Fehler (SL 1) bis gegen hochmotivierte, gut ausgestattete Angreifer (SL 4).
- **Rollen**: Betreiber (Asset Owner), Integrator (Service Provider), Hersteller (Product Supplier) – jeweils mit eigenen Teilnormen.

> [!MERKE] Verfügbarkeit und Safety zuerst
> In OT steht die Sicherheit von Menschen und Anlage (Safety) an erster Stelle. Sicherheitsmaßnahmen dürfen den Prozess nicht gefährden – Patches und Scans werden sorgfältig geplant.

## Tiefer eingetaucht

Praktischer Einstieg nach IEC 62443-3-2: System abgrenzen, erste Risikobewertung, Zonen und Conduits festlegen, detaillierte Risikobewertung pro Zone, Ziel-Security-Level bestimmen, Anforderungen ableiten. Hersteller können Produkte nach 62443-4-2 (Komponenten) und ihren Entwicklungsprozess nach 62443-4-1 zertifizieren lassen.

Die Grenze zwischen IT und OT verschwimmt (Fernwartung, Cloud-Anbindung, IIoT). Die Industrie-DMZ (Ebene 3.5) ist daher zentral: Keine direkte Verbindung zwischen Büro-IT und Steuerungsnetz, Datenaustausch über gespiegelte Systeme oder Datendioden.

## Quiz

? Welche Ebene des Purdue-Modells enthält SPS/PLC?
= 1
= Ebene 1
! Ebene 0 ist der physische Prozess selbst.

? Was sind Conduits in IEC 62443?
+ kontrollierte Verbindungen zwischen Zonen
- Kabelkanäle
- Steuerungsprogramme
- Notausgänge
! Zonen und Conduits bilden die Sicherheitsarchitektur.

? Wie viele Security Levels definiert IEC 62443?
= 4
= vier
! Von SL 1 (zufällige Fehler) bis SL 4 (hochmotivierte Angreifer).

?tf In OT steht Safety (Schutz von Mensch und Anlage) an erster Stelle.
= wahr
! Sicherheitsmaßnahmen dürfen den Prozess nicht gefährden.

? Welche Ebene trennt Unternehmens-IT und Produktionsnetz?
= 3.5
= Industrie-DMZ
! Keine direkte Verbindung zwischen Büro und Steuerungsnetz.

? Welcher Teil von IEC 62443 betrifft den sicheren Entwicklungsprozess von Herstellern?
= 4-1
= 62443-4-1
! 4-2 beschreibt Anforderungen an Komponenten.
