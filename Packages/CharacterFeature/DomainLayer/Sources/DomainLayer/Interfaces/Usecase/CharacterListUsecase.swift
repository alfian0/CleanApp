//
//  CharacterListUsecase.swift
//  DomainLayer
//
//  Created by Alfian on 26/11/24.
//

public protocol CharacterListUsecase {
  func execute(page: Int) async throws -> ListModel<CharacterModel>
}
