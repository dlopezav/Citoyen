import SwiftUI

struct ConceptsHomeView: View {
    let bundle: StudyBundle
    @EnvironmentObject private var library: StudyLibrary

    var body: some View {
        NavigationStack {
            List {
                ForEach(bundle.parts) { part in
                    Section {
                        if let pdf = library.pdfURL() {
                            NavigationLink {
                                PDFReaderScreen(url: pdf, initialPage: part.page)
                            } label: {
                                Label("Début de partie — page \(part.page)", systemImage: "book.closed")
                            }
                        }
                        ForEach(part.concepts) { concept in
                            if let pdf = library.pdfURL() {
                                NavigationLink {
                                    ConceptDetailView(concept: concept, partTitle: part.title, pdfURL: pdf)
                                } label: {
                                    ConceptRow(concept: concept)
                                }
                            } else {
                                ConceptRow(concept: concept)
                            }
                        }
                    } header: {
                        Text(part.title)
                    }
                }
            }
            .navigationTitle("Concepts")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

struct ConceptRow: View {
    let concept: Concept

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(concept.title)
                .font(.headline)
            Text(concept.summary)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .lineLimit(2)
            Text("PDF · page \(concept.page)")
                .font(.caption)
                .foregroundStyle(.tertiary)
        }
        .padding(.vertical, 4)
    }
}

struct ConceptDetailView: View {
    let concept: Concept
    let partTitle: String
    let pdfURL: URL

    var body: some View {
        List {
            Section("Résumé") {
                Text(concept.summary)
            }
            Section {
                NavigationLink {
                    PDFReaderScreen(url: pdfURL, initialPage: concept.page)
                } label: {
                    Label("Ouvrir le livret — page \(concept.page)", systemImage: "book.pages")
                }
            }
        }
        .navigationTitle(concept.title)
        .navigationBarTitleDisplayMode(.inline)
    }
}