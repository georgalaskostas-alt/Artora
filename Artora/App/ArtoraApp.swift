import SwiftUI

@main
struct ArtoraApp: App {
    @StateObject private var progress = ProgressStore()
    @StateObject private var gallery = GalleryStore()

    var body: some Scene {
        WindowGroup {
            AcademyRoot()
                .environmentObject(progress)
                .environmentObject(gallery)
        }
    }
}
