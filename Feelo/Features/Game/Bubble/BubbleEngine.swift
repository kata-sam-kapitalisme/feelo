import Observation
import SwiftUI
import UIKit

@Observable
final class BubbleEngine {
    var bubbles: [Bubble] = []
    var score = 0
    var timeLeft: Double = 260
    var finished = false

    private var size: CGSize = .zero
    private var color: Color = .blue
    private let impact = UIImpactFeedbackGenerator(style: .light)

    func configure(
        scenario: Scenario,
        size: CGSize
    ) {
        self.size = size
        self.color = scenario.bubbleColor
        self.timeLeft = scenario.duration

        score = 0
        finished = false
        bubbles = []

        impact.prepare()
        spawnWave()
    }

    func update(dt: Double) {
        guard !finished else {
            return
        }

        timeLeft -= dt

        if timeLeft <= 0 {
            timeLeft = 0
            finished = true
            return
        }

        moveBubbles(dt: dt)

        bubbles.removeAll { bubble in
            guard bubble.popped,
                  let poppedAt = bubble.poppedAt
            else {
                return false
            }

            return Date().timeIntervalSince(poppedAt) > AppConst.Time.splashDur
        }

        if bubbles.isEmpty || bubbles.allSatisfy(\.popped) {
            spawnWave()
        }
    }

    func hit(points: [CGPoint]) {
        guard !points.isEmpty else {
            return
        }

        var didHit = false

        for index in bubbles.indices {
            guard !bubbles[index].popped else {
                continue
            }

            let radius = bubbles[index].currentRadius()

            guard radius > 4 else {
                continue
            }

            for point in points {
                let dx = bubbles[index].position.x - point.x
                let dy = bubbles[index].position.y - point.y
                let distance = sqrt(dx * dx + dy * dy)

                if distance < radius {
                    bubbles[index].popped = true
                    bubbles[index].poppedAt = Date()
                    score += 1
                    SoundSvc.shared.bubblePop()
                    didHit = true
                    break
                }
            }
        }

        if didHit {
            impact.impactOccurred()
        }
    }

    #if DEBUG
    func debugTap(_ point: CGPoint) {
        hit(points: [point])
    }
    #endif

    func resize(_ newSize: CGSize) {
        size = newSize

        if bubbles.isEmpty {
            spawnWave()
        }
    }

    func reset(scenario: Scenario) {
        configure(
            scenario: scenario,
            size: size
        )
    }

    private func spawnWave() {
        guard size.width > 0,
              size.height > 0
        else {
            return
        }

        var next: [Bubble] = []

        for _ in 0..<AppConst.Game.bubblePerWave {
            let x = CGFloat.random(
                in: AppConst.Game.bubblePad...(size.width - AppConst.Game.bubblePad)
            )

            let y = CGFloat.random(
                in: AppConst.Game.bubblePad...(size.height - AppConst.Game.bubblePad)
            )

            let angle = CGFloat.random(in: 0...(2 * .pi))

            let speed = CGFloat.random(
                in: AppConst.Game.bubbleMinSpeed...AppConst.Game.bubbleMaxSpeed
            )

            next.append(
                Bubble(
                    id: UUID(),
                    position: CGPoint(
                        x: x,
                        y: y
                    ),
                    radius: CGFloat.random(
                        in: AppConst.Game.bubbleMinR...AppConst.Game.bubbleMaxR
                    ),
                    color: color,
                    createdAt: Date(),
                    velocity: CGPoint(
                        x: cos(angle) * speed,
                        y: sin(angle) * speed
                    )
                )
            )
        }

        bubbles = next
    }

    private func moveBubbles(dt: Double) {
        for index in bubbles.indices {
            guard !bubbles[index].popped else {
                continue
            }

            bubbles[index].position.x += bubbles[index].velocity.x * dt
            bubbles[index].position.y += bubbles[index].velocity.y * dt

            let radius = bubbles[index].radius

            if bubbles[index].position.x - radius < 0 {
                bubbles[index].position.x = radius
                bubbles[index].velocity.x = abs(bubbles[index].velocity.x)
            } else if bubbles[index].position.x + radius > size.width {
                bubbles[index].position.x = size.width - radius
                bubbles[index].velocity.x = -abs(bubbles[index].velocity.x)
            }

            if bubbles[index].position.y - radius < 0 {
                bubbles[index].position.y = radius
                bubbles[index].velocity.y = abs(bubbles[index].velocity.y)
            } else if bubbles[index].position.y + radius > size.height {
                bubbles[index].position.y = size.height - radius
                bubbles[index].velocity.y = -abs(bubbles[index].velocity.y)
            }
        }
    }
}
