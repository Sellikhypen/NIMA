---
id: hd-01
title: Härtung · Linux-Server
paths: specialist, cyberrange, cdsa
order: 80
difficulty: medium
icon: lock.square.stack.fill
tags: haertung
summary: Minimalinstallation, Updates, SSH, Benutzer und sudo, Dateirechte, Kernel-Parameter, Firewall, MAC-Systeme, Logging und Prüfung mit Lynis und CIS Benchmarks.
---

## Grundprinzipien

1. **Minimal**: nur benötigte Pakete und Dienste
2. **Aktuell**: automatische Sicherheitsupdates (z. B. `unattended-upgrades`)
3. **Least Privilege**: Rechte so knapp wie möglich
4. **Nachvollziehbar**: Logging und Überwachung
5. **Prüfbar**: Konfiguration als Code und regelmäßige Audits

## SSH

```text
# /etc/ssh/sshd_config (Auszug)
PermitRootLogin no
PasswordAuthentication no
PubkeyAuthentication yes
KbdInteractiveAuthentication no
AllowGroups ssh-users
MaxAuthTries 3
X11Forwarding no
```

Zusätzlich: Schlüssel mit Passphrase (ed25519), ggf. MFA, Zugriff nur aus Verwaltungsnetz, Fail2ban gegen Brute-Force.

## Benutzer und Rechte

| Maßnahme | Hinweis |
|---|---|
| sudo statt root-Login | Befehle werden protokolliert |
| sudo-Regeln eng fassen | keine Shells, Editoren oder Interpreter freigeben |
| SUID-Dateien prüfen | `find / -perm -4000 -type f` regelmäßig mit Soll-Liste vergleichen |
| Dateirechte | `/etc/shadow` 640/600, keine weltweit schreibbaren Verzeichnisse ohne Sticky Bit |
| Mount-Optionen | `/tmp` mit `noexec,nosuid,nodev` |

## Kernel und Netzwerk

```text
# /etc/sysctl.d/99-hardening.conf (Auszug)
kernel.kptr_restrict = 2
kernel.dmesg_restrict = 1
kernel.yama.ptrace_scope = 1
net.ipv4.conf.all.rp_filter = 1
net.ipv4.conf.all.accept_redirects = 0
net.ipv4.tcp_syncookies = 1
```

Firewall mit nftables/ufw: Default Deny eingehend, nur benötigte Ports.

## MAC und Logging

SELinux oder AppArmor im **Enforcing**-Modus, auditd für sicherheitsrelevante Ereignisse, Logs an zentrales SIEM ([[mod:bt-02|Log-Management]]).

## Prüfen

**Lynis** liefert einen Härtungsindex und Vorschläge; CIS Benchmarks und OpenSCAP prüfen gegen definierte Profile.

## Quiz

? Welche sshd-Einstellung verbietet die direkte Anmeldung als root?
= PermitRootLogin no

? Warum sollten sudo-Regeln keine Editoren oder Interpreter freigeben?
+ Sie erlauben oft das Starten einer Shell mit erhöhten Rechten
- Sie sind zu langsam
- Sie brauchen Internet
- Sie verbrauchen Lizenzen

? Welche Mount-Optionen härten /tmp?
+ noexec
+ nosuid
+ nodev
- exec

? Welches Werkzeug liefert einen Härtungsindex für Linux?
= Lynis

? In welchem Modus sollte SELinux laufen?
= Enforcing

@@@ MODULE @@@
---
id: hd-02
title: Härtung · Windows und CIS Benchmarks
paths: specialist, cdsa
order: 81
difficulty: medium
icon: square.grid.3x3.square
tags: haertung
summary: Benchmarks und Baselines verstehen, Level 1 und 2, die wirksamsten Windows-Härtungsmaßnahmen, Attack Surface Reduction, Credential-Schutz und Messung der Umsetzung.
---

## Benchmarks und Baselines

| Quelle | Inhalt |
|---|---|
| CIS Benchmarks | detaillierte Empfehlungen für Betriebssysteme, Cloud, Anwendungen; Level 1 (breit einsetzbar) und Level 2 (strenger) |
| Microsoft Security Baselines | fertige GPOs/Intune-Profile |
| DISA STIGs | US-Behördenstandards |
| BSI SiSyPHuS | Analysen und Empfehlungen zu Windows 10/11 |

## Wirksamste Maßnahmen

| Maßnahme | Schutz vor |
|---|---|
| keine lokalen Admin-Rechte für Benutzer | Großteil der Malware-Folgen |
| LAPS | Wiederverwendung lokaler Admin-Passwörter |
| Credential Guard, LSA-Schutz | Auslesen von Anmeldedaten |
| ASR-Regeln (Attack Surface Reduction) | Office-Makros, die Prozesse starten; Skripte aus Mails |
| Application Control (WDAC/AppLocker) | unbekannte Programme |
| SMB-Signing, SMBv1 aus | Relay- und Wurmangriffe |
| BitLocker mit TPM (+PIN) | Datenzugriff bei Gerätediebstahl |
| PowerShell Constrained Language + Logging | Missbrauch von Skripten |
| Firewall mit eingehendem Default Deny | Seitwärtsbewegung |

## Umsetzung

1. Benchmark wählen, Abweichungen bewerten
2. Pilotgruppe, Kompatibilität testen
3. ausrollen über GPO/Intune ([[mod:adv-01|GPO-Härtung]])
4. Ausnahmen dokumentieren
5. Konformität messen (z. B. CIS-CAT, Defender Vulnerability Management, Policy Analyzer)

## Quiz

? Was unterscheidet CIS Level 1 und Level 2?
+ Level 2 ist strenger und kann Funktionen stärker einschränken
- Level 1 ist strenger
- Level 2 ist nur für Linux
- es gibt keinen Unterschied

? Wofür steht ASR?
= Attack Surface Reduction

? Welche Maßnahme schützt vor Wiederverwendung lokaler Admin-Passwörter?
= LAPS

? Welche Maßnahme schützt Daten bei Gerätediebstahl?
= BitLocker

? Wie heißt das BSI-Projekt zu Windows-Sicherheitsanalysen?
= SiSyPHuS

@@@ MODULE @@@
---
id: hd-03
title: Härtung · Endpunkte, macOS und mobile Geräte
paths: specialist
order: 82
difficulty: easy
icon: iphone.gen3.radiowaves.left.and.right
tags: haertung
summary: Gemeinsame Baseline für alle Endgeräte, macOS-Schutzmechanismen, Mobile Device Management, BYOD und die wichtigsten Einstellungen für iOS und Android.
---

## Gemeinsame Baseline

| Bereich | Mindestanforderung |
|---|---|
| Updates | automatisch, Fristen überwachen |
| Verschlüsselung | Festplatte/Speicher vollständig |
| Sperre | Bildschirmsperre, starke PIN/Biometrie |
| Konten | keine Admin-Rechte im Alltag |
| Schutz | EDR/Antimalware ([[mod:bt-01|EDR]]) |
| Verwaltung | zentral (MDM/UEM), Inventar |
| Daten | Backups bzw. Cloud-Synchronisation nach Richtlinie |

## macOS

| Mechanismus | Funktion |
|---|---|
| Gatekeeper | nur signierte/notarisierte Apps |
| SIP (System Integrity Protection) | schützt Systemdateien auch vor root |
| XProtect | integrierte Malware-Erkennung |
| FileVault | Festplattenverschlüsselung |
| TCC | Zugriffsfreigaben für Kamera, Mikrofon, Dateien |

## Mobile Device Management

MDM bzw. UEM (z. B. Intune, Jamf) setzt Richtlinien durch, verteilt Apps, kann Geräte sperren oder löschen und meldet Konformität an Conditional Access.

| Modell | Hinweis |
|---|---|
| Firmengerät (COBO/COPE) | volle Verwaltung |
| BYOD | nur Arbeitsbereich verwalten (Work Profile, User Enrollment), Privatsphäre respektieren |

## iOS und Android

- aktuelles Betriebssystem, keine gerooteten/jailbreakten Geräte zulassen
- Apps nur aus verwalteten Stores
- Datentrennung zwischen geschäftlichen und privaten Apps (Managed Open-In, Work Profile)
- Bluetooth/AirDrop-Empfang beschränken

## Quiz

? Welcher macOS-Mechanismus schützt Systemdateien selbst vor root?
= SIP
= System Integrity Protection

? Wie heißt die Festplattenverschlüsselung unter macOS?
= FileVault

? Was sollte bei BYOD verwaltet werden?
+ nur der geschäftliche Arbeitsbereich
- das gesamte private Gerät
- nichts
- nur die Fotos

? Welche Geräte sollten nicht zugelassen werden?
+ gerootete oder jailbreakte Geräte
- Geräte mit aktueller Software
- verschlüsselte Geräte
- Geräte mit PIN

@@@ MODULE @@@
---
id: hd-04
title: Härtung · Netzwerkgeräte
paths: specialist, cyberrange
order: 83
difficulty: medium
icon: server.rack
tags: haertung
summary: Management-Ebene absichern, sichere Protokolle, AAA, Switch-Port-Sicherheit, Firmware, Konfigurationssicherung und Überwachung von Routern, Switches und Firewalls.
---

## Drei Ebenen

| Ebene | Inhalt | Schutz |
|---|---|---|
| Management Plane | Verwaltung (SSH, Web, SNMP) | eigenes Verwaltungsnetz, nur sichere Protokolle |
| Control Plane | Routing-Protokolle, STP | Authentifizierung, Rate Limiting |
| Data Plane | Nutzdaten | ACLs, Segmentierung |

## Management absichern

- SSH statt Telnet, HTTPS statt HTTP, **SNMPv3** statt v1/v2c mit Community-Strings
- Zugriff nur aus dem Verwaltungsnetz (Out-of-Band oder eigenes VLAN)
- **AAA** über RADIUS/TACACS+ mit individuellen Konten, lokales Notfallkonto mit starkem Passwort
- Standardpasswörter ändern, ungenutzte Dienste abschalten
- Login-Banner, Sitzungs-Timeouts

## Switch-Sicherheit

| Funktion | Schutz vor |
|---|---|
| Port Security / 802.1X | fremde Geräte ([[mod:nw-03|802.1X]]) |
| DHCP Snooping | gefälschte DHCP-Server |
| Dynamic ARP Inspection | ARP-Spoofing |
| BPDU Guard | Manipulation des Spanning Tree |
| ungenutzte Ports | deaktivieren, in ein „totes“ VLAN |
| kein Native VLAN 1 für Nutzdaten | VLAN-Hopping |

## Betrieb

- Firmware aktuell, Sicherheitsmeldungen der Hersteller verfolgen
- Konfigurationen versioniert sichern, Änderungen vergleichen
- Syslog und NTP zentral, Konfigurationsänderungen alarmieren
- regelmäßige Regelprüfung auf Firewalls (ungenutzte oder zu weite Regeln)

## Quiz

? Welche SNMP-Version sollte verwendet werden?
= SNMPv3
= 3

? Welche Funktion schützt vor gefälschten DHCP-Servern?
= DHCP Snooping

? Welche Funktion schützt vor ARP-Spoofing?
= Dynamic ARP Inspection
= DAI

? Welche Protokolle werden für AAA genutzt?
+ RADIUS
+ TACACS+
- FTP
- Telnet

? Welche Ebene umfasst SSH, Web-Oberfläche und SNMP?
= Management Plane
