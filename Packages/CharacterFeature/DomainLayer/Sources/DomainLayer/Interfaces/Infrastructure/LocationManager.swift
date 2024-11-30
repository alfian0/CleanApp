//
//  LocationManager.swift
//  DomainLayer
//
//  Created by Alfian on 29/11/24.
//

import CoreLocation

public protocol LocationManager {
    func startUpdatingLocation(completion: @escaping (Result<LocationModel, Error>) -> Void)
    func stopUpdatingLocation()
}