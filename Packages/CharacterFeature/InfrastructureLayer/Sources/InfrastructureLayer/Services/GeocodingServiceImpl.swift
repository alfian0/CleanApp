//
//  GeocodingServiceImpl.swift
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

  public func reverseGeocode(
    location: LocationModel,
    completion: @escaping (Result<[PlacemarkModel], Error>) -> Void
  ) {
    geocoder
      .reverseGeocodeLocation(
        CLLocation(
          latitude: location.coordinate.latitude,
          longitude: location.coordinate.longitude
        )
      ) { placemarks, error in
        if let error = error {
          completion(.failure(error))
        } else {
          let placemarks = placemarks?.map { placemark in
            PlacemarkModel(
              name: placemark.name,
              country: placemark.country,
              administrativeArea: placemark.administrativeArea,
              locality: placemark.locality,
              postalCode: placemark.postalCode,
              isoCountryCode: placemark.isoCountryCode,
              location: location
            )
          }
          completion(.success(placemarks ?? []))
        }
      }
  }
}
