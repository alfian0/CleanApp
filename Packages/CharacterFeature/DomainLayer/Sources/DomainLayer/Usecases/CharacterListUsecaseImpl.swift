//
//  CharacterListUsecaseImpl.swift
//  DomainLayer
//
//  Created by Alfian on 26/11/24.
//

public final class CharacterListUsecaseImpl: CharacterListUsecase {
  private let characterRepository: CharacterRepository

  public init(characterRepository: CharacterRepository) {
    self.characterRepository = characterRepository
  }

  public func execute() async throws -> ListModel<CharacterModel> {
    try await characterRepository.getCharacters()
  }
}
