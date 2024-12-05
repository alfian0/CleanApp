//
//  CharacterListViewModel.swift
//  PresentationLayer
//
//  Created by Alfian on 26/11/24.
//

import DomainLayer
import Foundation

@MainActor
public final class CharacterListViewModel: ObservableObject {
  @Published private(set) var characters: [CharacterViewModel] = []

  private var page: Int = 1
  private var pages: Int = 1
  private var isLoading: Bool = false

  private let characterListUseCase: CharacterListUsecase

  public init(characterListUseCase: CharacterListUsecase) {
    self.characterListUseCase = characterListUseCase
  }

  func fetchCharacters() {
    guard isLoading == false && page <= pages else { return }
    isLoading = true
    let usecase = characterListUseCase
    Task { [weak self] in
      guard let self = self else { return }
      do {
        let fetchedCharacters = try await usecase.execute(page: self.page)
        let characters = fetchedCharacters.results.map {
          CharacterViewModel(id: $0.id, name: $0.name, species: $0.species, image: $0.image)
        }

        pages = fetchedCharacters.pages
        if page == 1 {
          self.characters = characters
        } else {
          self.characters.append(contentsOf: characters)
        }
        page += 1
      } catch {
        print(error.localizedDescription)
      }
      isLoading = false
    }
  }

  func hasReachEnd(of character: CharacterViewModel) -> Bool {
    character.id == characters.last?.id
  }
}
