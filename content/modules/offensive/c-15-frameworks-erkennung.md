---
id: c-15
title: Exploit-Frameworks und C2 – Aufbau und Erkennung
paths: cpts, cdsa
order: 5.5
difficulty: medium
icon: square.grid.3x3.middle.filled
summary: Wie Frameworks wie Metasploit und Command-and-Control-Systeme aufgebaut sind, welche Begriffe man kennen muss und – vor allem – wie Verteidiger ihre Spuren in Netz, Speicher und Logs erkennen.
htb: Using the Metasploit Framework
---

## Wozu Frameworks?

Prüfer nutzen Frameworks, um bekannte Schwachstellen reproduzierbar und kontrolliert nachzuweisen, statt für jede Lücke eigenen Code zu schreiben. Red Teams nutzen **Command-and-Control-Systeme (C2)**, um realistische Angreifer zu simulieren. Verteidiger müssen beide verstehen, weil echte Angreifer dieselben oder ähnliche Werkzeuge einsetzen.

## Aufbau von Metasploit

| Modultyp | Zweck |
|---|---|
| Auxiliary | Scanner, Fuzzer, Informationssammlung ohne Codeausführung |
| Exploit | nutzt eine bestimmte Schwachstelle aus |
| Payload | Code, der nach erfolgreicher Ausnutzung läuft |
| Post | Module für die Phase nach dem Zugriff (Informationen sammeln) |
| Encoder / Evasion | verändern Payloads |

| Begriff | Bedeutung |
|---|---|
| Single Payload | in sich geschlossen |
| Staged Payload | kleiner erster Teil lädt den größeren zweiten nach |
| Meterpreter | erweiterte, im Speicher laufende Payload mit vielen Funktionen |
| Handler / Listener | wartet auf eingehende Verbindungen der Payload |
| Workspace / Datenbank | speichert Hosts, Dienste, Zugangsdaten eines Projekts |

> [!MERKE] Prüfungen und Frameworks
> In Zertifizierungen und Projekten zählt, dass man versteht, **was** ein Modul tut, welche Voraussetzungen es hat und welche Spuren es hinterlässt. Viele Prüfungsregeln begrenzen den Einsatz automatischer Exploitation – immer die jeweiligen Regeln lesen.

## Command and Control (C2)

Ein **C2-System** besteht aus einem Server (Team-Server), **Implantaten** auf kompromittierten Systemen und **Listenern**. Implantate melden sich in Intervallen (**Beaconing**) über HTTP(S), DNS, SMB oder andere Kanäle und holen Aufgaben ab. Bekannte Frameworks: Cobalt Strike (kommerziell, häufig von Kriminellen missbraucht), Sliver, Havoc, Mythic.

## Erkennung – die Verteidigerperspektive

| Ebene | Indikatoren |
|---|---|
| Netzwerk | regelmäßige Verbindungen mit Jitter zu seltenen Zielen, ungewöhnliche TLS-Fingerprints (JA3/JA4), Standard-Zertifikate bekannter Frameworks, lange DNS-Abfragen |
| Endpunkt | Prozesse ohne Dateisystem-Abbild, ungewöhnliche Speicherbereiche (ausführbar + beschreibbar), Code-Injektion (Sysmon 8/10), verdächtige Named Pipes (Sysmon 17/18) |
| Verhalten | Office startet Shell, `rundll32`/`regsvr32` mit Netzwerkverbindungen, Dienste mit zufälligen Namen (7045) |
| Speicherforensik | `malfind` findet injizierten Code, Konfigurationsextraktoren lesen C2-Einstellungen aus |

> [!TIPP] Standard-Artefakte
> Viele Frameworks hinterlassen in Standardkonfiguration typische Muster: Pipe-Namen, URI-Pfade, HTTP-Header, Zertifikatsfelder. Öffentliche Sigma-, YARA- und Suricata-Regeln decken viele davon ab – ein guter Startpunkt für das eigene Detection Engineering ([[mod:d-07|YARA und Sigma]]).

## Quiz

? Welcher Metasploit-Modultyp sammelt Informationen ohne Codeausführung?
= Auxiliary

? Was ist eine Staged Payload?
+ Ein kleiner erster Teil lädt den größeren zweiten Teil nach
- eine Payload ohne Netzwerkverbindung
- eine verschlüsselte Datenbank
- ein Scanner

? Wie heißt der Teil eines C2-Systems, der auf dem kompromittierten System läuft?
= Implantat
= Implant
= Agent

? Wie nennt man das regelmäßige Melden eines Implantats beim C2-Server?
= Beaconing

? Welche Sysmon-Ereignisse betreffen Named Pipes?
+ 17 und 18
- 1 und 3
- 22 und 23
- 12 und 13

? Welches Volatility-Plugin findet injizierten Code im Speicher?
= malfind
= windows.malfind

? Welche Netzwerk-Fingerprints helfen, ungewöhnliche TLS-Clients zu erkennen?
= JA3
= JA4
= JA3/JA4
