---
id: w-07
title: Mobile Sicherheit – iOS und Android
paths: wifi, specialist
order: 7
difficulty: medium
icon: iphone.gen3
summary: Sicherheitsmodelle von iOS und Android, Sandbox und Berechtigungen, App-Prüfung nach OWASP MASVS, MDM im Unternehmen, Risiken durch Sideloading, veraltete Geräte und unsichere Apps.
---

## Sicherheitsmodelle

| Merkmal | iOS | Android |
|---|---|---|
| App-Isolation | Sandbox pro App | Linux-Benutzer pro App + SELinux |
| Code-Signierung | Pflicht, Apple-Zertifikate | Pflicht, Entwicklerzertifikat |
| Verschlüsselung | Data Protection, Secure Enclave | dateibasiert, Hardware-Keystore |
| Updates | zentral von Apple, lange Unterstützung | abhängig von Hersteller und Modell |
| App-Quellen | App Store, in der EU auch alternative Marktplätze; Sideloading über Entwicklerzertifikate | Play Store und andere Quellen erlaubt |
| Berechtigungen | zur Laufzeit abgefragt | zur Laufzeit abgefragt |

> [!INFO] Sideloading und NIMA
> Auch NIMA wird per AltStore oder Sideloadly installiert: Die App wird dabei mit deiner eigenen Apple-ID neu signiert. Das funktioniert nur für Apps, deren Quelle du vertraust – bei NIMA ist das dein eigenes Repository mit nachvollziehbarem Build.

## Typische Risiken

| Risiko | Beschreibung |
|---|---|
| veraltete Geräte | ohne Sicherheitsupdates bleiben bekannte Lücken offen |
| Jailbreak / Root | hebt Schutzmechanismen auf |
| Apps aus unsicheren Quellen | Schadsoftware, Spionage-Apps |
| übermäßige Berechtigungen | Apps sammeln mehr Daten als nötig |
| unsichere App-Entwicklung | Klartext-Speicherung, fehlende Zertifikatsprüfung, hartkodierte Schlüssel |
| Phishing per SMS/Messenger | mobile Ansichten verbergen echte URLs |
| öffentliche WLANs | Mitlesen ohne durchgehende Verschlüsselung ([[mod:w-04|WLAN-Bedrohungen]]) |

## App-Prüfung nach OWASP MASVS

Der **Mobile Application Security Verification Standard** gliedert Anforderungen in:

| Bereich | Fragen |
|---|---|
| STORAGE | Werden sensible Daten sicher (Keychain/Keystore) gespeichert? |
| CRYPTO | Werden bewährte Verfahren korrekt genutzt? |
| AUTH | Ist die Authentifizierung serverseitig sicher? |
| NETWORK | TLS korrekt, ggf. Certificate Pinning? |
| PLATFORM | sichere Nutzung von Plattformfunktionen (WebViews, Deep Links, IPC) |
| CODE | aktuelle Abhängigkeiten, sichere Eingabeverarbeitung |
| RESILIENCE | Schutz gegen Manipulation (für besonders sensible Apps) |
| PRIVACY | Datensparsamkeit, Transparenz |

Der begleitende **OWASP MASTG** beschreibt die Testmethoden (statische Analyse, dynamische Analyse mit Werkzeugen wie Frida oder Objection in eigenen Testumgebungen).

## Mobile Device Management

| Funktion | Nutzen |
|---|---|
| Inventar und Compliance | nur aktuelle, nicht gejailbreakte Geräte erhalten Zugriff |
| Richtlinien | Code-Sperre, Verschlüsselung, Update-Pflicht |
| App-Verteilung | geprüfte Firmen-Apps, Blocklisten |
| Trennung | Arbeits- und Privatbereich (Android Work Profile, iOS User Enrollment) |
| Fernlöschung | bei Verlust oder Ausscheiden |

In Kombination mit Conditional Access ([[mod:s-10|Cloud und Identität]]) entscheidet der Gerätezustand über den Zugriff auf Unternehmensdaten.

## Quiz

? Wo speichert iOS kryptografische Schlüssel hardwaregeschützt?
= Secure Enclave

? Welcher OWASP-Standard beschreibt Sicherheitsanforderungen an mobile Apps?
= MASVS
= OWASP MASVS

? Welcher MASVS-Bereich behandelt die sichere Speicherung sensibler Daten?
= STORAGE

? Was bewirkt ein Jailbreak sicherheitstechnisch?
+ Er hebt Schutzmechanismen des Betriebssystems auf
- Er verbessert die Verschlüsselung
- Er installiert Updates schneller
- Er hat keine Auswirkungen

? Welche MDM-Funktion trennt Arbeits- und Privatbereich auf Android?
= Work Profile
= Arbeitsprofil

? Wo sollten mobile Apps Passwörter und Tokens speichern?
+ in Keychain bzw. Keystore
- in einer Textdatei
- in den App-Einstellungen im Klartext
- im Bildschirmfoto

?tf Bei Android hängt die Update-Versorgung stark vom Gerätehersteller ab.
= wahr
