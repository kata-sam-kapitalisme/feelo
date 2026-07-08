import SwiftUI

struct DoneView: View {
    @Environment(AppNav.self) private var nav

    private var item: Scenario {
        nav.scenario ?? ScenarioRepo.first
    }

    var body: some View {
        GeometryReader { geo in
            let scale = min(geo.size.width / AppConst.Ref.w, geo.size.height / AppConst.Ref.h)
            let cardSize = min(geo.size.width * 0.32, geo.size.height * 0.40)

            ZStack {
                Image(AssetName.Img.bgWaves)
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()

                VStack(spacing: geo.size.height * 0.04) {
                    VStack(spacing: 20 * scale) {
                        Text("Petualangan selesai!")
                            .font(AppFont.bold(40 * scale))
                            .foregroundStyle(.white)

                        Text("Stiker baru!")
                            .font(AppFont.semi(36 * scale))
                            .foregroundStyle(.white)
                    }

                    ZStack {
                        RoundedRectangle(cornerRadius: 140 * scale)
                            .fill(Color(
                                red: 82 / 255,
                                green: 146 / 255,
                                blue: 58 / 255
                            ))
                            .shadow(
                                color: .black.opacity(0.28),
                                radius: 10,
                                x: 0,
                                y: 10
                            )

                        Image(item.badgeImg)
                            .resizable()
                            .scaledToFit()
                            .padding(22 * scale)
                    }
                    .frame(width: cardSize, height: cardSize)

                    Text(item.badgeTitle)
                        .font(AppFont.bold(50 * scale))
                        .foregroundStyle(.white)

                    Button {
                        SoundSvc.shared.click()
                        nav.goHome()
                    } label: {
                        Text("Back Home")
                            .font(AppFont.semi(36 * scale))
                            .foregroundStyle(.black)
                            .frame(
                                width: geo.size.width * 0.22,
                                height: 60 * scale
                            )
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
                            .background(.white)
                            .clipShape(Capsule())
                    }
                    .buttonStyle(.plain)
                }
                .frame(
                    maxWidth: .infinity,
                    maxHeight: .infinity,
                    alignment: .center
                )
                .padding(.horizontal, 40)
            }
        }
//        .onAppear {
//            ProgressSvc.markDone(item.id)
//        }
        .ignoresSafeArea()
    }
}
