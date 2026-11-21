---
id: f-08
title: Kryptografie verständlich
paths: grundlagen, cjca, specialist
order: 8
difficulty: medium
icon: lock.shield
summary: Symmetrische und asymmetrische Verfahren, Hashfunktionen, Passwortspeicherung, digitale Signaturen, Zertifikate, PKI und TLS – mit dem Blick, wie Kryptografie in der Praxis scheitert.
---

## Die Schutzziele

Kryptografie dient den klassischen Schutzzielen der Informationssicherheit:

| Schutzziel | Frage | Kryptografisches Mittel |
|---|---|---|
| Vertraulichkeit | Kann nur der Berechtigte lesen? | Verschlüsselung |
| Integrität | Wurde etwas verändert? | Hash, MAC, Signatur |
| Authentizität | Stammt es wirklich vom Absender? | MAC, Signatur, Zertifikat |
| Nichtabstreitbarkeit | Kann der Absender es leugnen? | digitale Signatur |

> [!MERKE] Kerckhoffs' Prinzip
> Ein Verfahren muss sicher sein, auch wenn alles außer dem Schlüssel öffentlich bekannt ist. „Security by Obscurity“ – Sicherheit durch Geheimhaltung des Verfahrens – funktioniert nicht.

## Symmetrische Verschlüsselung

Sender und Empfänger nutzen **denselben Schlüssel**. Symmetrische Verfahren sind sehr schnell und werden für die eigentlichen Daten verwendet.

- **[[AES]]** (128/192/256 Bit) ist der Standard.
- **ChaCha20** ist eine schnelle Alternative, besonders auf Mobilgeräten.
- Veraltet und unsicher: DES, 3DES, RC4.

**Betriebsmodi** bestimmen, wie Blöcke verknüpft werden. Der Modus **ECB** verschlüsselt gleiche Blöcke gleich und verrät dadurch Muster – er sollte nicht verwendet werden. Moderne Systeme nutzen **authentifizierte Verschlüsselung** wie **AES-GCM** oder **ChaCha20-Poly1305**, die Vertraulichkeit und Integrität gleichzeitig sichern.

> [!WARNUNG] Das Schlüsselproblem
> Symmetrische Verfahren lösen nicht, wie zwei Parteien den gemeinsamen Schlüssel sicher austauschen. Dafür braucht man asymmetrische Verfahren oder einen Schlüsselaustausch wie [[Diffie-Hellman]].

## Asymmetrische Verschlüsselung

Jeder Teilnehmer hat ein **Schlüsselpaar**: einen öffentlichen Schlüssel (darf jeder kennen) und einen privaten Schlüssel (bleibt geheim).

- Mit dem **öffentlichen** Schlüssel verschlüsselt man Daten, die nur der Besitzer des **privaten** Schlüssels lesen kann.
- Mit dem **privaten** Schlüssel signiert man; jeder kann die Signatur mit dem **öffentlichen** Schlüssel prüfen.

Verfahren: **[[RSA]]** (Faktorisierungsproblem, heute mindestens 2048 Bit, besser 3072+), **elliptische Kurven** (ECDSA, Ed25519 – kürzere Schlüssel bei gleicher Sicherheit).

> [!INFO] Hybride Verfahren
> Asymmetrische Kryptografie ist langsam. In der Praxis wird sie nur genutzt, um einen symmetrischen Sitzungsschlüssel zu vereinbaren oder zu schützen. Die Daten selbst werden symmetrisch verschlüsselt. So arbeiten TLS, SSH, PGP und S/MIME.

## Hashfunktionen

Eine [[Hashfunktion]] bildet beliebige Daten auf einen Wert fester Länge ab. Gute Hashfunktionen sind:

- **Einweg** – aus dem Hash lässt sich die Eingabe nicht berechnen,
- **kollisionsresistent** – zwei verschiedene Eingaben mit gleichem Hash sind praktisch nicht zu finden,
- **lawinenartig** – ein geändertes Bit ändert etwa die Hälfte des Hashes.

| Verfahren | Länge | Status |
|---|---|---|
| MD5 | 128 Bit | gebrochen – nur noch als Prüfsumme für Fehler, nicht für Sicherheit |
| SHA-1 | 160 Bit | Kollisionen praktisch gezeigt – abgelöst |
| SHA-256 / SHA-512 | 256 / 512 Bit | aktueller Standard |
| SHA-3 | variabel | moderner Standard |

## Passwörter richtig speichern

Passwörter werden nicht verschlüsselt, sondern **gehasht** – aber nicht mit schnellen Hashfunktionen. Schnelle Hashes lassen sich mit Grafikkarten in Milliarden Versuchen pro Sekunde durchprobieren.

Richtig ist ein **langsames, gesalzenes Passwort-Hashverfahren**: [[bcrypt]], scrypt, **Argon2** (empfohlen) oder PBKDF2.

- Ein **[[Salt]]** ist ein zufälliger Wert pro Passwort. Er sorgt dafür, dass gleiche Passwörter unterschiedliche Hashes ergeben, und macht vorberechnete Tabellen ([[Rainbow Table|Rainbow Tables]]) nutzlos.
- Ein **Work Factor** macht jede Berechnung absichtlich teuer.

> [!GEFAHR] Typische Fehler
> Passwörter im Klartext, nur Base64-kodiert, mit MD5/SHA-1 ohne Salt oder umkehrbar verschlüsselt gespeichert – all das findet man in Prüfungen regelmäßig. Windows speichert lokale Passwörter als ungesalzene [[NTLM]]-Hashes, weshalb deren Schutz besonders wichtig ist.

## Message Authentication Codes

Ein **MAC** (z. B. **HMAC-SHA256**) ist ein Hash, in den ein geheimer Schlüssel einfließt. Nur wer den Schlüssel kennt, kann einen gültigen MAC erzeugen oder prüfen. So erkennt der Empfänger Manipulationen und weiß, dass die Nachricht von jemandem mit dem Schlüssel stammt. [[JWT|JSON Web Tokens]] mit `HS256` funktionieren so.

## Digitale Signaturen

1. Der Absender hasht das Dokument.
2. Er verschlüsselt (signiert) den Hash mit seinem **privaten** Schlüssel.
3. Der Empfänger prüft mit dem **öffentlichen** Schlüssel und vergleicht mit dem selbst berechneten Hash.

Stimmen beide überein, ist das Dokument unverändert und stammt vom Inhaber des privaten Schlüssels.

## Zertifikate und PKI

Woher weiß man, dass ein öffentlicher Schlüssel wirklich zu `bank.example` gehört? Ein **[[Zertifikat]]** (Standard X.509) bindet einen öffentlichen Schlüssel an eine Identität und ist von einer **Zertifizierungsstelle (CA)** signiert. Browser und Betriebssysteme vertrauen einer Liste von Root-CAs; daraus entsteht eine **Vertrauenskette** (Root-CA → Zwischen-CA → Server-Zertifikat). Das Gesamtsystem heißt [[PKI]].

Wichtige Felder: Subject, Subject Alternative Names (SAN), Aussteller, Gültigkeitszeitraum, Schlüsselverwendung. Widerrufene Zertifikate werden über **CRL** oder **OCSP** veröffentlicht.

> [!INFO] Eigene CA in der Range
> Auch deine Cyber Range betreibt eine eigene Zertifizierungsstelle – siehe [[mod:cr-05|Kapitel L2]].

## TLS in Kürze

[[TLS]] (Nachfolger von SSL) sichert HTTPS, moderne Mailprotokolle und vieles mehr. Beim Handshake einigen sich Client und Server auf Verfahren, der Server weist sich per Zertifikat aus, und per (Elliptic-Curve-)Diffie-Hellman wird ein Sitzungsschlüssel vereinbart. **TLS 1.3** ist aktuell, TLS 1.2 mit sicheren Cipher Suites noch akzeptabel, alles darunter sollte deaktiviert sein.

> [!MERKE] Forward Secrecy
> Bei (EC)DHE-Schlüsselaustausch wird für jede Sitzung ein neuer, flüchtiger Schlüssel erzeugt. Wird später der private Schlüssel des Servers gestohlen, lassen sich frühere, mitgeschnittene Sitzungen trotzdem nicht entschlüsseln.

## Quiz

? Welche Verschlüsselungsart nutzt denselben Schlüssel für Ver- und Entschlüsselung?
= symmetrisch
= symmetrische Verschlüsselung

? Mit welchem Schlüssel wird eine digitale Signatur erstellt?
+ dem privaten Schlüssel des Absenders
- dem öffentlichen Schlüssel des Absenders
- dem öffentlichen Schlüssel des Empfängers
- einem gemeinsamen symmetrischen Schlüssel

? Welcher AES-Betriebsmodus verrät Muster und sollte nicht genutzt werden?
= ECB

? Welche Verfahren eignen sich zum Speichern von Passwörtern?
+ Argon2
+ bcrypt
+ scrypt
- MD5
- SHA-256 ohne Salt
- Base64

? Wozu dient ein Salt?
+ Gleiche Passwörter ergeben unterschiedliche Hashes, vorberechnete Tabellen werden nutzlos
- Er verschlüsselt den Hash
- Er macht den Hash kürzer
- Er ersetzt das Passwort

?tf MD5 gilt heute als sicher für Signaturen.
= falsch

? Wie heißt die Eigenschaft, dass ein gestohlener Server-Schlüssel alte Sitzungen nicht entschlüsselbar macht?
= Forward Secrecy
= Perfect Forward Secrecy
= PFS

? Welcher Standard beschreibt das Format von Zertifikaten?
= X.509

? Welches Prinzip besagt, dass ein Verfahren auch sicher sein muss, wenn alles außer dem Schlüssel bekannt ist?
= Kerckhoffs
= Kerckhoffs' Prinzip
= Kerckhoffs Prinzip

? Welche TLS-Version ist aktuell?
= 1.3
= TLS 1.3

? Was ist ein HMAC?
+ Ein Hash mit geheimem Schlüssel, der Integrität und Authentizität sichert
- Ein asymmetrisches Verschlüsselungsverfahren
- Ein Zertifikatsformat
- Ein Passwort-Hashverfahren
