import XCTest
@testable import Artora

final class AlignmentAndPathTests: XCTestCase {
    func testTranslationNormalization() throws {
        func mask(_ x: Int,_ y: Int) throws -> SketchMask {
            var p = [UInt8](repeating:255,count:64*64)
            for i in 0..<8 { p[(y+i)*64+x] = 0; p[y*64+x+i] = 0 }
            return try XCTUnwrap(SketchMask(pixels:p,side:64))
        }
        let a = try XCTUnwrap(SketchAlignment.normalize(try mask(3,5)))
        let b = try XCTUnwrap(SketchAlignment.normalize(try mask(20,25)))
        XCTAssertEqual(a.ink,b.ink)
    }
    func testBlankRejected() throws {
        let a = try XCTUnwrap(SketchMask(pixels:Array(repeating:255,count:64*64),side:64))
        XCTAssertNil(SketchAlignment.normalize(a))
    }
    func testRecommendationExcludesCompleted() {
        let lessons = LessonCatalog.lessons
        let completed = Set(lessons.dropLast().map(\.id))
        XCTAssertEqual(LearningPath.next(in:lessons,completed:completed)?.id,lessons.last?.id)
        XCTAssertNil(LearningPath.next(in:lessons,completed:Set(lessons.map(\.id))))
    }
}
