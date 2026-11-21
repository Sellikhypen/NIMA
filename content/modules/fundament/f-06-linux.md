---
id: f-06
title: Linux-Grundlagen für Security
paths: grundlagen, cjca, cpts, cdsa
order: 6
difficulty: easy
icon: terminal
summary: Dateisystem-Hierarchie, Benutzer und Rechte, Prozesse, Dienste, Logs und die Shell – alles, was du brauchst, um Linux-Systeme zu verstehen, zu verwalten und abzusichern.
htb: Linux Fundamentals
---

## Warum Linux?

Die meisten Server, Container, Router, Firewalls und Security-Werkzeuge laufen auf Linux. Wer Systeme prüfen oder verteidigen will, muss sich auf der Kommandozeile sicher bewegen und verstehen, wo Linux welche Informationen ablegt.

## Die Dateisystem-Hierarchie (FHS)

Unter Linux gibt es keine Laufwerksbuchstaben. Alles hängt unter der Wurzel `/`.

| Pfad | Inhalt | Sicherheitsrelevanz |
|---|---|---|
| `/etc` | Konfiguration | Passwortdateien, Dienstkonfigurationen |
| `/home` | Benutzerverzeichnisse | SSH-Schlüssel, Shell-History |
| `/root` | Home von root | nur für root lesbar |
| `/var/log` | Logdateien | Grundlage jeder Untersuchung |
| `/var/www` | Webinhalte | Konfigurationen mit Zugangsdaten |
| `/tmp`, `/dev/shm` | temporär, für alle beschreibbar | beliebter Ablageort für Fremdcode |
| `/proc` | virtuelle Prozessinfos | Befehlszeilen, Umgebungsvariablen |
| `/bin`, `/usr/bin` | Programme | manipulierte Binaries erkennen |
| `/opt` | Zusatzsoftware | oft schlecht gepflegt |

> [!MERKE] /etc/passwd und /etc/shadow
> `/etc/passwd` listet alle Konten (weltlesbar). Die Passwort-[[Hashfunktion|Hashes]] liegen getrennt in `/etc/shadow`, das nur root lesen darf. Ein `x` im zweiten Feld von passwd verweist auf shadow.

## Benutzer, Gruppen und Rechte

Jede Datei gehört einem **Benutzer** und einer **Gruppe** und hat drei Rechtesätze: Besitzer (u), Gruppe (g), andere (o). Jeder Satz kann lesen (r = 4), schreiben (w = 2) und ausführen (x = 1).

```text
-rwxr-x--- 1 alice devs 4096 skript.sh
 |  |  |
 |  |  +-- andere: keine Rechte (0)
 |  +----- Gruppe devs: lesen + ausführen (5)
 +-------- Besitzerin alice: alles (7)
```

Oktal geschrieben: `750`. Geändert wird mit `chmod`, Besitzer mit `chown`.

### Besondere Rechte

| Recht | Wirkung | Risiko bei Fehlkonfiguration |
|---|---|---|
| [[SUID]] | Programm läuft mit den Rechten des Besitzers | gehört es root und ist missbrauchbar → Rechteausweitung |
| SGID | läuft mit den Rechten der Gruppe; in Verzeichnissen erben Dateien die Gruppe | ähnlich wie SUID |
| Sticky Bit | in Verzeichnissen dürfen nur Besitzer ihre Dateien löschen | ohne Sticky Bit kann jeder in `/tmp` fremde Dateien löschen |

> [!WARNUNG] Das Prinzip der geringsten Rechte
> Fast alle Wege zur [[Privilege Escalation|Rechteausweitung]] auf Linux beruhen auf zu großzügigen Rechten: beschreibbare Skripte, die root ausführt, unnötige SUID-Programme, zu weite `sudo`-Regeln. Wer Systeme härtet, prüft genau diese Stellen regelmäßig.

## sudo

`sudo` erlaubt es definierten Benutzern, einzelne Befehle mit erhöhten Rechten auszuführen. Die Regeln stehen in `/etc/sudoers` (bearbeitet mit `visudo`). `sudo -l` zeigt, was der aktuelle Benutzer darf.

> [!TIPP] Sichere sudo-Regeln
> Erlaube nur exakt benötigte Befehle mit festen Argumenten, keine Editoren, Interpreter oder Pager mit Root-Rechten, und protokolliere die Nutzung. Viele harmlose Programme können sonst eine Shell starten.

## Prozesse und Dienste

Jedes laufende Programm ist ein **Prozess** mit einer **PID**, einem Besitzer und einem Elternprozess. Wichtige Werkzeuge: `ps aux`, `top`/`htop`, `pstree`, `kill`.

Dienste werden heute meist über **systemd** gesteuert:

```bash
systemctl status ssh        # Zustand eines Dienstes
systemctl list-units --type=service --state=running
journalctl -u ssh --since today   # Logs eines Dienstes
```

Wiederkehrende Aufgaben laufen über **cron** (`/etc/crontab`, `/etc/cron.d/`, Benutzer-Crontabs) oder systemd-Timer. Beides ist ein klassischer Ort für Persistenz – Verteidiger sollten Änderungen hier überwachen.

## Logs

| Datei | Inhalt (Debian/Ubuntu) |
|---|---|
| `/var/log/auth.log` | Logins, sudo, SSH |
| `/var/log/syslog` | allgemeine Systemmeldungen |
| `/var/log/kern.log` | Kernel |
| `/var/log/apache2/` bzw. `/var/log/nginx/` | Webserver-Zugriffe und Fehler |
| `journalctl` | systemd-Journal |

Auf RHEL-basierten Systemen heißen sie z. B. `/var/log/secure` und `/var/log/messages`.

## Die Shell sicher benutzen

```bash
pwd; ls -la; cd /etc          # navigieren
cat, less, head, tail -f      # Dateien lesen
grep -ri "passwort" /etc 2>/dev/null   # rekursiv suchen
find / -name "*.conf" 2>/dev/null       # Dateien finden
ss -tulpn                     # lauschende Ports
ip a; ip r                    # Adressen und Routen
```

Pipes (`|`) verbinden Befehle, `>` schreibt in Dateien, `2>/dev/null` verwirft Fehlermeldungen.

## Quiz

? In welcher Datei liegen unter Linux die Passwort-Hashes?
= /etc/shadow

? Welche Oktalzahl entspricht `rwxr-x---`?
= 750

? Welches Spezialrecht lässt ein Programm mit den Rechten seines Besitzers laufen?
= SUID
= setuid

? Welches Verzeichnis enthält Konfigurationsdateien?
= /etc

? Welcher Befehl zeigt, welche Befehle der aktuelle Benutzer mit sudo ausführen darf?
= sudo -l

? Welche Logdatei enthält auf Ubuntu SSH-Logins und sudo-Nutzung?
= /var/log/auth.log

? Mit welchem Befehl zeigst du lauschende Ports samt Prozess an?
= ss -tulpn
= netstat -tulpn
= re:(ss|netstat) -[tulpn]{5}

?tf Das Sticky Bit verhindert in /tmp, dass Benutzer fremde Dateien löschen.
= wahr

? Mit welchem Werkzeug werden Systemdienste auf modernen Distributionen gesteuert?
= systemctl
= systemd

? Welche Verzeichnisse sind typischerweise für alle Benutzer beschreibbar?
+ /tmp
+ /dev/shm
- /etc
- /root
