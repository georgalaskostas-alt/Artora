import UIKit
import CoreGraphics

enum SketchAnalyzer {
    static func measure(_ image: UIImage) -> SketchMetrics? {
        let side = 256
        let format = UIGraphicsImageRendererFormat()
        format.scale = 1
        format.opaque = true
        let normalized = UIGraphicsImageRenderer(size: CGSize(width: side,height: side),format:format).image { context in
            UIColor.white.setFill()
            context.fill(CGRect(x:0,y:0,width:side,height:side))
            let scale = min(CGFloat(side)/image.size.width,CGFloat(side)/image.size.height)
            let w = image.size.width*scale, h = image.size.height*scale
            image.draw(in:CGRect(x:(CGFloat(side)-w)/2,y:(CGFloat(side)-h)/2,width:w,height:h))
        }
        guard let cg = normalized.cgImage else { return nil }
        var bytes = [UInt8](repeating:255,count:side*side)
        let success = bytes.withUnsafeMutableBytes { buffer -> Bool in
            guard let context = CGContext(data:buffer.baseAddress,width:side,height:side,bitsPerComponent:8,bytesPerRow:side,space:CGColorSpaceCreateDeviceGray(),bitmapInfo:CGImageAlphaInfo.none.rawValue) else { return false }
            context.draw(cg,in:CGRect(x:0,y:0,width:side,height:side))
            return true
        }
        return success ? SketchMetrics.measure(bytes,width:side,height:side) : nil
    }
}
