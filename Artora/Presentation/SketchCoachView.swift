import SwiftUI

struct SketchCoachView: View {
    let result: SketchComparison
    let greek: Bool
    @StateObject private var narrator = LessonNarrator()
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label(greek ? "Ο βοηθός σχεδίου" : "Drawing coach", systemImage: "lightbulb").font(.headline)
            ForEach(SketchCoach.advice(for: result), id: \.rawValue) { advice in
                HStack(alignment: .top) {
                    Image(systemName: "pencil.tip").foregroundStyle(ArtoraTheme.accent)
                    Text(advice.text(greek: greek)).frame(maxWidth: .infinity, alignment: .leading)
                }.font(.subheadline)
            }
            Button {
                narrator.speak(SketchCoach.advice(for: result).map { $0.text(greek: greek) }.joined(separator: " "), language: greek ? .greek : .english)
            } label: { Label(greek ? "Άκουσε τις συμβουλές" : "Listen to tips", systemImage: "speaker.wave.2") }
            Text(greek ? "Πειραματικές συμβουλές βάσει αντιστοίχισης γραμμών. Δεν αξιολογούν το ταλέντο ή την ποιότητα του έργου." : "Experimental tips based on line correspondence, not artistic talent or quality.").font(.caption).foregroundStyle(.secondary)
        }.padding().background(.thinMaterial, in: RoundedRectangle(cornerRadius: 16))
        .onDisappear { narrator.stop() }
    }
}
