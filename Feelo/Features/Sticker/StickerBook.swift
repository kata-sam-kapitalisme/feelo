import SwiftUI

struct StickerBook: View {
    let items: [Sticker]

    var body: some View {
        ZStack {
            ForEach(
                AppConst.Sticker.ringYs,
                id: \.self
            ) { y in
                RingView()
                    .frame(
                        width: AppConst.Sticker.ringW,
                        height: AppConst.Sticker.ringH
                    )
                    .position(
                        x: AppConst.Sticker.ringX,
                        y: y
                    )
            }

            RoundedRectangle(
                cornerRadius: AppConst.Sticker.bookCorner,
                style: .continuous
            )
            .fill(AppColor.page)
            .frame(
                width: AppConst.Sticker.bookW,
                height: AppConst.Sticker.bookH
            )
            .position(
                x: AppConst.Sticker.bookX,
                y: AppConst.Sticker.bookY
            )

            StickerGrid(items: items)
                .frame(
                    width: AppConst.Sticker.gridW,
                    height: AppConst.Sticker.gridH
                )
                .position(
                    x: AppConst.Sticker.gridX,
                    y: AppConst.Sticker.gridY
                )
        }
    }
}

private struct RingView: View {
    var body: some View {
        Ellipse()
            .stroke(
                Color(
                    red: 46 / 255,
                    green: 125 / 255,
                    blue: 38 / 255
                ),
                lineWidth: AppConst.Sticker.ringLine
            )
    }
}
