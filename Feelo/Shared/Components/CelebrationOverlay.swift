//
//  CelebrationOverlay.swift
//  Feelo
//
//  Created by Rafi Rasendrya Favian on 07/07/26.
//

import SwiftUI

struct CelebrationOverlay: View {
    let score: Int
    let goalMet: Bool
    let onExit: () -> Void
    
    @State private var scale: CGFloat = 0.5
    @State private var countdown: Int = 5
    @State private var hasExited: Bool = false
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.65)
                .ignoresSafeArea()
                .contentShape(Rectangle())
                .onTapGesture { triggerExit() }
            
            ConfettiView()
            
            VStack(spacing: 28) {
                Text(goalMet ? "HEBAT!" : "Bagus!")
                    .font(.system(size: 72, weight: .black))
                    .foregroundStyle(goalMet ? .yellow : .white)
                    .shadow(color: .black.opacity(0.4), radius: 6)
                
                Text(goalMet ? "Kamu luar biasa!" : "Kerja bagus!")
                    .font(.title)
                    .foregroundStyle(.white)
                
                Text("Melanjutkan dalam \(countdown)...")
                    .font(.headline)
                    .foregroundStyle(.white.opacity(0.7))
                    .padding(.top, 20)
            }
            .padding(40)
            .scaleEffect(scale)
            .onAppear {
                withAnimation(.spring(duration: 0.6)) { scale = 1.0 }
                SoundManager.shared.playSound(named: "confetti_sound")
                startCountdown()
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
        onExit()
    }
}

struct ConfettiView: View {
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
        .onAppear { animate = true }
    }
}
