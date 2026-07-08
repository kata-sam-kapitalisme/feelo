import SwiftUI

struct BubbleIntro: View {
    @Environment(AppNav.self) private var nav

    @State private var vm = BubbleIntroVM()
    @State private var speech = SpeechSvc()
    @State private var tapInstruction = true

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
            guard !tapInstruction else { return }
            speech.speak(vm.text)
        }
        .onChange(of: vm.step) { _, _ in
            guard !tapInstruction else { return }
            speech.speak(vm.text)
        }
        .onDisappear {
            speech.stop()
        }
        .tapSound {
            if tapInstruction {
                tapInstruction = false
                speech.speak(vm.text)
                return
            }
            
            guard vm.step != .five else { return }
            
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
        }
        .padding(32)
    }
    
}

#Preview(traits: .landscapeLeft) {
    BubbleIntro()
        .environment(AppNav())
}
