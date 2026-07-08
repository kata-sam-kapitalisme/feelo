import SwiftUI

struct Tri: Shape {
    func path(in rect: CGRect) -> Path {
        let points = [
            CGPoint(
                x: rect.midX,
                y: rect.minY
            ),
            CGPoint(
                x: rect.maxX,
                y: rect.maxY
            ),
            CGPoint(
                x: rect.minX,
                y: rect.maxY
            )
        ]

        return RoundPath.make(
            points,
            radius: min(rect.width, rect.height) * 0.12
        )
    }
}

struct DownTri: Shape {
    func path(in rect: CGRect) -> Path {
        let points = [
            CGPoint(
                x: rect.minX,
                y: rect.minY
            ),
            CGPoint(
                x: rect.maxX,
                y: rect.minY
            ),
            CGPoint(
                x: rect.midX,
                y: rect.maxY
            )
        ]

        return RoundPath.make(
            points,
            radius: min(rect.width, rect.height) * 0.12
        )
    }
}

struct Star: Shape {
    func path(in rect: CGRect) -> Path {
        let center = CGPoint(
            x: rect.midX,
            y: rect.midY
        )

        let outer = min(
            rect.width,
            rect.height
        ) / 2

        let inner = outer * 0.45

        var points: [CGPoint] = []

        for index in 0..<10 {
            let angle = -CGFloat.pi / 2 + CGFloat(index) * .pi / 5
            let radius = index.isMultiple(of: 2) ? outer : inner

            points.append(
                CGPoint(
                    x: center.x + CGFloat(cos(angle)) * radius,
                    y: center.y + CGFloat(sin(angle)) * radius
                )
            )
        }

        return RoundPath.make(
            points,
            radius: outer * 0.20
        )
    }
}

struct Diamond: Shape {
    func path(in rect: CGRect) -> Path {
        let points = [
            CGPoint(
                x: rect.midX,
                y: rect.minY
            ),
            CGPoint(
                x: rect.maxX,
                y: rect.midY
            ),
            CGPoint(
                x: rect.midX,
                y: rect.maxY
            ),
            CGPoint(
                x: rect.minX,
                y: rect.midY
            )
        ]

        return RoundPath.make(
            points,
            radius: min(rect.width, rect.height) * 0.16
        )
    }
}

enum RoundPath {
    static func make(
        _ points: [CGPoint],
        radius: CGFloat
    ) -> Path {
        var path = Path()

        guard points.count > 2 else {
            return path
        }

        for index in points.indices {
            let previous = points[
                (index - 1 + points.count) % points.count
            ]

            let current = points[index]

            let next = points[
                (index + 1) % points.count
            ]

            let before = unit(
                from: current,
                to: previous
            )

            let after = unit(
                from: current,
                to: next
            )

            let maxRadius = min(
                distance(current, previous),
                distance(current, next)
            ) * 0.42

            let corner = min(
                radius,
                maxRadius
            )

            let start = CGPoint(
                x: current.x + before.x * corner,
                y: current.y + before.y * corner
            )

            let end = CGPoint(
                x: current.x + after.x * corner,
                y: current.y + after.y * corner
            )

            if index == 0 {
                path.move(to: start)
            } else {
                path.addLine(to: start)
            }

            path.addQuadCurve(
                to: end,
                control: current
            )
        }

        path.closeSubpath()
        return path
    }

    private static func unit(
        from start: CGPoint,
        to end: CGPoint
    ) -> CGPoint {
        let x = end.x - start.x
        let y = end.y - start.y

        let length = max(
            sqrt((x * x) + (y * y)),
            0.0001
        )

        return CGPoint(
            x: x / length,
            y: y / length
        )
    }

    private static func distance(
        _ a: CGPoint,
        _ b: CGPoint
    ) -> CGFloat {
        let x = a.x - b.x
        let y = a.y - b.y

        return sqrt((x * x) + (y * y))
    }
}
