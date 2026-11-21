---
id: b-02
title: SQL-Injection verstehen und verhindern
paths: cwes, cpts, cwee
order: 7
difficulty: medium
icon: cylinder.split.1x2.fill
summary: Wie SQL-Injection entsteht, welche Varianten es gibt (In-Band, Blind, Out-of-Band, Second Order), welche Folgen sie hat, wie man sie im Code und in Logs erkennt und wie man sie zuverlässig verhindert.
---

## Die Ursache

SQL-Injection entsteht, wenn eine Anwendung eine Abfrage **durch Zusammensetzen von Text** baut:

```python
# UNSICHER – Benutzereingabe wird Teil des SQL-Codes
query = "SELECT * FROM users WHERE name = '" + name + "'"
```

Enthält `name` Zeichen mit Bedeutung für SQL (Anführungszeichen, Kommentarzeichen, Operatoren), verändert sich die Struktur der Abfrage. Die Datenbank kann nicht mehr unterscheiden, was Daten und was Befehl ist.

```python
# SICHER – Parameter werden getrennt übergeben
cur.execute("SELECT * FROM users WHERE name = %s", (name,))
```

> [!MERKE] Die eine Regel
> **Parametrisierte Abfragen (Prepared Statements)** verhindern SQL-Injection grundlegend, weil die Struktur der Abfrage feststeht, bevor die Daten eingesetzt werden. Escaping und Filter sind fehleranfällige Notlösungen.

## Varianten

| Variante | Woran man sie erkennt | Beschreibung |
|---|---|---|
| **In-Band (Error-based)** | Datenbankfehler in der Antwort | Fehlermeldungen geben Informationen preis |
| **In-Band (Union-based)** | Daten erscheinen in der Seite | Ergebnisse weiterer Abfragen werden angehängt |
| **Blind (Boolean)** | Seite unterscheidet sich je nach wahr/falsch | Informationen werden Bit für Bit erschlossen |
| **Blind (Time-based)** | Antwortzeit unterscheidet sich | Verzögerungen dienen als Ja/Nein-Signal |
| **Out-of-Band** | Datenbank baut externe Verbindung auf | Daten verlassen den Server über DNS/HTTP |
| **Second Order** | Wirkung tritt später ein | gespeicherte Eingabe wird erst bei späterer Verarbeitung gefährlich |

## Mögliche Auswirkungen

- vertrauliche Daten auslesen (Kundendaten, Passwort-Hashes)
- Anmeldung umgehen
- Daten verändern oder löschen
- je nach Datenbankrechten: Dateien lesen/schreiben oder Betriebssystembefehle ausführen
- Ausgangspunkt für weitere Angriffe im Netz

## Erkennen

**Im Code:** String-Verkettung oder Formatierung in Abfragen, „raw“-Methoden von ORMs, dynamische Spalten- oder Tabellennamen aus Eingaben, gespeicherte Prozeduren mit dynamischem SQL.

**Im Betrieb:**

| Signal | Quelle |
|---|---|
| Datenbank-Syntaxfehler in hoher Zahl | Anwendungs- und DB-Logs |
| SQL-Schlüsselwörter und Kommentarzeichen in Parametern | Webserver-Logs, WAF |
| ungewöhnlich lange Antwortzeiten bei bestimmten Parametern | APM, Logs |
| Abfragen auf `information_schema` durch das Anwendungskonto | DB-Audit-Log |

**In Prüfungen:** Werkzeuge wie **sqlmap** automatisieren das Erkennen und Nachweisen von SQL-Injection. Im Pentest werden sie nur im erlaubten Rahmen und mit Rücksicht auf Produktivdaten eingesetzt – Abfragen, die Daten verändern oder viel Last erzeugen, sind ohne Freigabe tabu.

## Verhindern – Defense in Depth

| Ebene | Maßnahme |
|---|---|
| Code | Prepared Statements, ORM korrekt nutzen, dynamische Bezeichner nur aus Allowlists |
| Validierung | Eingaben auf erwartetes Format prüfen (z. B. IDs nur Ziffern) |
| Datenbank | Least Privilege, keine gefährlichen Funktionen, getrennte Konten für Lesen/Schreiben |
| Fehlerbehandlung | keine Datenbankfehler an Benutzer ausgeben |
| Infrastruktur | WAF als zusätzliche Schicht, Monitoring, Datenbank nicht aus dem Netz erreichbar |
| Daten | sensible Daten verschlüsseln, Passwörter mit Argon2/bcrypt |

## Quiz

? Was ist die grundlegende Ursache von SQL-Injection?
+ Abfragen werden durch Zusammensetzen von Text mit Benutzereingaben gebaut
- die Datenbank ist zu alt
- die Website nutzt HTTPS
- die Tabellen haben keinen Index

? Welche Maßnahme verhindert SQL-Injection grundlegend?
= Prepared Statements
= parametrisierte Abfragen

? Welche Variante nutzt Unterschiede in der Antwortzeit?
= Time-based
= Blind Time-based
= zeitbasiert

? Wie heißt die Variante, bei der eine gespeicherte Eingabe erst später gefährlich wird?
= Second Order

? Welches Werkzeug automatisiert das Nachweisen von SQL-Injection?
= sqlmap

? Welche Signale können auf SQL-Injection-Versuche hindeuten?
+ viele Datenbank-Syntaxfehler
+ Abfragen des Anwendungskontos auf information_schema
- erfolgreiche Logins am Morgen
- ein Zertifikatswechsel

?tf Eine WAF macht parametrisierte Abfragen überflüssig.
= falsch
