// The Swift Programming Language
// https://docs.swift.org/swift-book

import DomainLayer
import DataLayer
import PresentationLayer

public struct CharacterFeature {
    @MainActor
    public static func makeCharacterListView() -> MapView {
        let repository = CharacterRepositoryImpl()
        let usecase = CharacterListUsecaseImpl(characterRepository: repository)
        let viewModel = CharacterListViewModel(characterListUseCase: usecase)
        
        return MapView()
    }
}
