import SwiftUI

struct CloudBubble: View {
    let title: String?
    let text: String
    let important: Bool
    let scale: CGFloat

    init(
        text: String,
        important: Bool = false,
        scale: CGFloat = 1.0
    ) {
        self.title = nil
        self.text = text
        self.important = important
        self.scale = scale
    }

    init(
        title: String,
        text: String,
        important: Bool = true,
        scale: CGFloat = 1.0
    ) {
        self.title = title
        self.text = text
        self.important = important
        self.scale = scale
    }

    var body: some View {
        VStack(spacing: 4) {
            if let title {
                Text(title)
                    .font(
                        important
                        ? AppFont.bold(33 * scale)
                        : AppFont.semi(33 * scale)
                    )
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.black)
            }

            Text(text)
                .font(AppFont.semi(33 * scale))
                .multilineTextAlignment(.center)
                .foregroundStyle(.black)
        }
        .padding(.horizontal, 48 * scale)
        .padding(.vertical, 24 * scale)
        .frame(
            width: AppConst.Layout.cloudW * scale,
            height: AppConst.Layout.cloudH * scale
        )
        .background {
            Image(AssetName.Img.cloudText)
                .resizable()
                .scaledToFill()
        }
    }
}

// Klau klian mau bold important texts/parts tinggal set important: true
