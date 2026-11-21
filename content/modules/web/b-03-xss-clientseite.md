---
id: b-03
title: XSS und clientseitige Sicherheit
paths: cwes, cpts, cwee
order: 8
difficulty: medium
icon: chevron.left.slash.chevron.right
summary: Die drei XSS-Varianten, Ausgabekontexte und richtige Kodierung, gefährliche DOM-Senken, Content Security Policy im Detail, Trusted Types, Clickjacking und JavaScript-Verschleierung.
htb: Cross-Site Scripting (XSS)
---

## Was XSS bedeutet

Bei **Cross-Site Scripting** gelangt fremder JavaScript-Code in eine Seite und läuft im Browser anderer Benutzer – mit allen Rechten dieser Seite. Er kann Inhalte lesen, Aktionen im Namen des Benutzers ausführen, Formulare fälschen oder Tastatureingaben mitlesen.

| Variante | Weg des Codes |
|---|---|
| Reflected | aus der Anfrage (z. B. URL-Parameter) direkt in die Antwort |
| Stored | gespeichert (Kommentar, Profil) und jedem Besucher ausgeliefert |
| DOM-basiert | clientseitiges JavaScript übernimmt Daten (z. B. aus `location.hash`) in eine gefährliche Senke |

## Ausgabekontexte

Die richtige Schutzmaßnahme hängt davon ab, **wo** Daten eingefügt werden:

| Kontext | Beispiel | richtige Behandlung |
|---|---|---|
| HTML-Text | `<p>NAME</p>` | HTML-Entities kodieren (`<` → `&lt;`) |
| HTML-Attribut | `<input value="NAME">` | Attribut-Kodierung, Attribut immer in Anführungszeichen |
| URL | `<a href="URL">` | Schema prüfen (nur `https:`), URL-Kodierung |
| JavaScript | `var x = 'NAME';` | Daten nicht in Skripte einbetten; JSON sicher serialisieren |
| CSS | `style="color: NAME"` | Benutzerdaten vermeiden |

> [!MERKE] Templates nutzen
> Moderne Template-Engines und Frameworks (React, Vue, Angular, Jinja2, Twig, Razor) kodieren automatisch für den HTML-Kontext. Lücken entstehen fast immer dort, wo dieser Schutz bewusst abgeschaltet wird.

## Gefährliche DOM-Senken

| Senke | sichere Alternative |
|---|---|
| `element.innerHTML = …` | `textContent` |
| `document.write` | DOM-Methoden |
| `eval`, `setTimeout("string")`, `new Function` | Funktionen statt Strings |
| `location = userInput` | nur geprüfte Ziele |
| `dangerouslySetInnerHTML` (React), `v-html` (Vue) | nur mit bereinigtem HTML (z. B. DOMPurify) |

## Content Security Policy

Eine **CSP** legt fest, woher Skripte, Styles, Bilder und Frames kommen dürfen. Eine strenge Richtlinie macht viele XSS-Lücken unschädlich:

```text
Content-Security-Policy: default-src 'self'; script-src 'nonce-r4nd0m' 'strict-dynamic'; object-src 'none'; base-uri 'none'; frame-ancestors 'none'
```

| Direktive | Wirkung |
|---|---|
| `script-src` mit Nonce/Hash | nur Skripte mit passendem, pro Antwort zufälligem Nonce laufen |
| `'unsafe-inline'` | erlaubt Inline-Skripte – hebt den Schutz größtenteils auf |
| `object-src 'none'` | keine Plugins |
| `base-uri 'none'` | verhindert Manipulation relativer URLs |
| `frame-ancestors` | Schutz vor Clickjacking |
| `report-to` | Verstöße melden (gut zum Einführen im Report-Only-Modus) |

**Trusted Types** erzwingen zusätzlich, dass gefährliche DOM-Senken nur geprüfte Objekte statt beliebiger Strings annehmen.

## Clickjacking

Eine fremde Seite bettet die Anwendung unsichtbar in einen Frame ein und bringt Benutzer dazu, unbemerkt auf Schaltflächen zu klicken. Schutz: `frame-ancestors` bzw. `X-Frame-Options: DENY`.

## JavaScript-Verschleierung

Viele Seiten und Schadskripte liefern **minifizierten** oder **verschleierten** Code. Prüfer und Analysten nutzen Formatierer („Beautifier“), Browser-Entwicklerwerkzeuge (Breakpoints, Netzwerk-Tab) und Deobfuscator, um zu verstehen, welche API-Aufrufe und Daten im Spiel sind. Verschleierung ist kein Schutz: Alles, was im Browser läuft, kann gelesen werden.

## Quiz

? Bei welcher XSS-Variante übernimmt clientseitiges JavaScript Daten in eine gefährliche Senke?
= DOM-basiert
= DOM
= DOM-based

? Welche sichere Alternative gibt es zu innerHTML?
= textContent

? Welche CSP-Direktive verhindert, dass die Seite in fremde Frames eingebettet wird?
= frame-ancestors

? Welcher CSP-Wert hebt den Schutz vor Inline-Skripten weitgehend auf?
= 'unsafe-inline'
= unsafe-inline

? Welche Bibliothek bereinigt HTML vor dem Einfügen?
= DOMPurify

? Wie heißt der Angriff, bei dem eine Seite unsichtbar eingebettet wird, um Klicks zu erschleichen?
= Clickjacking

?tf Verschleierter JavaScript-Code ist vor Analyse geschützt.
= falsch

? Wie behandelt man Daten im HTML-Textkontext?
+ HTML-Entities kodieren
- Base64 kodieren
- in Großbuchstaben umwandeln
- gar nicht
