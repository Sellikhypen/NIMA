---
id: mg-11
title: Security-Management 11 · Pentests beauftragen und richtig nutzen
paths: specialist, cpts
order: 15.1
difficulty: easy
icon: person.crop.rectangle.badge.plus
tags: management, pentest, beschaffung
summary: Wie man als Auftraggeber den passenden Pentest auswählt, Anbieter bewertet, den Test begleitet und die Ergebnisse in echte Verbesserungen übersetzt.
---

## Einfach erklärt

Einen Pentest zu beauftragen ist wie einen Gutachter für ein Haus zu bestellen: Man muss sagen, **was** begutachtet werden soll, einen **seriösen** Gutachter finden und danach die Mängel tatsächlich **beheben**. Ein Bericht in der Schublade schützt niemanden.

## Vor der Beauftragung

1. **Ziel klären**: Compliance-Nachweis, neue Anwendung vor Livegang, Prüfung nach Vorfall, realistische Angriffssimulation?
2. **Umfang festlegen**: Systeme, Anwendungen, Rollen, Ausschlüsse.
3. **Testart wählen**: Black/Grey/White Box, extern/intern, Assumed Breach.
4. **Zeitfenster und Ansprechpartner**.

## Anbieter bewerten

| Kriterium | Frage |
|---|---|
| Qualifikation | praktische Zertifikate der Tester, Erfahrung im Themengebiet |
| Methodik | nachvollziehbares Vorgehen (z. B. OWASP, PTES, BSI-Praxisleitfaden) |
| Beispielbericht | verständlich, reproduzierbar, mit konkreten Empfehlungen? |
| Kommunikation | Sofortmeldung kritischer Funde? Abschlussgespräch? |
| Retest | inklusive? |
| Recht | Vertrag, Haftung, Vertraulichkeit, Datenschutz |

> [!WARNUNG] Billig-Pentest = Scannerbericht
> Ein günstiger „Pentest“, der nur einen automatischen Scanner laufen lässt, findet keine Logikfehler, keine Ketten und keine Rechteprobleme.

## Nach dem Test

- Findings priorisieren und **mit Verantwortlichen und Fristen** in das Ticketsystem übernehmen.
- Ursachen statt Symptome beheben (Warum gab es die Lücke? Prozess? Schulung?).
- **Retest** durchführen lassen.
- Erkenntnisse an das SOC geben: Welche Testaktivitäten wurden **nicht** erkannt?

## Tiefer eingetaucht

Regelmäßigkeit schlägt Einzelaktion: Wichtige Anwendungen nach größeren Änderungen testen, Infrastruktur jährlich, ergänzt durch kontinuierliche Scans und ggf. Bug Bounty. Wer Pentest-Ergebnisse über Jahre vergleicht, sieht, ob Entwicklung und Betrieb sicherer werden – oder dieselben Fehler wiederkehren.

## Quiz

? Was sollte vor der Beauftragung eines Pentests geklärt werden?
+ Ziel und Umfang des Tests
- die Farbe des Berichts
- der Lieblingsscanner des Anbieters
- nichts, der Anbieter entscheidet alles
! Ohne klares Ziel passt der Test oft nicht zum Bedarf.

? Woran erkennt man einen reinen Scannerbericht?
+ keine Logikfehler, keine Ketten, generische Empfehlungen
- viele individuelle Nachweise
- verständliche Management-Zusammenfassung
- Retest inklusive
! Manuelle Arbeit ist der Kern eines Pentests.

?tf Findings sollten mit Verantwortlichen und Fristen nachverfolgt werden.
= wahr
! Sonst bleibt der Bericht folgenlos.

? Welche Information aus dem Pentest ist für das SOC besonders wertvoll?
+ welche Testaktivitäten nicht erkannt wurden
- die Rechnung
- die Namen der Tester
- die verwendete Schriftart
! So lassen sich Erkennungslücken schließen.

? Wie heißt die erneute Prüfung nach der Behebung?
= Retest
= Nachtest
! Er bestätigt die Wirksamkeit der Korrekturen.

@@@ MODULE @@@
---
id: mg-12
title: Security-Management 12 · Audits und Zertifizierungen vorbereiten
paths: specialist
order: 15.2
difficulty: medium
icon: checkmark.rectangle.stack.fill
tags: audit, iso 27001, compliance
summary: Wie man sich auf ISO-27001-Audits, BSI-Prüfungen oder Kundenaudits vorbereitet – Nachweise, Interviews, Stichproben und Umgang mit Abweichungen.
---

## Einfach erklärt

Ein Audit ist wie eine Fahrprüfung: Der Prüfer will nicht nur hören, dass du die Regeln kennst, sondern sehen, dass du sie **anwendest**. Er fragt Menschen, schaut Nachweise an und nimmt Stichproben.

## Arten von Audits

| Art | Zweck |
|---|---|
| Internes Audit | eigene Prüfung, Pflicht im ISMS |
| Zertifizierungsaudit (Stufe 1 + 2) | Dokumentenprüfung, dann Umsetzungsprüfung vor Ort |
| Überwachungsaudit | jährlich zwischen Rezertifizierungen |
| Lieferanten-/Kundenaudit | Nachweis gegenüber Geschäftspartnern |

## Vorbereitung

1. **Anwendbarkeitserklärung (SoA)** aktuell: welche Maßnahmen gelten, warum, wie umgesetzt?
2. **Nachweise** griffbereit: Richtlinien, Risikoanalyse, Schulungsnachweise, Protokolle von Managementbewertungen, Vorfallberichte, Zugriffsrezertifizierungen, Backup-Tests.
3. **Interviewpartner** vorbereiten – ehrlich antworten, nichts erfinden, „Das zeige ich Ihnen“ statt langer Erklärungen.
4. Interne Audits und Managementbewertung vorher durchgeführt.

> [!TIPP] Stichproben vorhersehen
> Prüfer fragen gern: „Zeigen Sie mir den Austrittsprozess für drei Mitarbeiter des letzten Quartals“ oder „Den letzten Restore-Test“. Solche Nachweise vorher selbst prüfen.

## Abweichungen

| Typ | Bedeutung |
|---|---|
| Hauptabweichung | Anforderung nicht erfüllt, Zertifikat gefährdet |
| Nebenabweichung | teilweise erfüllt |
| Beobachtung / Verbesserungspotenzial | Hinweis |

Abweichungen sind kein Weltuntergang: Ursache analysieren, Korrekturmaßnahme planen, Wirksamkeit nachweisen.

## Tiefer eingetaucht

Ein Audit ist am wertvollsten, wenn man es als **kostenlose Beratung** versteht: Ein guter Auditor findet blinde Flecken. Umgekehrt ist ein bestandenes Audit kein Beweis für Sicherheit – es zeigt, dass ein Managementsystem existiert und funktioniert. Technische Tiefe (Pentests, Red Teaming) ergänzt das.

## Quiz

? Was ist die Anwendbarkeitserklärung (SoA)?
+ Dokument, das festlegt, welche Annex-A-Maßnahmen gelten und wie sie umgesetzt sind
- ein Vertrag mit dem Auditor
- eine Rechnung
- ein Netzwerkplan
! Statement of Applicability.

? Wie sollte man sich im Audit-Interview verhalten?
+ ehrlich antworten und Nachweise zeigen
- möglichst lange reden
- Antworten erfinden
- Fragen ignorieren
! Erfundene Antworten fallen bei Stichproben auf.

? Welche Abweichung gefährdet das Zertifikat?
= Hauptabweichung
! Nebenabweichungen und Beobachtungen sind weniger schwerwiegend.

?tf Ein bestandenes ISO-27001-Audit beweist, dass ein Unternehmen nicht gehackt werden kann.
= falsch
! Es zeigt ein funktionierendes Managementsystem, keine Unverwundbarkeit.

? Aus welchen Stufen besteht ein Zertifizierungsaudit?
+ Stufe 1: Dokumentenprüfung
+ Stufe 2: Umsetzungsprüfung
- Stufe 0: Kaffeepause
- Stufe 3: Pentest
! Danach folgen jährliche Überwachungsaudits.

@@@ MODULE @@@
---
id: mg-13
title: Security-Management 13 · Security-Kultur und Security Champions
paths: specialist, cwee
order: 15.3
difficulty: easy
icon: person.3.fill
tags: kultur, champions, devsecops
summary: Wie man Sicherheit in Teams verankert – Champions-Programme, Anreize, Fehlerkultur und Zusammenarbeit statt Kontrolle.
---

## Einfach erklärt

Eine kleine Sicherheitsabteilung kann nicht überall gleichzeitig sein. **Security Champions** sind Freiwillige in Entwicklungs- und Fachteams, die Sicherheit dort mitdenken, wo die Arbeit passiert – wie Ersthelfer im Büro, die nicht Arzt sind, aber wissen, was zu tun ist.

## Ein Champions-Programm aufbauen

1. **Freiwillige** mit Interesse gewinnen (nicht verordnen).
2. **Zeitbudget** vereinbaren (z. B. 10 % der Arbeitszeit).
3. **Ausbildung**: Bedrohungsmodellierung, sichere Programmierung, Werkzeuge.
4. **Regelmäßiger Austausch**: monatliche Treffen, Chat-Kanal, Fallbeispiele.
5. **Anerkennung**: Sichtbarkeit, Weiterbildung, Karrierewirkung.
6. **Rolle klären**: Champions beraten und eskalieren – Verantwortung bleibt beim Team.

## Kultur-Bausteine

| Baustein | Wirkung |
|---|---|
| Fehlerkultur ohne Schuld | Probleme werden früh gemeldet |
| Sicherheit als Qualitätsmerkmal | gehört zur „Definition of Done“ |
| einfache sichere Wege | Templates, Bibliotheken, Pipelines – der sichere Weg ist der bequeme |
| Transparenz | offene Kennzahlen, gemeinsame Ziele |
| Vorbild der Leitung | Führungskräfte halten Regeln selbst ein |

> [!MERKE] Der sichere Weg muss der einfachste sein
> Wenn Sicherheit Umwege erfordert, werden Umwege um die Sicherheit gebaut. Paved Roads (vorbereitete, sichere Standardwege) wirken stärker als Verbote.

## Tiefer eingetaucht

Messbar wird Kultur über Indikatoren wie: Anteil Projekte mit Bedrohungsmodell, Zeit bis zur Behebung von Schwachstellen, Anzahl freiwilliger Meldungen, Teilnahme an Trainings, Ergebnisse von Kulturumfragen. Champions sind zugleich Frühwarnsystem: Sie wissen, wo Prozesse hakten und Schatten-Lösungen entstehen.

## Quiz

? Was sind Security Champions?
+ Freiwillige in Teams, die Sicherheit vor Ort mitdenken und beraten
- externe Hacker
- Auditoren
- Geschäftsführer
! Sie tragen Sicherheitswissen in den Alltag der Teams.

? Was beschreibt eine „Paved Road“?
+ ein vorbereiteter, sicherer Standardweg, der auch der bequemste ist
- eine gesperrte Straße
- eine Firewall
- ein Backup-Verfahren
! Sicherheit durch Einfachheit statt Verbote.

?tf Champions übernehmen die volle Verantwortung für die Sicherheit ihres Teams.
= falsch
! Sie beraten und eskalieren – die Verantwortung bleibt beim Team.

? Warum ist eine Fehlerkultur ohne Schuld wichtig?
+ Probleme werden früher gemeldet
- weil Fehler dann verschwinden
- weil sie Geld spart
- weil Audits es verbieten
! Angst führt zum Verschweigen.

? Was ist ein guter Indikator für Sicherheitskultur?
+ Anzahl freiwilliger Meldungen
- Anzahl Folien in der Schulung
- Größe des Sicherheitsbudgets allein
- Anzahl der Firewalls
! Freiwilliges Melden zeigt Vertrauen und Bewusstsein.

@@@ MODULE @@@
---
id: mg-14
title: Security-Management 14 · Cyberversicherung verstehen
paths: specialist
order: 15.4
difficulty: easy
icon: umbrella.fill
tags: versicherung, risiko
summary: Was Cyberversicherungen abdecken, welche Anforderungen Versicherer stellen, Obliegenheiten im Schadensfall und typische Ausschlüsse.
---

## Einfach erklärt

Eine Cyberversicherung ist wie eine Hausratversicherung für digitale Schäden: Sie zahlt nicht dafür, dass nichts passiert, sondern hilft finanziell und mit Experten, wenn etwas passiert. Und wie bei jeder Versicherung gilt: Wer die Tür offen lässt, bekommt im Schadensfall Probleme.

## Typische Leistungen

| Bereich | Beispiel |
|---|---|
| Eigenschäden | Betriebsunterbrechung, Wiederherstellung von Daten und Systemen |
| Drittschäden | Ansprüche von Kunden und Partnern |
| Krisendienstleister | Forensik, Rechtsberatung, Krisenkommunikation |
| Kosten | Benachrichtigung Betroffener, Behördenverfahren |

## Anforderungen der Versicherer (häufig)

- MFA für Fernzugriff, E-Mail und Admins
- Offline/unveränderliche Backups mit Tests
- EDR auf Endgeräten
- Patch-Management mit Fristen
- Privilegierte Zugänge geschützt
- Schulungen und Notfallplan

> [!WARNUNG] Obliegenheiten
> Falsche Angaben im Antrag oder nicht eingehaltene Sicherheitsvorgaben können den Versicherungsschutz gefährden. Antragsfragen technisch prüfen lassen, nicht „aus dem Bauch“ beantworten.

## Im Schadensfall

1. Versicherer **sofort** informieren (Hotline).
2. Vorgegebene Dienstleister (Panel) nutzen bzw. abstimmen.
3. Nichts ohne Absprache entscheiden, was Kosten auslöst (z. B. Lösegeldverhandlungen).
4. Dokumentation sichern.

## Tiefer eingetaucht

Ausschlüsse betreffen oft: Krieg und staatliche Angriffe (Formulierung genau prüfen), bekannte, aber nicht behobene Schwachstellen, vorsätzliches Handeln, Infrastrukturausfälle (Strom, Internet), Vertragsstrafen. Eine Versicherung ist **Risikotransfer** für das Restrisiko – sie ersetzt keine Sicherheitsmaßnahmen. Die Fragebögen der Versicherer sind aber ein nützlicher Spiegel: Sie zeigen, welche Grundmaßnahmen der Markt als Mindeststandard ansieht.

## Quiz

? Was ist eine Cyberversicherung aus Sicht des Risikomanagements?
+ Risikotransfer für das Restrisiko
- ein Ersatz für Sicherheitsmaßnahmen
- ein Virenscanner
- eine Firewall
! Sie mildert finanzielle Folgen, verhindert aber keine Angriffe.

? Welche Maßnahmen verlangen Versicherer häufig?
+ MFA für Fernzugriff und Admins
+ getestete Offline-Backups
+ EDR auf Endgeräten
- bunte Bildschirmschoner
! Diese gelten als Mindeststandard.

?tf Falsche Angaben im Versicherungsantrag können den Schutz gefährden.
= wahr
! Antragsfragen technisch prüfen lassen.

? Was sollte man im Schadensfall zuerst tun?
+ den Versicherer sofort über die Hotline informieren
- ein Lösegeld überweisen
- alle Logs löschen
- abwarten
! Viele Policen sehen sofortige Meldung und Panel-Dienstleister vor.

? Was ist ein häufiger Ausschluss?
+ bekannte, aber nicht behobene Schwachstellen
- Phishing-Schäden
- Forensikkosten
- Datenwiederherstellung
! Grobe Fahrlässigkeit kann den Schutz einschränken.

@@@ MODULE @@@
---
id: mg-15
title: Security-Management 15 · Remote Work und hybrides Arbeiten absichern
paths: specialist, grundlagen
order: 15.5
difficulty: easy
icon: house.and.flag.fill
tags: homeoffice, remote work
summary: Welche Risiken Homeoffice und mobiles Arbeiten bringen und wie Geräte, Zugänge, Kommunikation und Verhalten sinnvoll geschützt werden.
---

## Einfach erklärt

Im Büro schützen viele unsichtbare Schichten: Firewall, kontrollierter Zutritt, Kollegen, die bei Seltsamem nachfragen. Zu Hause oder im Café fallen viele davon weg. Sicherheit muss deshalb **mit dem Gerät und der Identität reisen**.

## Schutzbausteine

| Bereich | Maßnahme |
|---|---|
| Geräte | verwaltete Firmengeräte (MDM), Festplattenverschlüsselung, EDR, automatische Updates |
| Zugang | MFA, Conditional Access, ZTNA/VPN, keine Admin-Rechte im Alltag |
| Netz | WLAN zu Hause mit WPA2/3, kein Firmenzugriff über öffentliche Rechner |
| Daten | Firmendaten in freigegebenen Cloud-Diensten, nicht auf privaten Geräten/USB |
| Kommunikation | freigegebene Kollaborationswerkzeuge, Verifizierung ungewöhnlicher Anweisungen |
| Physisch | Sichtschutz, Bildschirmsperre, Gespräche nicht im Zug über Vertrauliches |
| Drucken | möglichst gar nicht; sonst sichere Entsorgung |

> [!TIPP] Klare Regeln für private Geräte
> Wenn private Geräte genutzt werden dürfen (BYOD), dann nur mit getrennten Arbeitsprofilen bzw. App-Schutzrichtlinien – und mit klarer Information, was die Firma sehen kann und was nicht.

## Typische Angriffe

- Phishing mit Bezug auf Videokonferenzen oder Collaboration-Tools
- Anrufe angeblicher IT-Mitarbeiter („Wir müssen Ihren Rechner aus der Ferne prüfen“)
- Heimrouter mit Standardpasswort oder alter Firmware
- Familienmitglieder an Firmengeräten

## Tiefer eingetaucht

Architektonisch hat Remote Work die Verlagerung zu **Zero Trust** beschleunigt: Statt „im Netz = vertraut“ zählen Identität, Gerätezustand und Kontext bei jedem Zugriff. Für das SOC bedeutet das neue Datenquellen (Identitätsanbieter, Cloud-Proxys, MDM) und neue Muster (unmögliche Reisen, ungewöhnliche Geräte). Und für Notfälle: Wie erreicht man Mitarbeitende, wenn zentrale Dienste ausfallen?

## Quiz

? Warum muss Sicherheit beim Remote Work „mit dem Gerät reisen“?
+ weil schützende Schichten des Büros zu Hause fehlen
- weil Geräte schwerer werden
- weil das WLAN schneller ist
- weil Büros abgeschafft wurden
! Gerät und Identität tragen den Schutz.

? Was sollte für Firmenzugriffe immer aktiv sein?
= MFA
= Multi-Faktor-Authentifizierung
! Ergänzt durch Conditional Access und Gerätekonformität.

?tf Firmenzugriff von öffentlichen Rechnern, z. B. in Hotels, ist unbedenklich.
= falsch
! Solche Rechner können Keylogger oder Malware enthalten.

? Wie trennt man Firmendaten auf privaten Geräten?
+ mit Arbeitsprofilen bzw. App-Schutzrichtlinien
- gar nicht
- mit einem Aufkleber
- durch Umbenennen der Dateien
! BYOD nur mit klarer technischer Trennung.

? Welches Architekturprinzip wurde durch Remote Work beschleunigt?
= Zero Trust
! Identität, Gerät und Kontext statt Netzwerkstandort.

@@@ MODULE @@@
---
id: adx-11
title: AD verstehen 11 · Lokale Admins, LAPS und Gruppenrichtlinien-Sicherheit
paths: cpts, cape, specialist, cdsa
order: 13.1
difficulty: medium
icon: person.badge.shield.checkmark
tags: active directory, laps, gpo
summary: Warum identische lokale Admin-Passwörter gefährlich sind, wie Windows LAPS funktioniert und wie man Gruppenrichtlinien selbst vor Missbrauch schützt.
---

## Einfach erklärt

Hätten alle Wohnungen eines Hauses denselben Schlüssel, könnte ein Einbrecher mit einem einzigen Schlüssel alle öffnen. Genau so ist es mit **identischen lokalen Administratorpasswörtern** auf allen Rechnern – ein klassischer Weg für Angreifer, sich im Netz auszubreiten. **LAPS** gibt jedem Rechner einen eigenen, regelmäßig wechselnden Schlüssel.

## Windows LAPS

- Ein **einzigartiges, zufälliges** Passwort für das lokale Admin-Konto pro Gerät.
- Automatische **Rotation** (z. B. alle 30 Tage und nach Nutzung).
- Speicherung im AD-Computerobjekt oder in Entra ID, **verschlüsselt** möglich.
- Lesen nur für berechtigte Gruppen; Zugriffe werden protokolliert.
- Auch für DSRM-Passwörter auf DCs nutzbar.

```powershell
Get-LapsADPassword -Identity PC-0815 -AsPlainText
Reset-LapsPassword
```

> [!WARNUNG] Wer darf lesen?
> Die Berechtigung, LAPS-Passwörter zu lesen, ist faktisch lokaler Admin auf allen betroffenen Rechnern. Diese Gruppe klein halten und überwachen.

## Gruppenrichtlinien schützen

GPOs sind mächtig: Wer eine GPO ändern darf, die auf viele Rechner wirkt, kann dort Skripte ausführen oder Admins hinzufügen.

| Risiko | Schutz |
|---|---|
| Schreibrechte auf GPOs für zu viele | Rechte prüfen, delegieren nur gezielt |
| Rechte auf OUs mit `GPLink` | wer verlinken darf, kontrolliert die OU |
| Passwörter in GPP (alte Group Policy Preferences) | entfernen – der Schlüssel ist öffentlich |
| Skripte auf SYSVOL beschreibbar | Dateirechte prüfen |

Änderungen an GPOs überwachen (Event 5136/5137/5141, Versionierung, Backups mit `Backup-GPO`).

## Tiefer eingetaucht

Ergänzend: Lokale Konten nicht für Netzwerkanmeldungen zulassen (Richtlinie „Deny access to this computer from the network“ für die Gruppe „Local account and member of Administrators group“) – dann nützt selbst ein bekanntes lokales Passwort kaum für Lateral Movement. Zusammen mit LAPS und Host-Firewalls zwischen Arbeitsplätzen bricht eine der häufigsten Ausbreitungstechniken weg.

## Quiz

? Was macht LAPS?
+ vergibt jedem Rechner ein einzigartiges, rotierendes lokales Admin-Passwort
- verschlüsselt Festplatten
- filtert E-Mails
- blockiert USB-Sticks
! Verhindert Ausbreitung über identische Passwörter.

? Mit welchem Cmdlet liest man ein LAPS-Passwort aus AD?
= Get-LapsADPassword
! Nur mit entsprechender Berechtigung.

?tf Die Berechtigung, LAPS-Passwörter zu lesen, ist sehr mächtig.
= wahr
! Sie entspricht faktisch lokalen Admin-Rechten auf den Rechnern.

? Warum sind alte GPP-Passwörter gefährlich?
+ der Entschlüsselungsschlüssel ist öffentlich bekannt
- sie sind zu lang
- sie laufen nie ab
- sie liegen nur lokal
! Jeder Domänennutzer kann sie auf SYSVOL lesen und entschlüsseln.

? Wer eine GPO ändern darf, die auf viele Rechner wirkt, kann …
+ auf diesen Rechnern Befehle ausführen lassen
- nur die Hintergrundfarbe ändern
- nichts Relevantes
- nur Drucker hinzufügen
! GPO-Rechte sind hochprivilegiert.

? Mit welchem Cmdlet sichert man Gruppenrichtlinien?
= Backup-GPO
! Für Wiederherstellung und Versionsvergleich.

@@@ MODULE @@@
---
id: ir-06
title: Incident Response 6 · Phishing-Vorfall von der Meldung bis zum Abschluss
paths: cdsa, specialist
order: 34.6
difficulty: medium
icon: envelope.arrow.triangle.branch.fill
tags: phishing, incident response
summary: Der vollständige Ablauf eines Phishing-Vorfalls – Analyse, Empfänger finden, Klicks und Eingaben ermitteln, Bereinigung, Kontosicherung.
---

## Einfach erklärt

Eine Mitarbeiterin meldet eine verdächtige Mail. Ab jetzt läuft die Uhr: Wer hat dieselbe Mail bekommen? Wer hat geklickt? Hat jemand ein Passwort eingegeben? Je schneller diese Fragen beantwortet sind, desto kleiner der Schaden.

## Ablauf

1. **Analysieren**: Header (Absender, Return-Path, Authentifizierungsergebnisse), Links (Ziel, Domainalter), Anhänge (Sandbox), Inhalt.
2. **Einordnen**: Phishing (Anmeldedaten), Malware, BEC, Spam?
3. **Umfang**: Alle Empfänger über Message-Trace bzw. Suche nach Betreff, Absender, URL finden.
4. **Entfernen**: Mails aus allen Postfächern löschen (z. B. per Such- und Löschfunktion des Mailsystems).
5. **Blockieren**: Absender/Domain, URLs am Proxy/DNS, Hashes im EDR.
6. **Betroffene ermitteln**: Proxy-/DNS-Logs – wer hat die URL aufgerufen? Anmeldelogs – gab es danach verdächtige Anmeldungen?
7. **Konten sichern**: Passwort zurücksetzen, Sitzungen widerrufen, MFA-Methoden prüfen, Posteingangsregeln prüfen.
8. **Kommunizieren**: Melderin danken, ggf. Warnung an alle.
9. **Dokumentieren und lernen**.

> [!MERKE] Sitzungen widerrufen
> Bei Adversary-in-the-Middle-Phishing hat der Angreifer ein gültiges Session-Cookie. Ein Passwortwechsel allein beendet die Sitzung nicht immer – Sitzungen und Tokens explizit widerrufen.

## Tiefer eingetaucht

Automatisierung lohnt sich hier besonders (SOAR): Gemeldete Mail → automatische Header- und URL-Analyse → Suche nach weiteren Empfängern → Vorschlag zum Löschen → Proxy-Abgleich der Klicks. Der Analyst entscheidet nur noch und kümmert sich um die echten Treffer.

Kennzahlen: Zeit von erster Zustellung bis zur ersten Meldung, bis zur Entfernung aus allen Postfächern, Anzahl Klicks vor/nach Entfernung. Sie zeigen, wie gut Awareness, Meldebutton und SOC zusammenspielen.

## Quiz

? Was ist nach der Analyse einer Phishing-Mail ein wichtiger nächster Schritt?
+ alle weiteren Empfänger finden und die Mail aus allen Postfächern entfernen
- die Mail weiterleiten an alle
- die Melderin ermahnen
- den Mailserver neu starten
! Umfang klären und Kampagne stoppen.

? Wie findet man heraus, wer auf den Link geklickt hat?
+ Proxy- und DNS-Logs auswerten
- alle Mitarbeitenden befragen
- raten
- die Mail ausdrucken
! Logs liefern belastbare Antworten.

?tf Bei AiTM-Phishing reicht ein Passwortwechsel immer aus.
= falsch
! Sitzungen und Tokens müssen zusätzlich widerrufen werden.

? Was sollte bei einem kompromittierten Postfach zusätzlich geprüft werden?
+ Posteingangsregeln und MFA-Methoden
- die Bildschirmauflösung
- die Druckeinstellungen
- das Desktop-Hintergrundbild
! Typische Persistenz nach Kontoübernahme.

? Welche Kennzahl zeigt die Zusammenarbeit von Awareness und SOC?
+ Zeit von der Zustellung bis zur ersten Meldung
- Anzahl der Mailserver
- Größe der Postfächer
- Anzahl der Anhänge
! Je schneller gemeldet wird, desto weniger Opfer.

@@@ MODULE @@@
---
id: ir-07
title: Incident Response 7 · Business E-Mail Compromise untersuchen
paths: cdsa, specialist
order: 34.7
difficulty: medium
icon: eurosign.circle.fill
tags: bec, incident response, e-mail
summary: Wie BEC-Betrug abläuft, welche Spuren übernommene Postfächer hinterlassen und wie man Zahlungen stoppt, Umfang klärt und vorbeugt.
---

## Einfach erklärt

Beim **Business E-Mail Compromise** braucht der Angreifer keine Schadsoftware. Er liest in einem übernommenen Postfach mit, wartet auf den richtigen Moment – eine anstehende Zahlung – und schickt dann aus dem echten Postfach oder einer täuschend ähnlichen Domain: „Bitte überweisen Sie ab sofort auf unser neues Konto.“

## Typischer Ablauf

1. Phishing → Zugangsdaten oder Session gestohlen.
2. Stilles Mitlesen, Suche nach „Rechnung“, „Zahlung“, „IBAN“.
3. Posteingangsregeln: Antworten bestimmter Partner in versteckte Ordner verschieben.
4. Gefälschte Zahlungsanweisung – oft parallel per Lookalike-Domain.
5. Geld wird schnell weitertransferiert.

## Sofortmaßnahmen

| Maßnahme | Warum |
|---|---|
| Bank sofort kontaktieren, Rückruf der Zahlung versuchen | Stunden zählen |
| Konto sichern (Sitzungen widerrufen, Passwort, MFA) | Zugriff beenden |
| Posteingangsregeln, Weiterleitungen, App-Zustimmungen prüfen | Persistenz entfernen |
| Partner informieren | auch deren Postfächer können betroffen sein |
| Anzeige bei der Polizei | Strafverfolgung, Unterstützung bei Geldflüssen |

## Untersuchung

- Anmeldelogs: ungewöhnliche Orte, Geräte, Zeiten.
- Audit-Logs: neue Regeln, Weiterleitungen, gelesene Mails (MailItemsAccessed).
- Gesendete Elemente und gelöschte Elemente prüfen.
- Welche Mails mit sensiblen Daten wurden gelesen? → ggf. Meldepflicht.

> [!MERKE] Prozess schlägt Technik
> Die wirksamste Prävention: Änderungen von Bankverbindungen **nie** nur per E-Mail akzeptieren, sondern über einen bekannten Kontakt telefonisch bestätigen.

## Tiefer eingetaucht

Weitere Prävention: phishing-resistente MFA, Conditional Access, Blockieren externer automatischer Weiterleitung, Warnhinweise für externe Absender und neue Domains, DMARC auf `reject` für eigene Domains, Überwachung von Lookalike-Domains. BEC verursacht weltweit Schäden in Milliardenhöhe – oft mehr als Ransomware.

## Quiz

? Was braucht ein Angreifer bei BEC typischerweise nicht?
+ Schadsoftware
- ein übernommenes oder gefälschtes Postfach
- Wissen über anstehende Zahlungen
- eine glaubwürdige Geschichte
! BEC funktioniert oft ganz ohne Malware.

? Was ist bei einer betrügerischen Überweisung zuerst zu tun?
+ sofort die Bank kontaktieren, um die Zahlung zurückzuholen
- eine Woche abwarten
- das Postfach löschen
- die Rechnung bezahlen
! Je schneller, desto größer die Chance auf Rückholung.

?tf Angreifer nutzen bei BEC oft Posteingangsregeln, um Antworten zu verstecken.
= wahr
! Diese Regeln müssen gefunden und entfernt werden.

? Welche Prävention ist gegen BEC am wirksamsten?
+ Bankverbindungsänderungen telefonisch über bekannte Kontakte bestätigen
- längere E-Mail-Signaturen
- größere Postfächer
- mehr Spamfilter-Regeln allein
! Prozess schlägt Technik.

? Welches Audit-Ereignis zeigt in M365, welche Mails gelesen wurden?
= MailItemsAccessed
! Wichtig für die Bewertung von Meldepflichten.

@@@ MODULE @@@
---
id: ir-08
title: Incident Response 8 · Insider-Vorfälle fair und rechtssicher untersuchen
paths: cdsa, specialist
order: 34.8
difficulty: medium
icon: person.fill.questionmark
tags: insider, incident response, recht
summary: Wie man Verdachtsfälle gegen Mitarbeitende untersucht – Beteiligte, Rechtsrahmen, Beweissicherung, Verhältnismäßigkeit und Unschuldsvermutung.
---

## Einfach erklärt

Ein Insider-Verdacht ist heikel: Es geht um Kolleginnen und Kollegen, um Arbeitsrecht, Datenschutz und Vertrauen. Eine Untersuchung muss deshalb **fair, verhältnismäßig und sauber dokumentiert** sein – wie ein ordentliches Verfahren, nicht wie eine Hexenjagd.

## Beteiligte

| Rolle | Aufgabe |
|---|---|
| Personalabteilung | arbeitsrechtliche Schritte, Kommunikation |
| Rechtsabteilung | Rechtsrahmen, Beweisverwertbarkeit |
| Datenschutzbeauftragte | Verhältnismäßigkeit, Dokumentation |
| Betriebsrat | Mitbestimmung, je nach Maßnahme |
| Sicherheitsteam | technische Untersuchung |
| Führungskraft | nur soweit nötig (Need-to-know) |

## Grundsätze

1. **Anlass** dokumentieren: Was begründet den Verdacht?
2. **Verhältnismäßigkeit**: geringstmöglicher Eingriff, zeitlich und inhaltlich begrenzt.
3. **Vertraulichkeit**: kleiner Kreis, keine Gerüchte.
4. **Beweissicherung** forensisch sauber (Chain of Custody).
5. **Unschuldsvermutung**: Auch entlastende Hinweise suchen und dokumentieren.
6. **Anhörung** der betroffenen Person zu gegebener Zeit.

> [!GEFAHR] Nicht eigenmächtig handeln
> Das heimliche Durchsuchen privater Inhalte oder flächendeckende Überwachung ohne Rechtsgrundlage kann selbst strafbar sein und Beweise unverwertbar machen.

## Typische Indikatoren

- ungewöhnliche Datenmengen kurz vor Kündigung/Austritt
- Zugriffe auf Daten außerhalb der eigenen Aufgaben
- Nutzung privater Cloud-Speicher oder USB-Geräte entgegen Richtlinien
- Arbeitszeiten, die nicht zum Muster passen
- Umgehung von Sicherheitskontrollen

## Tiefer eingetaucht

Prävention ist besser als Untersuchung: Least Privilege, Funktionstrennung, sauberer Leaver-Prozess (Zugänge am letzten Tag sofort entziehen), DLP für hochsensible Daten, Hinweisgebersystem (Hinweisgeberschutzgesetz) und eine Kultur, in der Probleme angesprochen werden. Viele Insider-Vorfälle sind übrigens **fahrlässig**, nicht böswillig – Schulung und gute Werkzeuge wirken dort am besten.

## Quiz

? Welche Grundsätze gelten bei Insider-Untersuchungen?
+ Verhältnismäßigkeit
+ Vertraulichkeit
+ Unschuldsvermutung
- möglichst viele Personen informieren
! Fair, begrenzt und dokumentiert.

? Wer sollte bei einer Insider-Untersuchung früh eingebunden werden?
+ Rechtsabteilung, Personalabteilung und Datenschutz
- die Presse
- alle Kolleginnen und Kollegen
- niemand
! Rechtssicherheit und Verwertbarkeit hängen davon ab.

?tf Heimliches Durchsuchen privater Inhalte ohne Rechtsgrundlage kann Beweise unverwertbar machen.
= wahr
! Und kann selbst strafbar sein.

? Was ist ein typischer Insider-Indikator?
+ ungewöhnliche Datenmengen kurz vor dem Austritt
- regelmäßiges Mittagessen
- pünktliches Erscheinen
- Teilnahme an Schulungen
! Kontext ist entscheidend – nicht jede Auffälligkeit ist ein Vergehen.

? Welches Gesetz schützt Hinweisgeber in Deutschland?
= Hinweisgeberschutzgesetz
= HinSchG
! Unternehmen ab einer gewissen Größe brauchen interne Meldestellen.
