//
//  ContentView.swift
//  Alwell
//
//  Created by Adham Khalifa on 8/10/24.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var healthManager: HealthManager  // Use shared instance

    @State private var editingMetric: String? = nil
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Heart Rate Section
                    HealthMetricCard(
                        title: "Heart Rate",
                        value: String(format: "%.1f BPM", healthManager.heartRate),
                        icon: "heart.fill",
                        color: .red
                    )
                    // Sleep Analysis Section
                    HealthMetricCard(
                        title: "Sleep",
                        value: "\(healthManager.sleepAnalysis.hours)h \(healthManager.sleepAnalysis.minutes)m",
                        icon: "bed.double.fill",
                        color: .blue
                    )
                    // Step Count Section
                    HealthMetricCard(
                        title: "Steps",
                        value: String(format: "%.1f", healthManager.stepCount),
                        icon: "figure.walk",
                        color: .green
                    )
                    // Weight Section
                    HealthMetricCard(
                        title: "Weight",
                        value: String(format: "%.1f lbs", healthManager.weight),  // Display formatted weight
                        icon: "scalemass.fill",
                        color: .gray
                    )
                    // Body Temperature Section
                    HealthMetricCard(
                        title: "Body Temperature",
                        value: String(format: "%.1f°F", healthManager.bodyTemperature),
                        icon: "thermometer",
                        color: .red
                    )
                }
                .padding()
            }
            .navigationBarTitle("Health Data", displayMode: .inline)
        }
    }
}


struct HealthMetricCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .font(.system(size: 40))
                .foregroundColor(color)
                .padding(.trailing, 10)
            
            VStack(alignment: .leading) {
                Text(title)
                    .font(.headline)
                Text(value)
                    .font(.title)
                    .fontWeight(.bold)
            }
            Spacer()
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(10)
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
