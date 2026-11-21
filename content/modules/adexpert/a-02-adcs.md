---
id: a-02
title: Active Directory Certificate Services (ADCS)
paths: cape
order: 12
difficulty: insane
icon: rosette
summary: Wie die Microsoft-PKI im AD funktioniert, Zertifikatsvorlagen und Enrollment, warum Fehlkonfigurationen zu Domänenübernahmen führen können, die bekannten Risikoklassen im Überblick und eine Prüf- und Härtungsliste.
---

## ADCS in einem Satz

**ADCS** ist die Zertifizierungsstelle von Microsoft, eng mit Active Directory verzahnt. Zertifikate werden u. a. für Smartcard-Anmeldung, WLAN (802.1X), Webserver und Verschlüsselung genutzt – und können zur **Kerberos-Anmeldung** (PKINIT) verwendet werden. Genau das macht Fehlkonfigurationen so folgenreich.

## Bausteine

| Begriff | Bedeutung |
|---|---|
| Enterprise CA | in AD integrierte Zertifizierungsstelle |
| Zertifikatsvorlage | Bauplan: wer darf beantragen, wofür gilt das Zertifikat (EKU), wer bestimmt den Inhaber |
| Enrollment | Beantragen eines Zertifikats (über RPC/DCOM oder Web-Enrollment) |
| EKU | Extended Key Usage, z. B. Client Authentication, Smart Card Logon |
| NTAuth-Store | Liste der CAs, deren Zertifikate für die AD-Anmeldung akzeptiert werden |

## Warum Fehlkonfigurationen kritisch sind

Wenn ein normaler Benutzer ein Zertifikat erhalten kann, das **eine beliebige Identität** ausweist und zur Anmeldung taugt, kann er sich als jeder Benutzer anmelden – auch als Domain Admin. Ein Zertifikat bleibt zudem gültig, selbst wenn das Passwort des Kontos geändert wird.

## Die bekannten Risikoklassen (Überblick)

Die Sicherheitsforschung (u. a. das Whitepaper „Certified Pre-Owned“) hat die Fehlkonfigurationen als **ESC1, ESC2 …** durchnummeriert. Für Prüfung und Härtung reicht es, die Muster zu kennen:

| Muster | Was ist falsch konfiguriert? | Behebung |
|---|---|---|
| Antragsteller bestimmt die Identität | Vorlage erlaubt „Supply in the request“ und Client-Authentifizierung für breite Gruppen | Option entfernen oder Manager-Freigabe erzwingen |
| zu allgemeine EKUs | „Any Purpose“ oder gar keine EKU | EKUs auf den Zweck beschränken |
| Enrollment-Agent-Vorlagen zu offen | Benutzer dürfen Zertifikate im Namen anderer beantragen | Enrollment-Agent-Rechte und Einschränkungen setzen |
| zu weite Rechte auf Vorlagen oder CA-Objekte | Benutzer dürfen Vorlagen ändern oder die CA verwalten | ACLs bereinigen, wie Tier-0 behandeln |
| CA-Flag `EDITF_ATTRIBUTESUBJECTALTNAME2` | jeder Antrag darf alternative Namen angeben | Flag entfernen |
| Web-Enrollment über HTTP mit NTLM | Anmeldungen lassen sich an die CA weiterleiten | HTTPS mit EPA, NTLM deaktivieren, Web-Enrollment abschalten, wenn nicht nötig |
| schwache Zertifikatszuordnung | Zertifikate werden zu locker Konten zugeordnet | starke Zuordnung erzwingen (Microsoft-Updates seit 2022) |

> [!GEFAHR] ADCS ist Tier 0
> Server mit Enterprise CA und alle Konten mit Rechten auf CA und Vorlagen gehören zur höchsten Schutzebene – genau wie Domain Controller.

## Prüfen

| Werkzeug | Zweck |
|---|---|
| PingCastle | meldet riskante Vorlagen und CA-Einstellungen |
| Certify / Certipy (im Audit- bzw. Find-Modus) | listet Vorlagen, Rechte und verwundbare Konfigurationen |
| PSPKIAudit | PowerShell-Audit von ADCS |
| BloodHound (mit ADCS-Daten) | Pfade über Zertifikatsdienste |

## Erkennung

- Ereignisse der CA: **4886** (Antrag erhalten), **4887** (Zertifikat ausgestellt) – besonders mit abweichendem Subject/SAN
- Kerberos-Anmeldungen mit Zertifikat (4768 mit Zertifikatsinformationen) für Konten, die sonst keine Smartcards nutzen
- Änderungen an Vorlagen (Ereignisse für Verzeichnisänderungen, 4899/4900)

## Quiz

? Wofür steht ADCS?
= Active Directory Certificate Services

? Warum kann ein falsch konfiguriertes Zertifikat zur Domänenübernahme führen?
+ Es kann eine beliebige Identität ausweisen und zur Kerberos-Anmeldung genutzt werden
- Es löscht den Domain Controller
- Es deaktiviert die Firewall
- Es verschlüsselt das Active Directory

? Wie heißt das Feld, das den Verwendungszweck eines Zertifikats festlegt?
= EKU
= Extended Key Usage

? Welche Schutzebene haben ADCS-Server im Tiering-Modell?
= Tier 0
= 0

? Welche CA-Ereignis-ID zeigt ein ausgestelltes Zertifikat?
= 4887

? Bleibt ein ausgestelltes Anmeldezertifikat nach einer Passwortänderung gültig?
+ Ja, bis es abläuft oder widerrufen wird
- Nein, es wird automatisch ungültig
- Nur bei RC4
- Nur bei Computerkonten

? Welche Werkzeuge listen verwundbare Zertifikatsvorlagen?
+ Certify / Certipy
+ PingCastle
- Wireshark
- Hashcat
