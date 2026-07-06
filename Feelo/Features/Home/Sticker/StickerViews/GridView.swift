import SwiftUI

struct StickerGrid: View {
    let stickers: [Sticker]

    private let cols = 3
    private let rows = 2

    var body: some View {
        GeometryReader { geo in
            let cellW = geo.size.width / CGFloat(cols)
            let cellH = geo.size.height / CGFloat(rows)

            ZStack {
                RoundedRectangle(cornerRadius: 46, style: .continuous)
                    .stroke(StickerTheme.line, lineWidth: 4)

                VStack(spacing: 0) {
                    ForEach(0..<rows, id: \.self) { row in
                        HStack(spacing: 0) {
                            ForEach(0..<cols, id: \.self) { col in
                                StickerCell(sticker: sticker(row: row, col: col))
                                    .frame(width: cellW, height: cellH)
                            }
                        }
                    }
                }
                .clipShape(RoundedRectangle(cornerRadius: 46, style: .continuous))

                GridLine(axis: .v)
                    .frame(width: 5, height: geo.size.height)
                    .position(x: cellW, y: geo.size.height / 2)

                GridLine(axis: .v)
                    .frame(width: 5, height: geo.size.height)
                    .position(x: cellW * 2, y: geo.size.height / 2)

                GridLine(axis: .h)
                    .frame(width: geo.size.width, height: 5)
                    .position(x: geo.size.width / 2, y: cellH)
            }
        }
    }

    private func sticker(row: Int, col: Int) -> Sticker {
        let i = row * cols + col
        guard stickers.indices.contains(i) else {
            return Sticker(id: "empty-\(i)", title: "???", img: nil, lockShape: .square)
        }

        return stickers[i]
    }
}

private enum GridAxis {
    case h
    case v
}

private struct GridLine: View {
    let axis: GridAxis

    var body: some View {
        GeometryReader { geo in
            Path { path in
                switch axis {
                case .h:
                    path.move(to: CGPoint(x: 0, y: geo.size.height / 2))
                    path.addLine(to: CGPoint(x: geo.size.width, y: geo.size.height / 2))
                case .v:
                    path.move(to: CGPoint(x: geo.size.width / 2, y: 0))
                    path.addLine(to: CGPoint(x: geo.size.width / 2, y: geo.size.height))
                }
            }
            .stroke(
                StickerTheme.line,
                style: StrokeStyle(lineWidth: 5, lineCap: .butt, dash: [8, 12])
            )
        }
    }
}
