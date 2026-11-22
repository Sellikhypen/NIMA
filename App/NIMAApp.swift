import SwiftUI

@main
struct NIMAApp: App {
    @State private var store = Store()

    init() {
        let tab = UITabBarAppearance()
        tab.configureWithOpaqueBackground()
        tab.backgroundColor = UIColor(red: 0.04, green: 0.06, blue: 0.09, alpha: 0.98)
        UITabBar.appearance().standardAppearance = tab
        UITabBar.appearance().scrollEdgeAppearance = tab
        let nav = UINavigationBarAppearance()
        nav.configureWithTransparentBackground()
        nav.titleTextAttributes = [.foregroundColor: UIColor.white]
        nav.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        UINavigationBar.appearance().standardAppearance = nav
        UINavigationBar.appearance().scrollEdgeAppearance = nav
    }

    var body: some Scene {
        WindowGroup {
            RootView()
                .environment(store)
                .preferredColorScheme(.dark)
                .tint(NT.acc)
                .task { await store.load() }
        }
    }
}

struct RootView: View {
    @Environment(Store.self) private var store
    @State private var tab = 0
    @State private var booted = false

    var body: some View {
        @Bindable var store = store
        ZStack(alignment: .top) {
            if store.content != nil {
                TabView(selection: $tab) {
                    HomeView(tab: $tab).tabItem { Label("Basis", systemImage: "house.fill") }.tag(0)
                    PathsView().tabItem { Label("Pfade", systemImage: "point.topleft.down.to.point.bottomright.curvepath.fill") }.tag(1)
                    TrainView().tabItem { Label("Training", systemImage: "scope") }.tag(2)
                    GlossaryView().tabItem { Label("Lexikon", systemImage: "character.book.closed.fill") }.tag(3)
                    ProfileView().tabItem { Label("Profil", systemImage: "person.crop.circle.fill") }.tag(4)
                }
                .id(store.themeVersion)
                .environment(\.openURL, OpenURLAction { url in
                    store.handle(url: url)
                    return .handled
                })
                .sheet(item: $store.sheetTerm) { t in
                    NavigationStack {
                        TermView(term: t)
                            .navigationDestination(for: Module.self) { ModuleView(module: $0) }
                    }
                    .presentationDetents([.medium, .large])
                    .presentationBackground(NT.bg2)
                    .environment(\.openURL, OpenURLAction { url in
                        store.handle(url: url)
                        return .handled
                    })
                }
                .sheet(item: $store.sheetModule) { m in
                    NavigationStack { ModuleView(module: m) }
                        .modifier(LocalLinks())
                        .presentationBackground(NT.bg)
                }
                .sheet(item: $store.sheetLesson) { ref in
                    NavigationStack {
                        LessonPager(module: ref.module, start: ref.index)
                            .toolbar { ToolbarItem(placement: .topBarLeading) { Button("Schließen") { store.sheetLesson = nil } } }
                    }
                    .modifier(LocalLinks())
                    .presentationBackground(NT.bg)
                }
                .fullScreenCover(isPresented: Binding(get: { !store.progress.onboarded }, set: { _ in })) {
                    OnboardingView()
                }
            } else if let err = store.loadError {
                VStack(spacing: 12) {
                    Image(systemName: "exclamationmark.triangle.fill").font(.largeTitle).foregroundStyle(NT.red)
                    Text("Inhalte konnten nicht geladen werden").font(.headline)
                    Text(err).font(.footnote).foregroundStyle(NT.tx2).multilineTextAlignment(.center)
                }
                .padding()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(AppBackground())
            } else {
                BootView()
            }

            if let t = store.toast {
                ToastView(toast: t)
                    .transition(.move(edge: .top).combined(with: .opacity))
                    .padding(.top, 6)
                    .onTapGesture { store.toast = nil }
                    .zIndex(10)
            }
        }
        .animation(.spring(duration: 0.4), value: store.toast)
        .environment(\.readScale, CGFloat(store.progress.prefs.readScale))
        .tint(NT.acc)
        .overlay {
            if let c = store.celebrations.first {
                CelebrationView(c: c, confetti: store.progress.prefs.confetti) { store.celebrations.removeFirst() }
                    .transition(.opacity)
                    .zIndex(20)
            }
        }
        .animation(.easeInOut(duration: 0.3), value: store.celebrations.count)
    }
}

struct BootView: View {
    @State private var lines: [String] = []
    private let script = [
        "[*] NIMA wird gestartet …",
        "[*] Lade Module, Lektionen und Lexikon …",
        "[*] Verbinde mit dem Lab (tun0) … OK",
        "[*] Initialisiere Lernkartei …",
    ]
    var body: some View {
        ZStack {
            AppBackground()
            VStack(alignment: .leading, spacing: 18) {
                HStack(spacing: 14) {
                    NimaLogo(size: 64)
                    VStack(alignment: .leading, spacing: 2) {
                        Text("NIMA").font(.system(size: 40, weight: .black, design: .monospaced)).foregroundStyle(NT.tx)
                        Text("CYBER ACADEMY").font(NT.mono(12)).tracking(4).foregroundStyle(NT.acc)
                    }
                }
                VStack(alignment: .leading, spacing: 6) {
                    ForEach(lines, id: \.self) { l in
                        Text(l).font(NT.mono(13, .regular)).foregroundStyle(l.contains("OK") ? NT.acc : NT.tx2)
                    }
                }
                ProgressView().tint(NT.acc)
            }
            .padding(30)
        }
        .task {
            for l in script {
                lines.append(l)
                try? await Task.sleep(nanoseconds: 250_000_000)
            }
        }
    }
}

struct NimaLogo: View {
    var size: CGFloat = 40
    var body: some View {
        ZStack {
            Hexagon().fill(NT.acc.opacity(0.12))
            Hexagon().stroke(NT.acc, lineWidth: size * 0.05)
            Image(systemName: "chevron.right").font(.system(size: size * 0.32, weight: .black)).foregroundStyle(NT.acc).offset(x: -size * 0.1)
            Rectangle().fill(NT.acc).frame(width: size * 0.2, height: size * 0.06).offset(x: size * 0.14, y: size * 0.13)
        }
        .frame(width: size, height: size * 1.1)
        .shadow(color: NT.acc.opacity(0.6), radius: size * 0.2)
    }
}

struct CelebrationView: View {
    let c: Celebration
    var confetti: Bool = true
    let done: () -> Void
    @State private var appear = false
    var body: some View {
        let col = Color(hex: c.color)
        ZStack {
            Color.black.opacity(0.85).ignoresSafeArea()
            if confetti { ConfettiView(color: col).ignoresSafeArea().allowsHitTesting(false) }
            VStack(spacing: 16) {
                Text(c.subtitle.uppercased()).font(NT.mono(13, .heavy)).tracking(4).foregroundStyle(col)
                Image(systemName: c.icon).font(.system(size: 80, weight: .bold)).foregroundStyle(col)
                    .shadow(color: col, radius: 24)
                    .scaleEffect(appear ? 1 : 0.3)
                    .rotation3DEffect(.degrees(appear ? 0 : 360), axis: (x: 0, y: 1, z: 0))
                Text(c.title).font(.system(size: 40, weight: .black, design: .monospaced)).foregroundStyle(NT.tx).multilineTextAlignment(.center)
                Text(c.detail).font(NT.mono(13, .medium)).foregroundStyle(NT.tx2).multilineTextAlignment(.center).textSelection(.enabled)
                Button("Weiter") { done() }.buttonStyle(PrimaryButtonStyle(color: col)).frame(width: 200).padding(.top, 10)
            }
            .padding(30)
        }
        .onAppear { withAnimation(.spring(response: 0.7, dampingFraction: 0.6)) { appear = true } }
    }
}

struct ConfettiView: View {
    let color: Color
    @State private var start = Date()
    var body: some View {
        TimelineView(.animation) { tl in
            Canvas { ctx, size in
                let t = tl.date.timeIntervalSince(start)
                let colors: [Color] = [color, NT.gold, NT.blue, NT.red, NT.purple, .white]
                for i in 0..<90 {
                    let seed = Double(i) * 12.9898
                    let x0 = (sin(seed) * 43758.5453).truncatingRemainder(dividingBy: 1)
                    let x = abs(x0) * size.width
                    let speed = 120 + abs(sin(seed * 3)) * 220
                    let y = (t * speed + abs(cos(seed)) * size.height).truncatingRemainder(dividingBy: size.height + 40) - 20
                    let rect = CGRect(x: x + sin(t * 2 + seed) * 20, y: y, width: 7, height: 4)
                    ctx.fill(Path(roundedRect: rect, cornerRadius: 1), with: .color(colors[i % colors.count].opacity(0.85)))
                }
            }
        }
    }
}
