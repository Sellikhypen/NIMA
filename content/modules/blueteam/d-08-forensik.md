---
id: d-08
title: Digitale Forensik
paths: cdsa, specialist
order: 8
difficulty: hard
icon: magnifyingglass
summary: Forensischer Prozess, Datenträger- und Speicherabbilder, Windows-Artefakte, Zeitleisten, Speicheranalyse mit Volatility und gerichtsverwertbare Dokumentation.
htb: Introduction to Digital Forensics
---

## Der forensische Prozess

1. **Identifikation** – welche Systeme und Datenquellen sind relevant?
2. **Sicherung** – Abbilder erstellen, Integrität per Hash sichern
3. **Analyse** – Artefakte auswerten, Zeitleiste rekonstruieren
4. **Dokumentation und Bericht** – nachvollziehbar, reproduzierbar, neutral

> [!MERKE] Grundsätze
> Arbeite nie am Original, sondern an verifizierten Kopien. Dokumentiere jeden Schritt mit Zeitstempel (**Chain of Custody**). Sichere flüchtige Daten zuerst (**Order of Volatility**) – siehe [[mod:s-07|Incident Response]].

## Sicherung

| Was | Werkzeuge | Format |
|---|---|---|
| Arbeitsspeicher | WinPmem, DumpIt, LiME (Linux), Magnet RAM Capture | raw, lime |
| Datenträger | FTK Imager, `dd`/`dc3dd`, Guymager | raw (dd), E01 |
| ausgewählte Artefakte (Triage) | KAPE, Velociraptor | Sammlung von Dateien |

Schreibschutz (Write Blocker) verhindert Änderungen am Originaldatenträger.

## Windows-Artefakte

| Artefakt | Ort | Aussage |
|---|---|---|
| Prefetch | `C:\Windows\Prefetch` | welche Programme wann ausgeführt wurden |
| Amcache / Shimcache | Registry / `Amcache.hve` | Hinweise auf vorhandene und ausgeführte Programme |
| UserAssist | NTUSER.DAT | vom Benutzer gestartete Programme |
| ShellBags | UsrClass.dat | geöffnete Ordner |
| LNK-Dateien / Jump Lists | Benutzerprofil | geöffnete Dateien |
| $MFT, $UsnJrnl, $LogFile | NTFS | Datei-Zeitstempel, Änderungen, Löschungen |
| Ereignisprotokolle | `winevt\Logs` | Anmeldungen, Dienste, Prozesse |
| Browser-Verlauf | Profilordner | besuchte Seiten, Downloads |
| SRUM | `SRUDB.dat` | Netzwerk- und Ressourcennutzung pro Programm |

> [!INFO] MACB-Zeitstempel
> Dateisysteme speichern Modified, Accessed, Changed (Metadaten) und Born (Erstellt). Angreifer können Zeitstempel manipulieren („Timestomping“); Abweichungen zwischen `$STANDARD_INFORMATION` und `$FILE_NAME` in der MFT sind ein Hinweis darauf.

## Zeitleisten

Eine **Super-Timeline** führt Ereignisse aus allen Quellen chronologisch zusammen (Werkzeuge: Plaso/log2timeline, Timeline Explorer). So wird sichtbar, wie ein Angriff ablief: Erstzugang → Ausführung → Persistenz → Ausbreitung → Datenabfluss.

## Speicheranalyse mit Volatility 3

Der Arbeitsspeicher enthält, was auf der Festplatte oft fehlt: laufende Prozesse, Netzwerkverbindungen, entschlüsselte Daten, injizierten Code.

```bash
vol -f memory.raw windows.info
vol -f memory.raw windows.pslist
vol -f memory.raw windows.pstree
vol -f memory.raw windows.cmdline
vol -f memory.raw windows.netscan
vol -f memory.raw windows.malfind
```

| Plugin | Zweck |
|---|---|
| `windows.pslist` / `pstree` | Prozesse und Hierarchie |
| `windows.psscan` | auch versteckte oder beendete Prozesse |
| `windows.cmdline` | Befehlszeilen |
| `windows.netscan` | Netzwerkverbindungen |
| `windows.malfind` | verdächtige ausführbare Speicherbereiche |
| `windows.dlllist` | geladene Bibliotheken |
| `windows.handles` | geöffnete Handles |

> [!TIPP] Vergleichen hilft
> Ein Prozess, der in `psscan`, aber nicht in `pslist` auftaucht, könnte versteckt worden sein. Prozesse mit falschem Elternteil oder ungewöhnlichem Pfad gehören genauer untersucht.

## Linux-Forensik in Kürze

`/var/log/auth.log`, `wtmp`/`btmp` (`last`, `lastb`), Shell-History, Cron-Einträge, `systemd`-Units, `/etc/passwd`-Änderungen, neu hinzugefügte `authorized_keys`, Dateien in `/tmp` und `/dev/shm`.

## Quiz

?order Bringe den forensischen Prozess in Reihenfolge
> Identifikation
> Sicherung
> Analyse
> Dokumentation und Bericht

? Welches Windows-Artefakt zeigt, welche Programme ausgeführt wurden (Ordner unter C:\Windows)?
= Prefetch

? Welches Volatility-Plugin findet auch versteckte oder beendete Prozesse?
= windows.psscan
= psscan

? Welches Volatility-Plugin zeigt Netzwerkverbindungen?
= windows.netscan
= netscan

? Wie heißt das Manipulieren von Datei-Zeitstempeln?
= Timestomping

? Welches Werkzeug erstellt Super-Timelines?
+ Plaso / log2timeline
- Wireshark
- Nmap
- Splunk Forwarder

? Welches Gerät verhindert Änderungen am Originaldatenträger?
= Write Blocker
= Schreibschutz

?tf Forensiker arbeiten direkt am Originaldatenträger, um Zeit zu sparen.
= falsch
