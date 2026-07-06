import SwiftUI
import UIKit

struct PumpBallView: View {
    @Environment(Router.self) private var router
    @State private var cameraManager = CameraManager()
    @State private var poseManager   = PoseManager()
    @State private var gameEngine    = PumpGameEngine()

    // Normalized average wrist Y from Vision (0 = bottom, 1 = top)
    private var normalizedWristY: CGFloat {
        guard !poseManager.wristPoints.isEmpty else { return 0.5 }
        return poseManager.wristPoints.map(\.y).reduce(0, +) / CGFloat(poseManager.wristPoints.count)
    }

    var body: some View {
        GeometryReader { geo in
            ZStack {
                // Layer 1: Camera background
                CameraView(cameraManager: cameraManager).ignoresSafeArea()

                // Layer 2: GIF background
                GifImageView(name: "Background Bubble")
                    .ignoresSafeArea()
                    .blendMode(.screen)

                // Layer 3: Pump
                VStack {
                    Spacer()
                    HStack(alignment: .bottom, spacing: 0) {
                        Spacer().frame(width: geo.size.width * 0.30)
                        Image(gameEngine.isHandsUp ? "pompa_naik" : "pompa_turun")
                            .resizable()
                            .scaledToFit()
                            .frame(height: gameEngine.isHandsUp ? geo.size.height * 0.55 : geo.size.height * 0.45)
                            .animation(.easeInOut(duration: 0.15), value: gameEngine.isHandsUp)
                        Spacer()
                    }
                    .padding(.bottom, 16)
                }

                // Layer 4: Ball (conditional states)
                ZStack {
                    if !gameEngine.isGameFinished {
                        // Deflated/inflating ball
                        VStack {
                            Spacer()
                            HStack(alignment: .bottom, spacing: 0) {
                                Spacer().frame(width: geo.size.width * 0.43)
                                Image("bola_kempes")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: geo.size.height * 0.25)
                                    .scaleEffect(0.4 + 0.4 * gameEngine.inflationProgress, anchor: .bottom)
                                    .animation(.spring(response: 0.35, dampingFraction: 0.6), value: gameEngine.inflationProgress)
                                Spacer()
                            }
                            .padding(.bottom, 24)
                        }
                        .transition(.opacity)
                    } else {
                        // Fully inflated ball (game complete)
                        VStack {
                            Spacer()
                            HStack(alignment: .bottom, spacing: 0) {
                                Spacer().frame(width: geo.size.width * 0.48)
                                Image("bola_full")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: geo.size.height * 0.28)
                                Spacer()
                            }
                            .padding(.bottom, 24) // aligns with bola_kempes baseline
                        }
                        .transition(.opacity)
                    }
                }
                .animation(.easeInOut(duration: 0.35), value: gameEngine.isGameFinished)

                /*
                // Layer 4: Wrist tracking dots (always visible for now)
                Canvas { context, size in
                    for normalized in poseManager.wristPoints {
                        let pt = poseManager.toScreen(normalized, in: size)
                        let r: CGFloat = 22
                        let dot = CGRect(x: pt.x - r, y: pt.y - r, width: r * 2, height: r * 2)
                        context.fill(Path(ellipseIn: dot), with: .color(.yellow.opacity(0.85)))
                        context.stroke(Path(ellipseIn: dot), with: .color(.white), lineWidth: 3)
                    }
                }
                .ignoresSafeArea()
                .allowsHitTesting(false)
                */

                // Layer 5: Instructions (hidden when game is done)
                if !gameEngine.isGameFinished {
                    VStack {
                        ZStack {
                            Image("cloud_bubble")
                                .resizable()
                                .scaledToFit()
                                .frame(width: geo.size.width * 0.55)

                            // Fallback card — always visible even without the asset
                            RoundedRectangle(cornerRadius: 20)
                                .fill(.white.opacity(0.88))
                                .frame(width: geo.size.width * 0.52, height: 80)
                                .shadow(color: .black.opacity(0.12), radius: 8, y: 4)

                            VStack(spacing: 4) {
                                Text("Yuk, Pompa Bolanya!")
                                    .font(.title3).bold()
                                Text("Gerakkan tanganmu naik dan turun\nuntuk memompa bola!")
                                    .font(.subheadline)
                                    .multilineTextAlignment(.center)
                            }
                        }
                        .padding(.top, 20)
                        Spacer()
                    }
                }

                /*
                // Layer 6: Debug HUD (hand position + progress)
                VStack {
                    Spacer()
                    HStack(alignment: .bottom) {
                        debugHUD
                        Spacer()
                    }
                    .padding(.leading, 20)
                    .padding(.bottom, 20)
                }
                */
            }
            .onChange(of: poseManager.wristPoints) { _, newPoints in
                gameEngine.processWrists(newPoints)
            }
            .onChange(of: gameEngine.isGameFinished) { _, finished in
                if finished {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        router.currentScreen = .outro
                    }
                }
            }
            #if DEBUG
            .onTapGesture {
                gameEngine.registerPump()
            }
            #endif
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

    // MARK: - Debug HUD

    private var debugHUD: some View {
        VStack(alignment: .leading, spacing: 10) {
            // Hand detection status
            HStack(spacing: 8) {
                Circle()
                    .fill(poseManager.wristPoints.isEmpty ? Color.red : Color.green)
                    .frame(width: 12, height: 12)
                Text(poseManager.wristPoints.isEmpty
                     ? "No hands detected"
                     : "\(poseManager.wristPoints.count) hand(s) detected")
                    .font(.system(size: 13, weight: .semibold, design: .monospaced))
                    .foregroundStyle(.white)
            }

            // Wrist height bar
            if !poseManager.wristPoints.isEmpty {
                VStack(alignment: .leading, spacing: 4) {
                    Text(String(format: "Wrist Y: %.2f", normalizedWristY))
                        .font(.system(size: 12, design: .monospaced))
                        .foregroundStyle(.white)

                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(.white.opacity(0.25))
                            .frame(width: 140, height: 10)
                        RoundedRectangle(cornerRadius: 4)
                            .fill(wristBarColor)
                            .frame(width: 140 * normalizedWristY, height: 10)
                    }

                    // Threshold markers
                    HStack(spacing: 0) {
                        Spacer().frame(width: 140 * 0.4)
                        Rectangle().fill(.yellow).frame(width: 1, height: 6)
                        Spacer().frame(width: 140 * 0.2 - 2)
                        Rectangle().fill(.yellow).frame(width: 1, height: 6)
                        Spacer()
                    }
                    .frame(width: 140)
                }
            }

            // Pump state indicator
            HStack(spacing: 8) {
                Image(systemName: gameEngine.isHandsUp ? "arrow.up.circle.fill" : "arrow.down.circle.fill")
                    .foregroundStyle(gameEngine.isHandsUp ? .green : .orange)
                    .font(.system(size: 16))
                Text(gameEngine.isHandsUp ? "Hands UP" : "Hands DOWN")
                    .font(.system(size: 13, weight: .semibold, design: .monospaced))
                    .foregroundStyle(gameEngine.isHandsUp ? .green : .orange)
            }

            // Pump progress dots
            HStack(spacing: 6) {
                Text("Pumps:")
                    .font(.system(size: 12, design: .monospaced))
                    .foregroundStyle(.white)
                ForEach(0..<gameEngine.requiredPumps, id: \.self) { i in
                    Circle()
                        .fill(i < gameEngine.pumpCount ? Color.green : Color.white.opacity(0.35))
                        .frame(width: 16, height: 16)
                        .overlay(
                            Circle().stroke(Color.white.opacity(0.6), lineWidth: 1.5)
                        )
                }
            }
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(.black.opacity(0.55))
        )
    }

    private var wristBarColor: Color {
        if normalizedWristY > 0.6 { return .green }
        if normalizedWristY < 0.4 { return .orange }
        return .yellow
    }
}
