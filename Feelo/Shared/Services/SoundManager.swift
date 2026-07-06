import AVFoundation

final class SoundManager {
    static let shared = SoundManager()
    private var player: AVAudioPlayer?

    private init() {
        guard let url = Bundle.main.url(
            forResource: "floraphonic-casual-click-pop-ui-4-262121",
            withExtension: "mp3"
        ) else { return }
        player = try? AVAudioPlayer(contentsOf: url)
        player?.prepareToPlay()
    }

    func playClick() {
        player?.stop()
        player?.currentTime = 0
        player?.play()
    }
}
