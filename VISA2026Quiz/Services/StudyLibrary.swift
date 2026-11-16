import Foundation

@MainActor
final class StudyLibrary: ObservableObject {
    @Published private(set) var bundle: StudyBundle?
    @Published private(set) var loadError: String?

    var allConcepts: [Concept] {
        bundle?.parts.flatMap(\.concepts) ?? []
    }

    func load() {
        guard bundle == nil else { return }
        do {
            guard let url = Bundle.main.url(forResource: "content", withExtension: "json") else {
                loadError = "Fichier content.json introuvable dans l'app."
                return
            }
            let data = try Data(contentsOf: url)
            bundle = try JSONDecoder().decode(StudyBundle.self, from: data)
        } catch {
            loadError = error.localizedDescription
        }
    }

    func pdfURL() -> URL? {
        guard let name = bundle?.pdfFileName else { return nil }
        let base = (name as NSString).deletingPathExtension
        let ext = (name as NSString).pathExtension
        return Bundle.main.url(forResource: base, withExtension: ext.isEmpty ? "pdf" : ext)
    }

    func concept(for id: String) -> Concept? {
        allConcepts.first { $0.id == id }
    }
}