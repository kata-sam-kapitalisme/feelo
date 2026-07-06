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

            // Back card dimensions — from Figma specs
            // Middle: 335×232 / front 439×304 = 0.763 ratio
            let midW   = frontW * 0.763
            let midH   = frontH * 0.763
            // Far: 251×174 / front 439×304 = 0.572 ratio
            let farW   = frontW * 0.572
            let farH   = frontH * 0.572

            // Y offsets: derived from Figma canvas (total height = 365.27)
            // middle top=23.33 → bottom=255.33 → offset = -(365.27-255.33)/365.27 * geo.h
            let midOffY  = -(geo.size.height * 0.301)
            // far top ≈ 0 → bottom≈174 → offset = -(365.27-174)/365.27 * geo.h
            let farOffY  = -(geo.size.height * 0.524)

            ZStack(alignment: .bottom) {

                // ── Far back card — Figma: 251×174, angle: -3.39°, cornerRadius: 50
                ZStack {
                    RoundedRectangle(cornerRadius: 50)
                        .fill(place.isLocked ? Color(hex: "EBEBEB") : Color(red: 0.62, green: 0.82, blue: 0.96))
                    if place.isLocked {
                        RoundedRectangle(cornerRadius: 50)
                            .fill(Color.black.opacity(0.75))
                    }
                }
                .shadow(color: .black.opacity(0.15), radius: 0, x: 0, y: 3)
                .frame(width: farW, height: farH)
                .rotationEffect(.degrees(-3.39))
                .offset(y: farOffY)

                // ── Middle back card — Figma: 335×232, angle: +2.76°, cornerRadius: 50
                ZStack {
                    RoundedRectangle(cornerRadius: 50)
                        .fill(place.isLocked ? Color(hex: "F8F8F8") : Color(red: 0.75, green: 0.90, blue: 0.98))
                    if place.isLocked {
                        RoundedRectangle(cornerRadius: 50)
                            .fill(Color.black.opacity(0.75))
                    }
                }
                .shadow(color: .black.opacity(0.18), radius: 0, x: 0, y: 4)
                .frame(width: midW, height: midH)
                .rotationEffect(.degrees(2.76))
                .offset(y: midOffY)

                // ── Front card ────────────────────────────────────
                ZStack {
                    // White frame — cornerRadius: 50, border: 15
                    RoundedRectangle(cornerRadius: 50)
                        .fill(.white)
                        .shadow(color: Color(hex: "27461C"), radius: 0, x: 0, y: frontW * (20 / 439))

                    // Scene image — inset 15pt each side
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
                    .frame(width: frontW - 30, height: frontH - 30)
                    .clipShape(RoundedRectangle(cornerRadius: 38))

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
                    .frame(width: frontW - 30, height: frontH - 30)
                    .clipShape(RoundedRectangle(cornerRadius: 38))

                    // Locked dim overlay covering entire card
                    if place.isLocked {
                        RoundedRectangle(cornerRadius: 50)
                            .fill(Color.black.opacity(0.75))
                            .frame(width: frontW, height: frontH)

                        lockIcon(size: min(frontW, frontH) * 0.28)
                    }
                }
                .frame(width: frontW, height: frontH)
                // Label: left-aligned at left:44/439≈10% of card width,
                // top: 300/304 of card height → almost fully below card
                .overlay(alignment: .bottomLeading) {
                    pillLabel(cardWidth: frontW)
                        // Positive y pushes label down below card bottom.
                        // 300px top on 304px card → overlap = 4px → offset = labelH - 4/304*frontH
                        .offset(
                            x: frontW * 0.10,    // left: 44/439
                            y: frontW * 0.14     // pull up — label straddles bottom edge
                        )
                }
            }
            // Fill the full GeometryReader frame, anchored to bottom
            .frame(width: geo.size.width, height: geo.size.height, alignment: .bottom)
        }
        .contentShape(Rectangle())
        .onTapWithSound {
            if !place.isLocked { onTap() }
        }
    }

    // MARK: - Lock icon
 
    private func lockIcon(size: CGFloat) -> some View {
        ZStack {
            Circle()
                .fill(.white)
                .frame(width: size, height: size)
                .shadow(color: .black.opacity(0.15), radius: 0, x: 0, y: 2)
            Image(systemName: "lock.fill")
                .font(.system(size: size * 0.42, weight: .bold))
                .foregroundStyle(Color.orange)
        }
    }

    // MARK: - Pill label (Union SVG)
 
    private func pillLabel(cardWidth: CGFloat) -> some View {
        // Figma: 342.5 × 110 on a 439pt card → 342.5/439 ≈ 0.780, 110/439 ≈ 0.251
        let labelW   = cardWidth * 0.780
        let labelH   = cardWidth * 0.251
        // Font: 32px on 439pt card -> 32/439 ≈ 0.07289
        let fontSize = cardWidth * 0.07289
 
        let font: Font
        if UIFont(name: "FredokaLight-Bold", size: fontSize) != nil {
            font = .custom("FredokaLight-Bold", size: fontSize)
        } else {
            font = .system(size: fontSize, weight: .bold, design: .rounded)
        }
 
        return ZStack {
            Image("Union")
                .resizable()
                .renderingMode(.template)
                .foregroundStyle(Color.white)
                .frame(width: labelW, height: labelH)
                .shadow(color: Color(hex: "27461C"), radius: 0, x: 0, y: cardWidth * (20 / 439))
 
            Text(place.title)
                .font(font)
                .foregroundStyle(Color(red: 0.10, green: 0.22, blue: 0.12))
                .lineLimit(1)
                .padding(.horizontal, cardWidth * 0.046)  // 20/439 ≈ 4.6%
                .offset(y: -labelH * 0.14)

            // Locked dim overlay: 75% black Union shape on top
            if place.isLocked {
                Image("Union")
                    .resizable()
                    .renderingMode(.template)
                    .foregroundStyle(Color.black.opacity(0.75))
                    .frame(width: labelW, height: labelH)
            }
        }
        .frame(width: labelW, height: labelH)
    }
}
