---
id: lx-01
title: Linux-Praxis 1 · Navigation und Dateien
paths: grundlagen, cjca
order: 20
difficulty: easy
icon: folder
tags: linux
summary: Sich sicher im Dateisystem bewegen – Pfade, Navigation, Dateien anlegen, kopieren, verschieben, löschen, Links, Wildcards und versteckte Dateien.
---

## Pfade

| Art | Beispiel | Bedeutung |
|---|---|---|
| absolut | `/etc/ssh/sshd_config` | beginnt an der Wurzel `/` |
| relativ | `docs/notiz.txt` | vom aktuellen Verzeichnis aus |
| `.` | `./skript.sh` | aktuelles Verzeichnis |
| `..` | `cd ..` | übergeordnetes Verzeichnis |
| `~` | `~/.bashrc` | Home-Verzeichnis |

## Navigation

```bash
pwd                 # wo bin ich?
ls -la              # alle Dateien inkl. versteckter, mit Details
ls -lt              # nach Änderungszeit sortiert
cd /var/log         # wechseln
cd -                # zurück zum vorherigen Verzeichnis
tree -L 2           # Baumansicht (falls installiert)
```

> [!INFO] Versteckte Dateien
> Dateien, die mit einem Punkt beginnen (`.bash_history`, `.ssh`), werden von `ls` ohne `-a` nicht angezeigt. Gerade dort liegen oft Konfigurationen und Zugangsdaten.

## Dateien und Verzeichnisse bearbeiten

```bash
mkdir -p projekt/scans      # Verzeichnis inkl. Elternverzeichnissen
touch notizen.md            # leere Datei anlegen
cp datei.txt backup/        # kopieren
cp -r ordner/ ziel/         # rekursiv kopieren
mv alt.txt neu.txt          # verschieben oder umbenennen
rm datei.txt                # löschen (kein Papierkorb!)
rm -r ordner/               # rekursiv löschen
ln -s /opt/tool/bin/tool ~/bin/tool   # symbolischer Link
```

> [!WARNUNG] rm ist endgültig
> `rm` löscht ohne Rückfrage und ohne Papierkorb. Besonders `rm -rf` mit Variablen oder Wildcards hat schon ganze Systeme gelöscht. Vorher mit `ls` prüfen, was getroffen wird.

## Wildcards (Globbing)

| Muster | trifft |
|---|---|
| `*` | beliebig viele Zeichen |
| `?` | genau ein Zeichen |
| `[abc]` | eines der Zeichen |
| `{a,b}` | Alternativen (`cp datei.{txt,bak}`) |

## Dateien finden

```bash
find / -name "*.conf" 2>/dev/null
find /home -type f -mtime -1         # in den letzten 24 h geändert
find / -size +100M 2>/dev/null       # große Dateien
locate passwd                        # schnelle Indexsuche
which python3; type ls               # wo liegt ein Befehl?
```

## Dateien betrachten

`cat`, `less` (blättern, `/` suchen, `q` beenden), `head -n 20`, `tail -n 50`, `tail -f` (live mitlesen), `file` (Dateityp), `stat` (Zeitstempel, Rechte), `wc -l` (Zeilen zählen).

## Quiz

? Welcher Befehl zeigt das aktuelle Verzeichnis?
= pwd

? Mit welcher ls-Option werden versteckte Dateien angezeigt?
= -a
= ls -a
= ls -la

? Was bedeutet `..` in einem Pfad?
+ das übergeordnete Verzeichnis
- das aktuelle Verzeichnis
- das Home-Verzeichnis
- die Wurzel

? Mit welchem Befehl liest man eine Logdatei live mit?
= tail -f

? Welcher find-Ausdruck findet Dateien, die in den letzten 24 Stunden geändert wurden?
= -mtime -1
= find -mtime -1

?tf rm verschiebt Dateien in einen Papierkorb.
= falsch

@@@ MODULE @@@
---
id: lx-02
title: Linux-Praxis 2 · Text verarbeiten mit grep, sed, awk
paths: grundlagen, cjca, cdsa
order: 21
difficulty: medium
icon: text.magnifyingglass
tags: linux
summary: Logs und Ausgaben filtern, umformen und auswerten – Pipes, Umleitungen, grep, cut, sort, uniq, sed, awk und jq für JSON.
---

## Pipes und Umleitungen

| Zeichen | Wirkung |
|---|---|
| `|` | Ausgabe an den nächsten Befehl |
| `>` | in Datei schreiben (überschreiben) |
| `>>` | an Datei anhängen |
| `2>` | Fehlerausgabe umleiten |
| `2>&1` | Fehler in die normale Ausgabe |
| `<` | Datei als Eingabe |
| `tee` | gleichzeitig anzeigen und speichern |

## grep

```bash
grep -i "failed" /var/log/auth.log        # ohne Groß-/Kleinschreibung
grep -r "password" /etc 2>/dev/null       # rekursiv
grep -v "^#" sshd_config                  # Kommentare ausblenden
grep -E "error|warn" app.log              # erweiterte Regex
grep -c "404" access.log                  # Treffer zählen
grep -o "[0-9]\{1,3\}\(\.[0-9]\{1,3\}\)\{3\}" access.log   # nur IPs ausgeben
```

## cut, sort, uniq

```bash
cut -d: -f1,7 /etc/passwd                 # Benutzername und Shell
sort | uniq -c | sort -rn | head          # Häufigkeiten
sort -u                                   # eindeutig sortieren
```

## sed – Streams bearbeiten

```bash
sed 's/alt/neu/g' datei.txt               # ersetzen
sed -n '10,20p' datei.txt                 # Zeilen 10–20 ausgeben
sed '/^$/d' datei.txt                     # leere Zeilen löschen
```

## awk – spaltenweise auswerten

```bash
awk '{print $1}' access.log | sort | uniq -c | sort -rn | head   # Top-IPs
awk -F: '$3 >= 1000 {print $1}' /etc/passwd                      # normale Benutzer
awk '$9 == 500 {count++} END {print count}' access.log            # Anzahl 500er
```

## jq – JSON verarbeiten

```bash
cat events.json | jq '.[] | select(.level=="high") | .host'
jq -r '.users[].name' users.json
```

> [!PRAXIS] Beispiel: Top-Angreifer-IPs aus SSH-Logs
> ```text
> grep "Failed password" /var/log/auth.log | awk '{print $(NF-3)}' | sort | uniq -c | sort -rn | head
> ```
> Diese Kette ist eine typische Aufgabe für SOC-Analysten und ein guter Test, ob man Pipes verstanden hat.

## Quiz

? Welches Zeichen hängt Ausgabe an eine Datei an, statt sie zu überschreiben?
= >>

? Welche grep-Option blendet passende Zeilen aus?
= -v

? Welche Befehlskette zählt Häufigkeiten und sortiert absteigend?
+ sort | uniq -c | sort -rn
- uniq | sort | head
- cat | grep | wc
- sed | awk | tee

? Welches Werkzeug verarbeitet JSON auf der Kommandozeile?
= jq

? Mit welcher cut-Option legt man das Trennzeichen fest?
= -d

? Was bewirkt `2>/dev/null`?
+ Fehlermeldungen werden verworfen
- die Ausgabe wird gespeichert
- der Befehl läuft zweimal
- die Datei wird gelöscht

@@@ MODULE @@@
---
id: lx-03
title: Linux-Praxis 3 · Benutzer, Gruppen und Rechte
paths: grundlagen, cjca, cpts
order: 22
difficulty: medium
icon: person.2.badge.gearshape
tags: linux
summary: Benutzer und Gruppen verwalten, Rechte setzen, umask, ACLs, sudo-Konfiguration und typische Prüfungen bei der Härtung.
---

## Benutzer und Gruppen

```bash
id; whoami; groups
sudo useradd -m -s /bin/bash alice
sudo passwd alice
sudo usermod -aG docker alice     # Gruppe hinzufügen (-a nicht vergessen!)
sudo userdel -r alice
getent passwd alice; getent group sudo
```

| Datei | Inhalt |
|---|---|
| `/etc/passwd` | Konten |
| `/etc/shadow` | Passwort-Hashes, Ablaufdaten |
| `/etc/group` | Gruppen und Mitglieder |
| `/etc/sudoers`, `/etc/sudoers.d/` | sudo-Regeln |

> [!WARNUNG] usermod ohne -a
> `usermod -G gruppe` **ersetzt** alle Zusatzgruppen. Nur mit `-aG` wird angehängt – ein klassischer Admin-Fehler.

## Rechte setzen

```bash
chmod 640 datei            # rw-r-----
chmod u+x skript.sh        # Besitzer darf ausführen
chmod -R o-rwx /srv/daten  # anderen alle Rechte entziehen
chown www-data:www-data /var/www/html -R
```

**umask** legt fest, welche Rechte neue Dateien **nicht** erhalten. Mit `umask 027` entstehen Dateien als `640` und Verzeichnisse als `750`.

## ACLs

Für feinere Rechte als Besitzer/Gruppe/andere:

```bash
setfacl -m u:bob:r datei.txt
getfacl datei.txt
```

## sudo richtig konfigurieren

```text
# /etc/sudoers.d/backup – nur mit visudo bearbeiten
backup ALL=(root) NOPASSWD: /usr/local/bin/backup.sh
```

- nur konkrete Befehle mit festem Pfad erlauben
- keine Editoren, Pager, Interpreter oder Befehle mit Shell-Escape
- Wildcards in Argumenten vermeiden
- `sudo -l` zeigt die eigenen Rechte

## Prüfliste für die Härtung

```bash
awk -F: '$3 == 0 {print $1}' /etc/passwd     # nur root darf UID 0 haben
awk -F: '$2 == "" {print $1}' /etc/shadow    # Konten ohne Passwort
find / -perm -4000 -type f 2>/dev/null       # SUID-Dateien inventarisieren
find / -perm -o+w -type f 2>/dev/null | grep -v proc   # weltweit beschreibbare Dateien
```

## Quiz

? Mit welcher usermod-Option fügt man eine Gruppe hinzu, ohne andere zu entfernen?
= -aG

? Welche Rechte ergibt chmod 640?
+ rw-r-----
- rwxr-x---
- rw-rw-rw-
- r--r--r--

? Mit welchem Befehl sollte sudoers bearbeitet werden?
= visudo

? Welcher Befehl setzt eine ACL für einen Benutzer?
= setfacl

? Welches Konto darf als einziges UID 0 haben?
= root

?tf umask 027 erzeugt neue Dateien mit den Rechten 640.
= wahr

@@@ MODULE @@@
---
id: lx-04
title: Linux-Praxis 4 · Prozesse, Dienste und Zeitpläne
paths: grundlagen, cjca, cdsa
order: 23
difficulty: medium
icon: cpu
tags: linux
summary: Prozesse beobachten und steuern, Signale, systemd-Dienste und -Timer, cron, Ressourcenverbrauch und verdächtige Prozesse erkennen.
---

## Prozesse

```bash
ps aux                      # alle Prozesse
ps auxf                     # mit Baumstruktur
pgrep -a ssh                # Prozesse nach Name
top / htop                  # live
pstree -p                   # Prozessbaum mit PIDs
ls -l /proc/1234/exe        # echtes Programm eines Prozesses
cat /proc/1234/cmdline | tr '\0' ' '
```

## Signale

| Signal | Nummer | Wirkung |
|---|---|---|
| SIGTERM | 15 | höflich beenden (Standard von `kill`) |
| SIGKILL | 9 | sofort beenden, nicht abfangbar |
| SIGHUP | 1 | Konfiguration neu laden (bei vielen Diensten) |
| SIGSTOP / SIGCONT | 19 / 18 | anhalten / fortsetzen |

## systemd

```bash
systemctl status nginx
systemctl enable --now nginx      # aktivieren und starten
systemctl list-units --type=service --state=running
systemctl list-timers
journalctl -u nginx --since "1 hour ago"
systemctl cat nginx               # Unit-Datei anzeigen
```

Unit-Dateien liegen in `/etc/systemd/system/` (Admin) und `/lib/systemd/system/` (Pakete). Sicherheitsoptionen in Units: `User=`, `NoNewPrivileges=yes`, `ProtectSystem=strict`, `PrivateTmp=yes`.

## cron

```text
# Minute Stunde Tag Monat Wochentag Befehl
30 2 * * * /usr/local/bin/backup.sh
```

Orte: `crontab -l` (Benutzer), `/etc/crontab`, `/etc/cron.d/`, `/etc/cron.{hourly,daily,weekly}`.

> [!TIPP] Persistenz-Check
> Bei Untersuchungen alle Cron-Orte und systemd-Units/-Timer prüfen – inklusive Änderungszeiten. Neue Einträge, die Programme aus `/tmp` oder `/dev/shm` starten, sind höchst verdächtig.

## Verdächtige Prozesse erkennen

- Programm aus `/tmp`, `/dev/shm` oder gelöschter Datei (`/proc/PID/exe -> (deleted)`)
- Namen, die Kernel-Threads imitieren (`[kworker]` als normaler Prozess)
- hohe CPU-Last durch unbekannte Prozesse (Kryptomining)
- Shells mit Netzwerkverbindungen (`ss -tanp`)

## Quiz

? Welches Signal beendet einen Prozess sofort und kann nicht abgefangen werden?
= SIGKILL
= 9

? Welcher Befehl aktiviert und startet einen Dienst gleichzeitig?
= systemctl enable --now

? Wo zeigt Linux das echte Programm eines Prozesses?
= /proc/PID/exe
= /proc/<PID>/exe

? Was bedeutet der cron-Eintrag `30 2 * * *`?
+ täglich um 2:30 Uhr
- alle 30 Minuten
- am 30. jedes Monats
- montags um 2 Uhr

? Welche systemd-Option verhindert, dass ein Dienst zusätzliche Rechte erhält?
= NoNewPrivileges=yes
= NoNewPrivileges

@@@ MODULE @@@
---
id: lx-05
title: Linux-Praxis 5 · Netzwerk auf der Kommandozeile
paths: grundlagen, cjca, cpts
order: 24
difficulty: medium
icon: network
tags: linux
summary: Adressen, Routen, DNS, Verbindungen, lauschende Ports, Firewall mit nftables/ufw, Verkehr mitschneiden und Dateien übertragen.
---

## Konfiguration ansehen

```bash
ip a                    # Adressen
ip r                    # Routen
ip neigh                # ARP-/NDP-Tabelle
resolvectl status       # DNS (systemd-resolved)
cat /etc/resolv.conf
hostnamectl
```

## Verbindungen und Ports

```bash
ss -tulpn               # lauschende TCP/UDP-Ports mit Prozess
ss -tanp                # alle TCP-Verbindungen
lsof -i :443            # wer nutzt Port 443?
```

## Erreichbarkeit testen

```bash
ping -c 3 10.0.0.1
traceroute 8.8.8.8      # bzw. tracepath
dig +short example.com A
dig -x 8.8.8.8          # Reverse Lookup
nc -zv 10.0.0.5 22      # Port-Test
curl -I https://example.com
```

## Firewall

```bash
# ufw (einfach)
sudo ufw default deny incoming
sudo ufw allow from 10.0.0.0/24 to any port 22 proto tcp
sudo ufw enable

# nftables (modern)
sudo nft list ruleset
```

## Verkehr mitschneiden

```bash
sudo tcpdump -i eth0 -nn port 53
sudo tcpdump -i eth0 -w capture.pcap host 10.0.0.5
```

Auswertung in Wireshark oder Zeek – siehe [[mod:d-05|Netzwerkanalyse]].

## Dateien übertragen (legitime Administration)

```bash
scp datei.txt user@server:/tmp/
rsync -avz ordner/ user@server:/backup/
python3 -m http.server 8000      # schneller HTTP-Server im aktuellen Verzeichnis
curl -O https://server/datei
wget https://server/datei
```

> [!INFO] Verteidigersicht
> Dieselben Werkzeuge nutzen Angreifer. Ungewöhnliche ausgehende Downloads von Servern oder ein unerwarteter Python-HTTP-Server im Netz sind deshalb lohnende Erkennungsfälle.

## Quiz

? Welcher Befehl zeigt die Routen?
= ip r
= ip route

? Welcher Befehl zeigt lauschende Ports mit Prozess?
= ss -tulpn

? Welche dig-Option liefert nur die Antwort?
= +short

? Wie führt man mit dig einen Reverse Lookup aus?
= dig -x

? Welche ufw-Standardregel blockiert eingehende Verbindungen?
= ufw default deny incoming
= default deny incoming

? Welcher Befehl startet einen einfachen HTTP-Server in Python 3?
= python3 -m http.server

@@@ MODULE @@@
---
id: lx-06
title: Linux-Praxis 6 · Paketverwaltung und Updates
paths: grundlagen, specialist
order: 25
difficulty: easy
icon: shippingbox.fill
tags: linux
summary: apt, dnf und Co., Repositories und Signaturen, automatische Sicherheitsupdates, Paketintegrität prüfen und installierte Software inventarisieren.
---

## Paketmanager

| Distribution | Werkzeug | Paketformat |
|---|---|---|
| Debian, Ubuntu, Kali | `apt` | .deb |
| RHEL, Fedora, Rocky | `dnf` (früher yum) | .rpm |
| Arch | `pacman` | .pkg.tar.zst |
| Alpine | `apk` | .apk |
| SUSE | `zypper` | .rpm |

```bash
sudo apt update && sudo apt upgrade
apt list --upgradable
apt show openssh-server
dpkg -l | grep ssl
sudo dnf check-update && sudo dnf upgrade --security
```

## Repositories und Signaturen

Pakete stammen aus Repositories, deren Metadaten **kryptografisch signiert** sind. Der Paketmanager prüft die Signatur mit den hinterlegten Schlüsseln. Fremde Repositories bedeuten Vertrauen in deren Betreiber – sie sollten sparsam und mit eigenem, eingeschränktem Schlüssel (`signed-by=`) eingebunden werden.

## Automatische Sicherheitsupdates

- Debian/Ubuntu: `unattended-upgrades`
- RHEL-Familie: `dnf-automatic`
- Neustarts für Kernel- und Bibliotheksupdates einplanen (`needrestart`, Livepatch)

## Integrität prüfen

```bash
debsums -c               # geänderte Dateien aus Paketen (Debian)
rpm -Va                  # Prüfung aller Pakete (RPM)
```

Geänderte Systemprogramme können auf Manipulation hindeuten – siehe [[mod:d-11|Linux-Incident-Response]].

## Inventar

Für Schwachstellenmanagement braucht man Listen installierter Pakete mit Versionen (`dpkg -l`, `rpm -qa`) – idealerweise automatisiert über Agenten oder Konfigurationsmanagement.

## Quiz

? Welcher Paketmanager wird bei Debian und Ubuntu genutzt?
= apt

? Welcher Paketmanager wird bei RHEL und Fedora genutzt?
= dnf

? Welches Paket installiert unter Ubuntu automatisch Sicherheitsupdates?
= unattended-upgrades

? Welcher Befehl prüft alle RPM-Pakete auf Veränderungen?
= rpm -Va

? Warum sind Repository-Metadaten signiert?
+ Damit Manipulationen an Paketen erkannt werden
- Damit Downloads schneller sind
- Damit Pakete kleiner werden
- Aus Lizenzgründen

@@@ MODULE @@@
---
id: lx-07
title: Linux-Praxis 7 · Logs, journald und rsyslog
paths: cdsa, grundlagen
order: 26
difficulty: medium
icon: doc.text.below.ecg
tags: linux
summary: Wo Linux protokolliert, journalctl effektiv nutzen, rsyslog-Weiterleitung, Logrotation, Anmeldehistorie und die wichtigsten Muster für Analysen.
---

## Zwei Welten

| System | Speicherort | Werkzeug |
|---|---|---|
| systemd-journald | binär unter `/var/log/journal/` (wenn persistent) | `journalctl` |
| rsyslog / syslog-ng | Textdateien unter `/var/log/` | `less`, `grep` |

## journalctl

```bash
journalctl -b                     # seit dem letzten Boot
journalctl -u ssh --since today
journalctl -p err -b              # nur Fehler
journalctl _UID=1000              # nach Benutzer
journalctl -f                     # live
journalctl -o json-pretty -n 5    # strukturiert
```

## Wichtige Logdateien

| Datei (Debian/Ubuntu) | Inhalt |
|---|---|
| `/var/log/auth.log` | Anmeldungen, sudo, SSH |
| `/var/log/syslog` | allgemeine Meldungen |
| `/var/log/kern.log` | Kernel |
| `/var/log/dpkg.log`, `apt/history.log` | Paketinstallationen |
| `/var/log/apache2/`, `/var/log/nginx/` | Webserver |
| `/var/log/audit/audit.log` | auditd |

Anmeldehistorie: `last` (wtmp), `lastb` (btmp, fehlgeschlagen), `lastlog`.

## Weiterleitung an ein SIEM

```text
# /etc/rsyslog.d/50-siem.conf
*.* @@siem.intern:514        # @@ = TCP, @ = UDP
```

Besser: verschlüsselt (TLS) und mit Puffer gegen Verbindungsabbrüche, oder ein Agent (Wazuh, Elastic Agent, Fluent Bit).

## Logrotation

`logrotate` (Konfiguration in `/etc/logrotate.d/`) rotiert, komprimiert und löscht alte Logs. Aufbewahrungsfristen müssen zu Sicherheits- und Datenschutzanforderungen passen.

> [!WARNUNG] Lokale Logs sind manipulierbar
> Wer root ist, kann lokale Logs löschen oder verändern. Deshalb gehören Logs **zeitnah** auf ein zentrales System, auf das die Server selbst keinen Schreibzugriff für bestehende Einträge haben.

## Quiz

? Mit welcher journalctl-Option sieht man Meldungen seit dem letzten Boot?
= -b

? Welcher Befehl zeigt fehlgeschlagene Anmeldungen aus btmp?
= lastb

? Welche Datei protokolliert unter Ubuntu Paketinstallationen?
+ /var/log/dpkg.log
- /var/log/auth.log
- /var/log/kern.log
- /etc/passwd

? Was bedeutet `@@` in einer rsyslog-Weiterleitung?
+ Übertragung per TCP
- Übertragung per UDP
- Verschlüsselung
- Komprimierung

? Welches Werkzeug rotiert und löscht alte Logs?
= logrotate

?tf Logs sollten zeitnah zentral gespeichert werden, weil root lokale Logs manipulieren kann.
= wahr

@@@ MODULE @@@
---
id: lx-08
title: Linux-Praxis 8 · Bash-Skripte für den Alltag
paths: grundlagen, cjca, cdsa
order: 27
difficulty: medium
icon: terminal.fill
tags: linux
summary: Robuste Bash-Skripte schreiben – Variablen, Bedingungen, Schleifen, Funktionen, Argumente, Fehlerbehandlung und drei praktische Beispiele für Admins und Analysten.
htb: Introduction to Bash Scripting
---

## Grundgerüst

```bash
#!/usr/bin/env bash
set -euo pipefail        # bei Fehlern abbrechen, undefinierte Variablen verbieten
IFS=$'\n\t'

usage() { echo "Aufruf: $0 <logdatei>"; exit 1; }
[[ $# -eq 1 ]] || usage
LOG="$1"
[[ -r "$LOG" ]] || { echo "Datei nicht lesbar: $LOG" >&2; exit 2; }
```

| Option | Wirkung |
|---|---|
| `set -e` | Abbruch bei Fehler |
| `set -u` | Fehler bei undefinierten Variablen |
| `set -o pipefail` | Fehler in Pipes werden erkannt |

## Bedingungen und Schleifen

```bash
if [[ -f /etc/os-release ]]; then
  . /etc/os-release; echo "System: $PRETTY_NAME"
fi

for host in $(cat hosts.txt); do
  ping -c1 -W1 "$host" &>/dev/null && echo "$host erreichbar"
done

while read -r user _ ; do
  echo "Benutzer: $user"
done < <(cut -d: -f1 /etc/passwd)

case "$1" in
  start) echo starten ;;
  stop)  echo stoppen ;;
  *)     usage ;;
esac
```

## Praktische Beispiele

**1. Fehlgeschlagene SSH-Anmeldungen pro IP**

```bash
grep "Failed password" /var/log/auth.log | awk '{print $(NF-3)}' | sort | uniq -c | sort -rn | head
```

**2. Prüfen, ob wichtige Dienste laufen**

```bash
for svc in ssh nginx wazuh-agent; do
  systemctl is-active --quiet "$svc" && echo "OK  $svc" || echo "FEHLT $svc"
done
```

**3. Neue SUID-Dateien gegenüber einer Basislinie**

```bash
find / -perm -4000 -type f 2>/dev/null | sort > /tmp/suid_now.txt
diff /var/lib/baseline/suid.txt /tmp/suid_now.txt
```

> [!TIPP] ShellCheck
> Das Werkzeug **ShellCheck** findet typische Fehler in Bash-Skripten (fehlende Anführungszeichen, falsche Vergleiche) – ideal vor dem Einsatz auf echten Systemen.

## Quiz

? Welche Zeile lässt ein Bash-Skript bei Fehlern, undefinierten Variablen und Pipe-Fehlern abbrechen?
= set -euo pipefail

? Welche Variable enthält die Anzahl der Argumente?
= $#

? Welche Variable enthält das erste Argument?
= $1

? Welches Werkzeug prüft Bash-Skripte auf typische Fehler?
= ShellCheck

? Welche Struktur wählt anhand eines Werts zwischen mehreren Fällen?
= case

? Welcher Test prüft, ob eine Datei existiert und eine reguläre Datei ist?
= -f
= [[ -f datei ]]
