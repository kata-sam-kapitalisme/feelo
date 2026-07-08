import SwiftUI

enum ScenarioRepo {
    static let all: [Scenario] = [
        Scenario(
            id: "pecahkan-gelembung",
            title: "Pecahkan Gelembung",
            place: "Taman Bermain",
            thumb: AssetName.Img.placeBubble,
            emotion: "Bersemangat",
            intro1: "Kita akan belajar memecahkan gelembung! Siap?",
            intro2: "Gunakan tanganmu untuk memecahkan semua gelembung yang muncul. Yuk mulai!",
            bubbleColor: .blue,
            bubbleCount: 12,
            badgeTitle: "Gelembung Ceria",
            badgeImg: AssetName.Img.stBubble,
            duration: 45,
            kind: .bubble
        ),

        Scenario(
            id: "pompa-bola",
            title: "Pompa Bola",
            place: "Taman Bermain",
            thumb: AssetName.Img.placePump,
            emotion: "Kecewa",
            intro1: "Ada bola yang kempes di taman! Ayo kita pompa bersama!",
            intro2: "Gerakkan tanganmu naik dan turun untuk memompa bola. Pompa sampai penuh, yuk!",
            bubbleColor: .orange,
            bubbleCount: 0,
            badgeTitle: "Pom-pom-pa!",
            badgeImg: AssetName.Img.stBasket,
            duration: 60,
            kind: .pump
        )
    ]

    static var first: Scenario {
        all[0]
    }

    static func item(_ id: String) -> Scenario? {
        all.first { $0.id == id }
    }

    static func byPlace(_ place: String) -> [Scenario] {
        all.filter { $0.place == place }
    }

    static func byEmotion(_ emotion: String) -> [Scenario] {
        all.filter { $0.emotion == emotion }
    }
}
