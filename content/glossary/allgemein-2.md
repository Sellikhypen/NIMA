# NIMA-Lexikon: Windows, Active Directory, Linux, Blue Team, Forensik

## Registry
aka: Windows-Registry, Registrierungsdatenbank
kat: Windows
kurz: Hierarchische Konfigurationsdatenbank von Windows.
Enthält Einstellungen, Dienste, Autostarts und viele forensische Spuren; gespeichert in Hive-Dateien.
siehe: Hive

## Hive
aka: Registry-Hive
kat: Windows
kurz: Datei, in der ein Teil der Registry gespeichert ist, z. B. SYSTEM, SOFTWARE, SAM, NTUSER.DAT.

## NTUSER.DAT
kat: Windows
kurz: Registry-Hive mit den Einstellungen eines Benutzers im Profilverzeichnis.
Forensisch wertvoll: zuletzt geöffnete Dateien, UserAssist, Run-Keys des Nutzers.

## Run-Key
aka: Run-Schlüssel, Autostart-Schlüssel
kat: Windows
kurz: Registry-Schlüssel, dessen Einträge bei der Anmeldung automatisch starten.
Klassischer Persistenzort für Malware.

## UAC
aka: User Account Control, Benutzerkontensteuerung
kat: Windows
kurz: Windows-Mechanismus, der Admin-Aktionen bestätigen lässt.
Laut Microsoft keine Sicherheitsgrenze, aber wichtige Hürde.

## LSA-Schutz
aka: RunAsPPL, LSA Protection
kat: Windows
kurz: Betreibt LSASS als geschützten Prozess, um das Auslesen von Anmeldedaten zu erschweren.
siehe: LSASS, Credential Guard

## Windows Defender
aka: Microsoft Defender Antivirus
kat: Windows
kurz: In Windows integrierter Malware-Schutz mit Cloud-Schutz und Tamper Protection.

## Tamper Protection
kat: Windows
kurz: Schutz, der verhindert, dass Malware oder Nutzer Defender-Einstellungen abschalten.

## AMSI
aka: Antimalware Scan Interface
kat: Windows
kurz: Schnittstelle, über die Skriptinhalte (PowerShell, VBA, JS) vor der Ausführung gescannt werden.

## AppLocker
kat: Windows
kurz: Windows-Funktion zur Steuerung, welche Programme und Skripte ausgeführt werden dürfen.
siehe: WDAC

## WDAC
aka: Windows Defender Application Control, App Control for Business
kat: Windows
kurz: Kernel-basierte Anwendungssteuerung – robuster als AppLocker.

## BitLocker
kat: Windows
kurz: Festplattenverschlüsselung von Windows, idealerweise mit TPM und PIN.
siehe: TPM

## TPM
aka: Trusted Platform Module
kat: Grundlagen
kurz: Sicherheitschip für Schlüssel und Messung des Startvorgangs.
Gibt z. B. BitLocker-Schlüssel nur bei unverändertem Boot frei.

## Script Block Logging
kat: Windows
kurz: PowerShell-Protokollierung ausgeführter Skriptblöcke (Event 4104), auch nach Entschleierung.

## Constrained Language Mode
kat: Windows
kurz: Eingeschränkter PowerShell-Modus, der gefährliche Sprachfunktionen sperrt.

## JEA
aka: Just Enough Administration
kat: Windows
kurz: PowerShell-Remoting-Endpunkte, über die Nutzer nur definierte Befehle ausführen dürfen.

## WMI
aka: Windows Management Instrumentation
kat: Windows
kurz: Verwaltungsschnittstelle für Windows, auch remote nutzbar.
Wird für Verwaltung und von Angreifern für Ausführung und Persistenz genutzt.

## Geplante Aufgabe
aka: Scheduled Task, Aufgabenplanung
kat: Windows
kurz: Zeit- oder ereignisgesteuert gestartete Aufgabe; beliebter Persistenzmechanismus (Event 4698).

## Windows-Dienst
aka: Service
kat: Windows
kurz: Hintergrundprogramm, das unter einer festgelegten Identität läuft.
Unsichere Dienstkonfigurationen sind ein häufiger Weg zur Rechteausweitung.

## Unquoted Service Path
kat: Windows
kurz: Dienstpfad mit Leerzeichen ohne Anführungszeichen; kann zum Start fremder Programme führen.

## SeImpersonatePrivilege
kat: Windows
kurz: Privileg zum Annehmen fremder Identitäten; bei Dienstkonten ein bekannter Weg zu SYSTEM-Rechten.

## SYSTEM
aka: LocalSystem, NT AUTHORITY\SYSTEM
kat: Windows
kurz: Höchstprivilegiertes lokales Konto unter Windows.

## Event Log
aka: Ereignisprotokoll, EVTX
kat: Windows
kurz: Windows-Protokolle für System-, Sicherheits- und Anwendungsereignisse.

## Logon Type
aka: Anmeldetyp
kat: Windows
kurz: Art einer Windows-Anmeldung, z. B. 2 interaktiv, 3 Netzwerk, 10 RDP.

## Windows Event Forwarding
aka: WEF, WEC
kat: Windows
kurz: Eingebauter Mechanismus zur zentralen Sammlung von Windows-Ereignissen.

## Prefetch
kat: Forensik
kurz: Windows-Artefakt mit Hinweisen auf ausgeführte Programme und Ausführungszeiten.

## Amcache
kat: Forensik
kurz: Windows-Artefakt mit Informationen zu ausgeführten Programmen inklusive SHA1-Hash.

## Shimcache
aka: AppCompatCache
kat: Forensik
kurz: Kompatibilitäts-Cache in der Registry; zeigt Programme, die Windows gesehen hat.

## ShellBags
kat: Forensik
kurz: Registry-Spuren angesehener Ordner – auch auf entfernten Laufwerken.

## LNK-Datei
aka: Verknüpfung
kat: Forensik
kurz: Windows-Verknüpfung mit Metadaten zu Zielpfad, Laufwerk und Zeitstempeln.

## Jump List
kat: Forensik
kurz: Liste zuletzt verwendeter Dateien pro Anwendung; forensisch auswertbar.

## SRUM
aka: System Resource Usage Monitor
kat: Forensik
kurz: Windows-Datenbank mit Ressourcen- und Netzwerknutzung pro Programm.

## $MFT
aka: Master File Table, MFT
kat: Forensik
kurz: Zentrale NTFS-Tabelle mit Einträgen und Zeitstempeln aller Dateien.

## Timestomping
kat: Forensik
kurz: Manipulation von Dateizeitstempeln zur Verschleierung.

## Volatility
kat: Forensik
kurz: Framework zur Analyse von Arbeitsspeicherabbildern.

## Speicherabbild
aka: Memory Dump, RAM-Abbild
kat: Forensik
kurz: Kopie des Arbeitsspeichers zur forensischen Analyse laufender Prozesse und Verbindungen.

## Write Blocker
kat: Forensik
kurz: Gerät oder Software, das Schreibzugriffe auf Beweisdatenträger verhindert.

## Forensisches Abbild
aka: Image, Disk Image
kat: Forensik
kurz: Bitgenaue Kopie eines Datenträgers, deren Echtheit per Hash belegt wird.

## KAPE
kat: Forensik
kurz: Werkzeug zur schnellen, gezielten Sammlung und Verarbeitung forensischer Artefakte.

## Velociraptor
kat: Forensik
kurz: Endpoint-Werkzeug für Live-Response, Artefaktsammlung und Hunting über viele Systeme.

## Plaso
aka: log2timeline
kat: Forensik
kurz: Framework zur Erstellung von Super-Timelines aus vielen Artefaktquellen.

## Super-Timeline
kat: Forensik
kurz: Zusammengeführte Zeitleiste aus vielen Quellen zur Rekonstruktion eines Vorfalls.

## Triage (Forensik)
aka: forensische Triage
kat: Forensik
kurz: Schnelle Sammlung der wichtigsten Artefakte statt vollständiger Abbilder.

## Domäne
aka: Domain (AD)
kat: Active Directory
kurz: Verwaltungseinheit in Active Directory mit gemeinsamer Datenbank und Richtlinien.

## Forest
aka: Gesamtstruktur
kat: Active Directory
kurz: Oberste AD-Ebene und eigentliche Sicherheitsgrenze.

## Trust
aka: Vertrauensstellung
kat: Active Directory
kurz: Beziehung, über die eine Domäne Anmeldungen einer anderen akzeptiert.

## SID
aka: Security Identifier
kat: Active Directory
kurz: Eindeutige Kennung eines Sicherheitsprinzipals unter Windows.

## RID
aka: Relative Identifier
kat: Active Directory
kurz: Letzter Teil einer SID; z. B. 500 für den eingebauten Administrator.

## SID-Filterung
aka: SID Filtering
kat: Active Directory
kurz: Schutzmechanismus an Trusts, der fremde SIDs in Tickets herausfiltert.

## Global Catalog
kat: Active Directory
kurz: Teilkopie aller Objekte eines Forests für schnelle forestweite Suchen (Port 3268/3269).

## FSMO
aka: FSMO-Rollen, Betriebsmasterrollen
kat: Active Directory
kurz: Fünf Sonderrollen, die jeweils nur ein Domain Controller innehat.

## SYSVOL
kat: Active Directory
kurz: Freigabe auf Domain Controllern mit Gruppenrichtlinien und Skripten; für alle Domänennutzer lesbar.

## GPP-Passwort
aka: cpassword
kat: Active Directory
kurz: Alte Group-Policy-Preferences-Passwörter in SYSVOL, deren Schlüssel öffentlich ist.

## krbtgt
kat: Active Directory
kurz: Konto, dessen Schlüssel alle Kerberos-TGTs signiert.
Nach Kompromittierung zweimal zurücksetzen.
siehe: Golden Ticket

## PAC
aka: Privilege Attribute Certificate
kat: Active Directory
kurz: Teil eines Kerberos-Tickets mit Gruppenmitgliedschaften des Nutzers.

## Silver Ticket
kat: Active Directory
kurz: Gefälschtes Service-Ticket, erstellt mit dem Schlüssel eines Dienstkontos.

## Unconstrained Delegation
aka: uneingeschränkte Delegation
kat: Active Directory
kurz: Delegationsform, bei der ein Dienst TGTs von Nutzern erhält – sehr riskant.
siehe: Delegation

## Constrained Delegation
aka: eingeschränkte Delegation, KCD
kat: Active Directory
kurz: Delegation nur zu festgelegten Ziel-Diensten.

## RBCD
aka: Resource-Based Constrained Delegation
kat: Active Directory
kurz: Delegation, die am Zielobjekt festgelegt wird; wer das Attribut schreiben darf, kontrolliert sie.

## S4U2Self
kat: Active Directory
kurz: Kerberos-Erweiterung, mit der ein Dienst ein Ticket für einen Nutzer an sich selbst anfordert.

## S4U2Proxy
kat: Active Directory
kurz: Kerberos-Erweiterung, mit der ein Dienst im Namen eines Nutzers Tickets für andere Dienste anfordert.

## MachineAccountQuota
aka: ms-DS-MachineAccountQuota
kat: Active Directory
kurz: Anzahl der Computerkonten, die normale Nutzer anlegen dürfen (Standard 10) – besser 0.

## Protected Users
kat: Active Directory
kurz: Gruppe, deren Mitglieder verschärfte Schutzregeln erhalten (kein NTLM, keine Delegation, kein RC4).

## adminCount
kat: Active Directory
kurz: Attribut, das von AdminSDHolder geschützte Konten markiert.

## ACL
aka: Access Control List, Zugriffssteuerungsliste
kat: Grundbegriffe
kurz: Liste von Berechtigungseinträgen auf einem Objekt.

## ACE
aka: Access Control Entry
kat: Grundbegriffe
kurz: Einzelner Eintrag einer ACL, der einem Prinzipal Rechte erlaubt oder verweigert.

## DACL
kat: Active Directory
kurz: Discretionary ACL – regelt Zugriffsrechte auf ein Objekt.
siehe: SACL

## GenericAll
kat: Active Directory
kurz: AD-Recht mit vollständiger Kontrolle über ein Objekt.

## WriteDacl
kat: Active Directory
kurz: Recht, die Berechtigungen eines Objekts zu ändern – faktisch Vollkontrolle.

## DSRM
aka: Directory Services Restore Mode
kat: Active Directory
kurz: Wiederherstellungsmodus eines Domain Controllers mit eigenem lokalen Kennwort.

## Tombstone Lifetime
kat: Active Directory
kurz: Aufbewahrungsdauer gelöschter AD-Objekte; Backups älter als sie sind problematisch.

## Forest Recovery
kat: Active Directory
kurz: Vollständige Wiederherstellung eines AD-Forests nach Kompromittierung oder Totalausfall.

## Entra ID
aka: Azure AD, Azure Active Directory
kat: Cloud
kurz: Microsofts Cloud-Identitätsdienst für Microsoft 365 und viele Anwendungen.

## PIM
aka: Privileged Identity Management
kat: Cloud
kurz: Funktion, Admin-Rollen nur bei Bedarf und zeitlich begrenzt zu aktivieren.

## Break-Glass-Konto
aka: Notfallkonto
kat: Management
kurz: Besonders geschütztes Notfallkonto für den Fall, dass normale Admin-Zugänge ausfallen.

## Consent Phishing
aka: OAuth-Phishing
kat: Angriffsklassen
kurz: Täuschung von Nutzern, einer bösartigen App weitreichende Berechtigungen zu erteilen.

## Service Principal
kat: Cloud
kurz: Identität einer Anwendung oder eines Dienstes in Entra ID.

## Inode
kat: Grundlagen
kurz: Linux-Datenstruktur mit Metadaten einer Datei (Rechte, Besitzer, Zeitstempel).

## Dateirechte (Linux)
aka: chmod, rwx
kat: Grundlagen
kurz: Lese-, Schreib- und Ausführungsrechte für Besitzer, Gruppe und andere.

## SGID
kat: Grundlagen
kurz: Bit, durch das ein Programm mit den Rechten der Gruppe läuft; bei Ordnern erben neue Dateien die Gruppe.
siehe: SUID

## Sticky Bit
kat: Grundlagen
kurz: Ordner-Bit, durch das nur Eigentümer ihre Dateien löschen dürfen (z. B. /tmp).

## Capabilities (Linux)
aka: Linux Capabilities
kat: Grundlagen
kurz: Aufteilung von root-Rechten in einzelne Fähigkeiten, z. B. CAP_NET_ADMIN.

## sudo
kat: Grundlagen
kurz: Ausführen von Befehlen mit anderen Rechten gemäß Regeln in /etc/sudoers.

## sudoers
kat: Grundlagen
kurz: Konfigurationsdatei für sudo-Regeln; sollte nur mit visudo bearbeitet werden.

## systemd
kat: Grundlagen
kurz: Init-System und Dienstverwaltung moderner Linux-Systeme.

## journald
aka: systemd-journald, Journal
kat: Grundlagen
kurz: Zentrales Logsystem von systemd, auswertbar mit journalctl.

## rsyslog
kat: Grundlagen
kurz: Verbreiteter Syslog-Dienst zur lokalen Protokollierung und Weiterleitung.

## Cronjob
aka: cron, crontab
kat: Grundlagen
kurz: Zeitgesteuerte Aufgabe unter Linux; auch beliebter Persistenzort.

## SELinux
kat: Härtung
kurz: Mandatory-Access-Control-System für Linux mit Labels an Prozessen und Dateien.

## AppArmor
kat: Härtung
kurz: Pfadbasiertes Mandatory-Access-Control-System für Linux.

## LD_PRELOAD
aka: ld.so.preload
kat: Grundlagen
kurz: Mechanismus zum Vorladen von Bibliotheken; missbraucht für Userland-Rootkits.

## PAM
aka: Pluggable Authentication Modules
kat: Grundlagen
kurz: Modulares Authentifizierungssystem unter Linux; manipulierte Module sind ein Persistenztrick.

## Shell-History
aka: .bash_history
kat: Forensik
kurz: Verlauf eingegebener Befehle; wertvolle, aber leicht manipulierbare Spur.

## Alarm
aka: Alert
kat: Blue Team
kurz: Hinweis eines Sicherheitssystems auf ein möglicherweise sicherheitsrelevantes Ereignis.

## True Positive
kat: Blue Team
kurz: Korrekt ausgelöster Alarm bei tatsächlich bösartiger Aktivität.
siehe: False Positive

## Benign True Positive
kat: Blue Team
kurz: Regel feuert korrekt, die Aktivität ist aber erwartet und harmlos.

## Alert Fatigue
aka: Alarmmüdigkeit
kat: Blue Team
kurz: Abstumpfung durch zu viele unwichtige Alarme – echte Angriffe werden übersehen.

## Use Case (SIEM)
aka: Detection Use Case
kat: Blue Team
kurz: Beschreibung, was erkannt werden soll, mit Datenquelle, Logik und Reaktion.

## Korrelation
aka: Korrelationsregel
kat: Blue Team
kurz: Verknüpfung mehrerer Ereignisse zu einem aussagekräftigen Muster.

## Risk-based Alerting
aka: RBA
kat: Blue Team
kurz: Summierung schwacher Signale pro Entität zu einem Risikowert; Alarm erst über einer Schwelle.

## Baseline
aka: Normalzustand
kat: Blue Team
kurz: Beschreibung des normalen Verhaltens als Vergleichsgrundlage für Abweichungen.

## Stack Counting
kat: Blue Team
kurz: Zählen von Häufigkeiten über viele Systeme, um seltene Ausreißer zu finden.

## Pyramid of Pain
kat: Blue Team
kurz: Modell, das Indikatoren danach ordnet, wie schmerzhaft ihre Erkennung für Angreifer ist – von Hashes bis TTPs.

## Diamond Model
kat: Blue Team
kurz: Analysemodell mit den Ecken Angreifer, Fähigkeit, Infrastruktur und Opfer.

## TTP
aka: Tactics, Techniques and Procedures
kat: Blue Team
kurz: Vorgehensweise eines Angreifers auf Ebene von Taktiken, Techniken und Prozeduren.

## D3FEND
aka: MITRE D3FEND
kat: Blue Team
kurz: MITRE-Wissensbasis zu defensiven Techniken als Gegenstück zu ATT&CK.

## Atomic Test
aka: Atomic
kat: Blue Team
kurz: Kleiner, gezielter Test einer einzelnen ATT&CK-Technik zur Prüfung von Erkennungen.
siehe: Atomic Red Team

## Breach and Attack Simulation
aka: BAS
kat: Blue Team
kurz: Werkzeuge, die automatisch Angriffstechniken simulieren und Erkennungen prüfen.

## KQL
aka: Kusto Query Language
kat: Werkzeuge
kurz: Abfragesprache von Microsoft Sentinel, Defender und Azure Data Explorer.

## SPL
aka: Search Processing Language
kat: Werkzeuge
kurz: Abfragesprache von Splunk.

## EQL
aka: Event Query Language
kat: Werkzeuge
kurz: Abfragesprache von Elastic für Ereignissequenzen.

## Sentinel
aka: Microsoft Sentinel
kat: Werkzeuge
kurz: Cloud-SIEM von Microsoft.

## Splunk
kat: Werkzeuge
kurz: Verbreitete Plattform zur Suche und Analyse von Maschinendaten, oft als SIEM genutzt.

## Elastic Stack
aka: ELK, Elastic
kat: Werkzeuge
kurz: Elasticsearch, Logstash/Beats/Agent und Kibana – Basis vieler Logplattformen.

## OpenSearch
kat: Werkzeuge
kurz: Freier Fork von Elasticsearch und Kibana.

## MISP
kat: Werkzeuge
kurz: Open-Source-Plattform zum Sammeln und Teilen von Threat Intelligence.

## OpenCTI
kat: Werkzeuge
kurz: Open-Source-Plattform zur Verwaltung von Threat Intelligence.

## STIX
kat: Blue Team
kurz: Standardisiertes Format zur Beschreibung von Threat Intelligence.
siehe: TAXII

## TAXII
kat: Blue Team
kurz: Protokoll zum automatisierten Austausch von STIX-Daten.

## Retro-Hunting
kat: Blue Team
kurz: Rückwirkende Suche nach neuen Indikatoren in historischen Logs.

## Sighting
kat: Blue Team
kurz: Rückmeldung, dass ein Indikator in der eigenen Umgebung gesehen wurde.

## Beacon-Intervall
aka: Sleep, Callback-Intervall
kat: Blue Team
kurz: Zeitabstand, in dem Malware Kontakt zum C2-Server aufnimmt.
siehe: Beaconing, Jitter

## JA3
kat: Blue Team
kurz: Fingerabdruck eines TLS-Clients anhand des ClientHello; Nachfolger ist JA4.

## RITA
kat: Werkzeuge
kurz: Open-Source-Werkzeug zur statistischen Erkennung von Beaconing in Zeek-Logs.

## Arkime
aka: Moloch
kat: Werkzeuge
kurz: System zur Speicherung und Suche vollständiger Netzwerkmitschnitte.

## EDR-Isolation
aka: Netzwerkisolation, Host-Isolation
kat: Blue Team
kurz: Trennung eines Endgeräts vom Netz per EDR, wobei die Verbindung zur Verwaltung bleibt.

## Eindämmung
aka: Containment
kat: Blue Team
kurz: IR-Phase, in der die Ausbreitung eines Vorfalls gestoppt wird.

## Beseitigung
aka: Eradication
kat: Blue Team
kurz: IR-Phase, in der Ursache, Malware und Persistenz entfernt werden.

## Out-of-Band-Kommunikation
aka: OOB-Kommunikation
kat: Blue Team
kurz: Kommunikation im Vorfall über Kanäle außerhalb der möglicherweise kompromittierten Infrastruktur.

## Krisenstab
kat: Management
kurz: Gremium, das bei schweren Vorfällen Entscheidungen trifft und koordiniert.

## Meldepflicht
kat: Recht
kurz: Gesetzliche Pflicht, bestimmte Vorfälle Behörden oder Betroffenen zu melden (z. B. DSGVO 72 h, NIS2 24 h).

## Infostealer
kat: Bedrohungen
kurz: Malware, die Zugangsdaten, Cookies und Wallets stiehlt und an Angreifer schickt.

## Initial Access Broker
aka: IAB, Zugangsbroker
kat: Bedrohungen
kurz: Kriminelle, die erbeutete Zugänge zu Unternehmensnetzen an andere verkaufen.

## Ransomware as a Service
aka: RaaS
kat: Bedrohungen
kurz: Geschäftsmodell, bei dem Betreiber Ransomware an Affiliates vermieten.

## Affiliate
kat: Bedrohungen
kurz: Angreifer, der im RaaS-Modell die Ransomware eines Betreibers gegen Gewinnbeteiligung einsetzt.

## Schattenkopie
aka: Volume Shadow Copy, VSS
kat: Windows
kurz: Windows-Snapshot-Funktion; Ransomware löscht sie gezielt.

## Datenexfiltration
kat: Bedrohungen
kurz: Unbefugtes Abfließen von Daten aus einer Organisation.
siehe: Exfiltration

## rclone
kat: Werkzeuge
kurz: Legitimes Synchronisationswerkzeug für Cloud-Speicher, häufig für Datenabfluss missbraucht.
