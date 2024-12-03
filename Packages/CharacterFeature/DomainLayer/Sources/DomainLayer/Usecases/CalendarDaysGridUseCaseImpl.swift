//
//  CalendarDaysGridUseCaseImpl.swift
//  DomainLayer
//
//  Created by Alfian on 03/12/24.
//

public final class CalendarDaysGridUseCaseImpl: CalendarDaysGridUseCase {
  private let manager: CalendarService

  public init(manager: CalendarService) {
    self.manager = manager
  }

  public func execute(timeInterval: Double) -> [String] {
    var totalSquare: [String] = []
    let days = manager.daysInMonth(timeInterval: timeInterval)
    let firstDayOfMonth = manager.firstOfMonth(timeInterval: timeInterval)
    let startingSpace = manager.weekOfDate(timeInterval: firstDayOfMonth)
    for index in 1 ... 42 {
      if index <= startingSpace || (index - startingSpace) > days {
        totalSquare.append("")
      } else {
        totalSquare.append(String(index - startingSpace))
      }
    }
    return totalSquare
  }
}
