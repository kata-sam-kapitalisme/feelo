import SwiftUI

struct StickerView: View {
    @Environment(Router.self) private var router
    @State private var presenter = StickerPresenter()

    var body: some View {
        GeometryReader { geo in
            let scale = min(
                geo.size.width / StickerTheme.canvas.width,
                geo.size.height / StickerTheme.canvas.height
            )

            let canvasW = StickerTheme.canvas.width * scale
            let canvasH = StickerTheme.canvas.height * scale
            let left = (geo.size.width - canvasW) / 2
            let top = (geo.size.height - canvasH) / 2

            ZStack {
                StickerTheme.bg
                    .ignoresSafeArea()

                ZStack {
                    StickerBook(stickers: presenter.stickers)

                    StickerTitleBar(text: "Koleksi Stiker")
                        .frame(width: 874, height: 131)
                        .position(x: 703, y: 159.5)
                }
                .frame(width: StickerTheme.canvas.width, height: StickerTheme.canvas.height)
                .scaleEffect(scale)
                .frame(width: canvasW, height: canvasH)
                .position(x: geo.size.width / 2, y: geo.size.height / 2)

                StickerBackBtn {
                    router.goHome()
                }
                .frame(
                    width: max(56, 80 * scale),
                    height: max(56, 80 * scale)
                )
                .position(
                    x: left + (120 * scale),
                    y: top + (100 * scale)
                )
                .zIndex(10)
            }
            .frame(width: geo.size.width, height: geo.size.height)
        }
        .ignoresSafeArea()
    }
}

#Preview {
    StickerView()
        .environment(Router())
}
