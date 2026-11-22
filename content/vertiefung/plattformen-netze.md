# Tiefer eingetaucht – Plattformen, Krypto, Netze

## cl-01 | Wie AWS entscheidet
Ein explizites Deny gewinnt immer, ohne Allow gilt Verweigern. SCPs und Permissions Boundaries **begrenzen**, sie erteilen nichts. Kontoübergreifend müssen in der Regel beide Seiten zustimmen. Das Management-Konto einer Organisation unterliegt SCPs nicht.

> [!PRAXIS] Denk weiter
> Rolle erlaubt s3:GetObject, trotzdem AccessDenied. Wo suchen? Bucket-Policy, SCP, Boundary, Session Policy, VPC-Endpoint-Policy und KMS-Schlüsselrichtlinie.

## cl-02 | Die Brücken zwischen den Rechtesystemen
Entra-Rollen und Azure RBAC sind getrennt, aber verbunden: Globale Admins können sich Zugriff auf Azure geben, Rechte auf einer VM erlauben die Nutzung ihrer Managed Identity. App-Besitzer können Anmeldedaten hinzufügen und damit als die App handeln.

> [!PRAXIS] Denk weiter
> „Contributor kann keine Rechte vergeben“, also harmlos? Nein: Er kann Code auf Ressourcen ausführen, deren Identität mehr darf.

## cl-03 | Was beim Start wirklich gilt
Tags sind veränderlich, Digests nicht. `USER` im Dockerfile lässt sich beim Start überschreiben. Veröffentlichte Ports umgehen unter Linux oft UFW-Regeln, weil Docker eigene Firewall-Ketten setzt: an 127.0.0.1 binden oder DOCKER-USER nutzen.

> [!PRAXIS] Denk weiter
> Mitglied der Gruppe docker, kein sudo. Wie viel Recht? Praktisch root, denn der Daemon kann Host-Verzeichnisse einbinden.

## cl-04 | Indirekte Rechte
Wer Pods in einem Namespace erstellen darf, kann deren Service Accounts und Secrets benutzen, auch ohne Leserecht auf Secrets. RBAC kennt kein Deny. NetworkPolicies wirken nur mit passendem CNI und erst, sobald eine den Pod auswählt.

> [!PRAXIS] Denk weiter
> `list secrets` ohne `get`: sicher? Nein, die Liste liefert die Inhalte mit.

## cl-05 | Privat ist nicht vertrauenswürdig
Private Endpunkte entfernen den Internetweg, nicht die Notwendigkeit von Autorisierung. Peering ist nicht transitiv, Hubs und Transit-Gateways können es dagegen werden. Egress-Filter auf IPs scheitern an geteilten Anbieteradressen, nötig sind Namen und Identitäten.

> [!PRAXIS] Denk weiter
> Nur dein VPC erreicht S3. Abfluss unmöglich? Nein, in fremde Buckets geht es, solange die Endpoint-Policy nicht auf eigene begrenzt.

## cl-06 | Ereignisse sind Eingaben
Funktionen werden von Queues, Dateinamen und Tabellenänderungen ausgelöst, jedes ist fremde Eingabe. Wiederverwendete Instanzen behalten globale Variablen und /tmp zwischen Aufrufen. Viele Auslöser liefern mindestens einmal, also idempotent verarbeiten.

> [!PRAXIS] Denk weiter
> IaC-Scan grün. Cloud sicher? Der Scan sieht Code, nicht Handänderungen und Laufzeitwerte. Drift und Konto prüfen.

## hd-01 | Nicht aussperren, aber prüfen
Bei OpenSSH gewinnt meist der **erste** Wert, eine Drop-in-Datei kann die Hauptdatei überstimmen. `sshd -T` zeigt das wirksame Ergebnis. Bei sysctl zählt der laufende Wert. Härtung wird mit zweiter offener Sitzung und Rückweg ausgerollt.

> [!PRAXIS] Denk weiter
> PasswordAuthentication no, trotzdem Passwortabfrage. Warum? Keyboard-interactive über PAM ist eine eigene Methode.

## hd-02 | Punktzahl und Schutz
95 % Benchmark können die entscheidenden 5 % auslassen. Level 2 kostet bewusst Funktion. Abweichungen gehören begründet und versioniert, gemessen wird am Client, denn GPO, MDM und lokale Werte können konkurrieren.

> [!PRAXIS] Denk weiter
> Kontosperre nach drei Fehlern: sicherer? Teils, aber jeder kann damit Konten aussperren. Höhere Schwelle, MFA und Erkennung sind ausgewogener.

## hd-03 | Verschlüsselt, aber wann?
Geräteverschlüsselung schützt am stärksten vor dem ersten Entsperren nach dem Start. Danach liegen Schlüssel für viele Daten im Speicher. MDM kann mächtig wie Root sein: Ein kompromittierter MDM-Admin verteilt Apps, Skripte oder Löschbefehle an alle.

> [!PRAXIS] Denk weiter
> BYOD oder verwaltet? Nach Daten: Für BYOD App- oder Profil-Trennung ohne Privatzugriff, für Admin-Arbeit verwaltete Geräte.

## hd-04 | Drei Ebenen, drei Ausfälle
Eine ACL auf Durchgangsverkehr schützt das Gerät selbst nicht unbedingt: Pakete an die Control Plane brauchen eigene Filter und Raten. Zentrale Anmeldung braucht ein geschütztes lokales Notfallkonto, sonst sperrt ein RADIUS-Ausfall alle aus.

> [!PRAXIS] Denk weiter
> Konfiguration unverändert seit Monaten. Integer? Nur diese Datei. Startkonfiguration, Firmware-Image und Boot-Parameter prüfen.

## kr-01 | Grenzen von AEAD
AES-GCM verlangt eindeutige Nonces je Schlüssel. Eine Wiederholung legt XOR der Klartexte offen und ermöglicht Fälschungen. Bei zufälligen 96-Bit-Nonces sollte ein Schlüssel höchstens 2³² Verschlüsselungen tragen. AEAD schützt auch nicht vor Replay.

> [!PRAXIS] Denk weiter
> Zähler als Nonce, VM-Snapshot zurückgesetzt. Gefahr? Nonce-Wiederholung. Neuer Sitzungsschlüssel oder missbrauchsresistentes Verfahren wie AES-GCM-SIV.

## kr-02 | Die Parameter gehören dazu
RSA ohne Padding ist formbar, sicher sind OAEP zum Verschlüsseln und PSS zum Signieren. ECDSA mit wiederholter Zufallszahl k verrät den privaten Schlüssel. Diffie-Hellman authentifiziert niemanden, dafür braucht es Signatur oder PSK.

> [!PRAXIS] Denk weiter
> RSA 2048 oder ECC 256? ECC P-256 liegt bei etwa 128 Bit Sicherheit, RSA-2048 bei etwa 112. Schlüssellängen verschiedener Verfahren sind nicht vergleichbar.

## kr-03 | Vertrauen hat Namen und Grenzen
Gültigkeit heißt: Kette, Zeit, Verwendungszweck, Name und Sperrstatus passen. Eine interne CA ohne Name Constraints kann für jede Domain ausstellen. Die Root bleibt offline, ihre CRL muss trotzdem rechtzeitig erneuert werden.

> [!PRAXIS] Denk weiter
> CRL abgelaufen, kein Zertifikat gesperrt. Folge? Strikte Prüfer lehnen alles ab: ein Totalausfall.

## kr-04 | Wann ist zu spät?
Mosca-Regel: Ist Geheimhaltungsdauer X plus Migrationsdauer Y größer als die Zeit Z bis zum relevanten Quantencomputer, bist du zu spät. FIPS 203 (ML-KEM), 204 (ML-DSA) und 205 (SLH-DSA) sind seit August 2024 veröffentlicht. Größere Schlüssel sprengen Puffer und Paketgrößen.

> [!PRAXIS] Denk weiter
> X 15 Jahre, Y 5, Z geschätzt 15. Handeln? Ja, 20 > 15, zuerst beim Schlüsselaustausch.

## kr-05 | Fehler ohne falsche Mathematik
Padding-Orakel, Timing und Downgrade nutzen das **Verhalten**: unterschiedliche Fehler, Dauer oder akzeptierte Optionen. Gegenmittel sind einheitliche Fehler, Vergleich in konstanter Zeit, feste Algorithmen und negative Testvektoren.

> [!PRAXIS] Denk weiter
> Warum übersieht ein Round-trip-Test alles? Er prüft nur, dass Eigenes wieder lesbar ist. Verändertes Tag, falscher Schlüssel und wiederholte Nachricht müssen scheitern.

## lx-01 | Namen und Inodes
Ein Dateiname ist ein Verweis auf einen Inode. Hardlinks teilen ihn, Symlinks speichern einen Pfad. `mv` im selben Dateisystem ist atomares Umbenennen, dazwischen Kopieren und Löschen. Globs erweitert die Shell, bevor das Programm startet.

> [!PRAXIS] Denk weiter
> Datei heißt `-rf`. Wie löschen? `rm -- -rf` oder `rm ./-rf`. Für beliebige Namen: `find -print0 | xargs -0`.

## lx-02 | Pipelines, die still irren
`uniq` zählt nur benachbarte Duplikate. Sortierung hängt von der Locale ab. `sort file > file` leert die Datei, bevor sort liest. In einer Pipe zählt ohne `pipefail` nur der letzte Exit-Code.

> [!PRAXIS] Denk weiter
> `grep x log | wc -l` ergibt 0. Keine Treffer? Oder grep konnte nicht lesen, oder das Log ist rotiert oder komprimiert. Kontrollmuster testen.

## lx-03 | Die ACL-Maske
Bei gesetzter ACL zeigt die Gruppenspalte die **Maske**, die benannte Einträge begrenzt. Ein chmod kann so ACLs entwerten. Die erste passende Klasse gilt: Eigentümer mit 077 hat keinen Zugriff, obwohl andere dürfen. sudo-Regeln auf Editoren oder Interpreter sind meist volle Root-Rechte.

> [!PRAXIS] Denk weiter
> In Gruppe aufgenommen, kein Zugriff. Warum? Laufende Prozesse behalten alte Gruppen. Neu anmelden.

## lx-04 | Wer überwacht wen?
systemd verfolgt Dienste über cgroups, nicht nur PIDs. Zustand D wartet im Kernel, oft auf I/O, und reagiert nicht auf SIGKILL. Zombies sind fertig und warten auf ihren Elternprozess. cron hat minimale Umgebung.

> [!PRAXIS] Denk weiter
> Verdächtigen Prozess sofort killen? Erst exe, cmdline, Umgebung, Verbindungen und cgroup sichern. Er könnte neu starten.

## lx-05 | Die Entscheidung des Kernels
`ip route get ZIEL` zeigt Route und Quelladresse, die wirklich benutzt würden, samt Policy Routing. `ss` zeigt Sockets des aktuellen Netzwerk-Namespace, Container fehlen. 0.0.0.0 heißt alle IPv4-Adressen, nicht öffentlich erreichbar.

> [!PRAXIS] Denk weiter
> Pakete in tcpdump, Anwendung sieht nichts. Möglich? Ja, tcpdump greift eingehend vor der Firewall ab. Regeln, rp_filter und Bindung prüfen.

## lx-06 | Was die Signatur sichert
APT prüft die Signatur der Repository-Metadaten, die Hashes der Pakete enthalten. Das belegt Herkunft vom Schlüsselinhaber, nicht Gutartigkeit, Maintainer-Skripte laufen als root. `signed-by` begrenzt Schlüssel je Quelle.

> [!PRAXIS] Denk weiter
> Bibliothek aktualisiert, noch verwundbar? Laufende Prozesse halten die alte. needrestart prüfen, Dienste neu starten.

## lx-07 | Vertrauen in lokale Logs
root kann lokale Logs verändern, Beweiskraft entsteht durch zeitnahe Weiterleitung. Im Journal setzt journald Felder mit Unterstrich (`_UID`, `_EXE`) selbst, MESSAGE bestimmt der Sender. Jeder Benutzer kann mit logger Einträge schreiben.

> [!PRAXIS] Denk weiter
> Logs reichen nur zwei Tage. Manipulation? Vielleicht nur Volatilität in /run, Größenlimit oder Flut. Boots und Limits prüfen.

## lx-08 | Was set -e verschweigt
`set -e` greift nicht in if-Bedingungen, vor && und in Funktionen, die dort aufgerufen werden. `local x=$(cmd)` verschluckt den Fehler von cmd. Kritische Schritte brauchen explizite Prüfung, trap räumt auf, flock verhindert Parallelstarts.

> [!PRAXIS] Denk weiter
> Warum ist `for f in $(ls)` falsch? Namen werden an Leerraum zerlegt und als Glob gedeutet. `for f in ./*` verwenden.

## nw-01 | Wissen des Switches
Ein Switch lernt aus Quell-MACs und flutet Unbekanntes. Altert ein Eintrag vor dem ARP-Cache des Routers, entsteht Unicast-Flooding. Moderne Telefone randomisieren MACs, die Adresse ist keine Identität.

> [!PRAXIS] Denk weiter
> 1518-Byte-Rahmen, 1500 MTU, Widerspruch? Nein: 14 Header plus 4 FCS. Mit VLAN-Tag 1522.

## nw-02 | Trennung ist Konfiguration
VLANs trennen Schicht 2, jedes Gerät mit Bein in beiden hebt das auf. STP schützt vor Schleifen, vertraut aber BPDUs: BPDU Guard am Rand, Root Guard nach unten. Native VLAN ungenutzt lassen, DTP aus.

> [!PRAXIS] Denk weiter
> Zwei VLANs, ein Router ohne ACL. Segmentiert? Nur Broadcasts. IP-Verkehr fließt frei.

## nw-03 | Spezifischer gewinnt
Zuerst zählt Präfixlänge, erst bei gleicher Länge Distanz und Metrik. Darum zieht ein fälschlich angekündigtes /24 Verkehr aus einem /16. RPKI bestätigt den Ursprungs-AS, nicht den gesamten Pfad.

> [!PRAXIS] Denk weiter
> Ping einseitig erfolgreich, stateful Firewall verwirft TCP. Ursache? Asymmetrisches Routing: Der Rückweg trifft nicht dieselbe Zustandstabelle.

## nw-04 | Parallelwelt
Windows und Linux haben IPv6 aktiv, auch in „reinen IPv4-Netzen“. Ohne RA Guard kann ein Gerät zum Router werden. Privacy-Adressen wechseln, für Zuordnung braucht man Neighbor-Tabellen. Fragmentieren darf nur der Absender.

> [!PRAXIS] Denk weiter
> ICMPv6 komplett blockiert: was bricht? Nachbarauflösung, Autokonfiguration und Path MTU Discovery.

## nw-05 | Zustand und Erkennung
Die NGFW muss erste Pakete durchlassen, bevor sie die Anwendung kennt. Ohne TLS-Inspektion sieht sie Metadaten. Die Zustandstabelle ist endlich, und nach Regeländerungen laufen bestehende Sitzungen oft weiter.

> [!PRAXIS] Denk weiter
> Blockregel gesetzt, C2 sendet weiter. Was fehlt? Zustände löschen und Reihenfolge, IPv6 sowie andere Wege prüfen.

## nw-06 | Dienste, denen alle glauben
NTP schätzt den Versatz mit vier Zeitstempeln und unterstellt symmetrische Laufzeit. Syslog über UDP geht still verloren, auch TCP garantiert keine Verarbeitung. Bei SNMPv3 schützt nur authPriv Inhalt und Echtheit.

> [!PRAXIS] Denk weiter
> Zwei Zeitquellen widersprechen sich. Welche stimmt? Nicht entscheidbar, deshalb mindestens drei, besser vier.

## nw-07 | Halbieren statt raten
Teile die Strecke: Kommt das Paket in der Mitte an? Jeder Test halbiert den Suchraum. Zwei gleichzeitige Mitschnitte trennen Verlust von Nichtantwort. Ändere eine Sache je Schritt und nimm sie zurück, wenn sie nichts bewirkt.

> [!PRAXIS] Denk weiter
> Connection refused gegen Timeout? Refused heißt, etwas antwortete (meist kein Listener). Timeout heißt Schweigen: Filter, Route, Rückweg.

## nw-08 | Wo die Abwehr stehen muss
Eine volle Leitung lässt sich nicht an ihrem Ende filtern. Drei Einheiten zählen: Bit/s für Leitungen, Pakete/s für Geräte, Anfragen/s für Anwendungen. Scrubbing hilft nicht, wenn die Ursprungs-IP direkt erreichbar ist.

> [!PRAXIS] Denk weiter
> Blackholing aktiviert: Was ist erreicht? Das übrige Netz lebt, das Ziel ist vollständig offline, bewusst.
