import SwiftUI
struct MCQSceneView: View {
    var question: String?
    var options: [String]?
    var correctOptionIndex: Int?
    var characterImageName: String = "Vaani_Question"
    @Binding var showMCQScene: Bool
    @Binding var showFinalScene: Bool
    
    @State private var selectedOptionIndex: Int? = nil
    @State private var showResult: Bool = false

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
            
            VStack {
                // Question Box
                Text(question ?? "What should Vaani do next?")
                    .font(.title3)
                    .bold()
                    .italic()
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.indigo.opacity(0.9))
                    .cornerRadius(12)
                    .frame(width: 350)
                
                Spacer()
                
                // Options
                VStack(alignment: .leading, spacing: 12) {
                    ForEach(Array(options?.enumerated() ?? defaultOptions().enumerated()), id: \.element) { index, option in
                        Button(action: {
                            self.selectedOptionIndex = index
                            self.showResult = true
                        }) {
                            Text(option)
                                .multilineTextAlignment(.leading)
                                .frame(minWidth: 330, alignment: .leading)
                                .font(.body)
                                .padding()
                                .foregroundColor(.white)
                                .background(getOptionColor(index))
                                .cornerRadius(12)
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 40)
            }
            .frame(maxHeight: .infinity, alignment: .bottom) 
        }
        .onChange(of: selectedOptionIndex) {
                checkIfRight()
        }
    }

    func getOptionColor(_ index: Int) -> Color {
        let generator = UIImpactFeedbackGenerator(style: .heavy)
        if let selected = selectedOptionIndex {
            if selected == index {
                generator.impactOccurred()
                return selected == correctOptionIndex ? Color.green.opacity(0.7) : Color.red.opacity(0.7)
            }
        }
        return Color.indigo.opacity(0.8)
    }
    
    func checkIfRight() {
        if let selectedOptionIndex = selectedOptionIndex {
            if selectedOptionIndex == correctOptionIndex {
                let generator = UIImpactFeedbackGenerator(style: .light)
                generator.impactOccurred()
                // Show final scene after a delay
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    showFinalScene = true
                    showMCQScene = false
                }
            }
        }
    }

    func defaultOptions() -> [String] {
        return [
            "Panic and hide it from everyone.",
            "Use tissue paper and hope it stops.",
            "Find an elder she trusts and ask for help.", // Correct answer
            "Ignore it and continue with the party."
        ]
    }
}
