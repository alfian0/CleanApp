//
//  CalendarService.swift
//  DomainLayer
//
//  Created by Alfian on 03/12/24.
//

public protocol CalendarService {
  func daysInMonth(timeInterval: Double) -> Int
  func dayOfDate(timeInterval: Double) -> Int
  func weekOfDate(timeInterval: Double) -> Int
  func firstOfMonth(timeInterval: Double) -> Double
}
