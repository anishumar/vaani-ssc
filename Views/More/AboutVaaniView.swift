import SwiftUI

struct AboutVaaniView: View {
    @Binding var isPresented: Bool
    private var version: String {
        (Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String) ?? "1.0"
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text("Why Vaani")
                        .font(.headline)
                    Text("Many people miss early signs of conditions like PCOS or irregular cycles. Vaani helps you learn, ask questions, and build habits—privately on your device.")
                        .font(.body)
                    Text("Vaani is your discreet, stigma-free health mentor—helping you understand periods, PCOS, UTIs, and more.")
                        .font(.body)
                    Text("Privacy")
                        .font(.headline)
                    Text("Your data stays on your device. No tracking, no sharing. We can't see your stories or your plan.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    Text("Version \(version)")
                        .font(.caption)
                        .foregroundStyle(.tertiary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
            }
            .navigationTitle("About Vaani")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { isPresented = false }
                }
            }
        }
    }
}

#Preview {
    AboutVaaniView(isPresented: .constant(true))
}
