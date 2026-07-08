import SwiftUI

struct StickerTitle: View {
    let text: String

    var body: some View {
        RoundedRectangle(
            cornerRadius: AppConst.Sticker.titleCorner,
            style: .continuous
        )
        .fill(AppColor.header)
        .overlay {
            Text(text)
                .font(AppFont.bold(72))
                .foregroundStyle(.black)
                .lineLimit(1)
                .minimumScaleFactor(0.75)
                .padding(.horizontal, 56)
        }
    }
}
