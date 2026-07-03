import SwiftUI

enum ScenarioRepository {
    static let all: [Scenario] = [
        Scenario(
            id: "pecahkan-gelembung",
            title: "Pecahkan Gelembung",
            introScene1: "Kita akan belajar memecahkan gelembung! Siap?",
            introScene2: "Gunakan tanganmu untuk memecahkan semua gelembung yang muncul. Yuk mulai!",
            bubbleColor: .blue,
            bubbleCount: 12,
            badgeTitle: "Gelembung Ceria",
            gameplayDurationSeconds: 45
        ),
        Scenario(
            id: "si-kancil",
            title: "Si Kancil",
            introScene1: "Si Kancil adalah hewan yang cerdik dan berani. Hari ini kita ikut petualangannya!",
            introScene2: "Bantu Si Kancil melompati rintangan dengan memecahkan gelembung di depannya. Siap melompat?",
            bubbleColor: .green,
            bubbleCount: 10,
            badgeTitle: "Kancil Pemberani",
            gameplayDurationSeconds: 40
        ),
        Scenario(
            id: "bintang-kecil",
            title: "Bintang Kecil",
            introScene1: "Jauh di langit malam, ada bintang kecil yang ingin bersinar lebih terang.",
            introScene2: "Pecahkan gelembung awan yang menutupi bintang agar ia bisa bersinar untuk semua orang!",
            bubbleColor: .yellow,
            bubbleCount: 8,
            badgeTitle: "Bintang Bersinar",
            gameplayDurationSeconds: 35
        ),
        Scenario(
            id: "petualangan-awan",
            title: "Petualangan Awan",
            introScene1: "Awan-awan ajaib mengundangmu untuk terbang bersama mereka hari ini!",
            introScene2: "Sentuh setiap awan yang melayang dan rasakan betapa ringannya perasaanmu. Ayo terbang!",
            bubbleColor: .cyan,
            bubbleCount: 15,
            badgeTitle: "Penjelajah Awan",
            gameplayDurationSeconds: 50
        ),
    ]

    static func scenario(for id: String) -> Scenario? {
        all.first { $0.id == id }
    }

    static var defaultScenario: Scenario { all[0] }
}
