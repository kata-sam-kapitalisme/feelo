import SwiftUI

struct TapHint: View {
    private var windowSafeAreaBottom: CGFloat {
        UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .first?.keyWindow?.safeAreaInsets.bottom ?? 0
    }

    var body: some View {
        ZStack {
            Color.black
                .opacity(0.5)
                .ignoresSafeArea()

            VStack {
                Spacer()

                HStack(spacing: 12) {
                    Spacer()

                    GifView(name: AssetName.Gif.tapNext)
                        .frame(width: 80, height: 80)

                    Text("Ketuk untuk melanjutkan...")
                        .font(AppFont.semi(24))
                        .foregroundStyle(.white)
                }
                .padding(.trailing, 32)
                .padding(.bottom, max(32, windowSafeAreaBottom + 45))
            }
        }
        .ignoresSafeArea()
    }
}
