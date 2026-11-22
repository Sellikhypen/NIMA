---
id: wb-01
title: Web vertieft 1 · Browser, DOM und Same-Origin-Policy
paths: cwes, cwee, grundlagen
order: 40.1
difficulty: easy
icon: globe
tags: web, browser
summary: Wie der Browser Webseiten aufbaut, was das DOM ist und warum die Same-Origin-Policy die wichtigste Schutzmauer im Web ist.
---

## Einfach erklärt

Jeder Browser-Tab ist wie ein eigenes Zimmer. Eine Webseite darf in **ihrem** Zimmer alles umräumen, aber nicht in das Zimmer einer anderen Webseite schauen. Diese Regel heißt **Same-Origin-Policy (SOP)**. Ohne sie könnte eine bösartige Seite in einem anderen Tab dein Online-Banking auslesen.

## Was ist ein Origin?

Ein Origin besteht aus drei Teilen: **Schema + Host + Port**.

| URL | gleicher Origin wie `https://shop.example.com`? |
|---|---|
| `https://shop.example.com/warenkorb` | ja (Pfad zählt nicht) |
| `http://shop.example.com` | nein (Schema) |
| `https://api.example.com` | nein (Host) |
| `https://shop.example.com:8443` | nein (Port) |

## Das DOM

Der Browser wandelt HTML in einen Baum aus Objekten um – das **Document Object Model**. JavaScript kann diesen Baum lesen und verändern: Texte austauschen, Formulare auslesen, Elemente einfügen. Genau deshalb ist **XSS** so gefährlich: Fremdes JavaScript läuft im Origin der Seite und hat vollen Zugriff auf deren DOM, Cookies (ohne HttpOnly) und Aktionen.

> [!MERKE] SOP schützt das Lesen, nicht das Senden
> Eine fremde Seite kann Anfragen an deine Bank **senden** (Formulare, Bilder), aber die **Antwort nicht lesen**. Deshalb gibt es zusätzlich CSRF-Schutz.

## Tiefer eingetaucht

Was SOP erlaubt und verbietet:

- **Erlaubt**: Einbetten von Bildern, Skripten, Stylesheets, iframes anderer Origins; Formulare an andere Origins abschicken.
- **Verboten**: per `fetch`/XHR die Antwort eines fremden Origins lesen; in das DOM eines fremden iframes greifen.

Lockerungen sind bewusst möglich: **CORS** erlaubt einem Server, bestimmten Origins das Lesen zu gestatten; `postMessage` erlaubt kontrollierte Kommunikation zwischen Fenstern. Beide sind häufige Fehlerquellen: zu großzügige CORS-Header (`Access-Control-Allow-Origin` mit reflektiertem Origin plus Credentials) oder `postMessage`-Empfänger, die den Absender nicht prüfen.

Moderne Browser ergänzen SOP durch **Site Isolation** (jede Site in eigenem Prozess) und Cookie-Regeln wie **SameSite**.

## Quiz

? Aus welchen drei Teilen besteht ein Origin?
+ Schema
+ Host
+ Port
- Pfad
! Der Pfad gehört nicht zum Origin.

? Haben `https://example.com` und `https://example.com:8443` denselben Origin?
+ nein
- ja
! Ein anderer Port ergibt einen anderen Origin.

?tf Die Same-Origin-Policy verhindert, dass eine fremde Seite Anfragen an deine Bank sendet.
= falsch
! SOP verhindert nur das Lesen der Antwort. Gegen ungewollte Aktionen braucht es CSRF-Schutz.

? Wie heißt der Objektbaum, den der Browser aus HTML erzeugt?
= DOM
= Document Object Model
! JavaScript liest und verändert die Seite über das DOM.

? Welcher Mechanismus erlaubt einem Server, anderen Origins das Lesen seiner Antworten zu gestatten?
= CORS
! Cross-Origin Resource Sharing lockert die SOP kontrolliert.

? Was sollte ein `postMessage`-Empfänger immer prüfen?
+ den Origin des Absenders
- die Bildschirmauflösung
- die Uhrzeit
- die Länge der Nachricht
! Ohne Prüfung kann jede beliebige Seite Nachrichten einschleusen.

? Warum ist XSS trotz SOP gefährlich?
+ der eingeschleuste Code läuft im Origin der angegriffenen Seite
- weil XSS die SOP abschaltet
- weil XSS nur in alten Browsern funktioniert
- weil XSS Passwörter im Klartext auf dem Server ändert
! Für den Browser ist das Skript „eigener“ Code der Seite.

@@@ MODULE @@@
---
id: wb-02
title: Web vertieft 2 · Cookies und ihre Attribute
paths: cwes, cwee
order: 40.2
difficulty: easy
icon: birthday.cake.fill
tags: web, cookies, session
summary: Wie Cookies funktionieren und wie Secure, HttpOnly, SameSite, Domain, Path und Präfixe Sitzungen schützen.
---

## Einfach erklärt

HTTP vergisst nach jeder Anfrage, wer du bist. Ein **Cookie** ist wie ein Garderobenzettel: Der Server gibt dir beim Login einen Zettel mit einer Nummer, und du zeigst ihn bei jeder Anfrage vor. Wer deinen Zettel stiehlt, bekommt deine Jacke – also deine Sitzung.

## Ein Cookie setzen

```http
Set-Cookie: session=8f3a9c...; Path=/; Secure; HttpOnly; SameSite=Lax; Max-Age=3600
```

| Attribut | Wirkung |
|---|---|
| `Secure` | nur über HTTPS senden |
| `HttpOnly` | für JavaScript unsichtbar – schützt bei XSS vor Cookie-Diebstahl |
| `SameSite=Strict` | nie bei Anfragen von fremden Sites mitsenden |
| `SameSite=Lax` | nur bei Top-Level-Navigation (Link-Klick, GET) mitsenden |
| `SameSite=None` | immer mitsenden – erfordert `Secure` |
| `Domain` | auch an Subdomains senden (Vorsicht!) |
| `Path` | nur für bestimmte Pfade |
| `Max-Age`/`Expires` | Lebensdauer; ohne: Session-Cookie bis Browserende |

> [!TIPP] Gute Standardwerte für Sitzungscookies
> `Secure; HttpOnly; SameSite=Lax` (oder `Strict`), kein `Domain`-Attribut, kurze Lebensdauer, nach Login neu ausstellen.

## Tiefer eingetaucht

**Cookie-Präfixe** erzwingen sichere Eigenschaften:

- `__Secure-` – Cookie muss `Secure` haben.
- `__Host-` – zusätzlich kein `Domain` und `Path=/`; damit kann keine Subdomain das Cookie überschreiben.

Warum ist `Domain=example.com` riskant? Dann erhält jede Subdomain das Cookie – auch eine vergessene, übernehmbare (**Subdomain-Takeover**) oder eine mit XSS-Lücke.

**Session Fixation**: Akzeptiert ein Server eine vom Angreifer vorgegebene Session-ID und behält sie nach dem Login bei, kann der Angreifer die Sitzung übernehmen. Abhilfe: Nach jeder Rechteänderung (Login, Rollenwechsel) eine **neue** Session-ID ausgeben.

SameSite unterscheidet **Site** (registrierbare Domain, z. B. `example.com`) von **Origin**: `a.example.com` und `b.example.com` sind same-site, aber cross-origin.

## Quiz

? Welches Attribut verhindert, dass JavaScript ein Cookie lesen kann?
= HttpOnly
! HttpOnly schützt das Cookie bei XSS vor dem Auslesen – nicht aber vor Aktionen im Namen des Nutzers.

? Welches Attribut sorgt dafür, dass ein Cookie nur über HTTPS gesendet wird?
= Secure
! Ohne Secure könnte das Cookie bei einer unverschlüsselten Verbindung mitgelesen werden.

? Welcher SameSite-Wert sendet das Cookie nie bei Anfragen von fremden Sites?
+ Strict
- Lax
- None
- Default
! Strict ist am sichersten, kann aber Komfort kosten (z. B. beim Folgen externer Links).

?tf `SameSite=None` funktioniert in modernen Browsern nur zusammen mit `Secure`.
= wahr
! Browser verwerfen `SameSite=None` ohne `Secure`.

? Welches Cookie-Präfix verbietet das Domain-Attribut und verlangt Path=/?
= __Host-
! `__Host-` bindet das Cookie fest an genau einen Host.

? Wie verhindert man Session Fixation?
+ nach dem Login eine neue Session-ID ausstellen
- Session-IDs in der URL übertragen
- Cookies ohne Ablauf setzen
- das Domain-Attribut setzen
! Eine neue ID macht eine vom Angreifer vorgegebene ID wertlos.

? Warum ist ein Cookie mit `Domain=example.com` riskant?
+ alle Subdomains erhalten es, auch unsichere oder übernommene
- es läuft sofort ab
- es wird nicht verschlüsselt gespeichert
- es funktioniert nur mit HTTP
! Die Angriffsfläche wächst um jede Subdomain.

@@@ MODULE @@@
---
id: wb-03
title: Web vertieft 3 · CSRF verstehen und verhindern
paths: cwes, cwee, cpts
order: 40.3
difficulty: medium
icon: arrow.uturn.right.circle.fill
tags: web, csrf
summary: Wie Cross-Site Request Forgery Aktionen im Namen eingeloggter Nutzer auslöst und welche Kombination aus Tokens, SameSite und Prüfungen schützt.
---

## Einfach erklärt

Du bist bei deiner Bank eingeloggt. In einem anderen Tab öffnest du eine präparierte Seite. Diese Seite enthält unsichtbar ein Formular, das sich selbst an deine Bank abschickt: „Überweise 500 € an Konto X“. Dein Browser hängt brav dein Bank-Cookie an – für die Bank sieht es aus, als hättest du geklickt.

Das ist **Cross-Site Request Forgery (CSRF)**: Der Angreifer kann die Antwort nicht lesen, aber er kann eine **Aktion auslösen**.

## Voraussetzungen für CSRF

1. Eine **zustandsändernde Aktion** (Passwort ändern, Überweisung, E-Mail ändern).
2. Authentifizierung **nur über automatisch mitgesendete** Daten (Cookies, Basic Auth, Client-Zertifikate).
3. **Keine unvorhersehbaren Parameter** – der Angreifer kennt alle Felder der Anfrage.

Fehlt eine Voraussetzung, funktioniert CSRF nicht.

## Schutzmaßnahmen

| Maßnahme | Wie sie wirkt |
|---|---|
| Anti-CSRF-Token | zufälliger Wert pro Sitzung/Formular, den die fremde Seite nicht kennt |
| SameSite-Cookies | Cookie wird bei Cross-Site-Anfragen nicht mitgesendet |
| Origin/Referer prüfen | Server lehnt Anfragen von fremden Origins ab |
| Erneute Bestätigung | Passwort oder MFA für kritische Aktionen |
| Kein GET für Änderungen | GET darf nichts verändern |

> [!MERKE] Verteidigung in der Tiefe
> Token **plus** SameSite **plus** Origin-Prüfung. Einzelne Maßnahmen haben Lücken – z. B. schützt `SameSite=Lax` nicht gegen GET-Anfragen, die etwas verändern.

## Tiefer eingetaucht

Typische Implementierungsfehler, die man bei Code-Reviews und Tests findet:

- Das Token wird **nur geprüft, wenn es vorhanden ist** – fehlt es, geht die Anfrage durch.
- Das Token ist **nicht an die Sitzung gebunden** – ein gültiges Token aus dem eigenen Konto funktioniert auch für andere.
- Die Methode lässt sich wechseln: POST ist geschützt, die gleiche Aktion per GET nicht.
- JSON-APIs verlassen sich darauf, dass Formulare keinen `application/json`-Content-Type senden können, akzeptieren aber auch `text/plain`.
- **Login-CSRF**: Der Angreifer loggt das Opfer in **sein** Konto ein und sieht später, was das Opfer dort eingibt.

Bei APIs mit Token im `Authorization`-Header (statt Cookie) ist klassisches CSRF nicht möglich, weil der Browser den Header nicht automatisch setzt.

## Quiz

? Was kann ein Angreifer bei CSRF typischerweise NICHT?
+ die Antwort des Servers lesen
- eine Anfrage im Namen des Opfers auslösen
- ein Formular automatisch abschicken
- das Opfer auf eine präparierte Seite locken
! Die Same-Origin-Policy verhindert das Lesen; die Aktion wird trotzdem ausgeführt.

? Welche Bedingungen müssen für CSRF erfüllt sein?
+ zustandsändernde Aktion
+ Authentifizierung über automatisch gesendete Daten wie Cookies
+ keine unvorhersehbaren Parameter
- der Server nutzt HTTP/2
! Fehlt eine dieser Bedingungen, scheitert der Angriff.

? Welche Maßnahme fügt einen zufälligen, der fremden Seite unbekannten Wert in jede Anfrage ein?
= Anti-CSRF-Token
= CSRF-Token
! Das Token muss an die Sitzung gebunden und serverseitig immer geprüft werden.

?tf APIs, die ein Bearer-Token im Authorization-Header erwarten, sind für klassisches CSRF anfällig.
= falsch
! Der Browser setzt diesen Header nicht automatisch bei fremden Anfragen.

? Welcher Fehler macht einen CSRF-Token-Schutz wirkungslos?
+ das Token wird nur geprüft, wenn es mitgesendet wird
- das Token ist 32 Zeichen lang
- das Token wird pro Sitzung erzeugt
- das Token steht in einem versteckten Feld
! Ein fehlendes Token muss zur Ablehnung führen.

? Wie heißt der Angriff, bei dem das Opfer in das Konto des Angreifers eingeloggt wird?
= Login-CSRF
= Login CSRF
! So landen Eingaben des Opfers im Konto des Angreifers.

? Warum dürfen GET-Anfragen keine Daten verändern?
+ sie werden u. a. durch SameSite=Lax bei Top-Level-Navigation mitgesendet und leicht ausgelöst
- GET ist langsamer
- GET verschlüsselt nicht
- GET-Anfragen werden nie geloggt
! Links und Bilder lösen GET-Anfragen trivial aus.

@@@ MODULE @@@
---
id: wb-04
title: Web vertieft 4 · Content Security Policy in der Tiefe
paths: cwes, cwee
order: 40.4
difficulty: medium
icon: lock.doc.fill
tags: web, csp, xss
summary: Wie eine CSP Skriptquellen begrenzt, warum Nonces und strict-dynamic besser sind als Allowlists und wie man eine Policy schrittweise einführt.
---

## Einfach erklärt

Eine **Content Security Policy (CSP)** ist eine Gästeliste für deine Webseite: Der Server sagt dem Browser, **woher** Skripte, Bilder und Styles kommen dürfen. Taucht ein Skript auf, das nicht auf der Liste steht – etwa durch XSS eingeschleust –, führt der Browser es nicht aus.

CSP verhindert XSS nicht an der Wurzel, sie ist eine **zweite Verteidigungslinie**, die Ausnutzung stark erschwert.

## Aufbau einer Policy

```http
Content-Security-Policy: default-src 'self'; script-src 'nonce-r4nd0m' 'strict-dynamic'; object-src 'none'; base-uri 'none'; frame-ancestors 'none'
```

| Direktive | Steuert |
|---|---|
| `default-src` | Rückfallwert für alle Ressourcen |
| `script-src` | erlaubte Skriptquellen |
| `object-src` | Plugins (`'none'` setzen!) |
| `base-uri` | verhindert Umbiegen relativer URLs über `<base>` |
| `frame-ancestors` | wer die Seite einbetten darf (Clickjacking-Schutz) |
| `form-action` | wohin Formulare senden dürfen |
| `report-to` | wohin Verstöße gemeldet werden |

## Nonces statt Allowlists

Eine Allowlist wie `script-src https://cdn.example.com` klingt sicher, wird aber oft umgangen: Liegen auf dem erlaubten CDN Bibliotheken mit „Gadgets“ (z. B. JSONP-Endpunkte oder alte Frameworks), kann ein Angreifer darüber Code ausführen.

Besser: Jede Antwort bekommt eine **zufällige Nonce**, und nur Skripte mit passendem Attribut laufen:

```html
<script nonce="r4nd0m">app.start()</script>
```

`'strict-dynamic'` erlaubt zusätzlich Skripte, die ein vertrauenswürdiges Skript selbst nachlädt.

> [!WARNUNG] Diese Werte schwächen jede CSP
> `'unsafe-inline'` (erlaubt Inline-Skripte) und `'unsafe-eval'` (erlaubt `eval`) heben einen Großteil des Schutzes auf.

## Tiefer eingetaucht

Einführung in der Praxis:

1. Mit `Content-Security-Policy-Report-Only` starten – nichts wird blockiert, Verstöße werden nur gemeldet.
2. Berichte auswerten, Inline-Handler (`onclick=`) in eigene Skripte umziehen.
3. Nonces serverseitig pro Antwort erzeugen (nie statisch!).
4. Auf erzwingenden Modus umschalten, Berichte weiter überwachen.

Weitere moderne Bausteine: **Trusted Types** (`require-trusted-types-for 'script'`) zwingt DOM-Senken wie `innerHTML`, nur geprüfte Werte anzunehmen – ein starker Schutz gegen DOM-XSS. Eine CSP gilt pro Antwort; werden mehrere Policies gesendet, müssen Ressourcen **alle** erfüllen.

## Quiz

? Was ist die Hauptaufgabe einer CSP?
+ festlegen, aus welchen Quellen Ressourcen geladen und ausgeführt werden dürfen
- Passwörter verschlüsseln
- SQL-Injection verhindern
- Cookies signieren
! CSP begrenzt Skriptquellen und erschwert so die Ausnutzung von XSS.

? Welche Direktive schützt gegen Clickjacking?
= frame-ancestors
! Sie legt fest, wer die Seite in einem Frame einbetten darf.

? Welcher Wert sollte für `object-src` gesetzt werden?
= 'none'
= none
! Plugins wie Flash sind veraltet und ein bekannter Umgehungsweg.

?tf `'unsafe-inline'` in script-src hebt einen großen Teil des XSS-Schutzes auf.
= wahr
! Eingeschleuste Inline-Skripte würden dann ausgeführt.

? Warum sind Nonces sicherer als Domain-Allowlists?
+ erlaubte Domains enthalten oft nutzbare Skript-Gadgets
- Nonces sind kürzer
- Allowlists funktionieren nur in Firefox
- Nonces verschlüsseln das Skript
! Nonces binden die Erlaubnis an genau die Skripte, die der Server ausgeliefert hat.

? Mit welchem Header testet man eine CSP, ohne etwas zu blockieren?
= Content-Security-Policy-Report-Only
! So lassen sich Verstöße sammeln, bevor man scharf schaltet.

? Welche Technik zwingt DOM-Senken wie innerHTML, nur geprüfte Werte anzunehmen?
= Trusted Types
! Trusted Types sind ein wirksamer Schutz gegen DOM-basiertes XSS.

@@@ MODULE @@@
---
id: wb-05
title: Web vertieft 5 · XXE und unsichere Deserialisierung
paths: cwes, cwee, cpts
order: 40.5
difficulty: hard
icon: doc.badge.gearshape.fill
tags: web, xxe, deserialisierung
summary: Warum XML-Parser und Deserialisierer gefährlich werden, wenn sie zu viel können – Ursachen, Auswirkungen und sichere Konfiguration.
---

## Einfach erklärt

Manche Datenformate sind mehr als Daten: Sie können **Anweisungen** enthalten. XML kann sagen „füge hier den Inhalt dieser Datei ein“. Serialisierte Objekte können sagen „baue dieses Objekt und führe dabei jene Methode aus“. Wenn eine Anwendung solche Eingaben von Nutzern ungeprüft verarbeitet, führt sie fremde Anweisungen aus.

## XXE – XML External Entities

XML erlaubt **Entities**, also Platzhalter. Externe Entities verweisen auf Dateien oder URLs. Ein unsicher konfigurierter Parser löst sie auf – mit möglichen Folgen:

- Lesen lokaler Dateien,
- Anfragen an interne Systeme (**SSRF**),
- Denial of Service durch rekursive Entities („Billion Laughs“).

XML steckt oft versteckt in anderen Formaten: SVG-Bilder, DOCX/XLSX (gezippte XML), SOAP, SAML.

> [!MERKE] Die Lösung ist eine Konfigurationszeile
> DTDs bzw. externe Entities im Parser **deaktivieren**. Die meisten modernen Bibliotheken tun das inzwischen standardmäßig – aber nicht alle und nicht in alten Versionen.

## Unsichere Deserialisierung

**Serialisierung** wandelt Objekte in Bytes oder Text um (zum Speichern oder Übertragen), **Deserialisierung** baut sie wieder auf. Formate wie Java-Serialisierung, Python `pickle`, PHP `unserialize` oder .NET `BinaryFormatter` können dabei beliebige Klassen instanziieren. Ein Angreifer, der die Eingabe kontrolliert, kann Ketten vorhandener Klassen („Gadget Chains“) so kombinieren, dass Code ausgeführt wird.

| Format | Risiko | Bessere Alternative |
|---|---|---|
| Java `ObjectInputStream` | hoch | JSON mit festem Schema, Allowlist-Filter |
| Python `pickle` | hoch | JSON |
| PHP `unserialize` | hoch | `json_decode` |
| .NET `BinaryFormatter` | hoch, offiziell abgekündigt | `System.Text.Json` |

## Tiefer eingetaucht

Erkennen in Tests und Code-Reviews:

- Base64-Daten in Cookies oder Parametern, die mit typischen Magic Bytes beginnen (Java: `rO0` als Base64 von `AC ED`).
- Aufrufe wie `pickle.loads`, `unserialize`, `readObject`, `yaml.load` (ohne SafeLoader) auf Eingaben von außen.
- XML-Uploads, SVG-Verarbeitung, Office-Dokument-Importe.

Verteidigung:

1. Keine nativen Objektformate für Daten aus nicht vertrauenswürdigen Quellen.
2. Wenn unvermeidbar: **Integritätsschutz** (HMAC-Signatur) und Klassen-Allowlist.
3. XML-Parser härten: DTD-Verarbeitung aus, externe Entities aus, Entity-Expansion begrenzen.
4. Deserialisierung in Prozessen mit minimalen Rechten, Egress-Filter gegen SSRF.

## Quiz

? Wofür steht XXE?
= XML External Entity
= XML External Entities
! Externe Entities verweisen auf Dateien oder URLs, die der Parser auflöst.

? Welche Auswirkungen kann XXE haben?
+ Lesen lokaler Dateien
+ Anfragen an interne Systeme (SSRF)
+ Denial of Service
- Änderung der Bildschirmauflösung
! Je nach Parser und Umgebung sind mehrere Auswirkungen möglich.

? Wie verhindert man XXE am wirksamsten?
+ DTD-Verarbeitung bzw. externe Entities im Parser deaktivieren
- XML gzip-komprimieren
- nur HTTPS verwenden
- XML-Dateien umbenennen
! Ohne externe Entities gibt es nichts aufzulösen.

?tf SVG-Bilder können XXE auslösen, weil sie XML sind.
= wahr
! Auch DOCX, XLSX und SAML basieren auf XML.

? Welche Python-Funktion ist bei nicht vertrauenswürdigen Daten gefährlich?
+ pickle.loads
- json.loads
- int()
- str.split
! pickle kann beim Laden beliebigen Code ausführen.

? Wie nennt man Ketten vorhandener Klassen, die bei der Deserialisierung zu Codeausführung führen?
= Gadget Chain
= Gadget Chains
= Gadget-Kette
! Der Angreifer bringt keinen eigenen Code mit, sondern kombiniert vorhandene Klassen.

? Mit welchen Zeichen beginnt ein Base64-kodierter Java-Serialisierungsstrom typischerweise?
= rO0
! Die Magic Bytes AC ED ergeben Base64-kodiert „rO0“.

@@@ MODULE @@@
---
id: wb-06
title: Web vertieft 6 · Zugriffskontrolle in APIs (IDOR, BOLA, BFLA)
paths: cwes, cwee, cpts
order: 40.6
difficulty: medium
icon: person.2.badge.key.fill
tags: web, api, zugriffskontrolle
summary: Warum fehlerhafte Berechtigungsprüfungen die häufigste API-Schwachstelle sind und wie man sie systematisch findet und verhindert.
---

## Einfach erklärt

Stell dir eine Garderobe vor, bei der jeder Zettel einfach eine fortlaufende Nummer hat. Gibst du statt „17“ den Zettel „18“ ab – bekommst du die Jacke eines anderen. Genau das ist **IDOR** (Insecure Direct Object Reference): Die Anwendung prüft, **dass** du eingeloggt bist, aber nicht, **ob dir das Objekt gehört**.

```http
GET /api/rechnungen/1042   → deine Rechnung
GET /api/rechnungen/1043   → Rechnung einer fremden Firma
```

## Die Begriffe der OWASP API Top 10

| Begriff | Bedeutung | Beispiel |
|---|---|---|
| BOLA (Broken Object Level Authorization) | Zugriff auf fremde **Objekte** | fremde Rechnung lesen |
| BFLA (Broken Function Level Authorization) | Zugriff auf fremde **Funktionen** | normaler Nutzer ruft `/api/admin/users` auf |
| BOPLA (Broken Object Property Level Authorization) | Zugriff auf einzelne **Felder** | eigenes Feld `role` per Mass Assignment auf `admin` setzen |

> [!MERKE] Authentifizierung ≠ Autorisierung
> Authentifizierung: Wer bist du? Autorisierung: Was darfst du? IDOR ist fast immer ein Autorisierungsfehler.

## Systematisch testen

1. Zwei Testkonten anlegen (A und B), idealerweise auch unterschiedliche Rollen.
2. Alle Anfragen von A aufzeichnen (Proxy).
3. Jede Anfrage mit dem Sitzungstoken von B wiederholen.
4. Antworten vergleichen: Bekommt B Daten oder Funktionen von A?

Zufällige IDs (UUIDs) erschweren das Raten, **ersetzen aber keine Prüfung** – IDs tauchen in Links, Logs und anderen Antworten auf.

## Tiefer eingetaucht

Sichere Implementierung:

- Berechtigungen **serverseitig zentral** prüfen (Middleware/Policy-Engine), nicht in jedem Controller neu.
- Abfragen an den Nutzer binden: `SELECT * FROM rechnungen WHERE id = ? AND mandant_id = ?` statt nur `WHERE id = ?`.
- **Deny by Default**: Neue Endpunkte sind gesperrt, bis eine Regel sie freigibt.
- Für Felder: Ein- und Ausgabe über explizite DTOs/Schemas, keine automatische Bindung aller Felder (**Mass Assignment**).
- Automatisierte Tests: Für jeden Endpunkt ein Test „fremder Nutzer bekommt 403/404“.

Zugriffskontrolle steht in der OWASP Top 10 (2021) auf Platz 1 – sie ist schwer zu automatisieren, weil Scanner die Geschäftslogik nicht kennen. Darum ist manuelles Testen mit mehreren Rollen so wertvoll.

## Quiz

? Was beschreibt IDOR?
+ Zugriff auf fremde Objekte durch Ändern einer Referenz wie einer ID
- Einschleusen von SQL-Befehlen
- Ausführen von JavaScript im Browser
- Überlasten des Servers
! Die Anwendung prüft nicht, ob das Objekt dem Nutzer gehört.

? Wofür steht BFLA?
= Broken Function Level Authorization
! Normale Nutzer erreichen Funktionen, die Admins vorbehalten sind.

?tf Zufällige UUIDs als IDs machen eine Berechtigungsprüfung überflüssig.
= falsch
! IDs werden oft an anderer Stelle sichtbar. Nur eine Prüfung schützt.

? Was ist der Unterschied zwischen Authentifizierung und Autorisierung?
+ Authentifizierung klärt wer, Autorisierung klärt was erlaubt ist
- beides ist dasselbe
- Autorisierung kommt immer vor der Authentifizierung
- Authentifizierung betrifft nur Admins
! IDOR ist ein Autorisierungsfehler bei korrekt funktionierender Authentifizierung.

? Wie testet man systematisch auf IDOR?
+ Anfragen eines Kontos mit der Sitzung eines zweiten Kontos wiederholen
- nur mit einem Admin-Konto testen
- ausschließlich automatische Scanner verwenden
- den Quelltext der Startseite lesen
! Zwei (oder mehr) Testkonten sind die Grundlage.

? Wie heißt das automatische Übernehmen aller Request-Felder in ein Objekt, das z. B. das Setzen von `role=admin` erlaubt?
= Mass Assignment
! Abhilfe: explizite Allowlists bzw. DTOs für erlaubte Felder.

? Welche SQL-Abfrage schützt besser gegen IDOR?
+ WHERE id = ? AND mandant_id = ?
- WHERE id = ?
- WHERE id LIKE ?
- SELECT * ohne WHERE
! Die Abfrage wird an den berechtigten Mandanten gebunden.

@@@ MODULE @@@
---
id: wb-07
title: Web vertieft 7 · Rate Limiting, Brute-Force-Schutz und Passwort-Reset
paths: cwes, cwee, specialist
order: 40.7
difficulty: medium
icon: speedometer
tags: web, authentifizierung
summary: Wie man Anmeldung, Registrierung und Passwort-Reset gegen Automatisierung und Logikfehler absichert.
---

## Einfach erklärt

Ein Schloss mit drei Ziffern hat nur 1.000 Kombinationen. Wer unbegrenzt probieren darf, öffnet es in Minuten. Webanwendungen haben dasselbe Problem: Login-Formulare, Gutscheincodes, PIN-Abfragen, 6-stellige MFA-Codes. **Rate Limiting** begrenzt, wie oft man pro Zeit probieren darf.

## Wo Rate Limiting nötig ist

- Login und MFA-Code-Eingabe
- Passwort-Reset (Anfrage **und** Code-Eingabe)
- Registrierung (Spam, Konten-Enumeration)
- Gutschein- und Einladungscodes
- teure API-Endpunkte (Suche, Export) gegen DoS

> [!WARNUNG] Kontosperre mit Augenmaß
> Harte Sperren nach wenigen Fehlversuchen erlauben Angreifern, gezielt Konten zu sperren (DoS). Besser: zunehmende Verzögerung, CAPTCHA nach Auffälligkeit, Risiko-basierte Prüfung.

## Ein sicherer Passwort-Reset

1. Gleiche Antwort, ob die E-Mail existiert oder nicht (keine **Nutzer-Enumeration**).
2. Token: lang, zufällig, **einmalig**, kurz gültig (z. B. 15–60 Minuten), serverseitig gehasht gespeichert.
3. Reset-Link aus einer **fest konfigurierten** Basis-URL bauen – nicht aus dem `Host`-Header der Anfrage.
4. Nach dem Reset: alle Sitzungen beenden, Nutzer benachrichtigen.
5. MFA bleibt aktiv; ein Reset darf MFA nicht stillschweigend aushebeln.

## Tiefer eingetaucht

Häufige Fehler, die in Tests auffallen:

- **Host-Header-Poisoning**: Die Anwendung baut den Reset-Link mit dem vom Angreifer gesetzten `Host` – der Token landet beim Angreifer, wenn das Opfer klickt.
- Rate Limit nur pro IP – umgehbar über viele IPs; besser zusätzlich pro Konto und global.
- Rate Limit über Header wie `X-Forwarded-For` aushebelbar, wenn die Anwendung diesem Header blind vertraut.
- Unterschiedliche Antwortzeiten verraten, ob ein Konto existiert (**Timing-Enumeration**).
- Reset-Tokens, die aus Zeitstempel oder Nutzer-ID abgeleitet sind und sich vorhersagen lassen.
- **Race Conditions**: Mehrere parallele Anfragen umgehen „nur einmal einlösbar“-Logik.

Gute Systeme kombinieren Rate Limits mit **Erkennung**: Auffällige Muster (viele Konten, eine IP; ein Konto, viele IPs) erzeugen Alarme.

## Quiz

? Warum sind harte Kontosperren nach drei Fehlversuchen problematisch?
+ Angreifer können gezielt Konten sperren
- sie verhindern Phishing
- sie verlangsamen den Server
- sie sind rechtlich verboten
! Das wäre ein einfacher Denial-of-Service gegen einzelne Nutzer.

? Was ist bei der Antwort auf eine Passwort-Reset-Anfrage wichtig?
+ dieselbe Antwort, egal ob die E-Mail existiert
- dem Nutzer das alte Passwort anzeigen
- den Token in der Antwort mitsenden
- die Anfrage ohne Limit zulassen
! Sonst lässt sich herausfinden, welche Konten existieren.

? Wie heißt der Angriff, bei dem ein manipulierter Host-Header den Reset-Link auf eine fremde Domain lenkt?
= Host-Header-Poisoning
= Host Header Poisoning
= Host-Header-Injection
! Reset-Links müssen aus einer fest konfigurierten Basis-URL gebaut werden.

?tf Ein Rate Limit nur pro IP-Adresse ist ausreichend gegen verteilte Angriffe.
= falsch
! Angreifer nutzen viele IPs. Zusätzlich pro Konto und global begrenzen.

? Welche Eigenschaften braucht ein Reset-Token?
+ zufällig und lang
+ einmalig verwendbar
+ kurze Gültigkeit
- aus der Nutzer-ID abgeleitet
! Vorhersagbare Tokens lassen sich erraten.

? Was sollte nach einem erfolgreichen Passwort-Reset passieren?
+ alle bestehenden Sitzungen beenden
- MFA dauerhaft deaktivieren
- das neue Passwort per E-Mail senden
- den Reset-Token wiederverwendbar lassen
! So verliert ein Angreifer, der schon eingeloggt war, den Zugriff.

? Welche Schwachstelle kann „Gutschein nur einmal einlösbar“ durch parallele Anfragen umgehen?
= Race Condition
! Prüfung und Einlösung müssen atomar erfolgen.

@@@ MODULE @@@
---
id: wb-08
title: Web vertieft 8 · Security-Header im Überblick
paths: cwes, cwee, specialist
order: 40.8
difficulty: easy
icon: list.bullet.indent
tags: web, header, härtung
summary: HSTS, CSP, X-Content-Type-Options, Referrer-Policy, Permissions-Policy und Co. – was jeder Header bewirkt und welche Werte sinnvoll sind.
---

## Einfach erklärt

Security-Header sind kurze Anweisungen des Servers an den Browser: „Lade mich nur über HTTPS“, „Lass dich nicht in fremde Seiten einbetten“, „Rate nicht, welcher Dateityp das ist“. Sie kosten fast nichts und schließen ganze Angriffsklassen.

## Die wichtigsten Header

| Header | Wert (Beispiel) | Schützt vor |
|---|---|---|
| `Strict-Transport-Security` | `max-age=31536000; includeSubDomains` | Downgrade auf HTTP, SSL-Stripping |
| `Content-Security-Policy` | siehe CSP-Modul | XSS-Ausnutzung, Clickjacking (`frame-ancestors`) |
| `X-Content-Type-Options` | `nosniff` | MIME-Sniffing |
| `Referrer-Policy` | `strict-origin-when-cross-origin` | Abfluss von URLs mit Tokens |
| `Permissions-Policy` | `camera=(), microphone=(), geolocation=()` | Missbrauch von Browser-Funktionen |
| `X-Frame-Options` | `DENY` | Clickjacking (älterer Weg) |
| `Cross-Origin-Opener-Policy` | `same-origin` | Fenster-Angriffe, Spectre-Seitenkanäle |
| `Cache-Control` | `no-store` (für sensible Seiten) | Zwischenspeichern persönlicher Daten |

> [!TIPP] Unnötiges entfernen
> Header wie `Server: Apache/2.4.41` oder `X-Powered-By: PHP/7.2` verraten Versionen. Weglassen oder kürzen – es ersetzt kein Patchen, spart Angreifern aber Recherche.

## HSTS genauer

Beim ersten Besuch sagt der Server per HSTS: „Für die nächsten 12 Monate nur noch HTTPS.“ Der Browser schreibt danach jede `http://`-Anfrage intern auf `https://` um. Problem: der **allererste** Besuch. Lösung: **HSTS-Preload-Liste** – die Domain wird fest in Browser eingebaut (Voraussetzung: `preload`, `includeSubDomains`, lange `max-age`).

## Tiefer eingetaucht

Prüfen lassen sich Header mit Browser-Entwicklerwerkzeugen, `curl -I https://example.com` oder Online-Scannern. Achtung bei der Einführung:

- `includeSubDomains` bricht Subdomains, die noch kein HTTPS haben.
- Eine zu strenge CSP bricht Funktionen – erst im Report-Only-Modus testen.
- Header müssen auch auf **Fehlerseiten**, Weiterleitungen und API-Antworten gesetzt werden, nicht nur auf der Startseite.
- Hinter Reverse Proxies/CDNs prüfen, ob Header überschrieben oder doppelt gesetzt werden.

Veraltet bzw. nicht mehr empfohlen: `X-XSS-Protection` (der Filter wurde aus Browsern entfernt und konnte selbst Lücken verursachen), `Expect-CT`, `Public-Key-Pins` (HPKP).

## Quiz

? Welcher Header zwingt den Browser, eine Domain nur noch per HTTPS aufzurufen?
= Strict-Transport-Security
= HSTS
! HSTS verhindert Downgrade-Angriffe wie SSL-Stripping.

? Welcher Wert gehört zu X-Content-Type-Options?
= nosniff
! Der Browser soll den angegebenen Content-Type respektieren und nicht raten.

? Welches Problem löst die HSTS-Preload-Liste?
+ den ungeschützten allerersten Besuch
- abgelaufene Zertifikate
- XSS in Formularen
- langsame Ladezeiten
! Preloaded Domains sind schon im Browser als HTTPS-only hinterlegt.

?tf Der Header X-XSS-Protection wird heute noch empfohlen.
= falsch
! Der XSS-Filter wurde aus modernen Browsern entfernt; Schutz bietet CSP.

? Welcher Header kann den Zugriff auf Kamera und Mikrofon verbieten?
= Permissions-Policy
! Früher hieß er Feature-Policy.

? Wie prüft man die Header einer Seite schnell auf der Kommandozeile?
= curl -I
= curl -I https://example.com
! `-I` fordert nur die Header an (HEAD-Anfrage).

? Welche Referrer-Policy ist ein guter Standard?
+ strict-origin-when-cross-origin
- unsafe-url
- no-referrer-when-downgrade
- always
! Zu fremden Origins wird nur der Origin gesendet, nicht der vollständige Pfad.

@@@ MODULE @@@
---
id: wb-09
title: Web vertieft 9 · GraphQL-Sicherheit
paths: cwes, cwee
order: 40.9
difficulty: hard
icon: point.3.connected.trianglepath.dotted
tags: web, api, graphql
summary: Wie GraphQL funktioniert, welche Risiken Introspection, tiefe Abfragen, Batching und fehlende Feld-Autorisierung bringen und wie man sie beherrscht.
---

## Einfach erklärt

Bei einer klassischen REST-API gibt es viele feste Speisekarten (`/users`, `/orders`). **GraphQL** ist ein Buffet: Es gibt **einen** Endpunkt, und der Client sagt genau, welche Daten er haben möchte – auch verschachtelt in einer einzigen Anfrage.

```graphql
query {
  user(id: 42) {
    name
    orders { id total }
  }
}
```

Das ist flexibel – aber jedes Feld braucht seine eigene Berechtigungsprüfung, und der Client kann sehr teure Anfragen stellen.

## Typische Risiken

| Risiko | Beschreibung | Gegenmaßnahme |
|---|---|---|
| Introspection | Schema inkl. versteckter Felder abrufbar | in Produktion abschalten oder einschränken |
| Fehlende Feld-Autorisierung | Prüfung nur auf Query-Ebene, nicht pro Feld/Objekt | Autorisierung im Resolver bzw. in der Geschäftslogik |
| Tiefe/zirkuläre Abfragen | `user → friends → friends → …` legt den Server lahm | Tiefen- und Komplexitätslimits |
| Batching/Aliases | hunderte Login-Versuche in einer Anfrage | Rate Limits auf Operationsebene |
| Injection | Argumente landen ungeprüft in SQL/NoSQL | parametrisierte Abfragen |
| Ausführliche Fehler | Stacktraces, Feldvorschläge | generische Fehlermeldungen |

> [!MERKE] Ein Endpunkt, viele Funktionen
> WAFs und Rate Limits, die nur auf URLs schauen, sehen bei GraphQL immer `/graphql`. Schutz muss die **Operationen** verstehen.

## Tiefer eingetaucht

**Aliases** erlauben dasselbe Feld mehrfach mit unterschiedlichen Argumenten in einer Anfrage:

```graphql
mutation {
  a: login(user: "admin", pass: "1") { token }
  b: login(user: "admin", pass: "2") { token }
}
```

Ein Rate Limit „1 Anfrage pro Sekunde“ zählt das als **eine** Anfrage. Deshalb Limits auf Anzahl Operationen/Komplexität setzen.

Weitere Praxis:

- **Persisted Queries**: Der Server akzeptiert nur vorab registrierte Abfragen (per Hash) – sehr wirksam für öffentliche Clients.
- **Query Cost Analysis**: Jede Abfrage bekommt Kosten (Felder × erwartete Listenlängen), über einem Limit wird abgelehnt.
- Auch bei deaktivierter Introspection verraten **Feldvorschläge** in Fehlermeldungen („Did you mean …?“) Teile des Schemas.
- GraphQL über GET kann CSRF ermöglichen, wenn Mutationen per GET erlaubt sind.

## Quiz

? Was ist ein typisches Merkmal von GraphQL?
+ ein Endpunkt, und der Client bestimmt die gewünschten Felder
- für jede Ressource ein eigener Endpunkt
- nur XML als Antwortformat
- keine Möglichkeit zur Verschachtelung
! Diese Flexibilität verlangt Autorisierung auf Feld- und Objektebene.

? Wie heißt die GraphQL-Funktion, die das vollständige Schema zurückliefert?
= Introspection
! In Produktion sollte sie deaktiviert oder auf Berechtigte beschränkt sein.

? Wie können Aliases ein einfaches Rate Limit umgehen?
+ viele Operationen stecken in einer einzigen HTTP-Anfrage
- sie verschlüsseln die Anfrage
- sie ändern die IP-Adresse
- sie deaktivieren den Server
! Limits müssen Operationen bzw. Komplexität zählen, nicht nur Requests.

?tf Wenn Introspection deaktiviert ist, kann man keinerlei Schema-Informationen mehr gewinnen.
= falsch
! Feldvorschläge in Fehlermeldungen und Client-Code verraten oft weiterhin Felder.

? Welche Maßnahme erlaubt nur vorab registrierte Abfragen?
= Persisted Queries
! Der Client sendet nur noch einen Hash der freigegebenen Abfrage.

? Welche Gegenmaßnahmen helfen gegen sehr tiefe, verschachtelte Abfragen?
+ Tiefenlimit
+ Komplexitäts- bzw. Kostenanalyse
- längere Timeouts
- mehr Arbeitsspeicher allein
! Begrenzen statt mit Ressourcen „durchhalten“.

? Wo sollte die Autorisierung in GraphQL stattfinden?
+ in den Resolvern bzw. der Geschäftslogik pro Objekt und Feld
- nur am Eingang des /graphql-Endpunkts
- nur im Frontend
- in der Firewall
! Eine einzige Prüfung am Endpunkt übersieht verschachtelte Zugriffe.

@@@ MODULE @@@
---
id: wb-10
title: Web vertieft 10 · Moderne Angriffsklassen konzeptionell – Cache, Smuggling, Prototype Pollution
paths: cwee
order: 40.95
difficulty: insane
icon: square.stack.3d.down.forward.fill
tags: web, fortgeschritten
summary: Web-Cache-Poisoning, HTTP Request Smuggling und Prototype Pollution – woher sie kommen, warum sie so wirkungsvoll sind und wie man Systeme dagegen absichert.
---

## Einfach erklärt

Moderne Webanwendungen bestehen aus vielen Schichten: CDN, Cache, Load Balancer, Reverse Proxy, Anwendung, Frameworks. Viele fortgeschrittene Angriffe entstehen nicht durch **einen** Fehler, sondern weil **zwei Komponenten dieselbe Sache unterschiedlich verstehen**. Wie bei der Stillen Post: Jeder macht seinen Teil richtig, und trotzdem kommt etwas Falsches an.

## Web-Cache-Poisoning

Ein Cache speichert Antworten, um sie anderen Nutzern schneller auszuliefern. Er entscheidet anhand eines **Cache-Keys** (meist Host + Pfad), ob zwei Anfragen „gleich“ sind. Beeinflusst ein Header, der **nicht** im Key steht (z. B. `X-Forwarded-Host`), die Antwort, kann ein Angreifer eine manipulierte Antwort im Cache ablegen – die dann alle anderen Besucher bekommen.

Abwehr: Antworten nur aus Key-Bestandteilen bauen, unbekannte Header am Rand verwerfen, `Vary` korrekt setzen, dynamische/personalisierte Antworten nicht cachen.

Verwandt: **Web Cache Deception** – der Cache speichert eine personalisierte Seite, weil die URL wie eine statische Datei aussieht (`/konto/profil.css`).

## HTTP Request Smuggling

Frontend (Proxy) und Backend müssen sich einigen, wo eine Anfrage endet. HTTP/1.1 kennt dafür zwei Header: `Content-Length` und `Transfer-Encoding: chunked`. Interpretieren beide Systeme eine mehrdeutige Anfrage unterschiedlich, „schmuggelt“ der Angreifer den Anfang einer zweiten Anfrage durch, die das Backend der Anfrage des **nächsten** Nutzers voranstellt.

Abwehr: HTTP/2 durchgängig bis zum Backend, mehrdeutige Anfragen am Frontend ablehnen, Verbindungen zwischen Proxy und Backend nicht unkritisch wiederverwenden, Komponenten aktuell halten.

## Prototype Pollution

In JavaScript erben Objekte Eigenschaften von `Object.prototype`. Fügt eine unsichere Merge- oder Parse-Funktion Schlüssel wie `__proto__` ungeprüft ein, verändert sie den Prototyp **aller** Objekte. Ein später geprüftes `if (user.isAdmin)` kann so plötzlich `true` sein; in Kombination mit bestimmten Bibliotheken („Gadgets“) bis hin zur Codeausführung.

Abwehr: Schlüssel `__proto__`, `constructor`, `prototype` filtern, `Object.create(null)` oder `Map` für Nutzerdaten, Schema-Validierung, Bibliotheken aktuell halten.

## Tiefer eingetaucht

Gemeinsames Muster aller drei Klassen: **Parser-Differenzen und implizite Annahmen.** Für Verteidiger heißt das:

- Architektur dokumentieren: Welche Komponente parst was, welche Header werden weitergereicht?
- Normalisieren an **einer** Stelle, mehrdeutige Eingaben **ablehnen** statt „reparieren“.
- Caches konservativ konfigurieren und regelmäßig gezielt testen.
- Abhängigkeiten scannen (SCA), da viele Gadgets in Drittbibliotheken stecken.

> [!EXAM] CWEE-Denkweise
> Bei fortgeschrittenen Prüfungen geht es weniger um einzelne Payloads als darum, das Zusammenspiel von Komponenten zu verstehen und Annahmen zu hinterfragen.

## Quiz

? Was ist die gemeinsame Ursache von Request Smuggling und vielen Cache-Angriffen?
+ verschiedene Komponenten interpretieren dieselbe Anfrage unterschiedlich
- schwache Passwörter
- fehlende Verschlüsselung
- veraltete Browser
! Parser-Differenzen zwischen Proxy, Cache und Backend sind der Kern.

? Was bestimmt, ob ein Cache zwei Anfragen als gleich betrachtet?
= Cache-Key
= Cache Key
! Beeinflussen Nicht-Key-Bestandteile die Antwort, droht Cache-Poisoning.

? Welche beiden Header sind bei klassischem Request Smuggling im Spiel?
+ Content-Length
+ Transfer-Encoding
- Content-Type
- Accept-Language
! Uneinigkeit über das Ende einer Anfrage ermöglicht das Schmuggeln.

?tf Durchgängiges HTTP/2 bis zum Backend reduziert das Risiko von Request Smuggling deutlich.
= wahr
! HTTP/2 hat eine eindeutige Längenangabe auf Frame-Ebene.

? Welcher Schlüssel ist bei Prototype Pollution besonders gefährlich?
= __proto__
! Er verändert den Prototyp, von dem alle Objekte erben.

? Wie nennt man den Angriff, bei dem ein Cache eine personalisierte Seite speichert, weil die URL wie eine statische Datei aussieht?
= Web Cache Deception
! Beispiel: /konto/profil.css liefert die Profilseite, der Cache hält sie für CSS.

? Welche Maßnahmen schützen gegen Prototype Pollution?
+ gefährliche Schlüssel wie __proto__ filtern
+ Map oder Object.create(null) für Nutzerdaten
+ Schema-Validierung der Eingaben
- längere Session-Cookies
! Mehrere Ebenen kombinieren.

@@@ MODULE @@@
---
id: wb-11
title: Web vertieft 11 · JavaScript und Node.js für Sicherheitsleute
paths: cwes, cwee, grundlagen
order: 41
difficulty: medium
icon: curlybraces
tags: web, javascript, nodejs
summary: Genug JavaScript, um Frontend-Code zu lesen, DOM-Senken zu erkennen und typische Node.js-Risiken im Backend zu verstehen.
---

## Einfach erklärt

JavaScript ist die Sprache des Browsers – und mit Node.js auch vieler Server. Wer Webanwendungen prüft oder absichert, muss JavaScript nicht schreiben wie ein Profi, aber **lesen** können: Woher kommen Daten (**Quellen**), und wo landen sie (**Senken**)?

## Quellen und Senken im Browser

| Quellen (nutzerkontrolliert) | gefährliche Senken |
|---|---|
| `location.search`, `location.hash` | `innerHTML`, `outerHTML` |
| `document.referrer` | `document.write` |
| `postMessage`-Daten | `eval`, `setTimeout("string")`, `Function()` |
| `localStorage` (wenn fremd befüllbar) | `element.src`/`href` mit `javascript:` |

Fließt eine Quelle ungeprüft in eine Senke, entsteht **DOM-XSS**.

```javascript
// unsicher
document.getElementById("gruss").innerHTML = "Hallo " + new URLSearchParams(location.search).get("name");
// sicher
document.getElementById("gruss").textContent = "Hallo " + new URLSearchParams(location.search).get("name");
```

> [!TIPP] textContent statt innerHTML
> `textContent` behandelt alles als Text. Das ist fast immer, was man will.

## Node.js im Backend

Typische Risiken:

- **Command Injection** über `child_process.exec` mit zusammengesetzten Strings – besser `execFile`/`spawn` mit Argument-Array.
- **Path Traversal** beim Ausliefern von Dateien – Pfade normalisieren und gegen ein Basisverzeichnis prüfen.
- **NoSQL-Injection**: `{ "user": "admin", "pass": { "$ne": null } }` – Typen validieren.
- **Prototype Pollution** in Merge-Funktionen.
- **ReDoS**: schlecht gebaute reguläre Ausdrücke blockieren die Event-Loop – und damit den ganzen Server.
- **Abhängigkeiten**: npm-Projekte haben oft hunderte transitive Pakete (`npm audit`, Lockfiles, SCA).

## Tiefer eingetaucht

Node.js ist **single-threaded** mit Event-Loop. Eine einzige blockierende Operation (synchrones Dateilesen, teure Regex, große JSON-Verarbeitung) hält alle anderen Anfragen an – darum wiegen DoS-Fehler hier schwerer als bei Thread-basierten Servern.

Beim Lesen von Frontend-Code helfen: Source Maps (falls ausgeliefert – dann sieht man den Originalcode), die Browser-Entwicklerwerkzeuge (Haltepunkte, Netzwerk-Tab) und die Suche nach API-Endpunkten, Schlüsseln und versteckten Routen im gebündelten Code. Geheimnisse gehören **nie** in Frontend-Code – alles, was an den Browser geht, ist öffentlich.

## Quiz

? Welche DOM-Eigenschaft ist sicher, um Nutzertext auszugeben?
+ textContent
- innerHTML
- outerHTML
- document.write
! textContent interpretiert keinen HTML-Code.

? Wie nennt man XSS, das vollständig im Browser durch Quelle → Senke entsteht?
= DOM-XSS
= DOM XSS
= DOM-based XSS
! Der Server sieht die schädlichen Daten oft gar nicht (z. B. im URL-Fragment).

? Welche Node.js-Funktion ist bei zusammengesetzten Strings anfällig für Command Injection?
+ child_process.exec
- JSON.parse
- Array.map
- console.log
! exec startet eine Shell; besser execFile/spawn mit Argument-Liste.

?tf Geheime API-Schlüssel im Frontend-JavaScript sind sicher, wenn der Code minifiziert ist.
= falsch
! Alles im Browser ist für Nutzer einsehbar.

? Was ist ReDoS?
+ Denial of Service durch extrem langsame reguläre Ausdrücke
- ein Redis-Datenbankfehler
- eine Art von CSRF
- eine Verschlüsselungsmethode
! Katastrophales Backtracking blockiert die Event-Loop.

? Welcher Payload ist ein typisches Beispiel für NoSQL-Injection?
+ {"$ne": null}
- ' OR 1=1--
- <script>alert(1)</script>
- ../../etc/passwd
! Operatoren in JSON-Eingaben verändern die Abfragelogik.

? Mit welchem npm-Befehl prüft man Abhängigkeiten auf bekannte Schwachstellen?
= npm audit
! Ergänzend helfen Lockfiles und SCA-Werkzeuge in der CI.

@@@ MODULE @@@
---
id: wb-12
title: Web vertieft 12 · Secrets-Management in Anwendungen
paths: cwes, cwee, specialist
order: 41.5
difficulty: medium
icon: key.horizontal.fill
tags: devsecops, secrets
summary: Wo Passwörter, API-Keys und Zertifikate in Projekten auftauchen, warum sie nicht ins Repository gehören und wie Vaults, Rotation und Scanning helfen.
---

## Einfach erklärt

Ein **Secret** ist alles, was Zugang verschafft: Datenbankpasswort, API-Schlüssel, privater Schlüssel, Token. Steht so etwas im Quellcode, ist es wie ein Haustürschlüssel unter der Fußmatte – jeder, der den Code sieht (Kollegen, Dienstleister, ein Leak, ein öffentliches Repo), hat den Schlüssel.

## Wo Secrets „leaken“

- im Git-Repository – **auch in alten Commits**, nachdem sie „gelöscht“ wurden
- in Docker-Images (Schichten bleiben erhalten)
- in CI/CD-Logs (`echo $PASSWORD`)
- in Konfigurationsdateien auf Webservern (`.env` öffentlich abrufbar)
- in Frontend-Code, Mobile-Apps, Fehlermeldungen
- in Tickets, Chats und Wikis

> [!GEFAHR] Geleakt heißt: rotieren
> Ein Secret, das einmal in einem Repository stand, gilt als kompromittiert. Aus der Historie entfernen reicht nicht – es muss **ersetzt** (rotiert) werden.

## Besser machen

| Praxis | Wirkung |
|---|---|
| Secrets-Manager / Vault | zentrale, verschlüsselte Ablage mit Zugriffskontrolle und Audit |
| Umgebungsvariablen zur Laufzeit | nicht im Code, nicht im Image |
| Kurzlebige, dynamische Credentials | Vault erzeugt DB-Zugänge mit Ablaufzeit |
| Workload Identity / Managed Identity | Cloud-Dienste authentifizieren sich ohne gespeicherte Schlüssel |
| Pre-Commit- und CI-Scanning | Werkzeuge wie gitleaks oder trufflehog stoppen Commits mit Secrets |
| Least Privilege | jedes Secret darf nur das Nötigste |
| Rotation | regelmäßig und sofort nach Verdacht |

## Tiefer eingetaucht

Ein gutes Secrets-Konzept beantwortet: **Wer** darf **welches** Secret **wann** lesen, und wie merken wir Missbrauch? Moderne Plattformen setzen auf **identitätsbasierten Zugriff** statt statischer Schlüssel: Ein Pod in Kubernetes erhält per Service-Account-Token eine kurzlebige Cloud-Identität (OIDC-Federation), eine CI-Pipeline per OIDC kurzzeitige Cloud-Rechte ohne gespeicherten Schlüssel.

Für Git gilt: `.gitignore` für `.env`-Dateien, verschlüsselte Konfiguration (z. B. SOPS) für Werte, die versioniert werden müssen, und Push-Protection auf der Plattform. Wird doch etwas committed: rotieren, dann Historie bereinigen (z. B. `git filter-repo`), Forks und Caches bedenken.

## Quiz

? Was ist zuerst zu tun, wenn ein API-Schlüssel in ein Repository committed wurde?
+ den Schlüssel rotieren bzw. widerrufen
- den Commit rückgängig machen und hoffen
- das Repository umbenennen
- den Schlüssel in Base64 umwandeln
! Er gilt als kompromittiert – Historie bereinigen allein reicht nicht.

?tf Ein in einem früheren Commit gelöschtes Secret ist nicht mehr auffindbar.
= falsch
! Die Git-Historie enthält alle früheren Versionen.

? Nenne ein Werkzeug, das Repositories nach Secrets durchsucht.
= gitleaks
= trufflehog
= detect-secrets
! Am besten als Pre-Commit-Hook und in der CI.

? Was ist der Vorteil dynamischer Credentials aus einem Vault?
+ sie laufen automatisch ab und sind pro Nutzung eindeutig
- sie sind kürzer
- sie brauchen keine Verschlüsselung
- sie funktionieren ohne Netzwerk
! Ein gestohlenes, kurzlebiges Credential ist schnell wertlos.

? Wo können Secrets in Container-Umgebungen versehentlich landen?
+ in Image-Schichten
+ in CI-Logs
+ in Umgebungsvariablen, die geloggt werden
- im Bildschirmschoner
! Jede Ebene muss betrachtet werden.

? Wie nennt man es, wenn Cloud-Dienste sich ohne gespeicherten Schlüssel über ihre Identität authentifizieren?
= Managed Identity
= Workload Identity
! So gibt es kein statisches Secret, das gestohlen werden könnte.

@@@ MODULE @@@
---
id: wb-13
title: Web vertieft 13 · DAST, SAST und Scanner richtig einsetzen
paths: cwes, cwee, cpts, specialist
order: 42
difficulty: medium
icon: magnifyingglass.circle.fill
tags: web, werkzeuge, devsecops
summary: Was automatische Scanner finden, was sie übersehen, wie man False Positives bewertet und Scanner sinnvoll in Entwicklung und Tests einbindet.
---

## Einfach erklärt

Automatische Scanner sind wie ein Metalldetektor am Strand: Sie finden schnell viel – auch viele Kronkorken. Den echten Schatz (Logikfehler, Berechtigungslücken) finden sie selten, weil sie nicht verstehen, was die Anwendung eigentlich tun soll.

## Arten von Tests

| Verfahren | Prüft | Stärke | Schwäche |
|---|---|---|---|
| SAST (statisch) | Quellcode ohne Ausführung | früh, findet Muster wie SQL-Strings | viele False Positives, keine Laufzeitumgebung |
| DAST (dynamisch) | laufende Anwendung von außen | realistische Ergebnisse | findet nur, was es erreicht; keine Logik |
| IAST | Agent in der laufenden App | verbindet Code und Laufzeit | Aufwand, Sprachabhängigkeit |
| SCA | Abhängigkeiten | bekannte CVEs in Bibliotheken | sagt nicht, ob die Funktion genutzt wird |
| Secret-Scanning | Repos, Images | findet Schlüssel | Muster-basiert |

> [!MERKE] Scanner ergänzen, nicht ersetzen
> Zugriffskontrolle, Geschäftslogik und Verkettungen findet man fast nur manuell.

## Ergebnisse bewerten

Jeder Fund wird geprüft:

1. **Reproduzierbar?** Lässt sich der Effekt manuell bestätigen?
2. **Erreichbar?** Ist der betroffene Code/Endpunkt im Betrieb erreichbar?
3. **Auswirkung?** Was könnte ein Angreifer konkret tun?
4. **Bewertung** (z. B. CVSS) und Priorisierung.

Ein unbestätigter Scanner-Fund gehört nicht ungeprüft in einen Pentest-Bericht.

## Tiefer eingetaucht

In der Entwicklung (**DevSecOps**) gilt: schnell und rauscharm.

- SAST und Secret-Scanning im Pull Request – nur neue Funde zeigen, nicht die Altlasten.
- SCA mit Regeln: Build bricht bei kritischen, ausnutzbaren Lücken ohne Ausnahme.
- DAST nächtlich gegen eine Testumgebung, authentifiziert gescannt (sonst sieht der Scanner nur die Login-Seite).
- Ergebnisse in ein Ticketsystem mit Verantwortlichen und Fristen.

Fallstricke bei DAST: Scanner können Daten verändern (Formulare absenden, Datensätze löschen) – nie ohne Absprache gegen Produktion. Bei Single-Page-Apps braucht es Crawler, die JavaScript ausführen, und eine API-Beschreibung (OpenAPI), damit alle Endpunkte geprüft werden.

## Quiz

? Welche Testart analysiert den Quellcode ohne ihn auszuführen?
= SAST
! Static Application Security Testing.

? Was findet ein DAST-Scanner typischerweise schlecht?
+ Fehler in der Geschäftslogik und Zugriffskontrolle
- fehlende Security-Header
- reflektiertes XSS
- veraltete Serverversionen im Banner
! Scanner kennen die beabsichtigte Logik der Anwendung nicht.

? Wofür steht SCA?
= Software Composition Analysis
! SCA prüft Drittbibliotheken auf bekannte Schwachstellen und Lizenzen.

?tf Ungeprüfte Scanner-Ergebnisse gehören direkt in einen Pentest-Bericht.
= falsch
! Funde müssen bestätigt und bewertet werden.

? Warum sollte man DAST authentifiziert ausführen?
+ sonst sieht der Scanner nur öffentliche Seiten wie den Login
- weil es schneller ist
- weil sonst keine HTTPS-Verbindung möglich ist
- weil es die Lizenz verlangt
! Der Großteil der Funktionen liegt hinter der Anmeldung.

? Warum ist DAST gegen Produktion riskant?
+ der Scanner kann Daten verändern oder Last erzeugen
- Produktion hat kein HTTPS
- Scanner funktionieren dort nicht
- es ist immer illegal
! Formulare werden abgeschickt, Datensätze angelegt oder gelöscht.

? Was sollte im Pull Request bevorzugt angezeigt werden?
+ nur neu eingeführte Funde
- alle historischen Funde
- keine Funde
- nur Funde mit CVSS 10
! Rauscharme Rückmeldung wird von Entwicklern ernst genommen.

@@@ MODULE @@@
---
id: wb-14
title: Web vertieft 14 · Webanwendungen in Python, PHP und Java absichern
paths: cwes, cwee
order: 42.5
difficulty: medium
icon: chevron.left.forwardslash.chevron.right
tags: web, entwicklung, code-review
summary: Die wichtigsten sicheren und unsicheren Muster in Flask/Django, PHP und Java/Spring – als Spickzettel für Code-Reviews.
---

## Einfach erklärt

Jede Sprache hat ihre Fallen. Wer Code reviewt, sucht deshalb nach bekannten **gefährlichen Funktionen** und prüft, ob nutzerkontrollierte Daten dort ankommen. Dieses Modul ist ein Spickzettel für drei verbreitete Welten.

## Python (Flask, Django)

| Risiko | unsicher | sicher |
|---|---|---|
| SQL | `cursor.execute("... WHERE id=" + uid)` | `cursor.execute("... WHERE id=%s", (uid,))`, ORM |
| Templates | `render_template_string(user_input)` | feste Templates, Autoescaping |
| Befehle | `os.system(f"ping {host}")` | `subprocess.run(["ping", host])` |
| Deserialisierung | `pickle.loads(data)`, `yaml.load` | `json.loads`, `yaml.safe_load` |
| Konfiguration | `DEBUG = True` in Produktion | Debug aus, `SECRET_KEY` geheim |

## PHP

| Risiko | unsicher | sicher |
|---|---|---|
| SQL | `mysqli_query($db, "... '$id'")` | PDO mit Prepared Statements |
| Ausgabe | `echo $_GET['q'];` | `htmlspecialchars($q, ENT_QUOTES)` |
| Dateien | `include($_GET['page']);` | Allowlist fester Dateinamen |
| Vergleich | `==` bei Passwort-Hashes/Tokens | `password_verify`, `hash_equals`, `===` |
| Deserialisierung | `unserialize($_COOKIE['x'])` | `json_decode` |

> [!WARNUNG] PHP-Typjonglage
> Der lose Vergleich `==` kann Strings wie `"0e123"` und `"0e456"` als gleich behandeln (beide werden als Zahl 0 gelesen). Bei Sicherheitsprüfungen immer strikt vergleichen.

## Java (Spring)

| Risiko | unsicher | sicher |
|---|---|---|
| SQL | String-Konkatenation in JDBC | `PreparedStatement`, JPA-Parameter |
| Deserialisierung | `ObjectInputStream.readObject()` auf Eingaben | JSON mit festen DTOs |
| XML | Standard-`DocumentBuilderFactory` alter Versionen | DTDs/externe Entities deaktivieren |
| Mass Assignment | Entity direkt an Request binden | DTOs, `@JsonIgnore` |
| Expression Language | Nutzereingabe in SpEL/OGNL | nie Eingaben als Ausdruck auswerten |

## Tiefer eingetaucht

Vorgehen beim Review (**Source → Sink**):

1. Einstiegspunkte finden: Routen, Controller, Message-Handler.
2. Datenfluss verfolgen bis zu gefährlichen Senken.
3. Validierung, Kodierung und Berechtigungsprüfung auf dem Weg prüfen.
4. Framework-Schutz verstehen: Was macht das Framework automatisch (z. B. Autoescaping, CSRF-Middleware), und wo wird es bewusst umgangen (`|safe`, `@csrf_exempt`, `th:utext`)?

Die interessantesten Funde liegen oft dort, wo Entwickler den Schutz des Frameworks **ausschalten** – diese Stellen gezielt suchen.

## Quiz

? Wie führt man in Python einen Befehl ohne Shell-Interpretation aus?
+ subprocess.run mit einer Argument-Liste
- os.system mit f-String
- eval
- exec
! Ohne Shell werden Sonderzeichen wie ; oder | nicht interpretiert.

? Welche PHP-Funktion kodiert HTML-Sonderzeichen für die Ausgabe?
= htmlspecialchars
! Mit ENT_QUOTES werden auch Anführungszeichen kodiert.

?tf In PHP kann `"0e123" == "0e456"` true ergeben.
= wahr
! Beide werden als wissenschaftliche Notation für 0 interpretiert – daher strikt vergleichen.

? Welche YAML-Funktion ist in Python sicher für fremde Daten?
= yaml.safe_load
= safe_load
! yaml.load ohne SafeLoader kann beliebige Objekte erzeugen.

? Welche Flask-Funktion ist mit Nutzereingaben gefährlich (SSTI)?
+ render_template_string
- jsonify
- redirect
- url_for
! Nutzereingaben werden dort als Template ausgewertet.

? Wonach sucht man im Code-Review gezielt, weil dort Framework-Schutz umgangen wird?
+ Stellen wie |safe, @csrf_exempt oder th:utext
- Kommentare in Englisch
- lange Funktionsnamen
- Unit-Tests
! Bewusste Ausnahmen vom Standard-Schutz sind häufige Fehlerquellen.

? Was beschreibt der Review-Ansatz „Source → Sink“?
+ Datenfluss von Nutzereingaben bis zu gefährlichen Funktionen verfolgen
- Code von unten nach oben lesen
- nur Dateien mit „source“ im Namen prüfen
- Abhängigkeiten aktualisieren
! So findet man gezielt Injection- und Ausgabefehler.
