//
//  GetEventListUsecase.swift
//  DomainLayer
//
//  Created by Alfian on 04/12/24.
//

public protocol GetEventListUsecase {
  func execute(startDate: Double, endDate: Double) async throws -> [EventDomainModel]
}
