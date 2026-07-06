import SwiftUI

enum StickerTheme {
    static let canvas = CGSize(width: 1406, height: 1064)

    static let bg = Color(red: 49 / 255, green: 88 / 255, blue: 35 / 255)
    static let page = Color(red: 253 / 255, green: 244 / 255, blue: 227 / 255)
    static let header = Color(red: 198 / 255, green: 217 / 255, blue: 191 / 255)
    static let line = Color(red: 250 / 255, green: 225 / 255, blue: 179 / 255)
    static let text = Color(red: 43 / 255, green: 74 / 255, blue: 33 / 255)
    static let locked = Color(red: 217 / 255, green: 217 / 255, blue: 217 / 255)
    static let mark = Color(red: 127 / 255, green: 128 / 255, blue: 127 / 255)

    static func bold(_ size: CGFloat) -> Font {
        AppFont.bold(size)
    }
}
