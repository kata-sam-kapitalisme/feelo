import SwiftUI

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

    var body: some View {
        ZStack(alignment: .topLeading) {
            // Background
            Image("bg_waves")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()

            VStack(alignment: .leading, spacing: 0) {
                // ── Header ──────────────────────────────────────────
                header
                    .padding(.horizontal, 28)
                    .padding(.top, 20)
                    .padding(.bottom, 8)

                // ── Category title ──────────────────────────────────
                Text(filterTitle)
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 28)
                    .padding(.bottom, 18)

                // ── Grid ────────────────────────────────────────────
                if scenarios.isEmpty {
                    emptyState
                } else {
                    ScrollView(.vertical, showsIndicators: false) {
                        LazyVGrid(columns: columns, spacing: 16) {
                            ForEach(scenarios) { scenario in
                                SceneGridCard(
                                    scenario: scenario,
                                    locked: isLocked(scenario)
                                ) {
                                    if !isLocked(scenario) {
                                        router.selectedScenario = scenario
                                        router.currentScreen = .intro
                                    }
                                }
                            }
                        }
                        .padding(.horizontal, 28)
                        .padding(.bottom, 40)
                    }
                }
            }
        }
    }

    // MARK: - Header

    private var header: some View {
        HStack(alignment: .center) {
            // Back button
            Button {
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

            // Feelo logo
            Image("logo")
                .resizable()
                .scaledToFit()
                .frame(width: 250, height: 109.81068420410156)
        }
    }

    // MARK: - Empty State

    private var emptyState: some View {
        VStack(spacing: 14) {
            Image(systemName: "tray.fill")
                .font(.system(size: 44))
                .foregroundStyle(.white.opacity(0.35))
            Text("Belum ada cerita di sini")
                .font(.system(.body, design: .rounded, weight: .semibold))
                .foregroundStyle(.white.opacity(0.45))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

// MARK: - SceneFilter helpers

private extension SceneFilter {
    var iconName: String {
        switch self {
        case .place:   return "mappin.circle.fill"
        case .emotion: return "face.smiling.fill"
        }
    }
}

// MARK: - SceneGridCard

private struct SceneGridCard: View {
    let scenario: Scenario
    let locked: Bool
    let onTap: () -> Void

    // Aspect ratio matching the screenshot (roughly 4:3)
    private let cardAspect: CGFloat = 4 / 3

    var body: some View {
        Button(action: onTap) {
            GeometryReader { geo in
                ZStack(alignment: .bottom) {
                    // ── Thumbnail ──────────────────────────────
                    thumbnailImage(width: geo.size.width, height: geo.size.height)

                    // ── Lock overlay (darkens entire card) ─────
                    if locked {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.black.opacity(0.50))
                    }

                    // ── Lock icon ──────────────────────────────
                    if locked {
                        lockIcon
                    }

                    // ── Title pill (bottom) ────────────────────
                    titlePill
                        .padding(.horizontal, 10)
                        .padding(.bottom, 10)
                }
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .shadow(color: .black.opacity(0.30), radius: 8, x: 0, y: 4)
            }
            .aspectRatio(cardAspect, contentMode: .fit)
        }
        .buttonStyle(.plain)
    }

    // Thumbnail: use asset image if available, else coloured gradient placeholder
    @ViewBuilder
    private func thumbnailImage(width: CGFloat, height: CGFloat) -> some View {
        let imageName = "place_\(placeImageKey(scenario.placeTag))"
        if UIImage(named: imageName) != nil {
            Image(imageName)
                .resizable()
                .scaledToFill()
                .frame(width: width, height: height)
                .clipped()
        } else {
            // Coloured placeholder gradient
            LinearGradient(
                colors: [scenario.bubbleColor.opacity(0.85), scenario.bubbleColor.opacity(0.4)],
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

    private var lockIcon: some View {
        ZStack {
            Circle()
                .fill(Color.white)
                .frame(width: 52, height: 52)
                .shadow(color: .black.opacity(0.15), radius: 4, y: 2)
            Image(systemName: "lock.fill")
                .font(.system(size: 22, weight: .bold))
                .foregroundStyle(Color.orange)
        }
    }

    private var titlePill: some View {
        Text(scenario.title)
            .font(.system(size: 13, weight: .bold, design: .rounded))
            .foregroundStyle(Color(red: 0.11, green: 0.25, blue: 0.13))
            .lineLimit(1)
            .padding(.horizontal, 14)
            .padding(.vertical, 7)
            .background(
                Capsule()
                    .fill(Color.white.opacity(0.92))
                    .shadow(color: .black.opacity(0.12), radius: 3, y: 1)
            )
    }

    // Maps placeTag to the xcassets image key
    private func placeImageKey(_ tag: String) -> String {
        switch tag.lowercased() {
        case "taman bermain": return "taman"
        case "sekolah":       return "sekolah"
        case "rumah":         return "rumah"
        case "pantai":        return "pantai"
        case "kebun":         return "kebun"
        default:              return tag.lowercased()
        }
    }
}
