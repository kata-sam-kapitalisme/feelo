import SwiftUI

struct IntroView: View {
    @Environment(Router.self) private var router
    @State private var viewModel: IntroViewModel

    init() {
        // viewModel is initialised in onAppear after router is available
        _viewModel = State(initialValue: IntroViewModel(scenario: ScenarioRepository.defaultScenario))
    }

    var body: some View {
        ZStack {
            Color(.systemGray6)
                .ignoresSafeArea()

            VStack(spacing: 24) {
                // Video placeholder
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color(.systemGray4))
                    .overlay {
                        VStack(spacing: 8) {
                            Image(systemName: "play.rectangle.fill")
                                .font(.system(size: 48))
                                .foregroundStyle(.white)
                            Text("Video Placeholder")
                                .font(.caption)
                                .foregroundStyle(.white.opacity(0.8))
                        }
                    }
                    .aspectRatio(16 / 9, contentMode: .fit)
                    .frame(maxWidth: 560)

                // Subtitle card
                Text(viewModel.subtitle)
                    .font(.title3)
                    .fontWeight(.medium)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
                    .padding(.vertical, 20)
                    .cardStyle()
                    .frame(maxWidth: 480)

                Text("Ketuk untuk lanjut")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .padding(32)
        }
        .onAppear {
            let scenario = router.selectedScenario ?? ScenarioRepository.defaultScenario
            viewModel = IntroViewModel(scenario: scenario)
        }
        .onTapGesture {
            if viewModel.advance() {
                router.currentScreen = .action
            }
        }
    }
}
