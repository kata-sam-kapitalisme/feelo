import SwiftUI

struct OutroView: View {
    @Environment(Router.self) private var router

    var body: some View {
        let scenario = router.selectedScenario ?? ScenarioRepository.defaultScenario
        switch scenario.gameType {
        case .bubblePop:
            BubbleOutroView()
        case .pumpBall:
            PumpBallOutroView()
        }
    }
}
