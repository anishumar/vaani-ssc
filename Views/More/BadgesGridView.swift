import SwiftUI

struct BadgesGridView: View {
    private let dc = DataController.shared
    private var definitions: [BadgeDef] { dc.getBadgeDefinitions() }
    private var unlockedIds: Set<String> { dc.getUnlockedBadgeIds() }

    private let columns: [GridItem] = [GridItem(.adaptive(minimum: 90))]

    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(definitions, id: \.id) { badge in
                    let isUnlocked = unlockedIds.contains(badge.id)
                    VStack(spacing: 8) {
                        if let customImage = badge.customImage {
                            Image(customImage)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 56, height: 56)
                                .grayscale(isUnlocked ? 0 : 1)
                                .opacity(isUnlocked ? 1 : 0.4)
                        } else {
                            Image(systemName: badge.systemImage)
                                .font(.system(size: 36))
                                .foregroundStyle(isUnlocked ? Color.accentColor : .gray.opacity(0.5))
                        }
                        Text(badge.title)
                            .font(.caption2)
                            .multilineTextAlignment(.center)
                            .lineLimit(2)
                            .foregroundStyle(isUnlocked ? .primary : .secondary)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(Color(.secondarySystemGroupedBackground))
                    .cornerRadius(12)
                }
            }
            .padding()
        }
        .navigationTitle("Badges")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        BadgesGridView()
    }
}
