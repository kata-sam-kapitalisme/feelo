import SwiftUI

struct StickerCell: View {
    let item: Sticker

    var body: some View {
        GeometryReader { geo in
            ZStack {
                if let img = item.img {
                    StickerAnim(
                        img: img,
                        width: imageW(img, geo.size),
                        height: imageH(img, geo.size),
                        delay: animDelay(img)
                    )
                    .position(
                        x: geo.size.width / 2,
                        y: geo.size.height * AppConst.Sticker.stickerY
                    )
                } else {
                    LockedSticker(shape: item.shape)
                        .frame(
                            width: lockW(item.shape, geo.size),
                            height: lockH(item.shape, geo.size)
                        )
                        .position(
                            x: geo.size.width / 2,
                            y: geo.size.height * AppConst.Sticker.lockY
                        )
                }

                Text(item.title)
                    .font(AppFont.bold(AppConst.Sticker.cellTitleFont))
                    .foregroundStyle(AppColor.textMain)
                    .lineLimit(1)
                    .minimumScaleFactor(0.72)
                    .multilineTextAlignment(.center)
                    .frame(width: geo.size.width * AppConst.Sticker.cellTitleW)
                    .position(
                        x: geo.size.width / 2,
                        y: geo.size.height * AppConst.Sticker.cellTitleY
                    )
            }
        }
    }

    private func imageW(
        _ img: String,
        _ size: CGSize
    ) -> CGFloat {
        img == AssetName.Img.stBasket
        ? size.width * AppConst.Sticker.basketStickerW
        : size.width * AppConst.Sticker.bubbleStickerW
    }

    private func imageH(
        _ img: String,
        _ size: CGSize
    ) -> CGFloat {
        img == AssetName.Img.stBasket
        ? size.height * AppConst.Sticker.basketStickerH
        : size.height * AppConst.Sticker.bubbleStickerH
    }

    private func lockW(
        _ shape: StickerShape,
        _ size: CGSize
    ) -> CGFloat {
        switch shape {
        case .tri, .downTri:
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

    private func lockH(
        _ shape: StickerShape,
        _ size: CGSize
    ) -> CGFloat {
        switch shape {
        case .tri, .downTri:
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
        case AssetName.Img.stBasket:
            return 0.35

        default:
            return 0
        }
    }
}

private struct LockedSticker: View {
    let shape: StickerShape

    var body: some View {
        GeometryReader { geo in
            ZStack {
                bodyShape

                Text("?")
                    .font(AppFont.bold(markSize(geo.size)))
                    .foregroundStyle(AppColor.markGrey)
                    .offset(
                        y: markY(
                            shape,
                            geo.size
                        )
                    )
            }
        }
    }

    @ViewBuilder
    private var bodyShape: some View {
        switch shape {
        case .tri:
            Tri()
                .fill(AppColor.lockGrey)

        case .circle:
            Circle()
                .fill(AppColor.lockGrey)

        case .star:
            Star()
                .fill(AppColor.lockGrey)

        case .downTri:
            DownTri()
                .fill(AppColor.lockGrey)

        case .square:
            RoundedRectangle(
                cornerRadius: 40,
                style: .continuous
            )
            .fill(AppColor.lockGrey)

        case .diamond:
            Diamond()
                .fill(AppColor.lockGrey)
        }
    }

    private func markSize(_ size: CGSize) -> CGFloat {
        min(
            size.width,
            size.height
        ) * AppConst.Sticker.lockMarkRatio
    }

    private func markY(
        _ shape: StickerShape,
        _ size: CGSize
    ) -> CGFloat {
        switch shape {
        case .tri:
            return size.height * 0.05

        case .downTri:
            return -size.height * 0.03

        case .star:
            return size.height * 0.03

        case .circle, .square, .diamond:
            return 0
        }
    }
}
