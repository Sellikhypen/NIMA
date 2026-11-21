---
id: d-09
title: Phishing-Analyse und E-Mail-Forensik
paths: cdsa, cjca
order: 9
difficulty: medium
icon: envelope.open.badge.clock
summary: Gemeldete Mails strukturiert untersuchen – Header, Authentifizierungsergebnisse, Links, Anhänge, Indikatoren extrahieren, Umfang ermitteln und Gegenmaßnahmen einleiten.
---

## Der Ablauf einer Phishing-Untersuchung

1. **Mail sichern** – als `.eml`/`.msg` mit allen Headern, nicht nur als Screenshot
2. **Header analysieren** – Absenderinfrastruktur, SPF/DKIM/DMARC
3. **Inhalt bewerten** – Sprache, Druckmittel, Abweichungen von echten Mails
4. **Links und Anhänge** in sicherer Umgebung untersuchen
5. **Indikatoren** extrahieren (Absender, Domains, URLs, IPs, Hashes, Betreff)
6. **Umfang** bestimmen – wer hat die Mail noch erhalten, geklickt, Daten eingegeben?
7. **Reagieren** – Mails entfernen, Domains blockieren, betroffene Konten absichern
8. **Dokumentieren** und Rückmeldung an die meldende Person

## Header-Analyse

| Prüfpunkt | Warnsignal |
|---|---|
| `From` vs. `Return-Path` vs. `Reply-To` | unterschiedliche Domains |
| `Authentication-Results` | `spf=fail`, `dkim=none`, `dmarc=fail` |
| erste externe `Received`-Zeile | unerwartetes Land, Hosting-Anbieter, private Mailserver |
| Absenderdomain | kürzlich registriert, Tippfehler-Domain (`nordllcht.example`) |
| `Message-ID` | Domain passt nicht zum angeblichen Absender |

Werkzeuge: Header-Analyzer der Mailplattform, Online-Analyzer (nur für unkritische Daten), MXToolbox, eigene Skripte.

## Links untersuchen

- Linkziel ansehen, **nicht** anklicken – angezeigter Text und echtes Ziel unterscheiden sich oft
- URL-Kürzer und Weiterleitungsketten auflösen (in isolierter Umgebung)
- Reputation prüfen (Threat-Intelligence-Dienste, Sandbox-Dienste)
- gefälschte Anmeldeseiten erkennen: falsche Domain, frisches Zertifikat, Formular sendet an fremde Adresse

> [!WARNUNG] Vertraulichkeit beachten
> Was in öffentliche Scan-Dienste hochgeladen wird, ist oft für andere sichtbar. Interne Dokumente oder personalisierte Links (mit Token des Empfängers) gehören nicht in öffentliche Sandboxen.

## Anhänge untersuchen

| Typ | Risiko | Analyse |
|---|---|---|
| Office mit Makros | Makros laden Schadcode nach | `olevba`, `oledump` (statisch) |
| PDF | eingebettete Links/Skripte | `pdfid`, `pdf-parser` |
| ZIP/ISO/IMG | umgehen Schutzmechanismen, enthalten Verknüpfungen oder Skripte | Inhalt auflisten, nicht öffnen |
| LNK, HTA, JS, VBS | direkte Ausführung | statisch untersuchen |
| HTML-Anhang | lokale Phishing-Seite | Quelltext lesen |

Grundregeln der sicheren Analyse stehen in [[mod:d-06|Malware-Analyse]].

## Umfang und Reaktion

- Suche im Mail-Gateway bzw. Microsoft 365/Google Workspace nach gleicher Absenderdomain, Betreff, Link oder Anhang-Hash
- Proxy- und DNS-Logs: Wer hat die Phishing-Domain aufgerufen?
- Anmeldelogs: Gab es danach Anmeldungen von ungewöhnlichen Orten? Neue Weiterleitungsregeln im Postfach? Neue MFA-Methoden?
- Maßnahmen: Mails aus allen Postfächern entfernen, Domain/URL blockieren, Passwörter zurücksetzen, Sitzungen und Tokens widerrufen, MFA-Registrierungen prüfen

> [!TIPP] Postfachregeln prüfen
> Nach erfolgreichem Phishing legen Angreifer oft Regeln an, die Mails verstecken oder weiterleiten (z. B. alles mit „Rechnung“ in einen versteckten Ordner). Das ist ein klassischer Hinweis auf Business-E-Mail-Compromise.

## Quiz

? In welchem Format sichert man eine verdächtige Mail?
+ als .eml/.msg mit allen Headern
- als Screenshot
- als ausgedruckte Seite
- gar nicht

? Welches Header-Feld enthält die Ergebnisse von SPF, DKIM und DMARC?
= Authentication-Results

? Welches Werkzeug analysiert Makros in Office-Dokumenten statisch?
= olevba
= oledump

? Welche Anzeichen deuten nach erfolgreichem Phishing auf eine Kontoübernahme hin?
+ neue Weiterleitungsregeln im Postfach
+ neue MFA-Methoden
- ein voller Papierkorb
- eine neue Signatur des Mitarbeiters

? Warum sollte man personalisierte Links nicht in öffentliche Sandboxen laden?
+ Sie können Token des Empfängers enthalten und für andere sichtbar werden
- Sandboxen sind immer offline
- Links sind dort nicht erlaubt
- Es spielt keine Rolle

? Wie heißt Betrug über kompromittierte geschäftliche Postfächer?
= Business E-Mail Compromise
= BEC
