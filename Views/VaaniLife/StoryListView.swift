import SwiftUI

/// Main story list shown when opening Vaani's Life tab. Tap a card to open that story.
struct StoryListView: View {
    @AppStorage("currentStoryIndex") private var storedStoryIndex: Int = -1
    @Environment(\.colorScheme) private var colorScheme
    let onSelectStory: (Int) -> Void
    private let allStories = DataController.shared.getAllStories()

    var body: some View {
        let generator = UIImpactFeedbackGenerator(style: .soft)
        let isDark = colorScheme == .dark
        ScrollView {
            LazyVStack(spacing: 15) {
                ForEach(allStories.indices, id: \.self) { index in
                    let imageName = allStories[index].storyImage
                    let title = allStories[index].title
                    let isEven = index % 2 == 0
                    let backgroundColor = isDark
                        ? Color(hex: isEven ? "#3D2E4F" : "#2E3D4F")
                        : Color(hex: isEven ? "#DBBBF5" : "#DDF0FF")
                    HStack(alignment: .bottom) {
                        VStack(alignment: .leading) {
                            Image("Vaani_Tick")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 50)
                                .opacity(index < max(0, storedStoryIndex) ? 1 : 0)
                            Spacer()
                            Text(title)
                                .font(.headline)
                                .foregroundStyle(.primary)
                                .lineLimit(3)
                                .multilineTextAlignment(.leading)
                            Spacer()
                        }
                        .padding(10)
                        Spacer()
                        Image(imageName)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100)
                            .padding()
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .frame(height: 170)
                    .background(backgroundColor)
                    .cornerRadius(15)
                    .onTapGesture {
                        generator.impactOccurred()
                        onSelectStory(index)
                    }
                    .contentShape(Rectangle())
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
        }
    }
}
