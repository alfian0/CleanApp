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
    var components = DateComponents()
    components.year = 2024
    components.month = 12
    components.day = 3
    components.hour = 14
    components.minute = 14
    let date = Calendar.current.date(from: components)!

    let sut = CalendarServiceImpl(calendar: .current)
    let daysInMonth = sut.daysInMonth(timeInterval: date.timeIntervalSince1970)

    let firstMonth = sut.firstOfMonth(timeInterval: date.timeIntervalSince1970)
    XCTAssertEqual(firstMonth, 1732986000.0)

    XCTAssertEqual(daysInMonth, 31)

    let dayOfDate = sut.dayOfDate(timeInterval: date.timeIntervalSince1970)
    XCTAssertEqual(dayOfDate, 3)

    let weekOfDate = sut.weekOfDate(timeInterval: date.timeIntervalSince1970)
    XCTAssertEqual(weekOfDate, 2)
  }
}
