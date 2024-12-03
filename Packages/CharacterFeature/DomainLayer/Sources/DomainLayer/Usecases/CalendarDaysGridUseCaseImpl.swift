//
//  CalendarDaysGridUseCaseImpl.swift
//  DomainLayer
//
//  Created by Alfian on 03/12/24.
//

public final class CalendarDaysGridUseCaseImpl: CalendarDaysGridUseCase {
  private let manager: CalendarManager

  public init(manager: CalendarManager) {
    self.manager = manager
  }

  public func execute(model: DateDomainModel) -> [String] {
    var totalSquare: [String] = []
    let days = manager.daysInMonth(date: model)
    let firstDayOfMonth = manager.firstOfMonth(date: model)
    let startingSpace = manager.weekOfDate(date: firstDayOfMonth)
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
