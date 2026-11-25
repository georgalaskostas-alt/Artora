import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var progress: ProgressStore
    @State private var selectedCategory: LessonCategory?

    private var language: LearningLanguage { progress.preferredLanguage }
    private var shownLessons: [Lesson] {
        LessonCatalog.lessons.filter { selectedCategory == nil || $0.category == selectedCategory }
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    HStack {
                        VStack(alignment: .leading, spacing: 6) {
                            Text("ARTORA")
                                .font(.system(size: 12, weight: .black, design: .rounded))
                                .tracking(4)
                                .foregroundStyle(ArtoraTheme.accent)
                            Text(language == .greek ? "Η τέχνη αρχίζει εδώ." : "Art begins here.")
                                .font(.system(size: 33, weight: .bold, design: .serif))
                                .foregroundStyle(ArtoraTheme.ink)
                        }
                        Spacer()
                        Image(systemName: "pencil.tip.crop.circle")
                            .font(.system(size: 33))
                            .foregroundStyle(ArtoraTheme.accent)
                            .accessibilityHidden(true)
                    }

                    VStack(alignment: .leading, spacing: 15) {
                        Text(language == .greek ? "Ο δικός σου καμβάς" : "Your drawing journey")
                            .font(.title3.bold())
                        Text(language == .greek ? "Πάρε χαρτί και μολύβι. Μια γραμμή τη φορά." : "Grab paper and a pencil. One line at a time.")
                            .foregroundStyle(.secondary)
                        ProgressView(value: progress.completionRate(for: LessonCatalog.lessons))
                            .tint(ArtoraTheme.accent)
                        Text("\(progress.completedIDs.count) / \(LessonCatalog.lessons.count) " + (language == .greek ? "μαθήματα" : "lessons"))
                            .font(.caption.weight(.semibold))
                    }
                    .padding(22)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(ArtoraTheme.soft, in: RoundedRectangle(cornerRadius: 26))

                    HStack {
                        Text(language == .greek ? "Ανακάλυψε" : "Explore")
                            .font(.title2.bold())
                        Spacer()
                        Picker("Language", selection: $progress.preferredLanguage) {
                            ForEach(LearningLanguage.allCases) { option in
                                Text(option.label).tag(option)
                            }
                        }
                        .labelsHidden()
                        .accessibilityLabel(language == .greek ? "Γλώσσα" : "Language")
                    }

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 9) {
                            categoryChip(nil, title: language == .greek ? "Όλα" : "All")
                            ForEach(LessonCategory.allCases) { category in
                                categoryChip(category, title: category.name(for: language))
                            }
                        }
                    }

                    LazyVStack(spacing: 12) {
                        ForEach(shownLessons) { lesson in
                            NavigationLink(value: lesson) {
                                LessonCard(lesson: lesson, language: language, complete: progress.isComplete(lesson))
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
                .padding(22)
            }
            .background(ArtoraTheme.paper.ignoresSafeArea())
            .navigationDestination(for: Lesson.self) { lesson in
                LessonView(lesson: lesson)
            }
        }
    }

    private func categoryChip(_ category: LessonCategory?, title: String) -> some View {
        Button {
            selectedCategory = category
        } label: {
            Text(title)
                .font(.subheadline.weight(.medium))
                .padding(.horizontal, 15)
                .padding(.vertical, 10)
                .foregroundStyle(selectedCategory == category ? Color.white : ArtoraTheme.ink)
                .background(selectedCategory == category ? ArtoraTheme.accent : Color.white,
                            in: Capsule())
        }
    }
}

private struct LessonCard: View {
    let lesson: Lesson
    let language: LearningLanguage
    let complete: Bool

    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: lesson.systemImage)
                .font(.system(size: 27))
                .frame(width: 72, height: 76)
                .foregroundStyle(ArtoraTheme.accent)
                .background(ArtoraTheme.soft, in: RoundedRectangle(cornerRadius: 17))
                .accessibilityHidden(true)
            VStack(alignment: .leading, spacing: 6) {
                Text(lesson.category.name(for: language).uppercased())
                    .font(.system(size: 10, weight: .bold)).tracking(1.2)
                    .foregroundStyle(ArtoraTheme.accent)
                Text(lesson.title(for: language))
                    .font(.headline)
                    .foregroundStyle(ArtoraTheme.ink)
                Text("\(lesson.durationMinutes) min · " + (language == .greek ? "Επίπεδο" : "Level") + " \(lesson.difficulty)")
                    .font(.caption).foregroundStyle(.secondary)
            }
            Spacer(minLength: 4)
            Image(systemName: complete ? "checkmark.circle.fill" : "arrow.up.right")
                .foregroundStyle(ArtoraTheme.accent)
        }
        .padding(12)
        .background(.white, in: RoundedRectangle(cornerRadius: 22))
        .accessibilityElement(children: .combine)
    }
}
