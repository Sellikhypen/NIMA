---
id: kr-01
title: Kryptografie 1 · Blockchiffren und Betriebsmodi
paths: grundlagen, specialist, cwee
order: 60
difficulty: hard
icon: square.grid.3x3.fill
tags: krypto
summary: Wie AES intern arbeitet, Block- und Stromchiffren, Padding, die Modi ECB, CBC, CTR und GCM, Initialisierungsvektoren und Nonces sowie typische Fehler.
---

## Block- und Stromchiffren

| Art | Arbeitsweise | Beispiele |
|---|---|---|
| Blockchiffre | verschlüsselt feste Blöcke (AES: 128 Bit) | AES, (veraltet: DES, 3DES) |
| Stromchiffre | erzeugt einen Schlüsselstrom, der mit den Daten verknüpft wird (XOR) | ChaCha20, (veraltet: RC4) |

**AES** arbeitet in Runden (10/12/14 für 128/192/256 Bit Schlüssel) mit den Schritten SubBytes, ShiftRows, MixColumns und AddRoundKey.

## Betriebsmodi

| Modus | Eigenschaften | Bewertung |
|---|---|---|
| ECB | jeder Block einzeln, gleiche Blöcke → gleiche Ausgabe | unsicher, verrät Muster |
| CBC | jeder Block wird vor der Verschlüsselung mit dem vorherigen verknüpft; braucht zufälligen IV und Padding | nur mit zusätzlicher Integritätssicherung |
| CTR | macht aus der Blockchiffre eine Stromchiffre; Nonce + Zähler | Nonce darf sich nie wiederholen |
| **GCM** | CTR + Authentifizierung (AEAD) | empfohlen |
| ChaCha20-Poly1305 | Stromchiffre + Authentifizierung (AEAD) | empfohlen |

> [!MERKE] AEAD
> **Authenticated Encryption with Associated Data** schützt Vertraulichkeit **und** Integrität. Ohne Integritätsschutz können Angreifer verschlüsselte Daten gezielt verändern oder über Fehlermeldungen Informationen gewinnen (Padding-Oracle-Angriffe bei CBC).

## IV und Nonce

| Begriff | Anforderung |
|---|---|
| IV (CBC) | zufällig und unvorhersagbar |
| Nonce (CTR, GCM) | darf mit demselben Schlüssel **nie** wiederverwendet werden |

Eine wiederverwendete Nonce bei GCM bricht Vertraulichkeit und Authentizität – einer der folgenreichsten Implementierungsfehler.

## Typische Fehler

- ECB verwenden
- statische oder vorhersagbare IVs
- Nonce-Wiederverwendung
- CBC ohne MAC
- Schlüssel aus Passwörtern ohne Ableitungsfunktion (PBKDF2, Argon2)
- eigene Kryptografie statt bewährter Bibliotheken (libsodium, Tink, Plattform-APIs)

## Quiz

? Wie groß ist ein AES-Block?
= 128 Bit
= 128

? Welcher Modus verrät Muster in den Daten?
= ECB

? Wofür steht AEAD?
= Authenticated Encryption with Associated Data

? Was darf bei GCM mit demselben Schlüssel nie passieren?
+ eine Nonce wiederverwenden
- den Schlüssel länger als 128 Bit wählen
- Daten über 1 KB verschlüsseln
- AES verwenden

? Welcher Angriff nutzt Fehlermeldungen bei CBC ohne Integritätsschutz?
= Padding Oracle
= Padding-Oracle

@@@ MODULE @@@
---
id: kr-02
title: Kryptografie 2 · Public-Key-Verfahren und elliptische Kurven
paths: grundlagen, specialist
order: 61
difficulty: hard
icon: key.horizontal.fill
tags: krypto
summary: RSA im Detail, Diffie-Hellman, elliptische Kurven (ECDH, ECDSA, Ed25519), Schlüssellängen und Sicherheitsniveaus, Signaturen in der Praxis.
---

## RSA

RSA beruht darauf, dass das Faktorisieren großer Zahlen schwer ist. Ein Schlüsselpaar besteht aus einem Modulus `n = p·q`, einem öffentlichen Exponenten (meist 65537) und einem privaten Exponenten.

| Einsatz | Verfahren |
|---|---|
| Verschlüsselung | RSA-OAEP (nicht das alte PKCS#1 v1.5 ohne Schutzmaßnahmen) |
| Signatur | RSA-PSS (oder PKCS#1 v1.5-Signaturen) |

## Diffie-Hellman und ECDH

Zwei Parteien vereinbaren über einen unsicheren Kanal einen gemeinsamen Schlüssel. Mit flüchtigen Schlüsseln (DHE/ECDHE) entsteht **Forward Secrecy**. DH allein authentifiziert nicht – das übernehmen Signaturen bzw. Zertifikate.

## Elliptische Kurven

Elliptische Kurven bieten dieselbe Sicherheit mit viel kürzeren Schlüsseln:

| Sicherheitsniveau | symmetrisch | RSA / DH | elliptische Kurve |
|---|---|---|---|
| 112 Bit | 3DES | 2048 | 224 |
| 128 Bit | AES-128 | 3072 | 256 (P-256, X25519, Ed25519) |
| 192 Bit | AES-192 | 7680 | 384 (P-384) |
| 256 Bit | AES-256 | 15360 | 521 (P-521) |

| Verfahren | Zweck |
|---|---|
| X25519 / ECDH | Schlüsselaustausch |
| Ed25519 | Signaturen (z. B. SSH-Schlüssel) |
| ECDSA (P-256) | Signaturen (Zertifikate) |

> [!WARNUNG] ECDSA und Zufall
> ECDSA braucht für jede Signatur eine einmalige Zufallszahl. Wird sie wiederverwendet oder ist sie vorhersagbar, lässt sich der private Schlüssel berechnen – das ist in der Praxis mehrfach passiert. Ed25519 vermeidet dieses Problem durch deterministische Erzeugung.

## Schlüssel erzeugen (Beispiele)

```bash
ssh-keygen -t ed25519 -C "admin@firma"
openssl genpkey -algorithm RSA -pkeyopt rsa_keygen_bits:3072 -out key.pem
openssl genpkey -algorithm ed25519 -out ed.pem
```

## Quiz

? Auf welchem mathematischen Problem beruht RSA?
= Faktorisierung
= Faktorisierung großer Zahlen

? Welches RSA-Verfahren wird für Verschlüsselung empfohlen?
= RSA-OAEP
= OAEP

? Welche RSA-Länge entspricht etwa 128 Bit Sicherheit?
= 3072

? Welches Verfahren wird für moderne SSH-Schlüssel empfohlen?
= Ed25519

? Was passiert, wenn bei ECDSA die Zufallszahl wiederverwendet wird?
+ Der private Schlüssel lässt sich berechnen
- Die Signatur wird länger
- Nichts
- Die Verschlüsselung wird stärker

@@@ MODULE @@@
---
id: kr-03
title: Kryptografie 3 · PKI betreiben
paths: specialist, cyberrange, cape
order: 62
difficulty: hard
icon: rosette
tags: krypto
summary: Aufbau einer Zertifizierungshierarchie, Offline-Root, Zertifikatslebenszyklus, Sperrung mit CRL und OCSP, ACME-Automatisierung, Certificate Transparency und HSMs.
---

## Hierarchie

| Ebene | Aufgabe | Schutz |
|---|---|---|
| Root-CA | Vertrauensanker, signiert nur Zwischen-CAs | **offline**, im Tresor, HSM |
| Zwischen-CA (Issuing CA) | stellt Endzertifikate aus | online, gehärtet, eigener Tier |
| Endzertifikate | Server, Clients, Benutzer, Code | kurze Laufzeit |

Fällt eine Zwischen-CA, kann die Root-CA sie sperren und eine neue ausstellen – die Root bleibt unberührt.

## Lebenszyklus

1. **Antrag** (CSR mit öffentlichem Schlüssel)
2. **Prüfung** der Identität bzw. Berechtigung (z. B. Domain-Validierung)
3. **Ausstellung**
4. **Verteilung** und Installation
5. **Überwachung** des Ablaufs
6. **Erneuerung** oder **Sperrung** bei Kompromittierung

> [!TIPP] Automatisieren
> Das **ACME**-Protokoll (Let's Encrypt, interne ACME-Server wie step-ca) automatisiert Ausstellung und Erneuerung. Kurze Laufzeiten (Tage bis wenige Monate) sind nur mit Automatisierung praktikabel – und reduzieren das Risiko kompromittierter Schlüssel.

## Sperrung

| Verfahren | Funktionsweise |
|---|---|
| CRL | Liste gesperrter Seriennummern, regelmäßig veröffentlicht |
| OCSP | Online-Abfrage des Status eines Zertifikats |
| OCSP Stapling | Server liefert die OCSP-Antwort gleich mit |

## Certificate Transparency

Öffentliche CAs müssen jedes Zertifikat in öffentlichen, manipulationssicheren Logs eintragen. Domain-Inhaber können so fehlerhaft ausgestellte Zertifikate für ihre Domains entdecken – und Angreifer nutzen die Logs zur Aufklärung (siehe [[mod:c-04|Web-Recon]]).

## HSM

Ein **Hardware Security Module** speichert private Schlüssel so, dass sie das Gerät nie verlassen. Signaturen werden im HSM erzeugt. Pflicht für Root-CAs und häufig für Code-Signing.

## Quiz

? Wie wird eine Root-CA idealerweise betrieben?
+ offline, mit HSM
- als Webserver
- auf jedem Client
- ohne Schutz

? Welches Protokoll automatisiert die Ausstellung von Zertifikaten?
= ACME

? Wie heißt die Online-Abfrage des Zertifikatsstatus?
= OCSP

? Wie heißt die Technik, bei der der Server die OCSP-Antwort mitliefert?
= OCSP Stapling

? Was ist ein HSM?
+ Hardware, die private Schlüssel speichert, ohne sie herauszugeben
- ein Hashverfahren
- ein Zertifikatsformat
- ein Webserver

@@@ MODULE @@@
---
id: kr-04
title: Kryptografie 4 · Post-Quanten-Kryptografie
paths: specialist, grundlagen
order: 63
difficulty: medium
icon: atom
tags: krypto
summary: Warum Quantencomputer heutige Public-Key-Verfahren bedrohen, „Store now, decrypt later“, die neuen NIST-Standards ML-KEM und ML-DSA, hybride Verfahren und Krypto-Agilität.
---

## Die Bedrohung

Ein ausreichend großer Quantencomputer könnte mit dem **Shor-Algorithmus** die mathematischen Probleme hinter RSA, Diffie-Hellman und elliptischen Kurven effizient lösen. Symmetrische Verfahren und Hashfunktionen sind weniger betroffen: Der **Grover-Algorithmus** halbiert effektiv die Schlüssellänge, weshalb AES-256 als ausreichend gilt.

| Verfahren | Auswirkung durch Quantencomputer |
|---|---|
| RSA, DH, ECDH, ECDSA | gebrochen (Shor) |
| AES-128 | Sicherheit sinkt deutlich (Grover) |
| AES-256, SHA-384/512 | weiterhin ausreichend |

## Store now, decrypt later

Angreifer können heute verschlüsselten Verkehr aufzeichnen und ihn entschlüsseln, sobald Quantencomputer verfügbar sind. Für Daten mit langer Vertraulichkeitsdauer (Gesundheit, Staatsgeheimnisse, Geschäftsgeheimnisse) ist die Bedrohung deshalb **schon heute** relevant.

## Neue Standards

Das NIST hat 2024 die ersten Post-Quanten-Standards veröffentlicht:

| Standard | Name | Zweck |
|---|---|---|
| FIPS 203 | ML-KEM (früher Kyber) | Schlüsselvereinbarung |
| FIPS 204 | ML-DSA (früher Dilithium) | Signaturen |
| FIPS 205 | SLH-DSA (SPHINCS+) | hashbasierte Signaturen |

## Hybride Verfahren

In der Übergangszeit werden klassische und Post-Quanten-Verfahren **kombiniert** (z. B. X25519 + ML-KEM in TLS). Die Verbindung bleibt sicher, solange mindestens eines der beiden Verfahren hält. Moderne Browser und Betriebssysteme unterstützen das bereits.

## Krypto-Agilität

Organisationen sollten wissen, wo welche Kryptografie eingesetzt wird (**Kryptoinventar**), und Systeme so bauen, dass Verfahren ohne Neuentwicklung ausgetauscht werden können. Das BSI empfiehlt, die Migration frühzeitig zu planen.

## Quiz

? Welcher Quantenalgorithmus bricht RSA und elliptische Kurven?
= Shor
= Shor-Algorithmus

? Welcher NIST-Standard beschreibt ML-KEM?
= FIPS 203

? Wie hieß ML-DSA früher?
= Dilithium

? Was bedeutet „Store now, decrypt later“?
+ Heute aufgezeichnete Daten werden später mit Quantencomputern entschlüsselt
- Daten werden nur lokal gespeichert
- Backups werden verschlüsselt
- Schlüssel werden später erzeugt

? Warum gilt AES-256 als quantenresistent genug?
+ Grover halbiert die effektive Schlüssellänge nur, 128 Bit bleiben übrig
- AES verwendet keine Mathematik
- Quantencomputer können AES nicht lesen
- AES-256 ist ein Post-Quanten-Verfahren nach FIPS 203

@@@ MODULE @@@
---
id: kr-05
title: Kryptografie 5 · Fehler in der Praxis
paths: specialist, cwee, cwes
order: 64
difficulty: medium
icon: exclamationmark.lock
tags: krypto
summary: Die häufigsten Krypto-Fehler aus Audits und Pentests – hartkodierte Schlüssel, schlechter Zufall, fehlende Prüfungen, Timing-Lecks, falsche Passwortspeicherung – und wie man sie findet.
---

## Die Top-Fehler

| Fehler | Beispiel | Lösung |
|---|---|---|
| hartkodierte Schlüssel | Schlüssel im App-Code oder Repository | Secret-Management, Schlüsselrotation |
| schlechter Zufall | `rand()`, `Math.random()` für Tokens | CSPRNG (`secrets`, `crypto.getRandomValues`) |
| fehlende Zertifikatsprüfung | `verify=False`, „alle Zertifikate akzeptieren“ | Standardprüfung beibehalten, ggf. Pinning |
| Timing-Lecks | `==` zum Vergleich von MACs oder Tokens | zeitkonstanter Vergleich (`hmac.compare_digest`) |
| Kodierung statt Verschlüsselung | Base64 „verschleiert“ Passwörter | echte Verschlüsselung bzw. Hashing |
| eigene Algorithmen | „selbst erfundene“ Verschlüsselung | Standardverfahren und -bibliotheken |
| falsche Passwortspeicherung | MD5/SHA-1, kein Salt | Argon2id/bcrypt |
| Schlüssel zu kurz/alt | RSA-1024, SHA-1-Signaturen | aktuelle Längen und Verfahren |
| JWT-Fehler | `alg: none`, schwacher HMAC-Schlüssel | siehe [[mod:x-02|OAuth/JWT]] |

## So findet man sie

- **Code-Review**: Suche nach Krypto-APIs, festen Strings mit Schlüssellänge, `verify=False`, `MD5`, `ECB`, `Random`
- **Secret-Scanning** in Repositories und Images
- **TLS-Prüfung** externer Dienste (testssl.sh)
- **Konfigurationsprüfung** von Servern (Cipher Suites, Protokolle)
- **Kryptoinventar** und Richtlinie (welche Verfahren sind erlaubt?)

> [!MERKE] Die goldene Regel
> Benutze bewährte, hochwertige Bibliotheken mit sicheren Standardeinstellungen und verstehe genau, welche Garantie sie bieten. Die meisten Krypto-Fehler entstehen nicht im Algorithmus, sondern in seiner Anwendung.

## Quiz

? Wie vergleicht man MACs oder Tokens sicher?
+ zeitkonstant, z. B. mit hmac.compare_digest
- mit ==
- per String-Länge
- gar nicht

? Welche Funktion ist für Tokens ungeeignet?
+ Math.random()
- crypto.getRandomValues()
- secrets.token_hex()
- os.urandom()

? Welches Werkzeug prüft die TLS-Konfiguration externer Dienste?
= testssl.sh
= testssl

? Wo entstehen die meisten Krypto-Fehler?
+ in der Anwendung der Verfahren
- im AES-Algorithmus selbst
- in der Hardware
- in Quantencomputern

?tf Base64 ist geeignet, um Passwörter in Konfigurationsdateien zu schützen.
= falsch
