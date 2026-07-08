import SwiftUI

struct PumpIntro: View {
    @Environment(AppNav.self) private var nav

    @State private var vm = PumpIntroVM()
    @State private var tapInstruction = true

    var body: some View {
        ZStack {
            Image(AssetName.Img.bgSky)
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()

            GifView(name: vm.bgGif)
                .id(vm.bgGif)
                .ignoresSafeArea()

            ballInBushLayer
            characterLayer
            
            if !tapInstruction {
                textLayer
            }
            
            if tapInstruction {
                TapHint()
            }
            
            if vm.step == .five {
                VStack {
                    Spacer()
                    
                    HStack {
                        Spacer()
                        
                        NextButton {
                            nav.screen = .game
                        }
                    }
                    .padding(.trailing, 32)
                    .padding(.bottom, 32)
                }
            }
        }
        .onAppear {
            SoundSvc.shared.playAmbient()
            guard !tapInstruction else { return }
            SoundSvc.shared.playVoice(vm.voice)
        }
        .onChange(of: vm.step) { _, _ in
            guard !tapInstruction else { return }
            SoundSvc.shared.playVoice(vm.voice)
        }
        .onDisappear {
            SoundSvc.shared.stopVoice()
        }
        .tapSound {
            if tapInstruction {
                tapInstruction = false
                SoundSvc.shared.playVoice(vm.voice)
                return
            }
            
            guard vm.step != .five else { return }
            
            if vm.next() {
                nav.screen = .game
            }
        }
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

    private var characterLayer: some View {
        let isAction = vm.charGif == AssetName.Gif.pump3

        let ratio = isAction
            ? AppConst.Stage.pumpCharAction
            : AppConst.Stage.pumpCharSmall

        let y = isAction
            ? AppConst.Stage.pumpCharActionY
            : 0

        let alignment: Alignment = vm.step == .two
            ? .bottomLeading
            : .bottom

        let leading = vm.step == .two
            ? AppConst.Stage.pumpSceneTwoLead
            : 0

        return StageSprite(
            source: .gif,
            name: vm.charGif,
            spec: SpriteSpec(
                size: .squareFromHeight(ratio),
                place: .aligned(
                    alignment,
                    leading: leading,
                    y: y
                )
            )
        )
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

        }
        .padding(32)
    }
}

#Preview(traits: .landscapeLeft) {
    PumpIntro()
        .environment(AppNav())
}
