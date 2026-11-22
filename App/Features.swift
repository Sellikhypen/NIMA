import SwiftUI
import Charts
import UniformTypeIdentifiers

// MARK: - Einstellungen

struct SettingsView: View {
    @Environment(Store.self) private var store
    @State private var confirmReset = false
    @State private var importing = false
    @State private var backupURL: URL?
    var body: some View {
        @Bindable var store = store
        Form {
            Section("Profil") {
                HStack {
                    Text("Name")
                    Spacer()
                    TextField("Operator", text: $store.progress.name)
                        .multilineTextAlignment(.trailing)
                        .foregroundStyle(NT.acc)
                }
                Picker("Erfahrung", selection: $store.progress.experience) {
                    Text("Einsteiger").tag("start")
                    Text("Fortgeschritten").tag("mid")
                    Text("Profi").tag("pro")
                }
            }
            Section {
                Stepper(value: $store.progress.dailyGoal, in: 5...300, step: 5) {
                    LabeledContent("Tagesziel", value: "\(store.progress.dailyGoal) Punkte")
                }
                Stepper(value: $store.progress.prefs.sessionSize, in: 5...60, step: 5) {
                    LabeledContent("Fragen pro Training", value: "\(store.progress.prefs.sessionSize)")
                }
                Stepper(value: $store.progress.prefs.newPerSession, in: 0...30) {
                    LabeledContent("Neue Karten pro Session", value: "\(store.progress.prefs.newPerSession)")
                }
                Picker("Wiederholungs-Abstände", selection: $store.progress.prefs.srsFactor) {
                    Text("Intensiv (kürzer)").tag(0.7)
                    Text("Ausgewogen").tag(1.0)
                    Text("Entspannt (länger)").tag(1.4)
                }
                Toggle("Neue Fragen leicht → schwer", isOn: $store.progress.prefs.simpleFirst)
            } header: { Text("Lernen") } footer: {
                Text("Tagesziel: 1 Punkt pro beantworteter Frage, 3 Punkte pro gelesener Lektion. Die Wiederholungs-Abstände steuern, wie schnell gemeisterte Karten wiederkommen (Spaced Repetition, SM-2).")
            }
            Section {
                Toggle("Wissens-Check nach jeder Lektion", isOn: $store.progress.prefs.lessonChecks)
                Toggle("Kontext aus der Lektion zeigen", isOn: $store.progress.prefs.showContext)
                Toggle("Hinweis-Button anzeigen", isOn: $store.progress.prefs.showHints)
                Toggle("Tippfehler tolerieren", isOn: $store.progress.prefs.typoTolerance)
                Toggle("Antworten mischen", isOn: $store.progress.prefs.shuffleOptions)
                Toggle("Automatisch weiter bei richtig", isOn: $store.progress.prefs.autoNext)
            } header: { Text("Quiz & Erklärungen") }
            Section {
                Picker("Bestehensgrenze", selection: $store.progress.prefs.examPass) {
                    Text("70 %").tag(0.7)
                    Text("75 %").tag(0.75)
                    Text("80 %").tag(0.8)
                    Text("90 %").tag(0.9)
                }
                Picker("Zeit pro Frage", selection: $store.progress.prefs.examSeconds) {
                    Text("45 s").tag(45)
                    Text("60 s").tag(60)
                    Text("75 s").tag(75)
                    Text("90 s").tag(90)
                    Text("120 s").tag(120)
                }
            } header: { Text("Prüfungssimulation") }
            Section {
                VStack(alignment: .leading, spacing: 8) {
                    LabeledContent("Textgröße", value: "\(Int(store.progress.prefs.readScale * 100)) %")
                    Slider(value: $store.progress.prefs.readScale, in: 0.85...1.4, step: 0.05)
                    MD(text: "Beispieltext mit **Fachbegriff** und `befehl -x`.", size: 16, color: NT.tx2)
                        .environment(\.readScale, CGFloat(store.progress.prefs.readScale))
                }
                Toggle("Haptisches Feedback", isOn: $store.progress.haptics)
                Toggle("Konfetti & Feiern", isOn: $store.progress.prefs.confetti)
                NavigationLink { ShopView() } label: {
                    LabeledContent("Farbthema", value: THEMES.first { $0.id == store.progress.prefs.accent }?.name ?? "Matrix")
                }
            } header: { Text("Darstellung") }
            Section {
                Toggle("Tägliche Erinnerung", isOn: $store.progress.prefs.reminder)
                if store.progress.prefs.reminder {
                    DatePicker("Uhrzeit", selection: reminderTime, displayedComponents: .hourAndMinute)
                }
            } header: { Text("Erinnerung") } footer: { Text("Eine lokale Mitteilung pro Tag – keine Daten verlassen dein Gerät.") }
            Section {
                if let url = backupURL {
                    ShareLink(item: url) { Label("Backup teilen / sichern", systemImage: "square.and.arrow.up") }
                } else {
                    Button { backupURL = store.exportBackup() } label: { Label("Backup erstellen", systemImage: "externaldrive.fill.badge.plus") }
                }
                Button { importing = true } label: { Label("Backup laden", systemImage: "square.and.arrow.down") }
                Button(role: .destructive) { confirmReset = true } label: { Label("Fortschritt zurücksetzen", systemImage: "trash") }
            } header: { Text("Daten") } footer: {
                if let c = store.content {
                    Text("Inhalte \(c.version) · \(c.stats.modules) Module · \(c.stats.lessons) Lektionen · \(c.stats.questions) Fragen · \(c.stats.terms) Begriffe · \(c.stats.words.formatted()) Wörter")
                }
            }
        }
        .scrollContentBackground(.hidden)
        .background(AppBackground())
        .navigationTitle("Einstellungen")
        .onChange(of: store.progress.prefs) { old, new in
            store.save()
            if old.reminder != new.reminder || old.reminderHour != new.reminderHour || old.reminderMinute != new.reminderMinute {
                store.scheduleReminder()
            }
        }
        .onChange(of: store.progress.dailyGoal) { _, _ in store.save() }
        .onChange(of: store.progress.haptics) { _, _ in store.save() }
        .onChange(of: store.progress.name) { _, _ in store.save() }
        .onChange(of: store.progress.experience) { _, _ in store.save() }
        .fileImporter(isPresented: $importing, allowedContentTypes: [.json]) { result in
            if case .success(let url) = result {
                if !store.importBackup(url) {
                    store.showToast(icon: "xmark.octagon.fill", title: "Backup ungültig", detail: "Die Datei konnte nicht gelesen werden.", color: "#FF4D5E")
                }
            }
        }
        .confirmationDialog("Wirklich alles zurücksetzen?", isPresented: $confirmReset, titleVisibility: .visible) {
            Button("Zurücksetzen", role: .destructive) { store.resetProgress() }
        } message: { Text("XP, Level, Statistiken, Achievements, Notizen und Lernkartei werden gelöscht. Tipp: vorher ein Backup erstellen.") }
    }

    var reminderTime: Binding<Date> {
        Binding(
            get: {
                Calendar.current.date(bySettingHour: store.progress.prefs.reminderHour, minute: store.progress.prefs.reminderMinute, second: 0, of: Date()) ?? Date()
            },
            set: { d in
                let c = Calendar.current.dateComponents([.hour, .minute], from: d)
                store.progress.prefs.reminderHour = c.hour ?? 19
                store.progress.prefs.reminderMinute = c.minute ?? 0
            }
        )
    }
}

// MARK: - Shop

struct ShopView: View {
    @Environment(Store.self) private var store
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Image(systemName: "cube.fill").foregroundStyle(NT.gold)
                    Text("\(store.progress.coins) Credits").font(NT.mono(22, .heavy)).foregroundStyle(NT.gold)
                    Spacer()
                }
                .card(glow: NT.gold)
                Text("Credits verdienst du mit Lektionen, richtigen Antworten, Missionen, Flags, Achievements und Prüfungen.")
                    .font(.footnote).foregroundStyle(NT.tx3)

                SectionHeader(title: "Power-ups")
                ShopRow(icon: "snowflake", color: NT.blue, title: "Streak-Freeze",
                        text: "Rettet deine Streak automatisch, wenn du einen Tag verpasst. Besitz: \(store.progress.streakFreezes)/3",
                        price: 150, disabled: store.progress.streakFreezes >= 3) {
                    if store.buyFreeze() { store.showToast(icon: "snowflake", title: "Streak-Freeze gekauft", detail: "Du hast jetzt \(store.progress.streakFreezes).", color: "#4CC2FF") }
                }
                ShopRow(icon: "bolt.badge.clock.fill", color: NT.orange, title: "XP-Booster ×2",
                        text: store.boostActive ? "Aktiv – noch \(store.boostMinutesLeft) min. Kauf verlängert um 30 min." : "30 Minuten doppelte XP für Lektionen, Fragen und Prüfungen.",
                        price: 200, disabled: false) {
                    if store.buyBoost() { store.showToast(icon: "bolt.fill", title: "XP-Booster aktiv", detail: "Noch \(store.boostMinutesLeft) Minuten ×2 XP.", color: "#FFAF00") }
                }

                SectionHeader(title: "Farbthemen", trailing: "\(store.progress.ownedThemes.count)/\(THEMES.count)")
                LazyVGrid(columns: [GridItem(.flexible(), spacing: 12), GridItem(.flexible(), spacing: 12)], spacing: 12) {
                    ForEach(THEMES) { t in
                        let owned = store.progress.ownedThemes.contains(t.id)
                        let active = store.progress.prefs.accent == t.id
                        Button {
                            if !store.buyTheme(t) { store.showToast(icon: "cube", title: "Zu wenig Credits", detail: "Dir fehlen \(t.price - store.progress.coins) Credits.", color: "#FF4D5E") }
                        } label: {
                            VStack(alignment: .leading, spacing: 8) {
                                HStack {
                                    Circle().fill(Color(hex: t.hex)).frame(width: 26, height: 26).shadow(color: Color(hex: t.hex), radius: 8)
                                    Spacer()
                                    if active { Image(systemName: "checkmark.circle.fill").foregroundStyle(Color(hex: t.hex)) }
                                }
                                Text(t.name).font(.system(size: 15, weight: .bold)).foregroundStyle(NT.tx)
                                Text(owned ? (active ? "Aktiv" : "Anwenden") : "\(t.price) Credits").font(NT.mono(11)).foregroundStyle(owned ? NT.tx2 : NT.gold)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .card(padding: 14, glow: active ? Color(hex: t.hex) : nil)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            .padding(16)
        }
        .background(AppBackground())
        .navigationTitle("Shop")
    }
}

struct ShopRow: View {
    let icon: String
    let color: Color
    let title: String
    let text: String
    let price: Int
    let disabled: Bool
    let buy: () -> Void
    @Environment(Store.self) private var store
    var body: some View {
        HStack(spacing: 14) {
            IconTile(icon: icon, color: color, size: 46)
            VStack(alignment: .leading, spacing: 3) {
                Text(title).font(.system(size: 16, weight: .bold))
                Text(text).font(.system(size: 12)).foregroundStyle(NT.tx2)
            }
            Spacer(minLength: 0)
            Button(action: buy) {
                Text("\(price)").font(NT.mono(13, .heavy))
                    .padding(.horizontal, 12).padding(.vertical, 8)
                    .background(Capsule().fill(NT.gold.opacity(store.progress.coins >= price && !disabled ? 0.2 : 0.05)))
                    .foregroundStyle(store.progress.coins >= price && !disabled ? NT.gold : NT.tx3)
            }
            .disabled(store.progress.coins < price || disabled)
        }
        .card(padding: 14)
    }
}

// MARK: - Statistik

struct StatsView: View {
    @Environment(Store.self) private var store
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                SkillOverview()
                Heatmap()
                ForecastCard()
                DifficultyBreakdown()
                PathMasteryList()
            }
            .padding(16)
        }
        .background(AppBackground())
        .navigationTitle("Statistik")
    }
}

struct SkillOverview: View {
    @Environment(Store.self) private var store
    var body: some View {
        let r = store.overallSkill
        let t = skillTier(r)
        let next = SKILL_TIERS.first { $0.min > r }
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader(title: "Skill-Liga (Können)", trailing: "\(store.skillCount("all")) Antworten")
            HStack(spacing: 14) {
                SkillBadge(rating: r, size: 60)
                VStack(alignment: .leading, spacing: 4) {
                    Text(t.name).font(.system(size: 22, weight: .heavy)).foregroundStyle(Color(hex: t.color))
                    Text("Rating \(Int(r))").font(NT.mono(13, .bold)).foregroundStyle(NT.tx2)
                    if let n = next {
                        Text("Noch \(Int(n.min - r)) bis \(n.name)").font(NT.mono(11)).foregroundStyle(NT.tx3)
                    }
                }
                Spacer()
            }
            Text("Das Rating funktioniert wie Elo im Schach: Schwere Fragen richtig = großer Sprung, leichte Fragen falsch = Abzug. Anders als XP misst es, wie gut du wirklich bist.")
                .font(.system(size: 12)).foregroundStyle(NT.tx3)
            ForEach(store.paths) { p in
                let pr = store.skillRating(p.id)
                let n = store.skillCount(p.id)
                if n > 0 {
                    HStack(spacing: 10) {
                        SkillBadge(rating: pr, size: 26)
                        Text(p.title).font(.system(size: 13, weight: .semibold)).lineLimit(1)
                        Spacer()
                        Text("\(skillTier(pr).name) · \(Int(pr))").font(NT.mono(11, .bold)).foregroundStyle(Color(hex: skillTier(pr).color))
                    }
                }
            }
        }
        .card(padding: 16, glow: Color(hex: t.color))
    }
}

struct Heatmap: View {
    @Environment(Store.self) private var store
    var body: some View {
        let weeks = 17
        let cal = Calendar(identifier: .iso8601)
        let wd = cal.component(.weekday, from: Date())
        let dow = (wd + 5) % 7
        let goal = max(store.progress.dailyGoal, 1)
        VStack(alignment: .leading, spacing: 10) {
            SectionHeader(title: "Lernkalender", trailing: "\(store.activeDays) aktive Tage")
            HStack(alignment: .top, spacing: 3) {
                ForEach(0..<weeks, id: \.self) { w in
                    VStack(spacing: 3) {
                        ForEach(0..<7, id: \.self) { d in
                            let offset = -((weeks - 1 - w) * 7 + dow - d)
                            let a = store.progress.daily[Store.dayKey(offset: offset)]?.activity ?? 0
                            let lvl = offset > 0 ? -1 : (a == 0 ? 0 : a < goal / 2 ? 1 : a < goal ? 2 : a < goal * 2 ? 3 : 4)
                            RoundedRectangle(cornerRadius: 3)
                                .fill(Heatmap.shade(lvl))
                                .aspectRatio(1, contentMode: .fit)
                        }
                    }
                }
            }
            HStack(spacing: 4) {
                Text("weniger").font(NT.mono(9)).foregroundStyle(NT.tx3)
                ForEach(0..<5, id: \.self) { l in
                    RoundedRectangle(cornerRadius: 2).fill(Heatmap.shade(l)).frame(width: 10, height: 10)
                }
                Text("mehr").font(NT.mono(9)).foregroundStyle(NT.tx3)
                Spacer()
                let mins = store.progress.daily.values.reduce(0) { $0 + $1.seconds + $1.readSeconds } / 60
                Text("Lernzeit gesamt: \(mins / 60) h \(mins % 60) min").font(NT.mono(9)).foregroundStyle(NT.tx3)
            }
        }
        .card(padding: 14)
    }

    static func shade(_ lvl: Int) -> Color {
        let opacities: [Double] = [0, 0.25, 0.5, 0.75, 1]
        if lvl < 0 { return Color.clear }
        if lvl == 0 { return Color.white.opacity(0.06) }
        return NT.acc.opacity(opacities[min(lvl, 4)])
    }
}

struct FcPoint: Identifiable {
    let id: Int
    let label: String
    let count: Int
}

struct ForecastCard: View {
    @Environment(Store.self) private var store
    var body: some View {
        let f = store.forecast(days: 7)
        let labels = ["Heute", "Morgen"] + (2..<7).map { "+\($0)" }
        let pts = f.enumerated().map { FcPoint(id: $0.offset, label: labels[$0.offset], count: $0.element) }
        VStack(alignment: .leading, spacing: 10) {
            SectionHeader(title: "Wiederholungen · 7 Tage", trailing: "\(f.reduce(0, +)) Karten")
            Chart(pts) { p in
                BarMark(x: .value("Tag", p.label), y: .value("Karten", p.count))
                    .foregroundStyle(p.id == 0 ? NT.orange : NT.blue)
                    .annotation(position: .top) { if p.count > 0 { Text("\(p.count)").font(NT.mono(9)).foregroundStyle(NT.tx3) } }
            }
            .frame(height: 140)
            Text("Spaced Repetition plant jede Karte kurz vor dem Vergessen ein. Wer die heutigen Karten erledigt, hält den Berg klein.")
                .font(.system(size: 11)).foregroundStyle(NT.tx3)
        }
        .card(padding: 14)
    }
}

struct DifficultyBreakdown: View {
    @Environment(Store.self) private var store
    var body: some View {
        let rows: [(String, Int, Int, Int)] = ["easy", "medium", "hard", "insane"].map { d in
            var seen = 0, right = 0, total = 0, mastered = 0
            for m in store.modules {
                for q in m.quiz where (q.difficulty ?? "medium") == d {
                    total += 1
                    if let c = store.progress.cards[q.id], c.seen > 0 {
                        seen += c.seen
                        right += c.right
                        if c.mastered { mastered += 1 }
                    }
                }
            }
            return (d, total, mastered, seen > 0 ? Int(Double(right) / Double(seen) * 100) : -1)
        }
        VStack(alignment: .leading, spacing: 10) {
            SectionHeader(title: "Nach Schwierigkeit")
            ForEach(rows, id: \.0) { r in
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Pill(text: NT.diffLabel(r.0), color: NT.diff(r.0))
                        Spacer()
                        Text("\(r.2)/\(r.1) gemeistert").font(NT.mono(11)).foregroundStyle(NT.tx2)
                        Text(r.3 >= 0 ? "\(r.3) %" : "–").font(NT.mono(11, .bold)).foregroundStyle(NT.diff(r.0)).frame(width: 44, alignment: .trailing)
                    }
                    BarView(value: Double(r.2) / Double(max(r.1, 1)), color: NT.diff(r.0), height: 4)
                }
            }
        }
        .card(padding: 14)
    }
}

struct PathMasteryList: View {
    @Environment(Store.self) private var store
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            SectionHeader(title: "Pfade")
            ForEach(store.paths) { p in
                let c = Color(hex: p.color)
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Image(systemName: p.icon).foregroundStyle(c)
                        Text(p.title).font(.system(size: 13, weight: .semibold))
                        if store.progress.pathCerts[p.id] != nil { Image(systemName: "rosette").foregroundStyle(NT.gold) }
                        Spacer()
                        Text("\(Int(store.pathProgress(p) * 100)) %").font(NT.mono(11, .bold)).foregroundStyle(c)
                    }
                    BarView(value: store.pathProgress(p), color: c, height: 4)
                }
            }
        }
        .card(padding: 14)
    }
}

// MARK: - Notizen & Lesezeichen

struct NotesView: View {
    @Environment(Store.self) private var store
    var body: some View {
        List {
            let marks = store.progress.lessonMarks.compactMap { id -> (Module, Int)? in store.lesson(id) }
            Section("Lesezeichen (\(marks.count))") {
                if marks.isEmpty { Text("Tippe in einer Lektion auf das Lesezeichen-Symbol.").font(.footnote).foregroundStyle(NT.tx3) }
                ForEach(Array(marks.enumerated()), id: \.offset) { _, r in
                    NavigationLink(value: LessonRef(module: r.0, index: r.1)) {
                        VStack(alignment: .leading, spacing: 2) {
                            Text(Store.plain(r.0.lessons[r.1].title)).font(.system(size: 15, weight: .semibold))
                            Text(r.0.title).font(.system(size: 12)).foregroundStyle(NT.tx2)
                        }
                    }
                }
            }
            .listRowBackground(NT.panel.opacity(0.7))
            let notes = store.progress.notes.sorted { $0.key < $1.key }.compactMap { kv -> (Module, Int, String)? in
                guard let r = store.lesson(kv.key) else { return nil }
                return (r.0, r.1, kv.value)
            }
            Section("Notizen (\(notes.count))") {
                if notes.isEmpty { Text("Notizen legst du in jeder Lektion über das Stift-Symbol an.").font(.footnote).foregroundStyle(NT.tx3) }
                ForEach(Array(notes.enumerated()), id: \.offset) { _, n in
                    NavigationLink(value: LessonRef(module: n.0, index: n.1)) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(Store.plain(n.0.lessons[n.1].title)).font(.system(size: 14, weight: .semibold))
                            Text(n.2).font(.system(size: 13)).foregroundStyle(NT.gold).lineLimit(4)
                        }
                    }
                }
            }
            .listRowBackground(NT.panel.opacity(0.7))
        }
        .scrollContentBackground(.hidden)
        .background(AppBackground())
        .navigationTitle("Notizen")
    }
}

// MARK: - Fehlerbuch

struct MistakesView: View {
    @Environment(Store.self) private var store
    @State private var quiz: QuizConfig?
    @State private var onlyLeeches = false
    var body: some View {
        let list = onlyLeeches ? store.leeches : store.weakQuestions
        List {
            Section {
                VStack(alignment: .leading, spacing: 10) {
                    Text("Hier landen alle Fragen, die du schon einmal falsch hattest – sortiert nach Fehlerquote. **Problemkarten** hast du mehrfach wieder vergessen: Lies dort die Lektion nach, statt nur zu wiederholen.")
                        .font(.system(size: 13)).foregroundStyle(NT.tx2)
                    Toggle("Nur Problemkarten (\(store.leeches.count))", isOn: $onlyLeeches).font(.system(size: 14))
                    Button { quiz = QuizConfig(mode: .training, title: "Fehlerbuch", questions: Array(list.prefix(20)).shuffled()) } label: {
                        Label("Fehler trainieren (\(min(list.count, 20)))", systemImage: "crosshair")
                    }
                    .buttonStyle(PrimaryButtonStyle(color: NT.red))
                    .disabled(list.isEmpty)
                }
                .padding(.vertical, 6)
            }
            .listRowBackground(NT.panel.opacity(0.7))
            Section("\(list.count) Fragen") {
                ForEach(list.prefix(150)) { q in
                    let c = store.card(q)
                    VStack(alignment: .leading, spacing: 5) {
                        HStack {
                            if c?.isLeech == true { Pill(text: "Problem", color: NT.red) }
                            Text("\(c?.wrong ?? 0)× falsch · \(c?.right ?? 0)× richtig").font(NT.mono(10)).foregroundStyle(NT.tx3)
                            Spacer()
                        }
                        MD(text: q.q, size: 14, weight: .semibold)
                        MD(text: "→ **" + q.displayAnswer + "**", size: 13, color: NT.acc)
                        if let e = q.explain, !e.isEmpty { MD(text: e, size: 12, color: NT.tx2) }
                        else if let x = q.ctx, !x.isEmpty { MD(text: "„" + x + "“", size: 12, color: NT.tx2) }
                        if let m = store.module(of: q) {
                            NavigationLink(value: LessonRef(module: m, index: q.lesson ?? 0)) {
                                Text("Nachlesen: \(m.title)").font(NT.mono(10, .bold)).foregroundStyle(NT.blue)
                            }
                        }
                    }
                    .padding(.vertical, 4)
                }
            }
            .listRowBackground(NT.panel.opacity(0.7))
        }
        .scrollContentBackground(.hidden)
        .background(AppBackground())
        .navigationTitle("Fehlerbuch")
        .fullScreenCover(item: $quiz) { QuizView(config: $0) }
    }
}

// MARK: - Lernplan

struct PlanEditor: View {
    @Environment(Store.self) private var store
    @Environment(\.dismiss) private var dismiss
    @State private var path = ""
    @State private var date = Calendar.current.date(byAdding: .day, value: 60, to: Date()) ?? Date()
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    Picker("Ziel", selection: $path) {
                        Text("Kein Lernplan").tag("")
                        ForEach(store.paths) { p in Text(p.title).tag(p.id) }
                    }
                    if !path.isEmpty {
                        DatePicker("Prüfungstermin / Ziel", selection: $date, in: Date()..., displayedComponents: .date)
                    }
                } footer: {
                    Text("NIMA rechnet aus, wie viele Lektionen du pro Tag schaffen musst, und zeigt dir auf der Startseite, ob du im Plan bist.")
                }
                if let p = store.pathIndex[path] {
                    let remaining = store.modules(of: p).reduce(0) { $0 + $1.lessons.filter { !store.isRead($0) }.count }
                    let days = max(1, (Calendar.current.dateComponents([.day], from: Date(), to: date).day ?? 0) + 1)
                    Section("Vorschau") {
                        LabeledContent("Offene Lektionen", value: "\(remaining)")
                        LabeledContent("Tage", value: "\(days)")
                        LabeledContent("Pro Tag", value: "\(Int((Double(remaining) / Double(days)).rounded(.up))) Lektionen")
                        LabeledContent("Fragen im Pfad", value: "\(store.modules(of: p).reduce(0) { $0 + $1.quiz.count })")
                    }
                }
            }
            .scrollContentBackground(.hidden)
            .background(AppBackground())
            .navigationTitle("Lernplan")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) { Button("Abbrechen") { dismiss() } }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Sichern") {
                        store.progress.planPath = path
                        store.progress.planDate = path.isEmpty ? 0 : date.timeIntervalSince1970
                        store.save()
                        dismiss()
                    }
                    .bold()
                }
            }
            .onAppear {
                path = store.progress.planPath
                if store.progress.planDate > 0 { date = Date(timeIntervalSince1970: store.progress.planDate) }
            }
        }
    }
}

struct PlanCard: View {
    @Environment(Store.self) private var store
    @State private var edit = false
    var body: some View {
        Button { edit = true } label: {
            if let s = store.planStatus {
                let c = Color(hex: s.path.color)
                HStack(spacing: 14) {
                    ProgressRing(value: Double(s.todayDone) / Double(max(s.perDay, 1)), color: s.onTrack ? NT.acc : c, size: 56, line: 6, label: "\(s.todayDone)", sub: "/\(s.perDay)")
                    VStack(alignment: .leading, spacing: 4) {
                        Text("LERNPLAN · \(s.path.title.uppercased())").font(NT.mono(10, .bold)).tracking(1.2).foregroundStyle(c).lineLimit(1)
                        Text(s.remainingLessons == 0 ? "Pfad komplett gelesen – jetzt Prüfung üben!" : (s.onTrack ? "Heute im Plan ✓" : "Heute noch \(s.perDay - s.todayDone) Lektion(en)"))
                            .font(.system(size: 15, weight: .bold)).foregroundStyle(NT.tx)
                        Text("\(s.remainingLessons) Lektionen offen · \(s.daysLeft) Tage").font(.system(size: 12)).foregroundStyle(NT.tx2)
                    }
                    Spacer(minLength: 0)
                    Image(systemName: "slider.horizontal.3").foregroundStyle(NT.tx3)
                }
                .card(glow: c)
            } else {
                HStack(spacing: 14) {
                    IconTile(icon: "calendar.badge.clock", color: NT.teal, size: 46)
                    VStack(alignment: .leading, spacing: 3) {
                        Text("Lernplan erstellen").font(.system(size: 15, weight: .bold)).foregroundStyle(NT.tx)
                        Text("Ziel-Zertifikat + Termin wählen – NIMA plant deine Tagesportion.").font(.system(size: 12)).foregroundStyle(NT.tx2).multilineTextAlignment(.leading)
                    }
                    Spacer(minLength: 0)
                    Image(systemName: "plus.circle.fill").font(.system(size: 26)).foregroundStyle(NT.teal)
                }
                .card()
            }
        }
        .buttonStyle(.plain)
        .sheet(isPresented: $edit) { PlanEditor() }
    }
}

// MARK: - Missionen

struct QuestsCard: View {
    @Environment(Store.self) private var store
    var body: some View {
        let qs = store.dailyQuests
        let doneAll = store.progress.questDay == Store.dayKey() && store.progress.questClaimed.contains("chest")
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                SectionHeader(title: "Tagesmissionen")
                Image(systemName: doneAll ? "gift.fill" : "gift").foregroundStyle(doneAll ? NT.gold : NT.tx3)
                Text(doneAll ? "Truhe geöffnet" : "\(qs.filter { $0.done }.count)/3 → Truhe").font(NT.mono(10)).foregroundStyle(NT.tx3)
            }
            ForEach(qs) { q in QuestRow(q: q) }
            Divider().overlay(NT.line)
            HStack {
                Text("WOCHEN-CHALLENGES").font(NT.mono(10, .bold)).tracking(1.2).foregroundStyle(NT.purple)
                Spacer()
                Text(weekLeft).font(NT.mono(10)).foregroundStyle(NT.tx3)
            }
            ForEach(store.weeklyQuests) { q in QuestRow(q: q, color: NT.purple) }
        }
        .card()
    }
    var weekLeft: String {
        let cal = Calendar(identifier: .iso8601)
        let dow = (cal.component(.weekday, from: Date()) + 5) % 7
        let left = 6 - dow
        return left == 0 ? "letzter Tag" : "noch \(left + 1) Tage"
    }
}

struct QuestRow: View {
    let q: Quest
    var color: Color = NT.teal
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: q.claimed || q.done ? "checkmark.circle.fill" : q.icon)
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(q.claimed || q.done ? NT.acc : color)
                .frame(width: 30, height: 30)
                .background(Circle().fill((q.done ? NT.acc : color).opacity(0.12)))
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(q.title).font(.system(size: 13, weight: .semibold)).foregroundStyle(q.claimed ? NT.tx2 : NT.tx).strikethrough(q.claimed, color: NT.tx3)
                    Spacer()
                    Text("+\(q.xp) XP").font(NT.mono(10, .bold)).foregroundStyle(q.claimed ? NT.tx3 : NT.acc)
                }
                HStack(spacing: 8) {
                    BarView(value: q.fraction, color: q.done ? NT.acc : color, height: 4)
                    Text("\(min(q.value, q.target))/\(q.target)").font(NT.mono(9)).foregroundStyle(NT.tx3).frame(minWidth: 44, alignment: .trailing)
                }
            }
        }
    }
}

// MARK: - Empfehlung

struct RecommendationCard: View {
    @Environment(Store.self) private var store
    @Binding var quiz: QuizConfig?
    var body: some View {
        let rec = store.recommendation
        switch rec {
        case .review(let n):
            RecTile(icon: "brain.head.profile", color: NT.orange, kicker: "EMPFOHLEN · JETZT WIEDERHOLEN", title: "\(n) Karten sind fällig", text: "Wiederholen, bevor du vergisst – fällige Karten geben +20 % XP.") {
                quiz = QuizConfig(mode: .training, title: "Wiederholung", questions: store.buildTraining(nil))
            }
        case .lesson(let m, let i):
            NavigationLink(value: LessonRef(module: m, index: i)) {
                RecTileBody(icon: m.icon, color: NT.acc, kicker: "EMPFOHLEN · WEITERLERNEN", title: Store.plain(m.lessons[i].title), text: "\(m.title) · Lektion \(i + 1)/\(m.lessons.count) · \(m.lessons[i].readMinutes) min")
            }
            .buttonStyle(.plain)
        case .weak(let n):
            RecTile(icon: "ladybug.fill", color: NT.red, kicker: "EMPFOHLEN · PROBLEMKARTEN", title: "\(n) Karten machen dir Ärger", text: "Gezielt üben – mit Erklärung und Lektion zum Nachlesen.") {
                quiz = QuizConfig(mode: .training, title: "Problemkarten", questions: Array(store.leeches.prefix(15)).shuffled())
            }
        case .vocab(let n):
            RecTile(icon: "textformat.abc", color: NT.blue, kicker: "EMPFOHLEN · FACHBEGRIFFE", title: "\(n) Begriffe sind fällig", text: "Fachsprache sitzt nur, wenn man sie wiederholt.") {
                quiz = QuizConfig(mode: .vocab, title: "Begriffe-Training", questions: store.buildVocab())
            }
        case .explore:
            RecTile(icon: "sparkles", color: NT.purple, kicker: "EMPFOHLEN", title: "Alles erledigt – Zeit für ein Survival?", text: "3 Leben, Fragen werden immer schwerer.") {
                quiz = QuizConfig(mode: .survival, title: "Survival", questions: store.buildSurvival(nil))
            }
        }
    }
}

struct RecTile: View {
    let icon: String
    let color: Color
    let kicker: String
    let title: String
    let text: String
    let action: () -> Void
    var body: some View {
        Button(action: action) { RecTileBody(icon: icon, color: color, kicker: kicker, title: title, text: text) }.buttonStyle(.plain)
    }
}

struct RecTileBody: View {
    let icon: String
    let color: Color
    let kicker: String
    let title: String
    let text: String
    var body: some View {
        HStack(spacing: 14) {
            IconTile(icon: icon, color: color, size: 50)
            VStack(alignment: .leading, spacing: 4) {
                Text(kicker).font(NT.mono(10, .bold)).tracking(1.2).foregroundStyle(color).lineLimit(1)
                Text(title).font(.system(size: 16, weight: .bold)).foregroundStyle(NT.tx).lineLimit(2).multilineTextAlignment(.leading)
                Text(text).font(.system(size: 12)).foregroundStyle(NT.tx2).lineLimit(2).multilineTextAlignment(.leading)
            }
            Spacer(minLength: 0)
            Image(systemName: "play.circle.fill").font(.system(size: 34)).foregroundStyle(color)
        }
        .card(glow: color)
    }
}

// MARK: - Onboarding

struct OnboardingView: View {
    @Environment(Store.self) private var store
    @State private var page = 0
    @State private var name = ""
    @State private var exp = "start"
    @State private var goal = 20
    @State private var path = "grundlagen"
    var body: some View {
        ZStack {
            AppBackground()
            VStack(spacing: 22) {
                HStack(spacing: 6) {
                    ForEach(0..<4, id: \.self) { i in Capsule().fill(i <= page ? NT.acc : Color.white.opacity(0.12)).frame(height: 4) }
                }
                .padding(.top, 20)
                Spacer(minLength: 0)
                Group {
                    switch page {
                    case 0: welcome
                    case 1: nameStep
                    case 2: experience
                    default: goalStep
                    }
                }
                .transition(.asymmetric(insertion: .move(edge: .trailing).combined(with: .opacity), removal: .move(edge: .leading).combined(with: .opacity)))
                Spacer(minLength: 0)
                Button {
                    if page < 3 { withAnimation(.spring) { page += 1 } } else { finish() }
                } label: { Text(page < 3 ? "Weiter" : "Los geht's") }
                    .buttonStyle(PrimaryButtonStyle())
                    .disabled(page == 1 && name.trimmingCharacters(in: .whitespaces).isEmpty)
            }
            .padding(24)
            .frame(maxWidth: 560)
        }
        .onAppear { name = store.progress.name == "Operator" ? "" : store.progress.name }
    }

    var welcome: some View {
        VStack(alignment: .leading, spacing: 16) {
            NimaLogo(size: 70)
            Text("Willkommen bei NIMA").font(.system(size: 32, weight: .black))
            Text("Deine Cyber Academy: vom ersten Bit bis zur Zertifikatsprüfung.").font(.system(size: 17)).foregroundStyle(NT.tx2)
            VStack(alignment: .leading, spacing: 10) {
                OnbPoint(icon: "stairs", text: "Jedes Thema startet **einfach erklärt** und geht Schritt für Schritt in die **Tiefe**.")
                OnbPoint(icon: "brain.head.profile", text: "**Spaced Repetition** holt jede Frage genau dann zurück, bevor du sie vergisst.")
                OnbPoint(icon: "text.quote", text: "Zu jeder Antwort: **Erklärung + Stelle in der Lektion** zum Nachlesen.")
                OnbPoint(icon: "trophy.fill", text: "XP-Ränge für Fleiß, **Skill-Ligen** für echtes Können, Missionen, Flags und Zertifikate.")
            }
        }
    }

    var nameStep: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Wie sollen wir dich nennen?").font(.system(size: 28, weight: .heavy))
            Text("Dein Hacker-Alias erscheint im Terminal und auf deinen Flags.").foregroundStyle(NT.tx2)
            TextField("z. B. Operator", text: $name)
                .font(NT.mono(22, .bold))
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .padding(16)
                .background(RoundedRectangle(cornerRadius: 14).fill(NT.panel))
                .overlay(RoundedRectangle(cornerRadius: 14).stroke(NT.acc.opacity(0.4), lineWidth: 1))
        }
    }

    var experience: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Wo startest du?").font(.system(size: 28, weight: .heavy))
            OnbChoice(title: "Einsteiger", text: "Ich will die Grundlagen von Netzwerken, Linux & Co. verstehen.", icon: "leaf.fill", active: exp == "start") { exp = "start"; path = "grundlagen" }
            OnbChoice(title: "Fortgeschritten", text: "Grundlagen sitzen – ich will Richtung Pentest oder SOC.", icon: "bolt.fill", active: exp == "mid") { exp = "mid"; path = "cjca" }
            OnbChoice(title: "Profi", text: "Ich bereite mich auf eine Zertifizierung wie CPTS oder CDSA vor.", icon: "flame.fill", active: exp == "pro") { exp = "pro"; path = "cpts" }
        }
    }

    var goalStep: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Dein Tagesziel").font(.system(size: 28, weight: .heavy))
            Text("Lieber jeden Tag ein bisschen als einmal viel – so funktioniert Langzeitgedächtnis.").foregroundStyle(NT.tx2)
            ForEach([(10, "Locker", "~5 min"), (20, "Normal", "~10 min"), (40, "Ehrgeizig", "~20 min"), (80, "Hardcore", "~40 min")], id: \.0) { g in
                OnbChoice(title: "\(g.1) · \(g.0) Punkte", text: g.2 + " pro Tag", icon: "target", active: goal == g.0) { goal = g.0 }
            }
            Picker("Startpfad", selection: $path) {
                ForEach(store.paths) { p in Text(p.title).tag(p.id) }
            }
            .pickerStyle(.menu)
        }
    }

    func finish() {
        let n = name.trimmingCharacters(in: .whitespaces)
        store.progress.name = n.isEmpty ? "Operator" : String(n.prefix(24))
        store.progress.experience = exp
        store.progress.dailyGoal = goal
        if store.progress.planPath.isEmpty { store.progress.planPath = path }
        if let p = store.pathIndex[path], let first = store.modules(of: p).first, let l = first.lessons.first {
            store.progress.lastLesson = l.id
        }
        store.progress.onboarded = true
        store.save()
        store.haptic(.success)
    }
}

struct OnbPoint: View {
    let icon: String
    let text: String
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon).foregroundStyle(NT.acc).frame(width: 24)
            MD(text: text, size: 15, color: NT.tx2)
        }
    }
}

struct OnbChoice: View {
    let title: String
    let text: String
    let icon: String
    let active: Bool
    let action: () -> Void
    var body: some View {
        Button(action: action) {
            HStack(spacing: 14) {
                IconTile(icon: icon, color: active ? NT.acc : NT.tx3, size: 42)
                VStack(alignment: .leading, spacing: 2) {
                    Text(title).font(.system(size: 16, weight: .bold)).foregroundStyle(NT.tx)
                    Text(text).font(.system(size: 12)).foregroundStyle(NT.tx2).multilineTextAlignment(.leading)
                }
                Spacer(minLength: 0)
                Image(systemName: active ? "checkmark.circle.fill" : "circle").foregroundStyle(active ? NT.acc : NT.tx3)
            }
            .card(padding: 14, glow: active ? NT.acc : nil)
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Zertifikate

struct CertificatesCard: View {
    @Environment(Store.self) private var store
    var body: some View {
        let certs = store.paths.filter { store.progress.pathCerts[$0.id] != nil }
        VStack(alignment: .leading, spacing: 10) {
            SectionHeader(title: "NIMA-Zertifikate", trailing: "\(certs.count)/\(store.paths.count)")
            if certs.isEmpty {
                Text("Bestehe eine Pfad-Prüfung (mind. 20 Fragen, ≥ 80 %) im Training oder auf der Pfadseite, um ein Zertifikat zu erhalten.")
                    .font(.system(size: 12)).foregroundStyle(NT.tx3)
            }
            ForEach(certs) { p in
                let c = Color(hex: p.color)
                HStack(spacing: 12) {
                    Image(systemName: "rosette").font(.system(size: 26)).foregroundStyle(c).shadow(color: c, radius: 6)
                    VStack(alignment: .leading, spacing: 2) {
                        Text(p.title).font(.system(size: 14, weight: .bold))
                        Text(Date(timeIntervalSince1970: store.progress.pathCerts[p.id] ?? 0).formatted(date: .long, time: .omitted)).font(NT.mono(10)).foregroundStyle(NT.tx3)
                        Text(store.flagHash(p.id, "cert")).font(NT.mono(9)).foregroundStyle(c).lineLimit(1).minimumScaleFactor(0.5).textSelection(.enabled)
                    }
                }
                .card(padding: 10, glow: c)
            }
        }
    }
}
