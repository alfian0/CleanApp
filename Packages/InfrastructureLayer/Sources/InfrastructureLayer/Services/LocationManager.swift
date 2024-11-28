//
//  LocationManager.swift
//  InfrastructureLayer
//
//  Created by Alfian on 28/11/24.
//

import Foundation
import CoreLocation

public final class LocationManager: NSObject {
    private let manager: CLLocationManager
    private var completion: ((Result<CLLocation, Error>) -> Void)?
    public var finish: (() -> Void)?
    
    public init(manager: CLLocationManager = CLLocationManager()) {
        self.manager = manager
        super.init()
        self.manager.delegate = self
    }
    
    public func startUpdatingLocation(completion: @escaping (Result<CLLocation, Error>) -> Void) {
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
    
    public func stopUpdatingLocation () {
        manager.stopUpdatingLocation()
        finish?()
    }
}

extension LocationManager: CLLocationManagerDelegate {
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let lastLocation = locations.last {
            completion?(.success(lastLocation))
        }
    }
    
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        completion?(.failure(error))
    }
    
    public func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus  {
        case .authorizedAlways, .authorizedWhenInUse:
            manager.startUpdatingLocation()
        default:
            stopUpdatingLocation()
        }
    }
}

extension LocationManager {
    public enum LocationManagerError: Error {
        case authorizationDenied
        case unknownAuthorizationStatus
        case locationUpdateTimedOut
    }
}

public final class LocationManagerStream {
    private var manager: LocationManager
    private var continuation: AsyncThrowingStream<CLLocation, Error>.Continuation?
    
    public init(manager: LocationManager) {
        self.manager = manager
        self.manager.finish = { [weak self] in
            self?.continuation?.finish()
            self?.continuation = nil
        }
    }
    
    public func stopUpdatingLocation() {
        manager.stopUpdatingLocation()
    }

    public func fetchLocation() -> AsyncThrowingStream<CLLocation, Error> {
        // Create an AsyncStream that will emit CLLocation values
        return AsyncThrowingStream { [weak self] continuation in
            self?.continuation = continuation
            // Start fetching location by calling the fetchLocation method of LocationManager
            self?.manager.startUpdatingLocation { result in
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
