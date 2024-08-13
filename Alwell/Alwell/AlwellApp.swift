import SwiftUI

@main
struct AlwellApp: App {
    @StateObject private var healthManager = HealthManager()
    @State private var isUserSetupComplete = UserDefaults.standard.bool(forKey: "isUserSetupComplete")

    var body: some Scene {
        WindowGroup {
            if isUserSetupComplete {
                AlwellTabView()
                    .environmentObject(healthManager)
            } else {
                WelcomeView(isUserSetupComplete: $isUserSetupComplete)
                    .environmentObject(healthManager)
            }
        }
    }
}
