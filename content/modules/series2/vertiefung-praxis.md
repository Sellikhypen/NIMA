---
id: ptm-11
title: Pentest-Methodik 11 · Webanwendungen prüfen nach OWASP WSTG
paths: cwes, cpts, cwee
order: 39.5
difficulty: medium
icon: checklist.unchecked
tags: web, methodik, wstg
summary: Der OWASP Web Security Testing Guide als roter Faden – Kategorien, Vorgehen, Testkonten, Abdeckung dokumentieren und typische Lücken im Testplan vermeiden.
---

## Einfach erklärt

Ein Pilot geht vor dem Start eine Checkliste durch – nicht weil er sein Flugzeug nicht kennt, sondern weil Checklisten verhindern, dass man unter Druck etwas vergisst. Der **OWASP Web Security Testing Guide (WSTG)** ist so eine Checkliste für Webanwendungen: eine Sammlung von Prüfkategorien, die sicherstellt, dass kein wichtiger Bereich übersehen wird.

## Die Kategorien

| Kürzel | Bereich | Beispiele |
|---|---|---|
| INFO | Informationssammlung | Technologie, Einstiegspunkte, Kommentare |
| CONF | Konfiguration und Betrieb | Header, HTTP-Methoden, Backups im Webroot |
| IDNT | Identitätsmanagement | Registrierung, Rollen, Kontenaufzählung |
| ATHN | Authentifizierung | Passwortrichtlinie, Lockout, Reset, MFA |
| ATHZ | Autorisierung | IDOR, Rechteausweitung, Pfadmanipulation |
| SESS | Sitzungen | Cookies, Fixation, Timeout, CSRF |
| INPV | Eingabevalidierung | Injection-Klassen, XSS, SSRF |
| ERRH | Fehlerbehandlung | Stacktraces, Fehlercodes |
| CRYP | Kryptografie | TLS, schwache Verfahren, Zufall |
| BUSL | Geschäftslogik | Abläufe umgehen, Limits, Race Conditions |
| CLNT | Clientseite | DOM-XSS, CORS, Clickjacking, postMessage |
| APIT | APIs | GraphQL, REST-Besonderheiten |

## Vorgehen

1. **Kartieren**: Alle Funktionen, Rollen, Parameter, Endpunkte (Proxy-Verlauf, Sitemap, API-Beschreibung).
2. **Testplan**: Pro Kategorie festlegen, was relevant ist – und warum etwas nicht relevant ist.
3. **Testkonten**: mindestens zwei pro Rolle, plus unterschiedliche Rollen.
4. **Testen und dokumentieren**: Jeder Testfall mit Ergebnis (bestanden, Befund, nicht anwendbar).
5. **Abdeckung** im Bericht zeigen: Was wurde geprüft, was nicht (z. B. aus Zeitgründen)?

> [!MERKE] „Nicht getestet“ ist auch eine Information
> Ein Bericht, der offenlegt, welche Bereiche nicht geprüft wurden, ist ehrlicher und nützlicher als einer, der Vollständigkeit vortäuscht.

## Häufige Lücken im Testplan

- Nur mit Admin-Konto getestet → Autorisierungsfehler bleiben unsichtbar.
- APIs neben der Weboberfläche vergessen (Mobile-App-Backend!).
- Geschäftslogik nicht verstanden → Logikfehler übersehen.
- Dateiuploads, Exporte, Importe nicht geprüft.
- Passwort-Reset und Registrierung nur oberflächlich.

## Tiefer eingetaucht

Der WSTG ist kein starres Pflichtprogramm, sondern ein Rahmen. Für hohe Schutzbedarfe gibt es den **ASVS** (Application Security Verification Standard) mit konkreten, prüfbaren Anforderungen in drei Stufen – nützlich, wenn Entwicklungsteams wissen wollen, *was* eine sichere Anwendung erfüllen muss, nicht nur *wie* man testet. Kombiniert ergibt sich ein Kreislauf: Anforderungen (ASVS) → Entwicklung → Test (WSTG) → Bericht → Behebung → Retest.

## Quiz

? Was ist der OWASP WSTG?
+ ein Leitfaden mit Prüfkategorien für Webanwendungstests
- ein Virenscanner
- ein Webserver
- eine Programmiersprache
! Er sorgt dafür, dass kein wichtiger Bereich übersehen wird.

? Welche WSTG-Kategorie betrifft IDOR und Rechteausweitung?
= ATHZ
= Autorisierung
! Authorization Testing.

? Welche Kategorie betrifft Abläufe umgehen und Race Conditions?
= BUSL
= Geschäftslogik
! Business Logic Testing.

?tf Ein Test nur mit Admin-Konto findet Autorisierungsfehler zuverlässig.
= falsch
! Dafür braucht man mehrere Konten und Rollen.

? Welcher OWASP-Standard beschreibt prüfbare Anforderungen an sichere Anwendungen?
= ASVS
= Application Security Verification Standard
! Mit drei Stufen je nach Schutzbedarf.

? Warum sollte ein Bericht auch nicht getestete Bereiche nennen?
+ er ist ehrlicher und zeigt verbleibende Unsicherheit
- weil es Seiten füllt
- weil es Pflicht für jeden Satz ist
- damit der Kunde keine Fragen stellt
! Abdeckung transparent machen.

@@@ MODULE @@@
---
id: adx-12
title: AD verstehen 12 · AD-Aufklärung erkennen
paths: cdsa, cape, specialist
order: 13.2
difficulty: hard
icon: eye.trianglebadge.exclamationmark
tags: active directory, erkennung, ldap
summary: Wie sich die Erkundung von Active Directory in Logs zeigt – LDAP-Abfragen, Sitzungs- und Freigaben-Enumeration, Honeytokens und Defender for Identity.
---

## Einfach erklärt

Bevor ein Einbrecher ein Bürogebäude ausraubt, liest er den Gebäudeplan und schaut, wer wo sitzt. Im Active Directory heißt das: Benutzer, Gruppen, Admins, Computer und Rechte abfragen. Das Problem für Verteidiger: **Jeder angemeldete Nutzer darf vieles davon lesen.** Die Kunst ist, ungewöhnliche Neugier von normalem Betrieb zu unterscheiden.

## Typische Aufklärungsaktivitäten

| Aktivität | Spuren |
|---|---|
| Massenhafte LDAP-Abfragen (alle Nutzer, Gruppen, SPNs, ACLs) | hohe Zahl/Größe von LDAP-Suchen eines Clients; Event 1644 (bei aktivierter Diagnose) |
| Abfrage privilegierter Gruppen | Zugriffe auf Domain Admins & Co. (Event 4661/4662 mit SACL) |
| Sitzungs-Enumeration auf vielen Hosts | viele SMB-Verbindungen zu `IPC$` / `srvsvc` von einem Client |
| Freigaben durchsuchen | viele 5140/5145-Ereignisse in kurzer Zeit |
| SPN-Abfragen | LDAP-Filter auf `servicePrincipalName` |
| Kerberos-Abfragen für viele Dienste | Anstieg von 4769 von einem Konto |

> [!MERKE] Volumen und Herkunft
> Admin-Werkzeuge und Inventarsysteme fragen das AD ebenfalls ab. Auffällig ist ein **normaler Arbeitsplatz** oder ein **normales Benutzerkonto**, das plötzlich das gesamte Verzeichnis ausliest.

## Erkennung verbessern

1. **Baseline**: Welche Systeme fragen normalerweise viel ab (Monitoring, IAM, Backup)? → Allowlist.
2. **Honeytokens**: Ein Köder-Admin-Konto oder ein Köder-SPN, das niemand legitim nutzt. Jede Abfrage oder Ticketanforderung dafür ist ein starker Alarm.
3. **SACLs** auf sensiblen Objekten (z. B. AdminSDHolder, privilegierte Gruppen) für Lesezugriffe gezielt aktivieren.
4. **Spezialisierte Sensoren** wie Microsoft Defender for Identity erkennen Aufklärungsmuster aus DC-Verkehr.
5. **Netzwerksicht**: Viele SMB-Verbindungen von einem Client zu vielen Hosts in Minuten.

## Prävention

- Unnötige Leserechte einschränken (z. B. Sitzungsabfrage auf Servern per Richtlinie begrenzen; Windows schränkt NetSessionEnum in neueren Versionen standardmäßig ein).
- Beschreibungsfelder ohne Passwörter oder sensible Hinweise.
- Tiering und Hygiene reduzieren den Wert der gesammelten Informationen.

## Tiefer eingetaucht

Aufklärung ist oft der **früheste** erkennbare Schritt nach dem Erstzugang – lange bevor Schaden entsteht. Ein gut platzierter Köder (etwa ein Konto `svc_backup_admin` mit SPN, das nirgends verwendet wird, aber attraktiv aussieht) liefert mit sehr wenig Rauschen einen Alarm genau in dieser Phase. Wichtig: Köder dürfen keine echten Rechte haben und müssen dokumentiert sein, damit eigene Admins nicht versehentlich Alarm auslösen.

## Quiz

? Warum ist AD-Aufklärung schwer zu erkennen?
+ normale Benutzer dürfen viele Informationen legitim lesen
- weil sie keine Netzwerkpakete erzeugt
- weil sie nur nachts passiert
- weil AD keine Logs kennt
! Entscheidend sind Volumen, Herkunft und Kontext.

? Was ist ein Honeytoken im AD-Kontext?
+ ein Köderkonto oder Köder-SPN, das niemand legitim nutzt
- ein besonders starkes Passwort
- ein MFA-Gerät
- ein Gruppenrichtlinienobjekt
! Jede Nutzung erzeugt einen rauscharmen Alarm.

? Welche Event-IDs zeigen Zugriffe auf Netzwerkfreigaben?
+ 5140
+ 5145
- 4624
- 1102
! Viele davon in kurzer Zeit können auf Enumeration hindeuten.

?tf Ein normaler Arbeitsplatz, der das gesamte Verzeichnis ausliest, ist auffälliger als ein Inventarsystem.
= wahr
! Baseline und Allowlists trennen legitime Abfragen von verdächtigen.

? Welches Microsoft-Produkt erkennt Aufklärungsmuster aus dem Verkehr der Domain Controller?
= Defender for Identity
= Microsoft Defender for Identity
! Früher Azure ATP.

? Was gehört nicht in AD-Beschreibungsfelder?
+ Passwörter und sensible Hinweise
- Abteilungsnamen
- Standort
- Telefonnummer der IT
! Jeder Domänennutzer kann sie lesen.

@@@ MODULE @@@
---
id: adx-13
title: AD verstehen 13 · Kerberos-Ereignisse lesen und interpretieren
paths: cdsa, cape
order: 13.3
difficulty: hard
icon: doc.text.magnifyingglass
tags: kerberos, logs, erkennung
summary: Die Felder von 4768, 4769 und 4771 verstehen – Verschlüsselungstypen, Fehlercodes, Ticketoptionen – und daraus Kerberoasting, AS-REP-Roasting und Anomalien ableiten.
---

## Einfach erklärt

Jede Kerberos-Anfrage hinterlässt auf dem Domain Controller einen Eintrag – wie ein Ticketschalter, der jedes ausgegebene Ticket notiert. Wer die Spalten dieses Notizbuchs lesen kann, erkennt, wenn jemand ungewöhnlich viele oder ungewöhnliche Tickets abholt.

## Die drei wichtigsten Ereignisse

| ID | Bedeutung | Wichtige Felder |
|---|---|---|
| 4768 | TGT angefordert (AS) | Account Name, Client Address, Ticket Encryption Type, Pre-Authentication Type, Result Code |
| 4769 | Service-Ticket angefordert (TGS) | Account Name, Service Name, Ticket Encryption Type, Ticket Options, Failure Code |
| 4771 | Vorauthentifizierung fehlgeschlagen | Account Name, Client Address, Failure Code |

## Verschlüsselungstypen

| Wert | Typ | Bewertung |
|---|---|---|
| 0x17 | RC4-HMAC | veraltet; in 4769 bei Service-Tickets ein Kerberoasting-Signal |
| 0x12 | AES256 | Standard heute |
| 0x11 | AES128 | ok |

## Wichtige Fehlercodes

| Code | Bedeutung | Interpretation |
|---|---|---|
| 0x6 | Benutzer unbekannt | Kontenaufzählung? |
| 0x12 | Konto gesperrt/deaktiviert | Spraying auf gesperrte Konten |
| 0x18 | Vorauthentifizierung fehlgeschlagen (falsches Passwort) | Password Spraying, wenn über viele Konten |
| 0x25 | Uhrzeitabweichung zu groß | Zeitproblem oder Fremdsystem |

## Muster erkennen

- **Kerberoasting**: Ein Konto fordert in kurzer Zeit viele 4769 für verschiedene Dienste an, oft mit **0x17**.
- **AS-REP-Roasting**: 4768 mit **Pre-Authentication Type 0** für Konten ohne Vorauthentifizierung.
- **Password Spraying über Kerberos**: viele 4771 mit 0x18 über viele Konten von einer Quelle.
- **Ungewöhnliche Dienste**: Service-Tickets für sensible Dienste (z. B. DC-Dienste) von untypischen Konten.

> [!TIPP] Allowlist für Altlasten
> Manche Altsysteme brauchen noch RC4. Diese bekannten Fälle dokumentieren und aus Alarmen ausnehmen – dann wird jeder **neue** RC4-Fall aussagekräftig.

## Tiefer eingetaucht

Langfristig ist Prävention besser als Erkennung: RC4 für Dienstkonten abschalten (`msDS-SupportedEncryptionTypes` auf AES), gMSA einsetzen, Vorauthentifizierung nie deaktivieren, Konten in Protected Users. Gefälschte Tickets (Golden/Silver) sind schwerer zu erkennen; Hinweise sind Tickets mit ungewöhnlichen Lebensdauern, Service-Tickets ohne vorheriges 4768 desselben Kontos auf dem DC, oder Anomalien im PAC, die moderne DCs nach den PAC-Härtungsupdates prüfen.

## Quiz

? Welches Ereignis zeigt die Anforderung eines Service-Tickets?
= 4769
! 4768 betrifft das TGT.

? Welcher Verschlüsselungstyp in 4769 kann auf Kerberoasting hindeuten?
= 0x17
= RC4
= RC4-HMAC
! Viele RC4-Tickets für verschiedene Dienste von einem Konto sind verdächtig.

? Welcher Fehlercode in 4771 steht für ein falsches Passwort bei der Vorauthentifizierung?
= 0x18
! Über viele Konten verteilt ein Hinweis auf Password Spraying.

? Was deutet auf AS-REP-Roasting hin?
+ 4768 mit Pre-Authentication Type 0
- 4624 mit Logon Type 2
- 7045 mit neuem Dienst
- 1102
! Betroffen sind Konten ohne Vorauthentifizierung.

?tf Bekannte RC4-Altlasten sollten dokumentiert und aus Alarmen ausgenommen werden.
= wahr
! Dann wird jeder neue RC4-Fall aussagekräftig.

? Welcher Fehlercode zeigt eine zu große Uhrzeitabweichung?
= 0x25
! Kerberos erlaubt standardmäßig nur wenige Minuten Abweichung.

@@@ MODULE @@@
---
id: os-14
title: Betriebssysteme 14 · Anmeldedaten unter Windows schützen
paths: specialist, cdsa, cpts, cape
order: 25.4
difficulty: hard
icon: lock.shield.fill
tags: windows, lsass, credential guard
summary: Wo Windows Anmeldedaten im Speicher und auf der Platte hält, wie Credential Guard, LSA-Schutz und Protected Users schützen und wie man Credential Dumping erkennt.
---

## Einfach erklärt

Damit man sich nicht ständig neu anmelden muss, merkt sich Windows Anmeldeinformationen – im Arbeitsspeicher des Prozesses **LSASS** und an einigen Orten auf der Festplatte. Für Angreifer ist das eine Schatzkammer: Wer Admin-Rechte auf einem Rechner hat, versucht, dort Passwörter, Hashes oder Tickets anderer Nutzer zu finden. Die Verteidigung hat zwei Ziele: **weniger dort ablegen** und **den Zugriff erschweren**.

## Wo Anmeldedaten liegen

| Ort | Inhalt |
|---|---|
| LSASS-Speicher | Hashes, Kerberos-Tickets, ggf. Klartext (bei alten Einstellungen) |
| SAM (Registry) | Hashes lokaler Konten |
| LSA Secrets | Passwörter von Dienstkonten, Maschinenkonto |
| Cached Domain Credentials | Verifizierer für Offline-Anmeldungen |
| DPAPI-geschützte Daten | Browser-Passwörter, WLAN-Schlüssel, gespeicherte Anmeldedaten |
| NTDS.dit (nur DC) | alle Domänen-Hashes |

## Schutzmaßnahmen

| Maßnahme | Wirkung |
|---|---|
| Credential Guard | Geheimnisse in virtualisierungsbasierter Isolation statt im LSASS-Speicher |
| LSA-Schutz (RunAsPPL) | LSASS als geschützter Prozess, Zugriff nur für signierte, berechtigte Prozesse |
| Protected Users | kein NTLM, keine Delegation, kein RC4, kürzere Ticketlaufzeit |
| WDigest aus | keine Klartextpasswörter im Speicher (Standard seit Win 8.1) |
| Restricted Admin / Remote Credential Guard | RDP ohne Ablage der Anmeldedaten auf dem Ziel |
| Tiering | privilegierte Konten melden sich nicht auf unsicheren Systemen an |
| ASR-Regel gegen LSASS-Diebstahl | blockiert typische Zugriffe |
| Cached Logons begrenzen | weniger gespeicherte Verifizierer |

> [!MERKE] Am wirksamsten: Admins nicht dort anmelden
> Keine Technik schützt so gut wie die Regel, dass hochprivilegierte Konten sich gar nicht erst an Arbeitsplätzen oder normalen Servern anmelden.

## Erkennung

- Sysmon 10 / EDR: Prozesszugriff auf `lsass.exe` mit verdächtigen Zugriffsrechten durch ungewöhnliche Prozesse.
- Erstellung von Speicherabbildern (Dateien wie `lsass.dmp`, Nutzung von Debug-Funktionen).
- Zugriff auf Registry-Hives SAM/SECURITY bzw. deren Export.
- Schattenkopien-Zugriffe auf `NTDS.dit` auf DCs.
- Event 4656/4663 mit SACL auf LSASS (Audit).

## Tiefer eingetaucht

Credential Guard benötigt Virtualisierungsfunktionen (VBS), Secure Boot und TPM; seit neueren Windows-Versionen ist es auf geeigneter Hardware standardmäßig aktiv. Einschränkungen: Es schützt nicht vor Keyloggern oder vor dem Missbrauch einer gerade aktiven Sitzung. Deshalb bleibt Defense in Depth nötig: weniger Rechte, weniger Anmeldungen an exponierten Systemen, schnelle Erkennung.

## Quiz

? In welchem Prozess hält Windows Anmeldedaten im Speicher?
= lsass.exe
= LSASS
! Ein Hauptziel für Credential Dumping.

? Was macht Credential Guard?
+ isoliert Geheimnisse per Virtualisierung außerhalb des normalen LSASS-Speichers
- verschlüsselt die Festplatte
- blockiert alle Netzwerkverbindungen
- ersetzt Passwörter durch PINs
! Virtualization-based Security.

? Was bewirkt der LSA-Schutz (RunAsPPL)?
+ LSASS läuft als geschützter Prozess, auf den nur berechtigte signierte Prozesse zugreifen
- LSASS wird beendet
- Passwörter werden gelöscht
- Anmeldungen werden verboten
! Erschwert das Auslesen des Speichers.

?tf Die wirksamste Maßnahme ist, dass hochprivilegierte Konten sich nicht auf normalen Systemen anmelden.
= wahr
! Was nie dort war, kann dort nicht gestohlen werden.

? Welche Datei enthält auf Domain Controllern alle Domänen-Hashes?
= NTDS.dit
! Zugriffe über Schattenkopien sind ein Warnsignal.

? Welche Funktion verhindert die Ablage von Anmeldedaten auf dem RDP-Zielsystem?
+ Remote Credential Guard
+ Restricted Admin
- WDigest
- AutoLogon
! Wichtig für Admin-Zugriffe per RDP.

@@@ MODULE @@@
---
id: de-05
title: Detection Engineering 5 · Ein Hunting-Playbook mit zehn Hypothesen
paths: cdsa
order: 32.5
difficulty: hard
icon: scope
tags: threat hunting, hypothesen
summary: Zehn praxiserprobte Hunting-Hypothesen mit Datenquellen, Suchlogik und Bewertung – als Startpunkt für ein eigenes, wiederholbares Hunting-Programm.
---

## Einfach erklärt

Threat Hunting ohne Plan ist wie Pilze suchen, indem man ziellos durch den Wald läuft. Mit Plan weiß man: Steinpilze wachsen unter Fichten, nach Regen. Eine **Hunting-Hypothese** ist genau dieses Wissen: „Wenn ein Angreifer X tut, finden wir Spur Y in Datenquelle Z.“

## Aufbau einer Hypothese

| Feld | Beispiel |
|---|---|
| Hypothese | Angreifer nutzen geplante Aufgaben zur Persistenz |
| ATT&CK | T1053.005 |
| Datenquellen | Security 4698, Sysmon 1, TaskScheduler-Log |
| Suchlogik | neue Aufgaben außerhalb von Softwareverteilungszeiten, Programme in Benutzerprofilen/Temp |
| Erwartetes Rauschen | Updater, Monitoring-Agenten |
| Ergebnis | nichts gefunden / Befund / neue Erkennungsregel |

## Zehn Hypothesen für den Start

1. **Persistenz über geplante Aufgaben** mit Programmen in `AppData`/`Temp`.
2. **Neue Dienste** mit zufällig wirkenden Namen oder Pfaden außerhalb von `Program Files`.
3. **Office startet Skript-Interpreter** (Word → PowerShell/cmd/mshta).
4. **Ungewöhnliche Prozesse mit Netzwerkverbindungen** ins Internet (z. B. `rundll32`, `regsvr32`).
5. **Seltene Programme** (Stack Counting: Binärdateien auf weniger als drei Systemen).
6. **Kodierte PowerShell** (`-enc`) außerhalb bekannter Verwaltungswerkzeuge.
7. **Workstation-zu-Workstation-Anmeldungen** (Logon Type 3/10 zwischen Clients).
8. **Neue Posteingangsregeln** mit Weiterleitung nach extern.
9. **Beaconing** zu seltenen Domains (regelmäßige Intervalle, wenig Varianz).
10. **Anmeldungen privilegierter Konten** auf Systemen außerhalb ihrer Ebene (Tiering-Verstoß).

> [!MERKE] Jede Jagd endet mit einem Ergebnis
> Auch „nichts gefunden“ ist wertvoll – wenn dokumentiert ist, was gesucht wurde. Und jede erfolgreiche Suche sollte zu einer automatischen Erkennungsregel werden.

## Ablauf eines Hunts

1. Hypothese wählen (z. B. anhand aktueller Threat Intelligence).
2. Datenverfügbarkeit prüfen (haben wir die Logs, über welchen Zeitraum?).
3. Suchen, eingrenzen, Rauschen per Allowlist entfernen.
4. Treffer untersuchen.
5. Ergebnis dokumentieren, ggf. Vorfall eröffnen, Regel bauen.

## Tiefer eingetaucht

Ein Hunting-Programm braucht Rhythmus (z. B. jede Woche eine Hypothese), Priorisierung (Techniken, die relevante Angreifer nutzen und die bisher **nicht** erkannt werden) und Messung (Anzahl Hunts, daraus entstandene Regeln, gefundene Vorfälle, entdeckte Logging-Lücken). Viele Hunts decken übrigens weniger Angreifer als **Hygieneprobleme** auf – vergessene Dienste, unsichere Skripte, Schatten-IT. Auch das macht die Umgebung sicherer.

## Quiz

? Was ist eine Hunting-Hypothese?
+ eine überprüfbare Annahme, wie sich eine Angreiferaktivität in Daten zeigt
- ein zufälliger Suchbegriff
- ein Alarm des SIEM
- eine Firewall-Regel
! Sie gibt der Suche Richtung.

? Welche Datenquelle passt zur Hypothese „Persistenz über geplante Aufgaben“?
+ Event 4698
+ Sysmon Event 1
- DHCP-Leases
- Druckerprotokolle
! Ergänzt um das TaskScheduler-Log.

?tf Ein Hunt, der nichts findet, ist wertlos.
= falsch
! Dokumentiert zeigt er, was geprüft wurde – und deckt oft Logging-Lücken auf.

? Was sollte aus einem erfolgreichen Hunt entstehen?
+ eine automatische Erkennungsregel
- nichts
- ein neues Passwort für alle
- ein Firewall-Neustart
! So wird einmalige Suche zu dauerhaftem Schutz.

? Welche Technik findet seltene Programme in der Umgebung?
= Stack Counting
! Häufigkeiten über viele Systeme zählen.

? Was decken Hunts häufig zusätzlich auf?
+ Hygieneprobleme wie vergessene Dienste und Schatten-IT
- Stromausfälle
- Wetterdaten
- Hardware-Garantien
! Auch das verbessert die Sicherheit.

@@@ MODULE @@@
---
id: db-01
title: Datenbanksicherheit · Zugriff, Verschlüsselung, Auditing
paths: specialist, cwes, cdsa
order: 14.6
difficulty: medium
icon: cylinder.fill
tags: datenbanken, härtung
summary: Wie man Datenbanken absichert – Netzwerkzugriff, Konten und Rollen, Verschlüsselung im Ruhezustand und unterwegs, Auditing, Backups und typische Fehlkonfigurationen.
---

## Einfach erklärt

Datenbanken sind die Tresore der IT: Kundendaten, Bestellungen, Passwort-Hashes. Ein Tresor braucht eine dicke Tür (Netzwerkzugang), Schlüssel nur für Befugte (Konten und Rollen), ein Protokoll, wer ihn geöffnet hat (Auditing), und eine Kopie an einem anderen Ort (Backup).

## Schutzschichten

| Schicht | Maßnahme |
|---|---|
| Netzwerk | nicht öffentlich erreichbar; nur Anwendungsserver dürfen verbinden |
| Authentifizierung | starke Passwörter oder Zertifikate/Identitäten; keine Standardkonten |
| Autorisierung | eigene Konten pro Anwendung mit minimalen Rechten; Admin-Konten getrennt |
| Verschlüsselung unterwegs | TLS zwischen Anwendung und Datenbank |
| Verschlüsselung im Ruhezustand | TDE oder Datenträgerverschlüsselung; Schlüssel getrennt |
| Feldverschlüsselung | für besonders sensible Felder (z. B. Gesundheitsdaten) |
| Auditing | Anmeldungen, Rechteänderungen, Zugriffe auf sensible Tabellen |
| Backup | verschlüsselt, getrennt, getestet |
| Updates | Datenbanksoftware im Patch-Management |

> [!WARNUNG] Offene Datenbanken im Internet
> Immer wieder werden Datenbanken (z. B. Elasticsearch, MongoDB, Redis) ohne Passwort aus dem Internet erreichbar gefunden – und von automatisierten Angreifern geleert oder erpresst. Niemals direkt exponieren.

## Typische Fehlkonfigurationen

- Anwendung verbindet sich als Datenbank-Admin (`root`, `sa`, `postgres`).
- Gefährliche Funktionen aktiv (Dateizugriff, Betriebssystembefehle, externe Verbindungen).
- Testdatenbanken mit Echtdaten.
- Backups ungeschützt auf Fileservern.
- Fehlende Protokollierung von Admin-Aktivitäten.

## Tiefer eingetaucht

Bei SQL-Injection entscheidet die Datenbankkonfiguration über den Schaden: Mit minimalen Rechten liest ein Angreifer im schlimmsten Fall die Tabellen der Anwendung; mit Admin-Rechten und aktivierten Systemfunktionen kann er Dateien schreiben oder Befehle auf dem Server ausführen. **Row-Level Security** (Zeilenebene) kann zusätzlich Mandanten trennen. Für Analysen und Tests gilt: Produktionsdaten pseudonymisieren oder synthetische Daten verwenden.

## Quiz

? Wer sollte sich mit einer Produktionsdatenbank verbinden dürfen?
+ nur die Anwendungsserver und berechtigte Admins über gesicherte Wege
- jeder im Internet
- alle Arbeitsplätze
- das Gastnetz
! Datenbanken gehören nie direkt ins Internet.

? Mit welchem Konto sollte eine Anwendung sich verbinden?
+ einem eigenen Konto mit minimalen Rechten
- dem Datenbank-Admin-Konto
- einem gemeinsamen Konto aller Anwendungen
- ohne Passwort
! Begrenzt den Schaden einer SQL-Injection.

? Wofür steht TDE?
= Transparent Data Encryption
! Verschlüsselung der Datenbankdateien im Ruhezustand.

?tf Testdatenbanken sollten Echtdaten ungeschützt enthalten.
= falsch
! Pseudonymisierte oder synthetische Daten verwenden.

? Welche Datenbanken werden häufig ohne Passwort offen im Internet gefunden?
+ Elasticsearch
+ MongoDB
+ Redis
- keine
! Automatisierte Angreifer finden sie schnell.

? Was regelt Row-Level Security?
+ Zugriff auf einzelne Zeilen, z. B. pro Mandant
- die Zeilenlänge
- die Schriftart
- die Backup-Häufigkeit
! Zusätzliche Trennung innerhalb einer Tabelle.

@@@ MODULE @@@
---
id: gt-07
title: Grundlagen-Training 7 · E-Mail-Header Schritt für Schritt lesen
paths: cdsa, cjca, grundlagen
order: 15.3
difficulty: medium
icon: envelope.open.badge.clock
tags: e-mail, header, phishing
summary: Received-Kette, Return-Path, Message-ID, Authentication-Results und typische Fälschungsmerkmale – Header-Analyse als Routine im SOC.
---

## Einfach erklärt

Der E-Mail-Header ist der Briefumschlag mit allen Poststempeln: Jede Station, die die Mail weitergereicht hat, schreibt einen Stempel dazu. Die Stempel stehen **von unten nach oben** – der unterste ist der älteste, der oberste stammt vom eigenen Mailserver. Was ein Absender selbst eintragen kann, ist fälschbar; was die Server stempeln, ist vertrauenswürdiger.

## Die wichtigsten Felder

| Feld | Bedeutung | Fälschbar? |
|---|---|---|
| From | sichtbarer Absender | ja |
| Reply-To | Antwortadresse | ja – oft abweichend bei Betrug |
| Return-Path | Umschlag-Absender (für Bounces, SPF) | ja, aber SPF prüft ihn |
| Received | Stempel jeder Station | untere Einträge können gefälscht sein, obere vom eigenen Server nicht |
| Message-ID | eindeutige Kennung | ja, aber Format verrät manchmal das System |
| Authentication-Results | Ergebnis von SPF, DKIM, DMARC beim Empfang | vom eigenen Server gesetzt – vertrauenswürdig |
| X-Mailer / User-Agent | verwendetes Programm | ja |

## Analyse in fünf Schritten

1. **Authentication-Results** lesen: `spf=pass`, `dkim=pass`, `dmarc=pass`? Welche Domains wurden geprüft?
2. **From vs. Return-Path vs. Reply-To** vergleichen: Passen die Domains zusammen?
3. **Received-Kette** von unten nach oben: Woher kam die Mail wirklich (erste externe IP)?
4. **Domain-Alter und Reputation** der beteiligten Domains und IPs prüfen.
5. **Links und Anhänge** sicher analysieren (nicht anklicken – Ziel prüfen, Sandbox).

> [!TIPP] Reply-To ist verräterisch
> Bei Betrugsmails ist From oft eine echte oder ähnliche Domain, Reply-To aber eine Freemail-Adresse. Antworten landen dann beim Betrüger.

## Tiefer eingetaucht

Ein `dmarc=pass` bedeutet nur, dass die Mail wirklich von der angegebenen Domain stammt – nicht, dass die Domain vertrauenswürdig ist. Angreifer registrieren eigene, ähnliche Domains mit korrekt gesetztem SPF/DKIM/DMARC. Umgekehrt kann eine legitime Mail an Weiterleitungen scheitern (dafür gibt es ARC). Header-Analyse ist deshalb immer **Indizienarbeit**: mehrere Merkmale zusammen ergeben ein Bild. Werkzeuge wie Header-Analyzer der Mailanbieter helfen, die Received-Kette übersichtlich darzustellen.

## Quiz

? In welcher Reihenfolge liest man die Received-Kette?
+ von unten nach oben (älteste zuerst)
- von oben nach unten
- alphabetisch
- zufällig
! Jede Station fügt ihren Stempel oben an.

? Welches Feld wird vom eigenen Mailserver gesetzt und ist daher vertrauenswürdig?
= Authentication-Results
! Es enthält die Ergebnisse von SPF, DKIM und DMARC.

? Was ist ein typisches Betrugsmerkmal?
+ Reply-To zeigt auf eine andere, z. B. Freemail-Adresse
- eine Message-ID ist vorhanden
- die Mail hat einen Betreff
- die Mail ist in HTML
! Antworten landen so beim Betrüger.

?tf dmarc=pass beweist, dass die Absenderdomain vertrauenswürdig ist.
= falsch
! Es beweist nur, dass die Mail von der angegebenen Domain stammt – auch Betrüger haben eigene Domains.

? Welches Feld prüft SPF?
= Return-Path
! Der Umschlag-Absender bzw. die MAIL-FROM-Domain.

@@@ MODULE @@@
---
id: gt-08
title: Grundlagen-Training 8 · Statistik für Analysten
paths: cdsa, grundlagen
order: 32.6
difficulty: medium
icon: chart.bar.fill
tags: statistik, analyse
summary: Mittelwert, Median, Perzentile, Standardabweichung, Basisrate und Korrelation – das statistische Handwerkszeug, um Logs zu verstehen und Fehlalarme zu vermeiden.
---

## Einfach erklärt

Analysten arbeiten mit Zahlen: Wie viele Anmeldungen sind normal? Ist dieser Upload ungewöhnlich groß? Ein paar statistische Grundbegriffe helfen enorm, richtige Schlüsse zu ziehen – und nicht auf Zahlen hereinzufallen, die beeindruckend aussehen, aber nichts bedeuten.

## Lagemaße

| Maß | Bedeutung | Vorsicht |
|---|---|---|
| Mittelwert | Summe / Anzahl | anfällig für Ausreißer |
| Median | mittlerer Wert der sortierten Liste | robust gegen Ausreißer |
| Perzentil (p95, p99) | Wert, unter dem 95 % bzw. 99 % liegen | gut für Schwellen |

Beispiel: Uploads pro Tag eines Nutzers 10, 12, 11, 9, 2000 MB. Mittelwert ≈ 408 MB, Median 11 MB. Der Median beschreibt den Normalfall besser.

## Streuung

**Standardabweichung** misst, wie stark Werte um den Mittelwert schwanken. Eine einfache Ausreißerregel: Werte über Mittelwert + 3 × Standardabweichung. Für schiefe Verteilungen (typisch bei Datenmengen) sind Perzentile oder der **Median der absoluten Abweichungen** robuster.

## Basisrate – die wichtigste Falle

Eine Regel erkennt Angriffe mit 99 % Trefferquote und hat nur 1 % Fehlalarme. Klingt gut? Wenn unter 1.000.000 Ereignissen nur 10 echte Angriffe sind, erzeugt die Regel rund **10.000 Fehlalarme** – und nur etwa 10 echte Treffer. Je seltener das Gesuchte, desto mehr dominieren Fehlalarme.

> [!MERKE] Seltene Ereignisse brauchen sehr präzise Regeln
> Die Basisrate entscheidet, ob eine Regel im SOC brauchbar ist. Darum kombiniert man Signale (Risk-based Alerting) und nutzt Kontext.

## Korrelation ist nicht Kausalität

Zwei Werte steigen gleichzeitig – heißt nicht, dass einer den anderen verursacht. Mehr Alarme an Montagen liegen vielleicht nur an mehr Aktivität nach dem Wochenende.

## Tiefer eingetaucht

Zeitreihen haben Muster: Tageszyklen, Wochenzyklen, Saisonalität. Gute Baselines vergleichen deshalb „Montag 9 Uhr“ mit früheren Montagen um 9 Uhr, nicht mit dem Gesamtdurchschnitt. Visualisierung (Histogramme, Box-Plots, Zeitreihen) zeigt oft auf einen Blick, was Tabellen verbergen. Und: Kleine Stichproben erzeugen zufällige Ausreißer – vor Schlüssen auf ausreichend Daten achten.

## Quiz

? Welches Lagemaß ist robust gegen Ausreißer?
= Median
! Der Mittelwert wird von einzelnen extremen Werten stark verzerrt.

? Was ist der Median von 10, 12, 11, 9, 2000?
= 11
! Sortiert: 9, 10, 11, 12, 2000 – der mittlere Wert ist 11.

? Was beschreibt das 95. Perzentil?
+ den Wert, unter dem 95 % der Messwerte liegen
- den Durchschnitt aller Werte
- den höchsten Wert
- die Anzahl der Werte
! Gut geeignet für Schwellenwerte.

?tf Bei sehr seltenen Angriffen erzeugt selbst eine Regel mit 1 % Fehlalarmrate sehr viele Fehlalarme.
= wahr
! Das ist das Basisraten-Problem.

? Was bedeutet „Korrelation ist nicht Kausalität“?
+ gemeinsames Auftreten beweist keine Ursache-Wirkung-Beziehung
- Korrelation ist verboten
- Kausalität ist immer falsch
- Statistik ist nutzlos
! Andere Faktoren können beide Werte beeinflussen.

@@@ MODULE @@@
---
id: ir-09
title: Incident Response 9 · Container- und Kubernetes-Forensik
paths: cdsa, specialist
order: 34.9
difficulty: hard
icon: shippingbox.and.arrow.backward.fill
tags: forensik, container, kubernetes
summary: Wie man flüchtige Container untersucht – Beweise sichern bevor sie verschwinden, Image-Diff, Laufzeit-Telemetrie, Audit-Logs und Node-Forensik.
---

## Einfach erklärt

Container sind wie Zelte auf einem Festival: schnell aufgebaut, schnell wieder weg. Wenn in einem Zelt etwas passiert ist, muss man die Spuren sichern, **bevor** es abgebaut wird – denn Kubernetes ersetzt kranke Container automatisch durch frische. Ohne Vorbereitung ist der Tatort nach Minuten verschwunden.

## Herausforderungen

| Herausforderung | Konsequenz |
|---|---|
| Kurzlebigkeit | Container werden neu gestartet, Beweise gehen verloren |
| Unveränderliche Images | Änderungen liegen nur in der beschreibbaren Schicht |
| Viele Schichten | Container, Pod, Node, Cluster, Cloud – Spuren überall verteilt |
| Wenig Werkzeuge im Container | minimale Images ohne Shell |

## Beweise sichern

1. **Nicht sofort löschen**: Pod isolieren (NetworkPolicy, Label entfernen, damit er aus dem Service fällt), Node ggf. absperren (cordon).
2. **Container-Dateisystem sichern**: `docker export` / `crictl`-basierte Sicherung oder Checkpoint (CRIU), Diff gegen das Image (`docker diff`).
3. **Logs sichern**: Container-Logs, Kubernetes-Audit-Logs, Events.
4. **Speicher** des Nodes bzw. Prozesses, falls möglich.
5. **Image** mit Digest festhalten, Registry-Historie prüfen.

> [!MERKE] Diff ist Gold
> Was sich im Container gegenüber dem Image verändert hat – neue Dateien, geänderte Binärdateien, Skripte in /tmp –, ist oft der direkteste Hinweis auf den Angriff.

## Datenquellen

- **Kubernetes-Audit-Log**: Wer hat welche API-Aufrufe gemacht (exec in Pods, Secrets gelesen, neue Rollen)?
- **Laufzeit-Telemetrie** (z. B. Falco, EDR für Container): Shells in Containern, ungewöhnliche Prozesse, Netzwerkverbindungen.
- **Node-Logs**: kubelet, Container-Runtime, Systemlogs.
- **Cloud-Logs** bei verwalteten Clustern.

## Tiefer eingetaucht

Typische Angriffsketten in Kubernetes: verwundbare Anwendung im Pod → Service-Account-Token → API-Zugriff → Secrets lesen oder privilegierten Pod starten → Node-Übernahme → Cloud-Credentials des Nodes. Die Untersuchung folgt dieser Kette rückwärts. Vorbereitung entscheidet: Audit-Logging aktiv und exportiert, Laufzeit-Erkennung installiert, ein Playbook für „Pod isolieren und sichern“ – geübt, bevor es gebraucht wird.

## Quiz

? Warum ist Container-Forensik zeitkritisch?
+ Container werden schnell ersetzt und Beweise gehen verloren
- weil Container sehr groß sind
- weil Container verschlüsselt sind
- weil es keine Logs gibt
! Spuren vor dem Neustart sichern.

? Was zeigt docker diff?
+ Änderungen im Container-Dateisystem gegenüber dem Image
- die Netzwerkbandbreite
- die Benutzerpasswörter
- die CPU-Temperatur
! Oft der direkteste Hinweis auf den Angriff.

? Welche Logquelle zeigt, wer in Kubernetes Secrets gelesen oder exec ausgeführt hat?
= Kubernetes-Audit-Log
= Audit-Log
! Muss aktiviert und exportiert sein.

?tf Einen kompromittierten Pod sollte man sofort löschen, bevor man Beweise sichert.
= falsch
! Erst isolieren und sichern, dann bereinigen.

? Wie entfernt man einen Pod aus dem Verkehr, ohne ihn zu löschen?
+ Label entfernen bzw. NetworkPolicy setzen
- den Cluster neu installieren
- das Image löschen
- alle Nodes ausschalten
! So bleibt der Zustand für die Untersuchung erhalten.

@@@ MODULE @@@
---
id: sd-02
title: Secure Design · Ein Architektur-Review durchführen
paths: specialist, cwee
order: 46
difficulty: medium
icon: square.and.pencil.circle.fill
tags: architektur, review, design
summary: Wie man eine geplante Lösung systematisch auf Sicherheit prüft – Fragenkatalog, Vertrauensgrenzen, Identitäten, Daten, Betrieb und ein Ergebnis, mit dem Teams arbeiten können.
---

## Einfach erklärt

Bevor ein Haus gebaut wird, prüft ein Statiker die Pläne. Ein **Architektur-Review** ist der Statiker für IT-Lösungen: Er schaut auf die Pläne, bevor teuer gebaut wird, und fragt: Wo sind die Schwachstellen? Was passiert, wenn ein Teil ausfällt oder angegriffen wird?

## Der Fragenkatalog

| Bereich | Fragen |
|---|---|
| Kontext | Welche Daten, welcher Schutzbedarf, welche Nutzer, welche Regulierung? |
| Vertrauensgrenzen | Wo wechseln Daten zwischen Zonen, Mandanten, Organisationen? |
| Identität | Wie melden sich Nutzer und Dienste an? MFA? Dienstidentitäten statt Schlüssel? |
| Autorisierung | Wo wird geprüft, ob ein Zugriff erlaubt ist – zentral oder verstreut? |
| Daten | Verschlüsselung unterwegs und im Ruhezustand? Schlüsselverwaltung? Löschung? |
| Schnittstellen | Welche APIs, wer darf sie aufrufen, Rate Limits? |
| Abhängigkeiten | Drittanbieter, Bibliotheken, SaaS – was passiert bei deren Kompromittierung? |
| Betrieb | Logging, Monitoring, Patchen, Backups, Notfall |
| Ausfall | Was passiert bei Ausfall einzelner Komponenten? |
| Missbrauch | Wie könnte die Funktion missbraucht werden? |

## Ablauf

1. **Unterlagen** anfordern: Architekturdiagramm, Datenflüsse, Anforderungen.
2. **Workshop** mit Architekten und Entwicklern (90 Minuten reichen oft).
3. **Threat Modeling** entlang des Datenflussdiagramms.
4. **Ergebnisbericht**: Risiken mit Priorität, konkrete Empfehlungen, offene Fragen.
5. **Nachverfolgung**: Empfehlungen als Tickets, Re-Review bei größeren Änderungen.

> [!TIPP] Partner, nicht Prüfer
> Ein Review wirkt am besten, wenn das Sicherheitsteam als Partner auftritt, der hilft, gute Lösungen zu finden – nicht als Behörde, die Genehmigungen verweigert.

## Tiefer eingetaucht

Wiederkehrende Funde sind ein Signal für fehlende Standards: Wenn jedes Team das Logging neu erfindet, braucht es eine Referenzarchitektur oder eine Bibliothek. Reife Organisationen bauen deshalb **Sicherheitsmuster** (z. B. „So bindet man eine neue Anwendung an SSO an“, „So speichert man Secrets“) und messen, welcher Anteil neuer Projekte sie nutzt. Reviews werden dadurch schneller und konzentrieren sich auf das wirklich Neue.

## Quiz

? Wann ist ein Architektur-Review am wirksamsten?
+ bevor teuer gebaut wird
- nach dem Go-Live
- nach einem Vorfall
- nie
! Änderungen am Entwurf sind am billigsten.

? Was gehört in den Fragenkatalog eines Reviews?
+ Vertrauensgrenzen
+ Identität und Autorisierung
+ Betrieb und Logging
- Lieblingsfarbe des Teams
! Plus Daten, Schnittstellen, Abhängigkeiten und Ausfallverhalten.

?tf Wiederkehrende Review-Funde deuten auf fehlende Standards oder Referenzarchitekturen hin.
= wahr
! Sicherheitsmuster beschleunigen künftige Reviews.

? Welche Methode wird im Review entlang des Datenflussdiagramms eingesetzt?
= Threat Modeling
= Bedrohungsmodellierung
! Zum Beispiel mit STRIDE.

? Wie sollte das Sicherheitsteam im Review auftreten?
+ als Partner, der hilft, gute Lösungen zu finden
- als Behörde, die alles verbietet
- gar nicht
- anonym
! Partnerschaft erhöht die Akzeptanz der Empfehlungen.
