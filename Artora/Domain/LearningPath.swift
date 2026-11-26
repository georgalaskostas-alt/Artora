import Foundation

enum LearningPath {
    static func next(in lessons: [Lesson], completed: Set<String>, preferred: LessonCategory? = nil) -> Lesson? {
        let remaining = lessons.filter { !completed.contains($0.id) }
        let ordered = remaining.sorted {
            if $0.difficulty != $1.difficulty { return $0.difficulty < $1.difficulty }
            if ($0.category == preferred) != ($1.category == preferred) { return $0.category == preferred }
            return $0.id < $1.id
        }
        return ordered.first
    }
}
