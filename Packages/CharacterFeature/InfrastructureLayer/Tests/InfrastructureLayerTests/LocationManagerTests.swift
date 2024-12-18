//
//  LocationManagerTests.swift
//  InfrastructureLayer
//
//  Created by Alfian on 28/11/24.
//

import CoreLocation
import InfrastructureLayer
import XCTest

final class LocationManagerTests: XCTestCase {
  func test_fetchLocation_withSuccessLocation() {
    let expectation = expectation(description: "Should fetch location")
    let expectedLocation = CLLocation(latitude: 0, longitude: 0)
    let manager = CLLocationManagerSpy()
    manager.simulatedAuthorizationStatus = .notDetermined
    manager.simulatedResult = .success(expectedLocation)
    let sut = LocationManagerImpl(manager: manager)
    XCTAssertNotNil(manager.delegate)
    sut.startUpdatingLocation { result in
      switch result {
      case let .success(location):
        XCTAssertEqual(location.coordinate.latitude, expectedLocation.coordinate.latitude)
        XCTAssertEqual(location.coordinate.longitude, expectedLocation.coordinate.longitude)
        expectation.fulfill()
      case .failure:
        XCTFail()
      }
    }
    XCTAssertTrue(manager.didCallRequestWhenInUseAuthorization)
    XCTAssertTrue(manager.didCallStartUpdatingLocation)
    XCTAssertEqual(manager.simulatedAuthorizationStatus, .authorizedWhenInUse)
    wait(for: [expectation])
  }

  func test_fetchLocation_withFailed() {
    let expectation = expectation(description: "Should error when fetch location")
    let manager = CLLocationManagerSpy()
    manager.simulatedAuthorizationStatus = .notDetermined
    manager.simulatedResult = .failure(LocationManagerImpl.LocationManagerError.locationUpdateTimedOut)
    let sut = LocationManagerImpl(manager: manager)
    XCTAssertNotNil(manager.delegate)
    sut.startUpdatingLocation { result in
      switch result {
      case .success:
        XCTFail()
      case let .failure(error):
        XCTAssertEqual(
          error as? LocationManagerImpl.LocationManagerError,
          LocationManagerImpl.LocationManagerError.locationUpdateTimedOut
        )
        expectation.fulfill()
      }
    }
    XCTAssertTrue(manager.didCallRequestWhenInUseAuthorization)
    XCTAssertTrue(manager.didCallStartUpdatingLocation)
    XCTAssertEqual(manager.simulatedAuthorizationStatus, .authorizedWhenInUse)
    wait(for: [expectation])
  }
}

final class CLLocationManagerSpy: CLLocationManager {
  // Simulate the authorization status
  var simulatedAuthorizationStatus: CLAuthorizationStatus = .notDetermined

  // Simulate location result
  var simulatedResult: Result<CLLocation, Error>?

  // Track whether certain methods were called
  private(set) var didCallRequestWhenInUseAuthorization = false
  private(set) var didCallRequestAlwaysAuthorization = false
  private(set) var didCallStartUpdatingLocation = false
  private(set) var didCallStopUpdatingLocation = false

  override var authorizationStatus: CLAuthorizationStatus {
    return simulatedAuthorizationStatus
  }

  override func requestWhenInUseAuthorization() {
    didCallRequestWhenInUseAuthorization = true
    simulatedAuthorizationStatus = .authorizedWhenInUse
    delegate?.locationManagerDidChangeAuthorization?(self)
  }

  override func requestAlwaysAuthorization() {
    didCallRequestAlwaysAuthorization = true
    simulatedAuthorizationStatus = .authorizedAlways
    delegate?.locationManagerDidChangeAuthorization?(self)
  }

  override func startUpdatingLocation() {
    didCallStartUpdatingLocation = true

    // Simulate location updates or failures based on the result
    guard let result = simulatedResult else { return }
    switch result {
    case let .success(location):
      delegate?.locationManager?(self, didUpdateLocations: [location])
    case let .failure(error):
      delegate?.locationManager?(self, didFailWithError: error)
    }
  }

  override func stopUpdatingLocation() {
    didCallStopUpdatingLocation = true
  }
}
