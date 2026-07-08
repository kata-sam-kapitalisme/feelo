import SwiftUI

struct Bubble: Identifiable {
    let id: UUID
    var position: CGPoint
    let radius: CGFloat
    let color: Color
    var popped: Bool = false
    var poppedAt: Date?
    let createdAt: Date
    var velocity: CGPoint

    func currentRadius(growTime: Double = 0.4) -> CGFloat {
        guard !popped else {
            return radius
        }

        let time = min(
            1,
            Date().timeIntervalSince(createdAt) / growTime
        )

        let eased = 1 - pow(1 - time, 3)

        return radius * CGFloat(eased)
    }
}
