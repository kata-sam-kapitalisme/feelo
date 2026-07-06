//
//  SoundManager.swift
//  Feelo
//
//  Created by Rafi Rasendrya Favian on 06/07/26.
//

import SwiftUI
import AVFoundation

// Manager sederhana untuk memutar suara
class SoundManager {
    static let shared = SoundManager()
    private var player: AVAudioPlayer?

    func playSound(named soundName: String) {
        guard let url = Bundle.main.url(forResource: soundName, withExtension: "mp3") else {
            print("File suara tidak ditemukan")
            return
        }
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.play()
        } catch {
            print("Error saat memutar suara: \(error.localizedDescription)")
        }
    }
}
