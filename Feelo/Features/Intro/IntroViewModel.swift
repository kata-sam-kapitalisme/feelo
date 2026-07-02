import Observation

enum IntroScene {
    case one
    case two
}

@Observable
final class IntroViewModel {
    var currentScene: IntroScene = .one

    var subtitle: String {
        switch currentScene {
        case .one: return "Kita akan belajar memecahkan gelembung! Siap?"
        case .two: return "Gunakan tanganmu untuk memecahkan semua gelembung yang muncul. Yuk mulai!"
        }
    }

    /// Returns `true` when the view should navigate away.
    func advance() -> Bool {
        switch currentScene {
        case .one:
            currentScene = .two
            return false
        case .two:
            return true
        }
    }
}
