import SwiftUI

struct SummariesView: View {
    let bundle: StudyBundle
    @EnvironmentObject private var library: StudyLibrary

    var body: some View {
        NavigationStack {
            List(bundle.parts) { part in
                Section(part.title) {
                    Text(part.summary)
                        .font(.body)
                    if let pdf = library.pdfURL() {
                        NavigationLink {
                            PDFReaderScreen(url: pdf, initialPage: part.page)
                        } label: {
                            Text("Voir dans le PDF (p. \(part.page))")
                        }
                    }
                    ForEach(part.concepts) { concept in
                        if let pdf = library.pdfURL() {
                            NavigationLink {
                                ConceptDetailView(concept: concept, partTitle: part.title, pdfURL: pdf)
                            } label: {
                                Text(concept.title)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Résumés")
        }
    }
}