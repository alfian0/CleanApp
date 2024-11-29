//
//  GeocodingService.swift
//  InfrastructureLayer
//
//  Created by Alfian on 29/11/24.
//

import CoreLocation
import DomainLayer

public final class GeocodingServiceImpl: GeocodingService {
    private let geocoder: CLGeocoder

    public init(geocoder: CLGeocoder = CLGeocoder()) {
        self.geocoder = geocoder
    }

    public func reverseGeocode(location: CLLocation, completion: @escaping (Result<[CLPlacemark]?, Error>) -> Void) {
        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(placemarks))
            }
        }
    }
}
