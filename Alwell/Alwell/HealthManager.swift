//
//  HealthManager.swift
//  Alwell
//

import HealthKit
import SwiftUI

class HealthManager: ObservableObject {
    private var healthStore = HKHealthStore()
    
    @Published var heartRate: Double = 0.0
    @Published var stepCount: Double = 0.0
    @Published var sleepAnalysis: (hours: Int, minutes: Int) = (0, 0)  // Store hours and minutes separately
    @Published var bodyTemperature: Double = 0.0
    @Published var weight: Double = 0.0
    @Published var caloriesBurned: Double = 0.0  // Add this variable

    
    // Request authorization to access HealthKit data
    func requestAuthorization() {
        let allTypes = Set([
            HKObjectType.quantityType(forIdentifier: .heartRate)!,
            HKObjectType.quantityType(forIdentifier: .stepCount)!,
            HKObjectType.categoryType(forIdentifier: .sleepAnalysis)!,
            HKObjectType.quantityType(forIdentifier: .bodyTemperature)!,
            HKObjectType.quantityType(forIdentifier: .bodyMass)!
        ])
        
        healthStore.requestAuthorization(toShare: allTypes, read: allTypes) { (success, error) in
            if success {
                print("HealthKit authorization granted.")
                self.fetchAllData()
            } else if let error = error {
                print("HealthKit authorization failed: \(error.localizedDescription)")
            }
        }
    }
    
    // Fetch all data
    func fetchAllData() {
        fetchHeartRate()
        fetchStepCount()
        fetchSleepAnalysis()
        fetchBodyTemperature()
        fetchWeight()
        fetchCaloriesBurned()
    }

    // Fetch Heart Rate
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
    
    // Fetch Step Count
    func fetchStepCount() {
        guard let stepCountType = HKObjectType.quantityType(forIdentifier: .stepCount) else { return }

        let query = HKStatisticsQuery(quantityType: stepCountType, quantitySamplePredicate: nil, options: .cumulativeSum) { query, statistics, error in
            guard let statistics = statistics, let sum = statistics.sumQuantity() else { return }
            DispatchQueue.main.async {
                self.stepCount = sum.doubleValue(for: HKUnit.count())
            }
        }

        healthStore.execute(query)
    }
    
    // Fetch Sleep Analysis
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
    
    // Fetch Body Temperature
    func fetchBodyTemperature() {
        guard let temperatureType = HKObjectType.quantityType(forIdentifier: .bodyTemperature) else { return }

        let query = HKSampleQuery(sampleType: temperatureType, predicate: nil, limit: 1, sortDescriptors: [NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)]) { query, results, error in
            guard let result = results?.first as? HKQuantitySample else { return }
            DispatchQueue.main.async {
                self.bodyTemperature = result.quantity.doubleValue(for: HKUnit.degreeFahrenheit())
            }
        }

        healthStore.execute(query)
    }
    
    // Fetch Weight
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
    
    // In requestAuthorization() and fetchAllData():
    func fetchCaloriesBurned() {
        guard let caloriesType = HKObjectType.quantityType(forIdentifier: .activeEnergyBurned) else { return }

        let query = HKStatisticsQuery(quantityType: caloriesType, quantitySamplePredicate: nil, options: .cumulativeSum) { query, statistics, error in
            guard let statistics = statistics, let sum = statistics.sumQuantity() else { return }
            DispatchQueue.main.async {
                self.caloriesBurned = sum.doubleValue(for: HKUnit.kilocalorie())
            }
        }

        healthStore.execute(query)
    }
}
