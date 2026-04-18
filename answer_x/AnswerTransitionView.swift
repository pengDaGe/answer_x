import Foundation
import SwiftUI

struct AnswerTransitionView: View {
    let gateway: OracleGatewayType
    let question: String
    let onComplete: () -> Void

    @State private var progress: CGFloat = 0
    @State private var corePulse = false
    @State private var ringPulse = false
    @State private var orbitRotation = Angle.zero
    @State private var didTriggerCompletion = false

    var body: some View {
        ZStack {
            OracleBackground(mode: .oracle)

            Circle()
                .fill(OracleColor.primaryDim.opacity(0.12))
                .frame(width: 320, height: 320)
                .blur(radius: 120)
                .offset(y: -40)

            VStack(spacing: 0) {
                Spacer(minLength: 80)

                Text("AnswerX")
                    .font(OracleTypography.displayMedium())
                    .foregroundStyle(OracleColor.primary)
                    .tracking(2.0)
                    .padding(.bottom, 72)

                orbSection

                Text("Connecting to the Void...")
                    .font(OracleTypography.headlineMedium())
                    .foregroundStyle(OracleColor.onSurface)
                    .padding(.top, 72)

                Text("Loading...")
                    .font(OracleTypography.labelMedium())
                    .foregroundStyle(OracleColor.primaryFixed.opacity(0.82))
                    .tracking(3.0)
                    .textCase(.uppercase)
                    .padding(.top, OracleSpacing.lg)

                progressBar
                    .padding(.top, OracleSpacing.xxxl)
                    .padding(.horizontal, 82)

                Spacer()
            }
            .padding(.horizontal, OracleSpacing.lg)
        }
        .toolbar(.hidden, for: .navigationBar)
        .task {
            startAnimation()
        }
    }

    private var orbSection: some View {
        let orbitRadius: CGFloat = 100

        return ZStack {
            Circle()
                .fill(OracleColor.primaryDim.opacity(ringPulse ? 0.30 : 0.18))
                .frame(width: 220, height: 220)
                .blur(radius: ringPulse ? 58 : 42)
                .animation(.easeInOut(duration: 1.8).repeatForever(autoreverses: true), value: ringPulse)

            Circle()
                .fill(
                    RadialGradient(
                        colors: [
                            OracleColor.surfaceContainerHigh,
                            OracleColor.surface,
                            OracleColor.void
                        ],
                        center: .center,
                        startRadius: 10,
                        endRadius: 90
                    )
                )
                .frame(width: 180, height: 180)
                .overlay {
                    Circle()
                        .stroke(OracleColor.onSurface.opacity(0.06), lineWidth: 1)
                }

            Circle()
                .fill(
                    LinearGradient(
                        colors: [OracleColor.primaryFixed, OracleColor.primary],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 96, height: 96)
                .scaleEffect(corePulse ? 1.04 : 0.94)
                .shadow(color: OracleColor.primary.opacity(0.65), radius: 28)
                .animation(.easeInOut(duration: 1.2).repeatForever(autoreverses: true), value: corePulse)

            ZStack {
                Circle()
                    .fill(OracleColor.tertiary)
                    .frame(width: 12, height: 12)
                    .shadow(color: OracleColor.tertiary.opacity(0.8), radius: 8)
                    .offset(orbitOffset(radius: orbitRadius, degrees: -90))

                Circle()
                    .fill(OracleColor.secondary)
                    .frame(width: 10, height: 10)
                    .shadow(color: OracleColor.secondary.opacity(0.8), radius: 8)
                    .offset(orbitOffset(radius: orbitRadius, degrees: 42))
            }
            .rotationEffect(orbitRotation)
            .animation(.linear(duration: 2.8).repeatForever(autoreverses: false), value: orbitRotation)
        }
    }

    private var progressBar: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Capsule(style: .continuous)
                    .fill(OracleColor.surfaceContainerHigh)

                Capsule(style: .continuous)
                    .fill(
                        LinearGradient(
                            colors: [OracleColor.primaryFixed, OracleColor.primary],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(width: geometry.size.width * progress)
                    .overlay(alignment: .trailing) {
                        Capsule(style: .continuous)
                            .fill(Color.white.opacity(0.25))
                            .frame(width: 30)
                            .blur(radius: 6)
                            .opacity(progress > 0.02 ? 1 : 0)
                    }
            }
        }
        .frame(height: 6)
    }

    private func startAnimation() {
        guard !didTriggerCompletion else { return }

        corePulse = true
        ringPulse = true
        orbitRotation = .degrees(360)

        withAnimation(.linear(duration: 2.6)) {
            progress = 1
        }

        didTriggerCompletion = true

        Task {
            try? await Task.sleep(for: .milliseconds(2600))
            await MainActor.run {
                onComplete()
            }
        }
    }

    private func orbitOffset(radius: CGFloat, degrees: Double) -> CGSize {
        let radians = degrees * .pi / 180
        return CGSize(
            width: radius * CGFloat(cos(radians)),
            height: radius * CGFloat(sin(radians))
        )
    }
}
