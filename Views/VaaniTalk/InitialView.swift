
import SwiftUI

struct InitialView: View {
    @Binding var isConversing: Bool
    @Binding var messages: [Message]
    
    var responses: [Int] = []
    var body: some View {
        VStack(alignment: .leading, spacing: 40.0) {
            
            VStack(alignment: .leading, spacing: 5.0) {
                Text("Hello, \(DataController.shared.getUserName())")
                    .font(.largeTitle)
                    .foregroundColor(Color.primary)
                Text("How can I help you?")
                    .font(.body)
                    .fontWeight(.semibold)
                    .foregroundStyle(.purple)
                
            }
        }
        .padding(.top, 20.0)
        .onAppear {
            isConversing = false
        }
    }
    

    
}

