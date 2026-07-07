import Foundation
import Combine

@MainActor
final class Store: ObservableObject {
    static let freeLimit = 25

    @Published var items: [Source] = []
    @Published var isPro: Bool = false

    private let fileURL: URL

    init() {
        let dir = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
        try? FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
        self.fileURL = dir.appendingPathComponent("citecount_items.json")
        load()
    }

    var canAddMore: Bool {
        isPro || items.count < Store.freeLimit
    }

    func add(_ item: Source) {
        items.append(item)
        save()
    }

    func update(_ item: Source) {
        guard let idx = items.firstIndex(where: { $0.id == item.id }) else { return }
        items[idx] = item
        save()
    }

    func delete(at offsets: IndexSet) {
        items.remove(atOffsets: offsets)
        save()
    }

    func delete(_ item: Source) {
        items.removeAll { $0.id == item.id }
        save()
    }

    func load() {
        guard let data = try? Data(contentsOf: fileURL) else {
            items = seedData()
            save()
            return
        }
        if let decoded = try? JSONDecoder().decode([Source].self, from: data) {
            items = decoded
        } else {
            items = seedData()
        }
    }

    func save() {
        if let data = try? JSONEncoder().encode(items) {
            try? data.write(to: fileURL)
        }
    }

    private func seedData() -> [Source] {
        [
        Source(title: "Sample Title 1", cited: false),
        Source(title: "Sample Title 2", cited: false),
        Source(title: "Sample Title 3", cited: false)
        ]
    }
}
