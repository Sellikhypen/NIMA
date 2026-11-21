---
id: c-16
title: Fallstudie – Pentest eines Unternehmensnetzes
paths: cpts, cape
order: 11
difficulty: hard
icon: building.2.crop.circle
summary: Ein vollständiger, fiktiver Pentest der „Nordlicht GmbH“ als Erzählung – von Scope und Recon über interne Befunde bis zur Attack Chain und den Empfehlungen im Bericht. So denkt man im CPTS-Exam.
htb: Attacking Enterprise Networks
---

## Ausgangslage

Die fiktive **Nordlicht GmbH** (250 Mitarbeitende) beauftragt einen Grey-Box-Pentest: externe Angriffsfläche plus internes Netz, Ziel ist die Bewertung, ob ein Angreifer bis zur Kontrolle der Domäne gelangen könnte. Scope: eine öffentliche IP-Range, die Domain `nordlicht.example`, ein internes /16 nach Zugang. Ausschlüsse: Produktionssteuerung (OT), Denial-of-Service, Social Engineering. Diese Struktur entspricht auch dem Szenario „Operation Nordlicht“ deiner [[mod:cr-20|Cyber Range]].

> [!INFO] Diese Fallstudie zeigt Denkweise und Struktur
> Sie beschreibt, **welche Art** von Befunden typischerweise gefunden wird und wie sie im Bericht zusammenhängen – nicht die technischen Einzelschritte.

## Phase 1 – Externe Aufklärung

- Certificate-Transparency-Logs zeigen `vpn.`, `mail.`, `portal.` und `dev-portal.nordlicht.example`.
- `dev-portal` ist eine Testinstanz des Kundenportals mit älterer Softwareversion und aktivem Debug-Modus.
- Der Mailserver erlaubt Benutzer-Enumeration; aus der Website und Berufsnetzwerken ergibt sich das Namensschema `vorname.nachname`.

**Befunde:** Testumgebung öffentlich erreichbar (hoch), Informationspreisgabe durch Debug-Modus (mittel), Benutzer-Enumeration (niedrig).

## Phase 2 – Erster Zugang

Die Testinstanz enthält eine bekannte, öffentlich dokumentierte Schwachstelle der veralteten Version. Der Nachweis zeigt Zugriff auf den Server mit den Rechten des Webdienstes. In einer Konfigurationsdatei liegen Zugangsdaten für eine Datenbank – und dasselbe Passwort wird von einem Dienstkonto in der Domäne genutzt.

**Befunde:** Veraltete Software mit bekannter kritischer Schwachstelle (kritisch), Klartext-Zugangsdaten in Konfigurationsdateien (hoch), Passwort-Wiederverwendung (hoch).

## Phase 3 – Internes Netz

Der Testserver steht in einem Netz, das ohne Filterung mit dem Client- und Servernetz verbunden ist. Mit dem Dienstkonto lässt sich das Active Directory lesen. Die Analyse der Beziehungen zeigt:

- Das Dienstkonto ist Mitglied einer Gruppe mit lokalen Admin-Rechten auf mehreren Servern.
- Auf einem dieser Server ist regelmäßig ein Domänenadministrator angemeldet (Wartungsaufgabe).
- Mehrere Dienstkonten mit SPN haben Passwörter, die seit Jahren nicht geändert wurden.
- SMB-Signierung ist auf den meisten Servern nicht erzwungen.

**Befunde:** fehlende Segmentierung zwischen DMZ-Testsystem und internem Netz (kritisch), zu weite lokale Admin-Rechte (hoch), Admin-Anmeldungen auf Tier-1-Systemen (hoch), schwache Dienstkonten-Passwörter (hoch), SMB-Signing nicht erzwungen (mittel).

## Phase 4 – Auswirkung

Durch die Kombination der Befunde wäre ein Angreifer in der Lage gewesen, Anmeldedaten eines Domänenadministrators zu erlangen und damit die gesamte Domäne zu kontrollieren. Im Auftrag wurde dies nur so weit nachgewiesen, wie es die Rules of Engagement erlaubten – mit Rücksprache vor dem letzten Schritt.

## Die Attack Chain im Bericht

1. öffentlich erreichbare, veraltete Testinstanz →
2. Zugriff auf Server und Konfigurationsdateien →
3. wiederverwendetes Passwort eines Dienstkontos →
4. fehlende Segmentierung erlaubt Zugriff ins interne Netz →
5. zu weite lokale Admin-Rechte + Admin-Anmeldung auf Tier-1-Server →
6. Kontrolle über die Domäne

> [!MERKE] Die Kette ist wichtiger als jeder Einzelbefund
> Kein einzelner Fehler war „katastrophal“. Erst ihre Kombination führte zur Domänenkompromittierung. Genau das macht die Attack-Chain-Darstellung für das Management so verständlich – und zeigt, dass schon das Brechen **eines** Glieds den Weg blockiert hätte.

## Empfehlungen (priorisiert)

| Priorität | Maßnahme |
|---|---|
| sofort | Testinstanz vom Internet trennen und aktualisieren; betroffene Passwörter ändern; Konfigurationsdateien bereinigen |
| kurzfristig | Segmentierung DMZ ↔ intern; gMSA für Dienstkonten; LAPS; SMB-Signing erzwingen |
| mittelfristig | Tiering-Modell mit getrennten Admin-Konten und PAWs; Inventar aller öffentlichen Systeme; Secret-Management |
| dauerhaft | regelmäßige AD-Bewertung (PingCastle), Schwachstellenmanagement mit Fristen, Monitoring von Admin-Anmeldungen |

## Quiz

?order Bringe die Glieder der Attack Chain in Reihenfolge
> veraltete, öffentliche Testinstanz
> Zugriff auf Server und Konfigurationsdateien
> wiederverwendetes Dienstkonto-Passwort
> fehlende Segmentierung ins interne Netz
> Admin-Anmeldung auf Tier-1-Server
> Kontrolle über die Domäne

? Welche Quelle zeigte die vergessene Subdomain dev-portal?
+ Certificate-Transparency-Logs
- der Router des Kunden
- die Firewall-Logs
- das Telefonbuch

? Welche Maßnahme hätte die Passwort-Wiederverwendung bei Dienstkonten verhindert?
= gMSA

? Welche Maßnahme verhindert Admin-Anmeldungen auf weniger geschützten Servern?
= Tiering-Modell
= Tiering

? Was ist die zentrale Erkenntnis einer Attack Chain?
+ Schon das Brechen eines Glieds hätte den Weg blockiert
- Nur der letzte Befund ist wichtig
- Einzelbefunde sind egal
- Der Pentester war besonders schnell

?tf Social Engineering war in dieser Fallstudie im Scope.
= falsch
