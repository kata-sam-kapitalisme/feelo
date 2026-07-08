import SwiftUI

struct StickerGrid: View {
    let items: [Sticker]

    var body: some View {
        GeometryReader { geo in
            let cellW = geo.size.width / CGFloat(AppConst.Sticker.cols)
            let cellH = geo.size.height / CGFloat(AppConst.Sticker.rows)

            ZStack {
                RoundedRectangle(
                    cornerRadius: AppConst.Sticker.gridCorner,
                    style: .continuous
                )
                .stroke(
                    AppColor.line,
                    lineWidth: 4
                )

                VStack(spacing: 0) {
                    ForEach(0..<AppConst.Sticker.rows, id: \.self) { row in
                        HStack(spacing: 0) {
                            ForEach(0..<AppConst.Sticker.cols, id: \.self) { col in
                                StickerCell(
                                    item: sticker(
                                        row: row,
                                        col: col
                                    )
                                )
                                .frame(
                                    width: cellW,
                                    height: cellH
                                )
                            }
                        }
                    }
                }
                .clipShape(
                    RoundedRectangle(
                        cornerRadius: AppConst.Sticker.gridCorner,
                        style: .continuous
                    )
                )

                GridLine(axis: .vertical)
                    .frame(
                        width: AppConst.Sticker.gridLine,
                        height: geo.size.height
                    )
                    .position(
                        x: cellW,
                        y: geo.size.height / 2
                    )

                GridLine(axis: .vertical)
                    .frame(
                        width: AppConst.Sticker.gridLine,
                        height: geo.size.height
                    )
                    .position(
                        x: cellW * 2,
                        y: geo.size.height / 2
                    )

                GridLine(axis: .horizontal)
                    .frame(
                        width: geo.size.width,
                        height: AppConst.Sticker.gridLine
                    )
                    .position(
                        x: geo.size.width / 2,
                        y: cellH
                    )
            }
        }
    }

    private func sticker(
        row: Int,
        col: Int
    ) -> Sticker {
        let index = row * AppConst.Sticker.cols + col

        guard items.indices.contains(index) else {
            return Sticker(
                id: "empty-\(index)",
                title: "???",
                img: nil,
                shape: .square
            )
        }

        return items[index]
    }
}

private enum GridAxis {
    case horizontal
    case vertical
}

private struct GridLine: View {
    let axis: GridAxis

    var body: some View {
        GeometryReader { geo in
            Path { path in
                switch axis {
                case .horizontal:
                    path.move(
                        to: CGPoint(
                            x: 0,
                            y: geo.size.height / 2
                        )
                    )
                    path.addLine(
                        to: CGPoint(
                            x: geo.size.width,
                            y: geo.size.height / 2
                        )
                    )

                case .vertical:
                    path.move(
                        to: CGPoint(
                            x: geo.size.width / 2,
                            y: 0
                        )
                    )
                    path.addLine(
                        to: CGPoint(
                            x: geo.size.width / 2,
                            y: geo.size.height
                        )
                    )
                }
            }
            .stroke(
                AppColor.line,
                style: StrokeStyle(
                    lineWidth: AppConst.Sticker.gridLine,
                    lineCap: .butt,
                    dash: AppConst.Sticker.gridDash
                )
            )
        }
    }
}
