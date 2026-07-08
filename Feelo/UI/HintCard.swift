import SwiftUI

struct HintCard: View {
    let gif: String
    let show: Bool

    var body: some View {
        GifView(
            name: gif,
            fit: "contain"
        )
        .frame(
            width: AppConst.Layout.tutorialSize,
            height: AppConst.Layout.tutorialSize
        )
        .background(.white)
        .clipShape(
            RoundedRectangle(
                cornerRadius: 24,
                style: .continuous
            )
        )
        .overlay {
            RoundedRectangle(
                cornerRadius: 24,
                style: .continuous
            )
            .stroke(
                .white,
                lineWidth: 5
            )
        }
        .shadow(
            color: .black.opacity(0.25),
            radius: 10,
            x: 0,
            y: 6
        )
        .scaleEffect(show ? 1 : 0.6)
        .opacity(show ? 1 : 0)
        .animation(
            .spring(duration: 0.5),
            value: show
        )
    }
}
