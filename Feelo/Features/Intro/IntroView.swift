import SwiftUI

struct IntroView: View {
    @Environment(AppNav.self) private var nav

    var body: some View {
        let item = nav.scenario ?? ScenarioRepo.first

        switch item.kind {
        case .bubble:
            BubbleIntro()

        case .pump:
            PumpIntro()
        }
    }
}
