import Foundation
import SwiftUI

enum OracleGatewayType: String, CaseIterable, Hashable, Identifiable, Codable {
    case savage
    case clearHeaded
    case wealth
    case love
    case worker
    case gettingRich
    case mbti
    case social

    var id: String { rawValue }

    var title: String {
        switch self {
        case .savage: return "Savage Mode"
        case .clearHeaded: return "Clear-headed Mode"
        case .wealth: return "God of Wealth"
        case .love: return "Love Mode"
        case .worker: return "Worker Mode"
        case .gettingRich: return "Getting Rich"
        case .mbti: return "MBTI Mode"
        case .social: return "Social Animal"
        }
    }

    var subtitle: String {
        switch self {
        case .savage: return "Brutal Honesty Only"
        case .clearHeaded: return "Logical Synthesis"
        case .wealth: return "Prosperity Rituals"
        case .love: return "Affection Algorithms"
        case .worker: return "Efficiency Protocol"
        case .gettingRich: return "Fortune Optimization"
        case .mbti: return "Personality Sync"
        case .social: return "Network Dynamics"
        }
    }

    var systemImage: String {
        switch self {
        case .savage: return "bolt.fill"
        case .clearHeaded: return "sun.max.fill"
        case .wealth: return "dollarsign.circle.fill"
        case .love: return "heart.fill"
        case .worker: return "gearshape.2.fill"
        case .gettingRich: return "bitcoinsign.circle.fill"
        case .mbti: return "brain.head.profile"
        case .social: return "person.3.fill"
        }
    }

    var accent: Color {
        switch self {
        case .savage: return OracleColor.secondaryDim
        case .clearHeaded: return OracleColor.onSurface
        case .wealth: return OracleColor.tertiary
        case .love: return OracleColor.secondary
        case .worker: return OracleColor.onSurfaceVariant
        case .gettingRich: return OracleColor.primary
        case .mbti: return OracleColor.primaryDim
        case .social: return OracleColor.onSurface
        }
    }

    var glowOpacity: Double {
        switch self {
        case .savage, .wealth, .love: return 0.22
        case .worker: return 0.16
        case .gettingRich: return 0.24
        case .mbti: return 0.20
        case .clearHeaded, .social: return 0.10
        }
    }

    var fillIcon: Bool {
        switch self {
        case .mbti:
            return false
        default:
            return true
        }
    }

    var promptExamples: [String] {
        switch self {
        case .savage:
            return ["Am I wasting my time here?", "Should I cut this off now?", "What truth am I avoiding?"]
        case .clearHeaded:
            return ["What is the most rational next move?", "Should I quit my job?", "What am I missing in this decision?"]
        case .wealth:
            return ["When will money flow again?", "Where is the strongest opportunity?", "What should I invest my energy in?"]
        case .love:
            return ["Does he like me?", "What is this connection really?", "Should I open up or step back?"]
        case .worker:
            return ["How do I break this bottleneck?", "What system should I improve first?", "Where is my effort leaking?"]
        case .gettingRich:
            return ["When will I be rich?", "Which risk is worth taking now?", "What is my fastest wealth channel?"]
        case .mbti:
            return ["Why do I always react like this?", "Which role fits me best?", "What dynamic keeps repeating?"]
        case .social:
            return ["Who in my circle drains my signal?", "What energy do I project socially?", "Which connection deserves more attention?"]
        }
    }

    var guidanceNote: String {
        switch self {
        case .savage: return "Truth cuts quickest when you stop decorating it."
        case .clearHeaded: return "Detach emotion for a moment. Let logic speak first."
        case .wealth: return "Prosperity favors precision, not panic."
        case .love: return "Affection patterns surface when the heart goes still."
        case .worker: return "Efficiency is a ritual. Friction always reveals the weak seam."
        case .gettingRich: return "Fortune emerges where desire and discipline finally align."
        case .mbti: return "Personality is a pattern map. Ask the void where you loop."
        case .social: return "Your network mirrors your frequency. Watch what keeps returning."
        }
    }
}

enum OracleRoute: Hashable {
    case detail(OracleGatewayType)
    case transition(OracleGatewayType, String)
    case result(OracleHistoryRecord)
    case historyDetail(OracleHistoryRecord)
    case favorites
}

struct OracleGeneratedAnswer: Hashable, Codable {
    let theme: String
    let template: String
    let emotion: String
    let ending: String

    var fullText: String {
        [template, emotion, ending]
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
            .joined(separator: " ")
    }
}

enum OracleAnswerBook {
    static func normalizeQuestion(_ question: String) -> String {
        question
            .components(separatedBy: .whitespacesAndNewlines)
            .filter { !$0.isEmpty }
            .joined(separator: " ")
    }

    static func sanitizeEnglishQuestion(_ question: String) -> String {
        let filteredScalars = question.unicodeScalars.filter { scalar in
            switch scalar.value {
            case 65...90, 97...122:
                return true
            default:
                return CharacterSet.whitespacesAndNewlines.contains(scalar)
            }
        }

        return String(String.UnicodeScalarView(filteredScalars))
    }

    static func resolvedQuestion(_ question: String, fallback: String) -> String {
        let normalized = normalizeQuestion(sanitizeEnglishQuestion(question))
        return normalized.isEmpty ? fallback : normalized
    }

    static func answer(for gateway: OracleGatewayType, question: String, on date: Date = Date()) -> OracleGeneratedAnswer {
        let fallback = gateway.promptExamples.first ?? "Should I quit my job?"
        let resolvedQuestion = resolvedQuestion(question, fallback: fallback)
        let seed = "\(gateway.rawValue)|\(resolvedQuestion.lowercased())|\(dayKey(for: date))"
        let configuration = gateway.answerConfiguration

        return OracleGeneratedAnswer(
            theme: configuration.themes[stableIndex(seed: seed, salt: "theme", count: configuration.themes.count)],
            template: configuration.templates[stableIndex(seed: seed, salt: "template", count: configuration.templates.count)],
            emotion: configuration.emotions[stableIndex(seed: seed, salt: "emotion", count: configuration.emotions.count)],
            ending: configuration.endings[stableIndex(seed: seed, salt: "ending", count: configuration.endings.count)]
        )
    }

    private static func dayKey(for date: Date) -> String {
        let components = Calendar(identifier: .gregorian).dateComponents(in: .current, from: date)
        let year = components.year ?? 0
        let month = components.month ?? 0
        let day = components.day ?? 0
        return "\(year)-\(month)-\(day)"
    }

    private static func stableIndex(seed: String, salt: String, count: Int) -> Int {
        guard count > 0 else { return 0 }
        return Int(stableHash("\(seed)|\(salt)") % UInt64(count))
    }

    private static func stableHash(_ value: String) -> UInt64 {
        var hash: UInt64 = 14_695_981_039_346_656_037
        for byte in value.utf8 {
            hash ^= UInt64(byte)
            hash &*= 1_099_511_628_211
        }
        return hash
    }
}

private struct OracleAnswerConfiguration {
    let themes: [String]
    let templates: [String]
    let emotions: [String]
    let endings: [String]
}

private extension OracleGatewayType {
    var answerConfiguration: OracleAnswerConfiguration {
        switch self {
        case .savage:
            return .savage
        case .clearHeaded:
            return .clearHeaded
        case .wealth:
            return .wealth
        case .love:
            return .love
        case .worker:
            return .worker
        case .gettingRich:
            return .gettingRich
        case .mbti:
            return .mbti
        case .social:
            return .social
        }
    }
}

private extension OracleAnswerConfiguration {
    static let savage = OracleAnswerConfiguration(
        themes: [
            "edge",
            "mirror",
            "ember",
            "break"
        ],
        templates: [
            "What unsettles you may be the part that has already turned true.",
            "The thing you keep circling may not welcome another round.",
            "A sharper answer is waiting just behind your hesitation.",
            "What feels harsh now may only be clearing what was never steady."
        ],
        emotions: [
            "Do not soften too quickly,",
            "Let the sting remain a little longer,",
            "Hold the line for now,",
            "Even discomfort has its use,"
        ],
        endings: [
            "something false is already loosening.",
            "the next sign may arrive without kindness, but with clarity.",
            "what falls away now may have been overdue.",
            "the silence around this is not empty."
        ]
    )

    static let clearHeaded = OracleAnswerConfiguration(
        themes: [
            "stillness",
            "glass",
            "plain view",
            "balance"
        ],
        templates: [
            "The clearer road is rarely the louder one.",
            "What matters most may reveal itself after the extra noise fades.",
            "Not every urgent feeling deserves a quick answer.",
            "What remains simple after reflection deserves another look."
        ],
        emotions: [
            "Wait for the air to settle,",
            "Read what is left after emotion passes,",
            "Keep your hands still for a moment,",
            "Listen for the quieter logic,"
        ],
        endings: [
            "the right direction may already be standing in plain sight.",
            "what is true will ask for less decoration.",
            "the next step may be smaller than you expect, but cleaner.",
            "clarity often arrives without applause."
        ]
    )

    static let wealth = OracleAnswerConfiguration(
        themes: [
            "tide",
            "coin",
            "harvest",
            "current"
        ],
        templates: [
            "What seems slow may still be the richer current.",
            "A narrow opening may be worth more than a bright distraction.",
            "What is meant to grow often begins in a quieter ledger.",
            "There is value moving where impatience rarely looks."
        ],
        emotions: [
            "Leave some room for timing,",
            "Do not chase the loudest promise,",
            "Watch what keeps returning,",
            "Hold your desire lightly,"
        ],
        endings: [
            "the profitable sign may appear in modest clothing.",
            "what multiplies seldom announces itself first.",
            "a smaller yes may be guarding the larger one.",
            "the next gain may arrive sideways."
        ]
    )

    static let love = OracleAnswerConfiguration(
        themes: [
            "pulse",
            "echo",
            "velvet",
            "return"
        ],
        templates: [
            "Not every distance means departure.",
            "What is unsaid may still be leaning toward you.",
            "A soft return can mean more than a quick approach.",
            "The heart often recognizes movement before the mind admits it."
        ],
        emotions: [
            "Do not force the moment,",
            "Let the feeling breathe,",
            "Read the pauses too,",
            "Stay near your own warmth,"
        ],
        endings: [
            "what is genuine will not need to rush.",
            "the answer may come in tone before it comes in words.",
            "a gentle sign may matter more than a dramatic one.",
            "something tender is still deciding how to appear."
        ]
    )

    static let worker = OracleAnswerConfiguration(
        themes: [
            "gear",
            "thread",
            "draft",
            "rhythm"
        ],
        templates: [
            "What feels stuck may only be asking for a different rhythm.",
            "The knot may loosen where you stopped looking.",
            "Not every delay is resistance.",
            "The unfinished part may be holding the real instruction."
        ],
        emotions: [
            "Work with the grain,",
            "Do one thing less,",
            "Trust the slower correction,",
            "Stay with the useful friction,"
        ],
        endings: [
            "the next opening may come from a small adjustment.",
            "what clears first may not be the part you expected.",
            "momentum could return quietly.",
            "the better system may already be half-built."
        ]
    )

    static let gettingRich = OracleAnswerConfiguration(
        themes: [
            "vault",
            "scale",
            "lever",
            "rise"
        ],
        templates: [
            "What compounds is still learning its shape.",
            "A door that seems narrow may open wider once chosen.",
            "The stronger opportunity may not be the faster one.",
            "What truly expands often begins without spectacle."
        ],
        emotions: [
            "Think beyond the immediate reward,",
            "Do not spend your hunger all at once,",
            "Let the long game whisper,",
            "Keep some faith in repetition,"
        ],
        endings: [
            "the larger return may be gathering offstage.",
            "what scales well may first look unremarkable.",
            "the next gain could come from what endures.",
            "an unseen engine may already be starting."
        ]
    )

    static let mbti = OracleAnswerConfiguration(
        themes: [
            "mask",
            "loop",
            "echo",
            "threshold"
        ],
        templates: [
            "A familiar role may be growing too small for you.",
            "What you call instinct may partly be memory.",
            "The pattern repeats because it still has something to reveal.",
            "Another version of you is quietly asking for room."
        ],
        emotions: [
            "Notice what feels overly familiar,",
            "Do not answer from reflex,",
            "Stay curious about your own contradiction,",
            "Let the old script pause,"
        ],
        endings: [
            "a truer fit may emerge in the gap.",
            "what changes first may be the name you give yourself.",
            "the next clue may arrive through discomfort.",
            "something in you is ready to answer differently."
        ]
    )

    static let social = OracleAnswerConfiguration(
        themes: [
            "room",
            "signal",
            "orbit",
            "crowd"
        ],
        templates: [
            "One presence in the room may matter more than the whole room.",
            "The signal around you changes when certain names appear.",
            "What feels easy is not always what is aligned.",
            "A connection may be ripening before it becomes obvious."
        ],
        emotions: [
            "Watch who settles your spirit,",
            "Listen beneath the chatter,",
            "Do not mistake access for closeness,",
            "Let the room reveal itself,"
        ],
        endings: [
            "the meaningful invitation may be the quiet one.",
            "what belongs will feel less crowded.",
            "someone's real intention may appear when the noise thins.",
            "the next bond may begin as a subtle shift."
        ]
    )
}
