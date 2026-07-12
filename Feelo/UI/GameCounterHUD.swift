import SwiftUI

struct GameCounterHUD: View {
    let iconName: String
    let current: Int
    let goal: Int

    var body: some View {
        HStack(spacing: 10) {
            Image(iconName)
                .resizable()
                .scaledToFit()
                .frame(width: 64, height: 64)

            Text("\(current)/\(goal)")
                .font(AppFont.bold(24))
                .foregroundStyle(.white)
                .contentTransition(.numericText())
                .animation(.bouncy, value: current)
                .frame(width: 74, alignment: .leading)
        }
        .padding(.leading, 12)
        .padding(.trailing, 16)
        .padding(.vertical, 8)
        .background { Capsule().fill(.black.opacity(0.38)) }
        .overlay { Capsule().stroke(.white.opacity(0.22), lineWidth: 1.5) }
        .shadow(color: .black.opacity(0.16), radius: 6, x: 0, y: 3)
    }
}
