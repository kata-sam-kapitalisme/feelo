import SwiftUI

struct TapHint: View {
    var body: some View {
        ZStack {
            Color.black
                .opacity(0.5)
                .ignoresSafeArea()

            VStack {
                Spacer()

                HStack(spacing: 8) {
                    Spacer()

                    GifView(name: AssetName.Gif.tapNext, fit: "contain")
                        .frame(width: 44, height: 44)

                    Text("Ketuk untuk melanjutkan...")
                        .font(AppFont.semi(24))
                        .foregroundStyle(.white)
                        .fixedSize()
                }
                .padding(.trailing, 32)
                .bottomSafePadding()
            }
        }
        .ignoresSafeArea()
    }
}
