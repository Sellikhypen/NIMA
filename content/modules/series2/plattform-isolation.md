---
id: pi-01
title: Plattform 1 · Virtualisierung sicher betreiben
paths: specialist, cyberrange
order: 11.5
difficulty: medium
icon: square.stack.3d.down.right.fill
tags: virtualisierung, hypervisor, härtung
summary: Hypervisor als Tier-0-System, Management-Netze, VM-Isolation, VM-Escape als Risikoklasse, Snapshots und Härtung von Proxmox, vSphere und Hyper-V.
---

## Einfach erklärt

Ein Hypervisor ist der Vermieter eines Hochhauses voller virtueller Wohnungen. Wer den Vermieter kontrolliert, hat Schlüssel zu **allen** Wohnungen: Er kann VMs kopieren, ausschalten, ihren Speicher lesen. Deshalb gehören Hypervisoren und ihre Verwaltung zu den wertvollsten Zielen – und zu den am besten zu schützenden Systemen.

## Risiken

| Risiko | Beispiel |
|---|---|
| Kompromittierte Verwaltung | Zugriff auf vCenter/Proxmox-Oberfläche → alle VMs |
| Ransomware auf Hypervisor-Ebene | alle VM-Dateien auf einmal verschlüsselt |
| VM-Escape | Ausbruch aus einer VM auf den Host (selten, aber kritisch) |
| Snapshots mit sensiblen Daten | enthalten RAM-Inhalte, Schlüssel |
| Gemischte Vertrauenszonen | DMZ-VM und DC auf demselben Host |

## Härtung

1. **Management-Netz** getrennt, nur über Jump-Host/PAW erreichbar.
2. Verwaltung mit **MFA** und eigener Identität (nicht dieselbe Domäne, die auf dem Host läuft – sonst Henne-Ei-Problem bei Kompromittierung).
3. **Updates** für Hypervisor und Verwaltung zeitnah (Massenausnutzung von Hypervisor-Lücken kam vor).
4. Unnötige Dienste (SSH, Shell) deaktivieren oder einschränken.
5. **Lockdown-/Härtungsmodi** der Plattform nutzen.
6. **Backups** von VMs getrennt und unveränderlich.
7. Logs der Verwaltung ins SIEM (Anmeldungen, VM-Exporte, Snapshot-Erstellung).

> [!MERKE] Henne-Ei-Problem
> Laufen die Domain Controller auf dem Hypervisor, und meldet man sich mit Domänenkonten am Hypervisor an, kann ein Domänen-Angreifer den Hypervisor übernehmen – und umgekehrt. Getrennte Identitäten durchbrechen den Kreis.

## Tiefer eingetaucht

VM-Escape-Lücken betreffen meist emulierte Geräte (virtuelle Netzwerkkarten, USB, Grafik). Weniger emulierte Hardware (paravirtualisierte Treiber, keine unnötigen Geräte) verringert die Angriffsfläche. Für Ranges und Malware-Labore gilt besonders: Analyse-VMs auf eigenen Hosts, ohne Zugriff auf Produktivnetze.

Ransomware-Gruppen haben eigene Varianten für Hypervisoren entwickelt, die VM-Festplatten direkt auf Datenspeicher-Ebene verschlüsseln. Erkennungsideen: ungewöhnliche Shell-Zugriffe auf Hosts, massenhaftes Herunterfahren von VMs, neue Dateien mit fremden Endungen in Datenspeichern.

## Quiz

? Warum sind Hypervisoren besonders wertvolle Ziele?
+ wer sie kontrolliert, kontrolliert alle darauf laufenden VMs
- weil sie wenig Strom verbrauchen
- weil sie keine Passwörter haben
- weil sie nur Testsysteme enthalten
! Sie gehören zu Tier 0.

? Was ist VM-Escape?
+ ein Ausbruch aus einer VM auf den Host
- das Herunterfahren einer VM
- ein Backup-Verfahren
- ein Netzwerkprotokoll
! Selten, aber besonders kritisch.

?tf Die Hypervisor-Verwaltung sollte dieselbe Domäne zur Anmeldung nutzen, die auf ihm läuft.
= falsch
! Das erzeugt ein Henne-Ei-Problem bei Kompromittierung.

? Was enthalten Snapshots mit Speicherzustand?
+ RAM-Inhalte wie Schlüssel und Passwörter
- nur Dateinamen
- nur das Betriebssystem-Logo
- nichts Sensibles
! Snapshots müssen entsprechend geschützt werden.

? Wie verringert man die Angriffsfläche für VM-Escape?
+ unnötige emulierte Geräte entfernen und paravirtualisierte Treiber nutzen
- mehr USB-Geräte durchreichen
- Updates deaktivieren
- alle VMs auf einen Host legen
! Viele Escape-Lücken betreffen emulierte Hardware.

@@@ MODULE @@@
---
id: pi-02
title: Plattform 2 · Container-Isolation – Namespaces, cgroups, seccomp
paths: specialist, cdsa, cwee
order: 71
difficulty: hard
icon: shippingbox.fill
tags: container, linux, isolation
summary: Wie Container technisch isoliert werden, warum sie keine VMs sind, welche Einstellungen Ausbrüche ermöglichen und wie man Laufzeitumgebungen härtet.
---

## Einfach erklärt

Container wirken wie eigene kleine Rechner, sind aber nur **Prozesse mit Scheuklappen**: Der Linux-Kernel zeigt ihnen eine eigene Sicht auf Dateien, Prozesse und Netz. Alle Container teilen sich denselben Kernel. Fällt eine Scheuklappe weg – etwa durch eine falsche Einstellung –, sieht der Container plötzlich den Host.

## Die Bausteine

| Mechanismus | Isoliert |
|---|---|
| Namespaces (pid, net, mnt, uts, ipc, user) | Sicht auf Prozesse, Netz, Dateisystem, Hostname |
| cgroups | Ressourcen (CPU, RAM, I/O) – gegen DoS |
| Capabilities | Teilrechte von root, z. B. `NET_ADMIN`, `SYS_ADMIN` |
| seccomp | erlaubte Systemaufrufe |
| AppArmor/SELinux | Zugriff auf Dateien und Ressourcen |
| User Namespaces / rootless | root im Container ≠ root auf dem Host |

## Gefährliche Einstellungen

| Einstellung | Warum gefährlich |
|---|---|
| `--privileged` | fast alle Schutzmechanismen aus |
| Docker-Socket eingebunden (`/var/run/docker.sock`) | Container kann Host-Container steuern → Host-Übernahme |
| `hostPath`-Mounts auf `/` oder `/etc` | direkter Zugriff auf Host-Dateien |
| `CAP_SYS_ADMIN` | sehr mächtige Capability |
| `hostPID`, `hostNetwork` | Sicht auf Host-Prozesse/Netz |
| root im Container ohne User Namespace | Ausbruchsfolgen schwerer |

> [!GEFAHR] Docker-Socket = root auf dem Host
> Wer den Docker-Socket im Container hat, kann einen neuen privilegierten Container mit Host-Dateisystem starten. Niemals ohne zwingenden Grund einbinden.

## Tiefer eingetaucht

Härtung: rootless Container (Podman, Docker rootless), Standard-seccomp-Profil aktiv lassen, Capabilities mit `--cap-drop=ALL` entfernen und nur Nötiges hinzufügen, schreibgeschütztes Root-Dateisystem (`--read-only`), Ressourcenlimits. Für höhere Isolation: Sandbox-Laufzeiten (gVisor) oder Micro-VMs (Kata Containers, Firecracker), die einen eigenen Kernel bzw. eine zusätzliche Schicht einziehen. Erkennung zur Laufzeit (z. B. Falco) achtet auf Shells in Containern, Zugriffe auf sensible Pfade und unerwartete Netzwerkverbindungen.

## Quiz

? Was teilen sich alle Container auf einem Host?
= Kernel
= den Kernel
! Deshalb sind Container keine VMs.

? Welcher Mechanismus begrenzt Ressourcen wie CPU und RAM?
= cgroups
= Control Groups
! Schutz gegen Ressourcen-Erschöpfung.

? Welcher Mechanismus filtert erlaubte Systemaufrufe?
= seccomp
! Docker hat ein Standardprofil, das aktiv bleiben sollte.

?tf Ein eingebundener Docker-Socket ermöglicht faktisch root-Zugriff auf den Host.
= wahr
! Damit lassen sich privilegierte Container starten.

? Welche Option schaltet fast alle Container-Schutzmechanismen ab?
= --privileged
= privileged
! Nur in begründeten Ausnahmefällen.

? Welche Laufzeiten bieten stärkere Isolation durch zusätzliche Schichten?
+ gVisor
+ Kata Containers
- Bash
- Notepad
! Eigener Kernel bzw. Sandbox zwischen Container und Host.

@@@ MODULE @@@
---
id: pi-03
title: Plattform 3 · Passkeys und FIDO2 im Detail
paths: specialist, cwes, cwee
order: 5.3
difficulty: medium
icon: person.badge.key.fill
tags: passkeys, fido2, webauthn
summary: Wie WebAuthn-Registrierung und -Anmeldung funktionieren, synchronisierte vs. gerätegebundene Passkeys, Attestation und Einführung im Unternehmen.
---

## Einfach erklärt

Ein Passkey ist wie ein Schlüssel, der nur in **ein bestimmtes Schloss** passt und nie aus deiner Tasche genommen wird. Statt ein Passwort einzutippen, beweist dein Gerät mit einer Signatur, dass es den passenden Schlüssel besitzt – entsperrt per Fingerabdruck, Gesicht oder PIN. Phishing-Seiten bekommen nichts, was sie verwenden könnten.

## Registrierung (vereinfacht)

1. Server sendet eine **Challenge** und seine Domain (Relying Party ID).
2. Gerät erzeugt ein **Schlüsselpaar** nur für diese Domain.
3. Öffentlicher Schlüssel + Credential-ID gehen an den Server; der private bleibt im Gerät.

## Anmeldung

1. Server sendet eine neue Challenge.
2. Browser prüft die Domain und reicht sie mit ans Gerät.
3. Gerät signiert nach **Nutzerverifikation** (Biometrie/PIN).
4. Server prüft die Signatur mit dem gespeicherten öffentlichen Schlüssel.

| Eigenschaft | Wirkung |
|---|---|
| Domain-Bindung | gefälschte Domains erhalten keine gültige Signatur |
| kein gemeinsames Geheimnis | Server-Datenleck liefert keine nutzbaren Passwörter |
| Nutzerverifikation lokal | Biometrie verlässt das Gerät nicht |

## Varianten

| Art | Eigenschaft |
|---|---|
| Synchronisierte Passkeys | über Cloud-Schlüsselbund auf mehrere Geräte verteilt – komfortabel |
| Gerätegebundene Passkeys / Sicherheitsschlüssel | verlassen das Gerät nie – höchste Sicherheit, z. B. für Admins |

> [!MERKE] Wiederherstellung planen
> Die Schwachstelle ist oft nicht der Passkey, sondern der **Fallback**: Wenn Kontowiederherstellung per SMS-Code möglich ist, greifen Angreifer dort an.

## Tiefer eingetaucht

Unternehmen können per **Attestation** prüfen, welche Authentifikatoren genutzt werden (z. B. nur zertifizierte Hardware-Schlüssel für Admins). Einführungspfad: zuerst privilegierte Konten, dann alle; Bootstrap neuer Geräte über bestehende starke Faktoren oder vor Ort; Wiederherstellung mit Identitätsprüfung statt schwacher Faktoren. Conditional-Access-Richtlinien können „phishing-resistente Authentifizierungsstärke“ für sensible Anwendungen verlangen.

## Quiz

? Warum sind Passkeys phishing-resistent?
+ die Signatur ist an die echte Domain gebunden
- weil sie lang sind
- weil sie per SMS kommen
- weil sie täglich wechseln
! Eine gefälschte Domain erhält keine gültige Anmeldung.

? Was bleibt bei Passkeys immer auf dem Gerät?
+ der private Schlüssel
- der öffentliche Schlüssel
- die Challenge
- die Domain
! Der Server kennt nur den öffentlichen Schlüssel.

?tf Ein Datenleck beim Server liefert bei Passkeys keine nutzbaren Anmeldegeheimnisse.
= wahr
! Öffentliche Schlüssel allein erlauben keine Anmeldung.

? Welche Passkey-Variante ist für Admins mit höchstem Schutzbedarf geeignet?
+ gerätegebundene Passkeys bzw. Hardware-Sicherheitsschlüssel
- per SMS synchronisierte Codes
- ausgedruckte Passwörter
- geteilte Konten
! Sie verlassen das Gerät nie.

? Was ist bei Passkey-Einführungen oft die eigentliche Schwachstelle?
+ schwache Wiederherstellungs- und Fallback-Verfahren
- die Kryptografie
- die Domain-Bindung
- die Biometrie
! Angreifer zielen auf den schwächsten Weg.

? Wie heißt der Web-Standard hinter Passkeys?
= WebAuthn
! Zusammen mit CTAP bildet er FIDO2.

@@@ MODULE @@@
---
id: pi-04
title: Plattform 4 · Paket-Ökosysteme und Abhängigkeiten absichern
paths: cwee, specialist, cwes
order: 72
difficulty: medium
icon: shippingbox.and.arrow.backward
tags: supply chain, npm, pypi, abhängigkeiten
summary: Typosquatting, Dependency Confusion, kompromittierte Maintainer und bösartige Install-Skripte – und wie Lockfiles, Proxys, Prüfungen und Richtlinien schützen.
---

## Einfach erklärt

Moderne Software ist wie ein Gericht aus vielen Zutaten von verschiedenen Lieferanten – hunderte Pakete aus npm, PyPI, Maven & Co. Wenn ein Lieferant vergiftete Zutaten liefert oder jemand ein Paket mit fast gleichem Namen unterschiebt, landet das Gift im Gericht.

## Angriffsklassen

| Klasse | Beschreibung |
|---|---|
| Typosquatting | Paket mit Tippfehler-Namen (`reqeusts` statt `requests`) |
| Dependency Confusion | öffentliches Paket mit gleichem Namen wie internes, höhere Version → wird bevorzugt |
| Kompromittierter Maintainer | gekapertes Konto veröffentlicht bösartige Version |
| Bösartige Install-Skripte | Code läuft schon bei `npm install` / `pip install` |
| Verlassene Pakete | übernommen und manipuliert |
| Protestware | Maintainer baut absichtlich schädliches Verhalten ein |

## Schutzmaßnahmen

1. **Lockfiles** mit Hashes (`package-lock.json`, `poetry.lock`, `pip --require-hashes`).
2. **Interner Paket-Proxy/Mirror** mit Freigabeprozess; interne Namensräume (Scopes) reservieren.
3. **Install-Skripte** einschränken (z. B. `npm config set ignore-scripts true` in CI, wo möglich).
4. **SCA** und Malware-Erkennung für Pakete in der CI.
5. **Neue Abhängigkeiten bewusst aufnehmen**: Wer pflegt es? Wie verbreitet? Wie viele eigene Abhängigkeiten?
6. **Minimale Rechte** für Build-Umgebungen (keine Produktions-Secrets in Builds aus Pull Requests).
7. **SBOM** erzeugen, um im Ernstfall schnell zu wissen, wo ein Paket steckt.

> [!MERKE] Jede Abhängigkeit ist Code von Fremden
> Weniger Abhängigkeiten bedeuten weniger Risiko. Für eine Zeile Funktionalität kein Paket mit 50 eigenen Abhängigkeiten installieren.

## Tiefer eingetaucht

Im Ernstfall (bösartige Version bekannt geworden): SBOM/Lockfiles durchsuchen, betroffene Builds identifizieren, Secrets rotieren, die in Builds verfügbar waren, Artefakte neu bauen, Produktionssysteme auf Anzeichen prüfen. Ökosysteme verbessern sich: verpflichtende MFA für Maintainer populärer Pakete, Trusted Publishing (OIDC statt langlebiger Tokens), Herkunftsnachweise (Provenance) für Pakete.

## Quiz

? Was ist Typosquatting bei Paketen?
+ ein bösartiges Paket mit fast gleichem Namen wie ein beliebtes
- ein Paket mit Rechtschreibfehlern in der Doku
- ein sehr großes Paket
- ein verschlüsseltes Paket
! Ein Tippfehler bei der Installation genügt.

? Was ist Dependency Confusion?
+ ein öffentliches Paket mit dem Namen eines internen wird bevorzugt installiert
- zwei Entwickler streiten über Pakete
- ein Paket ohne Lizenz
- ein Paket ohne Version
! Interne Namensräume reservieren und Proxy-Regeln nutzen.

?tf Install-Skripte von Paketen können schon bei der Installation Code ausführen.
= wahr
! In CI nach Möglichkeit einschränken.

? Was enthält ein Lockfile mit Hashes?
+ exakte Versionen und Prüfsummen aller Abhängigkeiten
- Passwörter
- Lizenztexte
- Benutzerdaten
! Verhindert unbemerkte Änderungen.

? Was hilft im Ernstfall, schnell betroffene Systeme zu finden?
= SBOM
= Software Bill of Materials
! Die Zutatenliste jeder Software.

@@@ MODULE @@@
---
id: pi-05
title: Plattform 5 · Backup-Technik vertieft
paths: specialist, cyberrange
order: 14.55
difficulty: medium
icon: externaldrive.fill.badge.timemachine
tags: backup, resilienz
summary: Snapshots vs. Backups, Deduplizierung, Immutable Storage, Air-Gap, Backup-Härtung, Restore-Tests und Wiederherstellungsreihenfolge.
---

## Einfach erklärt

Ein **Snapshot** ist ein Lesezeichen im selben Buch – brennt das Buch, ist auch das Lesezeichen weg. Ein **Backup** ist eine Kopie des Buches an einem anderen Ort. Für Ransomware-Resilienz braucht man Kopien, die ein Angreifer **nicht erreichen oder nicht verändern** kann.

## Begriffe

| Begriff | Bedeutung |
|---|---|
| Snapshot | Zeitpunktabbild auf demselben System – schnell, aber nicht unabhängig |
| Backup | unabhängige Kopie auf anderem System |
| Deduplizierung | gleiche Datenblöcke nur einmal speichern |
| Immutable / WORM | für eine Frist unveränderlich (Object Lock, Hardened Repository) |
| Air-Gap | physisch oder logisch getrennt, nur zeitweise verbunden |
| Wiederherstellungspunkt | ein abrufbarer Stand |

## Backup-Infrastruktur härten

1. **Eigene Identität**: Backup-Server nicht in der Produktivdomäne; eigene Admin-Konten mit MFA.
2. **Netz trennen**: Backup-Netz, nur nötige Ports.
3. **Unveränderlichkeit** mit Frist (z. B. 14–30 Tage).
4. **Vier-Augen-Prinzip** für Löschungen und Änderungen der Aufbewahrung.
5. **Verschlüsselung** der Backups (Schlüssel getrennt sicher verwahrt!).
6. **Alarme** bei ungewöhnlichen Löschungen, Job-Fehlern, Änderungen.

> [!GEFAHR] Angreifer jagen Backups
> In vielen Ransomware-Fällen wurden zuerst die Backups gelöscht oder verschlüsselt. Ein Backup, das mit Domänen-Admin-Rechten löschbar ist, ist im Ernstfall vermutlich weg.

## Wiederherstellung

- **Restore-Tests** regelmäßig (Dateien, ganze Systeme, Datenbanken, AD).
- **Reihenfolge** festlegen: Identität (AD) → Netzwerkdienste (DNS/DHCP) → kritische Anwendungen → Rest.
- **Saubere Umgebung**: Backups vor dem Zurückspielen auf Malware prüfen (der Angreifer war vielleicht schon vor Wochen da).
- **Dauer messen**: Reicht die Bandbreite, um Terabytes in der geplanten RTO zurückzuspielen?

## Tiefer eingetaucht

SaaS-Daten (M365, Google Workspace) gehören ins Backup-Konzept – Anbieter bieten oft nur begrenzte Wiederherstellung. Für Datenbanken sind konsistente Sicherungen (Anwendungs-bewusst, Transaktionslogs) wichtig. Und: Dokumentation des Wiederanlaufs muss **offline** verfügbar sein – im Ernstfall ist das Wiki vielleicht selbst verschlüsselt.

## Quiz

? Warum ist ein Snapshot kein vollwertiges Backup?
+ er liegt auf demselben System und geht mit ihm verloren
- er ist zu groß
- er ist verschlüsselt
- er enthält keine Daten
! Backups brauchen ein unabhängiges System.

? Was bedeutet Immutable Storage?
+ Daten können für eine festgelegte Frist nicht verändert oder gelöscht werden
- Daten werden sofort gelöscht
- Daten sind öffentlich
- Daten sind komprimiert
! Schutz gegen Löschung durch Angreifer.

?tf Backup-Server sollten Mitglied der normalen Produktivdomäne mit denselben Admin-Konten sein.
= falsch
! Eigene Identität verhindert, dass Domänen-Angreifer Backups löschen.

? Welches System wird bei einer Wiederherstellung typischerweise zuerst benötigt?
+ Identität bzw. Active Directory
- der Kantinenplan
- das Intranet-Design
- Testsysteme
! Ohne Anmeldung funktioniert wenig anderes.

? Warum sollte man Backups vor dem Zurückspielen prüfen?
+ der Angreifer könnte schon vor Wochen im System gewesen sein
- weil Backups immer leer sind
- weil es Pflicht für Drucker ist
- weil Backups automatisch gelöscht werden
! Sonst stellt man die Hintertür gleich mit wieder her.

@@@ MODULE @@@
---
id: pi-06
title: Plattform 6 · E-Mail-Security-Gateway und Postfachschutz
paths: specialist, cdsa
order: 15.6
difficulty: medium
icon: tray.full.fill
tags: e-mail, gateway, schutz
summary: Wie E-Mail-Schutz in Schichten funktioniert – Reputation, Authentifizierung, Inhaltsfilter, Sandboxing, Link-Umschreibung, Bannerwarnungen und Post-Delivery-Bereinigung.
---

## Einfach erklärt

Die Poststelle eines großen Unternehmens öffnet nicht jeden Brief ungeprüft: Sie kennt verdächtige Absender, durchleuchtet Pakete und warnt bei Ungewöhnlichem. Ein **E-Mail-Security-Gateway** tut dasselbe für E-Mails – in mehreren Schichten.

## Die Schichten

| Schicht | Prüft |
|---|---|
| Verbindung | IP-Reputation, Rate Limits, TLS |
| Authentifizierung | SPF, DKIM, DMARC, ARC |
| Absender | Lookalike-Domains, Display-Name-Spoofing, neue Domains |
| Inhalt | Spam, Phishing-Muster, Schlüsselwörter |
| Anhänge | Dateitypen blockieren (z. B. `.exe`, `.js`, `.iso`), Makros, Sandbox-Detonation |
| Links | Umschreibung und Prüfung beim Klick (Time-of-Click) |
| Nach Zustellung | nachträgliches Entfernen, wenn eine Mail später als bösartig erkannt wird |
| Nutzer | Banner „Externe Mail“, Meldebutton |

> [!TIPP] Gefährliche Anhangtypen blockieren
> Ausführbare Dateien, Skripte, Disk-Images (`.iso`, `.img`, `.vhd`) und HTML-Anhänge haben in normaler Geschäftskommunikation selten etwas zu suchen. Blockieren oder in Quarantäne.

## Tiefer eingetaucht

Angreifer passen sich an: Links zu legitimen Cloud-Diensten (Dateifreigaben) mit bösartigem Inhalt, QR-Codes in Bildern, passwortgeschützte Archive (Sandbox kann nicht hineinschauen), verzögerte Aktivierung von Links nach der Zustellung. Deshalb sind Time-of-Click-Prüfung, nachträgliche Bereinigung (Zero-hour Auto Purge) und das Zusammenspiel mit EDR (was passiert nach dem Öffnen?) so wichtig.

Auch **ausgehende** Mails gehören geprüft: Ein kompromittiertes Postfach, das plötzlich hunderte Phishing-Mails an Partner verschickt, muss schnell gestoppt werden (Ausgangslimits, Erkennung).

## Quiz

? Welche Anhangtypen sollte man in der Regel blockieren?
+ ausführbare Dateien und Skripte
+ Disk-Images wie .iso
- normale PDF-Rechnungen von bekannten Partnern
- Textnachrichten ohne Anhang
! Sie haben in Geschäftskommunikation selten etwas zu suchen.

? Was bedeutet Time-of-Click-Prüfung?
+ Links werden beim Anklicken erneut geprüft, nicht nur bei Zustellung
- Mails werden nur nachts zugestellt
- der Nutzer muss die Uhrzeit eingeben
- Links werden gelöscht
! Wichtig, weil Links nach der Zustellung bösartig werden können.

?tf Passwortgeschützte Archive können eine Sandbox-Analyse umgehen.
= wahr
! Die Sandbox kann den Inhalt nicht entpacken.

? Warum sollte man auch ausgehende Mails überwachen?
+ kompromittierte Postfächer verschicken sonst Phishing an Partner
- weil ausgehende Mails langsamer sind
- weil Empfänger es verlangen
- weil Anhänge größer sind
! Ausgangslimits und Erkennung begrenzen den Schaden.

? Was macht ein Banner „Externe Mail“?
+ es macht Nutzer darauf aufmerksam, dass die Mail von außerhalb kommt
- es blockiert die Mail
- es verschlüsselt die Mail
- es übersetzt die Mail
! Hilft gegen Absenderfälschung mit internen Namen.

@@@ MODULE @@@
---
id: pi-07
title: Plattform 7 · KI im SOC – Nutzen, Grenzen, Risiken
paths: cdsa, specialist
order: 35
difficulty: easy
icon: sparkles.rectangle.stack.fill
tags: ki, soc
summary: Wo KI-Assistenten Analysten wirklich helfen, wo sie irren, wie man Ergebnisse prüft und welche Daten man ihnen anvertraut.
---

## Einfach erklärt

KI-Assistenten können im SOC wie ein sehr schneller, belesener Praktikant wirken: Sie fassen Alarme zusammen, erklären unbekannte Befehle, schlagen Abfragen vor und schreiben Berichtsentwürfe. Aber wie bei einem Praktikanten gilt: **Ergebnisse prüfen**, bevor man danach handelt.

## Wo KI hilft

| Aufgabe | Nutzen |
|---|---|
| Alarmzusammenfassung | Kontext aus vielen Ereignissen in wenigen Sätzen |
| Erklären | verschleierte Skripte, unbekannte Kommandozeilen, Logformate |
| Abfragen vorschlagen | SPL/KQL aus natürlicher Sprache |
| Entwürfe | Incident-Berichte, Kundenkommunikation |
| Anreicherung | Zusammenführen von Threat-Intel-Infos |

## Grenzen und Risiken

- **Halluzinationen**: überzeugend formulierte, falsche Aussagen (z. B. erfundene Event-IDs).
- **Fehlender Kontext**: kennt die eigene Umgebung nicht.
- **Prompt Injection**: Angreifer platzieren Anweisungen in Logs oder Mails, die von der KI gelesen werden.
- **Datenschutz/Vertraulichkeit**: Welche Daten dürfen an welchen Dienst?
- **Automatisierungsbias**: Menschen vertrauen Maschinenergebnissen zu schnell.

> [!MERKE] Verifizieren, dann handeln
> Jede KI-Aussage, die zu einer Entscheidung führt (Host isolieren, Vorfall schließen), braucht eine Prüfung an der Quelle – im Log, im Code, in der Dokumentation.

## Gute Praxis

1. Freigegebene Werkzeuge mit klaren Datenregeln (keine Kundendaten in private Dienste).
2. KI-Ausgaben kennzeichnen („KI-Entwurf“) und durch Menschen freigeben.
3. Vorgeschlagene Abfragen erst testen, Ergebnisse plausibilisieren.
4. KI-Zugriff auf Werkzeuge nach Least Privilege (lesen ja, sperren nur mit Bestätigung).
5. Wirksamkeit messen: Spart es Zeit? Wie oft lag es falsch?

## Tiefer eingetaucht

Angreifer nutzen KI ebenfalls – für glaubwürdigere Phishing-Texte, schnellere Aufklärung, Variation von Schadcode. Das verändert weniger die Grundprinzipien der Verteidigung als ihr Tempo: Phishing-resistente MFA, Härtung und gute Erkennung bleiben wirksam. Und Analystinnen und Analysten, die Grundlagen tief verstehen, sind besser darin, KI-Fehler zu erkennen – Lernen bleibt also wichtiger denn je.

## Quiz

? Was ist eine Halluzination bei KI-Assistenten?
+ eine überzeugend formulierte, aber falsche Aussage
- ein Bildschirmfehler
- ein Netzwerkausfall
- ein besonders schnelles Ergebnis
! Deshalb Aussagen an der Quelle prüfen.

? Wie können Angreifer KI-Assistenten im SOC manipulieren?
+ durch Anweisungen in Logs oder E-Mails, die die KI liest (Prompt Injection)
- durch Abschalten des Stroms
- durch größere Bildschirme
- durch längere Passwörter
! Verarbeitete Daten können Anweisungen enthalten.

?tf KI-Ergebnisse sollten vor folgenreichen Entscheidungen verifiziert werden.
= wahr
! Verifizieren, dann handeln.

? Was ist Automatisierungsbias?
+ Menschen vertrauen Maschinenergebnissen zu schnell
- Maschinen bevorzugen bestimmte Nutzer
- Automatisierung ist immer falsch
- Bias in Netzwerkkabeln
! Bewusst gegensteuern durch Prüfung.

? Welche Aufgabe eignet sich gut für KI-Unterstützung?
+ verschleierte Skripte erklären und Alarme zusammenfassen
- ungeprüft Hosts isolieren
- Vorfälle ohne Prüfung schließen
- Kundendaten in private Dienste kopieren
! Unterstützung ja, blinde Automatisierung nein.

@@@ MODULE @@@
---
id: pi-08
title: Plattform 8 · Drucker, Scanner und Peripherie als Angriffsfläche
paths: specialist, cpts
order: 14.15
difficulty: easy
icon: printer.fill
tags: drucker, peripherie, härtung
summary: Warum Multifunktionsdrucker kleine Server sind, welche Risiken sie bergen und wie man sie, USB-Geräte und andere Peripherie absichert.
---

## Einfach erklärt

Ein moderner Multifunktionsdrucker ist ein kleiner Server: mit Betriebssystem, Festplatte, Webserver, Adressbuch, Zugang zum Mailserver und zu Netzwerkfreigaben. Weil ihn niemand als Computer wahrnimmt, wird er selten gepatcht – ein beliebter, unauffälliger Einstiegspunkt.

## Risiken

| Risiko | Beispiel |
|---|---|
| Standardpasswort der Weboberfläche | Konfiguration ändern, Adressbuch auslesen |
| Gespeicherte Zugangsdaten | LDAP-/SMTP-/SMB-Konten für Scan-to-Mail/Ordner |
| Festplatte mit Druck- und Scanjobs | Daten bei Entsorgung |
| Veraltete Firmware | bekannte Lücken |
| Offene Dienste | Telnet, FTP, SNMP mit Standard-Community |
| Druckspooler auf Windows-Servern | historisch viele schwere Lücken |

> [!WARNUNG] LDAP-Passback
> Manche Drucker erlauben, die LDAP-Serveradresse zu ändern und eine „Testverbindung“ zu starten – dann schickt der Drucker die gespeicherten Domänen-Anmeldedaten an einen beliebigen Server. Admin-Oberfläche schützen!

## Absichern

1. Admin-Passwort ändern, Weboberfläche nur aus dem Management-Netz.
2. Firmware aktuell halten (in Patch-Management aufnehmen!).
3. Ungenutzte Dienste abschalten; SNMPv3 statt v1/v2c.
4. Dienstkonten für Scan-Funktionen minimal berechtigen.
5. Drucker in eigenes Segment.
6. Festplatten verschlüsseln bzw. bei Entsorgung sicher löschen.
7. Druckspooler auf Servern abschalten, die nicht drucken müssen (vor allem DCs).

## Peripherie allgemein

- **USB-Geräte** per Richtlinie einschränken (nur freigegebene Gerätetypen/IDs), Autorun aus.
- **BadUSB**: Geräte, die sich als Tastatur ausgeben und Befehle tippen – Gerätesteuerung und Sensibilisierung.
- **Docking-Stationen, Konferenztechnik**: ebenfalls Firmware und Netzwerkzugang beachten.

## Tiefer eingetaucht

In Pentests sind Drucker oft der leise Weg zu ersten Domänen-Anmeldedaten (über gespeicherte Konten). Für Verteidiger heißt das: Inventar aller „Nicht-Computer“ im Netz (Drucker, Kameras, Telefone, Gebäudetechnik), Segmentierung und Überwachung – sie sind Teil der Angriffsfläche wie jeder Server.

## Quiz

? Warum sind Multifunktionsdrucker sicherheitsrelevant?
+ sie sind kleine Server mit gespeicherten Zugangsdaten und Daten
- weil sie viel Papier verbrauchen
- weil sie laut sind
- weil sie keine Netzwerkverbindung haben
! Und werden selten gepatcht.

? Was ist ein LDAP-Passback-Angriff?
+ der Drucker schickt gespeicherte Anmeldedaten an einen vom Angreifer gewählten Server
- ein Papierstau
- ein Angriff auf Toner
- eine Druckerwarteschlange
! Weboberfläche schützen und Standardpasswörter ändern.

?tf Druckspooler sollten auf Domain Controllern deaktiviert werden.
= wahr
! Der Spooler war Ursache mehrerer schwerer Lücken.

? Welche SNMP-Version sollte genutzt werden?
= SNMPv3
= v3
! v1/v2c übertragen Community-Strings im Klartext.

? Was ist BadUSB?
+ ein Gerät, das sich als Tastatur ausgibt und Befehle eintippt
- ein defekter USB-Stick
- ein zu langsamer USB-Anschluss
- ein USB-Kabel ohne Abschirmung
! Gerätesteuerung schränkt erlaubte Gerätetypen ein.
