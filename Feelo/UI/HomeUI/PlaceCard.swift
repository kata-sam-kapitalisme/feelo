import SwiftUI
import UIKit

struct PlaceCard: View {
    let place: PlaceItem
    let action: () -> Void

    var body: some View {
        GeometryReader { geo in
            let frontH = geo.size.height * 0.82
            let frontW = geo.size.width

            let midW = frontW * 0.763
            let midH = frontH * 0.763

            let farW = frontW * 0.572
            let farH = frontH * 0.572

            let midY = -(geo.size.height * 0.301)
            let farY = -(geo.size.height * 0.524)

            ZStack(alignment: .bottom) {
                backCard(
                    width: farW,
                    height: farH,
                    rotation: -3.39,
                    offsetY: farY,
                    color: place.locked
                        ? Color(hex: "EBEBEB")
                        : Color(red: 0.62, green: 0.82, blue: 0.96)
                )

                backCard(
                    width: midW,
                    height: midH,
                    rotation: 2.76,
                    offsetY: midY,
                    color: place.locked
                        ? Color(hex: "F8F8F8")
                        : Color(red: 0.75, green: 0.90, blue: 0.98)
                )

                ZStack {
                    RoundedRectangle(cornerRadius: 50)
                        .fill(.white)
                        .shadow(
                            color: AppColor.greenDark,
                            radius: 0,
                            x: 0,
                            y: frontW * (20 / 439)
                        )

                    cardImage
                        .frame(
                            width: frontW - 30,
                            height: frontH - 30
                        )
                        .clipShape(
                            RoundedRectangle(cornerRadius: 38)
                        )

                    LinearGradient(
                        colors: [
                            .black.opacity(0),
                            .black.opacity(0),
                            .black.opacity(0.40)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .frame(
                        width: frontW - 30,
                        height: frontH - 30
                    )
                    .clipShape(
                        RoundedRectangle(cornerRadius: 38)
                    )

                    if place.locked {
                        RoundedRectangle(cornerRadius: 50)
                            .fill(.black.opacity(0.75))
                            .frame(
                                width: frontW,
                                height: frontH
                            )

                        LockIcon(size: min(frontW, frontH) * 0.28)
                    }
                }
                .frame(
                    width: frontW,
                    height: frontH
                )
                .overlay(alignment: .bottomLeading) {
                    label(cardWidth: frontW)
                        .offset(
                            x: frontW * 0.10,
                            y: frontW * 0.14
                        )
                }
            }
            .frame(
                width: geo.size.width,
                height: geo.size.height,
                alignment: .bottom
            )
        }
        .contentShape(Rectangle())
        .tapSound {
            guard !place.locked else {
                return
            }

            action()
        }
    }

    private var cardImage: some View {
        Group {
            if UIImage(named: place.img) != nil {
                Image(place.img)
                    .resizable()
                    .scaledToFill()
            } else {
                LinearGradient(
                    colors: [
                        .teal.opacity(0.7),
                        .green.opacity(0.45)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            }
        }
    }

    private func backCard(
        width: CGFloat,
        height: CGFloat,
        rotation: Double,
        offsetY: CGFloat,
        color: Color
    ) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 50)
                .fill(color)

            if place.locked {
                RoundedRectangle(cornerRadius: 50)
                    .fill(.black.opacity(0.75))
            }
        }
        .shadow(
            color: .black.opacity(0.16),
            radius: 0,
            x: 0,
            y: 3
        )
        .frame(
            width: width,
            height: height
        )
        .rotationEffect(.degrees(rotation))
        .offset(y: offsetY)
    }

    private func label(cardWidth: CGFloat) -> some View {
        let labelW = cardWidth * 0.780
        let labelH = cardWidth * 0.251
        let fontSize = cardWidth * 0.07289

        return ZStack {
            Image(AssetName.Img.unionTag)
                .resizable()
                .renderingMode(.template)
                .foregroundStyle(.white)
                .frame(
                    width: labelW,
                    height: labelH
                )
                .shadow(
                    color: AppColor.greenDark,
                    radius: 0,
                    x: 0,
                    y: cardWidth * (20 / 439)
                )

            Text(place.title)
                .font(AppFont.semi(fontSize))
                .foregroundStyle(AppColor.darkText)
                .lineLimit(1)
                .padding(.horizontal, cardWidth * 0.046)
                .offset(y: -labelH * 0.14)

            if place.locked {
                Image(AssetName.Img.unionTag)
                    .resizable()
                    .renderingMode(.template)
                    .foregroundStyle(.black.opacity(0.75))
                    .frame(
                        width: labelW,
                        height: labelH
                    )
            }
        }
        .frame(
            width: labelW,
            height: labelH
        )
    }
}
