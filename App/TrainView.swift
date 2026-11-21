import SwiftUI
import Charts

struct TrainView: View {
    @Environment(Store.self) private var store
    @State private var scope = "all"
    @State private var quiz: QuizConfig?
    @State private var examCount = 40

    var scopeIds: [String]? {
        if scope == "all" { return nil }
        return store.pathIndex[scope]?.modules
    }
    var scopeTitle: String { scope == "all" ? "Alle Module" : (store.pathIndex[scope]?.title ?? "") }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    VStack(alignment: .leading, spacing: 10) {
                        SectionHeader(title: "Bereich")
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 8) {
                                ScopeChip(title: "Alle", active: scope == "all") { scope = "all" }
                                ForEach(store.paths) { p in
                                    ScopeChip(title: p.title, active: scope == p.id, color: Color(hex: p.color)) { scope = p.id }
                                }
                            }
                        }
                        let pool = store.pool(scopeIds)
                        let due = pool.filter { store.isDue($0) }.count
                        let seen = pool.filter { (store.card($0)?.seen ?? 0) > 0 }.count
                        HStack(spacing: 10) {
                            MiniResult(v: "\(pool.count)", l: "Fragen", c: NT.tx)
                            MiniResult(v: "\(seen)", l: "Gesehen", c: NT.blue)
                            MiniResult(v: "\(due)", l: "Fällig", c: NT.orange)
                        }
                    }

                    SectionHeader(title: "Modus")
                    ModeCard(icon: "scope", title: "Training", text: "Spaced Repetition: fällige und neue Karten zuerst. Falsche Antworten kommen in derselben Runde wieder.", color: NT.acc) {
                        quiz = QuizConfig(mode: .training, title: "Training · " + scopeTitle, questions: store.buildTraining(scopeIds))
                    }
                    ModeCard(icon: "rectangle.on.rectangle.angled", title: "Karteikarten", text: "Frage lesen, selbst überlegen, aufdecken, ehrlich bewerten. Ideal für neuen Stoff.", color: NT.purple) {
                        quiz = QuizConfig(mode: .flashcards, title: "Karteikarten · " + scopeTitle, questions: store.buildTraining(scopeIds, size: 25))
                    }
                    ModeCard(icon: "terminal.fill", title: "Terminal-Drill", text: "Nur Tipp-Fragen: Befehle, Pfade, Ports und Fachbegriffe exakt eintippen.", color: NT.teal) {
                        quiz = QuizConfig(mode: .training, title: "Terminal-Drill", questions: store.buildTraining(scopeIds, size: 15, onlyTyped: true))
                    }
                    ModeCard(icon: "bolt.fill", title: "Blitz", text: "60 Sekunden, so viele richtige Antworten wie möglich. Combo zählt!", color: NT.blue) {
                        quiz = QuizConfig(mode: .blitz, title: "Blitz · " + scopeTitle, questions: store.buildBlitz(scopeIds))
                    }
                    ModeCard(icon: "crosshair", title: "Schwachstellen", text: "Gezielt die Fragen, bei denen du am häufigsten falsch lagst.", color: NT.red) {
                        quiz = QuizConfig(mode: .training, title: "Schwachstellen", questions: store.buildWeak())
                    }
                    VStack(alignment: .leading, spacing: 12) {
                        HStack(spacing: 12) {
                            IconTile(icon: "checkmark.seal.fill", color: NT.gold, size: 44)
                            VStack(alignment: .leading, spacing: 3) {
                                Text("Prüfungssimulation").font(.system(size: 16, weight: .bold))
                                Text("Kein Feedback, Timer (75 s pro Frage), bestanden ab 80 %. Fragen gleichmäßig über alle Module des Bereichs verteilt.").font(.system(size: 12)).foregroundStyle(NT.tx2)
                            }
                        }
                        Picker("Fragen", selection: $examCount) {
                            ForEach([20, 40, 60, 100], id: \.self) { Text("\($0) Fragen").tag($0) }
                        }
                        .pickerStyle(.segmented)
                        Button {
                            let qs = store.buildExam(scopeIds, count: examCount)
                            quiz = QuizConfig(mode: .exam, title: "Prüfung · " + scopeTitle, questions: qs, timeLimit: qs.count * 75)
                        } label: { Label("Prüfung starten", systemImage: "play.fill") }
                            .buttonStyle(PrimaryButtonStyle(color: NT.gold))
                    }
                    .card(padding: 16, glow: NT.gold)

                    if !store.progress.exams.isEmpty {
                        SectionHeader(title: "Prüfungshistorie")
                        ForEach(store.progress.exams.suffix(10).reversed()) { e in
                            HStack {
                                Image(systemName: e.passed ? "checkmark.seal.fill" : "xmark.seal.fill").foregroundStyle(e.passed ? NT.acc : NT.red)
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(e.title).font(.system(size: 14, weight: .semibold)).lineLimit(1)
                                    Text(e.date.formatted(date: .abbreviated, time: .shortened)).font(NT.mono(10)).foregroundStyle(NT.tx3)
                                }
                                Spacer()
                                Text("\(Int(e.score * 100)) %").font(NT.mono(15, .heavy)).foregroundStyle(e.passed ? NT.acc : NT.red)
                            }
                            .card(padding: 12)
                        }
                    }
                }
                .padding(16)
            }
            .background(AppBackground())
            .navigationTitle("Training")
            .fullScreenCover(item: $quiz) { QuizView(config: $0) }
        }
    }
}

struct ScopeChip: View {
    let title: String
    let active: Bool
    var color: Color = NT.acc
    let action: () -> Void
    var body: some View {
        Button(action: action) {
            Text(title).font(NT.mono(12, .bold))
                .padding(.horizontal, 12).padding(.vertical, 8)
                .background(Capsule().fill(active ? color.opacity(0.18) : Color.white.opacity(0.05)))
                .overlay(Capsule().stroke(active ? color.opacity(0.6) : NT.line, lineWidth: 1))
                .foregroundStyle(active ? color : NT.tx2)
        }
        .buttonStyle(.plain)
    }
}

struct ModeCard: View {
    let icon: String
    let title: String
    let text: String
    let color: Color
    let action: () -> Void
    var body: some View {
        Button(action: action) {
            HStack(spacing: 14) {
                IconTile(icon: icon, color: color, size: 46)
                VStack(alignment: .leading, spacing: 3) {
                    Text(title).font(.system(size: 16, weight: .bold)).foregroundStyle(NT.tx)
                    Text(text).font(.system(size: 12)).foregroundStyle(NT.tx2).multilineTextAlignment(.leading)
                }
                Spacer(minLength: 0)
                Image(systemName: "play.circle.fill").font(.system(size: 28)).foregroundStyle(color)
            }
            .card(padding: 14)
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Profil

struct ProfileView: View {
    @Environment(Store.self) private var store
    @State private var confirmReset = false
    var body: some View {
        @Bindable var store = store
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    RankLadder()
                    StatsGrid()
                    ActivityChart()
                    SectionHeader(title: "Achievements", trailing: "\(store.progress.achievements.count)/\(ACHIEVEMENTS.count)")
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 104), spacing: 10)], spacing: 10) {
                        ForEach(ACHIEVEMENTS) { a in AchievementTile(a: a, got: store.progress.achievements[a.id] != nil) }
                    }
                    FlagsList()
                    SectionHeader(title: "Einstellungen")
                    VStack(spacing: 0) {
                        HStack {
                            Text("Name")
                            Spacer()
                            TextField("Operator", text: $store.progress.name)
                                .multilineTextAlignment(.trailing)
                                .foregroundStyle(NT.acc)
                                .onSubmit { store.save() }
                        }
                        .padding(.vertical, 10)
                        Divider().overlay(NT.line)
                        Stepper(value: $store.progress.dailyGoal, in: 5...200, step: 5) {
                            HStack { Text("Tagesziel"); Spacer(); Text("\(store.progress.dailyGoal) Punkte").foregroundStyle(NT.tx2) }
                        }
                        .padding(.vertical, 10)
                        .onChange(of: store.progress.dailyGoal) { _, _ in store.save() }
                        Divider().overlay(NT.line)
                        Toggle("Haptisches Feedback", isOn: $store.progress.haptics)
                            .padding(.vertical, 10)
                            .onChange(of: store.progress.haptics) { _, _ in store.save() }
                        Divider().overlay(NT.line)
                        Button(role: .destructive) { confirmReset = true } label: {
                            HStack { Text("Fortschritt zurücksetzen"); Spacer(); Image(systemName: "trash") }
                        }
                        .padding(.vertical, 10)
                    }
                    .card(padding: 14)
                    Text("Tagesziel: 1 Punkt pro beantworteter Frage, 3 Punkte pro gelesener Lektion.").font(.footnote).foregroundStyle(NT.tx3)
                    if let c = store.content {
                        Text("Inhalte \(c.version) · \(c.stats.modules) Module · \(c.stats.lessons) Lektionen · \(c.stats.questions) Fragen · \(c.stats.terms) Begriffe")
                            .font(NT.mono(10)).foregroundStyle(NT.tx3)
                    }
                }
                .padding(16)
            }
            .background(AppBackground())
            .navigationTitle("Profil")
            .confirmationDialog("Wirklich alles zurücksetzen?", isPresented: $confirmReset, titleVisibility: .visible) {
                Button("Zurücksetzen", role: .destructive) { store.resetProgress() }
            } message: { Text("XP, Level, Statistiken, Achievements und Lernkartei werden gelöscht.") }
        }
    }
}

struct RankLadder: View {
    @Environment(Store.self) private var store
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 16) {
                RankBadge(index: store.rankIndex, size: 70)
                VStack(alignment: .leading, spacing: 4) {
                    Text(store.progress.name).font(.system(size: 22, weight: .heavy))
                    Text("\(store.rank.name) · Level \(store.level)").font(NT.mono(13, .bold)).foregroundStyle(Color(hex: store.rank.color))
                    Text("\(store.progress.xp) XP gesamt").font(NT.mono(11)).foregroundStyle(NT.tx3)
                }
            }
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .bottom, spacing: 14) {
                    ForEach(Array(RANKS.enumerated()), id: \.offset) { i, r in
                        VStack(spacing: 4) {
                            RankBadge(index: i, size: i == store.rankIndex ? 50 : 38)
                                .saturation(i <= store.rankIndex ? 1 : 0)
                                .opacity(i <= store.rankIndex ? 1 : 0.4)
                            Text(r.name).font(NT.mono(9, .bold)).foregroundStyle(i <= store.rankIndex ? Color(hex: r.color) : NT.tx3)
                            Text("Lvl \(r.level)").font(NT.mono(8)).foregroundStyle(NT.tx3)
                        }
                    }
                }
                .padding(.vertical, 4)
            }
        }
        .card(padding: 16, glow: Color(hex: store.rank.color))
    }
}

struct StatsGrid: View {
    @Environment(Store.self) private var store
    var body: some View {
        let p = store.progress
        let acc = p.totalAnswered > 0 ? Double(p.totalCorrect) / Double(p.totalAnswered) : 0
        let secs = p.daily.values.reduce(0) { $0 + $1.seconds }
        LazyVGrid(columns: [GridItem(.flexible(), spacing: 10), GridItem(.flexible(), spacing: 10)], spacing: 10) {
            KPI(icon: "doc.text.fill", title: "Lektionen", value: "\(store.lessonsReadCount)", sub: "gelesen", color: NT.blue)
            KPI(icon: "target", title: "Trefferquote", value: "\(Int(acc * 100)) %", sub: "\(p.totalCorrect)/\(p.totalAnswered)", color: NT.acc)
            KPI(icon: "brain", title: "Gemeistert", value: "\(store.masteredCount)", sub: "Karten Box ≥ 4", color: NT.purple)
            KPI(icon: "flame.fill", title: "Beste Streak", value: "\(p.bestStreak)", sub: "aktuell \(store.streakAlive)", color: NT.orange)
            KPI(icon: "bolt.fill", title: "Max Combo", value: "\(p.maxCombo)", sub: "Blitz \(p.blitzBest)", color: NT.gold)
            KPI(icon: "clock.fill", title: "Quizzeit", value: "\(secs / 3600)h \(secs % 3600 / 60)m", sub: "\(p.daily.count) aktive Tage", color: NT.teal)
            KPI(icon: "crown.fill", title: "Module owned", value: "\(store.ownedModules)", sub: "Root-Flags", color: NT.red)
            KPI(icon: "character.book.closed.fill", title: "Begriffe", value: "\(p.termsViewed.count)", sub: "nachgeschlagen", color: NT.blue)
        }
    }
}

struct KPI: View {
    let icon: String
    let title: String
    let value: String
    let sub: String
    let color: Color
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Label(title.uppercased(), systemImage: icon).font(NT.mono(10, .bold)).foregroundStyle(NT.tx3)
            Text(value).font(NT.mono(24, .heavy)).foregroundStyle(color).lineLimit(1).minimumScaleFactor(0.6)
            Text(sub).font(.system(size: 11)).foregroundStyle(NT.tx2)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .card(padding: 14)
    }
}

struct DayPoint: Identifiable {
    let id: String
    let label: String
    let answered: Int
    let correct: Int
    let lessons: Int
}

struct ActivityChart: View {
    @Environment(Store.self) private var store
    var body: some View {
        let pts: [DayPoint] = (0..<14).reversed().map { i in
            let k = Store.dayKey(offset: -i)
            let d = store.progress.daily[k] ?? DayStat()
            return DayPoint(id: k, label: String(k.suffix(2)), answered: d.answered, correct: d.correct, lessons: d.lessons)
        }
        VStack(alignment: .leading, spacing: 10) {
            SectionHeader(title: "Aktivität · 14 Tage")
            Chart {
                ForEach(pts) { p in
                    BarMark(x: .value("Tag", p.label), y: .value("Antworten", p.answered))
                        .foregroundStyle(Color.white.opacity(0.15))
                    BarMark(x: .value("Tag", p.label), y: .value("Richtig", p.correct))
                        .foregroundStyle(NT.acc)
                    LineMark(x: .value("Tag", p.label), y: .value("Lektionen", p.lessons * 3))
                        .foregroundStyle(NT.blue)
                        .interpolationMethod(.catmullRom)
                }
            }
            .chartLegend(.hidden)
            .frame(height: 170)
            HStack(spacing: 14) {
                Label("richtig", systemImage: "square.fill").foregroundStyle(NT.acc)
                Label("beantwortet", systemImage: "square.fill").foregroundStyle(Color.white.opacity(0.3))
                Label("Lektionen ×3", systemImage: "line.diagonal").foregroundStyle(NT.blue)
            }
            .font(NT.mono(10))
        }
        .card(padding: 14)
    }
}

struct AchievementTile: View {
    let a: Achievement
    let got: Bool
    var body: some View {
        let c = Color(hex: a.color)
        VStack(spacing: 6) {
            Image(systemName: got ? a.icon : "lock.fill")
                .font(.system(size: 24))
                .foregroundStyle(got ? c : NT.tx3)
                .frame(width: 50, height: 50)
                .background(Circle().fill(got ? c.opacity(0.15) : Color.white.opacity(0.04)))
                .shadow(color: got ? c.opacity(0.6) : .clear, radius: 8)
            Text(a.name).font(.system(size: 12, weight: .bold)).foregroundStyle(got ? NT.tx : NT.tx3).multilineTextAlignment(.center).lineLimit(2)
            Text(a.desc).font(.system(size: 10)).foregroundStyle(NT.tx3).multilineTextAlignment(.center).lineLimit(2)
        }
        .frame(maxWidth: .infinity, minHeight: 128)
        .card(padding: 10)
        .opacity(got ? 1 : 0.7)
    }
}

struct FlagsList: View {
    @Environment(Store.self) private var store
    var body: some View {
        let flags = store.progress.flags.sorted { $0.value > $1.value }.prefix(30)
        if !flags.isEmpty {
            VStack(alignment: .leading, spacing: 8) {
                SectionHeader(title: "Flag-Sammlung", trailing: "\(store.progress.flags.count)")
                ForEach(Array(flags), id: \.key) { k, _ in
                    let parts = k.split(separator: ":").map(String.init)
                    let mid = parts.first ?? ""
                    let kind = parts.last ?? ""
                    HStack(spacing: 10) {
                        Image(systemName: kind == "root" ? "crown.fill" : "flag.fill").foregroundStyle(kind == "root" ? NT.red : NT.acc)
                        VStack(alignment: .leading, spacing: 2) {
                            Text(store.moduleIndex[mid]?.title ?? mid).font(.system(size: 13, weight: .semibold)).lineLimit(1)
                            Text(store.flagHash(mid, kind)).font(NT.mono(10)).foregroundStyle(kind == "root" ? NT.red : NT.acc).textSelection(.enabled).lineLimit(1).minimumScaleFactor(0.6)
                        }
                    }
                    .card(padding: 10)
                }
            }
        }
    }
}
