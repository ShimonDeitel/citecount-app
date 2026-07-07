import Foundation

struct Source: Identifiable, Codable, Equatable {
    var id: UUID = UUID()
    var createdAt: Date = Date()
    var title: String
    var cited: Bool

    init(id: UUID = UUID(), createdAt: Date = Date(), title: String, cited: Bool) {
        self.id = id
        self.createdAt = createdAt
        self.title = title
        self.cited = cited
    }
}
