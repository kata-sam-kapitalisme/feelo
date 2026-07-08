enum StickerShape: Equatable {
    case tri
    case circle
    case star
    case downTri
    case square
    case diamond
}

struct Sticker: Identifiable, Equatable {
    let id: String
    let title: String
    let img: String?
    let shape: StickerShape

    var unlocked: Bool {
        img != nil
    }
}
