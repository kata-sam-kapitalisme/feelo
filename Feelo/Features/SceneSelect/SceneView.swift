import SwiftUI
import UIKit

struct SceneView: View {
    @Environment(AppNav.self) private var nav

    private let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]

    private var items: [Scenario] {
        nav.filter?.items ?? []
    }

    private var title: String {
        nav.filter?.title ?? "Semua Cerita"
    }

    var body: some View {
        ZStack(alignment: .topLeading) {
            Image(AssetName.Img.bgWaves)
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()

            VStack(alignment: .leading, spacing: 0) {
                header
                    .padding(.horizontal, 28)
                    .padding(.top, 20)
                    .padding(.bottom, 8)

                Text(title)
                    .font(AppFont.semi(40))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 28)
                    .padding(.bottom, 18)

                if items.isEmpty {
                    emptyView
                } else {
                    ScrollView(.vertical, showsIndicators: false) {
                        LazyVGrid(
                            columns: columns,
                            spacing: 16
                        ) {
                            ForEach(items) { item in
                                SceneCard(
                                    item: item,
                                    locked: item.locked,
                                    done: ProgressSvc.isDone(item.id)
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
                        .padding(.horizontal, 28)
                        .padding(.bottom, 40)
                    }
                }
            }
        }
        .onAppear {
            SoundSvc.shared.playBGM()
        }
    }

    private var header: some View {
        HStack(alignment: .center) {
            Button {
                SoundSvc.shared.click()
                nav.screen = .home
            } label: {
                ZStack {
                    Circle()
                        .fill(.white)
                        .frame(
                            width: 46,
                            height: 46
                        )
                        .shadow(
                            color: .black.opacity(0.15),
                            radius: 4,
                            x: 0,
                            y: 2
                        )

                    Image(systemName: "chevron.left")
                        .font(.system(
                            size: 18,
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
                    width: AppConst.Layout.logoW,
                    height: AppConst.Layout.logoH
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
                        .padding(.leading, 18)
                        .padding(.bottom, 18)

                    if locked {
                        LockIcon(size: 62)
                            .frame(
                                maxWidth: .infinity,
                                maxHeight: .infinity,
                                alignment: .center
                            )
                    }

                    if done && !locked {
                        checkIcon
                            .padding(.top, 26)
                            .padding(.trailing, 26)
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
                    width: 82,
                    height: 82
                )
                .shadow(
                    color: .black.opacity(0.18),
                    radius: 8,
                    x: 0,
                    y: 4
                )

            Image(systemName: "checkmark")
                .font(.system(
                    size: 34,
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
            .font(AppFont.semi(22))
            .foregroundStyle(AppColor.darkText)
            .lineLimit(1)
            .multilineTextAlignment(.center)
            .padding(.horizontal, 18)
            .frame(height: 62)
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
