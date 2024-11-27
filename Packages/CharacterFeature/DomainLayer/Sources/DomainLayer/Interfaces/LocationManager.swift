//
//  LocationManager.swift
//  DomainLayer
//
//  Created by Alfian on 27/11/24.
//

import CoreLocation

@MainActor
public protocol LocationManager {
    var location: CLLocation? { get }
    var authorizationStatus: CLAuthorizationStatus { get }
    var error: Error? { get }
    
    func requestAuthorization()
    func startUpdatingLocation()
    func stopUpdatingLocation()
}
