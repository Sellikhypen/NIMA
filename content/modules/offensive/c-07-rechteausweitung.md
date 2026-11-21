---
id: c-07
title: Rechteausweitung verstehen – Linux und Windows
paths: cpts, cjca
order: 7
difficulty: hard
icon: arrow.up.right.circle
summary: Die Klassen von Fehlkonfigurationen, die zu Rechteausweitung führen, wie man ein System systematisch bewertet und wie man genau diese Schwachstellen härtet und überwacht.
htb: Linux Privilege Escalation
---

## Was ist Rechteausweitung?

**[[Privilege Escalation]]** bedeutet, von einem Konto mit wenigen Rechten zu einem mit mehr Rechten zu gelangen – bis hin zu `root` bzw. `SYSTEM`. Sie ist fast immer nötig, um aus einem ersten Zugang einen echten Schaden zu machen. Für Verteidiger heißt das: Wer Rechteausweitung verhindert, entschärft viele Angriffe.

| Richtung | Beispiel |
|---|---|
| vertikal | normaler Benutzer → Administrator |
| horizontal | Benutzer A → Benutzer B mit anderen Daten |

## Die Klassen – Linux

| Klasse | Was schiefgelaufen ist | Härtung |
|---|---|---|
| zu weite **sudo**-Regeln | Programme mit Root-Rechten erlaubt, die selbst Befehle ausführen können | exakt definierte Befehle, keine Interpreter/Editoren |
| **SUID/SGID**-Programme | unnötige oder missbrauchbare Programme mit Besitzerrechten | Liste regelmäßig prüfen, unnötige Bits entfernen |
| **Capabilities** | Teilrechte wie `cap_setuid` an Interpretern | nur bei echtem Bedarf vergeben |
| beschreibbare **Cronjobs/Skripte** | root führt eine Datei aus, die andere ändern dürfen | Rechte von Skripten und Verzeichnissen prüfen |
| **PATH**-Probleme | privilegierte Programme rufen andere ohne absoluten Pfad auf | absolute Pfade, sichere Umgebung |
| Gruppen wie `docker`, `lxd`, `disk` | Gruppenmitgliedschaft entspricht faktisch root | Mitgliedschaften minimieren |
| Zugangsdaten in Dateien | Passwörter in Konfigurationen, History, Backups | Secret-Management, Rechte, Bereinigung |
| veralteter **Kernel** | bekannte Kernel-Schwachstellen | Patchen, Neustart einplanen |
| NFS mit `no_root_squash` | root auf Client = root auf der Freigabe | `root_squash` |

## Die Klassen – Windows

| Klasse | Was schiefgelaufen ist | Härtung |
|---|---|---|
| gefährliche **Privilegien** (z. B. SeImpersonate, SeBackup, SeDebug) | Dienst- oder Benutzerkonten haben zu viele Rechte | Dienstkonten mit minimalen Rechten, virtuelle Konten |
| Dienst-Fehlkonfigurationen | beschreibbare Dienstbinaries, unquoted service paths, zu weite Dienstrechte | Pfade in Anführungszeichen, ACLs prüfen |
| **AlwaysInstallElevated** | MSI-Pakete werden immer mit SYSTEM-Rechten installiert | Richtlinie deaktivieren |
| gespeicherte Anmeldedaten | Unattend-Dateien, Skripte, Registry, Anmeldeinformationsverwaltung | bereinigen, LAPS, gMSA |
| DLL-Suchreihenfolge | Programme laden Bibliotheken aus beschreibbaren Pfaden | sichere Verzeichnisrechte |
| fehlende Updates | bekannte lokale Schwachstellen | Patch-Management |
| geplante Aufgaben | privilegierte Aufgaben führen beschreibbare Dateien aus | Rechte prüfen |

## Systematisch bewerten

Gute Prüfer gehen immer gleich vor – und gute Administratoren prüfen ihre Systeme mit derselben Liste:

1. **Wer bin ich?** Benutzer, Gruppen, Privilegien
2. **Was ist das System?** Version, Patchstand, Rolle
3. **Was darf ich?** sudo-Regeln, besondere Rechte
4. **Was läuft?** Prozesse, Dienste, geplante Aufgaben – und unter welchem Konto
5. **Was ist beschreibbar?** Dateien und Verzeichnisse, die privilegiert genutzt werden
6. **Was liegt herum?** Konfigurationen, Skripte, Backups, History mit Zugangsdaten
7. **Was ist erreichbar?** nur lokal lauschende Dienste, interne Netze

Automatisierte Prüfskripte (z. B. aus der PEASS-ng-Sammlung, Seatbelt, PowerUp für Windows-Audits) beschleunigen das, ersetzen aber nicht das Verständnis der Ergebnisse.

## Erkennung

| Signal | Quelle |
|---|---|
| neue SUID-Dateien, geänderte sudoers | File Integrity Monitoring (z. B. Wazuh) |
| Prozesse mit Root/SYSTEM, deren Elternprozess ein Webserver oder Benutzerprozess ist | EDR, Sysmon, auditd |
| neue Dienste, geplante Aufgaben | Event IDs 7045, 4698 |
| Änderungen an Gruppenmitgliedschaften | 4728/4732, `/etc/group` |

## Quiz

? Wie nennt man den Wechsel von einem normalen Benutzer zum Administrator?
= vertikale Rechteausweitung
= vertikal

? Warum ist die Mitgliedschaft in der Gruppe docker kritisch?
+ Sie entspricht faktisch Root-Rechten auf dem Host
- Sie verlangsamt das System
- Sie deaktiviert die Firewall
- Sie ist nicht kritisch

? Welche NFS-Einstellung verhindert, dass root auf dem Client root auf der Freigabe ist?
= root_squash

? Wie heißt die Windows-Schwachstelle, bei der Dienstpfade mit Leerzeichen ohne Anführungszeichen stehen?
= Unquoted Service Path

? Welche Windows-Richtlinie lässt MSI-Pakete immer mit SYSTEM-Rechten installieren?
= AlwaysInstallElevated

? Welche Event ID zeigt, dass eine geplante Aufgabe erstellt wurde?
= 4698

?order Bringe die ersten Schritte einer systematischen Bewertung in Reihenfolge
> Wer bin ich? (Benutzer, Gruppen, Privilegien)
> Was ist das System? (Version, Patchstand)
> Was darf ich? (sudo, Sonderrechte)
> Was läuft? (Prozesse, Dienste, Aufgaben)

?tf Ein veralteter Kernel kann zur Rechteausweitung führen.
= wahr
