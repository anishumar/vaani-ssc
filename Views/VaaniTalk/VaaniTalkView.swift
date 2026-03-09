import SwiftUI

struct VaaniTalkView: View {
    @State private var messages: [Message] = []
    @State private var isShowingQuestionSelector = false
    @State private var currentCyclingPhrase: String = ""

    private let suggestedItems = DataController.shared.getSuggestedQAItems()
    private static let cyclingQuestions = [
        "How do I use a tampon?",
        "How can I track my periods?"
    ]

    var body: some View {
        VStack(spacing: 0) {
            if !messages.isEmpty {
                newChatButton
            }

            if messages.isEmpty {
                emptyState
            } else {
                messageList
            }

            inputBar
        }
        .background(Color(.systemGroupedBackground))
        .sheet(isPresented: $isShowingQuestionSelector) {
            NavigationStack {
                QuestionCategorySelectionView(isShowingQuestionSelector: $isShowingQuestionSelector, isConversing: .constant(true)) { selectedQA in
                    addQA(selectedQA)
                }
            }
            .presentationDetents([.medium, .large])
        }
    }

    private var newChatButton: some View {
        HStack {
            Spacer()
            Button(action: {
                withAnimation { messages.removeAll() }
            }) {
                Image(systemName: "plus.bubble")
                    .font(.system(size: 18))
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .background(Color(.systemGroupedBackground))
    }

    private var emptyState: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Hello, \(DataController.shared.getUserName())")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundStyle(.primary)
                    Text("How can I help you today?")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .padding(.horizontal, 20)
                .padding(.top, 24)

                VStack(alignment: .leading, spacing: 12) {
                    Text("Suggested questions")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundStyle(.secondary)

                    VStack(alignment: .leading, spacing: 0) {
                        ForEach(suggestedItems) { item in
                            Button(action: { addQA(item) }) {
                                Text(item.question)
                                    .font(.subheadline)
                                    .foregroundStyle(.primary)
                                    .multilineTextAlignment(.leading)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            .buttonStyle(.plain)
                            .padding(.vertical, 10)
                        }

                        Button(action: { isShowingQuestionSelector = true }) {
                            HStack(spacing: 6) {
                                Image(systemName: "square.grid.2x2")
                                Text("Browse topics")
                            }
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        }
                        .buttonStyle(.plain)
                        .padding(.vertical, 10)
                    }
                }
                .padding(16)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color(.secondarySystemGroupedBackground))
                .cornerRadius(16)
                .padding(.horizontal, 20)
                .padding(.bottom, 40)
            }
        }
        .scrollDismissesKeyboard(.interactively)
    }

    private var messageList: some View {
        ScrollViewReader { proxy in
            ScrollView {
                LazyVStack(spacing: 12) {
                    ForEach(messages) { message in
                        let asked = Set(messages.filter { $0.isUser }.map { $0.text.trimmingCharacters(in: .whitespacesAndNewlines) })
                        let baseSuggested = message.suggestedQuestions.filter { !asked.contains($0.question.trimmingCharacters(in: .whitespacesAndNewlines)) }
                        let needed = 6 - baseSuggested.count
                        let supplement = needed > 0
                            ? DataController.shared.getSuggestedQAItems(
                                limit: needed,
                                excluding: asked.union(Set(baseSuggested.map { $0.question.trimmingCharacters(in: .whitespacesAndNewlines) }))
                            )
                            : []
                        let displayedSuggestions = Array((baseSuggested + supplement).prefix(6))
                        return MessagesView(
                            message: message,
                            showSuggestions: message.id == messages.last?.id,
                            displayedSuggestions: displayedSuggestions,
                            onSuggestedQuestionTap: addQA,
                            onBrowseTap: { isShowingQuestionSelector = true }
                        )
                        .id(message.id)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .padding(.bottom, 8)
            }
            .scrollDismissesKeyboard(.interactively)
            .onChange(of: messages) { _, _ in
                withAnimation(.easeOut(duration: 0.2)) {
                    if let last = messages.last {
                        proxy.scrollTo(last.id, anchor: .bottom)
                    }
                }
            }
        }
    }

    private var inputBar: some View {
        HStack(alignment: .bottom, spacing: 12) {
            Button(action: { isShowingQuestionSelector = true }) {
                ZStack(alignment: .leading) {
                    CyclingTypingTextView(
                        phrases: Self.cyclingQuestions,
                        characterDelay: 0.04,
                        holdDuration: 2.0,
                        onPhraseComplete: { phrase in
                            currentCyclingPhrase = phrase
                        }
                    )
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .foregroundStyle(Color(.placeholderText))
                }
                .frame(minWidth: 100, maxWidth: 280)
            }
            .buttonStyle(.plain)
            .background(Color(.systemBackground))
            .cornerRadius(20)

            Spacer(minLength: 0)

            Button(action: askCurrentCyclingQuestion) {
                Image(systemName: "arrow.up.circle.fill")
                    .font(.system(size: 32))
                    .foregroundStyle(Color.accentColor)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color(.systemBackground))
    }

    private func addQA(_ item: QAItem) {
        messages.append(Message(text: item.question, isUser: true))
        DataController.shared.incrementQuestionsAsked()
        let result = DataController.shared.searchQAItems(query: item.question)
        let suggested = result.relatedQuestions.isEmpty ? suggestedItems : Array(result.relatedQuestions.prefix(6))
        messages.append(Message(text: item.answer, isUser: false, suggestedQuestions: suggested))
        isShowingQuestionSelector = false
    }

    private func askCurrentCyclingQuestion() {
        let query = currentCyclingPhrase.isEmpty ? Self.cyclingQuestions[0] : currentCyclingPhrase
        let result = DataController.shared.searchQAItems(query: query)
        if let item = result.items.first {
            addQA(item)
        }
    }
}

struct FlowLayout: Layout {
    var spacing: CGFloat = 8

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let result = arrange(proposal: proposal, subviews: subviews)
        return result.size
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let result = arrange(proposal: proposal, subviews: subviews)
        for (index, position) in result.positions.enumerated() {
            subviews[index].place(at: CGPoint(x: bounds.minX + position.x, y: bounds.minY + position.y), proposal: .unspecified)
        }
    }

    private func arrange(proposal: ProposedViewSize, subviews: Subviews) -> (size: CGSize, positions: [CGPoint]) {
        let maxWidth = proposal.width ?? 360
        var positions: [CGPoint] = []
        var x: CGFloat = 0
        var y: CGFloat = 0
        var rowHeight: CGFloat = 0

        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)
            if x + size.width > maxWidth && x > 0 {
                x = 0
                y += rowHeight + spacing
                rowHeight = 0
            }
            positions.append(CGPoint(x: x, y: y))
            x += size.width + spacing
            rowHeight = max(rowHeight, size.height)
        }

        let totalHeight = y + rowHeight
        return (CGSize(width: maxWidth, height: totalHeight), positions)
    }
}

#Preview {
    VaaniTalkView()
}
