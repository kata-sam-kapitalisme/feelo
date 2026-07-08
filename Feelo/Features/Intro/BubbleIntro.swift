import SwiftUI

struct BubbleIntro: View {
    @Environment(AppNav.self) private var nav

    @State private var vm = BubbleIntroVM()
    @State private var speech = SpeechSvc()

    var body: some View {
        GeometryReader { geo in
            let scale = min(1.0, min(geo.size.width / AppConst.Ref.w, geo.size.height / AppConst.Ref.h))
            let bgH = geo.size.width * AppConst.Ref.h / AppConst.Ref.w
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

                characterLayer(bgH: bgH, bgOffset: bgOffset, screenSize: geo.size)

                if vm.step == .four {
                    StageSprite(
                        source: .gif,
                        name: AssetName.Gif.bubItems,
                        spec: SpriteSpec(
                            size: .squareFromHeight(AppConst.Stage.bubbleItems),
                            place: .aligned(.center)
                        )
                    )
                }

                textLayer(scale: scale)
            }
            .onAppear {
                speech.speak(vm.text)
            }
            .onChange(of: vm.step) { _, _ in
                speech.speak(vm.text)
            }
            .onDisappear {
                speech.stop()
            }
            .tapSound {
                if vm.next() {
                    nav.screen = .game
                }
            }
        }
        .ignoresSafeArea()
    }

    @ViewBuilder
    private func characterLayer(bgH: CGFloat, bgOffset: CGFloat, screenSize: CGSize) -> some View {
        if vm.gif == AssetName.Gif.bubTut {
            let tutW = screenSize.width * 0.85
            let tutH = bgH * 0.85
            GifView(name: vm.gif)
                .frame(width: tutW, height: tutH)
                .position(x: screenSize.width / 2, y: screenSize.height - tutH / 2)
        } else {
            let charSize = bgH * AppConst.Stage.bubbleCharSmall
            GifView(name: vm.gif, fit: "contain")
                .frame(width: charSize, height: charSize)
                .position(x: screenSize.width / 2, y: screenSize.height - charSize / 2)
        }
    }

    private func textLayer(scale: CGFloat) -> some View {
        VStack {
            Spacer()
                .frame(maxHeight: 40)

            CloudBubble(text: vm.text, scale: scale)
                .animation(
                    .easeInOut(duration: 0.3),
                    value: vm.step
                )

            Spacer()

            TapHint()
        }
        .padding(32 * scale)
    }
}
