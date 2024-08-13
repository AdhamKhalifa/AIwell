import SwiftUI
import Contacts

struct HomeView: View {
    @EnvironmentObject var healthManager: HealthManager
    @State private var isSyncing = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
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
                        Text(String(format: "%.1f kcal", healthManager.caloriesBurned))
                            .font(.headline)
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                }
                
                // Sync Status and Button
                HStack {
                    Button(action: {
                        withAnimation {
                            isSyncing = true
                        }
                        DispatchQueue.global(qos: .background).async {
                            self.healthManager.fetchHeartRate()
                            self.healthManager.fetchStepCount()
                            self.healthManager.fetchCaloriesBurned()
                            self.healthManager.fetchExerciseMinutes()
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) { // Simulating delay
                                withAnimation {
                                    isSyncing = false
                                }
                                // Show "Synced just now" message
                                print("Synced just now")
                            }
                        }
                    }) {
                        HStack {
                            if isSyncing {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle())
                                    .scaleEffect(1.5)
                            } else {
                                Image(systemName: "arrow.2.circlepath")
                                    .font(.system(size: 40))
                                    .foregroundColor(.blue)
                            }
                            Text(isSyncing ? "Syncing..." : "Last Sync: Just Now")
                                .font(.headline)
                        }
                    }
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
            }
            .padding()
            .navigationBarTitle("Home", displayMode: .inline)
        }
    }
    
    // Get the iPhone user's first name
    func getUserName() -> String {
        return UserDefaults.standard.string(forKey: "userFirstName") ?? "User"
    }
}
