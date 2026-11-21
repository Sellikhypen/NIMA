import SwiftUI

struct PathsView: View {
    @Environment(Store.self) private var store
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 14) {
                    Text("Wähle deinen Pfad. Zertifikatspfade folgen dem Aufbau der HTB Academy, ergänzt um Spezialpfade und deine Cyber Range.")
                        .font(.system(size: 14)).foregroundStyle(NT.tx2)
                    ForEach(groups, id: \.0) { g in
                        SectionHeader(title: g.0)
                        ForEach(g.1) { p in
                            NavigationLink(value: p) { PathCard(path: p) }.buttonStyle(.plain)
                        }
                    }
                }
                .padding(16)
            }
            .background(AppBackground())
            .navigationTitle("Lernpfade")
            .navigationDestination(for: LPath.self) { PathDetailView(path: $0) }
            .navigationDestination(for: Module.self) { ModuleView(module: $0) }
            .navigationDestination(for: LessonRef.self) { LessonPager(module: $0.module, start: $0.index) }
        }
    }

    var groups: [(String, [LPath])] {
        let ps = store.paths
        return [
            ("Fundament", ps.filter { $0.kind == "foundation" }),
            ("HTB-Zertifikate", ps.filter { $0.kind == "cert" }),
            ("Spezialisierungen", ps.filter { $0.kind == "special" }),
            ("Deine Cyber Range", ps.filter { $0.kind == "range" }),
        ].filter { !$0.1.isEmpty }
    }
}

struct PathCard: View {
    @Environment(Store.self) private var store
    let path: LPath
    var body: some View {
        let c = Color(hex: path.color)
        let mods = store.modules(of: path)
        let done = mods.filter { store.flagState($0).root }.count
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 14) {
                IconTile(icon: path.icon, color: c, size: 52)
                VStack(alignment: .leading, spacing: 3) {
                    HStack(spacing: 6) {
                        Text(path.title).font(.system(size: 18, weight: .heavy)).foregroundStyle(NT.tx)
                        if !path.cert.isEmpty { Pill(text: path.cert, color: c) }
                    }
                    Text(path.subtitle).font(.system(size: 12)).foregroundStyle(NT.tx2).lineLimit(2)
                }
                Spacer(minLength: 0)
                ProgressRing(value: store.pathProgress(path), color: c, size: 56, line: 6)
            }
            HStack(spacing: 3) {
                ForEach(mods) { m in
                    let p = store.moduleProgress(m)
                    RoundedRectangle(cornerRadius: 2)
                        .fill(store.flagState(m).root ? c : (p > 0 ? c.opacity(0.4) : Color.white.opacity(0.08)))
                        .frame(height: 6)
                }
            }
            HStack {
                Label("\(mods.count) Module", systemImage: "square.stack.3d.up").font(NT.mono(11))
                Spacer()
                Label("\(done) owned", systemImage: "crown").font(NT.mono(11))
                Spacer()
                Label("\(mods.reduce(0) { $0 + $1.minutes } / 60) h", systemImage: "clock").font(NT.mono(11))
            }
            .foregroundStyle(NT.tx3)
        }
        .card(padding: 16, glow: c)
    }
}

struct PathDetailView: View {
    @Environment(Store.self) private var store
    let path: LPath
    @State private var quiz: QuizConfig?
    var body: some View {
        let c = Color(hex: path.color)
        let mods = store.modules(of: path)
        let ids = mods.map { $0.id }
        let qCount = mods.reduce(0) { $0 + $1.quiz.count }
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                VStack(alignment: .leading, spacing: 12) {
                    HStack(spacing: 14) {
                        IconTile(icon: path.icon, color: c, size: 60)
                        VStack(alignment: .leading, spacing: 4) {
                            Text(path.title).font(.system(size: 24, weight: .heavy))
                            Text(path.subtitle).font(.system(size: 13)).foregroundStyle(NT.tx2)
                        }
                        Spacer()
                        ProgressRing(value: store.pathProgress(path), color: c, size: 70, line: 7, sub: "PFAD")
                    }
                    Text(path.description).font(.system(size: 14)).foregroundStyle(NT.tx2).fixedSize(horizontal: false, vertical: true)
                    if let n = store.nextLesson(in: path) {
                        NavigationLink(value: LessonRef(module: n.0, index: n.1)) {
                            Label("Weiter: \(Store.plain(n.0.lessons[n.1].title))", systemImage: "play.fill").lineLimit(1)
                        }
                        .buttonStyle(PrimaryButtonStyle(color: c))
                    }
                    HStack(spacing: 10) {
                        Button { quiz = QuizConfig(mode: .training, title: path.title, questions: store.buildTraining(ids)) } label: { Label("Training", systemImage: "scope") }
                            .buttonStyle(GhostButtonStyle())
                        Button { quiz = QuizConfig(mode: .exam, title: path.title + " · Prüfung", questions: store.buildExam(ids, count: 40), timeLimit: 40 * 75) } label: { Label("Prüfung", systemImage: "checkmark.seal") }
                            .buttonStyle(GhostButtonStyle())
                    }
                    .disabled(qCount == 0)
                }
                .card(padding: 18, glow: c)

                SectionHeader(title: "Module", trailing: "\(mods.count) · \(qCount) Fragen")
                ForEach(Array(mods.enumerated()), id: \.element.id) { i, m in
                    NavigationLink(value: m) { ModuleRow(module: m, number: i + 1, color: c) }.buttonStyle(.plain)
                }
            }
            .padding(16)
        }
        .background(AppBackground())
        .navigationTitle(path.title)
        .navigationBarTitleDisplayMode(.inline)
        .fullScreenCover(item: $quiz) { QuizView(config: $0) }
    }
}

struct ModuleRow: View {
    @Environment(Store.self) private var store
    let module: Module
    let number: Int
    let color: Color
    var body: some View {
        let p = store.moduleProgress(module)
        let f = store.flagState(module)
        HStack(spacing: 14) {
            ZStack {
                Circle().stroke(f.root ? color : Color.white.opacity(0.2), lineWidth: 2)
                if f.root {
                    Circle().fill(color)
                    Image(systemName: "checkmark").font(.system(size: 13, weight: .heavy)).foregroundStyle(.black)
                } else {
                    Text("\(number)").font(NT.mono(13, .heavy)).foregroundStyle(p > 0 ? NT.tx : NT.tx3)
                }
            }
            .frame(width: 34, height: 34)
            VStack(alignment: .leading, spacing: 5) {
                Text(module.title).font(.system(size: 15, weight: .bold)).foregroundStyle(NT.tx).multilineTextAlignment(.leading)
                HStack(spacing: 8) {
                    Pill(text: NT.diffLabel(module.difficulty), color: NT.diff(module.difficulty))
                    Text("\(module.lessons.count) Lekt. · \(module.quiz.count) Fragen · \(module.minutes) min").font(NT.mono(10)).foregroundStyle(NT.tx3)
                }
                BarView(value: p, color: color, height: 4)
            }
            Image(systemName: "chevron.right").foregroundStyle(NT.tx3)
        }
        .card(padding: 14)
    }
}

struct ModuleView: View {
    @Environment(Store.self) private var store
    let module: Module
    @State private var quiz: QuizConfig?
    var body: some View {
        let f = store.flagState(module)
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                VStack(alignment: .leading, spacing: 12) {
                    HStack(alignment: .top, spacing: 14) {
                        IconTile(icon: module.icon, size: 58)
                        VStack(alignment: .leading, spacing: 6) {
                            Text(module.title).font(.system(size: 22, weight: .heavy)).fixedSize(horizontal: false, vertical: true)
                            HStack(spacing: 6) {
                                Pill(text: NT.diffLabel(module.difficulty), color: NT.diff(module.difficulty))
                                Pill(text: "\(module.minutes) min", color: NT.tx2)
                            }
                        }
                    }
                    MD(text: module.summary, size: 14, color: NT.tx2)
                    HStack(spacing: 14) {
                        ProgressRing(value: store.moduleProgress(module), size: 64, line: 6, sub: "MODUL")
                        VStack(alignment: .leading, spacing: 6) {
                            HStack { Text("Gelesen").font(NT.mono(11)).foregroundStyle(NT.tx3); Spacer(); Text("\(Int(store.readFraction(module) * 100)) %").font(NT.mono(11, .bold)) }
                            BarView(value: store.readFraction(module), color: NT.blue, height: 5)
                            HStack { Text("Quiz-Mastery").font(NT.mono(11)).foregroundStyle(NT.tx3); Spacer(); Text("\(Int(store.quizMastery(module) * 100)) %").font(NT.mono(11, .bold)) }
                            BarView(value: store.quizMastery(module), height: 5)
                        }
                    }
                    HStack(spacing: 8) {
                        FlagChip(title: "user", got: f.user, color: NT.acc)
                        FlagChip(title: "root", got: f.root, color: NT.red)
                        Spacer()
                    }
                    if !module.source.isEmpty {
                        Label("Quelle: \(module.source)", systemImage: "doc.text").font(NT.mono(10)).foregroundStyle(NT.tx3)
                    }
                }
                .card(padding: 18)

                if !module.quiz.isEmpty {
                    HStack(spacing: 10) {
                        Button { quiz = QuizConfig(mode: .training, title: module.title, questions: store.buildTraining([module.id])) } label: { Label("Quiz", systemImage: "scope") }
                            .buttonStyle(PrimaryButtonStyle())
                        Button { quiz = QuizConfig(mode: .flashcards, title: module.title, questions: store.buildTraining([module.id], size: 25)) } label: { Label("Karten", systemImage: "rectangle.on.rectangle.angled") }
                            .buttonStyle(GhostButtonStyle())
                        Button { quiz = QuizConfig(mode: .exam, title: module.title + " · Prüfung", questions: store.buildExam([module.id], count: 20), timeLimit: 20 * 75) } label: { Label("Prüfung", systemImage: "checkmark.seal") }
                            .buttonStyle(GhostButtonStyle())
                    }
                }

                SectionHeader(title: "Lektionen", trailing: "\(module.lessons.count)")
                ForEach(Array(module.lessons.enumerated()), id: \.element.id) { i, l in
                    NavigationLink(value: LessonRef(module: module, index: i)) {
                        HStack(spacing: 12) {
                            Image(systemName: store.isRead(l) ? "checkmark.circle.fill" : "circle")
                                .font(.system(size: 20))
                                .foregroundStyle(store.isRead(l) ? NT.acc : NT.tx3)
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Lektion \(i + 1)").font(NT.mono(10)).foregroundStyle(NT.tx3)
                                Text(Store.plain(l.title)).font(.system(size: 15, weight: .semibold)).foregroundStyle(NT.tx).multilineTextAlignment(.leading)
                            }
                            Spacer()
                            Image(systemName: "chevron.right").foregroundStyle(NT.tx3)
                        }
                        .card(padding: 13)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(16)
        }
        .background(AppBackground())
        .navigationTitle(module.title)
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(for: LessonRef.self) { LessonPager(module: $0.module, start: $0.index) }
        .fullScreenCover(item: $quiz) { QuizView(config: $0) }
    }
}

struct FlagChip: View {
    let title: String
    let got: Bool
    let color: Color
    var body: some View {
        Label(title.uppercased(), systemImage: title == "root" ? "crown.fill" : "flag.fill")
            .font(NT.mono(10, .bold))
            .padding(.horizontal, 9).padding(.vertical, 5)
            .foregroundStyle(got ? color : NT.tx3)
            .background(RoundedRectangle(cornerRadius: 8).fill(got ? color.opacity(0.14) : Color.white.opacity(0.04)))
            .overlay(RoundedRectangle(cornerRadius: 8).stroke(got ? color.opacity(0.5) : NT.line, lineWidth: 1))
    }
}
