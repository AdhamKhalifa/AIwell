import Foundation

class AIManager: ObservableObject {
    private let openAIAPIKey = "API-Key"
    private let baseURL = "https://api.openai.com/v1/chat/completions"
    
    func sendMessage(_ message: String, withContext context: String, completion: @escaping (String) -> Void) {
        guard let url = URL(string: baseURL) else { return }
        
        let headers = [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(openAIAPIKey)"
        ]
        
        let body: [String: Any] = [
            "model": "gpt-4",
            "messages": [
                ["role": "system", "content": "You are a health assistant AI."],
                ["role": "user", "content": context + "\n\n" + message]
            ]
        ]
        
        let requestBody = try? JSONSerialization.data(withJSONObject: body)
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        request.httpBody = requestBody
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                if let jsonResponse = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let choices = jsonResponse["choices"] as? [[String: Any]],
                   let message = choices.first?["message"] as? [String: Any],
                   let content = message["content"] as? String {
                    DispatchQueue.main.async {
                        completion(content)
                    }
                } else {
                    DispatchQueue.main.async {
                        completion("Failed to get a response from the AI.")
                    }
                }
            } else if let error = error {
                DispatchQueue.main.async {
                    completion("Error: \(error.localizedDescription)")
                }
            }
        }
        
        task.resume()
    }
    
    func getUserContext() -> String {
        let firstName = UserDefaults.standard.string(forKey: "userFirstName") ?? "User"
        let birthDate = UserDefaults.standard.object(forKey: "userBirthDate") as? Date ?? Date()
        let gender = UserDefaults.standard.string(forKey: "userGender") ?? "Unknown"
        let ethnicity = UserDefaults.standard.string(forKey: "userEthnicity") ?? "Unknown"
        let chronicDisease = UserDefaults.standard.string(forKey: "userChronicDiseases") ?? "None"
        
        let ageComponents = Calendar.current.dateComponents([.year], from: birthDate, to: Date())
        let age = ageComponents.year ?? 0
        
        return """
        Name: \(firstName)
        Age: \(age)
        Gender: \(gender)
        Ethnicity: \(ethnicity)
        Chronic Diseases: \(chronicDisease)
        """
    }
    
    func getHealthContext(healthManager: HealthManager) -> String {
        return """
        Health Data:
        Heart Rate: \(String(format: "%.1f BPM", healthManager.heartRate))
        Steps: \(String(format: "%.1f", healthManager.stepCount))
        Sleep: \(healthManager.sleepAnalysis.hours)h \(healthManager.sleepAnalysis.minutes)m
        Weight: \(String(format: "%.1f lbs", healthManager.weight))
        Calories Burned: \(String(format: "%.1f kcal", healthManager.caloriesBurned))
        Exercise Minutes: \(String(format: "%.1f min", healthManager.exerciseMinutes))
        Physical Effort (MET): \(String(format: "%.1f MET", healthManager.physicalEffort))
        Respiratory Rate: \(String(format: "%.1f", healthManager.respiratoryRate))
        Cardio Fitness VO2: \(String(format: "%.1f", healthManager.cardioFitnessVO2))
        """
    }
}

