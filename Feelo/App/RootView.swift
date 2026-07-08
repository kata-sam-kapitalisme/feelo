import SwiftUI

struct RootView: View {
    @Environment(AppNav.self) private var nav

    var body: some View {
        switch nav.screen {
        case .home:
            HomeView()

        case .scene:
            SceneView()

        case .intro:
            IntroView()

        case .game:
            GameView()

        case .outro:
            OutroView()

        case .done:
            DoneView()

        case .sticker:
            StickerView()
        }
    }
}
