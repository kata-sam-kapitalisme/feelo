import SwiftUI

struct CloudBubble: View {
    let title: String?
    let text: String
    let important: Bool

    init(
        text: String,
        important: Bool = false
    ) {
        self.title = nil
        self.text = text
        self.important = important
    }

    init(
        title: String,
        text: String,
        important: Bool = true
    ) {
        self.title = title
        self.text = text
        self.important = important
    }

    var body: some View {
        VStack(spacing: 4) {
            if let title {
                Text(title)
                    .font(
                        important
                        ? AppFont.bold(33)
                        : AppFont.semi(33)
                    )
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.black)
            }

            Text(text)
                .font(AppFont.semi(33))
                .multilineTextAlignment(.center)
                .foregroundStyle(.black)
        }
        .padding(.horizontal, 48)
        .padding(.vertical, 24)
        .frame(
            width: AppConst.Layout.cloudW,
            height: AppConst.Layout.cloudH
        )
        .background {
            Image(AssetName.Img.cloudText)
                .resizable()
                .scaledToFill()
        }
    }
}

// Klau klian mau bold important texts/parts tinggal set important: true
