import Foundation

// MARK: - Myth buster

struct MythFact: Identifiable {
    let id: String
    let myth: String
    let fact: String
    let topic: String?
}

// MARK: - Period tracker

struct PeriodEntry: Identifiable, Codable {
    var id: String
    var startDate: Date
    var endDate: Date?
    var flow: String? // light, medium, heavy
    var notes: String?
}

// MARK: - Badges

struct BadgeDef: Identifiable {
    let id: String
    let title: String
    let systemImage: String
    let customImage: String?
}

// MARK: - Glossary

struct GlossaryTerm: Identifiable {
    let id: String
    let term: String
    let definition: String
}

// MARK: - Playlist

struct PlaylistItem: Identifiable {
    let id: String
    let title: String
    let subtitle: String
    let urlString: String
    let group: String? // "Calm", "Focus", "Energy"
}

// MARK: - Condition awareness

struct ConditionInfo: Identifiable {
    let id: String
    let title: String
    let summary: String
    let whenToSeeDoctor: String
    let storyIndex: Int?
    let glossaryTermId: String?
    let tipWhenSelected: String?
    var imageName: String? = nil
}
