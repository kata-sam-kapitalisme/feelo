# Project Specification: Intro Page (Layered Animation)

**Target:** iOS/iPadOS (Landscape Only)
**Framework:** SwiftUI
**Goal:** Build an interactive intro sequence using a layered composition of static images and GIFs. The user will tap the screen to progress through 4 distinct narrative scenes, which updates both the character's GIF animation and the subtitle text.

---

## 1. Recommended Tech Stack for GIFs in SwiftUI

Since standard SwiftUI `Image("my_gif")` does not animate GIFs, the AI agent needs to implement a GIF renderer.

- **Recommended Approach (Zero Dependencies):** Ask the AI to create a `UIViewRepresentable` that wraps a `WKWebView`. This is the most lightweight, native way to load a local `.gif` file in SwiftUI and have it scale perfectly to full screen without memory leaks or relying on third-party packages like SDWebImage.
- **Layering:** `ZStack` will be used to stack the background, moving trees, character GIFs, and the text overlay.

---

## 2. Asset Inventory & Screen Layers

_Ensure these files are added to the Xcode project (GIFs must be added to the project navigator, not just the Asset Catalog, so they can be loaded by URL)._

- **Layer 1 (Furthest Back):** `background.png` (Static background sky/ground/playground equipment)
- **Layer 2:** `Background Bubble.gif` (Environment animation)
- **Layer 3:** Character State GIF (Changes based on current scene)
  - Scene 1: `1.gif` (Neutral/Idle state, holding wand down)
  - Scene 2: `1.gif` (Getting ready state, holding wand down) _Note: If this visually matches Scene 1, you can reuse `1.gif` here._
  - Scene 3: `2.gif` (Blowing the bubble)
  - Scene 4: `3.gif` (Surrounded by many bubbles)
- **Layer 4 (Top):** Speech Bubble & Subtitle Text.

---

## 3. Scene Data & Copywriting

The text must update dynamically as the user progresses through the 4 taps.

- **Scene 1:**
  - **Text:** "Kamu sedang berada di taman dan bertemu Tilly yang sedang bermain gelembung."
  - **Character Asset:** `1.gif`
- **Scene 2:**
  - **Text:** "Tilly mengajakmu bermain bersama. Ia mulai menyiapkan tongkat gelembungnya."
  - **Character Asset:** `2.gif`
- **Scene 3:**
  - **Text:** "Tilly meniup tongkat gelembung. Gelembung-gelembung mulai melayang di udara."
  - **Character Asset:** `3.gif`
- **Scene 4:**
  - **Text:** "Wah, gelembungnya banyak sekali! Kamu merasa bersemangat!"
  - **Character Asset:** `4.gif`

---

## 4. AI Agent Master To-Do List

_Feed these prompts to your coding agent sequentially to build the page._

### Phase 1: GIF Support Component

- [ ] **Prompt 1.1: Native GIF Player**
  > "Create a SwiftUI view called `GifImageView` using `UIViewRepresentable` that wraps a `WKWebView`. It should accept a string representing the filename of a local GIF. Configure the WKWebView to have a clear background, disable scrolling, disable user interaction, and scale the GIF to 'aspect-fit' or 'aspect-fill' the bounds of the view."

### Phase 2: Base Layout & Layering

- [ ] **Prompt 2.1: ZStack Foundation**
  > "Create `IntroSequenceView`. Use a `ZStack` as the root. Add `Image("background")` as the bottom layer, ensuring it is resizable, scaled to fill, and uses `.ignoresSafeArea()`. Directly above it, add `GifImageView(name: "Background Bubble")`, also scaled to fill and ignoring safe areas."

### Phase 3: State Management & Character Logic

- [ ] **Prompt 3.1: Scene State Handling**
  > "In `IntroSequenceView`, create a `@State var currentScene: Int = 1`. Create a computed property that returns the correct character GIF filename based on `currentScene` (1 returns '1', 2 returns '2', 3 returns '3', 4 returns '4'). Add this character `GifImageView` as Layer 3 in our `ZStack`. Ensure the character image scales to fit the screen appropriately."

### Phase 4: Subtitles & Speech Bubble

- [ ] **Prompt 4.1: Cloud Text Overlay**
  > "Create a computed property that returns the correct Indonesian subtitle string based on `currentScene` (Reference the 4-scene data). Add a `VStack` to the top of the `ZStack`. Inside, display this text. Wrap the text in a white rounded rectangle or a 'cloud' shape with a thick gray border and drop shadow, exactly like a comic book speech bubble. Ensure the typography is bold, highly legible, centered, and has horizontal padding."

### Phase 5: User Interaction & Routing

- [ ] **Prompt 5.1: Tap to Progress**
  > "Add an `.onTapGesture` to the root `ZStack` (or a full-screen clear overlay). When tapped, increment `currentScene` by 1. Add an animation (like `.easeInOut(duration: 0.3)`) to smooth the text transitions. If `currentScene` exceeds 4, trigger a closure or update the global `Router` state to navigate the user to the `.action` gameplay page."
