---
id: cx-01
title: Cloud vertieft 1 · Shared Responsibility und Cloud-Grundbegriffe
paths: specialist, grundlagen, cdsa
order: 70.1
difficulty: easy
icon: cloud.sun.fill
tags: cloud, grundlagen
summary: Wer in IaaS, PaaS und SaaS wofür verantwortlich ist, wie Konten, Regionen und Ressourcen organisiert sind und wo die typischen Missverständnisse liegen.
---

## Einfach erklärt

Cloud ist wie Wohnen zur Miete: Der Vermieter kümmert sich um Fundament, Dach und Leitungen, du um deine Wohnungstür und was in der Wohnung passiert. Wie viel du selbst machst, hängt vom Mietmodell ab – möbliert oder leer, mit oder ohne Reinigung.

## Wer ist wofür verantwortlich?

| Bereich | IaaS (z. B. VM) | PaaS (z. B. Datenbankdienst) | SaaS (z. B. M365) |
|---|---|---|---|
| Physik, Rechenzentrum | Anbieter | Anbieter | Anbieter |
| Hypervisor, Netzwerk-Hardware | Anbieter | Anbieter | Anbieter |
| Betriebssystem, Patches | **Kunde** | Anbieter | Anbieter |
| Anwendung | **Kunde** | **Kunde** (Code/Konfiguration) | Anbieter |
| Identitäten und Zugriffe | **Kunde** | **Kunde** | **Kunde** |
| Daten und Konfiguration | **Kunde** | **Kunde** | **Kunde** |

> [!MERKE] Identität, Konfiguration und Daten bleiben immer beim Kunden
> Die meisten Cloud-Vorfälle entstehen nicht durch Fehler des Anbieters, sondern durch falsch konfigurierte Zugriffe und gestohlene Zugangsdaten.

## Organisation

- **Konten/Abonnements/Projekte** als Grenzen (AWS Accounts, Azure Subscriptions, GCP Projects).
- **Organisation/Management Groups** mit zentralen Richtlinien (z. B. SCPs, Azure Policy).
- **Regionen und Zonen** für Verfügbarkeit und Datenstandort.
- **Landing Zone**: vorbereitete, sichere Grundstruktur mit Logging, Netz, Identität.

## Tiefer eingetaucht

Ein bewährtes Muster ist die **Mehrkonten-Strategie**: getrennte Konten für Produktion, Entwicklung, Sicherheit/Logging und Shared Services. Ein kompromittiertes Entwicklungskonto erreicht dann nicht automatisch die Produktion. Zentrale Logs landen in einem eigenen Sicherheitskonto, auf das Workload-Admins keinen Schreibzugriff haben.

Typische Missverständnisse: „Der Anbieter macht Backups“ (nicht unbedingt für deine Daten in deiner Konfiguration), „Standardeinstellungen sind sicher“ (nicht immer), „In der Cloud gibt es keine Server zu patchen“ (bei IaaS sehr wohl).

## Quiz

? Wer ist bei IaaS für das Patchen des Betriebssystems verantwortlich?
= Kunde
= der Kunde
! Bei IaaS stellt der Anbieter nur die virtuelle Maschine bereit.

? Wofür ist der Kunde in jedem Cloud-Modell verantwortlich?
+ Identitäten und Zugriffe
+ seine Daten
+ seine Konfiguration
- das physische Rechenzentrum
! Diese drei Bereiche bleiben immer beim Kunden.

?tf Die meisten Cloud-Vorfälle entstehen durch Fehlkonfiguration und gestohlene Zugangsdaten.
= wahr
! Nicht durch Lücken beim Anbieter.

? Wie nennt man eine vorbereitete, sichere Cloud-Grundstruktur?
= Landing Zone
! Mit Kontenstruktur, Logging, Netz und Identität.

? Warum trennt man Produktion und Entwicklung in verschiedene Konten?
+ damit ein kompromittiertes Konto nicht automatisch alles erreicht
- weil es billiger ist
- weil die Cloud es verlangt
- damit Logs verschwinden
! Konten sind starke Isolationsgrenzen.

@@@ MODULE @@@
---
id: cx-02
title: Cloud vertieft 2 · IAM-Prinzipien in AWS, Azure und GCP
paths: specialist, cdsa
order: 70.2
difficulty: medium
icon: person.badge.key
tags: cloud, iam
summary: Wie Cloud-IAM Richtlinien auswertet, warum Rollen besser als Schlüssel sind und wie man überprivilegierte Identitäten findet und begrenzt.
---

## Einfach erklärt

In der Cloud ist fast jede Aktion ein API-Aufruf: „Starte VM“, „Lies Datei aus Bucket“, „Lösche Datenbank“. **IAM** entscheidet bei jedem Aufruf: **Wer** fragt, **was** soll getan werden, **auf welcher Ressource**, unter welchen **Bedingungen**? Ein einziges zu großzügiges Recht kann alles öffnen.

## Bausteine im Vergleich

| Konzept | AWS | Azure | GCP |
|---|---|---|---|
| Identitäten | Users, Roles | Entra-ID-Nutzer, Service Principals, Managed Identities | Users, Service Accounts |
| Rechte | Policies (JSON) | Rollen (RBAC) mit Scope | Rollen mit Bindings |
| Temporärer Zugriff | `AssumeRole` (STS) | Managed Identity, PIM | Impersonation, Workload Identity |
| Leitplanken | SCPs, Permission Boundaries | Azure Policy, Management Groups | Organization Policies |

## Eine AWS-Policy lesen

```json
{
  "Effect": "Allow",
  "Action": ["s3:GetObject"],
  "Resource": "arn:aws:s3:::berichte-2026/*",
  "Condition": { "Bool": { "aws:SecureTransport": "true" } }
}
```

Regel der Auswertung: **Explizites Deny schlägt alles**, sonst muss ein Allow existieren, sonst gilt implizites Deny.

> [!WARNUNG] Wildcards
> `"Action": "*"` und `"Resource": "*"` sind faktisch Admin-Rechte. Auch scheinbar harmlose Rechte wie `iam:PassRole`, `iam:CreateAccessKey` oder das Ändern von Policies können zu voller Kontrolle führen.

## Tiefer eingetaucht

Gute Praxis:

1. **Keine langlebigen Zugriffsschlüssel** für Menschen – SSO mit kurzlebigen Sitzungen.
2. **Rollen für Workloads** (Instance Profiles, Managed Identities, Workload Identity) statt eingebetteter Schlüssel.
3. **Least Privilege** mit Daten: Zugriffsanalysen (z. B. IAM Access Analyzer, „last accessed“) zeigen, welche Rechte nie genutzt werden.
4. **Root/Global Admin** mit Hardware-MFA, nicht im Alltag nutzen.
5. **Leitplanken** auf Organisationsebene: Was niemand darf (z. B. Logging abschalten, Regionen außerhalb der EU nutzen).

Angriffspfade in Cloud-IAM ähneln AD: Ketten aus scheinbar kleinen Rechten (eine Rolle darf eine andere annehmen, die Policies ändern darf …). Werkzeuge zur Visualisierung solcher Pfade helfen Verteidigern, sie abzuschneiden.

## Quiz

? Was gilt in AWS IAM, wenn eine Policy explizit Deny sagt und eine andere Allow?
+ Deny gewinnt
- Allow gewinnt
- die neuere Policy gewinnt
- es entscheidet der Zufall
! Explizites Deny schlägt jedes Allow.

? Was ist besser als langlebige Zugriffsschlüssel für Workloads?
+ Rollen bzw. Managed Identities mit temporären Credentials
- Schlüssel im Quellcode
- Schlüssel in Umgebungsvariablen ohne Rotation
- ein gemeinsamer Admin-Schlüssel
! Temporäre Credentials laufen automatisch ab.

? Welche AWS-Aktion kann zur Rechteausweitung führen, weil sie einer Ressource eine Rolle übergibt?
= iam:PassRole
! In Kombination mit dem Anlegen von Ressourcen gefährlich.

?tf "Action": "*" mit "Resource": "*" entspricht faktisch Admin-Rechten.
= wahr
! Wildcards sollten nur in begründeten Ausnahmen vorkommen.

? Wie heißen organisationsweite Leitplanken in AWS?
= SCPs
= Service Control Policies
! Sie begrenzen, was Konten maximal dürfen.

? Welcher AWS-Dienst stellt temporäre Credentials beim Annehmen einer Rolle aus?
= STS
= Security Token Service
! AssumeRole liefert zeitlich begrenzte Schlüssel.

@@@ MODULE @@@
---
id: cx-03
title: Cloud vertieft 3 · Die häufigsten Cloud-Fehlkonfigurationen
paths: specialist, cdsa, cpts
order: 70.3
difficulty: medium
icon: exclamationmark.icloud.fill
tags: cloud, fehlkonfiguration
summary: Öffentliche Speicher, offene Management-Ports, Metadatendienst, Logging aus, überprivilegierte Rollen – woran man sie erkennt und wie man sie dauerhaft verhindert.
---

## Einfach erklärt

Die Cloud macht es sehr leicht, etwas mit einem Klick öffentlich zu machen – und genauso leicht, es zu vergessen. Viele große Datenlecks waren keine Hacks, sondern **offen stehende Türen**: ein Speicher-Bucket für jeden lesbar, eine Datenbank ohne Passwort im Internet.

## Die Top-Fehlkonfigurationen

| Fehlkonfiguration | Risiko | Gegenmaßnahme |
|---|---|---|
| Öffentlich lesbarer Objektspeicher (S3, Blob, GCS) | Datenleck | „Block Public Access“ organisationsweit, private Endpunkte |
| Offene Management-Ports (SSH/RDP) | Brute Force, Exploits | Bastion/SSM/Bastion-Dienst, keine öffentlichen IPs |
| Datenbanken mit öffentlicher Erreichbarkeit | Datenleck | private Netze, Firewall-Regeln |
| Logging deaktiviert | blind bei Vorfällen | CloudTrail/Activity Logs zentral und unveränderlich |
| Überprivilegierte Rollen | Ausweitung | Least Privilege, Zugriffsanalyse |
| Langlebige Schlüssel, nicht rotiert | Diebstahl | Rollen, Rotation, Secret Scanning |
| IMDSv1 (unauthentifizierter Metadatendienst) | SSRF → Credentials | IMDSv2 erzwingen |
| Unverschlüsselte Snapshots, öffentlich geteilt | Datenleck | Freigaben prüfen, Verschlüsselung |
| Fehlende MFA für Konsolenzugriff | Kontoübernahme | MFA erzwingen |

> [!GEFAHR] Metadatendienst und SSRF
> Jede Cloud-VM kann über eine interne Adresse (z. B. `169.254.169.254`) ihre Rollen-Credentials abrufen. Eine SSRF-Lücke in einer Webanwendung kann diese abgreifen. IMDSv2 verlangt ein Token per PUT-Anfrage und erschwert das erheblich.

## Tiefer eingetaucht

Dauerhaft verhindern statt nachträglich finden:

- **Policy as Code**: Leitplanken, die öffentliche Buckets oder unverschlüsselte Volumes gar nicht erst zulassen (SCP, Azure Policy „Deny“, Organization Policy).
- **IaC-Scanning** in der CI (z. B. Checkov, tfsec/Trivy) findet Fehler vor dem Deployment.
- **CSPM** überwacht laufend die Konfiguration aller Konten.
- **Drift-Erkennung**: Abweichungen zwischen Code und Realität (Klick-Änderungen in der Konsole) melden.

## Quiz

? Was ist eine der häufigsten Ursachen für Cloud-Datenlecks?
+ öffentlich lesbarer Objektspeicher
- zu starke Verschlüsselung
- zu viele Regionen
- zu kurze Passwörter für den Anbieter
! Oft reicht eine falsch gesetzte Freigabe.

? Unter welcher IP-Adresse ist der Metadatendienst vieler Clouds erreichbar?
= 169.254.169.254
! Eine Link-Local-Adresse, nur von der VM selbst erreichbar.

? Was bringt IMDSv2?
+ Abrufe brauchen ein Token per PUT, was SSRF-Ausnutzung erschwert
- schnellere VMs
- kostenlose Speicher
- automatische Backups
! Einfache GET-basierte SSRF genügt dann nicht mehr.

?tf Öffentliche IP-Adressen für SSH und RDP sind in der Cloud unbedenklich, wenn Passwörter lang sind.
= falsch
! Besser: Bastion- oder Session-Manager-Dienste ohne offene Ports.

? Wie verhindert man Fehlkonfigurationen schon vor dem Deployment?
+ IaC-Scanning in der CI
- häufiger in die Konsole klicken
- Logs löschen
- Zugriffsschlüssel teilen
! Werkzeuge wie Checkov oder Trivy prüfen Terraform & Co.

? Wie heißt die laufende Überwachung der Cloud-Konfiguration?
= CSPM
= Cloud Security Posture Management
! Sie meldet Abweichungen von Best Practices.

@@@ MODULE @@@
---
id: cx-04
title: Cloud vertieft 4 · CSPM, CWPP und CNAPP – Cloud-Sicherheitswerkzeuge einordnen
paths: specialist, cdsa
order: 70.4
difficulty: medium
icon: square.stack.3d.up.badge.automatic
tags: cloud, werkzeuge
summary: Was die vielen Abkürzungen der Cloud-Sicherheit bedeuten, welche Fragen jedes Werkzeug beantwortet und wie man sie sinnvoll kombiniert.
---

## Einfach erklärt

Cloud-Sicherheitswerkzeuge haben viele Abkürzungen, beantworten aber im Kern wenige Fragen: **Ist alles richtig eingestellt?** (CSPM) **Sind die Workloads sicher?** (CWPP) **Wer darf was?** (CIEM) **Wie hängt alles zusammen?** (CNAPP).

## Überblick

| Abkürzung | Bedeutung | Beantwortet |
|---|---|---|
| CSPM | Cloud Security Posture Management | Fehlkonfigurationen, Compliance |
| CWPP | Cloud Workload Protection Platform | Schutz von VMs, Containern, Serverless zur Laufzeit |
| CIEM | Cloud Infrastructure Entitlement Management | überprivilegierte Identitäten |
| KSPM | Kubernetes Security Posture Management | Kubernetes-Konfiguration |
| DSPM | Data Security Posture Management | wo liegen sensible Daten? |
| CNAPP | Cloud-Native Application Protection Platform | Kombination aller obigen plus Kontext |

> [!MERKE] Kontext macht den Unterschied
> „Eine VM hat eine kritische Schwachstelle“ ist eine von tausenden Meldungen. „Eine internetexponierte VM mit kritischer Schwachstelle hat eine Rolle mit Zugriff auf den Kunden-Bucket“ ist ein **Angriffspfad** – und gehört ganz nach oben.

## Sinnvoll einführen

1. Mit **nativen Werkzeugen** starten (AWS Security Hub/GuardDuty, Microsoft Defender for Cloud, Google Security Command Center).
2. **Benchmarks** wählen (CIS) und Abweichungen priorisieren – nicht alles auf einmal.
3. Ergebnisse an **Verantwortliche** pro Konto/Team routen.
4. Wiederkehrende Funde durch **Leitplanken** (Policy as Code) dauerhaft verhindern.
5. Laufzeit-Erkennung (CWPP/EDR) für kritische Workloads ergänzen.

## Tiefer eingetaucht

Werkzeuge erzeugen schnell tausende Befunde. Erfolgreiche Teams messen deshalb nicht die Anzahl offener Findings, sondern z. B. „exponierte Angriffspfade zu Kronjuwelen“ und „Zeit bis zur Behebung kritischer Fehlkonfigurationen“. Ergänzend: **Cloud Detection and Response** (Erkennung auf Basis von Audit-Logs, z. B. ungewöhnliche API-Aufrufe), damit nicht nur Konfiguration, sondern auch Angriffe sichtbar werden.

## Quiz

? Welche Werkzeugklasse findet Fehlkonfigurationen in Cloud-Konten?
= CSPM
! Cloud Security Posture Management.

? Wofür steht CIEM?
= Cloud Infrastructure Entitlement Management
! Es findet überprivilegierte Identitäten.

? Was kombiniert eine CNAPP?
+ mehrere Cloud-Sicherheitsfunktionen mit Kontext zu Angriffspfaden
- nur Virenscanner
- nur Backups
- nur Firewall-Regeln
! Kontext hilft, die wirklich gefährlichen Kombinationen zu priorisieren.

?tf Die reine Anzahl offener Cloud-Findings ist die beste Erfolgskennzahl.
= falsch
! Aussagekräftiger sind exponierte Angriffspfade und Behebungszeiten.

? Welche Werkzeugklasse schützt Workloads zur Laufzeit?
= CWPP
= Cloud Workload Protection Platform
! Für VMs, Container und Serverless.

@@@ MODULE @@@
---
id: cx-05
title: Cloud vertieft 5 · Kubernetes RBAC und Pod-Sicherheit
paths: specialist, cdsa
order: 70.5
difficulty: hard
icon: helm
tags: kubernetes, rbac, container
summary: Wie Kubernetes Rechte vergibt, welche Rollen gefährlich sind, wie Service-Account-Tokens funktionieren und wie Pod Security Standards Container einschränken.
---

## Einfach erklärt

Kubernetes ist ein Hafen mit tausenden Containern. Der **API-Server** ist die Hafenmeisterei: Wer dort Befehle geben darf, kontrolliert den Hafen. **RBAC** regelt, wer welche Befehle geben darf – und viele Container bekommen ungewollt eine Schlüsselkarte (Service-Account-Token) mit, die mehr öffnet als nötig.

## RBAC-Bausteine

| Objekt | Bedeutung |
|---|---|
| Role / ClusterRole | Rechte (Verben auf Ressourcen) im Namespace bzw. clusterweit |
| RoleBinding / ClusterRoleBinding | weist Rolle einem Subjekt zu |
| Subjekt | User, Group, ServiceAccount |

```yaml
kind: Role
apiVersion: rbac.authorization.k8s.io/v1
metadata: { namespace: shop, name: pod-leser }
rules:
- apiGroups: [""]
  resources: ["pods"]
  verbs: ["get", "list", "watch"]
```

## Gefährliche Rechte

| Recht | Warum |
|---|---|
| `*` auf `*` / `cluster-admin` | alles |
| `create pods` | Pod mit Host-Zugriff starten → Node-Übernahme |
| `get secrets` | alle Geheimnisse im Namespace |
| `pods/exec` | Shell in fremden Containern |
| `escalate`, `bind`, `impersonate` | Rechteausweitung |
| `nodes/proxy` | direkter Kubelet-Zugriff |

> [!WARNUNG] Default Service Account
> Jeder Pod erhält standardmäßig ein Token. Wo der Pod nicht mit der API sprechen muss: `automountServiceAccountToken: false`.

## Pod Security

**Pod Security Standards** (Privileged, Baseline, Restricted) per Namespace-Label durchsetzen:

```yaml
metadata:
  labels:
    pod-security.kubernetes.io/enforce: restricted
```

`restricted` verlangt u. a.: kein privileged, kein hostPath/hostNetwork, nicht als root, keine zusätzlichen Capabilities, Seccomp-Profil.

## Tiefer eingetaucht

Weitere Schichten: **NetworkPolicies** (Default Deny zwischen Pods), **Admission Controller** wie Kyverno oder OPA Gatekeeper (eigene Regeln, z. B. nur signierte Images), Secrets-Verschlüsselung in etcd, Audit-Logging des API-Servers, Laufzeit-Erkennung (z. B. Falco). Werkzeuge wie kube-bench (CIS-Benchmark) und Rechte-Analysen zeigen Schwachstellen in der Cluster-Konfiguration.

## Quiz

? Was verbindet eine Rolle mit einem Benutzer oder Service Account?
= RoleBinding
= ClusterRoleBinding
! Die Rolle definiert Rechte, das Binding weist sie zu.

? Warum ist das Recht „create pods“ gefährlich?
+ man kann Pods mit Host-Zugriff starten und so den Node übernehmen
- es löscht den Cluster
- es verlangsamt den API-Server
- es ist nur lesend
! Ohne Pod Security kann ein privilegierter Pod den Host kompromittieren.

? Wie verhindert man, dass ein Pod automatisch ein API-Token erhält?
= automountServiceAccountToken: false
= automountServiceAccountToken
! Sinnvoll für alle Pods, die nicht mit der API sprechen.

? Welcher Pod Security Standard ist am strengsten?
= restricted
! Privileged ist am lockersten, Baseline dazwischen.

?tf NetworkPolicies können Verkehr zwischen Pods standardmäßig verbieten.
= wahr
! Voraussetzung ist ein CNI-Plugin, das sie unterstützt.

? Welches Werkzeug prüft einen Cluster gegen den CIS-Benchmark?
= kube-bench
! Für Laufzeit-Erkennung eignet sich z. B. Falco.

@@@ MODULE @@@
---
id: cx-06
title: Cloud vertieft 6 · Container-Images und Software-Lieferkette
paths: specialist, cwee, cdsa
order: 70.6
difficulty: medium
icon: shippingbox.circle.fill
tags: container, supply chain, sbom
summary: Wie man Images klein und sicher baut, scannt, signiert und nur vertrauenswürdige Images ausführt – vom Dockerfile bis zur Admission-Regel.
---

## Einfach erklärt

Ein Container-Image ist ein Fertiggericht: Man weiß nicht automatisch, welche Zutaten drin sind und ob eine davon verdorben ist. **Lieferkettensicherheit** heißt: Zutatenliste (SBOM), Qualitätskontrolle (Scan), Siegel (Signatur) und eine Küche, die nur versiegelte Ware annimmt (Admission-Regel).

## Ein sicheres Dockerfile

```dockerfile
FROM python:3.12-slim AS build
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir --prefix=/install -r requirements.txt

FROM gcr.io/distroless/python3-debian12
COPY --from=build /install /usr/local
COPY app/ /app
USER 65532:65532
ENTRYPOINT ["python3", "/app/main.py"]
```

| Praxis | Wirkung |
|---|---|
| kleine Basis (slim, distroless) | weniger Pakete, weniger Lücken |
| Multi-Stage-Build | Build-Werkzeuge nicht im finalen Image |
| fester Tag oder Digest | reproduzierbar (`@sha256:…`) |
| nicht als root | weniger Schaden bei Ausbruch |
| keine Secrets im Image | Schichten bleiben lesbar |

## Scannen, signieren, durchsetzen

1. **Scannen** im Build und regelmäßig in der Registry (z. B. Trivy, Grype).
2. **SBOM** erzeugen (z. B. Syft, im SPDX- oder CycloneDX-Format).
3. **Signieren** (z. B. Sigstore/cosign) und Herkunftsnachweise (SLSA-Provenance).
4. **Admission-Regel** im Cluster: nur signierte Images aus der eigenen Registry.

> [!MERKE] Neue Lücken in alten Images
> Ein Image ohne Befund heute kann morgen kritische Lücken haben. Regelmäßig neu scannen und neu bauen.

## Tiefer eingetaucht

Lieferkettenangriffe der letzten Jahre (manipulierte Build-Systeme, gekaperte Pakete, Typosquatting in Paketregistern, kompromittierte Maintainer-Konten) zeigen: Vertrauen muss überprüfbar sein. Frameworks wie **SLSA** beschreiben Stufen für vertrauenswürdige Builds (geschützte, nachvollziehbare Build-Plattform, signierte Herkunft). Für Abhängigkeiten gilt: Versionen pinnen, Lockfiles nutzen, interne Proxys/Mirrors, neue Pakete vor Aufnahme prüfen.

## Quiz

? Was ist der Vorteil eines Multi-Stage-Builds?
+ Build-Werkzeuge landen nicht im finalen Image
- das Image wird größer
- Secrets werden verschlüsselt
- der Container läuft als root
! Weniger Inhalt bedeutet weniger Angriffsfläche.

? Mit welchem Werkzeug kann man Container-Images signieren?
= cosign
= Sigstore
! Signaturen lassen sich im Cluster vor dem Start prüfen.

? Was ist eine SBOM?
+ eine Liste aller Komponenten eines Softwarepakets
- ein Backup-Format
- ein Netzwerkprotokoll
- ein Lizenzschlüssel
! Software Bill of Materials.

?tf Ein Image, das heute keine Befunde hat, bleibt dauerhaft frei von Schwachstellen.
= falsch
! Neue Lücken werden laufend bekannt.

? Wie referenziert man ein Image unveränderlich?
+ über den Digest (@sha256:…)
- über den Tag latest
- über den Dateinamen
- über die Größe
! Tags können umgezogen werden, Digests nicht.

? Welches Framework beschreibt Stufen für vertrauenswürdige Builds?
= SLSA
! Supply-chain Levels for Software Artifacts.

@@@ MODULE @@@
---
id: cx-07
title: Cloud vertieft 7 · Incident Response in der Cloud
paths: cdsa, specialist
order: 70.7
difficulty: hard
icon: cloud.bolt.fill
tags: cloud, incident response, forensik
summary: Wie sich Cloud-Vorfälle von klassischen unterscheiden, welche Vorbereitung nötig ist und wie man eindämmt, Beweise sichert und Persistenz findet.
---

## Einfach erklärt

Bei einem Vorfall im eigenen Rechenzentrum zieht man notfalls das Netzwerkkabel. In der Cloud gibt es kein Kabel – aber dafür **APIs**: Man kann per Befehl isolieren, Snapshots ziehen und Rechte entziehen, schneller als jeder Techniker im Keller. Voraussetzung: Man hat es vorbereitet.

## Vorbereitung

- Audit-Logs in allen Konten/Regionen aktiv und zentral, **unveränderlich** gespeichert.
- Eigenes **Forensik-Konto** mit vorbereiteten Rollen und Werkzeugen.
- **Break-Glass-Zugänge** für das IR-Team.
- Playbooks für typische Szenarien: geleakter Schlüssel, kompromittierte VM, öffentlicher Bucket, übernommenes Admin-Konto.
- Kontakt zum Support des Anbieters.

## Eindämmen

| Szenario | Sofortmaßnahmen |
|---|---|
| Geleakter Zugriffsschlüssel | deaktivieren, Nutzung im Log prüfen, alle angelegten Ressourcen/Identitäten suchen |
| Kompromittierte VM | Security Group auf „isoliert“, Snapshot der Volumes, Speicherabbild wenn möglich, Instanzrolle entziehen |
| Übernommenes Admin-Konto | Sitzungen widerrufen, MFA prüfen, Passwort/Schlüssel neu, Änderungen der letzten Tage prüfen |
| Öffentlicher Bucket mit Daten | Zugriff schließen, Zugriffslogs auswerten (wer hat gelesen?) |

> [!WARNUNG] Persistenz suchen
> Angreifer legen in der Cloud schnell neue Nutzer, Schlüssel, Rollen mit Vertrauensbeziehung zu eigenen Konten, Lambda-Funktionen oder Föderations-Provider an. Ohne gründliche Suche kommen sie wieder.

## Tiefer eingetaucht

Beweissicherung: Snapshots in das Forensik-Konto kopieren, Hashes dokumentieren, Logs exportieren. Achtung bei Aufbewahrungsfristen – manche Logs sind nur Tage oder Wochen verfügbar.

Analyse: Zeitleiste aus Audit-Logs („Wer hat mit welchem Schlüssel von welcher IP welche API aufgerufen?“), korreliert mit VM-Artefakten und Netzwerk-Flow-Logs. Typische Angreiferaktionen: `GetCallerIdentity` (Wer bin ich?), Enumeration von Rechten und Ressourcen, Abschalten von Logging, Anlegen von Persistenz, Abfluss über eigene Buckets oder Snapshot-Freigaben an fremde Konten, Starten teurer Instanzen für Kryptomining.

## Quiz

? Was ersetzt in der Cloud das „Kabel ziehen“ zur Isolation einer VM?
+ eine Security Group bzw. Netzwerkregel, die allen Verkehr sperrt
- den Anbieter anrufen und warten
- die VM sofort löschen
- nichts, Isolation ist unmöglich
! Per API lässt sich in Sekunden isolieren – ohne Beweise zu vernichten.

? Was sollte man vor dem Löschen einer kompromittierten VM sichern?
+ Snapshots der Volumes und ggf. ein Speicherabbild
- nichts
- nur den Namen der VM
- die Rechnung
! Sonst sind Beweise unwiederbringlich verloren.

?tf Angreifer legen in Cloud-Umgebungen häufig neue Schlüssel und Rollen als Persistenz an.
= wahr
! Diese müssen bei der Bereinigung gezielt gesucht werden.

? Welche AWS-API rufen Angreifer häufig zuerst auf, um ihre Identität zu prüfen?
= GetCallerIdentity
= sts:GetCallerIdentity
! Ein früher Indikator in CloudTrail.

? Warum braucht man ein separates Forensik-Konto?
+ um Beweise getrennt vom kompromittierten Konto sicher zu analysieren
- weil es billiger ist
- weil Logs dort schöner aussehen
- um die Rechnung zu teilen
! Der Angreifer soll keinen Zugriff auf die Untersuchung haben.

? Was ist ein häufiges Ziel von Angreifern mit Cloud-Zugriff, das hohe Kosten verursacht?
= Kryptomining
= Cryptomining
! Teure GPU-Instanzen werden in fremden Regionen gestartet.

@@@ MODULE @@@
---
id: cx-08
title: Cloud vertieft 8 · Microsoft 365 absichern
paths: specialist, cdsa
order: 70.8
difficulty: medium
icon: envelope.open.fill
tags: m365, cloud, e-mail
summary: Die wichtigsten Stellschrauben für Exchange Online, SharePoint/OneDrive, Teams und Entra ID – vom Secure Score bis zur Freigaberichtlinie.
---

## Einfach erklärt

Für viele Unternehmen ist Microsoft 365 das digitale Büro: E-Mail, Dateien, Chats, Videokonferenzen. Wer hier ein Konto übernimmt, liest Mails mit, verschickt Rechnungen mit falscher Bankverbindung und greift auf Dokumente zu. Die gute Nachricht: Die meisten Schutzfunktionen sind schon da – sie müssen nur eingeschaltet werden.

## Prioritätenliste

| Bereich | Maßnahme |
|---|---|
| Identität | MFA für alle (phishing-resistent für Admins), Legacy-Auth blockieren, Conditional Access |
| Admins | wenige Global Admins, PIM, Break-Glass-Konten |
| E-Mail | SPF/DKIM/DMARC, Anti-Phishing-Richtlinien (Impersonation), Safe Links/Safe Attachments |
| Weiterleitung | automatische externe Weiterleitung blockieren |
| Apps | Nutzerzustimmung zu Apps einschränken, Admin-Consent-Workflow |
| Freigaben | externe Freigabe in SharePoint/OneDrive begrenzen, „Jeder mit dem Link“ vermeiden |
| Teams | externe Kommunikation und Gastzugriff bewusst konfigurieren |
| Protokollierung | Unified Audit Log aktiv, Export ins SIEM, Aufbewahrung |

> [!TIPP] Secure Score als Kompass
> Der Microsoft Secure Score zeigt priorisierte Empfehlungen. Nicht blind jeden Punkt umsetzen, aber als Checkliste und Fortschrittsmaß nutzen.

## Tiefer eingetaucht

Typische Angriffsmuster in M365: Adversary-in-the-Middle-Phishing mit Session-Diebstahl, Geräte-Code-Phishing, OAuth-Consent-Phishing, Posteingangsregeln zum Verstecken von Antworten, Massenversand von Phishing aus übernommenen Konten (interne Ausbreitung).

Gegenmittel: Token Protection und Continuous Access Evaluation, Conditional Access mit Geräte-Compliance, Alarme für neue Weiterleitungsregeln, neue App-Zustimmungen und ungewöhnliche Anmeldeorte, regelmäßige Überprüfung von Gastkonten und externen Freigaben. Für Backups von M365-Daten gilt das Shared-Responsibility-Modell: Microsoft schützt die Plattform, gelöschte oder verschlüsselte Inhalte wiederherzustellen ist nur begrenzt eingebaut.

## Quiz

? Warum sollte die automatische externe Weiterleitung blockiert werden?
+ Angreifer nutzen sie, um Mails unbemerkt abzuleiten
- sie verlangsamt Exchange
- sie verhindert Spam
- sie ist kostenpflichtig
! Weiterleitungsregeln sind typische Persistenz nach Kontoübernahme.

? Welcher Wert gibt priorisierte Sicherheitsempfehlungen für M365?
= Secure Score
= Microsoft Secure Score
! Gut als Fortschrittsmaß, nicht blind abarbeiten.

?tf Externe Freigaben mit „Jeder mit dem Link“ sind für vertrauliche Dokumente unbedenklich.
= falsch
! Links werden weitergeleitet und sind ohne Anmeldung nutzbar.

? Was sollte man bei der Zustimmung zu Apps einstellen?
+ Nutzerzustimmung einschränken und einen Admin-Consent-Workflow nutzen
- jedem Nutzer jede App erlauben
- Apps grundsätzlich mit Global-Admin-Rechten ausstatten
- keine Protokollierung
! Schützt vor Consent Phishing.

? Welche Protokollierung muss für Untersuchungen in M365 aktiv sein?
= Unified Audit Log
! Idealerweise mit Export ins SIEM und längerer Aufbewahrung.

@@@ MODULE @@@
---
id: cx-09
title: Cloud vertieft 9 · Google Cloud Sicherheitsgrundlagen
paths: specialist
order: 70.9
difficulty: medium
icon: cloud.circle.fill
tags: gcp, cloud
summary: Ressourcenhierarchie, IAM, Service Accounts, Organization Policies, VPC Service Controls und Logging in Google Cloud.
---

## Einfach erklärt

Google Cloud ist wie ein Bürogebäude mit klarer Hierarchie: **Organisation** (das Gebäude), **Ordner** (Etagen), **Projekte** (Räume) und darin die Ressourcen. Rechte und Regeln, die oben vergeben werden, gelten für alles darunter – praktisch, aber auch gefährlich, wenn man oben zu großzügig ist.

## Ressourcenhierarchie und IAM

| Ebene | Typische Regeln |
|---|---|
| Organisation | Organization Policies, zentrale Admins |
| Ordner | Abteilungen/Umgebungen |
| Projekt | Ressourcen, Abrechnung, API-Aktivierung |

IAM-Rollen gibt es als **Basic** (Owner, Editor, Viewer – zu grob), **Predefined** (dienstspezifisch) und **Custom**. Empfehlung: Basic-Rollen vermeiden.

## Service Accounts

- Identitäten für Workloads.
- **Keine Schlüsseldateien** herunterladen – stattdessen angehängte Service Accounts, **Workload Identity Federation** (für externe Systeme wie CI) oder Impersonation.
- Default-Compute-Service-Account hat oft die Editor-Rolle → einschränken oder nicht verwenden.

> [!WARNUNG] Editor ist fast Owner
> Die Basic-Rolle Editor erlaubt Änderungen an fast allen Ressourcen. Wer sie Workloads gibt, macht jede kompromittierte VM zur Gefahr für das ganze Projekt.

## Leitplanken und Logging

- **Organization Policies**: z. B. keine Service-Account-Schlüssel, keine externen IPs, nur bestimmte Regionen.
- **VPC Service Controls**: Perimeter um Datendienste, verhindert Abfluss in fremde Projekte.
- **Cloud Audit Logs**: Admin Activity (immer an), Data Access (gezielt aktivieren).
- **Security Command Center** für Befunde und Bedrohungserkennung.

## Tiefer eingetaucht

Angriffspfade in GCP drehen sich oft um Service Accounts: Wer `iam.serviceAccounts.actAs` oder `getAccessToken` auf einen mächtigen Service Account hat, kann dessen Rechte nutzen. Rechteanalysen (Policy Analyzer, IAM Recommender) zeigen ungenutzte Rechte und helfen beim Zurückschneiden.

## Quiz

? Welche Ebene steht in GCP ganz oben?
= Organisation
= Organization
! Darunter folgen Ordner und Projekte.

? Welche Rollenart sollte in GCP möglichst vermieden werden?
+ Basic-Rollen wie Owner und Editor
- Predefined-Rollen
- Custom-Rollen mit minimalen Rechten
- Viewer auf einzelnen Ressourcen
! Sie sind zu grob.

? Was ist die empfohlene Alternative zu heruntergeladenen Service-Account-Schlüsseln für externe CI-Systeme?
= Workload Identity Federation
! Kurzlebige Tokens statt statischer Schlüsseldateien.

?tf VPC Service Controls können Datenabfluss in fremde Projekte verhindern.
= wahr
! Sie bilden einen Perimeter um Datendienste.

? Welche Audit-Logs sind in GCP immer aktiviert?
= Admin Activity
= Admin Activity Logs
! Data-Access-Logs muss man gezielt aktivieren.

? Welche Berechtigung erlaubt, als ein Service Account zu handeln?
= iam.serviceAccounts.actAs
= actAs
! Ein typischer Baustein für Rechteausweitung.

@@@ MODULE @@@
---
id: cx-10
title: Cloud vertieft 10 · Kosten, Verfügbarkeit und Resilienz als Sicherheitsthema
paths: specialist, cyberrange
order: 70.95
difficulty: easy
icon: dollarsign.arrow.circlepath
tags: cloud, resilienz, kosten
summary: Warum Budgets, Quotas, Multi-Region-Design und Backups in der Cloud zur Sicherheit gehören – von Denial of Wallet bis Regionsausfall.
---

## Einfach erklärt

In der Cloud kostet alles, was läuft. Ein Angreifer, der in einem gestohlenen Konto teure Rechner startet, richtet in Stunden einen fünfstelligen Schaden an – ganz ohne Datenklau. Und eine einzige Region kann ausfallen. **Kosten und Verfügbarkeit** sind deshalb auch Sicherheitsthemen.

## Schutz vor Kostenschäden

| Maßnahme | Wirkung |
|---|---|
| Budgets mit Alarmen | frühe Warnung bei ungewöhnlichen Kosten |
| Service Quotas / Limits | begrenzen, wie viele teure Ressourcen möglich sind |
| Regionen einschränken | Angreifer weichen gern auf ungenutzte Regionen aus |
| Anomalie-Erkennung | plötzlicher Anstieg von GPU-Instanzen, Datenverkehr |
| Rate Limits und Auto-Scaling-Grenzen | verhindert **Denial of Wallet** bei Serverless |

> [!MERKE] Denial of Wallet
> Bei Serverless-Diensten skaliert alles automatisch. Ein Angreifer muss den Dienst nicht lahmlegen – er lässt ihn einfach sehr teuer werden.

## Resilienz

- **Zonen** gegen Rechenzentrumsausfall, **Regionen** gegen großflächige Ausfälle.
- Backups in **anderem Konto** und ggf. anderer Region, unveränderlich (Object Lock/Immutable Storage).
- Infrastruktur als Code: Umgebung in neuer Region reproduzierbar.
- Regelmäßige Wiederherstellungs- und Failover-Tests.
- Abhängigkeiten kennen: Identitätsdienst, DNS, zentrale Dienste des Anbieters.

## Tiefer eingetaucht

Große Ausfälle bei Cloud-Anbietern zeigen, dass auch zentrale Steuerungsdienste (Identität, DNS, Kontrollebenen) ausfallen können. Kritische Anwendungen planen deshalb „statische Stabilität“: Die Anwendung läuft weiter, auch wenn man vorübergehend nichts ändern kann.

Für die Sicherheit gilt außerdem: Notfall-Zugänge, die nicht vom normalen Identitätsdienst abhängen, Dokumentation offline verfügbar, und ein Plan, wie man bei Kompromittierung eines ganzen Kontos (z. B. durch gestohlene Root-Zugangsdaten) handlungsfähig bleibt.

## Quiz

? Was beschreibt „Denial of Wallet“?
+ ein Angriff, der durch automatische Skalierung hohe Kosten verursacht
- ein Angriff auf Geldbörsen-Apps
- ein Stromausfall
- ein Fehler im Abrechnungssystem
! Besonders relevant bei Serverless-Diensten.

? Welche Maßnahme warnt früh bei ungewöhnlichen Cloud-Kosten?
+ Budgets mit Alarmen
- längere Passwörter
- mehr Regionen
- abgeschaltete Logs
! Ergänzt durch Kosten-Anomalie-Erkennung.

?tf Angreifer weichen gern auf Regionen aus, die das Unternehmen gar nicht nutzt.
= wahr
! Ungenutzte Regionen sollten gesperrt werden.

? Wo sollten Cloud-Backups idealerweise liegen?
+ in einem anderen Konto, unveränderlich gespeichert
- im selben Konto ohne Schutz
- nur auf dem Laptop des Admins
- gar nicht, die Cloud fällt nie aus
! So überstehen sie auch die Kompromittierung des Produktionskontos.

? Wogegen schützt die Verteilung über mehrere Zonen?
+ gegen den Ausfall eines einzelnen Rechenzentrums
- gegen Phishing
- gegen falsche IAM-Rechte
- gegen Kostenexplosionen
! Gegen Regionsausfälle braucht es mehrere Regionen.
