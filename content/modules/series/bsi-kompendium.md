---
id: bsi-01
title: BSI-Kompendium · ISMS – Sicherheitsmanagement
paths: specialist
order: 30
difficulty: medium
icon: building.columns
tags: bsi
summary: Die Schicht ISMS im IT-Grundschutz-Kompendium – Verantwortung der Leitung, Leitlinie, Organisation, Konzeption und kontinuierliche Verbesserung.
---

## Inhalt der Schicht

Die Schicht **ISMS** enthält den Baustein **ISMS.1 Sicherheitsmanagement**. Er beschreibt, wie Informationssicherheit gesteuert wird – unabhängig von Technik.

## Kernanforderungen (Auswahl)

| Anforderung | Inhalt |
|---|---|
| Übernahme der Gesamtverantwortung | Die Leitung ist verantwortlich und stellt Ressourcen bereit |
| Festlegung der Sicherheitsziele | Ziele und Strategie abgestimmt auf die Geschäftsziele |
| Leitlinie zur Informationssicherheit | verbindliches Dokument, von der Leitung verabschiedet |
| Benennung eines ISB | Informationssicherheitsbeauftragter mit ausreichend Zeit und direktem Zugang zur Leitung |
| Sicherheitskonzept | Umsetzung auf Basis von Strukturanalyse, Schutzbedarf, Modellierung |
| Integration in Prozesse | Sicherheit in Projekte, Beschaffung, Änderungen einbinden |
| Aufrechterhaltung | Überprüfung, Kennzahlen, Management-Berichte |

> [!MERKE] Ohne Leitung kein ISMS
> Das BSI betont: Informationssicherheit ist Chefsache. Ohne sichtbare Unterstützung und Ressourcen der Leitung scheitern ISMS in der Praxis – das gilt genauso für ISO 27001 ([[mod:s-02|ISMS nach ISO 27001]]).

## Quiz

? Welcher Baustein bildet die Schicht ISMS?
= ISMS.1
= ISMS.1 Sicherheitsmanagement

? Wer trägt die Gesamtverantwortung für Informationssicherheit?
+ die Leitung der Institution
- der Administrator
- der Datenschutzbeauftragte
- der Hersteller

? Wie heißt die zentrale Rolle für Informationssicherheit im IT-Grundschutz?
= ISB
= Informationssicherheitsbeauftragter

? Welches Dokument verabschiedet die Leitung als Grundlage?
= Leitlinie zur Informationssicherheit
= Leitlinie

@@@ MODULE @@@
---
id: bsi-02
title: BSI-Kompendium · ORP – Organisation und Personal
paths: specialist
order: 31
difficulty: easy
icon: person.3.sequence.fill
tags: bsi
summary: Organisation, Personal, Sensibilisierung, Identitäts- und Berechtigungsmanagement sowie Compliance-Management als organisatorisches Fundament.
---

## Bausteine

| Baustein | Thema |
|---|---|
| ORP.1 | Organisation – Zuständigkeiten, Regelungen, Betriebsmittel |
| ORP.2 | Personal – Einarbeitung, Vertretung, Ausscheiden |
| ORP.3 | Sensibilisierung und Schulung zur Informationssicherheit |
| ORP.4 | Identitäts- und Berechtigungsmanagement |
| ORP.5 | Compliance Management (Anforderungsmanagement) |

## Wichtige Inhalte

- **Ausscheiden von Mitarbeitenden**: alle Zugänge sperren, Geräte und Ausweise zurück, Passwörter gemeinsam genutzter Konten ändern
- **Vertretungsregelungen**, damit Wissen und Aufgaben nicht an Einzelnen hängen
- **Schulungskonzept** mit zielgruppengerechten Inhalten und Erfolgskontrolle ([[mod:s-08|Awareness]])
- **Berechtigungen** nach Need-to-know und Least Privilege, Antrags- und Genehmigungsprozess, regelmäßige Rezertifizierung, Funktionstrennung
- **Compliance**: rechtliche und vertragliche Anforderungen ermitteln und überwachen

> [!TIPP] Joiner, Mover, Leaver
> Die drei kritischen Momente im Identitätsmanagement: Eintritt, Wechsel der Abteilung (alte Rechte entziehen!) und Austritt. Vor allem beim Wechsel sammeln sich sonst über Jahre Rechte an („Privilege Creep“).

## Quiz

? Welcher Baustein behandelt Identitäts- und Berechtigungsmanagement?
= ORP.4

? Welcher Baustein behandelt Sensibilisierung und Schulung?
= ORP.3

? Wie nennt man das Ansammeln von Rechten über Jahre?
= Privilege Creep

? Was muss beim Ausscheiden passieren?
+ alle Zugänge sperren und gemeinsam genutzte Passwörter ändern
- nichts
- nur das E-Mail-Postfach löschen
- den Arbeitsplatz neu streichen

@@@ MODULE @@@
---
id: bsi-03
title: BSI-Kompendium · CON – Konzepte und Vorgehensweisen
paths: specialist
order: 32
difficulty: medium
icon: doc.text.fill
tags: bsi
summary: Kryptokonzept, Datenschutz, Datensicherungskonzept, Löschen und Vernichten, Softwareentwicklung, Webanwendungen und Informationsaustausch.
---

## Wichtige Bausteine

| Baustein | Thema |
|---|---|
| CON.1 | Kryptokonzept |
| CON.2 | Datenschutz |
| CON.3 | Datensicherungskonzept |
| CON.6 | Löschen und Vernichten |
| CON.7 | Informationssicherheit auf Auslandsreisen |
| CON.8 | Software-Entwicklung |
| CON.9 | Informationsaustausch |
| CON.10 | Entwicklung von Webanwendungen |
| CON.11 | Geheimschutz |

## Kerngedanken

- **Kryptokonzept**: Welche Verfahren und Schlüssellängen sind erlaubt, wie werden Schlüssel erzeugt, verteilt, gespeichert, gesperrt? (siehe [[mod:kr-05|Krypto-Fehler]])
- **Datensicherung**: Was wird wie oft, wohin und wie lange gesichert? Wer darf wiederherstellen? Wird die Wiederherstellung getestet?
- **Löschen und Vernichten**: geeignete Verfahren je Datenträger und Schutzbedarf (DIN 66399), Nachweis
- **Software-Entwicklung**: sichere Vorgehensmodelle, Tests, Abhängigkeiten ([[mod:x-04|Secure SDLC]])
- **Auslandsreisen**: Geräte mit minimalen Daten, Verschlüsselung, Vorsicht bei Grenzkontrollen und fremden Netzen

## Quiz

? Welcher Baustein behandelt das Kryptokonzept?
= CON.1

? Welcher Baustein behandelt das Datensicherungskonzept?
= CON.3

? Welcher Baustein behandelt Löschen und Vernichten?
= CON.6

? Was gehört in ein Datensicherungskonzept?
+ Umfang, Häufigkeit, Speicherort, Aufbewahrung und Wiederherstellungstests
- nur der Name des Backup-Programms
- die Farben der Bänder
- nichts

@@@ MODULE @@@
---
id: bsi-04
title: BSI-Kompendium · OPS – Betrieb
paths: specialist, cdsa
order: 33
difficulty: medium
icon: gearshape.2.fill
tags: bsi
summary: IT-Administration, Patch- und Änderungsmanagement, Schutz vor Schadprogrammen, Protokollierung, Fernwartung, Outsourcing und Cloud-Nutzung im Betrieb.
---

## Wichtige Bausteine

| Baustein | Thema |
|---|---|
| OPS.1.1.2 | Ordnungsgemäße IT-Administration |
| OPS.1.1.3 | Patch- und Änderungsmanagement |
| OPS.1.1.4 | Schutz vor Schadprogrammen |
| OPS.1.1.5 | Protokollierung |
| OPS.1.1.6 | Software-Tests und -Freigaben |
| OPS.1.2.5 | Fernwartung |
| OPS.2.2 | Cloud-Nutzung |
| OPS.2.3 | Nutzung von Outsourcing |

## Kerngedanken

- **Administration**: personalisierte Admin-Konten, getrennt von Alltagskonten, dokumentierte Tätigkeiten
- **Patch-Management**: Verantwortliche, Informationsquellen, Fristen, Tests, Rückfallplanung ([[mod:s-09|Schwachstellenmanagement]])
- **Änderungsmanagement**: geplante, genehmigte, dokumentierte Änderungen mit Notfallweg
- **Protokollierung**: Protokollierungskonzept, zentrale Speicherung, Auswertung, Datenschutz
- **Fernwartung**: nur nach Freigabe, verschlüsselt, protokolliert, begrenzt ([[mod:s-13|Dienstleister]])

## Quiz

? Welcher Baustein behandelt Patch- und Änderungsmanagement?
= OPS.1.1.3

? Welcher Baustein behandelt Protokollierung?
= OPS.1.1.5

? Welcher Baustein behandelt Fernwartung?
= OPS.1.2.5

? Wie sollten Admin-Konten gestaltet sein?
+ personalisiert und getrennt von Alltagskonten
- geteilt von allen Admins
- identisch mit dem E-Mail-Konto
- ohne Passwort

@@@ MODULE @@@
---
id: bsi-05
title: BSI-Kompendium · DER – Detektion und Reaktion
paths: specialist, cdsa
order: 34
difficulty: medium
icon: waveform.path.ecg.rectangle
tags: bsi
summary: Detektion sicherheitsrelevanter Ereignisse, Behandlung von Sicherheitsvorfällen, Forensik, Audits und Revisionen sowie Notfallmanagement.
---

## Wichtige Bausteine

| Baustein | Thema |
|---|---|
| DER.1 | Detektion von sicherheitsrelevanten Ereignissen |
| DER.2.1 | Behandlung von Sicherheitsvorfällen |
| DER.2.2 | Vorsorge für die IT-Forensik |
| DER.2.3 | Bereinigung weitreichender Sicherheitsvorfälle |
| DER.3.1 | Audits und Revisionen |
| DER.3.2 | Revisionen auf Basis des Leitfadens IS-Revision |
| DER.4 | Notfallmanagement |

## Kerngedanken

- **Detektion**: Detektionskonzept, relevante Logquellen, zentrale Auswertung, definierte Meldewege ([[mod:d-01|SOC und SIEM]])
- **Vorfallbehandlung**: Richtlinie, Verantwortlichkeiten, Meldewege, Einstufung, Eindämmung, Wiederherstellung, Nachbereitung ([[mod:s-07|Incident Response]])
- **Forensik-Vorsorge**: Logs aufbewahren, Werkzeuge und Ansprechpartner bereithalten, Beweissicherung planen ([[mod:d-08|Forensik]])
- **Bereinigung weitreichender Vorfälle**: wenn große Teile der Infrastruktur betroffen sind (z. B. AD-Kompromittierung) – Neuaufbau planen, Vertrauensanker erneuern
- **Notfallmanagement**: siehe BSI-Standard 200-4

## Quiz

? Welcher Baustein behandelt die Detektion sicherheitsrelevanter Ereignisse?
= DER.1

? Welcher Baustein behandelt die Behandlung von Sicherheitsvorfällen?
= DER.2.1

? Welcher Baustein behandelt die Vorsorge für IT-Forensik?
= DER.2.2

? Welcher Baustein behandelt Notfallmanagement?
= DER.4

? Welcher BSI-Standard vertieft das Notfallmanagement?
= 200-4

@@@ MODULE @@@
---
id: bsi-06
title: BSI-Kompendium · APP – Anwendungen
paths: specialist
order: 35
difficulty: medium
icon: app.connected.to.app.below.fill
tags: bsi
summary: Bürosoftware, Webbrowser, Verzeichnisdienste und Active Directory, E-Mail, Webanwendungen und -server, Datenbanken und weitere Anwendungsbausteine.
---

## Wichtige Bausteine

| Baustein | Thema |
|---|---|
| APP.1.1 | Office-Produkte |
| APP.1.2 | Webbrowser |
| APP.2.1 | Allgemeiner Verzeichnisdienst |
| APP.2.2 | Active Directory Domain Services |
| APP.3.1 | Webanwendungen und Webservices |
| APP.3.2 | Webserver |
| APP.4.3 | Relationale Datenbanken |
| APP.5.3 | Allgemeiner E-Mail-Client und -Server |

## Beispiele für Anforderungen

- **Office**: Makros einschränken, aktive Inhalte aus dem Internet blockieren
- **Browser**: zentrale Konfiguration, Updates, Erweiterungen kontrollieren
- **Active Directory**: Tiering, Schutz privilegierter Konten, Härtung der DCs ([[mod:a-04|AD verteidigen]])
- **Webanwendungen**: Authentifizierung, Eingabevalidierung, Schutz vor Injection, sichere Sitzungen
- **Webserver**: Härtung, TLS, Protokollierung ([[mod:wd-01|Webserver härten]])
- **Datenbanken**: getrennte Konten, Verschlüsselung, Zugriffsbeschränkung im Netz

## Quiz

? Welcher Baustein behandelt Active Directory Domain Services?
= APP.2.2

? Welcher Baustein behandelt Webanwendungen und Webservices?
= APP.3.1

? Welcher Baustein behandelt relationale Datenbanken?
= APP.4.3

? Was fordert der Office-Baustein unter anderem?
+ Makros und aktive Inhalte einschränken
- Office deinstallieren
- nur alte Versionen nutzen
- alle Add-ins erlauben

@@@ MODULE @@@
---
id: bsi-07
title: BSI-Kompendium · SYS – IT-Systeme
paths: specialist
order: 36
difficulty: medium
icon: desktopcomputer
tags: bsi
summary: Server und Clients unter Windows, Linux und macOS, Virtualisierung, Container, Speicherlösungen, Smartphones und Wechseldatenträger.
---

## Wichtige Bausteine

| Baustein | Thema |
|---|---|
| SYS.1.1 | Allgemeiner Server |
| SYS.1.2.3 | Windows Server |
| SYS.1.3 | Server unter Linux und Unix |
| SYS.1.5 | Virtualisierung |
| SYS.1.6 | Containerisierung |
| SYS.1.8 | Speicherlösungen |
| SYS.2.1 | Allgemeiner Client |
| SYS.2.2.3 | Clients unter Windows |
| SYS.2.3 | Clients unter Linux und Unix |
| SYS.3.2.1 | Allgemeine Smartphones und Tablets |
| SYS.4.5 | Wechseldatenträger |

## Querschnittsanforderungen

- sichere Grundkonfiguration und Härtung (Baselines, [[mod:wp-06|Windows-Härtung]])
- Updates zeitnah
- Schutz vor Schadprogrammen
- Protokollierung
- minimale installierte Software und Dienste
- Verschlüsselung mobiler Geräte und Datenträger
- Virtualisierung: Trennung von Management und VMs, Kontrolle über Snapshots, Ressourcenplanung (vgl. deine [[mod:cr-04|Range L1]])

## Quiz

? Welcher Baustein behandelt Virtualisierung?
= SYS.1.5

? Welcher Baustein behandelt Containerisierung?
= SYS.1.6

? Welcher Baustein behandelt Server unter Linux und Unix?
= SYS.1.3

? Welcher Baustein behandelt Wechseldatenträger?
= SYS.4.5

@@@ MODULE @@@
---
id: bsi-08
title: BSI-Kompendium · IND – Industrielle IT
paths: specialist, cyberrange
order: 37
difficulty: hard
icon: gearshape.arrow.triangle.2.circlepath
tags: bsi
summary: OT-Betrieb, Segmentierung, Prozessleit- und Automatisierungstechnik, speicherprogrammierbare Steuerungen und Fernwartung im industriellen Umfeld.
---

## Wichtige Bausteine

| Baustein | Thema |
|---|---|
| IND.1 | Prozessleit- und Automatisierungstechnik |
| IND.2.1 | Allgemeine ICS-Komponente |
| IND.2.2 | Speicherprogrammierbare Steuerung (SPS) |
| IND.2.3 | Sensoren und Aktoren |
| IND.2.4 | Maschine |
| IND.2.7 | Safety Instrumented Systems |
| IND.3.2 | Fernwartung im industriellen Umfeld |

## Kerngedanken

- Verfügbarkeit und Safety haben Vorrang ([[mod:s-11|OT-Sicherheit]])
- Segmentierung zwischen Büro- und Produktionsnetz, Zonen nach IEC 62443
- Inventar aller Komponenten inkl. Firmware-Stand
- Änderungen nur geplant und mit Herstellerfreigabe
- Fernwartung über zentrale, protokollierte Zugänge
- Safety-Systeme (SIS) besonders schützen und getrennt halten

## Quiz

? Welcher Baustein behandelt speicherprogrammierbare Steuerungen?
= IND.2.2

? Welcher Baustein behandelt Fernwartung im industriellen Umfeld?
= IND.3.2

? Was hat in der industriellen IT Vorrang?
+ Verfügbarkeit und Safety
- Vertraulichkeit
- Geschwindigkeit der Updates
- Design

? Welcher Baustein behandelt Safety Instrumented Systems?
= IND.2.7

@@@ MODULE @@@
---
id: bsi-09
title: BSI-Kompendium · NET – Netze und Kommunikation
paths: specialist, cyberrange
order: 38
difficulty: medium
icon: network
tags: bsi
summary: Netzarchitektur und -design, Netzmanagement, Router und Switches, Firewall, VPN, WLAN, VoIP und Netzzugangskontrolle.
---

## Wichtige Bausteine

| Baustein | Thema |
|---|---|
| NET.1.1 | Netzarchitektur und -design |
| NET.1.2 | Netzmanagement |
| NET.2.1 | WLAN-Betrieb |
| NET.2.2 | WLAN-Nutzung |
| NET.3.1 | Router und Switches |
| NET.3.2 | Firewall |
| NET.3.3 | VPN |
| NET.3.4 | Network Access Control |
| NET.4.2 | VoIP |

## Kerngedanken

- **Netzarchitektur**: Segmentierung in Zonen, Trennung von Management-Netzen, P-A-P-Struktur (Paketfilter – Application Level Gateway – Paketfilter) für Übergänge zum Internet
- **Netzmanagement**: eigenes Management-Netz, verschlüsselte Protokolle, zentrale Konfigurationssicherung
- **Firewall**: Default Deny, dokumentiertes Regelwerk, regelmäßige Prüfung ([[mod:nw-05|Firewalls]])
- **WLAN**: WPA3/WPA2-Enterprise, Trennung von Gastnetzen ([[mod:w-05|WLAN-Härtung]])
- **NAC**: nur bekannte, konforme Geräte erhalten Netzzugang (802.1X)

## Quiz

? Welcher Baustein behandelt Netzarchitektur und -design?
= NET.1.1

? Welcher Baustein behandelt den WLAN-Betrieb?
= NET.2.1

? Welcher Baustein behandelt Network Access Control?
= NET.3.4

? Wofür steht die P-A-P-Struktur?
+ Paketfilter – Application Level Gateway – Paketfilter
- Proxy – Antivirus – Patch
- Port – Adresse – Protokoll
- Plan – Act – Prüfen

@@@ MODULE @@@
---
id: bsi-10
title: BSI-Kompendium · INF – Infrastruktur
paths: specialist
order: 39
difficulty: easy
icon: building.2.fill
tags: bsi
summary: Gebäude, Elektrotechnische Verkabelung, Rechenzentrum, Serverraum, Büroarbeitsplatz, häuslicher Arbeitsplatz und mobiler Arbeitsplatz.
---

## Wichtige Bausteine

| Baustein | Thema |
|---|---|
| INF.1 | Allgemeines Gebäude |
| INF.2 | Rechenzentrum sowie Serverraum |
| INF.5 | Raum sowie Schrank für technische Infrastruktur |
| INF.7 | Büroarbeitsplatz |
| INF.8 | Häuslicher Arbeitsplatz |
| INF.9 | Mobiler Arbeitsplatz |
| INF.10 | Besprechungs-, Veranstaltungs- und Schulungsräume |
| INF.12 | Verkabelung |

## Kerngedanken

- Brandschutz, Stromversorgung, Klima, Wasser
- Zutrittskontrolle nach Zonen ([[mod:s-12|Physische Sicherheit]])
- Serverräume ohne Fremdnutzung, überwacht
- **Homeoffice**: geschützte Geräte, kein Mitlesen durch Dritte, sichere Aufbewahrung von Unterlagen, VPN
- **mobiles Arbeiten**: Sichtschutz, verschlüsselte Geräte, Vorsicht in öffentlichen Netzen

## Quiz

? Welcher Baustein behandelt Rechenzentrum und Serverraum?
= INF.2

? Welcher Baustein behandelt den häuslichen Arbeitsplatz?
= INF.8

? Welcher Baustein behandelt den mobilen Arbeitsplatz?
= INF.9

? Welche Maßnahmen gehören zum mobilen Arbeiten?
+ Sichtschutz und verschlüsselte Geräte
- Passwörter auf Zettel am Laptop
- öffentliche WLANs ohne VPN
- unverschlüsselte USB-Sticks
