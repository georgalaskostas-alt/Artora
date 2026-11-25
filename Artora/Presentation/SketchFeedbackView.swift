import SwiftUI
import UIKit

struct SketchFeedbackView: View {
    let image: UIImage
    let greek: Bool
    @State private var metrics: SketchMetrics?
    var body: some View {
        VStack(alignment:.leading,spacing:12) {
            Text(greek ? "Πειραματική ανάλυση εικόνας" : "Experimental image analysis").font(.headline)
            Button(greek ? "Ανάλυση" : "Analyze") { metrics = SketchAnalyzer.measure(image) }.buttonStyle(.borderedProminent)
            if let metrics {
                metric(greek ? "Σκούρα εικονοστοιχεία" : "Dark pixels",metrics.inkFraction)
                metric(greek ? "Οριζόντια έκταση" : "Horizontal span",metrics.horizontalSpan)
                metric(greek ? "Κατακόρυφη έκταση" : "Vertical span",metrics.verticalSpan)
                Text(greek ? "Σύγκρινε το περίγραμμα και τις αναλογίες με το παράδειγμα του μαθήματος. Οι σκιές και ο φωτισμός επηρεάζουν τις μετρήσεις." : "Compare outlines and proportions with your lesson reference. Shadows and lighting affect these measurements.").font(.subheadline)
            }
            Text(greek ? "Δεν είναι βαθμολογία ούτε αξιολόγηση από εκπαιδευμένο μοντέλο AI." : "Not a grade or a trained AI assessment.").font(.caption).foregroundStyle(.secondary)
        }.padding().frame(maxWidth:.infinity,alignment:.leading).background(.thinMaterial,in:RoundedRectangle(cornerRadius:18))
    }
    private func metric(_ title:String,_ value:Double) -> some View {
        VStack(alignment:.leading) {
            HStack { Text(title); Spacer(); Text(value,format:.percent.precision(.fractionLength(1))) }
            ProgressView(value:value)
        }.font(.subheadline)
    }
}
