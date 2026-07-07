import SwiftUI

// MARK: - HomeView

struct HomeView: View {
    @Environment(Router.self) private var router
    @State private var viewModel = HomeViewModel()
    @State private var badgePressed = false
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                // ── Background ──────────────────────────────────────
                Image("bg_waves")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                
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
        .onAppear {
            SoundManager.shared.playBGM()
        }
    }
    
    // MARK: - Responsive helpers
    
    private func hPad(_ geo: GeometryProxy) -> CGFloat {
        max(20, geo.size.width * 0.03)
    }
    
    // MARK: - Header
    
    private var homeHeader: some View {
        HStack(alignment: .center) {
            Image("logo")
                .resizable()
                .scaledToFit()
                .frame(width: 250, height: 109.81068420410156)
            
            Spacer()
            
            Button {
                SoundManager.shared.playClick()
                withAnimation(.spring(response: 0.3, dampingFraction: 0.5)) { badgePressed = true }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    badgePressed = false
                    router.currentScreen = .badge
                }
            } label: {
                ZStack {
                    Circle()
                        .fill(Color.white)
                        .frame(width: 80, height: 80)
                        .shadow(color: .black.opacity(0.25), radius: 6, y: 3)
                    Image("badge")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 48, height: 48)
                }
            }
            .buttonStyle(.plain)
            .scaleEffect(badgePressed ? 0.88 : 1.0)
        }
    }
    
    // MARK: - Section Title
    
    private func sectionTitle(_ text: String) -> some View {
        let fredokaLoaded = UIFont(name: "FredokaLight-Bold", size: 40) != nil
        return Text(text)
            .font(fredokaLoaded
                  ? .custom("FredokaLight-Bold", size: 40)
                  : .system(size: 40, weight: .bold, design: .rounded))
            .foregroundStyle(.white)
            .lineSpacing(0)
            .tracking(0)
    }
    
    // MARK: - Places Carousel
    
    @ViewBuilder
    private func placesCarousel(geo: GeometryProxy) -> some View {
        // Card width = ~35% of screen width; height = 3/4 of that (landscape 4:3)
        let cardW = geo.size.width * 0.33
        let cardH = cardW * 0.832   // Figma canvas: (61.27 + 304) / 439 = 0.832
        
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 16) {
                ForEach(viewModel.places) { place in
                    PlaceCard(place: place) {
                        router.sceneFilter = .place(place.title)
                        router.currentScreen = .sceneSelect
                    }
                    .frame(width: cardW, height: cardH)
                    .padding(.bottom, cardH * 0.25)   // room for proportional label overflow
                }
            }
            .padding(.horizontal, hPad(geo))
        }
    }
    
    
    // MARK: - Emotions Carousel
    
    @ViewBuilder
    private func emotionsCarousel(geo: GeometryProxy) -> some View {
        let circleSize: CGFloat = 200
        
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
