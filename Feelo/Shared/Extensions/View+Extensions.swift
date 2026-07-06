import SwiftUI

extension View {
    func cardStyle() -> some View {
        self
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .shadow(color: .black.opacity(0.08), radius: 8, x: 0, y: 4)
    }

    func onTapWithSound(perform action: @escaping () -> Void) -> some View {
        self.onTapGesture {
            SoundManager.shared.playClick()
            action()
        }
    }
}
