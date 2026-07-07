import SwiftUI

struct StickerAnimView: View {
    let img: String
    let width: CGFloat
    let height: CGFloat
    let delay: Double

    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var active = false

    var body: some View {
        Image(img)
            .resizable()
            .scaledToFit()
            .frame(width: width, height: height)
            .scaleEffect(active && !reduceMotion ? 1.035 : 1.0)
            .rotationEffect(.degrees(active && !reduceMotion ? 2.2 : -1.2))
            .offset(y: active && !reduceMotion ? -6 : 4)
            .animation(
                reduceMotion ? nil :
                    .easeInOut(duration: 2.1)
                    .delay(delay)
                    .repeatForever(autoreverses: true),
                value: active
            )
            .onAppear {
                guard !reduceMotion else { return }
                active = true
            }
    }
}
