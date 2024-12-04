//
//  CalendarView.swift
//  PresentationLayer
//
//  Created by Alfian on 03/12/24.
//

import DomainLayer
import EventKit
import InfrastructureLayer
import SwiftUI

public struct CalendarView: View {
  @StateObject var viewModel: CalendarViewModel

  public init(viewModel: CalendarViewModel) {
    _viewModel = .init(wrappedValue: viewModel)
  }

  public var body: some View {
    ScrollView {
      LazyVStack {
        LazyVGrid(columns: [
          .init(.flexible()),
          .init(.flexible()),
          .init(.flexible()),
          .init(.flexible()),
          .init(.flexible()),
          .init(.flexible()),
          .init(.flexible())
        ]) {
          ForEach(viewModel.labels, id: \.self) { day in
            Text(day)
              .font(.headline)
          }
        }
        LazyVGrid(columns: [
          .init(.flexible()),
          .init(.flexible()),
          .init(.flexible()),
          .init(.flexible()),
          .init(.flexible()),
          .init(.flexible()),
          .init(.flexible())
        ]) {
          ForEach(viewModel.days, id: \.self) { day in
            Text(day)
              .frame(maxWidth: 32, maxHeight: 32)
              .padding(8)
          }
        }
        .onAppear {
          viewModel.fetchCalendarDaysGrid()
        }

        ForEach(viewModel.events, id: \.self) { event in
          Text(event.title)
        }
      }
      .padding(16)
    }
  }
}

#Preview {
  CalendarView(
    viewModel: CalendarViewModel(
      calendarDaysGridUsecase: CalendarDaysGridUseCaseImpl(manager: CalendarServiceImpl(calendar: .current)),
      getEventListUsecase: GetEventListUsecaseImpl(service: EventStoreServiceImpl(eventStore: EKEventStore()))
    )
  )
}
