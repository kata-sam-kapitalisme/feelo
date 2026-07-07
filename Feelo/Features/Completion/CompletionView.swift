import SwiftUI

struct CompletionView: View {
    @Environment(Router.self) private var router

    private var scenario: Scenario {
        router.selectedScenario ?? ScenarioRepository.defaultScenario
    }

    var body: some View {
        GeometryReader { geo in
            ZStack {
                Image("bg_waves")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()

                VStack(spacing: geo.size.height * 0.04) {
                    VStack(spacing: 20) {
                        Text("Petualangan selesai!")
                            .font(AppFont.bold(40))
                            .foregroundStyle(.white)

                        Text("Stiker baru!")
                            .font(AppFont.semiBold(36))
                            .foregroundStyle(.white)
                    }

                    ZStack {
                        RoundedRectangle(cornerRadius: 140)
                            .fill(Color(red: 82 / 255, green: 146 / 255, blue: 58 / 255))
                            .shadow(
                                color: .black.opacity(0.28),
                                radius: 10,
                                x: 0,
                                y: 10
                            )

                        Image(scenario.badgeImage)
                            .resizable()
                            .scaledToFit()
                            .padding(22)
                    }
                    .frame(
                        width: geo.size.width * 0.32,
                        height: geo.size.width * 0.32
                    )

                    Text(scenario.badgeTitle)
                        .font(AppFont.bold(50))
                        .foregroundStyle(.white)

                    Button {
                        SoundManager.shared.playClick()
                        router.goHome()
                    } label: {
                        Text("Back Home")
                            .font(AppFont.semiBold(36))
                            .foregroundStyle(.black)
                            .frame(
                                width: geo.size.width * 0.22,
                                height: 60
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
        .onAppear {
            LevelProgress.markCleared(scenario.id)
        }
        .ignoresSafeArea()
    }
}

#Preview {
    let router = Router()
    router.selectedScenario = ScenarioRepository.all.last

    return CompletionView()
        .environment(router)
}
