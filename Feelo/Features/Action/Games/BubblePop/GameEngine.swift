import SwiftUI
import UIKit

@Observable
final class GameEngine {
    var bubbles: [Bubble] = []
    var score: Int = 0
    var timeRemaining: Double = 30
    var isFinished: Bool = false

    private var screenSize: CGSize = .zero
    private var bubbleColor: Color = .red
    private let impactFeedback = UIImpactFeedbackGenerator(style: .light)
    private var waveCount: Int = 0

    func configure(scenario: Scenario, screenSize: CGSize) {
        self.screenSize = screenSize
        self.bubbleColor = scenario.bubbleColor
        self.timeRemaining = scenario.gameplayDurationSeconds
        self.score = 0
        self.isFinished = false
        self.bubbles = []
        self.waveCount = 0
        impactFeedback.prepare()
        spawnWave()
    }

    func update(dt: Double) {
        guard !isFinished else { return }

        timeRemaining -= dt
        if timeRemaining <= 0 {
            timeRemaining = 0
            isFinished = true
            return
        }

        updatePositions(dt: dt)

        // Remove bubbles whose splash animation has finished (0.35s window)
        let splashDuration: TimeInterval = 0.35
        bubbles.removeAll { bubble in
            guard bubble.isPopped, let poppedAt = bubble.poppedAt else { return false }
            return Date().timeIntervalSince(poppedAt) > splashDuration
        }

        if bubbles.isEmpty || bubbles.allSatisfy({ $0.isPopped }) {
            spawnWave()
        }
    }

    private func spawnWave() {
        guard screenSize.width > 0 else { return }
        waveCount += 1
        let count = 4
        var newBubbles: [Bubble] = []
        let padding: CGFloat = 70
        for _ in 0..<count {
            let x = CGFloat.random(in: padding...(screenSize.width - padding))
            let y = CGFloat.random(in: padding...(screenSize.height - padding))
            let angle = CGFloat.random(in: 0...(2 * .pi))
            let speed = CGFloat.random(in: 40...80)
            newBubbles.append(Bubble(
                id: UUID(),
                position: CGPoint(x: x, y: y),
                radius: CGFloat.random(in: 36...54),
                color: bubbleColor,
                spawnedAt: Date(),
                velocity: CGPoint(x: cos(angle) * speed, y: sin(angle) * speed)
            ))
        }
        bubbles = newBubbles
    }

    private func updatePositions(dt: Double) {
        for i in bubbles.indices {
            guard !bubbles[i].isPopped else { continue }
            bubbles[i].position.x += bubbles[i].velocity.x * dt
            bubbles[i].position.y += bubbles[i].velocity.y * dt
            // Bounce off edges
            let r = bubbles[i].radius
            if bubbles[i].position.x - r < 0 {
                bubbles[i].position.x = r
                bubbles[i].velocity.x = abs(bubbles[i].velocity.x)
            } else if bubbles[i].position.x + r > screenSize.width {
                bubbles[i].position.x = screenSize.width - r
                bubbles[i].velocity.x = -abs(bubbles[i].velocity.x)
            }
            if bubbles[i].position.y - r < 0 {
                bubbles[i].position.y = r
                bubbles[i].velocity.y = abs(bubbles[i].velocity.y)
            } else if bubbles[i].position.y + r > screenSize.height {
                bubbles[i].position.y = screenSize.height - r
                bubbles[i].velocity.y = -abs(bubbles[i].velocity.y)
            }
        }
    }

    func checkCollisions(activePoints: [CGPoint]) {
        guard !activePoints.isEmpty else { return }
        var didPop = false
        for i in bubbles.indices {
            guard !bubbles[i].isPopped else { continue }
            let hitRadius = bubbles[i].currentRadius()
            guard hitRadius > 4 else { continue }  // not visible enough to hit yet
            for point in activePoints {
                let dx = bubbles[i].position.x - point.x
                let dy = bubbles[i].position.y - point.y
                let distance = sqrt(dx * dx + dy * dy)
                if distance < hitRadius {
                    bubbles[i].isPopped = true
                    bubbles[i].poppedAt = Date()
                    score += 1
                    didPop = true
                    break
                }
            }
        }
        if didPop {
            impactFeedback.impactOccurred()
        }
    }

    #if DEBUG
    func injectTap(at point: CGPoint) {
        checkCollisions(activePoints: [point])
    }
    #endif

    func updateScreenSize(_ size: CGSize) {
        screenSize = size
        if bubbles.isEmpty { spawnWave() }
    }

    func reset(scenario: Scenario) {
        configure(scenario: scenario, screenSize: screenSize)
    }
}
