import SwiftUI

struct OneMinuteResetView: View {
    @Binding var isPresented: Bool
    @State private var phase: Int = 0
    @State private var scale: CGFloat = 0.6
    private let totalBreaths = 4
    private let breathDuration: Double = 4.0
    private let messages = [
        "You're doing great.",
        "Rest is part of the plan.",
        "One breath at a time.",
        "Vaani is proud of you.",
    ]

    var body: some View {
        VStack(spacing: 32) {
            Spacer()
            if phase <= totalBreaths {
                Text(phase == 0 || phase % 2 == 0 ? "Breathe in" : "Breathe out")
                    .font(.title2)
                    .foregroundStyle(.secondary)
                Circle()
                    .fill(Color.accentColor.opacity(0.3))
                    .frame(width: 160, height: 160)
                    .scaleEffect(scale)
            } else {
                Image("App-Logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80, height: 80)
                    .cornerRadius(16)
                Text(messages.randomElement() ?? messages[0])
                    .font(.title3)
                    .fontWeight(.medium)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
            Spacer()
            Button("Done") {
                isPresented = false
            }
            .fontWeight(.semibold)
            .frame(maxWidth: .infinity)
            .padding()
            .padding(.bottom, 32)
        }
        .onAppear {
            runBreathingCycle()
        }
    }

    private func runBreathingCycle() {
        guard phase <= totalBreaths else { return }
        let isInhale = (phase == 0 || phase % 2 == 0)
        withAnimation(.easeInOut(duration: breathDuration / 2)) {
            scale = isInhale ? 1.2 : 0.6
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + breathDuration) {
            phase += 1
            if phase <= totalBreaths {
                runBreathingCycle()
            }
        }
    }
}

#Preview {
    OneMinuteResetView(isPresented: .constant(true))
}
