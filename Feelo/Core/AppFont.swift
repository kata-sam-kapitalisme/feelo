import CoreText
import Foundation
import SwiftUI
import UIKit

enum AppFont {
    private static let boldName = "FredokaLight-Bold"
    private static let semiName = "FredokaLight-SemiBold"
    private static let files = [
        "Fredoka-Bold",
        "Fredoka-SemiBold"
    ]

    static func register() {
        files.compactMap(fontURL).forEach { url in
            _ = CTFontManagerRegisterFontsForURL(url as CFURL, .process, nil)
        }
    }

    static func bold(_ size: CGFloat) -> Font {
        custom(boldName, size: size, weight: .bold)
    }

    static func semi(_ size: CGFloat) -> Font {
        custom(semiName, size: size, weight: .semibold)
    }

    private static func custom(
        _ name: String,
        size: CGFloat,
        weight: Font.Weight
    ) -> Font {
        if UIFont(name: name, size: size) != nil {
            return .custom(name, size: size)
        }

        return .system(
            size: size,
            weight: weight,
            design: .rounded
        )
    }

    private static func fontURL(_ file: String) -> URL? {
        Bundle.main.url(
            forResource: file,
            withExtension: "ttf"
        )
        ?? Bundle.main.url(
            forResource: file,
            withExtension: "ttf",
            subdirectory: "Fonts"
        )
        ?? Bundle.main.url(
            forResource: file,
            withExtension: "ttf",
            subdirectory: "Res/Fonts"
        )
    }
}
