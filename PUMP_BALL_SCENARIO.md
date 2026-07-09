# Project Specification: Scenario - Pumping the Ball

**Target:** iOS/iPadOS (Landscape Only)
**Framework:** SwiftUI, Apple Vision (`VNHumanBodyPoseObservation`), AVFoundation
**Goal:** Create an interactive scenario where the user physically pumps a ball by moving their hands up and down. The front camera tracks their wrists, and the on-screen ball inflates proportionally to their movements.

---

## 1. Global Setup & Assets Preparation

_Goal: Prepare the environment and necessary variables._

- **Assets Required (Placeholders for now, to be replaced with real images later):**
  - `tree_left`, `tree_right` (Environment)
  - `pump_base`, `pump_handle` (The pump mechanism)
  - `ball_graphic` (The basketball)
  - `cloud_bubble` (Instruction container)

---

## 2. Computer Vision Logic (`PoseManager` extension)

_Goal: Detect the "up and down" pumping motion using the user's wrists._

- [ ] **Wrist Tracking:**
  - Update the existing `PoseManager` (or create one) to continuously track the `leftWrist` and `rightWrist` normalized Y-coordinates from `VNDetectHumanBodyPoseRequest`.
  - Calculate the `averageWristY` (the midpoint between the left and right wrist heights).
- [ ] **Pump Gesture Detection (State Machine):**
  - Create a state variable in `PoseManager`: `var pumpState: PumpState = .down` (Enum: `.up`, `.down`).
  - **Logic:**
    - _Note: Vision's normalized Y-axis is 0.0 at the bottom, 1.0 at the top._
    - If `averageWristY > 0.6`, set `pumpState = .up` (Hands are raised).
    - If `averageWristY < 0.4` AND `pumpState == .up`, register a successful pump!
    - When a successful pump is registered, publish an event/trigger (e.g., `didPump()`) and set `pumpState = .down`.
- [ ] **Wrist Height Publisher (For UI Binding):**
  - Expose a `@Published var currentWristHeight: CGFloat` that maps the normalized Y-coordinate to the SwiftUI screen height. This will be used to move the pump handle up and down dynamically with the user's hands.

---

## 3. Game Engine & State (`PumpGameEngine`)

_Goal: Manage the inflation progress of the ball._

- [ ] **Game State Variables:**
  - `@Published var pumpCount: Int = 0`
  - `let requiredPumps: Int = 5` (Total pumps needed to finish the game)
  - `@Published var isGameFinished: Bool = false`
- [ ] **Progress Calculation:**
  - Create a computed property `var inflationProgress: Double` that returns `Double(pumpCount) / Double(requiredPumps)`. (Clamped between 0.0 and 1.0).
- [ ] **Action Handling:**
  - Create a function `registerPump()`.
  - Inside, increment `pumpCount`. Add a slight haptic feedback (`UIImpactFeedbackGenerator(style: .heavy)`).
  - Check if `pumpCount >= requiredPumps`. If true, set `isGameFinished = true` and trigger a success sound/event.

---

## 4. UI Layout & View (`PumpBallView.swift`)

_Goal: Build the overlay UI as seen in the reference design (image_91f365.jpg)._

- [ ] **Layer 1: Camera Background**
  - Add the `CameraView` as the base layer inside a `ZStack`. It must fill the screen and ignore safe areas.
- [ ] **Layer 2: Environment Assets**
  - Use an `HStack` to place `Image("tree_left")` on the bottom-leading edge and `Image("tree_right")` on the bottom-trailing edge. Use `.ignoresSafeArea()`.
- [ ] **Layer 3: The Pump & Ball**
  - **The Ball:** Place `Image("ball_graphic")` in the bottom-right quadrant (near the right tree).
    - **Animation:** Bind its `scaleEffect` to `(0.3 + (0.7 * gameEngine.inflationProgress))`. It starts small (30%) and grows to full size (100%) as the user pumps. Add a `.animation(.spring(), value: inflationProgress)` for a bouncy inflation effect.
  - **The Pump Base:** Place `Image("pump_base")` in the bottom-center of the screen.
  - **The Pump Handle:** Place `Image("pump_handle")` overlapping the base.
    - **Dynamic Movement:** Bind the Y-offset of the handle to `poseManager.currentWristHeight`. As the user moves their hands up/down, the handle should mimic their movement on screen. (Set min/max offset clamps so the handle doesn't disconnect from the base).
- [ ] **Layer 4: Instructions**
  - Place a `ZStack` at the top center.
  - Background: `Image("cloud_bubble")` (or a white Capsule with `.shadow`).
  - Text: Use a `VStack`.
    - Text 1: "Yuk, Pompa Bolanya!" (Bold, larger font).
    - Text 2: "Gerakkan tanganmu naik dan turun untuk memompa bola!" (Regular, smaller font).
  - Keep this layer visible until `isGameFinished` is true.

---

## 5. Developer Quality-of-Life (Debug Mode)

- [ ] **Screen Tap Simulator:**
  - Wrap the `ZStack` with a tap gesture. If `#if DEBUG` is active, tapping the screen manually calls `gameEngine.registerPump()`. This allows UI/animation testing without having to stand up and wave at the camera.
