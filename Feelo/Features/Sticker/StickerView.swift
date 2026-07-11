import SwiftUI

struct StickerView: View {
    @Environment(AppNav.self) private var nav
    @State private var vm = StickerVM()

    var body: some View {
        GeometryReader { geo in
            let scale = min(
                geo.size.width / AppConst.Sticker.canvas.width,
                geo.size.height / AppConst.Sticker.canvas.height
            )

            let canvasWidth = AppConst.Sticker.canvas.width * scale
            let canvasHeight = AppConst.Sticker.canvas.height * scale

            let left = (geo.size.width - canvasWidth) / 2
            let top = (geo.size.height - canvasHeight) / 2

            ZStack {
                AppColor.bgMain
                    .ignoresSafeArea()

                ZStack {
                    StickerBook(items: vm.items)

                    StickerTitle(text: "Koleksi Stiker")
                        .frame(
                            width: AppConst.Sticker.titleW,
                            height: AppConst.Sticker.titleH
                        )
                        .position(
                            x: AppConst.Sticker.titleX,
                            y: AppConst.Sticker.titleY
                        )
                }
                .frame(
                    width: AppConst.Sticker.canvas.width,
                    height: AppConst.Sticker.canvas.height
                )
                .scaleEffect(scale)
                .frame(
                    width: canvasWidth,
                    height: canvasHeight
                )
                .position(
                    x: geo.size.width / 2,
                    y: geo.size.height / 2 - safeAreaBottom / 2
                )

                backButton {
                    nav.goHome()
                }
                .frame(
                    width: max(
                        AppConst.Sticker.backMin,
                        AppConst.Sticker.backBase * scale
                    ),
                    height: max(
                        AppConst.Sticker.backMin,
                        AppConst.Sticker.backBase * scale
                    )
                )
                .position(
                    x: left + (AppConst.Sticker.backX * scale),
                    y: top + (AppConst.Sticker.backY * scale)
                )
                .zIndex(10)
            }
            .frame(
                width: geo.size.width,
                height: geo.size.height
            )
        }
        .onAppear {
            vm.load()
        }
        .ignoresSafeArea()
    }

    private func backButton(_ action: @escaping () -> Void) -> some View {
        Button {
            SoundSvc.shared.click()
            action()
        } label: {
            ZStack {
                Circle()
                    .fill(.white)

                Image(systemName: "chevron.left")
                    .font(.system(
                        size: 34,
                        weight: .bold
                    ))
                    .foregroundStyle(.black)
                    .offset(x: -2)
            }
            .contentShape(Circle())
        }
        .buttonStyle(.plain)
        .accessibilityLabel("Back to Home")
    }
}
