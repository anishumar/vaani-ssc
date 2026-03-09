import SwiftUI

enum VaaniTab: String {
    case talk, life, logs, more
}

@Observable
@MainActor
class VaaniApp: ObservableObject {
    static var shared = VaaniApp()
    var selectedTab: VaaniTab = .life

    static func openTab(_ tab: VaaniTab) {
        shared.selectedTab = tab
    }
}
