---
id: cr-26
title: Container- und Cloud-Szenarien
paths: cyberrange
order: 26
difficulty: hard
icon: shippingbox.circle
summary: Kapitel 26 deiner Cyber-Range-Dokumentation: Container- und Cloud-Szenarien.
source: Cyber_Range_Dokumentation.docx
htb: 
---

## Überblick

Moderne Unternehmen betreiben Anwendungen zunehmend in Containern und in der Cloud. ATT&CK hat darauf reagiert und in Version 18 weitere Techniken für Container, Kubernetes, CI/CD und Cloud-Datenbanken aufgenommen. Eine zeitgemäße Range bildet diese Welt ebenfalls nach – vollständig lokal, ohne echte Cloud-Konten.

## Ein Kubernetes-Cluster als Teil der Range

![Abbildung 70: Kubernetes-Cluster in der Range mit Angriffsfläche und Erkennung](asset:cyberrange/cr-26-070.png)

**So liest man die Abbildung:**

- Der Cluster besteht aus drei VMs: einer **Control Plane** (API-Server, etcd) und zwei **Workern** mit dem Kubelet.
- In den Workern laufen Pods mit absichtlichen Konfigurationsfehlern (rot und orange), z. B. ein privilegierter Pod oder ein Dienst ohne Passwort.
- Von außen ist der Cluster nur über den **Ingress**-Controller erreichbar.
- Rechts die **Erkennung**: Falco beobachtet Systemaufrufe, das Audit-Log des API-Servers protokolliert jede Anfrage, Zeek und Wazuh überwachen die Knoten.
| **Variante** | **Werkzeug** | **Ressourcen** | **Eignung** |
|---|---|---|---|
| **Leichtgewichtig** | k3s (einzelne Binärdatei) | 1–3 VMs, je 2 vCPU / 4 GB | **empfohlen für die Range** |
| **Kubernetes in Docker** | kind | 1 VM | schnelle Labs, weniger realistisch |
| **Standard-Distribution** | kubeadm | 3+ VMs | realistisch, mehr Aufwand |

Tabelle 160: Varianten für einen Range-Cluster

## Konfigurationsfehler als Lernstoff

Die meisten Vorfälle in Container-Umgebungen entstehen nicht durch exotische Schwachstellen, sondern durch **Fehlkonfiguration**. Die Range nutzt genau diese typischen Fehler – und das Blue Team lernt, sie zu finden und abzustellen.

| **Fehlkonfiguration** | **Risiko** | **Richtige Konfiguration** |
|---|---|---|
| **Privilegierte Container** | Container hat nahezu Host-Rechte | Pod Security Admission »restricted«, keine privileged-Flags |
| **ServiceAccount-Token automatisch in jedem Pod** | Token kann für API-Zugriffe missbraucht werden | automountServiceAccountToken: false, wo nicht benötigt |
| **Zu weite RBAC-Rechte** | Ein Pod darf Secrets lesen oder neue Pods erzeugen | minimale Roles, regelmäßige Prüfung |
| **Keine Netzwerk-Richtlinien** | Jeder Pod erreicht jeden Pod | Standard »deny all« plus gezielte Freigaben |
| **Ungeschützte Datenbank im Cluster** | Daten ohne Anmeldung lesbar | Passwort, Netzwerk-Richtlinie, Secret-Verwaltung |
| **Kubelet-API offen** | Befehle in Pods über Port 10250 | anonyme Authentifizierung aus, Webhook-Autorisierung |

Tabelle 161: Typische Fehlkonfigurationen und ihre Korrektur

**Härtung: Pod Security Admission und Netzwerk-Richtlinie**

```
# Namespace auf das strengste Pod-Security-Profil setzen
apiVersion: v1
kind: Namespace
metadata:
  name: shop
  labels:
    pod-security.kubernetes.io/enforce: restricted
    pod-security.kubernetes.io/audit: restricted
---
# Standard: aller eingehende und ausgehende Verkehr im Namespace verboten
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: default-deny-all
  namespace: shop
spec:
  podSelector: {}
  policyTypes: [ Ingress, Egress ]
```

**Falco-Regel zur Erkennung von Shells in Containern**

```
# Falco-Regel (vereinfacht): interaktive Shell in einem Container
- rule: Shell in Container gestartet
  desc: Eine interaktive Shell wurde in einem Container geöffnet
  condition: >
    spawned_process and container and proc.name in (bash, sh, zsh) and proc.tty != 0
  output: >
    Shell im Container (user=%user.name container=%container.name image=%container.image.repository
    cmd=%proc.cmdline)
  priority: WARNING
  tags: [container, shell, mitre_execution]
```

## Cloud-Dienste lokal simulieren

Echte Cloud-Konten haben in einer isolierten Range nichts zu suchen. Viele Cloud-Konzepte lassen sich aber lokal nachbilden, sodass Teilnehmer den Umgang mit Objektspeichern, Zugangsschlüsseln und Cloud-Logs üben können:

| **Cloud-Konzept** | **Lokale Nachbildung** | **Lernziel** |
|---|---|---|
| **Objektspeicher (S3-kompatibel)** | MinIO oder Ceph RGW im SINET | Fehlkonfigurierte öffentliche Buckets erkennen |
| **Cloud-APIs** | LocalStack (Emulation vieler AWS-Dienste) | Protokolle von API-Aufrufen auswerten |
| **Identitätsdienst** | Keycloak als »Cloud-IdP« für eine Fake-SaaS-Anwendung | Anmeldeprotokolle, MFA-Umgehungsversuche erkennen |
| **CI/CD-Plattform** | Gitea mit Actions im Übungsnetz | Geheimnisse in Pipelines, manipulierte Builds |

Tabelle 162: Lokale Nachbildung von Cloud-Diensten

> [!WARNUNG] Echte Cloud nur getrennt
> Soll eine echte Cloud-Umgebung trainiert werden, geschieht das in einem eigenen, isolierten Cloud-Konto ohne Verbindung zur Range und ohne Produktivdaten – mit Kostenbudget, Alarmen und automatischem Abbau nach der Übung.

## Die eigene Pipeline als Teil der Angriffsfläche

CI/CD-Pipelines haben in den letzten Jahren als Angriffsziel stark an Bedeutung gewonnen: Wer eine Pipeline kontrolliert, kann Schadcode in Software einschleusen, die anschließend an viele Systeme verteilt wird (Lieferkettenangriff). ATT&CK hat in Version 18 entsprechende Techniken ergänzt. Für die Range ergibt sich daraus zweierlei: Die **eigene** Pipeline (Gitea auf iac-01) muss geschützt werden, und eine **nachgebildete** Pipeline im Übungsnetz eignet sich hervorragend als Szenario-Baustein.

| **Schutzmaßnahme** | **Umsetzung auf iac-01** |
|---|---|
| **Geschützte Branches** | Direkte Pushes auf `main` verboten, Zusammenführen nur nach Review |
| **Geheimnisse getrennt** | API-Token nur als verschlüsselte Pipeline-Geheimnisse, nie im Code; je Pipeline nur die nötigen Rechte |
| **Runner isolieren** | Runner laufen in eigener VM bzw. eigenem Container, nur mit Zugriff auf die benötigten Ziele |
| **Abhängigkeiten festlegen** | feste Versionen für Provider, Plugins und Ansible-Collections (Lock-Dateien) |
| **Herkunft dokumentieren** | Software-Stückliste (SBOM) für selbst gebaute Images und Templates |
| **Protokollierung** | Gitea-Audit-Log und Pipeline-Läufe an das SIEM senden |

Tabelle 163: Schutz der eigenen Pipeline

> [!TIPP] Szenario-Baustein »manipulierte Pipeline«
> Eine Gitea-Instanz im Übungsnetz mit einer Build-Pipeline für die Webshop-Anwendung macht ein Lieferketten-Szenario möglich: Das Blue Team lernt, Pipeline-Protokolle zu lesen, unerwartete Änderungen an Build-Skripten zu erkennen und die Herkunft eines ausgelieferten Artefakts zurückzuverfolgen.
