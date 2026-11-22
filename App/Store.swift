import Foundation
import SwiftUI
import Observation
import UIKit
import UserNotifications

struct ToastMsg: Identifiable, Equatable {
    let id = UUID()
    let icon: String
    let title: String
    let detail: String
    let color: String
}

struct Celebration: Identifiable {
    let id = UUID()
    let kind: String   // level, rank, flag, cert, chest
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

struct Quest: Identifiable {
    let id: String
    let title: String
    let icon: String
    let target: Int
    let value: Int
    let xp: Int
    let coins: Int
    let claimed: Bool
    var done: Bool { value >= target }
    var fraction: Double { min(1, Double(value) / Double(max(target, 1))) }
}

struct ShopTheme: Identifiable {
    let id: String
    let name: String
    let hex: String
    let price: Int
}

let THEMES: [ShopTheme] = [
    ShopTheme(id: "matrix", name: "Matrix", hex: "#9FEF00", price: 0),
    ShopTheme(id: "ice", name: "Ice", hex: "#4CC2FF", price: 300),
    ShopTheme(id: "toxic", name: "Toxic", hex: "#2EE7B6", price: 300),
    ShopTheme(id: "phantom", name: "Phantom", hex: "#B77DFF", price: 400),
    ShopTheme(id: "ember", name: "Ember", hex: "#FFAF00", price: 400),
    ShopTheme(id: "aurum", name: "Aurum", hex: "#FFD35C", price: 500),
    ShopTheme(id: "crimson", name: "Crimson", hex: "#FF4D5E", price: 500),
    ShopTheme(id: "synth", name: "Synthwave", hex: "#FF4FD8", price: 650),
]

struct PlanStatus {
    let path: LPath
    let remainingLessons: Int
    let daysLeft: Int
    let perDay: Int
    let todayDone: Int
    let onTrack: Bool
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
    @ObservationIgnored var questionIndex: [String: Question] = [:]
    @ObservationIgnored var lessonQuestions: [String: [Question]] = [:]
    @ObservationIgnored var searchCorpus: [(hit: SearchHit, text: String)] = []
    @ObservationIgnored var vocabTerms: [Term] = []

    // State
    var progress = Progress()
    var toast: ToastMsg?
    var celebrations: [Celebration] = []
    var sheetTerm: Term?
    var sheetModule: Module?
    var sheetLesson: LessonRef?
    var themeVersion = 0

    @ObservationIgnored private var saveWork: DispatchWorkItem?

    // MARK: Loading

    @MainActor
    func load() async {
        loadProgress()
        Theme.accentHex = THEMES.first { $0.id == progress.prefs.accent }?.hex ?? "#9FEF00"
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
            evaluateQuests()
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
        var qi: [String: Question] = [:]
        var lq: [String: [Question]] = [:]
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
            for q in m.quiz {
                qm[q.id] = m.id
                qi[q.id] = q
                if let L = q.lesson, L >= 0, L < m.lessons.count {
                    lq[m.lessons[L].id, default: []].append(q)
                }
            }
        }
        var ti: [String: Term] = [:]
        for t in b.glossary {
            ti[t.id] = t
            corpus.append((SearchHit(id: "t:" + t.id, kind: "term", title: t.term, subtitle: Store.plain(t.short), moduleId: "", lessonIndex: -1, termId: t.id), (t.term + " " + t.aka.joined(separator: " ") + " " + t.short + " " + t.text.joined(separator: " ")).lowercased()))
        }
        var pi: [String: LPath] = [:]
        for p in b.paths { pi[p.id] = p }
        moduleIndex = mi; lessonIndex = li; questionModule = qm; questionIndex = qi; lessonQuestions = lq
        termIndex = ti; pathIndex = pi
        searchCorpus = corpus
        vocabTerms = b.glossary.filter { !$0.short.isEmpty && $0.term.count <= 48 }
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
        let prefs = progress.prefs
        progress = Progress()
        progress.name = name
        progress.prefs = prefs
        progress.prefs.accent = "matrix"
        progress.onboarded = true
        applyTheme("matrix")
        save()
    }

    /// Backup als JSON-Datei (für ShareLink)
    func exportBackup() -> URL? {
        let f = DateFormatter()
        f.dateFormat = "yyyy-MM-dd"
        let url = FileManager.default.temporaryDirectory.appendingPathComponent("NIMA-Backup-\(f.string(from: Date())).json")
        let enc = JSONEncoder()
        enc.outputFormatting = [.prettyPrinted, .sortedKeys]
        guard let data = try? enc.encode(progress) else { return nil }
        do { try data.write(to: url, options: .atomic) } catch { return nil }
        return url
    }

    func importBackup(_ url: URL) -> Bool {
        let scoped = url.startAccessingSecurityScopedResource()
        defer { if scoped { url.stopAccessingSecurityScopedResource() } }
        guard let data = try? Data(contentsOf: url), let p = try? JSONDecoder().decode(Progress.self, from: data) else { return false }
        progress = p
        progress.onboarded = true
        applyTheme(progress.prefs.accent)
        save()
        showToast(icon: "arrow.down.doc.fill", title: "Backup geladen", detail: "Level \(level) · \(progress.xp) XP", color: "#2EE7B6")
        return true
    }

    // MARK: Lookups

    var paths: [LPath] { content?.paths ?? [] }
    var modules: [Module] { content?.modules ?? [] }
    var glossary: [Term] { content?.glossary ?? [] }
    var prefs: Prefs { progress.prefs }

    func modules(of path: LPath) -> [Module] { path.modules.compactMap { moduleIndex[$0] } }

    func lesson(_ id: String) -> (Module, Int)? {
        guard let li = lessonIndex[id], let m = moduleIndex[li.module] else { return nil }
        return (m, li.index)
    }

    func module(of q: Question) -> Module? { questionModule[q.id].flatMap { moduleIndex[$0] } }

    func handle(url: URL) {
        guard url.scheme == "nima" else { return }
        let parts = url.pathComponents.filter { $0 != "/" }
        let id = parts.first ?? ""
        if url.host == "term", let t = termIndex[id] {
            sheetTerm = t
            viewedTerm(t)
        } else if url.host == "module", let m = moduleIndex[id] {
            sheetModule = m
        }
    }

    func viewedTerm(_ t: Term) {
        let prev = progress.termsViewed[t.id] ?? 0
        let startOfDay = Calendar.current.startOfDay(for: Date()).timeIntervalSince1970
        progress.termsViewed[t.id] = Date().timeIntervalSince1970
        if prev < startOfDay { bumpDay { $0.terms += 1 } }
        evaluateQuests()
        evaluateAchievements()
        save()
    }

    func openLesson(_ m: Module, _ i: Int) {
        sheetTerm = nil
        sheetLesson = LessonRef(module: m, index: max(0, min(i, m.lessons.count - 1)))
    }

    // MARK: Theme

    func applyTheme(_ id: String) {
        Theme.accentHex = THEMES.first { $0.id == id }?.hex ?? "#9FEF00"
        progress.prefs.accent = id
        themeVersion += 1
        save()
    }

    // MARK: Days & streak

    static let dayFormatter: DateFormatter = {
        let f = DateFormatter()
        f.calendar = Calendar(identifier: .gregorian)
        f.locale = Locale(identifier: "en_US_POSIX")
        f.dateFormat = "yyyy-MM-dd"
        return f
    }()

    static func dayKey(_ d: Date = Date()) -> String { dayFormatter.string(from: d) }

    static func dayKey(offset: Int) -> String {
        dayKey(Calendar.current.date(byAdding: .day, value: offset, to: Date()) ?? Date())
    }

    static func daysBetween(_ fromKey: String, _ to: Date = Date()) -> Int? {
        guard let d = dayFormatter.date(from: fromKey) else { return nil }
        let cal = Calendar.current
        return cal.dateComponents([.day], from: cal.startOfDay(for: d), to: cal.startOfDay(for: to)).day
    }

    var today: DayStat { progress.daily[Store.dayKey()] ?? DayStat() }

    var streakAlive: Int {
        let t = Store.dayKey(), y = Store.dayKey(offset: -1)
        return (progress.lastGoalDay == t || progress.lastGoalDay == y) ? progress.streak : 0
    }

    var goalReachedToday: Bool { progress.lastGoalDay == Store.dayKey() }

    private func checkStreakOnLaunch() {
        let t = Store.dayKey(), y = Store.dayKey(offset: -1)
        guard !progress.lastGoalDay.isEmpty, progress.lastGoalDay != t, progress.lastGoalDay != y, progress.streak > 0 else { return }
        let gap = (Store.daysBetween(progress.lastGoalDay) ?? 99) - 1
        if gap >= 1 && gap <= progress.streakFreezes {
            progress.streakFreezes -= gap
            progress.freezesUsed += gap
            progress.lastGoalDay = y
            showToast(icon: "snowflake", title: "Streak gerettet ❄️", detail: "\(gap) Streak-Freeze eingesetzt – \(progress.streak) Tage bleiben.", color: "#4CC2FF")
        } else {
            showToast(icon: "flame", title: "Streak verloren", detail: "\(progress.streak) Tage – heute neu starten! Tipp: Streak-Freeze im Shop.", color: "#FF4D5E")
            progress.streak = 0
        }
        save()
    }

    private func bumpDay(_ f: (inout DayStat) -> Void) {
        let k = Store.dayKey()
        var d = progress.daily[k] ?? DayStat()
        f(&d)
        progress.daily[k] = d
        if d.activity >= progress.dailyGoal && progress.lastGoalDay != k {
            progress.streak = progress.lastGoalDay == Store.dayKey(offset: -1) ? progress.streak + 1 : 1
            progress.bestStreak = max(progress.bestStreak, progress.streak)
            progress.lastGoalDay = k
            progress.coins += 10 + min(progress.streak, 30)
            addXP(50)
            showToast(icon: "flame.fill", title: "Tagesziel geschafft! \(progress.streak) 🔥", detail: "+50 XP · +\(10 + min(progress.streak, 30)) Credits", color: "#FFAF00")
            if [7, 14, 30, 50, 100, 200, 365].contains(progress.streak) {
                progress.streakFreezes = min(progress.streakFreezes + 1, 5)
                celebrations.append(Celebration(kind: "streak", title: "\(progress.streak) Tage", subtitle: "Streak-Meilenstein", detail: "Bonus: 1 Streak-Freeze gratis.\nDranbleiben ist die halbe Miete.", color: "#FFAF00", icon: "flame.fill"))
            }
        }
    }

    // MARK: XP, Level, Rang

    static func need(_ n: Int) -> Int { 40 * (n - 1) * (n - 1) + 80 * (n - 1) }

    static func level(for xp: Int) -> Int {
        var l = 1
        while Store.need(l + 1) <= xp { l += 1 }
        return l
    }

    var level: Int { Store.level(for: progress.xp) }

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

    /// Fortschritt zum nächsten Rang (0…1) und fehlende XP
    var rankProgress: (pct: Double, missing: Int) {
        let i = rankIndex
        guard i + 1 < RANKS.count else { return (1, 0) }
        let a = Store.need(RANKS[i].level), b = Store.need(RANKS[i + 1].level)
        return (Double(progress.xp - a) / Double(max(b - a, 1)), max(0, b - progress.xp))
    }

    var boostActive: Bool { progress.boostUntil > Date().timeIntervalSince1970 }
    var boostMinutesLeft: Int { max(0, Int((progress.boostUntil - Date().timeIntervalSince1970) / 60)) }

    @discardableResult
    func addXP(_ raw: Int, boosted: Bool = false) -> Int {
        guard raw > 0 else { return 0 }
        let amount = boosted && boostActive ? raw * 2 : raw
        let before = level
        progress.xp += amount
        let k = Store.dayKey()
        var d = progress.daily[k] ?? DayStat()
        d.xp += amount
        progress.daily[k] = d
        let after = level
        if after > before {
            let rb = Store.rankIndex(level: before), ra = Store.rankIndex(level: after)
            progress.coins += 5 * (after - before)
            if ra > rb {
                let r = RANKS[ra]
                progress.coins += 50 * (ra - rb)
                celebrations.append(Celebration(kind: "rank", title: r.name, subtitle: "Neuer Rang freigeschaltet", detail: "Level \(after) · \(r.motto)\n+\(50 * (ra - rb)) Credits", color: r.color, icon: "shield.lefthalf.filled"))
            } else {
                celebrations.append(Celebration(kind: "level", title: "Level \(after)", subtitle: "Level Up", detail: "Noch \(Store.need(after + 1) - progress.xp) XP bis Level \(after + 1) · +5 Credits", color: Theme.accentHex, icon: "arrow.up.circle.fill"))
            }
            haptic(.success)
        }
        return amount
    }

    // MARK: Skill-Rating (Elo pro Pfad)

    func skillRating(_ key: String) -> Double { progress.skill[key] ?? 900 }
    func skillCount(_ key: String) -> Int { progress.skillN[key] ?? 0 }
    var overallSkill: Double { skillRating("all") }

    private func updateSkill(_ q: Question, score: Double) {
        guard let m = module(of: q) else { return }
        for key in ["all"] + m.paths {
            let r = skillRating(key)
            let n = skillCount(key)
            let k: Double = n < 25 ? 40 : n < 120 ? 26 : 16
            let expected = 1.0 / (1.0 + pow(10.0, (q.rating - r) / 400.0))
            let before = skillTier(r).name
            let nr = max(100, min(2800, r + k * (score - expected)))
            progress.skill[key] = nr
            progress.skillN[key] = n + 1
            if key == "all", skillTier(nr).name != before, nr > r {
                let t = skillTier(nr)
                showToast(icon: t.icon, title: "Skill-Liga: \(t.name)", detail: "Dein Können-Rating steigt auf \(Int(nr)).", color: t.color)
            }
        }
    }

    // MARK: Lessons & modules

    func isRead(_ lesson: Lesson) -> Bool { progress.lessonsDone[lesson.id] != nil }

    func markRead(_ lesson: Lesson) {
        progress.lastLesson = lesson.id
        guard progress.lessonsDone[lesson.id] == nil else { save(); return }
        progress.lessonsDone[lesson.id] = Date().timeIntervalSince1970
        bumpDay { $0.lessons += 1 }
        addXP(15, boosted: true)
        progress.coins += 2
        if let r = self.lesson(lesson.id) { checkFlags(r.0) }
        evaluateQuests()
        evaluateAchievements()
        save()
    }

    func addReading(_ seconds: Int) {
        guard seconds > 3 else { return }
        bumpDay { $0.readSeconds += min(seconds, 1800) }
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
            // Modul fertig -> nächstes Modul im selben Pfad
            if let pid = m.paths.first, let p = pathIndex[pid], let n = nextLesson(in: p) { return n }
        }
        if let p = pathIndex[progress.planPath], let n = nextLesson(in: p) { return n }
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

    // MARK: Notizen & Lesezeichen

    func note(_ lessonId: String) -> String { progress.notes[lessonId] ?? "" }
    func setNote(_ lessonId: String, _ text: String) {
        let t = text.trimmingCharacters(in: .whitespacesAndNewlines)
        progress.notes[lessonId] = t.isEmpty ? nil : text
        save()
    }
    func isMarked(_ lessonId: String) -> Bool { progress.lessonMarks.contains(lessonId) }
    func toggleMark(_ lessonId: String) {
        if let i = progress.lessonMarks.firstIndex(of: lessonId) { progress.lessonMarks.remove(at: i) } else { progress.lessonMarks.append(lessonId) }
        haptic(.light)
        save()
    }

    // MARK: Spaced Repetition 2.0 (SM-2-Variante)

    func card(_ q: Question) -> CardState? { progress.cards[q.id] }

    func isDue(_ q: Question) -> Bool {
        guard let c = progress.cards[q.id], c.seen > 0 else { return false }
        return c.due <= Date().timeIntervalSince1970
    }

    var totalDue: Int {
        let now = Date().timeIntervalSince1970
        var n = 0
        for (k, c) in progress.cards where c.seen > 0 && c.due <= now && !k.hasPrefix("term:") { n += 1 }
        return n
    }

    var vocabDue: Int {
        let now = Date().timeIntervalSince1970
        return progress.cards.filter { $0.key.hasPrefix("term:") && $0.value.seen > 0 && $0.value.due <= now }.count
    }

    /// Fälligkeiten der nächsten Tage (0 = heute inkl. überfällig)
    func forecast(days: Int = 7) -> [Int] {
        var out = Array(repeating: 0, count: days)
        let cal = Calendar.current
        let start = cal.startOfDay(for: Date())
        for c in progress.cards.values where c.seen > 0 {
            let d = Date(timeIntervalSince1970: c.due)
            let n = max(0, cal.dateComponents([.day], from: start, to: cal.startOfDay(for: d)).day ?? 0)
            if n < days { out[n] += 1 }
        }
        return out
    }

    static func box(for interval: Double) -> Int {
        switch interval {
        case ..<0.01: return 0
        case ..<0.5: return 1
        case ..<2: return 2
        case ..<5: return 3
        case ..<12: return 4
        case ..<30: return 5
        case ..<75: return 6
        default: return 7
        }
    }

    /// grade: 0 = vergessen, 1 = schwer, 2 = gut, 3 = leicht
    private func schedule(_ key: String, grade: Int) -> (wasDue: Bool, card: CardState) {
        let now = Date().timeIntervalSince1970
        var c = progress.cards[key] ?? CardState()
        let wasDue = c.seen > 0 && c.due <= now
        c.seen += 1
        c.last = now
        if grade == 0 {
            c.wrong += 1
            c.streak = 0
            if c.interval >= 1 { c.lapses += 1 }
            c.ease = max(1.3, c.ease - 0.2)
            c.interval = 0
            c.box = c.box >= 4 ? 1 : 0
            c.due = now + 10 * 60
        } else {
            c.right += 1
            c.streak += 1
            var iv: Double
            if c.interval < 1 {
                iv = grade == 3 ? 3 : grade == 2 ? 1 : 0.25
            } else {
                let mult = grade == 1 ? 1.2 : grade == 2 ? c.ease : c.ease * 1.35
                iv = max(c.interval + (grade == 1 ? 0.5 : 1), c.interval * mult)
            }
            if grade == 1 { c.ease = max(1.3, c.ease - 0.15) } else if grade == 3 { c.ease = min(3.2, c.ease + 0.15) }
            iv = min(iv * progress.prefs.srsFactor, 365)
            c.interval = iv
            c.box = Store.box(for: iv)
            c.due = now + iv * 86400 * Double.random(in: 0.94...1.06)
        }
        progress.cards[key] = c
        return (wasDue, c)
    }

    @discardableResult
    func record(_ q: Question, correct: Bool, combo: Int, hint: Bool = false, typo: Bool = false, seconds: Int = 0, grade: Int? = nil, rated: Bool = true) -> Int {
        let prev = progress.cards[q.id]
        let g: Int = grade ?? {
            guard correct else { return 0 }
            if hint || typo { return 1 }
            if seconds > 0 && seconds <= 8 && (prev?.streak ?? 0) >= 2 { return 3 }
            return 2
        }()
        let (wasDue, c) = schedule(q.id, grade: g)
        let isVocab = q.id.hasPrefix("term:")
        progress.totalAnswered += 1
        var xp = 0
        if correct {
            progress.totalCorrect += 1
            if q.isTyped { progress.typedCorrect += 1 }
            if isVocab { progress.vocabCorrect += 1 }
            let mult: Double = ["easy": 1.0, "medium": 1.4, "hard": 1.8, "insane": 2.5][q.difficulty ?? "medium"] ?? 1.4
            var v = 10.0 * mult * (q.isTyped ? 1.3 : 1.0) * (1.0 + Double(min(combo, 20)) * 0.05)
            if hint { v *= 0.5 }
            if wasDue { v *= 1.2 }          // Wiederholung fälliger Karten lohnt sich
            if c.lapses >= 3 && c.streak == 1 { v *= 1.5 } // Problemkarte geknackt
            xp = max(1, Int(v.rounded()))
            progress.coins += 1
        }
        progress.maxCombo = max(progress.maxCombo, combo)
        let hour = Calendar.current.component(.hour, from: Date())
        if hour < 5 { progress.nightOwl = true }
        if hour >= 5 && hour < 7 { progress.earlyBird = true }
        bumpDay { d in
            d.answered += 1
            if correct { d.correct += 1 }
            d.seconds += min(seconds, 120)
            d.maxCombo = max(d.maxCombo, combo)
            if wasDue { d.reviews += 1 }
            if isVocab && correct { d.vocab += 1 }
        }
        xp = addXP(xp, boosted: true)
        if rated && !isVocab { updateSkill(q, score: correct ? (hint ? 0.6 : 1) : 0) }
        if let m = module(of: q) { checkFlags(m) }
        evaluateQuests()
        save()
        return xp
    }

    // MARK: Session builders

    func pool(_ moduleIds: [String]?) -> [Question] {
        let ms = moduleIds.map { $0.compactMap { moduleIndex[$0] } } ?? modules
        return ms.flatMap { $0.quiz }
    }

    func buildTraining(_ moduleIds: [String]?, size: Int? = nil, onlyTyped: Bool = false, difficulty: String? = nil) -> [Question] {
        let size = size ?? progress.prefs.sessionSize
        var p = pool(moduleIds)
        if onlyTyped { p = p.filter { $0.type == "input" } }
        if let d = difficulty { p = p.filter { ($0.difficulty ?? "medium") == d } }
        let now = Date().timeIntervalSince1970
        let due = p.filter { (progress.cards[$0.id]?.seen ?? 0) > 0 && (progress.cards[$0.id]?.due ?? 0) <= now }
            .sorted { (progress.cards[$0.id]?.due ?? 0) < (progress.cards[$1.id]?.due ?? 0) }
        var fresh = p.filter { (progress.cards[$0.id]?.seen ?? 0) == 0 }
        // Neue Karten: eher in Modul-Reihenfolge (einfach -> schwer), nicht völlig zufällig
        if progress.prefs.simpleFirst {
            let rank: [String: Int] = ["easy": 0, "medium": 1, "hard": 2, "insane": 3]
            fresh = fresh.shuffled().sorted { (rank[$0.difficulty ?? "medium"] ?? 1) < (rank[$1.difficulty ?? "medium"] ?? 1) }
        } else {
            fresh.shuffle()
        }
        let rest = p.filter { (progress.cards[$0.id]?.seen ?? 0) > 0 && (progress.cards[$0.id]?.due ?? 0) > now }
            .sorted { (progress.cards[$0.id]?.due ?? 0) < (progress.cards[$1.id]?.due ?? 0) }
        let newLimit = max(progress.prefs.newPerSession, size - due.count)
        var out: [Question] = []
        out += due.prefix(Int(Double(size) * 0.75))
        out += fresh.prefix(min(newLimit, size - out.count))
        out += due.dropFirst(Int(Double(size) * 0.75)).prefix(max(0, size - out.count))
        out += fresh.dropFirst(min(newLimit, fresh.count)).prefix(max(0, size - out.count))
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

    var weakQuestions: [Question] {
        let qs = progress.cards.compactMap { (k, c) -> Question? in c.wrong > 0 ? questionIndex[k] : nil }
        return qs.sorted {
            let a = progress.cards[$0.id]!, b = progress.cards[$1.id]!
            let sa = Double(a.wrong) / Double(max(a.seen, 1)) + Double(a.lapses) * 0.1 - Double(a.streak) * 0.15
            let sb = Double(b.wrong) / Double(max(b.seen, 1)) + Double(b.lapses) * 0.1 - Double(b.streak) * 0.15
            return sa > sb
        }
    }

    var leeches: [Question] { weakQuestions.filter { progress.cards[$0.id]?.isLeech ?? false } }

    func buildWeak(size: Int = 15) -> [Question] { Array(weakQuestions.prefix(size)).shuffled() }

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

    /// Survival: aufsteigende Schwierigkeit, 3 Leben
    func buildSurvival(_ moduleIds: [String]?) -> [Question] {
        let p = pool(moduleIds).filter { $0.type != "order" }.shuffled()
        let rank: [String: Int] = ["easy": 0, "medium": 1, "hard": 2, "insane": 3]
        // weiche Sortierung: Schwierigkeit + Zufall -> wird langsam härter
        return Array(p.prefix(400)).map { ($0, Double(rank[$0.difficulty ?? "medium"] ?? 1) + Double.random(in: 0...1.6)) }
            .sorted { $0.1 < $1.1 }.map { $0.0 }
    }

    /// Wissens-Check direkt nach einer Lektion
    func buildCheck(_ lesson: Lesson, count: Int = 3) -> [Question] {
        let qs = lessonQuestions[lesson.id] ?? []
        let unseen = qs.filter { (progress.cards[$0.id]?.seen ?? 0) == 0 }.shuffled()
        let seen = qs.filter { (progress.cards[$0.id]?.seen ?? 0) > 0 }.shuffled()
        return Array((unseen + seen).prefix(count))
    }

    func checkCount(_ lesson: Lesson) -> Int { min(3, lessonQuestions[lesson.id]?.count ?? 0) }

    func checkPassed(correct: Int, total: Int) {
        guard total > 0 else { return }
        bumpDay { $0.checks += 1 }
        if correct == total {
            progress.checksPassed += 1
            progress.coins += 3
            addXP(10, boosted: true)
        }
        evaluateQuests()
        save()
    }

    func sessionFinished(kind: String, correct: Int, total: Int) {
        if kind == "blitz" { bumpDay { $0.blitz += 1 } }
        if kind == "survival" && correct > progress.survivalBest { progress.survivalBest = correct }
        if total >= 10 && correct == total && kind != "exam" { progress.perfectSessions += 1 }
        evaluateQuests()
        evaluateAchievements()
        save()
    }

    // MARK: Begriffe-Training (aus dem Lexikon generiert)

    func vocabQuestion(_ t: Term, variant: Int) -> Question {
        let short = Store.plain(t.short)
        let masked = Store.mask(short, t)
        let explain = t.text.first ?? t.short
        let same = vocabTerms.filter { $0.cat == t.cat && $0.id != t.id }.shuffled()
        let other = vocabTerms.filter { $0.cat != t.cat && $0.id != t.id }.shuffled()
        let distract = Array((same.prefix(3) + other.prefix(3)).prefix(3))
        switch variant % 3 {
        case 0:
            var opts = [short] + distract.map { Store.mask(Store.plain($0.short), $0) }
            var correct = 0
            opts = Store.shuffledKeepingCorrect(opts, &correct)
            return Question.make(id: "term:" + t.id, type: "mc", q: "Was beschreibt **\(t.term)**?", options: opts, correct: [correct], explain: explain, difficulty: "easy")
        case 1:
            var opts = [t.term] + distract.map { $0.term }
            var correct = 0
            opts = Store.shuffledKeepingCorrect(opts, &correct)
            return Question.make(id: "term:" + t.id, type: "mc", q: "Welcher Begriff passt?\n\n»\(masked)«", options: opts, correct: [correct], explain: explain, difficulty: "medium")
        default:
            if t.term.count <= 26 {
                return Question.make(id: "term:" + t.id, type: "input", q: "Wie heißt der Fachbegriff?\n\n»\(masked)«", answers: [t.term] + t.aka, explain: explain,
                                     hint: "Kategorie: \(t.cat) · beginnt mit „\(t.term.prefix(2))…“", difficulty: "hard")
            }
            return vocabQuestion(t, variant: 1)
        }
    }

    static func mask(_ s: String, _ t: Term) -> String {
        var out = s
        for name in [t.term] + t.aka where name.count >= 2 {
            out = out.replacingOccurrences(of: name, with: "▢▢▢", options: .caseInsensitive)
        }
        return out
    }

    static func shuffledKeepingCorrect(_ opts: [String], _ correct: inout Int) -> [String] {
        let idx = Array(opts.indices).shuffled()
        correct = idx.firstIndex(of: 0) ?? 0
        return idx.map { opts[$0] }
    }

    func buildVocab(size: Int = 15, category: String? = nil, onlyBookmarks: Bool = false) -> [Question] {
        var terms = vocabTerms
        if let c = category { terms = terms.filter { $0.cat == c } }
        if onlyBookmarks { terms = terms.filter { progress.bookmarks.contains($0.id) } }
        let now = Date().timeIntervalSince1970
        let due = terms.filter { (progress.cards["term:" + $0.id]?.seen ?? 0) > 0 && (progress.cards["term:" + $0.id]?.due ?? 0) <= now }.shuffled()
        // Neue Begriffe: zuerst die, die man schon nachgeschlagen hat
        let fresh = terms.filter { (progress.cards["term:" + $0.id]?.seen ?? 0) == 0 }
            .sorted { (progress.termsViewed[$0.id] ?? 0) > (progress.termsViewed[$1.id] ?? 0) }
        let fresh2 = Array(fresh.prefix(size * 3)).shuffled()
        let rest = terms.filter { (progress.cards["term:" + $0.id]?.seen ?? 0) > 0 && (progress.cards["term:" + $0.id]?.due ?? 0) > now }.shuffled()
        let pick = Array((due + fresh2 + rest).prefix(size))
        return pick.map { t in
            let box = progress.cards["term:" + t.id]?.box ?? 0
            return vocabQuestion(t, variant: box <= 1 ? Int.random(in: 0...1) : Int.random(in: 0...2))
        }
    }

    var vocabMastered: Int { progress.cards.filter { $0.key.hasPrefix("term:") && $0.value.box >= 4 }.count }

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
        if a.isEmpty { return b.count }
        if b.isEmpty { return a.count }
        var prev = Array(0...b.count)
        for i in 1...a.count {
            var cur = [i] + Array(repeating: 0, count: b.count)
            for j in 1...b.count {
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
            // Umlaute/ß tolerant (ae = ä …)
            if Store.fold(Store.norm(a, cs: cs)) == Store.fold(user) { return (true, false) }
        }
        guard progress.prefs.typoTolerance else { return (false, false) }
        for a in answers where !a.lowercased().hasPrefix("re:") {
            let na = Store.norm(a, cs: cs)
            if na.count < 5 || user.count < 4 { continue }
            if Store.signature(na) != Store.signature(user) { continue }
            if Store.lev(na, user) <= (na.count >= 14 ? 2 : 1) { return (true, true) }
        }
        return (false, false)
    }

    static func fold(_ s: String) -> String {
        s.replacingOccurrences(of: "ä", with: "ae").replacingOccurrences(of: "ö", with: "oe")
            .replacingOccurrences(of: "ü", with: "ue").replacingOccurrences(of: "ß", with: "ss")
            .replacingOccurrences(of: "-", with: " ")
    }

    // MARK: Exams & Zertifikate

    func recordExam(title: String, correct: Int, total: Int, pathId: String? = nil) -> Bool {
        let score = total > 0 ? Double(correct) / Double(total) : 0
        let passed = score >= progress.prefs.examPass
        progress.exams.append(ExamRecord(date: Date(), title: title, score: score, correct: correct, total: total, passed: passed))
        bumpDay { $0.exams += 1 }
        if passed {
            progress.coins += 40 + total
            addXP(200 + total * 6, boosted: true)
            if let pid = pathId, let p = pathIndex[pid], total >= 20, score >= 0.8, progress.pathCerts[pid] == nil {
                progress.pathCerts[pid] = Date().timeIntervalSince1970
                progress.coins += 250
                celebrations.append(Celebration(kind: "cert", title: p.title, subtitle: "NIMA-Zertifikat erworben", detail: "Pfadprüfung mit \(Int(score * 100)) % bestanden.\n+250 Credits\n" + flagHash(pid, "cert"), color: p.color, icon: "rosette"))
            }
        }
        evaluateQuests()
        evaluateAchievements()
        save()
        return passed
    }

    // MARK: Lernplan

    var planStatus: PlanStatus? {
        guard let p = pathIndex[progress.planPath] else { return nil }
        let remaining = modules(of: p).reduce(0) { $0 + $1.lessons.filter { !isRead($0) }.count }
        let days: Int = {
            guard progress.planDate > 0 else { return 30 }
            let d = Store.daysBetween(Store.dayKey(Date(timeIntervalSince1970: progress.planDate)), Date()) ?? 0
            return max(1, -d + 1)
        }()
        let perDay = Int((Double(remaining) / Double(days)).rounded(.up))
        return PlanStatus(path: p, remainingLessons: remaining, daysLeft: days, perDay: perDay, todayDone: today.lessons, onTrack: today.lessons >= perDay)
    }

    // MARK: Quests

    private struct QuestTpl {
        let key: String
        let title: (Int) -> String
        let icon: String
        let targets: [Int]
        let metric: (DayStat) -> Int
    }

    private var dailyTemplates: [QuestTpl] {
        [
            QuestTpl(key: "lessons", title: { "Lies \($0) Lektionen" }, icon: "book.fill", targets: [2, 3], metric: { $0.lessons }),
            QuestTpl(key: "answer", title: { "Beantworte \($0) Fragen" }, icon: "questionmark.bubble.fill", targets: [20, 30], metric: { $0.answered }),
            QuestTpl(key: "correct", title: { "\($0) richtige Antworten" }, icon: "checkmark.circle.fill", targets: [15, 25], metric: { $0.correct }),
            QuestTpl(key: "combo", title: { "Erreiche Combo ×\($0)" }, icon: "bolt.fill", targets: [6, 10], metric: { $0.maxCombo }),
            QuestTpl(key: "reviews", title: { "Wiederhole \($0) fällige Karten" }, icon: "arrow.triangle.2.circlepath", targets: [8, 15], metric: { $0.reviews }),
            QuestTpl(key: "terms", title: { "Schlage \($0) Fachbegriffe nach" }, icon: "character.book.closed.fill", targets: [3, 5], metric: { $0.terms }),
            QuestTpl(key: "vocab", title: { "\($0) Begriffe im Begriffe-Training" }, icon: "textformat.abc", targets: [8, 12], metric: { $0.vocab }),
            QuestTpl(key: "checks", title: { "Mach \($0) Wissens-Checks" }, icon: "checklist", targets: [1, 2], metric: { $0.checks }),
            QuestTpl(key: "xp", title: { "Sammle \($0) XP" }, icon: "sparkles", targets: [200, 300], metric: { $0.xp }),
            QuestTpl(key: "blitz", title: { _ in "Spiele eine Blitz-Runde" }, icon: "hare.fill", targets: [1], metric: { $0.blitz }),
        ]
    }

    var dailyQuests: [Quest] {
        let key = Store.dayKey()
        var gen = SeededGenerator(seed: "quests" + key)
        var tpls = dailyTemplates
        // Reviews nur, wenn es überhaupt Karten gibt
        if progress.cards.isEmpty { tpls.removeAll { $0.key == "reviews" || $0.key == "combo" } }
        let picks = Array(tpls.shuffled(using: &gen).prefix(3))
        let d = today
        let claimed = progress.questDay == key ? progress.questClaimed : []
        let lvl = min(level, 40)
        return picks.map { t in
            let target = t.targets[Int(gen.next() % UInt64(t.targets.count))]
            return Quest(id: "d:" + t.key, title: t.title(target), icon: t.icon, target: target, value: t.metric(d),
                         xp: 40 + lvl * 2, coins: 10 + lvl / 4, claimed: claimed.contains("d:" + t.key))
        }
    }

    static var weekId: String {
        let cal = Calendar(identifier: .iso8601)
        let c = cal.dateComponents([.yearForWeekOfYear, .weekOfYear], from: Date())
        return "\(c.yearForWeekOfYear ?? 0)-W\(c.weekOfYear ?? 0)"
    }

    var weekStats: DayStat {
        let cal = Calendar(identifier: .iso8601)
        let wd = cal.component(.weekday, from: Date())
        let dow = (wd + 5) % 7
        var s = DayStat()
        for i in 0...dow {
            if let d = progress.daily[Store.dayKey(offset: -i)] {
                s.answered += d.answered; s.correct += d.correct; s.xp += d.xp; s.lessons += d.lessons
                s.exams += d.exams; s.vocab += d.vocab; s.checks += d.checks; s.reviews += d.reviews
                s.maxCombo = max(s.maxCombo, d.maxCombo)
            }
        }
        return s
    }

    var weeklyQuests: [Quest] {
        let w = weekStats
        let claimed = progress.weekKey == Store.weekId ? progress.weekClaimed : []
        let lvl = min(level, 40)
        let xpTarget = 1500 + lvl * 50
        return [
            Quest(id: "w:xp", title: "Sammle \(xpTarget) XP diese Woche", icon: "sparkles", target: xpTarget, value: w.xp, xp: 250, coins: 60, claimed: claimed.contains("w:xp")),
            Quest(id: "w:lessons", title: "Lies 15 Lektionen diese Woche", icon: "books.vertical.fill", target: 15, value: w.lessons, xp: 250, coins: 60, claimed: claimed.contains("w:lessons")),
            Quest(id: "w:reviews", title: "Wiederhole 60 fällige Karten", icon: "brain", target: 60, value: w.reviews, xp: 250, coins: 60, claimed: claimed.contains("w:reviews")),
        ]
    }

    func evaluateQuests() {
        guard content != nil else { return }
        let key = Store.dayKey()
        if progress.questDay != key { progress.questDay = key; progress.questClaimed = [] }
        if progress.weekKey != Store.weekId { progress.weekKey = Store.weekId; progress.weekClaimed = [] }
        for q in dailyQuests where q.done && !q.claimed {
            progress.questClaimed.append(q.id)
            progress.coins += q.coins
            addXP(q.xp)
            showToast(icon: q.icon, title: "Mission erfüllt: \(q.title)", detail: "+\(q.xp) XP · +\(q.coins) Credits", color: "#2EE7B6")
            haptic(.success)
        }
        let dq = dailyQuests
        if dq.allSatisfy({ $0.claimed }) && !progress.questClaimed.contains("chest") {
            progress.questClaimed.append("chest")
            progress.chestsOpened += 1
            let bonus = 30 + Int.random(in: 0...40)
            progress.coins += bonus
            addXP(80)
            if Int.random(in: 0..<6) == 0 && progress.streakFreezes < 5 { progress.streakFreezes += 1 }
            celebrations.append(Celebration(kind: "chest", title: "Missions-Truhe", subtitle: "Alle Tagesmissionen erfüllt", detail: "+80 XP · +\(bonus) Credits", color: "#FFD35C", icon: "shippingbox.fill"))
        }
        for q in weeklyQuests where q.done && !q.claimed {
            progress.weekClaimed.append(q.id)
            progress.coins += q.coins
            addXP(q.xp)
            showToast(icon: "calendar.badge.checkmark", title: "Wochen-Challenge: \(q.title)", detail: "+\(q.xp) XP · +\(q.coins) Credits", color: "#B77DFF")
        }
    }

    // MARK: Shop

    func buyFreeze() -> Bool {
        let price = 150
        guard progress.coins >= price, progress.streakFreezes < 3 else { return false }
        progress.coins -= price
        progress.streakFreezes += 1
        progress.shopBought += 1
        haptic(.success)
        evaluateAchievements()
        save()
        return true
    }

    func buyBoost() -> Bool {
        let price = 200
        guard progress.coins >= price else { return false }
        progress.coins -= price
        let now = Date().timeIntervalSince1970
        progress.boostUntil = max(progress.boostUntil, now) + 30 * 60
        progress.shopBought += 1
        haptic(.success)
        evaluateAchievements()
        save()
        return true
    }

    func buyTheme(_ t: ShopTheme) -> Bool {
        if progress.ownedThemes.contains(t.id) { applyTheme(t.id); return true }
        guard progress.coins >= t.price else { return false }
        progress.coins -= t.price
        progress.ownedThemes.append(t.id)
        progress.shopBought += 1
        applyTheme(t.id)
        haptic(.success)
        evaluateAchievements()
        return true
    }

    // MARK: Erinnerungen

    func scheduleReminder() {
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: ["nima.daily"])
        guard progress.prefs.reminder else { return }
        let hour = progress.prefs.reminderHour, minute = progress.prefs.reminderMinute
        let due = totalDue
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, _ in
            guard granted else { return }
            let c = UNMutableNotificationContent()
            c.title = "Zeit für NIMA 🔥"
            c.body = due > 0 ? "\(due) Karten warten auf dich – halte deine Streak am Leben." : "Eine Lektion am Tag hält die Streak am Leben."
            c.sound = .default
            var dc = DateComponents()
            dc.hour = hour
            dc.minute = minute
            let req = UNNotificationRequest(identifier: "nima.daily", content: c, trigger: UNCalendarNotificationTrigger(dateMatching: dc, repeats: true))
            center.add(req)
        }
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

    // MARK: Empfehlung

    enum NextAction { case review(Int), lesson(Module, Int), weak(Int), vocab(Int), explore }

    var recommendation: NextAction {
        let due = totalDue
        if due >= 10 { return .review(due) }
        if let c = continueLesson, today.lessons < 2 { return .lesson(c.0, c.1) }
        if due > 0 { return .review(due) }
        let weak = leeches.count
        if weak >= 3 { return .weak(weak) }
        if vocabDue > 0 { return .vocab(vocabDue) }
        if let c = continueLesson { return .lesson(c.0, c.1) }
        return .explore
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

    var masteredCount: Int { progress.cards.filter { !$0.key.hasPrefix("term:") && $0.value.box >= 4 }.count }
    var lessonsReadCount: Int { progress.lessonsDone.count }
    var ownedModules: Int { progress.flags.keys.filter { $0.hasSuffix(":root") }.count }
    var activeDays: Int { progress.daily.values.filter { $0.activity > 0 }.count }

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

enum Theme {
    static var accentHex = "#9FEF00"
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
    // Lesen
    Achievement(id: "first_lesson", name: "Hello World", desc: "Erste Lektion gelesen", icon: "book.fill", coins: 10, color: "#2EE7B6") { $0.lessonsReadCount >= 1 },
    Achievement(id: "lessons_10", name: "Neugierig", desc: "10 Lektionen gelesen", icon: "book.pages.fill", coins: 20, color: "#2EE7B6") { $0.lessonsReadCount >= 10 },
    Achievement(id: "lessons_25", name: "Leseratte", desc: "25 Lektionen gelesen", icon: "books.vertical.fill", coins: 40, color: "#9FEF00") { $0.lessonsReadCount >= 25 },
    Achievement(id: "lessons_100", name: "Wissensdurst", desc: "100 Lektionen gelesen", icon: "brain.head.profile", coins: 120, color: "#4CC2FF") { $0.lessonsReadCount >= 100 },
    Achievement(id: "lessons_300", name: "Bibliothekar", desc: "300 Lektionen gelesen", icon: "building.columns.fill", coins: 300, color: "#FFD35C") { $0.lessonsReadCount >= 300 },
    Achievement(id: "lessons_750", name: "Archivar", desc: "750 Lektionen gelesen", icon: "archivebox.fill", coins: 600, color: "#B77DFF") { $0.lessonsReadCount >= 750 },
    Achievement(id: "lessons_1500", name: "Alexandria", desc: "1.500 Lektionen gelesen", icon: "globe.europe.africa.fill", coins: 1200, color: "#FF4FD8") { $0.lessonsReadCount >= 1500 },
    Achievement(id: "notes_5", name: "Mitschreiber", desc: "5 Notizen angelegt", icon: "square.and.pencil", coins: 30, color: "#FFD35C") { $0.progress.notes.count >= 5 },
    Achievement(id: "marks_10", name: "Eselsohren", desc: "10 Lektionen gemerkt", icon: "bookmark.fill", coins: 30, color: "#FFAF00") { $0.progress.lessonMarks.count >= 10 },
    // Antworten
    Achievement(id: "first_blood", name: "First Blood", desc: "Erste richtige Antwort", icon: "scope", coins: 10, color: "#FF4D5E") { $0.progress.totalCorrect >= 1 },
    Achievement(id: "ans_100", name: "Enumerator", desc: "100 Fragen beantwortet", icon: "magnifyingglass", coins: 25, color: "#D08B4F") { $0.progress.totalAnswered >= 100 },
    Achievement(id: "ans_500", name: "Persistence", desc: "500 Fragen beantwortet", icon: "arrow.triangle.2.circlepath", coins: 60, color: "#C9D4E8") { $0.progress.totalAnswered >= 500 },
    Achievement(id: "ans_2000", name: "APT", desc: "2.000 Fragen beantwortet", icon: "eye.fill", coins: 200, color: "#FFD35C") { $0.progress.totalAnswered >= 2000 },
    Achievement(id: "ans_5000", name: "Botnet", desc: "5.000 Fragen beantwortet", icon: "network", coins: 500, color: "#B77DFF") { $0.progress.totalAnswered >= 5000 },
    Achievement(id: "ans_10000", name: "Zero Day", desc: "10.000 Fragen beantwortet", icon: "bolt.shield.fill", coins: 1000, color: "#FF4FD8") { $0.progress.totalAnswered >= 10000 },
    Achievement(id: "acc_90", name: "Präzise", desc: "≥ 90 % Trefferquote bei 300+ Antworten", icon: "target", coins: 150, color: "#9FEF00") { $0.progress.totalAnswered >= 300 && Double($0.progress.totalCorrect) / Double($0.progress.totalAnswered) >= 0.9 },
    Achievement(id: "combo_10", name: "Combo x10", desc: "10 richtige in Folge", icon: "bolt.fill", coins: 20, color: "#FFAF00") { $0.progress.maxCombo >= 10 },
    Achievement(id: "combo_25", name: "Unstoppable", desc: "25 richtige in Folge", icon: "bolt.circle.fill", coins: 60, color: "#FF7A3D") { $0.progress.maxCombo >= 25 },
    Achievement(id: "combo_50", name: "God Mode", desc: "50 richtige in Folge", icon: "sparkles", coins: 150, color: "#C77DFF") { $0.progress.maxCombo >= 50 },
    Achievement(id: "combo_100", name: "Kernel Panic", desc: "100 richtige in Folge", icon: "cpu.fill", coins: 400, color: "#FF4D5E") { $0.progress.maxCombo >= 100 },
    Achievement(id: "typed_50", name: "Terminal Junkie", desc: "50 getippte Antworten richtig", icon: "terminal.fill", coins: 40, color: "#9FEF00") { $0.progress.typedCorrect >= 50 },
    Achievement(id: "typed_250", name: "Shell Wizard", desc: "250 getippte Antworten richtig", icon: "chevron.left.forwardslash.chevron.right", coins: 150, color: "#2EE7B6") { $0.progress.typedCorrect >= 250 },
    // Gedächtnis
    Achievement(id: "mastered_100", name: "Knowledge Base", desc: "100 Karten gemeistert", icon: "brain", coins: 80, color: "#2EE7B6") { $0.masteredCount >= 100 },
    Achievement(id: "mastered_500", name: "Langzeitgedächtnis", desc: "500 Karten gemeistert", icon: "brain.filled.head.profile", coins: 300, color: "#4CC2FF") { $0.masteredCount >= 500 },
    Achievement(id: "mastered_1500", name: "Photographic", desc: "1.500 Karten gemeistert", icon: "camera.aperture", coins: 800, color: "#FFD35C") { $0.masteredCount >= 1500 },
    Achievement(id: "leech_free", name: "Entwurmt", desc: "200+ Karten und keine Problemkarte", icon: "ladybug.fill", coins: 120, color: "#9FEF00") { $0.progress.cards.count >= 200 && $0.leeches.isEmpty },
    // Lexikon
    Achievement(id: "terms_50", name: "Wörterbuch", desc: "50 Fachbegriffe nachgeschlagen", icon: "character.book.closed.fill", coins: 40, color: "#B77DFF") { $0.progress.termsViewed.count >= 50 },
    Achievement(id: "terms_250", name: "Lexikon", desc: "250 Fachbegriffe nachgeschlagen", icon: "text.book.closed.fill", coins: 150, color: "#FFD35C") { $0.progress.termsViewed.count >= 250 },
    Achievement(id: "terms_600", name: "Enzyklopädie", desc: "600 Fachbegriffe nachgeschlagen", icon: "books.vertical.circle.fill", coins: 400, color: "#FF4FD8") { $0.progress.termsViewed.count >= 600 },
    Achievement(id: "vocab_50", name: "Fachsprache", desc: "50 Begriffe im Training richtig", icon: "textformat.abc", coins: 50, color: "#4CC2FF") { $0.progress.vocabCorrect >= 50 },
    Achievement(id: "vocab_m100", name: "Polyglott", desc: "100 Begriffe gemeistert", icon: "character.bubble.fill", coins: 200, color: "#B77DFF") { $0.vocabMastered >= 100 },
    // Streak & Gewohnheit
    Achievement(id: "streak_3", name: "On Fire", desc: "3 Tage Streak", icon: "flame", coins: 20, color: "#FFAF00") { $0.progress.bestStreak >= 3 },
    Achievement(id: "streak_7", name: "Wochen-Warrior", desc: "7 Tage Streak", icon: "flame.fill", coins: 60, color: "#FF7A3D") { $0.progress.bestStreak >= 7 },
    Achievement(id: "streak_30", name: "Habit Hacker", desc: "30 Tage Streak", icon: "flame.circle.fill", coins: 250, color: "#FF4D5E") { $0.progress.bestStreak >= 30 },
    Achievement(id: "streak_100", name: "Unaufhaltsam", desc: "100 Tage Streak", icon: "infinity", coins: 800, color: "#FF4FD8") { $0.progress.bestStreak >= 100 },
    Achievement(id: "freeze_used", name: "Eiskalt", desc: "Streak mit Freeze gerettet", icon: "snowflake", coins: 20, color: "#4CC2FF") { $0.progress.freezesUsed >= 1 },
    Achievement(id: "days_30", name: "Stammgast", desc: "An 30 Tagen gelernt", icon: "calendar", coins: 150, color: "#2EE7B6") { $0.activeDays >= 30 },
    Achievement(id: "night_owl", name: "Nachteule", desc: "Zwischen 0 und 5 Uhr gelernt", icon: "moon.stars.fill", coins: 25, color: "#B77DFF") { $0.progress.nightOwl },
    Achievement(id: "early_bird", name: "Frühaufsteher", desc: "Zwischen 5 und 7 Uhr gelernt", icon: "sunrise.fill", coins: 25, color: "#FFAF00") { $0.progress.earlyBird },
    // Missionen
    Achievement(id: "daily_box", name: "Daily Box", desc: "Erste Daily Box geknackt", icon: "shippingbox.fill", coins: 15, color: "#FFAF00") { !$0.progress.dailyBoxDay.isEmpty },
    Achievement(id: "chest_1", name: "Missionar", desc: "Erste Missions-Truhe geöffnet", icon: "gift.fill", coins: 20, color: "#FFD35C") { $0.progress.chestsOpened >= 1 },
    Achievement(id: "chest_25", name: "Auftragskiller", desc: "25 Missions-Truhen", icon: "gift.circle.fill", coins: 250, color: "#FF4FD8") { $0.progress.chestsOpened >= 25 },
    Achievement(id: "checks_10", name: "Selbstkontrolle", desc: "10 Wissens-Checks fehlerfrei", icon: "checklist.checked", coins: 50, color: "#2EE7B6") { $0.progress.checksPassed >= 10 },
    Achievement(id: "checks_100", name: "Musterschüler", desc: "100 Wissens-Checks fehlerfrei", icon: "graduationcap.fill", coins: 300, color: "#FFD35C") { $0.progress.checksPassed >= 100 },
    Achievement(id: "perfect_5", name: "Fehlerfrei", desc: "5 Sessions mit 100 % (≥ 10 Fragen)", icon: "checkmark.seal.fill", coins: 80, color: "#9FEF00") { $0.progress.perfectSessions >= 5 },
    // Flags & Prüfungen
    Achievement(id: "flag_user", name: "Foothold", desc: "Erste User-Flag", icon: "flag.fill", coins: 25, color: "#9FEF00") { $0.progress.flags.keys.contains { $0.hasSuffix(":user") } },
    Achievement(id: "flag_root", name: "Rooted", desc: "Erstes Modul owned", icon: "crown.fill", coins: 60, color: "#FF4D5E") { $0.ownedModules >= 1 },
    Achievement(id: "owned_10", name: "Box Collector", desc: "10 Module owned", icon: "square.stack.3d.up.fill", coins: 200, color: "#FFD35C") { $0.ownedModules >= 10 },
    Achievement(id: "owned_50", name: "Domain Admin", desc: "50 Module owned", icon: "server.rack", coins: 600, color: "#C77DFF") { $0.ownedModules >= 50 },
    Achievement(id: "owned_150", name: "Enterprise Admin", desc: "150 Module owned", icon: "building.2.fill", coins: 1200, color: "#FF4FD8") { $0.ownedModules >= 150 },
    Achievement(id: "exam_1", name: "Certified", desc: "Erste Prüfung bestanden", icon: "rosette", coins: 50, color: "#4CC2FF") { $0.progress.exams.contains { $0.passed } },
    Achievement(id: "exam_10", name: "Prüfungsprofi", desc: "10 Prüfungen bestanden", icon: "medal", coins: 200, color: "#FFD35C") { $0.progress.exams.filter { $0.passed }.count >= 10 },
    Achievement(id: "exam_perfect", name: "Flawless", desc: "Prüfung mit 100 %", icon: "medal.fill", coins: 150, color: "#FFD35C") { $0.progress.exams.contains { $0.score >= 1 && $0.total >= 10 } },
    Achievement(id: "cert_1", name: "Zertifiziert", desc: "Erstes NIMA-Pfadzertifikat", icon: "scroll.fill", coins: 150, color: "#2EE7B6") { !$0.progress.pathCerts.isEmpty },
    Achievement(id: "cert_5", name: "Zertifikatssammler", desc: "5 Pfadzertifikate", icon: "rosette", coins: 600, color: "#FF4FD8") { $0.progress.pathCerts.count >= 5 },
    // Modi
    Achievement(id: "blitz_15", name: "Speed Demon", desc: "15 richtige in einem Blitz", icon: "hare.fill", coins: 40, color: "#FFAF00") { $0.progress.blitzBest >= 15 },
    Achievement(id: "blitz_30", name: "Lichtgeschwindigkeit", desc: "30 richtige in einem Blitz", icon: "bolt.horizontal.fill", coins: 150, color: "#4CC2FF") { $0.progress.blitzBest >= 30 },
    Achievement(id: "survival_20", name: "Überlebender", desc: "20 Fragen im Survival", icon: "heart.fill", coins: 60, color: "#FF4D5E") { $0.progress.survivalBest >= 20 },
    Achievement(id: "survival_75", name: "Unverwundbar", desc: "75 Fragen im Survival", icon: "heart.circle.fill", coins: 300, color: "#FF4FD8") { $0.progress.survivalBest >= 75 },
    // Level & Skill
    Achievement(id: "level_10", name: "Aufsteiger", desc: "Level 10 erreicht", icon: "chart.line.uptrend.xyaxis", coins: 100, color: "#9FEF00") { $0.level >= 10 },
    Achievement(id: "level_25", name: "Veteran", desc: "Level 25 erreicht", icon: "star.circle.fill", coins: 300, color: "#B77DFF") { $0.level >= 25 },
    Achievement(id: "level_50", name: "Halbgott", desc: "Level 50 erreicht", icon: "star.square.fill", coins: 800, color: "#FFD35C") { $0.level >= 50 },
    Achievement(id: "skill_gold", name: "Goldstandard", desc: "Skill-Liga Gold erreicht", icon: "shield.fill", coins: 100, color: "#FFD35C") { $0.overallSkill >= 1100 },
    Achievement(id: "skill_diamond", name: "Diamantenhart", desc: "Skill-Liga Diamant erreicht", icon: "diamond.fill", coins: 400, color: "#4CC2FF") { $0.overallSkill >= 1400 },
    Achievement(id: "skill_master", name: "Meisterklasse", desc: "Skill-Liga Master erreicht", icon: "crown.fill", coins: 800, color: "#B77DFF") { $0.overallSkill >= 1550 },
    // Shop
    Achievement(id: "shop_1", name: "Kunde", desc: "Erster Einkauf im Shop", icon: "cart.fill", coins: 10, color: "#2EE7B6") { $0.progress.shopBought >= 1 },
    Achievement(id: "theme_3", name: "Stilbewusst", desc: "3 Farbthemen besessen", icon: "paintpalette.fill", coins: 100, color: "#FF4FD8") { $0.progress.ownedThemes.count >= 3 },
]
