import SwiftUI

struct Bubble: Identifiable {
    let id: UUID
    var position: CGPoint
    let radius: CGFloat
    let color: Color
    var isPopped: Bool = false
    var poppedAt: Date? = nil
    let spawnedAt: Date
    var velocity: CGPoint

    /// Radius after applying the grow-in animation (0 → radius over `growDuration` seconds).
    func currentRadius(growDuration: Double = 0.4) -> CGFloat {
        guard !isPopped else { return radius }
        let t = min(1, Date().timeIntervalSince(spawnedAt) / growDuration)
        // Ease-out: fast start, smooth finish
        let eased = 1 - pow(1 - t, 3)
        return radius * CGFloat(eased)
    }
}
