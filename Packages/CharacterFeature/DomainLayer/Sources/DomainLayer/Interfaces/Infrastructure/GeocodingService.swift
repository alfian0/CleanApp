//
//  GeocodingService.swift
//  DomainLayer
//
//  Created by Alfian on 29/11/24.
//

public protocol GeocodingService {
    func reverseGeocode(location: LocationModel, completion: @escaping (Result<[PlacemarkModel], Error>) -> Void)
}
