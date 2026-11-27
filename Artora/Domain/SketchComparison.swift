import Foundation

struct SketchMask {
    let side: Int
    let ink: [Bool]
    init?(pixels: [UInt8], side: Int, threshold: UInt8 = 160) {
        guard side > 0, side <= 512, pixels.count == side * side else { return nil }
        self.side = side
        self.ink = pixels.map { $0 < threshold }
    }
    var count: Int { ink.filter { $0 }.count }
}

struct SketchComparison {
    let missing: [Bool]
    let extra: [Bool]
    let referenceCoverage: Double
    let drawingCoverage: Double

    static func compare(reference: SketchMask, drawing: SketchMask, tolerance: Int = 3) -> SketchComparison? {
        let n = reference.side
        guard n == drawing.side, reference.count > 0, drawing.count > 0, tolerance >= 0, tolerance <= 8 else { return nil }
        func near(_ mask: SketchMask, _ i: Int) -> Bool {
            let x = i % n, y = i / n
            for dy in -tolerance...tolerance {
                for dx in -tolerance...tolerance where dx*dx + dy*dy <= tolerance*tolerance {
                    let xx = x+dx, yy = y+dy
                    if xx >= 0, xx < n, yy >= 0, yy < n, mask.ink[yy*n+xx] { return true }
                }
            }
            return false
        }
        let missing = reference.ink.indices.map { reference.ink[$0] && !near(drawing,$0) }
        let extra = drawing.ink.indices.map { drawing.ink[$0] && !near(reference,$0) }
        return SketchComparison(missing:missing,extra:extra,
            referenceCoverage:1-Double(missing.filter{$0}.count)/Double(reference.count),
            drawingCoverage:1-Double(extra.filter{$0}.count)/Double(drawing.count))
    }
}
