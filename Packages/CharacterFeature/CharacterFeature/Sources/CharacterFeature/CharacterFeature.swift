// The Swift Programming Language
// https://docs.swift.org/swift-book

import DataLayer
import DomainLayer
import EventKit
import InfrastructureLayer
import PresentationLayer

public enum CharacterFeature {
  @MainActor
  public static func makeCharacterListView() -> CharacterListView {
    let repository = CharacterRepositoryImpl()
    let usecase = CharacterListUsecaseImpl(characterRepository: repository)
    let viewModel = CharacterListViewModel(characterListUseCase: usecase)

    return CharacterListView(viewModel: viewModel)
  }
}

public enum MapViewFeature {
  @MainActor
  public static func makeMapView() -> MapView {
    let manager = LocationManagerImpl()
    let usecase = GetCurrentRegionUsecaseImpl(locationManager: manager)
    let viewModel = MapViewModel(usecase: usecase)
    return MapView(viewModel: viewModel)
  }
}

public enum CalendarViewFeature {
  @MainActor
  public static func makeCalendarView() -> CalendarView {
    let calendarService = CalendarServiceImpl(calendar: .current)
    let calendarDaysGridUsecase = CalendarDaysGridUseCaseImpl(manager: calendarService)
    let eventService = EventStoreServiceImpl(eventStore: EKEventStore())
    let getEventListUsecase = GetEventListUsecaseImpl(service: eventService)
    let viewModel = CalendarViewModel(
      calendarDaysGridUsecase: calendarDaysGridUsecase,
      getEventListUsecase: getEventListUsecase
    )
    return CalendarView(viewModel: viewModel)
  }
}
