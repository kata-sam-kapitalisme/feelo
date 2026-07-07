import SwiftUI

struct BadgeView: View {
    @Environment(Router.self) private var router
    
    var body: some View {
        ZStack {
            Image("bg_waves")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            VStack(spacing: 32) {
                // Badge graphic placeholder
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [.yellow, .orange],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 160, height: 160)
                    .overlay {
                        VStack(spacing: 4) {
                            Text("⭐️")
                                .font(.system(size: 56))
                            Text(router.selectedScenario?.badgeTitle ?? "Gelembung Ceria")
                                .font(.caption)
                                .fontWeight(.bold)
                                .foregroundStyle(.white)
                                .multilineTextAlignment(.center)
                        }
                    }
                    .shadow(color: .orange.opacity(0.4), radius: 20, x: 0, y: 10)
                
                VStack(spacing: 8) {
                    Text("Selamat!")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    Text("Kamu mendapatkan lencana baru.")
                        .font(.title3)
                        .foregroundStyle(.secondary)
                }
                
                Button {
                    SoundManager.shared.playClick()
                    router.currentScreen = .home
                } label: {
                    Text("Kembali ke Beranda")
                        .font(.headline)
                        .foregroundStyle(.white)
                        .padding(.horizontal, 32)
                        .padding(.vertical, 14)
                        .background(Color.blue, in: Capsule())
                }
                .buttonStyle(.plain)
            }
            .padding(40)
        }
        .onAppear {
            SoundManager.shared.playBGM()
        }
    }
}
