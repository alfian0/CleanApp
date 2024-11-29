//
//  GeocodingService.swift
//  DomainLayer
//
//  Created by Alfian on 29/11/24.
//

import CoreLocation

public protocol GeocodingService {
    func reverseGeocode(location: CLLocation, completion: @escaping (Result<[CLPlacemark]?, Error>) -> Void)
}
