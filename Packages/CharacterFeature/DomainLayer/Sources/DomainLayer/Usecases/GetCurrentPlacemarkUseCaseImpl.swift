//
//  GetCurrentPlacemarkUseCaseImpl.swift
//  DomainLayer
//
//  Created by Alfian on 29/11/24.
//

public final class GetCurrentPlacemarkUseCaseImpl: GetCurrentPlacemarkUseCase {
  private let locationManager: LocationManager
  private let geocodingService: GeocodingService

  public init(locationManager: LocationManager, geocodingService: GeocodingService) {
    self.locationManager = locationManager
    self.geocodingService = geocodingService
  }

  public func execute() async throws -> PlacemarkModel {
    try await withCheckedThrowingContinuation { continuation in
      locationManager.startUpdatingLocation { [weak self] result in
        switch result {
        case let .success(location):
          self?.geocodingService.reverseGeocode(location: location) { result in
            switch result {
            case let .success(placemarks):
              guard let fistPlacemark = placemarks.first else {
                continuation.resume(throwing: LocationManagerError.noPlacemarkFound)
                return
              }
              continuation.resume(returning: fistPlacemark)
            case let .failure(error):
              continuation.resume(throwing: error)
            }
          }
        case let .failure(error):
          continuation.resume(throwing: error)
        }
      }
    }
  }
}

public extension GetCurrentPlacemarkUseCaseImpl {
  enum LocationManagerError: Error {
    case noPlacemarkFound
  }
}
