import SwiftUI

struct PumpBallIntroView: View {
    @Environment(Router.self) private var router

    var body: some View {
        ZStack {
            Color.gray.opacity(0.3).ignoresSafeArea()
            Text("PumpBall Intro")
                .font(.title)
                .fontWeight(.bold)
        }
        .onTapWithSound {
            router.currentScreen = .action
        }
    }
}
