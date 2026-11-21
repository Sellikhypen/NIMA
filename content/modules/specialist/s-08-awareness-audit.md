---
id: s-08
title: Security Awareness, Social Engineering und Audits
paths: specialist, cjca
order: 8
difficulty: easy
icon: person.3.sequence
summary: Warum Menschen Ziel Nummer eins sind, wie Social Engineering psychologisch funktioniert, wie wirksame Awareness aussieht und wie Audits und Kennzahlen Sicherheit messbar machen.
---

## Der Mensch im Mittelpunkt

Ein Großteil erfolgreicher Angriffe beginnt mit einer Täuschung: einer Phishing-Mail, einem Anruf eines „IT-Supports“, einem infizierten USB-Stick. Technik allein reicht nicht – Menschen müssen Angriffe erkennen und sicher reagieren können, **ohne** dass man ihnen die Schuld zuschiebt.

## Wie Social Engineering wirkt

Angreifer nutzen psychologische Prinzipien, die schnelles, unüberlegtes Handeln auslösen:

| Prinzip | Beispiel |
|---|---|
| Autorität | „Hier ist der Geschäftsführer, ich brauche sofort …“ |
| Dringlichkeit | „Ihr Konto wird in 30 Minuten gesperrt.“ |
| Angst | „Es wurde ein Verstoß festgestellt …“ |
| Neugier | „Gehaltsliste 2025.xlsx“ |
| Hilfsbereitschaft | „Können Sie mir kurz die Tür aufhalten?“ |
| Vertrauen / Sympathie | Bezug auf echte Kollegen und Projekte |
| Soziale Bewährtheit | „Alle Kollegen haben das schon erledigt.“ |

## Erscheinungsformen

| Form | Beschreibung |
|---|---|
| [[Phishing]] | massenhaft versandte Täuschungs-Mails |
| Spear Phishing | gezielt auf eine Person zugeschnitten |
| Whaling / CEO-Fraud | richtet sich an Führungskräfte bzw. gibt sich als solche aus |
| Vishing / Smishing | per Telefon bzw. SMS |
| Pretexting | erfundene Hintergrundgeschichte |
| Baiting | Köder wie USB-Sticks |
| Tailgating | Mitgehen durch gesicherte Türen |
| MFA-Fatigue | wiederholte MFA-Anfragen, bis jemand bestätigt |

## Wirksame Awareness

- kurz, regelmäßig, praxisnah statt jährlicher Pflichtfolien
- positive Fehlerkultur: Wer meldet, wird gelobt – auch nach einem Klick
- einfacher **Melde-Button** für verdächtige Mails
- realistische, abgestimmte Phishing-Simulationen mit sofortigem Lerneffekt
- zielgruppengerecht: Buchhaltung braucht CEO-Fraud-Training, Admins Training zu privilegierten Konten

## Technische Unterstützung

E-Mail-Authentifizierung mit **SPF**, **DKIM** und **DMARC**, Kennzeichnung externer Mails, Sandboxing von Anhängen, Makros aus dem Internet blockieren, phishing-resistente MFA, Prozessregeln (z. B. Zahlungsänderungen nur nach Rückruf über bekannte Nummer).

## Audits und Kennzahlen

| Art | Durchführung |
|---|---|
| internes Audit | durch eigene, unabhängige Auditoren |
| externes Audit | durch Zertifizierungsstelle oder Kunden |
| technische Prüfung | Schwachstellenscan, Pentest, Konfigurations-Review |

Ablauf eines Audits: Planung (Umfang, Kriterien) → Dokumentenprüfung → Interviews und Stichproben vor Ort → Feststellungen (Haupt-/Nebenabweichung, Hinweis) → Bericht → Maßnahmenverfolgung.

Beispiele für **Kennzahlen (KPIs)**: Patch-Quote kritischer Lücken innerhalb der Frist, MFA-Abdeckung, mittlere Zeit bis zur Erkennung (**MTTD**) und Behebung (**MTTR**), Melderate in Phishing-Simulationen, Anzahl offener Audit-Feststellungen.

## Quiz

? Welches Prinzip nutzt „Ihr Konto wird in 30 Minuten gesperrt“?
= Dringlichkeit
= Urgency

? Wie heißt Phishing, das gezielt eine Person adressiert?
= Spear Phishing
= Spear-Phishing

? Wie heißt Social Engineering per Telefon?
= Vishing

? Welche Verfahren authentifizieren E-Mail-Absenderdomänen?
+ SPF
+ DKIM
+ DMARC
- SNMP
- LDAP

? Was ist MFA-Fatigue?
+ wiederholte MFA-Anfragen, bis ein Benutzer genervt bestätigt
- ein abgelaufenes MFA-Token
- MFA per SMS
- ein Hardware-Token mit leerer Batterie

? Wofür steht MTTD?
= Mean Time to Detect
= Mean Time To Detect

?tf Mitarbeitende, die auf eine Phishing-Simulation klicken, sollten öffentlich bloßgestellt werden.
= falsch
