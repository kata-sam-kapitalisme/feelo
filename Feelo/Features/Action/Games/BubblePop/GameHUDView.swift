import SwiftUI

struct GameHUDView: View {
    let gameEngine: GameEngine
    let scenario: Scenario
    let onExit: () -> Void
    
    @State private var showCelebration = false
    
    private let goalScore = 4
    private var progress: Double {
        guard scenario.gameplayDurationSeconds > 0 else { return 0 }
        return gameEngine.timeRemaining / scenario.gameplayDurationSeconds
    }
    private var isComplete: Bool {
        gameEngine.isFinished || gameEngine.score >= goalScore
    }
    
    var body: some View {
        ZStack {
            // HUD bar
            VStack(spacing: 0) {
                // Timer progress bar
                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        Rectangle()
                            .fill(Color.white.opacity(0.3))
                        Rectangle()
                            .fill(timerColor)
                            .frame(width: geo.size.width * max(0, progress))
                            .animation(.linear(duration: 0.1), value: progress)
                    }
                }
                .frame(height: 10)
                
                // Score & timer display
                HStack {
                    // Star counter
                    HStack(spacing: 4) {
                        Image(systemName: "star.fill")
                            .foregroundStyle(.yellow)
                        Text("\(gameEngine.score)")
                            .font(.title2.bold())
                            .foregroundStyle(.white)
                            .contentTransition(.numericText())
                            .animation(.bouncy, value: gameEngine.score)
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(.black.opacity(0.4), in: Capsule())
                    
                    Spacer()
                    
                    // Time remaining
                    Text(timeString)
                        .font(.title3.bold())
                        .foregroundStyle(.white)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(.black.opacity(0.4), in: Capsule())
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
            }
            .background(.ultraThinMaterial.opacity(0.6))
            
            // Celebration overlay
            if isComplete {
                CelebrationOverlay(
                    score: gameEngine.score,
                    goalMet: gameEngine.score >= goalScore,
                    onExit: onExit
                    // Sementara ini di command dulu, dibutuhkan kalo mau testing
                    //                    bubbleColor: scenario.bubbleColor,
                    //                    onReplay: { gameEngine.reset(scenario: scenario) },

                )
                .transition(.opacity.combined(with: .scale))
                .animation(.spring(duration: 0.5), value: isComplete)
            }
        }
        .onChange(of: isComplete) { _, complete in
            if complete { showCelebration = true }
        }
    }
    
    private var timerColor: Color {
        progress > 0.5 ? .green : progress > 0.25 ? .yellow : .red
    }
    
    private var timeString: String {
        let t = Int(gameEngine.timeRemaining)
        return String(format: "%d:%02d", t / 60, t % 60)
    }
}

private struct CelebrationOverlay: View {
    let score: Int
    let goalMet: Bool
    //    let bubbleColor: Color
    //    let onReplay: () -> Void
    let onExit: () -> Void
    
    @State private var scale: CGFloat = 0.5
    @State private var countdown: Int = 6
    @State private var hasExited: Bool = false
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.65)
                .ignoresSafeArea()
                .contentShape(Rectangle())
                .onTapGesture {
                    triggerExit()
                }
            
            // Animasi Confetti di belakang teks
            ConfettiView()
            
            //            VStack(spacing: 28) {
            //                Text(goalMet ? "HEBAT!" : "Bagus!")
            //                    .font(.system(size: 72, weight: .black))
            //                    .foregroundStyle(goalMet ? .yellow : .white)
            //                    .shadow(color: .black.opacity(0.4), radius: 6)
            //
            //                Text(goalMet ? "Kamu luar biasa!" : "Coba lagi yuk!")
            //                    .font(.title)
            //                    .foregroundStyle(.white)
            //
            //                HStack(spacing: 6) {
            //                    ForEach(0..<max(1, score), id: \.self) { _ in
            //                        Image(systemName: "star.fill")
            //                            .font(.title)
            //                            .foregroundStyle(.yellow)
            //                    }
            //                }
            //
            //                HStack(spacing: 20) {
            //                    Button(action: onReplay) {
            //                        Label("Main Lagi!", systemImage: "arrow.clockwise")
            //                            .font(.title2.bold())
            //                            .padding(.horizontal, 28)
            //                            .padding(.vertical, 14)
            //                            .background(bubbleColor, in: Capsule())
            //                            .foregroundStyle(.white)
            //                    }
            //
            //                    Button(action: onExit) {
            //                        Label("Selesai", systemImage: "house.fill")
            //                            .font(.title2.bold())
            //                            .padding(.horizontal, 28)
            //                            .padding(.vertical, 14)
            //                            .background(.white.opacity(0.2), in: Capsule())
            //                            .foregroundStyle(.white)
            //                    }
            //                }
            //            }
            
            VStack(spacing: 28) {
                Text(goalMet ? "HEBAT!" : "Bagus!")
                    .font(.system(size: 72, weight: .black))
                    .foregroundStyle(goalMet ? .yellow : .white)
                    .shadow(color: .black.opacity(0.4), radius: 6)
                
                Text(goalMet ? "Kamu luar biasa!" : "Kerja bagus!")
                    .font(.title)
                    .foregroundStyle(.white)
                HStack(spacing: 6) {
                    ForEach(0..<max(1, score), id: \.self) { _ in
                        Image(systemName: "star.fill")
                            .font(.title)
                            .foregroundStyle(.yellow)
                    }
                }

                HStack(spacing: 20) {
                    Button(action: {
                        SoundManager.shared.playClick()
                        onReplay()
                    }) {
                        Label("Main Lagi!", systemImage: "arrow.clockwise")
                            .font(.title2.bold())
                            .padding(.horizontal, 28)
                            .padding(.vertical, 14)
                            .background(bubbleColor, in: Capsule())
                            .foregroundStyle(.white)
                    }

                    Button(action: {
                        SoundManager.shared.playClick()
                        onExit()
                    }) {
                        Label("Selesai", systemImage: "house.fill")
                            .font(.title2.bold())
                            .padding(.horizontal, 28)
                            .padding(.vertical, 14)
                            .background(.white.opacity(0.2), in: Capsule())
                            .foregroundStyle(.white)
                    }
                }

                // Teks Countdown
                Text("Melanjutkan dalam \(countdown)...")
                    .font(.headline)
                    .foregroundStyle(.white.opacity(0.7))
                    .padding(.top, 20)
                    .id("CountdownText")
            }
            .padding(40)
            .scaleEffect(scale)
            .onAppear {
                withAnimation(.spring(duration: 0.6)) { scale = 1.0 }
                SoundManager.shared.playSound(named: "confetti_sound")
                startCountdown()
            }
        }
        .onReceive(timer) { _ in
            if countdown > 1 {
                countdown -= 1
            } else {
                triggerExit()
            }
        }
    }
    
    private func startCountdown() {
        Task {
            while countdown > 0 {
                try? await Task.sleep(nanoseconds: 1_000_000_000)
                
                await MainActor.run {
                    if countdown > 1 {
                        countdown -= 1
                    } else {
                        countdown = 0
                        triggerExit()
                    }
                }
            }
        }
    }
    
    private func triggerExit() {
        guard !hasExited else { return }
        hasExited = true
        timer.upstream.connect().cancel() // Hentikan timer
        onExit()
    }
}

private struct ConfettiView: View {
    @State private var animate = false
    private let colors: [Color] = [.red, .blue, .green, .yellow, .pink, .purple, .orange]
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ForEach(0..<60, id: \.self) { _ in
                    Rectangle()
                        .fill(colors.randomElement() ?? .yellow)
                        .frame(width: CGFloat.random(in: 6...12), height: CGFloat.random(in: 6...12))
                        .position(
                            x: CGFloat.random(in: 0...geometry.size.width),
                            y: animate ? geometry.size.height + 50 : -50
                        )
                        .rotationEffect(.degrees(animate ? Double.random(in: 180...720) : 0))
                        .animation(
                            .linear(duration: Double.random(in: 2...4))
                            .repeatForever(autoreverses: false)
                            .delay(Double.random(in: 0...1.5)),
                            value: animate
                        )
                }
            }
        }
        .ignoresSafeArea()
        .allowsHitTesting(false)
        .onAppear {
            animate = true
        }
    }
}
