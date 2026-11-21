---
id: d-07
title: YARA und Sigma – Erkennungsregeln schreiben
paths: cdsa
order: 7
difficulty: hard
icon: text.badge.checkmark
summary: Aufbau von YARA-Regeln für Dateien und Speicher, Sigma-Regeln für Logs, Konvertierung in SIEM-Abfragen, Qualitätskriterien und Testen.
htb: YARA & Sigma for SOC Analysts
---

## YARA – Muster in Dateien

[[YARA]] beschreibt Merkmale von Dateien oder Speicherbereichen. Eine Regel besteht aus Metadaten, Strings und einer Bedingung:

```yara
rule Beispiel_Ransom_Note
{
    meta:
        author = "NIMA"
        description = "Erkennt eine typische Erpresser-Notiz"
        date = "2026-11-21"
    strings:
        $s1 = "Your files have been encrypted" ascii wide nocase
        $s2 = "bitcoin" ascii nocase
        $h1 = { 4D 5A 90 00 }
    condition:
        filesize < 2MB and ($s1 and $s2)
}
```

| Element | Bedeutung |
|---|---|
| `ascii`, `wide` | Kodierung (wide = UTF-16, typisch für Windows) |
| `nocase` | Groß-/Kleinschreibung egal |
| `{ 4D 5A ?? 00 }` | Hex-Muster mit Platzhaltern |
| `/regex/` | regulärer Ausdruck |
| `uint16(0) == 0x5A4D` | Prüfung auf PE-Datei am Dateianfang |
| `2 of ($s*)` | mindestens zwei der Strings |
| Module `pe`, `hash`, `math` | z. B. `pe.imports("kernel32.dll", "VirtualAllocEx")` |

> [!TIPP] Gute YARA-Regeln
> Kombiniere mehrere eindeutige Merkmale, begrenze per Dateigröße und Dateityp und vermeide zu allgemeine Strings – sonst entstehen Fehlalarme bei legitimer Software.

## Sigma – Muster in Logs

**[[Sigma]]** ist für Logs, was YARA für Dateien ist: ein herstellerneutrales YAML-Format, das in Abfragen für Splunk, Elastic, Sentinel und andere übersetzt wird.

```yaml
title: Office startet eine Shell
id: 0b6a8b6e-1d5c-4b1f-9e2a-000000000001
status: experimental
description: Erkennt Office-Programme, die eine Kommandozeile oder PowerShell starten
logsource:
  category: process_creation
  product: windows
detection:
  selection_parent:
    ParentImage|endswith:
      - '\WINWORD.EXE'
      - '\EXCEL.EXE'
      - '\POWERPNT.EXE'
  selection_child:
    Image|endswith:
      - '\cmd.exe'
      - '\powershell.exe'
  condition: selection_parent and selection_child
falsepositives:
  - legitime Add-ins
level: high
tags:
  - attack.execution
  - attack.t1204.002
```

| Feld | Bedeutung |
|---|---|
| `logsource` | welche Logs (Kategorie, Produkt, Dienst) |
| `detection` | Auswahlen und Bedingung |
| Modifikatoren | `contains`, `startswith`, `endswith`, `re`, `all` |
| `falsepositives` | bekannte legitime Auslöser |
| `level` | informational bis critical |
| `tags` | ATT&CK-Zuordnung |

Konvertierung mit **sigma-cli** (pySigma) in die Zielsprache, z. B. SPL oder Elastic-Abfragen.

## Qualität von Erkennungen

| Kriterium | Frage |
|---|---|
| Präzision | Wie viele Alarme sind echte Treffer? |
| Abdeckung | Welche Varianten der Technik werden erkannt? |
| Robustheit | Umgeht ein simples Umbenennen die Regel? |
| Kontext | Hat der Analyst genug Informationen zur Bewertung? |
| Testbarkeit | Gibt es Testdaten, mit denen die Regel geprüft wird? |

> [!MERKE] Detection as Code
> Regeln gehören in ein Git-Repository, werden per Review geprüft, automatisiert gegen Testdaten getestet und versioniert ausgerollt – genau wie in der Detection-Pipeline deiner [[mod:cr-23|Range]].

## Quiz

? In welchem Format werden Sigma-Regeln geschrieben?
= YAML

? Welcher YARA-Modifikator steht für UTF-16-kodierte Strings?
= wide

? Welcher Bereich einer YARA-Regel enthält die Logik?
= condition

? Was beschreibt `logsource` in einer Sigma-Regel?
+ welche Logs die Regel betrachtet
- den Autor
- die ATT&CK-Technik
- die Schwere

? Welche Werkzeuge erkennen Muster in Dateien bzw. in Logs?
+ YARA für Dateien, Sigma für Logs
- Sigma für Dateien, YARA für Logs
- beide nur für Netzwerkverkehr
- beide nur für E-Mails

? Wie heißt der Ansatz, Erkennungsregeln wie Software zu versionieren und zu testen?
= Detection as Code

? Mit welchem YARA-Ausdruck prüft man, ob eine Datei mit MZ beginnt?
= uint16(0) == 0x5A4D
= uint16(0)==0x5A4D
