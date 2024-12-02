//
//  GetCurrentRegionUsecase.swift
//  DomainLayer
//
//  Created by Alfian on 29/11/24.
//

public protocol GetCurrentRegionUsecase {
  func execute() async throws -> CoordinateModel
}
