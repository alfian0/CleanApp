//
//  ListModel.swift
//  DomainLayer
//
//  Created by Alfian on 26/11/24.
//

public struct ListModel<T: Sendable>: Sendable {
  public let results: [T]

  public init(results: [T]) {
    self.results = results
  }
}
