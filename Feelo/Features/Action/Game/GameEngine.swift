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

        if bubbles.isEmpty || bubbles.allSatisfy({ $0.isPopped }) {
            spawnWave()
        }
    }

    private func spawnWave() {
        guard screenSize.width > 0 else { return }
        waveCount += 1
        let count = 4
        var newBubbles: [Bubble] = []
        let padding: CGFloat = 60
        let yRange: ClosedRange<CGFloat> = -200...(-50)
        for _ in 0..<count {
            let x = CGFloat.random(in: padding...(screenSize.width - padding))
            let y = CGFloat.random(in: yRange)
            newBubbles.append(Bubble(
                id: UUID(),
                position: CGPoint(x: x, y: y),
                radius: CGFloat.random(in: 36...54),
                color: bubbleColor
            ))
        }
        bubbles = newBubbles
    }

    private func updatePositions(dt: Double) {
        let speed: CGFloat = 80
        for i in bubbles.indices {
            guard !bubbles[i].isPopped else { continue }
            bubbles[i].position.y += speed * dt
            // Wrap off-screen bottom back to top
            if bubbles[i].position.y > screenSize.height + 60 {
                bubbles[i].position.y = -60
                bubbles[i].position.x = CGFloat.random(in: 60...(screenSize.width - 60))
            }
        }
    }

    func checkCollisions(activePoints: [CGPoint]) {
        guard !activePoints.isEmpty else { return }
        var didPop = false
        for i in bubbles.indices {
            guard !bubbles[i].isPopped else { continue }
            for point in activePoints {
                let dx = bubbles[i].position.x - point.x
                let dy = bubbles[i].position.y - point.y
                let distance = sqrt(dx * dx + dy * dy)
                if distance < bubbles[i].radius {
                    bubbles[i].isPopped = true
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
