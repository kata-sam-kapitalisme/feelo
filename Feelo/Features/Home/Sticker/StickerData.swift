import Foundation

struct StickerData {
    func getStickers() -> [Sticker] {
        [
            levelSticker(
                id: "pecahkan-gelembung",
                unlockedTitle: "Bubble Pop!",
                lockShape: .triangle
            ),
            levelSticker(
                id: "pompa-bola",
                unlockedTitle: "Pom-pom-pa!",
                lockShape: .circle
            ),
            Sticker(
                id: "future-triangle",
                title: "???",
                img: nil,
                lockShape: .star
            ),
            Sticker(
                id: "future-star",
                title: "???",
                img: nil,
                lockShape: .downTriangle
            ),
            Sticker(
                id: "future-square",
                title: "???",
                img: nil,
                lockShape: .square
            ),
            Sticker(
                id: "future-diamond",
                title: "???",
                img: nil,
                lockShape: .diamond
            )
        ]
    }

    private func levelSticker(
        id: String,
        unlockedTitle: String,
        lockShape: LockShape
    ) -> Sticker {
        guard
            let scenario = ScenarioRepository.scenario(for: id),
            LevelProgress.isCleared(id)
        else {
            return Sticker(
                id: id,
                title: "???",
                img: nil,
                lockShape: lockShape
            )
        }

        return Sticker(
            id: id,
            title: unlockedTitle,
            img: scenario.badgeImage,
            lockShape: lockShape
        )
    }
}
