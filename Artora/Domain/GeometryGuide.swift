import Foundation

enum GeometryGuide {
    static func constructionMask(_ pixels: [UInt8], width: Int, height: Int) -> [UInt8]? {
        guard width >= 3, height >= 3, width <= 512, height <= 512, pixels.count == width*height else { return nil }
        var minX = width, minY = height, maxX = -1, maxY = -1
        for i in pixels.indices where pixels[i] < 128 {
            minX = min(minX, i % width); maxX = max(maxX, i % width)
            minY = min(minY, i / width); maxY = max(maxY, i / width)
        }
        guard maxX > minX, maxY > minY else { return nil }
        var result = [UInt8](repeating: 255, count: pixels.count)
        let cx = (minX+maxX)/2, cy = (minY+maxY)/2
        for y in minY...maxY {
            for x in minX...maxX {
                if x == minX || x == maxX || y == minY || y == maxY { result[y*width+x] = 100 }
                else if (x == cx && y % 6 < 3) || (y == cy && x % 6 < 3) { result[y*width+x] = 150 }
            }
        }
        return result
    }
}
