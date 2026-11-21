---
id: cl-01
title: Cloud · AWS-Sicherheitsgrundlagen
paths: specialist, cdsa
order: 70
difficulty: medium
icon: cloud.fill
tags: cloud
summary: Konten und Organisationen, IAM-Policies lesen, Rollen statt Schlüssel, S3-Sicherheit, VPC und Security Groups, Logging und die wichtigsten Sicherheitsdienste.
---

## Struktur

| Begriff | Bedeutung |
|---|---|
| Organization | Verbund vieler Konten mit zentraler Steuerung |
| Account | Abrechnungs- und Sicherheitsgrenze |
| SCP | Service Control Policy – Leitplanken für ganze Konten |
| Region / AZ | geografische Standorte |

> [!TIPP] Konten als Grenze
> Produktion, Test, Logging und Sicherheit gehören in getrennte Konten. Ein kompromittiertes Testkonto erreicht dann die Produktion nicht.

## IAM-Policies lesen

```json
{
  "Version": "2012-10-17",
  "Statement": [{
    "Effect": "Allow",
    "Action": ["s3:GetObject"],
    "Resource": "arn:aws:s3:::berichte-intern/*",
    "Condition": {"Bool": {"aws:SecureTransport": "true"}}
  }]
}
```

Auswertungsreihenfolge: explizites **Deny** schlägt alles, dann braucht es ein **Allow**, sonst gilt implizites Deny.

## S3

- **Block Public Access** auf Konto-Ebene aktivieren
- Verschlüsselung (SSE-S3/SSE-KMS) und Versionierung
- Bucket Policies statt ACLs
- Zugriffsprotokollierung

## Netzwerk

| Element | Funktion |
|---|---|
| VPC | eigenes virtuelles Netz |
| Subnetze | öffentlich (mit Internet-Gateway) oder privat |
| Security Groups | zustandsbehaftete Firewall pro Ressource |
| NACLs | zustandslose Filter pro Subnetz |
| VPC Endpoints | Zugriff auf AWS-Dienste ohne Internet |

## Sicherheitsdienste

CloudTrail (Protokoll), GuardDuty (Erkennung), Security Hub (Bewertung), Config (Konfigurationshistorie), IAM Access Analyzer (öffentliche/kontoübergreifende Freigaben), KMS (Schlüssel), Inspector (Schwachstellen).

## Quiz

? Was gewinnt bei der Auswertung von IAM-Policies immer?
+ ein explizites Deny
- ein Allow
- die neueste Policy
- die längste Policy

? Welche S3-Einstellung verhindert öffentliche Freigaben kontoweit?
= Block Public Access

? Welche AWS-Firewall arbeitet zustandsbehaftet pro Ressource?
= Security Groups
= Security Group

? Welcher Dienst erkennt verdächtige Aktivitäten in AWS?
= GuardDuty

? Wofür stehen SCPs?
= Service Control Policies
= Service Control Policy

@@@ MODULE @@@
---
id: cl-02
title: Cloud · Azure und Entra ID absichern
paths: specialist, cdsa
order: 71
difficulty: medium
icon: cloud.sun.fill
tags: cloud
summary: Mandanten, Abonnements und Management-Gruppen, Entra-Rollen vs. Azure-RBAC, Conditional Access, Managed Identities, Netzwerk und Defender for Cloud.
---

## Struktur

| Ebene | Bedeutung |
|---|---|
| Tenant (Entra ID) | Identitätsgrenze: Benutzer, Gruppen, Apps |
| Management Groups | Hierarchie für Richtlinien |
| Subscriptions | Abrechnungs- und Ressourcengrenze |
| Resource Groups | logische Gruppierung |

## Zwei Rechtesysteme

| System | gilt für | Beispiele |
|---|---|---|
| Entra-Rollen | Verzeichnis und Microsoft 365 | Global Administrator, User Administrator |
| Azure RBAC | Azure-Ressourcen | Owner, Contributor, Reader |

> [!WARNUNG] Global Administrator
> Ein Global Administrator kann sich auch Zugriff auf alle Azure-Abonnements verschaffen. Die Rolle gehört an wenige Notfall- und PIM-geschützte Konten.

## Identität absichern

- Conditional Access: MFA für alle, Legacy-Auth blockieren, Admins nur von konformen Geräten ([[mod:s-10|Cloud und Identität]])
- **Privileged Identity Management** für Rollen
- Break-Glass-Konten (2), ausgenommen von CA, mit starker Überwachung
- App-Registrierungen und Consent überwachen

## Managed Identities

Dienste (VMs, Functions, App Services) erhalten eine **Managed Identity** und bekommen Rechte über RBAC – keine Geheimnisse im Code. Minimale Rollen vergeben.

## Netzwerk und Schutz

VNets, Network Security Groups, Private Endpoints für PaaS-Dienste, Azure Firewall, **Defender for Cloud** (Bewertung und Erkennung), Azure Policy (erzwungene Konfiguration), Key Vault (Geheimnisse und Schlüssel).

## Quiz

? Welches Rechtesystem gilt für Azure-Ressourcen?
= Azure RBAC
= RBAC

? Welche Entra-Rolle ist die mächtigste?
= Global Administrator

? Wie erhalten Azure-Dienste Rechte ohne Geheimnisse im Code?
= Managed Identity
= Managed Identities

? Wie viele Break-Glass-Konten werden typischerweise empfohlen?
= 2
= zwei

? Welcher Dienst speichert Geheimnisse und Schlüssel in Azure?
= Key Vault

@@@ MODULE @@@
---
id: cl-03
title: Container · Docker sicher betreiben
paths: specialist, cyberrange
order: 72
difficulty: medium
icon: shippingbox.circle.fill
tags: cloud
summary: Sichere Images, Dockerfiles, Laufzeitoptionen, Rootless Docker, Secrets, Netzwerke, Scans und der Docker-Socket als kritischster Punkt.
---

## Sichere Images

- kleine, offizielle oder geprüfte Basis-Images (z. B. distroless, Alpine, slim)
- feste Versionen bzw. Digests statt `latest`
- Multi-Stage-Builds: Build-Werkzeuge nicht im End-Image
- regelmäßig neu bauen und scannen (Trivy, Grype)
- Images signieren (cosign)

## Dockerfile

```dockerfile
FROM python:3.12-slim AS app
RUN useradd -r -u 10001 appuser
WORKDIR /app
COPY --chown=appuser:appuser . .
RUN pip install --no-cache-dir -r requirements.txt
USER appuser
EXPOSE 8080
CMD ["python", "app.py"]
```

## Laufzeit-Optionen

| Option | Wirkung |
|---|---|
| `--user` / `USER` | nicht als root laufen |
| `--read-only` | Root-Dateisystem schreibgeschützt |
| `--cap-drop ALL` (+ nötige `--cap-add`) | Linux-Capabilities minimieren |
| `--security-opt no-new-privileges` | keine Rechteausweitung über SUID |
| Seccomp/AppArmor-Profile | Systemaufrufe einschränken |
| `--memory`, `--pids-limit` | Ressourcenlimits |
| **nie** `--privileged` | hebt die Isolation praktisch auf |

> [!GEFAHR] Der Docker-Socket
> Wer auf `/var/run/docker.sock` zugreifen kann, kontrolliert den Host als root. Den Socket niemals in Container mounten, die nicht ausschließlich vertrauenswürdige Verwaltungsaufgaben erfüllen.

## Secrets und Netzwerk

- Secrets über Docker Secrets/Orchestrator oder Vault, nicht als `ENV` im Image
- eigene Netzwerke pro Anwendung, nur nötige Ports veröffentlichen
- **Rootless Docker** oder Podman reduziert die Folgen eines Ausbruchs

## Quiz

? Warum sollte man feste Image-Versionen statt latest nutzen?
+ Reproduzierbarkeit und Kontrolle über Änderungen
- latest ist verboten
- feste Versionen sind kleiner
- es spielt keine Rolle

? Welche Option sollte nie ohne Not verwendet werden, weil sie die Isolation aufhebt?
= --privileged

? Welche Option entzieht alle Linux-Capabilities?
= --cap-drop ALL
= --cap-drop=ALL

? Welches Werkzeug scannt Container-Images auf Schwachstellen?
= Trivy

? Welche Datei darf nicht in Container gemountet werden?
= /var/run/docker.sock
= docker.sock

@@@ MODULE @@@
---
id: cl-04
title: Container · Kubernetes-Sicherheit
paths: specialist, cdsa
order: 73
difficulty: hard
icon: helm
tags: cloud
summary: Architektur, API-Server, RBAC, Service Accounts, Pod Security Standards, Network Policies, Secrets, Admission Control, Audit-Logs und typische Fehlkonfigurationen.
---

## Architektur in Kürze

| Komponente | Aufgabe | Sicherheitsrelevanz |
|---|---|---|
| API-Server | zentrale Steuerung | Authentifizierung, Autorisierung, Audit |
| etcd | Datenspeicher inkl. Secrets | Verschlüsselung, Zugriff nur für API-Server |
| Kubelet | Agent auf jedem Node | anonyme Zugriffe deaktivieren |
| Controller/Scheduler | Steuerung | |

## RBAC und Service Accounts

- Rollen (`Role`/`ClusterRole`) mit minimalen Rechten, Bindings nur wo nötig
- gefährliche Rechte: `*` auf Ressourcen, `create pods`, `secrets get/list`, `escalate`, `bind`, `impersonate`
- jeder Pod erhält einen Service Account; Token nur mounten, wenn nötig (`automountServiceAccountToken: false`)

## Pod Security Standards

| Profil | Bedeutung |
|---|---|
| Privileged | keine Einschränkungen |
| Baseline | verhindert bekannte Rechteausweitungen (z. B. privileged, hostNetwork) |
| Restricted | streng: Nicht-root, keine Capabilities, Seccomp |

Durchgesetzt über **Pod Security Admission** pro Namespace.

## Network Policies

Standardmäßig darf jeder Pod mit jedem sprechen. **Network Policies** (Default Deny + gezielte Freigaben) segmentieren den Cluster – vorausgesetzt, das Netzwerk-Plugin unterstützt sie.

## Secrets

Kubernetes-Secrets sind standardmäßig nur Base64-kodiert. Verschlüsselung in etcd aktivieren, Zugriff per RBAC begrenzen oder externe Secret-Stores anbinden.

## Weitere Kontrollen

Admission-Controller und Policy-Engines (OPA Gatekeeper, Kyverno), Image-Signaturprüfung, Audit-Logs des API-Servers, Laufzeiterkennung (Falco), CIS Kubernetes Benchmark (kube-bench).

## Quiz

? Welche Komponente speichert den Cluster-Zustand inklusive Secrets?
= etcd

? Welches Pod-Security-Profil ist am strengsten?
= Restricted

? Was gilt in Kubernetes ohne Network Policies?
+ Jeder Pod darf mit jedem sprechen
- Kein Pod darf kommunizieren
- Nur Pods im selben Namespace dürfen sprechen
- Nur DNS ist erlaubt

? Wie sind Kubernetes-Secrets standardmäßig geschützt?
+ nur Base64-kodiert
- AES-verschlüsselt mit HSM
- gar nicht gespeichert
- als Hash

? Welches Werkzeug erkennt verdächtiges Verhalten zur Laufzeit in Containern?
= Falco

? Welches Werkzeug prüft Cluster gegen den CIS Kubernetes Benchmark?
= kube-bench

@@@ MODULE @@@
---
id: cl-05
title: Cloud · Netzwerke und Zero Trust in der Cloud
paths: specialist
order: 74
difficulty: medium
icon: point.3.filled.connected.trianglepath.dotted
tags: cloud
summary: Hub-and-Spoke, private Endpunkte, Egress-Kontrolle, Web Application Firewalls und DDoS-Schutz der Anbieter, hybride Anbindung und Identität als Steuerungsebene.
---

## Architekturmuster

| Muster | Beschreibung |
|---|---|
| Hub-and-Spoke | zentrales Netz mit gemeinsamen Diensten (Firewall, DNS, VPN), Anwendungen in angebundenen Spokes |
| Landing Zone | vorbereitete, regelkonforme Grundstruktur für neue Workloads |
| Private Endpoints / PrivateLink | PaaS-Dienste nur über private Adressen erreichbar |

## Egress-Kontrolle

Workloads sollten nicht beliebig ins Internet dürfen: zentrale Firewall oder NAT mit FQDN-Regeln, DNS-Filter, Protokollierung. Das erschwert Datenabfluss und C2 ([[mod:att-12|ATT&CK C2]]).

## Schutzdienste der Anbieter

| Bedarf | AWS | Azure | Google Cloud |
|---|---|---|---|
| WAF | AWS WAF | Azure WAF / Front Door | Cloud Armor |
| DDoS | Shield | DDoS Protection | Cloud Armor |
| Firewall | Network Firewall | Azure Firewall | Cloud NGFW |

## Hybride Anbindung

Site-to-Site-VPN oder dedizierte Leitungen (Direct Connect, ExpressRoute, Interconnect) verbinden Rechenzentrum und Cloud. Dabei Routing und Firewall-Regeln so gestalten, dass die Cloud kein Umweg ins interne Netz wird.

## Zero Trust in der Cloud

Netzwerkgrenzen bleiben wichtig, aber die eigentliche Kontrolle liegt bei **Identität und Richtlinien**: wer darf mit welcher Rolle welche API aufrufen, von welchem Gerät, unter welchen Bedingungen.

## Quiz

? Wie heißt das Muster mit zentralem Netz und angebundenen Anwendungsnetzen?
= Hub-and-Spoke
= Hub and Spoke

? Was erreicht man mit Private Endpoints?
+ PaaS-Dienste sind nur über private Adressen erreichbar
- Dienste werden öffentlich
- Kosten verschwinden
- Logs werden gelöscht

? Wie heißt der DDoS-Schutzdienst von AWS?
= Shield
= AWS Shield

? Wie heißt eine vorbereitete, regelkonforme Grundstruktur für Cloud-Workloads?
= Landing Zone

@@@ MODULE @@@
---
id: cl-06
title: Cloud · Serverless und Infrastructure-as-Code-Sicherheit
paths: specialist, cwee
order: 75
difficulty: medium
icon: function
tags: cloud
summary: Sicherheitsmodell von Functions-as-a-Service, Rechte pro Funktion, Ereignisquellen als Eingaben, Abhängigkeiten, IaC-Scanning und Drift-Erkennung.
---

## Serverless verstehen

Bei **Functions as a Service** (AWS Lambda, Azure Functions, Google Cloud Functions) betreibt der Anbieter Server und Laufzeit. Der Kunde verantwortet Code, Abhängigkeiten, Rechte und Konfiguration.

| Risiko | Gegenmaßnahme |
|---|---|
| zu weite Rechte der Funktion | eigene Rolle pro Funktion, minimale Rechte |
| Ereignisdaten als ungeprüfte Eingabe (Queue, Upload, HTTP) | jede Ereignisquelle wie Benutzereingabe validieren |
| Secrets in Umgebungsvariablen im Klartext | Secret-Manager, Verschlüsselung |
| verwundbare Abhängigkeiten | SCA, kleine Pakete |
| Kostenmissbrauch („Denial of Wallet“) | Limits, Budgets, Alarme |
| fehlende Sicht | strukturierte Logs, Tracing |

## IaC-Sicherheit

Terraform-, CloudFormation-, Bicep- und Kubernetes-Dateien beschreiben Infrastruktur – Fehler darin werden automatisch ausgerollt ([[mod:f-16|Git und IaC]]).

| Werkzeug | Zweck |
|---|---|
| Checkov, tfsec/Trivy, KICS | IaC-Dateien auf Fehlkonfigurationen prüfen |
| Policy as Code (OPA, Sentinel) | Regeln vor dem Deployment erzwingen |
| Drift-Erkennung | Abweichungen zwischen Code und Realität finden |

> [!TIPP] Zustand schützen
> Terraform-State-Dateien enthalten oft Geheimnisse. Sie gehören in einen verschlüsselten, zugriffsbeschränkten Backend-Speicher – nicht ins Repository.

## Quiz

? Wer verantwortet bei Serverless Code, Abhängigkeiten und Rechte?
+ der Kunde
- der Anbieter
- niemand
- der Browser

? Wie nennt man Kostenangriffe auf Serverless-Funktionen?
= Denial of Wallet

? Welches Werkzeug prüft IaC-Dateien auf Fehlkonfigurationen?
+ Checkov
- Wireshark
- Volatility
- John

? Warum gehören Terraform-State-Dateien nicht ins Repository?
+ Sie enthalten oft Geheimnisse
- Sie sind zu klein
- Sie sind binär
- Terraform verbietet es

?tf Ereignisse aus Queues müssen wie Benutzereingaben validiert werden.
= wahr
