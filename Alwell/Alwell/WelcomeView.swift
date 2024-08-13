import SwiftUI

struct WelcomeView: View {
    @State private var firstName: String = ""
    @State private var birthDate: Date = Date()
    @State private var gender: String = "Male"
    @State private var ethnicity: String = ""
    @State private var chronicDisease: String = ""
    
    @State private var isOtherEthnicity = false
    @State private var isOtherChronicDisease = false
    @State private var showError = false
    @State private var errorMessage = ""
    
    @State private var showFAQ = false
    
    @Binding var isUserSetupComplete: Bool
    
    let genders = ["Male", "Female", "Other"]
    let ethnicities = ["Asian", "Black or African American", "Hispanic or Latino", "White", "Other"]
    let chronicDiseasesList = ["Diabetes", "Hypertension", "Asthma", "Heart Disease", "None", "Other"]
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Welcome to Alwell!")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top, 40)
                
                TextField("Enter your first name", text: $firstName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .onChange(of: firstName, perform: { value in
                        if firstName.contains(" ") {
                            errorMessage = "First name should not contain spaces."
                            showError = true
                        } else {
                            showError = false
                        }
                    })
                
                DatePicker("Select your birthdate", selection: $birthDate, displayedComponents: .date)
                    .padding()
                    .onChange(of: birthDate, perform: { _ in
                        if calculateAge(from: birthDate) < 13 {
                            errorMessage = "You must be at least 13 years old."
                            showError = true
                        } else {
                            showError = false
                        }
                    })
                
                if showError {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .font(.caption)
                        .padding(.bottom, 10)
                }
                
                Picker("Select your gender", selection: $gender) {
                    ForEach(genders, id: \.self) { gender in
                        Text(gender)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                
                Picker("Select your ethnicity", selection: $ethnicity) {
                    ForEach(ethnicities, id: \.self) { ethnicity in
                        Text(ethnicity)
                    }
                }
                .onChange(of: ethnicity) { value in
                    isOtherEthnicity = value == "Other"
                }
                .padding()
                
                if isOtherEthnicity {
                    TextField("Enter your ethnicity", text: $ethnicity)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)
                }
                
                Picker("Select chronic disease", selection: $chronicDisease) {
                    ForEach(chronicDiseasesList, id: \.self) { disease in
                        Text(disease)
                    }
                }
                .onChange(of: chronicDisease) { value in
                    isOtherChronicDisease = value == "Other"
                }
                .padding()
                
                if isOtherChronicDisease {
                    TextField("Enter chronic disease", text: $chronicDisease)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)
                }
                
                Button(action: {
                    if validateInputs() {
                        saveUserInfo()
                    }
                }) {
                    HStack {
                        Image(systemName: "arrow.right.circle.fill")
                        Text("Continue")
                    }
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.purple)
                    .cornerRadius(10)
                    .frame(minWidth: 100)
                }
                .padding(.top, 20)
                
                Spacer()
                
                Button("FAQ") {
                    showFAQ.toggle()
                }
                .font(.footnote)
                .padding(.bottom, 10)
                .sheet(isPresented: $showFAQ) {
                    FAQView()
                }
            }
            .padding()
            .navigationBarHidden(true)
        }
    }
    
    func validateInputs() -> Bool {
        if firstName.isEmpty || firstName.contains(" ") {
            errorMessage = "Please enter a valid first name."
            showError = true
            return false
        }
        if calculateAge(from: birthDate) < 13 {
            errorMessage = "You must be at least 13 years old."
            showError = true
            return false
        }
        return true
    }
    
    func calculateAge(from birthDate: Date) -> Int {
        let calendar = Calendar.current
        let ageComponents = calendar.dateComponents([.year], from: birthDate, to: Date())
        return ageComponents.year ?? 0
    }
    
    func saveUserInfo() {
        UserDefaults.standard.set(firstName, forKey: "userFirstName")
        UserDefaults.standard.set(birthDate, forKey: "userBirthDate")
        UserDefaults.standard.set(gender, forKey: "userGender")
        UserDefaults.standard.set(ethnicity, forKey: "userEthnicity")
        UserDefaults.standard.set(chronicDisease, forKey: "userChronicDiseases")
        
        UserDefaults.standard.set(true, forKey: "isUserSetupComplete")
        
        withAnimation {
            isUserSetupComplete = true
        }
    }
}

struct FAQView: View {
    var body: some View {
        VStack(spacing: 20) {
            Text("Frequently Asked Questions")
                .font(.title)
                .fontWeight(.bold)
                .padding()
            
            Text("Q: How does this app use my data?\nA: The app only stores your data locally on your device. We do not send any data to external servers.")
            
            Text("Q: What kind of data does this app store?\nA: The app stores health data like your heart rate, steps, sleep analysis, etc., all on your device.")
            
            Text("Q: Can I delete my data?\nA: Yes, you can delete your data by uninstalling the app, which will remove all stored information.")
            
            Spacer()
            
            Button("Close") {
                UIApplication.shared.windows.first { $0.isKeyWindow }?.rootViewController?.dismiss(animated: true, completion: nil)
            }
            .font(.headline)
            .foregroundColor(.white)
            .padding()
            .background(Color.blue)
            .cornerRadius(10)
            .frame(minWidth: 100)
        }
        .padding()
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView(isUserSetupComplete: .constant(false))
    }
}
