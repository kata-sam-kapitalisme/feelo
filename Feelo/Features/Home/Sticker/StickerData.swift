import Foundation

struct StickerData {
    func getStickers() -> [Sticker] {
        [
            Sticker(
                id: "bubble-pop",
                title: "Bubble Pop!",
                img: "sticker_bubble",
                lockShape: .triangle
            ),
            Sticker(
                id: "pom-pom-pa",
                title: "Pom-pom-pa!",
                img: "sticker_basket",
                lockShape: .triangle
            ),
            Sticker(
                id: "lock-triangle",
                title: "???",
                img: nil,
                lockShape: .triangle
            ),
            Sticker(
                id: "lock-star",
                title: "???",
                img: nil,
                lockShape: .star
            ),
            Sticker(
                id: "lock-down-triangle",
                title: "???",
                img: nil,
                lockShape: .downTriangle
            ),
            Sticker(
                id: "lock-square",
                title: "???",
                img: nil,
                lockShape: .square
            )
        ]
    }
}
