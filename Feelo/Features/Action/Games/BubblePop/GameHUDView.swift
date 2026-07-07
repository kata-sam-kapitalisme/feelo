import SwiftUI

struct GameHUDView: View {
    let gameEngine: GameEngine
    let scenario: Scenario
    let onExit: (Bool) -> Void

    private let goalScore = 10

    private var shownScore: Int {
        min(gameEngine.score, goalScore)
    }

    private var goalMet: Bool {
        gameEngine.score >= goalScore
    }

    private var gameEnded: Bool {
        gameEngine.isFinished || goalMet
    }

    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                HStack {
                    bubbleCounter

                    Spacer()
                }
                .padding(.horizontal, 18)
                .padding(.top, 18)

                Spacer()
            }

            if gameEnded {
                CelebrationOverlay(
                    score: shownScore,
                    goalMet: goalMet,
                    onExit: {
                        onExit(goalMet)
                    }
                )
                .transition(.opacity.combined(with: .scale))
                .animation(.spring(duration: 0.5), value: gameEnded)
                .zIndex(100)
            }
        }
    }

    private var bubbleCounter: some View {
        HStack(spacing: 10) {
            Image("bubble")
                .resizable()
                .scaledToFit()
                .frame(width: 64, height: 64)

            Text("\(shownScore)/\(goalScore)")
                .font(AppFont.bold(24))
                .foregroundStyle(.white)
                .contentTransition(.numericText())
                .animation(.bouncy, value: shownScore)
                .frame(width: 74, alignment: .leading)
        }
        .padding(.leading, 12)
        .padding(.trailing, 16)
        .padding(.vertical, 8)
        .background(
            Capsule()
                .fill(Color.black.opacity(0.38))
        )
        .overlay {
            Capsule()
                .stroke(.white.opacity(0.22), lineWidth: 1.5)
        }
        .shadow(color: .black.opacity(0.16), radius: 6, x: 0, y: 3)
    }
}
