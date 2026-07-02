import SwiftUI
import Observation

struct Bubble: Identifiable {
    let id = UUID()
    /// Normalized position (0–1) relative to screen size
    var normalizedPosition: CGPoint
    var color: Color
    var size: CGFloat
    var isPopped: Bool = false
}

@Observable
final class ActionViewModel {
    var bubbles: [Bubble] = []
    var poppedCount: Int = 0

    private let bubbleColors: [Color] = [
        .blue, .purple, .pink, .cyan, .green, .orange, .yellow
    ]

    func spawnBubbles(in size: CGSize) {
        guard bubbles.isEmpty else { return }
        bubbles = (0..<7).map { index in
            Bubble(
                normalizedPosition: CGPoint(
                    x: CGFloat.random(in: 0.1...0.9),
                    y: CGFloat.random(in: 0.15...0.85)
                ),
                color: bubbleColors[index % bubbleColors.count],
                size: CGFloat.random(in: 60...100)
            )
        }
    }

    func popBubble(id: UUID) {
        guard let index = bubbles.firstIndex(where: { $0.id == id }) else { return }
        bubbles[index].isPopped = true
        poppedCount += 1
    }

    var totalBubbles: Int { bubbles.count }
}
