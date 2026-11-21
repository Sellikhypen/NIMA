---
id: c-04
title: Web-Recon und Proxies
paths: cwes, cpts, cwee
order: 4
difficulty: easy
icon: network.badge.shield.half.filled
summary: Passive und aktive Informationsgewinnung über Web-Anwendungen, Fingerprinting, Crawling und die Arbeit mit Intercepting Proxies wie Burp Suite und OWASP ZAP.
htb: Information Gathering - Web Edition
---

## Passive Informationsgewinnung

| Quelle | Erkenntnis |
|---|---|
| WHOIS | Registrant, Nameserver, Zeitpunkte |
| DNS-Records | Mailserver, Subdomains, Verifizierungseinträge |
| Certificate Transparency (z. B. crt.sh) | alle jemals ausgestellten Zertifikate – oft mit internen Subdomain-Namen |
| Suchmaschinen (Operatoren wie `site:`, `filetype:`) | indexierte Dokumente, Login-Seiten |
| Web-Archive | frühere Versionen, entfernte Seiten |
| Code-Repositories | versehentlich veröffentlichte Konfigurationen und Schlüssel |

## Aktive Informationsgewinnung

- **Fingerprinting** – Webserver, Frameworks, CMS, Versionen (HTTP-Header, Cookies, typische Pfade, Werkzeuge wie WhatWeb, Wappalyzer)
- **WAF-Erkennung** – sitzt eine Web Application Firewall davor?
- **Crawling/Spidering** – Links verfolgen, Seiten und Parameter sammeln
- **robots.txt, sitemap.xml, /.well-known/** – Hinweise auf Pfade und Konfiguration
- **Virtual Hosts** – mehrere Anwendungen auf einer IP, unterschieden über den `Host`-Header

> [!MERKE] Subdomains und vHosts
> Subdomains stehen im DNS, vHosts nicht zwingend. Testumgebungen (`dev.`, `staging.`) sind oft schlechter geschützt als die Produktion – für Verteidiger ein Grund, sie nicht öffentlich erreichbar zu machen.

## Intercepting Proxies

Ein **Intercepting Proxy** sitzt zwischen Browser und Anwendung, zeigt jede Anfrage und Antwort und erlaubt, sie anzuhalten und zu verändern. Standardwerkzeuge: **Burp Suite** und **OWASP ZAP**.

| Funktion (Burp) | Zweck |
|---|---|
| Proxy / HTTP history | gesamten Verkehr mitschreiben |
| Repeater | eine Anfrage gezielt verändern und erneut senden |
| Intruder | Anfragen mit variierenden Werten automatisiert senden |
| Decoder | Kodierungen umwandeln |
| Comparer | Antworten vergleichen |
| Scanner (Pro) / Active Scan (ZAP) | automatisierte Prüfungen |

> [!TIPP] Warum der Proxy so wichtig ist
> Er zeigt, was die Anwendung **wirklich** tut: versteckte Parameter, API-Aufrufe, Cookies, Header, Weiterleitungen. Viele Web-Schwachstellen erkennt man erst, wenn man den Verkehr sieht – nicht in der Oberfläche.

## Die Verteidigersicht

- Versionsinformationen in Headern reduzieren (`Server`, `X-Powered-By`)
- Testsysteme nicht öffentlich erreichbar machen
- keine Geheimnisse in Repositories (Secret-Scanning einsetzen)
- Sicherheits-Header setzen (Content-Security-Policy, HSTS, X-Content-Type-Options)
- WAF als zusätzliche Schicht – nicht als Ersatz für sichere Entwicklung

## Quiz

? Welche Quelle listet alle jemals ausgestellten TLS-Zertifikate einer Domain?
= Certificate Transparency
= crt.sh

? Welches Burp-Werkzeug dient dazu, eine einzelne Anfrage gezielt zu verändern und erneut zu senden?
= Repeater

? Über welchen HTTP-Header werden Virtual Hosts unterschieden?
= Host

? Welche Dateien geben oft Hinweise auf Pfade einer Website?
+ robots.txt
+ sitemap.xml
- index.lock
- favicon.ico

? Welches Open-Source-Werkzeug ist eine Alternative zu Burp Suite?
= OWASP ZAP
= ZAP

?tf Eine WAF ersetzt sichere Programmierung.
= falsch
