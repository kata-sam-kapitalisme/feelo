import SwiftUI

struct BubbleIntroView: View {
    @Environment(Router.self) private var router
    @State private var viewModel = BubbleIntroViewModel()

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
            GeometryReader { geo in
                let isThree = viewModel.characterGifName == "3"
                let size = geo.size.height * (isThree ? 0.85 : 0.4)
                GifImageView(name: viewModel.characterGifName, objectFit: "contain")
                    .id(viewModel.characterGifName)
                    .frame(width: size, height: size)
                    .clipped()
                    .offset(y: isThree ? 80 : 0)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
            }
            .ignoresSafeArea()

            // Layer 4: speech bubble + subtitle
            VStack {
                Text(viewModel.subtitle)
                    .font(.title3)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
                    .padding(.vertical, 20)
                    .frame(maxWidth: 560)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(.white)
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(.gray.opacity(0.4), lineWidth: 2)
                            )
                            .shadow(radius: 8)
                    )
                    .animation(.easeInOut(duration: 0.3), value: viewModel.currentScene)

                Spacer()

                Text("Ketuk untuk lanjut")
                    .font(.caption)
                    .foregroundStyle(.white.opacity(0.7))
                    .padding(.bottom, 16)
            }
            .padding(32)
        }
        .onTapGesture {
            if viewModel.advance() {
                router.currentScreen = .action
            }
        }
    }
}
