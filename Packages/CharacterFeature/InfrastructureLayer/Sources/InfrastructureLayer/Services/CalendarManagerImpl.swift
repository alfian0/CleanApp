//
//  CalendarManagerImpl.swift
//  InfrastructureLayer
//
//  Created by Alfian on 03/12/24.
//

import DomainLayer
import Foundation

public final class CalendarManagerImpl: CalendarManager {
  private let calendar: Calendar

  public init(calendar: Calendar) {
    self.calendar = calendar
  }

  public func daysInMonth(date: DateDomainModel) -> Int {
    let date = buildDate(from: date)
    return calendar.range(of: .day, in: .month, for: date)?.count ?? 0
  }

  public func dayOfDate(date: DateDomainModel) -> Int {
    let date = buildDate(from: date)
    let components = calendar.dateComponents([.day], from: date)
    return components.day ?? 0
  }

  public func weekOfDate(date: DateDomainModel) -> Int {
    let date = buildDate(from: date)
    let components = calendar.dateComponents([.weekday], from: date)
    return max((components.weekday ?? 0) - 1, 0)
  }

  public func firstOfMonth(date: DateDomainModel) -> DateDomainModel {
    let date = buildDate(from: date)
    let components = calendar.dateComponents([.year, .month], from: date)
    return DateDomainModel(
      year: components.year ?? 0,
      month: components.month ?? 0,
      day: 1,
      hour: 0,
      minute: 0
    )
  }

  private func buildDate(from model: DateDomainModel) -> Date {
    var components = DateComponents()
    components.year = model.year
    components.month = model.month
    components.day = model.day
    components.hour = model.hour
    components.minute = model.minute

    return Calendar.current.date(from: components) ?? Date()
  }
}
