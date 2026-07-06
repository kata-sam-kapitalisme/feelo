import SwiftUI
import UIKit

@Observable
final class PumpGameEngine {
    private(set) var pumpCount: Int = 0
    let requiredPumps: Int = 5
    private(set) var isGameFinished: Bool = false

    private(set) var isHandsUp: Bool = false
    private var pumpState: PumpState = .down
    private enum PumpState { case up, down }

    var inflationProgress: Double {
        min(Double(pumpCount) / Double(requiredPumps), 1.0)
    }

    /// Called each frame with normalized Vision wrist coordinates (Y: 0=bottom, 1=top).
    func processWrists(_ points: [CGPoint]) {
        guard !isGameFinished, !points.isEmpty else { return }
        let avgY = points.map(\.y).reduce(0, +) / CGFloat(points.count)

        if avgY > 0.6 {
            pumpState = .up
            isHandsUp = true
        } else if avgY < 0.4, pumpState == .up {
            pumpState = .down
            isHandsUp = false
            registerPump()
        } else if avgY < 0.4 {
            isHandsUp = false
        }
    }

    func registerPump() {
        guard !isGameFinished else { return }
        pumpCount = min(pumpCount + 1, requiredPumps)
        UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
        if pumpCount >= requiredPumps {
            isGameFinished = true
        }
    }
}
