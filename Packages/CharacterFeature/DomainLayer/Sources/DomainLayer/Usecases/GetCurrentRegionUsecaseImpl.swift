//
//  GetCurrentRegionUsecaseImpl.swift
//  DomainLayer
//
//  Created by Alfian on 29/11/24.
//

public final class GetCurrentRegionUsecaseImpl: GetCurrentRegionUsecase {
  private let locationManager: LocationManager

  public init(locationManager: LocationManager) {
    self.locationManager = locationManager
  }

  public func execute() async throws -> CoordinateModel {
    try await withCheckedThrowingContinuation { continuation in
      locationManager.startUpdatingLocation { [weak self] result in
        switch result {
        case let .success(location):
          continuation.resume(returning: location.coordinate)
        case let .failure(error):
          continuation.resume(throwing: error)
        }
        self?.locationManager.stopUpdatingLocation()
      }
    }
  }
}
