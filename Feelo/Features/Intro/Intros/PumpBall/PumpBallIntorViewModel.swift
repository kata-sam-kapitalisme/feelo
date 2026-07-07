import Observation

enum PumpBallIntroScene {
    case one
    case two
    case three
    case four
    case five
}

@Observable
final class PumpBallIntroViewModel {
    var currentScene: PumpBallIntroScene = .five
    var characterGifName: String {
        switch currentScene {
        case .one, .two, .three, .four:
            // TODO: fill in once scenes 1-4 assets are ready (tolongg shanonn)
            return ""
        case .five:
            return "4-2"
        }
    }

    var subtitle: String {
        switch currentScene {
        case .one, .two, .three, .four:
            return "" // TODO: fill in once scenes 1-4 copy is ready (ini juga)
        case .five:
            return "Ayo Pompa Bolanya!"
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
