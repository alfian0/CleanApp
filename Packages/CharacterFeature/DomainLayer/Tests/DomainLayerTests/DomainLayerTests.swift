@testable import DomainLayer
import XCTest

final class DomainLayerTests: XCTestCase {
  func test_TotalSquareUsecaseImpl() {
    let date = DateDomainModel(year: 2024, month: 12, day: 03, hour: 14, minute: 14)

    let sut = CalendarDaysGridUseCaseImpl(manager: CalendarManagerStub())
    let totalSquare = sut.execute(model: date)
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
  func daysInMonth(date _: DateDomainModel) -> Int {
    31
  }

  func dayOfDate(date _: DateDomainModel) -> Int {
    3
  }

  func weekOfDate(date _: DateDomainModel) -> Int {
    0
  }

  func firstOfMonth(date _: DateDomainModel) -> DateDomainModel {
    DateDomainModel(year: 2024, month: 12, day: 1, hour: 0, minute: 0)
  }
}
