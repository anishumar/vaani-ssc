import SwiftUI

struct StorySceneView: View {
    var characterImage: String?
    var storyTitle: String?
    var description: String?
    var backgroundImage: String?
    var body: some View {
        ZStack {
            VStack {
                Image(backgroundImage ?? "")
                    .resizable()
                Spacer()
            }
            VStack {
                Spacer().frame(height: 60)
                Image(characterImage ?? "Vaani_VeryHappy")
                    .resizable()
                    .scaledToFit()
                    .animation(.smooth, value: characterImage)
                Spacer()
            }
            
            GradientView()
            VStack(alignment: .center, spacing: 30) {
                Spacer()
                Spacer()
                Spacer()
                Spacer()
                Text(description ?? "She remembers a health class where they mentioned something about periods.")
                    .font(.body)
                    .padding()
                    .foregroundStyle(.white)
                    .background(Color.indigo.opacity(0.7))
                    .cornerRadius(12)
                    .padding()
                
                Text("Tap to continue")
                    .foregroundStyle(.white)
            }
            .padding(.bottom, 20.0)
            
        }
    }
}

struct NewStoryGradientView: View {
    
    var body: some View {
        ZStack {
                LinearGradient(
                gradient: Gradient(colors: [
                    Color.purple.opacity(0),
                    Color.purple.opacity(0.1),
                    Color.purple.opacity(0.3),
                    Color.purple.opacity(0.4),
                    Color.purple.opacity(0.5),
                    Color.purple.opacity(0.5),
                    Color.purple.opacity(0.5),
                    Color.purple.opacity(0.5),
                    Color.purple.opacity(0.4),
                    Color.purple.opacity(0.3),
                    Color.purple.opacity(0.1),
                    Color.purple.opacity(0),
                ]),
                startPoint: .trailing,
                endPoint: .leading
            )
            Text("New Story")
                .font(.system(size: 50,weight: .bold))
                .bold()
                .foregroundColor(.yellow)
                .shadow(color: .purple, radius: 30)
                .shadow(color: .purple, radius: 50)
                .shadow(color: .purple, radius: 50)
                .shadow(color: .purple, radius: 50)
            
        }
    }
}

#Preview {
    StorySceneView()
}
