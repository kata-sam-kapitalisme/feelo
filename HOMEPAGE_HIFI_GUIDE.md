# High-Fidelity SwiftUI Guide: Feelo Homepage

**Target:** iOS/iPadOS (Landscape Only)
**Framework:** SwiftUI
**Scope:** Homepage UI only. (Do NOT build the Category Theme Place page yet).
**Context:** All image assets, custom fonts, and icons are already available in the Xcode Asset Catalog.

## 1. Global Styling & Design Tokens

_Instruct the AI to set up these constants/extensions before building the views._

- **Typography:**
  - Use the project's custom rounded, playful font (e.g., `"FredokaOne"`, `"Baloo"`, or whatever is configured).
  - **Header (Feelo Logo):** Custom font, large title size (approx 36-40pt), white.
  - **Section Titles:** Custom font, title/title2 size (approx 24-28pt), white.
  - **Pill Labels:** Custom font or rounded system font, subheadline/caption size (approx 14-16pt), dark gray/black text.
- **Colors:**
  - **Background Green:** Deep forest green.
  - **Overlay Dim:** `Color.black.opacity(0.6)` for locked items.
  - **Padlock Orange:** Warm orange for the lock icon center.
  - **Card Background:** White for active cards.
- **Layout Margins:** Use generous padding (e.g., `padding(.horizontal, 40)`) to account for safe areas on iPhones and provide a spacious feel on iPads.

---

## 2. Data Models (Mock Data Setup)

_Create basic structs to drive the UI loops. Do not hardcode every view._

- **PlaceModel:** `id`, `title` (String), `imageName` (String), `isLocked` (Bool).
- **EmotionModel:** `id`, `title` (String), `imageName` (String), `borderColor` (Color), `isLocked` (Bool).

---

## 3. Screen Structure (`HomeView.swift`)

_Goal: A ZStack for the background, containing a VStack with a Header, and two horizontal scroll views._

- [ ] **Background Layer:**
  - Base color: Dark Green.
  - Wavy Pattern: Overlay the prepared wavy background asset (`Image("bg_waves")` or similar) covering the entire screen, ignoring safe areas.
- [ ] **Main Content Layer:**
  - A `ScrollView(.vertical)` (if needed for smaller iPhones) or a `VStack` with `.padding()` for the main layout.

---

## 4. Component: Header

- [ ] **Layout:** `HStack` at the top of the screen.
- [ ] **Logo (Leading):** Text("Feelo") using the large custom font, white color.
- [ ] **Book Button (Trailing):**
  - A circular white button with a drop shadow.
  - Inside: The prepared book/journal icon asset.
  - Add a simple scaling tap animation.

---

## 5. Component: "Cerita untukmu" (Places Carousel)

- [ ] **Section Header:** `Text("Cerita untukmu")` aligned to the leading edge, white text.
- [ ] **ScrollView:** Horizontal scroll, hiding indicators, with spacing of approx `24`.
- [ ] **Card Design (Active State):**
  - Use a `ZStack`.
  - **Cloud Frame Background:** Use the prepared wavy/cloud-shaped asset (`Image("cloud_frame_white")`) or a rounded rectangle with heavy corner radius (e.g., `30`). Add a soft drop shadow.
  - **Main Image:** The place illustration (e.g., `Image("taman_bermain")`), clipped to a slightly smaller rounded rectangle so the white frame shows around it.
  - **Pill Label:** A white `Capsule()` overlapping the bottom edge of the image. Contains `Text` (e.g., "Taman Bermain") in dark text. Add a slight drop shadow to the capsule.
- [ ] **Card Design (Locked State):**
  - Same base layout as active.
  - **Dimming:** Apply a `.overlay(Color.black.opacity(0.6))` over the main image.
  - **Lock Icon:** A white `Circle()` in the exact center, containing an orange padlock icon asset.
  - **Pill Label:** Dimmed (e.g., gray background instead of bright white), or placed under the dimming layer depending on asset setup.

---

## 6. Component: "Macam-macam emosi" (Emotions Carousel)

- [ ] **Section Header:** `Text("Macam-macam emosi")` aligned to the leading edge, white text, placed below the Places carousel.
- [ ] **ScrollView:** Horizontal scroll, hiding indicators, spacing of approx `20`.
- [ ] **Card Design (Active State):**
  - **Shape:** Perfect `Circle()`.
  - **Border:** Thick stroke (e.g., `lineWidth: 6`). Color mapped from the data model (e.g., Yellow for "Bersemangat", Purple for "Kecewa").
  - **Image:** The emotion squirrel face, clipped to the circle shape.
  - **Pill Label:** White `Capsule()` with dark text (e.g., "Bersemangat"). Use `.offset(y: 15)` so it overlaps the bottom boundary of the circular image. Add a drop shadow.
- [ ] **Card Design (Locked State):**
  - **Shape:** `Circle()`.
  - **Border:** Dark gray/transparent.
  - **Image & Overlay:** Dimmed with `Color.black.opacity(0.6)`.
  - **Lock Icon:** White circle with orange padlock in the center.
  - **Pill Label:** Placed at the bottom, matching the locked aesthetic.

---

## 7. Interaction & Routing Integration

- [ ] **Tap Gestures:**
  - Add `.onTapGesture` only to cards where `isLocked == false`.
  - On tap, trigger the `Router` to switch to the `.intro` state (passing the selected Place or Emotion data if necessary for future steps).
- [ ] **Locked Feedback:**
  - (Optional) Add a slight "shake" animation or a subtle haptic feedback if the user taps a locked card, doing nothing else.
