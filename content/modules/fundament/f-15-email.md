---
id: f-15
title: E-Mail verstehen und absichern
paths: grundlagen, cdsa, specialist
order: 15
difficulty: medium
icon: envelope.badge.shield.half.filled
summary: Der Weg einer E-Mail, Header lesen, SPF, DKIM und DMARC im Detail, Transportverschlüsselung, S/MIME und PGP sowie die wichtigsten Schutzmaßnahmen gegen Spoofing und Phishing.
---

## Der Weg einer E-Mail

| Komponente | Aufgabe |
|---|---|
| MUA (Mail User Agent) | Mailprogramm: Outlook, Thunderbird, Apple Mail |
| MSA (Submission Agent) | nimmt Mails des Benutzers an (Port 587 bzw. 465 mit TLS) |
| MTA (Transfer Agent) | leitet Mails zwischen Servern weiter (Port 25, [[SMTP]]) |
| MDA (Delivery Agent) | legt die Mail im Postfach ab |
| IMAP / POP3 | Abruf durch den Client (993 / 995 mit TLS) |

Der sendende MTA fragt per DNS den **MX-Record** der Empfängerdomain ab und übergibt die Mail.

## Header lesen

Jeder Server fügt oben eine `Received:`-Zeile hinzu. Von **unten nach oben** gelesen zeigen sie den Weg der Mail.

| Header | Aussage |
|---|---|
| `From:` | angezeigter Absender – frei wählbar, nicht vertrauenswürdig |
| `Return-Path:` | Envelope-Absender (MAIL FROM) |
| `Reply-To:` | Ziel für Antworten – bei Betrug oft abweichend |
| `Received:` | Stationen mit Zeitstempeln und IPs |
| `Authentication-Results:` | Ergebnisse von SPF, DKIM, DMARC |
| `Message-ID:` | eindeutige Kennung |

> [!MERKE] Envelope vs. Header
> SMTP unterscheidet den **Umschlag** (`MAIL FROM`, `RCPT TO`) vom **Inhalt** mit den sichtbaren Headern. Beides kann unterschiedlich sein – deshalb braucht es Authentifizierungsverfahren.

## SPF, DKIM und DMARC

| Verfahren | prüft | Mechanismus |
|---|---|---|
| **SPF** | Darf dieser Server für die Envelope-Domain senden? | TXT-Record mit erlaubten IPs, z. B. `v=spf1 include:_spf.example.net -all` |
| **DKIM** | Ist die Mail unverändert und von der Domain signiert? | Signatur im Header, öffentlicher Schlüssel im DNS unter `selector._domainkey` |
| **DMARC** | Passt die sichtbare `From`-Domain zu SPF oder DKIM (Alignment)? Was tun bei Fehlschlag? | `_dmarc`-TXT-Record mit `p=none/quarantine/reject` und Berichtsadressen |

> [!TIPP] DMARC schrittweise einführen
> Mit `p=none` beginnen und Berichte auswerten, alle legitimen Absender (Newsletter-Dienste, CRM, Ticketsystem) in SPF/DKIM aufnehmen, dann auf `quarantine` und schließlich `reject` umstellen.

## Verschlüsselung

| Ebene | Verfahren | schützt |
|---|---|---|
| Transport | STARTTLS, MTA-STS, DANE | Verbindung zwischen Servern bzw. Client und Server |
| Ende-zu-Ende | S/MIME (Zertifikate), OpenPGP (Schlüsselpaare, Web of Trust) | Inhalt bis zum Empfänger |

STARTTLS allein kann durch Herabstufung umgangen werden; **MTA-STS** und **DANE** erzwingen verschlüsselte Übertragung.

## Schutz vor Spoofing und Phishing

- SPF, DKIM, DMARC mit `reject` für die eigene Domain
- Kennzeichnung externer Mails im Betreff oder Banner
- Sandboxing von Anhängen, Blockieren gefährlicher Dateitypen
- Erkennung von ähnlich aussehenden Domains (Typosquatting)
- Melde-Button und schnelle Analyse gemeldeter Mails ([[mod:d-09|Phishing-Analyse]])

## Quiz

? In welcher Richtung liest man Received-Header, um den Weg einer Mail zu verfolgen?
+ von unten nach oben
- von oben nach unten
- nur den obersten
- die Reihenfolge ist egal

? Welcher DNS-Record bestimmt den Mailserver einer Domain?
= MX

? Was prüft DMARC zusätzlich zu SPF und DKIM?
+ ob die sichtbare From-Domain zu SPF oder DKIM passt (Alignment)
- ob der Anhang einen Virus enthält
- ob der Empfänger existiert
- ob die Mail verschlüsselt ist

? Wo liegt der öffentliche DKIM-Schlüssel?
+ im DNS unter selector._domainkey
- im Mail-Body
- im MX-Record
- im SPF-Record

? Welche DMARC-Richtlinie weist Mails bei Fehlschlag ab?
= reject
= p=reject

? Welche Verfahren erzwingen verschlüsselte Übertragung zwischen Mailservern?
+ MTA-STS
+ DANE
- SPF
- POP3

?tf Der From-Header einer E-Mail ist vertrauenswürdig.
= falsch

? Welcher Port wird für die Einlieferung von Mails durch Clients (Submission) verwendet?
= 587
