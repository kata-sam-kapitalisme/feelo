# Feelo

A SwiftUI iOS app for Somatic Emotional Learning designed for children. Children learn to identify and express emotions through interactive body-movement games.

**Phase 1** establishes the core navigation flow and wireframe layouts using placeholder shapes. No real camera, vision, or video yet.

---

## Requirements

| Tool | Version |
|------|---------|
| Xcode | 15.0+ |
| iOS Deployment Target | 17.0+ |
| XcodeGen | 2.x |

**Supported devices:** iPhone & iPad
**Orientation:** Landscape only

---

## Setup

### 1. Install XcodeGen

```bash
brew install xcodegen
```

### 2. Clone the repository

```bash
git clone <repo-url>
cd feelo
```

### 3. Generate the Xcode project

```bash
xcodegen generate
```

### 4. Open in Xcode

```bash
open Feelo.xcodeproj
```

### 5. Configure signing

In Xcode, select the **Feelo** target → **Signing & Capabilities**:
- Check **Automatically manage signing**
- Select your **Team** (your personal Apple ID is enough for development)

### 6. Build and run

Select an iPhone or iPad simulator (iOS 17+), then press **Cmd+B** to build or **Cmd+R** to run.

> Note: Re-run `xcodegen generate` any time you add or remove source files, then reopen the project in Xcode.

---

## Navigation Flow

```
HomeView
  └─ tap "Pecahkan gelembung"
       └─ IntroView (Scene 1)
            └─ tap
                 └─ IntroView (Scene 2)
                      └─ tap
                           └─ ActionView
                                └─ tap background
                                     └─ OutroView
                                          └─ tap
                                               └─ BadgeView
                                                    └─ "Kembali ke Beranda"
                                                         └─ HomeView
```

---

## Project Structure

```
feelo/
├── project.yml                          # XcodeGen configuration
└── Feelo/
    ├── App/
    │   ├── FeeloApp.swift               # App entry point (@main)
    │   ├── Router.swift                 # AppScreen enum + Observable Router
    │   └── RootView.swift               # Switches on router.currentScreen
    ├── Features/
    │   ├── Home/
    │   │   ├── HomeViewModel.swift      # Section data (dailyChoices, stories, emotions)
    │   │   └── HomeView.swift           # 3-section vertical scroll with horizontal cards
    │   ├── Intro/
    │   │   ├── IntroViewModel.swift     # 2-scene state + advance() logic
    │   │   └── IntroView.swift          # Video placeholder + subtitle + tap to advance
    │   ├── Action/
    │   │   ├── ActionViewModel.swift    # Bubble struct + spawnBubbles(in:) + poppedCount
    │   │   └── ActionView.swift         # Bubbles, score pill, stickman, instruction card
    │   ├── Outro/
    │   │   └── OutroView.swift          # Celebration placeholder + tap to badge
    │   └── Badge/
    │       └── BadgeView.swift          # Badge graphic + Back Home button
    └── Shared/
        ├── Extensions/
        │   └── View+Extensions.swift    # .cardStyle() view modifier
        └── Components/
            └── ActivityCard.swift       # Reusable 16:9 card with tap action
```

---

## Architecture

- **Pattern:** MVVM with `@Observable` (iOS 17 Observation framework)
- **Navigation:** Router pattern — `Router` class holds `currentScreen: AppScreen`, injected via `@Environment`
- **ViewModels:** Created as `@State` inside their View; stateless views (Outro, Badge) have no ViewModel
- **Responsiveness:** Cards use `.containerRelativeFrame` to scale across iPhone and iPad

---

## Phase 2 Integration Points

| Phase 1 Placeholder | Phase 2 Replacement |
|---|---|
| Gray `Rectangle` in IntroView | AVPlayer / Lottie animation |
| Blue `Rectangle` in ActionView | `CameraView` (AVFoundation) |
| Fixed bubble positions | `GameEngine.spawnWave()` |
| Stickman `RoundedRectangle` | Pose skeleton from `VNHumanBodyPoseObservation` |
| Purple `Rectangle` in OutroView | Lottie celebration animation |
