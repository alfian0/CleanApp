//
//  CalendarManagerImpl.swift
//  InfrastructureLayer
//
//  Created by Alfian on 03/12/24.
//

import DomainLayer
import Foundation

public final class CalendarServiceImpl: CalendarService {
  private let calendar: Calendar

  public init(calendar: Calendar) {
    self.calendar = calendar
  }

  public func daysInMonth(timeInterval: Double) -> Int {
    let date = Date(timeIntervalSince1970: timeInterval)
    return calendar.range(of: .day, in: .month, for: date)?.count ?? 0
  }

  public func dayOfDate(timeInterval: Double) -> Int {
    let date = Date(timeIntervalSince1970: timeInterval)
    let components = calendar.dateComponents([.day], from: date)
    return components.day ?? 0
  }

  public func weekOfDate(timeInterval: Double) -> Int {
    let date = Date(timeIntervalSince1970: timeInterval)
    let components = calendar.dateComponents([.weekday], from: date)
    return max((components.weekday ?? 0) - 1, 0)
  }

  public func firstOfMonth(timeInterval: Double) -> Double {
    let date = Date(timeIntervalSince1970: timeInterval)
    let components = calendar.dateComponents([.year, .month], from: date)
    let result = calendar.date(from: components)
    return result?.timeIntervalSince1970 ?? 0
  }
}
