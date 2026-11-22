import SwiftUI
import Charts

struct TrainView: View {
    @Environment(Store.self) private var store
    @State private var scope = "all"
    @State private var quiz: QuizConfig?
    @State private var examCount = 40
    @State private var vocabCat = "Alle"

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
                        let mastered = pool.filter { store.card($0)?.mastered ?? false }.count
                        HStack(spacing: 8) {
                            MiniResult(v: "\(pool.count)", l: "Fragen", c: NT.tx)
                            MiniResult(v: "\(seen)", l: "Gesehen", c: NT.blue)
                            MiniResult(v: "\(mastered)", l: "Gemeistert", c: NT.gold)
                            MiniResult(v: "\(due)", l: "Fällig", c: NT.orange)
                        }
                        if scope != "all" {
                            let r = store.skillRating(scope)
                            HStack(spacing: 10) {
                                SkillBadge(rating: r, size: 30)
                                Text("Skill in diesem Pfad: \(skillTier(r).name) · \(Int(r))").font(NT.mono(12, .bold)).foregroundStyle(Color(hex: skillTier(r).color))
                                Spacer()
                            }
                        }
                    }

                    SectionHeader(title: "Lernen")
                    ModeCard(icon: "scope", title: "Training", text: "Spaced Repetition: fällige Karten zuerst, neue Fragen von leicht nach schwer. Falsche Antworten kommen in derselben Runde wieder.", color: NT.acc) {
                        quiz = QuizConfig(mode: .training, title: "Training · " + scopeTitle, questions: store.buildTraining(scopeIds))
                    }
                    ModeCard(icon: "rectangle.on.rectangle.angled", title: "Karteikarten", text: "Aufdecken und ehrlich bewerten: Nochmal · Schwer · Gut · Leicht – die Bewertung steuert den nächsten Termin.", color: NT.purple) {
                        quiz = QuizConfig(mode: .flashcards, title: "Karteikarten · " + scopeTitle, questions: store.buildTraining(scopeIds, size: 25))
                    }
                    ModeCard(icon: "terminal.fill", title: "Terminal-Drill", text: "Nur Tipp-Fragen: Befehle, Pfade, Ports und Fachbegriffe exakt eintippen.", color: NT.teal) {
                        quiz = QuizConfig(mode: .training, title: "Terminal-Drill", questions: store.buildTraining(scopeIds, onlyTyped: true))
                    }
                    HStack(spacing: 10) {
                        ForEach(["easy", "medium", "hard", "insane"], id: \.self) { d in
                            Button { quiz = QuizConfig(mode: .training, title: NT.diffLabel(d) + " · " + scopeTitle, questions: store.buildTraining(scopeIds, difficulty: d)) } label: {
                                VStack(spacing: 3) {
                                    Text(NT.diffLabel(d)).font(NT.mono(12, .heavy))
                                    Text("nur").font(NT.mono(9)).opacity(0.7)
                                }
                                .foregroundStyle(NT.diff(d))
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 10)
                                .background(RoundedRectangle(cornerRadius: 12).fill(NT.diff(d).opacity(0.1)))
                                .overlay(RoundedRectangle(cornerRadius: 12).stroke(NT.diff(d).opacity(0.4), lineWidth: 1))
                            }
                            .buttonStyle(.plain)
                        }
                    }

                    SectionHeader(title: "Fachbegriffe", trailing: "\(store.vocabMastered)/\(store.vocabTerms.count) gemeistert")
                    VStack(alignment: .leading, spacing: 10) {
                        HStack(spacing: 14) {
                            IconTile(icon: "textformat.abc", color: NT.blue, size: 46)
                            VStack(alignment: .leading, spacing: 3) {
                                Text("Begriffe-Training").font(.system(size: 16, weight: .bold))
                                Text("Aus dem Lexikon generiert: Definition erkennen, Begriff zuordnen, Begriff eintippen – mit eigener Lernkartei.").font(.system(size: 12)).foregroundStyle(NT.tx2)
                            }
                        }
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 6) {
                                ForEach(["Alle", "Gemerkt"] + vocabCats, id: \.self) { c in
                                    ScopeChip(title: c, active: vocabCat == c, color: NT.blue) { vocabCat = c }
                                }
                            }
                        }
                        Button {
                            let qs = store.buildVocab(category: vocabCat == "Alle" || vocabCat == "Gemerkt" ? nil : vocabCat, onlyBookmarks: vocabCat == "Gemerkt")
                            quiz = QuizConfig(mode: .vocab, title: "Begriffe · " + vocabCat, questions: qs)
                        } label: { Label(store.vocabDue > 0 ? "Starten · \(store.vocabDue) fällig" : "Starten", systemImage: "play.fill") }
                            .buttonStyle(PrimaryButtonStyle(color: NT.blue))
                    }
                    .card(padding: 14, glow: NT.blue)

                    SectionHeader(title: "Herausforderung")
                    ModeCard(icon: "bolt.fill", title: "Blitz", text: "60 Sekunden, so viele richtige Antworten wie möglich. Rekord: \(store.progress.blitzBest)", color: NT.blue) {
                        quiz = QuizConfig(mode: .blitz, title: "Blitz · " + scopeTitle, questions: store.buildBlitz(scopeIds))
                    }
                    ModeCard(icon: "heart.fill", title: "Survival", text: "3 Leben. Die Fragen werden immer schwerer – wie weit kommst du? Rekord: \(store.progress.survivalBest)", color: NT.red) {
                        quiz = QuizConfig(mode: .survival, title: "Survival · " + scopeTitle, questions: store.buildSurvival(scopeIds))
                    }
                    ModeCard(icon: "shippingbox.fill", title: "Daily Box", text: "10 Fragen des Tages – für alle gleich. Bonus: +100 XP.", color: NT.orange) {
                        quiz = QuizConfig(mode: .daily, title: "Daily Box", questions: store.buildDaily())
                    }

                    SectionHeader(title: "Schwächen")
                    NavigationLink { MistakesView() } label: {
                        HStack(spacing: 14) {
                            IconTile(icon: "crosshair", color: NT.red, size: 46)
                            VStack(alignment: .leading, spacing: 3) {
                                Text("Fehlerbuch").font(.system(size: 16, weight: .bold)).foregroundStyle(NT.tx)
                                Text("\(store.weakQuestions.count) Fragen mit Fehlern · \(store.leeches.count) Problemkarten – mit Erklärung und Link zur Lektion.").font(.system(size: 12)).foregroundStyle(NT.tx2).multilineTextAlignment(.leading)
                            }
                            Spacer(minLength: 0)
                            Image(systemName: "chevron.right").foregroundStyle(NT.tx3)
                        }
                        .card(padding: 14)
                    }
                    .buttonStyle(.plain)

                    VStack(alignment: .leading, spacing: 12) {
                        HStack(spacing: 12) {
                            IconTile(icon: "checkmark.seal.fill", color: NT.gold, size: 44)
                            VStack(alignment: .leading, spacing: 3) {
                                Text("Prüfungssimulation").font(.system(size: 16, weight: .bold))
                                Text("Kein Feedback, Timer (\(store.prefs.examSeconds) s pro Frage), bestanden ab \(Int(store.prefs.examPass * 100)) %. Eine Pfad-Prüfung mit ≥ 20 Fragen und ≥ 80 % bringt ein NIMA-Zertifikat.").font(.system(size: 12)).foregroundStyle(NT.tx2)
                            }
                        }
                        Picker("Fragen", selection: $examCount) {
                            ForEach([20, 40, 60, 100], id: \.self) { Text("\($0) Fragen").tag($0) }
                        }
                        .pickerStyle(.segmented)
                        Button {
                            let qs = store.buildExam(scopeIds, count: examCount)
                            quiz = QuizConfig(mode: .exam, title: "Prüfung · " + scopeTitle, questions: qs, timeLimit: qs.count * store.prefs.examSeconds, pathId: scope == "all" ? nil : scope)
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
            .navigationDestination(for: LessonRef.self) { LessonPager(module: $0.module, start: $0.index) }
            .navigationDestination(for: Module.self) { ModuleView(module: $0) }
            .fullScreenCover(item: $quiz) { QuizView(config: $0) }
        }
    }

    var vocabCats: [String] {
        let counts = Dictionary(grouping: store.vocabTerms, by: { $0.cat }).mapValues { $0.count }
        return counts.keys.filter { counts[$0, default: 0] >= 8 }.sorted { counts[$0, default: 0] > counts[$1, default: 0] }
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
    @State private var achFilter = 0
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    RankLadder()
                    LazyVGrid(columns: [GridItem(.flexible(), spacing: 10), GridItem(.flexible(), spacing: 10)], spacing: 10) {
                        ProfileLink(icon: "chart.bar.xaxis", title: "Statistik", sub: "Skill, Kalender, Prognose", color: NT.blue) { StatsView() }
                        ProfileLink(icon: "cart.fill", title: "Shop", sub: "\(store.progress.coins) Credits", color: NT.gold) { ShopView() }
                        ProfileLink(icon: "note.text", title: "Notizen", sub: "\(store.progress.notes.count) Notizen · \(store.progress.lessonMarks.count) Lesezeichen", color: NT.orange) { NotesView() }
                        ProfileLink(icon: "crosshair", title: "Fehlerbuch", sub: "\(store.weakQuestions.count) Fragen", color: NT.red) { MistakesView() }
                        ProfileLink(icon: "calendar.badge.clock", title: "Lernplan", sub: store.planStatus.map { $0.path.title } ?? "nicht gesetzt", color: NT.teal) { PlanEditorPage() }
                        ProfileLink(icon: "gearshape.fill", title: "Einstellungen", sub: "Lernen, Quiz, Darstellung", color: NT.tx2) { SettingsView() }
                    }
                    StatsGrid()
                    ActivityChart()
                    CertificatesCard()
                    let got = store.progress.achievements.count
                    SectionHeader(title: "Achievements", trailing: "\(got)/\(ACHIEVEMENTS.count)")
                    Picker("", selection: $achFilter) {
                        Text("Alle").tag(0)
                        Text("Erreicht").tag(1)
                        Text("Offen").tag(2)
                    }
                    .pickerStyle(.segmented)
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 104), spacing: 10)], spacing: 10) {
                        ForEach(ACHIEVEMENTS.filter { a in
                            let has = store.progress.achievements[a.id] != nil
                            return achFilter == 0 || (achFilter == 1 && has) || (achFilter == 2 && !has)
                        }) { a in AchievementTile(a: a, got: store.progress.achievements[a.id] != nil) }
                    }
                    FlagsList()
                }
                .padding(16)
            }
            .background(AppBackground())
            .navigationTitle("Profil")
            .navigationDestination(for: LessonRef.self) { LessonPager(module: $0.module, start: $0.index) }
            .navigationDestination(for: Module.self) { ModuleView(module: $0) }
        }
    }
}

/// Lernplan als eigene Seite im Profil (PlanEditor ist ein Sheet mit eigenem Stack)
struct PlanEditorPage: View {
    @State private var show = true
    var body: some View {
        VStack(spacing: 16) {
            PlanCard()
            Text("Tippe auf die Karte, um Ziel und Termin zu ändern.").font(.footnote).foregroundStyle(NT.tx3)
            Spacer()
        }
        .padding(16)
        .background(AppBackground())
        .navigationTitle("Lernplan")
    }
}

struct ProfileLink<Dest: View>: View {
    let icon: String
    let title: String
    let sub: String
    let color: Color
    @ViewBuilder let dest: () -> Dest
    var body: some View {
        NavigationLink { dest() } label: {
            VStack(alignment: .leading, spacing: 6) {
                IconTile(icon: icon, color: color, size: 36)
                Text(title).font(.system(size: 14, weight: .bold)).foregroundStyle(NT.tx)
                Text(sub).font(.system(size: 11)).foregroundStyle(NT.tx2).lineLimit(1)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .card(padding: 12)
        }
        .buttonStyle(.plain)
    }
}

struct RankLadder: View {
    @Environment(Store.self) private var store
    var body: some View {
        let r = store.overallSkill
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 16) {
                RankBadge(index: store.rankIndex, size: 70)
                VStack(alignment: .leading, spacing: 4) {
                    Text(store.progress.name).font(.system(size: 22, weight: .heavy))
                    Text("\(store.rank.name) · Level \(store.level)").font(NT.mono(13, .bold)).foregroundStyle(Color(hex: store.rank.color))
                    Text(store.rank.motto).font(.system(size: 12)).foregroundStyle(NT.tx2)
                    Text("\(store.progress.xp) XP gesamt").font(NT.mono(11)).foregroundStyle(NT.tx3)
                }
                Spacer(minLength: 0)
                VStack(spacing: 4) {
                    SkillBadge(rating: r, size: 44)
                    Text(skillTier(r).name).font(NT.mono(9, .bold)).foregroundStyle(Color(hex: skillTier(r).color))
                    Text("\(Int(r))").font(NT.mono(9)).foregroundStyle(NT.tx3)
                }
            }
            if store.rankIndex + 1 < RANKS.count {
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text("Bis \(RANKS[store.rankIndex + 1].name)").font(NT.mono(10)).foregroundStyle(NT.tx3)
                        Spacer()
                        Text("noch \(store.rankProgress.missing) XP").font(NT.mono(10, .bold)).foregroundStyle(NT.tx2)
                    }
                    BarView(value: store.rankProgress.pct, color: Color(hex: RANKS[store.rankIndex + 1].color), height: 5)
                }
            }
            ScrollViewReader { proxy in
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
                            .id(i)
                        }
                    }
                    .padding(.vertical, 4)
                }
                .onAppear { proxy.scrollTo(store.rankIndex, anchor: .center) }
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
        let secs = p.daily.values.reduce(0) { $0 + $1.seconds + $1.readSeconds }
        LazyVGrid(columns: [GridItem(.flexible(), spacing: 10), GridItem(.flexible(), spacing: 10)], spacing: 10) {
            KPI(icon: "doc.text.fill", title: "Lektionen", value: "\(store.lessonsReadCount)", sub: "gelesen", color: NT.blue)
            KPI(icon: "target", title: "Trefferquote", value: "\(Int(acc * 100)) %", sub: "\(p.totalCorrect)/\(p.totalAnswered)", color: NT.acc)
            KPI(icon: "brain", title: "Gemeistert", value: "\(store.masteredCount)", sub: "Fragen · \(store.vocabMastered) Begriffe", color: NT.purple)
            KPI(icon: "flame.fill", title: "Beste Streak", value: "\(p.bestStreak)", sub: "aktuell \(store.streakAlive) · ❄️ \(p.streakFreezes)", color: NT.orange)
            KPI(icon: "bolt.fill", title: "Max Combo", value: "\(p.maxCombo)", sub: "Blitz \(p.blitzBest) · Survival \(p.survivalBest)", color: NT.gold)
            KPI(icon: "clock.fill", title: "Lernzeit", value: "\(secs / 3600)h \(secs % 3600 / 60)m", sub: "\(store.activeDays) aktive Tage", color: NT.teal)
            KPI(icon: "crown.fill", title: "Module owned", value: "\(store.ownedModules)", sub: "Root-Flags", color: NT.red)
            KPI(icon: "checklist.checked", title: "Wissens-Checks", value: "\(p.checksPassed)", sub: "fehlerfrei", color: NT.teal)
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
            Text(sub).font(.system(size: 11)).foregroundStyle(NT.tx2).lineLimit(1).minimumScaleFactor(0.8)
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
