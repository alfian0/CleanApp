//
//  CalendarViewModel.swift
//  PresentationLayer
//
//  Created by Alfian on 03/12/24.
//

import DomainLayer
import Foundation
import InfrastructureLayer

@MainActor
public final class CalendarViewModel: ObservableObject {
  @Published var labels: [String] = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
  @Published var days: [String] = []
  @Published var events: [EventDomainModel] = [EventDomainModel(title: "aaaa", startDate: 0, endDate: 0, location: nil)]
  private let calendarDaysGridUsecase: CalendarDaysGridUseCase
  private let getEventListUsecase: GetEventListUsecase

  public init(
    calendarDaysGridUsecase: CalendarDaysGridUseCase,
    getEventListUsecase: GetEventListUsecase
  ) {
    self.calendarDaysGridUsecase = calendarDaysGridUsecase
    self.getEventListUsecase = getEventListUsecase
  }

  func fetchCalendarDaysGrid() {
    let date = Date()
    let endDate = Calendar.current.date(byAdding: .month, value: 1, to: date)!
    days = calendarDaysGridUsecase.execute(timeInterval: date.timeIntervalSince1970)
    let getEventListUsecase = getEventListUsecase
    Task {
      do {
        let events = try await getEventListUsecase.execute(
          startDate: date.timeIntervalSince1970,
          endDate: endDate.timeIntervalSince1970
        )
        self.events = events
      } catch {
        print(error)
      }
    }
  }
}
