import SwiftUI

@main
struct FeeloApp: App {
    @State private var router = Router()

    init() {
        AppFont.register()
    }

    var body: some Scene {
        WindowGroup {
            RootView()
                .environment(router)
        }
    }
}
