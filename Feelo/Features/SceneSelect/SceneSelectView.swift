import SwiftUI
import UIKit

struct SceneSelectView: View {
    @Environment(Router.self) private var router

    private let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]

    private var scenarios: [Scenario] {
        router.sceneFilter?.filteredScenarios ?? []
    }

    private var filterTitle: String {
        router.sceneFilter?.title ?? "Semua Cerita"
    }

    private func isLocked(_ scenario: Scenario) -> Bool {
        scenario.isLocked
    }

    private func isCleared(_ scenario: Scenario) -> Bool {
        LevelProgress.isCleared(scenario.id)
    }

    var body: some View {
        ZStack(alignment: .topLeading) {
            Image("bg_waves")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()

            VStack(alignment: .leading, spacing: 0) {
                header
                    .padding(.horizontal, 28)
                    .padding(.top, 20)
                    .padding(.bottom, 8)

                Text(filterTitle)
                    .font(AppFont.semiBold(40))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 28)
                    .padding(.bottom, 18)

                if scenarios.isEmpty {
                    emptyState
                } else {
                    ScrollView(.vertical, showsIndicators: false) {
                        LazyVGrid(columns: columns, spacing: 16) {
                            ForEach(scenarios) { scenario in
                                SceneGridCard(
                                    scenario: scenario,
                                    locked: isLocked(scenario),
                                    cleared: isCleared(scenario)
                                ) {
                                    guard !isLocked(scenario) else { return }

                                    SoundManager.shared.playLevelUp()
                                    SoundManager.shared.stopBGM()
                                    router.selectedScenario = scenario
                                    router.currentScreen = .intro
                                }
                            }
                        }
                        .padding(.horizontal, 28)
                        .padding(.bottom, 40)
                    }
                }
            }
        }
        .onAppear {
            SoundManager.shared.playBGM()
        }
    }

    private var header: some View {
        HStack(alignment: .center) {
            Button {
                SoundManager.shared.playClick()
                router.currentScreen = .home
            } label: {
                ZStack {
                    Circle()
                        .fill(Color.white)
                        .frame(width: 46, height: 46)
                        .shadow(color: .black.opacity(0.15), radius: 4, y: 2)

                    Image(systemName: "chevron.left")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundStyle(Color(red: 0.11, green: 0.30, blue: 0.14))
                }
            }
            .buttonStyle(.plain)

            Spacer()

            Image("logo")
                .resizable()
                .scaledToFit()
                .frame(width: 250, height: 109.81068420410156)
        }
    }

    private var emptyState: some View {
        VStack(spacing: 14) {
            Image(systemName: "tray.fill")
                .font(.system(size: 44))
                .foregroundStyle(.white.opacity(0.35))

            Text("Belum ada cerita di sini")
                .font(AppFont.semiBold(18))
                .foregroundStyle(.white.opacity(0.45))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

private extension SceneFilter {
    var iconName: String {
        switch self {
        case .place: return "mappin.circle.fill"
        case .emotion: return "face.smiling.fill"
        }
    }
}

private struct SceneGridCard: View {
    let scenario: Scenario
    let locked: Bool
    let cleared: Bool
    let onTap: () -> Void

    private let cardAspect: CGFloat = 4 / 3
    private let corner: CGFloat = 28

    var body: some View {
        Button(action: onTap) {
            GeometryReader { geo in
                ZStack(alignment: .bottomLeading) {
                    thumbnailImage(width: geo.size.width, height: geo.size.height)

                    if cleared && !locked {
                        RoundedRectangle(cornerRadius: corner, style: .continuous)
                            .fill(Color.black.opacity(0.58))
                    }

                    if locked {
                        RoundedRectangle(cornerRadius: corner, style: .continuous)
                            .fill(Color.black.opacity(0.58))
                    }

                    titlePill
                        .padding(.leading, 18)
                        .padding(.bottom, 18)

                    if locked {
                        lockIcon
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                    }

                    if cleared && !locked {
                        clearedIcon
                            .padding(.top, 26)
                            .padding(.trailing, 26)
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                    }
                }
                .clipShape(RoundedRectangle(cornerRadius: corner, style: .continuous))
                .overlay {
                    if cleared && !locked {
                        RoundedRectangle(cornerRadius: corner, style: .continuous)
                            .stroke(Color(red: 255 / 255, green: 211 / 255, blue: 82 / 255), lineWidth: 4)
                    }
                }
                .shadow(color: .black.opacity(0.30), radius: 8, x: 0, y: 4)
            }
            .aspectRatio(cardAspect, contentMode: .fit)
        }
        .buttonStyle(.plain)
    }

    @ViewBuilder
    private func thumbnailImage(width: CGFloat, height: CGFloat) -> some View {
        let imageName = "place_\(placeImageKey(scenario.thumbnail))"

        if UIImage(named: imageName) != nil {
            Image(imageName)
                .resizable()
                .scaledToFill()
                .frame(width: width, height: height)
                .clipped()
        } else {
            LinearGradient(
                colors: [
                    scenario.bubbleColor.opacity(0.85),
                    scenario.bubbleColor.opacity(0.4)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .overlay(
                Image(systemName: "photo")
                    .font(.system(size: 36))
                    .foregroundStyle(.white.opacity(0.35))
            )
        }
    }

    private var clearedIcon: some View {
        ZStack {
            Circle()
                .fill(Color.white)
                .frame(width: 82, height: 82)
                .shadow(color: .black.opacity(0.18), radius: 8, y: 4)

            Image(systemName: "checkmark")
                .font(.system(size: 34, weight: .black))
                .foregroundStyle(Color(red: 20 / 255, green: 170 / 255, blue: 95 / 255))
        }
    }

    private var lockIcon: some View {
        ZStack {
            Circle()
                .fill(Color.white)
                .frame(width: 62, height: 62)
                .shadow(color: .black.opacity(0.15), radius: 4, y: 2)

            Image(systemName: "lock.fill")
                .font(.system(size: 26, weight: .bold))
                .foregroundStyle(Color.orange)
        }
    }

    private var titlePill: some View {
        Text(scenario.title)
            .font(AppFont.semiBold(22))
            .foregroundStyle(Color(red: 0.11, green: 0.25, blue: 0.13))
            .lineLimit(1)
            .multilineTextAlignment(.center)
            .padding(.horizontal, 18)
            .frame(height: 62)
            .background(
                RoundedRectangle(cornerRadius: 50, style: .continuous)
                    .fill(Color.white.opacity(0.95))
                    .shadow(color: .black.opacity(0.12), radius: 3, y: 1)
            )
    }

    private func placeImageKey(_ tag: String) -> String {
        switch tag.lowercased() {
        case "taman bermain": return "taman"
        case "sekolah": return "sekolah"
        case "rumah": return "rumah"
        case "pantai": return "pantai"
        case "kebun": return "kebun"
        default: return tag.lowercased()
        }
    }
}
