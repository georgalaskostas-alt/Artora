import Foundation

enum PhotoLessonEdges {
    static func stages(_ pixels: [UInt8], width: Int, height: Int) -> [[UInt8]]? {
        guard width >= 3, height >= 3, width <= 512, height <= 512, pixels.count == width*height else { return nil }
        var magnitude = [Int](repeating: 0, count: pixels.count)
        for y in 1..<(height-1) {
            for x in 1..<(width-1) {
                let i = y*width+x
                let gx = Int(pixels[i-width+1])+2*Int(pixels[i+1])+Int(pixels[i+width+1])-Int(pixels[i-width-1])-2*Int(pixels[i-1])-Int(pixels[i+width-1])
                let gy = Int(pixels[i+width-1])+2*Int(pixels[i+width])+Int(pixels[i+width+1])-Int(pixels[i-width-1])-2*Int(pixels[i-width])-Int(pixels[i-width+1])
                magnitude[i] = abs(gx)+abs(gy)
            }
        }
        guard let peak = magnitude.max(), peak >= 40 else { return nil }
        return [0.65,0.40,0.20].map { fraction in
            let threshold = max(30, Int(Double(peak)*fraction))
            return magnitude.map { $0 >= threshold ? UInt8(0) : UInt8(255) }
        }
    }
}
