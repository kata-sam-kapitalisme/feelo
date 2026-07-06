import SwiftUI

struct StickerBook: View {
    let stickers: [Sticker]

    var body: some View {
        ZStack {
            ForEach([286, 441, 596, 751, 906], id: \.self) { y in
                RingView()
                    .frame(width: 100, height: 72)
                    .position(x: 68, y: CGFloat(y))
            }

            RoundedRectangle(cornerRadius: 50, style: .continuous)
                .fill(StickerTheme.page)
                .frame(width: 1310, height: 809)
                .position(x: 703, y: 580.5)

            StickerGrid(stickers: stickers)
                .frame(width: 1124, height: 692)
                .position(x: 703, y: 592)
        }
    }
}

private struct RingView: View {
    var body: some View {
        Ellipse()
            .stroke(
                Color(red: 46 / 255, green: 125 / 255, blue: 38 / 255),
                lineWidth: 10
            )
    }
}
