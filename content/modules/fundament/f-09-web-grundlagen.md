---
id: f-09
title: Web-Anwendungen verstehen
paths: grundlagen, cjca, cwes, cpts
order: 9
difficulty: easy
icon: globe
summary: Wie Web-Apps aufgebaut sind – Frontend, Backend, Datenbank, Cookies, Sessions, Same-Origin-Policy, APIs und die OWASP Top 10 als Landkarte der häufigsten Fehler.
htb: Introduction to Web Applications
---

## Aufbau einer Web-Anwendung

| Schicht | Aufgabe | Technologien |
|---|---|---|
| Frontend | läuft im Browser, stellt dar | HTML, CSS, JavaScript, Frameworks wie React oder Vue |
| Backend | Logik, Rechte, Datenzugriff | PHP, Python, Node.js, Java, C#, Go |
| Datenbank | speichert Daten | MySQL, PostgreSQL, MSSQL, MongoDB |
| Infrastruktur | liefert aus, schützt | Webserver, Reverse Proxy, Load Balancer, [[WAF]] |

> [!MERKE] Goldene Regel
> Alles, was aus dem Browser kommt, steht unter Kontrolle des Benutzers – Formularfelder, versteckte Felder, Header, Cookies, JavaScript-Prüfungen. Sicherheitsentscheidungen müssen deshalb **immer auf dem Server** getroffen werden.

## Cookies und Sessions

HTTP ist zustandslos. Damit eine Anwendung weiß, wer angemeldet ist, erzeugt sie nach dem Login eine **[[Session]]** und gibt dem Browser eine zufällige Session-ID in einem **[[Cookie]]**. Bei jeder Anfrage schickt der Browser das Cookie mit.

| Cookie-Attribut | Schutzwirkung |
|---|---|
| `Secure` | nur über HTTPS senden |
| `HttpOnly` | für JavaScript unlesbar – erschwert Diebstahl per [[XSS]] |
| `SameSite=Lax/Strict` | nicht bei fremden Seiten mitsenden – schützt vor [[CSRF]] |
| `Domain` / `Path` | Geltungsbereich |
| `Expires` / `Max-Age` | Lebensdauer |

> [!WARNUNG] Session-Sicherheit
> Session-IDs müssen lang und zufällig sein, nach dem Login neu vergeben werden (gegen Session Fixation), beim Logout serverseitig ungültig werden und ablaufen.

## Same-Origin-Policy und CORS

Ein **Origin** ist die Kombination aus Schema, Host und Port (`https://shop.example:443`). Die **Same-Origin-Policy** verhindert, dass JavaScript einer Seite die Antworten einer anderen Origin liest. **CORS** lockert das gezielt: Der Server erlaubt über Header wie `Access-Control-Allow-Origin` bestimmten fremden Origins den Zugriff.

> [!GEFAHR] Zu offenes CORS
> Wer jede Origin zulässt und gleichzeitig Cookies erlaubt (`Allow-Credentials: true`), hebt den Schutz der Same-Origin-Policy praktisch auf.

## APIs

Moderne Anwendungen trennen Frontend und Backend über **APIs**, meist REST mit JSON, zunehmend GraphQL. Authentifizierung erfolgt oft über Tokens wie [[JWT]] im Header `Authorization: Bearer …`.

Typische Fehler liegen bei der **Autorisierung**: Ein Endpunkt prüft zwar, ob jemand angemeldet ist, aber nicht, ob er genau dieses Objekt sehen darf ([[IDOR]] bzw. Broken Object Level Authorization).

## Die OWASP Top 10 (2021)

Die [[OWASP]] Top 10 sind die bekannteste Übersicht der häufigsten Web-Risiken:

| Nr. | Kategorie | Kurz erklärt |
|---|---|---|
| A01 | Broken Access Control | Benutzer erreichen Daten oder Funktionen, die ihnen nicht zustehen |
| A02 | Cryptographic Failures | sensible Daten ungeschützt oder schwach verschlüsselt |
| A03 | Injection | Eingaben werden als Code oder Befehl interpretiert ([[SQL-Injection]], XSS, Command Injection) |
| A04 | Insecure Design | Sicherheitsfehler schon im Entwurf |
| A05 | Security Misconfiguration | Standardpasswörter, offene Debug-Modi, unnötige Dienste |
| A06 | Vulnerable and Outdated Components | veraltete Bibliotheken mit bekannten Lücken |
| A07 | Identification and Authentication Failures | schwache Logins, fehlendes MFA, Session-Fehler |
| A08 | Software and Data Integrity Failures | unsignierte Updates, unsichere Deserialisierung |
| A09 | Security Logging and Monitoring Failures | Angriffe werden nicht bemerkt |
| A10 | Server-Side Request Forgery ([[SSRF]]) | der Server ruft vom Angreifer bestimmte Adressen ab |

> [!INFO] Nachfolger: OWASP Top 10:2025
> Die neue Ausgabe ordnet um: A01 Broken Access Control (jetzt mit SSRF), A02 Security Misconfiguration, A03 Software Supply Chain Failures, A04 Cryptographic Failures, A05 Injection, A06 Insecure Design, A07 Authentication Failures, A08 Software or Data Integrity Failures, A09 Security Logging & Alerting Failures, A10 Mishandling of Exceptional Conditions. Nenne bei einer Nummer immer die Jahreszahl.

> [!EXAM] Für CWES, CPTS und CWEE
> Die Web-Pfade gehen jede dieser Klassen im Detail durch: wie die Schwachstelle entsteht, woran man sie erkennt und wie man sie behebt.

## Das Grundmuster aller Injections

Fast alle Injection-Lücken haben dieselbe Ursache: **Daten und Befehle werden vermischt.** Eine Anwendung baut aus Benutzereingaben einen String zusammen und übergibt ihn einem Interpreter – einer Datenbank, einer Shell, einem Browser, einer Template-Engine. Enthält die Eingabe Zeichen, die für diesen Interpreter eine Bedeutung haben, ändert sich die Logik.

Die Lösung folgt demselben Muster:

1. **Trennen statt zusammensetzen** – parametrisierte Abfragen (Prepared Statements), Argumentlisten statt Shell-Strings.
2. **Kontextgerecht kodieren** – HTML-Ausgaben HTML-kodieren, JavaScript-Kontexte entsprechend.
3. **Eingaben validieren** – erlaubte Formate positiv definieren (Allowlist).
4. **Rechte minimieren** – der Datenbankbenutzer der App braucht keine Admin-Rechte.

## Quiz

? Was bewirkt das Cookie-Attribut HttpOnly?
+ JavaScript kann das Cookie nicht lesen
- Das Cookie wird nur über HTTPS gesendet
- Das Cookie wird bei fremden Seiten nicht mitgesendet
- Das Cookie läuft nach einer Stunde ab

? Welches Cookie-Attribut schützt vor CSRF?
= SameSite

? Woraus besteht eine Origin?
+ Schema, Host und Port
- Host und Pfad
- IP-Adresse und Cookie
- Domain und Session-ID

? Welche Kategorie steht in den OWASP Top 10 (2021) auf Platz 1?
= Broken Access Control

? Wie heißt die Schwachstelle, bei der man durch Ändern einer ID fremde Objekte sieht?
= IDOR
= Insecure Direct Object Reference

? Was ist die Grundursache fast aller Injection-Lücken?
+ Daten und Befehle werden vermischt
- Fehlende Verschlüsselung
- Zu kurze Passwörter
- Veraltete Browser

? Welche Maßnahme verhindert SQL-Injection grundlegend?
= Prepared Statements
= parametrisierte Abfragen
= Parametrisierte Queries

?tf Eine Prüfung im JavaScript des Browsers reicht als Sicherheitskontrolle aus.
= falsch

? Wofür steht SSRF?
= Server-Side Request Forgery
