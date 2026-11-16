import SwiftUI

struct QuizListView: View {
    let quizzes: [Quiz]

    var body: some View {
        NavigationStack {
            List(quizzes) { quiz in
                NavigationLink {
                    QuizSessionView(quiz: quiz)
                } label: {
                    VStack(alignment: .leading) {
                        Text(quiz.title)
                            .font(.headline)
                        Text("\(quiz.questions.count) questions")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .navigationTitle("Quiz")
        }
    }
}

struct QuizSessionView: View {
    let quiz: Quiz
    @EnvironmentObject private var library: StudyLibrary
    @State private var index = 0
    @State private var selected: Int?
    @State private var score = 0
    @State private var finished = false

    private var question: QuizQuestion { quiz.questions[index] }

    var body: some View {
        Group {
            if finished {
                quizResult
            } else {
                questionBody
            }
        }
        .navigationTitle(quiz.title)
        .navigationBarTitleDisplayMode(.inline)
    }

  @ViewBuilder
    private var questionBody: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Question \(index + 1)/\(quiz.questions.count)")
                .font(.caption)
                .foregroundStyle(.secondary)
            Text(question.text)
                .font(.title3.weight(.semibold))
            ForEach(question.choices.indices, id: \.self) { i in
                Button {
                    guard selected == nil else { return }
                    selected = i
                    if i == question.correctIndex { score += 1 }
                } label: {
                    HStack {
                        Text(question.choices[i])
                            .multilineTextAlignment(.leading)
                        Spacer()
                        if let selected, selected == i {
                            Image(systemName: i == question.correctIndex ? "checkmark.circle.fill" : "xmark.circle.fill")
                        } else if let selected, i == question.correctIndex {
                            Image(systemName: "checkmark.circle")
                        }
                    }
                    .padding()
                    .background(buttonBackground(for: i))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                .buttonStyle(.plain)
                .disabled(selected != nil)
            }
            if let selected {
                VStack(alignment: .leading, spacing: 8) {
                    Text(question.explanation)
                        .font(.subheadline)
                    if let pdf = library.pdfURL() {
                        NavigationLink {
                            PDFReaderScreen(url: pdf, initialPage: question.explanationPage)
                        } label: {
                            Label("Voir la source (p. \(question.explanationPage))", systemImage: "book")
                        }
                    }
                    ForEach(relatedConcepts, id: \.id) { concept in
                        if let pdf = library.pdfURL() {
                            NavigationLink {
                                PDFReaderScreen(url: pdf, initialPage: concept.page)
                            } label: {
                                Text("Concept : \(concept.title)")
                            }
                            .font(.caption)
                        }
                    }
                }
                .padding(.top, 8)
                Button(index + 1 < quiz.questions.count ? "Question suivante" : "Voir le score") {
                    if index + 1 < quiz.questions.count {
                        index += 1
                        self.selected = nil
                    } else {
                        finished = true
                    }
                }
                .buttonStyle(.borderedProminent)
                .frame(maxWidth: .infinity)
            }
            Spacer()
        }
        .padding()
    }

    private var relatedConcepts: [Concept] {
        quiz.conceptIds.compactMap { library.concept(for: $0) }.prefix(3).map { $0 }
    }

    private func buttonBackground(for i: Int) -> Color {
        guard let selected else { return Color(.secondarySystemBackground) }
        if i == question.correctIndex { return .green.opacity(0.25) }
        if i == selected { return .red.opacity(0.2) }
        return Color(.secondarySystemBackground)
    }

    private var quizResult: some View {
        VStack(spacing: 16) {
            Image(systemName: "star.circle.fill")
                .font(.system(size: 56))
                .foregroundStyle(.yellow)
            Text("Score : \(score)/\(quiz.questions.count)")
                .font(.title.bold())
            Button("Recommencer") {
                index = 0
                selected = nil
                score = 0
                finished = false
            }
            .buttonStyle(.borderedProminent)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}