---
id: f-14
title: Datenbanken und SQL-Grundlagen
paths: grundlagen, cjca, cwes, cpts
order: 14
difficulty: easy
icon: cylinder.split.1x2
summary: Relationale Datenbanken, Tabellen und Schlüssel, die wichtigsten SQL-Befehle, Joins und Unions, Benutzer und Rechte, NoSQL – das Fundament, um SQL-Injection und Datenbanksicherheit zu verstehen.
htb: SQL Injection Fundamentals
---

## Relationale Datenbanken

Eine relationale Datenbank speichert Daten in **Tabellen** aus Zeilen (Datensätzen) und Spalten (Attributen). Beziehungen entstehen über Schlüssel.

| Begriff | Bedeutung |
|---|---|
| Primärschlüssel | eindeutige ID einer Zeile |
| Fremdschlüssel | verweist auf den Primärschlüssel einer anderen Tabelle |
| Index | beschleunigt Suchen |
| Schema | Struktur aller Tabellen |
| DBMS | Datenbankmanagementsystem: MySQL/MariaDB, PostgreSQL, Microsoft SQL Server, Oracle, SQLite |

## Die wichtigsten SQL-Befehle

```sql
-- Daten lesen
SELECT name, email FROM users WHERE active = 1 ORDER BY name LIMIT 10;

-- Daten schreiben
INSERT INTO users (name, email) VALUES ('alice', 'alice@example.org');
UPDATE users SET active = 0 WHERE id = 42;
DELETE FROM sessions WHERE expires < NOW();

-- Struktur
CREATE TABLE notes (id INT PRIMARY KEY, user_id INT, text TEXT);
DROP TABLE notes;
```

| Kategorie | Befehle |
|---|---|
| DQL (Abfragen) | `SELECT` |
| DML (Daten ändern) | `INSERT`, `UPDATE`, `DELETE` |
| DDL (Struktur) | `CREATE`, `ALTER`, `DROP` |
| DCL (Rechte) | `GRANT`, `REVOKE` |

## Operatoren und Kommentare

| Element | Bedeutung |
|---|---|
| `AND`, `OR`, `NOT` | logische Verknüpfung – `AND` bindet stärker als `OR` |
| `LIKE 'adm%'` | Mustersuche (`%` beliebig viele Zeichen, `_` eines) |
| `IN (…)`, `BETWEEN` | Mengen, Bereiche |
| `--`, `#`, `/* */` | Kommentare (`#` nur MySQL) |

> [!MERKE] Warum Kommentare und Operatoren sicherheitsrelevant sind
> Wenn eine Anwendung Benutzereingaben direkt in eine Abfrage einsetzt, können Zeichen wie Anführungszeichen, Kommentarzeichen oder `OR` die Logik der Abfrage verändern. Das ist die Grundidee der [[mod:b-02|SQL-Injection]] – und der Grund, warum Abfragen immer **parametrisiert** werden müssen.

## Joins und Unions

```sql
-- JOIN: Spalten aus zwei Tabellen verbinden
SELECT u.name, o.total
FROM users u JOIN orders o ON o.user_id = u.id;

-- UNION: Ergebnisse zweier Abfragen untereinander anhängen
SELECT name FROM customers
UNION
SELECT name FROM suppliers;
```

Bei `UNION` müssen beide Abfragen **gleich viele Spalten** mit kompatiblen Typen liefern.

## Metadaten

Jede Datenbank beschreibt sich selbst:

| DBMS | Metadaten |
|---|---|
| MySQL/MariaDB, PostgreSQL, MSSQL | `information_schema.tables`, `information_schema.columns` |
| MSSQL zusätzlich | `sys.tables`, `sys.databases` |
| Oracle | `all_tables`, `all_tab_columns` |
| SQLite | `sqlite_master` |

## Benutzer und Rechte

Die Anwendung sollte mit einem eigenen Datenbankbenutzer arbeiten, der **nur** die nötigen Rechte auf **ihre** Tabellen hat – kein Admin, kein Zugriff auf Dateisystem- oder Systemfunktionen.

```sql
CREATE USER 'shop_app'@'10.10.30.%' IDENTIFIED BY '…';
GRANT SELECT, INSERT, UPDATE ON shop.* TO 'shop_app'@'10.10.30.%';
```

> [!WARNUNG] Gefährliche Rechte
> Rechte wie `FILE` (MySQL), `xp_cmdshell` (MSSQL) oder Superuser-Rollen machen aus einem Datenbankfehler schnell einen Zugriff auf das Betriebssystem. Sie gehören für Anwendungskonten deaktiviert.

## NoSQL

| Typ | Beispiel | Modell |
|---|---|---|
| Dokument | MongoDB, CouchDB | JSON-ähnliche Dokumente |
| Key-Value | Redis | Schlüssel → Wert |
| Spalten | Cassandra | breite Spalten |
| Graph | Neo4j | Knoten und Kanten (auch BloodHound) |

Auch NoSQL-Datenbanken sind anfällig für Injection, wenn Abfrageobjekte aus Benutzereingaben gebaut werden. Häufiger Befund: Datenbanken wie Redis, MongoDB oder Elasticsearch ohne Authentifizierung im Netz.

## Quiz

? Welcher SQL-Befehl liest Daten?
= SELECT

? Zu welcher SQL-Kategorie gehören GRANT und REVOKE?
= DCL

? Welche Bedingung muss bei UNION erfüllt sein?
+ beide Abfragen liefern gleich viele Spalten mit kompatiblen Typen
- beide Tabellen haben denselben Namen
- es gibt einen Primärschlüssel
- die Abfragen sind sortiert

? In welcher Datenbank liegen bei MySQL die Metadaten aller Tabellen?
= information_schema

? Welches Kommentarzeichen gibt es nur in MySQL?
= #

? Welches MSSQL-Feature ermöglicht Betriebssystembefehle und sollte deaktiviert sein?
= xp_cmdshell

? Welche Rechte braucht ein Anwendungskonto?
+ nur die nötigen Rechte auf die eigenen Tabellen
- Administratorrechte
- FILE-Rechte
- Zugriff auf alle Datenbanken

? Welcher Operator bindet in SQL stärker?
= AND
