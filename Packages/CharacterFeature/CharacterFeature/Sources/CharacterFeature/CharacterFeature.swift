// The Swift Programming Language
// https://docs.swift.org/swift-book

import DataLayer
import DomainLayer
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
