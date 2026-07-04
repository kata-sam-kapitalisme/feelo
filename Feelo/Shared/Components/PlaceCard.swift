import SwiftUI

struct PlaceCard: View {
    let place: PlaceModel
    let onTap: () -> Void

    var body: some View {
        ZStack(alignment: .bottom) {
            // White frame
            RoundedRectangle(cornerRadius: 30)
                .fill(.white)
                .shadow(color: .black.opacity(0.25), radius: 8, y: 4)

            // Image placeholder
            // TODO: Replace with Image(place.imageName).resizable().scaledToFill()
            Color.teal.opacity(0.5)
                .clipShape(RoundedRectangle(cornerRadius: 24))
                .padding(6)

            // Locked dim overlay
            if place.isLocked {
                Color.black.opacity(0.6)
                    .clipShape(RoundedRectangle(cornerRadius: 24))
                    .padding(6)

                lockIcon
            }

            // Pill label
            pillLabel
                .offset(y: 18)
        }
        .frame(width: 220, height: 160)
        .contentShape(Rectangle())
        .onTapGesture {
            if !place.isLocked { onTap() }
        }
    }

    private var lockIcon: some View {
        ZStack {
            Circle()
                .fill(.white)
                .frame(width: 44, height: 44)
            Image(systemName: "lock.fill")
                .font(.system(size: 20, weight: .semibold))
                .foregroundStyle(.orange)
        }
    }

    private var pillLabel: some View {
        Text(place.title)
            .font(.system(.subheadline, design: .rounded, weight: .semibold))
            .foregroundStyle(place.isLocked ? Color.gray : Color.black)
            .padding(.horizontal, 16)
            .padding(.vertical, 6)
            .background(
                Capsule()
                    .fill(place.isLocked ? Color.white.opacity(0.7) : Color.white)
                    .shadow(color: .black.opacity(0.15), radius: 4, y: 2)
            )
    }
}
