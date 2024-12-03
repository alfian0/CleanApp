//
//  CalendatManagerTests.swift
//  InfrastructureLayer
//
//  Created by Alfian on 03/12/24.
//

import DomainLayer
import InfrastructureLayer
import XCTest

final class CalendatManagerTests: XCTestCase {
  func test_CalendatManager() {
    let date = DateDomainModel(year: 2024, month: 12, day: 03, hour: 14, minute: 14)

    let sut = CalendarManagerImpl(calendar: .current)
    let daysInMonth = sut.daysInMonth(date: date)

    let firstMonth = sut.firstOfMonth(date: date)
    XCTAssertEqual(firstMonth, DateDomainModel(year: 2024, month: 12, day: 1, hour: 0, minute: 0))

    XCTAssertEqual(daysInMonth, 31)

    let dayOfDate = sut.dayOfDate(date: date)
    XCTAssertEqual(dayOfDate, 3)

    let weekOfDate = sut.weekOfDate(date: date)
    XCTAssertEqual(weekOfDate, 2)
  }
}
