import SwiftUI

// MARK: - HomeView

struct HomeView: View {
    @Environment(Router.self) private var router
    @State private var viewModel = HomeViewModel()
    @State private var bookPressed = false

    var body: some View {
        GeometryReader { geo in
            ZStack {
                // ── Background ──────────────────────────────────────
                Color(red: 0.13, green: 0.32, blue: 0.16)
                    .ignoresSafeArea()

                if UIImage(named: "bg_waves") != nil {
                    Image("bg_waves")
                        .resizable()
                        .ignoresSafeArea()
                        .opacity(0.18)
                }

                // ── Content ─────────────────────────────────────────
                VStack(alignment: .leading, spacing: 0) {

                    // Header
                    homeHeader
                        .padding(.horizontal, hPad(geo))
                        .padding(.top, geo.safeAreaInsets.top + 10)
                        .padding(.bottom, geo.size.height * 0.025)

                    // Section: Cerita untukmu
                    sectionTitle("Cerita untukmu")
                        .padding(.horizontal, hPad(geo))
                        .padding(.bottom, 12)

                    placesCarousel(geo: geo)

                    Spacer(minLength: 0)

                    // Section: Macam-macam emosi
                    sectionTitle("Macam-macam emosi")
                        .padding(.horizontal, hPad(geo))
                        .padding(.bottom, 12)

                    emotionsCarousel(geo: geo)

                    Spacer(minLength: geo.safeAreaInsets.bottom + 16)
                }
            }
        }
        .ignoresSafeArea(edges: .bottom)
    }

    // MARK: - Responsive helpers

    private func hPad(_ geo: GeometryProxy) -> CGFloat {
        max(20, geo.size.width * 0.03)
    }

    // MARK: - Header

    private var homeHeader: some View {
        HStack(alignment: .center) {
            Text("Feelo")
                .font(.system(size: 36, weight: .heavy, design: .rounded))
                .foregroundStyle(.white)

            Spacer()

            Button {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.5)) { bookPressed = true }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { bookPressed = false }
            } label: {
                ZStack {
                    Circle()
                        .fill(Color(red: 0.22, green: 0.18, blue: 0.45))
                        .frame(width: 52, height: 52)
                        .shadow(color: .black.opacity(0.25), radius: 6, y: 3)
                    Image(systemName: "book.fill")
                        .font(.system(size: 22, weight: .semibold))
                        .foregroundStyle(.yellow)
                }
            }
            .buttonStyle(.plain)
            .scaleEffect(bookPressed ? 0.88 : 1.0)
        }
    }

    // MARK: - Section Title

    private func sectionTitle(_ text: String) -> some View {
        Text(text)
            .font(.system(size: 24, weight: .bold, design: .rounded))
            .foregroundStyle(.white)
    }

    // MARK: - Places Carousel

    @ViewBuilder
    private func placesCarousel(geo: GeometryProxy) -> some View {
        // Card width = ~35% of screen width; height = 3/4 of that (landscape 4:3)
        let cardW = geo.size.width * 0.35
        let cardH = cardW * 0.75

        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 16) {
                ForEach(viewModel.places) { place in
                    PlaceCard(place: place) {
                        router.sceneFilter = .place(place.title)
                        router.currentScreen = .sceneSelect
                    }
                    .frame(width: cardW, height: cardH)
                    .padding(.bottom, 22)   // room for pill overflow
                }
            }
            .padding(.horizontal, hPad(geo))
        }
    }


    // MARK: - Emotions Carousel

    @ViewBuilder
    private func emotionsCarousel(geo: GeometryProxy) -> some View {
        let circleSize = geo.size.height * 0.26

        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 20) {
                ForEach(viewModel.emotions) { emotion in
                    EmotionCard(emotion: emotion) {
                        router.sceneFilter = .emotion(emotion.title)
                        router.currentScreen = .sceneSelect
                    }
                    .frame(width: circleSize, height: circleSize)
                    .padding(.bottom, circleSize * 0.22)   // room for pill overflow
                }
            }
            .padding(.horizontal, hPad(geo))
        }
    }
}
