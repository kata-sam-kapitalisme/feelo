import AVFoundation
import Observation

@Observable
final class SpeechSvc {
    private let synth = AVSpeechSynthesizer()

    func speak(_ text: String) {
        synth.stopSpeaking(at: .immediate)

        let utterance = AVSpeechUtterance(string: text)

        utterance.voice =
            AVSpeechSynthesisVoice(identifier: "com.apple.voice.enhanced.id-ID.Damayanti")
            ?? AVSpeechSynthesisVoice.speechVoices()
                .filter { $0.language == "id-ID" }
                .max { $0.quality.rawValue < $1.quality.rawValue }
            ?? AVSpeechSynthesisVoice(language: "id-ID")

        utterance.rate = 0.42
        utterance.pitchMultiplier = 1.1

        synth.speak(utterance)
    }

    func stop() {
        synth.stopSpeaking(at: .immediate)
    }
}
