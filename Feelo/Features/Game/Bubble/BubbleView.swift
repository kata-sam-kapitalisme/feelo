import SwiftUI
import UIKit

struct BubbleView: View {
    @Environment(AppNav.self) private var nav

    @State private var camera = CameraSvc()
    @State private var pose = PoseSvc()
    @State private var engine = BubbleEngine()
    @State private var showTutorial = true
    @State private var showPreparation = true

    var body: some View {
        GeometryReader { geo in
            let bgH = geo.size.width * AppConst.Ref.h / AppConst.Ref.w
            let bgOffset = -max(0, bgH - geo.size.height)

            ZStack {
                CameraView(camera: camera)
                    .ignoresSafeArea()

                Image(AssetName.Img.bgSky)
                    .resizable()
                    .frame(width: geo.size.width, height: bgH)
                    .offset(y: bgOffset)
                    .ignoresSafeArea()
                    .opacity(0.15)

                GifView(name: AssetName.Gif.bubBg)
                    .frame(width: geo.size.width, height: bgH)
                    .offset(y: bgOffset)
                    .ignoresSafeArea()
                    .blendMode(.screen)

                bubbleLayer(geo)

                VStack {
                    BubbleHUD(engine: engine) { success in
                        if success {
                            nav.finishGame()
                        } else {
                            nav.screen = .scene
                        }
                    }

                    Spacer()
                }

                if !showPreparation {
                    VStack {
                        HStack {
                            Spacer()

                            HintCard(
                                gif: AssetName.Gif.bubTut,
                                show: showTutorial
                            )
                            .padding(.top, 90)
                            .padding(.trailing, 16)
                        }

                        Spacer()
                    }
                }

                if showPreparation {
                    PreparationOverlay {
                        withAnimation(.easeInOut(duration: 0.35)) {
                            showPreparation = false
                        }
                        engine.start()
                    }
                    .zIndex(150)
                    .transition(.opacity)
                }
            }
            .onAppear {
                let item = nav.scenario ?? ScenarioRepo.first

                engine.configure(
                    scenario: item,
                    size: geo.size
                )
            }
            .onChange(of: showPreparation) { _, isPrep in
                if !isPrep {
                    Task {
                        try? await Task.sleep(
                            nanoseconds: AppConst.Time.tutorialNs
                        )

                        showTutorial = false
                    }
                }
            }
            .onChange(of: geo.size) { _, newSize in
                guard newSize != .zero else {
                    return
                }

                engine.resize(newSize)
            }
            #if DEBUG
            .onTapGesture { point in
                guard !showPreparation else { return }
                engine.debugTap(point)
            }
            #endif
        }
        .task {
            camera.start()
            pose.bind(camera.frames)
        }
        .onAppear {
            updateCameraOrientation()
        }
        .onReceive(
            NotificationCenter.default.publisher(
                for: UIDevice.orientationDidChangeNotification
            )
        ) { _ in
            updateCameraOrientation()
        }
        .onDisappear {
            camera.stop()
        }
        .ignoresSafeArea()
    }

    private func bubbleLayer(_ geo: GeometryProxy) -> some View {
        TimelineView(.animation) { timeline in
            Canvas { context, _ in
                let bubbleImage = context.resolve(
                    Image(AssetName.Img.bubble)
                )

                let splashImage = context.resolve(
                    Image(AssetName.Img.bubSplash)
                )

                for bubble in engine.bubbles {
                    let radius = bubble.popped
                        ? bubble.radius
                        : bubble.currentRadius()

                    let rect = CGRect(
                        x: bubble.position.x - radius,
                        y: bubble.position.y - radius,
                        width: radius * 2,
                        height: radius * 2
                    )

                    if bubble.popped,
                       let poppedAt = bubble.poppedAt {
                        let elapsed = Date().timeIntervalSince(poppedAt)
                        let alpha = max(
                            0,
                            1 - elapsed / AppConst.Time.splashDur
                        )

                        var popContext = context
                        popContext.opacity = alpha

                        let popRect = rect.insetBy(
                            dx: -bubble.radius * 0.3,
                            dy: -bubble.radius * 0.3
                        )

                        popContext.draw(
                            splashImage,
                            in: popRect
                        )
                    } else if !bubble.popped {
                        context.draw(
                            bubbleImage,
                            in: rect
                        )
                    }
                }
            }
            .onChange(of: timeline.date) { oldDate, newDate in
                guard !showPreparation else { return }

                engine.update(
                    dt: max(
                        0,
                        min(newDate.timeIntervalSince(oldDate), 0.1)
                    )
                )

                let screenPoints = pose.points.map {
                    pose.screenPoint(
                        $0,
                        in: geo.size
                    )
                }

                engine.hit(points: screenPoints)
            }
        }
        .ignoresSafeArea()
    }

    private func updateCameraOrientation() {
        guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return
        }

        camera.setOrientation(scene.interfaceOrientation)
    }
}
