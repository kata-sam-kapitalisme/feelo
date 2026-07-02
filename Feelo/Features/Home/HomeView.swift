import SwiftUI

struct HomeView: View {
    @Environment(Router.self) private var router
    @State private var viewModel = HomeViewModel()

    var body: some View {
        ScrollView(.vertical) {
            VStack(alignment: .leading, spacing: 28) {
                header

                ForEach(viewModel.sections, id: \.title) { section in
                    sectionView(section)
                }
            }
            .padding(.vertical, 24)
        }
        .background(Color(.systemGroupedBackground))
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Halo, Feelo! 👋")
                .font(.largeTitle)
                .fontWeight(.bold)
            Text("Mau belajar apa hari ini?")
                .font(.title3)
                .foregroundStyle(.secondary)
        }
        .padding(.horizontal, 24)
    }

    private func sectionView(_ section: HomeSection) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(section.title)
                .font(.title2)
                .fontWeight(.semibold)
                .padding(.horizontal, 24)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(section.items) { item in
                        ActivityCard(title: item.title, color: item.color) {
                            if let scenario = ScenarioRepository.scenario(for: item.scenarioID) {
                                router.selectedScenario = scenario
                                router.currentScreen = .intro
                            }
                        }
                        .containerRelativeFrame(.horizontal, count: 3, spacing: 16)
                    }
                }
                .padding(.horizontal, 24)
            }
        }
    }
}
