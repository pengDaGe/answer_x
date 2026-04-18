import SwiftUI

enum OracleMode: String, CaseIterable, Identifiable {
    case oracle = "Oracle"
    case wealth = "Wealth"
    case savage = "Savage"

    var id: String { rawValue }

    var accent: Color {
        switch self {
        case .oracle:
            OracleColor.primary
        case .wealth:
            OracleColor.tertiary
        case .savage:
            OracleColor.secondary
        }
    }

    var accentDim: Color {
        switch self {
        case .oracle:
            OracleColor.primaryDim
        case .wealth:
            OracleColor.tertiaryDim
        case .savage:
            OracleColor.secondaryDim
        }
    }

    var portalGradient: [Color] {
        switch self {
        case .oracle:
            [OracleColor.primary, OracleColor.secondary]
        case .wealth:
            [OracleColor.tertiary, OracleColor.primary]
        case .savage:
            [OracleColor.secondary, OracleColor.primary]
        }
    }
}

enum OracleColor {
    static let void = Color(hex: "0D0D0D")
    static let background = Color(hex: "0E0E0E")
    static let surface = Color(hex: "0E0E0E")
    static let surfaceContainer = Color(hex: "1A1919")
    static let surfaceContainerLow = Color(hex: "151515")
    static let surfaceContainerHigh = Color(hex: "201F1F")
    static let surfaceBright = Color(hex: "222222")
    static let surfaceContainerHighest = Color(hex: "2B2B2B")
    static let surfaceVariant = Color(hex: "433B49")

    static let primary = Color(hex: "DE8EFF")
    static let primaryDim = Color(hex: "9C5AD0")
    static let primaryContainer = Color(hex: "4B205B")
    static let primaryFixed = Color(hex: "F4C7FF")

    static let secondary = Color(hex: "FF5470")
    static let secondaryDim = Color(hex: "B8334A")

    static let tertiary = Color(hex: "F5C451")
    static let tertiaryDim = Color(hex: "C69529")

    static let onSurface = Color(hex: "F6EFFC")
    static let onSurfaceVariant = Color(hex: "ADAAAA")
    static let onPrimary = Color(hex: "18041E")
    static let outline = Color(hex: "767575")
    static let outlineVariant = Color(hex: "A39AAA")
}

enum OracleSpacing {
    static let xxs: CGFloat = 4
    static let xs: CGFloat = 8
    static let sm: CGFloat = 12
    static let md: CGFloat = 16
    static let lg: CGFloat = 24
    static let xl: CGFloat = 32
    static let xxl: CGFloat = 48
    static let xxxl: CGFloat = 72
}

enum OracleRadius {
    static let md: CGFloat = 24
    static let lg: CGFloat = 32
    static let full: CGFloat = 999
}

enum OracleBlur {
    static let glass: CGFloat = 20
    static let ambientGlow: CGFloat = 40
    static let portalGlow: CGFloat = 56
}

enum OracleOpacity {
    static let glassFill = 0.40
    static let gradientOverlay = 0.15
    static let ambientGlow = 0.18
    static let ghostBorder = 0.15
    static let innerGlow = 0.10
}

extension Color {
    init(hex: String, opacity: Double = 1.0) {
        let sanitized = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var value: UInt64 = 0
        Scanner(string: sanitized).scanHexInt64(&value)

        let red = Double((value >> 16) & 0xFF) / 255.0
        let green = Double((value >> 8) & 0xFF) / 255.0
        let blue = Double(value & 0xFF) / 255.0

        self.init(.sRGB, red: red, green: green, blue: blue, opacity: opacity)
    }
}
