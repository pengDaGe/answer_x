import SwiftUI

struct OracleTopBar: View {
    let mode: OracleMode

    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: OracleSpacing.sm) {
                HStack(spacing: OracleSpacing.xs) {
                    Image(systemName: "sparkles")
                        .font(.system(size: 15, weight: .bold))
                        .foregroundStyle(mode.accent)

                    Text("CYBER ORACLE")
                        .font(OracleTypography.headlineMedium())
                        .foregroundStyle(mode.accent)
                        .textCase(.uppercase)
                }

                Spacer()

                ZStack {
                    Circle()
                        .fill(mode.accent.opacity(0.16))
                        .blur(radius: 12)

                    Circle()
                        .fill(OracleColor.surfaceContainerHigh)
                        .overlay {
                            Circle()
                                .stroke(mode.accent.opacity(0.28), lineWidth: 1)
                        }

                    Image(systemName: "person.crop.circle.fill")
                        .font(.system(size: 24))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [OracleColor.onSurface, mode.accent],
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
                colors: [mode.accent.opacity(0.16), .clear],
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

struct OracleBackground: View {
    let mode: OracleMode

    init(mode: OracleMode = .oracle) {
        self.mode = mode
    }

    var body: some View {
        ZStack {
            OracleColor.surface

            RadialGradient(
                colors: [
                    mode.accent.opacity(0.24),
                    OracleColor.void.opacity(0.0)
                ],
                center: .topTrailing,
                startRadius: 40,
                endRadius: 420
            )
            .blur(radius: 10)

            LinearGradient(
                colors: [
                    OracleColor.primaryContainer.opacity(0.35),
                    OracleColor.surface.opacity(0.0),
                    OracleColor.secondaryDim.opacity(0.18)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        }
        .ignoresSafeArea()
    }
}

struct OracleOrbGlyph: View {
    let mode: OracleMode

    var body: some View {
        ZStack {
            Circle()
                .fill(mode.accent.opacity(0.18))
                .blur(radius: 30)
                .frame(width: 180, height: 180)

            Image(systemName: "book.pages.fill")
                .font(.system(size: 86, weight: .medium))
                .foregroundStyle(
                    LinearGradient(
                        colors: [
                            OracleColor.onSurface.opacity(0.98),
                            mode.accent.opacity(0.96),
                            OracleColor.secondary.opacity(0.88)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .shadow(color: mode.accent.opacity(0.45), radius: 28, x: 0, y: 0)

            Image(systemName: "sparkle")
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(mode.accent.opacity(0.85))
                .offset(x: -58, y: -20)

            Image(systemName: "sparkle")
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(mode.accent.opacity(0.85))
                .offset(x: 60, y: 18)

            Image(systemName: "sparkle")
                .font(.system(size: 13, weight: .semibold))
                .foregroundStyle(mode.accent.opacity(0.85))
                .offset(x: -26, y: 72)
        }
    }
}

struct OraclePortal<Content: View>: View {
    let mode: OracleMode
    private let content: Content

    init(mode: OracleMode = .oracle, @ViewBuilder content: () -> Content) {
        self.mode = mode
        self.content = content()
    }

    var body: some View {
        ZStack {
            Circle()
                .fill(mode.accentDim.opacity(0.28))
                .blur(radius: OracleBlur.portalGlow)
                .scaleEffect(0.9)

            Circle()
                .fill(.ultraThinMaterial)
                .overlay {
                    Circle()
                        .fill(OracleColor.surfaceVariant.opacity(OracleOpacity.glassFill))
                }
                .overlay {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [
                                    mode.portalGradient[0].opacity(OracleOpacity.gradientOverlay),
                                    mode.portalGradient[1].opacity(OracleOpacity.gradientOverlay)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                }
                .overlay {
                    Circle()
                        .stroke(
                            AngularGradient(
                                colors: mode.portalGradient + [mode.portalGradient[0]],
                                center: .center
                            ),
                            lineWidth: 2
                        )
                }
                .overlay {
                    Circle()
                        .stroke(OracleColor.onSurface.opacity(OracleOpacity.innerGlow), lineWidth: 1)
                        .padding(10)
                }

            content
                .padding(OracleSpacing.xxl)
        }
        .aspectRatio(1, contentMode: .fit)
    }
}

struct OracleBentoCard: View {
    let mode: OracleMode
    let systemImage: String
    let iconColor: Color
    let eyebrow: String
    let title: String
    let minHeight: CGFloat?

    var body: some View {
        VStack(alignment: .leading, spacing: OracleSpacing.sm) {
            Image(systemName: systemImage)
                .font(.system(size: 20, weight: .medium))
                .foregroundStyle(iconColor)
                .padding(.bottom, OracleSpacing.xs)

            Text(eyebrow)
                .font(OracleTypography.labelSmall())
                .foregroundStyle(OracleColor.onSurfaceVariant)
                .tracking(1.8)

            Text(title)
                .font(OracleTypography.headlineSmall())
                .foregroundStyle(OracleColor.onSurface)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(OracleSpacing.lg)
        .frame(maxWidth: .infinity, minHeight: minHeight, alignment: .topLeading)
        .oracleGlassCard(mode: mode, cornerRadius: OracleRadius.md)
    }
}

struct OracleInsightCard: View {
    let mode: OracleMode
    let quote: String
    let response: String
    let responseColor: Color
    let timestamp: String

    var body: some View {
        HStack(alignment: .top, spacing: OracleSpacing.md) {
            VStack(alignment: .leading, spacing: OracleSpacing.sm) {
                Text("\"\(quote)\"")
                    .font(OracleTypography.bodyMedium())
                    .foregroundStyle(OracleColor.onSurfaceVariant)
                    .italic()

                HStack(spacing: OracleSpacing.md) {
                    Text("Response: \(response)")
                        .font(OracleTypography.labelSmall())
                        .foregroundStyle(responseColor)
                        .tracking(1.2)

                    Text(timestamp)
                        .font(OracleTypography.labelSmall())
                        .foregroundStyle(OracleColor.outline)
                        .tracking(1.0)
                }
            }

            Spacer(minLength: OracleSpacing.md)

            Image(systemName: "arrow.up.right")
                .font(.system(size: 15, weight: .semibold))
                .foregroundStyle(OracleColor.onSurfaceVariant.opacity(0.9))
        }
        .padding(OracleSpacing.lg)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background {
            RoundedRectangle(cornerRadius: OracleRadius.md, style: .continuous)
                .fill(OracleColor.surfaceContainerLow)
        }
    }
}

struct OracleHistoryCard: View {
    let record: OracleHistoryRecord

    var body: some View {
        VStack(alignment: .leading, spacing: OracleSpacing.md) {
            HStack(alignment: .top, spacing: OracleSpacing.md) {
                Text(record.gateway.title.uppercased())
                    .font(OracleTypography.labelSmall())
                    .foregroundStyle(record.gateway.accent)
                    .tracking(2)

                Spacer()

                Text(record.timestampText)
                    .font(OracleTypography.labelSmall())
                    .foregroundStyle(OracleColor.outline)
                    .tracking(1.2)
            }

            Text("\"\(record.question)\"")
                .font(OracleTypography.bodyMedium())
                .foregroundStyle(OracleColor.onSurfaceVariant)
                .italic()
                .fixedSize(horizontal: false, vertical: true)

            Text(record.answerText)
                .font(OracleTypography.headlineSmall())
                .foregroundStyle(OracleColor.onSurface)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(OracleSpacing.lg)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background {
            RoundedRectangle(cornerRadius: OracleRadius.md, style: .continuous)
                .fill(OracleColor.surfaceContainerLow)
                .overlay {
                    RoundedRectangle(cornerRadius: OracleRadius.md, style: .continuous)
                        .stroke(record.gateway.accent.opacity(0.12), lineWidth: 1)
                }
        }
    }
}

struct OracleFavoriteCard: View {
    let record: OracleFavoriteRecord

    var body: some View {
        VStack(alignment: .leading, spacing: OracleSpacing.md) {
            HStack(alignment: .top, spacing: OracleSpacing.md) {
                Text(record.gateway.title.uppercased())
                    .font(OracleTypography.labelSmall())
                    .foregroundStyle(record.gateway.accent)
                    .tracking(2)

                Spacer()

                Text(record.timestampText)
                    .font(OracleTypography.labelSmall())
                    .foregroundStyle(OracleColor.outline)
                    .tracking(1.2)
            }

            Text("\"\(record.question)\"")
                .font(OracleTypography.bodyMedium())
                .foregroundStyle(OracleColor.onSurfaceVariant)
                .italic()
                .fixedSize(horizontal: false, vertical: true)

            Text(record.answerText)
                .font(OracleTypography.headlineSmall())
                .foregroundStyle(OracleColor.onSurface)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(OracleSpacing.lg)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background {
            RoundedRectangle(cornerRadius: OracleRadius.md, style: .continuous)
                .fill(OracleColor.surfaceContainerLow)
                .overlay {
                    RoundedRectangle(cornerRadius: OracleRadius.md, style: .continuous)
                        .stroke(record.gateway.accent.opacity(0.12), lineWidth: 1)
                }
        }
    }
}

struct OracleModeTile: View {
    let title: String
    let subtitle: String
    let systemImage: String
    let accent: Color
    let glowOpacity: Double
    let fillIcon: Bool

    init(
        title: String,
        subtitle: String,
        systemImage: String,
        accent: Color,
        glowOpacity: Double = 0.20,
        fillIcon: Bool = false
    ) {
        self.title = title
        self.subtitle = subtitle
        self.systemImage = systemImage
        self.accent = accent
        self.glowOpacity = glowOpacity
        self.fillIcon = fillIcon
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            VStack(alignment: .leading, spacing: OracleSpacing.md) {
                Group {
                    if fillIcon {
                        Image(systemName: systemImage)
                            .symbolVariant(.fill)
                    } else {
                        Image(systemName: systemImage)
                    }
                }
                .font(.system(size: 30, weight: .medium))
                .foregroundStyle(accent)

                Text(title)
                    .font(OracleTypography.titleMedium())
                    .foregroundStyle(accent)
                    .fixedSize(horizontal: false, vertical: true)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }

            Spacer(minLength: OracleSpacing.md)

            Text(subtitle)
                .font(OracleTypography.labelSmall())
                .foregroundStyle(OracleColor.onSurfaceVariant)
                .tracking(1.0)
                .textCase(.uppercase)
        }
        .padding(OracleSpacing.lg)
        .frame(maxWidth: .infinity, minHeight: 160, alignment: .leading)
        .background {
            ZStack {
                RoundedRectangle(cornerRadius: OracleRadius.md, style: .continuous)
                    .fill(accent.opacity(glowOpacity))
                    .blur(radius: 24)

                RoundedRectangle(cornerRadius: OracleRadius.md, style: .continuous)
                    .fill(.ultraThinMaterial)
                    .overlay {
                        RoundedRectangle(cornerRadius: OracleRadius.md, style: .continuous)
                            .fill(OracleColor.surfaceVariant.opacity(OracleOpacity.glassFill))
                    }
                    .overlay {
                        RoundedRectangle(cornerRadius: OracleRadius.md, style: .continuous)
                            .fill(
                                LinearGradient(
                                    colors: [
                                        accent.opacity(0.10),
                                        .clear
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                    }
                    .overlay {
                        RoundedRectangle(cornerRadius: OracleRadius.md, style: .continuous)
                            .stroke(OracleColor.onSurface.opacity(OracleOpacity.innerGlow), lineWidth: 1)
                    }
            }
        }
        .aspectRatio(1, contentMode: .fit)
    }
}

struct OracleInsightBanner: View {
    let eyebrow: String
    let message: String
    let accent: Color

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            RoundedRectangle(cornerRadius: OracleRadius.lg, style: .continuous)
                .fill(OracleColor.surfaceContainerLow)

            RoundedRectangle(cornerRadius: OracleRadius.lg, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [
                            accent.opacity(0.14),
                            .clear
                        ],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )

            Capsule(style: .continuous)
                .fill(accent)
                .frame(width: 6)
                .padding(.vertical, OracleSpacing.lg)
                .padding(.leading, OracleSpacing.md)
                .frame(maxWidth: .infinity, alignment: .leading)

            VStack(alignment: .leading, spacing: OracleSpacing.md) {
                Text(eyebrow)
                    .font(OracleTypography.labelMedium())
                    .foregroundStyle(accent)
                    .tracking(3.0)
                    .textCase(.uppercase)

                Text(message)
                    .font(OracleTypography.headlineMedium())
                    .foregroundStyle(OracleColor.onSurface)
                    .italic()
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(OracleSpacing.xl)
            .frame(maxWidth: .infinity, alignment: .leading)

            Image(systemName: "sparkles")
                .font(.system(size: 88, weight: .regular))
                .foregroundStyle(OracleColor.onSurface.opacity(0.08))
                .offset(x: 10, y: 10)
        }
    }
}

struct OraclePromptChip: View {
    let title: String
    let accent: Color

    var body: some View {
        Text(title)
            .font(OracleTypography.bodySmall())
            .foregroundStyle(OracleColor.onSurfaceVariant)
            .padding(.horizontal, OracleSpacing.md)
            .padding(.vertical, OracleSpacing.sm)
            .background {
                Capsule(style: .continuous)
                    .fill(OracleColor.surfaceContainerLow)
                    .overlay {
                        Capsule(style: .continuous)
                            .stroke(accent.opacity(0.18), lineWidth: 1)
                    }
            }
    }
}

struct OracleBottomNavigation: View {
    let mode: OracleMode
    let selected: OracleTab
    let onSelect: (OracleTab) -> Void

    var body: some View {
        HStack(spacing: 0) {
            ForEach(OracleTab.allCases) { tab in
                Button {
                    onSelect(tab)
                } label: {
                    VStack(spacing: OracleSpacing.xs) {
                        Image(systemName: tab == selected ? tab.filledSystemImage : tab.systemImage)
                            .font(.system(size: 18, weight: .medium))

                        Text(tab.title)
                            .font(OracleTypography.labelSmall())
                            .tracking(1.3)
                    }
                    .foregroundStyle(tab == selected ? mode.accent : OracleColor.outline)
                    .frame(maxWidth: .infinity)
                    .shadow(color: tab == selected ? mode.accent.opacity(0.45) : .clear, radius: 10)
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, OracleSpacing.md)
        .padding(.top, OracleSpacing.md)
        .padding(.bottom, OracleSpacing.lg + OracleSpacing.xs)
        .background {
            RoundedRectangle(cornerRadius: OracleRadius.lg, style: .continuous)
                .fill(.ultraThinMaterial)
                .overlay {
                    RoundedRectangle(cornerRadius: OracleRadius.lg, style: .continuous)
                        .fill(OracleColor.void.opacity(0.42))
                }
                .shadow(color: mode.accent.opacity(0.15), radius: 28, x: 0, y: -8)
        }
        .padding(.horizontal, OracleSpacing.sm)
    }
}

enum OracleTab: CaseIterable, Identifiable {
    case home
    case void
    case history
    case profile

    var id: String { title }

    var title: String {
        switch self {
        case .home:
            return "Home"
        case .void:
            return "Void"
        case .history:
            return "History"
        case .profile:
            return "Profile"
        }
    }

    var systemImage: String {
        switch self {
        case .home:
            return "sparkles"
        case .void:
            return "square.grid.2x2"
        case .history:
            return "clock.arrow.circlepath"
        case .profile:
            return "person.crop.circle"
        }
    }

    var filledSystemImage: String {
        switch self {
        case .home:
            return "sparkles"
        case .void:
            return "square.grid.2x2.fill"
        case .history:
            return "clock.arrow.circlepath"
        case .profile:
            return "person.crop.circle.fill"
        }
    }
}

struct OracleAccentButtonStyle: ButtonStyle {
    let accent: Color

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(OracleTypography.titleMedium())
            .foregroundStyle(OracleColor.onPrimary)
            .padding(.horizontal, OracleSpacing.xl)
            .padding(.vertical, OracleSpacing.md)
            .background(
                RoundedRectangle(cornerRadius: OracleRadius.md, style: .continuous)
                    .fill(accent)
            )
            .overlay {
                RoundedRectangle(cornerRadius: OracleRadius.md, style: .continuous)
                    .fill(accent.opacity(configuration.isPressed ? 0.18 : 0.12))
                    .blur(radius: OracleBlur.ambientGlow)
            }
            .scaleEffect(configuration.isPressed ? 0.985 : 1.0)
            .animation(.easeOut(duration: 0.18), value: configuration.isPressed)
    }
}

struct OraclePrimaryButtonStyle: ButtonStyle {
    let mode: OracleMode

    init(mode: OracleMode = .oracle) {
        self.mode = mode
    }

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(OracleTypography.titleMedium())
            .foregroundStyle(OracleColor.onPrimary)
            .padding(.horizontal, OracleSpacing.lg)
            .padding(.vertical, OracleSpacing.md)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: OracleRadius.md, style: .continuous)
                    .fill(mode.accent)
            )
            .overlay {
                RoundedRectangle(cornerRadius: OracleRadius.md, style: .continuous)
                    .fill(mode.accentDim.opacity(configuration.isPressed ? 0.18 : 0.10))
                    .blur(radius: OracleBlur.ambientGlow)
            }
            .scaleEffect(configuration.isPressed ? 0.985 : 1.0)
            .animation(.easeOut(duration: 0.18), value: configuration.isPressed)
    }
}

struct OracleSecondaryButtonStyle: ButtonStyle {
    let mode: OracleMode

    init(mode: OracleMode = .oracle) {
        self.mode = mode
    }

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(OracleTypography.titleMedium())
            .foregroundStyle(OracleColor.onSurface)
            .padding(.horizontal, OracleSpacing.lg)
            .padding(.vertical, OracleSpacing.md)
            .frame(maxWidth: .infinity)
            .background {
                RoundedRectangle(cornerRadius: OracleRadius.md, style: .continuous)
                    .fill(.ultraThinMaterial)
                    .overlay {
                        RoundedRectangle(cornerRadius: OracleRadius.md, style: .continuous)
                            .fill(OracleColor.surfaceVariant.opacity(OracleOpacity.glassFill))
                    }
                    .overlay {
                        RoundedRectangle(cornerRadius: OracleRadius.md, style: .continuous)
                            .stroke(mode.accent.opacity(0.20), lineWidth: 1)
                    }
            }
            .opacity(configuration.isPressed ? 0.82 : 1.0)
            .animation(.easeOut(duration: 0.18), value: configuration.isPressed)
    }
}

extension View {
    func oracleGlassCard(mode: OracleMode = .oracle, cornerRadius: CGFloat = OracleRadius.lg) -> some View {
        modifier(OracleGlassCardModifier(mode: mode, cornerRadius: cornerRadius))
    }

    func oracleHollowInput(mode: OracleMode = .oracle) -> some View {
        modifier(OracleHollowInputModifier(mode: mode))
    }
}

private struct OracleGlassCardModifier: ViewModifier {
    let mode: OracleMode
    let cornerRadius: CGFloat

    func body(content: Content) -> some View {
        content
            .background {
                ZStack {
                    RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                        .fill(mode.accentDim.opacity(OracleOpacity.ambientGlow))
                        .blur(radius: OracleBlur.ambientGlow)

                    RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                        .fill(.ultraThinMaterial)
                        .overlay {
                            RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                                .fill(OracleColor.surfaceVariant.opacity(OracleOpacity.glassFill))
                        }
                        .overlay {
                            RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                                .fill(
                                    LinearGradient(
                                        colors: [
                                            mode.accent.opacity(OracleOpacity.gradientOverlay),
                                            OracleColor.primaryContainer.opacity(OracleOpacity.gradientOverlay)
                                        ],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                        }
                        .overlay {
                            RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                                .stroke(OracleColor.onSurface.opacity(OracleOpacity.innerGlow), lineWidth: 1)
                        }
                }
            }
    }
}

private struct OracleHollowInputModifier: ViewModifier {
    let mode: OracleMode

    func body(content: Content) -> some View {
        content
            .font(OracleTypography.headlineSmall())
            .foregroundStyle(OracleColor.onSurface)
            .padding(.bottom, OracleSpacing.sm)
            .overlay(alignment: .bottom) {
                LinearGradient(
                    colors: [
                        mode.accent.opacity(0.55),
                        OracleColor.outlineVariant.opacity(OracleOpacity.ghostBorder)
                    ],
                    startPoint: .leading,
                    endPoint: .trailing
                )
                .frame(height: 1)
            }
    }
}
