
import SwiftUI

enum OnboardingStep {
    case welcome
    case howItWorks
    case name
    case age
}

struct OnboardingView: View {
    @State private var step: OnboardingStep = .welcome
    @State private var inputText: String = ""
    @State private var age: Int = 10
    @FocusState private var isTextFieldFocused: Bool

    var body: some View {
        let generator = UIImpactFeedbackGenerator(style: .light)
        ZStack {
            OnboardingGradientView()
            switch step {
            case .welcome:
                WelcomeView(onNext: { generator.impactOccurred(); step = .howItWorks })
            case .howItWorks:
                HowVaaniWorksView(onNext: { generator.impactOccurred(); step = .name })
            case .name:
                nameStepView(generator: generator)
            case .age:
                ageStepView(generator: generator)
            }
        }
        .animation(.easeInOut(duration: 0.25), value: step)
    }

    private func nameStepView(generator: UIImpactFeedbackGenerator) -> some View {
        VStack(spacing: 30) {
            Spacer()
            VStack(spacing: 20) {
                Text("Enter your name")
                    .font(.largeTitle)
                    .fontWeight(.heavy)
                    .foregroundStyle(.primary)
                Image("Vaani_Onboarding")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 300)
                    .shadow(color: .accentColor, radius: 100)
            }
            Spacer()
            TextField("Enter your beautiful name", text: $inputText)
                .frame(maxHeight: 12)
                .padding()
                .foregroundColor(.primary)
                .font(.title2)
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(.primary, lineWidth: 0.3)
                )
                .padding([.leading, .trailing], 50)
                .textFieldStyle(PlainTextFieldStyle())
                .focused($isTextFieldFocused)
                .onSubmit { DataController.shared.setUserName(name: inputText) }
            Button {
                DataController.shared.setUserName(name: inputText)
                generator.impactOccurred()
                step = .age
            } label: {
                Text("Continue")
                    .frame(maxHeight: 12)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.accentColor)
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }
            .padding(.horizontal, 50)
            .disabled(inputText.isEmpty)
            Spacer()
        }
        .onTapGesture { isTextFieldFocused = false }
    }

    private func ageStepView(generator: UIImpactFeedbackGenerator) -> some View {
        VStack(spacing: 10) {
            Spacer()
            Text("Enter your age")
                .font(.largeTitle)
                .fontWeight(.heavy)
                .foregroundStyle(.primary)
            Spacer()
            HStack {
                Button("", systemImage: "minus.circle.fill") {
                    generator.impactOccurred()
                    if age > 1 { age -= 1 }
                }
                .font(.system(size: 50))
                .background(Color.clear)
                Spacer()
                VStack {
                    Text("\(age)")
                        .font(.largeTitle)
                        .padding([.horizontal], 10)
                    Text("YEARS")
                }
                .foregroundStyle(.primary)
                Spacer()
                Button("", systemImage: "plus.circle.fill") {
                    generator.impactOccurred()
                    if age < 100 { age += 1 }
                }
                .font(.system(size: 50))
                .background(Color.clear)
            }
            .padding(.horizontal, 70)
            .foregroundStyle(.primary)
            Button {
                generator.impactOccurred()
                DataController.shared.setUserAge(age: age)
            } label: {
                Text("Continue")
                    .frame(maxHeight: 12)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.accentColor)
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }
            .padding(.horizontal, 50)
            Spacer()
            Spacer()
        }
    }
}

// MARK: - Welcome screen

private struct WelcomeView: View {
    var onNext: () -> Void
    @State private var appeared = false

    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            Image("Vaani_Onboarding")
                .resizable()
                .scaledToFit()
                .frame(width: 220)
                .shadow(color: Color.accentColor.opacity(0.5), radius: 40)
                .scaleEffect(appeared ? 1 : 0.85)
                .opacity(appeared ? 1 : 0)
            VStack(spacing: 16) {
                Text("Meet Vaani")
                    .font(.largeTitle)
                    .fontWeight(.heavy)
                    .foregroundStyle(.primary)
                Text("Your private health mentor—stories, answers, and daily plans. No judgment, just support.")
                    .font(.title3)
                    .fontWeight(.medium)
                    .foregroundStyle(.primary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
                Text("Built so more people can spot early signs and take care of themselves.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24)
            }
            .opacity(appeared ? 1 : 0)
            .offset(y: appeared ? 0 : 12)
            Spacer()
            Button(action: onNext) {
                Text("Next")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(Color.accentColor)
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }
            .padding(.horizontal, 50)
            .padding(.bottom, 48)
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.5)) { appeared = true }
        }
    }
}

// MARK: - How Vaani works

private struct HowVaaniWorksView: View {
    var onNext: () -> Void
    @State private var appeared = false

    var body: some View {
        VStack(spacing: 28) {
            Spacer()
            VStack(alignment: .leading, spacing: 20) {
                Text("How Vaani works")
                    .font(.largeTitle)
                    .fontWeight(.heavy)
                    .foregroundStyle(.primary)
                VStack(spacing: 12) {
                    featureCard(icon: "book.fill", title: "Stories", subtitle: "See real situations.")
                    featureCard(icon: "ellipsis.message.fill", title: "Talk", subtitle: "Ask anything.")
                    featureCard(icon: "chart.bar.doc.horizontal", title: "Plan", subtitle: "Track your day.")
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 24)
            .opacity(appeared ? 1 : 0)
            .offset(y: appeared ? 0 : 16)
            Spacer()
            Button(action: onNext) {
                Text("Next")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(Color.accentColor)
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }
            .padding(.horizontal, 50)
            .padding(.bottom, 48)
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.5)) { appeared = true }
        }
    }

    private func featureCard(icon: String, title: String, subtitle: String) -> some View {
        HStack(spacing: 16) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.accentColor.opacity(0.15))
                    .frame(width: 48, height: 48)
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundStyle(Color.accentColor)
            }
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.headline)
                    .foregroundStyle(.primary)
                Text(subtitle)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            Spacer(minLength: 0)
        }
        .padding(14)
        .background(Color(.systemBackground).opacity(0.4))
        .cornerRadius(16)
    }
}

struct OnboardingGradientView: View {
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        let colors: [Color] = colorScheme == .dark
            ? [
                Color.purple.opacity(0.7),
                Color.purple.opacity(0.35),
                Color.purple.opacity(0.1)
            ]
            : [
                Color.purple.opacity(0.55),
                Color.purple.opacity(0.25),
                Color.purple.opacity(0.08)
            ]
        LinearGradient(
            gradient: Gradient(colors: colors),
            startPoint: .top,
            endPoint: .bottom
        )
        .background(Color(uiColor: .systemBackground))
        .ignoresSafeArea()
    }
}

#Preview {
    OnboardingView()
}
