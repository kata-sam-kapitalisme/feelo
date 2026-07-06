import Observation

@Observable
final class StickerPresenter {
    private let data: StickerData
    private(set) var stickers: [Sticker] = []

    init(data: StickerData = StickerData()) {
        self.data = data
        load()
    }

    func load() {
        stickers = data.getStickers()
    }
}
