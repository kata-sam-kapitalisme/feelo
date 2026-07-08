import SwiftUI

struct PlaceItem: Identifiable {
    let id = UUID()
    let title: String
    let img: String
    let locked: Bool
}

struct EmotionItem: Identifiable {
    let id = UUID()
    let title: String
    let img: String
    let color: Color
    let locked: Bool
}

enum HomeData {
    static let places: [PlaceItem] = [
        PlaceItem(
            title: "Taman Bermain",
            img: AssetName.Img.placeBubble,
            locked: false
        ),
        PlaceItem(
            title: "Sekolah",
            img: AssetName.Img.placeSchool,
            locked: true
        ),
        PlaceItem(
            title: "Rumah",
            img: AssetName.Img.placeHome,
            locked: true
        ),
        PlaceItem(
            title: "Pantai",
            img: AssetName.Img.placeBeach,
            locked: true
        ),
        PlaceItem(
            title: "Kebun",
            img: AssetName.Img.placeFarm,
            locked: true
        )
    ]

    static let emotions: [EmotionItem] = [
        EmotionItem(
            title: "Bersemangat",
            img: AssetName.Img.emoExcited,
            color: .yellow,
            locked: false
        ),
        EmotionItem(
            title: "Kecewa",
            img: AssetName.Img.emoUpset,
            color: Color(hex: "8C33BF"),
            locked: false
        ),
        EmotionItem(
            title: "Takut",
            img: AssetName.Img.emoAfraid,
            color: .indigo,
            locked: true
        ),
        EmotionItem(
            title: "Bangga",
            img: AssetName.Img.emoHappy,
            color: .orange,
            locked: true
        ),
        EmotionItem(
            title: "Bingung",
            img: AssetName.Img.emoConfuse,
            color: .teal,
            locked: true
        ),
        EmotionItem(
            title: "Penasaran",
            img: AssetName.Img.emoExcited,
            color: .pink,
            locked: true
        )
    ]
}
