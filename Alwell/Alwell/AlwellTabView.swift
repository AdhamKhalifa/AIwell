//
//  AlwellTabView.swift
//  Alwell
//
//  Created by Adham Khalifa on 8/11/24.
//

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
                .badge(2)

            ContentView()
                .tag("Content")
                .tabItem {
                    VStack {
                        Image(systemName: "heart.circle")
                        Text("Health")
                    }
                }.badge(2)
            
            AIView()
                .tag("AI")
                .tabItem {
                    VStack {
                        Image(systemName: "bubble.left.and.bubble.right.fill")
                        Text("AI Chat")
                    }
                }.badge(2)
        }
        .accentColor(.purple) // Customize the selected tab's color
    }
}

struct AlwellTabView_Previews: PreviewProvider {
    static var previews: some View {
        AlwellTabView()
    }
}
