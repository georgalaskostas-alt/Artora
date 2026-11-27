import XCTest
@testable import Artora

final class SketchMetricsTests: XCTestCase {
    func testBlankImage() throws {
        let m = try XCTUnwrap(SketchMetrics.measure([255,255,255,255],width:2,height:2))
        XCTAssertEqual(m.inkFraction,0)
        XCTAssertEqual(m.horizontalSpan,0)
        XCTAssertEqual(m.verticalSpan,0)
    }
    func testSingleDarkPixel() throws {
        let m = try XCTUnwrap(SketchMetrics.measure([0,255,255,255],width:2,height:2))
        XCTAssertEqual(m.inkFraction,0.25)
        XCTAssertEqual(m.horizontalSpan,0.5)
        XCTAssertEqual(m.verticalSpan,0.5)
    }
    func testInvalidDimensions() {
        XCTAssertNil(SketchMetrics.measure([0],width:2,height:2))
        XCTAssertNil(SketchMetrics.measure([],width:0,height:0))
    }
}
