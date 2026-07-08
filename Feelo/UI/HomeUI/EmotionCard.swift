import SwiftUI
import UIKit

struct EmotionCard: View {
    let emotion: EmotionItem
    let action: () -> Void

    var body: some View {
        GeometryReader { geo in
            let size = min(
                geo.size.width,
                geo.size.height
            )

            let outer = size * 0.060
            let inner = size * 0.050
            let border = outer + inner
            let innerSize = size - border * 2

            ZStack(alignment: .topLeading) {
                Circle()
                    .fill(.white)
                    .frame(
                        width: size,
                        height: size
                    )

                Circle()
                    .strokeBorder(
                        ringColors.outer,
                        lineWidth: outer
                    )
                    .frame(
                        width: size,
                        height: size
                    )

                Circle()
                    .inset(by: outer)
                    .strokeBorder(
                        ringColors.inner,
                        lineWidth: inner
                    )
                    .frame(
                        width: size,
                        height: size
                    )

                emotionImage
                    .frame(
                        width: innerSize,
                        height: innerSize
                    )
                    .clipShape(Circle())
                    .offset(
                        x: border,
                        y: border
                    )

                if emotion.locked {
                    Circle()
                        .fill(.black.opacity(0.75))
                        .frame(
                            width: size,
                            height: size
                        )

                    LockIcon(size: size * 0.38)
                        .offset(
                            x: (size - size * 0.38) / 2,
                            y: (size - size * 0.38) / 2
                        )
                }

                label(size)
                    .offset(
                        x: size * 0.12,
                        y: size * 0.78
                    )
            }
            .frame(
                width: size,
                height: size
            )
        }
        .contentShape(Rectangle())
        .tapSound {
            guard !emotion.locked else {
                return
            }

            action()
        }
    }

    private var emotionImage: some View {
        Group {
            if emotion.locked {
                Image(AssetName.Img.lockPic)
                    .resizable()
                    .scaledToFill()
            } else if UIImage(named: emotion.img) != nil {
                Image(emotion.img)
                    .resizable()
                    .scaledToFill()
            } else {
                Circle()
                    .fill(ringColors.inner.opacity(0.30))
            }
        }
    }

    private var ringColors: (outer: Color, inner: Color) {
        if emotion.locked {
            return (
                Color(hex: "4FADEF"),
                Color(hex: "7DC6F9")
            )
        }

        switch emotion.title.lowercased() {
        case "bersemangat":
            return (
                Color(hex: "FFB900"),
                Color(hex: "FF8E52")
            )

        case "kecewa":
            return (
                Color(hex: "624EC5"),
                Color(hex: "4733AD")
            )

        case "takut":
            return (
                Color(hex: "4B9CD3"),
                Color(hex: "1D3557")
            )

        case "bangga":
            return (
                Color(hex: "FF5722"),
                Color(hex: "D84315")
            )

        case "bingung":
            return (
                Color(hex: "26A69A"),
                Color(hex: "00695C")
            )

        case "penasaran":
            return (
                Color(hex: "FF4081"),
                Color(hex: "C2185B")
            )

        default:
            return (
                emotion.color.opacity(0.8),
                emotion.color
            )
        }
    }

    private func label(_ size: CGFloat) -> some View {
        let fontSize = size * 0.10
        let labelW = size * 0.765
        let labelH = size * 0.22
        let labelR = size * 0.12

        return Text(emotion.title)
            .font(AppFont.semi(fontSize))
            .foregroundStyle(AppColor.darkText)
            .lineLimit(1)
            .minimumScaleFactor(0.6)
            .multilineTextAlignment(.center)
            .frame(
                width: labelW,
                height: labelH
            )
            .background {
                RoundedRectangle(cornerRadius: labelR)
                    .fill(.white)
                    .shadow(
                        color: .black.opacity(0.25),
                        radius: 8,
                        x: 0,
                        y: 8
                    )
            }
            .overlay {
                if emotion.locked {
                    RoundedRectangle(cornerRadius: labelR)
                        .fill(.black.opacity(0.75))
                }
            }
    }
}
