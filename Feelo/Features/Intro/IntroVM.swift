import Observation

enum BubbleIntroStep: Equatable {
    case one
    case two
    case three
    case four
    case five
}

@Observable
final class BubbleIntroVM {
    var step: BubbleIntroStep = .one

    var gif: String {
        switch step {
        case .one:
            return AssetName.Gif.bub1

        case .two:
            return AssetName.Gif.bub1

        case .three:
            return AssetName.Gif.bub2

        case .four:
            return AssetName.Gif.bub2

        case .five:
            return AssetName.Gif.bubTut
        }
    }

    var text: String {
        switch step {
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

    func next() -> Bool {
        switch step {
        case .one:
            step = .two
            return false

        case .two:
            step = .three
            return false

        case .three:
            step = .four
            return false

        case .four:
            step = .five
            return false

        case .five:
            return true
        }
    }
}

enum PumpIntroStep: Equatable {
    case one
    case two
    case three
    case four
    case five
}

@Observable
final class PumpIntroVM {
    var step: PumpIntroStep = .one

    var bgGif: String {
        switch step {
        case .one:
            return AssetName.Gif.bubBg

        case .two:
            return AssetName.Gif.pumpBg

        case .three:
            return AssetName.Gif.pumpBg

        case .four:
            return AssetName.Gif.pumpBg

        case .five:
            return AssetName.Gif.pumpBg
        }
    }

    var charGif: String {
        switch step {
        case .one:
            return AssetName.Gif.pump1

        case .two:
            return AssetName.Gif.pump1

        case .three:
            return AssetName.Gif.pump2

        case .four:
            return AssetName.Gif.pump3

        case .five:
            return AssetName.Gif.pump4
        }
    }

    var text: String {
        switch step {
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

    func next() -> Bool {
        switch step {
        case .one:
            step = .two
            return false

        case .two:
            step = .three
            return false

        case .three:
            step = .four
            return false

        case .four:
            step = .five
            return false

        case .five:
            return true
        }
    }
}
