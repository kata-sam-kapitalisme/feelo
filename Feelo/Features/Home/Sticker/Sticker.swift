import Foundation

struct Sticker: Identifiable, Equatable {
    let id: String
    let title: String
    let img: String?
    let lockShape: LockShape

    var unlocked: Bool {
        img != nil
    }
}
