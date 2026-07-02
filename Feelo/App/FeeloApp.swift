import SwiftUI

@main
struct FeeloApp: App {
    @State private var router = Router()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environment(router)
        }
    }
}
