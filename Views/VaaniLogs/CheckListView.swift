import SwiftUI
struct CheckListView: View {
    @State private var checkList: CheckList = DataController.shared.getSelectedCheckList()
    @State private var selectedList: [CheckListItem] = []
    @State private var isSheetPresented: Bool = false
    @State private var selectedTimeOfDay: ChecklistCategory = .morning
    @State private var overallProgress: Double = DataController.shared.getCheckListsProgress()
    @State private var selectedCheckListIndex: Int = DataController.shared.getSelectedCheckListIndex()

    var body: some View {
            ScrollView {
                VStack(alignment: .center, spacing: 15) {
                    // Checklist type picker
                    VStack(alignment: .leading, spacing: 8) {
                        Text("My checklist")
                            .font(.headline)
                            .foregroundStyle(.primary)
                        Menu {
                            ForEach(Array(DataController.shared.getCheckLists().enumerated()), id: \.offset) { index, list in
                                Button(list.name) {
                                    selectedCheckListIndex = index
                                    DataController.shared.setSelectedCheckListIndex(index)
                                    checkList = DataController.shared.getCheckList(at: index)
                                    overallProgress = DataController.shared.getCheckListsProgress()
                                }
                            }
                        } label: {
                            HStack {
                                Text(checkList.name)
                                    .foregroundStyle(.primary)
                                Image(systemName: "chevron.down")
                                    .font(.caption)
                                    .foregroundStyle(.primary)
                            }
                            .padding(.horizontal, 12)
                            .padding(.vertical, 10)
                            .background(Color(.secondarySystemGroupedBackground))
                            .cornerRadius(10)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)

                    HStack {
                        VStack(alignment: .leading) {
                            Text("\(String(format: "%.0f", overallProgress))%")
                                .font(.title)
                                .bold()
                            Text("Overall progress")
                                .font(.headline)
                            ProgressView(value: overallProgress, total: 100)
                        }
                        .padding(15)
                        Spacer()
                    }

                    HStack(alignment: .center, spacing: 15) {
                        CheckListItemView(
                            checkListItemName: "Morning",
                            isSmall: true,
                            imageName: "Morning",
                            bg: "#DBBBF5",
                            checkListItems: checkList.morningList,
                            onTap: {
                                selectedList = checkList.morningList
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
                                selectedList = checkList.afternoonList
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
                                selectedList = checkList.eveningList
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
                                selectedList = checkList.nightList
                                selectedTimeOfDay = .night
                                isSheetPresented = true
                            }

                        )
                    }

                    CheckListItemView(
                        checkListItemName: "Whole day common",
                        isSmall: false,
                        imageName: "Common", bg: "#DBBBF5",
                        checkListItems: checkList.commonList,
                        onTap: {
                            selectedList = checkList.commonList
                            selectedTimeOfDay = .common
                            isSheetPresented = true
                        }
                    )
                    Spacer()
                }
                .onAppear {
                    selectedCheckListIndex = DataController.shared.getSelectedCheckListIndex()
                    checkList = DataController.shared.getCheckList(at: selectedCheckListIndex)
                    overallProgress = DataController.shared.getCheckListsProgress()
                }
            }
            .sheet(isPresented: $isSheetPresented, onDismiss: {
                overallProgress = DataController.shared.getCheckListsProgress()
                checkList = DataController.shared.getSelectedCheckList()
            }) {
                CheckBoxListItemView(selectedTimeOfDay: $selectedTimeOfDay, checkList: $checkList, isSheetPresented: $isSheetPresented, checkListIndex: selectedCheckListIndex)
            }
    }
}

struct CheckListItemView: View {
    var checkListItemName: String
    var isSmall: Bool
    var imageName: String
    var bg: String
    var checkListItems: [CheckListItem]
    var onTap: () -> Void
    var body: some View {
        ZStack {
            VStack(alignment: .leading) {
                Text("\(completedTasksCount(for: checkListItems))/\(checkListItems.count)")
                    .font(.headline)
                Text(checkListItemName)
                    .font(.subheadline)
                HStack {
                    Spacer()
                    Image(imageName)
                        .resizable()
                        .scaledToFit()
                }
            }
            .foregroundStyle(.primary)
        }
        .frame(width: isSmall ? 150 : 345, height: 150)
        .padding()
        .background(Color(hex: bg))
        .cornerRadius(12)
//        .shadow(radius: 3)
        .onTapGesture {
            onTap()  // Call the closure to update selectedList & show sheet
        }
    }
    
    func completedTasksCount(for list: [CheckListItem]) -> Int {
        return list.filter { $0.isChecked }.count
    }
}

#Preview {
    CheckListView()
}

