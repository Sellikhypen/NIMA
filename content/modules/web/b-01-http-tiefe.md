---
id: b-01
title: HTTP und TLS in der Tiefe
paths: cwes, cpts, cwee
order: 6
difficulty: medium
icon: arrow.up.arrow.down.circle
summary: Anfragen und Antworten im Detail, wichtige Header, Sicherheits-Header, Caching, Weiterleitungen, HTTP/2 und HTTP/3, der TLS-1.3-Handshake und HSTS.
---

## Aufbau einer Antwort

```http
HTTP/1.1 200 OK
Date: Sat, 21 Nov 2026 12:00:00 GMT
Content-Type: text/html; charset=utf-8
Set-Cookie: session=8f2…; Secure; HttpOnly; SameSite=Lax
Cache-Control: no-store
Strict-Transport-Security: max-age=31536000; includeSubDomains
Content-Security-Policy: default-src 'self'
```

## Wichtige Anfrage-Header

| Header | Bedeutung | Sicherheitsaspekt |
|---|---|---|
| `Host` | Zielname (vHost) | Anwendungen dürfen ihm für Links nicht blind vertrauen |
| `Cookie` | Sitzungsdaten | Session-Schutz |
| `Authorization` | Basic, Bearer-Token | nur über TLS |
| `Origin` / `Referer` | Herkunft der Anfrage | Hilfsmittel gegen CSRF |
| `Content-Type` | Format des Bodys | falsche Annahmen führen zu Parser-Fehlern |
| `X-Forwarded-For` | Client-IP hinter Proxys | nur vom eigenen Proxy vertrauen |
| `User-Agent` | Client-Software | frei wählbar |

## Sicherheits-Header

| Header | Schutz |
|---|---|
| `Strict-Transport-Security` (HSTS) | Browser nutzt nur noch HTTPS für die Domain |
| `Content-Security-Policy` (CSP) | erlaubte Quellen für Skripte, Styles, Frames – starke XSS-Bremse |
| `X-Content-Type-Options: nosniff` | kein Raten des Dateityps |
| `X-Frame-Options` / CSP `frame-ancestors` | Schutz vor Clickjacking |
| `Referrer-Policy` | begrenzt weitergegebene URL-Informationen |
| `Permissions-Policy` | sperrt Browserfunktionen (Kamera, Mikrofon …) |
| `Cross-Origin-Opener-Policy` / `-Resource-Policy` | Isolation zwischen Origins |

## Caching

| Header | Bedeutung |
|---|---|
| `Cache-Control: no-store` | nichts speichern – für persönliche Seiten |
| `Cache-Control: private` | nur im Browser, nicht in gemeinsamen Caches |
| `Cache-Control: public, max-age=…` | darf überall zwischengespeichert werden |
| `Vary` | welche Anfrage-Header die Antwort beeinflussen |

Falsch konfigurierte Caches können persönliche Daten an andere Benutzer ausliefern – siehe [[mod:x-03|moderne Schwachstellenklassen]].

## Weiterleitungen

`301/308` (dauerhaft) und `302/303/307` (temporär) leiten über den `Location`-Header weiter. Wird das Ziel aus Benutzereingaben übernommen, entsteht ein **Open Redirect** – nützlich für Phishing und als Baustein für OAuth-Angriffe. Schutz: nur relative Ziele oder eine Allowlist.

## HTTP/2 und HTTP/3

| Version | Merkmale |
|---|---|
| HTTP/1.1 | Text, eine Anfrage pro Verbindung zur Zeit |
| HTTP/2 | binär, Multiplexing vieler Streams, Header-Kompression |
| HTTP/3 | über QUIC (UDP), schnellerer Verbindungsaufbau, TLS 1.3 integriert |

## Der TLS-1.3-Handshake

1. **ClientHello** – unterstützte Cipher Suites, Schlüsselanteil (Key Share), Servername (SNI)
2. **ServerHello** – Auswahl, eigener Key Share; ab hier ist alles verschlüsselt
3. Server sendet **Zertifikat** und **CertificateVerify** (Beweis des privaten Schlüssels), **Finished**
4. Client prüft Zertifikatskette und Hostnamen, sendet **Finished**

Nur noch eine Runde Hin und Zurück, Forward Secrecy ist Pflicht, veraltete Verfahren wurden entfernt. Details zur Kryptografie in [[mod:f-08|Kryptografie]].

> [!TIPP] TLS-Konfiguration prüfen
> Werkzeuge wie `testssl.sh` oder der SSL-Labs-Test zeigen unterstützte Protokolle, Cipher Suites, Zertifikatsprobleme und fehlende HSTS-Einstellungen.

## Quiz

? Welcher Header sorgt dafür, dass der Browser eine Domain nur noch per HTTPS aufruft?
= Strict-Transport-Security
= HSTS

? Welcher Header beschränkt erlaubte Skriptquellen und bremst XSS?
= Content-Security-Policy
= CSP

? Welcher Header verhindert das Raten des Dateityps?
= X-Content-Type-Options

? Welcher Cache-Control-Wert verbietet jegliches Speichern?
= no-store

? Wie heißt die Schwachstelle, wenn Weiterleitungsziele aus Benutzereingaben übernommen werden?
= Open Redirect

? Über welches Transportprotokoll läuft HTTP/3?
= QUIC

? Wie viele Roundtrips braucht der TLS-1.3-Handshake?
= 1
= eine

? Welches Werkzeug prüft TLS-Konfigurationen auf der Kommandozeile?
= testssl.sh
= testssl
