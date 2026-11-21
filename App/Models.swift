import Foundation

// MARK: - Content (aus content.json, erzeugt von tools/build_content.py)

struct ContentBundle: Decodable {
    let version: String
    let stats: ContentStats
    let paths: [LPath]
    let modules: [Module]
    let glossary: [Term]
}

struct ContentStats: Decodable {
    let modules: Int
    let lessons: Int
    let questions: Int
    let terms: Int
    let words: Int
    let images: Int
    let paths: Int
}

struct LPath: Decodable, Identifiable, Hashable {
    let id: String
    let title: String
    let subtitle: String
    let cert: String
    let kind: String
    let color: String
    let icon: String
    let description: String
    let modules: [String]

    static func == (a: LPath, b: LPath) -> Bool { a.id == b.id }
    func hash(into h: inout Hasher) { h.combine(id) }
}

struct Module: Decodable, Identifiable, Hashable {
    let id: String
    let title: String
    let summary: String
    let icon: String
    let difficulty: String
    let minutes: Int
    let paths: [String]
    let order: Double
    let tags: [String]
    let source: String
    let lessons: [Lesson]
    let quiz: [Question]
    let words: Int

    static func == (a: Module, b: Module) -> Bool { a.id == b.id }
    func hash(into h: inout Hasher) { h.combine(id) }
}

struct Lesson: Decodable, Identifiable, Hashable {
    let id: String
    let title: String
    let blocks: [Block]

    static func == (a: Lesson, b: Lesson) -> Bool { a.id == b.id }
    func hash(into h: inout Hasher) { h.combine(id) }
}

struct Block: Decodable, Hashable {
    let t: String
    let text: String?
    let items: [String]?
    let rows: [[String]]?
    let kind: String?
    let title: String?
    let src: String?
    let lang: String?
}

struct Question: Decodable, Identifiable, Hashable {
    let id: String
    let type: String
    let q: String
    let code: String?
    let options: [String]?
    let correct: [Int]?
    let answers: [String]?
    let value: Bool?
    let order: [String]?
    let explain: String?
    let hint: String?
    let difficulty: String?
    let caseSensitive: Bool?

    static func == (a: Question, b: Question) -> Bool { a.id == b.id }
    func hash(into h: inout Hasher) { h.combine(id) }

    var typeLabel: String {
        switch type {
        case "mc": return "Multiple Choice"
        case "multi": return "Mehrfachauswahl"
        case "input": return "Terminal"
        case "tf": return "Wahr / Falsch"
        case "order": return "Reihenfolge"
        default: return type
        }
    }

    var displayAnswer: String {
        switch type {
        case "input": return (answers ?? []).first(where: { !$0.lowercased().hasPrefix("re:") }) ?? (answers?.first ?? "")
        case "tf": return (value ?? false) ? "Wahr" : "Falsch"
        case "mc", "multi": return (correct ?? []).compactMap { i in options.flatMap { i < $0.count ? $0[i] : nil } }.joined(separator: " · ")
        case "order": return (order ?? []).enumerated().map { "\($0.offset + 1). \($0.element)" }.joined(separator: "  →  ")
        default: return ""
        }
    }
}

struct Term: Decodable, Identifiable, Hashable {
    let id: String
    let term: String
    let aka: [String]
    let cat: String
    let short: String
    let text: [String]
    let see: [String]
    let modules: [String]

    static func == (a: Term, b: Term) -> Bool { a.id == b.id }
    func hash(into h: inout Hasher) { h.combine(id) }
}

// MARK: - Fortschritt (Documents/progress.json)

struct CardState: Codable {
    var box: Int = 0
    var due: Double = 0
    var seen: Int = 0
    var right: Int = 0
    var wrong: Int = 0
}

struct DayStat: Codable {
    var answered: Int = 0
    var correct: Int = 0
    var xp: Int = 0
    var lessons: Int = 0
    var seconds: Int = 0
}

struct ExamRecord: Codable, Identifiable {
    var id: UUID = UUID()
    var date: Date = Date()
    var title: String = ""
    var score: Double = 0
    var correct: Int = 0
    var total: Int = 0
    var passed: Bool = false
}

struct Progress: Codable {
    var name: String = "Operator"
    var xp: Int = 0
    var coins: Int = 50
    var lessonsDone: [String: Double] = [:]
    var cards: [String: CardState] = [:]
    var daily: [String: DayStat] = [:]
    var streak: Int = 0
    var bestStreak: Int = 0
    var lastGoalDay: String = ""
    var achievements: [String: Double] = [:]
    var exams: [ExamRecord] = []
    var bookmarks: [String] = []
    var lastLesson: String = ""
    var maxCombo: Int = 0
    var totalAnswered: Int = 0
    var totalCorrect: Int = 0
    var typedCorrect: Int = 0
    var blitzBest: Int = 0
    var flags: [String: Double] = [:]
    var dailyGoal: Int = 20
    var haptics: Bool = true
    var termsViewed: [String: Double] = [:]
    var dailyBoxDay: String = ""

    init() {}

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        let d = Progress()
        name = try c.decodeIfPresent(String.self, forKey: .name) ?? d.name
        xp = try c.decodeIfPresent(Int.self, forKey: .xp) ?? d.xp
        coins = try c.decodeIfPresent(Int.self, forKey: .coins) ?? d.coins
        lessonsDone = try c.decodeIfPresent([String: Double].self, forKey: .lessonsDone) ?? [:]
        cards = try c.decodeIfPresent([String: CardState].self, forKey: .cards) ?? [:]
        daily = try c.decodeIfPresent([String: DayStat].self, forKey: .daily) ?? [:]
        streak = try c.decodeIfPresent(Int.self, forKey: .streak) ?? 0
        bestStreak = try c.decodeIfPresent(Int.self, forKey: .bestStreak) ?? 0
        lastGoalDay = try c.decodeIfPresent(String.self, forKey: .lastGoalDay) ?? ""
        achievements = try c.decodeIfPresent([String: Double].self, forKey: .achievements) ?? [:]
        exams = try c.decodeIfPresent([ExamRecord].self, forKey: .exams) ?? []
        bookmarks = try c.decodeIfPresent([String].self, forKey: .bookmarks) ?? []
        lastLesson = try c.decodeIfPresent(String.self, forKey: .lastLesson) ?? ""
        maxCombo = try c.decodeIfPresent(Int.self, forKey: .maxCombo) ?? 0
        totalAnswered = try c.decodeIfPresent(Int.self, forKey: .totalAnswered) ?? 0
        totalCorrect = try c.decodeIfPresent(Int.self, forKey: .totalCorrect) ?? 0
        typedCorrect = try c.decodeIfPresent(Int.self, forKey: .typedCorrect) ?? 0
        blitzBest = try c.decodeIfPresent(Int.self, forKey: .blitzBest) ?? 0
        flags = try c.decodeIfPresent([String: Double].self, forKey: .flags) ?? [:]
        dailyGoal = try c.decodeIfPresent(Int.self, forKey: .dailyGoal) ?? d.dailyGoal
        haptics = try c.decodeIfPresent(Bool.self, forKey: .haptics) ?? true
        termsViewed = try c.decodeIfPresent([String: Double].self, forKey: .termsViewed) ?? [:]
        dailyBoxDay = try c.decodeIfPresent(String.self, forKey: .dailyBoxDay) ?? ""
    }
}

// MARK: - Ränge & Achievements

struct Rank {
    let name: String
    let level: Int
    let color: String
    let tier: Int
}

let RANKS: [Rank] = [
    Rank(name: "Noob", level: 1, color: "#A4B1CD", tier: 1),
    Rank(name: "Script Kiddie", level: 4, color: "#2EE7B6", tier: 2),
    Rank(name: "Hacker", level: 9, color: "#9FEF00", tier: 3),
    Rank(name: "Pro Hacker", level: 16, color: "#4CC2FF", tier: 4),
    Rank(name: "Elite Hacker", level: 25, color: "#B77DFF", tier: 5),
    Rank(name: "Guru", level: 35, color: "#FFAF00", tier: 6),
    Rank(name: "Omniscient", level: 50, color: "#FF4D5E", tier: 7),
]

struct Achievement: Identifiable {
    let id: String
    let name: String
    let desc: String
    let icon: String
    let coins: Int
    let color: String
    let check: (Store) -> Bool
}
