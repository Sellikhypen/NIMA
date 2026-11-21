---
id: b-07
title: Gängige Anwendungen und CMS absichern
paths: cpts, cwes
order: 24
difficulty: medium
icon: app.badge
summary: WordPress, Joomla, Drupal, Tomcat, Jenkins, GitLab, Grafana, Splunk, Webmail und Co. – typische Fehlkonfigurationen, warum Admin-Oberflächen so wertvoll sind und wie man sie erkennt und härtet.
htb: Attacking Common Applications
---

## Warum Standardanwendungen?

Unternehmen betreiben viele fertige Anwendungen: Content-Management-Systeme, Build-Server, Monitoring, Ticket- und Wiki-Systeme. Sie sind oft schnell installiert, aber selten gehärtet. Ihre Admin-Oberflächen erlauben häufig **bewusst** das Ausführen von Code (Plugins, Skripte, Build-Jobs) – wer Admin-Zugang erlangt, kontrolliert damit meist den Server.

## Typische Anwendungen und Risiken

| Anwendung | typische Fehler | Härtung |
|---|---|---|
| **WordPress** | veraltete Plugins/Themes, schwache Admin-Passwörter, offene Benutzer-Enumeration, XML-RPC | Updates automatisieren, wenige gepflegte Plugins, MFA, Login schützen, Dateibearbeitung im Admin deaktivieren |
| **Joomla / Drupal** | veraltete Kerne mit bekannten kritischen Lücken | Sicherheitsupdates sofort, Erweiterungen minimieren |
| **Apache Tomcat** | Manager-Oberfläche mit Standard- oder schwachen Zugangsdaten, erreichbar aus dem Netz | Manager entfernen oder auf Admin-Netz beschränken, starke Zugangsdaten |
| **Jenkins** | anonymer Zugriff, Skriptkonsole für viele Benutzer, Secrets in Jobs | Authentifizierung, Matrix-Rechte, Skriptkonsole nur für Admins, Credentials-Plugin |
| **GitLab / Gitea** | offene Registrierung, öffentliche Projekte mit Secrets, veraltete Versionen | Registrierung beschränken, Secret-Scanning, Updates |
| **Grafana / Kibana / Splunk** | Standardpasswörter, anonyme Dashboards, alte Versionen | Passwörter ändern, SSO, nicht öffentlich exponieren |
| **phpMyAdmin / Adminer** | Datenbank-Verwaltung offen im Netz | nur über VPN/Admin-Netz |
| **Webmail / Exchange OWA** | Passwort-Spraying-Ziel, kritische Lücken in On-Premise-Servern | MFA, schnelles Patchen, Monitoring |
| **ManageEngine, Citrix, Ivanti usw.** | häufig ausgenutzte, internetfähige Appliances | Patch-Priorität „sofort“, Admin-Oberflächen intern |

> [!WARNUNG] Standard-Zugangsdaten
> Viele Produkte werden mit bekannten Standardkonten ausgeliefert (admin/admin, tomcat/tomcat usw.). Das Ändern aller Standardzugänge gehört in jede Inbetriebnahme-Checkliste.

## Erkennen und inventarisieren

- Fingerprinting über Header, Login-Seiten, typische Pfade, Favicons und Versionsdateien
- automatisierte Erkennung mit Scannern (z. B. Nuclei-Vorlagen, Schwachstellenscanner)
- Abgleich der Versionen mit Sicherheitshinweisen der Hersteller und der CISA-KEV-Liste
- für WordPress: spezialisierte Scanner wie **WPScan** zur Prüfung von Kern, Plugins und Themes

## Allgemeine Härtungsliste für Anwendungen

1. Inventar mit Version und Verantwortlichem
2. Updates mit festen Fristen, Erweiterungen auf das Nötigste beschränken
3. Admin-Oberflächen nur aus dem Admin-Netz bzw. über SSO mit MFA
4. Standardkonten entfernen oder Passwörter ändern
5. Funktionen zur Codeausführung (Skriptkonsolen, Datei-Editoren) einschränken
6. Anwendung mit eigenem, unprivilegiertem Systemkonto betreiben
7. Logs zentral sammeln, Anmeldungen und Konfigurationsänderungen überwachen
8. Backups und getestete Wiederherstellung

## Quiz

? Warum sind Admin-Oberflächen von Anwendungen wie Jenkins oder Tomcat so wertvoll für Angreifer?
+ Sie erlauben oft bewusst das Ausführen von Code auf dem Server
- Sie sind immer verschlüsselt
- Sie enthalten keine Daten
- Sie laufen nur intern

? Welches Werkzeug prüft WordPress-Kern, Plugins und Themes?
= WPScan

? Welche Tomcat-Oberfläche sollte entfernt oder auf das Admin-Netz beschränkt werden?
= Manager
= Tomcat Manager

? Welche Jenkins-Funktion sollte nur Administratoren zur Verfügung stehen?
= Skriptkonsole
= Script Console

? Was ist bei WordPress die häufigste Ursache für Kompromittierungen?
+ veraltete Plugins und Themes
- zu lange Artikel
- die Farbwahl
- zu viele Kategorien

?tf Standard-Zugangsdaten sollten bei der Inbetriebnahme immer geändert werden.
= wahr
