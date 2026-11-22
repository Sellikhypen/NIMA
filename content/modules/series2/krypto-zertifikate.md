---
id: kx-01
title: Krypto-Praxis 1 · Hashfunktionen im Detail
paths: grundlagen, specialist, cwee
order: 60.1
difficulty: medium
icon: number.square.fill
tags: kryptografie, hash
summary: Eigenschaften kryptografischer Hashfunktionen, warum MD5 und SHA-1 gebrochen sind, Längenerweiterung, HMAC und wann man welchen Hash nimmt.
---

## Einfach erklärt

Ein Hash ist ein **digitaler Fingerabdruck**: Aus beliebig vielen Daten entsteht ein kurzer, fester Wert. Ändert sich nur ein einziges Bit, sieht der Fingerabdruck völlig anders aus. Und aus dem Fingerabdruck kann man die Daten nicht zurückrechnen.

## Drei Sicherheitseigenschaften

| Eigenschaft | Bedeutung |
|---|---|
| Urbildresistenz | aus dem Hash lassen sich die Daten nicht berechnen |
| Zweite Urbildresistenz | zu gegebenen Daten findet man keine anderen mit gleichem Hash |
| Kollisionsresistenz | man findet überhaupt keine zwei Eingaben mit gleichem Hash |

## Algorithmen

| Algorithmus | Länge | Status |
|---|---|---|
| MD5 | 128 Bit | gebrochen (Kollisionen trivial) |
| SHA-1 | 160 Bit | gebrochen (praktische Kollisionen seit 2017) |
| SHA-256 / SHA-512 | 256/512 Bit | sicher |
| SHA-3 | variabel | sicher, andere Bauweise (Sponge) |
| BLAKE2/BLAKE3 | variabel | sicher, sehr schnell |

> [!WARNUNG] Schnelle Hashes nicht für Passwörter
> SHA-256 ist für Integrität hervorragend, für Passwörter aber zu schnell – Angreifer testen Milliarden Kandidaten pro Sekunde. Für Passwörter gibt es spezielle, langsame Verfahren.

## Tiefer eingetaucht

**Length-Extension-Angriff**: Bei Merkle-Damgård-Hashes (MD5, SHA-1, SHA-256) kann man aus `H(geheim || nachricht)` ohne Kenntnis des Geheimnisses `H(geheim || nachricht || zusatz)` berechnen. Deshalb nie selbst gebaute „Hash mit Geheimnis“-Konstruktionen als MAC verwenden, sondern **HMAC** (`HMAC-SHA256`), das genau dagegen konstruiert ist.

Einsatzgebiete: Dateiintegrität (SHA-256-Prüfsummen), digitale Signaturen (es wird der Hash signiert), Commit-IDs in Git, Deduplizierung, Erkennung bekannter Malware. Hashes allein beweisen nur Unverändertheit gegenüber einem bekannten Wert – nicht die Herkunft. Dafür braucht es HMAC oder Signaturen.

## Quiz

? Welche Eigenschaft besagt, dass man keine zwei Eingaben mit gleichem Hash findet?
= Kollisionsresistenz
! MD5 und SHA-1 erfüllen sie nicht mehr.

? Welche Hashfunktionen gelten als gebrochen?
+ MD5
+ SHA-1
- SHA-256
- SHA-3
! Für Kollisionsresistenz-kritische Zwecke nicht mehr verwenden.

? Welche Konstruktion sollte man für einen Nachrichtenauthentifizierungscode verwenden?
= HMAC
! Sie ist gegen Length-Extension-Angriffe geschützt.

?tf SHA-256 eignet sich gut für das Speichern von Passwörtern.
= falsch
! Zu schnell – Passwörter brauchen langsame, gesalzene Verfahren.

? Welcher Angriff betrifft Konstruktionen wie H(geheim || nachricht)?
= Length-Extension
= Length Extension
= Längenerweiterung
! Deshalb HMAC verwenden.

? Was beweist ein Hash allein nicht?
+ die Herkunft der Daten
- dass sich die Daten nicht verändert haben im Vergleich zu einem bekannten Hash
- die Länge des Hashwerts
- dass ein Hash berechnet wurde
! Für Herkunft braucht es HMAC oder Signaturen.

@@@ MODULE @@@
---
id: kx-02
title: Krypto-Praxis 2 · Passwort-Hashing mit bcrypt, scrypt und Argon2
paths: grundlagen, cwes, cwee, specialist
order: 60.2
difficulty: medium
icon: lock.rotation
tags: kryptografie, passwörter
summary: Warum Passwort-Hashes langsam und gesalzen sein müssen, wie Argon2id, bcrypt und scrypt funktionieren und wie man Parameter wählt und migriert.
---

## Einfach erklärt

Wird eine Passwortdatenbank gestohlen, beginnt ein Wettrennen: Angreifer raten Passwörter und vergleichen die Hashes. Je **langsamer** jeder einzelne Versuch ist, desto länger dauert das Raten. Passwort-Hashing macht jeden Versuch absichtlich teuer – für den Server einmal beim Login kaum spürbar, für den Angreifer milliardenfach.

## Die Zutaten

| Zutat | Zweck |
|---|---|
| **Salt** | zufälliger Wert pro Passwort – gleiche Passwörter ergeben verschiedene Hashes, Rainbow Tables werden nutzlos |
| **Arbeitsfaktor** | einstellbare Langsamkeit (Iterationen, Kostenfaktor) |
| **Speicherhärte** | viel RAM pro Versuch – macht GPU/ASIC-Angriffe teuer |
| optional **Pepper** | geheimer Zusatzwert außerhalb der Datenbank |

## Verfahren

| Verfahren | Eigenschaft | Empfehlung |
|---|---|---|
| Argon2id | speicherhart, Gewinner der Password Hashing Competition | erste Wahl |
| scrypt | speicherhart | gut |
| bcrypt | bewährt, Kostenfaktor, 72-Byte-Grenze | gut, wenn Argon2 nicht verfügbar |
| PBKDF2 | iterationsbasiert, nicht speicherhart | nur mit sehr vielen Iterationen (z. B. für FIPS) |
| MD5/SHA-x direkt | zu schnell | nie |

```python
from argon2 import PasswordHasher
ph = PasswordHasher(time_cost=3, memory_cost=64 * 1024, parallelism=2)
h = ph.hash("Kaffee-Fahrrad-Wolke-Tisch")
ph.verify(h, "Kaffee-Fahrrad-Wolke-Tisch")
```

> [!TIPP] Parameter regelmäßig anpassen
> Hardware wird schneller. Parameter so wählen, dass ein Login z. B. 0,2–0,5 s dauert, und beim nächsten erfolgreichen Login alte Hashes mit neuen Parametern ersetzen (Rehash).

## Tiefer eingetaucht

**Migration** von alten, schnellen Hashes: entweder beim nächsten Login neu hashen, oder sofort „umhüllen“ (`Argon2(md5_alt)`) und beim Login auf das direkte Verfahren umstellen. Vergleiche von Hashes und Tokens **zeitkonstant** durchführen (sonst Timing-Seitenkanal) – Bibliotheksfunktionen tun das bereits.

Das Format moderner Hash-Strings enthält Algorithmus, Parameter und Salt (z. B. `$argon2id$v=19$m=65536,t=3,p=2$…`) – so lässt sich auch Jahre später verifizieren und migrieren.

## Quiz

? Welches Passwort-Hashverfahren ist heute erste Wahl?
= Argon2id
= Argon2
! Speicherhart und Gewinner der Password Hashing Competition.

? Wozu dient ein Salt?
+ gleiche Passwörter ergeben unterschiedliche Hashes, Rainbow Tables werden nutzlos
- es macht Passwörter kürzer
- es verschlüsselt die Datenbank
- es ersetzt MFA
! Jedes Passwort bekommt einen eigenen Zufallswert.

? Was bedeutet Speicherhärte?
+ jeder Versuch braucht viel Arbeitsspeicher, was GPU-Angriffe verteuert
- der Hash wird auf der Festplatte gespeichert
- das Passwort wird im RAM verschlüsselt
- der Server braucht weniger Speicher
! GPUs haben pro Kern wenig Speicher.

?tf bcrypt verarbeitet Passwörter nur bis zu einer Länge von 72 Byte.
= wahr
! Längere Passwörter werden abgeschnitten.

? Was ist ein Pepper?
+ ein geheimer Zusatzwert, der außerhalb der Datenbank gespeichert wird
- ein öffentlicher Salt
- ein Hashalgorithmus
- ein Passwortmanager
! Schützt zusätzlich, wenn nur die Datenbank gestohlen wird.

? Wie sollte man Hashes und Tokens vergleichen?
+ zeitkonstant
- mit == auf Strings in beliebigen Sprachen
- zeichenweise mit frühem Abbruch
- gar nicht
! Sonst entsteht ein Timing-Seitenkanal.

@@@ MODULE @@@
---
id: kx-03
title: Krypto-Praxis 3 · Zufallszahlen und Schlüsselerzeugung
paths: specialist, cwee
order: 60.3
difficulty: medium
icon: dice.fill
tags: kryptografie, zufall
summary: Warum schlechte Zufallszahlen ganze Systeme brechen, was ein CSPRNG ist und wie man Tokens, Schlüssel und Nonces richtig erzeugt.
---

## Einfach erklärt

Ein Schlüssel ist nur so gut wie sein Zufall. Würfelt man mit einem gezinkten Würfel, kann der Gegner die Zahlen vorhersagen – egal wie stark das Schloss ist. Viele berühmte Kryptopannen waren keine Mathe-Fehler, sondern **schlechter Zufall**.

## PRNG vs. CSPRNG

| | PRNG (z. B. `random`, Mersenne Twister) | CSPRNG |
|---|---|---|
| Zweck | Simulation, Spiele | Sicherheit |
| Vorhersagbar? | aus einigen Ausgaben rekonstruierbar | praktisch nicht |
| Beispiele | `Math.random()`, `random.random()`, `rand()` | `secrets`, `crypto.getRandomValues`, `/dev/urandom`, `getrandom()`, `SecRandomCopyBytes` |

```python
import secrets
token = secrets.token_urlsafe(32)      # Session-/Reset-Token
key = secrets.token_bytes(32)          # 256-Bit-Schlüssel
```

## Wo Zufall entscheidend ist

- Session-IDs, Reset-Tokens, API-Keys
- Kryptografische Schlüssel
- **Nonces/IVs** – bei manchen Verfahren (z. B. AES-GCM) darf eine Nonce mit demselben Schlüssel **nie** wiederverwendet werden
- Salts
- Signaturen (ECDSA: eine wiederverwendete oder vorhersagbare Nonce verrät den privaten Schlüssel!)

> [!GEFAHR] Nonce-Wiederverwendung
> Bei AES-GCM zerstört eine einzige doppelt verwendete Nonce Vertraulichkeit und Integrität. Bei ECDSA kann sie den privaten Schlüssel offenlegen – so wurde u. a. eine bekannte Spielkonsole kompromittiert.

## Tiefer eingetaucht

Entropiequellen: Betriebssysteme sammeln Rauschen (Interrupt-Timing, Hardware-RNG wie RDRAND) und speisen damit einen CSPRNG. Kritisch sind Situationen mit wenig Entropie: frisch gebootete VMs und eingebettete Geräte (gleiche Images, gleiche Schlüssel!). Studien fanden im Internet zahlreiche Geräte mit identischen oder schwachen Schlüsseln aus genau diesem Grund.

Gegenmittel: moderne Kernel-APIs (`getrandom` blockiert bis zur ausreichenden Initialisierung), deterministische Nonces nach RFC 6979 für ECDSA bzw. Ed25519, für AES-GCM Zähler-Nonces oder nonce-missbrauchsresistente Verfahren (AES-GCM-SIV).

## Quiz

? Welches Python-Modul liefert kryptografisch sichere Zufallswerte?
= secrets
! random ist für Sicherheit ungeeignet.

? Wofür steht CSPRNG?
= Cryptographically Secure Pseudo-Random Number Generator
! Ein Zufallsgenerator, dessen Ausgaben nicht vorhersagbar sind.

?tf Bei AES-GCM ist das Wiederverwenden einer Nonce mit demselben Schlüssel unbedenklich.
= falsch
! Es zerstört Vertraulichkeit und Integrität.

? Was kann bei ECDSA eine wiederverwendete Nonce offenlegen?
+ den privaten Schlüssel
- nur den öffentlichen Schlüssel
- die Dateigröße
- gar nichts
! Deshalb deterministische Nonces (RFC 6979) oder Ed25519.

? Welche Umgebungen haben oft zu wenig Entropie direkt nach dem Start?
+ frisch gebootete VMs und eingebettete Geräte
- große Desktop-PCs nach Stunden Betrieb
- Server mit Hardware-RNG im Dauerbetrieb
- Smartphones nach Tagen Laufzeit
! Gleiche Images können gleiche Schlüssel erzeugen.

@@@ MODULE @@@
---
id: kx-04
title: Krypto-Praxis 4 · TLS-Konfiguration bewerten und härten
paths: specialist, cwes, cwee
order: 60.4
difficulty: medium
icon: lock.shield
tags: tls, kryptografie, härtung
summary: Protokollversionen, Cipher Suites, Zertifikate, OCSP-Stapling, HSTS und Werkzeuge zur Bewertung – eine praxisnahe Checkliste.
---

## Einfach erklärt

TLS ist das Schloss an jeder HTTPS-Verbindung. Wie bei echten Schlössern gibt es alte, leicht zu knackende Modelle und moderne. Eine gute TLS-Konfiguration bietet **nur moderne Schlösser** an und lässt sich nicht auf alte herunterhandeln.

## Checkliste

| Bereich | Empfehlung |
|---|---|
| Protokolle | TLS 1.3 und 1.2; TLS 1.0/1.1, SSLv3 aus |
| Schlüsselaustausch | ECDHE (Forward Secrecy) |
| Verschlüsselung | AES-GCM, ChaCha20-Poly1305; kein RC4, 3DES, CBC-Altlasten |
| Zertifikat | RSA ≥ 2048 Bit oder ECDSA P-256; vollständige Kette; korrekte Namen |
| Gültigkeit | kurze Laufzeiten, automatische Erneuerung (ACME) |
| OCSP-Stapling | Server liefert Sperrstatus mit |
| HSTS | `max-age` ≥ 1 Jahr, ggf. Preload |
| Kompression | TLS-Kompression aus (CRIME) |
| Renegotiation | sichere Renegotiation / bei 1.3 entfällt sie |

> [!TIPP] Bewährte Vorlagen
> Statt Cipher-Listen selbst zu basteln: Mozilla SSL Configuration Generator (Profile „modern“ oder „intermediate“).

## Prüfen

```bash
nmap --script ssl-enum-ciphers -p 443 example.com
testssl.sh https://example.com
openssl s_client -connect example.com:443 -tls1_2
```

## Tiefer eingetaucht

TLS 1.3 vereinfacht viel: weniger, ausschließlich sichere Cipher Suites, Forward Secrecy immer, schnellerer Handshake (1-RTT, optional 0-RTT – Achtung: 0-RTT-Daten sind wiederholbar, nur für idempotente Anfragen). **Encrypted Client Hello (ECH)** verbirgt zusätzlich den Ziel-Hostnamen.

Zertifikatsverwaltung ist oft die eigentliche Schwachstelle: abgelaufene Zertifikate legen Dienste lahm, vergessene Wildcard-Schlüssel auf vielen Servern vergrößern das Risiko. Inventar aller Zertifikate, automatische Erneuerung und Überwachung der Ablaufdaten (und Certificate Transparency für die eigene Domain) gehören zum Betrieb.

## Quiz

? Welche TLS-Versionen sollten heute angeboten werden?
+ TLS 1.3
+ TLS 1.2
- TLS 1.0
- SSLv3
! Ältere Versionen sind unsicher bzw. veraltet.

? Welcher Schlüsselaustausch bietet Forward Secrecy?
= ECDHE
! Ephemeral Diffie-Hellman auf elliptischen Kurven.

? Was ist OCSP-Stapling?
+ der Server liefert den Sperrstatus seines Zertifikats direkt mit
- eine Verschlüsselungsart
- ein Zertifikatsformat
- ein DNS-Eintrag
! Spart dem Client eine zusätzliche Anfrage und schützt Privatsphäre.

?tf 0-RTT-Daten in TLS 1.3 können wiederholt (replayed) werden.
= wahr
! Nur für idempotente Anfragen geeignet.

? Welches Werkzeug prüft TLS-Konfigurationen umfassend auf der Kommandozeile?
= testssl.sh
= testssl
! Alternativ nmap mit ssl-enum-ciphers.

? Welches Protokoll automatisiert die Ausstellung und Erneuerung von Zertifikaten?
= ACME
! Bekannt durch Let's Encrypt.

@@@ MODULE @@@
---
id: kx-05
title: Krypto-Praxis 5 · Schlüsselverwaltung, HSM und KMS
paths: specialist, cdsa
order: 60.5
difficulty: medium
icon: key.icloud.fill
tags: kryptografie, schlüsselmanagement
summary: Lebenszyklus kryptografischer Schlüssel, Envelope Encryption, Hardware-Sicherheitsmodule, Cloud-KMS und Krypto-Agilität.
---

## Einfach erklärt

Verschlüsselung verwandelt ein Datenproblem in ein Schlüsselproblem. Die beste Verschlüsselung nützt nichts, wenn der Schlüssel neben dem Tresor liegt. **Schlüsselverwaltung** regelt, wo Schlüssel entstehen, wo sie liegen, wer sie benutzen darf, wann sie gewechselt und wie sie vernichtet werden.

## Lebenszyklus

1. **Erzeugung** – mit gutem Zufall, idealerweise im HSM/KMS.
2. **Verteilung** – sicher, möglichst gar nicht im Klartext.
3. **Speicherung** – geschützt, getrennt von den Daten.
4. **Nutzung** – mit Zugriffskontrolle und Protokollierung.
5. **Rotation** – regelmäßig und bei Verdacht.
6. **Sperrung/Archivierung** – alte Schlüssel ggf. noch zum Entschlüsseln.
7. **Vernichtung** – nachweisbar.

## Envelope Encryption

Daten werden mit einem **Datenschlüssel** (DEK) verschlüsselt; der DEK wird mit einem **Hauptschlüssel** (KEK) im KMS/HSM verschlüsselt und neben den Daten gespeichert. Vorteile: große Datenmengen lokal schnell verschlüsseln, Hauptschlüssel verlässt nie das HSM, Rotation des KEK ohne alle Daten neu zu verschlüsseln.

| Baustein | Eigenschaft |
|---|---|
| HSM | Hardware, Schlüssel nicht exportierbar, zertifiziert (z. B. FIPS 140-3) |
| Cloud-KMS | verwalteter Dienst, oft HSM-gestützt, IAM-gesteuert, protokolliert |
| BYOK / HYOK | eigener Schlüssel in der Cloud bzw. Schlüssel bleibt beim Kunden |

> [!MERKE] Trennung von Daten und Schlüsseln
> Wer die verschlüsselte Datenbank und den Schlüssel am selben Ort ablegt, hat die Verschlüsselung nur dekorativ.

## Tiefer eingetaucht

**Krypto-Agilität**: Systeme so bauen, dass Algorithmen und Schlüssel ohne große Umbauten wechselbar sind – wichtig für die Post-Quanten-Migration. Dazu gehört ein **Krypto-Inventar** (welche Verfahren, Schlüssel, Zertifikate sind wo im Einsatz?).

Zugriff auf KMS-Schlüssel ist ein Hochwertrecht: Wer `Decrypt` auf den richtigen Schlüssel darf, liest die Daten. KMS-Protokolle (z. B. CloudTrail-Events für Decrypt) sind daher wichtige Erkennungsquellen für Datendiebstahl.

## Quiz

? Was ist Envelope Encryption?
+ Daten werden mit einem Datenschlüssel verschlüsselt, der wiederum mit einem Hauptschlüssel verschlüsselt ist
- Verschlüsselung von Briefumschlägen
- doppelte Verschlüsselung mit demselben Schlüssel
- Verschlüsselung nur der Dateinamen
! Der Hauptschlüssel verlässt das KMS/HSM nie.

? Was ist ein HSM?
+ ein Hardwaremodul, das Schlüssel sicher erzeugt und nicht exportierbar speichert
- ein Hashverfahren
- ein Netzwerkswitch
- ein Monitoring-Werkzeug
! Hardware Security Module.

?tf Schlüssel sollten getrennt von den verschlüsselten Daten gespeichert werden.
= wahr
! Sonst ist die Verschlüsselung wirkungslos.

? Was bedeutet Krypto-Agilität?
+ Algorithmen und Schlüssel lassen sich ohne große Umbauten austauschen
- Verschlüsselung läuft besonders schnell
- Schlüssel werden nie gewechselt
- nur symmetrische Verfahren werden genutzt
! Wichtig für die Post-Quanten-Migration.

? Welche Abkürzung beschreibt, dass Kunden eigene Schlüssel in einen Cloud-KMS einbringen?
= BYOK
= Bring Your Own Key
! Bei HYOK bleibt der Schlüssel ganz beim Kunden.

@@@ MODULE @@@
---
id: kx-06
title: Krypto-Praxis 6 · E-Mail-Verschlüsselung mit S/MIME und OpenPGP
paths: specialist, grundlagen
order: 60.6
difficulty: medium
icon: envelope.badge.shield.half.filled.fill
tags: kryptografie, e-mail
summary: Transportverschlüsselung vs. Ende-zu-Ende, wie S/MIME und OpenPGP funktionieren, Signieren vs. Verschlüsseln und typische Stolpersteine.
---

## Einfach erklärt

E-Mails sind wie Postkarten: Unterwegs kann sie jeder lesen, der sie in die Hand bekommt. **TLS zwischen Mailservern** steckt die Postkarte während des Transports in einen Umschlag – auf jedem Server liegt sie aber wieder offen. **Ende-zu-Ende-Verschlüsselung** (S/MIME, OpenPGP) versiegelt den Inhalt so, dass nur der Empfänger ihn öffnen kann.

## Zwei Verfahren

| | S/MIME | OpenPGP |
|---|---|---|
| Vertrauen | Zertifikate von CAs (hierarchisch) | Schlüssel, Vertrauen selbst verwaltet (Web of Trust, WKD) |
| Verbreitung | Unternehmen, Behörden, in Mail-Clients integriert | Technik-Community, Journalismus |
| Schlüsselverteilung | über Zertifikate, Verzeichnisse | Keyserver, WKD, persönlicher Austausch |

## Signieren vs. Verschlüsseln

- **Signieren** (mit dem eigenen privaten Schlüssel): Empfänger kann Absender und Unverändertheit prüfen.
- **Verschlüsseln** (mit dem öffentlichen Schlüssel des Empfängers): Nur der Empfänger kann lesen.
- Beides kombinieren für Vertraulichkeit **und** Authentizität.

> [!WARNUNG] Betreffzeile und Metadaten
> Klassisch werden Betreff, Absender, Empfänger und Zeitpunkt nicht verschlüsselt. Moderne Clients können den Betreff schützen („Protected Headers“) – Metadaten bleiben sichtbar.

## Tiefer eingetaucht

Die **EFAIL**-Schwachstellen (2018) zeigten, dass Clients, die HTML-Mails mit externen Inhalten laden, verschlüsselte Inhalte über manipulierte Mails abfließen lassen konnten. Abhilfe: aktuelle Clients, Nachladen externer Inhalte deaktivieren, authentifizierte Verschlüsselung.

In Unternehmen ist **zentrale Schlüsselverwaltung** wichtig: Was passiert, wenn ein Mitarbeiter geht und seine Mails verschlüsselt sind? Lösungen: Key Escrow/Recovery für Verschlüsselungsschlüssel (nicht für Signaturschlüssel!), Gateway-Verschlüsselung an der Unternehmensgrenze, klare Regeln, wann verschlüsselt werden muss (z. B. Gesundheits- oder Personaldaten).

## Quiz

? Was schützt TLS zwischen Mailservern?
+ den Transport zwischen den Servern, nicht die Speicherung auf den Servern
- die Mail vom Absender bis zum Empfänger vollständig
- nur den Anhang
- nur den Betreff
! Für Ende-zu-Ende braucht es S/MIME oder OpenPGP.

? Mit welchem Schlüssel verschlüsselt man eine Mail an jemanden?
+ mit dem öffentlichen Schlüssel des Empfängers
- mit dem eigenen privaten Schlüssel
- mit dem privaten Schlüssel des Empfängers
- mit einem gemeinsamen Passwort
! Nur der Empfänger kann mit seinem privaten Schlüssel entschlüsseln.

? Was ermöglicht eine digitale Signatur?
+ Prüfung von Absender und Unverändertheit
- Verschlüsselung des Inhalts
- schnellere Zustellung
- Spam-Filterung
! Signieren und Verschlüsseln sind getrennte Funktionen.

?tf Bei klassischer E-Mail-Verschlüsselung bleiben Absender und Empfänger sichtbar.
= wahr
! Metadaten werden nicht verschlüsselt.

? Welche Schwachstellen-Familie betraf 2018 verschlüsselte E-Mails in HTML-fähigen Clients?
= EFAIL
! Inhalte konnten über externe Inhalte abfließen.

? Welches Verfahren nutzt hierarchische Zertifikate von CAs?
= S/MIME
! OpenPGP setzt auf selbst verwaltetes Vertrauen.

@@@ MODULE @@@
---
id: zp-01
title: Lernplan · HTB CJCA – der Einstieg
paths: cjca
order: 0.05
difficulty: easy
icon: map.fill
tags: lernplan, zertifikat
summary: Ein strukturierter Lernplan für das Einstiegszertifikat – Reihenfolge der NIMA-Module, Wochenplan, Übungsstrategie und Prüfungsvorbereitung.
---

## Einfach erklärt

Ein Zertifikat ist wie ein Bergziel: Man kann einfach loslaufen – oder eine Route planen, Etappen festlegen und unterwegs Rast machen. Dieser Lernplan ist die Route für den Einstieg in die praktische Cybersicherheit.

## Route in vier Etappen

| Etappe | Inhalt | NIMA-Bereiche |
|---|---|---|
| 1. Fundament (2–3 Wochen) | Netzwerk, Linux, Windows, Web-Grundlagen | Erste Schritte, Fundament, Linux-/Windows-Praxis |
| 2. Werkzeuge (2 Wochen) | Kommandozeile, Scans, Proxy, Wireshark | Protokolle, Werkzeuge, Pentest-Methodik 1–3 |
| 3. Angriff & Verteidigung (3–4 Wochen) | Web-Schwachstellen, Passwörter, Rechteausweitung, Logs | OWASP-Serie, SOC-Praxis 1–4 |
| 4. Prüfung (1–2 Wochen) | Wiederholung, Simulation, Bericht | Prüfungssimulation, Fehlerbuch |

## Wochenrhythmus

- **5 Tage × 45–60 Min.**: 1–2 Lektionen lesen + Wissens-Check + 15–20 Wiederholungskarten.
- **1 Tag Praxis**: Labor auf einer Lernplattform.
- **1 Tag Pause** – Erholung gehört zum Lernen.

> [!TIPP] Nutze die Lernkartei konsequent
> Täglich die fälligen Karten abarbeiten ist wirksamer als stundenlanges Lesen am Wochenende. Die Spaced Repetition holt Wissen genau dann zurück, bevor es verblasst.

## Prüfungsvorbereitung

1. Prüfungssimulationen im Pfad CJCA mit mindestens 40 Fragen, Ziel ≥ 85 %.
2. Fehlerbuch leeren: Jede Problemkarte mit Lektion nachlesen.
3. Praktisch: einen kompletten Übungsablauf mit Notizen und Kurzbericht durchspielen.

## Tiefer eingetaucht

Der häufigste Fehler beim Einstieg: zu schnell zu fortgeschrittenen Themen springen. Wer Subnetting, HTTP-Anfragen und Linux-Rechte nicht sicher beherrscht, bleibt später bei jedem Pentest-Schritt hängen. Deshalb: Fundament wirklich festigen (Skill-Rating im Pfad „Fundament“ mindestens Gold), dann weiter.

## Quiz

? Womit sollte die Vorbereitung auf ein Einstiegszertifikat beginnen?
+ mit soliden Grundlagen in Netzwerk, Betriebssystemen und Web
- mit fortgeschrittenen Exploits
- mit dem Kauf teurer Hardware
- mit der Prüfung selbst
! Ohne Fundament bleibt man später hängen.

?tf Tägliches kurzes Wiederholen ist wirksamer als seltenes langes Lernen.
= wahr
! Das ist der Kern von Spaced Repetition.

? Welche Trefferquote ist in Simulationen ein gutes Ziel vor der Prüfung?
+ mindestens 85 %
- 30 %
- 50 %
- genau 60 %
! Etwas Puffer über der Bestehensgrenze gibt Sicherheit.

? Was macht man mit Problemkarten aus dem Fehlerbuch?
+ die zugehörige Lektion nachlesen und gezielt wiederholen
- ignorieren
- löschen
- nur auswendig lernen ohne Verständnis
! Verstehen schlägt Auswendiglernen.

@@@ MODULE @@@
---
id: zp-02
title: Lernplan · HTB CPTS – Penetration Tester
paths: cpts
order: 0.05
difficulty: medium
icon: map.fill
tags: lernplan, zertifikat, pentest
summary: Lernroute für den Penetration Tester – Methodik, Enumeration, Web, AD, Pivoting, Bericht – mit Zeitplan und Prüfungsstrategie.
---

## Einfach erklärt

CPTS prüft, ob man ein ganzes Unternehmensnetz methodisch testen und professionell berichten kann. Das ist eher ein Marathon als ein Sprint: viel Stoff, viel Praxis, und am Ende ein Bericht, der wie für einen echten Kunden geschrieben ist.

## Route

| Phase | Wochen | Schwerpunkte | NIMA-Bereiche |
|---|---|---|---|
| Methodik | 1–2 | Prozess, Scoping, Notizen, Bericht | Pentest-Methodik 1–4, c-01, c-10 |
| Enumeration | 2–3 | Nmap, Dienste, Footprinting | c-02, c-03, Protokolle |
| Web | 3–4 | OWASP, Proxies, Injection, Dateien | OWASP-Serie, Web vertieft, b-Module |
| System | 3 | Linux/Windows-Rechteausweitung, Passwörter | ptm-06/07, c-06, c-07 |
| Active Directory | 4 | Struktur, Kerberos, Angriffsklassen, Pfade | AD verstehen, c-08, a-Module |
| Netz | 2 | Pivoting, Tunneling | c-09, Netzarchitektur |
| Prüfungstraining | 2–3 | Simulationen, Labor-Netze, Bericht | Prüfungssimulation, Fallstudie c-16 |

> [!MERKE] Der Bericht zählt
> Viele scheitern nicht an der Technik, sondern am Bericht. Übe von Anfang an, jeden Fund sofort sauber zu dokumentieren.

## Strategie

1. **Eigene Checklisten** pro Dienst und für AD erstellen und laufend verbessern.
2. **Labornetze** mit mehreren Hosts üben – Ketten erkennen, nicht nur Einzelboxen.
3. **Zeitbox**-Disziplin trainieren (siehe Modul „Der praktische Prüfungstag“).
4. **Berichtsvorlage** vorbereiten, an Übungsnetzen ausprobieren.

## Tiefer eingetaucht

Skill-Ziele in NIMA vor der Prüfung: Skill-Liga im Pfad CPTS mindestens Platin, Fehlerbuch für AD- und Web-Fragen leer, mindestens drei bestandene Pfad-Prüfungen mit ≥ 80 %. Wichtiger als Punkte ist aber die Fähigkeit, **unbekannte** Situationen methodisch zu lösen – deshalb immer zuerst selbst versuchen, dann erst nachlesen.

## Quiz

? Woran scheitern viele Kandidaten neben der Technik?
+ am unvollständigen oder unklaren Bericht
- an zu vielen Pausen
- an zu guten Notizen
- an zu frühem Lernbeginn
! Der Bericht ist Teil der Bewertung.

? Warum sollte man in Labornetzen mit mehreren Hosts üben?
+ um Angriffsketten über mehrere Systeme zu erkennen
- weil Einzelsysteme verboten sind
- weil es schneller geht
- weil es keine Notizen braucht
! Die Prüfung verlangt Bewegung durch ein ganzes Netz.

?tf Eigene Checklisten pro Dienst helfen, in der Prüfung nichts zu übersehen.
= wahr
! Sie strukturieren die Enumeration.

? Welcher NIMA-Bereich ist für die AD-Vorbereitung zentral?
+ AD verstehen und die AD-Module
- WLAN vertieft
- OT-Serie
- Datenschutz-Technik
! Active Directory ist ein großer Prüfungsbestandteil.

@@@ MODULE @@@
---
id: zp-03
title: Lernplan · HTB CWES – Web Exploitation Specialist
paths: cwes
order: 0.05
difficulty: medium
icon: map.fill
tags: lernplan, zertifikat, web
summary: Lernroute für Web-Sicherheitsspezialisten – HTTP, Recon, OWASP-Klassen, APIs, Authentifizierung und Bug-Bounty-artiges Berichten.
---

## Einfach erklärt

CWES (ehemals CBBH) dreht sich um Webanwendungen: Wie findet man Schwachstellen systematisch, weist sie nach und beschreibt sie so, dass Entwickler sie beheben können? Grundlage ist ein tiefes Verständnis von HTTP und Browsern.

## Route

| Phase | Schwerpunkte | NIMA-Bereiche |
|---|---|---|
| Grundlagen | HTTP, TLS, Cookies, SOP, DOM | b-01, Web vertieft 1–2, f-09 |
| Recon | Proxy, Inhaltserkennung, Parameter, JS-Analyse | c-04, wb-11 |
| Injection | SQLi, Command Injection, SSTI, XXE | b-02, b-08, wb-05, OWASP A03 |
| Client-Seite | XSS, CSRF, CSP, Clickjacking | b-03, wb-03, wb-04 |
| Zugriffskontrolle | IDOR, BOLA, Rechte | wb-06, OWASP A01, b-05 |
| Authentifizierung | Sessions, Reset-Flows, OAuth/JWT | wb-07, x-02, wd-02 |
| Dateien & Server | Uploads, Inclusion, SSRF | b-04, OWASP A10 |
| Berichten | Findings, Nachweise, Bewertung | ptm-08, ptm-03, b-06 |

> [!TIPP] Zwei Konten, immer
> Für jede Anwendung mindestens zwei Testkonten (und Rollen) anlegen – Zugriffskontrollfehler findet man fast nur so.

## Strategie

1. Jede Anwendung zuerst **komplett kartieren**, dann testen.
2. Pro Parameter systematisch fragen: Wohin fließt er? (SQL, HTML, Datei, URL, Befehl)
3. Kleine Funde verketten (z. B. Self-XSS + CSRF).
4. Jeden Fund mit minimalem, reproduzierbarem Nachweis dokumentieren.

## Tiefer eingetaucht

Web-Tests leben von Neugier und Systematik zugleich. Eine eigene Notizvorlage pro Anwendung (Endpunkte, Rollen, Parameter, Hypothesen, Ergebnisse) verhindert, dass man Bereiche doppelt oder gar nicht prüft. Fortgeschrittene Themen (Cache-Angriffe, Smuggling, Prototype Pollution) gehören eher zu CWEE – für CWES zählen die Klassiker in Tiefe.

## Quiz

? Was ist die Grundlage für Web-Sicherheitstests?
+ ein tiefes Verständnis von HTTP und Browsern
- möglichst viele automatische Scanner
- ein schneller Computer
- Kenntnisse in Assembler
! Ohne HTTP-Verständnis bleibt man an der Oberfläche.

? Warum braucht man mindestens zwei Testkonten?
+ um Zugriffskontrollfehler wie IDOR zu finden
- weil Anwendungen sonst nicht starten
- um doppelt so schnell zu testen
- weil es die Lizenz verlangt
! Anfragen eines Kontos mit der Sitzung des anderen wiederholen.

?tf Kleine Funde können zu einer schwerwiegenden Kette kombiniert werden.
= wahr
! Verkettung ist eine Kernfähigkeit.

? Welche Frage stellt man systematisch zu jedem Parameter?
+ Wohin fließt der Wert – SQL, HTML, Datei, URL oder Befehl?
- Wie lang ist der Parametername?
- Welche Farbe hat das Formular?
- Wer hat die Seite gestaltet?
! Der Zielkontext bestimmt die mögliche Schwachstellenklasse.

@@@ MODULE @@@
---
id: zp-04
title: Lernplan · HTB CDSA – Defensive Security Analyst
paths: cdsa
order: 0.05
difficulty: medium
icon: map.fill
tags: lernplan, zertifikat, soc
summary: Lernroute für SOC-Analysten – SIEM-Abfragen, Windows-/Netzwerkanalyse, Hunting, Forensik, Malware-Triage und Incident-Berichte.
---

## Einfach erklärt

CDSA prüft, ob man wie ein SOC-Analyst arbeiten kann: Alarme verstehen, in großen Datenmengen die Spur eines Angriffs finden, den Ablauf rekonstruieren und verständlich berichten. Detektivarbeit mit Logs.

## Route

| Phase | Schwerpunkte | NIMA-Bereiche |
|---|---|---|
| SOC-Grundlagen | Triage, Prozesse, Modelle | d-01, soc-01, soc-10 |
| SIEM | SPL, KQL, Suchstrategien | d-02, soc-02, soc-03 |
| Windows | Event-IDs, Sysmon, PowerShell-Logs | d-03, soc-04, soc-05, soc-06 |
| Angriffe erkennen | ATT&CK, Lateral Movement, AD | ATT&CK-Serie, soc-12, d-10 |
| Netzwerk | Zeek, Suricata, Wireshark, Beaconing | d-05, np-09, soc-11 |
| Hunting | Hypothesen, Baselines | d-04, de-04 |
| Forensik | Artefakte, Speicher, Timeline | d-08, soc-07, soc-08, ir-03 |
| Malware | Triage, YARA, Sigma | d-06, d-07, soc-09 |
| Bericht | Incident-Bericht | soc-14, ir-01 |

> [!MERKE] Fragen stellen, nicht nur suchen
> Gute Analysten formulieren Hypothesen („Wenn sich der Angreifer per RDP bewegt hat, sehe ich 4624 Type 10 auf …“) und prüfen sie gezielt.

## Strategie

1. SPL und KQL so üben, dass Standardfragen (zählen, gruppieren, Zeitreihen) sitzen.
2. Event-IDs und Sysmon-IDs mit dem Begriffe- und Terminal-Drill festigen.
3. Mindestens zwei komplette Vorfälle (Labore) von Alarm bis Bericht durcharbeiten.
4. Zeitleisten-Disziplin: alles in UTC, mit Belegen.

## Tiefer eingetaucht

Die Prüfung belohnt Gründlichkeit: Nicht beim ersten Fund aufhören, sondern den **gesamten** Angriffsweg rekonstruieren – Erstzugang, Ausführung, Persistenz, Bewegung, Ziel. Ein Notizschema entlang der ATT&CK-Taktiken hilft, Lücken in der eigenen Rekonstruktion zu sehen.

## Quiz

? Was ist eine Kernfähigkeit für CDSA?
+ in großen Datenmengen die Spur eines Angriffs finden und rekonstruieren
- Malware programmieren
- Firewalls verkaufen
- Webdesign
! Detektivarbeit mit Logs.

? Wie arbeiten gute Analysten?
+ mit Hypothesen, die gezielt geprüft werden
- mit zufälligen Suchen
- nur mit vorgefertigten Dashboards
- ohne Notizen
! Hypothesen geben der Suche Richtung.

?tf Bei der Untersuchung sollte man nach dem ersten Fund aufhören.
= falsch
! Der gesamte Angriffsweg muss rekonstruiert werden.

? Welche Struktur hilft, Lücken in der eigenen Rekonstruktion zu sehen?
+ ein Notizschema entlang der ATT&CK-Taktiken
- alphabetische Sortierung
- Sortierung nach Dateigröße
- keine Struktur
! Fehlt z. B. die Persistenz, weiß man, wo man weitersuchen muss.

@@@ MODULE @@@
---
id: zp-05
title: Lernplan · HTB CWEE – Web Exploitation Expert
paths: cwee
order: 0.05
difficulty: hard
icon: map.fill
tags: lernplan, zertifikat, web
summary: Lernroute für fortgeschrittene Websicherheit – Whitebox-Analyse, fortgeschrittene Klassen, Parser-Differenzen, Kryptofehler und Verkettung.
---

## Einfach erklärt

CWEE ist die Meisterklasse der Websicherheit: Es geht weniger um bekannte Payloads, sondern darum, **Code zu lesen**, Annahmen von Entwicklern zu hinterfragen und mehrere Schwächen zu einer wirkungsvollen Kette zu verbinden.

## Route

| Phase | Schwerpunkte | NIMA-Bereiche |
|---|---|---|
| Whitebox | Code-Review, Source → Sink | x-01, wb-14 |
| Moderne Klassen | Cache, Smuggling, Prototype Pollution | wb-10, x-03 |
| Deserialisierung & XML | Gadget-Konzepte, XXE | wb-05 |
| Authentifizierung | OAuth, OIDC, JWT, Sessions | x-02, wd-02 |
| Krypto in Apps | Fehler, Zufall, Hashes | kr-05, kx-01–03 |
| JavaScript-Ökosystem | Node.js, Clientcode | wb-11 |
| Sichere Entwicklung | Verständnis für Gegenmaßnahmen | x-04, wb-12, wb-13 |

> [!MERKE] Denken in Annahmen
> Jede Zeile Code enthält Annahmen („diese ID gehört dem Nutzer“, „dieser String ist schon validiert“, „dieser Proxy normalisiert den Pfad“). Die interessanten Fehler liegen dort, wo Annahmen nicht stimmen.

## Strategie

1. Täglich Code lesen – auch Open-Source-Projekte und deren Sicherheitsfixes (Diffs zu CVEs sind exzellentes Lernmaterial).
2. Eigene kleine, absichtlich verwundbare Anwendungen bauen und wieder absichern.
3. Ketten üben: Welche Kombination aus Fehlern ergibt die größte Wirkung?
4. Gründlich dokumentieren – auch die Ursache im Code und die konkrete Korrektur.

## Tiefer eingetaucht

Hilfreich ist ein persönliches „Muster-Archiv“: Für jede Schwachstellenklasse typische gefährliche Funktionen pro Sprache/Framework, typische Fehlannahmen, Erkennungsmerkmale im Code und die richtige Korrektur. Dieses Archiv wächst mit jeder Übung – und ist in der Prüfung Gold wert.

## Quiz

? Worum geht es bei CWEE vor allem?
+ Code verstehen, Annahmen hinterfragen und Schwächen verketten
- automatische Scanner bedienen
- Netzwerkkabel verlegen
- Firewall-Regeln schreiben
! Whitebox-Denken steht im Mittelpunkt.

? Was ist exzellentes Lernmaterial für Code-Reviews?
+ Diffs von Sicherheitsfixes zu bekannten CVEs
- Werbeprospekte
- Wetterdaten
- Hardware-Handbücher
! Man sieht Fehler und Korrektur direkt nebeneinander.

?tf Viele interessante Fehler entstehen dort, wo Annahmen im Code nicht stimmen.
= wahr
! Annahmen gezielt hinterfragen.

? Was gehört in ein persönliches Muster-Archiv?
+ gefährliche Funktionen, Fehlannahmen und richtige Korrekturen je Klasse
- nur Payload-Listen
- Passwörter
- Lieblingswerkzeuge ohne Erklärung
! Ein wachsendes Nachschlagewerk für Reviews.

@@@ MODULE @@@
---
id: zp-06
title: Lernplan · HTB CAPE – Active Directory Penetration Expert
paths: cape
order: 0.05
difficulty: hard
icon: map.fill
tags: lernplan, zertifikat, active directory
summary: Lernroute für AD-Experten – Kerberos, Delegation, ADCS, Trusts, Angriffspfade und Verteidigungsverständnis in der Tiefe.
---

## Einfach erklärt

CAPE ist die Expertenstufe für Active Directory: Wer hier besteht, versteht AD so gut, dass er sowohl komplexe Angriffswege erkennt als auch erklären kann, wie man sie verhindert. Grundlage ist ein sehr genaues Verständnis von Kerberos, Rechten und Vertrauensbeziehungen.

## Route

| Phase | Schwerpunkte | NIMA-Bereiche |
|---|---|---|
| AD-Struktur | Forests, Gruppen, Objekte, Rechte | adx-01, adx-02, adv-02 |
| Kerberos | Tickets, PAC, Roasting-Klassen | adx-03, a-01 |
| NTLM & Relay | Coercion, Signing, Channel Binding | adx-04 |
| Delegation | Unconstrained, KCD, RBCD | adx-05 |
| ADCS | Vorlagen, Fehlkonfigurationsklassen | adx-08, a-02 |
| Trusts | Richtungen, SID-Filterung | a-03 |
| Angriffspfade | Graphen, ACL-Missbrauch | adx-07 |
| Verteidigung | Tiering, Erkennung, Recovery | adx-06, adx-09, a-04, soc-12 |

> [!MERKE] Bedingungen verstehen
> Für jede Angriffsklasse genau wissen: Welches Recht oder welche Konfiguration ist Voraussetzung? Welche Ereignisse entstehen? Was verhindert sie? Dieses Dreieck ist der Schlüssel.

## Strategie

1. Eigenes AD-Labor (mehrere Domänen, Trust, ADCS) aufbauen und gezielt fehlkonfigurieren.
2. Für jede Klasse eine Karteikarte: Voraussetzung – Ablauf (konzeptionell) – Spuren – Abwehr.
3. BloodHound-Pfade lesen und von Hand nachvollziehen.
4. Lange Ketten üben: von einem normalen Nutzer über mehrere Rechte zur Domänenkontrolle.

## Tiefer eingetaucht

Wer AD verteidigt oder testet, profitiert vom gleichen Wissen. Gute Prüfungsvorbereitung umfasst daher auch das Lesen von Microsoft-Dokumentation zu Kerberos-Erweiterungen, ADCS-Härtung und Sicherheitsupdates (z. B. zu Zertifikatszuordnung und PAC-Validierung) – viele Angriffsklassen wurden durch solche Updates verändert.

## Quiz

? Was ist die Grundlage für CAPE?
+ ein sehr genaues Verständnis von Kerberos, Rechten und Vertrauensbeziehungen
- Webdesign
- WLAN-Planung
- Cloud-Kostenoptimierung
! Active Directory in der Tiefe.

? Welches Dreieck sollte man für jede Angriffsklasse kennen?
+ Voraussetzung, entstehende Spuren, Abwehr
- Farbe, Größe, Preis
- Name, Datum, Autor
- Port, Protokoll, Kabel
! So versteht man Angriff und Verteidigung zugleich.

?tf Ein eigenes AD-Labor mit Trusts und ADCS ist eine sinnvolle Vorbereitung.
= wahr
! Gezielte Fehlkonfigurationen machen Klassen greifbar.

? Warum lohnt das Lesen von Microsoft-Sicherheitsupdates zu Kerberos und ADCS?
+ viele Angriffsklassen wurden durch solche Updates verändert
- weil sie Prüfungsfragen enthalten
- weil sie kürzer als Bücher sind
- weil sie Passwörter enthalten
! Wer den aktuellen Stand kennt, bewertet Umgebungen richtig.
