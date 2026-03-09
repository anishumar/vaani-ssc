import SwiftUI

/// Animates text character by character with an optional blinking cursor.
struct TypingTextView: View {
    let fullText: String
    var characterDelay: Double = 0.04
    var cursorBlinkInterval: Double = 0.5
    var onComplete: (() -> Void)? = nil

    @State private var displayedCount: Int = 0
    @State private var hasCompleted: Bool = false

    private var displayedText: String {
        let end = min(displayedCount, fullText.count)
        return String(fullText.prefix(end))
    }

    var body: some View {
        TimelineView(.periodic(from: Date(), by: cursorBlinkInterval)) { context in
            let cursorOn = context.date.timeIntervalSinceReferenceDate.remainder(dividingBy: cursorBlinkInterval * 2) < cursorBlinkInterval
            HStack(spacing: 0) {
                Text(displayedText)
                if cursorOn && displayedCount < fullText.count {
                    Text("|")
                        .foregroundStyle(.secondary)
                }
            }
        }
        .onAppear {
            startTyping()
        }
        .onChange(of: fullText) { _, _ in
            displayedCount = 0
            hasCompleted = false
            startTyping()
        }
    }

    private func startTyping() {
        guard displayedCount < fullText.count else {
            if !hasCompleted {
                hasCompleted = true
                onComplete?()
            }
            return
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + characterDelay) {
            displayedCount += 1
            if displayedCount >= fullText.count {
                if !hasCompleted {
                    hasCompleted = true
                    onComplete?()
                }
            } else {
                startTyping()
            }
        }
    }
}

/// Cycles through multiple strings, typing each one and then moving to the next.
struct CyclingTypingTextView: View {
    let phrases: [String]
    var characterDelay: Double = 0.04
    var holdDuration: Double = 2.0
    var onPhraseComplete: ((String) -> Void)? = nil

    @State private var phraseIndex: Int = 0
    @State private var displayedCount: Int = 0
    @State private var isHolding: Bool = false

    private var currentPhrase: String {
        guard !phrases.isEmpty else { return "" }
        return phrases[phraseIndex % phrases.count]
    }

    private var displayedText: String {
        let end = min(displayedCount, currentPhrase.count)
        return String(currentPhrase.prefix(end))
    }

    var body: some View {
        TimelineView(.periodic(from: Date(), by: 0.5)) { context in
            let cursorOn = context.date.timeIntervalSinceReferenceDate.remainder(dividingBy: 1.0) < 0.5
            HStack(spacing: 0) {
                Text(displayedText)
                if cursorOn && !isHolding && displayedCount < currentPhrase.count {
                    Text("|")
                        .foregroundStyle(.secondary)
                }
            }
        }
        .onAppear {
            startTyping()
        }
        .onChange(of: phraseIndex) { _, _ in
            displayedCount = 0
            isHolding = false
            startTyping()
        }
    }

    private func startTyping() {
        guard displayedCount < currentPhrase.count else {
            isHolding = true
            onPhraseComplete?(currentPhrase)
            DispatchQueue.main.asyncAfter(deadline: .now() + holdDuration) {
                phraseIndex = (phraseIndex + 1) % max(1, phrases.count)
            }
            return
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + characterDelay) {
            displayedCount += 1
            if displayedCount >= currentPhrase.count {
                isHolding = true
                onPhraseComplete?(currentPhrase)
                DispatchQueue.main.asyncAfter(deadline: .now() + holdDuration) {
                    phraseIndex = (phraseIndex + 1) % max(1, phrases.count)
                }
            } else {
                startTyping()
            }
        }
    }
}

#Preview("Single") {
    TypingTextView(fullText: "Ask Vaani...", onComplete: {})
        .padding()
}

#Preview("Cycling") {
    CyclingTypingTextView(
        phrases: [
            "What should I know about my first period?",
            "How can I track my periods?"
        ]
    )
    .padding()
}
