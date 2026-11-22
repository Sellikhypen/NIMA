import SwiftUI

struct HomeView: View {
    @Environment(Store.self) private var store
    @Binding var tab: Int
    @State private var quiz: QuizConfig?
    @State private var showSearch = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 18) {
                    HeroCard()
                    StreakCard()
                    RecommendationCard(quiz: $quiz)
                    PlanCard()
                    QuickActions(quiz: $quiz)
                    QuestsCard()
                    ContinueCard()
                    SectionHeader(title: "Zertifikate & Pfade", trailing: "\(store.paths.count) Pfade")
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(store.paths) { p in
                                NavigationLink(value: p) { PathMiniCard(path: p) }.buttonStyle(.plain)
                            }
                        }
                    }
                    TermOfTheDay()
                    LibraryStats()
                }
                .padding(16)
                .padding(.bottom, 30)
            }
            .background(AppBackground())
            .navigationTitle("")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    HStack(spacing: 8) {
                        NimaLogo(size: 24)
                        Text("NIMA").font(.system(size: 20, weight: .black, design: .monospaced))
                    }
                }
                ToolbarItemGroup(placement: .topBarTrailing) {
                    NavigationLink { ShopView() } label: {
                        HStack(spacing: 3) {
                            Image(systemName: "cube.fill").font(.system(size: 12))
                            Text("\(store.progress.coins)").font(NT.mono(12, .heavy))
                        }
                        .foregroundStyle(NT.gold)
                    }
                    Button { showSearch = true } label: { Image(systemName: "magnifyingglass") }
                }
            }
            .navigationDestination(for: LPath.self) { PathDetailView(path: $0) }
            .navigationDestination(for: Module.self) { ModuleView(module: $0) }
            .navigationDestination(for: LessonRef.self) { LessonPager(module: $0.module, start: $0.index) }
            .sheet(isPresented: $showSearch) { SearchView() }
            .fullScreenCover(item: $quiz) { QuizView(config: $0) }
        }
    }
}

struct LessonRef: Hashable, Identifiable {
    let module: Module
    let index: Int
    var id: String { module.id + "#\(index)" }
}

struct HeroCard: View {
    @Environment(Store.self) private var store
    var body: some View {
        let lp = store.levelProgress
        let r = store.rank
        VStack(alignment: .leading, spacing: 14) {
            HStack(spacing: 16) {
                RankBadge(index: store.rankIndex, size: 76)
                VStack(alignment: .leading, spacing: 4) {
                    Text(greeting.uppercased()).font(NT.mono(11)).tracking(2).foregroundStyle(NT.tx3)
                    Text(store.progress.name).font(.system(size: 26, weight: .heavy)).foregroundStyle(NT.tx).lineLimit(1)
                    Text("\(r.name) · Level \(store.level)").font(NT.mono(14, .bold)).foregroundStyle(Color(hex: r.color))
                }
                Spacer()
            }
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text("\(lp.cur) / \(lp.span) XP").font(NT.mono(11))
                    Spacer()
                    Text("Level \(store.level + 1)").font(NT.mono(11))
                }
                .foregroundStyle(NT.tx2)
                BarView(value: lp.pct, height: 9)
                if store.rankIndex + 1 < RANKS.count {
                    let nx = RANKS[store.rankIndex + 1]
                    HStack(spacing: 6) {
                        Text("Nächster Rang: \(nx.name) (Lvl \(nx.level))").font(NT.mono(11)).foregroundStyle(NT.tx3)
                        Spacer()
                        Text("\(Int(store.rankProgress.pct * 100)) %").font(NT.mono(11, .bold)).foregroundStyle(Color(hex: nx.color))
                    }
                    BarView(value: store.rankProgress.pct, color: Color(hex: nx.color), height: 4)
                }
                if store.boostActive {
                    Label("XP-Booster ×2 aktiv · noch \(store.boostMinutesLeft) min", systemImage: "bolt.badge.clock.fill").font(NT.mono(11, .bold)).foregroundStyle(NT.orange)
                }
            }
            HStack(spacing: 10) {
                StatChip(icon: "bolt.fill", value: "\(store.progress.xp)", label: "XP", color: NT.acc)
                StatChip(icon: skillTier(store.overallSkill).icon, value: "\(Int(store.overallSkill))", label: "Skill · " + skillTier(store.overallSkill).name, color: Color(hex: skillTier(store.overallSkill).color))
                StatChip(icon: "checkmark.seal.fill", value: "\(store.lessonsReadCount)", label: "Lektionen", color: NT.blue)
            }
        }
        .card(padding: 18, glow: Color(hex: r.color))
    }
    var greeting: String {
        let h = Calendar.current.component(.hour, from: Date())
        if h < 5 { return "Late Night Hacking" }
        if h < 11 { return "Guten Morgen" }
        if h < 18 { return "Willkommen zurück" }
        return "Guten Abend"
    }
}

struct StatChip: View {
    let icon: String
    let value: String
    let label: String
    let color: Color
    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            HStack(spacing: 4) {
                Image(systemName: icon).font(.system(size: 11))
                Text(value).font(NT.mono(15, .heavy))
            }
            .foregroundStyle(color)
            Text(label).font(NT.mono(10)).foregroundStyle(NT.tx3)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(10)
        .background(RoundedRectangle(cornerRadius: 12).fill(Color.white.opacity(0.04)))
    }
}

struct StreakCard: View {
    @Environment(Store.self) private var store
    var body: some View {
        let st = store.streakAlive
        let d = store.today
        let activity = d.activity
        HStack(spacing: 16) {
            Image(systemName: st > 0 ? "flame.fill" : "flame")
                .font(.system(size: 34))
                .foregroundStyle(st > 0 ? NT.orange : NT.tx3)
                .shadow(color: st > 0 ? NT.orange : .clear, radius: 10)
                .frame(width: 56, height: 56)
                .background(RoundedRectangle(cornerRadius: 16).fill(NT.orange.opacity(st > 0 ? 0.15 : 0.04)))
            VStack(alignment: .leading, spacing: 6) {
                HStack(alignment: .firstTextBaseline, spacing: 6) {
                    Text("\(st)").font(NT.mono(28, .heavy))
                    Text("Tage Streak").foregroundStyle(NT.tx2)
                    if store.progress.streakFreezes > 0 {
                        Label("\(store.progress.streakFreezes)", systemImage: "snowflake").font(NT.mono(11, .bold)).foregroundStyle(NT.blue)
                    }
                }
                WeekDots()
            }
            Spacer()
            ProgressRing(value: Double(activity) / Double(max(store.progress.dailyGoal, 1)), color: NT.orange, size: 64, line: 6, label: "\(activity)", sub: "/\(store.progress.dailyGoal)")
        }
        .card()
    }
}

struct WeekDots: View {
    @Environment(Store.self) private var store
    var body: some View {
        let cal = Calendar(identifier: .iso8601)
        let wd = cal.component(.weekday, from: Date())
        let dow = (wd + 5) % 7
        HStack(spacing: 5) {
            ForEach(0..<7, id: \.self) { i in
                let key = Store.dayKey(offset: i - dow)
                let d = store.progress.daily[key]
                let act = (d?.answered ?? 0) + (d?.lessons ?? 0) * 3
                let hit = act >= store.progress.dailyGoal
                VStack(spacing: 3) {
                    RoundedRectangle(cornerRadius: 6)
                        .fill(hit ? NT.orange : (act > 0 ? NT.orange.opacity(0.3) : Color.white.opacity(0.06)))
                        .frame(width: 22, height: 22)
                    Text(["Mo", "Di", "Mi", "Do", "Fr", "Sa", "So"][i]).font(NT.mono(9)).foregroundStyle(i == dow ? NT.tx : NT.tx3)
                }
            }
        }
    }
}

struct ContinueCard: View {
    @Environment(Store.self) private var store
    var body: some View {
        if let next = store.continueLesson {
            let m = next.0, i = next.1
            NavigationLink(value: LessonRef(module: m, index: i)) {
                HStack(spacing: 14) {
                    IconTile(icon: m.icon, size: 50)
                    VStack(alignment: .leading, spacing: 4) {
                        Text("WEITERLERNEN").font(NT.mono(10, .bold)).tracking(1.5).foregroundStyle(NT.acc)
                        Text(Store.plain(m.lessons[i].title)).font(.system(size: 16, weight: .bold)).foregroundStyle(NT.tx).lineLimit(2)
                        Text("\(m.title) · Lektion \(i + 1)/\(m.lessons.count)").font(.system(size: 12)).foregroundStyle(NT.tx2).lineLimit(1)
                        BarView(value: store.readFraction(m), height: 4)
                    }
                    Image(systemName: "play.circle.fill").font(.system(size: 34)).foregroundStyle(NT.acc)
                }
                .card(glow: NT.acc)
            }
            .buttonStyle(.plain)
        }
    }
}

struct QuickActions: View {
    @Environment(Store.self) private var store
    @Binding var quiz: QuizConfig?
    var body: some View {
        let due = store.totalDue
        let dailyDone = store.progress.dailyBoxDay == Store.dayKey()
        LazyVGrid(columns: [GridItem(.flexible(), spacing: 12), GridItem(.flexible(), spacing: 12)], spacing: 12) {
            QuickTile(icon: "scope", title: "Quick Hack", sub: due > 0 ? "\(due) fällig" : "Neue Fragen", color: NT.acc) {
                quiz = QuizConfig(mode: .training, title: "Quick Hack", questions: store.buildTraining(nil))
            }
            QuickTile(icon: "shippingbox.fill", title: "Daily Box", sub: dailyDone ? "Heute geknackt ✓" : "10 Fragen · Bonus", color: NT.orange) {
                quiz = QuizConfig(mode: .daily, title: "Daily Box", questions: store.buildDaily())
            }
            QuickTile(icon: "bolt.fill", title: "Blitz", sub: "60 s · Rekord \(store.progress.blitzBest)", color: NT.blue) {
                quiz = QuizConfig(mode: .blitz, title: "Blitz", questions: store.buildBlitz(nil))
            }
            QuickTile(icon: "rectangle.on.rectangle.angled", title: "Karteikarten", sub: "Aufdecken & bewerten", color: NT.purple) {
                quiz = QuizConfig(mode: .flashcards, title: "Karteikarten", questions: store.buildTraining(nil, size: 20))
            }
            QuickTile(icon: "textformat.abc", title: "Begriffe", sub: store.vocabDue > 0 ? "\(store.vocabDue) fällig" : "\(store.vocabMastered) gemeistert", color: NT.teal) {
                quiz = QuizConfig(mode: .vocab, title: "Begriffe-Training", questions: store.buildVocab())
            }
            QuickTile(icon: "heart.fill", title: "Survival", sub: "3 Leben · Rekord \(store.progress.survivalBest)", color: NT.red) {
                quiz = QuizConfig(mode: .survival, title: "Survival", questions: store.buildSurvival(nil))
            }
        }
    }
}

struct QuickTile: View {
    let icon: String
    let title: String
    let sub: String
    let color: Color
    let action: () -> Void
    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 8) {
                IconTile(icon: icon, color: color, size: 40)
                Text(title).font(.system(size: 15, weight: .bold)).foregroundStyle(NT.tx)
                Text(sub).font(.system(size: 12)).foregroundStyle(NT.tx2).lineLimit(1)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .card(padding: 14)
        }
        .buttonStyle(.plain)
    }
}

struct PathMiniCard: View {
    @Environment(Store.self) private var store
    let path: LPath
    var body: some View {
        let c = Color(hex: path.color)
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                IconTile(icon: path.icon, color: c, size: 38)
                Spacer()
                ProgressRing(value: store.pathProgress(path), color: c, size: 46, line: 5)
            }
            Text(path.title).font(.system(size: 15, weight: .heavy)).foregroundStyle(NT.tx).lineLimit(1)
            Text(path.subtitle).font(.system(size: 11)).foregroundStyle(NT.tx2).lineLimit(2).frame(height: 30, alignment: .top)
            Text("\(path.modules.count) Module").font(NT.mono(10)).foregroundStyle(NT.tx3)
        }
        .frame(width: 190)
        .card(padding: 14, glow: c)
    }
}

struct TermOfTheDay: View {
    @Environment(Store.self) private var store
    static func dayIndex(_ n: Int) -> Int {
        var gen = SeededGenerator(seed: "term" + Store.dayKey())
        return Int(gen.next() % UInt64(max(n, 1)))
    }
    var body: some View {
        let g = store.glossary
        if !g.isEmpty {
            let t = g[TermOfTheDay.dayIndex(g.count)]
            VStack(alignment: .leading, spacing: 8) {
                SectionHeader(title: "Begriff des Tages")
                Button { store.handle(url: URL(string: "nima://term/" + t.id)!) } label: {
                    HStack(alignment: .top, spacing: 12) {
                        IconTile(icon: "character.book.closed.fill", color: NT.blue, size: 40)
                        VStack(alignment: .leading, spacing: 4) {
                            Text(t.term).font(.system(size: 17, weight: .bold)).foregroundStyle(NT.tx)
                            Text(t.cat).font(NT.mono(10)).foregroundStyle(NT.blue)
                            Text(Store.plain(t.short)).font(.system(size: 13)).foregroundStyle(NT.tx2).multilineTextAlignment(.leading)
                        }
                        Spacer(minLength: 0)
                    }
                    .card()
                }
                .buttonStyle(.plain)
            }
        }
    }
}

struct LibraryStats: View {
    @Environment(Store.self) private var store
    var body: some View {
        if let s = store.content?.stats {
            VStack(alignment: .leading, spacing: 10) {
                SectionHeader(title: "Bibliothek")
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                    MiniStat(v: s.modules, l: "Module")
                    MiniStat(v: s.lessons, l: "Lektionen")
                    MiniStat(v: s.questions, l: "Fragen")
                    MiniStat(v: s.terms, l: "Begriffe")
                    MiniStat(v: s.words, l: "Wörter")
                    MiniStat(v: s.images, l: "Abbildungen")
                }
            }
        }
    }
}

struct MiniStat: View {
    let v: Int
    let l: String
    var body: some View {
        VStack(spacing: 2) {
            Text(v.formatted()).font(NT.mono(17, .heavy)).foregroundStyle(NT.acc)
            Text(l).font(NT.mono(10)).foregroundStyle(NT.tx3)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(RoundedRectangle(cornerRadius: 12).fill(NT.panel))
    }
}
