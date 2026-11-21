---
id: x-04
title: Sichere Softwareentwicklung und DevSecOps
paths: cwee, specialist, cwes
order: 14
difficulty: medium
icon: gearshape.2.fill
summary: Security im gesamten Entwicklungszyklus – Anforderungen, Threat Modeling, sichere Programmierrichtlinien, SAST/DAST/SCA in der CI/CD-Pipeline, Secrets, Supply-Chain-Sicherheit und SBOM.
---

## Shift Left

Je früher ein Sicherheitsfehler gefunden wird, desto billiger ist er zu beheben. **Shift Left** bedeutet, Sicherheit von Anfang an in den Entwicklungsprozess zu integrieren statt am Ende zu „testen“.

## Der sichere Entwicklungszyklus

| Phase | Sicherheitsaktivität |
|---|---|
| Anforderungen | Sicherheitsanforderungen definieren (z. B. nach OWASP ASVS) |
| Design | Threat Modeling (STRIDE), sichere Architekturmuster – siehe [[mod:s-06|Sicherheitsarchitektur]] |
| Implementierung | Coding-Richtlinien, Peer Reviews, IDE-Plugins |
| Build | SAST, SCA, Secret-Scanning, signierte Artefakte |
| Test | DAST, Pentests, Fuzzing |
| Release | Härtung, Konfigurationsprüfung, Freigabeprozess |
| Betrieb | Monitoring, Schwachstellenmanagement, Incident Response |

## Werkzeugklassen

| Abkürzung | Bedeutung | prüft |
|---|---|---|
| SAST | Static Application Security Testing | Quellcode ohne Ausführung |
| DAST | Dynamic Application Security Testing | laufende Anwendung von außen |
| IAST | Interactive AST | Anwendung von innen zur Laufzeit |
| SCA | Software Composition Analysis | Abhängigkeiten auf bekannte Lücken und Lizenzen |
| Secret-Scanning | – | Schlüssel und Passwörter im Code und in der Git-Historie |
| IaC-Scanning | – | Terraform, Kubernetes-Manifeste, Dockerfiles |
| Container-Scanning | – | Images auf veraltete Pakete |

## Secrets richtig verwalten

- niemals in Code, Konfigurationsdateien im Repo oder Container-Images
- zentrale Secret-Stores (HashiCorp Vault, Cloud Key Vaults, SOPS für verschlüsselte Dateien – wie in deiner [[mod:cr-06|Range]])
- kurze Lebensdauer, automatische Rotation
- versehentlich veröffentlichte Secrets sofort **widerrufen** – Löschen aus Git reicht nicht, die Historie bleibt

## Supply-Chain-Sicherheit

Angriffe auf Abhängigkeiten und Build-Systeme betreffen viele Kunden gleichzeitig.

| Risiko | Schutz |
|---|---|
| bekannte Lücken in Bibliotheken | SCA, automatische Update-PRs |
| Typosquatting / bösartige Pakete | geprüfte Registries, Lockfiles, Allowlists |
| kompromittierte Build-Pipeline | minimale Rechte für CI, kurzlebige Tokens, isolierte Runner |
| manipulierte Artefakte | Signaturen (z. B. Sigstore/cosign), reproduzierbare Builds |
| fehlende Transparenz | **SBOM** (Software Bill of Materials, z. B. CycloneDX, SPDX) |

> [!INFO] Frameworks
> SLSA (Supply-chain Levels for Software Artifacts) beschreibt Stufen für vertrauenswürdige Builds, das NIST SSDF (SP 800-218) Praktiken für sichere Entwicklung, OWASP SAMM ein Reifegradmodell.

## Sichere Programmierrichtlinien (Kurzfassung)

1. Alle Eingaben serverseitig validieren (Allowlist)
2. Ausgaben kontextgerecht kodieren
3. Parametrisierte Abfragen verwenden
4. Autorisierung bei jedem Zugriff prüfen
5. Bewährte Kryptobibliotheken nutzen, nichts selbst erfinden
6. Fehler abfangen, ohne interne Details preiszugeben
7. Sicherheitsrelevante Ereignisse protokollieren – ohne Geheimnisse in Logs
8. Abhängigkeiten aktuell halten
9. Least Privilege für Anwendungs- und Datenbankkonten
10. Sichere Standardwerte (Secure by Default)

## Quiz

? Welche Werkzeugklasse prüft Quellcode ohne Ausführung?
= SAST

? Welche Werkzeugklasse prüft eine laufende Anwendung von außen?
= DAST

? Welche Werkzeugklasse prüft Abhängigkeiten auf bekannte Lücken?
= SCA
= Software Composition Analysis

? Was ist eine SBOM?
+ eine Stückliste aller Softwarekomponenten
- ein Backup-Format
- ein Netzwerkprotokoll
- ein Passwort-Hash

? Was muss man tun, wenn ein Secret versehentlich in ein öffentliches Repository gelangt ist?
+ das Secret sofort widerrufen und ersetzen
- nur die Datei löschen
- das Repository umbenennen
- nichts, wenn es niemand bemerkt hat

? Wofür steht „Shift Left“?
+ Sicherheit früh im Entwicklungsprozess verankern
- Server nach links im Rack verschieben
- Logs nach links ausrichten
- Firewall-Regeln umkehren

? Welche Formate gibt es für SBOMs?
+ CycloneDX
+ SPDX
- STIX
- YARA
