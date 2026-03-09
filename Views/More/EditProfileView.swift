import SwiftUI

struct EditProfileView: View {
    @Binding var isPresented: Bool
    @State private var name: String = ""
    @State private var age: Int = 10
    private let dc = DataController.shared

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Name", text: $name)
                    Stepper("Age: \(age)", value: $age, in: 1...100)
                } header: {
                    Text("Profile")
                }
            }
            .navigationTitle("Edit profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { isPresented = false }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        dc.setUserName(name: name.isEmpty ? "User" : name)
                        dc.setUserAge(age: age)
                        isPresented = false
                    }
                }
            }
            .onAppear {
                name = dc.getUserName()
                age = dc.getUserAge()
                if age <= 0 || age > 100 { age = 10 }
            }
        }
    }
}

#Preview {
    EditProfileView(isPresented: .constant(true))
}
