import SwiftUI

struct AnswerDetailView: View {
    let gateway: OracleGatewayType
    let onDraw: (String) -> Void

    @Environment(\.dismiss) private var dismiss
    @State private var question = ""
    @State private var validationMessage: String?
    @State private var validationDismissTask: Task<Void, Never>?

    private let emptyValidationMessage = "Write one real question first, then the void can answer."
    private let englishOnlyValidationMessage = "Only English letters are supported here right now."

    var body: some View {
        ZStack {
            OracleBackground(mode: .oracle)
            OracleParticleField(accent: gateway.accent)

            VStack(spacing: 0) {
                header

                ScrollView(showsIndicators: false) {
                    VStack(spacing: OracleSpacing.xxxl) {
                        inputSection
                        promptSection
                        actionSection
                    }
                    .padding(.horizontal, OracleSpacing.lg)
                    .padding(.top, OracleSpacing.xxl)
                    .padding(.bottom, OracleSpacing.xxxl)
                    .frame(maxWidth: 720)
                    .frame(maxWidth: .infinity)
                }
            }
        }
        .toolbar(.hidden, for: .navigationBar)
        .onChange(of: question) { _, newValue in
            let sanitized = OracleAnswerBook.sanitizeEnglishQuestion(newValue)

            if sanitized != newValue {
                question = sanitized
                showValidationMessage(englishOnlyValidationMessage, autoHideAfter: 1.8)
                return
            }

            if validationMessage == emptyValidationMessage,
               !OracleAnswerBook.normalizeQuestion(newValue).isEmpty {
                clearValidationMessage()
            }
        }
    }

    private var header: some View {
        VStack(spacing: 0) {
            HStack(spacing: OracleSpacing.md) {
                HStack(spacing: OracleSpacing.sm) {
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

                    Text("CYBER ORACLE")
                        .font(OracleTypography.headlineMedium())
                        .foregroundStyle(OracleColor.primary)
                        .tracking(2.0)
                }

                Spacer()

                ZStack {
                    Circle()
                        .fill(gateway.accent.opacity(0.16))
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
                                colors: [OracleColor.onSurface, gateway.accent],
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

    private var inputSection: some View {
        VStack(alignment: .leading, spacing: OracleSpacing.sm) {
            Text("\(gateway.title.uppercased()) / CONSULT THE VOID")
                .font(OracleTypography.labelSmall())
                .foregroundStyle(OracleColor.onSurfaceVariant.opacity(0.7))
                .tracking(3.0)

            ZStack(alignment: .topLeading) {
                if question.isEmpty {
                    Text("Type what you want to ask...")
                        .font(OracleTypography.displaySmall())
                        .foregroundStyle(OracleColor.onSurfaceVariant.opacity(0.45))
                        .padding(.top, 8)
                        .allowsHitTesting(false)
                }

                TextEditor(text: $question)
                    .scrollContentBackground(.hidden)
                    .font(.custom("SpaceGrotesk-Bold", size: 40))
                    .foregroundStyle(OracleColor.onSurface)
                    .frame(minHeight: 156)
                    .padding(.horizontal, -5)
                    .padding(.vertical, -8)
            }
            .padding(.vertical, OracleSpacing.sm)
            .overlay(alignment: .bottom) {
                LinearGradient(
                    colors: [
                        gateway.accent.opacity(0.55),
                        OracleColor.outlineVariant.opacity(OracleOpacity.ghostBorder)
                    ],
                    startPoint: .leading,
                    endPoint: .trailing
                )
                .frame(height: 1)
            }

            if let validationMessage {
                Text(validationMessage)
                    .font(OracleTypography.bodySmall())
                    .foregroundStyle(OracleColor.secondary.opacity(0.92))
                    .transition(.move(edge: .top).combined(with: .opacity))
            }
        }
    }

    private var promptSection: some View {
        VStack(alignment: .leading, spacing: OracleSpacing.lg) {
            Text("Inspirations for your ritual")
                .font(OracleTypography.labelSmall())
                .foregroundStyle(OracleColor.onSurfaceVariant.opacity(0.45))
                .tracking(2.4)
                .textCase(.uppercase)

            LazyVGrid(
                columns: [GridItem(.adaptive(minimum: 160), spacing: OracleSpacing.sm)],
                alignment: .leading,
                spacing: OracleSpacing.sm
            ) {
                ForEach(gateway.promptExamples, id: \.self) { prompt in
                    Button {
                        question = OracleAnswerBook.sanitizeEnglishQuestion(prompt)
                        clearValidationMessage()
                    } label: {
                        OraclePromptChip(title: prompt, accent: gateway.accent)
                    }
                    .buttonStyle(.plain)
                }
            }

            HStack {
                Spacer(minLength: 0)

                Text(gateway.guidanceNote)
                    .font(OracleTypography.bodySmall())
                    .foregroundStyle(OracleColor.onSurfaceVariant.opacity(0.34))
                    .italic()
                    .multilineTextAlignment(.trailing)
                    .frame(maxWidth: 220, alignment: .trailing)
            }
        }
    }

    private var actionSection: some View {
        VStack(spacing: OracleSpacing.md) {
            Button {
                submitQuestion()
            } label: {
                HStack(spacing: OracleSpacing.sm) {
                    Text("Draw the Answer")
                    Image(systemName: "sparkles")
                        .font(.system(size: 20, weight: .bold))
                }
            }
            .buttonStyle(OracleAccentButtonStyle(accent: gateway.accent))

            Text("Awaiting Connection")
                .font(OracleTypography.labelSmall())
                .foregroundStyle(gateway.accent.opacity(0.6))
                .tracking(4.0)
                .textCase(.uppercase)
        }
        .frame(maxWidth: .infinity)
    }

    private func submitQuestion() {
        let sanitized = OracleAnswerBook.sanitizeEnglishQuestion(question)
        if sanitized != question {
            question = sanitized
            showValidationMessage(englishOnlyValidationMessage, autoHideAfter: 1.8)
            return
        }

        let normalized = OracleAnswerBook.normalizeQuestion(sanitized)
        guard !normalized.isEmpty else {
            showValidationMessage(emptyValidationMessage)
            return
        }

        onDraw(normalized)
    }

    private func showValidationMessage(_ message: String, autoHideAfter delay: Double? = nil) {
        validationDismissTask?.cancel()

        withAnimation(.spring(response: 0.32, dampingFraction: 0.88)) {
            validationMessage = message
        }

        guard let delay else { return }

        validationDismissTask = Task {
            try? await Task.sleep(for: .seconds(delay))
            guard !Task.isCancelled else { return }

            await MainActor.run {
                if validationMessage == message {
                    clearValidationMessage()
                }
            }
        }
    }

    private func clearValidationMessage() {
        validationDismissTask?.cancel()
        validationDismissTask = nil

        guard validationMessage != nil else { return }

        withAnimation(.easeOut(duration: 0.2)) {
            validationMessage = nil
        }
    }
}

private struct OracleParticleField: View {
    let accent: Color

    var body: some View {
        GeometryReader { geometry in
            Canvas { context, size in
                let step: CGFloat = 40
                for x in stride(from: 0, through: size.width, by: step) {
                    for y in stride(from: 0, through: size.height, by: step) {
                        let rect = CGRect(x: x, y: y, width: 1.5, height: 1.5)
                        context.fill(Path(ellipseIn: rect), with: .color(accent.opacity(0.08)))
                    }
                }
            }
            .opacity(0.25)
            .overlay {
                Circle()
                    .fill(accent.opacity(0.16))
                    .frame(width: geometry.size.width * 0.45)
                    .blur(radius: 120)
                    .offset(x: -geometry.size.width * 0.22, y: -geometry.size.height * 0.18)
            }
            .overlay {
                Circle()
                    .fill(OracleColor.secondary.opacity(0.08))
                    .frame(width: geometry.size.width * 0.35)
                    .blur(radius: 100)
                    .offset(x: geometry.size.width * 0.32, y: geometry.size.height * 0.34)
            }
        }
        .ignoresSafeArea()
    }
}
