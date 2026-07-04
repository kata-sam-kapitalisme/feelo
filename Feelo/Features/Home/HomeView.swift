import SwiftUI

struct HomeView: View {
    @Environment(Router.self) private var router
    @State private var viewModel = HomeViewModel()
    @State private var bookPressed = false

    var body: some View {
        ZStack {
            // Layer 1: dark green background
            Color(red: 0.08, green: 0.28, blue: 0.14)
                .ignoresSafeArea()

            // Layer 2: wave pattern placeholder
            // TODO: Replace with Image("bg_waves").resizable().ignoresSafeArea()
            Rectangle()
                .fill(Color.white.opacity(0.04))
                .ignoresSafeArea()

            // Layer 3: content
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: 32) {
                    header
                    placesSection
                    emotionsSection
                }
                .padding(.horizontal, 40)
                .padding(.vertical, 24)
            }
        }
    }

    // MARK: - Header

    private var header: some View {
        HStack {
            Text("Feelo")
                .font(.system(size: 38, weight: .bold, design: .rounded))
                .foregroundStyle(.white)

            Spacer()

            Button {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.5)) {
                    bookPressed = true
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    bookPressed = false
                }
            } label: {
                ZStack {
                    Circle()
                        .fill(.white)
                        .frame(width: 50, height: 50)
                        .shadow(color: .black.opacity(0.2), radius: 6, y: 3)
                    Image(systemName: "book.fill")
                        .font(.system(size: 22))
                        .foregroundStyle(Color(red: 0.08, green: 0.28, blue: 0.14))
                }
            }
            .scaleEffect(bookPressed ? 0.88 : 1.0)
        }
    }

    // MARK: - Places Section

    private var placesSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Cerita untukmu")
                .font(.system(.title2, design: .rounded, weight: .bold))
                .foregroundStyle(.white)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 20) {
                    ForEach(viewModel.places) { place in
                        PlaceCard(place: place) {
                            navigateToPlace(place)
                        }
                        .padding(.bottom, 24) // space for pill overflow
                    }
                }
                .padding(.horizontal, 40)
            }
            .padding(.horizontal, -40)
        }
    }

    // MARK: - Emotions Section

    private var emotionsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Macam-macam emosi")
                .font(.system(.title2, design: .rounded, weight: .bold))
                .foregroundStyle(.white)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 24) {
                    ForEach(viewModel.emotions) { emotion in
                        EmotionCard(emotion: emotion) {
                            router.sceneFilter = .emotion(emotion.title)
                            router.currentScreen = .sceneSelect
                        }
                    }
                }
                .padding(.horizontal, 40)
            }
            .padding(.horizontal, -40)
        }
    }

    // MARK: - Navigation

    private func navigateToPlace(_ place: PlaceModel) {
        router.sceneFilter = .place(place.title)
        router.currentScreen = .sceneSelect
    }
}
