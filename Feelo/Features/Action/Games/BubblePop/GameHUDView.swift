import SwiftUI

struct GameHUDView: View {
    let gameEngine: GameEngine
    let scenario: Scenario
    let onExit: () -> Void

    @State private var showCelebration = false

    private let goalScore = 4
    private var progress: Double {
        guard scenario.gameplayDurationSeconds > 0 else { return 0 }
        return gameEngine.timeRemaining / scenario.gameplayDurationSeconds
    }
    private var isComplete: Bool {
        gameEngine.isFinished || gameEngine.score >= goalScore
    }

    var body: some View {
        ZStack {
            // HUD bar
            VStack(spacing: 0) {
                // Timer progress bar
                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        Rectangle()
                            .fill(Color.white.opacity(0.3))
                        Rectangle()
                            .fill(timerColor)
                            .frame(width: geo.size.width * max(0, progress))
                            .animation(.linear(duration: 0.1), value: progress)
                    }
                }
                .frame(height: 10)

                // Score & timer display
                HStack {
                    // Star counter
                    HStack(spacing: 4) {
                        Image(systemName: "star.fill")
                            .foregroundStyle(.yellow)
                        Text("\(gameEngine.score)")
                            .font(.title2.bold())
                            .foregroundStyle(.white)
                            .contentTransition(.numericText())
                            .animation(.bouncy, value: gameEngine.score)
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(.black.opacity(0.4), in: Capsule())

                    Spacer()

                    // Time remaining
                    Text(timeString)
                        .font(.title3.bold())
                        .foregroundStyle(.white)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(.black.opacity(0.4), in: Capsule())
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
            }
            .background(.ultraThinMaterial.opacity(0.6))

            // Celebration overlay
            if isComplete {
                CelebrationOverlay(
                    score: gameEngine.score,
                    goalMet: gameEngine.score >= goalScore,
                    bubbleColor: scenario.bubbleColor,
                    onReplay: { gameEngine.reset(scenario: scenario) },
                    onExit: onExit
                )
                .transition(.opacity.combined(with: .scale))
                .animation(.spring(duration: 0.5), value: isComplete)
            }
        }
        .onChange(of: isComplete) { _, complete in
            if complete { showCelebration = true }
        }
    }

    private var timerColor: Color {
        progress > 0.5 ? .green : progress > 0.25 ? .yellow : .red
    }

    private var timeString: String {
        let t = Int(gameEngine.timeRemaining)
        return String(format: "%d:%02d", t / 60, t % 60)
    }
}

private struct CelebrationOverlay: View {
    let score: Int
    let goalMet: Bool
    let bubbleColor: Color
    let onReplay: () -> Void
    let onExit: () -> Void

    @State private var scale: CGFloat = 0.5

    var body: some View {
        ZStack {
            Color.black.opacity(0.65).ignoresSafeArea()

            VStack(spacing: 28) {
                Text(goalMet ? "HEBAT!" : "Bagus!")
                    .font(.system(size: 72, weight: .black))
                    .foregroundStyle(goalMet ? .yellow : .white)
                    .shadow(color: .black.opacity(0.4), radius: 6)

                Text(goalMet ? "Kamu luar biasa!" : "Coba lagi yuk!")
                    .font(.title)
                    .foregroundStyle(.white)

                HStack(spacing: 6) {
                    ForEach(0..<max(1, score), id: \.self) { _ in
                        Image(systemName: "star.fill")
                            .font(.title)
                            .foregroundStyle(.yellow)
                    }
                }

                HStack(spacing: 20) {
                    Button(action: {
                        SoundManager.shared.playClick()
                        onReplay()
                    }) {
                        Label("Main Lagi!", systemImage: "arrow.clockwise")
                            .font(.title2.bold())
                            .padding(.horizontal, 28)
                            .padding(.vertical, 14)
                            .background(bubbleColor, in: Capsule())
                            .foregroundStyle(.white)
                    }

                    Button(action: {
                        SoundManager.shared.playClick()
                        onExit()
                    }) {
                        Label("Selesai", systemImage: "house.fill")
                            .font(.title2.bold())
                            .padding(.horizontal, 28)
                            .padding(.vertical, 14)
                            .background(.white.opacity(0.2), in: Capsule())
                            .foregroundStyle(.white)
                    }
                }
            }
            .padding(40)
            .scaleEffect(scale)
            .onAppear {
                withAnimation(.spring(duration: 0.6)) { scale = 1.0 }
            }
        }
    }
}
