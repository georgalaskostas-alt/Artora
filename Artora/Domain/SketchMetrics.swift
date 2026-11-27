import Foundation

struct SketchMetrics {
    let inkFraction: Double
    let horizontalSpan: Double
    let verticalSpan: Double
    static func measure(_ pixels: [UInt8], width: Int, height: Int, threshold: UInt8 = 120) -> SketchMetrics? {
        guard width > 0, height > 0, width <= Int.max / height, pixels.count == width * height else { return nil }
        var count = 0, minX = width, minY = height, maxX = -1, maxY = -1
        for (i, value) in pixels.enumerated() where value < threshold {
            let x = i % width, y = i / width
            count += 1
            minX = min(minX,x); minY = min(minY,y)
            maxX = max(maxX,x); maxY = max(maxY,y)
        }
        return SketchMetrics(inkFraction: Double(count)/Double(pixels.count),
            horizontalSpan: count == 0 ? 0 : Double(maxX-minX+1)/Double(width),
            verticalSpan: count == 0 ? 0 : Double(maxY-minY+1)/Double(height))
    }
}
