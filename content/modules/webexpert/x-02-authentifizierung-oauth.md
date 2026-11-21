---
id: x-02
title: Authentifizierung, OAuth 2.0, OIDC und JWT
paths: cwee, cwes
order: 12
difficulty: hard
icon: person.badge.key.fill
summary: Wie moderne Anmeldung funktioniert – Passwort-Flows, Sessions vs. Tokens, OAuth-2.0-Flows, OpenID Connect, JWT-Aufbau und die typischen Implementierungsfehler mit ihren Gegenmaßnahmen.
---

## Authentifizierung vs. Autorisierung

| | Frage | Beispiel |
|---|---|---|
| Authentifizierung | **Wer** bist du? | Login mit Passwort und MFA |
| Autorisierung | **Was** darfst du? | Rolle „Admin“ darf Benutzer löschen |

Viele Schwachstellen entstehen, weil eine Anwendung nach erfolgreicher Authentifizierung die Autorisierung vergisst.

## Klassische Fehler bei Logins

| Fehler | Problem | Gegenmaßnahme |
|---|---|---|
| unterschiedliche Fehlermeldungen | verrät, ob ein Benutzer existiert | einheitliche Meldungen und Antwortzeiten |
| kein Rate Limiting | massenhaftes Raten möglich | Verzögerung, Sperren, CAPTCHA, MFA |
| schwacher Passwort-Reset | ratbare oder lange gültige Tokens, Host-Header-Vertrauen | lange Zufallstokens, kurze Gültigkeit, einmalig, feste Basis-URL |
| MFA nur im Frontend | Server prüft den zweiten Faktor nicht | MFA-Status serverseitig erzwingen |
| „Remember me“ mit vorhersagbarem Token | Sitzungen fälschbar | zufällige Tokens serverseitig speichern |

## Sessions vs. Tokens

| | serverseitige Session | Token (z. B. JWT) |
|---|---|---|
| Zustand | auf dem Server | im Token selbst |
| Widerruf | einfach (Session löschen) | schwierig – Token gilt bis Ablauf, außer man pflegt Sperrlisten |
| Skalierung | gemeinsamer Session-Speicher nötig | zustandslos |
| typischer Einsatz | klassische Web-Apps | APIs, Microservices, mobile Apps |

## JSON Web Tokens

Ein [[JWT]] besteht aus drei Base64URL-kodierten Teilen: `Header.Payload.Signatur`.

```json
{"alg":"RS256","typ":"JWT","kid":"2026-01"}
{"sub":"1234","name":"alice","role":"user","exp":1795200000}
```

| Fehlerklasse | Ursache | Gegenmaßnahme |
|---|---|---|
| Signatur wird nicht geprüft | Bibliothek nur zum Dekodieren genutzt | immer verifizieren |
| Algorithmus aus dem Token übernommen | Server akzeptiert, was der Token behauptet (z. B. `none` oder Wechsel zwischen asymmetrisch und symmetrisch) | erlaubten Algorithmus fest im Server konfigurieren |
| schwacher HMAC-Schlüssel | Schlüssel offline erratbar | langer Zufallsschlüssel bzw. asymmetrische Verfahren |
| `kid`/`jku`-Header ungeprüft | Server lädt Schlüssel aus angreiferkontrollierter Quelle | Schlüssel nur aus fester, vertrauenswürdiger Liste |
| fehlende Prüfung von `exp`, `aud`, `iss` | Token anderer Dienste oder abgelaufene Token gelten | alle Claims validieren |
| sensible Daten im Payload | Payload ist nur kodiert, nicht verschlüsselt | keine Geheimnisse ins JWT |

## OAuth 2.0

OAuth 2.0 regelt **delegierte Autorisierung**: Eine App erhält begrenzten Zugriff auf Ressourcen eines Benutzers, ohne dessen Passwort zu kennen.

| Rolle | Beispiel |
|---|---|
| Resource Owner | der Benutzer |
| Client | die App, die Zugriff möchte |
| Authorization Server | stellt Tokens aus |
| Resource Server | API mit den Daten |

**Authorization Code Flow mit PKCE** (empfohlen für alle Clients):

1. Client leitet den Benutzer mit `client_id`, `redirect_uri`, `scope`, `state` und `code_challenge` zum Authorization Server.
2. Benutzer meldet sich an und stimmt zu.
3. Authorization Server leitet mit einem **Code** zurück.
4. Client tauscht Code + `code_verifier` gegen ein **Access Token** (und ggf. Refresh Token).

> [!WARNUNG] Typische OAuth-Fehler
> - `redirect_uri` wird nicht exakt geprüft → Codes landen bei fremden Seiten
> - fehlender oder nicht geprüfter `state` → CSRF im Login-Flow
> - Implicit Flow (Token in der URL) – veraltet, nicht mehr verwenden
> - zu weite Scopes, langlebige Tokens ohne Widerruf
> - Kontoverknüpfung anhand unbestätigter E-Mail-Adressen

## OpenID Connect

**OIDC** baut auf OAuth 2.0 auf und ergänzt **Authentifizierung**: Neben dem Access Token liefert es ein **ID Token** (ein JWT mit Angaben zum Benutzer). Wichtig: Clients müssen Signatur, Aussteller (`iss`), Empfänger (`aud`), Ablauf und `nonce` prüfen. Deine Range nutzt OIDC mit Keycloak – siehe [[mod:cr-09|Kapitel L6]].

## Quiz

? Was beantwortet die Autorisierung?
+ Was darf ein Benutzer?
- Wer ist ein Benutzer?
- Welches Passwort hat ein Benutzer?
- Wo ist ein Benutzer?

? Aus wie vielen Teilen besteht ein JWT?
= 3
= drei

? Was ist am JWT-Payload falsch verstanden, wenn dort Geheimnisse stehen?
+ Der Payload ist nur kodiert, nicht verschlüsselt
- Der Payload ist zu kurz
- Der Payload ist signiert und daher geheim
- Der Payload wird nie übertragen

? Welcher OAuth-Flow wird heute für alle Clients empfohlen?
+ Authorization Code Flow mit PKCE
- Implicit Flow
- Password Grant
- kein Flow

? Wozu dient der Parameter state im OAuth-Flow?
+ Schutz vor CSRF im Login-Ablauf
- Speichern des Passworts
- Angabe der Token-Länge
- Auswahl des Algorithmus

? Was ergänzt OpenID Connect gegenüber OAuth 2.0?
+ Authentifizierung mit einem ID Token
- Verschlüsselung der Datenbank
- einen Passwort-Hash
- einen Firewall-Dienst

? Wo sollte der erlaubte JWT-Algorithmus festgelegt werden?
+ fest in der Server-Konfiguration
- im Token-Header
- im Browser
- in der URL
