import SwiftUI

struct HomeView: View {
    @Environment(AppNav.self) private var nav

    @State private var vm = HomeVM()
    @State private var badgePressed = false

    var body: some View {
        GeometryReader { geo in
            let size = HomeSize.make(geo)

            ZStack {
                Image(AssetName.Img.bgWaves)
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()

                VStack(alignment: .leading, spacing: 0) {
                    header(size)
                        .padding(.horizontal, size.sidePad)
                        .padding(.top, geo.safeAreaInsets.top + 8)
                        .padding(.bottom, size.headerBottom)

                    sectionTitle(
                        "Cerita untukmu",
                        fontSize: size.titleFont
                    )
                    .padding(.horizontal, size.sidePad)
                    .padding(.bottom, AppConst.Home.titleBottom)

                    placeList(size)
                        .frame(height: size.placeTotalH)

                    Color.clear.frame(height: size.sectionGap)

                    sectionTitle(
                        "Macam-macam emosi",
                        fontSize: size.titleFont
                    )
                    .padding(.horizontal, size.sidePad)
                    .padding(.bottom, AppConst.Home.titleBottom)

                    emotionList(size)
                        .frame(height: size.emotionTotalH)

                    Spacer(minLength: geo.safeAreaInsets.bottom + 8)
                }
            }
        }
        .ignoresSafeArea(edges: .bottom)
        .onAppear {
            SoundSvc.shared.playBGM()
        }
    }

    private func header(_ size: HomeSize) -> some View {
        HStack(alignment: .center) {
            Image(AssetName.Img.logo)
                .resizable()
                .scaledToFit()
                .frame(
                    width: size.logoW,
                    height: size.logoH
                )

            Spacer()

            Button {
                SoundSvc.shared.click()

                withAnimation(.spring(
                    response: 0.3,
                    dampingFraction: 0.5
                )) {
                    badgePressed = true
                }

                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    badgePressed = false
                    nav.screen = .sticker
                }
            } label: {
                ZStack {
                    Circle()
                        .fill(.white)
                        .frame(
                            width: size.badge,
                            height: size.badge
                        )
                        .shadow(
                            color: .black.opacity(0.25),
                            radius: 6,
                            x: 0,
                            y: 3
                        )

                    Image(AssetName.Img.badge)
                        .resizable()
                        .scaledToFit()
                        .frame(
                            width: size.badge * 0.60,
                            height: size.badge * 0.60
                        )
                }
            }
            .buttonStyle(.plain)
            .scaleEffect(badgePressed ? 0.88 : 1.0)
        }
    }

    private func sectionTitle(
        _ text: String,
        fontSize: CGFloat
    ) -> some View {
        Text(text)
            .font(AppFont.bold(fontSize))
            .foregroundStyle(.white)
            .lineSpacing(0)
            .tracking(0)
    }

    private func placeList(_ size: HomeSize) -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: AppConst.Home.itemGap) {
                ForEach(vm.places) { place in
                    PlaceCard(place: place) {
                        nav.filter = .place(place.title)
                        nav.screen = .scene
                    }
                    .frame(
                        width: size.placeW,
                        height: size.placeH
                    )
                    .padding(.bottom, size.placeBottom)
                }
            }
            .padding(.horizontal, size.sidePad)
        }
    }

    private func emotionList(_ size: HomeSize) -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: AppConst.Home.emotionGap) {
                ForEach(vm.emotions) { emotion in
                    EmotionCard(emotion: emotion) {
                        nav.filter = .emotion(emotion.title)
                        nav.screen = .scene
                    }
                    .frame(
                        width: size.emotion,
                        height: size.emotion
                    )
                    .padding(.bottom, size.emotionBottom)
                }
            }
            .padding(.horizontal, size.sidePad)
        }
    }
}

private struct HomeSize {
    let sidePad: CGFloat

    let logoW: CGFloat
    let logoH: CGFloat
    let badge: CGFloat
    let headerBottom: CGFloat

    let titleFont: CGFloat

    let placeW: CGFloat
    let placeH: CGFloat
    let placeBottom: CGFloat
    let placeTotalH: CGFloat

    let sectionGap: CGFloat
    let emotion: CGFloat
    let emotionBottom: CGFloat
    let emotionTotalH: CGFloat

    static func make(_ geo: GeometryProxy) -> HomeSize {
        let screen = geo.size
        let sidePad = max(
            AppConst.Home.minSidePad,
            screen.width * AppConst.Home.sidePadRatio
        )

        let logoW = min(
            AppConst.Home.maxLogoW,
            screen.width * AppConst.Home.logoScreenWRatio,
            screen.height * AppConst.Home.logoScreenHRatio
        )

        let logoH = logoW * AppConst.Home.logoRatio

        let badge = min(
            AppConst.Home.maxBadge,
            logoH * AppConst.Home.badgeLogoRatio
        )

        let headerBottom = screen.height * 0.018

        let titleFont = max(
            AppConst.Home.minTitle,
            min(
                AppConst.Home.maxTitle,
                screen.height * 0.055
            )
        )

        // Directly subtract each fixed block so the bottom spacer minimum
        // (safeAreaInsets.bottom + 8) is always reserved and never causes overflow.
        let headerBlock = geo.safeAreaInsets.top + 8 + logoH + headerBottom
        let titleBlock = (titleFont * 1.35 + AppConst.Home.titleBottom) * 2
        let footerBlock = geo.safeAreaInsets.bottom + 48
        let sectionGap = max(4, (screen.height * 0.008)).rounded()

        let available = max(
            200,
            screen.height - headerBlock - titleBlock - footerBlock - sectionGap
        )

        let maxPlaceW = screen.width * AppConst.Home.placeWidthRatio
        let maxPlaceH = maxPlaceW * AppConst.Home.placeAspect

        let placeSpace = available * AppConst.Home.placeSpaceRatio
        let placeH = min(
            maxPlaceH,
            placeSpace / (1 + AppConst.Home.placeBottomRatio)
        )

        let placeW = placeH / AppConst.Home.placeAspect
        let placeBottom = placeH * AppConst.Home.placeBottomRatio
        let placeTotalH = placeH + placeBottom

        let remaining = max(
            120,
            available - placeTotalH
        )

        let emotion = min(
            AppConst.Home.maxEmotion,
            max(
                AppConst.Home.minEmotion,
                remaining / (1 + AppConst.Home.emotionBottomRatio)
            )
        )

        let emotionBottom = emotion * AppConst.Home.emotionBottomRatio
        let emotionTotalH = min(remaining, emotion + emotionBottom)

        return HomeSize(
            sidePad: sidePad,
            logoW: logoW,
            logoH: logoH,
            badge: badge,
            headerBottom: headerBottom,
            titleFont: titleFont,
            placeW: placeW,
            placeH: placeH,
            placeBottom: placeBottom,
            placeTotalH: placeTotalH,
            sectionGap: sectionGap,
            emotion: emotion,
            emotionBottom: emotionBottom,
            emotionTotalH: emotionTotalH
        )
    }
}
