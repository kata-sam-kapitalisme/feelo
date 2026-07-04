import SwiftUI

enum ScenarioRepository {
    static let all: [Scenario] = [
        Scenario(
            id: "pecahkan-gelembung",
            title: "Pecahkan Gelembung",
            placeTag: "Taman Bermain",
            emotionTag: "Bersemangat",
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
            placeTag: "Taman Bermain",
            emotionTag: "Senang",
            introScene1: "Si Kancil adalah hewan yang cerdik dan berani. Hari ini kita ikut petualangannya!",
            introScene2: "Bantu Si Kancil melompati rintangan dengan memecahkan gelembung di depannya. Siap melompat?",
            bubbleColor: .green,
            bubbleCount: 10,
            badgeTitle: "Kancil Pemberani",
            gameplayDurationSeconds: 40,
            isLocked: true
        ),
        Scenario(
            id: "bintang-kecil",
            title: "Bintang Kecil",
            placeTag: "Sekolah",
            emotionTag: "Senang",
            introScene1: "Jauh di langit malam, ada bintang kecil yang ingin bersinar lebih terang.",
            introScene2: "Pecahkan gelembung awan yang menutupi bintang agar ia bisa bersinar untuk semua orang!",
            bubbleColor: .yellow,
            bubbleCount: 8,
            badgeTitle: "Bintang Bersinar",
            gameplayDurationSeconds: 35,
            isLocked: true
        ),
        Scenario(
            id: "pompa-bola",
            title: "Pompa Bola",
            placeTag: "Taman Bermain",
            emotionTag: "Bersemangat",
            introScene1: "Ada bola yang kempes di taman! Ayo kita pompa bersama!",
            introScene2: "Gerakkan tanganmu naik dan turun untuk memompa bola. Pompa sampai penuh, yuk!",
            bubbleColor: .orange,
            bubbleCount: 0,
            badgeTitle: "Pemompa Hebat",
            gameplayDurationSeconds: 60,
            gameType: .pumpBall
        ),
        Scenario(
            id: "petualangan-awan",
            title: "Petualangan Awan",
            placeTag: "Rumah",
            emotionTag: "Bersemangat",
            introScene1: "Awan-awan ajaib mengundangmu untuk terbang bersama mereka hari ini!",
            introScene2: "Sentuh setiap awan yang melayang dan rasakan betapa ringannya perasaanmu. Ayo terbang!",
            bubbleColor: .cyan,
            bubbleCount: 15,
            badgeTitle: "Penjelajah Awan",
            gameplayDurationSeconds: 50,
            isLocked: true
        ),
    ]

    static func scenario(for id: String) -> Scenario? {
        all.first { $0.id == id }
    }

    static func scenarios(forPlace place: String) -> [Scenario] {
        all.filter { $0.placeTag == place }
    }

    static func scenarios(forEmotion emotion: String) -> [Scenario] {
        all.filter { $0.emotionTag == emotion }
    }

    static var defaultScenario: Scenario { all[0] }
}
