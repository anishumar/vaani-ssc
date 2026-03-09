import SwiftUI



struct MainTabView: View {
    @StateObject private var appState = VaaniApp.shared
    var body: some View {
        TabView(selection: $appState.selectedTab) {
            VaaniLifeView()
                .tabItem {
                    Label("Stories", systemImage: "book.fill")
                }
                .tag(VaaniTab.life)

            VaaniTalkView()
                .tabItem {
                    Label("Ask", systemImage: "ellipsis.message.fill")
                }
                .tag(VaaniTab.talk)

            VaaniLogsView()
                .tabItem {
                    Label("Plans", systemImage: "chart.bar.doc.horizontal")
                }
                .tag(VaaniTab.logs)
            
            MoreView()
                .tabItem {
                    Label("Corner", systemImage: "ellipsis.circle.fill")
                }
                .tag(VaaniTab.more)
        }
        .navigationBarBackButtonHidden()
    }
}
