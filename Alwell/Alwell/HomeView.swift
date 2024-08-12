//
//  HomeView.swift
//  Alwell
//
//  Created by Adham Khalifa on 8/11/24.
//

import SwiftUI
import Contacts

struct HomeView: View {
    @EnvironmentObject var healthManager: HealthManager
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Greeting
                Text("Welcome back, \(getUserName())!")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top, 40)
                
                // Overview of Health Data
                HStack {
                    VStack {
                        Image(systemName: "heart.fill")
                            .foregroundColor(.red)
                            .font(.system(size: 50))
                        Text("Heart Rate")
                        Text(String(format: "%.1f BPM", healthManager.heartRate))
                            .font(.headline)
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    
                    VStack {
                        Image(systemName: "flame.fill")
                            .foregroundColor(.orange)
                            .font(.system(size: 50))
                        Text("Calories")
                        Text("1250 kcal") // Placeholder, update to fetch actual data
                            .font(.headline)
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                }
                
                // Sync Status and Button
                HStack {
                    Button(action: {
                        healthManager.fetchAllData()
                    }) {
                        HStack {
                            Image(systemName: "arrow.2.circlepath")
                                .font(.system(size: 40))
                                .foregroundColor(.blue)
                            Text("Last Sync: Just Now")
                                .font(.headline)
                        }
                    }
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
                
                VStack {
                    Image(systemName: "flame.fill")
                        .foregroundColor(.orange)
                        .font(.system(size: 50))
                    Text("Calories Burned")
                    Text(String(format: "%.1f kcal", healthManager.caloriesBurned))
                        .font(.headline)
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
                
                Spacer()
            }
            .padding()
            .navigationBarTitle("Home", displayMode: .inline)
        }
    }
    
    // Get the iPhone user's first name
    func getUserName() -> String {
        /*let name = CNContactStore().defaultContainerIdentifier
        let formatter = PersonNameComponentsFormatter()
        if let personName = formatter.string(from: PersonNameComponents(givenName: "Adham")) {
            return personName
        }*/
        return "User"
    }
}

