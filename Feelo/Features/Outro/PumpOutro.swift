import SwiftUI

struct PumpOutro: View {
    @Environment(AppNav.self) private var nav
    @State private var speech = SpeechSvc()

    private let text1 = "Kamu berhasil mengisi bolanya lagi!"
    private let text2 = "Sekarang, kamu bisa bermain bersama lagi."

    var body: some View {
        ZStack {
            Image(AssetName.Img.bgSky)
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()

            GifView(name: AssetName.Gif.pumpBg)
                .ignoresSafeArea()

            StageSprite(
                source: .gif,
                name: AssetName.Gif.pump5,
                spec: SpriteSpec(
                    size: .squareFromHeight(AppConst.Stage.pumpCharSmall),
                    place: .aligned(.bottom)
                )
            )

            VStack {
                Spacer()
                    .frame(maxHeight: 40)

                CloudBubble(
                    title: text1,
                    text: text2,
                    important: true
                )

                Spacer()

                TapHint()
            }
            .padding(32)
        }
        .onAppear {
            speech.speak("\(text1) \(text2)")
        }
        .onDisappear {
            speech.stop()
        }
        .tapSound {
            nav.finishStory()
        }
    }
}
