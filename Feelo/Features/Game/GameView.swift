import SwiftUI

struct GameView: View {
    @Environment(AppNav.self) private var nav

    var body: some View {
        let item = nav.scenario ?? ScenarioRepo.first

        switch item.kind {
        case .bubble:
            BubbleView()

        case .pump:
            PumpView()
        }
    }
}
