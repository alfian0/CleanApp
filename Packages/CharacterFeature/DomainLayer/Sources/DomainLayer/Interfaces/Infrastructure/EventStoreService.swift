//
//  EventStoreService.swift
//  DomainLayer
//
//  Created by Alfian on 04/12/24.
//

public protocol EventStoreService {
  func requestAuthorization(completion: @escaping @Sendable (Bool, Error?) -> Void)
  func fetchEvents(startDate: Double, endDate: Double) -> [EventDomainModel]
}
