import SwiftUI
import UIKit

struct ActionView: View {
    @Environment(Router.self) private var router
    @State private var cameraManager = CameraManager()
    @State private var poseManager   = PoseManager()
    @State private var gameEngine    = GameEngine()

    var body: some View {
        GeometryReader { geo in
            ZStack {
                CameraView(cameraManager: cameraManager).ignoresSafeArea()
                TimelineView(.animation) { timeline in
                    Canvas { context, size in
                        for bubble in gameEngine.bubbles where !bubble.isPopped {
                            let rect = CGRect(
                                x: bubble.position.x - bubble.radius,
                                y: bubble.position.y - bubble.radius,
                                width: bubble.radius * 2,
                                height: bubble.radius * 2
                            )
                            context.fill(Path(ellipseIn: rect), with: .color(bubble.color.opacity(0.7)))
                            context.stroke(Path(ellipseIn: rect), with: .color(.white.opacity(0.5)), lineWidth: 2)
                        }
                        for normalized in poseManager.wristPoints {
                            let pt = poseManager.toScreen(normalized, in: size)
                            let r: CGFloat = 14
                            let dot = CGRect(x: pt.x - r, y: pt.y - r, width: r * 2, height: r * 2)
                            context.fill(Path(ellipseIn: dot), with: .color(Color(red: 1, green: 0, blue: 1).opacity(0.8)))
                        }
                    }
                    .onChange(of: timeline.date) { old, new in
                        gameEngine.update(dt: max(0, min(new.timeIntervalSince(old), 0.1)))
                        gameEngine.checkCollisions(activePoints:
                            poseManager.wristPoints.map { poseManager.toScreen($0, in: geo.size) })
                    }
                    #if DEBUG
                    .onTapGesture { location in
                        gameEngine.injectTap(at: location)
                    }
                    #endif
                }
                .ignoresSafeArea()
                VStack {
                    GameHUDView(
                        gameEngine: gameEngine,
                        scenario: router.selectedScenario ?? ScenarioRepository.defaultScenario,
                        onExit: { router.currentScreen = .outro }
                    )
                    Spacer()
                }
            }
            .onAppear {
                let scenario = router.selectedScenario ?? ScenarioRepository.defaultScenario
                gameEngine.configure(scenario: scenario, screenSize: geo.size)
            }
            .onChange(of: geo.size) { _, newSize in
                guard newSize != .zero else { return }
                gameEngine.updateScreenSize(newSize)
            }
        }
        .task {
            cameraManager.start()
            poseManager.connect(to: cameraManager.sampleBufferPublisher)
        }
        .onAppear {
            if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                cameraManager.updateOrientation(scene.interfaceOrientation)
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) { _ in
            if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                cameraManager.updateOrientation(scene.interfaceOrientation)
            }
        }
        .onDisappear { cameraManager.stop() }
        .ignoresSafeArea()
    }
}
