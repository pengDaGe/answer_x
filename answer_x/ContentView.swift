import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var favoritesStore: OracleFavoritesStore
    @EnvironmentObject private var historyStore: OracleHistoryStore
    @State private var selectedTab: OracleTab = .home
    @State private var navigationPath: [OracleRoute] = []
    @State private var homeBentoCardHeight: CGFloat = 0
    private let mode: OracleMode = .oracle

    var body: some View {
        NavigationStack(path: $navigationPath) {
            ZStack {
                OracleBackground(mode: mode)

                VStack(spacing: 0) {
                    activeTopBar

                    ZStack {
                        if selectedTab == .history && historyStore.entries.isEmpty {
                            pageContent
                        } else {
                            ScrollView(showsIndicators: false) {
                                pageContent
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                .safeAreaInset(edge: .bottom) {
                    OracleBottomNavigation(mode: mode, selected: selectedTab) { tab in
                        withAnimation(.spring(response: 0.36, dampingFraction: 0.86)) {
                            selectedTab = tab
                        }
                    }
                        .padding(.bottom, OracleSpacing.xs)
                }
            }
            .toolbar(.hidden, for: .navigationBar)
            .navigationDestination(for: OracleRoute.self) { route in
                switch route {
                case .detail(let gateway):
                    AnswerDetailView(gateway: gateway) { question in
                        navigationPath.append(.transition(gateway, question))
                    }
                case .transition(let gateway, let question):
                    AnswerTransitionView(gateway: gateway, question: question) {
                        replaceTransitionWithResult(gateway: gateway, question: question)
                    }
                case .result(let record):
                    AnswerResultView(record: record)
                case .historyDetail(let record):
                    HistoryAnswerDetailView(record: record)
                case .favorites:
                    FavoriteAnswersView()
                }
            }
        }
    }

    @ViewBuilder
    private var activeTopBar: some View {
        switch selectedTab {
        case .history:
            if historyStore.entries.isEmpty {
                EmptyView()
            } else {
                HistoryTopBar()
            }
        default:
            OracleTopBar(mode: mode)
        }
    }

    @ViewBuilder
    private var pageContent: some View {
        switch selectedTab {
        case .home:
            homePage
        case .void:
            voidPage
        case .history:
            historyPage
        case .profile:
            profilePage
        }
    }

    private var homePage: some View {
        VStack(spacing: 0) {
            ZStack {
                Circle()
                    .fill(mode.accent.opacity(0.10))
                    .frame(width: 256, height: 256)
                    .blur(radius: 100)
                    .offset(x: -88, y: -68)

                Circle()
                    .fill(OracleColor.secondary.opacity(0.06))
                    .frame(width: 320, height: 320)
                    .blur(radius: 120)
                    .offset(x: 124, y: 48)

                VStack(spacing: OracleSpacing.xxl) {
                    OraclePortal(mode: mode) {
                        OracleOrbGlyph(mode: mode)
                    }
                    .frame(width: 320, height: 320)
                    .padding(.top, OracleSpacing.xxl)

                    VStack(spacing: OracleSpacing.md) {
                        (
                            Text("KNOW THE ")
                                .foregroundStyle(OracleColor.onSurface)
                            +
                            Text("VOID")
                                .foregroundStyle(mode.accentDim)
                        )
                        .font(OracleTypography.displayMedium())
                        .multilineTextAlignment(.center)

                        Text("Silence your mind, the universe will answer.")
                            .font(OracleTypography.bodyLarge())
                            .foregroundStyle(OracleColor.onSurfaceVariant.opacity(0.82))
                            .italic()
                            .multilineTextAlignment(.center)
                            .frame(maxWidth: 280)
                    }
                    .frame(maxWidth: .infinity)

                    VStack(spacing: OracleSpacing.md) {
                        Button("START DIVINATION") {
                            withAnimation(.spring(response: 0.36, dampingFraction: 0.86)) {
                                selectedTab = .void
                            }
                        }
                        .buttonStyle(OraclePrimaryButtonStyle(mode: mode))
                        .frame(maxWidth: 260)

                        HStack(spacing: OracleSpacing.md) {
                            OracleBentoCard(
                                mode: mode,
                                systemImage: "star.fill",
                                iconColor: OracleColor.secondary,
                                eyebrow: "RITUAL",
                                title: "Daily Fortune",
                                minHeight: homeBentoCardHeight == 0 ? nil : homeBentoCardHeight
                            )
                            .background {
                                GeometryReader { proxy in
                                    Color.clear.preference(
                                        key: OracleBentoCardHeightPreferenceKey.self,
                                        value: proxy.size.height
                                    )
                                }
                            }

                            OracleBentoCard(
                                mode: mode,
                                systemImage: "chart.line.uptrend.xyaxis",
                                iconColor: OracleColor.tertiary,
                                eyebrow: "COLLECTIVE",
                                title: "Trending Questions",
                                minHeight: homeBentoCardHeight == 0 ? nil : homeBentoCardHeight
                            )
                            .background {
                                GeometryReader { proxy in
                                    Color.clear.preference(
                                        key: OracleBentoCardHeightPreferenceKey.self,
                                        value: proxy.size.height
                                    )
                                }
                            }
                        }
                        .padding(.top, OracleSpacing.sm)
                        .onPreferenceChange(OracleBentoCardHeightPreferenceKey.self) { height in
                            if abs(homeBentoCardHeight - height) > 0.5 {
                                homeBentoCardHeight = height
                            }
                        }
                    }
                }
                .padding(.horizontal, OracleSpacing.lg)
                .padding(.bottom, OracleSpacing.xxl)
            }

            homeInsightsSection
                .padding(.top, OracleSpacing.xxl)
                .padding(.bottom, OracleSpacing.xxxl)
        }
    }

    private var voidPage: some View {
        VStack(alignment: .leading, spacing: 0) {
            headerSection
            modeGrid
                .padding(.top, OracleSpacing.lg)
            insightBanner
                .padding(.top, OracleSpacing.xxl)
                .padding(.bottom, OracleSpacing.xxxl)
        }
        .padding(.horizontal, OracleSpacing.lg)
        .padding(.top, OracleSpacing.lg)
    }

    private var historyPage: some View {
        Group {
            if historyStore.entries.isEmpty {
                HistoryEmptyStateView {
                    withAnimation(.spring(response: 0.36, dampingFraction: 0.86)) {
                        selectedTab = .void
                    }
                }
            } else {
                VStack(alignment: .leading, spacing: OracleSpacing.lg) {
                    VStack(alignment: .leading, spacing: OracleSpacing.xs) {
                        Text("PAST ECHOES")
                            .font(OracleTypography.displaySmall())
                            .foregroundStyle(OracleColor.onSurface)

                        Text("Every question, every chosen theme, every answer the void has already returned.")
                            .font(OracleTypography.labelMedium())
                            .foregroundStyle(OracleColor.onSurfaceVariant)
                            .tracking(1.6)
                            .textCase(.uppercase)
                    }

                    LazyVStack(spacing: OracleSpacing.md) {
                        ForEach(historyStore.entries) { record in
                            Button {
                                navigationPath.append(.historyDetail(record))
                            } label: {
                                OracleHistoryCard(record: record)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.bottom, OracleSpacing.xxxl)
                }
                .padding(.horizontal, OracleSpacing.lg)
                .padding(.top, OracleSpacing.lg)
            }
        }
    }

    private var profilePage: some View {
        VStack(alignment: .leading, spacing: OracleSpacing.lg) {
            HStack {
                Spacer()

                ZStack {
                    Circle()
                        .fill(OracleColor.primary.opacity(0.16))
                        .blur(radius: 18)

                    Circle()
                        .fill(OracleColor.surfaceContainerHigh)
                        .overlay {
                            Circle()
                                .stroke(OracleColor.primary.opacity(0.28), lineWidth: 1)
                        }

                    Image(systemName: "person.crop.circle.fill")
                        .font(.system(size: 42))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [OracleColor.onSurface, OracleColor.primary],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                }
                .frame(width: 84, height: 84)

                Spacer()
            }

            Button {
                navigationPath.append(.favorites)
            } label: {
                HStack(spacing: OracleSpacing.md) {
                    ZStack {
                        Circle()
                            .fill(OracleColor.primary.opacity(0.14))
                        Image(systemName: "bookmark.fill")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundStyle(OracleColor.primary)
                    }
                    .frame(width: 48, height: 48)

                    VStack(alignment: .leading, spacing: OracleSpacing.xs) {
                        Text("FAVORITES")
                            .font(OracleTypography.labelMedium())
                            .foregroundStyle(OracleColor.primary)
                            .tracking(2.2)

                        Text("\(favoritesStore.entries.count) saved answers from the void")
                            .font(OracleTypography.bodyMedium())
                            .foregroundStyle(OracleColor.onSurface)
                    }

                    Spacer()

                    Image(systemName: "chevron.right")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(OracleColor.onSurfaceVariant)
                }
                .padding(OracleSpacing.lg)
            }
            .buttonStyle(.plain)
            .oracleGlassCard(mode: mode, cornerRadius: OracleRadius.md)

            OracleInsightBanner(
                eyebrow: "Profile Insight",
                message: "Consistency sharpens the oracle. The more deliberate the ritual, the clearer the signal.",
                accent: OracleColor.tertiary
            )
        }
        .padding(.horizontal, OracleSpacing.lg)
        .padding(.top, OracleSpacing.lg)
        .padding(.bottom, OracleSpacing.xxxl)
    }

    private var headerSection: some View {
        VStack(alignment: .leading, spacing: OracleSpacing.xs) {
            (
                Text("CHOOSE YOUR ")
                    .foregroundStyle(OracleColor.onSurface)
                +
                Text("REALITY")
                    .foregroundStyle(mode.accentDim)
            )
            .font(OracleTypography.displaySmall())
            .lineLimit(2)

            Text("Select a gateway to calibrate the oracle's resonance")
                .font(OracleTypography.labelMedium())
                .foregroundStyle(OracleColor.onSurfaceVariant)
                .tracking(1.8)
                .textCase(.uppercase)
        }
    }

    private var homeInsightsSection: some View {
        VStack(spacing: OracleSpacing.lg) {
            HStack(alignment: .bottom) {
                VStack(alignment: .leading, spacing: OracleSpacing.xs) {
                    Text("INSIGHT")
                        .font(OracleTypography.labelSmall())
                        .foregroundStyle(mode.accentDim)
                        .tracking(2.2)

                    Text("Latest Ten Echoes")
                        .font(OracleTypography.headlineMedium())
                        .foregroundStyle(OracleColor.onSurface)
                }

                Spacer()

                Button("See the Log") {
                    withAnimation(.spring(response: 0.36, dampingFraction: 0.86)) {
                        selectedTab = .history
                    }
                }
                .font(OracleTypography.labelSmall())
                .foregroundStyle(OracleColor.onSurfaceVariant)
                .tracking(1.3)
            }

            if historyStore.entries.isEmpty {
                OracleInsightBanner(
                    eyebrow: "No History Yet",
                    message: "Cast your first question and the latest ten echoes will gather here.",
                    accent: OracleColor.primaryDim
                )
            } else {
                VStack(spacing: OracleSpacing.md) {
                    ForEach(historyStore.recentEntries(limit: 10)) { record in
                        Button {
                            navigationPath.append(.historyDetail(record))
                        } label: {
                            OracleHistoryCard(record: record)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
        }
        .padding(.horizontal, OracleSpacing.lg)
    }

    private var modeGrid: some View {
        LazyVGrid(
            columns: [
                GridItem(.flexible(), spacing: OracleSpacing.md),
                GridItem(.flexible(), spacing: OracleSpacing.md)
            ],
            spacing: OracleSpacing.md
        ) {
            ForEach(OracleGatewayType.allCases) { gateway in
                Button {
                    navigationPath.append(.detail(gateway))
                } label: {
                    OracleModeTile(
                        title: gateway.title,
                        subtitle: gateway.subtitle,
                        systemImage: gateway.systemImage,
                        accent: gateway.accent,
                        glowOpacity: gateway.glowOpacity,
                        fillIcon: gateway.fillIcon
                    )
                }
                .buttonStyle(.plain)
            }
        }
    }

    private func replaceTransitionWithResult(gateway: OracleGatewayType, question: String) {
        let resolvedQuestion = OracleAnswerBook.resolvedQuestion(
            question,
            fallback: gateway.promptExamples.first ?? "Should I quit my job?"
        )
        let answer = OracleAnswerBook.answer(for: gateway, question: resolvedQuestion)
        let record = historyStore.addRecord(
            question: resolvedQuestion,
            gateway: gateway,
            answer: answer
        )

        if let last = navigationPath.last,
           case .transition = last {
            navigationPath.removeLast()
        }
        navigationPath.append(.result(record))
    }

    private var insightBanner: some View {
        OracleInsightBanner(
            eyebrow: "Oracle Insight",
            message: "The void responds to the frequency you project. Choose your mode with intention.",
            accent: OracleColor.primary
        )
    }
}

private struct OracleBentoCardHeightPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0

    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = max(value, nextValue())
    }
}

private struct HistoryTopBar: View {
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: OracleSpacing.md) {
                Button {} label: {
                    Image(systemName: "line.3.horizontal")
                        .font(.system(size: 22, weight: .bold))
                        .foregroundStyle(OracleColor.primary)
                        .frame(width: 40, height: 40)
                }
                .buttonStyle(.plain)

                Spacer()

                Text("HISTORY")
                    .font(OracleTypography.headlineMedium())
                    .foregroundStyle(OracleColor.primary)
                    .tracking(4)

                Spacer()

                ZStack {
                    Circle()
                        .fill(OracleColor.primary.opacity(0.12))
                        .blur(radius: 10)

                    Circle()
                        .fill(OracleColor.surfaceContainerHigh)
                        .overlay {
                            Circle()
                                .stroke(OracleColor.onSurface.opacity(0.10), lineWidth: 1)
                        }

                    Image(systemName: "person.crop.circle.fill")
                        .font(.system(size: 24))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [OracleColor.onSurface, OracleColor.primary],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                }
                .frame(width: 42, height: 42)
            }
            .padding(.horizontal, OracleSpacing.lg)
            .padding(.top, OracleSpacing.md)
            .padding(.bottom, OracleSpacing.md)

            Rectangle()
                .fill(OracleColor.primary.opacity(0.12))
                .frame(height: 1)
        }
        .background {
            Rectangle()
                .fill(.ultraThinMaterial)
                .overlay {
                    Rectangle()
                        .fill(OracleColor.surface.opacity(0.72))
                }
        }
    }
}

private struct FavoriteAnswersView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var favoritesStore: OracleFavoritesStore

    var body: some View {
        ZStack {
            OracleBackground(mode: .oracle)

            VStack(spacing: 0) {
                header

                ScrollView(showsIndicators: false) {
                    VStack(spacing: OracleSpacing.xl) {
                        if favoritesStore.entries.isEmpty {
                            VStack(spacing: OracleSpacing.lg) {
                                Text("NO FAVORITES YET")
                                    .font(OracleTypography.displaySmall())
                                    .foregroundStyle(OracleColor.onSurface)
                                    .multilineTextAlignment(.center)

                                Text("Favorite an answer from the book and it will gather here.")
                                    .font(OracleTypography.bodyLarge())
                                    .foregroundStyle(OracleColor.onSurfaceVariant)
                                    .multilineTextAlignment(.center)
                                    .frame(maxWidth: 320)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.horizontal, OracleSpacing.lg)
                            .padding(.bottom, OracleSpacing.xxxl)
                        } else {
                            VStack(alignment: .leading, spacing: OracleSpacing.lg) {
                                VStack(alignment: .leading, spacing: OracleSpacing.xs) {
                                    Text("SAVED ANSWERS")
                                        .font(OracleTypography.displaySmall())
                                        .foregroundStyle(OracleColor.onSurface)

                                    Text("Every favorite keeps the saved time, the chosen theme, and the answer you decided to keep.")
                                        .font(OracleTypography.labelMedium())
                                        .foregroundStyle(OracleColor.onSurfaceVariant)
                                        .tracking(1.6)
                                        .textCase(.uppercase)
                                }

                                LazyVStack(spacing: OracleSpacing.md) {
                                    ForEach(favoritesStore.entries) { favorite in
                                        OracleFavoriteCard(record: favorite)
                                    }
                                }
                                .padding(.bottom, OracleSpacing.xxxl)
                            }
                            .padding(.horizontal, OracleSpacing.lg)
                        }
                    }
                }
            }
        }
        .toolbar(.hidden, for: .navigationBar)
    }

    private var header: some View {
        VStack(spacing: 0) {
            HStack(spacing: OracleSpacing.sm) {
                HStack(spacing: OracleSpacing.xs) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundStyle(OracleColor.primary)
                            .frame(width: 36, height: 36)
                            .background {
                                Circle()
                                    .fill(OracleColor.surfaceContainerHigh.opacity(0.9))
                            }
                    }
                    .buttonStyle(.plain)

                    Image(systemName: "bookmark.fill")
                        .font(.system(size: 15, weight: .bold))
                        .foregroundStyle(OracleColor.primary)

                    Text("FAVORITES")
                        .font(OracleTypography.headlineMedium())
                        .foregroundStyle(OracleColor.primary)
                        .textCase(.uppercase)
                }

                Spacer()

                ZStack {
                    Circle()
                        .fill(OracleColor.primary.opacity(0.16))
                        .blur(radius: 12)

                    Circle()
                        .fill(OracleColor.surfaceContainerHigh)
                        .overlay {
                            Circle()
                                .stroke(OracleColor.primary.opacity(0.28), lineWidth: 1)
                        }

                    Image(systemName: "person.crop.circle.fill")
                        .font(.system(size: 24))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [OracleColor.onSurface, OracleColor.primary],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                }
                .frame(width: 40, height: 40)
            }
            .padding(.horizontal, OracleSpacing.lg)
            .padding(.top, OracleSpacing.md)
            .padding(.bottom, OracleSpacing.md)

            LinearGradient(
                colors: [OracleColor.primary.opacity(0.16), .clear],
                startPoint: .leading,
                endPoint: .trailing
            )
            .frame(height: 1)
        }
        .background {
            Rectangle()
                .fill(.ultraThinMaterial)
                .overlay {
                    Rectangle()
                        .fill(OracleColor.surface.opacity(0.55))
                }
        }
    }
}

private struct HistoryEmptyStateView: View {
    let onStartDivination: () -> Void

    var body: some View {
        VStack(spacing: OracleSpacing.xxl) {
            ZStack {
                Circle()
                    .fill(OracleColor.primaryDim.opacity(0.12))
                    .frame(width: 280, height: 280)
                    .blur(radius: 90)

                Circle()
                    .stroke(OracleColor.onSurface.opacity(0.10), lineWidth: 1)
                    .frame(width: 188, height: 188)

                Circle()
                    .stroke(OracleColor.primary.opacity(0.20), lineWidth: 1)
                    .frame(width: 126, height: 126)

                Circle()
                    .stroke(OracleColor.secondary.opacity(0.12), lineWidth: 1)
                    .frame(width: 74, height: 74)

                Image(systemName: "triangle.fill")
                    .font(.system(size: 42, weight: .medium))
                    .foregroundStyle(OracleColor.primaryDim.opacity(0.8))

                Circle()
                    .fill(OracleColor.primaryFixed.opacity(0.65))
                    .frame(width: 10, height: 10)
                    .blur(radius: 1.2)
                    .offset(x: -74, y: -54)

                Circle()
                    .fill(OracleColor.secondary.opacity(0.36))
                    .frame(width: 6, height: 6)
                    .blur(radius: 1.2)
                    .offset(x: 68, y: 66)
            }

            VStack(spacing: OracleSpacing.lg) {
                Text("THE VOID HAS NOT YET ECHOED")
                    .font(OracleTypography.displayMedium())
                    .foregroundStyle(
                        LinearGradient(
                            colors: [OracleColor.onSurface, OracleColor.onSurfaceVariant],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
                    .lineLimit(nil)
                    .minimumScaleFactor(1)
                    .frame(maxWidth: 360)

                Text("Your divination history will converge here. Why not pose a question to the cosmos first?")
                    .font(OracleTypography.bodyLarge())
                    .foregroundStyle(OracleColor.onSurfaceVariant.opacity(0.82))
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
                    .frame(maxWidth: 340)

                Button {
                    onStartDivination()
                } label: {
                    HStack(spacing: OracleSpacing.sm) {
                        Image(systemName: "sparkles")
                            .font(.system(size: 16, weight: .bold))
                        Text("START DIVINATION")
                            .tracking(2)
                    }
                    .frame(maxWidth: 300)
                }
                .buttonStyle(OraclePrimaryButtonStyle(mode: .oracle))
                .padding(.top, OracleSpacing.md)
            }
        }
        .padding(.horizontal, OracleSpacing.lg)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
