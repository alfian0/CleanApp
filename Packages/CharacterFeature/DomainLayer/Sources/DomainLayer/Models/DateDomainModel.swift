//
//  DateDomainModel.swift
//  DomainLayer
//
//  Created by Alfian on 03/12/24.
//

public struct DateDomainModel: Equatable {
  public let year: Int
  public let month: Int
  public let day: Int
  public let hour: Int
  public let minute: Int

  public init(year: Int, month: Int, day: Int, hour: Int, minute: Int) {
    self.year = year
    self.month = month
    self.day = day
    self.hour = hour
    self.minute = minute
  }
}
