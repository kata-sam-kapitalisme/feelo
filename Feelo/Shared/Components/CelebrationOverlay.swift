import SwiftUI

struct CelebrationOverlay: View {
    let score: Int
    let goalMet: Bool
    let onExit: () -> Void

    @State private var showCard = false
    @State private var didExit = false
    @State private var confettiOn = false

    var body: some View {
        ZStack {
            Color.black.opacity(0.14)
                .ignoresSafeArea()
                .contentShape(Rectangle())
                .onTapGesture {
                    exit()
                }

            SoftConfettiView(isActive: confettiOn)
                .allowsHitTesting(false)

            VStack(spacing: 14) {
                ZStack {
                    Circle()
                        .fill(.white.opacity(0.90))
                        .frame(width: 76, height: 76)

                    Image(systemName: goalMet ? "checkmark" : "arrow.clockwise")
                        .font(.system(size: 34, weight: .black))
                        .foregroundStyle(
                            goalMet
                                ? Color(red: 22 / 255, green: 163 / 255, blue: 92 / 255)
                                : Color(red: 255 / 255, green: 145 / 255, blue: 55 / 255)
                        )
                }

                VStack(spacing: 6) {
                    Text(goalMet ? "Hebat!" : "Coba Lagi")
                        .font(AppFont.bold(38))
                        .foregroundStyle(.white)

                    Text(goalMet ? "Aktivitas selesai" : "Kamu sudah berusaha")
                        .font(AppFont.semiBold(22))
                        .foregroundStyle(.white.opacity(0.88))
                }

                Text(goalMet ? "Lanjut cerita..." : "Kembali pilih cerita")
                    .font(AppFont.semiBold(17))
                    .foregroundStyle(.white.opacity(0.65))
                    .padding(.top, 2)
            }
            .padding(.horizontal, 38)
            .padding(.vertical, 28)
            .background {
                RoundedRectangle(cornerRadius: 34, style: .continuous)
                    .fill(.white.opacity(0.10))
                    .background(
                        .ultraThinMaterial,
                        in: RoundedRectangle(cornerRadius: 34, style: .continuous)
                    )
            }
            .overlay {
                RoundedRectangle(cornerRadius: 34, style: .continuous)
                    .stroke(.white.opacity(0.24), lineWidth: 2)
            }
            .shadow(color: .black.opacity(0.18), radius: 16, x: 0, y: 8)
            .scaleEffect(showCard ? 1 : 0.9)
            .opacity(showCard ? 1 : 0)
            .animation(.spring(response: 0.35, dampingFraction: 0.78), value: showCard)
        }
        .onAppear {
            showCard = true
            confettiOn = true

            if goalMet {
                SoundManager.shared.playSound(named: "confetti_sound")
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 1.8) {
                exit()
            }
        }
    }

    private func exit() {
        guard !didExit else { return }
        didExit = true
        onExit()
    }
}

private struct SoftConfettiView: View {
    let isActive: Bool

    private let count = 22

    var body: some View {
        GeometryReader { geo in
            ZStack {
                ForEach(0..<count, id: \.self) { index in
                    ConfettiPiece(index: index, screen: geo.size, isActive: isActive)
                }
            }
        }
        .ignoresSafeArea()
    }
}

private struct ConfettiPiece: View {
    let index: Int
    let screen: CGSize
    let isActive: Bool

    private var size: CGFloat {
        CGFloat(8 + (index % 4) * 3)
    }

    private var startX: CGFloat {
        let slots: [CGFloat] = [
            0.10, 0.16, 0.22, 0.28, 0.36, 0.42,
            0.50, 0.56, 0.64, 0.70, 0.78, 0.86, 0.92
        ]
        return screen.width * slots[index % slots.count]
    }

    private var startY: CGFloat {
        -CGFloat(20 + (index % 5) * 18)
    }

    private var endY: CGFloat {
        screen.height * CGFloat(0.22 + Double(index % 7) * 0.07)
    }

    private var xDrift: CGFloat {
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
            .frame(width: size, height: size)
            .opacity(isActive ? 0.85 : 0)
            .position(
                x: isActive ? startX + xDrift : startX,
                y: isActive ? endY : startY
            )
            .rotationEffect(.degrees(isActive ? Double(120 + index * 18) : 0))
            .animation(
                .easeOut(duration: duration).delay(delay),
                value: isActive
            )
    }

    @ViewBuilder
    private var piece: some View {
        if index.isMultiple(of: 3) {
            Circle()
                .fill(color)
        } else {
            RoundedRectangle(cornerRadius: 3, style: .continuous)
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
            return Color.white.opacity(0.9)
        }
    }
}
