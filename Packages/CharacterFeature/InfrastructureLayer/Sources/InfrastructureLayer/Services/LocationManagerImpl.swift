//
//  LocationManagerImpl.swift
//  InfrastructureLayer
//
//  Created by Alfian on 28/11/24.
//

import CoreLocation
import DomainLayer
import Foundation

public final class LocationManagerImpl: NSObject, LocationManager {
  private let manager: CLLocationManager
  private var completion: ((Result<LocationModel, Error>) -> Void)?

  public init(manager: CLLocationManager = CLLocationManager()) {
    self.manager = manager
    super.init()
    self.manager.delegate = self
  }

  public func startUpdatingLocation(completion: @escaping (Result<LocationModel, Error>) -> Void) {
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

  public func stopUpdatingLocation() {
    manager.stopUpdatingLocation()
    completion = nil
  }
}

extension LocationManagerImpl: CLLocationManagerDelegate {
  public func locationManager(_: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    if let lastLocation = locations.last {
      let location = LocationModel(
        coordinate: CoordinateModel(
          latitude: lastLocation.coordinate.latitude,
          longitude: lastLocation.coordinate.longitude
        )
      )
      completion?(.success(location))
    }
  }

  public func locationManager(_: CLLocationManager, didFailWithError error: any Error) {
    completion?(.failure(error))
  }

  public func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
    switch manager.authorizationStatus {
    case .authorizedAlways, .authorizedWhenInUse:
      manager.startUpdatingLocation()
    default:
      manager.stopUpdatingLocation()
    }
  }
}

public extension LocationManagerImpl {
  enum LocationManagerError: Error {
    case authorizationDenied
    case unknownAuthorizationStatus
    case locationUpdateTimedOut
  }
}
