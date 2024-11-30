//
//  GetCurrentPlacemarkUseCaseImpl.swift
//  DomainLayer
//
//  Created by Alfian on 29/11/24.
//

public final class GetCurrentPlacemarkUseCaseImpl: GetCurrentPlacemarkUseCase {
    private let locationManager: LocationManager
    private let geocodingService: GeocodingService

    public init(locationManager: LocationManager, geocodingService: GeocodingService) {
        self.locationManager = locationManager
        self.geocodingService = geocodingService
    }

    public func execute() async throws -> PlacemarkModel {
        return PlacemarkModel(
            name: "placemark.name",
            country: "placemark.country",
            administrativeArea: "placemark.administrativeArea",
            locality: "placemark.locality",
            postalCode: "placemark.postalCode",
            isoCountryCode: "placemark.isoCountryCode",
            location: LocationModel(
                coordinate: CoordinateModel(
                    latitude: 0,
                    longitude: 0
                )
            )
        )
    }
}

public extension GetCurrentPlacemarkUseCaseImpl {
    enum LocationManagerError: Error {
        case noPlacemarkFound
    }
}
