import Observation
import SwiftUI
import UIKit

@Observable
final class PumpEngine {
    private(set) var count = 0
    private(set) var finished = false
    private(set) var handsUp = false
    private(set) var started = false
    private var state: PumpState = .down
    
    private enum PumpState {
        case up
        case down
    }
    
    var goal: Int {
        AppConst.Game.pumpGoal
    }
    
    var progress: Double {
        min(
            Double(count) / Double(goal),
            1.0
        )
    }
    func start() {
        started = true
    }
    func updateHands(_ points: [CGPoint]) {
        guard started,
              !finished,
              !points.isEmpty
        else {
            return
        }
        
        let avgY = points.map(\.y).reduce(0, +) / CGFloat(points.count)
        
        if avgY > AppConst.Game.handUpY,
           state == .down {
            state = .up
            handsUp = true
            SoundSvc.shared.pumpUp()
        }
        else if avgY < AppConst.Game.handDownY,
            state == .up {
            state = .down
            handsUp = false
            SoundSvc.shared.pumpDown()
            pump()
        } else if avgY < AppConst.Game.handDownY {
            handsUp = false
        }
    }
    
    func pump() {
        guard started, !finished else {
            return
        }
        
        count = min(
            count + 1,
            goal
        )
        
        UIImpactFeedbackGenerator(style: .heavy)
            .impactOccurred()
        
        if count >= goal {
            finished = true
        }
    }
}
