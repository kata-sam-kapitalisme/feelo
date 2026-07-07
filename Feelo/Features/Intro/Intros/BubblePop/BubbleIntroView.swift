import SwiftUI

struct BubbleIntroView: View {
    @Environment(Router.self) private var router
    @State private var viewModel = BubbleIntroViewModel()
    @State private var speech = SpeechManager()

    var body: some View {
        ZStack {
            // Layer 1: static background
            if let bgImage = UIImage(named: "background") {
                Image(uiImage: bgImage)
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
            } else {
                Color.green.opacity(0.3).ignoresSafeArea()
            }

            // Layer 2: animated environment GIF
            GifImageView(name: "Background Bubble")
                .ignoresSafeArea()

            // Layer 3: character GIF (changes per scene) — anchored bottom-center
                        if viewModel.characterGifName != "4"{
                            GeometryReader { geo in
                                let isThree = viewModel.characterGifName == "3"
                                let size = geo.size.height * (isThree ? 0.85 : 0.4)
                                GifImageView(name: viewModel.characterGifName, objectFit: "contain")
                                    .id(viewModel.characterGifName)
                                    .frame(width: size, height: size)
                                    .clipped()
                                
                                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                            }
                            .ignoresSafeArea()
                        }
                        if viewModel.characterGifName == "4"{
                            GeometryReader { geo in
                                let isThree = viewModel.characterGifName == "4"
                                let size = geo.size.height * (isThree ? 0.95 : 0.4)
                                GifImageView(name: viewModel.characterGifName, objectFit: "contain")
                                    .id(viewModel.characterGifName)
                                    .frame(width: size, height: size)
                                    .clipped()
                                    .offset(y: isThree ? 120 : 32)
                                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                            }
                            .ignoresSafeArea()
                        }

            // Layer 4: bubbles overlay (scene 4 only)
            if viewModel.currentScene == .four {
                GeometryReader { geo in
                    let size = geo.size.height * 0.9
                    GifImageView(name: "bubbles", objectFit: "contain")
                        .frame(width: size, height: size)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                }
                .ignoresSafeArea()
            }

            // Layer 5: speech bubble + subtitle
            VStack {
                Spacer()
                    .frame(maxHeight: 40)

                CloudTextBubble(text: viewModel.subtitle)
                    .animation(.easeInOut(duration: 0.3), value: viewModel.currentScene)

                Spacer()

                Text("Ketuk untuk lanjut")
                    .font(.caption)
                    .foregroundStyle(.white.opacity(0.7))
                    .padding(.bottom, 16)
            }
            .padding(32)
        }
        .onAppear {
            speech.speak(viewModel.subtitle)
        }
        .onChange(of: viewModel.currentScene) { _, _ in
            speech.speak(viewModel.subtitle)
        }
        .onTapWithSound {
            if viewModel.advance() {
                router.currentScreen = .action
            }
        }
    }
}

