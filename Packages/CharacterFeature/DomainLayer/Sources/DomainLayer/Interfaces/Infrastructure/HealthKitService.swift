//
//  HealthKitService.swift
//  DomainLayer
//
//  Created by Alfian on 03/12/24.
//

public protocol HealthKitService {
  func requestAuthorization(completion: @escaping @Sendable (Bool, Error?) -> Void)
  func fetchStepCount(startDate: Double, endDate: Double,
                      completion: @escaping @Sendable ([Double: Int]?, Error?) -> Void)
}
