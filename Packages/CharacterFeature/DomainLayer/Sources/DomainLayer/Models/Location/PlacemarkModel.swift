//
//  PlacemarkModel.swift
//  DomainLayer
//
//  Created by Alfian on 30/11/24.
//

public struct PlacemarkModel: Sendable {
    public let name: String?
    public let country: String?
    public let administrativeArea: String?
    public let locality: String?
    public let postalCode: String?
    public let isoCountryCode: String?
    public let location: LocationModel

    public init(
        name: String?,
        country: String?,
        administrativeArea: String?,
        locality: String?,
        postalCode: String?,
        isoCountryCode: String?,
        location: LocationModel
    ) {
        self.name = name
        self.country = country
        self.administrativeArea = administrativeArea
        self.locality = locality
        self.postalCode = postalCode
        self.isoCountryCode = isoCountryCode
        self.location = location
    }
}
