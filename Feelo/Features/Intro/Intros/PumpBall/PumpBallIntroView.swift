import SwiftUI

struct PumpBallIntroView: View {
    @Environment(Router.self) private var router
    @State private var viewModel = PumpBallIntroViewModel()
    @State private var speech = SpeechManager()

    var body: some View {
        ZStack {
            // Layer 1: static background
            // TODO: swap "pumpball_background" for the real asset name once it exists.
            if let bgImage = UIImage(named: "background") {
                Image(uiImage: bgImage)
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
            } else {
                Color.gray.opacity(0.3).ignoresSafeArea()
            }

            // Layer 2: animated environment GIF
            // TODO: swap for the real environment gif name once it exists.
            GifImageView(name: "Background Pump 2")
                .ignoresSafeArea()

            // Layer 3: character GIF (changes per scene) — anchored bottom-center
            GeometryReader { geo in
                let size = geo.size.height * 0.70
                GifImageView(name: viewModel.characterGifName, objectFit: "contain")
                    .id(viewModel.characterGifName)
                    .frame(width: size, height: size)
                    .clipped()

                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
            }
            .ignoresSafeArea()

            // Layer 4: speech bubble + subtitle
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
        .onTapGesture {
            if viewModel.advance() {
                router.currentScreen = .action
            }
        }
    }
}
