import SwiftUI

struct VaaniLogsView: View {
    @State private var enabledIndices: [Int] = DataController.shared.getEnabledCheckListIndices()
    @State private var showEditSheet = false

    var body: some View {
        NavigationStack {
            Group {
                if enabledIndices.isEmpty {
                    ChecklistSelectionView(onSave: { indices in
                        enabledIndices = indices
                    })
                } else {
                    ChecklistGridView(
                        enabledIndices: enabledIndices,
                        onEdit: { showEditSheet = true },
                        onReorder: { newOrder in
                            enabledIndices = newOrder
                            DataController.shared.setEnabledCheckListIndices(newOrder)
                        }
                    )
                }
            }
            .onAppear {
                enabledIndices = DataController.shared.getEnabledCheckListIndices()
            }
            .sheet(isPresented: $showEditSheet) {
                NavigationStack {
                    ChecklistSelectionView(isEditing: true, onSave: { indices in
                        enabledIndices = indices
                    })
                }
            }
        }
    }
}

#Preview {
    VaaniLogsView()
}
