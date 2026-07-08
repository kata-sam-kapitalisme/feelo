import SwiftUI

struct BubbleIntro: View {
    @Environment(AppNav.self) private var nav

    @State private var vm = BubbleIntroVM()

    var body: some View {
        ZStack {
            Image(AssetName.Img.bgSky)
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()

            GifView(name: AssetName.Gif.bubBg)
                .ignoresSafeArea()

            characterLayer

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

            textLayer
        }
        .onAppear {
            SoundSvc.shared.playAmbient()
            SoundSvc.shared.playVoice(vm.voice)
        }
        .onChange(of: vm.step) { _, _ in
            SoundSvc.shared.playVoice(vm.voice)
        }
        .onDisappear {
            SoundSvc.shared.stopVoice()
        }
        .tapSound {
            if vm.next() {
                nav.screen = .game
            }
        }
    }

    @ViewBuilder
    private var characterLayer: some View {
        if vm.gif == AssetName.Gif.bubTut {
            StageSprite(
                source: .gif,
                name: vm.gif,
                spec: SpriteSpec(
                    size: .squareFromHeight(AppConst.Stage.bubbleTut),
                    place: .aligned(
                        .bottom,
                        y: AppConst.Stage.bubbleTutY
                    )
                )
            )
        } else {
            StageSprite(
                source: .gif,
                name: vm.gif,
                spec: SpriteSpec(
                    size: .squareFromHeight(AppConst.Stage.bubbleCharSmall),
                    place: .aligned(.bottom)
                )
            )
        }
    }

    private var textLayer: some View {
        VStack {
            Spacer()
                .frame(maxHeight: 40)

            CloudBubble(text: vm.text)
                .animation(
                    .easeInOut(duration: 0.3),
                    value: vm.step
                )

            Spacer()

            TapHint()
        }
        .padding(32)
    }
}
