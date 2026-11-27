import XCTest
@testable import Artora

final class SketchCoachTests: XCTestCase {
    private func result(_ r: Double, _ d: Double) -> SketchComparison {
        SketchComparison(missing: [], extra: [], referenceCoverage: r, drawingCoverage: d)
    }
    func testLowCorrespondenceRequestsRetake() { XCTAssertEqual(SketchCoach.advice(for: result(0.1, 0.9)), [.retake]) }
    func testMissingAndExtra() { XCTAssertEqual(SketchCoach.advice(for: result(0.5, 0.6)), [.outline, .simplify, .compareDetails]) }
    func testCloseCorrespondence() { XCTAssertEqual(SketchCoach.advice(for: result(0.95, 0.96)), [.practice]) }
    func testInvalidMetric() { XCTAssertEqual(SketchCoach.advice(for: result(.nan, 1)), [.retake]) }
}
