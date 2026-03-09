import SwiftUI

struct MythBusterCardView: View {
    private let facts = DataController.shared.getMythFacts()
    @State private var index: Int = 0

    private var current: MythFact? {
        guard !facts.isEmpty else { return nil }
        let i = (index % facts.count + facts.count) % facts.count
        return facts[i]
    }

    var body: some View {
        if let item = current {
            VStack(alignment: .leading, spacing: 0) {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Myth")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundStyle(.secondary)
                    Text(item.myth)
                        .font(.subheadline)
                        .foregroundStyle(.primary)
                        .fixedSize(horizontal: false, vertical: true)
                    Text("Fact")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundStyle(.secondary)
                        .padding(.top, 4)
                    Text(item.fact)
                        .font(.subheadline)
                        .foregroundStyle(.primary)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .frame(maxWidth: .infinity, alignment: .topLeading)

                HStack {
                    Spacer()
                    Button("Next") {
                        withAnimation { index += 1 }
                    }
                    .font(.caption.weight(.medium))
                }
                .padding(.top, 12)
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .topLeading)
            .background(Color(.secondarySystemGroupedBackground))
            .cornerRadius(12)
        }
    }
}

#Preview {
    MythBusterCardView()
        .padding()
}
