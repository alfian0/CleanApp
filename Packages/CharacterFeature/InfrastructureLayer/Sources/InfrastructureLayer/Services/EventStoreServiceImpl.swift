//
//  EventStoreServiceImpl.swift
//  InfrastructureLayer
//
//  Created by Alfian on 04/12/24.
//

import DomainLayer
import EventKit

public final class EventStoreServiceImpl: EventStoreService {
  private let eventStore: EKEventStore

  public init(eventStore: EKEventStore) {
    self.eventStore = eventStore
  }

  public func requestAuthorization(completion: @escaping @Sendable (Bool, Error?) -> Void) {
    let status = EKEventStore.authorizationStatus(for: .event)
    switch status {
    case .notDetermined:
      eventStore.requestAccess(to: .event) { granted, error in
        completion(granted, error)
      }
    case .denied, .restricted:
      completion(false, nil)
    default:
      completion(true, nil)
    }
  }

  public func fetchEvents(startDate: Double, endDate: Double) -> [EventDomainModel] {
    let eventStore = EKEventStore()

    let startDate = Date(timeIntervalSince1970: startDate)
    let endDate = Date(timeIntervalSince1970: endDate)

    let predicate = eventStore.predicateForEvents(withStart: startDate, end: endDate, calendars: nil)

    let events = eventStore.events(matching: predicate)

    return events.map {
      EventDomainModel(
        title: $0.title,
        startDate: $0.startDate.timeIntervalSince1970,
        endDate: $0.endDate.timeIntervalSince1970,
        location: $0.location
      )
    }
  }
}
