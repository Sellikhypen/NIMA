import Foundation
import SwiftUI
import Observation
import UIKit

struct ToastMsg: Identifiable, Equatable {
    let id = UUID()
    let icon: String
    let title: String
    let detail: String
    let color: String
}

struct Celebration: Identifiable {
    let id = UUID()
    let kind: String   // level, rank, flag
    let title: String
    let subtitle: String
    let detail: String
    let color: String
    let icon: String
}

struct SearchHit: Identifiable, Hashable {
    let id: String
    let kind: String      // module, lesson, term
    let title: String
    let subtitle: String
    let moduleId: String
    let lessonIndex: Int
    let termId: String
}

@Observable
final class Store {
    // Content
    var content: ContentBundle?
    var loadError: String?
    var loading = true
    @ObservationIgnored var moduleIndex: [String: Module] = [:]
    @ObservationIgnored var pathIndex: [String: LPath] = [:]
    @ObservationIgnored var termIndex: [String: Term] = [:]
    @ObservationIgnored var lessonIndex: [String: (module: String, index: Int)] = [:]
    @ObservationIgnored var questionModule: [String: String] = [:]
    @ObservationIgnored var searchCorpus: [(hit: SearchHit, text: String)] = []

    // State
    var progress = Progress()
    var toast: ToastMsg?
    var celebrations: [Celebration] = []
    var sheetTerm: Term?
    var sheetModule: Module?

    @ObservationIgnored private var saveWork: DispatchWorkItem?

    // MARK: Loading

    func load() async {
        loadProgress()
        do {
            let bundle = try await Task.detached(priority: .userInitiated) { () -> ContentBundle in
                guard let url = Bundle.main.url(forResource: "content", withExtension: "json", subdirectory: "Content") else {
                    throw NSError(domain: "NIMA", code: 1, userInfo: [NSLocalizedDescriptionKey: "content.json fehlt im App-Bundle"])
                }
                let data = try Data(contentsOf: url)
                return try JSONDecoder().decode(ContentBundle.self, from: data)
            }.value
            index(bundle)
            content = bundle
            loading = false
            checkStreakOnLaunch()
            evaluateAchievements()
        } catch {
            loadError = error.localizedDescription
            loading = false
        }
    }

    private func index(_ b: ContentBundle) {
        var mi: [String: Module] = [:]
        var li: [String: (module: String, index: Int)] = [:]
        var qm: [String: String] = [:]
        var corpus: [(hit: SearchHit, text: String)] = []
        for m in b.modules {
            mi[m.id] = m
            corpus.append((SearchHit(id: "m:" + m.id, kind: "module", title: m.title, subtitle: m.summary, moduleId: m.id, lessonIndex: -1, termId: ""), (m.title + " " + m.summary + " " + m.tags.joined(separator: " ")).lowercased()))
            for (i, l) in m.lessons.enumerated() {
                li[l.id] = (m.id, i)
                var t = l.title + " "
                for bl in l.blocks {
                    if let s = bl.text { t += s + " " }
                    if let it = bl.items { t += it.joined(separator: " ") + " " }
                    if let ti = bl.title { t += ti + " " }
                    if let rows = bl.rows { t += rows.map { $0.joined(separator: " ") }.joined(separator: " ") + " " }
                }
                corpus.append((SearchHit(id: "l:" + l.id, kind: "lesson", title: Store.plain(l.title), subtitle: m.title, moduleId: m.id, lessonIndex: i, termId: ""), Store.plain(t).lowercased()))
            }
            for q in m.quiz { qm[q.id] = m.id }
        }
        var ti: [String: Term] = [:]
        for t in b.glossary {
            ti[t.id] = t
            corpus.append((SearchHit(id: "t:" + t.id, kind: "term", title: t.term, subtitle: Store.plain(t.short), moduleId: "", lessonIndex: -1, termId: t.id), (t.term + " " + t.aka.joined(separator: " ") + " " + t.short + " " + t.text.joined(separator: " ")).lowercased()))
        }
        var pi: [String: LPath] = [:]
        for p in b.paths { pi[p.id] = p }
        moduleIndex = mi; lessonIndex = li; questionModule = qm; termIndex = ti; pathIndex = pi
        searchCorpus = corpus
    }

    static func plain(_ s: String) -> String {
        var out = s.replacingOccurrences(of: "**", with: "").replacingOccurrences(of: "`", with: "")
        if let re = try? NSRegularExpression(pattern: "\\[([^\\]]+)\\]\\([^)]+\\)") {
            out = re.stringByReplacingMatches(in: out, range: NSRange(out.startIndex..., in: out), withTemplate: "$1")
        }
        return out
    }

    // MARK: Persistence

    private var progressURL: URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("progress.json")
    }

    private func loadProgress() {
        if let data = try? Data(contentsOf: progressURL), let p = try? JSONDecoder().decode(Progress.self, from: data) {
            progress = p
        }
    }

    func save() {
        saveWork?.cancel()
        let snapshot = progress
        let url = progressURL
        let work = DispatchWorkItem {
            if let data = try? JSONEncoder().encode(snapshot) {
                try? data.write(to: url, options: .atomic)
            }
        }
        saveWork = work
        DispatchQueue.global(qos: .utility).asyncAfter(deadline: .now() + 0.6, execute: work)
    }

    func resetProgress() {
        let name = progress.name
        progress = Progress()
        progress.name = name
        save()
    }

    // MARK: Lookups

    var paths: [LPath] { content?.paths ?? [] }
    var modules: [Module] { content?.modules ?? [] }
    var glossary: [Term] { content?.glossary ?? [] }

    func modules(of path: LPath) -> [Module] { path.modules.compactMap { moduleIndex[$0] } }

    func lesson(_ id: String) -> (Module, Int)? {
        guard let li = lessonIndex[id], let m = moduleIndex[li.module] else { return nil }
        return (m, li.index)
    }

    func handle(url: URL) {
        guard url.scheme == "nima" else { return }
        let parts = url.pathComponents.filter { $0 != "/" }
        let id = parts.first ?? ""
        if url.host == "term", let t = termIndex[id] {
            sheetTerm = t
            progress.termsViewed[t.id] = Date().timeIntervalSince1970
            save()
        } else if url.host == "module", let m = moduleIndex[id] {
            sheetModule = m
        }
    }

    // MARK: Days & streak

    static func dayKey(_ d: Date = Date()) -> String {
        let f = DateFormatter()
        f.calendar = Calendar(identifier: .gregorian)
        f.dateFormat = "yyyy-MM-dd"
        return f.string(from: d)
    }

    static func dayKey(offset: Int) -> String {
        dayKey(Calendar.current.date(byAdding: .day, value: offset, to: Date()) ?? Date())
    }

    var today: DayStat { progress.daily[Store.dayKey()] ?? DayStat() }

    var streakAlive: Int {
        let t = Store.dayKey(), y = Store.dayKey(offset: -1)
        return (progress.lastGoalDay == t || progress.lastGoalDay == y) ? progress.streak : 0
    }

    private func checkStreakOnLaunch() {
        let t = Store.dayKey(), y = Store.dayKey(offset: -1)
        if !progress.lastGoalDay.isEmpty && progress.lastGoalDay != t && progress.lastGoalDay != y && progress.streak > 0 {
            showToast(icon: "flame", title: "Streak verloren", detail: "\(progress.streak) Tage – heute neu starten!", color: "#FF4D5E")
            progress.streak = 0
            save()
        }
    }

    private func bumpDay(_ f: (inout DayStat) -> Void) {
        let k = Store.dayKey()
        var d = progress.daily[k] ?? DayStat()
        f(&d)
        progress.daily[k] = d
        let activity = d.answered + d.lessons * 3
        if activity >= progress.dailyGoal && progress.lastGoalDay != k {
            progress.streak = progress.lastGoalDay == Store.dayKey(offset: -1) ? progress.streak + 1 : 1
            progress.bestStreak = max(progress.bestStreak, progress.streak)
            progress.lastGoalDay = k
            progress.coins += 10
            addXP(50)
            showToast(icon: "flame.fill", title: "Tagesziel geschafft! \(progress.streak) 🔥", detail: "+50 XP · +10 Credits", color: "#FFAF00")
        }
    }

    // MARK: XP, Level, Rang

    static func need(_ n: Int) -> Int { 40 * (n - 1) * (n - 1) + 80 * (n - 1) }

    var level: Int {
        var l = 1
        while Store.need(l + 1) <= progress.xp { l += 1 }
        return l
    }

    var levelProgress: (cur: Int, span: Int, pct: Double) {
        let l = level
        let base = Store.need(l), span = Store.need(l + 1) - base
        return (progress.xp - base, span, Double(progress.xp - base) / Double(max(span, 1)))
    }

    static func rankIndex(level: Int) -> Int {
        var r = 0
        for (i, rk) in RANKS.enumerated() where level >= rk.level { r = i }
        return r
    }

    var rankIndex: Int { Store.rankIndex(level: level) }
    var rank: Rank { RANKS[rankIndex] }

    func addXP(_ amount: Int) {
        guard amount > 0 else { return }
        let before = level
        progress.xp += amount
        let k = Store.dayKey()
        var d = progress.daily[k] ?? DayStat()
        d.xp += amount
        progress.daily[k] = d
        let after = level
        if after > before {
            let rb = Store.rankIndex(level: before), ra = Store.rankIndex(level: after)
            if ra > rb {
                let r = RANKS[ra]
                celebrations.append(Celebration(kind: "rank", title: r.name, subtitle: "Neuer Rang freigeschaltet", detail: "Level \(after) · Du steigst in der Hierarchie auf.", color: r.color, icon: "shield.lefthalf.filled"))
            } else {
                celebrations.append(Celebration(kind: "level", title: "Level \(after)", subtitle: "Level Up", detail: "Noch \(Store.need(after + 1) - progress.xp) XP bis Level \(after + 1)", color: "#9FEF00", icon: "arrow.up.circle.fill"))
            }
            haptic(.success)
        }
    }

    // MARK: Lessons & modules

    func isRead(_ lesson: Lesson) -> Bool { progress.lessonsDone[lesson.id] != nil }

    func markRead(_ lesson: Lesson) {
        progress.lastLesson = lesson.id
        guard progress.lessonsDone[lesson.id] == nil else { save(); return }
        progress.lessonsDone[lesson.id] = Date().timeIntervalSince1970
        bumpDay { $0.lessons += 1 }
        addXP(15)
        progress.coins += 2
        if let r = self.lesson(lesson.id) { checkFlags(r.0) }
        evaluateAchievements()
        save()
    }

    func readFraction(_ m: Module) -> Double {
        guard !m.lessons.isEmpty else { return 0 }
        return Double(m.lessons.filter { isRead($0) }.count) / Double(m.lessons.count)
    }

    func quizMastery(_ m: Module) -> Double {
        guard !m.quiz.isEmpty else { return 0 }
        var s = 0.0
        for q in m.quiz { if let c = progress.cards[q.id] { s += Double(min(c.box, 4)) / 4.0 } }
        return s / Double(m.quiz.count)
    }

    func moduleProgress(_ m: Module) -> Double {
        if m.quiz.isEmpty { return readFraction(m) }
        return readFraction(m) * 0.6 + quizMastery(m) * 0.4
    }

    func pathProgress(_ p: LPath) -> Double {
        let ms = modules(of: p)
        let total = ms.reduce(0) { $0 + max($1.lessons.count, 1) }
        guard total > 0 else { return 0 }
        return ms.reduce(0.0) { $0 + moduleProgress($1) * Double(max($1.lessons.count, 1)) } / Double(total)
    }

    func nextLesson(in p: LPath) -> (Module, Int)? {
        for m in modules(of: p) {
            if let i = m.lessons.firstIndex(where: { !isRead($0) }) { return (m, i) }
        }
        return nil
    }

    var continueLesson: (Module, Int)? {
        if let r = lesson(progress.lastLesson) {
            let m = r.0, i = r.1
            if i + 1 < m.lessons.count, isRead(m.lessons[i]) { return (m, i + 1) }
            if !isRead(m.lessons[i]) { return (m, i) }
        }
        for p in paths { if let n = nextLesson(in: p) { return n } }
        return nil
    }

    func flagState(_ m: Module) -> (user: Bool, root: Bool) {
        (progress.flags[m.id + ":user"] != nil, progress.flags[m.id + ":root"] != nil)
    }

    func checkFlags(_ m: Module) {
        let p = moduleProgress(m)
        if p >= 0.5 && progress.flags[m.id + ":user"] == nil {
            progress.flags[m.id + ":user"] = Date().timeIntervalSince1970
            progress.coins += 30
            celebrations.append(Celebration(kind: "flag", title: "FOOTHOLD", subtitle: "User Flag captured", detail: m.title + "\n" + flagHash(m.id, "user"), color: "#9FEF00", icon: "flag.fill"))
            addXP(120)
        }
        if p >= 0.9 && progress.flags[m.id + ":root"] == nil {
            progress.flags[m.id + ":root"] = Date().timeIntervalSince1970
            progress.coins += 100
            celebrations.append(Celebration(kind: "flag", title: "MODUL OWNED", subtitle: "Root Flag captured", detail: m.title + "\n" + flagHash(m.id, "root"), color: "#FF4D5E", icon: "crown.fill"))
            addXP(350)
        }
    }

    func flagHash(_ id: String, _ kind: String) -> String {
        var h1: UInt64 = 0xcbf29ce484222325, h2: UInt64 = 0x84222325cbf29ce4
        for b in (id + ":" + kind + ":nima").utf8 {
            h1 = (h1 ^ UInt64(b)) &* 0x100000001b3
            h2 = (h2 &+ UInt64(b)) &* 0x9E3779B97F4A7C15
        }
        return "NIMA{" + String(format: "%016llx%016llx", h1, h2) + "}"
    }

    // MARK: Questions & spaced repetition

    static let intervals: [Double] = [0, 4 * 3600, 86400, 3 * 86400, 7 * 86400, 16 * 86400, 35 * 86400, 90 * 86400]

    func card(_ q: Question) -> CardState? { progress.cards[q.id] }

    func isDue(_ q: Question) -> Bool {
        guard let c = progress.cards[q.id], c.seen > 0 else { return false }
        return c.due <= Date().timeIntervalSince1970
    }

    var totalDue: Int {
        var n = 0
        for m in modules { for q in m.quiz where isDue(q) { n += 1 } }
        return n
    }

    @discardableResult
    func record(_ q: Question, correct: Bool, combo: Int, hint: Bool = false, seconds: Int = 0) -> Int {
        var c = progress.cards[q.id] ?? CardState()
        c.seen += 1
        if correct {
            c.right += 1
            c.box = min(c.box + 1, Store.intervals.count - 1)
        } else {
            c.wrong += 1
            c.box = c.box >= 4 ? 1 : 0
        }
        c.due = Date().timeIntervalSince1970 + Store.intervals[c.box]
        progress.cards[q.id] = c
        progress.totalAnswered += 1
        var xp = 0
        if correct {
            progress.totalCorrect += 1
            if q.type == "input" || q.type == "order" { progress.typedCorrect += 1 }
            let mult: Double = ["easy": 1.0, "medium": 1.4, "hard": 1.8, "insane": 2.5][q.difficulty ?? "medium"] ?? 1.4
            var v = 10.0 * mult * ((q.type == "input" || q.type == "order") ? 1.3 : 1.0) * (1.0 + Double(min(combo, 20)) * 0.05)
            if hint { v *= 0.5 }
            xp = max(1, Int(v.rounded()))
            progress.coins += 1
        }
        progress.maxCombo = max(progress.maxCombo, combo)
        bumpDay { d in
            d.answered += 1
            if correct { d.correct += 1 }
            d.seconds += min(seconds, 120)
        }
        addXP(xp)
        if let mid = questionModule[q.id], let m = moduleIndex[mid] { checkFlags(m) }
        save()
        return xp
    }

    // Session builders
    func pool(_ moduleIds: [String]?) -> [Question] {
        let ms = moduleIds.map { $0.compactMap { moduleIndex[$0] } } ?? modules
        return ms.flatMap { $0.quiz }
    }

    func buildTraining(_ moduleIds: [String]?, size: Int = 15, onlyTyped: Bool = false) -> [Question] {
        var p = pool(moduleIds)
        if onlyTyped { p = p.filter { $0.type == "input" } }
        let now = Date().timeIntervalSince1970
        let due = p.filter { (progress.cards[$0.id]?.seen ?? 0) > 0 && (progress.cards[$0.id]?.due ?? 0) <= now }.shuffled()
        let fresh = p.filter { (progress.cards[$0.id]?.seen ?? 0) == 0 }.shuffled()
        let rest = p.filter { (progress.cards[$0.id]?.seen ?? 0) > 0 && (progress.cards[$0.id]?.due ?? 0) > now }
            .sorted { (progress.cards[$0.id]?.box ?? 0) < (progress.cards[$1.id]?.box ?? 0) }
        var out: [Question] = []
        out += due.prefix(Int(Double(size) * 0.7))
        out += fresh.prefix(size - out.count)
        out += due.dropFirst(Int(Double(size) * 0.7)).prefix(max(0, size - out.count))
        out += rest.prefix(max(0, size - out.count))
        return out.shuffled()
    }

    func buildExam(_ moduleIds: [String]?, count: Int) -> [Question] {
        let ms = moduleIds.map { $0.compactMap { moduleIndex[$0] } } ?? modules
        var per = ms.map { $0.quiz.shuffled() }.filter { !$0.isEmpty }
        var out: [Question] = []
        var i = 0
        while out.count < count && per.contains(where: { !$0.isEmpty }) {
            let k = i % per.count
            if !per[k].isEmpty { out.append(per[k].removeLast()) }
            i += 1
        }
        return out.shuffled()
    }

    func buildWeak(size: Int = 15) -> [Question] {
        let p = pool(nil).filter { (progress.cards[$0.id]?.wrong ?? 0) > 0 }
        return Array(p.sorted {
            let a = progress.cards[$0.id]!, b = progress.cards[$1.id]!
            return Double(a.wrong) / Double(max(a.seen, 1)) > Double(b.wrong) / Double(max(b.seen, 1))
        }.prefix(size)).shuffled()
    }

    func buildDaily() -> [Question] {
        var gen = SeededGenerator(seed: Store.dayKey())
        let all = pool(nil).sorted { $0.id < $1.id }
        return Array(all.shuffled(using: &gen).prefix(10))
    }

    func buildBlitz(_ moduleIds: [String]?) -> [Question] {
        let p = pool(moduleIds).filter { $0.type != "order" }
        var out: [Question] = []
        while out.count < 300 && !p.isEmpty { out += p.shuffled() }
        return out
    }

    // MARK: Answer checking

    static func norm(_ s: String, cs: Bool) -> String {
        var t = s.trimmingCharacters(in: .whitespacesAndNewlines)
        t = t.trimmingCharacters(in: CharacterSet(charactersIn: "`'\"„“”"))
        t = t.replacingOccurrences(of: "\\s+", with: " ", options: .regularExpression)
        if !cs { t = t.lowercased() }
        while t.count > 1 && (t.hasSuffix("/") || t.hasSuffix("\\")) { t.removeLast() }
        return t
    }

    static func lev(_ a: String, _ b: String) -> Int {
        let a = Array(a), b = Array(b)
        if abs(a.count - b.count) > 3 { return 99 }
        var prev = Array(0...b.count)
        for i in 1...max(a.count, 1) where !a.isEmpty {
            var cur = [i] + Array(repeating: 0, count: b.count)
            for j in 1...max(b.count, 1) where !b.isEmpty {
                cur[j] = min(prev[j] + 1, cur[j - 1] + 1, prev[j - 1] + (a[i - 1] == b[j - 1] ? 0 : 1))
            }
            prev = cur
        }
        return prev[b.count]
    }

    static func signature(_ s: String) -> String {
        let flags = s.split(separator: " ").filter { $0.hasPrefix("-") }.sorted().joined(separator: " ")
        let digits = s.components(separatedBy: CharacterSet.decimalDigits.inverted).filter { !$0.isEmpty }.joined(separator: ",")
        return flags + "|" + digits
    }

    func checkInput(_ q: Question, _ input: String) -> (ok: Bool, typo: Bool) {
        let cs = q.caseSensitive ?? false
        let user = Store.norm(input, cs: cs)
        if user.isEmpty { return (false, false) }
        let answers = q.answers ?? []
        for a in answers {
            if a.lowercased().hasPrefix("re:") {
                let pattern = "^(?:" + String(a.dropFirst(3)) + ")$"
                if let re = try? NSRegularExpression(pattern: pattern, options: cs ? [] : [.caseInsensitive]) {
                    let t = input.trimmingCharacters(in: .whitespacesAndNewlines)
                    if re.firstMatch(in: t, range: NSRange(t.startIndex..., in: t)) != nil { return (true, false) }
                }
                continue
            }
            if Store.norm(a, cs: cs) == user { return (true, false) }
        }
        for a in answers where !a.lowercased().hasPrefix("re:") {
            let na = Store.norm(a, cs: cs)
            if na.count < 6 || user.count < 4 { continue }
            if Store.signature(na) != Store.signature(user) { continue }
            if Store.lev(na, user) <= (na.count >= 14 ? 2 : 1) { return (true, true) }
        }
        return (false, false)
    }

    // MARK: Exams

    func recordExam(title: String, correct: Int, total: Int) -> Bool {
        let score = total > 0 ? Double(correct) / Double(total) : 0
        let passed = score >= 0.8
        progress.exams.append(ExamRecord(date: Date(), title: title, score: score, correct: correct, total: total, passed: passed))
        if passed {
            progress.coins += 40 + total
            addXP(200 + total * 6)
        }
        evaluateAchievements()
        save()
        return passed
    }

    // MARK: Glossary bookmarks

    func isBookmarked(_ t: Term) -> Bool { progress.bookmarks.contains(t.id) }
    func toggleBookmark(_ t: Term) {
        if let i = progress.bookmarks.firstIndex(of: t.id) { progress.bookmarks.remove(at: i) } else { progress.bookmarks.append(t.id) }
        haptic(.light)
        save()
    }

    // MARK: Search

    func search(_ query: String, limit: Int = 80) -> [SearchHit] {
        let q = query.lowercased().trimmingCharacters(in: .whitespaces)
        guard q.count >= 2 else { return [] }
        let words = q.split(separator: " ").map(String.init)
        var scored: [(SearchHit, Int)] = []
        for (hit, text) in searchCorpus {
            guard words.allSatisfy({ text.contains($0) }) else { continue }
            var s = 0
            let tl = hit.title.lowercased()
            if tl == q { s += 100 }
            if tl.hasPrefix(q) { s += 50 }
            if tl.contains(q) { s += 25 }
            s += hit.kind == "term" ? 8 : hit.kind == "module" ? 6 : 0
            scored.append((hit, s))
        }
        return scored.sorted { $0.1 > $1.1 }.prefix(limit).map { $0.0 }
    }

    // MARK: Feedback

    enum HapticKind { case success, error, light }
    func haptic(_ k: HapticKind) {
        guard progress.haptics else { return }
        switch k {
        case .success: UINotificationFeedbackGenerator().notificationOccurred(.success)
        case .error: UINotificationFeedbackGenerator().notificationOccurred(.error)
        case .light: UIImpactFeedbackGenerator(style: .light).impactOccurred()
        }
    }

    func showToast(icon: String, title: String, detail: String, color: String = "#9FEF00") {
        let t = ToastMsg(icon: icon, title: title, detail: detail, color: color)
        toast = t
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.2) { [weak self] in
            if self?.toast?.id == t.id { self?.toast = nil }
        }
    }

    // MARK: Achievements

    var masteredCount: Int { progress.cards.values.filter { $0.box >= 4 }.count }
    var lessonsReadCount: Int { progress.lessonsDone.count }
    var ownedModules: Int { progress.flags.keys.filter { $0.hasSuffix(":root") }.count }

    func evaluateAchievements() {
        for a in ACHIEVEMENTS where progress.achievements[a.id] == nil {
            if a.check(self) {
                progress.achievements[a.id] = Date().timeIntervalSince1970
                progress.coins += a.coins
                showToast(icon: a.icon, title: "Achievement: " + a.name, detail: a.desc + " · +\(a.coins) Credits", color: a.color)
                haptic(.success)
            }
        }
    }
}

struct SeededGenerator: RandomNumberGenerator {
    var state: UInt64
    init(seed: String) {
        var h: UInt64 = 0xcbf29ce484222325
        for b in seed.utf8 { h = (h ^ UInt64(b)) &* 0x100000001b3 }
        state = h == 0 ? 1 : h
    }
    mutating func next() -> UInt64 {
        state ^= state << 13
        state ^= state >> 7
        state ^= state << 17
        return state
    }
}

let ACHIEVEMENTS: [Achievement] = [
    Achievement(id: "first_lesson", name: "Hello World", desc: "Erste Lektion gelesen", icon: "book.fill", coins: 10, color: "#2EE7B6") { $0.lessonsReadCount >= 1 },
    Achievement(id: "lessons_25", name: "Leseratte", desc: "25 Lektionen gelesen", icon: "books.vertical.fill", coins: 40, color: "#9FEF00") { $0.lessonsReadCount >= 25 },
    Achievement(id: "lessons_100", name: "Wissensdurst", desc: "100 Lektionen gelesen", icon: "brain.head.profile", coins: 120, color: "#4CC2FF") { $0.lessonsReadCount >= 100 },
    Achievement(id: "lessons_300", name: "Bibliothekar", desc: "300 Lektionen gelesen", icon: "building.columns.fill", coins: 300, color: "#FFD35C") { $0.lessonsReadCount >= 300 },
    Achievement(id: "first_blood", name: "First Blood", desc: "Erste richtige Antwort", icon: "scope", coins: 10, color: "#FF4D5E") { $0.progress.totalCorrect >= 1 },
    Achievement(id: "ans_100", name: "Enumerator", desc: "100 Fragen beantwortet", icon: "magnifyingglass", coins: 25, color: "#D08B4F") { $0.progress.totalAnswered >= 100 },
    Achievement(id: "ans_500", name: "Persistence", desc: "500 Fragen beantwortet", icon: "arrow.triangle.2.circlepath", coins: 60, color: "#C9D4E8") { $0.progress.totalAnswered >= 500 },
    Achievement(id: "ans_2000", name: "APT", desc: "2.000 Fragen beantwortet", icon: "eye.fill", coins: 200, color: "#FFD35C") { $0.progress.totalAnswered >= 2000 },
    Achievement(id: "combo_10", name: "Combo x10", desc: "10 richtige in Folge", icon: "bolt.fill", coins: 20, color: "#FFAF00") { $0.progress.maxCombo >= 10 },
    Achievement(id: "combo_25", name: "Unstoppable", desc: "25 richtige in Folge", icon: "bolt.circle.fill", coins: 60, color: "#FF7A3D") { $0.progress.maxCombo >= 25 },
    Achievement(id: "combo_50", name: "God Mode", desc: "50 richtige in Folge", icon: "sparkles", coins: 150, color: "#C77DFF") { $0.progress.maxCombo >= 50 },
    Achievement(id: "streak_3", name: "On Fire", desc: "3 Tage Streak", icon: "flame", coins: 20, color: "#FFAF00") { $0.progress.bestStreak >= 3 },
    Achievement(id: "streak_7", name: "Wochen-Warrior", desc: "7 Tage Streak", icon: "flame.fill", coins: 60, color: "#FF7A3D") { $0.progress.bestStreak >= 7 },
    Achievement(id: "streak_30", name: "Habit Hacker", desc: "30 Tage Streak", icon: "flame.circle.fill", coins: 250, color: "#FF4D5E") { $0.progress.bestStreak >= 30 },
    Achievement(id: "flag_user", name: "Foothold", desc: "Erste User-Flag", icon: "flag.fill", coins: 25, color: "#9FEF00") { $0.progress.flags.keys.contains { $0.hasSuffix(":user") } },
    Achievement(id: "flag_root", name: "Rooted", desc: "Erstes Modul owned", icon: "crown.fill", coins: 60, color: "#FF4D5E") { $0.ownedModules >= 1 },
    Achievement(id: "owned_10", name: "Box Collector", desc: "10 Module owned", icon: "square.stack.3d.up.fill", coins: 200, color: "#FFD35C") { $0.ownedModules >= 10 },
    Achievement(id: "owned_50", name: "Domain Admin", desc: "50 Module owned", icon: "server.rack", coins: 600, color: "#C77DFF") { $0.ownedModules >= 50 },
    Achievement(id: "exam_1", name: "Certified", desc: "Erste Prüfung bestanden", icon: "rosette", coins: 50, color: "#4CC2FF") { $0.progress.exams.contains { $0.passed } },
    Achievement(id: "exam_perfect", name: "Flawless", desc: "Prüfung mit 100 %", icon: "medal.fill", coins: 150, color: "#FFD35C") { $0.progress.exams.contains { $0.score >= 1 && $0.total >= 10 } },
    Achievement(id: "typed_50", name: "Terminal Junkie", desc: "50 getippte Antworten richtig", icon: "terminal.fill", coins: 40, color: "#9FEF00") { $0.progress.typedCorrect >= 50 },
    Achievement(id: "mastered_100", name: "Knowledge Base", desc: "100 Karten gemeistert", icon: "brain", coins: 80, color: "#2EE7B6") { $0.masteredCount >= 100 },
    Achievement(id: "terms_50", name: "Wörterbuch", desc: "50 Fachbegriffe nachgeschlagen", icon: "character.book.closed.fill", coins: 40, color: "#B77DFF") { $0.progress.termsViewed.count >= 50 },
    Achievement(id: "terms_250", name: "Lexikon", desc: "250 Fachbegriffe nachgeschlagen", icon: "text.book.closed.fill", coins: 150, color: "#FFD35C") { $0.progress.termsViewed.count >= 250 },
    Achievement(id: "blitz_15", name: "Speed Demon", desc: "15 richtige in einem Blitz", icon: "hare.fill", coins: 40, color: "#FFAF00") { $0.progress.blitzBest >= 15 },
    Achievement(id: "daily_box", name: "Daily Box", desc: "Erste Daily Box geknackt", icon: "shippingbox.fill", coins: 15, color: "#FFAF00") { !$0.progress.dailyBoxDay.isEmpty },
    Achievement(id: "level_10", name: "Aufsteiger", desc: "Level 10 erreicht", icon: "chart.line.uptrend.xyaxis", coins: 100, color: "#9FEF00") { $0.level >= 10 },
    Achievement(id: "level_25", name: "Veteran", desc: "Level 25 erreicht", icon: "star.circle.fill", coins: 300, color: "#B77DFF") { $0.level >= 25 },
]
