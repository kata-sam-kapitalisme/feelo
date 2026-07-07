import SwiftUI

struct BubbleOutroView: View {
    @Environment(Router.self) private var router
    @State private var speech = SpeechManager()

    var body: some View {
        ZStack {
            if let bgImage = UIImage(named: "background") {
                Image(uiImage: bgImage)
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
            } else {
                Color.green.opacity(0.3)
                    .ignoresSafeArea()
            }

            GifImageView(name: "Background Bubble")
                .ignoresSafeArea()

            GeometryReader { geo in
                let size = geo.size.height * 0.4

                GifImageView(name: "1", objectFit: "contain")
                    .frame(width: size, height: size)
                    .clipped()
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
            }
            .ignoresSafeArea()

            VStack {
                Spacer()
                    .frame(maxHeight: 40)

                VStack(spacing: 4) {
                    Text("Kamu berhasil memecahkan semua gelembung!")
                        .font(AppFont.bold(33))
                        .multilineTextAlignment(.center)

                    Text("Kamu sangat bersemangat dan melompat dengan bahagia.")
                        .font(AppFont.semiBold(33))
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
                    .font(AppFont.semiBold(18))
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
        .onTapWithSound {
            router.showCompletion()
        }
    }
}

#Preview {
    let router = Router()
    router.selectedScenario = ScenarioRepository.defaultScenario

    return BubbleOutroView()
        .environment(router)
}
