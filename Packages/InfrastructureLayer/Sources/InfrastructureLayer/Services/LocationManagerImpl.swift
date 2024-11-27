//
//  LocationManager.swift
//  CleanApp
//
//  Created by Alfian on 27/11/24.
//

import CoreLocation
import Combine
import DomainLayer

final class LocationManagerImpl: NSObject, ObservableObject, LocationManager {
    private let locationManager = CLLocationManager()
    
    // Published properties for SwiftUI
    @Published var location: CLLocation?
    @Published var authorizationStatus: CLAuthorizationStatus = .notDetermined
    @Published var error: Error?

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    // Request authorization
    func requestAuthorization() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    // Start updating location
    func startUpdatingLocation() {
        locationManager.startUpdatingLocation()
    }
    
    // Stop updating location
    func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
    }
}

// MARK: - CLLocationManagerDelegate
extension LocationManagerImpl: @preconcurrency CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authorizationStatus = manager.authorizationStatus
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let newLocation = locations.last {
            location = newLocation
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        self.error = error
        print("Location manager failed with error: \(error.localizedDescription)")
    }
}
