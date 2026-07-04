import SwiftUI

struct EmotionCard: View {
    let emotion: EmotionModel
    let onTap: () -> Void

    var body: some View {
        GeometryReader { geo in
            let size = min(geo.size.width, geo.size.height)
            let innerSize = size - size * 0.12
            let borderWidth = size * 0.055

            ZStack {
                // Colored border ring + white fill
                Circle()
                    .strokeBorder(
                        emotion.isLocked ? Color.gray.opacity(0.45) : emotion.borderColor,
                        lineWidth: borderWidth
                    )
                    .background(Circle().fill(Color.white))
                    .frame(width: size, height: size)

                // Face image
                Group {
                    if UIImage(named: emotion.imageName) != nil {
                        Image(emotion.imageName)
                            .resizable()
                            .scaledToFill()
                    } else {
                        Circle().fill(emotion.borderColor.opacity(0.30))
                    }
                }
                .frame(width: innerSize, height: innerSize)
                .clipShape(Circle())

                // Locked dim overlay
                if emotion.isLocked {
                    Circle()
                        .fill(Color.black.opacity(0.55))
                        .frame(width: innerSize, height: innerSize)

                    lockIcon(size: size * 0.38)
                }

                // Pill overlapping bottom edge
                VStack {
                    Spacer()
                    pillLabel
                        .offset(y: size * 0.17)
                }
                .frame(width: size, height: size)
            }
            .frame(width: size, height: size)
        }
        .contentShape(Rectangle())
        .onTapGesture {
            if !emotion.isLocked { onTap() }
        }
    }

    private func lockIcon(size: CGFloat) -> some View {
        ZStack {
            Circle()
                .fill(.white)
                .frame(width: size, height: size)
                .shadow(color: .black.opacity(0.15), radius: 4, y: 2)
            Image(systemName: "lock.fill")
                .font(.system(size: size * 0.42, weight: .bold))
                .foregroundStyle(Color.orange)
        }
    }

    private var pillLabel: some View {
        Text(emotion.title)
            .font(.system(size: 13, weight: .bold, design: .rounded))
            .foregroundStyle(
                emotion.isLocked
                    ? Color.white.opacity(0.80)
                    : Color(red: 0.10, green: 0.22, blue: 0.12)
            )
            .lineLimit(1)
            .padding(.horizontal, 14)
            .padding(.vertical, 7)
            .background(
                Capsule()
                    .fill(emotion.isLocked ? Color.gray.opacity(0.50) : Color.white)
                    .shadow(color: .black.opacity(0.18), radius: 4, y: 2)
            )
    }
}
