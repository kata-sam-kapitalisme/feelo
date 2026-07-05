import SwiftUI

struct OutroView: View {
    @Environment(Router.self) private var router

    var body: some View {
        ZStack {
            Image("bg_waves")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()

            VStack(spacing: 32) {
                // Celebration placeholder
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.purple.opacity(0.5))
                    .frame(width: 240, height: 135)
                    .overlay {
                        VStack(spacing: 8) {
                            Text("🎉")
                                .font(.system(size: 48))
                            Text("Animasi Placeholder")
                                .font(.caption)
                                .foregroundStyle(.white.opacity(0.8))
                        }
                    }

                Text("Luar biasa! Kamu berhasil memecahkan semua gelembung!")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 48)

                Text("Ketuk untuk lanjut")
                    .font(.subheadline)
                    .foregroundStyle(.white.opacity(0.7))
            }
        }
        .onTapGesture {
            router.currentScreen = .badge
        }
    }
}
