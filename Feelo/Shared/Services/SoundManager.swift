import AVFoundation

final class SoundManager {
    static let shared = SoundManager()
    private var clickPlayer: AVAudioPlayer?
    private var levelUpPlayer: AVAudioPlayer?
    private var generalPlayer: AVAudioPlayer?

    private var bgmPlayer: AVAudioPlayer?
    
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

    func playSound(named soundName: String) {
        guard let url = Bundle.main.url(forResource: soundName, withExtension: "mp3") else {
            print("File suara tidak ditemukan: \(soundName)")
            return
        }
        do {
            generalPlayer = try AVAudioPlayer(contentsOf: url)
            generalPlayer?.play()
        } catch {
            print("Error saat memutar suara: \(error.localizedDescription)")
        }
    }
    
    func playBGM(named soundName: String = "bgm_homepage") {
            guard let url = Bundle.main.url(forResource: soundName, withExtension: "mp3") else {
                print("File BGM tidak ditemukan: \(soundName)")
                return
            }
            
            if bgmPlayer?.url == url && bgmPlayer?.isPlaying == true {
                return
            }
            
            do {
                bgmPlayer = try AVAudioPlayer(contentsOf: url)
                bgmPlayer?.numberOfLoops = -1 
                bgmPlayer?.play()
            } catch {
                print("Error saat memutar BGM: \(error.localizedDescription)")
            }
        }
        
        func stopBGM() {
            bgmPlayer?.stop()
            bgmPlayer = nil
        }
}
