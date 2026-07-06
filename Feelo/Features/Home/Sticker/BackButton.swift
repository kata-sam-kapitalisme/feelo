import SwiftUI

struct StickerBackBtn: View {
    let tap: () -> Void

    var body: some View {
        Button {
            SoundManager.shared.playClick()
            tap()
        } label: {
            ZStack {
                Circle()
                    .fill(.white)

                Image(systemName: "chevron.left")
                    .font(.system(size: 34, weight: .bold))
                    .foregroundStyle(.black)
                    .offset(x: -2)
            }
            .contentShape(Circle())
        }
        .buttonStyle(.plain)
        .accessibilityLabel("Back to Home")
    }
}
