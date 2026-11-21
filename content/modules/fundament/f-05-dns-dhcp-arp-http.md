---
id: f-05
title: DNS, DHCP, ARP und HTTP verstehen
paths: grundlagen, cjca, cwes
order: 5
difficulty: easy
icon: globe.europe.africa
summary: Die vier Protokolle, ohne die kein Netzwerk funktioniert – wie sie arbeiten, welche Informationen sie preisgeben und wo ihre Schwachstellen liegen.
htb: Web Requests
---

## DNS – das Telefonbuch des Internets

[[DNS]] übersetzt Namen wie `academy.example.com` in IP-Adressen. Ein Client fragt seinen **Resolver**; dieser fragt bei Bedarf die Root-Server, dann die Server der Top-Level-Domain und schließlich den **autoritativen** Nameserver der Domain. Antworten werden für die Dauer der **TTL** zwischengespeichert.

| Record | Inhalt | Beispiel |
|---|---|---|
| A | IPv4-Adresse | `www → 203.0.113.10` |
| AAAA | IPv6-Adresse | `www → 2001:db8::10` |
| CNAME | Alias auf anderen Namen | `shop → www` |
| MX | Mailserver der Domain | `10 mail.example.com` |
| NS | zuständige Nameserver | `ns1.example.com` |
| TXT | freier Text (SPF, DKIM, Verifizierung) | `v=spf1 …` |
| SOA | Verwaltungsinfos der Zone | Admin-Mail, Seriennummer |
| PTR | Rückwärtsauflösung (IP → Name) | `10.113.0.203.in-addr.arpa` |
| SRV | Dienste und Ports | `_ldap._tcp.dc._msdcs…` |

> [!INFO] DNS verrät viel
> Subdomains wie `vpn.`, `dev.`, `staging.` oder `mail.` zeigen die Infrastruktur eines Unternehmens. In Active-Directory-Netzen verraten SRV-Records, wo die Domain Controller stehen. Das macht DNS zur ersten Station jeder Aufklärung – und zu einer wichtigen Datenquelle für Verteidiger, die ungewöhnliche Abfragen erkennen wollen.

> [!GEFAHR] Zonentransfers
> Ein [[Zonentransfer]] (AXFR) überträgt eine komplette Zone an einen anderen Nameserver. Ist er für beliebige Anfragende erlaubt, bekommt jeder die vollständige Liste aller Hostnamen. Zonentransfers gehören auf autorisierte sekundäre Server beschränkt.

## DHCP – automatische Adressvergabe

[[DHCP]] verteilt IP-Adresse, Maske, Gateway und DNS-Server. Der Ablauf heißt **DORA**:

1. **Discover** – Client ruft per Broadcast nach einem Server.
2. **Offer** – Server bietet eine Adresse an.
3. **Request** – Client fordert sie an.
4. **Acknowledge** – Server bestätigt.

> [!WARNUNG] Rogue DHCP
> Weil Clients dem ersten antwortenden Server glauben, kann ein fremder DHCP-Server falsche Gateways oder DNS-Server verteilen und so Verkehr umleiten. Gegenmaßnahme in Switches: **DHCP Snooping**.

## ARP – von IP zu MAC

Im lokalen Netz braucht ein Rechner die MAC-Adresse des Ziels. [[ARP]] fragt per Broadcast „Wer hat 192.168.1.1?“ und merkt sich die Antwort im ARP-Cache.

> [!GEFAHR] ARP vertraut blind
> ARP hat keine Authentifizierung. Ein Gerät kann ungefragt behaupten, eine bestimmte IP zu besitzen ([[ARP-Spoofing]]) und sich so zwischen zwei Kommunikationspartner schalten ([[Man-in-the-Middle]]). Schutz: Dynamic ARP Inspection, Netzsegmentierung und durchgängige Verschlüsselung mit [[TLS]], damit mitgelesener Verkehr wertlos ist.

## HTTP – die Sprache des Webs

HTTP ist ein textbasiertes Anfrage-Antwort-Protokoll. Eine Anfrage besteht aus Methode, Pfad, Version, Headern und optional einem Body:

```http
GET /login HTTP/1.1
Host: portal.example.local
User-Agent: Mozilla/5.0
Cookie: session=4f9a…
```

### Methoden

| Methode | Zweck |
|---|---|
| GET | Ressource abrufen |
| POST | Daten senden (Formulare, APIs) |
| PUT / PATCH | Ressource ersetzen / ändern |
| DELETE | Ressource löschen |
| HEAD | wie GET, nur Header |
| OPTIONS | erlaubte Methoden abfragen |

### Statuscodes

| Bereich | Bedeutung | Beispiele |
|---|---|---|
| 1xx | Information | 101 Switching Protocols |
| 2xx | Erfolg | 200 OK, 201 Created, 204 No Content |
| 3xx | Umleitung | 301 Moved Permanently, 302 Found |
| 4xx | Client-Fehler | 400, 401 Unauthorized, 403 Forbidden, 404 Not Found |
| 5xx | Server-Fehler | 500 Internal Server Error, 503 Service Unavailable |

> [!MERKE] 401 vs. 403
> **401** heißt „nicht angemeldet“ (wer bist du?), **403** heißt „angemeldet oder nicht – du darfst das nicht“.

HTTP ist zustandslos. Damit eine Webseite sich an dich erinnert, nutzt sie [[Cookie|Cookies]] und [[Session|Sessions]]. Wie man diese absichert, lernst du im Modul [[mod:f-09|Web-Grundlagen]].

## Quiz

? Welcher DNS-Record enthält den Mailserver einer Domain?
= MX

? Welcher DNS-Record löst eine IP-Adresse zu einem Namen auf?
= PTR

? Welcher DNS-Record ist ein Alias?
= CNAME

? Wie heißt die Übertragung einer kompletten DNS-Zone?
= Zonentransfer
= AXFR

?order Bringe den DHCP-Ablauf in die richtige Reihenfolge
> Discover
> Offer
> Request
> Acknowledge

? Welche Switch-Funktion schützt vor fremden DHCP-Servern?
= DHCP Snooping

? Auf welcher OSI-Schicht arbeitet ARP?
= 2
= Schicht 2

?tf ARP authentifiziert Antworten kryptografisch.
= falsch

? Welcher HTTP-Statuscode bedeutet „nicht angemeldet“?
= 401

? Welcher HTTP-Statuscode bedeutet „verboten“?
= 403

? Welche HTTP-Methode ruft nur die Header ab?
= HEAD

?tf HTTP ist ein zustandsloses Protokoll.
= wahr
