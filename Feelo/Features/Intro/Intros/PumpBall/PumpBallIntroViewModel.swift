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
    var currentScene: PumpBallIntroScene = .one
    
    var backgroundGifName: String {
        switch currentScene {
        case .one:
            return "Background Bubble"
        default:
            return "Background Pump 2"
        }
    }

    var characterGifName: String {
        switch currentScene {
        case .one, .two: return "pump1"
        case .three: return "pump2"
        case .four: return "pump3"
        case .five: return "pump4"
        }
    }

    var subtitle: String {
        switch currentScene {
        case .one:
            return "Kamu selesai bermain gelembung bersama Tilly. Sekarang, Tilly mengajakmu mencoba permainan lain."
        case .two:
            return "Tilly melihat sebuah bola di semak-semak. Ia mengajakmu mengambilnya bersama."
        case .three:
            return "Oh tidak... bolanya ternyata kempes! Kamu merasa kecewa."
        case .four:
            return "Tidak apa-apa! Ayo kita pompa bolanya bersama!"
        case .five:
            return "Yuk, Pompa Bolanya! Gerakkan tanganmu naik dan turun untuk memompa bola!"
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


