import Foundation

struct OracleHistoryRecord: Identifiable, Codable, Hashable {
    let id: UUID
    let createdAt: Date
    let question: String
    let gateway: OracleGatewayType
    let answer: OracleGeneratedAnswer

    init(
        id: UUID = UUID(),
        createdAt: Date = Date(),
        question: String,
        gateway: OracleGatewayType,
        answer: OracleGeneratedAnswer
    ) {
        self.id = id
        self.createdAt = createdAt
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
        return formatter.localizedString(for: createdAt, relativeTo: Date())
    }
}

final class OracleHistoryStore: ObservableObject {
    @Published private(set) var entries: [OracleHistoryRecord]

    private let userDefaults: UserDefaults
    private let storageKey = "answer_x.oracle_history_records"
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()

    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
        self.entries = []
        load()
    }

    func addRecord(
        question: String,
        gateway: OracleGatewayType,
        answer: OracleGeneratedAnswer,
        createdAt: Date = Date()
    ) -> OracleHistoryRecord {
        let record = OracleHistoryRecord(
            createdAt: createdAt,
            question: question,
            gateway: gateway,
            answer: answer
        )

        entries.insert(record, at: 0)
        persist()
        return record
    }

    func recentEntries(limit: Int = 10) -> [OracleHistoryRecord] {
        Array(entries.prefix(limit))
    }

    private func load() {
        guard let data = userDefaults.data(forKey: storageKey),
              let decoded = try? decoder.decode([OracleHistoryRecord].self, from: data) else {
            entries = []
            return
        }

        entries = decoded.sorted(by: { $0.createdAt > $1.createdAt })
    }

    private func persist() {
        guard let data = try? encoder.encode(entries) else { return }
        userDefaults.set(data, forKey: storageKey)
    }
}
