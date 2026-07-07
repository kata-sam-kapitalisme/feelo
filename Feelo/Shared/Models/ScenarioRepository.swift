import SwiftUI

enum ScenarioRepository {
    static let all: [Scenario] = [
        Scenario(
            id: "pecahkan-gelembung",
            title: "Pecahkan Gelembung",
            placeTag: "Taman Bermain",
            thumbnail: "bubble",
            emotionTag: "Bersemangat",
            introScene1: "Kita akan belajar memecahkan gelembung! Siap?",
            introScene2: "Gunakan tanganmu untuk memecahkan semua gelembung yang muncul. Yuk mulai!",
            bubbleColor: .blue,
            bubbleCount: 12,
            badgeTitle: "Gelembung Ceria",
            badgeImage: "sticker_bubble",
            gameplayDurationSeconds: 45
        ),
        Scenario(
            id: "pompa-bola",
            title: "Pompa Bola",
            placeTag: "Taman Bermain",
            thumbnail: "pompa",
            emotionTag: "Kecewa",
            introScene1: "Ada bola yang kempes di taman! Ayo kita pompa bersama!",
            introScene2: "Gerakkan tanganmu naik dan turun untuk memompa bola. Pompa sampai penuh, yuk!",
            bubbleColor: .orange,
            bubbleCount: 0,
            badgeTitle: "Pom-pom-pa!",
            badgeImage: "sticker_basket",
            gameplayDurationSeconds: 60,
            gameType: .pumpBall
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
