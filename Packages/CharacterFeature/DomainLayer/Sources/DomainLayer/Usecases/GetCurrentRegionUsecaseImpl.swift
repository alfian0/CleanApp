//
//  GetCurrentRegionUsecaseImpl.swift
//  DomainLayer
//
//  Created by Alfian on 29/11/24.
//

import MapKit

public final class GetCurrentRegionUsecaseImpl: GetCurrentRegionUsecase {
    private let locationManager: LocationManager
    
    public init(locationManager: LocationManager) {
        self.locationManager = locationManager
    }
    
    public func execute() async throws -> MKCoordinateRegion {
        try await withCheckedThrowingContinuation { [weak self] continuation in
            self?.locationManager.startUpdatingLocation { result in
                switch result {
                case .success(let location):
                    continuation.resume(
                        returning: MKCoordinateRegion(
                            center: location.coordinate,
                            span: MKCoordinateSpan(
                                latitudeDelta: 0.05,
                                longitudeDelta: 0.05
                            )
                        )
                    )
                    self?.locationManager.stopUpdatingLocation()
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}
