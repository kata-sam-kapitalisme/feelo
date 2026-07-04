import SwiftUI

struct Scenario: Identifiable {
    let id: String
    let title: String
    let placeTag: String    // matches PlaceModel.title
    let emotionTag: String  // matches EmotionModel.title
    let introScene1: String
    let introScene2: String
    let bubbleColor: Color
    let bubbleCount: Int
    let badgeTitle: String
    let gameplayDurationSeconds: Double
}
