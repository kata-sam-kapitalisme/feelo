import SwiftUI

struct PumpBallIntroView: View {
    @Environment(Router.self) private var router
    @State private var viewModel = PumpBallIntroViewModel()
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
                Color.green.opacity(0.3).ignoresSafeArea()
            }

            // Layer 2: animated environment GIF
          GeometryReader { geo in
              GifImageView(name: viewModel.backgroundGifName)
                      .id(viewModel.backgroundGifName)
                      .ignoresSafeArea()

            if viewModel.currentScene == .two {
                Image("bola_semak")
                    .resizable()
                    .scaledToFit()
                    .frame(width: geo.size.width * 0.48)
                    .position(
                        x: geo.size.width * 0.77,
                        y: geo.size.height * 0.82
                    )
            }
        }
        .ignoresSafeArea()

            // Layer 3: character GIF (changes per scene) — anchored bottom-center
            GeometryReader { geo in
                let isThree = viewModel.characterGifName == "pump3"
                let size = geo.size.height * (isThree ? 0.5 : 0.4)
                GifImageView(name: viewModel.characterGifName, objectFit: "contain")
                    .id(viewModel.characterGifName)
                    .frame(width: size, height: size)
                    .clipped()
                    .offset(y: isThree ? 70 : 0)
                    .padding(.leading, viewModel.currentScene == .two ? 100 : 0)
                    .frame(
                        maxWidth: .infinity,
                        maxHeight: .infinity,
//                        alignment: .bottom
                        alignment: viewModel.currentScene == .two ? .bottomLeading : .bottom)
            }
            .ignoresSafeArea()

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

#Preview(traits: .landscapeLeft) {
    PumpBallIntroView()
        .environment(Router())
}
