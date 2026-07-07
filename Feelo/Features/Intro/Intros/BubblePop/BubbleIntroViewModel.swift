import Observation

enum BubbleIntroScene {
    case one
    case two
    case three
    case four
    case five
}

@Observable
final class BubbleIntroViewModel {
    var currentScene: BubbleIntroScene = .one

    var characterGifName: String {
        switch currentScene {
        case .one, .two: return "1"
        case .three: return "2"
        case .four: return "2"
        case .five: return "4"
        }
    }

    var subtitle: String {
        switch currentScene {
        case .one:
            return "Kamu sedang berada di taman dan bertemu Tilly yang sedang bermain gelembung."
        case .two:
            return "Tilly mengajakmu bermain bersama. Ia mulai menyiapkan tongkat gelembungnya."
        case .three:
            return "Tilly meniup tongkat gelembung. Gelembung-gelembung mulai melayang di udara."
        case .four:
            return "Wah, gelembungnya banyak sekali! Kamu merasa bersemangat!"
        case .five:
            return "Ayo pecahkan gelembung-gelembungnya!"
        }
    }

    /// Returns `true` when the view should navigate away.
    func advance() -> Bool {
        switch currentScene {
        case .one:
            currentScene = .two
            return false
        case .two:
            currentScene = .three
            return false
        case .three:
            currentScene = .four
            return false
        case .four:
            currentScene = .five
            return false
        case .five:
            return true
        }
    }
}
