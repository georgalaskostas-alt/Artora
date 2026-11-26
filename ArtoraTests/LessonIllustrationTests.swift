import XCTest
@testable import Artora

final class LessonIllustrationTests: XCTestCase {
    @MainActor func testEveryLessonHasOneNonemptyPathPerStep() {
        for lesson in LessonCatalog.lessons {
            let paths = SketchIllustration.paths(for: lesson.id)
            XCTAssertEqual(paths.count, lesson.steps.count, lesson.id)
            XCTAssertTrue(paths.allSatisfy { !$0.isEmpty }, lesson.id)
        }
    }
}
