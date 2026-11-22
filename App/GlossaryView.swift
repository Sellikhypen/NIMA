import SwiftUI

struct GlossaryView: View {
    @Environment(Store.self) private var store
    @State private var query = ""
    @State private var category = "Alle"
    @State private var onlyBookmarks = false
    @State private var quiz: QuizConfig?

    var categories: [String] {
        let counts = Dictionary(grouping: store.glossary, by: { $0.cat }).mapValues { $0.count }
        return ["Alle"] + counts.keys.sorted { counts[$0, default: 0] > counts[$1, default: 0] }
    }

    var filtered: [Term] {
        let q = query.lowercased().trimmingCharacters(in: .whitespaces)
        return store.glossary.filter { t in
            (category == "Alle" || t.cat == category) &&
            (!onlyBookmarks || store.progress.bookmarks.contains(t.id)) &&
            (q.isEmpty || t.term.lowercased().contains(q) || t.aka.contains { $0.lowercased().contains(q) } || t.short.lowercased().contains(q))
        }
    }

    var sections: [(String, [Term])] {
        let groups = Dictionary(grouping: filtered) { t -> String in
            let f = String(t.term.prefix(1)).uppercased()
            return f.rangeOfCharacter(from: .letters) != nil ? f : "#"
        }
        return groups.keys.sorted().map { ($0, groups[$0]!.sorted { $0.term.lowercased() < $1.term.lowercased() }) }
    }

    var body: some View {
        NavigationStack {
            List {
                Section {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            Button { onlyBookmarks.toggle() } label: {
                                Label("Gemerkt", systemImage: onlyBookmarks ? "star.fill" : "star")
                                    .font(NT.mono(11, .bold))
                                    .padding(.horizontal, 10).padding(.vertical, 6)
                                    .background(Capsule().fill(onlyBookmarks ? NT.gold.opacity(0.2) : Color.white.opacity(0.06)))
                                    .foregroundStyle(onlyBookmarks ? NT.gold : NT.tx2)
                            }
                            ForEach(categories, id: \.self) { c in
                                Button { category = c } label: {
                                    Text(c).font(NT.mono(11, .bold))
                                        .padding(.horizontal, 10).padding(.vertical, 6)
                                        .background(Capsule().fill(category == c ? NT.acc.opacity(0.18) : Color.white.opacity(0.06)))
                                        .foregroundStyle(category == c ? NT.acc : NT.tx2)
                                }
                            }
                        }
                        .buttonStyle(.plain)
                    }
                    .listRowBackground(Color.clear)
                    .listRowInsets(EdgeInsets(top: 4, leading: 16, bottom: 4, trailing: 16))
                }
                ForEach(sections, id: \.0) { sec in
                    Section(sec.0) {
                        ForEach(sec.1) { t in
                            NavigationLink(value: t) {
                                VStack(alignment: .leading, spacing: 3) {
                                    HStack {
                                        Text(t.term).font(.system(size: 16, weight: .semibold))
                                        if store.progress.bookmarks.contains(t.id) { Image(systemName: "star.fill").font(.caption2).foregroundStyle(NT.gold) }
                                        Spacer()
                                        Text(t.cat).font(NT.mono(9)).foregroundStyle(NT.tx3)
                                    }
                                    Text(Store.plain(t.short)).font(.system(size: 12)).foregroundStyle(NT.tx2).lineLimit(2)
                                }
                            }
                            .listRowBackground(NT.panel.opacity(0.7))
                        }
                    }
                }
            }
            .scrollContentBackground(.hidden)
            .background(AppBackground())
            .searchable(text: $query, prompt: "\(store.glossary.count) Fachbegriffe durchsuchen")
            .navigationTitle("Lexikon")
            .navigationDestination(for: Term.self) { TermView(term: $0) }
            .navigationDestination(for: Module.self) { ModuleView(module: $0) }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        quiz = QuizConfig(mode: .vocab, title: "Begriffe · " + (onlyBookmarks ? "Gemerkt" : category),
                                          questions: store.buildVocab(category: category == "Alle" ? nil : category, onlyBookmarks: onlyBookmarks))
                    } label: { Label("Trainieren", systemImage: "textformat.abc") }
                }
            }
            .fullScreenCover(item: $quiz) { QuizView(config: $0) }
        }
    }
}

struct TermView: View {
    @Environment(Store.self) private var store
    let term: Term
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                VStack(alignment: .leading, spacing: 8) {
                    HStack(alignment: .top) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(term.cat.uppercased()).font(NT.mono(11, .bold)).tracking(1.5).foregroundStyle(NT.blue)
                            Text(term.term).font(.system(size: 30, weight: .heavy)).textSelection(.enabled)
                            if !term.aka.isEmpty {
                                Text("auch: " + term.aka.joined(separator: ", ")).font(NT.mono(12)).foregroundStyle(NT.tx3)
                            }
                        }
                        Spacer()
                        Button { store.toggleBookmark(term) } label: {
                            Image(systemName: store.isBookmarked(term) ? "star.fill" : "star").font(.system(size: 22)).foregroundStyle(NT.gold)
                        }
                    }
                    if let c = store.progress.cards["term:" + term.id], c.seen > 0 {
                        Label(c.mastered ? "Gemeistert im Begriffe-Training" : "Im Begriffe-Training · Stufe \(c.box)", systemImage: c.mastered ? "checkmark.seal.fill" : "brain")
                            .font(NT.mono(11, .bold)).foregroundStyle(c.mastered ? NT.gold : NT.tx3)
                    }
                    if !term.short.isEmpty {
                        MD(text: term.short, size: 17, color: NT.tx, weight: .semibold)
                            .padding(12)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(RoundedRectangle(cornerRadius: 12).fill(NT.blue.opacity(0.08)))
                    }
                }
                ForEach(Array(term.text.enumerated()), id: \.offset) { _, p in
                    MD(text: p, size: 16, color: NT.tx.opacity(0.92))
                }
                if !term.see.isEmpty {
                    SectionHeader(title: "Siehe auch")
                    FlowLayout(spacing: 8) {
                        ForEach(term.see, id: \.self) { id in
                            if let t = store.termIndex[id] {
                                NavigationLink(value: t) {
                                    Text(t.term).font(NT.mono(12, .bold))
                                        .padding(.horizontal, 10).padding(.vertical, 6)
                                        .background(Capsule().fill(NT.acc.opacity(0.1)))
                                        .overlay(Capsule().stroke(NT.acc.opacity(0.4), lineWidth: 1))
                                        .foregroundStyle(NT.acc)
                                }
                            }
                        }
                    }
                }
                let mods = term.modules.compactMap { store.moduleIndex[$0] }
                if !mods.isEmpty {
                    SectionHeader(title: "Wird erklärt in", trailing: "\(mods.count) Module")
                    ForEach(mods) { m in
                        NavigationLink(value: m) {
                            HStack(spacing: 10) {
                                IconTile(icon: m.icon, size: 34)
                                Text(m.title).font(.system(size: 14, weight: .semibold)).foregroundStyle(NT.tx).multilineTextAlignment(.leading)
                                Spacer()
                                Image(systemName: "arrow.up.right").foregroundStyle(NT.tx3)
                            }
                            .card(padding: 10)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            .padding(18)
        }
        .background(AppBackground())
        .navigationTitle(term.term)
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(for: Term.self) { TermView(term: $0) }
        .onAppear { store.viewedTerm(term) }
    }
}

struct FlowLayout: Layout {
    var spacing: CGFloat = 8
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let maxW = proposal.width ?? 360
        var x: CGFloat = 0, y: CGFloat = 0, rowH: CGFloat = 0, width: CGFloat = 0
        for s in subviews {
            let sz = s.sizeThatFits(.unspecified)
            if x + sz.width > maxW && x > 0 { x = 0; y += rowH + spacing; rowH = 0 }
            x += sz.width + spacing
            rowH = max(rowH, sz.height)
            width = max(width, x)
        }
        return CGSize(width: min(width, maxW), height: y + rowH)
    }
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        var x = bounds.minX, y = bounds.minY, rowH: CGFloat = 0
        for s in subviews {
            let sz = s.sizeThatFits(.unspecified)
            if x + sz.width > bounds.maxX && x > bounds.minX { x = bounds.minX; y += rowH + spacing; rowH = 0 }
            s.place(at: CGPoint(x: x, y: y), proposal: ProposedViewSize(sz))
            x += sz.width + spacing
            rowH = max(rowH, sz.height)
        }
    }
}

struct SearchView: View {
    @Environment(Store.self) private var store
    @Environment(\.dismiss) private var dismiss
    @State private var query = ""
    var body: some View {
        NavigationStack {
            List {
                let hits = store.search(query)
                if query.count >= 2 && hits.isEmpty {
                    Text("Nichts gefunden.").foregroundStyle(NT.tx3).listRowBackground(Color.clear)
                }
                ForEach(hits) { h in
                    Button {
                        open(h)
                    } label: {
                        HStack(spacing: 12) {
                            Image(systemName: h.kind == "term" ? "character.book.closed.fill" : h.kind == "module" ? "square.stack.3d.up.fill" : "doc.text.fill")
                                .foregroundStyle(h.kind == "term" ? NT.blue : NT.acc)
                                .frame(width: 24)
                            VStack(alignment: .leading, spacing: 2) {
                                Text(h.title).font(.system(size: 15, weight: .semibold)).foregroundStyle(NT.tx).lineLimit(2)
                                Text(h.subtitle).font(.system(size: 12)).foregroundStyle(NT.tx2).lineLimit(1)
                            }
                        }
                    }
                    .listRowBackground(NT.panel.opacity(0.7))
                }
            }
            .scrollContentBackground(.hidden)
            .background(AppBackground())
            .searchable(text: $query, placement: .navigationBarDrawer(displayMode: .always), prompt: "Module, Lektionen, Begriffe …")
            .navigationTitle("Suche")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar { ToolbarItem(placement: .topBarTrailing) { Button("Fertig") { dismiss() } } }
            .navigationDestination(for: LessonRef.self) { LessonPager(module: $0.module, start: $0.index) }
            .navigationDestination(for: Module.self) { ModuleView(module: $0) }
            .navigationDestination(for: Term.self) { TermView(term: $0) }
        }
    }
    @State private var path = NavigationPath()
    func open(_ h: SearchHit) {
        if h.kind == "term", let t = store.termIndex[h.termId] {
            dismiss()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) { store.sheetTerm = t }
        } else if h.kind == "lesson", let m = store.moduleIndex[h.moduleId] {
            dismiss()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) { store.openLesson(m, h.lessonIndex) }
        } else if let m = store.moduleIndex[h.moduleId] {
            dismiss()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) { store.sheetModule = m }
        }
    }
}
