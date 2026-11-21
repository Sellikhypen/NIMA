---
id: s-01
title: Informationssicherheit – Grundbegriffe
paths: specialist, cjca
order: 1
difficulty: easy
icon: shield.checkered
summary: Schutzziele, Bedrohung, Schwachstelle, Risiko, Angreifertypen, Verteidigungsprinzipien und die Rollen im Security-Team.
---

## Informationssicherheit vs. IT-Sicherheit

**Informationssicherheit** schützt Informationen in jeder Form – auf Servern, auf Papier, in Köpfen. **IT-Sicherheit** ist der Teil, der sich auf IT-Systeme bezieht. **Cybersicherheit** betont den Schutz vor Angriffen über Netze. In Normen wie ISO 27001 und im BSI IT-Grundschutz geht es immer um das Ganze.

## Die Schutzziele (CIA-Triade)

| Schutzziel | Bedeutung | Bedrohung | Beispielmaßnahme |
|---|---|---|---|
| **C**onfidentiality – Vertraulichkeit | nur Berechtigte erhalten Zugriff | Datendiebstahl, Abhören | Verschlüsselung, Rechtekonzept |
| **I**ntegrity – Integrität | Daten sind korrekt und unverändert | Manipulation, Fehler | Hashes, Signaturen, Vier-Augen-Prinzip |
| **A**vailability – Verfügbarkeit | Systeme sind nutzbar, wenn sie gebraucht werden | Ausfall, DDoS, Ransomware | Redundanz, Backups, Notfallplanung |

Erweiterte Schutzziele: **Authentizität** (echt und zuordenbar), **Verbindlichkeit / Nichtabstreitbarkeit**, **Zurechenbarkeit**, **Datenschutz**.

> [!MERKE] Prüfungsklassiker
> Ransomware verletzt vor allem die Verfügbarkeit, bei „Double Extortion“ (Daten werden zusätzlich gestohlen) auch die Vertraulichkeit.

## Bedrohung, Schwachstelle, Risiko

| Begriff | Definition | Beispiel |
|---|---|---|
| Asset / Wert | etwas Schützenswertes | Kundendatenbank |
| Bedrohung | mögliche Ursache eines Schadens | Cyberkriminelle, Feuer, Bedienfehler |
| [[Schwachstelle]] | Eigenschaft, die eine Bedrohung ausnutzbar macht | ungepatchter Server |
| Exploit | Methode/Code, der eine Schwachstelle ausnutzt | öffentlich verfügbarer Angriffscode |
| [[Risiko]] | Kombination aus Eintrittswahrscheinlichkeit und Schadenshöhe | „hoch“ |
| Maßnahme / Control | reduziert das Risiko | Patch-Management |

> [!ANALOGIE] Das Haus
> Einbrecher sind die Bedrohung, das gekippte Fenster die Schwachstelle, der Schmuck der Wert. Das Risiko hängt davon ab, wie wahrscheinlich ein Einbruch ist und was verloren gehen kann. Das Schließen des Fensters ist die Maßnahme.

## Wer greift an? (Threat Actors)

| Angreifertyp | Motivation | Fähigkeiten |
|---|---|---|
| Script Kiddies | Neugier, Anerkennung | gering, nutzen fertige Werkzeuge |
| Cyberkriminelle | Geld (Ransomware, Betrug, Datenhandel) | mittel bis hoch, arbeitsteilig organisiert |
| Hacktivisten | politische Botschaft | gering bis mittel |
| Innentäter | Rache, Geld, Fahrlässigkeit | Zugang bereits vorhanden |
| Staatliche Akteure ([[APT]]) | Spionage, Sabotage | sehr hoch, langfristig |
| Wettbewerber | Wirtschaftsspionage | unterschiedlich |

## Verteidigungsprinzipien

- **Defense in Depth** – mehrere unabhängige Schutzschichten, damit ein einzelner Fehler nicht zum Totalschaden führt.
- **Least Privilege** – jeder bekommt nur die Rechte, die er wirklich braucht.
- **Need to know** – Zugriff auf Informationen nur bei Bedarf.
- **Separation of Duties** – kritische Vorgänge auf mehrere Personen verteilen.
- **Secure by Default** – sichere Grundeinstellungen.
- **[[Zero Trust]]** – „never trust, always verify“: kein implizites Vertrauen aufgrund der Netzwerkposition.
- **Assume Breach** – davon ausgehen, dass ein Angreifer schon drin ist, und Erkennung sowie Eindämmung planen.

## Maßnahmenarten

| nach Wirkung | Beispiel |
|---|---|
| präventiv | Firewall, MFA, Schulung |
| detektiv | SIEM, IDS, Log-Review |
| korrektiv | Backup-Wiederherstellung, Patch |
| abschreckend | Hinweisschilder, Rechtsfolgen |

| nach Art | Beispiel |
|---|---|
| technisch | Verschlüsselung, EDR |
| organisatorisch | Richtlinien, Prozesse, Schulungen |
| physisch | Zutrittskontrolle, Videoüberwachung |
| personell | Hintergrundprüfung, Vertraulichkeitsvereinbarung |

## Rollen im Security-Umfeld

| Rolle | Aufgabe |
|---|---|
| CISO / ISB | Verantwortung für das Informationssicherheits-Management |
| Datenschutzbeauftragter | Einhaltung des Datenschutzrechts (DSGVO) |
| Security Architect | sichere Gestaltung von Systemen |
| SOC-Analyst (Blue Team) | Überwachung, Erkennung, Reaktion |
| Incident Responder / DFIR | Vorfallbearbeitung, Forensik |
| Penetration Tester (Red Team) | autorisierte Angriffssimulation |
| Security Engineer | Betrieb von Sicherheitstechnik |
| Auditor | unabhängige Prüfung gegen Normen |

Wie diese Rollen in einer Übung zusammenspielen, zeigt deine [[mod:cr-12|Cyber Range]] (Red, Blue, White, Purple Team).

## Quiz

? Welche drei Schutzziele bilden die CIA-Triade?
+ Vertraulichkeit, Integrität, Verfügbarkeit
- Authentizität, Integrität, Anonymität
- Verschlüsselung, Hashing, Backup
- Vertraulichkeit, Verbindlichkeit, Verfügbarkeit

? Welches Schutzziel verletzt ein DDoS-Angriff vor allem?
= Verfügbarkeit
= Availability

? Was ist ein ungepatchter Server im Risikomodell?
+ eine Schwachstelle
- eine Bedrohung
- ein Risiko
- ein Asset

? Wie heißt das Prinzip „never trust, always verify“?
= Zero Trust

? Wie heißt das Prinzip mehrerer unabhängiger Schutzschichten?
= Defense in Depth

? Welche Maßnahmen sind detektiv?
+ SIEM
+ IDS
- Firewall
- Backup-Wiederherstellung

? Wie nennt man langfristig agierende, meist staatlich unterstützte Angreifergruppen?
= APT
= Advanced Persistent Threat

?tf Least Privilege bedeutet, dass Administratoren grundsätzlich alle Rechte erhalten.
= falsch
