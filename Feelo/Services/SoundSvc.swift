import AVFoundation

final class SoundSvc {
    static let shared = SoundSvc()
    
    private var clickPlayer: AVAudioPlayer?
    private var levelPlayer: AVAudioPlayer?
    private var effectPlayer: AVAudioPlayer?
    private var bgmPlayer: AVAudioPlayer?
    private var ambientPlayer: AVAudioPlayer?
    private var bubblePopPlayer: AVAudioPlayer?
    private var pumpUpPlayer: AVAudioPlayer?
    private var pumpDownPlayer: AVAudioPlayer?
    private var voicePlayer: AVAudioPlayer?
    
    private init() {
        clickPlayer = makePlayer(AssetName.Sound.click)
        levelPlayer = makePlayer(AssetName.Sound.levelup)
        bubblePopPlayer = makePlayer(AssetName.Sound.bubble_pop)
        pumpUpPlayer = makePlayer(AssetName.Sound.pump_up)
        pumpDownPlayer = makePlayer(AssetName.Sound.pump_down)
        
        clickPlayer?.prepareToPlay()
        levelPlayer?.prepareToPlay()
        bubblePopPlayer?.prepareToPlay()
        pumpUpPlayer?.prepareToPlay()
        pumpDownPlayer?.prepareToPlay()
    }
    
    func click() {
        play(clickPlayer)
    }
    
    func levelUp() {
        play(levelPlayer)
    }
    
    func bubblePop() {
        play(bubblePopPlayer)
    }
    
    func pumpUp() {
        play(pumpUpPlayer)
    }
    
    func pumpDown() {
        play(pumpDownPlayer)
    }
    
    func effect(_ name: String) {
        guard let player = makePlayer(name) else {
            print("Missing sound: \(name)")
            return
        }
        
        effectPlayer = player
        effectPlayer?.play()
    }
    
    func playBGM(_ name: String = AssetName.Sound.bgm) {
        guard let url = soundURL(name) else {
            print("Missing BGM: \(name)")
            return
        }
        
        if bgmPlayer?.url == url,
           bgmPlayer?.isPlaying == true {
            return
        }
        
        do {
            bgmPlayer = try AVAudioPlayer(contentsOf: url)
            bgmPlayer?.numberOfLoops = -1
            bgmPlayer?.play()
        } catch {
            print("BGM error: \(error.localizedDescription)")
        }
    }
    
    func stopBGM() {
        bgmPlayer?.stop()
        bgmPlayer = nil
    }
    
    func playAmbient(_ name: String = AssetName.Sound.ambient) {
        guard let url = soundURL(name) else {
            print("Missing BGM: \(name)")
            return
        }
        
        if ambientPlayer?.url == url,
           ambientPlayer?.isPlaying == true {
            return
        }
        
        do {
            ambientPlayer = try AVAudioPlayer(contentsOf: url)
            ambientPlayer?.numberOfLoops = -1
            ambientPlayer?.play()
        } catch {
            print("BGM error: \(error.localizedDescription)")
        }
    }
    
    func stopAmbient() {
        ambientPlayer?.stop()
        ambientPlayer = nil
    }
    
    func playVoice(_ name: String) {
        voicePlayer?.stop()
        voicePlayer = nil
        
        guard let player = makePlayer(name) else {
            print("Missing voice: \(name)")
            return
        }
        
        voicePlayer = player
        voicePlayer?.play()
    }
    
    func stopVoice() {
        voicePlayer?.stop()
        voicePlayer = nil
    }
    
    private func makePlayer(_ name: String) -> AVAudioPlayer? {
        guard let url = soundURL(name) else {
            return nil
        }
        
        return try? AVAudioPlayer(contentsOf: url)
    }
    
    private func soundURL(_ name: String) -> URL? {
        Bundle.main.url(
            forResource: name,
            withExtension: "mp3"
        )
        ?? Bundle.main.url(
            forResource: name,
            withExtension: "mp3",
            subdirectory: "Sounds"
        )
        ?? Bundle.main.url(
            forResource: name,
            withExtension: "mp3",
            subdirectory: "Res/Sounds"
        )
    }
    
    private func play(_ player: AVAudioPlayer?) {
        player?.stop()
        player?.currentTime = 0
        player?.play()
    }
}
