import AppIntents

struct StartGameIntent: AppIntent {
    static let title: LocalizedStringResource = "Start Vaani’s Health Game"
    static let description = IntentDescription("Opens the Vaani’s Life tab to play the health game.")

    func perform() async throws -> some IntentResult & ProvidesDialog {
        await VaaniApp.openTab(VaaniTab.life)
        return .result(dialog: "Opening Vaani’s Health Game!")
    }
    
    static let openAppWhenRun: Bool = true
}


struct StartChatIntent: AppIntent {
    static let title: LocalizedStringResource = "Start chat with Vaani"
    static let description = IntentDescription("Let's you start a chat with Vaani.")

    func perform() async throws -> some IntentResult & ProvidesDialog {
        await VaaniApp.openTab(VaaniTab.talk)
        return .result(dialog: "Opening Vaani’s Talk!")
    }
    
    static let openAppWhenRun: Bool = true
}


struct StartLogIntent: AppIntent {
    static let title: LocalizedStringResource = "Start the healthy checklist with Vaani"
    static let description = IntentDescription("Let's you start a healthy lifestyle with Vaani")

    func perform() async throws -> some IntentResult & ProvidesDialog {
        await VaaniApp.openTab(VaaniTab.logs)
        return .result(dialog: "Opening Vaani’s Plan!")
    }
    
    static let openAppWhenRun: Bool = true
}

// MARK: - Checklist Category Enum
enum ChecklistCategory: String, CaseIterable, Codable, AppEnum {
    case morning = "Morning"
    case afternoon = "Afternoon"
    case evening = "Evening"
    case night = "Night"
    case common = "Common"

    static var typeDisplayRepresentation: TypeDisplayRepresentation {
        TypeDisplayRepresentation(name: "Checklist Category")
    }

    static var caseDisplayRepresentations: [ChecklistCategory: DisplayRepresentation] {
        [
            .morning: DisplayRepresentation(title: "Morning"),
            .afternoon: DisplayRepresentation(title: "Afternoon"),
            .evening: DisplayRepresentation(title: "Evening"),
            .night: DisplayRepresentation(title: "Night"),
            .common: DisplayRepresentation(title: "Common")
        ]
    }
}

// MARK: - Checklist Item Entity
struct CheckListItemOption: AppEntity {
    let id: String
    let name: String
    let category: ChecklistCategory

    static var typeDisplayRepresentation: TypeDisplayRepresentation {
        TypeDisplayRepresentation(name: "Checklist Item")
    }

    var displayRepresentation: DisplayRepresentation {
        DisplayRepresentation(title: LocalizedStringResource(stringLiteral: name))
    }

    // This function ensures each checklist item is uniquely identified
    static let defaultQuery = CheckListItemQuery()
}

// MARK: - Query for Checklist Items


struct CheckListItemQuery: EntityQuery {
    func entities(for identifiers: [CheckListItemOption.ID]) async throws -> [CheckListItemOption] {
        let allItems = try await fetchEntities(for: nil) // Fetch all unchecked items
        return allItems.filter { identifiers.contains($0.id) }
    }

    func suggestedEntities() async throws -> [CheckListItemOption] {
        return try await fetchEntities(for: nil)
    }

    func fetchEntities(for category: ChecklistCategory?) async throws -> [CheckListItemOption] {
        let checklist = await DataController.shared.getPCOSCheckList()

        let filteredList: [CheckListItem] // Only one list at a time
        switch category {
            case .some(.morning): filteredList = checklist.morningList
            case .some(.afternoon): filteredList = checklist.afternoonList
            case .some(.evening): filteredList = checklist.eveningList
            case .some(.night): filteredList = checklist.nightList
            case .some(.common): filteredList = checklist.commonList
        case .none: filteredList = (checklist.morningList + checklist.afternoonList + checklist.eveningList + checklist.nightList + checklist.commonList)
        }
        return filteredList
            .filter { !$0.isChecked }
            .map { CheckListItemOption(id: $0.id.uuidString, name: $0.name, category: category ?? .morning) }
    }
}


struct ChecklistShortcuts: AppShortcutsProvider {
    static var appShortcuts: [AppShortcut] {
        return [
            AppShortcut(
                intent: MarkChecklist(),
                phrases: [
                    "${applicationName} mark \(\.$checklistItem) as done"
                ],
                shortTitle: LocalizedStringResource("Mark Checklist Item"),
                systemImageName: "checkmark.circle.fill"
            )
        ]
    }
}




struct MarkChecklist: AppIntent {
    static let title: LocalizedStringResource = "Mark Checklist Item as Done"
    static let description = IntentDescription("Marks a specific checklist item as completed.")

    @Parameter(title: "Time of the Day")
    var timeOfDay: ChecklistCategory

    @Parameter(title: "Checklist Item")
    var checklistItem: CheckListItemOption

    func perform() async throws -> some IntentResult & ProvidesDialog {
        let checklist = await DataController.shared.getPCOSCheckList()

        func getItemIndex(in list: [CheckListItem]) -> Int? {
            return list.firstIndex(where: { $0.name == checklistItem.name })
        }

        guard let itemIndex: Int = {
            switch timeOfDay {
                case .morning: return getItemIndex(in: checklist.morningList)
                case .afternoon: return getItemIndex(in: checklist.afternoonList)
                case .evening: return getItemIndex(in: checklist.eveningList)
                case .night: return getItemIndex(in: checklist.nightList)
                case .common: return getItemIndex(in: checklist.commonList)
            }
        }() else {
            return .result(dialog: "Checklist item '\(checklistItem.name)' not found in \(timeOfDay.rawValue).")
        }

        let checkListIndex = await DataController.shared.getSelectedCheckListIndex()
        await DataController.shared.toggleCheckItem(checkListIndex: checkListIndex, category: timeOfDay, itemIndex: itemIndex)

        return .result(dialog: "Marked '\(checklistItem.name)' as done in \(timeOfDay.rawValue) checklist!")
    }

    static let openAppWhenRun: Bool = false
}

