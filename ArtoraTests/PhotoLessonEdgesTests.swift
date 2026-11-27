import XCTest
@testable import Artora

final class PhotoLessonEdgesTests: XCTestCase {
    func testBlankRejected() { XCTAssertNil(PhotoLessonEdges.stages(Array(repeating:255,count:64),width:8,height:8)) }
    func testInvalidDimensions() { XCTAssertNil(PhotoLessonEdges.stages([0],width:8,height:8)) }
    func testProgressiveEdges() throws {
        let pixels: [UInt8] = (0..<64).map { $0 % 8 < 4 ? 0 : 255 }
        let stages = try XCTUnwrap(PhotoLessonEdges.stages(pixels,width:8,height:8))
        XCTAssertEqual(stages.count,3)
        XCTAssertTrue(stages[0].contains(0))
        for i in 0..<64 where stages[0][i] == 0 { XCTAssertEqual(stages[2][i],0) }
    }
}
