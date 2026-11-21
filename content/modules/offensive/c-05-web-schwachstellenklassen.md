---
id: c-05
title: Web-Schwachstellenklassen im Überblick
paths: cwes, cpts, cwee
order: 5
difficulty: medium
icon: exclamationmark.triangle
summary: SQL-Injection, XSS, Command Injection, File Inclusion, Datei-Uploads, SSRF, XXE, SSTI, IDOR, CSRF und Deserialisierung – jeweils Ursache, Auswirkung, Erkennung im Code und sichere Behebung.
htb: Web Attacks
---

> [!INFO] Aufbau dieses Moduls
> Für jede Klasse: **Ursache** (welcher Programmierfehler), **Auswirkung**, **woran man sie im Code oder Verhalten erkennt** und **wie man sie behebt**. Genau dieses Verständnis verlangen CWES und CWEE – besonders im Whitebox-Teil.

## SQL-Injection

| | |
|---|---|
| Ursache | Benutzereingaben werden in SQL-Abfragen eingebaut |
| Auswirkung | Daten auslesen oder ändern, Anmeldung umgehen, im Extremfall Codeausführung |
| Erkennung | String-Verkettung in Abfragen, Datenbankfehler in Antworten, verändertes Verhalten bei Sonderzeichen |
| Behebung | **Prepared Statements**, ORM korrekt nutzen, Least Privilege für den DB-Benutzer, Fehlermeldungen nicht ausgeben |

## Cross-Site Scripting (XSS)

| Variante | Wo steckt der Code? |
|---|---|
| Reflected | in der Anfrage, sofort zurückgegeben |
| Stored | gespeichert, jedem Besucher ausgeliefert |
| DOM-basiert | clientseitig im JavaScript verarbeitet |

Auswirkung: Aktionen im Namen des Opfers, Auslesen von Seiteninhalten, gefälschte Formulare. Behebung: **kontextgerechte Ausgabe-Kodierung**, Templates mit automatischem Escaping, keine gefährlichen DOM-Senken (`innerHTML`, `eval`) mit Benutzerdaten, **Content Security Policy**, `HttpOnly`-Cookies.

## Command Injection

Ursache: Eingaben landen in Shell-Befehlen. Behebung: Shell vermeiden und Programme mit **Argumentlisten** aufrufen, strikte Allowlists, Anwendung mit minimalen Rechten betreiben.

## File Inclusion und Path Traversal

Ursache: Dateipfade werden aus Benutzereingaben gebildet. Auswirkung: Lesen beliebiger Dateien (Konfigurationen, Schlüssel), bei Inclusion ggf. Codeausführung. Behebung: keine Pfade aus Eingaben, sondern **feste Zuordnung** (ID → Datei), kanonische Pfade prüfen, Basisverzeichnis erzwingen.

## Unsichere Datei-Uploads

Ursache: Uploads werden nach Dateiendung oder Content-Type „geprüft“ und im Web-Verzeichnis ausführbar abgelegt. Behebung: Inhalt prüfen, Dateien **außerhalb** des Webroots speichern, zufällige Namen, keine Ausführung im Upload-Verzeichnis, Größenlimits, Malware-Scan.

## SSRF – Server-Side Request Forgery

Ursache: Der Server ruft URLs ab, die der Benutzer bestimmt. Auswirkung: Zugriff auf interne Dienste und Cloud-Metadaten. Behebung: Allowlist erlaubter Ziele, interne Adressbereiche blockieren, Metadaten-Dienste absichern (z. B. IMDSv2), Egress-Filterung.

## XXE – XML External Entities

Ursache: XML-Parser lösen externe Entitäten auf. Behebung: **DTDs und externe Entitäten im Parser deaktivieren**, wo möglich JSON verwenden.

## SSTI – Server-Side Template Injection

Ursache: Benutzereingaben werden als Template statt als Daten gerendert. Behebung: Eingaben nur als Variablen an Templates übergeben, nie Templates aus Eingaben bauen, Sandbox-Modi nutzen.

## IDOR und Broken Access Control

Ursache: Der Server prüft nicht, ob der Benutzer **dieses** Objekt sehen oder ändern darf. Behebung: Autorisierung bei **jedem** Zugriff serverseitig prüfen, zentrale Rechtelogik, nicht ratbare IDs nur als Zusatz.

## CSRF – Cross-Site Request Forgery

Ursache: Der Browser schickt Cookies automatisch mit, auch bei Anfragen, die eine fremde Seite auslöst. Behebung: **Anti-CSRF-Token**, `SameSite`-Cookies, erneute Bestätigung bei kritischen Aktionen.

## Unsichere Deserialisierung

Ursache: Serialisierte Objekte aus nicht vertrauenswürdigen Quellen werden wiederhergestellt. Auswirkung: oft Codeausführung. Behebung: keine nativen Serialisierungsformate für Benutzerdaten, signierte Daten, einfache Formate wie JSON mit Schema-Validierung.

> [!MERKE] Das Grundmuster
> Fast alle Klassen entstehen, weil Daten aus einer nicht vertrauenswürdigen Quelle ohne ausreichende Trennung in einen Interpreter oder eine Entscheidung gelangen. Die Lösungen wiederholen sich: **trennen, kodieren, validieren, autorisieren, Rechte minimieren** – siehe [[mod:f-09|Web-Grundlagen]].

## Quiz

? Welche Maßnahme behebt SQL-Injection grundlegend?
= Prepared Statements
= parametrisierte Abfragen

? Bei welcher XSS-Variante wird der Schadcode gespeichert und jedem Besucher ausgeliefert?
= Stored
= Stored XSS

? Wie verhindert man Command Injection am sichersten?
+ Programme mit Argumentlisten statt über eine Shell aufrufen
- Eingaben in Großbuchstaben umwandeln
- die Seite per HTTPS ausliefern
- längere Passwörter verwenden

? Wie behebt man XXE?
+ externe Entitäten und DTDs im XML-Parser deaktivieren
- XML-Dateien umbenennen
- Cookies auf HttpOnly setzen
- den Webserver neu starten

? Welche Schwachstelle liegt vor, wenn der Server nicht prüft, ob ein Benutzer ein bestimmtes Objekt sehen darf?
= IDOR
= Broken Access Control

? Was schützt vor CSRF?
+ Anti-CSRF-Token
+ SameSite-Cookies
- Base64-Kodierung
- längere Session-IDs allein

? Wo sollten hochgeladene Dateien gespeichert werden?
+ außerhalb des Webroots, ohne Ausführungsrechte
- direkt im Webroot
- im Systemverzeichnis
- im Browser-Cache

? Welche Schwachstelle nutzt aus, dass der Server vom Benutzer bestimmte URLs abruft?
= SSRF
= Server-Side Request Forgery
