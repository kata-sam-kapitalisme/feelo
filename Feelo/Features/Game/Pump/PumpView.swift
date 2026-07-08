import SwiftUI
import UIKit

struct PumpView: View {
    @Environment(AppNav.self) private var nav

    @State private var camera = CameraSvc()
    @State private var pose = PoseSvc()
    @State private var engine = PumpEngine()
    @State private var showTutorial = true
    @State private var showDone = false

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
                    .opacity(0.30)

                GifView(name: AssetName.Gif.bubBg)
                    .frame(width: geo.size.width, height: bgH)
                    .offset(y: bgOffset)
                    .ignoresSafeArea()
                    .blendMode(.screen)

                pumpImage(geo)
                    .frame(height: geo.size.height)
                ballImage(geo)
                    .frame(height: geo.size.height)

                if !engine.finished {
                    guideCard(geo)
                        .zIndex(20)
                }

                if showDone {
                    DoneOverlay(
                        score: engine.goal,
                        success: true
                    ) {
                        nav.finishGame()
                    }
                    .transition(
                        .opacity.combined(with: .scale)
                    )
                    .animation(
                        .spring(duration: 0.5),
                        value: showDone
                    )
                    .zIndex(100)
                }

                VStack {
                    HStack {
                        Spacer()

                        HintCard(
                            gif: AssetName.Gif.pumpTut,
                            show: showTutorial
                        )
                        .padding(.top, 90)
                        .padding(.trailing, 16)
                    }

                    Spacer()
                }
                .zIndex(30)
            }
            .onAppear {
                Task {
                    try? await Task.sleep(
                        nanoseconds: AppConst.Time.tutorialNs
                    )

                    showTutorial = false
                }
            }
            .onChange(of: pose.points) { _, points in
                engine.updateHands(points)
            }
            .onChange(of: engine.finished) { _, isFinished in
                if isFinished {
                    DispatchQueue.main.asyncAfter(
                        deadline: .now() + AppConst.Time.doneDelay
                    ) {
                        showDone = true
                    }
                }
            }
            #if DEBUG
            .onTapGesture {
                engine.pump()
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

    private func pumpImage(_ geo: GeometryProxy) -> some View {
        VStack {
            Spacer()

            HStack(alignment: .bottom, spacing: 0) {
                Spacer()
                    .frame(
                        width: geo.size.width * AppConst.PumpLayout.pumpLead
                    )

                Image(
                    engine.handsUp
                    ? AssetName.Img.pumpUp
                    : AssetName.Img.pumpDown
                )
                .resizable()
                .scaledToFit()
                .frame(
                    height: engine.handsUp
                    ? geo.size.height * AppConst.PumpLayout.pumpUpH
                    : geo.size.height * AppConst.PumpLayout.pumpDownH
                )
                .animation(
                    .easeInOut(duration: 0.15),
                    value: engine.handsUp
                )

                Spacer()
            }
            .padding(.bottom, 16)
        }
    }

    private func ballImage(_ geo: GeometryProxy) -> some View {
        ZStack {
            if !engine.finished {
                VStack {
                    Spacer()

                    HStack(alignment: .bottom, spacing: 0) {
                        Spacer()
                            .frame(
                                width: geo.size.width * AppConst.PumpLayout.flatBallLead
                            )

                        Image(AssetName.Img.ballFlat)
                            .resizable()
                            .scaledToFit()
                            .frame(
                                height: geo.size.height * AppConst.PumpLayout.flatBallH
                            )
                            .scaleEffect(
                                AppConst.PumpLayout.flatBallMinScale
                                + AppConst.PumpLayout.flatBallGrowScale * engine.progress,
                                anchor: .bottom
                            )
                            .animation(
                                .spring(
                                    response: 0.35,
                                    dampingFraction: 0.6
                                ),
                                value: engine.progress
                            )

                        Spacer()
                    }
                    .padding(.bottom, 24)
                }
                .transition(.opacity)
            } else {
                VStack {
                    Spacer()

                    HStack(alignment: .bottom, spacing: 0) {
                        Spacer()
                            .frame(
                                width: geo.size.width * AppConst.PumpLayout.fullBallLead
                            )

                        Image(AssetName.Img.ballFull)
                            .resizable()
                            .scaledToFit()
                            .frame(
                                height: geo.size.height * AppConst.PumpLayout.fullBallH
                            )

                        Spacer()
                    }
                    .padding(.bottom, 24)
                }
                .transition(.opacity)
            }
        }
        .animation(
            .easeInOut(duration: 0.35),
            value: engine.finished
        )
    }

    private func guideCard(_ geo: GeometryProxy) -> some View {
        VStack {
            VStack(spacing: AppConst.PumpLayout.guideSpace) {
                Text("Yuk, Pompa Bolanya!")
                    .font(AppFont.bold(AppConst.PumpLayout.guideTitleFont))
                    .lineLimit(1)
                    .minimumScaleFactor(0.72)

                Text("Gerakkan tanganmu naik dan turun\nuntuk memompa bola!")
                    .font(AppFont.semi(AppConst.PumpLayout.guideTextFont))
                    .multilineTextAlignment(.center)
                    .minimumScaleFactor(0.72)
            }
            .foregroundStyle(.black)
            .padding(.horizontal, AppConst.PumpLayout.guidePadX)
            .padding(.vertical, AppConst.PumpLayout.guidePadY)
            .frame(
                width: geo.size.width * AppConst.PumpLayout.guideBoxW,
                height: min(
                    AppConst.PumpLayout.guideMaxH,
                    max(
                        AppConst.PumpLayout.guideMinH,
                        geo.size.height * AppConst.PumpLayout.guideBoxH
                    )
                )
            )
            .background {
                RoundedRectangle(cornerRadius: 20)
                    .fill(.white.opacity(0.88))
                    .shadow(
                        color: .black.opacity(0.12),
                        radius: 8,
                        x: 0,
                        y: 4
                    )
            }
            .padding(.top, geo.safeAreaInsets.top + AppConst.PumpLayout.guideTopPad)

            Spacer()
        }
        .frame(
            maxWidth: .infinity,
            maxHeight: .infinity,
            alignment: .top
        )
    }

    private func updateCameraOrientation() {
        guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return
        }

        camera.setOrientation(scene.interfaceOrientation)
    }
}
