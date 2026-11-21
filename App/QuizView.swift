import SwiftUI
import Observation

enum QuizMode { case training, flashcards, exam, blitz, daily }

struct QuizConfig: Identifiable {
    let id = UUID()
    let mode: QuizMode
    let title: String
    let questions: [Question]
    var timeLimit: Int = 0
}

struct QuizResult: Identifiable {
    let id = UUID()
    let question: Question
    let correct: Bool
    let given: String
}

@Observable
final class QuizSession {
    let config: QuizConfig
    var items: [Question]
    var index = 0
    var answered = false
    var revealed = false
    var lastCorrect = false
    var lastTypo = false
    var lastXP = 0
    var selection: Set<Int> = []
    var typed = ""
    var placed: [Int] = []
    var pool: [Int] = []
    var optionOrder: [Int] = []
    var hintShown = false
    var combo = 0
    var maxCombo = 0
    var xp = 0
    var results: [QuizResult] = []
    var remaining: Int
    var finished = false
    var reinserted: Set<String> = []
    var questionStart = Date()
    var extra: [String] = []
    var examPassed: Bool? = nil

    init(_ c: QuizConfig) {
        config = c
        items = c.questions
        remaining = c.mode == .blitz ? 60 : c.timeLimit
        prepare()
    }

    var current: Question? { index < items.count ? items[index] : nil }
    var correctCount: Int { results.filter { $0.correct }.count }

    func prepare() {
        selection = []; typed = ""; placed = []; hintShown = false; answered = false; revealed = false
        questionStart = Date()
        guard let q = current else { return }
        optionOrder = Array((q.options ?? []).indices).shuffled()
        var p = Array((q.order ?? []).indices)
        for _ in 0..<6 { p.shuffle(); if p != Array(p.indices) || p.count < 2 { break } }
        pool = p
    }

    func evaluate(_ store: Store) -> (Bool, Bool, String) {
        guard let q = current else { return (false, false, "") }
        switch q.type {
        case "mc", "multi":
            let c = Set(q.correct ?? [])
            let given = selection.sorted().compactMap { i in q.options.flatMap { i < $0.count ? $0[i] : nil } }.joined(separator: " · ")
            return (selection == c, false, given.isEmpty ? "—" : given)
        case "tf":
            let v = selection.contains(1)
            return (v == (q.value ?? false) && !selection.isEmpty, false, selection.isEmpty ? "—" : (v ? "Wahr" : "Falsch"))
        case "input":
            let r = store.checkInput(q, typed)
            return (r.ok, r.typo, typed.isEmpty ? "—" : typed)
        case "order":
            let ok = placed.count == (q.order ?? []).count && placed.enumerated().allSatisfy { $0.offset == $0.element }
            return (ok, false, placed.compactMap { i in q.order.flatMap { i < $0.count ? $0[i] : nil } }.joined(separator: " → "))
        default:
            return (false, false, "")
        }
    }

    func submit(_ store: Store, knew: Bool? = nil) {
        guard let q = current, !answered else { return }
        var ok: Bool, typo = false, given: String
        if let k = knew {
            ok = k; given = k ? "gewusst" : "nicht gewusst"
        } else {
            (ok, typo, given) = evaluate(store)
        }
        answered = true
        lastCorrect = ok
        lastTypo = typo
        if ok { combo += 1; maxCombo = max(maxCombo, combo) } else { combo = 0 }
        let secs = Int(Date().timeIntervalSince(questionStart))
        lastXP = store.record(q, correct: ok, combo: config.mode == .exam ? 0 : combo, hint: hintShown, seconds: secs)
        xp += lastXP
        results.append(QuizResult(question: q, correct: ok, given: given))
        store.haptic(ok ? .success : .error)
        if !ok && (config.mode == .training || config.mode == .flashcards || config.mode == .daily) && !reinserted.contains(q.id) {
            reinserted.insert(q.id)
            items.insert(q, at: min(items.count, index + 4))
        }
        store.evaluateAchievements()
    }

    func next(_ store: Store) {
        index += 1
        if index >= items.count || (config.mode == .blitz && remaining <= 0) { finish(store) } else { prepare() }
    }

    func finish(_ store: Store) {
        guard !finished else { return }
        finished = true
        let total = config.mode == .exam ? config.questions.count : results.count
        switch config.mode {
        case .exam:
            examPassed = store.recordExam(title: config.title, correct: correctCount, total: total)
            if examPassed == true { extra.append("Prüfungsbonus: +\(200 + total * 6) XP") }
        case .blitz:
            if correctCount > store.progress.blitzBest {
                store.progress.blitzBest = correctCount
                extra.append("Neuer Blitz-Rekord: \(correctCount)")
                store.addXP(50)
            }
        case .daily:
            if store.progress.dailyBoxDay != Store.dayKey() && results.count >= config.questions.count {
                store.progress.dailyBoxDay = Store.dayKey()
                store.progress.coins += 20
                store.addXP(100)
                extra.append("Daily Box geknackt: +100 XP · +20 Credits")
            }
        default: break
        }
        store.evaluateAchievements()
        store.save()
    }
}

struct QuizView: View {
    @Environment(Store.self) private var store
    @Environment(\.dismiss) private var dismiss
    @State private var session: QuizSession
    @State private var confirmQuit = false
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    init(config: QuizConfig) {
        _session = State(initialValue: QuizSession(config))
    }

    var body: some View {
        ZStack {
            AppBackground()
            if session.config.questions.isEmpty {
                VStack(spacing: 14) {
                    Image(systemName: "tray").font(.largeTitle).foregroundStyle(NT.tx3)
                    Text("Keine Fragen für diese Auswahl.").foregroundStyle(NT.tx2)
                    Button("Schließen") { dismiss() }.buttonStyle(GhostButtonStyle()).frame(width: 200)
                }
            } else if session.finished {
                QuizResultView(session: session) { dismiss() }
            } else if let q = session.current {
                VStack(spacing: 0) {
                    QuizTopBar(session: session) {
                        if session.results.isEmpty { dismiss() } else { confirmQuit = true }
                    }
                    ScrollView {
                        VStack(alignment: .leading, spacing: 16) {
                            QuestionCard(session: session, q: q)
                            AnswerArea(session: session, q: q)
                            if session.answered && session.config.mode != .exam && session.config.mode != .blitz {
                                FeedbackPanel(session: session, q: q)
                            }
                        }
                        .padding(16)
                        .frame(maxWidth: 760)
                        .frame(maxWidth: .infinity)
                    }
                    .scrollDismissesKeyboard(.interactively)
                    QuizBottomBar(session: session, q: q)
                }
            }
        }
        .onReceive(timer) { _ in
            guard !session.finished, session.remaining > 0, session.config.mode == .blitz || session.config.timeLimit > 0 else { return }
            session.remaining -= 1
            if session.remaining <= 0 { session.finish(store) }
        }
        .confirmationDialog("Session beenden?", isPresented: $confirmQuit, titleVisibility: .visible) {
            Button("Auswerten & beenden") {
                session.finish(store)
            }
            Button("Verwerfen", role: .destructive) { dismiss() }
            Button("Weiter lernen", role: .cancel) {}
        } message: {
            Text("Dein Fortschritt und deine XP bleiben erhalten.")
        }
    }
}

struct QuizTopBar: View {
    let session: QuizSession
    let close: () -> Void
    var body: some View {
        VStack(spacing: 10) {
            HStack(spacing: 12) {
                Button(action: close) {
                    Image(systemName: "xmark").font(.system(size: 15, weight: .bold)).foregroundStyle(NT.tx2)
                        .frame(width: 36, height: 36).background(Circle().fill(Color.white.opacity(0.06)))
                }
                VStack(alignment: .leading, spacing: 1) {
                    Text(session.config.title).font(NT.mono(12, .bold)).foregroundStyle(NT.tx2).lineLimit(1)
                    Text(session.config.mode == .blitz ? "\(session.correctCount) richtig" : "Frage \(min(session.index + 1, session.items.count)) / \(session.items.count)")
                        .font(NT.mono(11)).foregroundStyle(NT.tx3)
                }
                Spacer()
                if session.config.mode == .blitz || session.config.timeLimit > 0 {
                    Label(String(format: "%d:%02d", session.remaining / 60, session.remaining % 60), systemImage: "clock")
                        .font(NT.mono(14, .heavy))
                        .foregroundStyle(session.remaining <= (session.config.mode == .blitz ? 10 : 60) ? NT.red : NT.tx)
                }
                if session.config.mode != .exam {
                    Label("x\(session.combo)", systemImage: "bolt.fill")
                        .font(NT.mono(14, .heavy))
                        .foregroundStyle(session.combo >= 10 ? NT.red : session.combo >= 3 ? NT.orange : NT.tx3)
                    Text("+\(session.xp)").font(NT.mono(13, .bold)).foregroundStyle(NT.acc)
                }
            }
            if session.config.mode != .blitz {
                BarView(value: Double(session.index) / Double(max(session.items.count, 1)), height: 5)
            }
        }
        .padding(.horizontal, 16).padding(.top, 8).padding(.bottom, 6)
    }
}

struct QuestionCard: View {
    @Environment(Store.self) private var store
    let session: QuizSession
    let q: Question
    var body: some View {
        let c = store.card(q)
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 6) {
                Pill(text: q.typeLabel)
                Pill(text: NT.diffLabel(q.difficulty ?? "medium"), color: NT.diff(q.difficulty ?? "medium"))
                if c == nil || c?.seen == 0 { Pill(text: "Neu", color: NT.blue) } else { Pill(text: "Box \(c?.box ?? 0)", color: NT.tx3) }
                Spacer()
            }
            if let mid = store.questionModule[q.id], let m = store.moduleIndex[mid] {
                Text(m.title).font(NT.mono(10)).foregroundStyle(NT.tx3).lineLimit(1)
            }
            MD(text: q.q, size: 20, weight: .semibold)
            if let code = q.code, !code.isEmpty { CodeBlock(code: code, lang: "") }
            if session.hintShown, let h = hintText {
                Label { MD(text: h, size: 14, color: NT.gold) } icon: { Image(systemName: "lightbulb.fill").foregroundStyle(NT.gold) }
                    .padding(10).background(RoundedRectangle(cornerRadius: 10).fill(NT.gold.opacity(0.08)))
            }
        }
        .card(padding: 18)
    }
    var hintText: String? {
        if let h = q.hint, !h.isEmpty { return h }
        if q.type == "input" {
            let a = q.displayAnswer
            let n = max(1, Int(Double(a.count) * 0.35))
            return "Beginnt mit `\(a.prefix(n))…` (\(a.count) Zeichen)"
        }
        return nil
    }
}

struct AnswerArea: View {
    @Environment(Store.self) private var store
    @Bindable var session: QuizSession
    let q: Question
    @FocusState private var focused: Bool

    var body: some View {
        if session.config.mode == .flashcards {
            flashcard
        } else {
            switch q.type {
            case "mc", "multi": options
            case "tf": trueFalse
            case "input": terminal
            case "order": ordering
            default: EmptyView()
            }
        }
    }

    @ViewBuilder var flashcard: some View {
        if session.revealed {
            VStack(alignment: .leading, spacing: 10) {
                Text("ANTWORT").font(NT.mono(10, .bold)).tracking(2).foregroundStyle(NT.acc)
                MD(text: q.displayAnswer, size: 18, color: NT.acc, weight: .bold)
                if let e = q.explain, !e.isEmpty { MD(text: e, size: 15, color: NT.tx2) }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .card(padding: 16, glow: NT.acc)
        } else {
            Button { withAnimation(.spring) { session.revealed = true } } label: {
                VStack(spacing: 8) {
                    Image(systemName: "eye.fill").font(.system(size: 28))
                    Text("Antwort aufdecken").font(.system(size: 16, weight: .bold))
                    Text("Erst selbst überlegen – dann ehrlich bewerten").font(.system(size: 12)).foregroundStyle(NT.tx3)
                }
                .foregroundStyle(NT.acc)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 34)
                .background(RoundedRectangle(cornerRadius: 16).strokeBorder(NT.acc.opacity(0.4), style: StrokeStyle(lineWidth: 1.5, dash: [6])))
            }
            .buttonStyle(.plain)
        }
    }

    var options: some View {
        VStack(spacing: 10) {
            if q.type == "multi" {
                Text("Mehrere Antworten richtig (\(q.correct?.count ?? 0))").font(NT.mono(11, .bold)).foregroundStyle(NT.orange).frame(maxWidth: .infinity, alignment: .leading)
            }
            ForEach(Array(session.optionOrder.enumerated()), id: \.element) { pos, oi in
                OptionRow(number: pos + 1, text: q.options?[oi] ?? "", state: optionState(oi)) {
                    guard !session.answered else { return }
                    if q.type == "mc" {
                        session.selection = [oi]
                        session.submit(store)
                        autoAdvance()
                    } else {
                        if session.selection.contains(oi) { session.selection.remove(oi) } else { session.selection.insert(oi) }
                        store.haptic(.light)
                    }
                }
            }
        }
    }

    func optionState(_ oi: Int) -> OptionRow.State {
        let isCorrect = q.correct?.contains(oi) ?? false
        if session.answered && session.config.mode != .exam {
            if isCorrect { return .right }
            if session.selection.contains(oi) { return .wrong }
            return .dim
        }
        return session.selection.contains(oi) ? .selected : .normal
    }

    var trueFalse: some View {
        HStack(spacing: 12) {
            ForEach([1, 0], id: \.self) { v in
                let isRight = (v == 1) == (q.value ?? false)
                let st: OptionRow.State = session.answered && session.config.mode != .exam ? (isRight ? .right : (session.selection.contains(v) ? .wrong : .dim)) : .normal
                OptionRow(number: v == 1 ? 1 : 2, text: v == 1 ? "Wahr" : "Falsch", state: st, centered: true) {
                    guard !session.answered else { return }
                    session.selection = [v]
                    session.submit(store)
                    autoAdvance()
                }
            }
        }
    }

    var terminal: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 0) {
                Text("┌──(").foregroundStyle(NT.blue)
                Text(store.progress.name).foregroundStyle(NT.red).bold()
                Text("㉿").foregroundStyle(NT.blue)
                Text("nima").foregroundStyle(NT.acc)
                Text(")-[~]").foregroundStyle(NT.blue)
            }
            .font(NT.mono(13, .regular))
            HStack(spacing: 8) {
                Text("└─$").font(NT.mono(15, .bold)).foregroundStyle(NT.blue)
                TextField("Antwort eintippen …", text: $session.typed)
                    .font(NT.mono(16, .regular))
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .keyboardType(.asciiCapable)
                    .focused($focused)
                    .disabled(session.answered)
                    .submitLabel(.done)
                    .onSubmit { submitTyped() }
            }
            if session.answered && session.config.mode != .exam {
                Text(session.lastCorrect ? (session.lastTypo ? "[+] Korrekt (Tippfehler toleriert)" : "[+] Korrekt") : "[-] Falsch. Erwartet: \(q.displayAnswer)")
                    .font(NT.mono(13, .bold))
                    .foregroundStyle(session.lastCorrect ? NT.acc : NT.red)
            }
        }
        .padding(14)
        .background(RoundedRectangle(cornerRadius: 14).fill(Color(hex: "#03060A")))
        .overlay(RoundedRectangle(cornerRadius: 14).stroke(borderColor, lineWidth: 1.5))
        .onAppear { if !session.answered { focused = true } }
    }

    var borderColor: Color {
        guard session.answered, session.config.mode != .exam else { return NT.acc.opacity(0.35) }
        return session.lastCorrect ? NT.acc : NT.red
    }

    func submitTyped() {
        guard !session.answered, !session.typed.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        session.submit(store)
        autoAdvance()
    }

    var ordering: some View {
        let items = q.order ?? []
        return VStack(alignment: .leading, spacing: 10) {
            VStack(alignment: .leading, spacing: 8) {
                if session.placed.isEmpty {
                    Text("Tippe die Schritte in der richtigen Reihenfolge an").font(NT.mono(12)).foregroundStyle(NT.tx3).frame(maxWidth: .infinity).padding(.vertical, 14)
                }
                ForEach(Array(session.placed.enumerated()), id: \.offset) { n, oi in
                    let st: OptionRow.State = session.answered && session.config.mode != .exam ? (oi == n ? .right : .wrong) : .selected
                    OptionRow(number: n + 1, text: items[oi], state: st) {
                        guard !session.answered else { return }
                        session.placed.remove(at: n)
                    }
                }
            }
            .padding(10)
            .background(RoundedRectangle(cornerRadius: 14).strokeBorder(Color.white.opacity(0.15), style: StrokeStyle(lineWidth: 1, dash: [5])))
            FlowLayout(spacing: 8) {
                ForEach(session.pool.filter { !session.placed.contains($0) }, id: \.self) { oi in
                    Button {
                        session.placed.append(oi)
                        store.haptic(.light)
                    } label: {
                        MD(text: items[oi], size: 14)
                            .padding(.horizontal, 12).padding(.vertical, 9)
                            .background(RoundedRectangle(cornerRadius: 10).fill(NT.panel))
                            .overlay(RoundedRectangle(cornerRadius: 10).stroke(NT.line, lineWidth: 1))
                    }
                    .buttonStyle(.plain)
                    .disabled(session.answered)
                }
            }
            if session.answered && !session.lastCorrect && session.config.mode != .exam {
                MD(text: "Richtig: " + q.displayAnswer, size: 13, color: NT.acc)
            }
        }
    }

    func autoAdvance() {
        if session.config.mode == .exam {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) { session.next(store) }
        } else if session.config.mode == .blitz {
            let ok = session.lastCorrect
            DispatchQueue.main.asyncAfter(deadline: .now() + (ok ? 0.35 : 1.3)) {
                if session.answered && !session.finished { session.next(store) }
            }
        }
    }
}

struct OptionRow: View {
    enum State { case normal, selected, right, wrong, dim }
    let number: Int
    let text: String
    let state: State
    var centered = false
    let action: () -> Void

    var color: Color {
        switch state {
        case .right: return NT.acc
        case .wrong: return NT.red
        case .selected: return NT.acc
        default: return Color.white.opacity(0.14)
        }
    }

    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                ZStack {
                    RoundedRectangle(cornerRadius: 8).fill(state == .normal || state == .dim ? Color.white.opacity(0.06) : color)
                    if state == .right { Image(systemName: "checkmark").font(.system(size: 13, weight: .heavy)).foregroundStyle(.black) }
                    else if state == .wrong { Image(systemName: "xmark").font(.system(size: 13, weight: .heavy)).foregroundStyle(.white) }
                    else { Text("\(number)").font(NT.mono(13, .heavy)).foregroundStyle(state == .selected ? .black : NT.tx2) }
                }
                .frame(width: 30, height: 30)
                MD(text: text, size: 16, weight: .medium)
                    .frame(maxWidth: .infinity, alignment: centered ? .center : .leading)
            }
            .padding(14)
            .background(RoundedRectangle(cornerRadius: 14).fill(state == .right ? NT.acc.opacity(0.12) : state == .wrong ? NT.red.opacity(0.12) : Color.black.opacity(0.35)))
            .overlay(RoundedRectangle(cornerRadius: 14).stroke(color, lineWidth: state == .normal || state == .dim ? 1 : 1.5))
            .opacity(state == .dim ? 0.45 : 1)
        }
        .buttonStyle(.plain)
    }
}

struct FeedbackPanel: View {
    let session: QuizSession
    let q: Question
    var body: some View {
        let ok = session.lastCorrect
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Image(systemName: ok ? "checkmark.circle.fill" : "xmark.octagon.fill")
                Text(ok ? ["Pwned!", "Korrekt!", "Sauber!", "Treffer!"][q.id.count % 4] : "Access denied")
                    .font(NT.mono(15, .heavy))
                Spacer()
                if ok { Text("+\(session.lastXP) XP").font(NT.mono(13, .bold)) }
            }
            .foregroundStyle(ok ? NT.acc : NT.red)
            if !ok && session.config.mode != .flashcards {
                MD(text: "Richtig: **" + q.displayAnswer + "**", size: 15)
            }
            if let e = q.explain, !e.isEmpty, session.config.mode != .flashcards {
                MD(text: e, size: 15, color: NT.tx2)
            }
        }
        .padding(14)
        .background(RoundedRectangle(cornerRadius: 14).fill((ok ? NT.acc : NT.red).opacity(0.08)))
        .overlay(RoundedRectangle(cornerRadius: 14).stroke((ok ? NT.acc : NT.red).opacity(0.4), lineWidth: 1))
    }
}

struct QuizBottomBar: View {
    @Environment(Store.self) private var store
    @Bindable var session: QuizSession
    let q: Question
    var body: some View {
        HStack(spacing: 10) {
            if session.config.mode == .flashcards {
                if session.revealed && !session.answered {
                    Button { session.submit(store, knew: false); session.next(store) } label: { Label("Nicht gewusst", systemImage: "xmark") }
                        .buttonStyle(GhostButtonStyle(color: NT.red))
                    Button { session.submit(store, knew: true); session.next(store) } label: { Label("Gewusst", systemImage: "checkmark") }
                        .buttonStyle(PrimaryButtonStyle())
                }
            } else if session.answered {
                if session.config.mode != .blitz && session.config.mode != .exam {
                    Button { session.next(store) } label: { Label(session.index + 1 >= session.items.count ? "Ergebnis" : "Weiter", systemImage: "arrow.right") }
                        .buttonStyle(PrimaryButtonStyle())
                }
            } else {
                if (q.hint ?? "").isEmpty == false || q.type == "input", session.config.mode == .training || session.config.mode == .daily {
                    Button { withAnimation { session.hintShown = true } } label: { Image(systemName: "lightbulb") }
                        .buttonStyle(GhostButtonStyle(color: NT.gold)).frame(width: 64)
                        .disabled(session.hintShown)
                }
                if q.type == "multi" || q.type == "order" || q.type == "input" {
                    if session.config.mode != .blitz {
                        Button { session.submit(store); if session.config.mode == .exam { session.next(store) } } label: { Text(session.config.mode == .exam ? "Überspringen" : "Weiß nicht") }
                            .buttonStyle(GhostButtonStyle())
                    }
                    Button {
                        session.submit(store)
                        if session.config.mode == .exam { DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) { session.next(store) } }
                        else if session.config.mode == .blitz { DispatchQueue.main.asyncAfter(deadline: .now() + (session.lastCorrect ? 0.35 : 1.3)) { if !session.finished { session.next(store) } } }
                    } label: { Label("Prüfen", systemImage: "return") }
                        .buttonStyle(PrimaryButtonStyle())
                        .disabled(!canSubmit)
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .background(NT.bg2.opacity(0.95))
    }
    var canSubmit: Bool {
        switch q.type {
        case "multi": return !session.selection.isEmpty
        case "order": return session.placed.count == (q.order ?? []).count
        case "input": return !session.typed.trimmingCharacters(in: .whitespaces).isEmpty
        default: return true
        }
    }
}

struct QuizResultView: View {
    let session: QuizSession
    let done: () -> Void
    var body: some View {
        let total = session.config.mode == .exam ? session.config.questions.count : session.results.count
        let score = total > 0 ? Double(session.correctCount) / Double(total) : 0
        let verdict: String = {
            if let p = session.examPassed { return p ? "BESTANDEN" : "NICHT BESTANDEN" }
            if session.config.mode == .blitz { return "\(session.correctCount) RICHTIG" }
            return score >= 0.95 ? "PWNED!" : score >= 0.8 ? "SAUBER GEHACKT" : score >= 0.6 ? "SOLIDE" : score >= 0.4 ? "MEHR ENUMERATION NÖTIG" : "TRY HARDER"
        }()
        let col: Color = session.examPassed == false || score < 0.6 ? (session.examPassed == false ? NT.red : NT.orange) : NT.acc
        let wrong = session.results.filter { !$0.correct }
        ScrollView {
            VStack(spacing: 18) {
                Text(session.config.title.uppercased()).font(NT.mono(12, .bold)).tracking(2).foregroundStyle(NT.tx3).multilineTextAlignment(.center)
                ProgressRing(value: score, color: col, size: 170, line: 13, label: session.config.mode == .blitz ? "\(session.correctCount)" : "\(Int((score * 100).rounded()))%", sub: "\(session.correctCount)/\(total)")
                Text(verdict).font(.system(size: 24, weight: .black, design: .monospaced)).foregroundStyle(col)
                if session.config.mode == .exam { Text("Bestehensgrenze 80 %").font(NT.mono(12)).foregroundStyle(NT.tx3) }
                ForEach(session.extra, id: \.self) { e in Label(e, systemImage: "star.fill").font(NT.mono(12, .bold)).foregroundStyle(NT.gold) }
                HStack(spacing: 10) {
                    MiniResult(v: "+\(session.xp)", l: "XP", c: NT.acc)
                    MiniResult(v: "x\(session.maxCombo)", l: "Max Combo", c: NT.orange)
                    MiniResult(v: "\(session.results.count)", l: "Beantwortet", c: NT.blue)
                }
                Button("Fertig", action: done).buttonStyle(PrimaryButtonStyle(color: col))
                if !wrong.isEmpty {
                    SectionHeader(title: "Zum Wiederholen", trailing: "\(wrong.count)")
                    ForEach(wrong) { r in
                        VStack(alignment: .leading, spacing: 6) {
                            MD(text: r.question.q, size: 15, weight: .semibold)
                            Text("Deine Antwort: \(r.given)").font(.system(size: 13)).foregroundStyle(NT.red)
                            MD(text: "Richtig: **\(r.question.displayAnswer)**", size: 13, color: NT.acc)
                            if let e = r.question.explain, !e.isEmpty { MD(text: e, size: 13, color: NT.tx2) }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .card(padding: 12)
                    }
                }
            }
            .padding(20)
            .frame(maxWidth: 700)
            .frame(maxWidth: .infinity)
        }
    }
}

struct MiniResult: View {
    let v: String
    let l: String
    let c: Color
    var body: some View {
        VStack(spacing: 3) {
            Text(v).font(NT.mono(20, .heavy)).foregroundStyle(c)
            Text(l.uppercased()).font(NT.mono(9)).foregroundStyle(NT.tx3)
        }
        .frame(maxWidth: .infinity)
        .card(padding: 12)
    }
}
