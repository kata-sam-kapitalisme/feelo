import SwiftUI

struct TapHint: View {
    let text: String

    init(_ text: String = "Ketuk untuk lanjut") {
        self.text = text
    }

    var body: some View {
        Text(text)
            .font(AppFont.semi(18))
            .foregroundStyle(.white.opacity(0.7))
            .padding(.bottom, 16)
    }
}
