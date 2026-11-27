import XCTest
@testable import Artora

final class SketchComparisonTests: XCTestCase {
    func testIdentical() throws {
        let a = try XCTUnwrap(SketchMask(pixels:[0,255,255,255],side:2))
        let r = try XCTUnwrap(SketchComparison.compare(reference:a,drawing:a,tolerance:0))
        XCTAssertEqual(r.referenceCoverage,1)
        XCTAssertEqual(r.drawingCoverage,1)
    }
    func testDisjoint() throws {
        let a = try XCTUnwrap(SketchMask(pixels:[0,255,255,255],side:2))
        let b = try XCTUnwrap(SketchMask(pixels:[255,255,255,0],side:2))
        let r = try XCTUnwrap(SketchComparison.compare(reference:a,drawing:b,tolerance:0))
        XCTAssertEqual(r.referenceCoverage,0)
        XCTAssertTrue(r.missing[0])
        XCTAssertTrue(r.extra[3])
    }
    func testToleranceAndBlank() throws {
        let a = try XCTUnwrap(SketchMask(pixels:[0,255,255,255],side:2))
        let b = try XCTUnwrap(SketchMask(pixels:[255,0,255,255],side:2))
        let blank = try XCTUnwrap(SketchMask(pixels:[255,255,255,255],side:2))
        XCTAssertEqual(SketchComparison.compare(reference:a,drawing:b,tolerance:1)?.referenceCoverage,1)
        XCTAssertNil(SketchComparison.compare(reference:a,drawing:blank))
    }
}
