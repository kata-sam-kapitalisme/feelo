import Observation

enum SceneFilter {
    case place(String)
    case emotion(String)

    var title: String {
        switch self {
        case .place(let name):
            return name

        case .emotion(let name):
            return name
        }
    }

    var items: [Scenario] {
        switch self {
        case .place(let name):
            return ScenarioRepo.byPlace(name)

        case .emotion(let name):
            return ScenarioRepo.byEmotion(name)
        }
    }
}

enum AppScreen {
    case home
    case scene
    case intro
    case game
    case outro
    case done
    case sticker
}

@Observable
final class AppNav {
    var screen: AppScreen = .home
    var scenario: Scenario?
    var filter: SceneFilter?

    func finishGame() {
        screen = .outro
    }

    func finishStory() {
        if let id = scenario?.id {
            ProgressSvc.markDone(id)
        }

        screen = .done
    }

    func goHome() {
        scenario = nil
        filter = nil
        screen = .home
    }
}
