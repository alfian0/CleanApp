//
//  FetchUserAddressUseCase.swift
//  DomainLayer
//
//  Created by Alfian on 29/11/24.
//

import CoreLocation

public protocol GetCurrentPlacemarkUseCase {
    func execute() async throws -> CLPlacemark
}
