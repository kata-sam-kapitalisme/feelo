import SwiftUI

struct Bubble: Identifiable {
    let id: UUID
    var position: CGPoint
    let radius: CGFloat
    let color: Color
    var isPopped: Bool = false
}
