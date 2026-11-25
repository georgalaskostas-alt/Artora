import SwiftUI

@main
struct ArtoraApp: App {
    @StateObject private var progress = ProgressStore()

    var body: some Scene {
        WindowGroup {
            HomeView()
                .environmentObject(progress)
        }
    }
}
