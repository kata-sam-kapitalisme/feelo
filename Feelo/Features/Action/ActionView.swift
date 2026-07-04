import SwiftUI

struct ActionView: View {
    @Environment(Router.self) private var router

    var body: some View {
        let scenario = router.selectedScenario ?? ScenarioRepository.defaultScenario
        switch scenario.gameType {
        case .bubblePop:
            BubbleGameView()
        case .pumpBall:
            PumpBallView()
        }
    }
}
