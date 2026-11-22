# NIMA-Lexikon: Cloud, Kryptografie, WLAN/Funk, OT

## Shared Responsibility
aka: Modell der geteilten Verantwortung
kat: Cloud
kurz: Aufteilung der Sicherheitsverantwortung zwischen Cloud-Anbieter und Kunde.
Identitäten, Daten und Konfiguration liegen immer beim Kunden.

## IaaS
aka: Infrastructure as a Service
kat: Cloud
kurz: Cloud-Modell, bei dem virtuelle Server, Netze und Speicher gemietet werden.

## PaaS
aka: Platform as a Service
kat: Cloud
kurz: Cloud-Modell, bei dem eine Plattform (z. B. Datenbank, App-Laufzeit) bereitgestellt wird.

## SaaS
aka: Software as a Service
kat: Cloud
kurz: Fertige Anwendung aus der Cloud, z. B. E-Mail oder CRM.

## Serverless
aka: Function as a Service, FaaS
kat: Cloud
kurz: Ausführung einzelner Funktionen ohne Serververwaltung; Abrechnung pro Aufruf.

## Objektspeicher
aka: Object Storage, Bucket, S3
kat: Cloud
kurz: Cloud-Speicher für Dateien als Objekte in Buckets; öffentliche Freigaben sind eine häufige Leckquelle.

## Pre-Signed URL
aka: signierte URL
kat: Cloud
kurz: Zeitlich begrenzter, signierter Link auf ein einzelnes Objekt – sichere Alternative zu öffentlichen Freigaben.

## Metadatendienst
aka: IMDS, Instance Metadata Service
kat: Cloud
kurz: Interner Dienst einer Cloud-VM, der u. a. temporäre Zugangsdaten liefert (169.254.169.254).
IMDSv2 erschwert Missbrauch über SSRF.

## STS
aka: Security Token Service
kat: Cloud
kurz: AWS-Dienst, der temporäre Zugangsdaten ausstellt, z. B. beim Annehmen einer Rolle.

## Assume Role
kat: Cloud
kurz: Annehmen einer IAM-Rolle mit temporären Zugangsdaten.

## Workload Identity
aka: Workload Identity Federation
kat: Cloud
kurz: Authentifizierung von Workloads über ihre Identität statt gespeicherter Schlüssel.
siehe: Managed Identity

## CSPM
aka: Cloud Security Posture Management
kat: Cloud
kurz: Kontinuierliche Prüfung von Cloud-Konfigurationen auf Fehlkonfigurationen.

## CWPP
aka: Cloud Workload Protection Platform
kat: Cloud
kurz: Schutz von VMs, Containern und Serverless-Funktionen zur Laufzeit.

## CNAPP
aka: Cloud-Native Application Protection Platform
kat: Cloud
kurz: Kombination von CSPM, CWPP, CIEM u. a. mit Kontext zu Angriffspfaden.

## CIEM
aka: Cloud Infrastructure Entitlement Management
kat: Cloud
kurz: Analyse und Reduktion überprivilegierter Cloud-Identitäten.

## CASB
aka: Cloud Access Security Broker
kat: Cloud
kurz: Kontrolle und Überwachung der Nutzung von Cloud-Diensten.

## SASE
aka: Secure Access Service Edge, SSE
kat: Cloud
kurz: Netzwerk- und Sicherheitsfunktionen als Cloud-Dienst nahe am Nutzer.

## Policy as Code
kat: Cloud
kurz: Sicherheitsregeln als versionierter Code, automatisch durchgesetzt.

## Drift
aka: Konfigurationsdrift
kat: Cloud
kurz: Abweichung zwischen beschriebener (Code) und tatsächlicher Konfiguration.

## Denial of Wallet
kat: Cloud
kurz: Angriff, der durch automatische Skalierung hohe Kosten verursacht.

## Region
aka: Cloud-Region
kat: Cloud
kurz: Geografischer Standort eines Cloud-Anbieters mit mehreren Verfügbarkeitszonen.

## Verfügbarkeitszone
aka: Availability Zone, AZ
kat: Cloud
kurz: Physisch getrenntes Rechenzentrum innerhalb einer Region.

## GuardDuty
kat: Cloud
kurz: AWS-Dienst zur Bedrohungserkennung auf Basis von Logs und Netzwerkdaten.

## Defender for Cloud
kat: Cloud
kurz: Microsoft-Dienst für Cloud-Sicherheitsbewertung und Workload-Schutz.

## Security Command Center
kat: Cloud
kurz: Sicherheitszentrale von Google Cloud.

## VPC
aka: Virtual Private Cloud, VNet
kat: Cloud
kurz: Isoliertes virtuelles Netz in der Cloud.

## Security Group
aka: Netzwerksicherheitsgruppe, NSG
kat: Cloud
kurz: Zustandsbehaftete Firewall-Regeln für Cloud-Ressourcen.

## Private Endpoint
aka: PrivateLink
kat: Cloud
kurz: Zugriff auf Cloud-Dienste über private Adressen statt über das Internet.

## KMS
aka: Key Management Service
kat: Kryptografie
kurz: Dienst zur sicheren Erzeugung, Speicherung und Nutzung von Schlüsseln.

## HSM
aka: Hardware Security Module, Hardware-Sicherheitsmodul
kat: Kryptografie
kurz: Spezialhardware, die Schlüssel sicher erzeugt und nicht exportierbar speichert.

## Envelope Encryption
kat: Kryptografie
kurz: Daten mit Datenschlüssel verschlüsseln, Datenschlüssel mit Hauptschlüssel im KMS/HSM.

## BYOK
aka: Bring Your Own Key
kat: Kryptografie
kurz: Kunde bringt eigene Schlüssel in einen Cloud-KMS ein.

## Krypto-Agilität
aka: Crypto Agility
kat: Kryptografie
kurz: Fähigkeit, Algorithmen und Schlüssel ohne große Umbauten auszutauschen.

## Symmetrische Verschlüsselung
kat: Kryptografie
kurz: Verschlüsselung mit demselben Schlüssel für Ver- und Entschlüsselung, z. B. AES.

## Asymmetrische Verschlüsselung
aka: Public-Key-Kryptografie
kat: Kryptografie
kurz: Verfahren mit öffentlichem und privatem Schlüssel, z. B. RSA, ECC.

## Öffentlicher Schlüssel
aka: Public Key
kat: Kryptografie
kurz: Frei verteilbarer Teil eines Schlüsselpaars zum Verschlüsseln oder Prüfen von Signaturen.

## Privater Schlüssel
aka: Private Key
kat: Kryptografie
kurz: Geheimer Teil eines Schlüsselpaars zum Entschlüsseln oder Signieren.

## Digitale Signatur
kat: Kryptografie
kurz: Kryptografischer Nachweis von Herkunft und Unverändertheit von Daten.

## HMAC
kat: Kryptografie
kurz: Nachrichtenauthentifizierungscode auf Basis einer Hashfunktion und eines geheimen Schlüssels.

## AES-GCM
aka: GCM
kat: Kryptografie
kurz: Authentifizierte Verschlüsselung mit AES; Nonces dürfen pro Schlüssel nie wiederholt werden.

## ChaCha20-Poly1305
kat: Kryptografie
kurz: Moderne authentifizierte Stromverschlüsselung, schnell auch ohne Hardware-AES.

## ECB
aka: Electronic Codebook
kat: Kryptografie
kurz: Unsicherer Betriebsmodus, der gleiche Blöcke gleich verschlüsselt und Muster verrät.

## Nonce
kat: Kryptografie
kurz: „Number used once“ – Wert, der pro Verschlüsselung mit einem Schlüssel einzigartig sein muss.

## IV
aka: Initialisierungsvektor
kat: Kryptografie
kurz: Startwert für Betriebsmodi, oft zufällig und nicht geheim.

## CSPRNG
aka: kryptografisch sicherer Zufallsgenerator
kat: Kryptografie
kurz: Zufallsgenerator, dessen Ausgaben nicht vorhersagbar sind.

## Entropie
kat: Kryptografie
kurz: Maß für Unvorhersagbarkeit bzw. Zufälligkeit.

## Argon2
aka: Argon2id
kat: Kryptografie
kurz: Speicherharter Passwort-Hash, Gewinner der Password Hashing Competition.

## scrypt
kat: Kryptografie
kurz: Speicherhartes Verfahren zur Schlüsselableitung und Passwortspeicherung.

## PBKDF2
kat: Kryptografie
kurz: Iterationsbasierte Schlüsselableitung; nur mit vielen Iterationen für Passwörter geeignet.

## Pepper
kat: Kryptografie
kurz: Geheimer Zusatzwert beim Passwort-Hashing, außerhalb der Datenbank gespeichert.

## Length-Extension-Angriff
kat: Kryptografie
kurz: Angriff auf naive „Hash(geheim||nachricht)“-Konstruktionen; HMAC verhindert ihn.

## Kollision
aka: Hash-Kollision
kat: Kryptografie
kurz: Zwei verschiedene Eingaben mit gleichem Hashwert.

## SHA-256
kat: Kryptografie
kurz: Verbreitete, sichere Hashfunktion der SHA-2-Familie.

## MD5
kat: Kryptografie
kurz: Veraltete Hashfunktion mit trivialen Kollisionen – nicht mehr für Sicherheit verwenden.

## SHA-1
kat: Kryptografie
kurz: Veraltete Hashfunktion, praktisch gebrochen seit 2017.

## Ed25519
kat: Kryptografie
kurz: Moderne Signatur auf Basis elliptischer Kurven, u. a. für SSH-Schlüssel empfohlen.

## Post-Quanten-Kryptografie
aka: PQC
kat: Kryptografie
kurz: Verfahren, die auch gegen Quantencomputer sicher sein sollen, z. B. ML-KEM und ML-DSA.

## ML-KEM
aka: Kyber
kat: Kryptografie
kurz: Standardisierter Post-Quanten-Schlüsselaustausch.

## Harvest now, decrypt later
kat: Kryptografie
kurz: Strategie, heute verschlüsselte Daten zu speichern und später mit Quantencomputern zu entschlüsseln.

## S/MIME
kat: Kryptografie
kurz: Standard für signierte und verschlüsselte E-Mails mit Zertifikaten.

## OpenPGP
aka: PGP, GPG
kat: Kryptografie
kurz: Standard für E-Mail- und Dateiverschlüsselung mit selbst verwalteten Schlüsseln.

## Ende-zu-Ende-Verschlüsselung
aka: E2EE
kat: Kryptografie
kurz: Nur Absender und Empfänger können Inhalte lesen – auch der Dienstanbieter nicht.

## Transportverschlüsselung
kat: Kryptografie
kurz: Verschlüsselung nur auf dem Übertragungsweg, z. B. TLS zwischen Servern.

## ACME
kat: Kryptografie
kurz: Protokoll zur automatischen Ausstellung und Erneuerung von Zertifikaten.

## Certificate Pinning
aka: Pinning
kat: Kryptografie
kurz: Festlegen erwarteter Zertifikate oder Schlüssel in einer Anwendung.

## mTLS
aka: Mutual TLS
kat: Kryptografie
kurz: TLS mit gegenseitiger Authentifizierung per Zertifikat.

## dBm
kat: WLAN
kurz: Logarithmisches Maß für Signalleistung; −50 dBm ist stärker als −80 dBm.

## RSSI
kat: WLAN
kurz: Vom Gerät gemessene Empfangsstärke.

## SNR
aka: Signal-Rausch-Abstand
kat: WLAN
kurz: Abstand zwischen Nutzsignal und Rauschen in dB.

## BSSID
kat: WLAN
kurz: Hardwareadresse eines Access Points bzw. einer Funkzelle.
siehe: SSID

## Beacon-Frame
aka: Beacon (WLAN)
kat: WLAN
kurz: Regelmäßige Ankündigung eines Access Points mit SSID und Fähigkeiten.

## Probe Request
kat: WLAN
kurz: Anfrage eines Clients nach verfügbaren oder bekannten Netzen.

## Deauthentication
aka: Deauth
kat: WLAN
kurz: Management-Frame zum Trennen einer Verbindung; ohne PMF fälschbar.

## Monitor-Modus
aka: Monitor Mode
kat: WLAN
kurz: Betriebsart einer WLAN-Karte, in der alle Frames eines Kanals empfangen werden.

## 4-Way-Handshake
kat: WLAN
kurz: Austausch zur Ableitung der Sitzungsschlüssel bei WPA2/WPA3.

## SAE
aka: Simultaneous Authentication of Equals, Dragonfly
kat: WLAN
kurz: Schlüsselaustausch von WPA3-Personal, der Offline-Raten des Passworts verhindert.

## WPS
aka: Wi-Fi Protected Setup
kat: WLAN
kurz: Vereinfachte WLAN-Einrichtung; die PIN-Methode ist angreifbar und sollte aus sein.

## OFDMA
kat: WLAN
kurz: Aufteilung eines Kanals in Ressourceneinheiten für mehrere Clients gleichzeitig (Wi-Fi 6).

## Wi-Fi 7
aka: 802.11be
kat: WLAN
kurz: WLAN-Generation mit 320-MHz-Kanälen und Multi-Link Operation.

## DFS
aka: Dynamic Frequency Selection
kat: WLAN
kurz: Pflicht im 5-GHz-Band, bei Radar den Kanal zu wechseln.

## Roaming
kat: WLAN
kurz: Wechsel eines Clients zwischen Access Points; beschleunigt durch 802.11r/k/v.

## PEAP
kat: WLAN
kurz: EAP-Verfahren mit TLS-Tunnel, meist mit MSCHAPv2; ohne Zertifikatsprüfung angreifbar.

## EAP-TLS
kat: WLAN
kurz: EAP-Verfahren mit Zertifikaten auf Client- und Serverseite – sehr sicher.

## RadSec
kat: WLAN
kurz: RADIUS über TLS zur Absicherung der Verbindung zwischen AP und RADIUS-Server.

## Private PSK
aka: Identity PSK, PPSK
kat: WLAN
kurz: Eigenes WLAN-Passwort pro Gerät oder Gruppe, einzeln widerrufbar.

## Client-Isolation
kat: WLAN
kurz: Verhindert direkte Kommunikation zwischen Clients im selben WLAN.

## Spektrumanalyse
kat: WLAN
kurz: Messung aller Funksignale eines Bandes zur Erkennung von Störquellen.

## Jamming
aka: Störsender
kat: WLAN
kurz: Gezielte Funkstörung zur Unterbrechung der Kommunikation; in Deutschland verboten.

## Bluetooth Low Energy
aka: BLE
kat: WLAN
kurz: Energiesparende Bluetooth-Variante für Wearables, Tracker und IoT.

## Zigbee
kat: WLAN
kurz: Mesh-Funkprotokoll für Smart-Home- und IoT-Geräte.

## LoRaWAN
aka: LoRa
kat: WLAN
kurz: Funktechnik für große Reichweiten bei geringer Datenrate, z. B. für Sensoren.

## NFC
aka: Near Field Communication
kat: WLAN
kurz: Nahfeldfunk über wenige Zentimeter, z. B. für kontaktloses Bezahlen.

## RFID
kat: WLAN
kurz: Funkerkennung über Transponder, z. B. in Zutrittskarten; alte Varianten leicht kopierbar.

## Relay-Angriff
kat: Angriffsklassen
kurz: Verlängerung einer Funk- oder Protokollverbindung über Distanz, z. B. bei schlüssellosen Autos.

## SDR
aka: Software Defined Radio
kat: Werkzeuge
kurz: Funkempfänger/-sender, dessen Signalverarbeitung per Software erfolgt.

## SPS
aka: PLC, speicherprogrammierbare Steuerung
kat: OT
kurz: Industriesteuerung, die zyklisch Sensoren liest und Aktoren schaltet.

## Leitstand
aka: Leitwarte
kat: OT
kurz: Zentrale Stelle zur Überwachung und Steuerung industrieller Prozesse.

## Engineering-Workstation
kat: OT
kurz: Rechner zur Programmierung von Steuerungen – besonders schützenswert.

## SIS
aka: Safety Instrumented System, Sicherheitssteuerung
kat: OT
kurz: Unabhängiges System, das Anlagen bei Gefahr sicher abschaltet.

## Safety
aka: funktionale Sicherheit
kat: OT
kurz: Schutz von Menschen und Umwelt vor Gefahren durch Anlagen – in OT oberste Priorität.

## Feldbus
kat: OT
kurz: Kommunikationssystem zwischen Steuerungen, Sensoren und Aktoren (z. B. PROFIBUS).

## PROFINET
kat: OT
kurz: Industrielles Ethernet-Protokoll, verbreitet im Siemens-Umfeld.

## EtherNet/IP
aka: CIP
kat: OT
kurz: Industrielles Ethernet-Protokoll auf Basis des Common Industrial Protocol.

## IEC 61850
kat: OT
kurz: Kommunikationsstandard für Schaltanlagen in der Energietechnik.

## RTU
aka: Remote Terminal Unit
kat: OT
kurz: Fernwirkgerät, das entfernte Anlagenteile mit der Leitstelle verbindet.

## Industrie-DMZ
aka: Ebene 3.5
kat: OT
kurz: Pufferzone zwischen Unternehmens-IT und Produktionsnetz.

## Zone und Conduit
aka: Zonen und Conduits
kat: OT
kurz: Begriffe aus IEC 62443: Bereiche gleichen Schutzbedarfs und kontrollierte Verbindungen dazwischen.

## Security Level
aka: SL
kat: OT
kurz: Schutzstufe 1–4 nach IEC 62443, vom Schutz gegen Fehler bis gegen hochmotivierte Angreifer.

## B3S
aka: Branchenspezifischer Sicherheitsstandard
kat: Recht
kurz: Branchenstandard zur Umsetzung von KRITIS-Anforderungen, z. B. für Wasser oder Energie.

## Stuxnet
kat: OT
kurz: Bekannte Schadsoftware, die SPS-Logik manipulierte und Zentrifugen beschädigte.

## IIoT
aka: Industrial Internet of Things
kat: OT
kurz: Vernetzte industrielle Geräte und Sensoren, oft mit Cloud-Anbindung.
