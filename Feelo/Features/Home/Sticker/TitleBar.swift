import SwiftUI

struct StickerTitleBar: View {
    let text: String

    var body: some View {
        RoundedRectangle(cornerRadius: 40, style: .continuous)
            .fill(StickerTheme.header)
            .overlay {
                Text(text)
                    .font(StickerTheme.bold(72))
                    .foregroundStyle(.black)
                    .lineLimit(1)
                    .minimumScaleFactor(0.75)
                    .padding(.horizontal, 56)
            }
    }
}
