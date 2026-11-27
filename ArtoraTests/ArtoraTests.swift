import XCTest
@testable import Artora

final class ArtoraTests: XCTestCase {
    @MainActor
    func testLessonCatalogHasUniqueIdentifiers() {
        let lessons = LessonCatalog.lessons
        XCTAssertEqual(Set(lessons.map(\.id)).count, lessons.count)
        XCTAssertTrue(lessons.allSatisfy { !$0.steps.isEmpty })
        for lesson in lessons {
            XCTAssertEqual(Set(lesson.steps.map(\.id)).count, lesson.steps.count)
        }
    }

    @MainActor
    func testProgressPersistsBetweenStoreInstances() {
        let suiteName = "ArtoraTests.\(UUID().uuidString)"
        guard let defaults = UserDefaults(suiteName: suiteName) else {
            XCTFail("Could not create isolated test defaults")
            return
        }
        defer { defaults.removePersistentDomain(forName: suiteName) }
        let first = ProgressStore(defaults: defaults)
        let lesson = LessonCatalog.lessons[0]
        XCTAssertFalse(first.isComplete(lesson))
        first.complete(lesson)
        let second = ProgressStore(defaults: defaults)
        XCTAssertTrue(second.isComplete(lesson))
        XCTAssertEqual(second.completionRate(for: LessonCatalog.lessons), 1.0 / Double(LessonCatalog.lessons.count))
    }

    @MainActor
    func testEmptyCatalogProgressIsZero() {
        let defaults = UserDefaults(suiteName: "ArtoraTests.\(UUID().uuidString)")!
        let store = ProgressStore(defaults: defaults)
        XCTAssertEqual(store.completionRate(for: []), 0)
    }
}
