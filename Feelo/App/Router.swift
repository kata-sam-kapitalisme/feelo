import Observation

enum SceneFilter {
    case place(String)
    case emotion(String)

    var title: String {
        switch self {
        case .place(let name): return name
        case .emotion(let name): return name
        }
    }

    var filteredScenarios: [Scenario] {
        switch self {
        case .place(let name):
            return ScenarioRepository.scenarios(forPlace: name)
        case .emotion(let name):
            return ScenarioRepository.scenarios(forEmotion: name)
        }
    }
}

enum AppScreen {
    case home
    case sceneSelect
    case intro
    case action
    case outro
    case badge
}

@Observable
final class Router {
    var currentScreen: AppScreen = .home
    var selectedScenario: Scenario? = nil
    var sceneFilter: SceneFilter? = nil

    func goHome() {
        selectedScenario = nil
        sceneFilter = nil
        currentScreen = .home
    }
}
