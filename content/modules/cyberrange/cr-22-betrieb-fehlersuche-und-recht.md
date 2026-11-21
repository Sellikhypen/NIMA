---
id: cr-22
title: Betrieb, Fehlersuche und Recht
paths: cyberrange
order: 22
difficulty: medium
icon: wrench.and.screwdriver
summary: Kapitel 22 deiner Cyber-Range-Dokumentation: Betrieb, Fehlersuche und Recht.
source: Cyber_Range_Dokumentation.docx
htb: Cyber Range 11 · Betrieb & Skalierung
---

## Betriebs-Runbooks

| **Runbook** | **Auslöser** | **Kernschritte** |
|---|---|---|
| **Reset nach Übung** | ENDEX | Logs/PCAP sichern → qm rollback auf »clean« bzw. tofu destroy/apply → Ansible → Smoke-Test |
| **Template-Refresh** | Monatlich / Eval-Ablauf | packer build → Test-Klon → alte Templates archivieren |
| **Update Hypervisor** | Monatlich | Wartungsfenster, Backup, apt full-upgrade, Reboot, Funktionstest |
| **Ressourcenengpass** | RAM > 90 % | Nicht benötigte Sandboxen stoppen, KSM prüfen, Team-Anzahl reduzieren |
| **Verdacht auf Ausbruch** | Unerwarteter Verkehr im MGMT-Netz | Übung pausieren, Range-Bridge trennen, Forensik |

Tabelle 140: Betriebs-Runbooks

## Fehlersuche: typische Probleme

| **Symptom** | **Wahrscheinliche Ursache** | **Prüfung / Lösung** |
|---|---|---|
| **VM bekommt keine IP** | Falscher VLAN-Tag oder DHCP auf OPNsense aus | `qm config <id>` (tag=?), OPNsense DHCP-Log, `bridge vlan show` |
| **Ping geht, große Downloads hängen** | MTU-Problem (z. B. VXLAN) | `ping -M do -s 1422`, MTU in Zone/VNet bzw. Underlay anpassen |
| **Sensor sieht keinen Verkehr** | Hookscript nicht aktiv, Kabel, Offloading | `tc filter show dev tap100i0 ingress`, `tcpdump -i enp3s0`, ethtool |
| **Wazuh-Agent »disconnected«** | Firewall-Regel 1514/1515 fehlt, Zeitabweichung | OPNsense Live-Log, `agent_control -l`, NTP prüfen |
| **Kerberos-Fehler im AD** | Uhrzeitabweichung > 5 Min. | `w32tm /query /status`, NTP-Quelle |
| **Terraform hängt bei »still creating«** | Guest Agent fehlt, IP wird nie gemeldet | Agent im Template installieren, `agent { enabled = true }` |
| **Linked Clone schlägt fehl** | Template auf anderem Storage/Knoten | Template und Ziel auf gleichem Storage, ggf. Full Clone |
| **Guacamole: schwarzer Bildschirm** | RDP-Sicherheitsmodus, NLA, Zertifikat | Verbindungsparameter »security« und »ignore-cert« prüfen |
| **Hohe CPU-Last auf dem Sensor** | Offloading aus, zu viele Suricata-Regeln | Regelsätze straffen, mehr Kerne, Lastverteilung |

Tabelle 141: Fehlersuche

## Rechtliche Rahmenbedingungen (Deutschland, keine Rechtsberatung)

- **Strafrecht:** §§ 202a (Ausspähen von Daten), 202b (Abfangen von Daten), 202c (Vorbereiten – »Hackerparagraf«), 303a (Datenveränderung), 303b (Computersabotage) StGB. Angriffe ausschließlich auf eigene bzw. ausdrücklich freigegebene Systeme innerhalb der isolierten Range; Zweck (Ausbildung, Test) dokumentieren. Das Bundesverfassungsgericht hat 2009 klargestellt, dass Dual-Use-Werkzeuge nicht per se unter § 202c fallen, wenn keine Absicht zu Straftaten besteht.
- **Datenschutz (DSGVO/BDSG):** Keine echten personenbezogenen Daten im Szenario. Teilnehmerdaten (Leistungsbewertung, Sitzungsaufzeichnungen) sind personenbezogen → Zweckbindung, Information der Teilnehmer, Löschfristen, ggf. Mitbestimmung (Betriebsrat) bei Leistungsmessung.
- **Lizenzen:** Windows-Evaluierungsversionen nur zu Test- und Evaluierungszwecken gemäß Microsoft-Lizenzbedingungen; Elastic-Lizenzbedingungen beachten.
- **Malware:** Echte Schadsoftware nur in dafür freigegebenen, isolierten Segmenten und mit dokumentierter Verantwortlichkeit.
## Häufige Fragen

| **Frage** | **Antwort** |
|---|---|
| **Kann ich statt Proxmox auch VirtualBox oder VMware Workstation nehmen?** | Für erste Experimente ja (GOAD unterstützt beides). Für eine echte Range fehlen aber API-gesteuerte Linked Clones, Snapshots im Serverbetrieb, VLAN-aware Bridges und Mehrbenutzerbetrieb. Proxmox (oder ESXi/vSphere) ist die richtige Basis. |
| **Reicht ein Laptop?** | Für ein Einzelplatz-Labor mit 32–64 GB RAM und wenigen VMs ja (Stufe 1). WLAN-Betrieb wird von Ludus ausdrücklich nicht unterstützt; ein Laptop ist zudem schlecht für Dauerbetrieb geeignet. |
| **Warum nicht einfach alles in Docker?** | Container teilen sich den Kernel des Hosts. Windows/Active Directory lassen sich so nicht realistisch abbilden, und ein Kernel-Exploit aus einem Angreifer-Container träfe direkt den Host. Container nur für Infrastrukturdienste. |
| **Brauche ich Windows-Lizenzen?** | Für den Pilot genügen Evaluierungsversionen (Server 180, Client 90 Tage) im Rahmen der Lizenzbedingungen. Für Dauerbetrieb oder Schulungen gegen Entgelt ordnungsgemäß lizenzieren. |
| **Darf die Range ins Internet?** | Das Übungsnetz: nein, niemals. Nur die Hypervisoren und Infrastruktur-VMs dürfen über das MGMT-Netz bzw. einen Proxy Updates laden. Benötigte Inhalte (Pakete, Webseiten) werden vorab ins SINET gespiegelt. |
| **Brauche ich Security Onion UND Wazuh?** | Sie ergänzen sich: Security Onion sieht das Netz (wer spricht mit wem, Signaturen, PCAP), Wazuh sieht in die Rechner (Prozesse, Anmeldungen, Dateien). Bei knappem RAM kann man mit Wazuh + Sysmon beginnen und Security Onion später ergänzen. |
| **Wie viele Teilnehmer schafft der Pilot?** | Ein Red Team und ein bis zwei Blue Teams mit je 3–5 Personen; begrenzend ist der RAM von Maschine A (ein vollständiges Firmennetz ≈ 82 GB). |
| **Wie lange dauert ein Reset?** | Snapshot-Rollback: wenige Minuten. Vollständiger Neuaufbau aus Git (ohne Template-Bau): Ziel < 90 Minuten. |
| **Was kostet der Betrieb an Strom?** | Grobe Schätzung: zwei Server mit zusammen ca. 300 W Durchschnittslast ≈ 2.600 kWh pro Jahr bei Dauerbetrieb. Wer die Range nur bei Bedarf einschaltet, spart den Großteil. |
| **Was tun, wenn doch etwas ausbricht?** | Übung sofort pausieren, Range-Bridge trennen (`ip link set vmbr1 down`), betroffene Systeme isolieren, Logs sichern, Ursache analysieren – Runbook »Verdacht auf Ausbruch« (22.1). |
| **Muss ich alles selbst bauen?** | Nein. Ludus (Orchestrierung) und GOAD (AD-Labore) liefern große Teile fertig. Der Eigenbau lohnt sich vor allem für Lerneffekt, eigene Szenarien und volle Kontrolle. |

Tabelle 142: Häufige Fragen

## Die ersten zehn Arbeitstage

Für den Einstieg in die Umsetzung hat sich folgende Reihenfolge bewährt – sie liefert früh sichtbare Ergebnisse und deckt die größten Risiken (Isolation, RAM, Telemetrie) zuerst ab:

| **Tag** | **Aufgabe** | **Ergebnis am Abend** |
|---|---|---|
| **1** | Hardware prüfen, UEFI einstellen, Proxmox auf Maschine A installieren | Weboberfläche erreichbar |
| **2** | Härtung (2FA, Firewall, Repository), Bridges vmbr0/vmbr1 anlegen | Isolierte Übungsbridge |
| **3** | OPNsense installieren, VLANs 10/20/30 anlegen, Default Deny | Erste Zonen mit Routing |
| **4** | Erste Ubuntu-VM per Hand in VLAN 20, Egress-Test | Isolation nachgewiesen |
| **5** | Gitea + Packer: Ubuntu-Template bauen | Template 9001 |
| **6** | OpenTofu: VM aus Template per Code erzeugen und wieder löschen | Erster »Range as Code«-Durchlauf |
| **7** | Windows-Server-Template, Domain Controller per Ansible | nordwind.lab läuft |
| **8** | Maschine B: Proxmox, Wazuh, Agent auf dc01 | Erste Alarme im Dashboard |
| **9** | Spiegelung per Hookscript, Security Onion | Zeek-Logs vom Übungsverkehr |
| **10** | Mini-Szenario: Kali scannt DMZ, Blue sieht es; Snapshot + Rollback | Durchstich aller Schichten L0–L5 |

Tabelle 143: Durchstich in zehn Arbeitstagen

> [!TIPP] Durchstich vor Perfektion
> Das wichtigste Ziel der ersten zwei Wochen ist ein **vollständiger, wenn auch kleiner Durchstich durch alle Schichten**: eine VM, per Code erzeugt, isoliert, beobachtet, zurücksetzbar. Erst danach lohnt sich der Ausbau in die Breite (mehr Systeme, Szenarien, Teams).

## Die Range selbst überwachen

Neben der Sicherheits-Telemetrie der Übung braucht das Green Team ein **Betriebs-Monitoring** der Plattform: Auslastung, Speicherplatz, Dienstzustand. Bewährt hat sich Prometheus mit Grafana.

| **Messgröße** | **Quelle** | **Warnschwelle (Richtwert)** |
|---|---|---|
| **CPU-Wartezeit / Druck (PSI)** | node_exporter, /proc/pressure/cpu | dauerhaft > 10 % |
| **RAM-Auslastung Host** | node_exporter, Proxmox-API (pve-exporter) | > 90 % |
| **IO-Delay** | Proxmox-Übersicht, node_exporter | > 10 % über 5 Minuten |
| **ZFS-Pool-Belegung** | zfs_exporter oder Skript | > 80 % (ZFS wird langsamer) |
| **Paketrate am Sensor** | Security Onion Grid-Status | plötzlicher Abfall auf 0 |
| **Wazuh-Agenten verbunden** | Wazuh-API | Abweichung zur Soll-Anzahl |
| **Zertifikatslaufzeit** | blackbox_exporter | < 14 Tage |

Tabelle 144: Betriebskennzahlen der Range

## Wenn etwas wirklich schiefgeht

Trotz aller Vorsicht kann es passieren: Ein Teilnehmer findet einen Weg aus dem Übungsnetz, Schadsoftware erreicht ein reales System, oder Zugangsdaten der Infrastruktur werden bekannt. Für diesen Fall gibt es einen vorbereiteten Ablauf:

1. **Stoppen:** Exercise Director ruft »STOPP«; Green Team trennt die Data Plane (OPNsense-Interfaces deaktivieren oder VMs pausieren – nicht löschen).
1. **Eindämmen:** Betroffene reale Systeme vom Netz nehmen; Zugangsdaten der Infrastruktur sofort ändern.
1. **Beweise sichern:** PCAP, Logs, Guacamole-Aufzeichnungen und Snapshots der beteiligten VMs sichern, bevor etwas zurückgesetzt wird.
1. **Melden:** interne IT-Sicherheit bzw. CISO informieren; Meldepflichten prüfen (Datenschutz, ggf. NIS2).
1. **Ursache klären:** Wie kam es zum Ausbruch? Welche Regel oder Annahme war falsch?
1. **Beheben und testen:** Lücke schließen, Isolationstest wiederholen, erst dann neue Übung freigeben.
## Datenschutz im Detail

In einer Range werden personenbezogene Daten der **Teilnehmer** verarbeitet: Konten, Anmeldezeiten, Bildschirmaufzeichnungen, Chatverläufe, Leistungsbewertungen. Die Übungsdaten selbst (fiktive Mitarbeitende) sind dagegen erfunden. Die folgende Übersicht nennt typische Punkte, die mit dem Datenschutzbeauftragten zu klären sind (keine Rechtsberatung):

| **Thema** | **Fragestellung** | **Praxisempfehlung** |
|---|---|---|
| **Rechtsgrundlage** | Auf welcher Grundlage werden Teilnehmerdaten verarbeitet? | mit dem Datenschutzbeauftragten festlegen (z. B. Beschäftigungsverhältnis, Einwilligung bei Externen) |
| **Transparenz** | Wissen Teilnehmer, was aufgezeichnet wird? | Datenschutzhinweis im Briefing und im Portal |
| **Bildschirmaufzeichnung** | Ist die Aufzeichnung erforderlich und verhältnismäßig? | nur für AAR und Bewertung, Zugriff nur White Team |
| **Leistungsbewertung** | Fließen Ergebnisse in Personalentscheidungen ein? | Team- statt Einzelbewertung; bei Beschäftigten Mitbestimmung (Betriebs-/Personalrat) frühzeitig einbinden |
| **Speicherdauer** | Wie lange bleiben Daten erhalten? | Löschkonzept: z. B. Aufzeichnungen 30 Tage nach AAR, anonymisierte Statistiken länger |
| **Echte Daten** | Werden echte Personen- oder Firmendaten im Szenario verwendet? | **nein** – nur erfundene Daten |

Tabelle 145: Datenschutzthemen einer Cyber Range

## Regulatorischer Rückenwind: NIS2

Mit dem deutschen NIS2-Umsetzungs- und Cybersicherheitsstärkungsgesetz (NIS2UmsuCG), in Kraft seit dem 6. Dezember 2025, sind deutlich mehr Unternehmen zu Risikomanagement, Vorfallmeldungen und **Schulungen** verpflichtet – ausdrücklich auch die Geschäftsleitung. Eine Cyber Range ist kein gesetzlich vorgeschriebenes Werkzeug, aber sie ist ein sehr wirksamer Weg, mehrere Anforderungen praktisch zu erfüllen:

| **Anforderung (vereinfacht)** | **Beitrag der Range** |
|---|---|
| **Schulungen für Leitungsorgane und Beschäftigte** | Table-Top-Übungen für Führungskräfte, technische Übungen für IT/SOC |
| **Bewältigung von Sicherheitsvorfällen** | Incident-Response-Abläufe unter realistischen Bedingungen üben |
| **Meldepflichten mit kurzen Fristen** | Injects mit Meldefristen (Frühwarnung, Folgemeldung) trainieren |
| **Wirksamkeit von Maßnahmen bewerten** | Detektionen und Härtung messbar in der Range prüfen |
| **Aufrechterhaltung des Betriebs** | Wiederherstellung aus Backups und Notbetrieb üben |

Tabelle 146: Beiträge der Range zu NIS2-Anforderungen (keine Rechtsberatung)

## Änderungen und Wartungsfenster

Eine Range ist am verletzlichsten, wenn kurz vor einer Übung noch »schnell« etwas geändert wird. Ein einfaches **Change-Management** verhindert das, ohne den Betrieb zu lähmen.

| **Änderungsart** | **Beispiele** | **Verfahren** |
|---|---|---|
| **Standardänderung** | neue Regel in der Detection-Pipeline, neuer Benutzer, Dokumentation | Pull Request mit Review, jederzeit außer in Sperrzeiten |
| **Normale Änderung** | neue VM im Szenario, Firewall-Regel, neue Template-Version | Pull Request + Test in einer Test-Sandbox + Freigabe durch Green Lead |
| **Große Änderung** | Proxmox-Upgrade, neues Monitoring-Werkzeug, neue Netzarchitektur | Planung, Testumgebung, Wartungsfenster, Rückfallplan, Freigabe durch Projektleitung |
| **Notfalländerung** | Fehler während einer laufenden Übung | sofort durch Green Team, Dokumentation und Nachziehen in Git am selben Tag |

Tabelle 147: Arten von Änderungen

☐  **Sperrzeit:** ab 3 Arbeitstage vor einer Übung keine normalen oder großen Änderungen mehr

☐  **Wartungsfenster:** feste Zeit pro Woche (z. B. Dienstagnachmittag) für Updates und größere Arbeiten

☐  **Rückfallplan:** Für jede große Änderung ist vorher beschrieben, wie der alte Zustand wiederhergestellt wird (Snapshot, Backup, Git-Revert)

☐  **Kommunikation:** Übungskalender und geplante Wartungen sind für alle Beteiligten sichtbar

> [!INFO]
> **TEIL D**
> **Vertiefung**
> Fortgeschrittene Themen für Betrieb und Weiterentwicklung: Erkennung verbessern, neue Szenario-Arten, Industrie- und Container-Umgebungen, eigener Orchestrator, Leistung, Datensicherung, Bedrohungsmodell, Didaktik und Praxislabore.
> Kapitel 23: Detection Engineering und Purple Teaming
> Kapitel 24: Szenario-Katalog
> Kapitel 25: OT/ICS-Range: Industrieanlagen nachbilden
> Kapitel 26: Container- und Cloud-Szenarien
> Kapitel 27: Ein eigener Range-Orchestrator
> Kapitel 28: Leistung messen und optimieren
> Kapitel 29: Datensicherung und Wiederherstellung
> Kapitel 30: Bedrohungsmodell der Range
> Kapitel 31: Didaktik und Ausbildungskonzept
> Kapitel 32: Praxislabore für das Blue Team
