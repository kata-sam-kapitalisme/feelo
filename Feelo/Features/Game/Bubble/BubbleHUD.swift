import SwiftUI

struct BubbleHUD: View {
    let engine: BubbleEngine
    let action: (Bool) -> Void

    private var shownScore: Int {
        min(
            engine.score,
            AppConst.Game.bubbleGoal
        )
    }

    private var success: Bool {
        engine.score >= AppConst.Game.bubbleGoal
    }

    private var ended: Bool {
        engine.finished || success
    }

    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                HStack {
                    GameCounterHUD(
                        iconName: AssetName.Img.bubble,
                        current: shownScore,
                        goal: AppConst.Game.bubbleGoal
                    )

                    Spacer()
                }
                .padding(.horizontal, 18)
                .padding(.top, 18)

                Spacer()
            }

            if ended {
                DoneOverlay(
                    score: shownScore,
                    success: success
                ) {
                    action(success)
                }
                .transition(
                    .opacity.combined(with: .scale)
                )
                .animation(
                    .spring(duration: 0.5),
                    value: ended
                )
                .zIndex(100)
            }
        }
    }

}
