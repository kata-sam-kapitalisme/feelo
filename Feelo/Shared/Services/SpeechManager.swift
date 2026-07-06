import AVFoundation
import Observation

@Observable final class SpeechManager {
    private let synthesizer = AVSpeechSynthesizer()

    func speak(_ text: String) {
        synthesizer.stopSpeaking(at: .immediate)
        let utterance = AVSpeechUtterance(string: text)
        // Prefer enhanced Damayanti (warmer, more natural) → fall back to any id-ID voice
        utterance.voice = AVSpeechSynthesisVoice(identifier: "com.apple.voice.enhanced.id-ID.Damayanti")
            ?? AVSpeechSynthesisVoice.speechVoices().filter { $0.language == "id-ID" }.max(by: { $0.quality.rawValue < $1.quality.rawValue })
            ?? AVSpeechSynthesisVoice(language: "id-ID")
        utterance.rate = 0.42   // slightly slower — easier for kids to follow
        utterance.pitchMultiplier = 1.1  // slightly higher pitch — friendlier tone
        synthesizer.speak(utterance)
    }

    func stop() {
        synthesizer.stopSpeaking(at: .immediate)
    }
}
