import SwiftUI

/// Day–night routine view for a single checklist (opened from a grid card).
struct RoutineDetailView: View {
    let checkListIndex: Int
    @State private var checkList: CheckList = DataController.shared.getCheckList(at: 0)
    @State private var isSheetPresented: Bool = false
    @State private var selectedTimeOfDay: ChecklistCategory = .morning
    @State private var overallProgress: Double = 0
    @State private var showCompletionCelebration: Bool = false

    var body: some View {
        ScrollView {
            VStack(alignment: .center, spacing: 15) {
                if !checkList.description.isEmpty {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("About this plan")
                            .font(.headline)
                            .foregroundStyle(.primary)
                        Text(checkList.description)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(12)
                    .background(Color(.secondarySystemGroupedBackground))
                    .cornerRadius(12)
                    .padding(.horizontal)
                }

                HStack(alignment: .center, spacing: 15) {
                    CheckListItemView(
                        checkListItemName: "Morning",
                        isSmall: true,
                        imageName: "Morning",
                        bg: "#DBBBF5",
                        checkListItems: checkList.morningList,
                        onTap: {
                            selectedTimeOfDay = .morning
                            isSheetPresented = true
                        }
                    )
                    CheckListItemView(
                        checkListItemName: "Afternoon",
                        isSmall: true,
                        imageName: "Afternoon", bg: "#DDF0FF",
                        checkListItems: checkList.afternoonList,
                        onTap: {
                            selectedTimeOfDay = .afternoon
                            isSheetPresented = true
                        }
                    )
                }
                HStack(alignment: .center, spacing: 15) {
                    CheckListItemView(
                        checkListItemName: "Evening",
                        isSmall: true,
                        imageName: "Evening", bg: "#DDF0FF",
                        checkListItems: checkList.eveningList,
                        onTap: {
                            selectedTimeOfDay = .evening
                            isSheetPresented = true
                        }
                    )
                    CheckListItemView(
                        checkListItemName: "Night",
                        isSmall: true,
                        imageName: "Night", bg: "#DBBBF5",
                        checkListItems: checkList.nightList,
                        onTap: {
                            selectedTimeOfDay = .night
                            isSheetPresented = true
                        }
                    )
                }

                Spacer()
            }
            .onAppear { refreshFromData() }
        }
        .navigationTitle(checkList.name)
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $isSheetPresented, onDismiss: {
            refreshFromData()
            checkAndShowCelebration()
        }) {
            CheckBoxListItemView(
                selectedTimeOfDay: $selectedTimeOfDay,
                checkList: $checkList,
                isSheetPresented: $isSheetPresented,
                checkListIndex: checkListIndex
            )
        }
        .overlay {
            if showCompletionCelebration {
                completionCelebrationOverlay
            }
        }
        .onChange(of: overallProgress) { _, _ in
            checkAndShowCelebration()
        }
    }

    private var completionCelebrationOverlay: some View {
        ZStack {
            Color.black.opacity(0.3)
                .ignoresSafeArea()
            VStack(spacing: 24) {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 56))
                    .foregroundStyle(.green)
                    .symbolRenderingMode(.hierarchical)
                VStack(spacing: 4) {
                    Text("You did it!")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundStyle(.primary)
                    Text("Plan complete for today")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                Button("Done") {
                    showCompletionCelebration = false
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
                .padding(.top, 4)
            }
            .padding(28)
            .frame(maxWidth: 280)
            .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
            .shadow(color: .black.opacity(0.15), radius: 20, y: 10)
        }
    }

    private func checkAndShowCelebration() {
        guard overallProgress >= 100 else { return }
        let key = "lastCelebrationDate_\(checkListIndex)"
        let last = UserDefaults.standard.string(forKey: key)
        let today = dayString(from: Date())
        guard last != today else { return }
        UserDefaults.standard.set(today, forKey: key)
        showCompletionCelebration = true
        DataController.shared.recordPlanCompletionDate()
    }

    private func dayString(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = TimeZone.current
        return formatter.string(from: date)
    }

    private func refreshFromData() {
        checkList = DataController.shared.getCheckList(at: checkListIndex)
        overallProgress = checkList.progress
    }
}

#Preview {
    NavigationStack {
        RoutineDetailView(checkListIndex: 0)
    }
}
