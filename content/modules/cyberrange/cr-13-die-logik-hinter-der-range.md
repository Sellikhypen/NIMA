---
id: cr-13
title: Die Logik hinter der Range
paths: cyberrange
order: 13
difficulty: easy
icon: brain
summary: Kapitel 13 deiner Cyber-Range-Dokumentation: Die Logik hinter der Range.
source: Cyber_Range_Dokumentation.docx
htb: 
---

## Sechs Grundprinzipien

| **Prinzip** | **Bedeutung** | **Technische Umsetzung** |
|---|---|---|
| **Isolation** | Nichts darf aus der Range in reale Netze gelangen | Bridge ohne Uplink, Default Deny, keine Route ins MGMT, simuliertes Internet |
| **Realismus** | Teilnehmer finden echte Systeme mit echten Schwächen vor | Echte Betriebssysteme, AD, realistische Dienste, NPC-Verkehr, Fake-Internet |
| **Reproduzierbarkeit** | Jede Übung kann identisch wiederholt werden | IaC in Git, versionierte Templates |
| **Beobachtbarkeit** | Alles wird gemessen und ist nachvollziehbar | SPAN, Zeek, Suricata, Sysmon, zentrale Logs, NTP |
| **Rücksetzbarkeit** | Ausgangszustand in Minuten wiederherstellbar | Snapshots, Linked Clones, Destroy & Rebuild |
| **Skalierbarkeit / Mandantenfähigkeit** | Viele Teams parallel, ohne sich zu sehen | Klone pro Team, eigene VLAN/VNI-Bereiche, SDN-Zonen |

Tabelle 83: Grundprinzipien

Diese Prinzipien stehen teilweise im Spannungsverhältnis: **Realismus** verlangt z. B. viele Systeme und echtes Benutzerverhalten, **Rücksetzbarkeit** und **Skalierbarkeit** wünschen sich wenige, schlanke Systeme. Die Kunst liegt darin, den Realismus genau dort hoch zu treiben, wo er für die Lernziele zählt (z. B. Active Directory, Benutzerverkehr), und überall sonst zu vereinfachen.

## Lebenszyklus einer Übung

![Abbildung 38: Lebenszyklus einer Übung – alle Artefakte liegen versioniert in Git](asset:cyberrange/cr-13-038.png)

1. **Bedarf & Lernziele:** Zielgruppe, Kompetenzen, messbare Lernziele (»Blue Team erkennt Kerberoasting innerhalb von 15 Minuten«).
1. **Szenario-Design & MSEL:** Storyline, fiktives Unternehmen, Netzplan, Angriffskette (ATT&CK), MSEL.
1. **Build & Provisionierung:** Templates, VMs/Netze, Konfiguration, Schwachstellen, Agenten.
1. **Validierung (Dry-Run):** Green und Red Team spielen das Szenario einmal komplett durch.
1. **Durchführung:** STARTEX, Angriffe, Injects, Reaktionen, ENDEX.
1. **Monitoring & Scoring:** Echtzeit-Lagebild, Verfügbarkeit, Flaggen, Berichte, Detektionen.
1. **Debriefing / AAR:** Zeitstrahl rekonstruieren, Lessons Learned, Bewertung.
1. **Reset / Teardown:** Snapshots zurückrollen oder neu bauen; Erkenntnisse fließen in Templates und Szenarien zurück.
## Zustandsmaschine einer Sandbox

Plattformen wie KYPO/CyberRangeCZ und Ludus behandeln jede Teilnehmerumgebung als **Sandbox** mit klar definierten Zuständen und Übergängen. Diese Logik ist die Grundlage jeder Automatisierung: Ein Orchestrator muss zu jedem Zeitpunkt wissen, in welchem Zustand jede Sandbox ist und welcher Schritt als Nächstes erlaubt ist.

![Abbildung 39: Zustandsmaschine einer Sandbox](asset:cyberrange/cr-13-039.png)

| **Zustand** | **Bedeutung** | **Übergang durch** | **Werkzeug** |
|---|---|---|---|
| **DEFINIERT** | Topologie liegt als Code vor | Commit / Merge | Git, Gitea |
| **ALLOKIERT** | Ressourcen (VMIDs, VLAN/VNI, IP-Bereich) reserviert | Pool-Zuweisung | Orchestrator, IPAM |
| **PROVISIONIERT** | VMs und Netze existieren | tofu apply | OpenTofu → Proxmox-API |
| **KONFIGURIERT** | Dienste, Benutzer, Schwachstellen, Agenten installiert | ansible-playbook | Ansible |
| **BEREIT** | Validiert, Snapshot »clean« gesetzt | qm snapshot | Proxmox |
| **IN BENUTZUNG** | Teilnehmer arbeiten, Telemetrie läuft | Freigabe White Team | Guacamole |
| **ZURÜCKGESETZT** | Ausgangszustand wiederhergestellt | qm rollback | Proxmox |
| **ZERSTÖRT** | Ressourcen freigegeben | tofu destroy | OpenTofu |

Tabelle 84: Zustände einer Sandbox

## Szenario-Logik: Ziele, MSEL, Injects, ATT&CK

Das Szenario ist das »Programm«, das auf der Infrastruktur läuft. Es besteht aus fünf Bausteinen, die logisch aufeinander aufbauen:

| **Baustein** | **Frage** | **Beispiel** |
|---|---|---|
| **Lernziel** | Was soll ein Team danach können? | »Kerberoasting im SIEM erkennen und das betroffene Konto benennen« |
| **Storyline** | In welcher Welt spielt die Übung? | Nordwind Logistik GmbH, Webshop, 50 Mitarbeiter |
| **Angriffskette** | Welche Schritte geht der Angreifer? | Phishing → PowerShell → Kerberoasting → Lateral Movement → Ransomware (Kill Chain) |
| **MSEL / Injects** | Wann passiert was für wen? | T+0:45 Helpdesk-Anruf »PC ist langsam« an Blue Team |
| **Bewertungslogik** | Woran erkennen wir Erfolg? | Ticket mit Zeitstempel, betroffenem Konto und Event-ID 4769 innerhalb von 20 Minuten |

Tabelle 85: Bausteine eines Szenarios

Wichtig ist die **Rückverfolgbarkeit**: Jedes Lernziel ist mit mindestens einem Angriffsschritt, mindestens einer erwarteten Telemetrie-Spur und einem Bewertungskriterium verknüpft. Fehlt eines davon, ist das Lernziel nicht messbar – ein typischer Fehler bei ersten Szenarien.

## Methodik für das Szenario-Design

Ein gutes Szenario entsteht nicht durch eine Sammlung spannender Angriffe, sondern rückwärts von den Lernzielen her. Die folgende Methodik hat sich in vielen Übungen bewährt:

1. **Zielgruppe und Ausgangsniveau bestimmen:** Wer übt? Junior-Analysten, ein erfahrenes CSIRT, Führungskräfte?
1. **Lernziele formulieren** – messbar und nach Bloom-Stufen (Kapitel 31): »Die Teilnehmer erkennen Kerberoasting anhand von EID 4769 innerhalb von 30 Minuten.«
1. **Bedrohungsakteur wählen:** Motivation, Fähigkeiten, typische Techniken (z. B. finanziell motivierte Ransomware-Gruppe). Die Techniken stammen aus ATT&CK-Gruppenprofilen.
1. **Angriffskette entwerfen:** Jede Phase dient mindestens einem Lernziel. Phasen ohne Lernziel werden gestrichen oder automatisiert.
1. **Umgebung ableiten:** Welche Systeme braucht die Kette? Was braucht es für Realismus (NPCs, Artefakte)?
1. **Injects planen:** Ereignisse, die Entscheidungen erzwingen (Presseanfrage, Erpresserschreiben, Ausfall eines Dienstes).
1. **Bewertung festlegen:** Welche Beobachtung belegt, dass ein Lernziel erreicht wurde?
1. **Testen:** Dry-Run mit einem internen Team, Zeitmessung jeder Phase, Anpassung.
> [!TIPP] Die »Was-wäre-wenn«-Prüfung
> Für jede Phase wird gefragt: Was passiert, wenn das Blue Team **sofort** reagiert? Und was, wenn es **gar nicht** reagiert? Für beide Fälle braucht das White Team einen Plan (z. B. einen Ersatz-Zugang für das Red Team oder einen Hinweis-Inject für das Blue Team), damit die Übung nicht vorzeitig endet oder ins Leere läuft.

## Inject-Typen

| **Typ** | **Beispiel** | **Trainierte Fähigkeit** |
|---|---|---|
| **Technisch** | Neuer Angriff wird ausgelöst, Dienst fällt aus | Erkennung, Analyse, Wiederherstellung |
| **Kommunikativ** | Geschäftsführung verlangt Lagebericht in 20 Minuten | Verständliche Berichterstattung |
| **Rechtlich / regulatorisch** | Meldepflicht nach DSGVO (72 Stunden) oder NIS2 prüfen | Rechtliche Bewertung, Fristen |
| **Medien** | Journalist fragt nach einem Datenleck | Krisenkommunikation |
| **Sozial** | Mitarbeiter meldet verdächtigen Anruf vom »IT-Support« | Social-Engineering-Erkennung |
| **Entscheidung** | Erpresser fordert Lösegeld; Systeme abschalten oder weiterlaufen lassen? | Abwägung, Eskalation |
| **Hinweis (Hilfe)** | Anonymer Tipp auf ein kompromittiertes System | Steuerung bei festgefahrenen Teams |

Tabelle 86: Typen von Injects

## Schwierigkeit dynamisch steuern

Teams sind unterschiedlich stark. Damit alle gefordert, aber keines überfordert wird, hat das White Team mehrere Stellschrauben:

| **Stellschraube** | **Leichter** | **Schwerer** |
|---|---|---|
| **Tempo des Red Teams** | längere Pausen zwischen Phasen | Phasen parallel oder schneller |
| **Lautstärke der Angriffe** | bekannte Werkzeuge mit Standardsignaturen | Living-off-the-Land, verschleierte Befehle |
| **Hinweise** | Hinweis-Injects, Tipps im Portal (Punktabzug) | keine Hinweise |
| **Grundrauschen (NPCs)** | wenig Hintergrundverkehr | viel Verkehr, mehr Fehlalarme |
| **Ausgangslage** | Monitoring vollständig vorkonfiguriert | Blue Team muss Sensoren erst einrichten |

Tabelle 87: Stellschrauben für die Schwierigkeit

## Varianten erzeugen, damit Szenarien nicht verbrauchen

Ein Szenario, das alle Teilnehmer kennen, verliert seinen Wert. Statt ständig neue Szenarien zu schreiben, werden **Varianten** erzeugt: Die Grundstruktur bleibt gleich, Details ändern sich. Das spart Aufwand und erhält die Vergleichbarkeit.

| **Stellschraube** | **Beispiele für Varianten** | **Wirkung** |
|---|---|---|
| **Namen und Adressen** | andere Hostnamen, IP-Bereiche, Domains, Firmenname | Notizen aus früheren Übungen nützen nichts mehr |
| **Einstiegspunkt** | Phishing statt Web-Schwachstelle, kompromittierter Dienstleister-Zugang | andere Erkennungspfade |
| **Betroffene Konten** | anderes Dienstkonto, andere Abteilung | Analyse statt Erinnerung |
| **Zeitplan** | Phasen früher/später, Pausen dazwischen | keine Vorhersagbarkeit |
| **Werkzeugprofil** | andere Angreifer-Werkzeuge mit anderen Spuren | Regeln müssen verhaltens- statt werkzeugbasiert sein |
| **Ablenkung** | harmlose, aber auffällige Vorgänge (z. B. Software-Verteilung) | Triage-Fähigkeit wird geprüft |

Tabelle 88: Stellschrauben für Szenario-Varianten

Technisch werden Varianten über **Variablen** umgesetzt: Die Sandbox-Definition enthält Platzhalter (z. B. für Domainnamen oder das Ziel-Dienstkonto), und eine Variantendatei legt die Werte fest. So entsteht jede Variante reproduzierbar aus demselben Code.
