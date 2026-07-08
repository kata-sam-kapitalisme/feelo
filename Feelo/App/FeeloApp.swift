import SwiftUI

@main
struct FeeloApp: App {
    @State private var nav = AppNav()

    init() {
        AppFont.register()
    }

    var body: some Scene {
        WindowGroup {
            RootView()
                .environment(nav)
        }
    }
}
