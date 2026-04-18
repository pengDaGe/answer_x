import Foundation

struct OracleFavoriteRecord: Identifiable, Codable, Hashable {
    let id: UUID
    let sourceHistoryRecordID: UUID
    let favoritedAt: Date
    let question: String
    let gateway: OracleGatewayType
    let answer: OracleGeneratedAnswer

    init(
        id: UUID = UUID(),
        sourceHistoryRecordID: UUID,
        favoritedAt: Date = Date(),
        question: String,
        gateway: OracleGatewayType,
        answer: OracleGeneratedAnswer
    ) {
        self.id = id
        self.sourceHistoryRecordID = sourceHistoryRecordID
        self.favoritedAt = favoritedAt
        self.question = question
        self.gateway = gateway
        self.answer = answer
    }

    var answerText: String {
        answer.fullText
    }

    var timestampText: String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .short
        return formatter.localizedString(for: favoritedAt, relativeTo: Date())
    }
}

final class OracleFavoritesStore: ObservableObject {
    @Published private(set) var entries: [OracleFavoriteRecord]

    private let userDefaults: UserDefaults
    private let storageKey = "answer_x.oracle_favorite_records"
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()

    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
        self.entries = []
        load()
    }

    func isFavorited(historyRecordID: UUID) -> Bool {
        entries.contains(where: { $0.sourceHistoryRecordID == historyRecordID })
    }

    @discardableResult
    func toggleFavorite(for record: OracleHistoryRecord, at date: Date = Date()) -> Bool {
        if let existingIndex = entries.firstIndex(where: { $0.sourceHistoryRecordID == record.id }) {
            entries.remove(at: existingIndex)
            persist()
            return false
        }

        let favorite = OracleFavoriteRecord(
            sourceHistoryRecordID: record.id,
            favoritedAt: date,
            question: record.question,
            gateway: record.gateway,
            answer: record.answer
        )

        entries.insert(favorite, at: 0)
        persist()
        return true
    }

    private func load() {
        guard let data = userDefaults.data(forKey: storageKey),
              let decoded = try? decoder.decode([OracleFavoriteRecord].self, from: data) else {
            entries = []
            return
        }

        entries = decoded.sorted(by: { $0.favoritedAt > $1.favoritedAt })
    }

    private func persist() {
        guard let data = try? encoder.encode(entries) else { return }
        userDefaults.set(data, forKey: storageKey)
    }
}
