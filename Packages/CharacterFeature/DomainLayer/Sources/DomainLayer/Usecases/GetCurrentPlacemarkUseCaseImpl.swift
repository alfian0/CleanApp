//
//  FetchUserAddressUseCaseImpl.swift
//  DomainLayer
//
//  Created by Alfian on 29/11/24.
//

import CoreLocation

public final class GetCurrentPlacemarkUseCaseImpl: GetCurrentPlacemarkUseCase {
    private let locationManager: LocationManager
    private let geocodingService: GeocodingService

    public init(locationManager: LocationManager, geocodingService: GeocodingService) {
        self.locationManager = locationManager
        self.geocodingService = geocodingService
    }

    public func execute() async throws -> CLPlacemark {
        try await withCheckedThrowingContinuation { continuation in
            locationManager.startUpdatingLocation { [weak self] result in
                switch result {
                case .success(let location):
                    self?.geocodingService.reverseGeocode(location: location, completion: { result in
                        switch result {
                        case .success(let placemarks):
                            if let firstPlacemark = placemarks?.first {
                                continuation.resume(returning: firstPlacemark)
                            } else {
                                continuation.resume(throwing: LocationManagerError.noPlacemarkFound)
                            }
                        case .failure(let error):
                            continuation.resume(throwing: error)
                        }
                        self?.locationManager.stopUpdatingLocation()
                    })
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}


extension GetCurrentPlacemarkUseCaseImpl {
    public enum LocationManagerError: Error {
        case noPlacemarkFound
    }
}
