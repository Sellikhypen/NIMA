import SwiftUI
import UIKit

struct LessonPager: View {
    @Environment(Store.self) private var store
    let module: Module
    let start: Int
    @State private var index: Int = 0
    @State private var didInit = false
    @State private var quiz: QuizConfig?

    var body: some View {
        let lesson = module.lessons[min(index, module.lessons.count - 1)]
        ScrollViewReader { proxy in
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    Color.clear.frame(height: 0).id("top")
                    LessonHeader(module: module, index: index)
                    LessonBody(lesson: lesson)
                    LessonFooter(module: module, index: $index, quiz: $quiz)
                }
                .padding(.horizontal, 18)
                .padding(.bottom, 40)
                .frame(maxWidth: 820)
                .frame(maxWidth: .infinity)
            }
            .onChange(of: index) { _, _ in
                withAnimation { proxy.scrollTo("top", anchor: .top) }
            }
        }
        .background(AppBackground())
        .navigationTitle("Lektion \(index + 1)/\(module.lessons.count)")
        .navigationBarTitleDisplayMode(.inline)
        .safeAreaInset(edge: .top) {
            BarView(value: Double(index + 1) / Double(max(module.lessons.count, 1)), height: 3).padding(.horizontal, 0)
        }
        .onAppear {
            if !didInit { index = start; didInit = true }
            store.progress.lastLesson = module.lessons[min(index, module.lessons.count - 1)].id
        }
        .fullScreenCover(item: $quiz) { QuizView(config: $0) }
    }
}

struct LessonHeader: View {
    let module: Module
    let index: Int
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 8) {
                Image(systemName: module.icon).foregroundStyle(NT.acc)
                Text(module.title.uppercased()).font(NT.mono(11, .bold)).tracking(1).foregroundStyle(NT.tx3).lineLimit(1)
            }
            MD(text: module.lessons[index].title, size: 27, weight: .heavy)
            Rectangle().fill(LinearGradient(colors: [NT.acc, .clear], startPoint: .leading, endPoint: .trailing)).frame(height: 2).padding(.top, 4)
        }
        .padding(.top, 14)
        .padding(.bottom, 10)
    }
}

struct LessonBody: View {
    let lesson: Lesson
    var body: some View {
        LazyVStack(alignment: .leading, spacing: 14) {
            ForEach(Array(lesson.blocks.enumerated()), id: \.offset) { _, b in
                BlockView(block: b)
            }
        }
        .padding(.vertical, 8)
    }
}

struct LessonFooter: View {
    @Environment(Store.self) private var store
    let module: Module
    @Binding var index: Int
    @Binding var quiz: QuizConfig?
    var body: some View {
        let lesson = module.lessons[index]
        let read = store.isRead(lesson)
        let last = index + 1 >= module.lessons.count
        VStack(spacing: 12) {
            Divider().overlay(NT.line).padding(.vertical, 10)
            Button {
                store.markRead(lesson)
                store.haptic(.success)
                if !last { index += 1 }
            } label: {
                Label(last ? (read ? "Modul abgeschlossen" : "Abschließen (+15 XP)") : (read ? "Weiter zur nächsten Lektion" : "Gelesen · weiter (+15 XP)"),
                      systemImage: last ? "flag.checkered" : "arrow.right")
            }
            .buttonStyle(PrimaryButtonStyle())
            HStack(spacing: 10) {
                if index > 0 {
                    Button { index -= 1 } label: { Label("Zurück", systemImage: "arrow.left") }.buttonStyle(GhostButtonStyle())
                }
                if last && !module.quiz.isEmpty {
                    Button { quiz = QuizConfig(mode: .training, title: module.title, questions: store.buildTraining([module.id])) } label: { Label("Modul-Quiz", systemImage: "scope") }
                        .buttonStyle(GhostButtonStyle(color: NT.acc))
                }
            }
        }
    }
}

// MARK: - Blocks

struct BlockView: View {
    let block: Block
    var body: some View {
        switch block.t {
        case "p":
            MD(text: block.text ?? "", size: 16.5, color: NT.tx.opacity(0.92))
        case "h3":
            MD(text: block.text ?? "", size: 20, weight: .bold).padding(.top, 10)
        case "h4":
            MD(text: block.text ?? "", size: 17, color: NT.acc, weight: .bold).padding(.top, 6)
        case "ul":
            ListBlock(items: block.items ?? [], ordered: false)
        case "ol":
            ListBlock(items: block.items ?? [], ordered: true)
        case "code":
            CodeBlock(code: block.text ?? "", lang: block.lang ?? "")
        case "callout":
            CalloutBlock(kind: block.kind ?? "info", title: block.title ?? "", items: block.items ?? [])
        case "table":
            TableBlock(rows: block.rows ?? [])
        case "img":
            ImageBlock(src: block.src ?? "", caption: block.text ?? "")
        case "hr":
            Divider().overlay(NT.line)
        default:
            EmptyView()
        }
    }
}

struct ListBlock: View {
    let items: [String]
    let ordered: Bool
    var body: some View {
        VStack(alignment: .leading, spacing: 9) {
            ForEach(Array(items.enumerated()), id: \.offset) { i, it in
                HStack(alignment: .firstTextBaseline, spacing: 10) {
                    if ordered {
                        Text("\(i + 1).").font(NT.mono(14, .heavy)).foregroundStyle(NT.acc).frame(minWidth: 22, alignment: .trailing)
                    } else {
                        Image(systemName: "chevron.right").font(.system(size: 10, weight: .heavy)).foregroundStyle(NT.acc)
                    }
                    MD(text: it, size: 16, color: NT.tx.opacity(0.92))
                }
            }
        }
        .padding(.leading, 4)
    }
}

struct CodeBlock: View {
    @Environment(Store.self) private var store
    let code: String
    let lang: String
    @State private var copied = false
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                HStack(spacing: 5) {
                    Circle().fill(NT.red.opacity(0.8)).frame(width: 8, height: 8)
                    Circle().fill(NT.orange.opacity(0.8)).frame(width: 8, height: 8)
                    Circle().fill(NT.acc.opacity(0.8)).frame(width: 8, height: 8)
                }
                Text(lang.isEmpty ? "terminal" : lang).font(NT.mono(10)).foregroundStyle(NT.tx3).padding(.leading, 6)
                Spacer()
                Button {
                    UIPasteboard.general.string = code
                    copied = true
                    store.haptic(.light)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { copied = false }
                } label: {
                    Label(copied ? "Kopiert" : "Kopieren", systemImage: copied ? "checkmark" : "doc.on.doc").font(NT.mono(10))
                }
                .foregroundStyle(copied ? NT.acc : NT.tx2)
            }
            .padding(.horizontal, 12).padding(.vertical, 8)
            .background(Color.white.opacity(0.03))
            ScrollView(.horizontal, showsIndicators: false) {
                Text(code)
                    .font(.system(size: 13, design: .monospaced))
                    .foregroundStyle(Color(hex: "#CFE3C0"))
                    .textSelection(.enabled)
                    .padding(12)
            }
        }
        .background(RoundedRectangle(cornerRadius: 12).fill(Color(hex: "#03060A")))
        .overlay(RoundedRectangle(cornerRadius: 12).stroke(NT.line, lineWidth: 1))
    }
}

struct CalloutBlock: View {
    let kind: String
    let title: String
    let items: [String]
    var style: (String, Color, String) {
        switch kind {
        case "tipp": return ("lightbulb.fill", NT.acc, "Tipp")
        case "merke": return ("pin.fill", NT.gold, "Merke")
        case "warnung": return ("exclamationmark.triangle.fill", NT.orange, "Achtung")
        case "gefahr": return ("xmark.octagon.fill", NT.red, "Sicherheitskritisch")
        case "beispiel": return ("text.magnifyingglass", NT.purple, "Beispiel")
        case "ergebnis": return ("checkmark.seal.fill", NT.teal, "Ergebnis")
        case "exam": return ("graduationcap.fill", Color(hex: "#FF4FD8"), "Prüfungsrelevant")
        case "praxis": return ("terminal.fill", NT.acc, "Praxis")
        case "definition": return ("character.book.closed.fill", NT.blue, "Definition")
        case "analogie": return ("figure.walk", NT.gold, "Analogie")
        default: return ("info.circle.fill", NT.blue, "Info")
        }
    }
    var body: some View {
        let s = style
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 8) {
                Image(systemName: s.0).foregroundStyle(s.1)
                MD(text: title.isEmpty ? s.2 : title, size: 15, color: s.1, weight: .bold)
            }
            ForEach(Array(items.enumerated()), id: \.offset) { _, it in
                if it.hasPrefix("- ") {
                    HStack(alignment: .firstTextBaseline, spacing: 8) {
                        Text("•").foregroundStyle(s.1)
                        MD(text: String(it.dropFirst(2)), size: 15, color: NT.tx.opacity(0.9))
                    }
                } else {
                    MD(text: it, size: 15, color: NT.tx.opacity(0.9))
                }
            }
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(RoundedRectangle(cornerRadius: 14).fill(s.1.opacity(0.08)))
        .overlay(alignment: .leading) { RoundedRectangle(cornerRadius: 2).fill(s.1).frame(width: 4).padding(.vertical, 8) }
        .overlay(RoundedRectangle(cornerRadius: 14).stroke(s.1.opacity(0.3), lineWidth: 1))
    }
}

struct TableBlock: View {
    let rows: [[String]]
    var body: some View {
        ScrollView(.horizontal, showsIndicators: true) {
            Grid(alignment: .topLeading, horizontalSpacing: 0, verticalSpacing: 0) {
                ForEach(Array(rows.enumerated()), id: \.offset) { r, row in
                    GridRow {
                        ForEach(Array(row.enumerated()), id: \.offset) { _, cell in
                            MD(text: r == 0 ? Store.plain(cell) : cell, size: 13.5, color: r == 0 ? NT.acc : NT.tx.opacity(0.9), weight: r == 0 ? .bold : .regular)
                                .frame(minWidth: 110, maxWidth: 240, alignment: .topLeading)
                                .padding(10)
                                .background(r == 0 ? NT.acc.opacity(0.08) : (r % 2 == 0 ? Color.white.opacity(0.025) : Color.clear))
                        }
                    }
                    if r < rows.count - 1 { Divider().overlay(NT.line) }
                }
            }
        }
        .background(RoundedRectangle(cornerRadius: 12).fill(NT.panel))
        .overlay(RoundedRectangle(cornerRadius: 12).stroke(NT.line, lineWidth: 1))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

struct ImageBlock: View {
    let src: String
    let caption: String
    @State private var zoom = false
    var image: UIImage? {
        guard let url = Bundle.main.url(forResource: src, withExtension: nil, subdirectory: "Content/img") else { return nil }
        return UIImage(contentsOfFile: url.path)
    }
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            if let img = image {
                Image(uiImage: img)
                    .resizable()
                    .scaledToFit()
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .overlay(alignment: .bottomTrailing) {
                        Image(systemName: "arrow.up.left.and.arrow.down.right").font(.system(size: 12, weight: .bold)).padding(7)
                            .background(Circle().fill(.black.opacity(0.6))).padding(8)
                    }
                    .onTapGesture { zoom = true }
                    .fullScreenCover(isPresented: $zoom) { ZoomImage(image: img, caption: caption) }
            } else {
                Label("Bild fehlt: \(src)", systemImage: "photo").font(NT.mono(11)).foregroundStyle(NT.tx3)
            }
            if !caption.isEmpty {
                Text(caption).font(.system(size: 12).italic()).foregroundStyle(NT.tx2)
            }
        }
    }
}

struct ZoomImage: View {
    let image: UIImage
    let caption: String
    @Environment(\.dismiss) private var dismiss
    @State private var scale: CGFloat = 1
    @State private var last: CGFloat = 1
    var body: some View {
        ZStack(alignment: .topTrailing) {
            Color.black.ignoresSafeArea()
            ScrollView([.horizontal, .vertical], showsIndicators: false) {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .background(Color.white)
                    .frame(width: UIScreen.main.bounds.width * scale)
                    .gesture(MagnificationGesture()
                        .onChanged { v in scale = max(1, min(5, last * v)) }
                        .onEnded { _ in last = scale })
                    .onTapGesture(count: 2) { withAnimation { scale = scale > 1 ? 1 : 2.5; last = scale } }
            }
            Button { dismiss() } label: {
                Image(systemName: "xmark.circle.fill").font(.system(size: 30)).foregroundStyle(.white.opacity(0.85))
            }
            .padding()
        }
        .overlay(alignment: .bottom) {
            if !caption.isEmpty {
                Text(caption).font(.footnote).foregroundStyle(.white).padding(10).background(.black.opacity(0.6)).clipShape(RoundedRectangle(cornerRadius: 8)).padding()
            }
        }
    }
}
