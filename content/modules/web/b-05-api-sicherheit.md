---
id: b-05
title: API-Sicherheit – OWASP API Top 10
paths: cwes, cwee
order: 10
difficulty: medium
icon: point.3.connected.trianglepath.dotted
summary: REST, GraphQL und gRPC im Überblick, die OWASP API Security Top 10 (2023) mit Beispielen, API-Inventar, Authentifizierung, Rate Limiting und sichere API-Gestaltung.
htb: Web Service & API Attacks
---

## APIs als Hauptangriffsfläche

Mobile Apps, Single-Page-Anwendungen und Microservices sprechen über APIs. Viele moderne Datenlecks entstanden nicht über klassische Webseiten, sondern über APIs, die zu viel preisgaben oder Rechte nicht prüften.

| Stil | Merkmale |
|---|---|
| REST | Ressourcen über URLs und HTTP-Methoden, meist JSON |
| GraphQL | ein Endpunkt, Client bestimmt die Felder per Abfrage, Schema per Introspection |
| gRPC | binär (Protobuf), HTTP/2, oft intern |
| SOAP | XML, WSDL-Beschreibung, ältere Systeme |

## OWASP API Security Top 10 (2023)

| Nr. | Risiko | Kurz erklärt | Gegenmaßnahme |
|---|---|---|---|
| API1 | Broken Object Level Authorization | Objekt-IDs ändern → fremde Daten ([[IDOR]]) | Autorisierung pro Objekt prüfen |
| API2 | Broken Authentication | schwache Token, fehlendes Rate Limiting | bewährte Verfahren, MFA, Token-Validierung |
| API3 | Broken Object Property Level Authorization | zu viele Felder in Antworten oder ungeprüfte Felder in Anfragen (Mass Assignment) | Antwort- und Eingabeschemata mit Allowlists |
| API4 | Unrestricted Resource Consumption | keine Limits für Menge, Größe, Kosten | Rate Limits, Paginierung, Größenlimits |
| API5 | Broken Function Level Authorization | normale Benutzer erreichen Admin-Funktionen | Rollenprüfung pro Funktion, Deny by Default |
| API6 | Unrestricted Access to Sensitive Business Flows | automatisierter Missbrauch (Ticket-Bots, Massenregistrierung) | Anti-Automatisierung, Geschäftslimits |
| API7 | Server Side Request Forgery | Server ruft vom Benutzer bestimmte URLs ab | Allowlists, Egress-Filter |
| API8 | Security Misconfiguration | offene Debug-Endpunkte, CORS, fehlende Header | gehärtete Standardkonfiguration |
| API9 | Improper Inventory Management | alte API-Versionen und Test-Endpunkte bleiben erreichbar | API-Inventar, Lebenszyklus, Abschalten |
| API10 | Unsafe Consumption of APIs | Daten von Drittanbieter-APIs werden blind vertraut | auch externe Daten validieren |

## GraphQL-Besonderheiten

- **Introspection** verrät das komplette Schema – in Produktion deaktivieren oder einschränken
- verschachtelte Abfragen können enorme Last erzeugen – Tiefen- und Komplexitätslimits
- **Batching** mehrerer Operationen in einer Anfrage kann Rate Limits umgehen – pro Operation zählen
- Autorisierung muss auf Feld- und Resolver-Ebene erfolgen

## API-Inventar

Man kann nur schützen, was man kennt. Ein vollständiges Inventar (OpenAPI-Spezifikationen, API-Gateway, Traffic-Analyse) zeigt alle Endpunkte, Versionen, Datenarten und Verantwortlichen. „Schatten-APIs“ – undokumentierte, vergessene Endpunkte – sind ein häufiger Befund.

## Sichere API-Gestaltung

1. Authentifizierung über bewährte Standards (OAuth 2.0/OIDC, siehe [[mod:x-02|Authentifizierung]])
2. Autorisierung bei **jedem** Objekt- und Funktionszugriff
3. Eingaben gegen ein Schema validieren, unbekannte Felder ablehnen
4. Antworten nur mit benötigten Feldern
5. Rate Limits pro Benutzer, Token und IP
6. Versionierung und Abschaltplan für alte Versionen
7. zentrales Logging, Alarm bei Mustern wie massenhaften 403/404 oder ID-Aufzählung

## Quiz

? Welches Risiko steht auf Platz 1 der OWASP API Top 10 (2023)?
= Broken Object Level Authorization
= BOLA

? Welche GraphQL-Funktion verrät das komplette Schema?
= Introspection

? Wie heißt das Risiko, wenn alte API-Versionen erreichbar bleiben?
= Improper Inventory Management

? Wie nennt man undokumentierte, vergessene API-Endpunkte?
= Schatten-APIs
= Shadow APIs

? Was schützt gegen Unrestricted Resource Consumption?
+ Rate Limits, Paginierung und Größenlimits
- längere URLs
- XML statt JSON
- mehr Server

? Welche Spezifikation beschreibt REST-APIs maschinenlesbar?
= OpenAPI
= Swagger

?tf Daten von Drittanbieter-APIs müssen nicht validiert werden.
= falsch
