struct StickerRepo {
    func all() -> [Sticker] {
        [
            level(
                id: "pecahkan-gelembung",
                title: "Bubble Pop!",
                shape: .tri
            ),
            level(
                id: "pompa-bola",
                title: "Pom-pom-pa!",
                shape: .circle
            ),
            Sticker(
                id: "future-star",
                title: "???",
                img: nil,
                shape: .star
            ),
            Sticker(
                id: "future-down-tri",
                title: "???",
                img: nil,
                shape: .downTri
            ),
            Sticker(
                id: "future-square",
                title: "???",
                img: nil,
                shape: .square
            ),
            Sticker(
                id: "future-diamond",
                title: "???",
                img: nil,
                shape: .diamond
            )
        ]
    }

    private func level(
        id: String,
        title: String,
        shape: StickerShape
    ) -> Sticker {
        guard
            let item = ScenarioRepo.item(id),
            ProgressSvc.isDone(id)
        else {
            return Sticker(
                id: id,
                title: "???",
                img: nil,
                shape: shape
            )
        }

        return Sticker(
            id: id,
            title: title,
            img: item.badgeImg,
            shape: shape
        )
    }
}
