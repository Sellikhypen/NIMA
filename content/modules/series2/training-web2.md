---
id: gt-01
title: Grundlagen-Training 1 · Binär, Hex und Bits rechnen
paths: grundlagen, cjca
order: 1.1
difficulty: easy
icon: function
tags: training, zahlensysteme
summary: Schritt-für-Schritt-Übungen zum Umrechnen zwischen Dezimal, Binär und Hex sowie zu Bitoperationen – mit Tricks zum Kopfrechnen.
---

## Einfach erklärt

Binär rechnen ist wie Lichtschalter zählen: Jeder Schalter hat einen festen Wert – 1, 2, 4, 8, 16, 32, 64, 128. Ist der Schalter an (1), zählt der Wert mit. So ist `1010 0001` = 128 + 32 + 1 = **161**.

## Die Wertetabelle für ein Byte

| Bit | 7 | 6 | 5 | 4 | 3 | 2 | 1 | 0 |
|---|---|---|---|---|---|---|---|---|
| Wert | 128 | 64 | 32 | 16 | 8 | 4 | 2 | 1 |

**Dezimal → Binär**: Von links den größten passenden Wert abziehen. Beispiel 200: 200 − 128 = 72 (1), 72 − 64 = 8 (1), 32 (0), 16 (0), 8 − 8 = 0 (1), Rest 0 → `1100 1000`.

## Hexadezimal

Ein Hex-Zeichen = 4 Bit (ein **Nibble**). `A`=10, `B`=11, `C`=12, `D`=13, `E`=14, `F`=15.

| Binär | Hex | Dezimal |
|---|---|---|
| `1111 1111` | `FF` | 255 |
| `1100 0000` | `C0` | 192 |
| `1010 1000` | `A8` | 168 |
| `0111 1111` | `7F` | 127 |

> [!TIPP] Kopfrechen-Trick
> Binär in zwei Nibbles teilen und jedes einzeln in Hex umwandeln: `1100 1000` → `C` `8` → `0xC8` = 12 × 16 + 8 = 200.

## Bitoperationen

| Operation | Beispiel | Nutzen |
|---|---|---|
| AND | `11001000 AND 11110000 = 11000000` | Netzadresse aus IP und Maske |
| OR | `00000100 OR 00000001 = 00000101` | Bits setzen (Rechte, Flags) |
| XOR | `1010 XOR 1100 = 0110` | Verschlüsselung (One-Time-Pad), Prüfsummen |
| NOT | `NOT 00001111 = 11110000` | Wildcard-Masken |
| Shift | `0001 << 2 = 0100` | mal 2 je Stelle |

## Tiefer eingetaucht

Wo das in der Sicherheit auftaucht: Subnetting (AND), Linux-Rechte (`chmod 754` = `111 101 100`), TCP-Flags (SYN = 0x02, ACK = 0x10, SYN+ACK = 0x12), Windows `userAccountControl` (Bit 2 = deaktiviert), XOR-verschleierte Strings in Malware, Little-Endian-Darstellung in Speicherauszügen (`0x12345678` steht als `78 56 34 12` im Speicher).

## Quiz

? Was ist 1010 0001 in Dezimal?
= 161
! 128 + 32 + 1.

? Was ist 200 in Hexadezimal?
= C8
= 0xC8
! 12 × 16 + 8 = 200.

? Wie viele Bits hat ein Nibble?
= 4
! Genau eine Hex-Ziffer.

? Was ergibt 1010 XOR 1100?
= 0110
= 110
! XOR ist 1, wenn die Bits verschieden sind.

? Wie lautet 0x7F in Dezimal?
= 127
! 7 × 16 + 15.

? Welche Bitoperation berechnet die Netzadresse aus IP-Adresse und Maske?
= AND
! Nur Bits, die in beiden 1 sind, bleiben 1.

?tf Linux-Rechte 754 entsprechen binär 111 101 100.
= wahr
! rwx r-x r--.

? Welcher Hexwert steht im TCP-Header für SYN+ACK?
= 0x12
= 12
! SYN = 0x02, ACK = 0x10.

@@@ MODULE @@@
---
id: gt-02
title: Grundlagen-Training 2 · Subnetting-Drill
paths: grundlagen, cjca, cpts
order: 3.1
difficulty: medium
icon: square.split.2x2.fill
tags: training, subnetting
summary: Subnetting im Kopf – Blockgrößen-Methode, Netz- und Broadcastadresse, Hostanzahl und Aufteilen von Netzen mit vielen Übungsaufgaben.
---

## Einfach erklärt

Subnetting wirkt kompliziert, ist aber mit einem Trick schnell: die **Blockgröße**. Sie sagt, in welchen Schritten Netze im „interessanten Oktett“ beginnen. Bei `/26` ist die Blockgröße 64 – Netze beginnen bei .0, .64, .128, .192.

## Die Blockgrößen-Methode

1. Interessantes Oktett finden (dort, wo die Maske nicht 255 oder 0 ist).
2. Blockgröße = 256 − Maskenwert in diesem Oktett.
3. Netzadresse = größtes Vielfaches der Blockgröße ≤ Adresswert.
4. Broadcast = nächstes Netz − 1.
5. Hosts = 2^(Hostbits) − 2.

| Präfix | Maske (letztes Oktett) | Blockgröße | nutzbare Hosts |
|---|---|---|---|
| /24 | 0 | 256 | 254 |
| /25 | 128 | 128 | 126 |
| /26 | 192 | 64 | 62 |
| /27 | 224 | 32 | 30 |
| /28 | 240 | 16 | 14 |
| /29 | 248 | 8 | 6 |
| /30 | 252 | 4 | 2 |

## Durchgerechnetes Beispiel

`172.16.45.130/27`: Maske letztes Oktett 224 → Block 32 → Netze 0, 32, 64, 96, **128**, 160 … → Netz `172.16.45.128`, Broadcast `172.16.45.159`, Hosts `.129–.158` (30 Stück).

Im dritten Oktett: `10.4.77.9/20` → Maske `255.255.240.0` → Block 16 im 3. Oktett → Netze 0, 16, 32, 48, **64**, 80 → Netz `10.4.64.0`, Broadcast `10.4.79.255`.

> [!TIPP] Zweierpotenzen auswendig
> 2, 4, 8, 16, 32, 64, 128, 256, 512, 1024, 2048, 4096 – damit rechnet man Hostanzahlen sofort.

## Tiefer eingetaucht

Aufteilen: Ein `/24` in 4 gleich große Netze → 2 Bits leihen → `/26`. Für unterschiedliche Größen (VLSM) immer mit dem größten Bedarf beginnen. IPv6: Standard-Subnetz ist `/64`; Organisationen erhalten oft `/48` → 65.536 Subnetze. Im Pentest hilft schnelles Subnetting, Scope-Angaben zu prüfen und Scans korrekt zu begrenzen.

## Quiz

? Wie groß ist die Blockgröße bei /26?
= 64
! 256 − 192.

? Wie viele nutzbare Hosts hat ein /27?
= 30
! 2^5 − 2.

? Was ist die Netzadresse von 172.16.45.130/27?
= 172.16.45.128
! Block 32: Netze bei 0, 32, 64, 96, 128 …

? Was ist die Broadcastadresse von 172.16.45.130/27?
= 172.16.45.159
! Nächstes Netz (160) minus 1.

? Was ist die Netzadresse von 10.4.77.9/20?
= 10.4.64.0
! Block 16 im dritten Oktett.

? Wie viele Bits muss man leihen, um ein /24 in 4 gleich große Netze zu teilen?
= 2
! 2^2 = 4 → /26.

? Welche Maske gehört zu /28?
= 255.255.255.240
! Blockgröße 16, 14 Hosts.

?tf Das Standard-Subnetz in IPv6 ist /64.
= wahr
! Viele Mechanismen (z. B. SLAAC) setzen /64 voraus.

@@@ MODULE @@@
---
id: gt-03
title: Grundlagen-Training 3 · Ports und Dienste auswendig
paths: grundlagen, cjca, cpts, cdsa
order: 4.1
difficulty: easy
icon: list.number
tags: training, ports
summary: Die 40 wichtigsten Ports mit Dienst, Protokoll und Sicherheitsrelevanz – zum Auswendiglernen mit Eselsbrücken.
---

## Einfach erklärt

Ports sind Zimmernummern im Hotel „Server“. Wer die wichtigsten auswendig kennt, liest Scanergebnisse, Firewall-Regeln und Logs ohne Nachschlagen. Hier sind die Zimmer, die man kennen muss.

## Klassiker

| Port | Dienst | Bemerkung |
|---|---|---|
| 20/21 | FTP | Klartext, anonymer Zugriff prüfen |
| 22 | SSH | Schlüssel statt Passwort |
| 23 | Telnet | Klartext – abschalten |
| 25 | SMTP | Mailversand zwischen Servern |
| 53 | DNS | UDP und TCP |
| 67/68 | DHCP | UDP |
| 69 | TFTP | UDP, ohne Anmeldung |
| 80 / 443 | HTTP / HTTPS | |
| 88 | Kerberos | Hinweis auf Domain Controller |
| 110 / 995 | POP3 / POP3S | |
| 111 | RPCbind | NFS-Umfeld |
| 123 | NTP | UDP |
| 135 | MS-RPC | Windows |
| 137–139 | NetBIOS | Altlast |
| 143 / 993 | IMAP / IMAPS | |
| 161/162 | SNMP | Community-Strings, v3 nutzen |
| 389 / 636 | LDAP / LDAPS | Verzeichnis |
| 445 | SMB | Windows-Freigaben |
| 465 / 587 | SMTPS / Submission | Mailversand von Clients |
| 1433 | MS SQL | |
| 1521 | Oracle | |
| 2049 | NFS | |
| 3268/3269 | Global Catalog | |
| 3306 | MySQL/MariaDB | |
| 3389 | RDP | nie offen ins Internet |
| 5432 | PostgreSQL | |
| 5900 | VNC | oft schwach geschützt |
| 5985/5986 | WinRM | PowerShell Remoting |
| 6379 | Redis | oft ohne Passwort |
| 8080/8443 | alternative Web-Ports | Admin-Oberflächen |
| 9200 | Elasticsearch | Datenlecks bei offener Instanz |
| 27017 | MongoDB | Datenlecks bei offener Instanz |
| 502 | Modbus | OT |
| 102 | S7comm | OT (Siemens) |
| 1883 / 8883 | MQTT / MQTTS | IoT |

> [!TIPP] Eselsbrücken
> 445 = „4 Freigaben, 4 Ordner, 5 Dateien“ – SMB. 3389 = „33 Bildschirme, 89 Pixel“ – RDP. 88 = „Kerberos hat zwei Köpfe, wie zwei Achten“ (der dreiköpfige Höllenhund – fast).

## Tiefer eingetaucht

Ports 0–1023 sind „well-known“ (unter Linux nur mit Rechten bindbar), 1024–49151 registriert, 49152–65535 dynamisch (Client-Ports). Dienste können auf jedem Port laufen – Scanner wie Nmap erkennen Dienste daher per Banner und Fingerprinting (`-sV`), nicht nur per Portnummer.

## Quiz

? Welcher Port gehört zu SMB?
= 445
! 139 ist SMB über NetBIOS.

? Welcher Port deutet auf einen Domain Controller hin, weil dort Kerberos läuft?
= 88
! Kerberos auf TCP/UDP 88.

? Auf welchem Port läuft RDP standardmäßig?
= 3389
! Nie direkt ins Internet stellen.

? Welcher Port gehört zu WinRM über HTTP?
= 5985
! 5986 ist WinRM über HTTPS.

? Welcher Port gehört zu LDAPS?
= 636
! 389 ist LDAP.

? Welche Datenbank läuft standardmäßig auf 3306?
+ MySQL/MariaDB
- PostgreSQL
- MongoDB
- MS SQL
! PostgreSQL 5432, MongoDB 27017, MS SQL 1433.

? Welcher OT-Port gehört zu Modbus/TCP?
= 502
! Modbus kennt keine Authentifizierung.

?tf Ein Dienst kann auf einem beliebigen Port laufen, nicht nur auf seinem Standardport.
= wahr
! Deshalb Diensterkennung mit -sV statt Raten nach Portnummer.

? Welcher Port gehört zu SNMP?
= 161
! Traps gehen an 162.

@@@ MODULE @@@
---
id: gt-04
title: Grundlagen-Training 4 · HTTP-Statuscodes, Methoden und Header
paths: grundlagen, cwes, cjca
order: 5.1
difficulty: easy
icon: curlybraces
tags: training, http
summary: Die wichtigsten HTTP-Methoden, Statuscodes und Header mit ihrer Bedeutung für Tests, Fehlersuche und Loganalyse.
---

## Einfach erklärt

HTTP-Antworten haben eine Nummer, die sofort sagt, wie es lief – wie Ampelfarben: **2xx** grün (geklappt), **3xx** gelb (woanders hin), **4xx** rot durch den Client (du hast etwas falsch gemacht), **5xx** rot durch den Server (der Server hat ein Problem).

## Methoden

| Methode | Zweck | Sicher/idempotent |
|---|---|---|
| GET | lesen | sicher |
| HEAD | nur Header | sicher |
| POST | anlegen/Aktion | nein |
| PUT | ersetzen | idempotent |
| PATCH | teilweise ändern | nein |
| DELETE | löschen | idempotent |
| OPTIONS | erlaubte Methoden, CORS-Preflight | sicher |

## Statuscodes

| Code | Bedeutung | Sicherheitshinweis |
|---|---|---|
| 200 | OK | |
| 201 | Created | |
| 204 | No Content | |
| 301 / 302 / 307 / 308 | Weiterleitung | offene Weiterleitungen prüfen |
| 304 | Not Modified | Caching |
| 400 | Bad Request | Eingabefehler |
| 401 | Unauthorized (eigentlich: nicht authentifiziert) | |
| 403 | Forbidden (keine Berechtigung) | 401 vs. 403 verrät Existenz |
| 404 | Not Found | auch zum Verbergen genutzt |
| 405 | Method Not Allowed | andere Methode testen |
| 429 | Too Many Requests | Rate Limit aktiv |
| 500 | Internal Server Error | Fehlermeldungen können Details verraten |
| 502 / 503 / 504 | Gateway-/Verfügbarkeitsfehler | Proxy/Backend-Probleme |

> [!TIPP] Unterschiede verraten Informationen
> Liefert `/admin` 403 und `/gibtsnicht` 404, existiert `/admin`. Gleichförmige Antworten verhindern solche Rückschlüsse.

## Wichtige Header

| Header | Zweck |
|---|---|
| `Host` | Zielname (virtuelle Hosts) |
| `Cookie` / `Set-Cookie` | Sitzung |
| `Authorization` | Token/Anmeldedaten |
| `Content-Type` | Datenformat |
| `User-Agent` | Client-Kennung |
| `Referer` / `Origin` | Herkunft (CSRF-Prüfung) |
| `X-Forwarded-For` | ursprüngliche Client-IP hinter Proxies (fälschbar!) |
| `Location` | Ziel einer Weiterleitung |

## Tiefer eingetaucht

In Webserver-Logs helfen Statuscodes beim Erkennen von Angriffen: viele 404 in kurzer Zeit = Verzeichnis-Bruteforce; viele 401/403 = Anmeldeversuche oder Zugriffstests; 500er nach ungewöhnlichen Parametern = möglicherweise Injection-Versuche, die Fehler auslösen.

## Quiz

? Welche Statuscode-Klasse bedeutet einen Fehler des Clients?
= 4xx
= 4
! 5xx bedeutet einen Fehler des Servers.

? Welcher Statuscode zeigt ein aktives Rate Limit?
= 429
! Too Many Requests.

? Was bedeutet 403?
+ Zugriff verboten trotz bzw. ohne ausreichende Berechtigung
- Seite nicht gefunden
- Serverfehler
- Weiterleitung
! 401 bedeutet eigentlich „nicht authentifiziert“.

? Welche Methode wird für CORS-Preflights verwendet?
= OPTIONS
! Der Browser fragt vorab, ob die eigentliche Anfrage erlaubt ist.

?tf Der Header X-Forwarded-For kann vom Client gefälscht werden.
= wahr
! Anwendungen sollten ihm nur von vertrauenswürdigen Proxies glauben.

? Worauf deuten viele 404-Antworten in kurzer Zeit von einer IP hin?
+ Verzeichnis- oder Datei-Bruteforce
- einen Stromausfall
- ein erfolgreiches Login
- ein Software-Update
! Scanner probieren viele Pfade aus.

? Welcher Header enthält das Ziel einer Weiterleitung?
= Location
! Bei 3xx-Antworten.

@@@ MODULE @@@
---
id: gt-05
title: Grundlagen-Training 5 · Kodierungen erkennen – Base64, URL, Hex, Unicode
paths: grundlagen, cwes, cdsa
order: 1.2
difficulty: easy
icon: textformat.alt
tags: training, encoding
summary: Wie man gängige Kodierungen auf einen Blick erkennt, umwandelt und warum Kodierung keine Verschlüsselung ist.
---

## Einfach erklärt

Kodierung ist wie eine andere Schrift: Derselbe Text, nur anders geschrieben – jeder, der die Schrift kennt, kann ihn lesen. **Verschlüsselung** dagegen braucht einen Schlüssel. Analysten müssen Kodierungen sofort erkennen, denn Angreifer nutzen sie zur Tarnung.

## Erkennungsmerkmale

| Kodierung | Merkmale | Beispiel |
|---|---|---|
| Base64 | A–Z, a–z, 0–9, +, /, oft `=` am Ende, Länge Vielfaches von 4 | `aGFsbG8=` (hallo) |
| Base64URL | wie Base64, aber `-` und `_`, oft ohne `=` | in JWTs |
| URL-Kodierung | `%` + zwei Hexziffern | `%20` (Leerzeichen), `%2F` (/) |
| Hex | nur 0–9, a–f, gerade Länge | `68616c6c6f` |
| HTML-Entities | `&` … `;` | `&lt;script&gt;` |
| Unicode-Escapes | `\u` + 4 Hex | `<` (<) |
| ROT13 | Buchstaben um 13 verschoben | `unyyb` (hallo) |
| Gzip+Base64 | Base64 beginnt oft mit `H4sI` | komprimierte Payloads |

> [!MERKE] Bekannte Präfixe
> `TVqQ` = Base64 eines Windows-Programms (`MZ`), `rO0` = Java-Serialisierung, `H4sI` = Gzip, `eyJ` = JSON-Objekt (`{"`) – typisch für JWTs.

## Werkzeuge

```bash
echo 'aGFsbG8=' | base64 -d
python3 -c "import urllib.parse;print(urllib.parse.unquote('%3Cscript%3E'))"
echo 68616c6c6f | xxd -r -p
```

**CyberChef** ist das Schweizer Taschenmesser: Rezepte aus Dekodierschritten, „Magic“ erkennt Kodierungen automatisch.

## Tiefer eingetaucht

Mehrfachkodierung ist ein beliebter Trick, um Filter zu umgehen: `%253C` ist doppelt URL-kodiert (`%25` = `%`). Verteidiger normalisieren deshalb Eingaben **einmal** und prüfen danach. PowerShell-Angriffe nutzen `-EncodedCommand` mit Base64 von **UTF-16LE** – beim Dekodieren muss man diese Zeichenkodierung beachten, sonst erscheinen Nullbytes zwischen den Zeichen.

## Quiz

? Welche Kodierung erkennt man an Prozentzeichen mit zwei Hexziffern?
= URL-Kodierung
= URL-Encoding
= URL
! %20 ist ein Leerzeichen.

?tf Base64 ist eine Form der Verschlüsselung.
= falsch
! Jeder kann Base64 ohne Schlüssel dekodieren.

? Womit beginnt ein Base64-kodiertes Windows-Programm typischerweise?
= TVqQ
= TVq
! Base64 von „MZ“ …

? Womit beginnen JWTs typischerweise?
= eyJ
! Base64URL von {".

? Welche Zeichenkodierung nutzt PowerShell bei -EncodedCommand?
= UTF-16LE
= UTF-16
! Sonst erscheinen beim Dekodieren Nullbytes.

? Was bedeutet %253C?
+ doppelt URL-kodiertes <
- einfach kodiertes Leerzeichen
- ein Hexwert ohne Bedeutung
- ein Base64-Zeichen
! %25 ist %, danach 3C = <.

? Welches Werkzeug erkennt und dekodiert Kodierungen mit „Rezepten“?
= CyberChef
! Mit der Funktion „Magic“ sogar automatisch.

@@@ MODULE @@@
---
id: gt-06
title: Grundlagen-Training 6 · Kommandozeilen-Spickzettel Linux und Windows
paths: grundlagen, cjca, cpts, cdsa
order: 6.1
difficulty: easy
icon: terminal.fill
tags: training, kommandozeile
summary: Die wichtigsten Befehle nebeneinander – Dateien, Prozesse, Netzwerk, Benutzer, Dienste, Logs – für Linux, cmd und PowerShell.
---

## Einfach erklärt

Wer zwischen Linux und Windows wechselt, sucht oft nur den passenden Befehl. Diese Tabelle ist ein Übersetzungswörterbuch – dieselbe Frage, drei Sprachen.

## Dateien und System

| Aufgabe | Linux | cmd | PowerShell |
|---|---|---|---|
| Verzeichnis anzeigen | `ls -la` | `dir` | `Get-ChildItem -Force` |
| Datei lesen | `cat datei` | `type datei` | `Get-Content datei` |
| Suchen | `grep -ri text .` | `findstr /s /i text *` | `Select-String -Path * -Pattern text` |
| Datei finden | `find / -name x 2>/dev/null` | `dir /s x` | `Get-ChildItem -Recurse -Filter x` |
| Rechte | `ls -l`, `chmod` | `icacls datei` | `Get-Acl datei` |
| Systeminfo | `uname -a`, `cat /etc/os-release` | `systeminfo` | `Get-ComputerInfo` |

## Prozesse und Dienste

| Aufgabe | Linux | cmd | PowerShell |
|---|---|---|---|
| Prozesse | `ps aux` | `tasklist` | `Get-Process` |
| Prozess beenden | `kill PID` | `taskkill /PID n` | `Stop-Process -Id n` |
| Dienste | `systemctl list-units --type=service` | `sc query` | `Get-Service` |
| Geplante Aufgaben | `crontab -l`, `systemctl list-timers` | `schtasks /query` | `Get-ScheduledTask` |

## Netzwerk

| Aufgabe | Linux | cmd | PowerShell |
|---|---|---|---|
| IP-Konfiguration | `ip a` | `ipconfig /all` | `Get-NetIPConfiguration` |
| Verbindungen | `ss -tulpn` | `netstat -ano` | `Get-NetTCPConnection` |
| Routen | `ip route` | `route print` | `Get-NetRoute` |
| DNS-Abfrage | `dig name` | `nslookup name` | `Resolve-DnsName name` |
| Port testen | `nc -zv host 443` | – | `Test-NetConnection host -Port 443` |

## Benutzer

| Aufgabe | Linux | cmd | PowerShell |
|---|---|---|---|
| Wer bin ich | `id`, `whoami` | `whoami /all` | `whoami /all` |
| Benutzer | `cat /etc/passwd` | `net user` | `Get-LocalUser` |
| Gruppen | `getent group` | `net localgroup` | `Get-LocalGroup` |
| Angemeldet | `w`, `last` | `query user` | `quser` |

> [!TIPP] Hilfe immer griffbereit
> Linux: `man befehl` / `befehl --help`. cmd: `befehl /?`. PowerShell: `Get-Help befehl -Examples`.

## Tiefer eingetaucht

Logs: Linux `journalctl`, `/var/log/`; Windows `wevtutil qe Security /c:5 /rd:true /f:text` oder `Get-WinEvent -LogName Security -MaxEvents 5`. Für Incident Response lohnen sich diese Befehle als kleine Skripte, die Ergebnisse mit Zeitstempel in eine Datei schreiben – wiederholbar und dokumentiert.

## Quiz

? Welcher Linux-Befehl zeigt lauschende Ports mit zugehörigen Prozessen?
= ss -tulpn
! Älteres Pendant: netstat -tulpn.

? Welcher Windows-Befehl zeigt Verbindungen mit Prozess-IDs?
= netstat -ano
! In PowerShell: Get-NetTCPConnection.

? Welches PowerShell-Cmdlet entspricht grep?
= Select-String
! Mit -Pattern für Suchmuster.

? Mit welchem PowerShell-Cmdlet testet man, ob ein Port erreichbar ist?
= Test-NetConnection
! Mit -Port für den Zielport.

?tf `whoami /all` zeigt unter Windows auch Gruppen und Privilegien.
= wahr
! Sehr nützlich für die Rechteeinschätzung.

? Welcher cmd-Befehl zeigt Windows-Dateiberechtigungen?
= icacls
! In PowerShell: Get-Acl.

? Wie fragt man in cmd die Hilfe zu einem Befehl ab?
= /?
! Zum Beispiel: dir /?.

@@@ MODULE @@@
---
id: wb-15
title: Web vertieft 15 · JWT richtig prüfen und einsetzen
paths: cwes, cwee
order: 43
difficulty: hard
icon: ticket
tags: web, jwt, authentifizierung
summary: Aufbau von JSON Web Tokens, typische Prüfungsfehler (alg none, Schlüsselverwechslung, fehlende Claims) und sichere Einsatzmuster.
---

## Einfach erklärt

Ein **JWT** ist wie ein Konzertarmband mit Hologramm: Darauf steht, wer du bist und was du darfst, und das Hologramm (die **Signatur**) beweist, dass es echt ist. Der Türsteher muss das Hologramm aber auch **wirklich prüfen** – sonst kann sich jeder ein Armband selbst basteln.

## Aufbau

`header.payload.signature` – jeweils Base64URL-kodiert:

```json
{"alg":"RS256","typ":"JWT","kid":"2026-key-1"}
{"sub":"anna","role":"user","iss":"https://login.example.com","aud":"shop-api","exp":1795000000,"iat":1794996400}
```

Wichtig: Der Inhalt ist **nicht verschlüsselt** – jeder kann ihn lesen. Keine Geheimnisse hineinschreiben.

## Häufige Prüfungsfehler

| Fehler | Folge |
|---|---|
| Signatur wird nicht geprüft (nur dekodiert) | beliebige Tokens werden akzeptiert |
| `alg: none` akzeptiert | unsignierte Tokens gelten |
| Algorithmus-Verwechslung (RS256 erwartet, HS256 akzeptiert mit öffentlichem Schlüssel als Geheimnis) | Angreifer signiert selbst |
| Schwaches HMAC-Geheimnis | offline erratbar |
| `exp`, `aud`, `iss` nicht geprüft | abgelaufene oder fremde Tokens gelten |
| `kid`/`jku`/`x5u` ungeprüft genutzt | Schlüssel aus Angreiferquelle |

> [!MERKE] Algorithmus festlegen, nicht aus dem Token übernehmen
> Der Server bestimmt, welcher Algorithmus und welcher Schlüssel gilt. Werte im Token-Header sind Angreifer-kontrolliert.

## Sicher einsetzen

1. Bewährte Bibliothek, Algorithmus und Schlüssel fest konfigurieren.
2. Alle Claims prüfen: Signatur, `exp`, `nbf`, `iss`, `aud`.
3. Kurze Gültigkeit für Access Tokens (Minuten), Refresh Tokens serverseitig verwalten und widerrufbar machen.
4. Asymmetrische Verfahren (RS256/ES256/EdDSA), wenn mehrere Dienste prüfen.
5. Im Browser: nicht in `localStorage` (XSS-Diebstahl), lieber HttpOnly-Cookie oder BFF-Muster.

## Tiefer eingetaucht

JWTs sind schwer zu widerrufen: Sie gelten bis `exp`, auch wenn der Nutzer sich abmeldet oder gesperrt wird. Lösungen: kurze Laufzeiten, Sperrlisten für `jti`, oder serverseitige Sessions für Webanwendungen (oft die einfachere, sicherere Wahl). JWTs spielen ihre Stärken eher zwischen Diensten aus (Service-zu-Service, OIDC-ID-Tokens).

## Quiz

? Aus welchen drei Teilen besteht ein JWT?
+ Header
+ Payload
+ Signatur
- Passwort
! Jeweils Base64URL-kodiert und durch Punkte getrennt.

?tf Der Inhalt eines JWT ist standardmäßig verschlüsselt.
= falsch
! Er ist nur kodiert – jeder kann ihn lesen.

? Was ist am Algorithmus `none` gefährlich?
+ unsignierte Tokens würden akzeptiert
- er ist zu langsam
- er funktioniert nur mit RSA
- er verschlüsselt doppelt
! Der Server muss den Algorithmus fest vorgeben.

? Welche Claims sollten immer geprüft werden?
+ exp
+ aud
+ iss
- color
! Plus Signatur und ggf. nbf.

? Warum sollten JWTs im Browser nicht in localStorage liegen?
+ XSS-Code kann sie dort auslesen
- localStorage ist zu klein
- localStorage ist verschlüsselt
- Browser löschen localStorage stündlich
! HttpOnly-Cookies sind für Skripte unsichtbar.

? Wie heißt der Angriff, bei dem ein Server mit RS256 auch HS256 akzeptiert und der öffentliche Schlüssel als HMAC-Geheimnis dient?
= Algorithmus-Verwechslung
= Algorithm Confusion
= Key Confusion
! Der Angreifer kann dann selbst gültige Signaturen erzeugen.

@@@ MODULE @@@
---
id: wb-16
title: Web vertieft 16 · OAuth 2.0 und OIDC sicher umsetzen
paths: cwes, cwee
order: 43.5
difficulty: hard
icon: arrow.triangle.2.circlepath.circle
tags: web, oauth, oidc
summary: Authorization Code Flow mit PKCE, Redirect-URI-Prüfung, state und nonce, Token-Speicherung und die häufigsten Implementierungsfehler.
---

## Einfach erklärt

Mit OAuth gibst du einer App einen **Parkschein statt deines Autoschlüssels**: Sie darf genau das, was auf dem Schein steht (z. B. „Kalender lesen“), nicht mehr. **OpenID Connect** ergänzt einen Ausweis (ID-Token), damit sich Apps darauf verlassen können, **wer** du bist.

## Der empfohlene Ablauf: Authorization Code + PKCE

1. App erzeugt einen zufälligen `code_verifier` und daraus die `code_challenge`.
2. Weiterleitung zum Identitätsanbieter mit `client_id`, `redirect_uri`, `scope`, `state`, `code_challenge` (bei OIDC zusätzlich `nonce`).
3. Nutzer meldet sich an und stimmt zu.
4. Rückleitung zur `redirect_uri` mit `code` und `state`.
5. App prüft `state`, tauscht `code` + `code_verifier` gegen Tokens.
6. App prüft ID-Token (Signatur, `iss`, `aud`, `exp`, `nonce`).

| Parameter | Schützt gegen |
|---|---|
| `state` | CSRF im Login-Ablauf |
| PKCE | abgefangene Codes (z. B. auf Mobilgeräten) |
| `nonce` | wiederverwendete ID-Tokens |
| exakte `redirect_uri` | Umleitung des Codes zum Angreifer |

> [!WARNUNG] Veraltete Flows
> Implicit Flow (Token direkt in der URL) und Resource Owner Password Credentials (App bekommt das Passwort) gelten nach OAuth 2.1 bzw. aktuellen Best Practices als veraltet.

## Häufige Fehler

- Redirect-URI mit Platzhaltern oder Präfixvergleich → Code landet beim Angreifer (oft kombiniert mit Open Redirect).
- `state` fehlt oder wird nicht geprüft.
- ID-Token nicht validiert, Nutzer anhand der E-Mail aus beliebigen Anbietern zugeordnet (Kontoübernahme).
- Zu weite Scopes, Tokens zu lange gültig.
- Client-Secrets in Mobil- oder Browser-Apps (dort gibt es keine Geheimnisse → PKCE, öffentlicher Client).

## Tiefer eingetaucht

Für Single-Page-Apps empfehlen aktuelle Leitfäden das **Backend-for-Frontend**-Muster: Ein schlankes Backend führt den OAuth-Ablauf aus und hält Tokens, der Browser bekommt nur ein HttpOnly-Session-Cookie. So können Tokens nicht per XSS gestohlen werden. Für hohe Schutzbedarfe gibt es **PAR** (Pushed Authorization Requests) und **DPoP** (Tokens an einen Client-Schlüssel gebunden).

## Quiz

? Welcher Flow wird heute für Web- und Mobile-Apps empfohlen?
+ Authorization Code Flow mit PKCE
- Implicit Flow
- Resource Owner Password Credentials
- Basic Auth
! PKCE schützt auch öffentliche Clients.

? Wogegen schützt der Parameter state?
= CSRF
= Cross-Site Request Forgery
! Er bindet die Rückleitung an die ursprüngliche Anfrage.

? Was ergänzt OpenID Connect gegenüber OAuth?
+ ein ID-Token zur Identität des Nutzers
- Verschlüsselung der Festplatte
- eine Firewall
- ein Passwortmanager
! OAuth regelt Berechtigungen, OIDC die Anmeldung.

?tf Redirect-URIs sollten exakt und nicht per Präfix verglichen werden.
= wahr
! Sonst kann der Code an eine Angreifer-URL umgeleitet werden.

? Warum haben Single-Page-Apps keine echten Client-Secrets?
+ alles im Browser ist für Nutzer einsehbar
- weil sie zu klein sind
- weil OAuth das verbietet
- weil Browser keine Strings speichern
! Deshalb öffentliche Clients mit PKCE oder BFF-Muster.

? Wie heißt das Muster, bei dem ein Backend Tokens hält und der Browser nur ein Session-Cookie bekommt?
= Backend-for-Frontend
= BFF
! Schützt Tokens vor XSS-Diebstahl.

@@@ MODULE @@@
---
id: wb-17
title: Web vertieft 17 · Datei-Uploads sicher implementieren
paths: cwes, cwee
order: 44
difficulty: medium
icon: square.and.arrow.up.on.square.fill
tags: web, upload
summary: Wie man Uploads gegen Webshells, Pfadmanipulation, XSS, Zip-Bomben und DoS absichert – Prüfung, Speicherung, Auslieferung.
---

## Einfach erklärt

Ein Upload-Formular ist ein Briefkasten, in den jeder etwas werfen kann. Wer nicht prüft, was hineinkommt, und es dann im eigenen Haus auslegt, lädt Probleme ein: ein „Bild“, das in Wahrheit ein Skript ist, oder eine Datei, die sich beim Öffnen tausendfach vervielfältigt.

## Die drei Phasen

### 1. Annehmen
- **Allowlist** erlaubter Typen (nicht Blocklist).
- Typ anhand des **Inhalts** prüfen (Magic Bytes/Bibliothek), nicht nur Endung oder `Content-Type`.
- **Größenlimit** und Rate-Limit.
- Archive: Anzahl und entpackte Größe begrenzen (Zip-Bomben), Pfade in Archiven prüfen (Zip Slip).

### 2. Speichern
- **Neuen, zufälligen Dateinamen** vergeben; Originalnamen nur als Metadatum.
- Außerhalb des Webroots bzw. in Objektspeicher.
- Keine Ausführungsrechte im Upload-Verzeichnis.
- Optional: Malware-Scan, Bilder neu rendern (entfernt eingebettete Inhalte und Metadaten).

### 3. Ausliefern
- Mit korrektem `Content-Type` und `X-Content-Type-Options: nosniff`.
- Für nutzergenerierte Inhalte `Content-Disposition: attachment` oder eine **eigene Domain** (Sandbox-Domain), damit hochgeladenes HTML/SVG keinen Zugriff auf die Hauptdomain hat.
- Zugriffskontrolle: Darf dieser Nutzer diese Datei sehen?

> [!GEFAHR] SVG und HTML
> SVG-Bilder können JavaScript enthalten. Werden sie auf der Hauptdomain direkt angezeigt, ist das gespeichertes XSS.

## Tiefer eingetaucht

Typische Umgehungen schwacher Prüfungen: doppelte Endungen (`bild.php.jpg`), Groß-/Kleinschreibung (`.PhP`), alternative ausführbare Endungen (`.phtml`, `.phar`), manipulierte `Content-Type`-Header, Polyglot-Dateien (gültiges Bild und gültiges Skript zugleich), Konfigurationsdateien (`.htaccess`, `web.config`). Die Kombination aus Inhaltsprüfung, Umbenennen, Speicherung ohne Ausführungsrechte und getrennter Auslieferungsdomain macht all das wirkungslos.

## Quiz

? Warum sollte man hochgeladenen Dateien einen neuen, zufälligen Namen geben?
+ um Pfadmanipulation und das Überschreiben oder Ausführen gezielt benannter Dateien zu verhindern
- damit sie kleiner werden
- damit sie schneller laden
- weil Dateinamen verboten sind
! Der Originalname bleibt nur als Metadatum.

? Woran sollte der Dateityp geprüft werden?
+ am tatsächlichen Inhalt (Magic Bytes)
- nur an der Endung
- nur am Content-Type-Header des Clients
- am Dateinamen allein
! Endung und Header sind vom Angreifer kontrollierbar.

?tf SVG-Dateien können JavaScript enthalten.
= wahr
! Auf der Hauptdomain angezeigt, entsteht XSS.

? Wie heißt die Schwachstelle, bei der Pfade in Archiven beim Entpacken Dateien außerhalb des Zielordners schreiben?
= Zip Slip
! Pfade wie ../../ im Archiv müssen abgelehnt werden.

? Warum liefert man Nutzer-Uploads gern von einer separaten Domain aus?
+ damit hochgeladene Inhalte keinen Zugriff auf Cookies und DOM der Hauptdomain haben
- weil es billiger ist
- weil Browser es verlangen
- damit Dateien größer sein dürfen
! Die Same-Origin-Policy trennt dann beide Bereiche.

? Was hilft gegen Zip-Bomben?
+ Limits für Anzahl und entpackte Größe
- längere Dateinamen
- schnellere Festplatten
- keine Prüfung
! Kleine Archive können sonst riesige Datenmengen erzeugen.

@@@ MODULE @@@
---
id: wb-18
title: Web vertieft 18 · Open Redirect, Host-Header und WebSockets
paths: cwes, cwee
order: 44.5
difficulty: medium
icon: arrowshape.turn.up.right.fill
tags: web, redirect, websocket
summary: Drei unterschätzte Bereiche – Weiterleitungen, Vertrauen in den Host-Header und die Sicherheit von WebSocket-Verbindungen.
---

## Einfach erklärt

Manche Lücken sind allein harmlos, aber hervorragende **Bausteine**: Eine offene Weiterleitung lässt einen Phishing-Link vertrauenswürdig aussehen; ein falsch genutzter Host-Header verbiegt Links in E-Mails; eine WebSocket-Verbindung ohne Prüfung umgeht CSRF-Schutz.

## Open Redirect

`https://shop.example.com/login?next=https://boese.example` – leitet nach dem Login auf eine fremde Seite.

- Folgen: glaubwürdiges Phishing, Diebstahl von OAuth-Codes, Umgehen von URL-Filtern.
- Abhilfe: nur **relative Pfade** oder eine **Allowlist** erlaubter Ziele; keine vollständigen URLs aus Parametern übernehmen. Achtung bei Tricks wie `//boese.example`, `/\boese.example`, `https:boese.example`.

## Host-Header

Anwendungen bauen oft absolute Links mit dem `Host`-Header der Anfrage – den der Client bestimmt.

- Folgen: Passwort-Reset-Links zur Angreiferdomain, Cache-Poisoning, Zugriff auf interne virtuelle Hosts.
- Abhilfe: feste Basis-URL in der Konfiguration, Webserver nur bekannte Hostnamen beantworten lassen (Default-vHost verwirft), `X-Forwarded-Host` nur von vertrauenswürdigen Proxies.

## WebSockets

Eine WebSocket-Verbindung beginnt mit einem HTTP-Upgrade, danach fließen Nachrichten in beide Richtungen.

| Risiko | Abhilfe |
|---|---|
| Cross-Site WebSocket Hijacking (Cookie-Authentifizierung, Origin nicht geprüft) | `Origin` beim Handshake prüfen, Token statt nur Cookie |
| Keine Autorisierung pro Nachricht | jede Aktion serverseitig prüfen |
| Injection in Nachrichten | wie jede Eingabe validieren/kodieren |
| Unverschlüsselt (`ws://`) | immer `wss://` |
| DoS durch viele Verbindungen | Limits pro Nutzer/IP |

> [!MERKE] Kleine Lücke, große Kette
> In Berichten lohnt sich bei Bausteinen wie Open Redirect die Frage: Mit welcher anderen Schwäche wird daraus ein ernstes Problem?

## Tiefer eingetaucht

Für Tests: Weiterleitungsparameter sammeln (`next`, `url`, `return`, `redirect`, `continue`), verschiedene Schreibweisen ausprobieren, im OAuth-Kontext prüfen, ob der Identitätsanbieter einen Pfad mit Open Redirect als `redirect_uri` akzeptiert. Bei WebSockets mit einem Proxy die Nachrichten mitschneiden und manipulieren – viele Anwendungen prüfen dort weniger streng als bei normalen HTTP-Endpunkten.

## Quiz

? Was ist ein Open Redirect?
+ eine Weiterleitung auf beliebige, vom Nutzer übergebene Ziele
- eine offene Firewall
- ein Server ohne Passwort
- ein kaputter Link
! Beliebt für glaubwürdiges Phishing und OAuth-Angriffe.

? Wie verhindert man Open Redirects am besten?
+ nur relative Pfade oder eine Allowlist erlaubter Ziele zulassen
- längere URLs verwenden
- Weiterleitungen per JavaScript statt HTTP
- den Parameter umbenennen
! Vollständige URLs nicht aus Parametern übernehmen.

?tf Absolute Links sollten aus dem Host-Header der Anfrage gebaut werden.
= falsch
! Der Host-Header ist vom Client kontrollierbar – feste Basis-URL nutzen.

? Was sollte beim WebSocket-Handshake geprüft werden?
= Origin
= Origin-Header
! Sonst ist Cross-Site WebSocket Hijacking möglich.

? Welches Schema sollten WebSocket-Verbindungen nutzen?
= wss
= wss://
! ws:// ist unverschlüsselt.

? Welche Parameter sind typische Kandidaten für Open Redirects?
+ next
+ redirect
+ return
- color
! Auch url, continue und returnTo.
