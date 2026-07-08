import SwiftUI

struct BubbleOutro: View {
    @Environment(AppNav.self) private var nav
    
    private let text1 = "Kamu berhasil memecahkan semua gelembung!"
    private let text2 = "Kamu sangat bersemangat dan melompat dengan bahagia."

    var body: some View {
        ZStack {
            Image(AssetName.Img.bgSky)
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()

            GifView(name: AssetName.Gif.bubBg)
                .ignoresSafeArea()

            StageSprite(
                source: .gif,
                name: AssetName.Gif.bub1,
                spec: SpriteSpec(
                    size: .squareFromHeight(AppConst.Stage.bubbleCharSmall),
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
            SoundSvc.shared.playAmbient()
            SoundSvc.shared.playVoice(AssetName.Voiceover.bubble_outro)
        }
        .onDisappear {
            SoundSvc.shared.stopVoice()
        }
        .tapSound {
            nav.finishStory()
        }
    }
}
