import AVFoundation
import Combine

final class LessonNarrator: ObservableObject {
    private let synthesizer = AVSpeechSynthesizer()
    func speak(_ text: String, language: LearningLanguage) {
        stop()
        let utterance = AVSpeechUtterance(string:text)
        utterance.voice = AVSpeechSynthesisVoice(language:language == .greek ? "el-GR" : "en-US")
        utterance.rate = AVSpeechUtteranceDefaultSpeechRate * 0.85
        synthesizer.speak(utterance)
    }
    func stop() { synthesizer.stopSpeaking(at:.immediate) }
}
