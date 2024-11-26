//
//  CharacterRepository.swift
//  DomainLayer
//
//  Created by Alfian on 26/11/24.
//

public protocol CharacterRepository {
    func getCharacters() async throws -> ListModel<CharacterModel>
}
