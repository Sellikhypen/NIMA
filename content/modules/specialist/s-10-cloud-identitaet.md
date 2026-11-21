---
id: s-10
title: Cloud- und Identitätssicherheit
paths: specialist, cdsa
order: 10
difficulty: medium
icon: person.icloud
summary: Identität als Kontrollzentrum der Cloud – Entra ID, Conditional Access, Least Privilege mit IAM, Logging in AWS und Azure, CSPM und die häufigsten Fehlkonfigurationen.
---

## Identität ist der neue Perimeter

In der Cloud gibt es keinen klassischen Netzwerkrand. Wer gültige Zugangsdaten mit ausreichenden Rechten hat, kann von überall auf Ressourcen zugreifen. Deshalb steht **Identitäts- und Zugriffsmanagement** im Zentrum jeder Cloud-Sicherheit.

## Microsoft Entra ID (früher Azure AD)

| Funktion | Sicherheitsnutzen |
|---|---|
| **Conditional Access** | Zugriff abhängig von Benutzer, Gerät, Standort, Risiko – z. B. MFA erzwingen, Zugriff nur von verwalteten Geräten |
| **Privileged Identity Management (PIM)** | Admin-Rollen nur zeitlich begrenzt und mit Begründung aktivieren |
| Identity Protection | riskante Anmeldungen und Benutzer erkennen |
| Sign-in- und Audit-Logs | Grundlage für Untersuchungen |
| Legacy-Authentifizierung blockieren | alte Protokolle ohne MFA abschalten |

> [!WARNUNG] Häufige Lücken
> MFA-Ausnahmen für „Service-Konten“, nicht blockierte Legacy-Authentifizierung, zu viele Global Administrators, App-Registrierungen mit weitreichenden Rechten und lange gültigen Geheimnissen, fehlende Überwachung von Zustimmungen zu Drittanbieter-Apps (Consent Phishing).

## AWS IAM in Kürze

| Begriff | Bedeutung |
|---|---|
| User | dauerhafte Identität (für Menschen möglichst durch SSO ersetzen) |
| Role | annehmbare Identität mit temporären Zugangsdaten |
| Policy | JSON-Dokument mit erlaubten/verweigerten Aktionen auf Ressourcen |
| Root-Konto | allmächtig – nur für Notfälle, mit MFA, ohne Zugriffsschlüssel |

Prinzipien: keine Wildcards (`"Action": "*"`) in Policies, temporäre Zugangsdaten statt langlebiger Schlüssel, Rollen für Dienste, Permission Boundaries und Service Control Policies für Leitplanken.

## Logging

| Plattform | Protokolle |
|---|---|
| AWS | CloudTrail (API-Aufrufe), GuardDuty (Erkennung), VPC Flow Logs, Config |
| Azure | Activity Log, Entra Sign-in/Audit Logs, Defender for Cloud, NSG Flow Logs |
| Google Cloud | Cloud Audit Logs, Security Command Center |

Logs gehören zentral gesammelt, unveränderlich gespeichert und ins SIEM eingebunden.

## CSPM

**Cloud Security Posture Management** prüft Konfigurationen laufend gegen Benchmarks (CIS, Herstellerempfehlungen): öffentliche Speicher, offene Ports, fehlende Verschlüsselung, Logging deaktiviert, zu weite Rechte. Werkzeuge: Defender for Cloud, AWS Security Hub, Prowler, ScoutSuite.

## Quiz

? Welche Entra-Funktion steuert Zugriffe abhängig von Benutzer, Gerät und Risiko?
= Conditional Access

? Welche Funktion vergibt Admin-Rollen nur zeitlich begrenzt?
= PIM
= Privileged Identity Management

? Welcher AWS-Dienst protokolliert API-Aufrufe?
= CloudTrail

? Wie sollte das AWS-Root-Konto genutzt werden?
+ nur für Notfälle, mit MFA und ohne Zugriffsschlüssel
- täglich für alle Aufgaben
- mit geteiltem Passwort im Team
- gar nicht absichern

? Wofür steht CSPM?
= Cloud Security Posture Management

? Was ist Consent Phishing?
+ Benutzer werden dazu gebracht, einer bösartigen App weitreichende Rechte zu gewähren
- Phishing per SMS
- ein Angriff auf Router
- ein Backup-Fehler

?tf Legacy-Authentifizierung sollte blockiert werden, weil sie MFA umgehen kann.
= wahr
