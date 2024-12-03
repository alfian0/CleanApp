//
//  CalendarManager.swift
//  DomainLayer
//
//  Created by Alfian on 03/12/24.
//

public protocol CalendarManager {
  func daysInMonth(date: DateDomainModel) -> Int
  func dayOfDate(date: DateDomainModel) -> Int
  func weekOfDate(date: DateDomainModel) -> Int
  func firstOfMonth(date: DateDomainModel) -> DateDomainModel
}
