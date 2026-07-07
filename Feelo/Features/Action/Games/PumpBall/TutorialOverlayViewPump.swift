import SwiftUI

struct TutorialOverlayViewPump: View {
    var isVisible: Bool

    private let cardSize: CGFloat = 300

    var body: some View {
        GifImageView(name: "4-2", objectFit: "contain")
            .frame(width: cardSize, height: cardSize)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .stroke(Color.white, lineWidth: 5)
            )
            .shadow(color: .black.opacity(0.25), radius: 10, x: 0, y: 6)
            .scaleEffect(isVisible ? 1 : 0.6)
            .opacity(isVisible ? 1 : 0)
            .animation(.spring(duration: 0.5), value: isVisible)
    }
}
