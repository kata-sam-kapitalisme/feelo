import SwiftUI

struct EmotionCard: View {
    let emotion: EmotionModel
    let onTap: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                // Colored border circle
                Circle()
                    .strokeBorder(emotion.isLocked ? .gray : emotion.borderColor, lineWidth: 6)
                    .frame(width: 130, height: 130)

                // Image placeholder
                // TODO: Replace with Image(emotion.imageName).resizable().scaledToFill()
                Circle()
                    .fill(emotion.borderColor.opacity(emotion.isLocked ? 0.2 : 0.4))
                    .frame(width: 118, height: 118)

                // Locked dim overlay
                if emotion.isLocked {
                    Circle()
                        .fill(Color.black.opacity(0.6))
                        .frame(width: 118, height: 118)

                    lockIcon
                }
            }
            .overlay(alignment: .bottom) {
                pillLabel
                    .offset(y: 15)
            }

            Spacer().frame(height: 22) // room for pill offset
        }
        .contentShape(Rectangle())
        .onTapGesture {
            if !emotion.isLocked { onTap() }
        }
    }

    private var lockIcon: some View {
        ZStack {
            Circle()
                .fill(.white)
                .frame(width: 36, height: 36)
            Image(systemName: "lock.fill")
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(.orange)
        }
    }

    private var pillLabel: some View {
        Text(emotion.title)
            .font(.system(.caption, design: .rounded, weight: .semibold))
            .foregroundStyle(emotion.isLocked ? Color.gray : Color.black)
            .padding(.horizontal, 12)
            .padding(.vertical, 5)
            .background(
                Capsule()
                    .fill(Color.white)
                    .shadow(color: .black.opacity(0.2), radius: 4, y: 2)
            )
    }
}
