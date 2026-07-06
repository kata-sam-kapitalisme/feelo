import SwiftUI

struct EmotionCard: View {
    let emotion: EmotionModel
    let onTap: () -> Void

    var body: some View {
        GeometryReader { geo in
            let size = min(geo.size.width, geo.size.height)
            let outerWidth = size * 0.060          // 12pt outer ring width on 200px card
            let innerWidth = size * 0.050          // 10pt inner ring width on 200px card
            let totalBorderWidth = outerWidth + innerWidth // 22pt total border width on 200px card
            let innerSize = size - totalBorderWidth * 2 // 156pt inner circle size on 200px card

            ZStack(alignment: .topLeading) {
                let colors = ringColors

                // White fill background
                Circle()
                    .fill(Color.white)
                    .frame(width: size, height: size)

                // Outer border ring (12px)
                Circle()
                    .strokeBorder(colors.outer, lineWidth: outerWidth)
                    .frame(width: size, height: size)

                // Inner border ring (10px)
                Circle()
                    .inset(by: outerWidth)
                    .strokeBorder(colors.inner, lineWidth: innerWidth)
                    .frame(width: size, height: size)

                // Face / locked image
                Group {
                    if emotion.isLocked {
                        // Locked state: show locked_pic asset
                        Image("locked_pic")
                            .resizable()
                            .scaledToFill()
                    } else if UIImage(named: emotion.imageName) != nil {
                        Image(emotion.imageName)
                            .resizable()
                            .scaledToFill()
                    } else {
                        Circle().fill(colors.inner.opacity(0.30))
                    }
                }
                .frame(width: innerSize, height: innerSize)
                .clipShape(Circle())
                .offset(x: totalBorderWidth, y: totalBorderWidth)

                // Locked dim overlay covering entire card (rings, background, face image)
                if emotion.isLocked {
                    Circle()
                        .fill(Color.black.opacity(0.75))
                        .frame(width: size, height: size)

                    lockIcon(size: size * 0.38)
                        .offset(x: (size - size * 0.38) / 2, y: (size - size * 0.38) / 2)
                }

                // Pill label positioned exactly as in Figma: left 24, top 156 (proportional to 200px)
                pillLabel(size: size)
                    .offset(x: size * 0.12, y: size * 0.78)
            }
            .frame(width: size, height: size)
        }
        .contentShape(Rectangle())
        .onTapGesture {
            if !emotion.isLocked { onTap() }
        }
    }

    private var ringColors: (outer: Color, inner: Color) {
        if emotion.isLocked {
            return (Color(hex: "4FADEF"), Color(hex: "7DC6F9"))
        }

        switch emotion.title.lowercased() {
        case "bersemangat":
            return (Color(hex: "FFB900"), Color(hex: "FF8E52"))
        case "kecewa":
            return (Color(hex: "624EC5"), Color(hex: "4733AD"))
        case "takut":
            return (Color(hex: "4B9CD3"), Color(hex: "1D3557"))
        case "bangga":
            return (Color(hex: "FF5722"), Color(hex: "D84315"))
        case "bingung":
            return (Color(hex: "26A69A"), Color(hex: "00695C"))
        case "penasaran":
            return (Color(hex: "FF4081"), Color(hex: "C2185B"))
        default:
            return (emotion.borderColor.opacity(0.8), emotion.borderColor)
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

    private func pillLabel(size: CGFloat) -> some View {
        let fontSize = size * 0.10 // 20pt on 200px card
        let labelW = size * 0.765  // 153pt on 200px card
        let labelH = size * 0.22   // 44pt on 200px card
        let labelR = size * 0.12   // 24pt cornerRadius on 200px card
        let fredokaLoaded = UIFont(name: "FredokaLight-Bold", size: fontSize) != nil

        return Text(emotion.title)
            .font(fredokaLoaded
                  ? .custom("FredokaLight-Bold", size: fontSize)
                  : .system(size: fontSize, weight: .bold, design: .rounded))
            .foregroundStyle(Color(red: 0.10, green: 0.22, blue: 0.12))
            .lineLimit(1)
            .minimumScaleFactor(0.6)
            .multilineTextAlignment(.center)
            .frame(width: labelW, height: labelH)
            .background(
                RoundedRectangle(cornerRadius: labelR)
                    .fill(Color.white)
                    .shadow(color: .black.opacity(0.25), radius: 8, x: 0, y: 8)
            )
            .overlay(
                Group {
                    if emotion.isLocked {
                        RoundedRectangle(cornerRadius: labelR)
                            .fill(Color.black.opacity(0.75))
                    }
                }
            )
    }
}

// MARK: - Color Hex Extension
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
