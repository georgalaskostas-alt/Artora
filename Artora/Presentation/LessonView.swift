import SwiftUI

struct LessonView: View {
    let lesson: Lesson

    @EnvironmentObject private var progress: ProgressStore
    @Environment(\.dismiss) private var dismiss
    @State private var currentStep = 0
    @StateObject private var narrator = LessonNarrator()

    private var language: LearningLanguage { progress.preferredLanguage }

    var body: some View {
        VStack(spacing: 28) {
            HStack {
                Text(language == .greek ? "Βήμα \(currentStep + 1) από \(lesson.steps.count)" : "Step \(currentStep + 1) of \(lesson.steps.count)")
                    .font(.subheadline.weight(.semibold))
                Spacer()
                Text("\(Int(Double(currentStep + 1) / Double(lesson.steps.count) * 100))%")
                    .font(.subheadline.monospacedDigit())
            }
            ProgressView(value: Double(currentStep + 1), total: Double(lesson.steps.count))
                .tint(ArtoraTheme.accent)

            Spacer()
            SketchIllustration(lessonID: lesson.id, step: currentStep)
                .frame(maxWidth: .infinity)
                .frame(height: 230)
                .background(ArtoraTheme.soft, in: RoundedRectangle(cornerRadius: 30))
                .accessibilityHidden(true)

            Text(lesson.steps[currentStep].instruction(for: language))
                .font(.system(size: 25, weight: .medium, design: .serif))
                .multilineTextAlignment(.center)
                .foregroundStyle(ArtoraTheme.ink)
                .fixedSize(horizontal: false, vertical: true)

            Text(language == .greek ? "Σχεδίασε στο χαρτί σου και προχώρα όταν είσαι έτοιμος." : "Draw on paper and continue when you're ready.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
            Button { narrator.speak(lesson.steps[currentStep].instruction(for: language), language: language) } label: { Label(language == .greek ? "Άκουσε την οδηγία" : "Listen to instruction", systemImage: "speaker.wave.2") }
            Spacer()

            HStack(spacing: 12) {
                if currentStep > 0 {
                    Button(language == .greek ? "Πίσω" : "Back") { currentStep -= 1 }
                        .buttonStyle(.bordered)
                        .tint(ArtoraTheme.accent)
                }
                Button {
                    if currentStep < lesson.steps.count - 1 {
                        currentStep += 1
                    } else {
                        progress.complete(lesson)
                        dismiss()
                    }
                } label: {
                    Text(currentStep == lesson.steps.count - 1
                         ? (language == .greek ? "Ολοκλήρωση" : "Finish lesson")
                         : (language == .greek ? "Επόμενο βήμα" : "Next step"))
                        .frame(maxWidth: .infinity).padding(.vertical, 9)
                }
                .buttonStyle(.borderedProminent)
                .tint(ArtoraTheme.accent)
            }
        }
        .padding(24)
        .background(ArtoraTheme.paper.ignoresSafeArea())
        .navigationTitle(lesson.title(for: language))
        .navigationBarTitleDisplayMode(.inline)
        .onDisappear { narrator.stop() }
        .onChange(of: currentStep) { _, _ in narrator.stop() }
    }
}
