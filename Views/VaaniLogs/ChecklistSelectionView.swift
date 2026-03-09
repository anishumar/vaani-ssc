import SwiftUI

/// Screen where user selects which disease checklists to show in the Plans tab.
struct ChecklistSelectionView: View {
    @State private var selectedIndices: Set<Int> = Set(DataController.shared.getEnabledCheckListIndices())
    var isEditing: Bool = false
    var onSave: ([Int]) -> Void = { _ in }
    @Environment(\.dismiss) private var dismiss

    /// Display order: PCOS, Thyroid, PCOD, Anemia, Endometriosis... (separates similar ovary/uterus icons)
    private static let displayOrder = [0, 3, 1, 4, 2, 5, 6, 7, 8]

    private var allChecklists: [(index: Int, list: CheckList)] {
        let lists = DataController.shared.getCheckLists()
        return Self.displayOrder.map { ($0, lists[$0]) }
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                if !isEditing {
                    Text("Track what matters to you.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .padding(.horizontal)
                }

                LazyVStack(spacing: 12) {
                    ForEach(Array(allChecklists.enumerated()), id: \.element.index) { _, item in
                        let index = item.index
                        let list = item.list
                        let isOn = selectedIndices.contains(index)
                        Button {
                            if isOn {
                                selectedIndices.remove(index)
                            } else {
                                selectedIndices.insert(index)
                            }
                        } label: {
                            ChecklistSelectionCard(
                                name: list.name,
                                conditionBrief: list.conditionBrief,
                                iconImageName: diseaseIconName(for: list.name),
                                isSelected: isOn
                            )
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal)

                if !isEditing {
                    Button {
                        let indices = Array(selectedIndices).sorted()
                        guard !indices.isEmpty else { return }
                        DataController.shared.setEnabledCheckListIndices(indices)
                        onSave(indices)
                    } label: {
                        Text("Continue")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(selectedIndices.isEmpty ? Color.gray.opacity(0.25) : Color.accentColor)
                            .foregroundStyle(selectedIndices.isEmpty ? Color.secondary : Color.white)
                            .cornerRadius(12)
                    }
                    .buttonStyle(.plain)
                    .disabled(selectedIndices.isEmpty)
                    .padding(.horizontal)
                    .padding(.top, 4)
                }
            }
            .padding(.vertical, 20)
        }
        .background(Color(UIColor.systemGroupedBackground))
        .navigationTitle(isEditing ? "Edit Topics" : "Choose Topics")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                if isEditing {
                    Button("Cancel") { dismiss() }
                }
            }
            ToolbarItem(placement: .confirmationAction) {
                if isEditing {
                    Button("Save") {
                        let indices = Array(selectedIndices).sorted()
                        if !indices.isEmpty {
                            DataController.shared.setEnabledCheckListIndices(indices)
                            onSave(indices)
                            dismiss()
                        }
                    }
                    .disabled(selectedIndices.isEmpty)
                    .fontWeight(.semibold)
                }
            }
        }
        .onAppear {
            let current = DataController.shared.getEnabledCheckListIndices()
            if !current.isEmpty {
                selectedIndices = Set(current)
            }
        }
    }
}

private func diseaseIconName(for name: String) -> String? {
    switch name {
    case "PCOS": return "PCOS"
    case "PCOD": return "PCOD"
    case "Endometriosis": return "Endometriosis"
    case "Thyroid": return "Thyroid"
    case "Anemia": return "Anemia"
    case "PMS / PMDD": return "PMS_PMDD"
    case "Irregular periods": return "IrregularPeriods"
    case "UTI prevention": return "UTIPrevention"
    case "General wellness": return "GeneralWellness"
    default: return nil
    }
}

/// Left half: title + description. Right half: icon. Checkmark in bottom right corner.
private struct ChecklistSelectionCard: View {
    let name: String
    let conditionBrief: String
    var iconImageName: String? = nil
    let isSelected: Bool

    private let cardHeight: CGFloat = 190
    private let iconSize: CGFloat = 115

    var body: some View {
        HStack(alignment: .center, spacing: 16) {
            // Left half: title + description
            VStack(alignment: .leading, spacing: 6) {
                Text(name)
                    .font(.headline)
                    .foregroundStyle(.primary)
                Text(conditionBrief)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.leading)
                    .lineLimit(6)
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            // Right half: icon
            Group {
                if let icon = iconImageName {
                    Image(icon)
                        .resizable()
                        .scaledToFit()
                        .frame(width: iconSize, height: iconSize)
                } else {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(.tertiarySystemFill))
                        .frame(width: iconSize, height: iconSize)
                        .overlay(
                            Image(systemName: "leaf.fill")
                                .font(.system(size: 40))
                                .foregroundStyle(Color(.tertiaryLabel))
                        )
                }
            }
            .frame(width: iconSize, height: iconSize)
            .frame(maxWidth: .infinity, alignment: .center)
        }
        .padding(16)
        .frame(height: cardHeight)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(isSelected ? Color.accentColor.opacity(0.15) : Color(.secondarySystemGroupedBackground))
        .cornerRadius(15)
        .overlay(alignment: .bottomTrailing) {
            Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                .font(.title2)
                .foregroundStyle(isSelected ? Color.accentColor : Color(.tertiaryLabel))
                .padding(12)
        }
    }
}

#Preview {
    ChecklistSelectionView()
}
