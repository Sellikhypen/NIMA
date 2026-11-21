---
id: s-07
title: Incident Response und Notfallmanagement
paths: specialist, cdsa
order: 7
difficulty: medium
icon: light.beacon.max
summary: Der Lebenszyklus eines Sicherheitsvorfalls nach NIST, Rollen und Kommunikation, Beweissicherung, Ransomware-Szenario, Business Continuity, RTO/RPO und Backups.
htb: Incident Handling Process
---

## Ereignis, Alarm, Vorfall

| Begriff | Bedeutung |
|---|---|
| Ereignis (Event) | jede beobachtbare Begebenheit – ein Login, ein Verbindungsaufbau |
| Alarm (Alert) | ein Ereignis, das eine Regel als verdächtig markiert |
| Sicherheitsvorfall (Incident) | ein bestätigtes Ereignis mit negativer Auswirkung auf die Schutzziele |

## Der Incident-Response-Lebenszyklus (NIST SP 800-61)

1. **Preparation** – Pläne, Rollen, Kontaktlisten, Werkzeuge, Logging, Übungen
2. **Detection & Analysis** – erkennen, einordnen, Umfang bestimmen, priorisieren
3. **Containment, Eradication & Recovery** – eindämmen, Ursache beseitigen, wiederherstellen
4. **Post-Incident Activity** – Lessons Learned, Bericht, Verbesserungen

> [!INFO] SANS-Variante
> SANS beschreibt sechs Phasen: Preparation, Identification, Containment, Eradication, Recovery, Lessons Learned. Inhaltlich ist es dasselbe Modell.

## Eindämmung richtig wählen

| Strategie | Vorteil | Nachteil |
|---|---|---|
| System vom Netz isolieren | stoppt Ausbreitung | Angreifer merkt es evtl. |
| Konten sperren / Passwörter zurücksetzen | entzieht Zugang | muss vollständig sein, sonst bleibt Zugang |
| Firewall-Regeln / DNS-Sinkhole | blockiert Kontrollserver | Angreifer kann ausweichen |
| beobachten statt sofort eingreifen | mehr Erkenntnisse | Risiko weiteren Schadens |

> [!WARNUNG] Nicht vorschnell neu installieren
> Wer ein System sofort neu aufsetzt, vernichtet Spuren. Ohne Analyse bleibt unklar, wie der Angreifer hereinkam – und er kommt auf demselben Weg zurück.

## Beweissicherung

- **Order of Volatility**: zuerst flüchtige Daten sichern (Arbeitsspeicher, Netzwerkverbindungen, Prozesse), dann Festplatten, dann Logs und Backups.
- **Chain of Custody**: lückenlos dokumentieren, wer wann was gesichert, übergeben und analysiert hat.
- **Integrität**: Hashwerte der Abbilder bilden, nur auf Kopien arbeiten.
- Zeitstempel und Zeitzonen notieren – ohne gemeinsame Zeitbasis lässt sich kein Ablauf rekonstruieren.

## Kommunikation

Ein Vorfall ist auch ein Kommunikationsthema: Geschäftsleitung, Datenschutzbeauftragter, Rechtsabteilung, Aufsichtsbehörden (Fristen beachten, siehe [[mod:s-05|Recht]]), Polizei, Versicherung, Kunden, Presse. Kommunikationswege müssen auch funktionieren, wenn E-Mail und Chat kompromittiert sind (**Out-of-Band**).

## Szenario: Ransomware

1. Alarm des [[EDR]]: massenhaftes Umbenennen von Dateien auf mehreren Servern.
2. Sofort betroffene Systeme isolieren, Notfallteam einberufen.
3. Umfang klären: welche Systeme, welche Konten, wurden Daten abgezogen?
4. Erstinfektion und Persistenz finden (Phishing? Exponierter Dienst? Gestohlene VPN-Zugangsdaten?).
5. Kompromittierte Konten zurücksetzen, inklusive privilegierter Konten und – bei Domänenkompromittierung – des `krbtgt`-Kontos (zweimal).
6. Aus sauberen, getesteten Backups wiederherstellen.
7. Meldepflichten erfüllen, Lessons Learned durchführen.

## Business Continuity Management

[[BCM]] sorgt dafür, dass kritische Geschäftsprozesse auch während und nach einer Krise weiterlaufen (BSI-Standard 200-4, ISO 22301).

| Kennzahl | Bedeutung |
|---|---|
| **RTO** (Recovery Time Objective) | maximale Zeit bis zur Wiederherstellung |
| **RPO** (Recovery Point Objective) | maximal tolerierbarer Datenverlust (Zeit seit letzter Sicherung) |
| **MTPD** (Maximum Tolerable Period of Disruption) | maximal tolerierbare Ausfallzeit, bevor es existenzbedrohend wird |

Grundlage ist eine **Business Impact Analysis (BIA)**.

> [!MERKE] Die 3-2-1(-1-0)-Regel
> Drei Kopien, auf zwei Medientypen, eine außer Haus – ergänzt um eine unveränderliche bzw. offline Kopie und null Fehler bei regelmäßigen Wiederherstellungstests. Ein Backup, dessen Wiederherstellung nie getestet wurde, ist eine Hoffnung, kein Backup.

## Quiz

?order Bringe die NIST-Phasen der Incident Response in Reihenfolge
> Preparation
> Detection & Analysis
> Containment, Eradication & Recovery
> Post-Incident Activity

? Welche Daten sichert man nach der Order of Volatility zuerst?
+ Arbeitsspeicher
- Festplatte
- Backups
- archivierte Logs

? Wie heißt die lückenlose Dokumentation der Beweismittelübergabe?
= Chain of Custody

? Was beschreibt der RPO?
+ den maximal tolerierbaren Datenverlust
- die maximale Wiederherstellungszeit
- die Anzahl der Backups
- die Kosten eines Ausfalls

? Was beschreibt der RTO?
+ die maximale Zeit bis zur Wiederherstellung
- den maximal tolerierbaren Datenverlust
- die Größe der Sicherung
- die Meldefrist

? Wie heißt die Analyse, die kritische Prozesse und deren Ausfallfolgen ermittelt?
= Business Impact Analysis
= BIA

?tf Ein kompromittiertes System sollte sofort neu installiert werden, bevor man analysiert.
= falsch

? Wie oft wird das krbtgt-Passwort nach einer Domänenkompromittierung zurückgesetzt?
= zweimal
= 2

? Wie heißt Kommunikation über einen vom kompromittierten System unabhängigen Kanal?
= Out-of-Band
