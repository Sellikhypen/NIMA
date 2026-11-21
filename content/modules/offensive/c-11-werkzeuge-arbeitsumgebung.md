---
id: c-11
title: Arbeitsumgebung und Werkzeuge
paths: cpts, cjca, cwes
order: 0.5
difficulty: easy
icon: wrench.and.screwdriver
summary: Lab-Umgebung, VPN zu HTB, Pentest-Distributionen, Werkzeugkategorien, Datei- und Shell-Grundbegriffe und eine saubere Arbeitsorganisation.
htb: Getting Started
---

## Die Lab-Umgebung

| Komponente | Zweck |
|---|---|
| Angreifer-VM (z. B. Kali, Parrot, Pwnbox von HTB) | Werkzeuge, isoliert vom privaten System |
| VPN-Verbindung (OpenVPN, Interface `tun0`) | Zugang zum Lab-Netz von HTB |
| Notizsystem | Dokumentation von Anfang an |
| Snapshots | schnell zu einem sauberen Zustand zurück |

> [!WARNUNG] Trennung von Privatem und Lab
> Lab-VPNs verbinden deinen Rechner mit einem Netz voller absichtlich verwundbarer Systeme und anderer Teilnehmer. Arbeite in einer VM, nutze eine Host-Firewall und lege keine privaten Daten in die Lab-Umgebung.

## Werkzeugkategorien

| Kategorie | Beispiele | Zweck |
|---|---|---|
| Netzwerk-Scanner | Nmap, Masscan | Hosts und Dienste finden |
| Web-Proxies | Burp Suite, OWASP ZAP | Web-Verkehr analysieren |
| Web-Fuzzer | ffuf, gobuster, feroxbuster | Inhalte und Parameter finden |
| Schwachstellenscanner | OpenVAS/Greenbone, Nessus, Nuclei | bekannte Lücken prüfen |
| Frameworks | Metasploit | Module für Prüfung und Nachweis |
| Passwortprüfung | Hashcat, John the Ripper | Passwortstärke bewerten |
| AD-Analyse | BloodHound, NetExec, Impacket | Domänen untersuchen |
| Netzwerkanalyse | Wireshark, tcpdump | Verkehr verstehen |
| Exploit-Datenbanken | Exploit-DB / searchsploit, CVE-Datenbanken | Informationen zu bekannten Schwachstellen |

> [!MERKE] Werkzeuge sind austauschbar
> Prüfungen fragen nicht nach Lieblingstools, sondern nach Verständnis: Was tut das Werkzeug im Netz, was bedeutet seine Ausgabe, und wie verifiziere ich das Ergebnis manuell?

## Shells verstehen

| Begriff | Bedeutung |
|---|---|
| Bind Shell | das Zielsystem öffnet einen Port, man verbindet sich dorthin |
| Reverse Shell | das Zielsystem verbindet sich zurück zum Prüfer – umgeht eingehende Firewall-Regeln |
| Web Shell | Befehlsausführung über eine Webseite |
| interaktive TTY | vollwertiges Terminal mit Tab-Vervollständigung und Signalen |

Aus Verteidigersicht sind ausgehende Verbindungen von Servern zu unbekannten Zielen – besonders von Web- oder Datenbankservern – ein starkes Alarmsignal ([[mod:d-05|Netzwerkanalyse]]).

## Dateiübertragung (Konzepte)

Dateien müssen zwischen Prüfer und Zielsystem bewegt werden: über HTTP(S), SMB, SCP/SFTP, Base64 als Text, oder Bordmittel des Betriebssystems. Verteidiger überwachen deshalb Downloads durch Systemprogramme (z. B. `certutil`, `bitsadmin`, PowerShell-Webaufrufe) – siehe die **LOLBAS**-Liste für Windows und **GTFOBins** für Linux, die dokumentieren, welche legitimen Programme sich zweckentfremden lassen.

## Saubere Arbeitsorganisation

- je Ziel ein Ordner: `scans/`, `loot/`, `notes.md`, `screens/`
- Befehle und Ergebnisse sofort notieren
- Zeitstempel und Ziel-IP in jedem Screenshot
- Werkzeuge und Wortlisten versioniert, damit Ergebnisse reproduzierbar sind

## Quiz

? Über welches Interface läuft typischerweise die VPN-Verbindung ins HTB-Lab?
= tun0

? Was unterscheidet eine Reverse Shell von einer Bind Shell?
+ Bei der Reverse Shell verbindet sich das Zielsystem zum Prüfer zurück
- Die Reverse Shell ist immer verschlüsselt
- Die Bind Shell funktioniert nur unter Windows
- Es gibt keinen Unterschied

? Welche Liste dokumentiert zweckentfremdbare Windows-Bordmittel?
= LOLBAS

? Welche Liste dokumentiert zweckentfremdbare Linux-Programme?
= GTFOBins

? Welche Werkzeuge gehören zur Kategorie Web-Fuzzer?
+ ffuf
+ gobuster
- Wireshark
- Hashcat

? Welches Verhalten ist aus Verteidigersicht ein starkes Alarmsignal?
+ ausgehende Verbindungen eines Webservers zu unbekannten Zielen
- ein Benutzer öffnet eine Webseite
- ein Druckauftrag
- ein Windows-Update
