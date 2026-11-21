---
id: cr-09
title: L6 – Zugang, Identitäten und Portal
paths: cyberrange
order: 9
difficulty: medium
icon: person.badge.key
summary: Kapitel 9 deiner Cyber-Range-Dokumentation: L6 – Zugang, Identitäten und Portal.
source: Cyber_Range_Dokumentation.docx
htb: Cyber Range 09 · L6 Zugang & Identität
---

## Überblick

Die oberste Schicht regelt, **wie Menschen in die Range gelangen** – und vor allem, dass sie nur dorthin gelangen, wo sie hin dürfen. Der Grundsatz: Teilnehmer erhalten **keinen** Netzwerkzugang zur Range, sondern nur eine Bildschirmübertragung im Browser.

## Identitäten mit Keycloak

Keycloak ist der zentrale Identitätsanbieter (IAM). Er verwaltet Benutzer, Gruppen und Zweitfaktoren (TOTP) und meldet Benutzer per OpenID Connect bei allen Anwendungen an (Single Sign-on). Rollen werden über Gruppen abgebildet (RBAC):

| **Gruppe** | **Mitglieder** | **Guacamole-Verbindungen** | **Weitere Rechte** |
|---|---|---|---|
| **green** | Infrastruktur-Team | alle (Notfallzugriff) | Proxmox-Admin (separat über Admin-VPN), Gitea |
| **white** | Übungsleitung | lesend/Aufzeichnungen | CTFd-Admin, Scoring, Grafana-Lagebild |
| **red** | Angreifer | kali01, kali02 | – |
| **blue-1** | Verteidiger Team 1 | soc01, Admin-Zugänge der eigenen Systeme | SIEM Team 1 |
| **blue-2** | Verteidiger Team 2 | soc02 … | SIEM Team 2 |

Tabelle 60: Rollen und Rechte

## Remote-Zugang mit Apache Guacamole

Guacamole zeigt RDP-, SSH- und VNC-Sitzungen direkt im Browser. Es besteht aus zwei Teilen: der **Webanwendung** (Java/Tomcat) und dem Proxy-Dienst **guacd** (Port 4822), der die eigentlichen Verbindungen zu den VMs aufbaut. Sitzungen können aufgezeichnet und vom White Team später abgespielt werden – wertvoll für die Nachbesprechung.

![Abbildung 34: Anmeldung über Keycloak und Remote-Desktop-Sitzung über Guacamole](asset:cyberrange/cr-09-034.png)

**So liest man die Abbildung:**

- Schritte 1–5: Der Browser wird zu Keycloak umgeleitet, der Benutzer meldet sich mit Passwort und Einmalcode an, Keycloak bestätigt die Identität inklusive Gruppenzugehörigkeit per signiertem Token.
- Schritt 6: Guacamole prüft anhand der Gruppe, welche Verbindungen angezeigt werden.
- Schritte 7–12: Über einen WebSocket-Tunnel spricht der Browser mit der Webanwendung; `guacd` baut die RDP-Verbindung zur VM auf und übersetzt die Bildschirmdaten in Guacamole-Instruktionen, die der Browser darstellt.
## Portal, Aufgaben und Kommunikation

- **CTFd** – Aufgabenplattform mit Flaggen, Hinweisen und Punktetafel; für Forensik-Fragen (»Welche IP hatte der C2-Server?«) und Einzeltrainings.
- **Ticketsystem/Formulare** – Blue Teams melden Vorfälle strukturiert (Zeit, System, Technik, Maßnahme) – Grundlage der Bewertung.
- **Chat** (z. B. Mattermost oder Matrix) – getrennte Kanäle je Team plus Kanal zur Übungsleitung.
- **Admin-VPN (WireGuard, UDP 51820)** – ausschließlich für das Green Team in das MGMT-Netz, getrennt vom Teilnehmerzugang.
## Anmeldung mit OpenID Connect im Detail

Alle Webanwendungen der Range (Portal, CTFd, Gitea, Grafana, Guacamole) melden Benutzer über Keycloak an. Für Anwendungen mit eigenem Server-Teil ist der **Authorization Code Flow mit PKCE** der empfohlene Ablauf. (Guacamole nutzt in seiner OIDC-Erweiterung den impliziten Ablauf, siehe Kapitel 9.2 – das Prinzip der Token-Prüfung ist identisch.)

![Abbildung 35: Authorization Code Flow mit PKCE zwischen Browser, Anwendung und Keycloak](asset:cyberrange/cr-09-035.png)

**So liest man die Abbildung:**

- Die Anwendung erzeugt einen geheimen Zufallswert (`code_verifier`) und schickt nur dessen Hash (`code_challenge`) mit der Weiterleitung zu Keycloak.
- Der Benutzer meldet sich **bei Keycloak** an – die Anwendung sieht das Passwort nie. Mit MFA (TOTP) ist die Anmeldung zweistufig.
- Keycloak gibt dem Browser nur einen kurzlebigen **Code** zurück. Erst die Anwendung tauscht ihn serverseitig – mit dem `code_verifier` – gegen die Tokens.
- Die Anwendung prüft die Signatur des **ID-Tokens** mit den öffentlichen Schlüsseln aus dem JWKS und liest die **Claims**, z. B. die Gruppen.
**Dekodiertes ID-Token (Beispiel)**

```
Header:  {"alg":"RS256","typ":"JWT","kid":"q3Xn…"}
Payload: {
  "iss": "https://sso.range.local/realms/range",
  "aud": "ctfd",
  "sub": "5c1e…",
  "preferred_username": "blue3-anna",
  "groups": ["blue-team-3"],
  "exp": 1795689600, "iat": 1795686000,
  "acr": "1", "amr": ["pwd","otp"]
}
Signature: RSASSA-PKCS1-v1_5 mit SHA-256 über Header.Payload
```

> [!TIPP] Gruppen als Claim ausliefern
> Damit Anwendungen die Teamzugehörigkeit kennen, wird in Keycloak ein Client-Scope `groups` mit dem Mapper **Group Membership** angelegt (Token Claim Name `groups`, »Full group path« aus). Die Anwendungen ordnen den Gruppennamen dann Rollen zu, z. B. `blue-team-3` → Zugriff auf die Guacamole-Verbindungen von Team 3.

## Rollen- und Rechtekonzept

Das RBAC-Konzept legt fest, wer was darf. Es folgt dem Prinzip der geringsten Rechte: Jede Rolle erhält genau die Rechte, die sie für ihre Aufgabe braucht.

![Abbildung 36: Rollen- und Rechtematrix der Range](asset:cyberrange/cr-09-036.png)

**So liest man die Abbildung:**

- **Zeilen** sind Rollen, **Spalten** Ressourcen. Die Farbe zeigt die Stärke des Zugriffs.
- Das **Red Team** administriert nur seine eigenen Angriffssysteme und sieht das Scoreboard.
- Das **Blue Team** nutzt die Konsolen der Firmen-VMs und die SOC-Werkzeuge, darf aber keine PCAP-Rohdaten anderer Teams sehen.
- Nur das **Green Team** hat Zugriff auf die Proxmox-API. Das White Team sieht alles lesend und steuert Scoreboard und Injects.
| **Keycloak-Gruppe** | **Guacamole** | **CTFd** | **Security Onion / Wazuh** | **Grafana** |
|---|---|---|---|---|
| **red-team** | Verbindungen kali01/02, c2-01 | Teilnehmer | kein Zugriff | kein Zugriff |
| **blue-team-N** | Verbindungen der Firmen-VMs von Team N | Teilnehmer (Team N) | Analyst (eigene Daten) | Lesen (Team-Dashboard) |
| **white-team** | alle (nur Ansehen, Session-Sharing) | Admin | Analyst (alle Daten) | Admin |
| **green-team** | Admin | Admin | Admin | Admin |
| **observer** | keine | Scoreboard | kein Zugriff | Lesen (Übersicht) |

Tabelle 61: Abbildung der Keycloak-Gruppen auf Anwendungsrollen

## Guacamole-Verbindungen richtig konfigurieren

Jede Verbindung in Guacamole ist ein Datensatz mit Protokoll und Parametern. Einige Parameter sind für Ranges besonders wichtig, weil sie Sicherheit, Aufzeichnung und Bedienbarkeit bestimmen:

| **Parameter** | **Wert (Beispiel)** | **Bedeutung** |
|---|---|---|
| **hostname / port** | 10.10.30.101 / 3389 | Ziel-VM im Übungsnetz (über SVC erreichbar) |
| **security** | nla | Network Level Authentication für RDP |
| **ignore-cert** | true | selbstsignierte RDP-Zertifikate der Übungs-VMs akzeptieren |
| **disable-copy / disable-paste** | true / false | verhindert Datenabfluss aus der Range per Zwischenablage |
| **enable-drive** | false | kein Dateiaustausch mit dem Teilnehmer-PC |
| **recording-path / recording-name** | /recordings / ${GUAC_USERNAME}-${GUAC_DATE}-${GUAC_TIME} | Sitzungsaufzeichnung für AAR und Bewertung |
| **create-recording-path** | true | Verzeichnis automatisch anlegen |
| **resize-method** | display-update | Bildschirmgröße passt sich dem Browser an |

Tabelle 62: Wichtige Parameter einer RDP-Verbindung in Guacamole

> [!INFO] Aufzeichnungen auswerten
> Guacamole speichert Sitzungen in einem eigenen Protokollformat. Mit dem Werkzeug `guacenc` lassen sich daraus Videos erzeugen; seit Version 1.5 können Aufzeichnungen auch direkt in der Weboberfläche abgespielt werden. Guacamole 1.6.0 (Juni 2025) brachte zusätzlich eine eigene **AUDIT-Berechtigung**: Das White Team kann so den Verlauf einsehen, ohne Administratorrechte zu benötigen.

## Onboarding der Teilnehmer

1. **Zwei Wochen vorher:** Konten in Keycloak per Skript aus der Teilnehmerliste anlegen (Gruppe = Team), Einladungsmail mit Link zur Passwortvergabe.
1. **Eine Woche vorher:** Teilnehmer richten TOTP ein und testen den Zugang zum Portal (ohne Range-Zugriff).
1. **Vortag:** Green Team schaltet die Guacamole-Verbindungen frei; Funktionstest durch je eine Person pro Team.
1. **Übungstag, Briefing:** Spielregeln (RoE), Ansprechpartner, Kommunikationskanäle, Notfall-Kontakt.
1. **STARTEX:** Zugang zu den Systemen wird aktiv; Scoring beginnt.
1. **Nach ENDEX:** Range-Zugänge sofort sperren, Portal und Berichte bleiben für den AAR lesbar.
1. **Nach dem AAR:** Konten deaktivieren und nach der vereinbarten Frist löschen (Datenschutz).
## Den Keycloak-Realm einrichten

Keycloak gliedert alles in **Realms**. Ein Realm ist ein abgeschlossener Bereich mit eigenen Benutzern, Gruppen und Anwendungen. Die Range nutzt einen eigenen Realm »range« – der vorinstallierte Realm »master« bleibt ausschließlich der Verwaltung vorbehalten.

![Abbildung 37: Aufbau des Keycloak-Realms »range«](asset:cyberrange/cr-09-037.png)

**So liest man die Abbildung:**

- Unter dem Realm hängen vier Bereiche: **Clients** (die angebundenen Anwendungen), **Gruppen** (Teams), **Authentifizierung** (Anmeldeablauf) und **Client-Scopes** (welche Informationen in die Tokens kommen).
- Jede Anwendung ist ein eigener **Client** mit eigener Weiterleitungsadresse und eigenem Geheimnis.
- Die **Gruppen** entsprechen den Teams; über den **Mapper** »groups« erfahren die Anwendungen, zu welchem Team ein Benutzer gehört.
- Der Anmeldeablauf verlangt **Passwort und Einmalcode**; das Einrichten des Einmalcodes ist beim ersten Login Pflicht.
1. In der Admin-Konsole (Realm »master«) einen neuen Realm **range** anlegen.
1. Unter **Realm settings → Security defenses → Brute force detection** die Sperre nach wiederholten Fehlversuchen aktivieren.
1. Unter **Authentication** den Browser-Ablauf so einstellen, dass ein Einmalcode (OTP) verlangt wird; unter **Required actions** »Configure OTP« als Standard setzen.
1. Unter **Groups** die Gruppen red-team, blue-team-1 … n, white-team, green-team, observer anlegen.
1. Unter **Client scopes** einen Scope **groups** mit dem Mapper-Typ »Group Membership« anlegen (Claim-Name `groups`, vollständiger Gruppenpfad aus).
1. Für jede Anwendung einen **Client** anlegen: Protokoll OpenID Connect, gültige Weiterleitungsadressen exakt angeben (keine Platzhalter wie `*`), Scope »groups« zuweisen.
1. Unter **Sessions** die maximale Sitzungsdauer auf einen Übungstag begrenzen (z. B. 10 Stunden).
1. Den Realm exportieren und die Datei (ohne Geheimnisse) im Git-Repository ablegen – so lässt er sich bei einem Neuaufbau importieren.
> [!WARNUNG] Weiterleitungsadressen genau angeben
> Ein Client mit der Weiterleitungsadresse `*` akzeptiert beliebige Ziele – ein Angreifer könnte Tokens auf eine eigene Seite umleiten. In der Range werden deshalb nur die exakten Adressen der Anwendungen eingetragen, etwa `https://ctf.range.local/oauth/callback`.

## Guacamole-Verbindungen automatisch anlegen

Bei mehreren Teams mit je einem Dutzend VMs entstehen schnell hundert Verbindungen. Sie werden nicht von Hand angelegt, sondern aus den Ausgaben von OpenTofu erzeugt. Guacamole bietet dafür eine REST-Schnittstelle:

**Verbindungen über die Guacamole-REST-API anlegen (Beispiel)**

```
#!/usr/bin/env python3
"""Legt Guacamole-Verbindungen für ein Team aus dem OpenTofu-Inventar an (vereinfacht)."""
import json, requests

GUAC = "https://access.range.local/guacamole"
DS = "postgresql"                                   # Datenquelle der Guacamole-Datenbank
tok = requests.post(f"{GUAC}/api/tokens", data={"username": "svc-provision", "password": open("/run/secrets/guac").read().strip()}).json()["authToken"]
inv = json.load(open("tofu-output.json"))["inventory"]["value"]

for host, v in inv.items():
    proto, port = ("rdp", "3389") if host.startswith(("dc", "fs", "ws")) else ("ssh", "22")
    conn = {
        "parentIdentifier": "ROOT", "name": f"team1 – {host}", "protocol": proto,
        "parameters": {"hostname": v["ip"], "port": port, "security": "nla" if proto == "rdp" else "",
                       "ignore-cert": "true", "disable-copy": "true", "enable-drive": "false",
                       "recording-path": "/recordings", "recording-name": "${GUAC_USERNAME}-${GUAC_DATE}-${GUAC_TIME}",
                       "create-recording-path": "true"},
        "attributes": {"max-connections": "4", "max-connections-per-user": "2"},
    }
    r = requests.post(f"{GUAC}/api/session/data/{DS}/connections", params={"token": tok}, json=conn)
    r.raise_for_status()
```

Anschließend erhalten die Keycloak-Gruppen (die in Guacamole als Benutzergruppen erscheinen) das Leserecht auf die Verbindungen ihres Teams. Die Zugangsdaten zu den Ziel-VMs werden **nicht** in der Verbindung gespeichert: Teilnehmer melden sich an der VM mit den Konten an, die ihnen im Szenario zugeteilt wurden – das ist realistischer und verhindert, dass Guacamole zum Passwortspeicher wird.
