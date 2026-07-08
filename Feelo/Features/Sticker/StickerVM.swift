import Observation

@Observable
final class StickerVM {
    private let repo: StickerRepo
    private(set) var items: [Sticker] = []

    init(repo: StickerRepo = StickerRepo()) {
        self.repo = repo
        load()
    }

    func load() {
        items = repo.all()
    }
}
