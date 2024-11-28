//
//  LocationManager.swift
//  InfrastructureLayer
//
//  Created by Alfian on 28/11/24.
//

import Foundation
import CoreLocation

final class LocationManager: NSObject {
    private let manager: CLLocationManager
    private var completion: ((Result<CLLocation, Error>) -> Void)?
    var finish: (() -> Void)?
    
    init(manager: CLLocationManager = CLLocationManager()) {
        self.manager = manager
        super.init()
        self.manager.delegate = self
    }
    
    func fetchLocation(completion: @escaping (Result<CLLocation, Error>) -> Void) {
        self.completion = completion
        
        switch manager.authorizationStatus {
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        case .authorizedAlways, .authorizedWhenInUse:
            manager.startUpdatingLocation()
        case .denied, .restricted:
            completion(.failure(LocationManagerError.authorizationDenied))
        @unknown default:
            completion(.failure(LocationManagerError.unknownAuthorizationStatus))
        }
    }

    // The selector method for when the timer fires
    @objc
    private func locationUpdateTimedOut() {
        stopUpdatingLocation()
        completion?(.failure(LocationManagerError.locationUpdateTimedOut))
    }
    
    func stopUpdatingLocation () {
        manager.stopUpdatingLocation()
        finish?()
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let lastLocation = locations.last {
            completion?(.success(lastLocation))
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        completion?(.failure(error))
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus  {
        case .authorizedAlways, .authorizedWhenInUse:
            manager.startUpdatingLocation()
        default:
            stopUpdatingLocation()
        }
    }
}

extension LocationManager {
    enum LocationManagerError: Error {
        case authorizationDenied
        case unknownAuthorizationStatus
        case locationUpdateTimedOut
    }
}

final class LocationManagerStream {
    private var manager: LocationManager
    private var continuation: AsyncThrowingStream<CLLocation, Error>.Continuation?
    
    init(manager: LocationManager) {
        self.manager = manager
        self.manager.finish = { [weak self] in
            self?.continuation?.finish()
            self?.continuation = nil
        }
    }
    
    func finish() {
        manager.stopUpdatingLocation()
    }

    func fetchLocation() -> AsyncThrowingStream<CLLocation, Error> {
        // Create an AsyncStream that will emit CLLocation values
        return AsyncThrowingStream { [weak self] continuation in
            self?.continuation = continuation
            // Start fetching location by calling the fetchLocation method of LocationManager
            self?.manager.fetchLocation { result in
                switch result {
                case .success(let location):
                    continuation.yield(location)
                case .failure(let error):
                    continuation.finish(throwing: error)
                }
            }
        }
    }
}
