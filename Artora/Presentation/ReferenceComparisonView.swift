import SwiftUI
import UIKit

struct ReferenceComparisonView: View {
    let image: UIImage
    let greek: Bool
    @State private var lessonID = LessonCatalog.lessons[0].id
    @State private var result: SketchComparison?
    @State private var message = ""
    private let side = 128
    private var lesson: Lesson { LessonCatalog.lessons.first { $0.id == lessonID } ?? LessonCatalog.lessons[0] }

    var body: some View {
        VStack(alignment:.leading,spacing:12) {
            Text(greek ? "Σύγκριση με πρότυπο" : "Compare with reference").font(.headline)
            Picker(greek ? "Μάθημα" : "Lesson",selection:$lessonID) {
                ForEach(LessonCatalog.lessons) { item in Text(item.title(for:greek ? .greek : .english)).tag(item.id) }
            }
            SketchIllustration(lessonID:lessonID,step:lesson.steps.count-1).frame(height:150).background(.white,in:RoundedRectangle(cornerRadius:12))
            Text(greek ? "Χρησιμοποίησε καθαρή, κάθετη φωτογραφία με το σχέδιο στην ίδια θέση και κλίμακα με το πρότυπο." : "Use a clear overhead photo with your sketch at the same position and scale as the reference.").font(.caption)
            Button(greek ? "Σύγκριση" : "Compare") { compare() }.buttonStyle(.borderedProminent)
            if let result {
                Canvas { context,size in
                    let cell = min(size.width,size.height)/CGFloat(side)
                    let ox = (size.width-cell*CGFloat(side))/2
                    let oy = (size.height-cell*CGFloat(side))/2
                    for i in result.missing.indices {
                        guard result.missing[i] || result.extra[i] else { continue }
                        let rect = CGRect(x:ox+CGFloat(i%side)*cell,y:oy+CGFloat(i/side)*cell,width:cell,height:cell)
                        context.fill(Path(rect),with:.color(result.missing[i] ? .orange : .blue))
                    }
                }.frame(height:210).background(.white,in:RoundedRectangle(cornerRadius:12))
                Label(greek ? "Πορτοκαλί: γραμμές προτύπου χωρίς κοντινή αντιστοίχιση" : "Orange: unmatched reference lines",systemImage:"circle.fill").foregroundStyle(.orange)
                Label(greek ? "Μπλε: γραμμές φωτογραφίας χωρίς κοντινή αντιστοίχιση" : "Blue: unmatched photo lines",systemImage:"circle.fill").foregroundStyle(.blue)
                Text((greek ? "Κάλυψη προτύπου: " : "Reference coverage: ") + result.referenceCoverage.formatted(.percent.precision(.fractionLength(0))))
            }
            Text(message).font(.caption)
            Text(greek ? "Πειραματική σύγκριση pixels χωρίς αυτόματη ευθυγράμμιση. Δεν αποτελεί βαθμολογία ή AI αξιολόγηση." : "Experimental pixel comparison without automatic alignment. Not a grade or AI assessment.").font(.caption).foregroundStyle(.secondary)
        }.padding().background(.thinMaterial,in:RoundedRectangle(cornerRadius:18))
        .onChange(of:lessonID) { _,_ in result = nil; message = "" }
    }

    @MainActor private func compare() {
        result = nil
        let renderer = ImageRenderer(content:SketchIllustration(lessonID:lessonID,step:lesson.steps.count-1).frame(width:240,height:240).background(.white))
        renderer.scale = 1
        guard let reference = renderer.uiImage,
              let a = mask(reference), let b = mask(image),
              b.count > 12, b.count < side*side/2,
              let comparison = SketchComparison.compare(reference:a,drawing:b) else {
            message = greek ? "Δεν βρέθηκε κατάλληλο σχέδιο. Δοκίμασε καλύτερο φωτισμό." : "No suitable sketch detected. Try better lighting."
            return
        }
        result = comparison
        message = ""
    }

    private func mask(_ image:UIImage) -> SketchMask? {
        guard image.size.width > 0,image.size.height > 0 else { return nil }
        let format = UIGraphicsImageRendererFormat(); format.scale = 1; format.opaque = true
        let s = CGFloat(side)
        let normalized = UIGraphicsImageRenderer(size:CGSize(width:s,height:s),format:format).image { ctx in
            UIColor.white.setFill(); ctx.fill(CGRect(x:0,y:0,width:s,height:s))
            let scale = min(s/image.size.width,s/image.size.height)
            let w = image.size.width*scale,h = image.size.height*scale
            image.draw(in:CGRect(x:(s-w)/2,y:(s-h)/2,width:w,height:h))
        }
        guard let cg = normalized.cgImage else { return nil }
        var bytes = [UInt8](repeating:255,count:side*side)
        let ok = bytes.withUnsafeMutableBytes { buffer -> Bool in
            guard let ctx = CGContext(data:buffer.baseAddress,width:side,height:side,bitsPerComponent:8,bytesPerRow:side,space:CGColorSpaceCreateDeviceGray(),bitmapInfo:CGImageAlphaInfo.none.rawValue) else { return false }
            ctx.draw(cg,in:CGRect(x:0,y:0,width:s,height:s)); return true
        }
        return ok ? SketchMask(pixels:bytes,side:side) : nil
    }
}
