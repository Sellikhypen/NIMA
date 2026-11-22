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
    let level: String?
    let blocks: [Block]

    static func == (a: Lesson, b: Lesson) -> Bool { a.id == b.id }
    func hash(into h: inout Hasher) { h.combine(id) }

    /// intro = einfacher Einstieg, core = Kern, deep = Vertiefung
    var stage: String { level ?? "core" }

    var wordCount: Int {
        var n = 0
        for b in blocks {
            n += (b.text ?? "").split(separator: " ").count
            for it in b.items ?? [] { n += it.split(separator: " ").count }
            for r in b.rows ?? [] { n += r.joined(separator: " ").split(separator: " ").count }
        }
        return n
    }

    var readMinutes: Int { max(1, Int((Double(wordCount) / 170.0).rounded())) }

    /// Kernaussagen (Merke-/Prüfungs-Boxen) für Zusammenfassungen
    var keyPoints: [String] {
        blocks.filter { $0.t == "callout" && ["merke", "exam", "ergebnis", "definition"].contains($0.kind ?? "") }
            .flatMap { b -> [String] in
                let items = (b.items ?? []).map { $0.hasPrefix("- ") ? String($0.dropFirst(2)) : $0 }
                if let t = b.title, !t.isEmpty, items.count == 1 { return ["**\(t):** " + items[0]] }
                return items
            }
    }
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
    /// Index der passendsten Lektion im Modul (vom Compiler berechnet)
    let lesson: Int?
    /// Kontextsatz aus der Lektion
    let ctx: String?

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

    var isTyped: Bool { type == "input" || type == "order" }

    /// Elo-Schwierigkeit für das Skill-Rating
    var rating: Double {
        switch difficulty ?? "medium" {
        case "easy": return 850
        case "hard": return 1550
        case "insane": return 1900
        default: return 1200
        }
    }

    /// Erzeugte Frage (Begriffe-Training)
    static func make(id: String, type: String, q: String, options: [String]? = nil, correct: [Int]? = nil, answers: [String]? = nil,
                     explain: String? = nil, hint: String? = nil, difficulty: String = "easy") -> Question {
        Question(id: id, type: type, q: q, code: nil, options: options, correct: correct, answers: answers, value: nil, order: nil,
                 explain: explain, hint: hint, difficulty: difficulty, caseSensitive: false, lesson: nil, ctx: nil)
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

// MARK: - Tolerantes Dekodieren (alte Spielstände bleiben gültig)

extension KeyedDecodingContainer {
    func v<T: Decodable>(_ key: Key, _ fallback: T) -> T {
        (try? decodeIfPresent(T.self, forKey: key)) ?? fallback
    }
}

// MARK: - Fortschritt (Documents/progress.json)

struct CardState: Codable {
    var box: Int = 0          // Meisterungsstufe 0…7 (≥ 4 = gemeistert)
    var due: Double = 0
    var seen: Int = 0
    var right: Int = 0
    var wrong: Int = 0
    var ease: Double = 2.5    // SM-2-Faktor
    var interval: Double = 0  // Tage
    var lapses: Int = 0       // wie oft vergessen
    var last: Double = 0      // letzte Wiederholung
    var streak: Int = 0       // richtige in Folge

    init() {}

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        box = c.v(.box, 0)
        due = c.v(.due, 0)
        seen = c.v(.seen, 0)
        right = c.v(.right, 0)
        wrong = c.v(.wrong, 0)
        ease = c.v(.ease, 2.5)
        lapses = c.v(.lapses, wrong > 0 ? min(wrong, 3) : 0)
        last = c.v(.last, 0)
        streak = c.v(.streak, 0)
        // Migration: altes Leitner-System -> Intervall aus der Box ableiten
        let legacy: [Double] = [0, 0.17, 1, 3, 7, 16, 35, 90]
        interval = c.v(.interval, legacy[max(0, min(box, legacy.count - 1))])
    }

    var isLeech: Bool { lapses >= 4 && Double(right) / Double(max(seen, 1)) < 0.6 }
    var mastered: Bool { box >= 4 }
}

struct DayStat: Codable {
    var answered: Int = 0
    var correct: Int = 0
    var xp: Int = 0
    var lessons: Int = 0
    var seconds: Int = 0
    var maxCombo: Int = 0
    var terms: Int = 0
    var reviews: Int = 0
    var blitz: Int = 0
    var exams: Int = 0
    var vocab: Int = 0
    var checks: Int = 0
    var readSeconds: Int = 0

    init() {}

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        answered = c.v(.answered, 0)
        correct = c.v(.correct, 0)
        xp = c.v(.xp, 0)
        lessons = c.v(.lessons, 0)
        seconds = c.v(.seconds, 0)
        maxCombo = c.v(.maxCombo, 0)
        terms = c.v(.terms, 0)
        reviews = c.v(.reviews, 0)
        blitz = c.v(.blitz, 0)
        exams = c.v(.exams, 0)
        vocab = c.v(.vocab, 0)
        checks = c.v(.checks, 0)
        readSeconds = c.v(.readSeconds, 0)
    }

    var activity: Int { answered + lessons * 3 }
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

/// Einstellungen
struct Prefs: Codable, Equatable {
    var readScale: Double = 1.0
    var sessionSize: Int = 15
    var newPerSession: Int = 6
    var srsFactor: Double = 1.0
    var examPass: Double = 0.8
    var examSeconds: Int = 75
    var typoTolerance: Bool = true
    var showContext: Bool = true
    var showHints: Bool = true
    var autoNext: Bool = false
    var confetti: Bool = true
    var reminder: Bool = false
    var reminderHour: Int = 19
    var reminderMinute: Int = 0
    var accent: String = "matrix"
    var lessonChecks: Bool = true
    var shuffleOptions: Bool = true
    var simpleFirst: Bool = true

    init() {}

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        let d = Prefs()
        readScale = c.v(.readScale, d.readScale)
        sessionSize = c.v(.sessionSize, d.sessionSize)
        newPerSession = c.v(.newPerSession, d.newPerSession)
        srsFactor = c.v(.srsFactor, d.srsFactor)
        examPass = c.v(.examPass, d.examPass)
        examSeconds = c.v(.examSeconds, d.examSeconds)
        typoTolerance = c.v(.typoTolerance, d.typoTolerance)
        showContext = c.v(.showContext, d.showContext)
        showHints = c.v(.showHints, d.showHints)
        autoNext = c.v(.autoNext, d.autoNext)
        confetti = c.v(.confetti, d.confetti)
        reminder = c.v(.reminder, d.reminder)
        reminderHour = c.v(.reminderHour, d.reminderHour)
        reminderMinute = c.v(.reminderMinute, d.reminderMinute)
        accent = c.v(.accent, d.accent)
        lessonChecks = c.v(.lessonChecks, d.lessonChecks)
        shuffleOptions = c.v(.shuffleOptions, d.shuffleOptions)
        simpleFirst = c.v(.simpleFirst, d.simpleFirst)
    }
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
    // neu
    var prefs = Prefs()
    var onboarded: Bool = false
    var experience: String = "start"
    var skill: [String: Double] = [:]
    var skillN: [String: Int] = [:]
    var questDay: String = ""
    var questClaimed: [String] = []
    var weekKey: String = ""
    var weekClaimed: [String] = []
    var streakFreezes: Int = 0
    var freezesUsed: Int = 0
    var boostUntil: Double = 0
    var ownedThemes: [String] = ["matrix"]
    var notes: [String: String] = [:]
    var lessonMarks: [String] = []
    var survivalBest: Int = 0
    var vocabCorrect: Int = 0
    var planPath: String = ""
    var planDate: Double = 0
    var checksPassed: Int = 0
    var perfectSessions: Int = 0
    var pathCerts: [String: Double] = [:]
    var chestsOpened: Int = 0
    var shopBought: Int = 0
    var nightOwl: Bool = false
    var earlyBird: Bool = false

    init() {}

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        let d = Progress()
        name = c.v(.name, d.name)
        xp = c.v(.xp, 0)
        coins = c.v(.coins, d.coins)
        lessonsDone = c.v(.lessonsDone, [:])
        cards = c.v(.cards, [:])
        daily = c.v(.daily, [:])
        streak = c.v(.streak, 0)
        bestStreak = c.v(.bestStreak, 0)
        lastGoalDay = c.v(.lastGoalDay, "")
        achievements = c.v(.achievements, [:])
        exams = c.v(.exams, [])
        bookmarks = c.v(.bookmarks, [])
        lastLesson = c.v(.lastLesson, "")
        maxCombo = c.v(.maxCombo, 0)
        totalAnswered = c.v(.totalAnswered, 0)
        totalCorrect = c.v(.totalCorrect, 0)
        typedCorrect = c.v(.typedCorrect, 0)
        blitzBest = c.v(.blitzBest, 0)
        flags = c.v(.flags, [:])
        dailyGoal = c.v(.dailyGoal, d.dailyGoal)
        haptics = c.v(.haptics, true)
        termsViewed = c.v(.termsViewed, [:])
        dailyBoxDay = c.v(.dailyBoxDay, "")
        prefs = c.v(.prefs, Prefs())
        // Bestehende Nutzer müssen das Onboarding nicht erneut durchlaufen
        onboarded = c.v(.onboarded, xp > 0 || !lessonsDone.isEmpty)
        experience = c.v(.experience, "start")
        skill = c.v(.skill, [:])
        skillN = c.v(.skillN, [:])
        questDay = c.v(.questDay, "")
        questClaimed = c.v(.questClaimed, [])
        weekKey = c.v(.weekKey, "")
        weekClaimed = c.v(.weekClaimed, [])
        streakFreezes = c.v(.streakFreezes, 0)
        freezesUsed = c.v(.freezesUsed, 0)
        boostUntil = c.v(.boostUntil, 0)
        ownedThemes = c.v(.ownedThemes, ["matrix"])
        notes = c.v(.notes, [:])
        lessonMarks = c.v(.lessonMarks, [])
        survivalBest = c.v(.survivalBest, 0)
        vocabCorrect = c.v(.vocabCorrect, 0)
        planPath = c.v(.planPath, "")
        planDate = c.v(.planDate, 0)
        checksPassed = c.v(.checksPassed, 0)
        perfectSessions = c.v(.perfectSessions, 0)
        pathCerts = c.v(.pathCerts, [:])
        chestsOpened = c.v(.chestsOpened, 0)
        shopBought = c.v(.shopBought, 0)
        nightOwl = c.v(.nightOwl, false)
        earlyBird = c.v(.earlyBird, false)
    }
}

// MARK: - Ränge (XP = Fleiß) & Skill-Ligen (Elo = Können)

struct Rank {
    let name: String
    let level: Int
    let color: String
    let tier: Int
    let motto: String
}

let RANKS: [Rank] = [
    Rank(name: "Noob", level: 1, color: "#A4B1CD", tier: 1, motto: "Jeder Profi hat hier angefangen."),
    Rank(name: "Script Kiddie", level: 3, color: "#7FD8C2", tier: 2, motto: "Du kennst die ersten Werkzeuge."),
    Rank(name: "Lab Rat", level: 6, color: "#2EE7B6", tier: 3, motto: "Du lebst im Labor."),
    Rank(name: "Hacker", level: 9, color: "#9FEF00", tier: 4, motto: "Grundlagen sitzen."),
    Rank(name: "Analyst", level: 13, color: "#6FE36B", tier: 5, motto: "Du liest Logs wie Zeitung."),
    Rank(name: "Pentester", level: 17, color: "#4CC2FF", tier: 6, motto: "Methodik statt Glück."),
    Rank(name: "Pro Hacker", level: 22, color: "#3E8BFF", tier: 7, motto: "Du kombinierst Techniken."),
    Rank(name: "Red Teamer", level: 27, color: "#FF6B6B", tier: 8, motto: "Ganze Organisationen im Blick."),
    Rank(name: "Elite Hacker", level: 33, color: "#B77DFF", tier: 9, motto: "Tiefes Verständnis."),
    Rank(name: "Threat Hunter", level: 40, color: "#D36BFF", tier: 10, motto: "Du findest, was andere übersehen."),
    Rank(name: "Guru", level: 48, color: "#FFAF00", tier: 11, motto: "Andere fragen dich."),
    Rank(name: "Cyber Sage", level: 57, color: "#FFD35C", tier: 12, motto: "Wissen in der Breite und Tiefe."),
    Rank(name: "Omniscient", level: 67, color: "#FF4D5E", tier: 13, motto: "Kaum ein Thema ist dir fremd."),
    Rank(name: "Legend", level: 80, color: "#FF4FD8", tier: 14, motto: "Man erzählt sich von dir."),
    Rank(name: "Root of All", level: 100, color: "#FFFFFF", tier: 15, motto: "uid=0 – du hast alles gesehen."),
]

struct SkillTier {
    let name: String
    let min: Double
    let color: String
    let icon: String
}

let SKILL_TIERS: [SkillTier] = [
    SkillTier(name: "Bronze", min: 0, color: "#C98B5B", icon: "shield"),
    SkillTier(name: "Silber", min: 950, color: "#C9D4E8", icon: "shield.lefthalf.filled"),
    SkillTier(name: "Gold", min: 1100, color: "#FFD35C", icon: "shield.fill"),
    SkillTier(name: "Platin", min: 1250, color: "#2EE7B6", icon: "checkmark.shield.fill"),
    SkillTier(name: "Diamant", min: 1400, color: "#4CC2FF", icon: "diamond.fill"),
    SkillTier(name: "Master", min: 1550, color: "#B77DFF", icon: "crown.fill"),
    SkillTier(name: "Grandmaster", min: 1750, color: "#FF4D5E", icon: "flame.fill"),
]

func skillTier(_ r: Double) -> SkillTier {
    var t = SKILL_TIERS[0]
    for s in SKILL_TIERS where r >= s.min { t = s }
    return t
}

struct Achievement: Identifiable {
    let id: String
    let name: String
    let desc: String
    let icon: String
    let coins: Int
    let color: String
    let check: (Store) -> Bool
}
