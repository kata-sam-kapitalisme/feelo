import SwiftUI

struct ActionView: View {
    @Environment(Router.self) private var router
    @State private var viewModel: ActionViewModel

    init() {
        _viewModel = State(initialValue: ActionViewModel(scenario: ScenarioRepository.defaultScenario))
    }

    var body: some View {
        GeometryReader { geo in
            ZStack {
                // Camera / background placeholder
                RoundedRectangle(cornerRadius: 0)
                    .fill(Color.blue.opacity(0.15))
                    .ignoresSafeArea()
                    .overlay {
                        VStack(spacing: 8) {
                            Image(systemName: "camera.fill")
                                .font(.system(size: 40))
                                .foregroundStyle(.blue.opacity(0.4))
                            Text("Camera Placeholder")
                                .font(.caption)
                                .foregroundStyle(.blue.opacity(0.6))
                        }
                    }
                    .onTapGesture {
                        router.currentScreen = .outro
                    }

                // Stickman / body pose placeholder
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.green.opacity(0.3))
                    .frame(width: 60, height: 120)
                    .overlay {
                        Text("🧍")
                            .font(.system(size: 48))
                    }
                    .position(x: geo.size.width * 0.5, y: geo.size.height * 0.65)
                    .allowsHitTesting(false)

                // Bubbles
                ForEach(viewModel.bubbles) { bubble in
                    if !bubble.isPopped {
                        Circle()
                            .fill(bubble.color.opacity(0.7))
                            .frame(width: bubble.size, height: bubble.size)
                            .overlay {
                                Circle()
                                    .stroke(.white.opacity(0.5), lineWidth: 2)
                            }
                            .position(
                                x: bubble.normalizedPosition.x * geo.size.width,
                                y: bubble.normalizedPosition.y * geo.size.height
                            )
                            .onTapGesture {
                                viewModel.popBubble(id: bubble.id)
                            }
                    }
                }

                // Score pill
                scorePill
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                    .padding(20)

                // Instruction card
                instructionCard
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
                    .padding(20)
            }
            .onAppear {
                let scenario = router.selectedScenario ?? ScenarioRepository.defaultScenario
                viewModel = ActionViewModel(scenario: scenario)
                viewModel.spawnBubbles(in: geo.size)
            }
        }
        .ignoresSafeArea()
    }

    private var scorePill: some View {
        Text("💥 \(viewModel.poppedCount) / \(viewModel.totalBubbles)")
            .font(.headline)
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(.ultraThinMaterial, in: Capsule())
    }

    private var instructionCard: some View {
        Text("Pecahkan semua gelembung!\nKetuk layar untuk selesai.")
            .font(.subheadline)
            .multilineTextAlignment(.leading)
            .padding(12)
            .cardStyle()
            .frame(maxWidth: 240)
    }
}
