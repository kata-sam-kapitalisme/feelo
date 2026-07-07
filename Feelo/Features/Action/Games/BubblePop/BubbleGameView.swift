import SwiftUI
import UIKit

struct BubbleGameView: View {
    @Environment(Router.self) private var router
    @State private var cameraManager = CameraManager()
    @State private var poseManager   = PoseManager()
    @State private var gameEngine    = GameEngine()
    @State private var showTutorial  = true

    var body: some View {
        GeometryReader { geo in
            ZStack {
                CameraView(cameraManager: cameraManager).ignoresSafeArea()
                GifImageView(name: "Background Bubble")
                    .ignoresSafeArea()
                    .blendMode(.screen)
                    .opacity(1)
                TimelineView(.animation) { timeline in
                    Canvas { context, size in
                        let bubbleImage = context.resolve(Image("bubble"))
                        let splashImage = context.resolve(Image("bubble-splash"))
                        for bubble in gameEngine.bubbles {
                            let r = bubble.isPopped ? bubble.radius : bubble.currentRadius()
                            let rect = CGRect(
                                x: bubble.position.x - r,
                                y: bubble.position.y - r,
                                width: r * 2,
                                height: r * 2
                            )
                            if bubble.isPopped, let poppedAt = bubble.poppedAt {
                                let elapsed = Date().timeIntervalSince(poppedAt)
                                let alpha = max(0, 1 - elapsed / 0.35)
                                var splashCtx = context
                                splashCtx.opacity = alpha
                                let splashRect = rect.insetBy(dx: -bubble.radius * 0.3, dy: -bubble.radius * 0.3)
                                splashCtx.draw(splashImage, in: splashRect)
                            } else if !bubble.isPopped {
                                context.draw(bubbleImage, in: rect)
                            }
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
                //tambahan tutorial
                VStack {
                    HStack {
                        Spacer()
                        TutorialOverlayView(isVisible: showTutorial).padding(.top, 90).padding(.trailing, 16)
                    }
                    Spacer()
                }
            }
            .onAppear {
                let scenario = router.selectedScenario ?? ScenarioRepository.defaultScenario
                gameEngine.configure(scenario: scenario, screenSize: geo.size)
                //tambahan pop up tutorial 7 sec
                Task {
                    try? await Task.sleep(for: .seconds(7))
                    showTutorial = false
                }
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
