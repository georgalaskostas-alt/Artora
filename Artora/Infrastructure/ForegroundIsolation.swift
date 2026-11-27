import UIKit
import Vision
import CoreImage

enum ForegroundIsolation {
    static func isolate(_ image: CGImage) throws -> CGImage? {
        let request = VNGenerateForegroundInstanceMaskRequest()
        let handler = VNImageRequestHandler(cgImage: image)
        try handler.perform([request])
        guard let observation = request.results?.first, !observation.allInstances.isEmpty else { return nil }
        let buffer = try observation.generateScaledMaskForImage(forInstances: observation.allInstances, from: handler)
        let input = CIImage(cgImage: image)
        let mask = CIImage(cvPixelBuffer: buffer)
        let white = CIImage(color: CIColor(red: 1, green: 1, blue: 1)).cropped(to: input.extent)
        let output = input.applyingFilter("CIBlendWithMask", parameters: [kCIInputBackgroundImageKey: white, kCIInputMaskImageKey: mask]).cropped(to: input.extent)
        return CIContext().createCGImage(output, from: input.extent)
    }
}
