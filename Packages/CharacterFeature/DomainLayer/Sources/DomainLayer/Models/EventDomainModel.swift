//
//  EventDomainModel.swift
//  DomainLayer
//
//  Created by Alfian on 04/12/24.
//

public struct EventDomainModel: Hashable, Sendable {
  public let title: String
  public let startDate: Double
  public let endDate: Double
  public let location: String?

  public init(title: String, startDate: Double, endDate: Double, location: String?) {
    self.title = title
    self.startDate = startDate
    self.endDate = endDate
    self.location = location
  }
}
