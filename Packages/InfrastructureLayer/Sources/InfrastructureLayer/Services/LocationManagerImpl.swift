//
//  LocationManager.swift
//  CleanApp
//
//  Created by Alfian on 27/11/24.
//

import CoreLocation
import Combine
import DomainLayer

public final class LocationManagerImpl: NSObject, ObservableObject, LocationManager {
    private let locationManager = CLLocationManager()
    
    // Published properties for SwiftUI
    @Published public var location: CLLocation?
    @Published public var authorizationStatus: CLAuthorizationStatus = .notDetermined
    @Published public var error: Error?

    public override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    // Request authorization
    public func requestAuthorization() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    // Start updating location
    public func startUpdatingLocation() {
        locationManager.startUpdatingLocation()
    }
    
    // Stop updating location
    public func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
    }
}

// MARK: - CLLocationManagerDelegate
extension LocationManagerImpl: @preconcurrency CLLocationManagerDelegate {
    public func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authorizationStatus = manager.authorizationStatus
    }
    
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let newLocation = locations.last {
            location = newLocation
        }
    }
    
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        self.error = error
        print("Location manager failed with error: \(error.localizedDescription)")
    }
}
