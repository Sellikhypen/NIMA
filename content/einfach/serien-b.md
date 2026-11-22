# Einfach erklärt – Serien Teil B (AD defensiv, Blue Team, BSI, Cloud, Härtung, ISO, Recht, Karriere, Krypto, OT, Web-Verteidigung, WLAN-Betrieb)

## adv-01
Gruppenrichtlinien sind die Hausordnung, die AD an alle Rechner verteilt: Passwortregeln, Sperrbildschirm, Firewall, Softwareeinschränkungen. Richtig eingesetzt härten sie hunderte Rechner mit einem Klick.

## adv-02
Jedes Objekt im AD – Benutzer, Gruppe, Computer – hat Attribute und Berechtigungen. Wer darf ein Passwort zurücksetzen, wer Gruppen ändern? Diese unsichtbaren Rechte entscheiden oft über die Sicherheit der ganzen Domäne.

## adv-03
Viele Firmen verbinden ihr lokales AD mit Microsofts Cloud-Identität **Entra ID**. Das ist bequem – verbindet aber auch die Risiken beider Welten. Dieses Modul zeigt, wo die Brücken liegen und wie man sie schützt.

## adv-04
Ein AD ohne Überwachung ist wie ein Tresor ohne Alarmanlage. Welche Ereignisse zeigen Angriffe, welche Änderungen sind kritisch, und wie baut man eine sinnvolle Überwachung auf?

## bt-01
Ein **EDR** ist ein Wachmann auf jedem Rechner: Er beobachtet Prozesse, Dateien und Verbindungen, erkennt verdächtiges Verhalten und kann Geräte im Ernstfall isolieren.

## bt-02
Logs sind nur nützlich, wenn man sie sammelt, sicher aufbewahrt und wiederfindet. **Log-Management** klärt: Was wird gesammelt, wie lange, wo, und wer darf es sehen?

## bt-03
**SOAR** automatisiert Routine im SOC: Alarm anreichern, Nutzer sperren, Ticket anlegen. **Playbooks** beschreiben, was bei welchem Alarm passiert – wie Checklisten im Cockpit.

## bt-04
Ransomware ist der Albtraum jeder IT. Ein **Playbook** legt vorher fest, was in den ersten Stunden passiert: isolieren, sichern, kommunizieren, entscheiden – damit niemand im Chaos improvisieren muss.

## bt-05
Nicht jede Gefahr kommt von außen. **Insider** – böswillig oder fahrlässig – haben bereits Zugang und Vertrauen. Ihre Erkennung braucht Fingerspitzengefühl, klare Regeln und Datenschutz.

## bt-06
**Honeypots** und **Honeytokens** sind Köder: Systeme oder Daten, die niemand legitim anfasst. Wer es doch tut, verrät sich – ein sehr rauscharmes Alarmsignal.

## bt-07
Threat Intelligence ist Wissen über Angreifer – aber nur nützlich, wenn es im Alltag ankommt: in Erkennungsregeln, Blocklisten, Priorisierung und Lagebildern.

## bt-08
Beim **Purple Teaming** arbeiten Angreifer (Red) und Verteidiger (Blue) zusammen: Technik ausführen, prüfen, ob sie erkannt wurde, Erkennung verbessern – Schritt für Schritt.

## bsi-01
Der Baustein **ISMS** im BSI-Kompendium beschreibt, wie Sicherheit organisiert wird: Leitlinie, Verantwortliche, Prozesse und Verbesserung – das Fundament für alle anderen Bausteine.

## bsi-02
**ORP** steht für Organisation und Personal: Zuständigkeiten, Regeln für Mitarbeitende, Schulung, Identitäts- und Berechtigungsmanagement – Sicherheit beginnt bei Menschen und Strukturen.

## bsi-03
**CON** sammelt Konzepte und Vorgehensweisen: Kryptokonzept, Datenschutz, Löschen und Vernichten, Softwareentwicklung. Hier wird geplant, bevor gebaut wird.

## bsi-04
**OPS** betrifft den laufenden Betrieb: Patch- und Änderungsmanagement, Schutz vor Schadprogrammen, Protokollierung, Fernwartung, Outsourcing – die tägliche Sicherheitsarbeit.

## bsi-05
**DER** steht für Detektion und Reaktion: Sicherheitsvorfälle erkennen, behandeln, forensisch untersuchen und Notfälle bewältigen.

## bsi-06
**APP** behandelt Anwendungen: Office, Webbrowser, Webanwendungen, Datenbanken, E-Mail und mehr – mit konkreten Anforderungen für jede Kategorie.

## bsi-07
**SYS** deckt IT-Systeme ab: Server, Clients, Virtualisierung, Mobilgeräte, Drucker, IoT – jeweils mit typischen Gefährdungen und Schutzanforderungen.

## bsi-08
**IND** ist der Bereich für industrielle IT: Steuerungen, Prozessleittechnik, Fernwartung in Anlagen – mit Blick auf die besonderen Prioritäten der OT.

## bsi-09
**NET** betrachtet Netze und Kommunikation: Netzarchitektur, Firewalls, WLAN, VPN, Netzmanagement – die Leitungen, über die alles läuft.

## bsi-10
**INF** steht für Infrastruktur: Gebäude, Serverräume, Verkabelung, Arbeitsplätze, Homeoffice – die physische Grundlage der IT-Sicherheit.

## cl-01
In AWS ist fast alles über Schnittstellen steuerbar – und über **IAM** abgesichert. Root-Konto schützen, Rechte minimal halten, CloudTrail aktivieren: die drei Grundregeln für ein sicheres Konto.

## cl-02
Azure und Entra ID gehören zusammen: Ohne gute Identitätssicherheit ist die beste Cloud-Konfiguration wertlos. MFA, Conditional Access und Rollenmanagement stehen im Mittelpunkt.

## cl-03
Docker-Container sind leichtgewichtige Pakete für Anwendungen. Sicher werden sie durch kleine Images, keine root-Prozesse, eingeschränkte Rechte und regelmäßiges Scannen.

## cl-04
Kubernetes orchestriert hunderte Container – und bringt eigene Risiken: zu viele Rechte, offene Schnittstellen, fehlende Netzwerkregeln. Dieses Modul zeigt die wichtigsten Schutzschichten.

## cl-05
Auch in der Cloud gibt es Netze – virtuell und per Klick konfigurierbar. Zero Trust heißt hier: Segmentierung, private Endpunkte und Identität statt offener Ports.

## cl-06
Bei **Serverless** schreibt man nur noch Funktionen, die Infrastruktur verwaltet der Anbieter. **Infrastructure as Code** beschreibt Umgebungen in Dateien. Beides verschiebt Sicherheit in Code und Konfiguration.

## hd-01
Ein frisch installierter Linux-Server ist wie eine neue Wohnung mit offenen Fenstern. **Härtung** schließt sie: unnötige Dienste aus, SSH absichern, Updates automatisieren, Rechte prüfen, Protokollierung einschalten.

## hd-02
Für Windows gibt es fertige Härtungsvorgaben wie die **CIS Benchmarks** und Microsoft Security Baselines – erprobte Einstellungslisten, die man per Gruppenrichtlinie ausrollt.

## hd-03
Laptops, Macs, Smartphones und Tablets sind die Geräte, die das Haus verlassen. Verschlüsselung, Updates, Bildschirmsperre und zentrale Verwaltung schützen sie unterwegs.

## hd-04
Switches, Router und Firewalls sind das Rückgrat des Netzes. Standardpasswörter ändern, Verwaltungszugänge absichern, Firmware aktualisieren und Konfigurationen sichern – sonst wird das Rückgrat zur Schwachstelle.

## iso-01
Die **organisatorischen Maßnahmen** in ISO 27001 Annex A regeln Richtlinien, Rollen, Lieferanten, Vorfälle und Kontinuität – das Management-Gerüst der Sicherheit.

## iso-02
Die **personellen Maßnahmen** betreffen den Menschen: Überprüfung vor der Einstellung, Schulung, Vertraulichkeit, Austritt und Fernarbeit.

## iso-03
Die **physischen Maßnahmen** schützen Räume und Geräte: Zutritt, Arbeitsplätze, Versorgung, Verkabelung, Entsorgung von Datenträgern.

## iso-04
Die **technologischen Maßnahmen** sind der größte Block: Zugriffskontrolle, Kryptografie, Logging, Schwachstellenmanagement, sichere Entwicklung, Netzsicherheit und mehr.

## rg-01
**PCI DSS** ist der Sicherheitsstandard der Kreditkartenbranche. Wer Kartendaten verarbeitet, muss strenge Anforderungen erfüllen – von Netzsegmentierung bis zu regelmäßigen Tests.

## rg-02
**DORA** verpflichtet den Finanzsektor in der EU zu digitaler operationaler Resilienz: IKT-Risikomanagement, Vorfallmeldungen, Tests und Kontrolle von IT-Dienstleistern.

## rg-03
**KRITIS** sind Einrichtungen, deren Ausfall die Gesellschaft hart trifft – Strom, Wasser, Gesundheit. Das BSI-Gesetz legt für sie besondere Sicherheits- und Meldepflichten fest.

## rg-04
**TISAX** ist der Sicherheitsnachweis der Automobilindustrie. Ähnliche Branchenstandards gibt es für viele Bereiche – sie übersetzen allgemeine Sicherheitsregeln in die Sprache der Branche.

## dp-01
**Anonymisierte** Daten lassen keinen Rückschluss auf Personen mehr zu, **pseudonymisierte** nur mit Zusatzwissen. Der Unterschied entscheidet, ob Datenschutzrecht noch gilt.

## dp-02
Bevor riskante Datenverarbeitungen starten, verlangt die DSGVO eine **Datenschutz-Folgenabschätzung**: Welche Risiken entstehen für die Betroffenen, und wie werden sie gemindert?

## dp-03
Daten, die man nicht mehr braucht, sind nur noch Risiko. **Lösch- und Aufbewahrungskonzepte** legen fest, was wie lange aufbewahrt und wie es sicher gelöscht wird.

## kar-01
Cybersicherheit hat viele Türen: SOC, Pentest, Forensik, Architektur, Beratung, Management. Dieses Modul zeigt Wege hinein – auch für Quereinsteiger.

## kar-02
Wer viel lernt, braucht ein zweites Gehirn: ein Notizsystem, in dem Befehle, Erkenntnisse und Lösungswege auffindbar bleiben.

## kar-03
Praktische Prüfungen sind Marathons. Planung, Zeitmanagement, Notizen und Ruhe sind oft wichtiger als ein weiteres Werkzeug.

## kar-04
**CTFs** sind Rätselwettbewerbe für Hacker: Man sucht „Flags“ in Web, Krypto, Forensik und mehr. Sie trainieren Neugier und Problemlösen – mit Spaß.

## kr-01
Blockchiffren wie AES verschlüsseln Daten in festen Blöcken. Wie diese Blöcke verkettet werden – der **Betriebsmodus** –, entscheidet, ob das Ergebnis wirklich sicher ist.

## kr-02
Public-Key-Verfahren funktionieren mit Schlüsselpaaren: einer öffentlich, einer privat. Elliptische Kurven erreichen dieselbe Sicherheit mit viel kürzeren Schlüsseln.

## kr-03
Eine **PKI** ist die Infrastruktur hinter Zertifikaten: Wer stellt aus, wer prüft, wie wird widerrufen? Ohne gut betriebene PKI wackeln TLS, VPN und WLAN-Anmeldung.

## kr-04
Künftige Quantencomputer könnten heutige Public-Key-Verfahren brechen. **Post-Quanten-Kryptografie** entwickelt Ersatz – und die Umstellung muss schon heute geplant werden.

## kr-05
Kryptografie scheitert selten an der Mathematik, sondern an der Anwendung: falsche Modi, wiederverwendete Nonces, selbst gebaute Verfahren, schlechte Zufallszahlen.

## ot-01
Industrieanlagen sprechen eigene Sprachen wie Modbus, S7 oder OPC UA – oft ohne Verschlüsselung oder Anmeldung, weil sie für abgeschottete Netze gedacht waren.

## ot-02
In Industrienetzen darf Überwachung den Betrieb nicht stören. Deshalb hört man meist nur passiv mit und lernt, was „normal“ ist – Abweichungen fallen dann auf.

## ot-03
Ein Vorfall in einer Industrieanlage verlangt besondere Vorsicht: Sicherheit von Menschen und Anlage geht vor, und ein vorschnelles Abschalten kann mehr schaden als der Angriff.

## wd-01
Ein Webserver ist die Haustür der Anwendung. Härtung heißt: aktuelle Software, minimale Module, sichere TLS-Einstellungen, Security-Header und keine verräterischen Fehlerseiten.

## wd-02
Eine **Sitzung** merkt sich, wer angemeldet ist. Ist sie schlecht geschützt, kann jemand sie stehlen oder übernehmen – und ist dann ohne Passwort „du“.

## wd-03
Browser schützen Webseiten voneinander mit der Same-Origin-Policy. **CORS** lockert diesen Schutz gezielt – falsch konfiguriert, öffnet es Tür und Tor.

## wd-04
Eine **Web Application Firewall** filtert bösartige Anfragen vor der Anwendung. Sie ist ein Sicherheitsnetz – kein Ersatz für sicheren Code – und braucht Pflege, damit sie nicht zu viel oder zu wenig blockiert.

## wd-05
Webanwendungen sollten protokollieren, was sicherheitsrelevant ist: Anmeldungen, Fehler, Rechteänderungen. Nur so erkennt man Angriffe auf die Anwendung selbst.

## wd-06
Sicherer Betrieb umfasst mehr als den Code: Hosting, Backups, Updates, Zugänge, Überwachung und ein Plan für den Ernstfall.

## wl-01
Ein gutes WLAN wird geplant, bevor der erste Access Point hängt: Abdeckung, Kapazität, Sicherheit und Verwaltung gehören von Anfang an zusammen.

## wl-02
Funk ist unsichtbar – Messungen machen ihn sichtbar. Site Surveys und Spektrumanalyse zeigen Abdeckung, Störungen und unerwünschte Sender.

## wl-03
Gäste brauchen Internet, aber keinen Zugang zum Firmennetz. Gastnetze und Captive Portals trennen beides – richtig konfiguriert.

## wl-04
Ein **Wireless IDS/IPS** beobachtet den Funk und meldet gefälschte Access Points, Angriffe und Fehlkonfigurationen – die Alarmanlage für das WLAN.
