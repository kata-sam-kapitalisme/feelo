import SwiftUI

struct PreparationOverlay: View {
    let onFinish: () -> Void

    @State private var countdown = 5

    var body: some View {
        GeometryReader { geo in
            let scale = max(0.6, min(geo.size.width / AppConst.Ref.w, geo.size.height / AppConst.Ref.h))
            let cardW = min(geo.size.width * 0.82, 960 * scale)

            ZStack {
                Color.black.opacity(0.60)
                    .ignoresSafeArea()
                    .contentShape(Rectangle())

                VStack(spacing: 24 * scale) {
                    Image(AssetName.Img.foot)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 124 * scale)

                    VStack(spacing: 12 * scale) {
                        Text("Persiapan!")
                            .font(AppFont.semi(64 * scale))
                            .foregroundStyle(.black)
                            .multilineTextAlignment(.center)
                            .minimumScaleFactor(0.6)

                        Text("Mundur 3 langkah ke belakang, yuk!")
                            .font(AppFont.semi(36 * scale))
                            .foregroundStyle(.black)
                            .multilineTextAlignment(.center)
                            .minimumScaleFactor(0.6)
                    }
                }
                .padding(.horizontal, 64 * scale)
                .padding(.vertical, 48 * scale)
                .frame(maxWidth: cardW)
                .background {
                    RoundedRectangle(
                        cornerRadius: 48 * scale,
                        style: .continuous
                    )
                    .fill(Color(red: 245 / 255, green: 245 / 255, blue: 245 / 255))
                    .shadow(
                        color: .black.opacity(0.20),
                        radius: 24 * scale,
                        x: 0,
                        y: 12 * scale
                    )
                }
                .position(
                    x: geo.size.width / 2,
                    y: geo.size.height / 2
                )

                VStack {
                    Spacer()

                    HStack {
                        Spacer()

                        Text("Mulai dalam \(countdown)\(String(repeating: " .", count: countdown))")
                            .font(AppFont.medium(36 * scale))
                            .foregroundStyle(.white)
                            .multilineTextAlignment(.center)
                            .minimumScaleFactor(0.7)
                            .padding(.trailing, max(24, 40 * scale))
                            .padding(.bottom, max(20, 36 * scale))
                    }
                }
            }
        }
        .task {
            try? await Task.sleep(nanoseconds: 4_800_000_000)
            
            for i in stride(from: 5, through: 1, by: -1) {
                countdown = i
                SoundSvc.shared.click()
                try? await Task.sleep(nanoseconds: 1_000_000_000)
            }
            onFinish()
        }
    }
}
