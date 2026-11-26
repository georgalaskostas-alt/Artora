import Foundation

struct Lesson: Identifiable, Hashable {
    let id: String
    let titleEN: String
    let titleEL: String
    let category: LessonCategory
    let difficulty: Int
    let durationMinutes: Int
    let systemImage: String
    let steps: [LessonStep]

    func title(for language: LearningLanguage) -> String {
        language == .greek ? titleEL : titleEN
    }
}

struct LessonStep: Identifiable, Hashable {
    let id: String
    let instructionEN: String
    let instructionEL: String

    func instruction(for language: LearningLanguage) -> String {
        language == .greek ? instructionEL : instructionEN
    }
}

enum LessonCategory: String, CaseIterable, Identifiable {
    case foundations, nature, animals, objects

    var id: String { rawValue }

    var symbol: String {
        switch self {
        case .foundations: return "square.on.circle"
        case .nature: return "leaf"
        case .animals: return "pawprint"
        case .objects: return "cube"
        }
    }

    func name(for language: LearningLanguage) -> String {
        switch (self, language) {
        case (.foundations, .greek): return "Βασικές τεχνικές"
        case (.foundations, .english): return "Foundations"
        case (.nature, .greek): return "Φύση"
        case (.nature, .english): return "Nature"
        case (.animals, .greek): return "Ζώα"
        case (.animals, .english): return "Animals"
        case (.objects, .greek): return "Αντικείμενα"
        case (.objects, .english): return "Objects"
        }
    }
}

enum LearningLanguage: String, CaseIterable, Identifiable {
    case greek = "el"
    case english = "en"
    var id: String { rawValue }
    var label: String { self == .greek ? "Ελληνικά" : "English" }
}

enum LessonCatalog {
    static let lessons: [Lesson] = [
        Lesson(id: "basic-shapes", titleEN: "Shape your first sketch", titleEL: "Τα πρώτα σου σχήματα", category: .foundations, difficulty: 1, durationMinutes: 8, systemImage: "circle.grid.2x2",
            steps: [
                LessonStep(id: "shapes-1", instructionEN: "Draw a light circle in the middle of the paper.", instructionEL: "Σχεδίασε έναν απαλό κύκλο στο κέντρο του χαρτιού."),
                LessonStep(id: "shapes-2", instructionEN: "Add a square beside the circle.", instructionEL: "Πρόσθεσε ένα τετράγωνο δίπλα στον κύκλο."),
                LessonStep(id: "shapes-3", instructionEN: "Draw a triangle and compare all three outlines.", instructionEL: "Σχεδίασε ένα τρίγωνο και σύγκρινε τα περιγράμματα.")
            ]),
        Lesson(id: "simple-leaf", titleEN: "A leaf in four strokes", titleEL: "Ένα φύλλο σε τέσσερις κινήσεις", category: .nature, difficulty: 1, durationMinutes: 10, systemImage: "leaf",
            steps: [
                LessonStep(id: "leaf-1", instructionEN: "Draw a gently curved center line.", instructionEL: "Σχεδίασε μια ελαφρά καμπύλη κεντρική γραμμή."),
                LessonStep(id: "leaf-2", instructionEN: "Connect the tip to the base with one curved side.", instructionEL: "Σύνδεσε την κορυφή με τη βάση με μια καμπύλη πλευρά."),
                LessonStep(id: "leaf-3", instructionEN: "Repeat on the other side.", instructionEL: "Επανάλαβε στην άλλη πλευρά."),
                LessonStep(id: "leaf-4", instructionEN: "Add delicate veins from the central line.", instructionEL: "Πρόσθεσε λεπτές νευρώσεις από την κεντρική γραμμή.")
            ]),
        Lesson(id: "little-cat", titleEN: "Sketch a curious cat", titleEL: "Σχεδίασε μια περίεργη γάτα", category: .animals, difficulty: 2, durationMinutes: 12, systemImage: "cat",
            steps: [
                LessonStep(id: "cat-1", instructionEN: "Draw a circle for the head.", instructionEL: "Σχεδίασε έναν κύκλο για το κεφάλι."),
                LessonStep(id: "cat-2", instructionEN: "Add two triangular ears.", instructionEL: "Πρόσθεσε δύο τριγωνικά αυτιά."),
                LessonStep(id: "cat-3", instructionEN: "Place two eyes and a small nose.", instructionEL: "Τοποθέτησε δύο μάτια και μια μικρή μύτη."),
                LessonStep(id: "cat-4", instructionEN: "Finish with whiskers and gentle curves for the body.", instructionEL: "Ολοκλήρωσε με μουστάκια και απαλές καμπύλες για το σώμα.")
            ]),
        Lesson(id: "coffee-cup", titleEN: "A cozy coffee cup", titleEL: "Μια κούπα καφέ", category: .objects, difficulty: 2, durationMinutes: 14, systemImage: "cup.and.saucer",
            steps: [
                LessonStep(id: "cup-1", instructionEN: "Draw a wide oval for the cup opening.", instructionEL: "Σχεδίασε μια φαρδιά έλλειψη για το άνοιγμα της κούπας."),
                LessonStep(id: "cup-2", instructionEN: "Drop two sides from the oval.", instructionEL: "Κατέβασε δύο πλευρές από την έλλειψη."),
                LessonStep(id: "cup-3", instructionEN: "Connect the bottom with a soft curve and add a handle.", instructionEL: "Ένωσε τη βάση με μια απαλή καμπύλη και πρόσθεσε χερούλι.")
            ])
    ] + ExtraLessons.lessons
}
