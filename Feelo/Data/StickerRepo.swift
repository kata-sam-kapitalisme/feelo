struct StickerRepo {
    func all() -> [Sticker] {
        [
            level(
                id: "pecahkan-gelembung",
                title: "Bubble Pop!",
                flipTitle:"Bersemangat",
                shape: .tri,
                desc: "perasaan ketika hati kita merasa sangat gembira, bertenaga, dan tidak sabar untuk melakukan sesuatu yang seru!"
            ),
            level(
                id: "pompa-bola",
                title: "Pom-pom-pa!",
                flipTitle:"Kecewa",
                shape: .circle,
                desc: "perasaan ketika hati kita merasa sangat gembira, bertenaga, dan tidak sabar untuk melakukan sesuatu yang seru!"
            ),
            Sticker(
                id: "future-star",
                title: "???",
                flipTitle: nil,
                img: nil,
                shape: .star,
                desc: nil
            ),
            Sticker(
                id: "future-down-tri",
                title: "???",
                flipTitle: nil,
                img: nil,
                shape: .downTri,
                desc: nil
            ),
            Sticker(
                id: "future-square",
                title: "???",
                flipTitle: nil,
                img: nil,
                shape: .square,
                desc: nil
            ),
            Sticker(
                id: "future-diamond",
                title: "???",
                flipTitle: nil,
                img: nil,
                shape: .diamond,
                desc: nil
            )
        ]
    }

    private func level(
        id: String,
        title: String,
        flipTitle: String,
        shape: StickerShape,
        desc: String
    ) -> Sticker {
        guard
            let item = ScenarioRepo.item(id),
            ProgressSvc.isDone(id)
        else {
            return Sticker(
                id: id,
                title: "???",
                flipTitle: nil,
                img: nil,
                shape: shape,
                desc: nil
            )
        }

        return Sticker(
            id: id,
            title: title,
            flipTitle: flipTitle,
            img: item.badgeImg,
            shape: shape,
            desc: desc
        )
    }
}
