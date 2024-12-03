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
  private let calendar: Calendar
  private let calendarDaysGridUsecase: CalendarDaysGridUseCase

  init(
    calendar: Calendar,
    calendarDaysGridUsecase: CalendarDaysGridUseCase
  ) {
    self.calendar = calendar
    self.calendarDaysGridUsecase = calendarDaysGridUsecase
  }

  func fetchCalendarDaysGrid() {
    let date = Date()
    days = calendarDaysGridUsecase.execute(timeInterval: date.timeIntervalSince1970)
  }
}
