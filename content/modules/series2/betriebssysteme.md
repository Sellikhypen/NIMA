---
id: os-01
title: Betriebssysteme 1 · systemd verstehen und absichern
paths: grundlagen, specialist, cdsa
order: 24.1
difficulty: medium
icon: gearshape.2.fill
tags: linux, systemd, härtung
summary: Units, Targets, Timer und das Journal – und wie man Dienste mit systemd-Sandboxing-Optionen stark einschränkt.
---

## Einfach erklärt

**systemd** ist der Hausmeister moderner Linux-Systeme: Er startet beim Hochfahren alle Dienste in der richtigen Reihenfolge, startet abgestürzte neu, führt Zeitpläne aus und führt Buch (Journal). Wer systemd versteht, versteht, was auf einem Linux-Server läuft – und wo sich Angreifer einnisten könnten.

## Grundbegriffe

| Begriff | Bedeutung |
|---|---|
| Unit | Konfigurationseinheit: `.service`, `.timer`, `.socket`, `.mount` |
| Target | Gruppe von Units (z. B. `multi-user.target`) |
| Timer | moderner Ersatz für Cron |
| Journal | zentrales Log (`journalctl`) |

```bash
systemctl status ssh
systemctl list-units --type=service --state=running
systemctl list-timers
journalctl -u ssh --since "1 hour ago"
systemd-analyze security nginx.service
```

## Dienste einsperren

systemd bietet eingebaute Sandboxing-Optionen:

```ini
[Service]
User=webapp
NoNewPrivileges=yes
ProtectSystem=strict
ProtectHome=yes
PrivateTmp=yes
PrivateDevices=yes
ReadWritePaths=/var/lib/webapp
CapabilityBoundingSet=
RestrictAddressFamilies=AF_INET AF_INET6
SystemCallFilter=@system-service
```

> [!TIPP] Bewertung per Befehl
> `systemd-analyze security <dienst>` bewertet die Absicherung eines Dienstes und zeigt, welche Optionen fehlen.

## Tiefer eingetaucht

Persistenz über systemd ist bei Angreifern beliebt: eine neue `.service`-Datei in `/etc/systemd/system/` oder als **User-Unit** in `~/.config/systemd/user/` (läuft ohne root!), ein Timer statt Cronjob, oder eine geänderte bestehende Unit (`ExecStart` umgebogen, Drop-in-Dateien in `*.service.d/`).

Erkennung: Dateiintegritätsüberwachung für Unit-Verzeichnisse, auditd-Regeln (`-w /etc/systemd/system -p wa`), regelmäßiger Vergleich von `systemctl list-unit-files` mit einer Baseline, Alarme bei neuen Diensten mit ausführbaren Dateien in `/tmp`, `/dev/shm` oder Home-Verzeichnissen.

## Quiz

? Mit welchem Befehl zeigt man das Log eines bestimmten Dienstes?
= journalctl -u
= journalctl -u dienst
! Mit --since lässt sich der Zeitraum eingrenzen.

? Was ist der systemd-Ersatz für Cronjobs?
+ Timer
- Targets
- Sockets
- Slices
! systemctl list-timers zeigt alle geplanten Ausführungen.

? Welcher Befehl bewertet die Sandboxing-Absicherung eines Dienstes?
= systemd-analyze security
! Er vergibt eine Expositionsbewertung und listet fehlende Optionen.

?tf User-Units in ~/.config/systemd/user/ können ohne root-Rechte Persistenz schaffen.
= wahr
! Sie laufen im Kontext des Benutzers.

? Welche Option verhindert, dass ein Dienst neue Privilegien erhält (z. B. über SUID)?
= NoNewPrivileges=yes
= NoNewPrivileges
! Eine der wirksamsten Einzeloptionen.

? Was bewirkt ProtectSystem=strict?
+ das gesamte Dateisystem ist für den Dienst schreibgeschützt, außer explizit erlaubten Pfaden
- der Dienst startet nicht
- der Dienst läuft als root
- Logs werden gelöscht
! Mit ReadWritePaths gibt man gezielt Pfade frei.

@@@ MODULE @@@
---
id: os-02
title: Betriebssysteme 2 · SELinux und AppArmor
paths: specialist, cdsa
order: 24.2
difficulty: hard
icon: lock.square.stack.fill
tags: linux, mac, härtung
summary: Mandatory Access Control unter Linux – wie SELinux und AppArmor Prozesse auch dann einschränken, wenn klassische Rechte es erlauben würden.
---

## Einfach erklärt

Klassische Linux-Rechte fragen: **Wem gehört die Datei?** Root darf alles. **Mandatory Access Control** (MAC) fragt zusätzlich: **Was darf dieses Programm überhaupt?** Selbst wenn ein Webserver als root liefe, dürfte er laut MAC-Regel nur seine Webdateien lesen – nicht `/etc/shadow`.

Das ist wie ein Hotel, in dem nicht nur die Schlüsselkarte zählt, sondern auch die Rolle: Der Koch kommt mit dem Generalschlüssel trotzdem nicht in die Buchhaltung.

## SELinux (RHEL, Fedora, Android)

- Arbeitet mit **Labels** (Kontexten) an Prozessen und Dateien: `system_u:object_r:httpd_sys_content_t:s0`.
- Regeln legen fest, welcher Prozess-Typ auf welchen Datei-Typ wie zugreifen darf.
- Modi: `enforcing`, `permissive` (nur protokollieren), `disabled`.

```bash
getenforce
ls -Z /var/www/html
ausearch -m AVC -ts recent
restorecon -Rv /var/www/html
setsebool -P httpd_can_network_connect on
```

## AppArmor (Ubuntu, Debian, SUSE)

- Arbeitet mit **Pfad-basierten Profilen** pro Programm.
- Modi: `enforce` und `complain`.

```bash
aa-status
aa-complain /etc/apparmor.d/usr.sbin.nginx
aa-enforce /etc/apparmor.d/usr.sbin.nginx
```

> [!WARNUNG] Nicht einfach abschalten
> „SELinux deaktivieren“ ist eine verbreitete, aber schlechte Lösung bei Problemen. Besser: Ursache in den AVC-Logs finden, Kontext korrigieren oder Boolean setzen.

## Tiefer eingetaucht

MAC begrenzt den Schaden nach einer erfolgreichen Ausnutzung: Eine Lücke im Webserver führt dann nicht automatisch zum Zugriff auf andere Daten oder zum Ausbruch. Container-Plattformen nutzen das ebenfalls (SELinux-Labels pro Container bei Podman/OpenShift, AppArmor-Profile bei Docker).

Für Analysten sind **AVC-Denials** wertvoll: Ein verweigerter Zugriff eines Webservers auf ungewöhnliche Pfade kann auf einen Angriffsversuch hindeuten – MAC wird so auch zur Erkennungsquelle.

## Quiz

? Was unterscheidet MAC von klassischen Linux-Rechten?
+ Regeln gelten pro Programm bzw. Typ, unabhängig vom Dateibesitzer
- MAC gilt nur für root
- MAC ersetzt Passwörter
- MAC verschlüsselt Dateien
! Auch root-Prozesse werden eingeschränkt.

? Mit welchem Befehl zeigt man den SELinux-Modus an?
= getenforce
! enforcing, permissive oder disabled.

? Wie heißt der Modus, in dem SELinux nur protokolliert, aber nicht blockiert?
= permissive
! Bei AppArmor heißt das Pendant complain.

? Wie stellt man die korrekten SELinux-Kontexte für Dateien wieder her?
= restorecon
= restorecon -Rv
! Häufig nötig nach dem Verschieben von Dateien.

?tf SELinux bei Problemen dauerhaft zu deaktivieren ist die empfohlene Lösung.
= falsch
! Ursache in den AVC-Logs suchen und gezielt anpassen.

? Womit arbeitet AppArmor hauptsächlich?
+ pfadbasierten Profilen pro Programm
- Labels an jedem Objekt
- Firewall-Regeln
- Benutzergruppen
! SELinux nutzt dagegen Labels bzw. Kontexte.

@@@ MODULE @@@
---
id: os-03
title: Betriebssysteme 3 · Linux-Firewall mit nftables und ufw
paths: grundlagen, specialist, cyberrange
order: 24.3
difficulty: medium
icon: flame.fill
tags: linux, firewall, nftables
summary: Wie Netfilter Pakete verarbeitet, wie nftables-Regelwerke aufgebaut sind und wie man einen Server schnell und sicher abschottet.
---

## Einfach erklärt

Jeder Linux-Server hat einen eingebauten Türsteher im Kernel: **Netfilter**. Mit **nftables** (modern) oder der Vereinfachung **ufw** sagt man ihm, wer herein darf. Die goldene Regel: **Alles verbieten, was nicht ausdrücklich erlaubt ist** (Default Deny).

## ufw – schnell und einfach

```bash
ufw default deny incoming
ufw default allow outgoing
ufw allow from 10.0.5.0/24 to any port 22 proto tcp
ufw allow 443/tcp
ufw enable
ufw status verbose
```

## nftables – das vollständige Werkzeug

```text
table inet filter {
  chain input {
    type filter hook input priority 0; policy drop;
    ct state established,related accept
    iif "lo" accept
    ip saddr 10.0.5.0/24 tcp dport 22 accept
    tcp dport { 80, 443 } accept
    icmp type echo-request limit rate 5/second accept
    log prefix "nft-drop: " counter drop
  }
  chain output {
    type filter hook output priority 0; policy accept;
  }
}
```

| Element | Bedeutung |
|---|---|
| table | Container (Familie `inet` = IPv4 + IPv6) |
| chain mit hook | Einhängepunkt im Paketfluss (input, output, forward, prerouting, postrouting) |
| policy | Standardaktion |
| `ct state established,related` | Antworten auf bestehende Verbindungen erlauben (stateful) |

> [!WARNUNG] Nicht aussperren
> Bei Arbeiten per SSH zuerst die SSH-Regel setzen, dann die Policy auf drop. Ein Notfall-Zugang (Konsole, Out-of-Band) sollte bereitstehen.

## Tiefer eingetaucht

**Egress-Filter** (ausgehend) werden oft vergessen: Ein Webserver muss selten beliebige Ziele im Internet erreichen. Eine restriktive Output-Chain erschwert Reverse Shells, Datenabfluss und das Nachladen von Werkzeugen.

Weitere Praxis: Regeln versionieren (Datei in Git, Laden mit `nft -f`), Sets und Maps für große Listen, Rate-Limits gegen Brute Force, Logging gezielt und begrenzt. Docker und Kubernetes manipulieren Netfilter selbst – eigene Regeln müssen damit zusammenspielen (z. B. Docker-Chain `DOCKER-USER`).

## Quiz

? Wie heißt das Paketfilter-Framework im Linux-Kernel?
= Netfilter
! nftables und iptables sind Werkzeuge, um es zu konfigurieren.

? Was bedeutet „Default Deny“?
+ alles ist verboten, was nicht ausdrücklich erlaubt ist
- alles ist erlaubt
- nur Ping ist verboten
- nur ausgehender Verkehr ist erlaubt
! Die sicherste Grundhaltung für Firewalls.

? Welche nftables-Familie deckt IPv4 und IPv6 gemeinsam ab?
= inet
! ip und ip6 wären getrennte Familien.

?tf Bei Arbeiten per SSH sollte man zuerst die SSH-Regel anlegen und dann die Policy auf drop setzen.
= wahr
! Sonst sperrt man sich selbst aus.

? Wozu dient `ct state established,related accept`?
+ Antworten auf bestehende Verbindungen zulassen
- alle neuen Verbindungen erlauben
- ICMP blockieren
- Logs löschen
! Das macht die Firewall stateful.

? Warum lohnt sich ein Egress-Filter auf Servern?
+ er erschwert Reverse Shells und Datenabfluss
- er beschleunigt den Server
- er ersetzt Updates
- er verhindert Stromausfälle
! Server brauchen selten beliebige Ziele im Internet.

@@@ MODULE @@@
---
id: os-04
title: Betriebssysteme 4 · Dateisystem-Hierarchie und Mounts unter Linux
paths: grundlagen, cjca, cpts
order: 24.4
difficulty: easy
icon: folder.fill.badge.gearshape
tags: linux, dateisystem
summary: Wo unter Linux was liegt, welche Verzeichnisse sicherheitsrelevant sind und welche Mount-Optionen Angriffe erschweren.
---

## Einfach erklärt

Unter Linux gibt es keine Laufwerksbuchstaben. Alles hängt an einem einzigen Baum, der bei `/` beginnt. Andere Festplatten, USB-Sticks oder Netzfreigaben werden an Ästen dieses Baums **eingehängt** (gemountet). Wer weiß, welcher Ast wofür da ist, findet Konfigurationen, Logs und Spuren sofort.

## Die wichtigsten Verzeichnisse

| Pfad | Inhalt | Sicherheitsrelevanz |
|---|---|---|
| `/etc` | Konfiguration | Passwortdateien, sudoers, SSH, Dienste |
| `/var/log` | Logs | Spuren, Anmeldungen |
| `/home`, `/root` | Benutzerdaten | SSH-Schlüssel, History, Konfigurationen |
| `/tmp`, `/var/tmp`, `/dev/shm` | temporär, für alle beschreibbar | beliebtes Versteck für Werkzeuge |
| `/usr/bin`, `/usr/sbin` | Programme | manipulierte Binärdateien? |
| `/opt` | Zusatzsoftware | oft schlechter gepflegt |
| `/proc` | Prozess- und Kerninformationen | Kommandozeilen, Umgebungsvariablen |
| `/var/www` | Webinhalte | Webshells |
| `/boot` | Kernel, Bootloader | Integrität beim Start |

## Mount-Optionen als Schutz

```text
/dev/sdb1  /tmp     ext4  defaults,nodev,nosuid,noexec  0 2
tmpfs      /dev/shm tmpfs defaults,nodev,nosuid,noexec  0 0
```

| Option | Wirkung |
|---|---|
| `noexec` | keine Programme direkt von dort ausführen |
| `nosuid` | SUID-Bits werden ignoriert |
| `nodev` | keine Gerätedateien |
| `ro` | nur lesbar |

> [!TIPP] /tmp mit noexec
> Viele automatisierte Angriffe laden Werkzeuge nach `/tmp` und starten sie dort. `noexec` hält einen Teil davon auf – ist aber kein vollständiger Schutz (Interpreter können Skripte trotzdem lesen).

## Tiefer eingetaucht

Forensisch interessant: `/proc/<PID>/exe` zeigt auf die laufende Binärdatei – auch wenn sie bereits gelöscht wurde (`(deleted)`), lässt sie sich von dort noch sichern. `/proc/<PID>/cmdline` und `/proc/<PID>/environ` zeigen Kommandozeile und Umgebung. Versteckte Dateien (Punkt am Anfang) und unauffällige Namen („`...`“, Leerzeichen) in `/tmp` oder `/dev/shm` sind klassische Verstecke.

Netzwerk-Mounts (NFS, SMB/CIFS) bringen eigene Risiken: `no_root_squash` auf NFS, Zugangsdaten in `/etc/fstab` im Klartext (besser: Credentials-Datei mit Rechten 600).

## Quiz

? Wo liegen unter Linux die meisten Konfigurationsdateien?
= /etc
! Zum Beispiel /etc/ssh/sshd_config oder /etc/sudoers.

? Welche Mount-Option verhindert das direkte Ausführen von Programmen?
= noexec
! Häufig für /tmp und /dev/shm genutzt.

? Welche Verzeichnisse sind für alle beschreibbar und daher beliebte Verstecke?
+ /tmp
+ /dev/shm
+ /var/tmp
- /boot
! Dort legen Angreifer gerne Werkzeuge ab.

?tf Über /proc/PID/exe kann man eine bereits gelöschte, aber noch laufende Binärdatei sichern.
= wahr
! Der Kernel hält die Datei, solange der Prozess läuft.

? Was bewirkt die Mount-Option nosuid?
+ SUID- und SGID-Bits werden ignoriert
- Dateien werden verschlüsselt
- der Mount ist schreibgeschützt
- Gerätedateien werden erlaubt
! Verhindert Rechteausweitung über SUID-Programme auf diesem Mount.

? Wo findet man die Kommandozeile eines laufenden Prozesses?
= /proc/PID/cmdline
= /proc/<PID>/cmdline
! Die Argumente sind durch Nullbytes getrennt.

@@@ MODULE @@@
---
id: os-05
title: Betriebssysteme 5 · Die Windows-Registry vertieft
paths: grundlagen, cdsa, cpts
order: 24.5
difficulty: medium
icon: cylinder.split.1x2.fill
tags: windows, registry, forensik
summary: Aufbau der Registry, Hives, wichtige Schlüssel für Autostart, Dienste, Sicherheit und Forensik – und wie man Änderungen überwacht.
---

## Einfach erklärt

Die Registry ist das zentrale Notizbuch von Windows: Hier stehen Einstellungen, installierte Programme, Dienste, zuletzt geöffnete Dateien, angeschlossene USB-Sticks und vieles mehr. Für Admins ist sie ein Werkzeug, für Angreifer ein Versteck – und für Forensiker eine Schatzkiste.

## Aufbau

| Root-Key | Inhalt |
|---|---|
| `HKLM` | maschinenweite Einstellungen |
| `HKCU` | Einstellungen des angemeldeten Nutzers |
| `HKU` | alle geladenen Benutzerprofile |
| `HKCR` | Dateizuordnungen, COM-Klassen |
| `HKCC` | aktuelles Hardwareprofil |

Gespeichert wird in **Hive-Dateien**: `C:\Windows\System32\config\` (SYSTEM, SOFTWARE, SAM, SECURITY) und `NTUSER.DAT`/`UsrClass.dat` im Benutzerprofil.

## Wichtige Schlüssel

| Zweck | Schlüssel |
|---|---|
| Autostart | `…\Microsoft\Windows\CurrentVersion\Run`, `RunOnce` (HKLM und HKCU) |
| Dienste | `HKLM\SYSTEM\CurrentControlSet\Services` |
| Anmeldeprozess | `…\Windows NT\CurrentVersion\Winlogon` (Shell, Userinit) |
| Image File Execution Options | `…\Image File Execution Options` (Debugger-Umleitung) |
| USB-Geräte | `HKLM\SYSTEM\CurrentControlSet\Enum\USBSTOR` |
| Zuletzt verwendet | `NTUSER.DAT\…\Explorer\RecentDocs`, `UserAssist` |

> [!MERKE] Autostart-Orte gibt es dutzende
> Run-Keys sind nur der bekannteste Ort. Werkzeuge wie Sysinternals **Autoruns** zeigen alle Autostart-Stellen auf einen Blick – ideal für Untersuchungen.

## Tiefer eingetaucht

Überwachung: Sysmon-Events 12/13/14 für ausgewählte Schlüssel, SACLs mit Event 4657, EDR-Telemetrie. Typische Angreiferspuren: neue Werte in Run-Keys mit Pfaden in `AppData`/`Temp`, geänderte `Winlogon`-Werte, `IFEO`-Debugger-Einträge für Bedienungshilfen (z. B. `sethc.exe`), deaktivierte Sicherheitsfunktionen (Defender-Richtlinien unter `Policies`).

Forensisch werden Hives offline mit Werkzeugen wie Registry Explorer oder RegRipper ausgewertet. Die **LastWrite-Zeit** eines Schlüssels zeigt, wann er zuletzt geändert wurde – hilfreich für Zeitleisten. Transaktionsprotokolle (`.LOG1/.LOG2`) enthalten ggf. noch nicht eingepflegte Änderungen.

## Quiz

? Welcher Root-Key enthält maschinenweite Einstellungen?
= HKLM
= HKEY_LOCAL_MACHINE
! HKCU betrifft den aktuellen Benutzer.

? In welcher Datei liegt der Benutzerteil der Registry?
= NTUSER.DAT
! Im Profilverzeichnis jedes Benutzers.

? Welcher Schlüssel ist ein klassischer Autostart-Ort?
+ …\CurrentVersion\Run
- …\Control Panel\Desktop
- …\Fonts
- …\Keyboard Layout
! Sowohl unter HKLM als auch unter HKCU.

? Welches Sysinternals-Werkzeug zeigt alle Autostart-Orte?
= Autoruns
! Inklusive Diensten, Treibern, geplanten Aufgaben und mehr.

?tf Die LastWrite-Zeit eines Registry-Schlüssels hilft bei der Erstellung von Zeitleisten.
= wahr
! Sie zeigt den Zeitpunkt der letzten Änderung des Schlüssels.

? Wo sind Windows-Dienste in der Registry konfiguriert?
= HKLM\SYSTEM\CurrentControlSet\Services
! Jeder Dienst hat dort einen Unterschlüssel mit ImagePath, Start-Typ usw.

@@@ MODULE @@@
---
id: os-06
title: Betriebssysteme 6 · Microsoft Defender, ASR und Application Control
paths: specialist, cdsa
order: 24.6
difficulty: medium
icon: shield.righthalf.filled
tags: windows, defender, härtung
summary: Wie man die eingebauten Windows-Schutzfunktionen voll ausschöpft – Defender-Konfiguration, Attack Surface Reduction, Tamper Protection, WDAC und AppLocker.
---

## Einfach erklärt

Windows bringt eine ganze Sicherheitsabteilung mit – viele Funktionen sind aber nicht oder nur teilweise eingeschaltet. **Defender** erkennt Schadsoftware, **ASR-Regeln** verbieten typische Angriffstricks (z. B. „Office darf keine Programme starten“), und **Application Control** erlaubt nur bekannte Programme.

## Defender-Grundkonfiguration

- Echtzeitschutz und **Cloud-Schutz** (schnelle Erkennung neuer Malware)
- **Tamper Protection** – verhindert Abschalten durch Schadsoftware
- **PUA-Schutz** gegen unerwünschte Programme
- **Netzwerkschutz** gegen bösartige Domains
- **Controlled Folder Access** gegen Ransomware in Dokumentordnern

## Attack Surface Reduction (Auswahl)

| Regel | Verhindert |
|---|---|
| Office-Apps dürfen keine Kindprozesse erstellen | Makro-Malware |
| Ausführbare Inhalte aus E-Mail blockieren | Anhänge-Malware |
| Credential-Diebstahl aus LSASS blockieren | Credential Dumping |
| Verschleierte Skripte blockieren | getarnte JS/VBS/PS |
| Prozesse aus PSExec/WMI blockieren | bestimmte Lateral-Movement-Techniken |
| Ungesignierte Prozesse von USB blockieren | USB-Malware |

> [!TIPP] Erst Audit, dann Block
> ASR-Regeln im **Audit-Modus** starten, Ereignisse (1121/1122) auswerten, Ausnahmen gezielt setzen, dann blockieren.

## Application Control

- **AppLocker**: Regeln nach Pfad, Herausgeber, Hash – einfacher, aber umgehbar.
- **WDAC / App Control for Business**: im Kernel durchgesetzt, robuster; Basis-Policies von Microsoft als Startpunkt.
- Ziel: Nutzer können nur genehmigte Software ausführen; Werkzeuge aus `Downloads` oder `Temp` starten nicht.

## Tiefer eingetaucht

Wirksamkeit messen: Defender-Status per `Get-MpComputerStatus`, ASR-Ereignisse im SIEM, Abdeckung (alle Geräte mit aktuellem Schutz?). **EDR im Block-Modus** sorgt dafür, dass auch bei Drittanbieter-Antivirus Defender-Erkennungen eingreifen.

Grenzen: Angreifer mit Admin-Rechten versuchen Ausnahmen hinzuzufügen oder Schutz abzuschalten – Tamper Protection, zentrale Verwaltung und Alarme bei Konfigurationsänderungen (Event 5001/5007) halten dagegen.

## Quiz

? Was verhindert Tamper Protection?
+ dass Schadsoftware oder Nutzer Defender-Schutz abschalten
- dass Updates installiert werden
- dass Nutzer drucken
- dass Netzwerkverbindungen entstehen
! Einstellungen lassen sich nur zentral ändern.

? Welche ASR-Regel richtet sich gegen Makro-Malware?
+ Office-Apps dürfen keine Kindprozesse erstellen
- USB-Geräte blockieren
- Bildschirmsperre erzwingen
- Druckaufträge protokollieren
! Word, das PowerShell startet, wird dann blockiert.

? Wie sollte man ASR-Regeln einführen?
+ zuerst im Audit-Modus
- sofort alle blockierend
- gar nicht
- nur auf Servern
! So findet man Fehlalarme vor der Durchsetzung.

? Welche Application-Control-Lösung wird im Kernel durchgesetzt und gilt als robuster?
= WDAC
= App Control for Business
= Windows Defender Application Control
! AppLocker ist einfacher, aber leichter zu umgehen.

?tf Controlled Folder Access schützt Dokumentordner vor unbefugten Änderungen, z. B. durch Ransomware.
= wahr
! Nur vertrauenswürdige Programme dürfen dort schreiben.

? Welches Cmdlet zeigt den Defender-Status?
= Get-MpComputerStatus
! Zeigt u. a. Signaturstand und aktivierte Schutzfunktionen.

@@@ MODULE @@@
---
id: os-07
title: Betriebssysteme 7 · BitLocker, TPM und Festplattenverschlüsselung
paths: specialist, grundlagen
order: 24.7
difficulty: medium
icon: lock.laptopcomputer
tags: verschlüsselung, windows, tpm
summary: Wie Festplattenverschlüsselung Daten bei Verlust schützt, welche Rolle TPM und PIN spielen und wie Wiederherstellungsschlüssel sicher verwaltet werden.
---

## Einfach erklärt

Ein gestohlener Laptop ist ärgerlich. Ein gestohlener Laptop mit unverschlüsselten Kundendaten ist ein Datenschutzvorfall. **Festplattenverschlüsselung** sorgt dafür, dass ein Dieb nur Zeichensalat findet – selbst wenn er die Festplatte ausbaut.

## Bausteine

| Baustein | Aufgabe |
|---|---|
| BitLocker (Windows), FileVault (macOS), LUKS (Linux) | Verschlüsselung des Laufwerks |
| TPM | Sicherheitschip, der den Schlüssel nur bei unverändertem Startvorgang freigibt |
| PIN beim Start | zusätzlicher Faktor vor dem Booten |
| Wiederherstellungsschlüssel | Notfallschlüssel, z. B. bei Hardwaretausch |

## Schutzmodi bei BitLocker

| Modus | Schutz |
|---|---|
| nur TPM | bequem, schützt bei ausgebauter Platte; schwächer gegen gezielte Hardwareangriffe |
| TPM + PIN | deutlich stärker – ohne PIN kein Schlüssel |
| TPM + Startschlüssel (USB) | Besitzfaktor |

> [!WARNUNG] Wiederherstellungsschlüssel sicher ablegen
> Ohne Wiederherstellungsschlüssel sind Daten bei einem Problem verloren. Mit einem schlecht geschützten Schlüssel ist die Verschlüsselung wertlos. Zentral speichern (AD, Entra ID, MDM) und Zugriffe protokollieren.

## Tiefer eingetaucht

Bekannte Angriffsklassen (konzeptionell): Abgreifen des Schlüssels auf dem Bus zwischen separatem TPM-Chip und CPU bei reinem TPM-Modus, Kaltstart-Angriffe auf den Arbeitsspeicher, DMA-Angriffe über Schnittstellen. Gegenmittel: Pre-Boot-PIN, Kernel-DMA-Schutz, firmwarebasierte TPMs, Ruhezustand statt Standby auf Reisen.

Festplattenverschlüsselung schützt **ausgeschaltete** Geräte. Im laufenden, entsperrten Betrieb sind Daten für jeden Prozess mit Rechten lesbar – sie ersetzt also keine Zugriffskontrolle und keinen Malware-Schutz. Für Server in Rechenzentren und Cloud schützt sie vor allem bei Hardwareentsorgung und Diebstahl.

## Quiz

? Wovor schützt Festplattenverschlüsselung hauptsächlich?
+ vor dem Auslesen der Daten bei Verlust oder Diebstahl des ausgeschalteten Geräts
- vor Phishing
- vor Malware im laufenden Betrieb
- vor DDoS-Angriffen
! Im entsperrten Betrieb sind Daten für berechtigte Prozesse lesbar.

? Welcher Chip gibt den BitLocker-Schlüssel nur bei unverändertem Startvorgang frei?
= TPM
= Trusted Platform Module
! Er misst den Startvorgang.

? Welcher BitLocker-Modus bietet deutlich stärkeren Schutz als nur TPM?
+ TPM + PIN
- ohne TPM und ohne Passwort
- nur Wiederherstellungsschlüssel auf dem Desktop
- deaktiviert
! Ohne PIN wird der Schlüssel nicht freigegeben.

?tf Wiederherstellungsschlüssel sollten zentral und geschützt gespeichert werden.
= wahr
! Z. B. in AD, Entra ID oder dem MDM – mit Protokollierung.

? Wie heißt die Festplattenverschlüsselung unter macOS?
= FileVault
! Unter Linux ist LUKS verbreitet.

? Welche Angriffsklasse betrifft den Arbeitsspeicher kurz nach dem Ausschalten?
= Kaltstart-Angriff
= Cold Boot
= Cold-Boot-Angriff
! RAM-Inhalte verblassen nicht sofort.

@@@ MODULE @@@
---
id: os-08
title: Betriebssysteme 8 · macOS-Sicherheit verstehen
paths: specialist, cdsa
order: 24.8
difficulty: medium
icon: apple.logo
tags: macos, endpoint
summary: Gatekeeper, Notarisierung, SIP, TCC, XProtect, FileVault und Logs – wie macOS schützt und wo Analysten nachsehen.
---

## Einfach erklärt

macOS hat mehrere Sicherheitsschichten eingebaut, die zusammenarbeiten wie Türsteher an verschiedenen Eingängen: Beim Herunterladen prüft **Gatekeeper**, ob ein Programm von einem bekannten Entwickler stammt; **SIP** schützt Systemdateien sogar vor root; **TCC** fragt nach, bevor Apps auf Kamera, Mikrofon oder Dokumente zugreifen.

## Die Schutzschichten

| Funktion | Aufgabe |
|---|---|
| Gatekeeper + Notarisierung | nur signierte, von Apple geprüfte Apps starten ohne Warnung |
| XProtect | eingebaute Malware-Erkennung |
| SIP (System Integrity Protection) | schützt Systembereiche, auch vor root |
| TCC (Transparency, Consent, Control) | Zustimmung für Kamera, Mikrofon, Bildschirmaufnahme, Dateien |
| FileVault | Festplattenverschlüsselung |
| Secure Enclave | geschützte Schlüssel, Touch ID |
| Signed System Volume | kryptografisch versiegeltes Systemvolume |

> [!WARNUNG] Nutzer klicken Warnungen weg
> Viele Mac-Malware-Fälle beginnen mit „Rechtsklick → Öffnen“ auf eine nicht notarisierte App oder mit gefälschten Installern, die um das Admin-Passwort bitten.

## Wo Analysten nachsehen

- **Persistenz**: `~/Library/LaunchAgents`, `/Library/LaunchAgents`, `/Library/LaunchDaemons`, Login Items, Konfigurationsprofile.
- **Unified Log**: `log show --predicate 'process == "sshd"' --last 1h`.
- **Quarantäne-Attribut**: `xattr -l datei` (`com.apple.quarantine` zeigt Download-Herkunft).
- **TCC-Datenbank**: welche App welche Berechtigungen hat.
- **Endpoint Security Framework**: Grundlage moderner EDRs auf macOS.

## Tiefer eingetaucht

Typische Bedrohungen: Infostealer (Passwörter, Browser-Cookies, Krypto-Wallets) über gefälschte Apps und Cracks, Adware, gezielte Angriffe auf Entwickler (manipulierte Pakete). Unternehmen verwalten Macs per **MDM**: Konfigurationsprofile erzwingen FileVault, Firewall, Updates und Einschränkungen; PPPC-Profile regeln TCC-Berechtigungen für Sicherheitssoftware.

## Quiz

? Welche macOS-Funktion prüft beim Start, ob eine App signiert und notarisiert ist?
= Gatekeeper
! Nicht notarisierte Apps lösen eine Warnung aus.

? Was schützt SIP?
+ Systembereiche, sogar vor Änderungen durch root
- nur Benutzerdokumente
- das WLAN-Passwort
- die Bildschirmhelligkeit
! System Integrity Protection.

? Wofür steht TCC?
= Transparency, Consent, and Control
= Transparency Consent and Control
! Steuert Zugriffe auf Kamera, Mikrofon, Dateien usw.

? Wo legen Programme unter macOS oft Persistenz an?
+ LaunchAgents und LaunchDaemons
- im Papierkorb
- im Dock
- in den Systemeinstellungen für Hintergrundbilder
! Plist-Dateien starten Programme automatisch.

?tf Das Attribut com.apple.quarantine zeigt, dass eine Datei heruntergeladen wurde.
= wahr
! Abrufbar mit xattr -l.

? Mit welchem Befehl durchsucht man das Unified Log?
= log show
! Mit --predicate lässt sich filtern.

@@@ MODULE @@@
---
id: os-09
title: Betriebssysteme 9 · Windows-Dienste und Dienstkonten richtig betreiben
paths: specialist, cpts, cdsa
order: 24.9
difficulty: medium
icon: person.crop.circle.badge.questionmark
tags: windows, dienste, dienstkonten
summary: LocalSystem, LocalService, NetworkService, virtuelle Konten, gMSA – welche Identität ein Dienst braucht und wie man Dienste sicher konfiguriert.
---

## Einfach erklärt

Jeder Windows-Dienst läuft unter einer Identität – wie ein Mitarbeiter mit Ausweis. Viele Dienste bekommen aus Bequemlichkeit den **Generalschlüssel** (LocalSystem oder ein Domain-Admin-Konto). Wird so ein Dienst angegriffen, hat der Angreifer sofort alle Rechte. Besser: jedem Dienst nur den Ausweis, den er wirklich braucht.

## Eingebaute Identitäten

| Konto | Rechte lokal | Im Netzwerk |
|---|---|---|
| LocalSystem | volle Rechte | als Computerkonto |
| LocalService | eingeschränkt | anonym |
| NetworkService | eingeschränkt | als Computerkonto |
| Virtuelles Konto (`NT SERVICE\Name`) | eingeschränkt, eigenes Profil | als Computerkonto |
| gMSA | wie zugewiesen | eigenes Domänenkonto mit automatisch rotiertem Passwort |

> [!MERKE] gMSA statt Benutzerkonto
> Group Managed Service Accounts haben 120-stellige, automatisch rotierte Passwörter. Kerberoasting wird praktisch wirkungslos, und niemand muss Passwörter verwalten.

## Sicher konfigurieren

1. Minimal nötige Identität wählen (virtuelles Konto oder gMSA).
2. **Dateirechte** auf die Dienst-Binärdatei und den Ordner: nur Admins dürfen schreiben.
3. **Dienst-ACL**: Nur Admins dürfen den Dienst konfigurieren (`sc sdshow`).
4. Pfade in Anführungszeichen (Unquoted Service Path vermeiden).
5. Dienstkonten **nicht interaktiv** nutzbar („Deny log on locally“).
6. Nicht benötigte Dienste deaktivieren.

## Tiefer eingetaucht

Dienstkonten sind oft die vergessenen Superuser einer Domäne: alte Konten mit nie ablaufendem Passwort, Mitglied in Domain Admins, Passwort im Wiki. Ein Inventar (welches Konto, welcher Dienst, welcher Server, welcher Owner) ist der erste Schritt; danach Migration zu gMSA, Rechte reduzieren, SPNs prüfen.

Erkennung: Anmeldungen von Dienstkonten außerhalb ihrer Server oder interaktiv (Logon Type 2/10) sind fast immer verdächtig; Änderungen an Diensten (Event 7040, 7045, 4697) und an Dienst-Registry-Schlüsseln überwachen.

## Quiz

? Welche Dienstidentität hat lokal volle Rechte?
= LocalSystem
! Sie sollte nur verwendet werden, wenn es wirklich nötig ist.

? Was ist der größte Vorteil eines gMSA?
+ automatisch rotiertes, sehr langes Passwort
- es braucht keine Domäne
- es hat immer Admin-Rechte
- es kann sich interaktiv anmelden
! Kerberoasting wird dadurch praktisch wirkungslos.

? Wie tritt LocalService im Netzwerk auf?
+ anonym
- als Domain Admin
- als Computerkonto
- als angemeldeter Benutzer
! NetworkService tritt dagegen als Computerkonto auf.

?tf Dienstkonten sollten sich nicht interaktiv anmelden können.
= wahr
! Interaktive Anmeldungen von Dienstkonten sind ein Warnsignal.

? Mit welchem Befehl zeigt man die Sicherheitsbeschreibung (ACL) eines Dienstes?
= sc sdshow
! Zeigt, wer den Dienst starten, stoppen oder konfigurieren darf.

? Welche Event-ID zeigt die Änderung des Starttyps eines Dienstes?
= 7040
! 7045 zeigt eine Neuinstallation.

@@@ MODULE @@@
---
id: os-10
title: Betriebssysteme 10 · Mobile Endgeräte und App-Berechtigungen
paths: specialist, wifi
order: 24.95
difficulty: easy
icon: iphone.gen3
tags: mobile, berechtigungen, mdm
summary: Wie iOS und Android Apps einschränken, welche Berechtigungen kritisch sind und wie Unternehmen Firmendaten auf Smartphones schützen.
---

## Einfach erklärt

Jede App auf dem Smartphone lebt in ihrem eigenen Zimmer (**Sandbox**). Will sie an Kamera, Standort, Kontakte oder Fotos, muss sie fragen – und du entscheidest. Viele Probleme entstehen, weil man diese Fragen zu schnell mit „Erlauben“ beantwortet.

## Kritische Berechtigungen

| Berechtigung | Risiko |
|---|---|
| Bedienungshilfen (Android Accessibility) | App kann Bildschirm lesen und Eingaben auslösen – beliebt bei Banking-Trojanern |
| Geräteadministrator / Profile | weitreichende Kontrolle |
| SMS lesen | Abfangen von Bestätigungscodes |
| Standort „immer“ | Bewegungsprofil |
| Mikrofon/Kamera | Abhören |
| Lokales Netzwerk | Scannen von Geräten im WLAN |
| Benachrichtigungen lesen | Mitlesen von Codes und Nachrichten |

> [!TIPP] Regelmäßig aufräumen
> Einmal im Quartal die Berechtigungen prüfen und ungenutzte Apps löschen. Beide Systeme zeigen inzwischen an, welche App wann Kamera oder Mikrofon genutzt hat.

## Unternehmen: MDM und App-Schutz

- **MDM** (Mobile Device Management): Geräte registrieren, Richtlinien (PIN, Verschlüsselung, Updates) durchsetzen, im Verlustfall sperren/löschen.
- **BYOD** (eigene Geräte): Android **Work Profile** bzw. iOS **User Enrollment** trennen Firmen- und Privatbereich.
- **MAM / App Protection Policies**: Firmendaten nur in verwalteten Apps, kein Kopieren in private Apps.
- **Conditional Access**: Zugriff auf Firmendaten nur von konformen Geräten.

## Tiefer eingetaucht

Bedrohungen: Apps aus inoffiziellen Quellen (Sideloading), Smishing-Links, gefälschte Banking-Apps, Stalkerware, Zero-Click-Exploits gegen besonders gefährdete Personen (Abwehr: schnelle Updates, Lockdown-Modus auf iOS). Jailbreak/Root schwächt die Sandbox grundlegend – MDM-Lösungen erkennen das und sperren Firmenzugriff.

## Quiz

? Welche Android-Berechtigung missbrauchen Banking-Trojaner besonders häufig?
+ Bedienungshilfen (Accessibility)
- Taschenlampe
- Vibration
- Bildschirmhelligkeit
! Damit können Apps Bildschirminhalte lesen und Eingaben auslösen.

? Wie heißt die Android-Funktion, die Firmen- und Privatbereich trennt?
= Work Profile
= Arbeitsprofil
! Auf iOS übernimmt User Enrollment eine ähnliche Rolle.

? Wofür steht MDM?
= Mobile Device Management
! Zentrale Verwaltung und Absicherung mobiler Geräte.

?tf Ein gejailbreaktes Gerät hat eine geschwächte Sandbox.
= wahr
! Deshalb sperren viele Unternehmen solche Geräte vom Firmenzugriff aus.

? Was bewirken App Protection Policies (MAM)?
+ Firmendaten bleiben in verwalteten Apps und lassen sich nicht in private Apps kopieren
- sie verschlüsseln das WLAN
- sie installieren Spiele
- sie deaktivieren Updates
! Schutz auch ohne volle Geräteverwaltung.

? Welche iOS-Funktion schützt besonders gefährdete Personen vor gezielten Angriffen?
= Lockdown-Modus
= Lockdown Mode
! Sie schränkt viele angreifbare Funktionen stark ein.
