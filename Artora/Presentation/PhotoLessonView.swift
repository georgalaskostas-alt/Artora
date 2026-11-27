import SwiftUI
import UIKit

struct PhotoLessonView: View {
    let image: UIImage
    let greek: Bool
    @State private var stages: [UIImage] = []
    @State private var step = 0
    @State private var failed = false
    @State private var isolateSubject = true
    @State private var isolated = false
    @StateObject private var narrator = LessonNarrator()
    private var instructions: [String] {
        greek ? ["Σχεδίασε απαλά το βοηθητικό πλαίσιο και τις κεντρικές γραμμές. Δεν είναι απαραίτητα άξονες συμμετρίας.", "Σχεδίασε πρώτα τις πιο έντονες γραμμές. Αγνόησε τις μικρές λεπτομέρειες.", "Πρόσθεσε τις νέες γραμμές και σύγκρινε τις αποστάσεις.", "Πρόσθεσε μόνο τις λεπτομέρειες που βοηθούν το σχέδιό σου."] : ["Lightly draw the bounding box and center guides. These are not necessarily symmetry axes.", "Start with the strongest lines. Ignore small details.", "Add the new lines and compare distances.", "Add only the details that help your drawing."]
    }
    var body: some View {
        VStack(spacing: 16) {
            Text(greek ? "Μάθημα από φωτογραφία" : "Photo lesson").font(.title2.bold())
            Toggle(greek ? "Απομόνωση αντικειμένου" : "Isolate subject", isOn: $isolateSubject)
            if isolateSubject && !stages.isEmpty {
                Text(isolated ? (greek ? "Εφαρμόστηκε μάσκα προσκηνίου" : "Foreground mask applied") : (greek ? "Δεν εντοπίστηκε προσκήνιο. Χρησιμοποιείται η αρχική εικόνα." : "No foreground mask available. Using original image.")).font(.caption)
            }
            if stages.indices.contains(step) {
                Text("\(step+1) / \(stages.count)").font(.caption)
                Image(uiImage: stages[step]).resizable().interpolation(.none).scaledToFit().frame(maxHeight: 350).background(.white)
                Text(instructions[step])
                Button { narrator.speak(instructions[step], language: greek ? .greek : .english) } label: { Label(greek ? "Άκουσε" : "Listen", systemImage: "speaker.wave.2") }
                HStack {
                    Button(greek ? "Πίσω" : "Back") { step -= 1 }.disabled(step == 0)
                    Spacer()
                    Button(greek ? "Επόμενο" : "Next") { step += 1 }.disabled(step == stages.count-1)
                }.buttonStyle(.bordered)
            } else if failed {
                Text(greek ? "Δοκίμασε φωτογραφία με καθαρό αντικείμενο και μεγαλύτερη αντίθεση." : "Try a photo with a clear subject and stronger contrast.")
            } else { ProgressView() }
            Text(greek ? "Πειραματική απομόνωση προσκηνίου και ανίχνευση ακμών. Η μάσκα μπορεί να είναι ατελής." : "Experimental foreground isolation and edge detection. The mask may be imperfect.").font(.caption).foregroundStyle(.secondary)
        }.padding().task(id: isolateSubject) { generate() }.onDisappear { narrator.stop() }.onChange(of: step) { _,_ in narrator.stop() }
    }
    private func generate() {
        narrator.stop(); stages = []; step = 0; failed = false; isolated = false
        let n = 256, s = CGFloat(n)
        guard image.size.width > 0, image.size.height > 0 else { failed = true; return }
        let format = UIGraphicsImageRendererFormat(); format.scale = 1; format.opaque = true
        let normalized = UIGraphicsImageRenderer(size: CGSize(width:s,height:s), format:format).image { ctx in
            UIColor.white.setFill(); ctx.fill(CGRect(x:0,y:0,width:s,height:s))
            let scale = min(s/image.size.width,s/image.size.height)
            let w = image.size.width*scale, h = image.size.height*scale
            image.draw(in:CGRect(x:(s-w)/2,y:(s-h)/2,width:w,height:h))
        }
        guard let original = normalized.cgImage else { failed = true; return }
        var cg = original
        if isolateSubject, let foreground = try? ForegroundIsolation.isolate(original) {
            cg = foreground; isolated = true
        }
        var pixels = [UInt8](repeating:255,count:n*n)
        let ok = pixels.withUnsafeMutableBytes { b -> Bool in
            guard let c = CGContext(data:b.baseAddress,width:n,height:n,bitsPerComponent:8,bytesPerRow:n,space:CGColorSpaceCreateDeviceGray(),bitmapInfo:CGImageAlphaInfo.none.rawValue) else { return false }
            c.draw(cg,in:CGRect(x:0,y:0,width:s,height:s)); return true
        }
        guard ok, let masks = PhotoLessonEdges.stages(pixels,width:n,height:n) else { failed = true; return }
        guard let last = masks.last, let guide = GeometryGuide.constructionMask(last, width: n, height: n) else { failed = true; return }
        stages = ([guide] + masks).compactMap { mask in
            guard let provider = CGDataProvider(data:Data(mask) as CFData),
                  let cg = CGImage(width:n,height:n,bitsPerComponent:8,bitsPerPixel:8,bytesPerRow:n,space:CGColorSpaceCreateDeviceGray(),bitmapInfo:CGBitmapInfo(rawValue:CGImageAlphaInfo.none.rawValue),provider:provider,decode:nil,shouldInterpolate:false,intent:.defaultIntent) else { return nil }
            return UIImage(cgImage:cg)
        }
        if stages.count != 4 { stages = []; failed = true }
    }
}
