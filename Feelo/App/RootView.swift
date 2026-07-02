import SwiftUI

struct RootView: View {
    @Environment(Router.self) private var router

    var body: some View {
        switch router.currentScreen {
        case .home:
            HomeView()
        case .intro:
            IntroView()
        case .action:
            ActionView()
        case .outro:
            OutroView()
        case .badge:
            BadgeView()
        }
    }
}
