# Project Specification: Somatic Emotional Learning App (Phase 1: Flow & Layout)

**Target Devices:** iPad & iPhone (iOS 17+)
**Orientation:** Landscape Only
**Framework:** SwiftUI
**Goal for Phase 1:** Establish the core user flow, screen navigation, and responsive wireframe layouts. Do not focus on high-fidelity styling, real videos, or complex computer vision yet. Use basic shapes (RoundedRectangles, Circles) and solid colors as placeholders.

---

## 0. Global Setup & State Management

_Goal: Ensure the app stays in landscape and handles navigation smoothly._

- [ ] **Orientation Lock:** Configure `Info.plist` (or Xcode project settings) to restrict supported interface orientations to Landscape Left and Landscape Right.
- [ ] **State Manager:** Create a `Router` class (using `@Observable`) to manage the current screen state.
  - _Hint:_ Use an enum `enum AppScreen { case home, intro, action, outro, badge }`.
  - Create a `RootView` that uses a `switch` statement on the router's current screen to display the correct view.

---

## 1. Homepage (`HomeView.swift`)

_Goal: Create a vertically scrolling dashboard with horizontally scrolling categories._

- [ ] **Layout Structure:** Use a `ScrollView(.vertical)` containing a main `VStack` aligned to the leading edge.
- [ ] **Section 1: Pilihan hari ini (Today's Choices)**
  - Add a Section Title: "Pilihan hari ini".
  - Add a `ScrollView(.horizontal)`.
  - Create 3 large `RoundedRectangle` cards (Aspect ratio approx 16:9).
  - Add overlay text to the cards: "Pecahkan gelembung", "Pompa bola", "Petak umpet".
  - **Action:** Add an `onTapGesture` to the "Pecahkan gelembung" card that changes the Router state to `.intro`.
- [ ] **Section 2: Cerita untukmu (Stories for You)**
  - Add a Section Title: "Cerita untukmu".
  - Add a `ScrollView(.horizontal)`.
  - Create 5+ circular placeholders.
  - Add small labels above/on the circles: "Taman Bermain", "Sekolah", "Rumah", "Pantai", "Kolam Renang", "Kebun".
- [ ] **Section 3: Macam macam emosi (Kinds of Emotions)**
  - Add a Section Title: "Macam macam emosi".
  - Add a `ScrollView(.horizontal)`.
  - Create large `RoundedRectangle` cards (similar to Section 1).
  - On the rightmost card, add a placeholder graphic representing a "Badge" collection.
- [ ] **Responsiveness:** Ensure card sizes use relative scaling (e.g., `.containerRelativeFrame` or `GeometryReader`) so they look good on both wide iPhones and large iPads.

---

## 2. Intro Page (`IntroView.swift`)

_Goal: Display video/animation placeholders with dynamic subtitles driven by code._

- [ ] **Layout Structure:** Use a `ZStack` to layer the video placeholder underneath the UI.
- [ ] **Background Placeholder:** Create a full-screen `Rectangle` (e.g., `Color.gray.opacity(0.3)`) to represent the playing video/animation.
- [ ] **Subtitle Overlay:**
  - Create a `VStack` placed at the top of the screen.
  - Wrap the text in a highly legible container (e.g., white background, rounded corners, padding).
- [ ] **Sequence Logic:**
  - Create a state variable to handle multiple intro scenes.
  - **Scene 1 Text:** "Kamu sedang berada di taman dan bertemu dengan temanmu yang sedang bermain dengan gelembung. Dia mengajakmu untuk bermain bersama."
  - **Scene 2 Text:** "Teman kamu meniup dengan kuat melalui tongkat gelembung. Lihatlah gelembung-gelembung yang melayang itu! **Kamu merasa bersemangat!**"
- [ ] **Navigation:** Add an `onTapGesture` to the entire screen that advances from Scene 1 to Scene 2, and from Scene 2 to the `.action` state in the Router.

---

## 3. Action Page (`ActionView.swift`)

_Goal: Wireframe the interactive gameplay UI overlaying the camera feed._

- [ ] **Layout Structure:** Use a `ZStack`.
- [ ] **Camera Placeholder:** Add a full-screen background representing the front-camera feed.
- [ ] **Top Instruction Overlay:**
  - Add a card pinned to the top center.
  - Title text: "Pecahkan Gelembung!"
  - Subtitle text: "Ayunkan tanganmu dan pecahkan semua!"
- [ ] **Game Entities Placeholders:**
  - Hardcode 5-8 small `Circle` views scattered randomly around the screen to represent the bubbles.
  - Place a stickman/user placeholder icon in the bottom center.
- [ ] **Score Counter Overlay:**
  - Add a small pill-shaped card pinned to the bottom-right corner.
  - Text: "Jumlah Gelembung\n0/12".
- [ ] **Navigation (Temporary):** Add a hidden button or an `onTapGesture` to the background to simulate finishing the game, changing the Router state to `.outro`.

---

## 4. Outro Page (`OutroView.swift`)

_Goal: Display the resolution animation with subtitles._

- [ ] **Layout Structure:** `ZStack` (similar to IntroView).
- [ ] **Background Placeholder:** Full-screen rectangle for the celebration animation.
- [ ] **Subtitle Overlay:**
  - Pinned to the top.
  - Text: "**Kamu berhasil memecahkan semua gelembung!**\nKamu sangat bersemangat dan melompat dengan bahagia."
- [ ] **Navigation:** Add an `onTapGesture` to advance the Router state to `.badge`.

---

## 5. Badge Page (`BadgeView.swift`)

_Goal: A reward screen showing the earned sticker, leading back to home._

- [ ] **Layout Structure:** Use a `VStack` perfectly centered on the screen.
- [ ] **Header Texts:**
  - Title: "**Petualangan selesai!**"
  - Subtitle: "Stiker baru!"
- [ ] **Badge Graphic:**
  - Create a large prominent `RoundedRectangle` or `Circle` in the center.
- [ ] **Badge Title:**
  - Text: "**Gelembung Ceria**" (placed directly under the badge graphic).
- [ ] **Call to Action:**
  - Create a button at the bottom: "Back Home".
  - Style it with a pill-shaped gray background.
  - **Action:** Clicking this button changes the Router state back to `.home`.

---

## Developer Quality-of-Life Tips for the AI Agent:

- Use `Spacer()` and `.padding()` generously to ensure the UI breathes nicely in landscape mode.
- For typography, use default iOS dynamic types (e.g., `.font(.largeTitle.bold())`, `.font(.title3)`) instead of hardcoded point sizes so it scales naturally between iPhone 17 and iPad.
- Keep all views in separate Swift files to maintain clean architecture from day one.
