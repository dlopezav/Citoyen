import PDFKit
import SwiftUI

struct PDFKitView: UIViewRepresentable {
    let url: URL
  @Binding var page: Int

    func makeUIView(context: Context) -> PDFView {
        let view = PDFView()
        view.autoScales = true
        view.displayMode = .singlePageContinuous
        view.displayDirection = .vertical
        view.document = PDFDocument(url: url)
        return view
    }

    func updateUIView(_ uiView: PDFView, context: Context) {
        guard let document = uiView.document else { return }
        let index = max(0, min(page - 1, document.pageCount - 1))
        guard let pdfPage = document.page(at: index) else { return }
        if uiView.currentPage !== pdfPage {
            uiView.go(to: pdfPage)
        }
    }
}

struct PDFReaderScreen: View {
    let url: URL
    @State var initialPage: Int

    var body: some View {
        PDFKitView(url: url, page: $initialPage)
            .navigationTitle("Page \(initialPage)")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItemGroup(placement: .bottomBar) {
                    Button {
                        initialPage = max(1, initialPage - 1)
                    } label: {
                        Image(systemName: "chevron.left")
                    }
                    Spacer()
                    Text("\(initialPage)")
                        .font(.headline.monospacedDigit())
                    Spacer()
                    Button {
                        initialPage += 1
                    } label: {
                        Image(systemName: "chevron.right")
                    }
                }
            }
    }
}