import SwiftUI
import UIKit

struct SceneView: View {
    @Environment(AppNav.self) private var nav

    private var items: [Scenario] {
        nav.filter?.items ?? []
    }

    private var title: String {
        nav.filter?.title ?? "Semua Cerita"
    }

    var body: some View {
        GeometryReader { geo in
            let scale = min(1.0, min(geo.size.width / AppConst.Ref.w, geo.size.height / AppConst.Ref.h))
            let hPad = max(16, 28 * scale)
            let gridSpacing = max(12, 16 * scale)
            let scaledColumns = [
                GridItem(.flexible(), spacing: gridSpacing),
                GridItem(.flexible(), spacing: gridSpacing),
                GridItem(.flexible(), spacing: gridSpacing)
            ]

            ZStack(alignment: .topLeading) {
                Image(AssetName.Img.bgWaves)
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()

                VStack(alignment: .leading, spacing: 0) {
                    header(scale: scale)
                        .padding(.horizontal, hPad)
                        .padding(.top, 20 * scale)
                        .padding(.bottom, 8 * scale)

                    Text(title)
                        .font(AppFont.semi(max(28, 40 * scale)))
                        .foregroundStyle(.white)
                        .padding(.horizontal, hPad)
                        .padding(.bottom, 18 * scale)

                    if items.isEmpty {
                        emptyView
                    } else {
                        ScrollView(.vertical, showsIndicators: false) {
                            LazyVGrid(
                                columns: scaledColumns,
                                spacing: gridSpacing
                            ) {
                                ForEach(items) { item in
                                    SceneCard(
                                        item: item,
                                        locked: item.locked,
                                        done: ProgressSvc.isDone(item.id),
                                        scale: scale
                                    ) {
                                        guard !item.locked else {
                                            return
                                        }

                                        SoundSvc.shared.levelUp()
                                        SoundSvc.shared.stopBGM()

                                        nav.scenario = item
                                        nav.screen = .intro
                                    }
                                }
                            }
                            .padding(.horizontal, hPad)
                            .padding(.bottom, 40)
                        }
                    }
                }
            }
            .onAppear {
                SoundSvc.shared.playBGM()
            }
        }
    }

    private func header(scale: CGFloat) -> some View {
        let circleSize = max(36, 46 * scale)
        return HStack(alignment: .center) {
            Button {
                SoundSvc.shared.click()
                nav.screen = .home
            } label: {
                ZStack {
                    Circle()
                        .fill(.white)
                        .frame(
                            width: circleSize,
                            height: circleSize
                        )
                        .shadow(
                            color: .black.opacity(0.15),
                            radius: 4,
                            x: 0,
                            y: 2
                        )

                    Image(systemName: "chevron.left")
                        .font(.system(
                            size: 18 * scale,
                            weight: .bold
                        ))
                        .foregroundStyle(AppColor.darkText)
                }
            }
            .buttonStyle(.plain)

            Spacer()

            Image(AssetName.Img.logo)
                .resizable()
                .scaledToFit()
                .frame(
                    width: AppConst.Layout.logoW * scale,
                    height: AppConst.Layout.logoH * scale
                )
        }
    }

    private var emptyView: some View {
        VStack(spacing: 14) {
            Image(systemName: "tray.fill")
                .font(.system(size: 44))
                .foregroundStyle(.white.opacity(0.35))

            Text("Belum ada cerita di sini")
                .font(AppFont.semi(18))
                .foregroundStyle(.white.opacity(0.45))
        }
        .frame(
            maxWidth: .infinity,
            maxHeight: .infinity
        )
    }
}

private struct SceneCard: View {
    let item: Scenario
    let locked: Bool
    let done: Bool
    let scale: CGFloat
    let action: () -> Void

    private let aspect: CGFloat = 4 / 3
    private let corner: CGFloat = 28

    var body: some View {
        Button(action: action) {
            GeometryReader { geo in
                ZStack(alignment: .bottomLeading) {
                    thumb(
                        width: geo.size.width,
                        height: geo.size.height
                    )

                    if done && !locked {
                        RoundedRectangle(
                            cornerRadius: corner,
                            style: .continuous
                        )
                        .fill(.black.opacity(0.58))
                    }

                    if locked {
                        RoundedRectangle(
                            cornerRadius: corner,
                            style: .continuous
                        )
                        .fill(.black.opacity(0.58))
                    }

                    label
                        .padding(.leading, 18 * scale)
                        .padding(.bottom, 18 * scale)

                    if locked {
                        LockIcon(size: 62 * scale)
                            .frame(
                                maxWidth: .infinity,
                                maxHeight: .infinity,
                                alignment: .center
                            )
                    }

                    if done && !locked {
                        checkIcon
                            .padding(.top, 26 * scale)
                            .padding(.trailing, 26 * scale)
                            .frame(
                                maxWidth: .infinity,
                                maxHeight: .infinity,
                                alignment: .topTrailing
                            )
                    }
                }
                .clipShape(
                    RoundedRectangle(
                        cornerRadius: corner,
                        style: .continuous
                    )
                )
                .overlay {
                    if done && !locked {
                        RoundedRectangle(
                            cornerRadius: corner,
                            style: .continuous
                        )
                        .stroke(
                            Color(
                                red: 255 / 255,
                                green: 211 / 255,
                                blue: 82 / 255
                            ),
                            lineWidth: 4
                        )
                    }
                }
                .shadow(
                    color: .black.opacity(0.30),
                    radius: 8,
                    x: 0,
                    y: 4
                )
            }
            .aspectRatio(
                aspect,
                contentMode: .fit
            )
        }
        .buttonStyle(.plain)
    }

    private func thumb(
        width: CGFloat,
        height: CGFloat
    ) -> some View {
        Group {
            if UIImage(named: item.thumb) != nil {
                Image(item.thumb)
                    .resizable()
                    .scaledToFill()
                    .frame(
                        width: width,
                        height: height
                    )
                    .clipped()
            } else {
                LinearGradient(
                    colors: [
                        item.bubbleColor.opacity(0.85),
                        item.bubbleColor.opacity(0.4)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .overlay {
                    Image(systemName: "photo")
                        .font(.system(size: 36))
                        .foregroundStyle(.white.opacity(0.35))
                }
            }
        }
    }

    private var checkIcon: some View {
        ZStack {
            Circle()
                .fill(.white)
                .frame(
                    width: 82 * scale,
                    height: 82 * scale
                )
                .shadow(
                    color: .black.opacity(0.18),
                    radius: 8,
                    x: 0,
                    y: 4
                )

            Image(systemName: "checkmark")
                .font(.system(
                    size: 34 * scale,
                    weight: .black
                ))
                .foregroundStyle(
                    Color(
                        red: 20 / 255,
                        green: 170 / 255,
                        blue: 95 / 255
                    )
                )
        }
    }

    private var label: some View {
        Text(item.title)
            .font(AppFont.semi(22 * scale))
            .foregroundStyle(AppColor.darkText)
            .lineLimit(1)
            .multilineTextAlignment(.center)
            .padding(.horizontal, 18 * scale)
            .frame(height: 62 * scale)
            .background {
                RoundedRectangle(
                    cornerRadius: 50,
                    style: .continuous
                )
                .fill(.white.opacity(0.95))
                .shadow(
                    color: .black.opacity(0.12),
                    radius: 3,
                    x: 0,
                    y: 1
                )
            }
    }
}
