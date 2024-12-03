//
//  CalendarView.swift
//  PresentationLayer
//
//  Created by Alfian on 03/12/24.
//

import DomainLayer
import InfrastructureLayer
import SwiftUI

public struct CalendarView: View {
  @StateObject var viewModel: CalendarViewModel

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
      }
      .padding(16)
    }
  }
}

#Preview {
  CalendarView(
    viewModel: CalendarViewModel(
      calendar: .current,
      calendarDaysGridUsecase: CalendarDaysGridUseCaseImpl(manager: CalendarManagerImpl(calendar: .current))
    )
  )
}
