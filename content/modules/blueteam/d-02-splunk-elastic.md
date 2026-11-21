---
id: d-02
title: Untersuchen mit Splunk und Elastic
paths: cdsa
order: 2
difficulty: medium
icon: magnifyingglass.circle
summary: Suchsprachen SPL und KQL/EQL verstehen, typische Abfragen für Untersuchungen formulieren, Statistiken, Zeitleisten und Dashboards bauen.
htb: Understanding Log Sources & Investigating with Splunk
---

## Splunk und SPL

Splunk speichert Ereignisse in **Indizes**. Jedes Ereignis hat Standardfelder wie `_time`, `host`, `source` und `sourcetype`. Abgefragt wird mit der **Search Processing Language (SPL)** – einer Pipeline wie in der Shell.

```spl
index=wineventlog EventCode=4625
| stats count by Account_Name, src_ip
| where count > 10
| sort - count
```

| Befehl | Zweck |
|---|---|
| `stats` | zählen, summieren, gruppieren (`count by feld`) |
| `table` | ausgewählte Felder anzeigen |
| `where` | filtern nach Berechnungen |
| `eval` | neue Felder berechnen |
| `rex` | Felder per regulärem Ausdruck extrahieren |
| `timechart` | Werte über Zeit |
| `transaction` | zusammengehörige Ereignisse bündeln |
| `dedup` | Duplikate entfernen |
| `lookup` | Daten aus Tabellen anreichern |
| `rare` / `top` | seltenste / häufigste Werte |

> [!TIPP] Seltenes ist interessant
> `rare` ist eines der wertvollsten Werkzeuge im Hunting: Prozesse, die nur auf einem Rechner laufen, Eltern-Kind-Kombinationen, die sonst nie vorkommen, oder Benutzer, die sich nur einmal an einem Server anmelden.

### Beispiel: Prozessstarts aus Office-Programmen

```spl
index=sysmon EventCode=1 ParentImage IN ("*\\WINWORD.EXE","*\\EXCEL.EXE")
| table _time host User ParentImage Image CommandLine
```

Ein Word-Dokument, das eine Shell oder PowerShell startet, ist fast immer verdächtig.

## Elastic Stack

Der Elastic Stack (Elasticsearch, Logstash/Beats/Elastic Agent, Kibana) speichert Ereignisse im **Elastic Common Schema (ECS)** mit Feldern wie `event.code`, `process.name`, `source.ip`, `user.name`.

| Sprache | Einsatz | Beispiel |
|---|---|---|
| KQL | schnelle Filter in Kibana | `event.code:4625 and user.name:"admin"` |
| Lucene | ältere Syntax | `event.code:4625 AND NOT user.name:svc*` |
| EQL | Abfolgen von Ereignissen | Prozess startet, dann Netzwerkverbindung |
| ES|QL | Pipeline-Abfragen | `FROM logs-* | STATS count() BY host.name` |

```eql
sequence by host.name with maxspan=1m
  [process where process.name == "powershell.exe"]
  [network where destination.port == 443]
```

## Eine Untersuchung strukturieren

1. **Ausgangspunkt** – Alarm, Hinweis oder Hypothese
2. **Zeitfenster** festlegen und Zeitzonen beachten
3. **Pivotieren** – vom Host zum Benutzer, zur IP, zum Prozess, zum Hash
4. **Zeitleiste** aufbauen – was geschah in welcher Reihenfolge?
5. **Umfang** bestimmen – welche weiteren Hosts und Konten sind betroffen?
6. **Dokumentieren** – Abfragen und Ergebnisse festhalten, damit andere sie nachvollziehen können

## Quiz

? Welcher SPL-Befehl zählt Ereignisse gruppiert nach Feldern?
= stats
= stats count by

? Welcher SPL-Befehl extrahiert Felder per regulärem Ausdruck?
= rex

? Welcher SPL-Befehl zeigt die seltensten Werte eines Feldes?
= rare

? Welche Elastic-Sprache eignet sich für Abfolgen von Ereignissen?
= EQL

? Wie heißt das einheitliche Feldschema von Elastic?
= Elastic Common Schema
= ECS

? Warum ist ein Office-Programm als Elternprozess von PowerShell verdächtig?
+ Dokumente starten normalerweise keine Shells – das deutet auf bösartige Makros hin
- PowerShell darf nie gestartet werden
- Office-Programme sind immer Schadsoftware
- Es ist nicht verdächtig

? Welches Splunk-Standardfeld enthält den Zeitstempel?
= _time
