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
    let flipTitle: String?
    let desc: String?

    init(
        id: String,
        title: String,
        flipTitle: String? = nil,
        img: String?,
        shape: StickerShape,
        desc: String? = nil
    ) {
        self.id = id
        self.title = title
        self.flipTitle = flipTitle
        self.img = img
        self.shape = shape
        self.desc = desc
    }

    var unlocked: Bool {
        img != nil
    }
}
