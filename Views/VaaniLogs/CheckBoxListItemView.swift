import SwiftUI


struct CheckBoxListItemView: View {
    @Binding var selectedTimeOfDay: ChecklistCategory
    @Binding var checkList: CheckList
    @Binding var isSheetPresented: Bool
    var checkListIndex: Int
    let generator = UIImpactFeedbackGenerator(style: .light)
    @State private var showAddItem = false
    @State private var newItemName = ""

    var body: some View {
        VStack {
            HStack(alignment: .top) {
                Button(action: {
                    isSheetPresented = false
                }) {
                    HStack(spacing: 4) {
                        Image(systemName: "chevron.left")
                        Text("Back")
                    }
                }
                Spacer()
                Button("Done") {
                    isSheetPresented = false
                }
                .font(.subheadline)
                .fontWeight(.semibold)
            }
            .background(Color.clear)
            .padding()
            
            List {
                ForEach(getTimeOfDay()) { item in
                    let index = getTimeOfDay().firstIndex(where: { $0.id == item.id }) ?? 0
                    let isEven = index % 2 == 0
                    Button(action: {
                        toggleCheckItem(index: index)
                    }) {
                        HStack(spacing: 10) {
                            Group {
                                if item.isChecked {
                                    Image("Vaani_Tick")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 50, height: 50)
                                } else {
                                    Image(systemName: "circle")
                                        .foregroundStyle(.primary)
                                        .font(.system(size: 20))
                                        .frame(width: 40, height: 40)
                                }
                            }
                            .frame(width: 50, alignment: .leading)

                            Text(item.name)
                                .foregroundStyle(.primary)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.vertical, 22)
                                .multilineTextAlignment(.leading)

                            if item.isUserAdded {
                                Button {
                                    DataController.shared.removeCheckListItem(checkListIndex: checkListIndex, category: selectedTimeOfDay, itemId: item.id)
                                    checkList = DataController.shared.getCheckList(at: checkListIndex)
                                } label: {
                                    Image(systemName: "trash")
                                        .foregroundStyle(.red)
                                        .font(.body)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }
                    .padding(5)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color(.tertiarySystemGroupedBackground))
                    .cornerRadius(12)
                    .padding(.vertical, 10)
                    .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                    .listRowBackground(Color.clear)
                    .listRowSeparator(Visibility.hidden)
                }

                Button {
                    showAddItem = true
                } label: {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                        Text("Add custom item")
                    }
                    .foregroundStyle(Color.accentColor)
                    .padding(.vertical, 12)
                }
                .listRowBackground(Color.clear)
            }
        }
        .sheet(isPresented: $showAddItem) {
            addItemSheet
        }
    }

    private var addItemSheet: some View {
        NavigationStack {
            VStack(spacing: 16) {
                TextField("Item name", text: $newItemName)
                    .textFieldStyle(.roundedBorder)
                    .padding()
                Spacer()
            }
            .padding(.top)
            .navigationTitle("Add item")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        newItemName = ""
                        showAddItem = false
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") {
                        addCustomItem()
                    }
                    .disabled(newItemName.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
        }
    }

    private func addCustomItem() {
        let name = newItemName.trimmingCharacters(in: .whitespaces)
        guard !name.isEmpty else { return }
        DataController.shared.addCheckListItem(checkListIndex: checkListIndex, category: selectedTimeOfDay, name: name)
        checkList = DataController.shared.getCheckList(at: checkListIndex)
        newItemName = ""
        showAddItem = false
        generator.impactOccurred()
    }

    
    func getTimeOfDay() -> [CheckListItem] {
        switch selectedTimeOfDay {
        case .morning:
            return checkList.morningList
        case .afternoon:
            return checkList.afternoonList
        case .evening:
            return checkList.eveningList
        case .night:
            return checkList.nightList
        case .common:
            return checkList.commonList
        }
    }
    
    func toggleCheckItem(index: Int) {
        switch selectedTimeOfDay {
        case .morning:
            checkList.morningList[index].isChecked.toggle()
        case .afternoon:
            checkList.afternoonList[index].isChecked.toggle()
        case .evening:
            checkList.eveningList[index].isChecked.toggle()
        case .night:
            checkList.nightList[index].isChecked.toggle()
        case .common:
            checkList.commonList[index].isChecked.toggle()
        }
        generator.impactOccurred()
        DataController.shared.toggleCheckItem(checkListIndex: checkListIndex, category: selectedTimeOfDay, itemIndex: index)
    }
}
