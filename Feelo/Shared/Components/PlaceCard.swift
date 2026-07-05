import SwiftUI

struct PlaceCard: View {
    let place: PlaceModel
    let onTap: () -> Void


    var body: some View {
        GeometryReader { geo in
            // The front card occupies the bottom portion.
            // Back cards sit above it, each offset upward by a peek amount.
            // Total required height = geo.size.height + peek1 + peek2
            // But we only have geo.size.height, so we shrink the front card
            // height so the total stack still fits.

            let frontH = geo.size.height * 0.82   // front card takes 82% of height
            let frontW = geo.size.width

            // Back card dimensions — significantly smaller so rotation
            // corners never overflow the frame
            let midW   = frontW * 0.88
            let midH   = frontH * 0.88
            let farW   = frontW * 0.68   // wider but still smaller than mid
            let farH   = frontH * 0.72

            ZStack(alignment: .bottom) {

                // ── Far back card (smallest, deepest, tilted left) ──
                RoundedRectangle(cornerRadius: 18)
                    .fill(Color(red: 0.62, green: 0.82, blue: 0.96))
                    .shadow(color: .black.opacity(0.15), radius: 6, x: 0, y: 3)
                    .frame(width: farW, height: farH)
                    .rotationEffect(.degrees(-5))   // smaller angle = less corner overshoot
                    .offset(y: -(geo.size.height - frontH) * 1.4)

                // ── Middle back card (medium, lighter blue, tilted right)
                RoundedRectangle(cornerRadius: 24)
                    .fill(Color(red: 0.75, green: 0.90, blue: 0.98))
                    .shadow(color: .black.opacity(0.18), radius: 8, x: 0, y: 4)
                    .frame(width: midW, height: midH)
                    .rotationEffect(.degrees(6))
                    .offset(y: -(geo.size.height - frontH) * 0.7)

                // ── Front card ────────────────────────────────────
                ZStack {
                    // White frame
                    RoundedRectangle(cornerRadius: 28)
                        .fill(.white)
                        .shadow(color: .black.opacity(0.32), radius: 16, x: 0, y: 8)

                    // Scene image — scaledToFill fills the card width,
                    // eliminating white gaps on the sides
                    Group {
                        if UIImage(named: place.imageName) != nil {
                            Image(place.imageName)
                                .resizable()
                                .scaledToFill()
                        } else {
                            LinearGradient(
                                colors: [Color.teal.opacity(0.7), Color.green.opacity(0.45)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        }
                    }
                    .frame(width: frontW - 22, height: frontH - 22)
                    .clipShape(RoundedRectangle(cornerRadius: 20))

                    // Bottom contrast gradient
                    LinearGradient(
                        colors: [
                            Color.black.opacity(0),
                            Color.black.opacity(0),
                            Color.black.opacity(0.40)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .frame(width: frontW - 22, height: frontH - 22)
                    .clipShape(RoundedRectangle(cornerRadius: 20))

                    // Locked dim overlay
                    if place.isLocked {
                        RoundedRectangle(cornerRadius: 22)
                            .fill(Color.black.opacity(0.55))
                            .frame(width: frontW - 8, height: frontH - 8)

                        lockIcon(size: min(frontW, frontH) * 0.28)
                    }
                }
                .frame(width: frontW, height: frontH)
                // Pill label overflows the front card's bottom edge
                .overlay(alignment: .bottom) {
                    pillLabel(cardWidth: frontW)
                        .offset(y: frontW * 0.14)  // proportional vertical offset
                }
            }
            // Fill the full GeometryReader frame, anchored to bottom
            .frame(width: geo.size.width, height: geo.size.height, alignment: .bottom)
        }
        .contentShape(Rectangle())
        .onTapGesture {
            if !place.isLocked { onTap() }
        }
    }

    // MARK: - Lock icon

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

    // MARK: - Pill label (Union SVG)

    private func pillLabel(cardWidth: CGFloat) -> some View {
        let labelW   = cardWidth * 0.72
        let labelH   = cardWidth * 0.22
        let fontSize = cardWidth * 0.055   // smaller text

        return ZStack {
            // Explicit frame forces the SVG to fill exactly labelW × labelH
            // (scaledToFit was ignoring the width dimension)
            Image("Union")
                .resizable()
                .renderingMode(.template)
                .foregroundStyle(
                    place.isLocked
                        ? Color.gray.opacity(0.55)
                        : Color.white
                )
                .frame(width: labelW, height: labelH)
                .shadow(color: .black.opacity(0.22), radius: 6, y: 3)

            Text(place.title)
                .font(.system(size: fontSize, weight: .bold, design: .rounded))
                .foregroundStyle(
                    place.isLocked
                        ? Color.white.opacity(0.85)
                        : Color(red: 0.10, green: 0.22, blue: 0.12)
                )
                .lineLimit(1)
                .offset(y: -labelH * 0.12)
        }
        .frame(width: labelW, height: labelH)
    }
}
