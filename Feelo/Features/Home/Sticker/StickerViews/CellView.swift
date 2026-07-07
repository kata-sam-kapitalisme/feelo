import SwiftUI

struct StickerCell: View {
    let sticker: Sticker

    var body: some View {
        GeometryReader { geo in
            ZStack {
                if let img = sticker.img {
                    StickerAnimView(
                        img: img,
                        width: imgW(img, geo.size),
                        height: imgH(img, geo.size),
                        delay: animDelay(img)
                    )
                    .position(x: geo.size.width / 2, y: geo.size.height * 0.38)
                } else {
                    LockedSticker(shape: sticker.lockShape)
                        .frame(
                            width: lockW(sticker.lockShape, geo.size),
                            height: lockH(sticker.lockShape, geo.size)
                        )
                        .position(x: geo.size.width / 2, y: geo.size.height * 0.47)
                }

                Text(sticker.title)
                    .font(StickerTheme.bold(34))
                    .foregroundStyle(StickerTheme.text)
                    .lineLimit(1)
                    .minimumScaleFactor(0.72)
                    .multilineTextAlignment(.center)
                    .frame(width: geo.size.width * 0.86)
                    .position(x: geo.size.width / 2, y: geo.size.height * 0.86)
            }
        }
    }

    private func imgW(_ img: String, _ size: CGSize) -> CGFloat {
        img == "sticker_basket" ? size.width * 0.66 : size.width * 0.78
    }

    private func imgH(_ img: String, _ size: CGSize) -> CGFloat {
        img == "sticker_basket" ? size.height * 0.58 : size.height * 0.56
    }

    private func lockW(_ shape: LockShape, _ size: CGSize) -> CGFloat {
        switch shape {
        case .triangle, .downTriangle:
            return size.width * 0.52
        case .circle:
            return size.width * 0.52
        case .star:
            return size.width * 0.60
        case .square:
            return size.width * 0.55
        case .diamond:
            return size.width * 0.54
        }
    }

    private func lockH(_ shape: LockShape, _ size: CGSize) -> CGFloat {
        switch shape {
        case .triangle, .downTriangle:
            return size.height * 0.55
        case .circle:
            return size.height * 0.55
        case .star:
            return size.height * 0.61
        case .square:
            return size.height * 0.49
        case .diamond:
            return size.height * 0.56
        }
    }

    private func animDelay(_ img: String) -> Double {
        switch img {
        case "sticker_basket":
            return 0.35
        default:
            return 0
        }
    }
}
