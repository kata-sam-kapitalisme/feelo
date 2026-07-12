import AVFoundation
import Combine
import SwiftUI

struct PreparationOverlay: View {
    let cameraFrames: PassthroughSubject<CMSampleBuffer, Never>
    let onFinish: () -> Void

    @State private var countdown = 5
    @State private var bodySvc = BodySvc()
    @State private var screenSize: CGSize = .zero
    @State private var guideRect: CGRect = .zero

    var statusText: String {
        guard screenSize != .zero else { return "Sesuaikan posisimu..." }
        if bodySvc.isBodyInRect(guideRect, screenSize: screenSize) { return "Posisi pas! Siap..." }
        if bodySvc.isDetected { return "Mundur sedikit!" }
        return "Sesuaikan posisimu..."
    }

    var body: some View {
        GeometryReader { geo in
            let scale = max(0.6, min(geo.size.width / AppConst.Ref.w, geo.size.height / AppConst.Ref.h))
            let cardW = min(geo.size.width * 0.82, 960 * scale)

            ZStack {
                Color.black.opacity(0.60)
                    .ignoresSafeArea()
                    .contentShape(Rectangle())

                // VStack(spacing: 24 * scale) {
                //     VStack(spacing: 12 * scale) {
                //         Text("Persiapan!")
                //             .font(AppFont.semi(64 * scale))
                //             .foregroundStyle(.black)
                //             .multilineTextAlignment(.center)
                //             .minimumScaleFactor(0.6)

                //         Text("Mundur 3 langkah ke belakang, yuk!")
                //             .font(AppFont.semi(36 * scale))
                //             .foregroundStyle(.black)
                //             .multilineTextAlignment(.center)
                //             .minimumScaleFactor(0.6)
                //     }
                // }
                // .padding(.horizontal, 64 * scale)
                // .padding(.vertical, 48 * scale)
                // .frame(maxWidth: cardW)
                // .background {
                //     RoundedRectangle(
                //         cornerRadius: 48 * scale,
                //         style: .continuous
                //     )
                //     .fill(Color(red: 245 / 255, green: 245 / 255, blue: 245 / 255))
                //     .shadow(
                //         color: .black.opacity(0.20),
                //         radius: 24 * scale,
                //         x: 0,
                //         y: 12 * scale
                //     )
                // }
                // .position(
                //     x: geo.size.width / 2,
                //     y: geo.size.height / 2
                // )

                VStack {
                    Spacer()

                    Image(AssetName.Img.activityGuide)
                        .resizable()
                        .scaledToFit()
                        .frame(height: geo.size.height * 0.65)
                        .padding(.bottom, max(20, 32 * scale))
                }

                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Text(statusText)
                            .font(AppFont.medium(36 * scale))
                            .foregroundStyle(.white)
                            .multilineTextAlignment(.trailing)
                            .minimumScaleFactor(0.7)
                    }
                    .padding(.trailing, max(24, 40 * scale))
                    .bottomSafePadding()
                }
            }
            .onAppear {
                updateGuideRect(geo.size)
            }
            .onChange(of: geo.size) { _, newSize in
                updateGuideRect(newSize)
            }
        }
        .ignoresSafeArea()
        .task {
            bodySvc.bind(cameraFrames)

            while screenSize == .zero {
                try? await Task.sleep(nanoseconds: 50_000_000)
            }

            try? await Task.sleep(nanoseconds: 4_800_000_000)

            var current = 5
            while current >= 1 {
                while !bodySvc.isBodyInRect(guideRect, screenSize: screenSize) {
                    try? await Task.sleep(nanoseconds: 100_000_000)
                }
                countdown = current
                SoundSvc.shared.click()
                try? await Task.sleep(nanoseconds: 1_000_000_000)
                current -= 1
            }
            onFinish()
        }
    }

    private func updateGuideRect(_ size: CGSize) {
        let scale = max(0.6, min(size.width / AppConst.Ref.w, size.height / AppConst.Ref.h))
        let padding = max(20.0, 32.0 * scale)
        let imgH = size.height * 0.65
        let imgW = imgH * (544.0 / 989.0)
        guideRect = CGRect(
            x: (size.width - imgW) / 2,
            y: size.height - imgH - padding,
            width: imgW,
            height: imgH
        )
        screenSize = size
    }
}
