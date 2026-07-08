import SwiftUI

struct DoneOverlay: View {
    let score: Int
    let success: Bool
    let action: () -> Void

    @State private var visible = false
    @State private var closed = false
    @State private var confetti = false

    var body: some View {
        ZStack {
            Color.black.opacity(0.14)
                .ignoresSafeArea()
                .contentShape(Rectangle())
                .onTapGesture {
                    close()
                }

            ConfettiView(active: confetti)
                .allowsHitTesting(false)

            VStack(spacing: 14) {
                ZStack {
                    Circle()
                        .fill(.white.opacity(0.90))
                        .frame(
                            width: 76,
                            height: 76
                        )

                    Image(systemName: success ? "checkmark" : "arrow.clockwise")
                        .font(.system(
                            size: 34,
                            weight: .black
                        ))
                        .foregroundStyle(
                            success
                            ? Color(red: 22 / 255, green: 163 / 255, blue: 92 / 255)
                            : .orange
                        )
                }

                VStack(spacing: 6) {
                    Text(success ? "Hebat!" : "Coba Lagi")
                        .font(AppFont.bold(38))
                        .foregroundStyle(.white)

                    Text(success ? "Aktivitas selesai" : "Kamu sudah berusaha")
                        .font(AppFont.semi(22))
                        .foregroundStyle(.white.opacity(0.88))
                }

                Text(success ? "Lanjut cerita..." : "Kembali pilih cerita")
                    .font(AppFont.semi(17))
                    .foregroundStyle(.white.opacity(0.65))
                    .padding(.top, 2)
            }
            .padding(.horizontal, 38)
            .padding(.vertical, 28)
            .background {
                RoundedRectangle(
                    cornerRadius: 34,
                    style: .continuous
                )
                .fill(.white.opacity(0.10))
                .background(
                    .ultraThinMaterial,
                    in: RoundedRectangle(
                        cornerRadius: 34,
                        style: .continuous
                    )
                )
            }
            .overlay {
                RoundedRectangle(
                    cornerRadius: 34,
                    style: .continuous
                )
                .stroke(
                    .white.opacity(0.24),
                    lineWidth: 2
                )
            }
            .shadow(
                color: .black.opacity(0.18),
                radius: 16,
                x: 0,
                y: 8
            )
            .scaleEffect(visible ? 1 : 0.9)
            .opacity(visible ? 1 : 0)
            .animation(
                .spring(
                    response: 0.35,
                    dampingFraction: 0.78
                ),
                value: visible
            )
        }
        .onAppear {
            visible = true
            confetti = true

            if success {
                SoundSvc.shared.effect(AssetName.Sound.confetti)
            }

            DispatchQueue.main.asyncAfter(
                deadline: .now() + AppConst.Time.doneAuto
            ) {
                close()
            }
        }
    }

    private func close() {
        guard !closed else {
            return
        }

        closed = true
        action()
    }
}

private struct ConfettiView: View {
    let active: Bool

    private let count = 22

    var body: some View {
        GeometryReader { geo in
            ZStack {
                ForEach(0..<count, id: \.self) { index in
                    ConfettiPiece(
                        index: index,
                        screen: geo.size,
                        active: active
                    )
                }
            }
        }
        .ignoresSafeArea()
    }
}

private struct ConfettiPiece: View {
    let index: Int
    let screen: CGSize
    let active: Bool

    private var size: CGFloat {
        CGFloat(8 + (index % 4) * 3)
    }

    private var x: CGFloat {
        let slots: [CGFloat] = [
            0.10,
            0.16,
            0.22,
            0.28,
            0.36,
            0.42,
            0.50,
            0.56,
            0.64,
            0.70,
            0.78,
            0.86,
            0.92
        ]

        return screen.width * slots[index % slots.count]
    }

    private var yStart: CGFloat {
        -CGFloat(20 + (index % 5) * 18)
    }

    private var yEnd: CGFloat {
        screen.height * CGFloat(0.22 + Double(index % 7) * 0.07)
    }

    private var drift: CGFloat {
        CGFloat((index % 5) - 2) * 18
    }

    private var duration: Double {
        0.95 + Double(index % 5) * 0.12
    }

    private var delay: Double {
        Double(index % 7) * 0.045
    }

    var body: some View {
        piece
            .frame(
                width: size,
                height: size
            )
            .opacity(active ? 0.85 : 0)
            .position(
                x: active ? x + drift : x,
                y: active ? yEnd : yStart
            )
            .rotationEffect(
                .degrees(active ? Double(120 + index * 18) : 0)
            )
            .animation(
                .easeOut(duration: duration).delay(delay),
                value: active
            )
    }

    @ViewBuilder
    private var piece: some View {
        if index.isMultiple(of: 3) {
            Circle()
                .fill(color)
        } else {
            RoundedRectangle(
                cornerRadius: 3,
                style: .continuous
            )
            .fill(color)
        }
    }

    private var color: Color {
        switch index % 5 {
        case 0:
            return Color(red: 255 / 255, green: 211 / 255, blue: 82 / 255)

        case 1:
            return Color(red: 255 / 255, green: 142 / 255, blue: 82 / 255)

        case 2:
            return Color(red: 137 / 255, green: 205 / 255, blue: 235 / 255)

        case 3:
            return Color(red: 126 / 255, green: 198 / 255, blue: 118 / 255)

        default:
            return .white.opacity(0.9)
        }
    }
}
