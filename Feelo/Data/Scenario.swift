import SwiftUI

enum GameKind {
    case bubble
    case pump
}

struct Scenario: Identifiable {
    let id: String
    let title: String
    let place: String
    let thumb: String
    let emotion: String

    let intro1: String
    let intro2: String

    let bubbleColor: Color
    let bubbleCount: Int

    let badgeTitle: String
    let badgeImg: String

    let duration: Double
    var kind: GameKind = .bubble
    var locked: Bool = false
}
