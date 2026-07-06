import AVFoundation

final class SoundManager {
    static let shared = SoundManager()
    private var clickPlayer: AVAudioPlayer?
    private var levelUpPlayer: AVAudioPlayer?

    private init() {
        if let url = Bundle.main.url(forResource: "floraphonic-casual-click-pop-ui-4-262121", withExtension: "mp3") {
            clickPlayer = try? AVAudioPlayer(contentsOf: url)
            clickPlayer?.prepareToPlay()
        }
        if let url = Bundle.main.url(forResource: "universfield-level-up-02-199574", withExtension: "mp3") {
            levelUpPlayer = try? AVAudioPlayer(contentsOf: url)
            levelUpPlayer?.prepareToPlay()
        }
    }

    func playClick() {
        clickPlayer?.stop()
        clickPlayer?.currentTime = 0
        clickPlayer?.play()
    }

    func playLevelUp() {
        levelUpPlayer?.stop()
        levelUpPlayer?.currentTime = 0
        levelUpPlayer?.play()
    }
}
