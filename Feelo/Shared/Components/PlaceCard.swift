import SwiftUI

struct PlaceCard: View {
    let place: PlaceModel
    let onTap: () -> Void

    var body: some View {
        GeometryReader { geo in
            ZStack {
                // ── White cloud frame ──────────────────────────────
                RoundedRectangle(cornerRadius: 28)
                    .fill(.white)
                    .shadow(color: .black.opacity(0.22), radius: 10, x: 0, y: 6)

                // ── Scene image — centered with equal inset on all sides
                Group {
                    if UIImage(named: place.imageName) != nil {
                        Image(place.imageName)
                            .resizable()
                            .scaledToFit()
                    } else {
                        LinearGradient(
                            colors: [Color.teal.opacity(0.7), Color.green.opacity(0.45)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    }
                }
                .frame(width: geo.size.width - 14, height: geo.size.height - 14)
                .clipShape(RoundedRectangle(cornerRadius: 22))

                // ── Locked dim overlay ─────────────────────────────
                if place.isLocked {
                    RoundedRectangle(cornerRadius: 22)
                        .fill(Color.black.opacity(0.55))
                        .frame(width: geo.size.width - 14, height: geo.size.height - 14)

                    lockIcon(geo: geo)
                }
            }
            // ── Pill label overflowing the bottom edge ─────────────
            .overlay(alignment: .bottom) {
                pillLabel
                    .offset(y: 36)   // half of label height (72/2) so it straddles the edge
            }
        }
        .contentShape(Rectangle())
        .onTapGesture {
            if !place.isLocked { onTap() }
        }
    }

    private func lockIcon(geo: GeometryProxy) -> some View {
        let size: CGFloat = min(geo.size.width, geo.size.height) * 0.28
        return ZStack {
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
        ZStack {
            // Union SVG as label background shape
            Image("Union")
                .resizable()
                .renderingMode(.template)
                .foregroundStyle(
                    place.isLocked
                        ? Color.gray.opacity(0.55)
                        : Color.white
                )
                .scaledToFit()
                .shadow(color: .black.opacity(0.18), radius: 4, y: 2)

            // Title text centred on top of the Union shape
            Text(place.title)
                .font(.system(size: 18, weight: .bold, design: .rounded))
                .foregroundStyle(
                    place.isLocked
                        ? Color.white.opacity(0.85)
                        : Color(red: 0.10, green: 0.22, blue: 0.12)
                )
                .lineLimit(1)
                // Nudge text up slightly to sit in the flat top portion of the Union wave shape
                .offset(y: -6)
        }
        .frame(width: 220, height: 72)
    }
}
