import SwiftUI

@main
struct answer_xApp: App {
    var body: some Scene {
        WindowGroup {
            AppRootView()
                .preferredColorScheme(.dark)
        }
    }
}

private struct AppRootView: View {
    @State private var showsSplash = false
    @StateObject private var historyStore = OracleHistoryStore()
    @StateObject private var favoritesStore = OracleFavoritesStore()

    var body: some View {
        ZStack {
            ContentView()
                .opacity(showsSplash ? 0 : 1)
                .allowsHitTesting(!showsSplash)

            if showsSplash {
                SplashScreenView {
                    withAnimation(.easeInOut(duration: 0.42)) {
                        showsSplash = false
                    }
                }
                .transition(.opacity)
                .zIndex(1)
            }
        }
        .background(OracleColor.surface)
        .environmentObject(historyStore)
        .environmentObject(favoritesStore)
    }
}

private struct SplashScreenView: View {
    let onComplete: () -> Void

    @State private var iconVisible = false
    @State private var titleVisible = false
    @State private var footerVisible = false
    @State private var glowPulse = false
    @State private var didStartSequence = false

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                OracleBackground(mode: .oracle)
                SplashParticleBackdrop(accent: OracleColor.primaryDim)

                Rectangle()
                    .fill(
                        LinearGradient(
                            colors: [
                                .clear,
                                OracleColor.primaryDim.opacity(0.18),
                                .clear
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .frame(width: 1.5)
                    .ignoresSafeArea()

                Circle()
                    .fill(OracleColor.primaryDim.opacity(glowPulse ? 0.24 : 0.18))
                    .frame(width: geometry.size.width * 0.95)
                    .blur(radius: glowPulse ? 110 : 90)
                    .offset(y: geometry.size.height * 0.04)
                    .scaleEffect(glowPulse ? 1.08 : 0.94)
                    .animation(.easeInOut(duration: 2.6).repeatForever(autoreverses: true), value: glowPulse)

                Circle()
                    .fill(OracleColor.secondaryDim.opacity(0.12))
                    .frame(width: geometry.size.width * 0.72)
                    .blur(radius: 120)
                    .offset(y: geometry.size.height * 0.12)

                VStack(spacing: 0) {
                    Spacer(minLength: geometry.size.height * 0.17)

                    VStack(spacing: 32) {
                        brandPortal(size: min(geometry.size.width * 0.46, 164))
                            .scaleEffect(iconVisible ? 1 : 0.88)
                            .opacity(iconVisible ? 1 : 0)

                        VStack(spacing: 20) {
                            Text("AnswerX")
                                .font(OracleTypography.displayLarge())
                                .foregroundStyle(
                                    LinearGradient(
                                        colors: [
                                            OracleColor.primaryFixed,
                                            OracleColor.primary,
                                            OracleColor.primaryDim
                                        ],
                                        startPoint: .top,
                                        endPoint: .bottom
                                    )
                                )
                                .shadow(color: OracleColor.primary.opacity(0.34), radius: 18, x: 0, y: 8)
                                .tracking(-2)
                                .minimumScaleFactor(0.8)

                            Text("CONNECT TO THE VOID")
                                .font(OracleTypography.labelMedium())
                                .foregroundStyle(OracleColor.onSurfaceVariant.opacity(0.72))
                                .tracking(6)
                        }
                        .offset(y: titleVisible ? 0 : 18)
                        .opacity(titleVisible ? 1 : 0)
                    }

                    Spacer()

                    VStack(spacing: OracleSpacing.sm) {
                        ZStack(alignment: .leading) {
                            Capsule(style: .continuous)
                                .fill(OracleColor.surfaceContainerHigh.opacity(0.78))

                            Capsule(style: .continuous)
                                .fill(
                                    LinearGradient(
                                        colors: [OracleColor.primaryFixed, OracleColor.primaryDim],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .frame(width: glowPulse ? 16 : 10)
                                .animation(.easeInOut(duration: 1.3).repeatForever(autoreverses: true), value: glowPulse)
                        }
                        .frame(width: 52, height: 4)

                        Text("INITIALIZING RITUAL")
                            .font(OracleTypography.labelMedium())
                            .foregroundStyle(OracleColor.outline.opacity(0.56))
                            .tracking(3)
                    }
                    .padding(.bottom, max(28, geometry.safeAreaInsets.bottom + 10))
                    .offset(y: footerVisible ? 0 : 16)
                    .opacity(footerVisible ? 1 : 0)
                }
                .padding(.horizontal, OracleSpacing.xl)
            }
            .ignoresSafeArea()
        }
        .task {
            guard !didStartSequence else { return }

            didStartSequence = true
            glowPulse = true

            withAnimation(.spring(response: 0.78, dampingFraction: 0.84)) {
                iconVisible = true
            }

            try? await Task.sleep(nanoseconds: 180_000_000)

            withAnimation(.easeOut(duration: 0.55)) {
                titleVisible = true
            }

            try? await Task.sleep(nanoseconds: 150_000_000)

            withAnimation(.easeOut(duration: 0.48)) {
                footerVisible = true
            }

            try? await Task.sleep(nanoseconds: 1_250_000_000)

            onComplete()
        }
    }

    @ViewBuilder
    private func brandPortal(size: CGFloat) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 42, style: .continuous)
                .fill(OracleColor.primaryDim.opacity(0.22))
                .frame(width: size + 44, height: size + 44)
                .blur(radius: 28)

            RoundedRectangle(cornerRadius: 42, style: .continuous)
                .fill(OracleColor.surfaceContainerLow.opacity(0.96))
                .overlay {
                    RoundedRectangle(cornerRadius: 42, style: .continuous)
                        .fill(
                            LinearGradient(
                                colors: [
                                    OracleColor.primaryContainer.opacity(0.36),
                                    .clear
                                ],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                }
                .frame(width: size + 32, height: size + 32)

            RoundedRectangle(cornerRadius: 30, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [
                            Color(hex: "FFFDFE"),
                            Color(hex: "EEE7F2")
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: size, height: size)
                .overlay {
                    RoundedRectangle(cornerRadius: 30, style: .continuous)
                        .stroke(OracleColor.void.opacity(0.14), lineWidth: 1)
                }

            Image("SplashBrand")
                .resizable()
                .scaledToFit()
                .frame(width: size * 0.72, height: size * 0.72)
                .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        }
    }
}

private struct SplashParticleBackdrop: View {
    let accent: Color

    var body: some View {
        Canvas { context, size in
            let step: CGFloat = 36

            for x in stride(from: 0, through: size.width, by: step) {
                for y in stride(from: 0, through: size.height, by: step) {
                    let rect = CGRect(x: x + 4, y: y + 4, width: 1.5, height: 1.5)
                    context.fill(Path(ellipseIn: rect), with: .color(accent.opacity(0.10)))
                }
            }
        }
        .opacity(0.18)
        .ignoresSafeArea()
    }
}
