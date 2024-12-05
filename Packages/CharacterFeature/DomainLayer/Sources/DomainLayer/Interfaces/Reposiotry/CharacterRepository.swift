//
//  CharacterRepository.swift
//  DomainLayer
//
//  Created by Alfian on 26/11/24.
//

public protocol CharacterRepository {
  func getCharacters(page: Int) async throws -> ListModel<CharacterModel>
}
