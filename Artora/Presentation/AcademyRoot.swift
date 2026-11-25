import SwiftUI

struct AcademyRoot: View {
    @EnvironmentObject private var progress: ProgressStore
    @AppStorage("artora.onboarding.v1") private var onboarded = false
    private var greek: Bool { progress.preferredLanguage == .greek }
    var body: some View {
        TabView {
            HomeView().tabItem { Label(greek ? "Μαθήματα" : "Learn", systemImage:"book") }
            NavigationStack { StudioView() }.tabItem { Label(greek ? "Εργαστήριο" : "Studio", systemImage:"pencil.tip") }
            NavigationStack { PhotoReviewView() }.tabItem { Label(greek ? "Έλεγχος" : "Review", systemImage:"viewfinder") }
            NavigationStack {
                List {
                    Section(greek ? "Πρόοδος" : "Progress") {
                        ProgressView(value:progress.completionRate(for:LessonCatalog.lessons))
                        ForEach(LessonCatalog.lessons.filter { progress.isComplete($0) }) { lesson in
                            Label(lesson.title(for:progress.preferredLanguage),systemImage:"checkmark.circle")
                        }
                    }
                    Section(greek ? "Ρυθμίσεις" : "Settings") {
                        Picker(greek ? "Γλώσσα" : "Language",selection:$progress.preferredLanguage) {
                            ForEach(LearningLanguage.allCases) { Text($0.label).tag($0) }
                        }
                        Button(greek ? "Εισαγωγή" : "Show introduction") { onboarded = false }
                    }
                }.navigationTitle(greek ? "Η πορεία μου" : "My journey")
            }.tabItem { Label(greek ? "Πρόοδος" : "Progress",systemImage:"chart.bar") }
        }
        .tint(ArtoraTheme.accent)
        .fullScreenCover(isPresented: Binding(get:{ !onboarded },set:{ onboarded = !$0 })) {
            VStack(spacing: 24) {
                Spacer()
                SketchIllustration(lessonID:"simple-leaf",step:3).frame(height:220)
                Text("ARTORA").font(.caption.bold()).tracking(6)
                Text(greek ? "Κάθε γραμμή είναι μια αρχή." : "Every line is a beginning.").font(.largeTitle.bold()).multilineTextAlignment(.center)
                Text(greek ? "Χαρτί, μολύβι και λίγα λεπτά κάθε μέρα." : "Paper, pencil, and a few minutes each day.").multilineTextAlignment(.center)
                Picker("Language",selection:$progress.preferredLanguage) { ForEach(LearningLanguage.allCases) { Text($0.label).tag($0) } }.pickerStyle(.segmented)
                Spacer()
                Button { onboarded = true } label: { Text(greek ? "Ξεκινάμε" : "Begin").frame(maxWidth:.infinity).padding(10) }.buttonStyle(.borderedProminent).tint(ArtoraTheme.accent)
            }.padding(30).background(ArtoraTheme.paper.ignoresSafeArea()).foregroundStyle(ArtoraTheme.ink)
        }
    }
}
