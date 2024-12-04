//
//  GetEventListUsecaseImpl.swift
//  DomainLayer
//
//  Created by Alfian on 04/12/24.
//

public final class GetEventListUsecaseImpl: GetEventListUsecase {
  private let service: EventStoreService

  public init(service: EventStoreService) {
    self.service = service
  }

  public func execute(startDate: Double, endDate: Double) async throws -> [EventDomainModel] {
    let authorized = try await requestAuthorization()
    guard authorized else { return [] }
    return service.fetchEvents(startDate: startDate, endDate: endDate)
  }

  private func requestAuthorization() async throws -> Bool {
    try await withUnsafeThrowingContinuation { continuation in
      service.requestAuthorization { granted, error in
        guard error == nil else {
          continuation.resume(throwing: error!)
          return
        }

        continuation.resume(returning: granted)
      }
    }
  }
}
