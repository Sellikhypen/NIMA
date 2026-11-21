---
id: x-03
title: Logikfehler und moderne Web-Schwachstellenklassen
paths: cwee
order: 13
difficulty: insane
icon: brain.head.profile
summary: Business-Logic-Fehler, Race Conditions, Mass Assignment, Type Juggling, Prototype Pollution, Request Smuggling, Cache Poisoning und unsichere Deserialisierung – Ursachen, Erkennung und sichere Muster.
---

## Business-Logic-Fehler

Logikfehler entstehen, wenn eine Anwendung technisch korrekt arbeitet, aber Annahmen über den Ablauf verletzt werden können. Scanner finden sie kaum – man braucht Verständnis für den Geschäftsprozess.

| Beispiel | Annahme, die verletzt wird | Schutz |
|---|---|---|
| negative Menge im Warenkorb | Mengen sind immer positiv | serverseitige Validierung aller Werte |
| Schritt 3 eines Ablaufs direkt aufrufen | Benutzer durchlaufen Schritte nacheinander | Zustand serverseitig führen und prüfen |
| Gutschein mehrfach einlösen | jeder Code nur einmal | atomare Prüfung und Markierung |
| Preis aus dem Formular übernehmen | Client liefert korrekte Preise | Preise nur serverseitig bestimmen |

## Race Conditions

Wenn zwei Anfragen gleichzeitig dieselbe Prüfung passieren, bevor der Zustand aktualisiert wird („Time of Check to Time of Use“), kann z. B. ein Guthaben doppelt ausgegeben werden.

**Schutz:** Datenbanktransaktionen mit passender Isolation, Sperren (`SELECT … FOR UPDATE`), atomare Operationen, Idempotenz-Schlüssel, eindeutige Constraints.

## Mass Assignment

Frameworks binden Anfragedaten bequem an Objekte. Ohne Einschränkung lassen sich so Felder setzen, die nie vorgesehen waren (`isAdmin`, `balance`).

**Schutz:** explizite Allowlist erlaubter Felder (DTOs, `fillable`, Serializer mit festen Feldern).

## Type Juggling

Lose typisierte Vergleiche (z. B. `==` in PHP oder JavaScript) wandeln Typen automatisch um. Dadurch können unerwartete Werte Prüfungen bestehen.

**Schutz:** strikte Vergleiche (`===`), Typprüfungen, für Geheimnisse zeitkonstante Vergleichsfunktionen (`hash_equals`, `hmac.compare_digest`).

## Prototype Pollution (JavaScript)

In JavaScript erben Objekte von `Object.prototype`. Führt Code Benutzerdaten rekursiv in Objekte zusammen und erlaubt dabei Schlüssel wie `__proto__` oder `constructor`, lassen sich Eigenschaften **aller** Objekte verändern – mit Folgen von Logikfehlern bis zur Codeausführung.

**Schutz:** gefährliche Schlüssel ablehnen, `Object.create(null)` oder `Map` für Wörterbücher, Schema-Validierung, aktuelle Bibliotheken.

## HTTP Request Smuggling

Wenn Frontend (Proxy, Load Balancer) und Backend die Länge einer Anfrage unterschiedlich bestimmen (`Content-Length` vs. `Transfer-Encoding`), kann ein Teil einer Anfrage als Beginn der nächsten interpretiert werden – mit Auswirkungen auf andere Benutzer.

**Schutz:** einheitliche, standardkonforme Implementierungen, mehrdeutige Anfragen ablehnen, HTTP/2 Ende-zu-Ende, aktuelle Proxys.

## Web Cache Poisoning und Cache Deception

| Klasse | Idee | Schutz |
|---|---|---|
| Cache Poisoning | eine Antwort, die von nicht im Cache-Schlüssel enthaltenen Eingaben (z. B. Headern) beeinflusst wird, wird für alle zwischengespeichert | ungeschlüsselte Eingaben nicht in Antworten verwenden, Cache-Schlüssel sauber definieren |
| Cache Deception | private Seiten werden unter einer statisch wirkenden URL zwischengespeichert | nur explizit statische Inhalte cachen, `Cache-Control: private/no-store` |

## Unsichere Deserialisierung

Native Serialisierungsformate (Java, PHP, .NET, Python pickle) können beim Wiederherstellen automatisch Code ausführen („Gadget Chains“).

**Schutz:** keine nativen Formate für nicht vertrauenswürdige Daten, JSON mit Schema, Signaturen (HMAC) für serialisierte Daten, Allowlists erlaubter Klassen.

> [!MERKE] Was diese Klassen gemeinsam haben
> Sie entstehen an **Grenzen zwischen Komponenten** – zwischen Client und Server, Proxy und Backend, Daten und Objekten, Prüfung und Nutzung. Wer im Code-Review gezielt diese Übergänge betrachtet, findet sie.

## Quiz

? Wie heißt das Muster „Prüfung und Nutzung fallen zeitlich auseinander“?
= TOCTOU
= Time of Check to Time of Use

? Welche Maßnahme verhindert Mass Assignment?
+ explizite Allowlist erlaubter Felder
- längere Session-IDs
- HTTPS
- ein größerer Cache

? Welcher Vergleich verhindert Type Juggling in PHP?
= ===
= strikter Vergleich

? Welche Schlüssel sind bei Prototype Pollution gefährlich?
+ __proto__
+ constructor
- id
- name

? Welche Header sind bei Request Smuggling typischerweise beteiligt?
+ Content-Length
+ Transfer-Encoding
- Accept-Language
- User-Agent

? Was schützt gegen Race Conditions bei Guthaben-Buchungen?
+ Transaktionen und Sperren bzw. atomare Operationen
- ein schöneres Frontend
- längere Passwörter
- Base64-Kodierung

?tf Business-Logic-Fehler werden von automatischen Scannern zuverlässig gefunden.
= falsch
