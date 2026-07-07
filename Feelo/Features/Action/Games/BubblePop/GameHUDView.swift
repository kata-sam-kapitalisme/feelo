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
