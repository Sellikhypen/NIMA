---
id: s-06
title: Sicherheitsarchitektur und Zero Trust
paths: specialist, cdsa
order: 6
difficulty: medium
icon: square.stack.3d.up
summary: Netzzonen, DMZ, Segmentierung, Identität als neuer Perimeter, Zero-Trust-Architektur, Threat Modeling mit STRIDE und sichere Administration.
---

## Vom Burggraben zum Zero Trust

Klassische Netze folgten dem **Burgmodell**: außen eine starke Firewall, innen vertraut jeder jedem. Seit Cloud, mobilem Arbeiten und Angriffen über Phishing funktioniert das nicht mehr – ein einziger kompromittierter Laptop steht „innen“.

## Netzzonen und DMZ

| Zone | Inhalt | Vertrauen |
|---|---|---|
| Internet | alles Unbekannte | keins |
| [[DMZ]] | öffentlich erreichbare Dienste (Web, Mail-Relay, VPN-Gateway) | gering |
| Server-Zone | interne Anwendungen, Datenbanken | mittel |
| Client-Zone | Arbeitsplätze | gering bis mittel |
| Management-Zone | Hypervisoren, Netzwerkgeräte, Admin-Jump-Hosts | höchster Schutz |
| OT / Produktion | Steuerungen | strikt getrennt |

Der Verkehr zwischen Zonen läuft über Firewalls mit **Default Deny**: Erlaubt ist nur, was explizit freigegeben ist. Deine Range setzt genau dieses Prinzip um – siehe die Zonenmatrix in [[mod:cr-05|Kapitel L2]].

> [!TIPP] Ausgehenden Verkehr nicht vergessen
> Viele Firewalls filtern nur eingehend. Strenge **Egress-Filterung** (Server dürfen nur zu definierten Zielen) erschwert Schadsoftware die Kommunikation mit ihren Kontrollservern und den Abfluss von Daten.

## Zero Trust

[[Zero Trust]] (NIST SP 800-207) beruht auf drei Ideen:

1. **Explizit prüfen** – jede Anfrage wird anhand von Identität, Gerätezustand, Ort und Risiko bewertet.
2. **Minimale Rechte** – Just-in-Time- und Just-enough-Access.
3. **Von einem Einbruch ausgehen** – Segmentierung, Verschlüsselung überall, Monitoring.

Bausteine: starke Identitäten mit [[MFA]], Gerätezustandsprüfung (Compliance), Mikrosegmentierung, Policy Engine und Policy Enforcement Points, kontinuierliches Logging.

## Identität als Perimeter

| Maßnahme | Wirkung |
|---|---|
| MFA (am besten phishing-resistent: FIDO2/Passkeys) | gestohlene Passwörter allein reichen nicht |
| Single Sign-On mit zentraler Richtlinie | einheitliche Kontrolle, schnelles Sperren |
| Privileged Access Management (PAM) | Admin-Rechte nur bei Bedarf, aufgezeichnet |
| Tiering-Modell | Admin-Konten nur auf ihrer Ebene (Tier 0 = DCs/Identität) |
| Privileged Access Workstations | Administration nur von gehärteten Geräten |

## Threat Modeling mit STRIDE

Beim **Threat Modeling** analysiert man ein System schon im Entwurf. Microsofts **STRIDE** liefert die Bedrohungskategorien:

| Buchstabe | Bedrohung | verletztes Schutzziel | Gegenmaßnahme |
|---|---|---|---|
| S | Spoofing (Identität vortäuschen) | Authentizität | Authentifizierung |
| T | Tampering (Manipulation) | Integrität | Signaturen, Zugriffskontrolle |
| R | Repudiation (Abstreiten) | Nichtabstreitbarkeit | Logging, Signaturen |
| I | Information Disclosure | Vertraulichkeit | Verschlüsselung, Rechte |
| D | Denial of Service | Verfügbarkeit | Redundanz, Rate Limits |
| E | Elevation of Privilege | Autorisierung | Least Privilege, Validierung |

Vorgehen: Datenflussdiagramm zeichnen → Vertrauensgrenzen markieren → je Element STRIDE durchgehen → Maßnahmen ableiten.

## Härtung

- Hersteller- und **CIS Benchmarks** als Basis
- unnötige Dienste und Software entfernen
- sichere Konfiguration als Code (reproduzierbar, prüfbar – wie in deiner Range mit Ansible)
- Patch- und Schwachstellenmanagement mit klaren Fristen nach Kritikalität
- Application Allowlisting auf kritischen Systemen

## Quiz

? Wie heißt die Zone für öffentlich erreichbare Dienste zwischen Internet und internem Netz?
= DMZ
= demilitarisierte Zone

? Welches Firewall-Grundprinzip erlaubt nur explizit freigegebenen Verkehr?
= Default Deny
= default deny

? Welcher NIST-Standard beschreibt Zero Trust Architecture?
= SP 800-207
= 800-207
= NIST SP 800-207

? Wofür steht das E in STRIDE?
= Elevation of Privilege

? Welches Schutzziel verletzt Tampering?
= Integrität

? Welche MFA-Verfahren gelten als phishing-resistent?
+ FIDO2 / Passkeys
- SMS-Codes
- E-Mail-Links
- Sicherheitsfragen

? Welches Tier enthält im Tiering-Modell Domain Controller und Identitätssysteme?
= Tier 0
= 0

?tf Egress-Filterung erschwert Schadsoftware die Kommunikation nach außen.
= wahr
