import SwiftUI

struct MessagesView: View {
    var message: Message
    var showSuggestions: Bool = true
    var displayedSuggestions: [QAItem] = []
    var onSuggestedQuestionTap: ((QAItem) -> Void)? = nil
    var onBrowseTap: (() -> Void)? = nil

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .top, spacing: 10) {
                if message.isUser {
                    Spacer(minLength: 48)
                    bubble(content: message.text, isUser: true)
                } else {
                    avatar
                    bubble(content: message.text, isUser: false)
                    Spacer(minLength: 48)
                }
            }

            if showSuggestions && !message.isUser && (!displayedSuggestions.isEmpty || !message.suggestedQuestions.isEmpty) {
                suggestedQuestionsSection
            }
        }
    }

    private var suggestedQuestionsSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Suggested questions")
                .font(.caption)
                .fontWeight(.medium)
                .foregroundStyle(.secondary)
            ScrollView(.horizontal, showsIndicators: false) {
                VStack(alignment: .leading, spacing: 8) {
                    HStack(spacing: 8) {
                        ForEach(firstRowItems) { item in
                            suggestedChip(item)
                        }
                        if secondRowItems.isEmpty {
                            browseButton
                        }
                    }
                    if !secondRowItems.isEmpty {
                        HStack(spacing: 8) {
                            ForEach(secondRowItems) { item in
                                suggestedChip(item)
                            }
                            browseButton
                        }
                    }
                }
                .padding(.vertical, 4)
            }
        }
    }

    private var firstRowItems: [QAItem] {
        let mid = (displayedSuggestions.count + 1) / 2
        return Array(displayedSuggestions.prefix(mid))
    }

    private var secondRowItems: [QAItem] {
        let mid = (displayedSuggestions.count + 1) / 2
        return Array(displayedSuggestions.dropFirst(mid))
    }

    private var browseButton: some View {
        Button(action: { onBrowseTap?() }) {
            HStack(spacing: 6) {
                Image(systemName: "square.grid.2x2")
                Text("Browse topics")
            }
            .font(.subheadline)
            .foregroundStyle(.secondary)
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(Color(.systemBackground))
            .cornerRadius(10)
        }
        .buttonStyle(.plain)
    }

    private func suggestedChip(_ item: QAItem) -> some View {
        Button(action: { onSuggestedQuestionTap?(item) }) {
            Text(item.question)
                .font(.subheadline)
                .foregroundStyle(.primary)
                .multilineTextAlignment(.leading)
                .lineLimit(2)
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(Color(.systemBackground))
                .cornerRadius(10)
        }
        .buttonStyle(.plain)
    }

    private var avatar: some View {
        Image("App-Logo")
            .resizable()
            .scaledToFit()
            .frame(width: 28, height: 28)
            .cornerRadius(8)
    }

    private func bubble(content: String, isUser: Bool) -> some View {
        Text(content)
            .font(.body)
            .foregroundStyle(isUser ? .white : .primary)
            .multilineTextAlignment(.leading)
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 18)
                    .fill(isUser ? Color.accentColor : Color(.secondarySystemGroupedBackground))
            )
            .frame(maxWidth: 280, alignment: isUser ? .trailing : .leading)
            .layoutPriority(-1)
    }
}

#Preview {
    VStack(spacing: 12) {
        MessagesView(message: Message(text: "What is PCOS?", isUser: true))
        MessagesView(
            message: Message(text: "PCOS is a hormonal imbalance...", isUser: false, suggestedQuestions: []),
            displayedSuggestions: [
                QAItem(question: "What causes irregular periods?", answer: ""),
                QAItem(question: "How to track my cycle?", answer: "")
            ]
        )
    }
    .padding()
}
