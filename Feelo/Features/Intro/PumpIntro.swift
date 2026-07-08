import SwiftUI

struct PumpIntro: View {
    @Environment(AppNav.self) private var nav

    @State private var vm = PumpIntroVM()
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

                GifView(name: vm.bgGif)
                    .id(vm.bgGif)
                    .frame(width: geo.size.width, height: bgH)
                    .offset(y: bgOffset)
                    .ignoresSafeArea()

                ballInBushLayer
                characterLayer(bgH: bgH, screenSize: geo.size)
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
    private var ballInBushLayer: some View {
        if vm.step == .two {
            StageSprite(
                source: .image,
                name: AssetName.Img.ballBush,
                spec: SpriteSpec(
                    size: .widthFromScreen(AppConst.Stage.bushBallW),
                    place: .positioned(
                        x: AppConst.Stage.bushBallX,
                        y: AppConst.Stage.bushBallY
                    )
                )
            )
        }
    }

    private func characterLayer(bgH: CGFloat, screenSize: CGSize) -> some View {
        let isAction = vm.charGif == AssetName.Gif.pump3
        let charSize = bgH * (isAction ? AppConst.Stage.pumpCharAction : AppConst.Stage.pumpCharSmall)
        let yOffset = isAction ? AppConst.Stage.pumpCharActionY : 0.0
        let x = vm.step == .two
            ? AppConst.Stage.pumpSceneTwoLead + charSize / 2
            : screenSize.width / 2

        return GifView(name: vm.charGif, fit: "contain")
            .frame(width: charSize, height: charSize)
            .position(x: x, y: screenSize.height - charSize / 2 + yOffset)
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
