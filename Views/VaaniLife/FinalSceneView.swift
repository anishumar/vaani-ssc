import SwiftUI

struct FinalSceneView: View {
    var text: String?
    var characterImageName: String = "Vaani_Satisfied"
    
    var body: some View {
        ZStack {
            VStack {
                Spacer().frame(height: 60)
                Image(characterImageName)
                    .resizable()
                    .scaledToFit()
                Spacer()
            }
            
            GradientView()
            VStack(alignment: .center, spacing: 30) {
                Spacer()
                Spacer()
                Spacer()
                Spacer()
                if let text {
                    Text(text)
                        .font(.body)
                        .padding()
                        .foregroundStyle(.white)
                        .background(Color.indigo.opacity(0.7))
                        .cornerRadius(12)
                        .padding()
                }
                
                Text("Tap to continue")
                    .foregroundStyle(.white)
            }
            .padding(.bottom, 20.0)
        }
    }
}

#Preview {
    FinalSceneView()
}
