import SwiftUI

struct ConditionListView: View {
    private let conditions = DataController.shared.getConditions()

    var body: some View {
        List {
            ForEach(conditions) { condition in
                NavigationLink {
                    ConditionDetailView(condition: condition)
                } label: {
                    HStack(spacing: 12) {
                        if let img = condition.imageName {
                            Image(img)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 48, height: 48)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                        VStack(alignment: .leading, spacing: 2) {
                            Text(condition.title)
                                .font(.subheadline.weight(.medium))
                            Text(condition.summary)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                                .lineLimit(2)
                        }
                    }
                    .padding(.vertical, 4)
                }
            }
        }
        .navigationTitle("Conditions & health")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct ConditionDetailView: View {
    let condition: ConditionInfo

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                if let img = condition.imageName {
                    Image(img)
                        .resizable()
                        .scaledToFill()
                        .frame(maxWidth: .infinity)
                        .frame(height: 180)
                        .clipped()
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                        .padding(.horizontal)
                }
                Text(condition.summary)
                    .font(.body)
                Text("When to see a doctor")
                    .font(.headline)
                Text(condition.whenToSeeDoctor)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                if let tip = condition.tipWhenSelected {
                    Text("Tip")
                        .font(.headline)
                    Text(tip)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                if condition.storyIndex != nil {
                    Text("Learn more")
                        .font(.headline)
                    Text("Play the story in Vaani's Life to learn more.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
        }
        .navigationTitle(condition.title)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        ConditionListView()
    }
}
