import SwiftUI

enum SpriteSource {
    case image
    case gif
}

enum SpriteSize {
    case squareFromHeight(CGFloat)
    case widthFromScreen(CGFloat)
}

enum SpritePlace {
    case aligned(
        Alignment,
        leading: CGFloat = 0,
        y: CGFloat = 0
    )

    case positioned(
        x: CGFloat,
        y: CGFloat
    )
}

struct SpriteSpec {
    let size: SpriteSize
    let place: SpritePlace
    let fit: String

    init(
        size: SpriteSize,
        place: SpritePlace,
        fit: String = "contain"
    ) {
        self.size = size
        self.place = place
        self.fit = fit
    }
}

struct StageSprite: View {
    let source: SpriteSource
    let name: String
    let spec: SpriteSpec

    var body: some View {
        GeometryReader { geo in
            let frame = frameSize(in: geo.size)

            content
                .frame(
                    width: frame.width,
                    height: frame.height
                )
                .clipped()
                .applyPlace(
                    spec.place,
                    geo: geo,
                    frame: frame
                )
        }
        .ignoresSafeArea()
    }

    @ViewBuilder
    private var content: some View {
        switch source {
        case .image:
            Image(name)
                .resizable()
                .scaledToFit()

        case .gif:
            GifView(
                name: name,
                fit: spec.fit
            )
            .id(name)
        }
    }

    private func frameSize(in screen: CGSize) -> CGSize {
        switch spec.size {
        case .squareFromHeight(let ratio):
            let value = screen.height * ratio

            return CGSize(
                width: value,
                height: value
            )

        case .widthFromScreen(let ratio):
            let width = screen.width * ratio

            return CGSize(
                width: width,
                height: width
            )
        }
    }
}

private extension View {
    func applyPlace(
        _ place: SpritePlace,
        geo: GeometryProxy,
        frame: CGSize
    ) -> some View {
        switch place {
        case .aligned(let alignment, let leading, let y):
            return AnyView(
                self
                    .offset(y: y)
                    .padding(.leading, leading)
                    .frame(
                        maxWidth: .infinity,
                        maxHeight: .infinity,
                        alignment: alignment
                    )
            )

        case .positioned(let x, let y):
            return AnyView(
                self
                    .position(
                        x: geo.size.width * x,
                        y: geo.size.height * y
                    )
            )
        }
    }
}
