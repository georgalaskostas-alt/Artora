import Foundation

enum CoachingAdvice: String, Equatable {
    case retake, outline, simplify, compareDetails, practice
    func text(greek: Bool) -> String {
        switch self {
        case .retake: return greek ? "Έλεγξε τον φωτισμό, την περιστροφή και το επιλεγμένο πρότυπο. Φωτογράφισε ξανά πριν βγάλεις συμπεράσματα." : "Check lighting, rotation and the selected reference. Retake the photo before drawing conclusions."
        case .outline: return greek ? "Έλεγξε τις πορτοκαλί περιοχές. Δοκίμασε να σχεδιάσεις ξανά το βασικό περίγραμμα με απαλές γραμμές." : "Inspect the orange areas. Try drawing the main outline again with light strokes."
        case .simplify: return greek ? "Έλεγξε τις μπλε περιοχές. Αν πρόκειται για βοηθητικές γραμμές, σβήσε όσες δεν χρειάζεσαι." : "Inspect the blue areas. If they are construction lines, erase those you no longer need."
        case .compareDetails: return greek ? "Σύγκρινε τις αποστάσεις και τις καμπύλες με το πρότυπο, μία περιοχή κάθε φορά." : "Compare distances and curves with the reference, one region at a time."
        case .practice: return greek ? "Οι γραμμές εμφανίζουν κοντινή αντιστοίχιση. Δοκίμασε το ίδιο σχέδιο χωρίς να κοιτάς συνεχώς το πρότυπο." : "The lines show close correspondence. Try the same drawing without constantly looking at the reference."
        }
    }
}
enum SketchCoach {
    static func advice(for result: SketchComparison) -> [CoachingAdvice] {
        let r = result.referenceCoverage, d = result.drawingCoverage
        guard r.isFinite, d.isFinite, (0...1).contains(r), (0...1).contains(d), min(r,d) >= 0.25 else { return [.retake] }
        var advice: [CoachingAdvice] = []
        if r < 0.75 { advice.append(.outline) }
        if d < 0.75 { advice.append(.simplify) }
        if advice.isEmpty { return min(r,d) >= 0.9 ? [.practice] : [.compareDetails] }
        return advice + [.compareDetails]
    }
}
