import SwiftUI

struct BubbleOutroView: View {
    @Environment(Router.self) private var router
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

            // Layer 3: character GIF — anchored bottom-center
            GeometryReader { geo in
                let size = geo.size.height * 0.4
                GifImageView(name: "1", objectFit: "contain")
                    .frame(width: size, height: size)
                    .clipped()
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
            }
            .ignoresSafeArea()

            // Layer 4: text overlay
            VStack {
                Spacer()
                    .frame(maxHeight: 40)

                VStack(spacing: 4) {
                    Text("Kamu berhasil memecahkan semua gelembung!")
                        .font(.system(size: 33, weight: .bold))
                        .multilineTextAlignment(.center)
                    Text("Kamu sangat bersemangat dan melompat dengan bahagia.")
                        .font(.system(size: 33, weight: .regular))
                        .multilineTextAlignment(.center)
                }
                .padding(.horizontal, 48)
                .padding(.vertical, 24)
                .frame(width: 934, height: 238)
                .background(
                    Image("text-cloud")
                        .resizable()
                        .scaledToFill()
                )

                Spacer()

                Text("Ketuk untuk lanjut")
                    .font(.caption)
                    .foregroundStyle(.white.opacity(0.7))
                    .padding(.bottom, 16)
            }
            .padding(32)
        }
        .onAppear {
            speech.speak("Kamu berhasil memecahkan semua gelembung! Kamu sangat bersemangat dan melompat dengan bahagia.")
        }
        .onDisappear {
            speech.stop()
        }
        .onTapGesture {
            router.currentScreen = .badge
        }
    }
}

#Preview {
    let router = Router()
    router.selectedScenario = ScenarioRepository.defaultScenario

    return BubbleOutroView()
        .environment(router)
}
