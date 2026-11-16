import SwiftUI

struct RootTabView: View {
    @EnvironmentObject private var library: StudyLibrary

    var body: some View {
        Group {
            if let error = library.loadError {
                ContentUnavailableView("Erreur", systemImage: "exclamationmark.triangle", description: Text(error))
            } else if let bundle = library.bundle {
                TabView {
                    ConceptsHomeView(bundle: bundle)
                        .tabItem { Label("Concepts", systemImage: "list.bullet.rectangle") }

                    SummariesView(bundle: bundle)
                        .tabItem { Label("Résumés", systemImage: "text.alignleft") }

                    QuizListView(quizzes: bundle.quizzes)
                        .tabItem { Label("Quiz", systemImage: "questionmark.circle") }

                    if let pdf = library.pdfURL() {
                        NavigationStack {
                            PDFReaderScreen(url: pdf, initialPage: 1)
                                .navigationTitle(bundle.title)
                        }
                        .tabItem { Label("PDF", systemImage: "doc.richtext") }
                    }
                }
            } else {
                ProgressView("Chargement…")
            }
        }
        .onAppear { library.load() }
    }
}