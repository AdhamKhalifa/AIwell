import SwiftUI

struct ContentView: View {
    @EnvironmentObject var healthManager: HealthManager 
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Heart Rate Section
                    HealthMetricCard(
                        title: "Heart Rate",
                        value: String(format: "%.0f BPM", healthManager.heartRate),
                        icon: "heart.fill",
                        color: .red
                    )
                    // Step Count Section
                    HealthMetricCard(
                        title: "Steps",
                        value: String(format: "%.0f", healthManager.stepCount),
                        icon: "figure.walk",
                        color: .green
                    )
                    // Sleep Analysis Section
                    HealthMetricCard(
                        title: "Sleep",
                        value: "\(healthManager.sleepAnalysis.hours)h \(healthManager.sleepAnalysis.minutes)m",
                        icon: "bed.double.fill",
                        color: .blue
                    )
                    // Weight Section
                    HealthMetricCard(
                        title: "Weight",
                        value: String(format: "%.1f lbs", healthManager.weight),
                        icon: "scalemass.fill",
                        color: .gray
                    )
                    // Calories Burned Section
                    HealthMetricCard(
                        title: "Calories Burned",
                        value: String(format: "%.0f kcal", healthManager.caloriesBurned),
                        icon: "flame.fill",
                        color: .orange
                    )
                    // Physical Effort (MET) Section
                    HealthMetricCard(
                        title: "Exercise Minutes",
                        value: String(format: "%.0f min", healthManager.exerciseMinutes),
                        icon: "figure.walk",
                        color: .purple
                    )
                    // Respiratory Rate Section
                    HealthMetricCard(
                        title: "Respiratory Rate",
                        value: String(format: "%.0f breaths/min", healthManager.respiratoryRate),
                        icon: "lungs.fill",
                        color: .cyan
                    )
                    // Cardio Fitness (VO2 Max) Section
                    HealthMetricCard(
                        title: "Cardio Fitness (VO2 Max)",
                        value: String(format: "%.1f ml/kg·min", healthManager.cardioFitnessVO2),
                        icon: "waveform.path.ecg",
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
            .environmentObject(HealthManager())
    }
}
