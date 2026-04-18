import Photos
import SwiftUI
import UIKit

struct AnswerResultView: View {
    let record: OracleHistoryRecord

    var body: some View {
        OracleAnswerRecordScreen(
            record: record,
            showsAskAgain: true,
            askAgainTitle: "Ask Again"
        )
    }
}

struct HistoryAnswerDetailView: View {
    let record: OracleHistoryRecord

    var body: some View {
        OracleAnswerRecordScreen(
            record: record,
            showsAskAgain: false,
            askAgainTitle: nil
        )
    }
}

private struct OracleAnswerRecordScreen: View {
    let record: OracleHistoryRecord
    let showsAskAgain: Bool
    let askAgainTitle: String?

    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var favoritesStore: OracleFavoritesStore
    @State private var posterWidth: CGFloat = 0
    @State private var sharePayload: ShareImagePayload?
    @State private var alertMessage = ""
    @State private var showingAlert = false
    @State private var notice: String?

    private var gateway: OracleGatewayType {
        record.gateway
    }

    private var isFavorited: Bool {
        favoritesStore.isFavorited(historyRecordID: record.id)
    }

    var body: some View {
        ZStack {
            OracleBackground(mode: .oracle)
            resultAtmosphere

            VStack(spacing: 0) {
                header

                ScrollView(showsIndicators: false) {
                    VStack(spacing: OracleSpacing.xxl) {
                        resultBadge
                        posterCard
                        actionGrid
                    }
                    .padding(.horizontal, OracleSpacing.md)
                    .padding(.top, OracleSpacing.xl)
                    .padding(.bottom, OracleSpacing.xxxl)
                    .frame(maxWidth: 720)
                    .frame(maxWidth: .infinity)
                }
            }
        }
        .toolbar(.hidden, for: .navigationBar)
        .onPreferenceChange(PosterWidthPreferenceKey.self) { width in
            if width > 0 {
                posterWidth = width
            }
        }
        .sheet(item: $sharePayload) { payload in
            ShareSheet(items: [payload.image])
        }
        .alert("Action Failed", isPresented: $showingAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(alertMessage)
        }
        .overlay(alignment: .top) {
            if let notice {
                Text(notice)
                    .font(OracleTypography.labelMedium())
                    .foregroundStyle(OracleColor.onSurface)
                    .padding(.horizontal, OracleSpacing.lg)
                    .padding(.vertical, OracleSpacing.sm)
                    .background {
                        Capsule(style: .continuous)
                            .fill(OracleColor.surfaceContainerHigh.opacity(0.92))
                    }
                    .padding(.top, 92)
                    .transition(.move(edge: .top).combined(with: .opacity))
            }
        }
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

                    Image(systemName: "sparkles")
                        .font(.system(size: 15, weight: .bold))
                        .foregroundStyle(OracleColor.primary)

                    Text("CYBER ORACLE")
                        .font(OracleTypography.headlineMedium())
                        .foregroundStyle(OracleColor.primary)
                        .textCase(.uppercase)
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

    private var resultAtmosphere: some View {
        ZStack {
            Circle()
                .fill(OracleColor.primaryDim.opacity(0.18))
                .frame(width: 280, height: 280)
                .blur(radius: 120)
                .offset(x: -150, y: 180)

            Circle()
                .fill(OracleColor.secondaryDim.opacity(0.10))
                .frame(width: 240, height: 240)
                .blur(radius: 120)
                .offset(x: 160, y: 420)
        }
        .ignoresSafeArea()
    }

    private var resultBadge: some View {
        HStack {
            Spacer()

            HStack(spacing: OracleSpacing.sm) {
                Circle()
                    .fill(OracleColor.primary)
                    .frame(width: 8, height: 8)

                Text("THE BOOK OPENS")
                    .font(OracleTypography.labelMedium())
                    .foregroundStyle(OracleColor.primary)
                    .tracking(2.2)
                    .textCase(.uppercase)
            }
            .padding(.horizontal, OracleSpacing.lg)
            .padding(.vertical, OracleSpacing.sm)
            .background {
                Capsule(style: .continuous)
                    .fill(OracleColor.primary.opacity(0.10))
                    .overlay {
                        Capsule(style: .continuous)
                            .stroke(OracleColor.primary.opacity(0.30), lineWidth: 1)
                    }
            }

            Spacer()
        }
    }

    private var posterCard: some View {
        AnswerPosterCard(gateway: gateway, question: displayQuestion, answer: record.answer)
            .background {
                GeometryReader { proxy in
                    Color.clear.preference(key: PosterWidthPreferenceKey.self, value: proxy.size.width)
                }
            }
    }

    private var actionGrid: some View {
        VStack(spacing: OracleSpacing.md) {
            if showsAskAgain, let askAgainTitle {
                Button {
                    dismiss()
                } label: {
                    HStack(spacing: OracleSpacing.sm) {
                        Image(systemName: "arrow.clockwise")
                        Text(askAgainTitle)
                    }
                }
                .buttonStyle(OraclePrimaryButtonStyle(mode: .oracle))
            }

            HStack(spacing: OracleSpacing.md) {
                Button {
                    toggleFavorite()
                } label: {
                    HStack(spacing: OracleSpacing.sm) {
                        Image(systemName: isFavorited ? "bookmark.fill" : "bookmark")
                        Text(isFavorited ? "Favorited" : "Favorite")
                    }
                }
                .buttonStyle(OracleSecondaryButtonStyle(mode: .oracle))

                Button("Save Image") {
                    savePosterImage()
                }
                .buttonStyle(OracleSecondaryButtonStyle(mode: .oracle))
            }

            Button {
                sharePosterImage()
            } label: {
                HStack(spacing: OracleSpacing.sm) {
                    Image(systemName: "square.and.arrow.up")
                    Text("Share with Friends")
                }
            }
            .buttonStyle(OracleAccentButtonStyle(accent: OracleColor.primaryDim))
        }
    }

    private func savePosterImage() {
        guard let image = renderPosterImage() else {
            showError("Couldn't generate the poster image.")
            return
        }

        PHPhotoLibrary.requestAuthorization(for: .addOnly) { status in
            guard status == .authorized || status == .limited else {
                Task { @MainActor in
                    showError("Photo library access was denied.")
                }
                return
            }

            PHPhotoLibrary.shared().performChanges({
                PHAssetCreationRequest.creationRequestForAsset(from: image)
            }) { success, error in
                Task { @MainActor in
                    if success {
                        showNotice("Saved to Photos")
                    } else {
                        showError(error?.localizedDescription ?? "Failed to save image.")
                    }
                }
            }
        }
    }

    private func sharePosterImage() {
        guard let image = renderPosterImage() else {
            showError("Couldn't generate the poster image.")
            return
        }

        sharePayload = ShareImagePayload(image: image)
    }

    private func toggleFavorite() {
        let didFavorite = favoritesStore.toggleFavorite(for: record)
        showNotice(didFavorite ? "Added to Favorites" : "Removed from Favorites")
    }

    private var displayQuestion: String {
        record.question
    }

    @MainActor
    private func renderPosterImage() -> UIImage? {
        let width = max(posterWidth, UIScreen.main.bounds.width - (OracleSpacing.md * 2))
        let renderer = ImageRenderer(
            content: AnswerPosterCard(gateway: gateway, question: displayQuestion, answer: record.answer)
                .frame(width: width)
        )
        renderer.scale = UIScreen.main.scale
        renderer.isOpaque = false
        return renderer.uiImage
    }

    @MainActor
    private func showError(_ message: String) {
        alertMessage = message
        showingAlert = true
    }

    @MainActor
    private func showNotice(_ message: String) {
        withAnimation(.spring(response: 0.35, dampingFraction: 0.9)) {
            notice = message
        }

        Task {
            try? await Task.sleep(for: .seconds(2))
            await MainActor.run {
                withAnimation(.easeOut(duration: 0.2)) {
                    notice = nil
                }
            }
        }
    }
}

private struct AnswerPosterCard: View {
    let gateway: OracleGatewayType
    let question: String
    let answer: OracleGeneratedAnswer

    private var appVersionText: String {
        let shortVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
        let resolvedVersion = shortVersion?.trimmingCharacters(in: .whitespacesAndNewlines)
        let displayVersion = (resolvedVersion?.isEmpty == false ? resolvedVersion : nil) ?? "1.0"
        return "v\(displayVersion)"
    }

    var body: some View {
        VStack(spacing: OracleSpacing.xxl) {
            HStack {
                Text("AnswerX / \(appVersionText)")
                    .font(OracleTypography.labelSmall())
                    .foregroundStyle(OracleColor.primary)
                    .tracking(1.4)
            }
            .opacity(0.66)

            VStack(alignment: .leading, spacing: OracleSpacing.xs) {
                Text("User Inquiry")
                    .font(OracleTypography.labelSmall())
                    .foregroundStyle(OracleColor.outline)
                    .tracking(1.8)
                    .textCase(.uppercase)

                Text("\"\(question)\"")
                    .font(OracleTypography.headlineMedium())
                    .foregroundStyle(OracleColor.onSurfaceVariant)
                    .italic()
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            VStack(spacing: OracleSpacing.lg) {
                HStack(spacing: OracleSpacing.md) {
                    Rectangle()
                        .fill(
                            LinearGradient(
                                colors: [.clear, gateway.accent.opacity(0.5)],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(height: 1)

                    Image(systemName: "sparkles")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundStyle(gateway.accent)

                    Rectangle()
                        .fill(
                            LinearGradient(
                                colors: [gateway.accent.opacity(0.5), .clear],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(height: 1)
                }

                AnswerPosterResponse(gateway: gateway, answer: answer)
            }

            HStack(alignment: .bottom) {
                VStack(alignment: .leading, spacing: OracleSpacing.xs) {
                    Text("CYBER ORACLE")
                        .font(OracleTypography.titleMedium())
                        .foregroundStyle(OracleColor.onSurface)

                    Text("Sanctuary of Truth")
                        .font(OracleTypography.labelSmall())
                        .foregroundStyle(OracleColor.outline)
                        .tracking(2.6)
                        .textCase(.uppercase)
                }

                Spacer()

                VStack(alignment: .trailing, spacing: OracleSpacing.xs) {
                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                        .fill(OracleColor.surfaceContainerHigh)
                        .frame(width: 48, height: 48)
                        .overlay {
                            VStack(spacing: 3) {
                                ForEach(0..<4, id: \.self) { row in
                                    HStack(spacing: 3) {
                                        ForEach(0..<4, id: \.self) { col in
                                            Rectangle()
                                                .fill((row + col).isMultiple(of: 2) ? gateway.accent.opacity(0.75) : OracleColor.onSurface.opacity(0.32))
                                                .frame(width: 6, height: 6)
                                        }
                                    }
                                }
                            }
                        }

                    Text("Verify on Blockchain")
                        .font(OracleTypography.labelSmall())
                        .foregroundStyle(OracleColor.onSurfaceVariant)
                }
            }
            .padding(.top, OracleSpacing.lg)
            .overlay(alignment: .top) {
                Rectangle()
                    .fill(OracleColor.onSurface.opacity(0.06))
                    .frame(height: 1)
            }
        }
        .padding(OracleSpacing.xl)
        .background {
            ZStack {
                RoundedRectangle(cornerRadius: OracleRadius.lg, style: .continuous)
                    .fill(gateway.accent.opacity(0.18))
                    .blur(radius: 30)

                RoundedRectangle(cornerRadius: OracleRadius.lg, style: .continuous)
                    .fill(
                        LinearGradient(
                            colors: [
                                OracleColor.surfaceVariant.opacity(0.40),
                                OracleColor.surface.opacity(0.82)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .overlay {
                        RoundedRectangle(cornerRadius: OracleRadius.lg, style: .continuous)
                            .stroke(OracleColor.onSurface.opacity(0.06), lineWidth: 1)
                    }
                    .overlay {
                        RoundedRectangle(cornerRadius: OracleRadius.lg, style: .continuous)
                            .fill(
                                LinearGradient(
                                    colors: [
                                        OracleColor.primary.opacity(0.09),
                                        gateway.accent.opacity(0.08)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                    }
            }
        }
    }
}

private struct AnswerPosterResponse: View {
    let gateway: OracleGatewayType
    let answer: OracleGeneratedAnswer

    var body: some View {
        (
            Text(answer.template + " ").foregroundStyle(OracleColor.onSurface)
            + Text(answer.emotion + " ").foregroundStyle(gateway.accent.opacity(0.92))
            + Text(answer.ending).foregroundStyle(OracleColor.onSurface)
        )
        .font(OracleTypography.displaySmall())
        .lineSpacing(4)
        .fixedSize(horizontal: false, vertical: true)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

private struct PosterWidthPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0

    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = max(value, nextValue())
    }
}

private struct ShareImagePayload: Identifiable {
    let id = UUID()
    let image: UIImage
}

private struct ShareSheet: UIViewControllerRepresentable {
    let items: [Any]

    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: items, applicationActivities: nil)
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}
