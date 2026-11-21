---
id: wd-01
title: Web-Verteidigung 1 · Webserver härten
paths: cwes, specialist
order: 50
difficulty: medium
icon: server.rack
tags: webdef
summary: Apache, Nginx und IIS sicher konfigurieren – minimale Module, eigene Benutzer, Verzeichnisrechte, Header, TLS, Rate Limits und Logging.
---

## Grundprinzipien

1. nur benötigte Module und Funktionen aktivieren
2. Webserver als eigener, unprivilegierter Benutzer
3. Webroot nur lesbar; schreibbare Verzeichnisse ohne Ausführung
4. Versionsangaben und Verzeichnislisten abschalten
5. TLS modern konfigurieren, HTTP auf HTTPS umleiten
6. Sicherheits-Header setzen
7. Zugriffs- und Fehlerlogs zentral sammeln

## Nginx (Auszug)

```nginx
server_tokens off;
autoindex off;
client_max_body_size 10m;
add_header Strict-Transport-Security "max-age=31536000; includeSubDomains" always;
add_header X-Content-Type-Options "nosniff" always;
add_header Content-Security-Policy "default-src 'self'; frame-ancestors 'none'" always;
location ~ /\.(git|env|ht) { deny all; }
limit_req_zone $binary_remote_addr zone=login:10m rate=5r/m;
```

## Apache (Auszug)

```apache
ServerTokens Prod
ServerSignature Off
TraceEnable Off
Options -Indexes -Includes
<DirectoryMatch "/\.git"> Require all denied </DirectoryMatch>
Header always set X-Content-Type-Options "nosniff"
```

## IIS

- unnötige Rollendienste entfernen (WebDAV, CGI, wenn nicht gebraucht)
- Request Filtering (Dateiendungen, versteckte Segmente wie `web.config`, `.git`)
- Anwendungspools mit eigener Identität
- detaillierte Fehlermeldungen nur lokal

> [!WARNUNG] Versteckte Dateien
> `.git/`, `.env`, Backup-Dateien (`config.php.bak`, `~`-Dateien) und Entwicklungsartefakte im Webroot sind häufige, kritische Befunde. Deployment-Prozesse sollten nur das Nötige ausliefern.

## Quiz

? Welche Nginx-Direktive blendet die Versionsangabe aus?
= server_tokens off

? Welche Apache-Option deaktiviert Verzeichnislisten?
= -Indexes
= Options -Indexes

? Unter welchem Benutzer sollte ein Webserver laufen?
+ eigener, unprivilegierter Benutzer
- root
- Administrator
- der Benutzer des Entwicklers

? Welche Dateien gehören nie in den Webroot?
+ .git-Verzeichnis
+ .env-Dateien
- index.html
- style.css

? Welche Nginx-Funktion begrenzt die Zahl der Anfragen?
= limit_req
= limit_req_zone

@@@ MODULE @@@
---
id: wd-02
title: Web-Verteidigung 2 · Session-Management richtig gemacht
paths: cwes, cwee
order: 51
difficulty: medium
icon: person.badge.clock
tags: webdef
summary: Session-IDs, Cookie-Attribute, Lebensdauer, Erneuerung, Logout, Session Fixation und Hijacking verstehen und verhindern – mit Checkliste.
htb: Session Security
---

## Anforderungen an Session-IDs

| Anforderung | Begründung |
|---|---|
| mindestens 128 Bit Zufall aus CSPRNG | nicht erratbar |
| keine Bedeutung im Inhalt | keine Rückschlüsse auf Benutzer |
| nur im Cookie, nie in der URL | URLs landen in Logs, Verläufen, Referer-Headern |
| `Secure`, `HttpOnly`, `SameSite` | Transport, JavaScript-Zugriff, CSRF |
| `__Host-`-Präfix | Cookie nur für exakt diese Origin, mit `Secure` und `Path=/` |

## Lebenszyklus

| Ereignis | Maßnahme |
|---|---|
| Login | **neue** Session-ID ausstellen (gegen Session Fixation) |
| Rechteänderung (z. B. Admin-Modus) | erneut neue ID |
| Inaktivität | Idle-Timeout (z. B. 15–30 Minuten bei sensiblen Anwendungen) |
| absolute Dauer | maximale Lebensdauer unabhängig von Aktivität |
| Logout | serverseitig ungültig machen, Cookie löschen |
| Passwortänderung | alle anderen Sitzungen beenden |

## Angriffe verstehen

| Angriff | Prinzip | Schutz |
|---|---|---|
| Session Hijacking | gestohlene Session-ID (XSS, unverschlüsselte Verbindung, Malware) | HttpOnly, TLS, kurze Laufzeiten, Bindung an Kontext |
| Session Fixation | Opfer meldet sich mit einer vom Angreifer vorgegebenen ID an | ID nach Login erneuern |
| CSRF | Browser sendet Cookie bei fremd ausgelösten Anfragen | SameSite, Anti-CSRF-Token |

## Erkennung

- gleiche Session aus sehr unterschiedlichen IPs oder Ländern
- Session-Nutzung nach Logout
- viele ungültige Session-IDs (Ratenversuche)

## Quiz

? Wann muss eine Session-ID unbedingt erneuert werden?
+ nach dem Login
- nur beim Logout
- nie
- einmal pro Woche

? Warum gehören Session-IDs nicht in die URL?
+ URLs landen in Logs, Verläufen und Referer-Headern
- URLs sind zu kurz
- Browser löschen URLs
- Server können keine URLs lesen

? Welches Cookie-Präfix bindet ein Cookie streng an die Origin?
= __Host-

? Wie heißt der Angriff, bei dem das Opfer eine vorgegebene Session-ID verwendet?
= Session Fixation

? Wie viele Bit Zufall sollte eine Session-ID mindestens haben?
= 128

@@@ MODULE @@@
---
id: wd-03
title: Web-Verteidigung 3 · CORS und Browser-Sicherheitsmodell
paths: cwes, cwee
order: 52
difficulty: hard
icon: globe.badge.chevron.backward
tags: webdef
summary: Same-Origin-Policy im Detail, CORS-Header und Preflight, gefährliche Konfigurationen, SameSite-Cookies und wie Browser-Isolation moderne Anwendungen schützt.
---

## Same-Origin-Policy

Eine Seite darf die Antworten anderer **Origins** (Schema + Host + Port) nicht lesen. Sie darf aber viele Anfragen **senden** (Formulare, Bilder, Skripte) – daher kommt CSRF.

## CORS

**Cross-Origin Resource Sharing** erlaubt einem Server, bestimmten fremden Origins Lesezugriff zu geben.

| Header | Bedeutung |
|---|---|
| `Access-Control-Allow-Origin` | erlaubte Origin (exakt) oder `*` |
| `Access-Control-Allow-Credentials: true` | Cookies dürfen mitgeschickt und Antworten gelesen werden |
| `Access-Control-Allow-Methods` / `-Headers` | erlaubte Methoden und Header |
| `Access-Control-Max-Age` | Cache-Dauer des Preflights |

Für „nicht einfache“ Anfragen (z. B. `PUT`, JSON-Body, eigene Header) schickt der Browser vorher eine **Preflight**-Anfrage (`OPTIONS`).

## Gefährliche Konfigurationen

| Konfiguration | Problem |
|---|---|
| Origin wird ungeprüft gespiegelt + Credentials | jede Webseite kann Daten des angemeldeten Benutzers lesen |
| Prüfung per „endet mit“ oder „enthält“ | `firma.example.angreifer.org` passt |
| `null`-Origin erlaubt | sandboxed iframes und lokale Dateien erhalten Zugriff |
| Wildcard-Subdomains erlaubt | eine verwundbare Subdomain gefährdet alles |

**Richtig:** exakte Allowlist, Credentials nur wo nötig, `Vary: Origin` setzen.

## Weitere Browser-Schutzmechanismen

| Mechanismus | Wirkung |
|---|---|
| SameSite-Cookies | Cookies nicht bei Cross-Site-Anfragen |
| CSP | erlaubte Quellen für Inhalte ([[mod:b-03|XSS]]) |
| COOP/COEP/CORP | Isolation von Fenstern und Ressourcen |
| Fetch Metadata (`Sec-Fetch-Site`) | Server erkennt Herkunft von Anfragen und kann Cross-Site-Anfragen ablehnen |

## Quiz

? Was erlaubt die Same-Origin-Policy und was verhindert sie?
+ Sie verhindert das Lesen fremder Antworten, erlaubt aber viele Anfragen
- Sie verhindert jede Anfrage an fremde Seiten
- Sie erlaubt alles
- Sie betrifft nur Bilder

? Welche HTTP-Methode nutzt der CORS-Preflight?
= OPTIONS

? Warum ist das ungeprüfte Spiegeln der Origin mit Credentials gefährlich?
+ Jede Webseite kann Daten des angemeldeten Benutzers lesen
- Die Seite wird langsamer
- Cookies werden gelöscht
- Es ist nicht gefährlich

? Welcher Header sollte bei dynamischen CORS-Antworten gesetzt werden?
= Vary: Origin
= Vary

? Welche Request-Header-Familie verrät dem Server die Herkunft einer Anfrage?
= Sec-Fetch
= Fetch Metadata
= Sec-Fetch-Site

@@@ MODULE @@@
---
id: wd-04
title: Web-Verteidigung 4 · WAF-Betrieb
paths: cwes, cdsa, specialist
order: 53
difficulty: medium
icon: shield.lefthalf.filled.trianglebadge.exclamationmark
tags: webdef
summary: Wie Web Application Firewalls arbeiten, OWASP Core Rule Set, Anomalie-Bewertung, Einführung im Erkennungsmodus, Tuning gegen Fehlalarme und ihre Grenzen.
---

## Funktionsweise

Eine **WAF** prüft HTTP-Anfragen (und teils Antworten) gegen Regeln und blockiert verdächtige Muster. Sie kann als Modul im Webserver (ModSecurity, Coraza), als Reverse Proxy oder als Cloud-Dienst laufen.

| Ansatz | Beschreibung |
|---|---|
| Negativmodell | bekannte Angriffsmuster blockieren (Signaturen) |
| Positivmodell | nur erwartete Anfragen erlauben (Schema, Längen, Parameter) |
| Anomalie-Scoring | jede passende Regel addiert Punkte; ab Schwelle wird blockiert |

## OWASP Core Rule Set

Das **CRS** ist ein freier Regelsatz für ModSecurity-kompatible WAFs. Es arbeitet mit **Paranoia-Levels** (1–4): Höhere Stufen erkennen mehr, erzeugen aber mehr Fehlalarme.

## Einführung

1. im **Detection-/Log-Only-Modus** starten
2. Fehlalarme analysieren, gezielte Ausnahmen pro Anwendung und Parameter definieren
3. schrittweise in den Blockiermodus wechseln
4. Paranoia-Level und Schwellen nach Risiko anpassen
5. WAF-Logs ins SIEM, Regeln versionieren

## Grenzen

- Logikfehler, Zugriffskontrollprobleme und IDOR erkennt eine WAF kaum
- Umgehung über unerwartete Kodierungen oder Parser-Unterschiede ist möglich
- verschlüsselte oder binäre Formate sind schwer zu prüfen
- sie ersetzt **keine** sichere Entwicklung, sondern verschafft Zeit (z. B. als **virtueller Patch** bis zum Update)

## Quiz

? Wie heißt der freie WAF-Regelsatz von OWASP?
= Core Rule Set
= CRS

? Wie heißen die Stufen, mit denen das CRS Erkennung und Fehlalarme abwägt?
= Paranoia-Levels
= Paranoia Level

? In welchem Modus sollte eine WAF eingeführt werden?
+ zuerst im Erkennungs- bzw. Log-Only-Modus
- sofort im Blockiermodus mit höchster Stufe
- gar nicht
- nur nachts

? Welche Schwachstellen erkennt eine WAF kaum?
+ IDOR und Logikfehler
- einfache SQL-Injection-Muster
- bekannte XSS-Payloads
- Path-Traversal-Muster

? Wie nennt man eine WAF-Regel, die eine bekannte Lücke bis zum Update abfängt?
= virtueller Patch
= Virtual Patch

@@@ MODULE @@@
---
id: wd-05
title: Web-Verteidigung 5 · Logging und Angriffserkennung in Webanwendungen
paths: cwes, cdsa
order: 54
difficulty: medium
icon: doc.text.magnifyingglass
tags: webdef
summary: Access-Logs lesen, Angriffsmuster in Webserver- und Anwendungslogs erkennen, sinnvolle Anwendungsereignisse, Korrelation und typische SIEM-Regeln.
---

## Access-Log lesen

```text
203.0.113.7 - - [21/Nov/2026:12:01:07 +0000] "GET /search?q=test HTTP/1.1" 200 5123 "-" "Mozilla/5.0"
```

| Feld | Inhalt |
|---|---|
| IP | Client (hinter Proxys: X-Forwarded-For auswerten) |
| Zeit | mit Zeitzone |
| Anfrage | Methode, Pfad, Query, Protokoll |
| Status | Antwortcode |
| Größe | Bytes der Antwort |
| Referer, User-Agent | Herkunft, Client |

> [!INFO] Was fehlt
> POST-Bodys erscheinen nicht im Access-Log. Für Angriffe auf Formulare und APIs braucht man Anwendungs- oder WAF-Logs.

## Muster

| Muster | Hinweis auf |
|---|---|
| viele 404 in kurzer Zeit, bekannte Pfade (`/wp-admin`, `/.env`, `/.git/`) | Scans / Fuzzing |
| Sonderzeichen und SQL-Schlüsselwörter in Parametern | Injection-Versuche |
| `../` oder kodierte Varianten | Path Traversal |
| viele 401/403 auf Login-Endpunkt | Passwort-Angriffe |
| aufsteigende IDs in API-Pfaden mit 200/403 | Aufzählung / IDOR-Tests |
| ungewöhnliche Methoden (TRACE, PUT, DELETE) | Konfigurationstests |
| große Antworten an einzelne Clients | Datenabfluss |

## Anwendungsereignisse

Die Anwendung selbst sollte sicherheitsrelevante Ereignisse protokollieren: Logins, Fehlversuche, MFA, Passwortänderungen, Rechteänderungen, Zugriffsverweigerungen, Validierungsfehler, Exporte großer Datenmengen – strukturiert, mit Benutzer, Quelle und Korrelations-ID (siehe [[mod:ow-09|OWASP A09]]).

## Beispiel-Regeln fürs SIEM

- mehr als 100 × 404 von einer IP in 5 Minuten
- mehr als 20 fehlgeschlagene Logins auf ein Konto in 10 Minuten, oder über viele Konten von einer IP
- erfolgreicher Login nach vielen Fehlversuchen
- Zugriff auf Admin-Funktionen außerhalb bekannter IP-Bereiche

## Quiz

? Welche Daten fehlen im klassischen Access-Log?
+ POST-Bodys
- Statuscodes
- Zeitstempel
- Pfade

? Worauf deuten viele 404-Antworten auf Pfade wie /.env und /.git/ hin?
+ Scans oder Fuzzing
- normale Benutzer
- ein Zertifikatsproblem
- einen Stromausfall

? Worauf deuten aufsteigende IDs in API-Pfaden mit wechselnden 200/403 hin?
+ Aufzählung bzw. IDOR-Tests
- Caching
- normales Scrollen
- ein Update

? Welcher Header enthält hinter Proxys die echte Client-IP?
= X-Forwarded-For

?tf Ein erfolgreicher Login nach vielen Fehlversuchen ist ein lohnender Alarm.
= wahr

@@@ MODULE @@@
---
id: wd-06
title: Web-Verteidigung 6 · Sicheres Hosting und Betrieb
paths: cwes, specialist
order: 55
difficulty: easy
icon: externaldrive.connected.to.line.below
tags: webdef
summary: Trennung von Umgebungen, Deployment ohne Altlasten, Backups, Monitoring, CDN und DDoS-Schutz, Abhängigkeiten und Notfallplan für Webanwendungen.
---

## Umgebungen trennen

| Umgebung | Regeln |
|---|---|
| Entwicklung | keine echten Kundendaten |
| Test/Staging | nicht öffentlich erreichbar oder geschützt (SSO, IP-Allowlist) |
| Produktion | nur über Pipeline änderbar, Zugriff protokolliert |

Testsysteme im Internet sind ein klassischer Einstiegspunkt – siehe [[mod:c-16|Fallstudie]].

## Sauberes Deployment

- Artefakte aus der CI-Pipeline, keine manuellen Kopien
- keine Entwicklungsdateien (`.git`, Tests, Beispielkonfigurationen) ausliefern
- Secrets zur Laufzeit aus einem Secret-Store
- unveränderliche Images/Container, Rollback möglich

## Betrieb

| Thema | Maßnahme |
|---|---|
| Backups | Datenbank und Uploads, getestete Wiederherstellung |
| Updates | Plattform, Laufzeit, Bibliotheken mit Fristen |
| Monitoring | Verfügbarkeit, Fehlerquoten, ungewöhnliche Muster |
| CDN/WAF | Lastverteilung, DDoS-Schutz, virtuelle Patches |
| TLS | automatische Zertifikatserneuerung, Ablaufüberwachung |
| Zugänge | Admin-Bereiche nur über SSO/MFA bzw. VPN |

## Notfallplan für Webanwendungen

1. Kontaktliste (Entwicklung, Betrieb, Hosting, Datenschutz)
2. Wartungsseite bereit halten
3. Logs sichern, betroffene Version identifizieren
4. Lücke schließen oder Funktion abschalten, ggf. virtueller Patch
5. Secrets und Sessions rotieren
6. Meldepflichten prüfen ([[mod:s-05|Recht]])

## Quiz

? Welche Daten haben in Entwicklungsumgebungen nichts zu suchen?
= echte Kundendaten
= Kundendaten

? Wie sollte Produktion geändert werden?
+ nur über die CI/CD-Pipeline
- per FTP vom Entwickler-Laptop
- direkt auf dem Server mit einem Editor
- gar nicht

? Woher sollten Anwendungen ihre Secrets zur Laufzeit beziehen?
= Secret-Store
= Secret Store

? Was gehört in den Notfallplan einer Webanwendung?
+ Kontaktliste, Wartungsseite, Rotation von Secrets und Sessions
- nur ein Neustart des Servers
- das Löschen aller Logs
- nichts

?tf Staging-Umgebungen sollten öffentlich ohne Schutz erreichbar sein.
= falsch
