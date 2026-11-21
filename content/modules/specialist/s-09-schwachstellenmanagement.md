---
id: s-09
title: Schwachstellen- und Patch-Management
paths: specialist, cdsa, cjca
order: 9
difficulty: medium
icon: bandage
summary: Vom Inventar bis zur Behebung – Scannen, Bewerten mit CVSS, EPSS und KEV, Priorisieren nach Kontext, Fristen, Ausnahmen und Kennzahlen.
---

## Der Kreislauf

1. **Inventar** – alle Systeme, Software, Versionen, Eigentümer (ohne Inventar kein Management)
2. **Erkennen** – Schwachstellenscanner, Herstellerhinweise, CERT-Warnungen, SCA für Software
3. **Bewerten** – Schweregrad und Kontext
4. **Priorisieren** – was zuerst?
5. **Beheben** – Patch, Konfigurationsänderung, Workaround
6. **Verifizieren** – erneut scannen
7. **Berichten** – Kennzahlen, Ausnahmen

## Werkzeuge

| Typ | Beispiele |
|---|---|
| Netzwerk-Schwachstellenscanner | Greenbone/OpenVAS, Tenable Nessus, Qualys, Rapid7 |
| Agentenbasiert | EDR-/Defender-Schwachstellenmodule, Wazuh |
| Anwendungen | DAST-Scanner, SCA, Container-Scanner |
| Cloud | CSPM (Cloud Security Posture Management) |

> [!TIPP] Authentifizierte Scans
> Scans mit Anmeldedaten (credentialed) sehen installierte Software und Patchstände direkt und liefern wesentlich genauere Ergebnisse als reine Netzwerk-Scans.

## Bewerten: mehr als CVSS

| Quelle | Aussage |
|---|---|
| **CVSS** | technischer Schweregrad (0–10) |
| **EPSS** | Wahrscheinlichkeit, dass die Lücke in den nächsten 30 Tagen ausgenutzt wird |
| **CISA KEV** | Liste aktiv ausgenutzter Schwachstellen |
| Herstellerbewertung | z. B. „Critical“ bei Microsoft-Patchday |
| eigener Kontext | Ist das System aus dem Internet erreichbar? Welche Daten? Gibt es schützende Maßnahmen? |

> [!MERKE] Priorisierung
> Ein „High“ auf einem internetfähigen Webserver mit bekanntem Exploit ist dringender als ein „Critical“ auf einem isolierten Testsystem. Risikobasiert priorisieren heißt: Schweregrad × Ausnutzbarkeit × Exposition × Wert des Systems.

## Fristen (Beispiel)

| Kategorie | Frist |
|---|---|
| aktiv ausgenutzt (KEV), internetfähig | 24–72 Stunden |
| kritisch | 7 Tage |
| hoch | 30 Tage |
| mittel | 90 Tage |
| niedrig | im regulären Wartungszyklus |

## Wenn Patchen nicht geht

- **Workaround** des Herstellers (Funktion deaktivieren, Konfiguration ändern)
- **Kompensierende Maßnahmen**: Segmentierung, WAF/IPS-Regel, Zugriff einschränken, verstärktes Monitoring
- **Ausnahme** dokumentieren: Begründung, Risikoeigentümer, Ablaufdatum

## Kennzahlen

- Anteil kritischer Schwachstellen, die innerhalb der Frist behoben wurden
- mittlere Zeit bis zur Behebung (MTTR) pro Kategorie
- Scan-Abdeckung (Anteil inventarisierter Systeme, die regelmäßig gescannt werden)
- Anzahl und Alter offener Ausnahmen

## Quiz

?order Bringe den Schwachstellenmanagement-Kreislauf in Reihenfolge
> Inventar
> Erkennen
> Bewerten
> Priorisieren
> Beheben
> Verifizieren

? Was gibt EPSS an?
+ die Wahrscheinlichkeit, dass eine Lücke bald ausgenutzt wird
- den technischen Schweregrad
- die Anzahl betroffener Systeme
- den Patch-Termin

? Was ist die CISA-KEV-Liste?
+ eine Liste aktiv ausgenutzter Schwachstellen
- eine Liste von Antivirenprogrammen
- ein Scanner
- eine Firewall-Regel

? Warum sind authentifizierte Scans genauer?
+ Sie sehen installierte Software und Patchstände direkt
- Sie sind schneller
- Sie brauchen kein Netzwerk
- Sie schalten Firewalls ab

? Was gehört zu einer dokumentierten Ausnahme?
+ Begründung, Risikoeigentümer und Ablaufdatum
- nur der Name des Admins
- nichts, Ausnahmen sind informell
- ein neues Passwort

?tf Ein Critical auf einem isolierten Testsystem ist immer dringender als ein High auf einem internetfähigen Server mit bekanntem Exploit.
= falsch
