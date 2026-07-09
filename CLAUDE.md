# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Build Setup

The Xcode project is generated — **never edit `Feelo.xcodeproj` directly**.

```bash
# After adding or removing any Swift file:
xcodegen generate

# Open in Xcode:
open Feelo.xcodeproj
```

Build/run from Xcode (Cmd+B / Cmd+R). Target iOS 17+, iPhone & iPad, **landscape only**.

The camera + Vision hand-tracking pipeline requires a **physical device**. In the Simulator, use the `#if DEBUG` tap-to-inject path: tapping the game canvas calls `gameEngine.injectTap(at:)` to simulate bubble collisions without a camera.

## Architecture

**MVVM with `@Observable` (iOS 17 Observation framework).** No `ObservableObject`, no `@Published` — use `@Observable` on all model/viewmodel classes.

**Navigation** is a single flat enum switched in `RootView`. To navigate, set `router.currentScreen`:

```swift
// Router.swift
enum AppScreen { case home, intro, action, outro, badge }

@Observable final class Router {
    var currentScreen: AppScreen = .home
    var selectedScenario: Scenario? = nil   // set before navigating to .intro/.action
}
```

`Router` is injected at the root via `.environment(router)` and accessed in any view with `@Environment(Router.self)`.

**ViewModels** are created as `@State` inside their owning view (not injected). Stateless screens (Outro, Badge) have no ViewModel.

## Navigation Flow

```
Home → (tap card, sets router.selectedScenario) →
Intro (2-tap advance via IntroViewModel.advance()) →
Action (BubbleGameView) →
Outro → Badge → Home
```

## Scenario System

`Scenario` is the central data model flowing through the entire game session. `HomeViewModel` maps `HomeItem.scenarioID` strings → `ScenarioRepository.scenario(for:)` → `router.selectedScenario`. Views fall back to `ScenarioRepository.defaultScenario` when `selectedScenario` is nil.

Adding a new scenario: add an entry to `ScenarioRepository.all` in `Shared/Models/ScenarioRepository.swift` and a matching `HomeItem` with the same `scenarioID` in `HomeViewModel`.

## Game Architecture (BubblePop)

`BubbleGameView` owns all state (`CameraManager`, `PoseManager`, `GameEngine`) and wires them together:

- `CameraManager` → publishes `CMSampleBuffer` frames
- `PoseManager.connect(to:)` subscribes and emits `wristPoints: [CGPoint]` on `@MainActor`
- `GameEngine` is stepped via `TimelineView(.animation)` → `update(dt:)` + `checkCollisions(activePoints:)`
- `GameHUDView` reads `GameEngine` state and renders the timer bar, score, and `CelebrationOverlay`

`GameEngine.configure(scenario:screenSize:)` must be called before gameplay starts (done in `.onAppear` of the `GeometryReader`).

## Adding a New Game

1. Create `Features/Action/Games/<GameName>/` with its own view, engine, and model files
2. Switch on `router.selectedScenario` (or a new router property) inside `ActionView` to render the correct game view
3. `Shared/Camera/` and `Shared/Vision/` are already available to all games — no structural changes needed

## Key Constraints

- Landscape only — enforced in `project.yml` Info.plist properties; do not add portrait orientations
- iOS 17 minimum — use `@Observable`, not `ObservableObject`; use `onChange(of:) { old, new in }` (two-argument form)
- `CameraManager` orientation must be updated on interface rotation (`updateOrientation(_:)`) — already wired in `BubbleGameView` via `NotificationCenter`
