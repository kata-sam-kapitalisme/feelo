import SwiftUI

struct BubbleOutro: View {
    @Environment(AppNav.self) private var nav
    
    private let text1 = "Kamu berhasil memecahkan semua gelembung!"
    private let text2 = "Kamu sangat bersemangat dan melompat dengan bahagia."

    var body: some View {
        GeometryReader { geo in
            let scale = min(1.0, min(geo.size.width / AppConst.Ref.w, geo.size.height / AppConst.Ref.h))
            let bgH = max(geo.size.height, geo.size.width * AppConst.Ref.h / AppConst.Ref.w)
            let bgOffset = -max(0, bgH - geo.size.height)

            ZStack {
                Image(AssetName.Img.bgSky)
                    .resizable()
                    .frame(width: geo.size.width, height: bgH)
                    .offset(y: bgOffset)
                    .ignoresSafeArea()

                GifView(name: AssetName.Gif.bubBg)
                    .frame(width: geo.size.width, height: bgH)
                    .offset(y: bgOffset)
                    .ignoresSafeArea()

                let charSize = bgH * AppConst.Stage.bubbleCharSmall
                GifView(name: AssetName.Gif.bub1, fit: "contain")
                    .frame(width: charSize, height: charSize)
                    .position(x: geo.size.width / 2, y: geo.size.height - charSize / 2)

                VStack {
                    Spacer()
                        .frame(maxHeight: 40)

                    CloudBubble(
                        title: text1,
                        text: text2,
                        important: true,
                        scale: scale
                    )

                    Spacer()
                }
                .padding(32 * scale)
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
        .ignoresSafeArea()
    }
}

//#Preview(traits: .landscapeLeft) {
//    BubbleOutro()
//        .environment(AppNav())
//}
