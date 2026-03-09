
import SwiftUI

struct InitalStorySceneView: View {
    var body: some View {
        ZStack {
            VStack {
                Image("Vaani_Happy")
                    .resizable()
                    .scaledToFit()
                Spacer()
            }
            
            VStack {
                Spacer()
                GradientView()
            }
            VStack(spacing: 20) {
                Spacer()
                Spacer()
                Spacer()
                Text("Step into the story")
                    .bold()
                    .font(.title)
                Text("Tap to begin!")
                    .font(.title2)
                Spacer()
            }
            .foregroundStyle(.white)
            .shadow(radius: 20)
            
        }
    }
}

struct GradientView: View {
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [
                    Color.purple.opacity(1.0),
                    Color.purple.opacity(0.9),
                    Color.purple.opacity(0.8),
                    Color.purple.opacity(0.7),
                    Color.purple.opacity(0.3),
                    Color.purple.opacity(0.2),
                    Color.purple.opacity(0.1),
                    Color.purple.opacity(0),
                ]),
                startPoint: .bottom,
                endPoint: .top
            )
        }
        
    }
}

#Preview {
    InitalStorySceneView()
}
