@testable import DomainLayer
import XCTest

final class DomainLayerTests: XCTestCase {
  func test_totalSquareUsecaseImpl() {
    var components = DateComponents()
    components.year = 2024
    components.month = 12
    components.day = 3
    components.hour = 14
    components.minute = 14
    let date = Calendar.current.date(from: components)!

    let sut = CalendarDaysGridUseCaseImpl(manager: CalendarManagerStub())
    let totalSquare = sut.execute(timeInterval: date.timeIntervalSince1970)
    let expectedTotalSquare: [String] = [
      "1",
      "2",
      "3",
      "4",
      "5",
      "6",
      "7",
      "8",
      "9",
      "10",
      "11",
      "12",
      "13",
      "14",
      "15",
      "16",
      "17",
      "18",
      "19",
      "20",
      "21",
      "22",
      "23",
      "24",
      "25",
      "26",
      "27",
      "28",
      "29",
      "30",
      "31",
      "",
      "",
      "",
      "",
      "",
      "",
      "",
      "",
      "",
      "",
      ""
    ]
    XCTAssertEqual(totalSquare, expectedTotalSquare)
  }
}

// MARK: 2024-12-3

// days: 31
// day: 03
// week: 0 -> sunday
final class CalendarManagerStub: CalendarService {
  func daysInMonth(timeInterval _: Double) -> Int {
    31
  }

  func dayOfDate(timeInterval _: Double) -> Int {
    3
  }

  func weekOfDate(timeInterval _: Double) -> Int {
    0
  }

  func firstOfMonth(timeInterval _: Double) -> Double {
    1_732_986_000.0
  }
}
