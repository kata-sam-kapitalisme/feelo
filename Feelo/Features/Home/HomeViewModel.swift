import SwiftUI
import Observation

struct PlaceModel: Identifiable {
    let id = UUID()
    let title: String
    let imageName: String   // TODO: wire to real asset
    let isLocked: Bool
}

struct EmotionModel: Identifiable {
    let id = UUID()
    let title: String
    let imageName: String   // TODO: wire to real asset
    let borderColor: Color
    let isLocked: Bool
}

@Observable
final class HomeViewModel {
    let places: [PlaceModel] = [
        PlaceModel(title: "Taman Bermain", imageName: "place_taman",   isLocked: false),
        PlaceModel(title: "Sekolah",       imageName: "place_sekolah", isLocked: true),
        PlaceModel(title: "Rumah",         imageName: "place_rumah",   isLocked: true),
        PlaceModel(title: "Pantai",        imageName: "place_pantai",  isLocked: true),
        PlaceModel(title: "Kebun",         imageName: "place_kebun",   isLocked: true),
    ]

    let emotions: [EmotionModel] = [
        EmotionModel(title: "Bersemangat", imageName: "emo_bersemangat", borderColor: .yellow,                                  isLocked: false),
        EmotionModel(title: "Kecewa",      imageName: "emo_kecewa",      borderColor: Color(red: 0.55, green: 0.2, blue: 0.75), isLocked: false),
        EmotionModel(title: "Takut",       imageName: "emo_sedih",       borderColor: .indigo,                                  isLocked: true),
        EmotionModel(title: "Bangga",      imageName: "emo_senang",      borderColor: .orange,                                  isLocked: true),
        EmotionModel(title: "Bingung",     imageName: "emo_marah",       borderColor: .teal,                                    isLocked: true),
        EmotionModel(title: "Penasaran",   imageName: "emo_bersemangat", borderColor: .pink,                                    isLocked: true),
    ]
}
