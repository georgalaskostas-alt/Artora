import XCTest
@testable import Artora

final class GeometryGuideTests: XCTestCase {
    func testBlankRejected() { XCTAssertNil(GeometryGuide.constructionMask(Array(repeating:255,count:64),width:8,height:8)) }
    func testBounds() throws {
        var pixels = [UInt8](repeating:255,count:64)
        pixels[2*8+1] = 0; pixels[6*8+5] = 0
        let guide = try XCTUnwrap(GeometryGuide.constructionMask(pixels,width:8,height:8))
        XCTAssertEqual(guide[2*8+5],100)
        XCTAssertEqual(guide[6*8+1],100)
        XCTAssertEqual(guide[0],255)
    }
    func testInvalidDimensions() { XCTAssertNil(GeometryGuide.constructionMask([],width:8,height:8)) }
}
