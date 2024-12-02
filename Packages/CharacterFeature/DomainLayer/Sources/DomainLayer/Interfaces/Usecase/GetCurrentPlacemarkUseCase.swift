//
//  GetCurrentPlacemarkUseCase.swift
//  DomainLayer
//
//  Created by Alfian on 29/11/24.
//

public protocol GetCurrentPlacemarkUseCase {
  func execute() async throws -> PlacemarkModel
}
