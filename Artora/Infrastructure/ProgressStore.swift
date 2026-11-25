import Combine
import Foundation

@MainActor
final class ProgressStore: ObservableObject {
    @Published private(set) var completedIDs: Set<String>
    @Published var preferredLanguage: LearningLanguage {
        didSet { defaults.set(preferredLanguage.rawValue, forKey: languageKey) }
    }

    private let defaults: UserDefaults
    private let completedKey = "artora.completedLessonIDs.v1"
    private let languageKey = "artora.preferredLanguage.v1"

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        completedIDs = Set(defaults.stringArray(forKey: completedKey) ?? [])
        let saved = defaults.string(forKey: languageKey)
        let deviceLanguage = Locale.preferredLanguages.first ?? "en"
        preferredLanguage = LearningLanguage(rawValue: saved ?? "") ?? (deviceLanguage.hasPrefix("el") ? .greek : .english)
    }

    func complete(_ lesson: Lesson) {
        completedIDs.insert(lesson.id)
        defaults.set(completedIDs.sorted(), forKey: completedKey)
    }

    func isComplete(_ lesson: Lesson) -> Bool { completedIDs.contains(lesson.id) }

    func completionRate(for lessons: [Lesson]) -> Double {
        guard !lessons.isEmpty else { return 0 }
        return Double(lessons.filter { completedIDs.contains($0.id) }.count) / Double(lessons.count)
    }
}
