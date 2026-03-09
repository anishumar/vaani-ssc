import SwiftUI

struct ContentView: View {
    /// Use @AppStorage so ContentView re-renders when onboarding completes.
    /// When age is set, we show MainTabView as root—onboarding is no longer in the nav stack.
    @AppStorage("userAge") private var userAge: Int = 0

    var body: some View {
        if userAge > 0 {
            MainTabView()
        } else {
            OnboardingView()
        }
    }
}
