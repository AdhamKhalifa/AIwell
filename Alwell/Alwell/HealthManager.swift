import HealthKit
import SwiftUI

class HealthManager: ObservableObject {
    let healthStore = HKHealthStore()
    
    @Published var heartRate: Double = 0.0
    @Published var stepCount: Double = 0.0
    @Published var sleepAnalysis: (hours: Int, minutes: Int) = (0, 0) // Define as a tuple
    @Published var weight: Double = 0.0
    @Published var caloriesBurned: Double = 0.0
    @Published var physicalEffort: Double = 0.0
    @Published var respiratoryRate: Double = 0.0
    @Published var cardioFitnessVO2: Double = 0.0
    @Published var exerciseMinutes: Double = 0.0
    
    init() {
        let healthTypes: Set = [
            HKQuantityType(.stepCount),
            HKQuantityType(.heartRate),
            HKQuantityType(.bodyMass),
            HKQuantityType(.activeEnergyBurned),
            HKQuantityType(.appleExerciseTime),
            HKQuantityType(.respiratoryRate),
            HKQuantityType(.vo2Max),
            HKQuantityType(.walkingHeartRateAverage)
        ]
        
        Task {
            do {
                try await healthStore.requestAuthorization(toShare: [], read: healthTypes)
                fetchHeartRate()
                fetchStepCount()
                fetchSleepAnalysis()
                fetchWeight()
                fetchCaloriesBurned()
                fetchPhysicalEffort()
                fetchRespiratoryRate()
                fetchCardioFitnessVO2()
                fetchExerciseMinutes()
            } catch {
                print("Error fetching health data: \(error.localizedDescription)")
            }
        }
    }

    func fetchHeartRate() {
        guard let heartRateType = HKObjectType.quantityType(forIdentifier: .heartRate) else { return }

        let query = HKSampleQuery(sampleType: heartRateType, predicate: nil, limit: 1, sortDescriptors: [NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)]) { query, results, error in
            guard let result = results?.first as? HKQuantitySample else { return }
            DispatchQueue.main.async {
                self.heartRate = result.quantity.doubleValue(for: HKUnit(from: "count/min"))
            }
        }

        healthStore.execute(query)
    }

    func fetchStepCount() {
        let steps = HKQuantityType(.stepCount)
        let startOfDay = Calendar.current.startOfDay(for: Date())
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: Date(), options: .strictStartDate)
        
        let query = HKStatisticsQuery(quantityType: steps, quantitySamplePredicate: predicate, options: .cumulativeSum) { _, result, error in
            guard let result = result, let sum = result.sumQuantity() else {
                print("Failed to fetch step count: \(error?.localizedDescription ?? "N/A")")
                return
            }
            
            DispatchQueue.main.async {
                self.stepCount = sum.doubleValue(for: .count())
            }
        }
        
        healthStore.execute(query)
    }
    
    func fetchSleepAnalysis() {
        guard let sleepType = HKObjectType.categoryType(forIdentifier: .sleepAnalysis) else { return }

        let query = HKSampleQuery(sampleType: sleepType, predicate: nil, limit: 1, sortDescriptors: [NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)]) { query, results, error in
            guard let result = results?.first as? HKCategorySample else { return }
            DispatchQueue.main.async {
                let sleepDurationInHours = result.endDate.timeIntervalSince(result.startDate) / 3600.0
                let hours = Int(sleepDurationInHours)
                let minutes = Int((sleepDurationInHours - Double(hours)) * 60)
                self.sleepAnalysis = (hours, minutes)
            }
        }

        healthStore.execute(query)
    }
    
    func fetchWeight() {
        guard let weightType = HKObjectType.quantityType(forIdentifier: .bodyMass) else { return }

        let query = HKSampleQuery(sampleType: weightType, predicate: nil, limit: 1, sortDescriptors: [NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)]) { query, results, error in
            guard let result = results?.first as? HKQuantitySample else { return }
            DispatchQueue.main.async {
                self.weight = result.quantity.doubleValue(for: HKUnit.pound())
            }
        }

        healthStore.execute(query)
    }

    func fetchCaloriesBurned() {
        guard let caloriesType = HKObjectType.quantityType(forIdentifier: .activeEnergyBurned) else { return }

        let startOfDay = Calendar.current.startOfDay(for: Date())
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: Date(), options: .strictStartDate)

        let query = HKStatisticsQuery(quantityType: caloriesType, quantitySamplePredicate: predicate, options: .cumulativeSum) { query, statistics, error in
            guard let statistics = statistics, let sum = statistics.sumQuantity() else { return }
            DispatchQueue.main.async {
                self.caloriesBurned = sum.doubleValue(for: HKUnit.kilocalorie())
            }
        }

        healthStore.execute(query)
    }

    func fetchPhysicalEffort() {
        guard let metType = HKObjectType.quantityType(forIdentifier: .appleExerciseTime) else { return }

        let query = HKStatisticsQuery(quantityType: metType, quantitySamplePredicate: nil, options: .cumulativeSum) { query, statistics, error in
            guard let statistics = statistics, let sum = statistics.sumQuantity() else { return }
            DispatchQueue.main.async {
                self.physicalEffort = sum.doubleValue(for: HKUnit.minute())
            }
        }

        healthStore.execute(query)
    }

    func fetchRespiratoryRate() {
        guard let respiratoryRateType = HKObjectType.quantityType(forIdentifier: .respiratoryRate) else { return }

        let query = HKSampleQuery(sampleType: respiratoryRateType, predicate: nil, limit: 1, sortDescriptors: [NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)]) { query, results, error in
            guard let result = results?.first as? HKQuantitySample else { return }
            DispatchQueue.main.async {
                self.respiratoryRate = result.quantity.doubleValue(for: HKUnit(from: "count/min"))
            }
        }

        healthStore.execute(query)
    }

    func fetchCardioFitnessVO2() {
        guard let vo2Type = HKObjectType.quantityType(forIdentifier: .vo2Max) else { return }

        let query = HKSampleQuery(sampleType: vo2Type, predicate: nil, limit: 1, sortDescriptors: [NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)]) { query, results, error in
            guard let result = results?.first as? HKQuantitySample else { return }
            DispatchQueue.main.async {
                self.cardioFitnessVO2 = result.quantity.doubleValue(for: HKUnit(from: "ml/kg·min"))
            }
        }

        healthStore.execute(query)
    }

    func fetchExerciseMinutes() {
        guard let exerciseTimeType = HKObjectType.quantityType(forIdentifier: .appleExerciseTime) else { return }
        
        let startOfDay = Calendar.current.startOfDay(for: Date())
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: Date(), options: .strictStartDate)
        
        let query = HKStatisticsQuery(quantityType: exerciseTimeType, quantitySamplePredicate: predicate, options: .cumulativeSum) { query, statistics, error in
            guard let statistics = statistics, let sum = statistics.sumQuantity() else { return }
            DispatchQueue.main.async {
                self.exerciseMinutes = sum.doubleValue(for: HKUnit.minute())
            }
        }
        
        healthStore.execute(query)
    }
}
