//
//  ListModel.swift
//  DomainLayer
//
//  Created by Alfian on 26/11/24.
//

public struct ListModel<T: Sendable>: Sendable {
  public let results: [T]
  public let pages: Int

  public init(results: [T], pages: Int) {
    self.results = results
    self.pages = pages
  }
}
