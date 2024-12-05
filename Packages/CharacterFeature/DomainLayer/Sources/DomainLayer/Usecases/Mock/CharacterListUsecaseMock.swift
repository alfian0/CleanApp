//
//  CharacterListUsecaseMock.swift
//  DomainLayer
//
//  Created by Alfian on 26/11/24.
//

public final class CharacterListUsecaseMock: CharacterListUsecase {
  public init() {}

  public func execute(page _: Int) async throws -> ListModel<CharacterModel> {
    return ListModel(
      results: [
        CharacterModel(
          id: 1,
          name: "Rick Sanchez",
          status: "Alive",
          species: "Human",
          gender: "Male",
          image: "https://rickandmortyapi.com/api/character/avatar/1.jpeg"
        ),
        CharacterModel(
          id: 2,
          name: "Morty Smith",
          status: "Alive",
          species: "Human",
          gender: "Male",
          image: "https://rickandmortyapi.com/api/character/avatar/2.jpeg"
        )
      ],
      pages: 1
    )
  }
}
