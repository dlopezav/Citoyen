import Foundation

struct StudyBundle: Codable {
    let title: String
    let pdfFileName: String
    let pageCount: Int
    let parts: [StudyPart]
    let quizzes: [Quiz]
}

struct StudyPart: Identifiable, Codable {
    let id: String
    let title: String
    let page: Int
    let summary: String
    let concepts: [Concept]
}

struct Concept: Identifiable, Codable, Hashable {
    let id: String
    let title: String
    let page: Int
    let summary: String
}

struct Quiz: Identifiable, Codable {
    let id: String
    let title: String
    let conceptIds: [String]
    let questions: [QuizQuestion]
}

struct QuizQuestion: Identifiable, Codable {
    let id: String
    let text: String
    let choices: [String]
    let correctIndex: Int
    let explanationPage: Int
    let explanation: String
}