import Observation

enum AppScreen {
    case home
    case intro
    case action
    case outro
    case badge
}

@Observable
final class Router {
    var currentScreen: AppScreen = .home
    var selectedScenario: Scenario? = nil
}
