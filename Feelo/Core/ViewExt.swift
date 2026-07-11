import SwiftUI

extension View {
    /// True on 13" iPads (long side > 1200pt); false on 11" and smaller.
    /// Use this wherever layout needs to differ between the two iPad sizes.
    var isLargeIPad: Bool {
        let s = UIScreen.main.bounds.size
        return max(s.width, s.height) > 1200
    }

    var safeAreaBottom: CGFloat {
        UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .first?.keyWindow?.safeAreaInsets.bottom ?? 0
    }

    /// Adds bottom padding that accounts for the home-indicator bar on 11" iPads.
    /// On 13" iPads the bar is absent so `base` is used directly.
    func bottomSafePadding(base: CGFloat = 32, offset: CGFloat = 45) -> some View {
        padding(.bottom, isLargeIPad ? base : max(base, safeAreaBottom + offset))
    }

    func cardShadow() -> some View {
        shadow(
            color: .black.opacity(0.08),
            radius: 8,
            x: 0,
            y: 4
        )
    }

    func tapSound(_ action: @escaping () -> Void) -> some View {
        onTapGesture {
            SoundSvc.shared.click()
            action()
        }
    }
}

extension Color {
    init(hex: String) {
        let clean = hex.trimmingCharacters(
            in: CharacterSet.alphanumerics.inverted
        )

        var int: UInt64 = 0
        Scanner(string: clean).scanHexInt64(&int)

        let a: UInt64
        let r: UInt64
        let g: UInt64
        let b: UInt64

        switch clean.count {
        case 3:
            a = 255
            r = (int >> 8) * 17
            g = (int >> 4 & 0xF) * 17
            b = (int & 0xF) * 17

        case 6:
            a = 255
            r = int >> 16
            g = int >> 8 & 0xFF
            b = int & 0xFF

        case 8:
            a = int >> 24
            r = int >> 16 & 0xFF
            g = int >> 8 & 0xFF
            b = int & 0xFF

        default:
            a = 255
            r = 0
            g = 0
            b = 0
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
