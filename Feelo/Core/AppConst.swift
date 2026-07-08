import SwiftUI

enum AppConst {
    enum Time {
        static let tutorialNs: UInt64 = 7_000_000_000
        static let splashDur: TimeInterval = 0.35
        static let doneDelay: TimeInterval = 1.5
        static let doneAuto: TimeInterval = 1.8
    }

    enum Game {
        static let bubbleGoal = 10
        static let bubblePerWave = 12

        static let bubblePad: CGFloat = 70
        static let bubbleMinR: CGFloat = 36
        static let bubbleMaxR: CGFloat = 54
        static let bubbleMinSpeed: CGFloat = 40
        static let bubbleMaxSpeed: CGFloat = 80

        static let pumpGoal = 8
        static let handUpY: CGFloat = 0.6
        static let handDownY: CGFloat = 0.4
    }

    enum Layout {
        static let logoW: CGFloat = 250
        static let logoH: CGFloat = 109.81

        static let cloudW: CGFloat = 934
        static let cloudH: CGFloat = 238

        static let tutorialSize: CGFloat = 300
    }

    enum Home {
        static let minSidePad: CGFloat = 20
        static let sidePadRatio: CGFloat = 0.03

        static let maxLogoW: CGFloat = 250
        static let logoRatio: CGFloat = 109.81 / 250
        static let logoScreenWRatio: CGFloat = 0.20
        static let logoScreenHRatio: CGFloat = 0.34

        static let maxBadge: CGFloat = 80
        static let badgeLogoRatio: CGFloat = 0.73

        static let maxTitle: CGFloat = 40
        static let minTitle: CGFloat = 28

        static let placeAspect: CGFloat = 0.832
        static let placeWidthRatio: CGFloat = 0.33
        static let placeBottomRatio: CGFloat = 0.25
        static let placeSpaceRatio: CGFloat = 0.58

        static let maxEmotion: CGFloat = 200
        static let minEmotion: CGFloat = 130
        static let emotionBottomRatio: CGFloat = 0.22

        static let titleBottom: CGFloat = 12
        static let itemGap: CGFloat = 16
        static let emotionGap: CGFloat = 20
    }

    enum Stage {
        static let bubbleCharSmall: CGFloat = 0.40
        static let bubbleTut: CGFloat = 0.95
        static let bubbleTutY: CGFloat = 120
        static let bubbleItems: CGFloat = 0.90

        static let pumpCharSmall: CGFloat = 0.40
        static let pumpCharAction: CGFloat = 0.50
        static let pumpCharActionY: CGFloat = 70
        static let pumpSceneTwoLead: CGFloat = 100

        static let bushBallW: CGFloat = 0.48
        static let bushBallX: CGFloat = 0.77
        static let bushBallY: CGFloat = 0.82
    }

    enum PumpLayout {
        static let pumpLead: CGFloat = 0.30
        static let pumpUpH: CGFloat = 0.55
        static let pumpDownH: CGFloat = 0.45

        static let flatBallLead: CGFloat = 0.43
        static let flatBallH: CGFloat = 0.25
        static let flatBallMinScale: CGFloat = 0.40
        static let flatBallGrowScale: CGFloat = 0.40

        static let fullBallLead: CGFloat = 0.48
        static let fullBallH: CGFloat = 0.28

        static let guideTopPad: CGFloat = 24
        static let guideBoxW: CGFloat = 0.72
        static let guideBoxH: CGFloat = 0.17
        static let guideMinH: CGFloat = 104
        static let guideMaxH: CGFloat = 150
        static let guideTitleFont: CGFloat = 46
        static let guideTextFont: CGFloat = 34
        static let guideSpace: CGFloat = 4
        static let guidePadX: CGFloat = 28
        static let guidePadY: CGFloat = 16
    }

    enum Sticker {
        static let canvas = CGSize(
            width: 1406,
            height: 1064
        )

        static let titleW: CGFloat = 874
        static let titleH: CGFloat = 131
        static let titleX: CGFloat = 703
        static let titleY: CGFloat = 159.5
        static let titleCorner: CGFloat = 40

        static let bookW: CGFloat = 1310
        static let bookH: CGFloat = 809
        static let bookX: CGFloat = 703
        static let bookY: CGFloat = 580.5
        static let bookCorner: CGFloat = 50

        static let gridW: CGFloat = 1124
        static let gridH: CGFloat = 692
        static let gridX: CGFloat = 703
        static let gridY: CGFloat = 592
        static let gridCorner: CGFloat = 46
        static let gridLine: CGFloat = 5
        static let gridDash: [CGFloat] = [8, 12]

        static let ringX: CGFloat = 68
        static let ringW: CGFloat = 100
        static let ringH: CGFloat = 72
        static let ringLine: CGFloat = 10
        static let ringYs: [CGFloat] = [
            286,
            441,
            596,
            751,
            906
        ]

        static let backBase: CGFloat = 80
        static let backMin: CGFloat = 56
        static let backX: CGFloat = 120
        static let backY: CGFloat = 100

        static let cols = 3
        static let rows = 2

        static let cellTitleY: CGFloat = 0.86
        static let cellTitleW: CGFloat = 0.86
        static let cellTitleFont: CGFloat = 34

        static let stickerY: CGFloat = 0.38
        static let bubbleStickerW: CGFloat = 0.78
        static let bubbleStickerH: CGFloat = 0.56
        static let basketStickerW: CGFloat = 0.66
        static let basketStickerH: CGFloat = 0.58

        static let lockY: CGFloat = 0.47
        static let lockLine: CGFloat = 10
        static let lockMarkRatio: CGFloat = 0.26
    }
}
