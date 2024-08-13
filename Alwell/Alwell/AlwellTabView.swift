import SwiftUI

struct AlwellTabView: View {
    @EnvironmentObject var healthManager: HealthManager

    @State var selectedTab = "Home"
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .tag("Home")
                .tabItem {
                    VStack {
                        Image(systemName: "house.fill")
                        Text("Home")
                    }
                }
                

            ContentView()
                .tag("Content")
                .tabItem {
                    VStack {
                        Image(systemName: "heart.circle")
                        Text("Health")
                    }
                }
            
            AIView()
                .tag("AI")
                .tabItem {
                    VStack {
                        Image(systemName: "bubble.left.and.bubble.right.fill")
                        Text("AI Chat")
                    }
                }
        }
        .accentColor(.purple)
        .environmentObject(HealthManager())
    }
}

struct AlwellTabView_Previews: PreviewProvider {
    static var previews: some View {
        AlwellTabView()
    }
}
