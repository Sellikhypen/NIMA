# NIMA-Lexikon: Vertiefung (Blue Team, Cloud, AD, Härtung, WLAN, OT, Karriere)

## UEBA
aka: User and Entity Behavior Analytics
kat: Blue Team
kurz: Analyse, die ungewöhnliches Verhalten von Benutzern und Systemen gegenüber ihrer eigenen Normalität erkennt.
UEBA lernt typische Muster – Anmeldezeiten, Datenmengen, genutzte Systeme – und meldet Abweichungen, etwa große Downloads kurz vor einem Austritt oder Anmeldungen von ungewöhnlichen Orten. Besonders nützlich gegen Innentäter und übernommene Konten.
siehe: DLP, SIEM

## DLP
aka: Data Loss Prevention
kat: Blue Team
kurz: Technik und Prozesse, die das unerlaubte Abfließen sensibler Daten erkennen und verhindern.
DLP-Lösungen erkennen sensible Inhalte (z. B. Kreditkartennummern, Klassifizierungslabels) in E-Mails, Uploads, USB-Kopien oder Cloud-Freigaben und können warnen, blockieren oder protokollieren. Ohne saubere Datenklassifizierung erzeugt DLP viele Fehlalarme.
siehe: UEBA

## TLP
aka: Traffic Light Protocol
kat: Blue Team
kurz: Kennzeichnung, wie weit Informationen weitergegeben werden dürfen: RED, AMBER, GREEN, CLEAR.
TLP:RED nur an direkt Beteiligte, TLP:AMBER innerhalb der Organisation nach Need-to-know (AMBER+STRICT nur intern), TLP:GREEN innerhalb der Community, TLP:CLEAR öffentlich. Standard beim Austausch von Threat Intelligence.

## WORM-Speicher
aka: WORM, Write Once Read Many, unveränderlicher Speicher
kat: Blue Team
kurz: Speicher, dessen Daten nach dem Schreiben für eine Frist nicht verändert oder gelöscht werden können.
WORM schützt Logs und Backups vor Manipulation – auch durch Angreifer mit Administratorrechten. Cloud-Speicher bieten dafür Object Lock bzw. Immutable Storage.

## Double Extortion
aka: doppelte Erpressung
kat: Bedrohungen
kurz: Ransomware-Taktik, bei der Daten verschlüsselt und zusätzlich gestohlen werden, um mit Veröffentlichung zu drohen.
Backups allein helfen dann nicht mehr vollständig, weil die Drohung der Veröffentlichung bleibt. Erkennung von Datenabfluss vor der Verschlüsselung wird dadurch entscheidend.

## Adversary Emulation
kat: Blue Team
kurz: Nachstellen der dokumentierten Abläufe einer realen Angreifergruppe, um Erkennung und Schutz zu testen.
Grundlage sind Threat-Intelligence-Berichte und MITRE ATT&CK. Anders als ein freies Red Team folgt die Emulation einem festen Plan, damit Ergebnisse vergleichbar sind.
siehe: Purple Team, Tabletop-Übung

## Tabletop-Übung
aka: Tabletop, Planspiel
kat: Blue Team
kurz: Übung, bei der ein Vorfallszenario am Tisch durchgesprochen wird, um Prozesse und Entscheidungen zu testen.
Teilnehmende aus IT, Management, Recht und Kommunikation spielen Schritt für Schritt durch, wer was entscheidet. Deckt fehlende Zuständigkeiten und Kontaktlisten auf – ohne technisches Risiko.
siehe: Adversary Emulation

## Service Control Policy
aka: SCP
kat: Cloud
kurz: Leitplanke in AWS Organizations, die maximal erlaubte Aktionen für ganze Konten festlegt.
SCPs gewähren selbst keine Rechte, sondern begrenzen sie: Was eine SCP verbietet, kann auch ein Administrator im Konto nicht tun. Typisch: Regionen einschränken, Abschalten von CloudTrail verbieten.

## Managed Identity
aka: Managed Identities
kat: Cloud
kurz: Von Azure verwaltete Identität für Dienste, die Rechte ohne gespeicherte Geheimnisse erhält.
VMs, Functions oder App Services erhalten eine Identität, deren Anmeldedaten Azure selbst rotiert. Rechte werden per RBAC vergeben – Passwörter oder Schlüssel im Code entfallen.

## Landing Zone
kat: Cloud
kurz: Vorbereitete, regelkonforme Grundstruktur aus Konten, Netzwerken, Richtlinien und Logging für neue Cloud-Workloads.
Neue Projekte starten so automatisch mit zentralem Logging, Leitplanken und Netzanbindung, statt jedes Mal neu und uneinheitlich aufgebaut zu werden.

## Denial of Wallet
kat: Cloud
kurz: Angriff, der durch massenhaftes Auslösen kostenpflichtiger Cloud-Ressourcen finanziellen Schaden verursacht.
Besonders Serverless-Funktionen skalieren automatisch – und damit auch die Rechnung. Schutz: Limits, Budgets mit Alarmen, Rate Limiting und Authentifizierung vor teuren Funktionen.

## Pod Security Standards
aka: Pod Security Admission, PSS
kat: Cloud
kurz: Kubernetes-Profile Privileged, Baseline und Restricted, die festlegen, welche Pod-Einstellungen erlaubt sind.
Per Namespace-Label durchgesetzt. Restricted verlangt u. a. Ausführung ohne root, keine zusätzlichen Capabilities und ein Seccomp-Profil.
siehe: Network Policy

## Network Policy
aka: Kubernetes Network Policy
kat: Cloud
kurz: Kubernetes-Regel, die festlegt, welche Pods miteinander und mit externen Zielen kommunizieren dürfen.
Ohne Network Policies darf jeder Pod mit jedem sprechen. Bewährt ist ein Default-Deny pro Namespace mit gezielten Freigaben. Das Netzwerk-Plugin muss Policies unterstützen.
siehe: Pod Security Standards

## AdminSDHolder
kat: Active Directory
kurz: AD-Objekt, dessen Berechtigungen als Vorlage für alle geschützten privilegierten Gruppen und Konten dienen.
Der SDProp-Prozess setzt die Berechtigungen geschützter Objekte regelmäßig auf die von AdminSDHolder zurück. Wer AdminSDHolder ändert, verankert Rechte dauerhaft – Änderungen müssen daher überwacht werden.
siehe: GPO

## Protected Users
kat: Active Directory
kurz: Sicherheitsgruppe, deren Mitglieder strengere Authentifizierungsregeln erhalten.
Für Mitglieder gibt es u. a. kein NTLM, keine Delegation, keine RC4-Verschlüsselung für Kerberos und kürzere Ticket-Laufzeiten. Gedacht für privilegierte Konten, vorher auf Kompatibilität testen.

## Entra Connect
aka: Azure AD Connect, Entra Connect Sync
kat: Active Directory
kurz: Microsoft-Werkzeug, das lokale AD-Identitäten mit Entra ID synchronisiert.
Weil der Sync-Server weitreichende Rechte in beiden Welten hat, gilt er als Tier-0-System und muss wie ein Domain Controller geschützt werden.

## Security Baseline
aka: Sicherheits-Baseline, Microsoft Security Baseline
kat: Härtung
kurz: Empfohlene Mindestkonfiguration für ein System, oft als fertige Richtlinien verfügbar.
Microsoft liefert Baselines als GPOs bzw. Intune-Profile; sie werden getestet, angepasst und mit dokumentierten Ausnahmen ausgerollt.
siehe: CIS Benchmark

## CIS Benchmark
aka: CIS Benchmarks
kat: Härtung
kurz: Konsensbasierte Härtungsempfehlungen des Center for Internet Security für viele Systeme und Dienste.
Level 1 ist breit einsetzbar mit wenig Funktionseinschränkung, Level 2 strenger für Umgebungen mit hohem Schutzbedarf. Prüfbar mit Werkzeugen wie CIS-CAT oder OpenSCAP.
siehe: Security Baseline, Lynis

## Lynis
kat: Härtung
kurz: Open-Source-Werkzeug, das Linux- und Unix-Systeme auf Härtung prüft und einen Index ausgibt.
Lynis prüft Hunderte Punkte (Dienste, Rechte, Kernel, Logging) und gibt konkrete Vorschläge. Gut geeignet, um Fortschritte bei der Härtung messbar zu machen.
siehe: CIS Benchmark

## Attack Surface Reduction
aka: ASR, ASR-Regeln
kat: Härtung
kurz: Windows-Defender-Regeln, die typische Angriffsverhalten wie Makros, die Prozesse starten, blockieren.
Beispiele: Office darf keine Kindprozesse starten, ausführbare Inhalte aus E-Mails werden blockiert, Zugriff auf LSASS wird eingeschränkt. Zuerst im Audit-Modus testen.

## System Integrity Protection
aka: SIP
kat: Härtung
kurz: macOS-Schutz, der Systemdateien und -prozesse auch vor dem root-Benutzer schützt.
SIP verhindert Änderungen an geschützten Systembereichen; deaktivieren ist nur aus dem Wiederherstellungsmodus möglich. Ein deaktiviertes SIP ist ein Warnsignal.

## DHCP Snooping
kat: Netzwerk
kurz: Switch-Funktion, die DHCP-Antworten nur von vertrauenswürdigen Ports zulässt.
Verhindert gefälschte DHCP-Server und baut eine Zuordnungstabelle aus MAC, IP und Port auf, die von Dynamic ARP Inspection genutzt wird.
siehe: Dynamic ARP Inspection

## Dynamic ARP Inspection
aka: DAI
kat: Netzwerk
kurz: Switch-Funktion, die ARP-Pakete gegen bekannte IP-MAC-Zuordnungen prüft und Fälschungen verwirft.
Grundlage ist die Tabelle aus DHCP Snooping. Schützt vor ARP-Spoofing und damit vor Man-in-the-Middle im lokalen Netz.
siehe: DHCP Snooping

## Captive Portal
kat: WLAN
kurz: Webseite, die Nutzer eines Gästenetzes vor dem Internetzugang zur Anmeldung oder Zustimmung umleitet.
Ein Captive Portal steuert den Zugang, verschlüsselt aber nicht den Funkverkehr. Für verschlüsselte offene Netze dient OWE.
siehe: OWE

## OWE
aka: Opportunistic Wireless Encryption, Enhanced Open
kat: WLAN
kurz: Verfahren, das offene WLANs ohne Passwort pro Client verschlüsselt.
Per Diffie-Hellman entsteht für jeden Client ein eigener Schlüssel. Schützt vor passivem Mitlesen, aber nicht vor gefälschten Access Points, weil sich das Netz nicht authentifiziert.
siehe: Captive Portal

## Rogue AP
aka: Rogue Access Point
kat: WLAN
kurz: Nicht genehmigter Access Point, der am kabelgebundenen Firmennetz hängt.
Oft gut gemeint (eigener Router am Arbeitsplatz), aber eine Hintertür ins interne Netz. WIDS/WIPS erkennen ihn, indem sie Funk- und Kabelseite abgleichen.
siehe: Evil Twin

## Site Survey
aka: Funkausleuchtung, WLAN-Ausleuchtung
kat: WLAN
kurz: Planung oder Messung der WLAN-Funkabdeckung, prädiktiv, passiv oder aktiv.
Prädiktive Surveys nutzen Grundrisse und Wandmaterialien, passive messen den Empfang, aktive messen Durchsatz und Roaming mit Verbindung.

## Datendiode
aka: Data Diode, unidirektionales Gateway
kat: OT
kurz: Hardware, die Daten physikalisch nur in eine Richtung durchlässt.
Typisch in OT und KRITIS: Messwerte und Logs fließen aus dem Steuerungsnetz in die IT, aber keine Verbindung ist in Gegenrichtung möglich.
siehe: Modbus

## Spaced Repetition
aka: verteilte Wiederholung
kat: Lernen
kurz: Lernmethode, bei der Inhalte in wachsenden Abständen wiederholt werden, kurz bevor man sie vergisst.
Richtig beantwortete Fragen kommen seltener, falsche öfter. So bleibt Wissen mit wenig Aufwand langfristig – NIMAs Training nutzt dieses Prinzip.
