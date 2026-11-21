---
id: cr-07
title: L4 – Szenario und Inhalte
paths: cyberrange
order: 7
difficulty: medium
icon: building.2
summary: Kapitel 7 deiner Cyber-Range-Dokumentation: L4 – Szenario und Inhalte.
source: Cyber_Range_Dokumentation.docx
htb: Cyber Range 07 · L4 Szenario & Inhalte
---

## Überblick

Die Schichten L0–L3 liefern eine leere »Bühne«. Schicht L4 ist das **Bühnenbild**: das fiktive Unternehmen mit seinen Servern, Benutzern, Daten, Schwachstellen und dem Internet drumherum – plus die Werkzeuge der Angreifer. Je realistischer diese Schicht, desto höher der Lerneffekt.

## Das fiktive Unternehmen

Alle Szenarien dieses Projekts spielen bei der **Nordwind Logistik GmbH** (Domäne `nordwind.lab`). Ein durchgängiges fiktives Unternehmen hat Vorteile: Teilnehmer finden sich schnell zurecht, Szenarien bauen aufeinander auf, und Dokumente (Organigramm, Netzplan, Richtlinien) können wiederverwendet werden.

| **Bereich** | **Systeme** | **Geschäftsfunktion** | **Angriffswert** |
|---|---|---|---|
| **Vertrieb** | Webshop web01 (Nginx + PHP + MariaDB) | Online-Bestellungen | Kundendaten, Verfügbarkeit (Scoring!) |
| **Kommunikation** | mail01 (Postfix/Dovecot) | E-Mail | Einfallstor für Phishing |
| **Verwaltung** | dc01 (AD, DNS), fs01 (Dateiserver) | Anmeldung, Dateien | Domänen-Admin = »Schlüssel zum Königreich« |
| **Mitarbeiter** | ws01–ws03 (Windows 11) | Büroarbeit (simuliert durch GHOSTS) | Erstes Opfer, Sprungbrett |
| **IT-Sicherheit** | soc01/soc02 | Überwachung (Blue Team) | – |

Tabelle 45: Die Nordwind Logistik GmbH

## Active Directory als Kernstück

Active Directory ist in fast allen Unternehmen das Rückgrat der Anmeldung – und deshalb das wichtigste Ziel realer Angreifer. Der Domain Controller dc01 wird per Ansible vollständig aufgebaut: Gesamtstruktur, Organisationseinheiten (OUs), etwa 50 synthetische Benutzer mit realistischen Namen und Abteilungen, Gruppen, Gruppenrichtlinien, Dateifreigaben. Die Benutzer werden aus einer CSV-Datei erzeugt, sodass jede Range dieselbe »Belegschaft« hat.

## Katalog absichtlicher Schwachstellen

Schwachstellen werden **bewusst und dokumentiert** eingebaut – jede als eigene, benannte Ansible-Rolle. So ist jederzeit nachvollziehbar, welche Lücke Absicht ist und welche ein Fehler wäre.

| **Rolle** | **Schwachstelle** | **ATT&CK** | **Lernziel** |
|---|---|---|---|
| **vuln_weak_passwords** | Schwache, wiederverwendete Passwörter einiger Benutzer | T1110 Brute Force | Erkennen von Password Spraying (4625/4771) |
| **ad_vulns_kerberoast** | Dienstkonto mit SPN und schwachem Passwort | T1558.003 | Kerberoasting erkennen (4769, RC4) |
| **vuln_asrep** | Konto ohne Kerberos-Vorauthentifizierung | T1558.004 | AS-REP-Roasting erkennen |
| **vuln_acl** | Zu weitreichende AD-Berechtigung (GenericAll auf Gruppe) | T1098 | Rechteausweitung nachvollziehen |
| **vuln_smb_share** | Freigabe mit Passwörtern in Skripten | T1552.001 | Credential-Funde, Datei-Auditing |
| **vuln_web_sqli** | SQL-Injection im Webshop | T1190 | Web-Angriffe in Logs/IDS erkennen |
| **vuln_local_admin** | Gleiches lokales Admin-Passwort auf allen Clients | T1078.003 | Lateral Movement eindämmen (Lösung: LAPS) |

Tabelle 46: Katalog absichtlicher Schwachstellen (Auszug)

## Simulierte Benutzer mit GHOSTS

Ohne normale Benutzeraktivität ist jede Anomalie trivial zu finden: Wenn im Netz nur der Angreifer etwas tut, ist **jede** Verbindung verdächtig. GHOSTS (General HOSTS) vom CMU Software Engineering Institute löst das: Ein Client auf jedem Arbeitsplatz führt **Timelines** aus – zeitgesteuerte Abfolgen von Tätigkeiten. Die zentrale GHOSTS-API (Docker, Port 5000, mit Postgres und Grafana auf Port 3000) verteilt Timelines und sammelt Ergebnisse.

**GHOSTS-Timeline (vereinfacht, Struktur gemäß GHOSTS-Doku)**

```
{
  "Status": "Run",
  "TimeLineHandlers": [
    { "HandlerType": "BrowserFirefox", "Initial": "about:blank", "UtcTimeOn": "07:00:00", "UtcTimeOff": "16:00:00",
      "Loop": true,
      "TimeLineEvents": [
        { "Command": "random", "CommandArgs": ["https://news.example.lab", "https://shop.nordwind.lab", "https://wiki.example.lab"],
          "DelayAfter": 90000, "DelayBefore": 0 } ] },
    { "HandlerType": "Outlook", "UtcTimeOn": "07:00:00", "UtcTimeOff": "16:00:00", "Loop": true,
      "TimeLineEvents": [ { "Command": "reply", "CommandArgs": ["CurrentUser", "random"], "DelayAfter": 600000 } ] }
  ]
}
```

Im Szenario »Operation Nordlicht« öffnet ein GHOSTS-Benutzer zu einem festgelegten Zeitpunkt den präparierten Mailanhang – der »Mitarbeiter« ist damit Teil des Drehbuchs, ohne dass ein Mensch eingreifen muss.

## Werkzeuge des Red Teams

| **Werkzeug** | **Zweck** | **Einsatz** |
|---|---|---|
| **Kali Linux** | Distribution mit Hunderten Sicherheitswerkzeugen | Arbeitsplatz der Angreifer |
| **Nmap** | Netzwerk- und Portscans | Aufklärung |
| **Impacket, NetExec** | Protokollwerkzeuge für SMB, Kerberos, LDAP, WMI | AD-Angriffe, Lateral Movement |
| **BloodHound** | Graphanalyse von AD-Berechtigungen | Angriffspfade finden |
| **MITRE Caldera** | Automatisierte Angreifer-Emulation (Agent »Sandcat«, Server Port 8888) | Reproduzierbare Angriffsketten |
| **Atomic Red Team** | Kleine Testfälle je ATT&CK-Technik | Detektionen gezielt prüfen |
| **Sliver / Mythic** | C2-Frameworks | Realistische Fernsteuerung |

Tabelle 47: Red-Team-Werkzeuge

> [!WARNUNG] Automatisierte Angriffe = gleiche Bedingungen
> Für faire Bewertung mehrerer Blue Teams sollte die Angriffskette weitgehend **automatisiert** laufen (Caldera-Operationen, Skripte). Ein menschliches Red Team handelt flexibler, aber nicht identisch gegen alle Teams.

## Struktur des Active Directory

Das Active Directory der fiktiven Firma ist absichtlich wie in einem echten mittelständischen Unternehmen aufgebaut – mit gewachsenen Strukturen, Altlasten und Fehlern. Gleichzeitig folgt es dem **Tier-Modell**, damit das Blue Team die Verstöße dagegen erkennen und beheben kann.

![Abbildung 24: AD-Gesamtstruktur, Organisationseinheiten und Tier-Modell im Szenario](asset:cyberrange/cr-07-024.png)

**So liest man die Abbildung:**

- Oben stehen **Gesamtstruktur** (Forest) und **Domäne** mit zwei Domänencontrollern.
- Darunter liegen die **Organisationseinheiten** nach Tiers: Tier 0 (rot) enthält alles, was die Domäne kontrolliert, Tier 1 die Server, Tier 2 die Arbeitsplätze.
- Die graue OU enthält range-interne Objekte (NPC-Konten, Scoring-Konten, Köder), die für Teilnehmer wie normale Objekte aussehen.
- Unten sind die **absichtlichen Fehler** genannt, die das Szenario ausnutzt.
**PowerShell – OUs, Dienstkonto und absichtliche Fehlkonfiguration**

```
# Auszug aus der Ansible-Rolle ad_objects (PowerShell über win_shell)
Import-Module ActiveDirectory
$base = "DC=nordwind,DC=lab"
foreach ($ou in "Tier0","Tier1","Tier2","RangeIntern") {
  New-ADOrganizationalUnit -Name $ou -Path $base -ProtectedFromAccidentalDeletion $true
}
New-ADOrganizationalUnit -Name "Benutzer" -Path "OU=Tier2,$base"
# Dienstkonto mit SPN und schwachem Passwort  -> Ziel für Kerberoasting (T1558.003)
New-ADUser -Name "svc_sql" -Path "OU=Tier1,$base" -Enabled $true `
  -AccountPassword (ConvertTo-SecureString "Sommer2026!" -AsPlainText -Force) `
  -ServicePrincipalNames "MSSQLSvc/fs01.nordwind.lab:1433" -PasswordNeverExpires $true
# Helpdesk-Gruppe mit zu weitreichenden Rechten -> Rechteausweitung (BloodHound-Pfad)
dsacls "CN=Server-Admins,OU=Tier1,$base" /G "NORDWIND\Helpdesk:GA"
```

Die Benutzer werden aus einer CSV-Datei mit fiktiven Namen, Abteilungen und Telefonnummern erzeugt (z. B. 120 Mitarbeitende in Vertrieb, Lager, Disposition, Verwaltung). Werkzeuge wie **BadBlood** oder eigene Skripte erzeugen zusätzlich zufällige, aber reproduzierbare Strukturen mit Gruppenschachtelungen und Berechtigungsfehlern – wichtig ist ein fester Zufalls-Startwert (Seed), damit jede Range-Kopie identisch ist.

## Simulierte Benutzer mit GHOSTS im Detail

Eine Range ohne Benutzer ist unrealistisch still: Jede Verbindung wäre verdächtig, und das Blue Team könnte Angriffe allein durch das Vorhandensein von Verkehr erkennen. GHOSTS (von CMU SEI) erzeugt deshalb glaubwürdigen Hintergrundverkehr.

![Abbildung 25: Architektur von GHOSTS mit API, Clients und Handlern](asset:cyberrange/cr-07-025.png)

**So liest man die Abbildung:**

- Die **GHOSTS-API** verwaltet Maschinen, Gruppen und Timelines und speichert alles in PostgreSQL.
- Auf jeder NPC-VM läuft ein **GHOSTS-Client**, der seine Timeline abholt und über **Handler** ausführt (Browser, Office, Mail, SSH …).
- Das **White Team** kann während der Übung neue Timelines einspielen – z. B. »Benutzer X öffnet um 10:15 den Phishing-Anhang«.
- **Grafana** zeigt, welche Aktivitäten tatsächlich stattgefunden haben.
**GHOSTS-Timeline: ein Benutzer surft während der Arbeitszeit (UTC)**

```
{
  "Status": "Run",
  "TimeLineHandlers": [
    {
      "HandlerType": "BrowserFirefox",
      "Initial": "about:blank",
      "UtcTimeOn": "06:00:00", "UtcTimeOff": "15:30:00",
      "Loop": true,
      "TimeLineEvents": [
        { "Command": "random",
          "CommandArgs": [ "https://intranet.nordwind.lab", "https://news-sim.com",
                           "https://nordwind-logistik.de/shop" ],
          "DelayAfter": 45000, "DelayBefore": 0 }
      ]
    }
  ]
}
```

> [!TIPP] Realismus durch Rhythmus
> Echte Büros haben Muster: Login-Welle um 8 Uhr, Mittagsloch, Mail-Spitzen nach Besprechungen. Timelines mit Zeitfenstern (`UtcTimeOn/Off`) und zufälligen Verzögerungen bilden diese Muster nach. Ein guter Test: Kann das Blue Team in einer Stunde Verkehr ohne Angriff **keinen** Alarm finden? Dann ist das Grundrauschen realistisch.

## Erweiterter Schwachstellenkatalog mit ATT&CK-Zuordnung

Jede Schwachstelle im Szenario ist bewusst gewählt, dokumentiert und einer ATT&CK-Technik zugeordnet. So weiß das White Team genau, was die Teams lernen sollen, und das Blue Team kann seine Erkennung systematisch prüfen.

| **Nr.** | **Schwachstelle** | **System** | **ATT&CK** | **Erwartete Spur** |
|---|---|---|---|---|
| **V1** | Phishing mit Makro-/ISO-Anhang | ws-Clients | T1566.001 | Sysmon 1 (Office → cmd/powershell) |
| **V2** | SQL-Injection im Login | web01 | T1190 | Webserver-Log, Suricata-Alarm |
| **V3** | Datei-Upload ohne Prüfung → Webshell | web01 | T1505.003 | FIM-Alarm, Zeek http.log |
| **V4** | sudo-Regel für www-data auf `find` | web01 | T1548.003 | auditd, Wazuh |
| **V5** | Kerberoasting (svc_sql) | dc01 | T1558.003 | EID 4769 mit RC4 (0x17) |
| **V6** | AS-REP-Roasting (Konto ohne Vorauth.) | dc01 | T1558.004 | EID 4768, PreAuthType 0 |
| **V7** | LLMNR/NBT-NS aktiv, SMB-Signing aus | CORP | T1557.001 | Zeek ntlm.log, EID 4624 Typ 3 |
| **V8** | Helpdesk mit GenericAll auf Server-Admins | AD | T1098 | EID 4728/4732 (Gruppenänderung) |
| **V9** | Passwort in GPO-Preference (cpassword) | SYSVOL | T1552.006 | Zugriffe auf Groups.xml (5145) |
| **V10** | Lokaler Admin überall gleich | ws-Clients | T1078.003 | Pass-the-Hash: 4624 Typ 3 + NTLM |
| **V11** | ADCS-Vorlage ESC1 (Subject frei wählbar) | PKI | T1649 | EID 4886/4887 auf der CA |
| **V12** | Replikationsrechte für Backup-Konto → DCSync | AD | T1003.006 | EID 4662 mit Replikations-GUIDs |
| **V13** | Unverschlüsselte Backups auf Fileserver | fs01 | T1005 | Zugriffe 5145, große SMB-Transfers |
| **V14** | Exfiltration über DNS möglich | Firewall | T1048.003 | lange Subdomains in dns.log |

Tabelle 48: Schwachstellenkatalog mit ATT&CK-Technik und erwarteter Spur

> [!GEFAHR] Schwachstellen nur im Übungsnetz
> Die Ansible-Rolle `vulns` darf ausschließlich auf Hosts im Übungsnetz laufen. Ein Schutzmechanismus im Playbook prüft vor jedem Task, ob die Zieladresse in einem Range-Präfix (10.10.0.0/16) liegt, und bricht sonst ab.

## Artefakte: was die Firma »echt« macht

Realismus entsteht durch Details, die mit der eigentlichen Technik nichts zu tun haben, aber Analysten fordern: Inhalte auf Fileservern, E-Mail-Verläufe, ein Intranet mit Telefonliste, Tickets im Helpdesk-System. Diese **Artefakte** werden einmal erstellt und mit dem Szenario versioniert.

| **Artefakt** | **Beispiel** | **Nutzen in der Übung** |
|---|---|---|
| **Dokumente** | Angebote, Netzpläne, Passwortliste »alt.xlsx« | Ziel für Datenabfluss; Spuren beim Zugriff |
| **E-Mail-Verläufe** | Projektmails, Rechnungen, Newsletter | Phishing glaubwürdig einbetten |
| **Intranet** | Organigramm, Telefonliste, IT-Anleitungen | Aufklärung für das Red Team, Kontext für Blue |
| **Helpdesk-Tickets** | »Drucker geht nicht«, »Passwort vergessen« | Social Engineering, Inject-Material |
| **Logs der Vorgeschichte** | Simulierte Vorwoche ohne Angriff | Basislinie für Anomalie-Erkennung |

Tabelle 49: Artefakte für ein glaubwürdiges Szenario

## Personas: wer die simulierten Mitarbeitenden sind

GHOSTS kann beliebige Aktivitäten erzeugen – aber erst durch **Personas** wird daraus ein glaubwürdiger Büroalltag. Eine Persona beschreibt eine typische Mitarbeiterin oder einen typischen Mitarbeiter: Abteilung, Arbeitszeiten, genutzte Programme, Kommunikationspartner und Gewohnheiten.

![Abbildung 26: Tagesrhythmen verschiedener Personas](asset:cyberrange/cr-07-026.png)

**So liest man die Abbildung:**

- Jede Linie ist eine **Persona** mit typischem Tagesablauf; die y-Achse zeigt die Zahl der Aktionen pro Stunde.
- Der **Vertrieb** hat Spitzen am Morgen (Mails) und am Nachmittag (Kundentermine), die **Disposition** arbeitet stark mit dem Fileserver am Vormittag.
- Der **Helpdesk** ist gleichmäßig aktiv, die **Geschäftsführung** nur zu wenigen Zeitpunkten.
- In der **Mittagspause** sinkt die Aktivität deutlich – ein Angriff in dieser Zeit fällt im Verkehr stärker auf.
| **Persona** | **Anzahl** | **Typische Aktivitäten** | **Besonderheit für die Übung** |
|---|---|---|---|
| **Vertrieb** | 6 | Mail, Web (Kunden, News), CRM-Webanwendung, Telefonliste | hohe Mailmenge, klickt eher auf Links |
| **Disposition / Lager** | 5 | Fileserver, Tabellen, Lieferanten-Webportal | viele SMB-Zugriffe – Grundrauschen für Lateral-Movement-Erkennung |
| **Buchhaltung** | 3 | Rechnungs-PDFs, Bank-Webseite (SINET), Mail | Ziel von Rechnungs-Phishing |
| **IT-Helpdesk** | 2 | RDP zu Servern, Admin-Werkzeuge, Ticketsystem | legitime Admin-Aktivität, die Angriffen ähnelt |
| **Geschäftsführung** | 1 | Mail, Kalender, Intranet | seltene, aber privilegierte Anmeldungen |

Tabelle 50: Personas der Nordwind Logistik GmbH

> [!TIPP] Legitime Admin-Aktivität ist wichtig
> Der Helpdesk sorgt für **echte** RDP-Anmeldungen, Fernwartung und Dienstneustarts. Ohne diese Aktivität wäre jede Admin-Handlung des Red Teams sofort verdächtig. Mit ihr muss das Blue Team lernen, legitime von bösartiger Verwaltung zu unterscheiden – genau wie im echten Betrieb.

## Szenario-Daten reproduzierbar erzeugen

Benutzerkonten, Dokumente, Mail-Verläufe und Telefonlisten werden nicht von Hand geschrieben, sondern per Skript erzeugt. Damit jede Range-Kopie **identisch** ist, wird ein fester **Seed** verwendet – derselbe Startwert erzeugt immer dieselben »zufälligen« Daten.

**Mitarbeiterliste mit Faker und festem Seed**

```
#!/usr/bin/env python3
"""Erzeugt die Mitarbeiterliste der fiktiven Nordwind Logistik GmbH (reproduzierbar)."""
import csv
from faker import Faker

fake = Faker("de_DE")
Faker.seed(20261120)                 # fester Seed: jede Range bekommt dieselben Personen
ABTEILUNGEN = {"Vertrieb": 30, "Disposition": 35, "Lager": 25, "Buchhaltung": 12, "IT": 6, "Leitung": 3}

with open("mitarbeiter.csv", "w", newline="", encoding="utf-8") as f:
    w = csv.writer(f, delimiter=";")
    w.writerow(["vorname", "nachname", "sam", "abteilung", "telefon", "titel"])
    for abt, n in ABTEILUNGEN.items():
        for _ in range(n):
            vn, nn = fake.first_name(), fake.last_name()
            sam = (vn[0] + nn).lower().replace("ä", "ae").replace("ö", "oe").replace("ü", "ue").replace("ß", "ss")[:20]
            w.writerow([vn, nn, sam, abt, fake.phone_number(), fake.job()])
```

| **Datenart** | **Werkzeug / Quelle** | **Hinweis** |
|---|---|---|
| **Personen** | Faker mit festem Seed | nur erfundene Personen; Ähnlichkeiten mit echten sind Zufall |
| **Dokumente** | Vorlagen + Skript (Platzhalter füllen) | Angebote, Rechnungen, Lieferscheine; keine echten Firmendaten |
| **Mail-Verläufe** | Vorlagen je Persona, per Skript in Postfächer importiert | Verlauf über »Vorwoche« verteilt |
| **Webseiten der Kulissen** | statische Seiten, einmal gestaltet | fiktive Marken und Logos |
| **Log-Vorgeschichte** | GHOSTS-Lauf im Vorfeld (z. B. 3 Tage) | liefert eine Basislinie für das Blue Team |

Tabelle 51: Erzeugung von Szenario-Daten
