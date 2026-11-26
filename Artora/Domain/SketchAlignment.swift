import Foundation

enum SketchAlignment {
    // Normalize translation and uniform scale only. Preserve aspect ratio.
    static func normalize(_ mask: SketchMask, padding: Int = 12) -> SketchMask? {
        let n = mask.side
        guard padding >= 0, padding < n / 2 else { return nil }
        let indices = mask.ink.indices.filter { mask.ink[$0] }
        guard !indices.isEmpty else { return nil }
        let xs = indices.map { $0 % n }, ys = indices.map { $0 / n }
        guard let left = xs.min(), let right = xs.max(), let top = ys.min(), let bottom = ys.max() else { return nil }
        let w = right-left+1, h = bottom-top+1
        let scale = Double(n-2*padding)/Double(max(w,h))
        let ox = (Double(n)-Double(w)*scale)/2
        let oy = (Double(n)-Double(h)*scale)/2
        var pixels = [UInt8](repeating:255,count:n*n)
        for y in 0..<n {
            for x in 0..<n {
                let sx = Int(floor((Double(x)+0.5-ox)/scale))+left
                let sy = Int(floor((Double(y)+0.5-oy)/scale))+top
                if sx >= left, sx <= right, sy >= top, sy <= bottom, mask.ink[sy*n+sx] {
                    pixels[y*n+x] = 0
                }
            }
        }
        return SketchMask(pixels:pixels,side:n)
    }
}
