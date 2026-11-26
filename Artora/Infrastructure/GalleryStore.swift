import Foundation
import Combine

struct GalleryArtwork: Codable, Identifiable, Equatable {
    let id: UUID
    let created: Date
    let title: String
    let jpeg: Data
}

@MainActor final class GalleryStore: ObservableObject {
    @Published private(set) var artworks: [GalleryArtwork] = []
    @Published private(set) var loadFailed = false
    private let directory: URL
    init(directory: URL = URL.documentsDirectory.appendingPathComponent("ArtoraGallery", isDirectory: true)) {
        self.directory = directory
        do {
            try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
            let urls = try FileManager.default.contentsOfDirectory(at: directory, includingPropertiesForKeys: nil)
            for url in urls where url.pathExtension == "artwork" {
                do { artworks.append(try JSONDecoder().decode(GalleryArtwork.self, from: Data(contentsOf: url))) }
                catch { loadFailed = true }
            }
            artworks.sort { $0.created > $1.created }
        } catch { loadFailed = true }
    }
    func add(title: String, jpeg: Data) throws {
        guard !jpeg.isEmpty else { throw CocoaError(.fileWriteUnknown) }
        let item = GalleryArtwork(id: UUID(), created: Date(), title: title, jpeg: jpeg)
        try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
        try JSONEncoder().encode(item).write(to: url(item.id), options: [.atomic, .completeFileProtection])
        artworks.insert(item, at: 0)
    }
    func remove(_ item: GalleryArtwork) throws {
        try FileManager.default.removeItem(at: url(item.id))
        artworks.removeAll { $0.id == item.id }
    }
    private func url(_ id: UUID) -> URL { directory.appendingPathComponent(id.uuidString).appendingPathExtension("artwork") }
}
