//
//  SemanticSearchHelper.swift
//  Vaani
//
//  Uses Apple's Natural Language framework for semantic question matching.
//  On-device, no internet required. iOS 17+.
//

import Foundation
import NaturalLanguage

enum SemanticSearchHelper {
    /// High confidence: 0.25+ = clearly related
    private static let highConfidenceThreshold: Double = 0.25
    /// Low confidence: 0.12+ = best-effort match, show with "This might help"
    private static let lowConfidenceThreshold: Double = 0.12

    /// Search QA items by semantic similarity. Returns items above highConfidenceThreshold.
    static func semanticSearch(query: String, in items: [QAItem]) -> [QAItem] {
        let scored = semanticSearchWithScores(query: query, in: items)
        return scored.filter { $0.score >= highConfidenceThreshold }.map(\.item)
    }

    /// Returns top matches with scores. Use minThreshold: nil for best-effort (no minimum).
    static func semanticSearchWithScores(query: String, in items: [QAItem], limit: Int = 5, minThreshold: Double? = lowConfidenceThreshold) -> [(item: QAItem, score: Double)] {
        let q = query.trimmingCharacters(in: .whitespacesAndNewlines)
        if q.isEmpty || items.isEmpty { return [] }

        guard let embedding = NLEmbedding.sentenceEmbedding(for: .english) else {
            return []
        }

        guard let queryVector = embedding.vector(for: q) else {
            return []
        }

        let threshold = minThreshold ?? -1.0
        var scored: [(item: QAItem, score: Double)] = []
        for item in items {
            guard let questionVector = embedding.vector(for: item.question) else { continue }
            let sim = cosineSimilarity(queryVector, questionVector)
            if sim >= threshold {
                scored.append((item, sim))
            }
        }

        return Array(scored.sorted { $0.score > $1.score }.prefix(limit))
    }

    /// Cosine similarity between two vectors. Returns value in [-1, 1].
    private static func cosineSimilarity(_ a: [Double], _ b: [Double]) -> Double {
        guard a.count == b.count, !a.isEmpty else { return 0 }
        var dot: Double = 0
        var normA: Double = 0
        var normB: Double = 0
        for i in a.indices {
            dot += a[i] * b[i]
            normA += a[i] * a[i]
            normB += b[i] * b[i]
        }
        let denom = sqrt(normA) * sqrt(normB)
        guard denom > 0 else { return 0 }
        return dot / denom
    }
}
