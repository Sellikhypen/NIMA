---
id: cr-20
title: Beispielszenario »Operation Nordlicht«
paths: cyberrange
order: 20
difficulty: medium
icon: scope
summary: Kapitel 20 deiner Cyber-Range-Dokumentation: Beispielszenario »Operation Nordlicht«.
source: Cyber_Range_Dokumentation.docx
htb: 
---

## Lage und Lernziele

Die fiktive **Nordwind Logistik GmbH** (`nordwind.lab`) betreibt einen Webshop in der DMZ, einen Mailserver, einen Dateiserver und Active Directory. Eine kriminelle Gruppe verschafft sich per Phishing Zugang, bewegt sich lateral, schleust Kundendaten aus (Exfiltration) und verschlüsselt den Dateiserver (Ransomware). Das Blue Team übernimmt die Rolle des internen SOC.

| **Nr.** | **Lernziel (messbar)** | **Nachweis** |
|---|---|---|
| **LZ1** | Phishing-Ausführung innerhalb von 20 Min. erkennen | Ticket mit Host, Prozess, Zeit |
| **LZ2** | Kerberoasting identifizieren und das betroffene Konto benennen | SIEM-Abfrage auf 4769 (0x17), Bericht |
| **LZ3** | Lateral Movement eindämmen (Host isolieren) ohne Webshop-Ausfall | Service-Check grün, Firewall-Regel |
| **LZ4** | Exfiltrationskanal und Datenmenge bestimmen | Zeek-Analyse (conn/http.log), Bericht |
| **LZ5** | Meldung an Geschäftsführung und Behörde (Inject) korrekt formulieren | Bewertung durch White Team |

Tabelle 130: Lernziele

## Angriffskette

![Abbildung 59: Angriffskette von »Operation Nordlicht« über die Zeit](asset:cyberrange/cr-20-059.png)

| **Phase** | **Taktik** | **Technik (ID)** | **Umsetzung** | **Erwartete Telemetrie** |
|---|---|---|---|---|
| **1** | Initial Access | Spearphishing Attachment (T1566.001) | Mail mit Office-Dokument an ws01 | Mail-Log, Zeek smtp.log |
| **2** | Execution | Malicious File (T1204.002), PowerShell (T1059.001) | GHOSTS-NPC öffnet Anhang, Payload startet | Sysmon 1 (winword → powershell), 4688 |
| **3** | Command & Control | Web Protocols (T1071.001) | HTTPS-Beacon zum Redirector im SINET | Sysmon 3/22, Zeek ssl.log (Beaconing), JA4 |
| **4** | Persistence | Scheduled Task (T1053.005) | schtasks /create … | Event 4698, Sysmon 1 |
| **5** | Discovery | Domain Account Discovery (T1087.002) | LDAP-Enumeration | Viele LDAP-Abfragen (Zeek) |
| **6** | Credential Access | Kerberoasting (T1558.003), LSASS Memory (T1003.001) | TGS für SPN, Dump auf ws01 | 4769 mit RC4 (0x17), Sysmon 10 auf lsass.exe |
| **7** | Lateral Movement | SMB/Admin Shares (T1021.002) | PsExec-ähnliche Ausführung auf fs01 | 7045, 4624 Typ 3, Zeek smb_files.log |
| **8** | Exfiltration | Over C2 Channel (T1041) | Upload von Kundendaten | Zeek conn.log: große orig_bytes |
| **9** | Impact | Data Encrypted for Impact (T1486) | Simulierte Verschlüsselung harmloser Testdateien | Sysmon 11 (Massenumbenennung), Service-Check rot |

Tabelle 131: Angriffskette mit ATT&CK-Zuordnung

## Drehbuch (MSEL, Auszug)

| **Zeit** | **Inject** | **Von → An** | **Erwartete Reaktion** |
|---|---|---|---|
| **T+0:00** | STARTEX, Lagebriefing | White → alle | Teams beziehen Positionen |
| **T+0:15** | Phishing-Mail zugestellt (Phasen 1–3) | Red → ws01 | Blue erkennt Prozesskette (LZ1) |
| **T+0:45** | Helpdesk-Anruf: »PC ist langsam« | White → Blue | Triage, Host-Analyse |
| **T+1:15** | Phasen 4–6 | Red | Blue erkennt Kerberoasting (LZ2) |
| **T+2:00** | Phase 7, Webshop muss online bleiben | Red / White | Eindämmung ohne Ausfall (LZ3) |
| **T+2:45** | Presseanfrage zu »Datenleck« | White → Blue-Lead | Abstimmung, Sprachregelung |
| **T+3:15** | Phasen 8–9 | Red | Exfiltration bestimmen (LZ4), Wiederherstellung |
| **T+3:45** | Anweisung GF: Meldung vorbereiten | White → Blue | Meldung (LZ5) |
| **T+4:00** | ENDEX | White → alle | Logs sichern, Hot-Wash |

Tabelle 132: Master Scenario Events List (Auszug)

## Automatisierung der Angriffskette

Damit alle Blue Teams identische Bedingungen haben, wird die Kette als **Caldera-Operation** hinterlegt: Ein Sandcat-Agent auf ws01 (Port 8888 zum Caldera-Server im RED-Netz) führt die Fähigkeiten (»abilities«) in der Reihenfolge eines Angreiferprofils aus. Für einzelne Techniken werden Atomic-Red-Team-Tests verwendet. Das Red Team überwacht den Ablauf und greift nur bei Bedarf manuell ein.

## Ablauf eines Übungstags

![Abbildung 60: Zeitlicher Ablauf eines Übungstags »Operation Nordlicht«](asset:cyberrange/cr-20-060.png)

**So liest man die Abbildung:**

- Jede Zeile ist eine **Rolle**. Das White Team steuert mit Briefing, STARTEX, drei Injects, ENDEX und Hot-Wash.
- Das **Red Team** arbeitet die Angriffskette in fünf Blöcken ab; die Zeiten stammen aus der MSEL.
- Das **Blue Team** beginnt mit Lagefeststellung und Härtung und ist danach durchgehend im Einsatz.
- **NPCs** und **Scoring** laufen den ganzen Tag im Hintergrund.
## Erweitertes Drehbuch für einen ganzen Übungstag

Das Drehbuch aus Kapitel 20.3 ist für eine vierstündige Kompaktübung ausgelegt. Für einen ganzen Übungstag (Abbildung oben) wird es gestreckt und um eine zweite Eskalationsstufe (Rechteausweitung mit DCSync) sowie einen alternativen Exfiltrationskanal (DNS) ergänzt. Die Lernziele LZ1–LZ5 bleiben gleich.

| **Nr.** | **Zeit** | **Ereignis / Inject** | **Von → An** | **Erwartete Reaktion** | **Lernziel** |
|---|---|---|---|---|---|
| **M01** | 09:00 | STARTEX, Lagebild »Normalbetrieb« | White → Blue | Bestandsaufnahme, Monitoring prüfen | – |
| **M02** | 09:20 | Phishing-Welle an 15 Mitarbeitende | Red → NPCs | Erkennung über Mail-Logs / Meldungen | LZ1 |
| **M03** | 09:45 | NPC ws07 öffnet Anhang, Beacon startet | GHOSTS / Red | Beacon im conn.log/ssl.log finden | LZ1 |
| **M04** | 10:30 | Discovery im AD (LDAP-Abfragen, BloodHound) | Red | Auffällige LDAP-Last erkennen | LZ2 |
| **M05** | 11:00 | Inject 1: Geschäftsführung fragt nach Lage | White → Blue | Lagebericht in 20 Min. | LZ5 |
| **M06** | 12:30 | Kerberoasting svc_sql | Red | EID 4769 mit RC4 erkennen | LZ2 |
| **M07** | 13:15 | Anmeldung als svc_sql auf fs01, Lateral Movement | Red | 4624 Typ 3, ungewöhnliche Quelle | LZ3 |
| **M08** | 13:30 | Inject 2: Mitarbeiter meldet Anruf vom »IT-Support« | White → Blue | Social Engineering einordnen | LZ5 |
| **M09** | 14:00 | Rechteausweitung über Helpdesk-Gruppe, DCSync | Red | EID 4728, 4662 erkennen, eindämmen | LZ3 |
| **M10** | 15:00 | Simulierte Verschlüsselung auf fs01 | Red | Dienstausfall, Wiederherstellung | LZ3 |
| **M11** | 15:30 | Inject 3: Erpresserschreiben + Presseanfrage | White → Blue | Entscheidungsvorlage, Meldepflichten prüfen | LZ5 |
| **M12** | 16:00 | Exfiltration über DNS | Red | DNS-Tunnel erkennen und blockieren | LZ4 |
| **M13** | 16:30 | ENDEX | White → alle | Abschlussbericht bis 17:00 | – |

Tabelle 133: Erweiterte MSEL »Operation Nordlicht« (ganzer Übungstag)

## Musterlösung für das Blue Team

Für die Bewertung und den AAR braucht das White Team eine Musterlösung: Was hätte ein sehr gutes Team wann gefunden und getan? Die Musterlösung wird **nicht** an die Teilnehmer ausgegeben, sondern dient als Maßstab.

| **Phase** | **Beste Erkennung** | **Beste Reaktion** | **Spätester akzeptabler Zeitpunkt** |
|---|---|---|---|
| **Phishing** | Zeek smtp.log: Absender-Domain nordwind-logistlk.de, Anhang .iso; Meldung von NPC-Konto | Domain auf DNS/Mail-Gateway blocken, Postfächer bereinigen | 10:15 |
| **Beacon** | ssl.log: Verbindungen alle ~60 s zu nordwind-cloud.com, seltenes JA4 | ws07 isolieren (Firewall-Regel), Speicherabbild sichern | 11:00 |
| **Kerberoasting** | Wazuh/Sigma: 4769 mit Ticket-Verschlüsselung 0x17 für svc_sql | Passwort svc_sql ändern (lang, zufällig), SPN prüfen | 13:30 |
| **Rechteausweitung / DCSync** | 4728 (Helpdesk → Server-Admins), 4662 mit Replikations-GUIDs von Nicht-DC | Gruppenmitgliedschaft entfernen, krbtgt zweimal zurücksetzen | 14:45 |
| **Verschlüsselung** | FIM: Massen-Umbenennungen, Dienst-Check rot | Freigabe trennen, Snapshot/Backup zurückspielen | 15:30 |
| **Exfiltration DNS** | dns.log: Labels > 50 Zeichen an eine Zone | Zone sperren, Umfang der Daten abschätzen | 16:20 |

Tabelle 134: Musterlösung (nur für das White Team)

> [!INFO] Warum »spätester akzeptabler Zeitpunkt«?
> Die Bewertung belohnt nicht nur, **ob** etwas gefunden wurde, sondern **wann**. Findet ein Team den Beacon erst nach dem Kerberoasting, hat es zwar richtig analysiert, aber die Chance verpasst, den Angriff früh zu stoppen. Der AAR macht genau diesen Unterschied sichtbar.
