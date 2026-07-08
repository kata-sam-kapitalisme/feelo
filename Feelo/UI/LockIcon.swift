import SwiftUI

struct LockIcon: View {
    let size: CGFloat

    var body: some View {
        ZStack {
            Circle()
                .fill(.white)
                .frame(
                    width: size,
                    height: size
                )
                .shadow(
                    color: .black.opacity(0.15),
                    radius: 0,
                    x: 0,
                    y: 2
                )

            Image(systemName: "lock.fill")
                .font(.system(
                    size: size * 0.42,
                    weight: .bold
                ))
                .foregroundStyle(.orange)
        }
    }
}
