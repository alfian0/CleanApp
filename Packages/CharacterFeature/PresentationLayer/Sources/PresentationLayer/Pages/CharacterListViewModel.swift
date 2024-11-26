//
//  CharacterListViewModel.swift
//  PresentationLayer
//
//  Created by Alfian on 26/11/24.
//

import Foundation
import DomainLayer

@MainActor
public final class CharacterListViewModel: ObservableObject {
    @Published private(set) var characters: [CharacterViewModel] = []
    private let characterListUseCase: CharacterListUsecase
    
    public init(characterListUseCase: CharacterListUsecase) {
        self.characterListUseCase = characterListUseCase
    }
    
    func fetchCharacters() {
        let usecase = characterListUseCase
        Task {
            do {
                let fetchedCharacters = try await usecase.execute()
                self.characters = fetchedCharacters.results.map {
                    CharacterViewModel(id: $0.id, name: $0.name, species: $0.species, image: $0.image)
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
