import SwiftUI

struct IntroView: View {
    @Environment(Router.self) private var router

    var body: some View {
        let scenario = router.selectedScenario ?? ScenarioRepository.defaultScenario
        switch scenario.gameType {
        case .bubblePop:
            BubbleIntroView()
        case .pumpBall:
            PumpBallIntroView()
        }
    }
}
