
import SwiftUI

struct QuestionCategorySelectionView: View {
    @Binding var isShowingQuestionSelector: Bool
    @Binding var isConversing: Bool
    @Environment(\.colorScheme) private var colorScheme
    let categories = DataController.shared.getAllQuestionCategories()
    let onQuestionSelected: (QAItem) -> Void
    
    var body: some View {
        let isDark = colorScheme == .dark
        ScrollView {
            LazyVGrid(columns: [GridItem(.flexible(), spacing: 12), GridItem(.flexible())], spacing: 12) {
                ForEach(categories.indices, id: \.self) { index in
                    let row = index / 2
                    let col = index % 2
                    let isEvenDiagonal = (row + col) % 2 == 0
                    let backgroundColor = isDark
                        ? Color(hex: isEvenDiagonal ? "#3D2E4F" : "#2E3D4F")
                        : Color(hex: isEvenDiagonal ? "#DBBBF5" : "#DDF0FF")
                    
                    NavigationLink {
                        QuestionListView(isConversing: $isConversing, isShowingQuestionSelector: $isShowingQuestionSelector, category: categories[index], onSelect: onQuestionSelected)
                    }
                    label: {
                        Text(categories[index].name)
                            .padding()
                            .frame(maxWidth: .infinity, minHeight: 100)
                            .background(backgroundColor)
                            .foregroundStyle(.primary)
                            .cornerRadius(12)
                    }
                }
            }
            .padding()
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Choose a Category")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct QuestionListView: View {
    @Binding var isConversing: Bool
    @Binding var isShowingQuestionSelector: Bool
    let category: QuestionCategory
    let onSelect: (QAItem) -> Void
    
    var body: some View {
        List(category.items) { item in
            Button(action: {
                onSelect(item)
                isShowingQuestionSelector = false
                isConversing = true
            }) {
                VStack(alignment: .leading) {
                    Text(item.question)
                        .foregroundColor(.primary)
                    Text("Tap to see answer")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
        }
        .navigationTitle(category.name)
    }
}

