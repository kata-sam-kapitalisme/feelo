import Observation

enum IntroScene {
    case one
    case two
}

@Observable
final class IntroViewModel {
    var currentScene: IntroScene = .one
    private let scenario: Scenario

    init(scenario: Scenario) {
        self.scenario = scenario
    }

    var subtitle: String {
        switch currentScene {
        case .one: return scenario.introScene1
        case .two: return scenario.introScene2
        }
    }

    /// Returns `true` when the view should navigate away.
    func advance() -> Bool {
        switch currentScene {
        case .one:
            currentScene = .two
            return false
        case .two:
            return true
        }
    }
}
