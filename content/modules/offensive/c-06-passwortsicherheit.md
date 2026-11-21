---
id: c-06
title: Passwortsicherheit und Anmeldedaten
paths: cpts, cjca, specialist
order: 6
difficulty: medium
icon: key.horizontal
summary: Warum Passwörter das schwächste Glied sind, wie Hashes gespeichert und geprüft werden, Credential Stuffing und Password Spraying verstehen, Passwortrichtlinien nach NIST und BSI, MFA und Passkeys.
htb: Password Attacks
---

## Warum Anmeldedaten so begehrt sind

Mit gültigen Anmeldedaten sieht ein Angreifer aus wie ein normaler Benutzer – keine Schadsoftware, kein Exploit, kaum Alarme. Deshalb gehören gestohlene oder erratene Zugangsdaten seit Jahren zu den häufigsten Einfallstoren.

## Wo Passwörter gespeichert sind

| System | Speicherort | Format |
|---|---|---|
| Linux | `/etc/shadow` | gesalzene Hashes (yescrypt, SHA-512-crypt) |
| Windows lokal | SAM-Datenbank | NT-Hash (ungesalzen) |
| Active Directory | `NTDS.dit` auf DCs | NT-Hashes, Kerberos-Schlüssel |
| Windows-Speicher | LSASS-Prozess | Anmeldeinformationen aktiver Sitzungen |
| Anwendungen | Datenbanken, Konfigurationsdateien | sehr unterschiedlich – oft der schwächste Punkt |
| Browser / Passwortmanager | verschlüsselte Tresore | abhängig vom Master-Passwort |

> [!WARNUNG] Wiederverwendung
> Ein Passwort aus einer Konfigurationsdatei, einem Skript oder einem Datenleck funktioniert erstaunlich oft auch an anderer Stelle. Passwort-Wiederverwendung macht aus einem kleinen Fund einen großen Schaden.

## Angriffsmuster verstehen

| Muster | Vorgehen | Erkennungsmerkmal | Gegenmaßnahme |
|---|---|---|---|
| Brute Force | viele Passwörter gegen ein Konto | viele Fehlversuche pro Konto | Sperrung/Verzögerung, MFA |
| [[Password Spraying]] | wenige häufige Passwörter gegen viele Konten | Fehlversuche verteilt über viele Konten | Passwort-Blocklisten, MFA, Monitoring |
| Credential Stuffing | Kombinationen aus fremden Datenlecks | Logins von vielen IPs, hohe Erfolgsrate bei bestimmten Konten | MFA, Leak-Abgleich, Bot-Schutz |
| Offline-Cracking | gestohlene Hashes lokal durchprobieren | nicht im Netz sichtbar – Erkennung beim Diebstahl der Hashes | langsame Hashverfahren, lange Passwörter |

## Warum Hashverfahren wichtig sind

Schnelle Hashes (MD5, SHA-1, NT-Hash) lassen sich mit Grafikkarten in Milliarden Versuchen pro Sekunde prüfen. Langsame, gesalzene Verfahren (Argon2, bcrypt, scrypt) machen jeden Versuch teuer. Wie das funktioniert, steht in [[mod:f-08|Kryptografie]].

## Gute Passwortrichtlinien

Moderne Empfehlungen (NIST SP 800-63B, BSI) haben sich deutlich verändert:

| alt | heute |
|---|---|
| Komplexitätsregeln (Sonderzeichen-Pflicht) | **Länge** zählt (mind. 12–15 Zeichen, Passphrasen) |
| regelmäßiger Zwangswechsel | Wechsel nur bei Verdacht auf Kompromittierung |
| keine Prüfung gegen Leaks | Abgleich mit Listen bekannter und kompromittierter Passwörter |
| Passwort allein | **MFA**, idealerweise phishing-resistent |

## Mehr als Passwörter

- **MFA** – etwas, das man weiß, hat oder ist. SMS ist besser als nichts, aber anfällig; Authenticator-Apps sind besser; **FIDO2-Sicherheitsschlüssel und Passkeys** sind phishing-resistent.
- **Passwortmanager** – ermöglichen lange, einzigartige Passwörter für jeden Dienst.
- **Privileged Access Management** – Admin-Passwörter rotieren automatisch und sind nur bei Bedarf abrufbar.
- **LAPS** – eindeutige lokale Admin-Passwörter pro Windows-Rechner.
- **Dienstkonten** – als gMSA mit automatisch rotierenden, langen Passwörtern.

## Quiz

? Wie heißt das Muster, bei dem wenige häufige Passwörter gegen viele Konten getestet werden?
= Password Spraying

? Wie heißt das Muster, bei dem Zugangsdaten aus fremden Datenlecks durchprobiert werden?
= Credential Stuffing

? Welche Eigenschaft ist laut NIST für Passwörter am wichtigsten?
+ Länge
- Sonderzeichen-Pflicht
- monatlicher Wechsel
- Großbuchstaben am Anfang

?tf NIST empfiehlt regelmäßigen Zwangswechsel von Passwörtern ohne Anlass.
= falsch

? Welche MFA-Verfahren sind phishing-resistent?
+ FIDO2-Sicherheitsschlüssel
+ Passkeys
- SMS-Codes
- E-Mail-Codes

? In welcher Datei speichert Active Directory die Passwort-Hashes?
= NTDS.dit

? Welches Microsoft-Werkzeug vergibt eindeutige lokale Admin-Passwörter pro Rechner?
= LAPS

? Woran erkennt man Password Spraying in den Logs?
+ Fehlversuche verteilt über viele Konten mit wenigen Versuchen pro Konto
- viele Fehlversuche gegen ein einzelnes Konto
- keine Fehlversuche
- nur erfolgreiche Anmeldungen
