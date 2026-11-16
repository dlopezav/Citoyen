import SwiftUI

@main
struct VISA2026QuizApp: App {
    @StateObject private var library = StudyLibrary()

    var body: some Scene {
        WindowGroup {
            RootTabView()
                .environmentObject(library)
        }
    }
}