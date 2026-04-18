import SwiftUI
import UIKit

enum OracleTypography {
    static func displayLarge() -> Font {
        oracleFont(named: "SpaceGrotesk-Bold", size: 64, weight: .bold)
    }

    static func displayMedium() -> Font {
        oracleFont(named: "SpaceGrotesk-Bold", size: 48, weight: .bold)
    }

    static func displaySmall() -> Font {
        oracleFont(named: "SpaceGrotesk-SemiBold", size: 40, weight: .semibold)
    }

    static func headlineLarge() -> Font {
        oracleFont(named: "SpaceGrotesk-SemiBold", size: 30, weight: .semibold)
    }

    static func headlineMedium() -> Font {
        oracleFont(named: "SpaceGrotesk-SemiBold", size: 24, weight: .semibold)
    }

    static func headlineSmall() -> Font {
        oracleFont(named: "Manrope-SemiBold", size: 20, weight: .semibold)
    }

    static func titleMedium() -> Font {
        oracleFont(named: "Manrope-SemiBold", size: 16, weight: .semibold)
    }

    static func bodyLarge() -> Font {
        oracleFont(named: "Manrope-Regular", size: 18, weight: .regular)
    }

    static func bodyMedium() -> Font {
        oracleFont(named: "Manrope-Regular", size: 15, weight: .regular)
    }

    static func bodySmall() -> Font {
        oracleFont(named: "Manrope-Regular", size: 13, weight: .regular)
    }

    static func labelMedium() -> Font {
        oracleFont(named: "PlusJakartaSans-Medium", size: 12, weight: .medium)
    }

    static func labelSmall() -> Font {
        oracleFont(named: "PlusJakartaSans-SemiBold", size: 11, weight: .semibold)
    }

    // Falls back to system fonts until the brand fonts are bundled into the app target.
    private static func oracleFont(named name: String, size: CGFloat, weight: UIFont.Weight) -> Font {
        if let customFont = UIFont(name: name, size: size) {
            return Font(customFont)
        }

        return Font(UIFont.systemFont(ofSize: size, weight: weight))
    }
}
