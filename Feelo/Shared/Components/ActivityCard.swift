import SwiftUI

struct ActivityCard: View {
    let title: String
    let color: Color
    let action: () -> Void

    var body: some View {
        Button(action: {
            SoundManager.shared.playClick()
            action()
        }) {
            VStack(alignment: .leading, spacing: 8) {
                RoundedRectangle(cornerRadius: 12)
                    .fill(color)
                    .aspectRatio(16 / 9, contentMode: .fit)

                Text(title)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(.primary)
                    .padding(.horizontal, 4)
                    .padding(.bottom, 8)
            }
            .cardStyle()
        }
        .buttonStyle(.plain)
    }
}
