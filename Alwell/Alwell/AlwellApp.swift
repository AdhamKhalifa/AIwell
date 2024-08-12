//
//  AlwellApp.swift
//  Alwell
//
//  Created by Adham Khalifa on 8/10/24.
//

import SwiftUI

@main
struct AlwellApp: App {
    @StateObject private var healthManager = HealthManager()

    var body: some Scene {
        WindowGroup {
            AlwellTabView() // Ensure this is your root view with tabs
                .environmentObject(healthManager) // Inject the HealthManager into the environment
                .onAppear {
                    healthManager.requestAuthorization() // Request HealthKit authorization when the app starts
                }
        }
    }
}
