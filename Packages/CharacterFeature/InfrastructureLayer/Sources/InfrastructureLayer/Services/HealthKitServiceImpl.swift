//
//  HealthKitServiceImpl.swift
//  InfrastructureLayer
//
//  Created by Alfian on 03/12/24.
//

import HealthKit

public class HealthKitServiceImpl {
  private let healthStore: HKHealthStore

  init(healthStore: HKHealthStore) {
    self.healthStore = healthStore
  }

  func requestAuthorization(completion: @escaping @Sendable (Bool, Error?) -> Void) {
    guard HKHealthStore.isHealthDataAvailable() else {
      completion(false, nil)
      return
    }

    let stepType = HKQuantityType.quantityType(forIdentifier: .stepCount)!

    let readTypes: Set<HKObjectType> = [stepType]

    healthStore.requestAuthorization(toShare: nil, read: readTypes) { success, error in
      completion(success, error)
    }
  }

  func fetchStepCount(startDate: Date, endDate: Date,
                      completion: @escaping @Sendable ([Double: Int]?, Error?) -> Void) {
    let stepType = HKQuantityType.quantityType(forIdentifier: .stepCount)!
    let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate)

    let interval = DateComponents(day: 1)
    let query = HKStatisticsCollectionQuery(
      quantityType: stepType,
      quantitySamplePredicate: predicate,
      options: .cumulativeSum,
      anchorDate: startDate,
      intervalComponents: interval
    )

    query.initialResultsHandler = { _, results, error in
      guard let statsCollection = results else {
        completion(nil, error)
        return
      }

      var stepsByDate: [Double: Int] = [:]

      statsCollection.enumerateStatistics(from: startDate, to: endDate) { statistics, _ in
        if let quantity = statistics.sumQuantity() {
          let stepCount = Int(quantity.doubleValue(for: .count()))
          stepsByDate[statistics.startDate.timeIntervalSince1970] = stepCount
        }
      }

      completion(stepsByDate, nil)
    }

    healthStore.execute(query)
  }
}
