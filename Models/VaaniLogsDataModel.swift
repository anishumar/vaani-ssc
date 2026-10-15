import Foundation
import SwiftUI

struct CheckList: Identifiable, Codable {
    let id: UUID
    var name: String
    var description: String
    /// Brief one-line summary of what the condition/disease is (for the selection screen).
    var conditionBrief: String

    var morningList: [CheckListItem]
    var afternoonList: [CheckListItem]
    var eveningList: [CheckListItem]
    var nightList: [CheckListItem]
    var commonList: [CheckListItem]
    
    var progress: Double {
        let totalItems = morningList + afternoonList + eveningList + nightList
        let checkedItemsCount = totalItems.filter { $0.isChecked }.count
        return totalItems.isEmpty ? 0 : round(Double(checkedItemsCount) / Double(totalItems.count) * 100)
    }

    init(id: UUID = UUID(), name: String, description: String, conditionBrief: String = "", morningList: [CheckListItem], afternoonList: [CheckListItem], eveningList: [CheckListItem], nightList: [CheckListItem], commonList: [CheckListItem]) {
        self.id = id
        self.name = name
        self.description = description
        self.conditionBrief = conditionBrief
        self.morningList = morningList
        self.afternoonList = afternoonList
        self.eveningList = eveningList
        self.nightList = nightList
        self.commonList = commonList
    }

    func getItems(for category: ChecklistCategory) -> [CheckListItem] {
            switch category {
            case .morning: return morningList
            case .afternoon: return afternoonList
            case .evening: return eveningList
            case .night: return nightList
            case .common: return commonList
            }
        }
}

extension CheckList {
    enum CodingKeys: String, CodingKey {
        case id, name, description, conditionBrief
        case morningList, afternoonList, eveningList, nightList, commonList
    }

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        id = try c.decode(UUID.self, forKey: .id)
        name = try c.decode(String.self, forKey: .name)
        description = try c.decode(String.self, forKey: .description)
        conditionBrief = try c.decodeIfPresent(String.self, forKey: .conditionBrief) ?? ""
        morningList = try c.decode([CheckListItem].self, forKey: .morningList)
        afternoonList = try c.decode([CheckListItem].self, forKey: .afternoonList)
        eveningList = try c.decode([CheckListItem].self, forKey: .eveningList)
        nightList = try c.decode([CheckListItem].self, forKey: .nightList)
        commonList = try c.decode([CheckListItem].self, forKey: .commonList)
    }

    func encode(to encoder: Encoder) throws {
        var c = encoder.container(keyedBy: CodingKeys.self)
        try c.encode(id, forKey: .id)
        try c.encode(name, forKey: .name)
        try c.encode(description, forKey: .description)
        try c.encode(conditionBrief, forKey: .conditionBrief)
        try c.encode(morningList, forKey: .morningList)
        try c.encode(afternoonList, forKey: .afternoonList)
        try c.encode(eveningList, forKey: .eveningList)
        try c.encode(nightList, forKey: .nightList)
        try c.encode(commonList, forKey: .commonList)
    }
}


struct CheckListItem: Identifiable, Codable {
    let id: UUID
    var name: String
    var isChecked: Bool
    var isUserAdded: Bool

    init(name: String, isChecked: Bool = false, isUserAdded: Bool = false) {
        self.id = UUID()
        self.name = name
        self.isChecked = isChecked
        self.isUserAdded = isUserAdded
    }

    enum CodingKeys: String, CodingKey { case id, name, isChecked, isUserAdded }

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        id = try c.decode(UUID.self, forKey: .id)
        name = try c.decode(String.self, forKey: .name)
        isChecked = try c.decode(Bool.self, forKey: .isChecked)
        isUserAdded = try c.decodeIfPresent(Bool.self, forKey: .isUserAdded) ?? false
    }

    func encode(to encoder: Encoder) throws {
        var c = encoder.container(keyedBy: CodingKeys.self)
        try c.encode(id, forKey: .id)
        try c.encode(name, forKey: .name)
        try c.encode(isChecked, forKey: .isChecked)
        try c.encode(isUserAdded, forKey: .isUserAdded)
    }
}

