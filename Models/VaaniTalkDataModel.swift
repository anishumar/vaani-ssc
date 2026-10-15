//
//  File.swift
//  Florie-app
//
//  Created by Anish Umar on 06/02/26.
//

import Foundation

struct Message: Identifiable, Equatable {
    let id = UUID()
    let text: String
    let isUser: Bool
    var suggestedQuestions: [QAItem] = []
}


struct QuestionCategory: Identifiable {
    let id = UUID()
    let name: String
    let items: [QAItem]
}

struct QAItem: Identifiable, Equatable {
    let id = UUID()
    let question: String
    let answer: String
}

struct QASearchResult {
    let items: [QAItem]
    let isLowConfidence: Bool
    let relatedQuestions: [QAItem]
}


