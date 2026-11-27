import XCTest
@testable import Artora

final class GalleryStoreTests: XCTestCase {
    @MainActor func testPersistenceAndDeletion() throws {
        let directory = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)
        defer { try? FileManager.default.removeItem(at: directory) }
        let first = GalleryStore(directory: directory)
        try first.add(title: "Test", jpeg: Data([1,2,3]))
        let second = GalleryStore(directory: directory)
        XCTAssertEqual(second.artworks, first.artworks)
        try second.remove(try XCTUnwrap(second.artworks.first))
        XCTAssertTrue(GalleryStore(directory: directory).artworks.isEmpty)
    }
    @MainActor func testEmptyDataRejected() throws {
        let directory = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)
        defer { try? FileManager.default.removeItem(at: directory) }
        let store = GalleryStore(directory: directory)
        XCTAssertThrowsError(try store.add(title: "Empty", jpeg: Data()))
        XCTAssertTrue(store.artworks.isEmpty)
    }
}
