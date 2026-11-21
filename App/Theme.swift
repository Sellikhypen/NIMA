import SwiftUI

extension Color {
    init(hex: String) {
        var s = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        if s.hasPrefix("#") { s.removeFirst() }
        var v: UInt64 = 0
        Scanner(string: s).scanHexInt64(&v)
        self.init(red: Double((v >> 16) & 0xFF) / 255, green: Double((v >> 8) & 0xFF) / 255, blue: Double(v & 0xFF) / 255)
    }
}

enum NT {
    static let bg = Color(hex: "#070B12")
    static let bg2 = Color(hex: "#0C121C")
    static let panel = Color(hex: "#121B28")
    static let panel2 = Color(hex: "#182436")
    static let line = Color.white.opacity(0.08)
    static let tx = Color(hex: "#E8EEF8")
    static let tx2 = Color(hex: "#A4B1CD")
    static let tx3 = Color(hex: "#66738E")
    static let acc = Color(hex: "#9FEF00")
    static let red = Color(hex: "#FF4D5E")
    static let orange = Color(hex: "#FFAF00")
    static let blue = Color(hex: "#4CC2FF")
    static let purple = Color(hex: "#B77DFF")
    static let teal = Color(hex: "#2EE7B6")
    static let gold = Color(hex: "#FFD35C")

    static func diff(_ d: String) -> Color {
        switch d {
        case "easy": return acc
        case "hard": return red
        case "insane": return Color(hex: "#C77DFF")
        default: return orange
        }
    }
    static func diffLabel(_ d: String) -> String {
        switch d { case "easy": return "Easy"; case "hard": return "Hard"; case "insane": return "Insane"; default: return "Medium" }
    }
    static func mono(_ size: CGFloat, _ w: Font.Weight = .semibold) -> Font { .system(size: size, weight: w, design: .monospaced) }
}

struct AppBackground: View {
    var body: some View {
        ZStack {
            NT.bg.ignoresSafeArea()
            RadialGradient(colors: [NT.acc.opacity(0.13), .clear], center: .topLeading, startRadius: 0, endRadius: 420).ignoresSafeArea()
            RadialGradient(colors: [NT.teal.opacity(0.07), .clear], center: .bottomTrailing, startRadius: 0, endRadius: 380).ignoresSafeArea()
            GridPattern().stroke(NT.acc.opacity(0.035), lineWidth: 1).ignoresSafeArea()
        }
    }
}

struct GridPattern: Shape {
    func path(in rect: CGRect) -> Path {
        var p = Path()
        let step: CGFloat = 36
        var x: CGFloat = 0
        while x < rect.width { p.move(to: CGPoint(x: x, y: 0)); p.addLine(to: CGPoint(x: x, y: rect.height)); x += step }
        var y: CGFloat = 0
        while y < rect.height { p.move(to: CGPoint(x: 0, y: y)); p.addLine(to: CGPoint(x: rect.width, y: y)); y += step }
        return p
    }
}

struct CardModifier: ViewModifier {
    var padding: CGFloat = 16
    var glow: Color? = nil
    func body(content: Content) -> some View {
        content
            .padding(padding)
            .background(RoundedRectangle(cornerRadius: 18, style: .continuous).fill(NT.panel.opacity(0.92)))
            .overlay(RoundedRectangle(cornerRadius: 18, style: .continuous).stroke(glow?.opacity(0.35) ?? NT.line, lineWidth: 1))
            .shadow(color: (glow ?? .clear).opacity(0.18), radius: 14, y: 6)
    }
}

extension View {
    func card(padding: CGFloat = 16, glow: Color? = nil) -> some View { modifier(CardModifier(padding: padding, glow: glow)) }
}

struct SectionHeader: View {
    let title: String
    var trailing: String? = nil
    var body: some View {
        HStack(spacing: 8) {
            Rectangle().fill(NT.acc).frame(width: 7, height: 7).rotationEffect(.degrees(45)).shadow(color: NT.acc, radius: 5)
            Text(title.uppercased()).font(NT.mono(12, .bold)).tracking(1.6).foregroundStyle(NT.tx2)
            Spacer()
            if let t = trailing { Text(t).font(NT.mono(11)).foregroundStyle(NT.tx3) }
        }
        .padding(.top, 6)
    }
}

struct ProgressRing: View {
    let value: Double
    var color: Color = NT.acc
    var size: CGFloat = 54
    var line: CGFloat = 6
    var label: String? = nil
    var sub: String? = nil
    var body: some View {
        ZStack {
            Circle().stroke(Color.white.opacity(0.08), lineWidth: line)
            Circle().trim(from: 0, to: max(0.001, min(1, value)))
                .stroke(color, style: StrokeStyle(lineWidth: line, lineCap: .round))
                .rotationEffect(.degrees(-90))
                .shadow(color: color.opacity(0.6), radius: 4)
            VStack(spacing: 1) {
                Text(label ?? "\(Int((value * 100).rounded()))%").font(NT.mono(size * 0.24, .heavy)).foregroundStyle(NT.tx)
                if let s = sub { Text(s).font(NT.mono(size * 0.13)).foregroundStyle(NT.tx3) }
            }
        }
        .frame(width: size, height: size)
        .animation(.easeOut(duration: 0.8), value: value)
    }
}

struct BarView: View {
    let value: Double
    var color: Color = NT.acc
    var height: CGFloat = 6
    var body: some View {
        GeometryReader { g in
            ZStack(alignment: .leading) {
                Capsule().fill(Color.white.opacity(0.08))
                Capsule().fill(LinearGradient(colors: [color.opacity(0.55), color], startPoint: .leading, endPoint: .trailing))
                    .frame(width: max(0, g.size.width * min(1, value)))
                    .shadow(color: color.opacity(0.6), radius: 4)
            }
        }
        .frame(height: height)
        .animation(.easeOut(duration: 0.6), value: value)
    }
}

struct Pill: View {
    let text: String
    var color: Color = NT.acc
    var body: some View {
        Text(text.uppercased())
            .font(NT.mono(10, .bold))
            .tracking(0.6)
            .padding(.horizontal, 8).padding(.vertical, 3)
            .foregroundStyle(color)
            .background(Capsule().fill(color.opacity(0.1)))
            .overlay(Capsule().stroke(color.opacity(0.7), lineWidth: 1))
    }
}

struct Hexagon: Shape {
    func path(in r: CGRect) -> Path {
        var p = Path()
        let w = r.width, h = r.height
        p.move(to: CGPoint(x: w / 2, y: 0))
        p.addLine(to: CGPoint(x: w, y: h * 0.25))
        p.addLine(to: CGPoint(x: w, y: h * 0.75))
        p.addLine(to: CGPoint(x: w / 2, y: h))
        p.addLine(to: CGPoint(x: 0, y: h * 0.75))
        p.addLine(to: CGPoint(x: 0, y: h * 0.25))
        p.closeSubpath()
        return p
    }
}

struct RankBadge: View {
    let index: Int
    var size: CGFloat = 60
    var body: some View {
        let r = RANKS[max(0, min(RANKS.count - 1, index))]
        let c = Color(hex: r.color)
        ZStack {
            Hexagon().fill(LinearGradient(colors: [c.opacity(0.45), Color.black.opacity(0.9)], startPoint: .topLeading, endPoint: .bottomTrailing))
            Hexagon().stroke(c, lineWidth: size * 0.045)
            Hexagon().stroke(c.opacity(0.3), lineWidth: 1).padding(size * 0.12)
            VStack(spacing: -size * 0.1) {
                if r.tier >= 5 { Image(systemName: "star.fill").font(.system(size: size * 0.16)).foregroundStyle(c).padding(.bottom, size * 0.04) }
                ForEach(0..<min(r.tier, 4), id: \.self) { _ in
                    Image(systemName: "chevron.up").font(.system(size: size * 0.2, weight: .heavy)).foregroundStyle(c)
                }
            }
        }
        .frame(width: size, height: size * 1.1)
        .shadow(color: c.opacity(0.55), radius: size * 0.15)
    }
}

struct IconTile: View {
    let icon: String
    var color: Color = NT.acc
    var size: CGFloat = 44
    var body: some View {
        Image(systemName: icon)
            .font(.system(size: size * 0.42, weight: .semibold))
            .foregroundStyle(color)
            .frame(width: size, height: size)
            .background(RoundedRectangle(cornerRadius: size * 0.28, style: .continuous).fill(color.opacity(0.12)))
            .overlay(RoundedRectangle(cornerRadius: size * 0.28, style: .continuous).stroke(color.opacity(0.3), lineWidth: 1))
    }
}

struct PrimaryButtonStyle: ButtonStyle {
    var color: Color = NT.acc
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 16, weight: .bold))
            .foregroundStyle(Color.black.opacity(0.85))
            .padding(.vertical, 14).padding(.horizontal, 18)
            .frame(maxWidth: .infinity)
            .background(RoundedRectangle(cornerRadius: 14, style: .continuous).fill(color))
            .shadow(color: color.opacity(0.5), radius: configuration.isPressed ? 4 : 12, y: 4)
            .scaleEffect(configuration.isPressed ? 0.97 : 1)
    }
}

struct GhostButtonStyle: ButtonStyle {
    var color: Color = NT.tx
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 15, weight: .semibold))
            .foregroundStyle(color)
            .padding(.vertical, 12).padding(.horizontal, 16)
            .frame(maxWidth: .infinity)
            .background(RoundedRectangle(cornerRadius: 14, style: .continuous).fill(Color.white.opacity(configuration.isPressed ? 0.1 : 0.05)))
            .overlay(RoundedRectangle(cornerRadius: 14, style: .continuous).stroke(NT.line, lineWidth: 1))
    }
}

struct ToastView: View {
    let toast: ToastMsg
    var body: some View {
        let c = Color(hex: toast.color)
        HStack(spacing: 12) {
            IconTile(icon: toast.icon, color: c, size: 38)
            VStack(alignment: .leading, spacing: 2) {
                Text(toast.title).font(.system(size: 14, weight: .bold)).foregroundStyle(NT.tx)
                Text(toast.detail).font(.system(size: 12)).foregroundStyle(NT.tx2).lineLimit(2)
            }
            Spacer(minLength: 0)
        }
        .padding(12)
        .background(RoundedRectangle(cornerRadius: 16, style: .continuous).fill(NT.panel2))
        .overlay(RoundedRectangle(cornerRadius: 16, style: .continuous).stroke(c.opacity(0.5), lineWidth: 1))
        .shadow(color: .black.opacity(0.5), radius: 16, y: 8)
        .padding(.horizontal, 16)
    }
}

/// Inline-Markdown (fett, kursiv, Code, Links) als Text
struct MD: View {
    let text: String
    var size: CGFloat = 16
    var color: Color = NT.tx
    var weight: Font.Weight = .regular
    var body: some View {
        Text(MD.attributed(text))
            .font(.system(size: size, weight: weight))
            .foregroundStyle(color)
            .tint(NT.acc)
            .lineSpacing(size * 0.28)
            .textSelection(.enabled)
            .fixedSize(horizontal: false, vertical: true)
    }

    static func attributed(_ s: String) -> AttributedString {
        var a = (try? AttributedString(markdown: s, options: AttributedString.MarkdownParsingOptions(interpretedSyntax: .inlineOnlyPreservingWhitespace))) ?? AttributedString(s)
        for run in a.runs {
            if let intent = run.inlinePresentationIntent, intent.contains(.code) {
                a[run.range].font = Font.system(size: 14, weight: .medium, design: .monospaced)
                a[run.range].foregroundColor = NT.acc
                a[run.range].backgroundColor = NT.acc.opacity(0.08)
            }
            if run.link != nil {
                a[run.range].foregroundColor = NT.acc
                a[run.range].underlineStyle = Text.LineStyle.single
            }
        }
        return a
    }
}
