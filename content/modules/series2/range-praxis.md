---
id: rp-01
title: Range-Praxis 1 · Eine Übung planen – vom Lernziel zum Szenario
paths: cyberrange
order: 40.1
difficulty: easy
icon: target
tags: cyber range, übung, didaktik
summary: Wie man eine Übung rückwärts plant – Zielgruppe, messbare Lernziele, Szenario, Umgebung, Bewertung und Nachbesprechung.
---

## Einfach erklärt

Eine gute Übung beginnt nicht mit der Technik, sondern mit der Frage: **Was sollen die Teilnehmenden danach können?** Wie bei einer Fahrstunde: Erst steht fest „heute üben wir Einparken“, dann sucht man den passenden Parkplatz.

## Rückwärtsplanung

1. **Zielgruppe**: Vorwissen, Rollen (SOC-Analysten, Admins, Management?).
2. **Lernziele** – messbar formuliert: „Die Teilnehmenden erkennen eine Kerberoasting-Aktivität in den DC-Logs innerhalb von 30 Minuten.“
3. **Format**: Tabletop, technisches Blue-Team-Labor, Red vs. Blue, CTF, Purple-Team-Workshop.
4. **Szenario**: Geschichte und Ablauf, die die Lernziele auslösen.
5. **Umgebung**: Welche Systeme, Daten, Werkzeuge sind nötig – nicht mehr.
6. **Bewertung**: Woran misst man das Erreichen der Lernziele?
7. **Nachbesprechung**: Was haben wir gelernt, was nehmen wir in den Alltag mit?

> [!MERKE] Weniger ist mehr
> Drei gut erreichte Lernziele sind besser als zehn halb erreichte. Überladene Szenarien frustrieren.

## Formate im Vergleich

| Format | Aufwand | Stärken |
|---|---|---|
| Tabletop | gering | Entscheidungen, Kommunikation, Prozesse |
| Blue-Team-Labor | mittel | Analyse-Handwerk |
| Red vs. Blue | hoch | Realismus, Teamarbeit unter Druck |
| CTF | mittel | Motivation, Breite |
| Purple-Workshop | mittel | Erkennung gezielt verbessern |

## Tiefer eingetaucht

Lernziele lassen sich mit der **Bloom-Taxonomie** abstufen: erinnern → verstehen → anwenden → analysieren → bewerten → erschaffen. Einsteiger-Übungen zielen auf Anwenden, Fortgeschrittene auf Analysieren und Bewerten.

Rahmenwerke wie das **NICE Framework** oder **ECSF** (European Cybersecurity Skills Framework) helfen, Übungen auf Rollen und Kompetenzen abzubilden – nützlich, wenn eine Range ein ganzes Ausbildungsprogramm trägt.

## Quiz

? Womit beginnt die Planung einer guten Übung?
+ mit messbaren Lernzielen für die Zielgruppe
- mit dem Kauf von Hardware
- mit der Auswahl der Farben
- mit dem Scoring-System
! Technik folgt dem Lernziel.

? Welches Format eignet sich besonders für Entscheidungen und Kommunikation mit geringem Aufwand?
= Tabletop
= Tabletop-Übung
! Ohne technische Umgebung, am Tisch durchgespielt.

?tf Je mehr Lernziele eine Übung hat, desto besser.
= falsch
! Wenige, gut erreichte Ziele sind wirksamer.

? Welche Taxonomie stuft Lernziele von „erinnern“ bis „erschaffen“ ab?
= Bloom
= Bloom-Taxonomie
! Hilft, Übungen passend zum Niveau zu gestalten.

? Was ist ein messbares Lernziel?
+ Teilnehmende erkennen Kerberoasting in DC-Logs innerhalb von 30 Minuten
- Teilnehmende verstehen Sicherheit besser
- Teilnehmende haben Spaß
- Teilnehmende lernen viel
! Messbar heißt: beobachtbar und überprüfbar.

@@@ MODULE @@@
---
id: rp-02
title: Range-Praxis 2 · Drehbuch, Injects und White Cell
paths: cyberrange
order: 40.2
difficulty: medium
icon: theatermasks.fill
tags: cyber range, msel, white team
summary: Wie man eine Übung steuert – MSEL, Injects, Auslöser, Rollen der White Cell, Eskalationen und spontane Anpassungen.
---

## Einfach erklärt

Eine Übung ist wie ein Theaterstück mit Improvisation: Es gibt ein **Drehbuch** (MSEL), in dem steht, wann was passiert, und eine **Regie** (White Cell), die beobachtet, Ereignisse einspielt und notfalls umsteuert, wenn die Teilnehmenden einen anderen Weg nehmen als erwartet.

## Das MSEL (Master Scenario Events List)

| Zeit | Inject | Kanal | Erwartete Reaktion | Lernziel |
|---|---|---|---|---|
| T+0:00 | Phishing-Mail an drei Nutzer | E-Mail | Meldung durch Nutzer, Analyse | LZ1 |
| T+0:30 | EDR-Alarm auf Client-07 | SIEM | Triage, Isolierung | LZ2 |
| T+1:15 | Anruf „Presse fragt nach Datenleck“ | Telefon | Kommunikation an Leitung | LZ4 |
| T+2:00 | Ungewöhnliche Anmeldung am DC | SIEM | Eskalation, AD-Untersuchung | LZ3 |

**Injects** sind Ereignisse, die eingespielt werden: technische (Angriffsschritte, Logs) und nicht-technische (Anrufe, E-Mails von „Kunden“, Presseanfragen).

## Rollen

| Rolle | Aufgabe |
|---|---|
| White Cell / Exercise Control | steuert, spielt Injects ein, beantwortet Fragen „der Welt“ |
| Red Cell | führt Angriffsschritte aus |
| Trainees (Blue) | reagieren |
| Beobachter / Evaluatoren | bewerten anhand der Lernziele |
| Green Team | betreibt die Technik der Range |

> [!TIPP] Plan B für jeden Inject
> Teams finden manchmal Spuren nicht – oder viel zu schnell. Für wichtige Lernziele vorbereitete Hilfestellungen („Ein Kollege erwähnt …“) und Beschleuniger einplanen.

## Tiefer eingetaucht

Die White Cell führt ein Übungsprotokoll: Welche Injects wann, welche Reaktionen, welche Abweichungen. Das ist Grundlage für die Bewertung und den Hot-Wash direkt danach.

Wichtig sind klare **Spielregeln**: Was ist „im Spiel“, was nicht (echte Produktionssysteme sind tabu)? Wie kennzeichnet man Übungskommunikation („ÜBUNG ÜBUNG ÜBUNG“), damit niemand eine Übungs-Pressemitteilung für echt hält? Und ein Abbruchwort für echte Notfälle.

## Quiz

? Wofür steht MSEL?
= Master Scenario Events List
! Das Drehbuch mit allen geplanten Injects.

? Was ist ein Inject?
+ ein eingespieltes Ereignis, das eine Reaktion auslösen soll
- ein Virus
- eine Firewall-Regel
- ein Teilnehmer
! Technisch (Logs, Angriffe) oder nicht-technisch (Anrufe, Mails).

? Welche Rolle steuert die Übung und spielt Injects ein?
= White Cell
= White Team
= Exercise Control
! Sie ist die Regie der Übung.

?tf Übungskommunikation sollte klar als Übung gekennzeichnet sein.
= wahr
! Damit sie nicht mit echten Ereignissen verwechselt wird.

? Wozu dient ein Plan B für wichtige Injects?
+ um Lernziele auch zu erreichen, wenn Teams Spuren nicht finden oder zu schnell sind
- um die Übung zu verlängern
- um Teilnehmer zu bestrafen
- um Kosten zu sparen
! Hilfestellungen und Beschleuniger halten die Übung auf Kurs.

@@@ MODULE @@@
---
id: rp-03
title: Range-Praxis 3 · Firewall und Netz mit OPNsense aufbauen
paths: cyberrange
order: 40.3
difficulty: medium
icon: firewall
tags: opnsense, firewall, cyber range
summary: Eine OPNsense als zentrale Range-Firewall – Interfaces, VLANs, Regeln, NAT, DHCP/DNS, Logging und Schutz des Management-Zugangs.
---

## Einfach erklärt

In einer Range ist die Firewall das Verkehrsministerium: Sie verbindet die Teilnetze (Angreifer, DMZ, Büro, Server, SOC), legt fest, wer mit wem sprechen darf, und schreibt alles mit. **OPNsense** ist eine freie, gut dokumentierte Firewall-Distribution – ideal für Labore.

## Grundaufbau

| Interface | Netz | Zweck |
|---|---|---|
| WAN | Uplink / NAT ins echte Netz (stark eingeschränkt) | Updates, nur wenn nötig |
| LAN-Mgmt | 10.10.0.0/24 | Verwaltung, nur Range-Admins |
| VLAN 20 DMZ | 10.10.20.0/24 | Web, Mail |
| VLAN 30 Clients | 10.10.30.0/24 | Arbeitsplätze |
| VLAN 40 Server | 10.10.40.0/24 | AD, Fileserver |
| VLAN 50 SOC | 10.10.50.0/24 | SIEM, Sensoren |
| VLAN 66 Red | 10.10.66.0/24 | Angreifer |

## Regeln (Beispiele)

1. Standard: alles blockieren (implizit), Logging für Blockaden aktivieren.
2. Red → DMZ: HTTP/HTTPS, SMTP erlaubt (realistische Angriffsfläche).
3. Clients → Server: DNS, Kerberos, LDAP, SMB – wie in einem echten Unternehmen.
4. Alle → SOC: Syslog/Agent-Ports erlaubt; SOC → alle: nur Management, wenn nötig.
5. Range → echtes Internet: blockiert (oder nur über Proxy für Updates).

> [!GEFAHR] Ausbruchschutz
> Die Range darf niemals echte Systeme außerhalb erreichen – Angriffsverkehr könnte sonst unbeteiligte Dritte treffen. Egress vom Range-Netz ins echte Netz strikt blockieren und regelmäßig testen.

## Tiefer eingetaucht

Logs der Firewall gehen per Syslog an das SIEM der Range – für Blue-Team-Übungen eine wichtige Datenquelle. Konfiguration als XML sichern und versionieren, damit sie nach jeder Übung reproduzierbar ist. Für Szenarien mit IDS lässt sich **Suricata** direkt auf OPNsense aktivieren. Die Weboberfläche gehört ausschließlich ins Management-Netz, mit starkem Passwort/MFA.

## Quiz

? Was ist OPNsense?
+ eine freie Firewall-Distribution
- ein SIEM
- ein Virenscanner
- ein Passwortmanager
! Gut geeignet für Labore und kleine bis mittlere Netze.

? Warum muss Egress aus der Range ins echte Netz blockiert werden?
+ damit Angriffsverkehr keine unbeteiligten Systeme trifft
- damit Updates schneller laufen
- weil es Strom spart
- weil OPNsense es verlangt
! Ausbruchschutz ist die wichtigste Range-Regel.

? Wohin sollten die Firewall-Logs in einer Range gehen?
+ an das SIEM der Range
- an die Presse
- nirgendwohin
- an das echte Unternehmens-SIEM
! Sie sind wichtige Daten für Blue-Team-Übungen.

?tf Die Verwaltungsoberfläche der Range-Firewall sollte aus dem Red-Team-Netz erreichbar sein.
= falsch
! Nur aus dem Management-Netz.

? Welches IDS lässt sich direkt auf OPNsense aktivieren?
= Suricata
! Für Szenarien mit Netzwerkerkennung.

@@@ MODULE @@@
---
id: rp-04
title: Range-Praxis 4 · Wazuh als Range-SIEM und HIDS
paths: cyberrange, cdsa
order: 40.4
difficulty: medium
icon: eye.trianglebadge.exclamationmark
tags: wazuh, siem, cyber range
summary: Wazuh für Übungsumgebungen aufsetzen – Manager, Agents, Regeln, Decoder, FIM, Active Response und Dashboards für das Blue Team.
---

## Einfach erklärt

**Wazuh** ist ein freies Sicherheitssystem, das auf jedem Rechner einen kleinen Agenten installiert. Die Agenten melden Logs, Dateiänderungen und Auffälligkeiten an eine Zentrale, die daraus Alarme macht. Für eine Range ist das ideal: kostenlos, gut dokumentiert, realistische SOC-Erfahrung.

## Komponenten

| Komponente | Aufgabe |
|---|---|
| Wazuh Manager | empfängt Daten, wertet Regeln aus |
| Indexer | speichert Alarme und Ereignisse (OpenSearch-basiert) |
| Dashboard | Weboberfläche für Analysten |
| Agent | sammelt auf Windows/Linux/macOS Logs, FIM-Daten, Inventar |

## Wichtige Funktionen

- **Decoder** zerlegen Logzeilen in Felder; **Regeln** bewerten sie mit Level 0–15.
- **FIM** (File Integrity Monitoring) meldet Änderungen an überwachten Dateien.
- **Sysmon-Integration** auf Windows für hochwertige Telemetrie.
- **SCA** (Security Configuration Assessment) prüft Härtung gegen CIS.
- **Vulnerability Detection** gleicht Softwareinventar mit CVEs ab.
- **Active Response** kann automatisch reagieren (z. B. IP blockieren) – in Übungen mit Bedacht.

## Eigene Regel (Beispiel)

```xml
<group name="range,">
  <rule id="100100" level="12">
    <if_sid>61603</if_sid>
    <field name="win.eventdata.parentImage" type="pcre2">(?i)\\(winword|excel)\.exe$</field>
    <field name="win.eventdata.image" type="pcre2">(?i)\\(powershell|cmd)\.exe$</field>
    <description>Office startet Shell – möglicher Makro-Angriff</description>
    <mitre><id>T1204.002</id></mitre>
  </rule>
</group>
```

> [!TIPP] Übungen vorbereiten
> Vor jeder Übung die Angriffsschritte einmal durchspielen und prüfen, welche Alarme entstehen. So weiß die White Cell, was das Blue Team sehen kann.

## Tiefer eingetaucht

Ressourcenbedarf: Der Indexer braucht viel RAM und schnellen Speicher – für eine Range mit 20–50 Agenten reicht oft eine einzelne VM mit ausreichend Arbeitsspeicher. Nach jeder Übung Indizes archivieren (für die Nachbesprechung) und zurücksetzen. Für Lernzwecke lohnt es, Teilnehmende eigene Regeln schreiben zu lassen – Detection Engineering in kleinem Maßstab.

## Quiz

? Welche Komponente von Wazuh läuft auf den überwachten Rechnern?
= Agent
= Wazuh Agent
! Er sammelt Logs, FIM-Daten und Inventar.

? Wofür steht FIM?
= File Integrity Monitoring
! Meldet Änderungen an überwachten Dateien.

? Was zerlegt in Wazuh Logzeilen in Felder?
= Decoder
! Regeln werten die zerlegten Felder dann aus.

?tf Active Response kann in Wazuh automatisch auf Alarme reagieren.
= wahr
! In Übungen mit Bedacht einsetzen, damit Szenarien nicht abgewürgt werden.

? Welche Wazuh-Funktion prüft Systeme gegen Härtungsvorgaben wie CIS?
= SCA
= Security Configuration Assessment
! Gut für Härtungsübungen.

? Welcher Bereich der Regel-Level-Skala zeigt in Wazuh schwerwiegende Alarme?
+ hohe Level wie 12 bis 15
- Level 0
- negative Level
- nur Level 1
! Level 0 bedeutet „ignorieren“.

@@@ MODULE @@@
---
id: rp-05
title: Range-Praxis 5 · Security Onion als Netzwerk-Sensor
paths: cyberrange, cdsa
order: 40.5
difficulty: medium
icon: waveform.badge.magnifyingglass
tags: security onion, nsm, cyber range
summary: Wie Security Onion Zeek, Suricata, PCAP und eine Analyseoberfläche bündelt und wie man es in der Range für Netzwerkforensik nutzt.
---

## Einfach erklärt

Wenn Wazuh die Kameras in den Räumen sind, ist **Security Onion** die Kamera im Flur: Es schaut auf den **Netzwerkverkehr** zwischen den Systemen. Es bündelt mehrere bewährte Werkzeuge in einer Distribution, sodass man nicht alles einzeln einrichten muss.

## Was drinsteckt

| Werkzeug | Aufgabe |
|---|---|
| Zeek | Verbindungs- und Protokolllogs (conn, dns, http, ssl, files …) |
| Suricata | signaturbasierte Alarme |
| Stenographer / PCAP | vollständige Mitschnitte zum Nachsehen |
| Elastic-basierte Oberfläche (SOC, Hunt) | Suche, Fälle, Dashboards |
| Strelka | Dateianalyse aus dem Netzwerkverkehr |
| Elastic Agent | zusätzlich Host-Logs |

## In die Range einbinden

1. Sensor-VM mit zwei Netzwerkschnittstellen: Management + **Monitor-Interface**.
2. Verkehr zum Monitor-Interface spiegeln (SPAN/Mirror am virtuellen Switch, z. B. Proxmox/OVS-Mirror).
3. Netze und Home-Net-Bereiche konfigurieren.
4. Prüfen: Sieht der Sensor Verkehr aller wichtigen Segmente?

> [!WARNUNG] Speicher planen
> Vollständige Mitschnitte füllen Platten schnell. Aufbewahrungsdauer festlegen; für Übungen reichen oft einige Tage.

## Analyse-Workflow

Alarm (Suricata) → zugehörige Zeek-Logs (Verbindung, DNS, HTTP) → PCAP für den genauen Inhalt → extrahierte Dateien → Fall dokumentieren. Genau dieser Weg vom Alarm zum Beweis ist ein ausgezeichnetes Übungsziel.

## Tiefer eingetaucht

Security Onion lässt sich als **Standalone** (alles auf einer VM, gut für Labore) oder **verteilt** (Manager, Sensoren, Search Nodes) betreiben. Eigene Suricata-Regeln lassen Teilnehmende üben, Netzwerkerkennungen zu schreiben; Zeek-Skripte ermöglichen fortgeschrittene Erkennungen (z. B. ungewöhnliche TLS-Zertifikate). Für die Nachbesprechung sind exportierte PCAPs einer Übung wertvolles Lernmaterial – sie lassen sich später erneut analysieren.

## Quiz

? Welche Werkzeuge bündelt Security Onion unter anderem?
+ Zeek
+ Suricata
+ PCAP-Speicherung
- Microsoft Word
! Plus eine Oberfläche für Suche und Fälle.

? Wie gelangt Netzwerkverkehr zum Sensor?
+ über ein gespiegeltes Monitor-Interface (SPAN/Mirror)
- per E-Mail
- über USB-Sticks
- gar nicht
! Der Sensor hört passiv mit.

? Welches Werkzeug in Security Onion erzeugt Verbindungs- und Protokolllogs?
= Zeek
! Suricata liefert dagegen signaturbasierte Alarme.

?tf Vollständige Mitschnitte brauchen viel Speicherplatz.
= wahr
! Aufbewahrungsdauer bewusst festlegen.

? Was ist ein sinnvoller Analyse-Workflow?
+ Alarm → Zeek-Logs → PCAP → extrahierte Dateien → Fall dokumentieren
- PCAP löschen → Alarm schließen
- nur Alarme zählen
- Sensor neu starten
! Vom Alarm zum Beweis.

@@@ MODULE @@@
---
id: rp-06
title: Range-Praxis 6 · Range-Systeme mit Ansible konfigurieren
paths: cyberrange, specialist
order: 40.6
difficulty: medium
icon: gearshape.arrow.triangle.2.circlepath
tags: ansible, automatisierung, cyber range
summary: Wie man Range-Systeme reproduzierbar konfiguriert – Inventar, Playbooks, Rollen, Variablen, Vault und das absichtliche Einbauen von Schwachstellen.
---

## Einfach erklärt

Eine Range mit 40 Systemen per Hand einzurichten dauert Tage – und beim nächsten Mal ist alles ein bisschen anders. **Ansible** beschreibt die gewünschte Konfiguration in Textdateien und setzt sie auf allen Systemen gleich um. Wie ein Rezept, das jede Küche identisch nachkocht.

## Bausteine

| Baustein | Bedeutung |
|---|---|
| Inventar | Liste der Systeme und Gruppen |
| Playbook | Ablauf: welche Aufgaben auf welchen Hosts |
| Task / Modul | einzelner Schritt (Paket installieren, Datei kopieren, Dienst starten) |
| Rolle | wiederverwendbares Bündel (z. B. „domain_controller“, „webserver_verwundbar“) |
| Variablen | Unterschiede pro Szenario/Host |
| Handler | Aktion bei Änderung (z. B. Dienst neu starten) |
| Vault | verschlüsselte Geheimnisse |

```yaml
- name: Webserver der DMZ vorbereiten
  hosts: dmz_web
  become: true
  roles:
    - common_hardening
    - nginx
    - role: vuln_app
      vars:
        vuln_app_version: "2.3.1"   # absichtlich alte Version für das Szenario
```

> [!MERKE] Idempotenz
> Ein gutes Playbook kann man beliebig oft ausführen – das Ergebnis bleibt gleich. Das macht Ranges zuverlässig zurücksetzbar.

## Schwachstellen absichtlich einbauen

Szenarien brauchen gezielte Schwächen (schwaches Dienstkonto-Passwort, offene Freigabe, veraltete App). In Rollen sauber dokumentieren: **welche** Schwäche, **wofür** (Lernziel), **wie** man sie erkennt. So bleiben Übungen nachvollziehbar und lassen sich variieren.

## Tiefer eingetaucht

Windows-Systeme werden per WinRM (oder SSH) verwaltet; Module für AD (`microsoft.ad`), Gruppenrichtlinien und Dienste stehen bereit. Zusammen mit Terraform (Infrastruktur) und Packer (Golden Images) entsteht eine vollständig automatisierte Range: Images bauen → VMs erzeugen → konfigurieren → Szenario-Daten einspielen (z. B. Nutzer, Mails, Dokumente mit Faker-Daten). Alles in Git, mit Tests (z. B. Goss/Molecule), dass die Umgebung wie erwartet aussieht.

## Quiz

? Was beschreibt ein Ansible-Playbook?
+ welche Aufgaben auf welchen Hosts ausgeführt werden
- eine Liste von Passwörtern
- ein Netzwerkdiagramm
- eine Firewall-Regel
! Playbooks sind in YAML geschrieben.

? Was bedeutet Idempotenz?
+ mehrfaches Ausführen führt immer zum gleichen Ergebnis
- das Playbook läuft nur einmal
- das Playbook ist verschlüsselt
- das Playbook ist schneller
! Grundlage für zuverlässig zurücksetzbare Ranges.

? Womit verschlüsselt man Geheimnisse in Ansible?
= Ansible Vault
= Vault
! So können Passwörter sicher im Repository liegen.

?tf Absichtlich eingebaute Schwachstellen sollten mit Lernziel und Erkennungsweg dokumentiert werden.
= wahr
! Das macht Übungen nachvollziehbar und variierbar.

? Wie heißt ein wiederverwendbares Bündel von Aufgaben in Ansible?
= Rolle
= Role
! Z. B. eine Rolle „domain_controller“.

@@@ MODULE @@@
---
id: rp-07
title: Range-Praxis 7 · Infrastruktur mit Terraform/OpenTofu und Packer
paths: cyberrange, specialist
order: 40.7
difficulty: medium
icon: square.stack.3d.forward.dottedline.fill
tags: terraform, packer, iac, cyber range
summary: VMs, Netze und Vorlagen als Code – Golden Images mit Packer, Infrastruktur mit Terraform/OpenTofu, State sicher verwalten und Umgebungen pro Team klonen.
---

## Einfach erklärt

Wenn Ansible das Einrichten der Möbel ist, sind **Packer** und **Terraform/OpenTofu** der Bau der Räume: Packer baut **Vorlagen** (Golden Images) für Betriebssysteme, Terraform erzeugt daraus VMs, Netze und Speicher – per Textdatei statt per Klick.

## Packer – Golden Images

- automatisierte Installation (Unattend/Kickstart/cloud-init)
- Updates, Basiswerkzeuge, Agenten
- Bereinigung (Sysprep bei Windows), dann als Vorlage speichern

## Terraform/OpenTofu – Infrastruktur

```hcl
resource "proxmox_virtual_environment_vm" "client" {
  for_each  = toset(["client-01", "client-02", "client-03"])
  name      = "${var.team}-${each.key}"
  node_name = "pve01"
  clone { vm_id = var.win11_template_id }
  network_device { bridge = "vmbr1" vlan_id = 30 }
}
```

| Begriff | Bedeutung |
|---|---|
| Provider | Schnittstelle zur Plattform (Proxmox, vSphere, AWS …) |
| Resource | etwas, das erzeugt wird |
| Variable / Module | Wiederverwendung, z. B. pro Team |
| State | Abbild dessen, was existiert |
| `plan` / `apply` / `destroy` | Vorschau, Umsetzen, Abbauen |

> [!WARNUNG] Der State ist sensibel
> Die State-Datei kann Passwörter und IPs enthalten. Verschlüsselt und zugriffsbeschränkt in einem Remote-Backend speichern, nie ins öffentliche Repository.

## Tiefer eingetaucht

Für Team-Übungen: dasselbe Modul mit Variable `team` mehrfach instanziieren – jedes Team bekommt eine identische, isolierte Umgebung (eigene VLANs/VRFs). Nach der Übung `destroy` und neu erzeugen statt aufzuräumen – sauber und reproduzierbar.

Qualität: `terraform validate`, `fmt`, Linting, IaC-Scanner gegen Fehlkonfigurationen, Plan-Review im Pull Request. **Drift** (manuelle Änderungen) erkennt man per `plan` – in einer Range ist Drift oft ein Zeichen für „jemand hat in der Übung etwas verändert“, was für die Nachbesprechung interessant sein kann.

## Quiz

? Wofür wird Packer eingesetzt?
+ zum automatisierten Bauen von Golden Images
- zum Packen von ZIP-Archiven
- als Firewall
- als SIEM
! Vorlagen, aus denen VMs geklont werden.

? Welcher Terraform-Befehl zeigt eine Vorschau der Änderungen?
= terraform plan
= plan
! apply setzt um, destroy baut ab.

? Warum muss die State-Datei geschützt werden?
+ sie kann Passwörter und sensible Details enthalten
- sie ist sehr groß
- sie ist verschlüsselt
- sie wird nie gebraucht
! Remote-Backend mit Verschlüsselung und Zugriffskontrolle nutzen.

?tf Mit Variablen und Modulen kann man für jedes Team eine identische Umgebung erzeugen.
= wahr
! z. B. per for_each oder Modul-Instanzen.

? Was ist Drift?
+ eine Abweichung zwischen Code und tatsächlicher Infrastruktur
- ein Rennsport
- ein Netzwerkprotokoll
- ein Backup-Typ
! Entsteht z. B. durch manuelle Änderungen.

? Wie heißt der freie Fork von Terraform?
= OpenTofu
! Kompatibel zur HCL-Syntax von Terraform.

@@@ MODULE @@@
---
id: rp-08
title: Range-Praxis 8 · Scoring-Engine und CTFd betreiben
paths: cyberrange
order: 40.8
difficulty: medium
icon: rosette
tags: scoring, ctfd, cyber range
summary: Wie man Leistung fair misst – Service-Checks, Flags, Inject-Bewertung, Abzüge, CTFd-Konfiguration und typische Fallstricke.
---

## Einfach erklärt

Punkte machen Übungen spannend – aber nur, wenn sie **fair** messen, was man lernen soll. Eine Scoring-Engine ist wie der Schiedsrichter: Sie prüft automatisch, ob Dienste laufen, ob Flags gefunden wurden, und Menschen bewerten, was Maschinen nicht prüfen können (Berichte, Kommunikation).

## Punktequellen

| Quelle | Beispiel | Wer bewertet |
|---|---|---|
| Service-Verfügbarkeit | Webshop erreichbar und funktionsfähig | automatisch (Checks alle 2–5 Min.) |
| Flags | gefundene Beweise / Geheimnisse | automatisch |
| Injects | Vorfallbericht, Management-Mail | White Cell / Evaluatoren |
| Erkennung | Angriffsschritt korrekt gemeldet | Evaluatoren |
| Abzüge | Regelverstöße, Hilfe angefordert | White Cell |

## CTFd

**CTFd** ist eine verbreitete Open-Source-Plattform für Aufgaben und Flags:

- Challenges mit Kategorien, Punktwerten, Hinweisen (ggf. mit Punktabzug)
- **dynamische Punkte** (je mehr Teams lösen, desto weniger wert)
- Teams, Scoreboard, Zeitfenster
- Flags als statische Strings oder reguläre Ausdrücke

> [!TIPP] Flags eindeutig gestalten
> Ein einheitliches Format (z. B. `NIMA{…}`) verhindert Verwirrung und Raten. Für Team-Umgebungen pro Team unterschiedliche Flags erzeugen, damit Teilen nicht hilft.

## Tiefer eingetaucht

Fallstricke: Service-Checks, die zu streng sind (Team verliert Punkte durch Netzwerkruckler) oder zu lax (Dienst „läuft“, ist aber kaputt); Punktesysteme, die Abschalten belohnen (Blue Team schaltet verwundbaren Dienst ab → keine Angriffe, aber auch keine Verfügbarkeitspunkte – das muss ausbalanciert sein); undurchsichtige Bewertung, die Motivation zerstört.

Gute Praxis: Bewertungsregeln vorab veröffentlichen, Checks in Testläufen kalibrieren, Ergebnisse in der Nachbesprechung erklären. Der Punktestand ist Mittel zum Zweck – das Ziel bleiben die Lernziele.

## Quiz

? Was prüft ein Service-Check?
+ ob ein Dienst erreichbar und funktionsfähig ist
- ob das Team pünktlich ist
- ob die Flagge farbig ist
- ob Logs verschlüsselt sind
! Automatisch in festen Intervallen.

? Was ist CTFd?
+ eine Open-Source-Plattform für Aufgaben, Flags und Scoreboards
- ein Betriebssystem
- eine Firewall
- ein Kryptoverfahren
! Weit verbreitet für CTF-Veranstaltungen.

? Was bewirkt dynamisches Scoring?
+ eine Aufgabe ist weniger wert, je mehr Teams sie lösen
- Punkte verdoppeln sich stündlich
- alle Aufgaben sind gleich viel wert
- Punkte werden zufällig vergeben
! So werden schwere Aufgaben stärker belohnt.

?tf Unterschiedliche Flags pro Team verhindern, dass Teilen von Lösungen hilft.
= wahr
! Besonders wichtig bei parallelen Team-Umgebungen.

? Was ist ein häufiger Fehler bei Punktesystemen?
+ Abschalten verwundbarer Dienste wird belohnt
- Regeln werden vorab veröffentlicht
- Checks werden kalibriert
- Ergebnisse werden erklärt
! Verfügbarkeit und Sicherheit müssen ausbalanciert sein.

@@@ MODULE @@@
---
id: rp-09
title: Range-Praxis 9 · Hot-Wash und Nachbereitung
paths: cyberrange, specialist
order: 40.9
difficulty: easy
icon: bubble.left.and.bubble.right.fill
tags: debriefing, lernen, cyber range
summary: Wie man direkt nach einer Übung und später strukturiert nachbespricht, Erkenntnisse sichert und die Range kontinuierlich verbessert.
---

## Einfach erklärt

Der größte Lerneffekt einer Übung entsteht oft **danach**: Wenn man gemeinsam versteht, was passiert ist, warum eine Entscheidung gut oder schlecht war und was man nächstes Mal anders macht. Ein Sporttrainer schaut sich nach dem Spiel die Aufzeichnung mit dem Team an – genauso funktioniert ein **Hot-Wash**.

## Hot-Wash (direkt danach, 30–60 Min.)

1. Kurze Rekonstruktion: Was hat das Red Team getan? (Aha-Momente für Blue)
2. Jedes Team: Was lief gut? Was war schwierig?
3. White Cell: Welche Lernziele wurden erreicht, welche nicht?
4. Offene Fragen sammeln.

Regeln: keine Schuldzuweisungen, Fakten vor Meinungen, alle kommen zu Wort.

## Nachbereitung (Tage danach)

- **Übungsbericht**: Ablauf, erreichte Lernziele, Beobachtungen, Empfehlungen.
- **Individuelles Feedback** für Teilnehmende.
- **Material**: PCAPs, Logs, Zeitleiste für späteres Selbststudium.
- **Range-Verbesserungen**: Was hat technisch gehakt? Welche Injects funktionierten nicht?
- **Transfer in den Alltag**: Welche Erkenntnisse betreffen echte Prozesse (z. B. Eskalationswege)?

> [!MERKE] Lernen sichtbar machen
> Ein Vorher-nachher-Vergleich (z. B. Selbsteinschätzung oder kleiner Test vor und nach der Übung) zeigt den Lernerfolg – und rechtfertigt die Investition in die Range.

## Tiefer eingetaucht

Für die Range selbst gilt der Verbesserungskreislauf (Plan – Do – Check – Act): Jede Übung liefert Daten über Stabilität, Ressourcenbedarf, Szenarioqualität und Zufriedenheit. Ein „Lessons Learned“-Backlog für die Range, priorisiert und mit Zuständigkeiten, sorgt dafür, dass jede Übung besser wird als die letzte.

## Quiz

? Was ist ein Hot-Wash?
+ eine kurze strukturierte Nachbesprechung direkt nach der Übung
- das Reinigen der Server
- ein Neustart aller VMs
- eine Waschmaschine im Rechenzentrum
! Ideal, solange alles frisch im Gedächtnis ist.

? Welche Regeln gelten im Hot-Wash?
+ keine Schuldzuweisungen
+ Fakten vor Meinungen
+ alle kommen zu Wort
- nur das Siegerteam spricht
! So entsteht eine offene Lernkultur.

?tf Ein Vorher-nachher-Vergleich hilft, den Lernerfolg sichtbar zu machen.
= wahr
! Und begründet den Nutzen der Range.

? Welches Material ist für späteres Selbststudium wertvoll?
+ PCAPs, Logs und die Zeitleiste der Übung
- nur die Punkteliste
- die Einkaufsliste für Snacks
- gar nichts
! Damit lassen sich Abläufe in Ruhe nachvollziehen.

? Welcher Kreislauf beschreibt die kontinuierliche Verbesserung der Range?
= PDCA
= Plan-Do-Check-Act
! Jede Übung liefert Daten für die nächste.

@@@ MODULE @@@
---
id: rp-10
title: Range-Praxis 10 · Teilnehmerdaten, Faker und realistische Grundrauschen
paths: cyberrange
order: 41
difficulty: medium
icon: person.3.sequence.fill
tags: datengenerierung, realismus, cyber range
summary: Wie eine Range lebendig wirkt – synthetische Nutzer, Dokumente, E-Mails und Hintergrundverkehr (Grey Space), ohne echte personenbezogene Daten.
---

## Einfach erklärt

Eine Range ohne Alltag ist wie ein Filmset ohne Statisten: Jeder Angriff fällt sofort auf, weil sonst nichts passiert. Echte Netze sind voller **Grundrauschen** – Nutzer surfen, Mails fliegen, Dateien werden geöffnet. Erst darin wird die Suche nach dem Angreifer realistisch.

## Synthetische Daten

- **Nutzer und Organigramm**: mit Faker-Bibliotheken erzeugt (Namen, Abteilungen, Telefonnummern) – **keine echten Personen**.
- **Dokumente**: Rechnungen, Verträge, Protokolle mit plausiblen Inhalten und Metadaten.
- **E-Mail-Postfächer** mit Verlauf.
- **Webseiten** für das fiktive Unternehmen.

> [!GEFAHR] Keine echten personenbezogenen Daten
> Echte Mitarbeiter- oder Kundendaten haben in Übungsumgebungen nichts zu suchen – Datenschutz gilt auch im Labor.

## Hintergrundaktivität (Grey Space)

| Ansatz | Beispiel |
|---|---|
| NPC-Agenten | Software, die Nutzer simuliert: surfen, Mails schreiben, Office nutzen (z. B. GHOSTS) |
| Geplante Aufgaben | Skripte, die regelmäßig Dateien anlegen, Freigaben nutzen |
| Simuliertes Internet | Webseiten, DNS, Mail, Suchmaschine in der Range (z. B. INetSim, eigene Dienste) |
| Rausch-Logs | realistische Fehlanmeldungen, Updates, Druckaufträge |

## Tiefer eingetaucht

Gutes Grundrauschen hat **Muster**: Arbeitszeiten, Mittagspausen, unterschiedliche Rollen (Entwickler nutzen andere Systeme als die Buchhaltung). Je realistischer, desto besser trainiert das Blue Team, Signale von Rauschen zu trennen – genau die Fähigkeit, die im echten SOC zählt.

Gleichzeitig muss Rauschen **kontrollierbar** sein: Für Einsteiger-Übungen wenig, für Fortgeschrittene mehr. Und die White Cell muss wissen, welche Aktivitäten zum Grundrauschen gehören, um Fragen der Teilnehmenden zu beantworten.

## Quiz

? Warum braucht eine Range Grundrauschen?
+ damit Angriffe nicht sofort auffallen und die Suche realistisch ist
- damit die Server warm bleiben
- um Speicherplatz zu füllen
- weil es gesetzlich vorgeschrieben ist
! Signal von Rauschen trennen ist eine Kernfähigkeit im SOC.

? Womit erzeugt man synthetische Personendaten?
+ mit Faker-Bibliotheken
- mit echten Kundendaten
- mit dem Telefonbuch
- mit Social-Media-Profilen
! Echte personenbezogene Daten gehören nicht in Übungen.

? Wie heißt ein bekanntes Framework zur Simulation von Nutzeraktivität?
= GHOSTS
! Es steuert NPC-Agenten, die surfen, Mails schreiben und Dokumente bearbeiten.

?tf Für Einsteiger-Übungen sollte das Grundrauschen geringer sein als für Fortgeschrittene.
= wahr
! Rauschen ist ein Stellrad für den Schwierigkeitsgrad.

? Was simuliert INetSim?
+ Internetdienste wie Web, DNS und Mail innerhalb der Range
- echte Nutzer
- Firewalls
- Stromausfälle
! So wirkt die Range verbunden, ohne echtes Internet.
