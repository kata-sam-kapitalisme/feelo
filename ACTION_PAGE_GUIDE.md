# Rebuild Guide — Somatic Emotional Learning Game

This guide walks through rebuilding this prototype into a real production app in a new repo. The prototype becomes one embedded feature (the game screen) inside a larger app with a real user flow.

---

## 1. Create the New Project

```bash
mkdir <your-app>
cd <your-app>
```

Create a `project.yml` for XcodeGen. Key settings to carry over from the prototype:

```yaml
name: <YourApp>

options:
  bundleIdPrefix: com.<yourorg>
  deploymentTarget:
    iOS: "17.0"
  xcodeVersion: "15.0"
  createIntermediateGroups: true

settings:
  base:
    SWIFT_VERSION: "5.9"
    IPHONEOS_DEPLOYMENT_TARGET: "17.0"
    TARGETED_DEVICE_FAMILY: "1,2" # iPhone + iPad
    SUPPORTS_MACCATALYST: NO

targets:
  <YourApp>:
    type: application
    platform: iOS
    sources:
      - path: <YourApp>
    info:
      path: <YourApp>/Info.plist
      properties:
        NSCameraUsageDescription: "Camera is used to track your body movements for the game."
        UILaunchScreen: {}
    settings:
      base:
        PRODUCT_BUNDLE_IDENTIFIER: com.<yourorg>.<yourapp>
        CODE_SIGN_STYLE: Automatic
    dependencies:
      - sdk: AVFoundation.framework
      - sdk: Vision.framework
```

Generate and open:

```bash
brew install xcodegen   # if not already installed
xcodegen generate
open <YourApp>.xcodeproj
```

---

## 2. Folder Structure

Organise the new app with these groups. The prototype's game code slots into `Features/SomaticGame/`:

```
<YourApp>/
├── App/
│   ├── AppEntry.swift          # @main
│   └── RootView.swift          # NavigationStack / TabView root
│
├── Features/
│   ├── Onboarding/             # New: real user onboarding flow
│   ├── Home/                   # New: real home/dashboard
│   └── SomaticGame/            # ← prototype code lives here
│       ├── Camera/
│       │   ├── CameraManager.swift
│       │   └── CameraView.swift
│       ├── Vision/
│       │   └── PoseManager.swift
│       ├── Game/
│       │   ├── Bubble.swift
│       │   ├── GameEngine.swift
│       │   └── GamePlayView.swift
│       ├── Views/
│       │   ├── ScenarioIntroView.swift
│       │   └── GameHUDView.swift
│       └── Models/
│           ├── EmotionType.swift
│           ├── Scenario.swift
│           └── ScenarioRepository.swift
│
└── Shared/
    ├── Extensions/
    └── Components/
```

---

## 3. Copy the Prototype Files

Copy these files verbatim from `c4-proto/c4-proto/` into `Features/SomaticGame/`:

| Source                            | Destination                    |
| --------------------------------- | ------------------------------ |
| `Camera/CameraManager.swift`      | `Features/SomaticGame/Camera/` |
| `Camera/CameraView.swift`         | `Features/SomaticGame/Camera/` |
| `Vision/PoseManager.swift`        | `Features/SomaticGame/Vision/` |
| `Game/Bubble.swift`               | `Features/SomaticGame/Game/`   |
| `Game/GameEngine.swift`           | `Features/SomaticGame/Game/`   |
| `Game/GamePlayView.swift`         | `Features/SomaticGame/Game/`   |
| `Views/ScenarioIntroView.swift`   | `Features/SomaticGame/Views/`  |
| `Views/GameHUDView.swift`         | `Features/SomaticGame/Views/`  |
| `Models/EmotionType.swift`        | `Features/SomaticGame/Models/` |
| `Models/Scenario.swift`           | `Features/SomaticGame/Models/` |
| `Models/ScenarioRepository.swift` | `Features/SomaticGame/Models/` |

Do **not** copy `ContentView.swift` or `c4_protoApp.swift` — the new app has its own entry point.

After copying, run `xcodegen generate` again so Xcode picks up the new files.

---

## 4. Wire the Game into the Real User Flow

The prototype's `ContentView` hardcodes directly into `GamePlayView`. Replace that with a proper navigation flow:

### 4a. App entry point (`App/AppEntry.swift`)

```swift
import SwiftUI

@main
struct YourApp: App {
    var body: some Scene {
        WindowGroup {
            RootView()
        }
    }
}
```

### 4b. Root navigation (`App/RootView.swift`)

```swift
import SwiftUI

struct RootView: View {
    var body: some View {
        NavigationStack {
            // Replace with your real home screen.
            // Navigate to ScenarioListView when the user reaches the game feature.
            ScenarioListView()
        }
    }
}
```

### 4c. Replace `HomeView` with a proper scenario picker

The prototype's `HomeView` can be renamed `ScenarioListView` and used as-is, or replaced with your real home screen. The key `NavigationLink` chain is:

```
YourHomeScreen
  → ScenarioListView        (pick a scenario)
    → ScenarioIntroView     (narrative + TTS read-aloud)
      → GamePlayView        (camera + bubble game)
        → GameHUDView       (timer, score, celebration overlay)
```

All four views already exist in the prototype. You only need to integrate `ScenarioListView` (previously `HomeView`) into wherever the game feature is triggered in your real app.

---

## 5. Adapt the Data Model for a Real Backend

`ScenarioRepository` currently returns hardcoded static data. Replace it with a real data source:

```swift
// Before (prototype — static mock)
enum ScenarioRepository {
    static let all: [Scenario] = [ ... ]
}

// After (production — async fetch from API or local JSON)
final class ScenarioRepository: ObservableObject {
    @Published var scenarios: [Scenario] = []

    func load() async throws {
        // Fetch from API, local JSON bundle, or CoreData
        // Decode into [Scenario]
    }
}
```

The `Scenario` struct itself is reusable with no changes. Add `Codable` conformance if loading from JSON/API:

```swift
struct Scenario: Identifiable, Codable {
    let id: UUID
    let title: String
    let storyNarrative: String
    let targetEmotion: EmotionType
    let requiredMotion: RequiredMotion
    let gameplayDurationSeconds: Double
    let bubbleColor: Color     // NOTE: Color is not Codable — store as hex String, convert on init
    let emoji: String
}
```

---

## 6. Camera & Vision — No Changes Required

`CameraManager` and `PoseManager` are production-ready as written. Key things to know when integrating:

- `CameraManager` must be started with `.task { cameraManager.start() }` and stopped with `.onDisappear { cameraManager.stop() }` — already handled in `GamePlayView`.
- `PoseManager` processes frames on a background `DispatchQueue` and publishes results back on `@MainActor`. This is safe to use in any view.
- The `NSCameraUsageDescription` key in `Info.plist` is already defined in `project.yml`. Confirm it's present in your new project's plist.

---

## 7. Game Engine — No Changes Required

`GameEngine` is fully self-contained. The only integration point is:

```swift
// In your containing view:
gameEngine.configure(scenario: selectedScenario, screenSize: geo.size)
```

`GamePlayView` already calls this correctly. No changes needed unless you want to extend game mechanics.

---

## 8. Real User Flow Additions

These features don't exist in the prototype and need to be built for production:

### Onboarding

- Camera permission explanation screen before `AVCaptureDevice.requestAccess` fires
- Brief tutorial showing the child what to do (animated demo of the motion)

### User / Child Profile

- Store child's name and age to personalise TTS narration and difficulty
- Progress tracking (which scenarios completed, score history)

### Session Results

- After `CelebrationOverlay` dismisses, navigate to a results screen
- Save score + timestamp to local persistence (SwiftData or CoreData)

### Accessibility

- VoiceOver labels on all game elements
- Reduce motion mode that disables bubble animation and uses tap instead of pose

### Analytics

- Log session start/end, scenario chosen, score, and whether the goal was met

---

## 9. Persistence (SwiftData recommended)

```swift
import SwiftData

@Model
final class GameSession {
    var scenarioTitle: String
    var emotion: String
    var score: Int
    var goalMet: Bool
    var playedAt: Date

    init(scenarioTitle: String, emotion: String, score: Int, goalMet: Bool) {
        self.scenarioTitle = scenarioTitle
        self.emotion = emotion
        self.score = score
        self.goalMet = goalMet
        self.playedAt = .now
    }
}
```

Add `@Environment(\.modelContext) private var modelContext` in the view that owns `GameHUDView` and save a `GameSession` when `gameEngine.isFinished` becomes `true`.

---

## 10. Testing

### Simulator (no camera)

`GameEngine` has a `#if DEBUG` escape hatch already built in:

```swift
#if DEBUG
func injectTap(at point: CGPoint) {
    checkCollisions(activePoints: [point])
}
#endif
```

Add a `simultaneousGesture(TapGesture())` on the canvas in DEBUG mode to call `injectTap` — this lets you test bubble popping and scoring in the Simulator without a camera.

### Physical Device

Build for a real iPhone or iPad (iOS 17+). The full camera + Vision hand-tracking pipeline only runs on real hardware.

### Unit Tests

The following components are pure logic and testable without a device:

- `GameEngine` — `spawnWave()`, `checkCollisions()`, `update()` timer countdown
- `ScenarioRepository` — scenario count, non-empty titles/narratives
- `PoseManager.toScreen(_:in:)` — coordinate conversion correctness

---

## 11. Build Checklist Before Shipping

- [ ] `NSCameraUsageDescription` set in `Info.plist`
- [ ] Development team set in Signing & Capabilities
- [ ] Tested on physical device (iPhone and iPad)
- [ ] Camera permission denial handled gracefully (`CameraView` already shows a fallback label)
- [ ] TTS `id-ID` voice available on test device; `en-US` fallback confirmed
- [ ] `ScenarioRepository` loads real data (not hardcoded mock)
- [ ] Game session results persisted
- [ ] App runs in both portrait and landscape on iPad
