import SwiftUI

struct LockedSticker: View {
    let shape: LockShape

    var body: some View {
        GeometryReader { geo in
            ZStack {
                bodyShape

                Text("?")
                    .font(StickerTheme.bold(markSize(geo.size)))
                    .foregroundStyle(StickerTheme.mark)
                    .offset(y: markY(shape, geo.size))
            }
        }
    }

    @ViewBuilder
    private var bodyShape: some View {
        switch shape {
        case .triangle:
            Triangle(dir: .up)
                .fill(StickerTheme.locked)
        case .star:
            Star()
                .fill(StickerTheme.locked)
        case .downTriangle:
            Triangle(dir: .down)
                .fill(StickerTheme.locked)
        case .square:
            RoundedRectangle(cornerRadius: 38, style: .continuous)
                .fill(StickerTheme.locked)
        }
    }

    private func markSize(_ size: CGSize) -> CGFloat {
        min(size.width, size.height) * 0.26
    }

    private func markY(_ shape: LockShape, _ size: CGSize) -> CGFloat {
        switch shape {
        case .triangle:
            return size.height * 0.05
        case .downTriangle:
            return -size.height * 0.03
        case .star:
            return size.height * 0.03
        case .square:
            return 0
        }
    }
}

private enum TriDir {
    case up
    case down
}

private struct Triangle: Shape {
    let dir: TriDir

    func path(in rect: CGRect) -> Path {
        let points: [CGPoint]

        switch dir {
        case .up:
            points = [
                CGPoint(x: rect.midX, y: rect.minY),
                CGPoint(x: rect.maxX, y: rect.maxY),
                CGPoint(x: rect.minX, y: rect.maxY)
            ]
        case .down:
            points = [
                CGPoint(x: rect.minX, y: rect.minY),
                CGPoint(x: rect.maxX, y: rect.minY),
                CGPoint(x: rect.midX, y: rect.maxY)
            ]
        }

        let radius = min(rect.width, rect.height) * 0.14
        return RoundPath.make(points, radius: radius)
    }
}

private struct Star: Shape {
    func path(in rect: CGRect) -> Path {
        let c = CGPoint(x: rect.midX, y: rect.midY)
        let outer = min(rect.width, rect.height) * 0.50
        let inner = outer * 0.54
        var points: [CGPoint] = []

        for i in 0..<10 {
            let angle = (Double(i) * .pi / 5) - (.pi / 2)
            let radius = i.isMultiple(of: 2) ? outer : inner
            points.append(
                CGPoint(
                    x: c.x + CGFloat(cos(angle)) * radius,
                    y: c.y + CGFloat(sin(angle)) * radius
                )
            )
        }

        return RoundPath.make(points, radius: outer * 0.14)
    }
}

private enum RoundPath {
    static func make(_ points: [CGPoint], radius: CGFloat) -> Path {
        var path = Path()
        guard points.count > 2 else { return path }

        for i in points.indices {
            let previous = points[(i - 1 + points.count) % points.count]
            let current = points[i]
            let next = points[(i + 1) % points.count]
            let before = unit(from: current, to: previous)
            let after = unit(from: current, to: next)
            let maxRadius = min(distance(current, previous), distance(current, next)) * 0.42
            let corner = min(radius, maxRadius)
            let start = CGPoint(
                x: current.x + before.x * corner,
                y: current.y + before.y * corner
            )
            let end = CGPoint(
                x: current.x + after.x * corner,
                y: current.y + after.y * corner
            )

            if i == 0 {
                path.move(to: start)
            } else {
                path.addLine(to: start)
            }

            path.addQuadCurve(to: end, control: current)
        }

        path.closeSubpath()
        return path
    }

    private static func unit(from start: CGPoint, to end: CGPoint) -> CGPoint {
        let x = end.x - start.x
        let y = end.y - start.y
        let length = max(sqrt((x * x) + (y * y)), 0.0001)
        return CGPoint(x: x / length, y: y / length)
    }

    private static func distance(_ a: CGPoint, _ b: CGPoint) -> CGFloat {
        let x = a.x - b.x
        let y = a.y - b.y
        return sqrt((x * x) + (y * y))
    }
}
