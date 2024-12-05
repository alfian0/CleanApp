//
//  CharacterRepository.swift
//  DataLayer
//
//  Created by Alfian on 26/11/24.
//

import DomainLayer
import Foundation
import InfrastructureLayer

public final class CharacterRepositoryImpl: CharacterRepository {
  private let service: RickAndMortyServiceImpl
  private let decoder: JSONDecoder

  public init(service: RickAndMortyServiceImpl, decoder: JSONDecoder) {
    self.service = service
    self.decoder = decoder
  }

  public func getCharacters(page: Int) async throws -> ListModel<CharacterModel> {
    let data = try await service.getCharacters(page: page)
    let result = try decoder.decode(ListResponse.self, from: data)
    let items = result.results.map {
      CharacterModel(
        id: $0.id,
        name: $0.name,
        status: $0.gender,
        species: $0.species,
        gender: $0.gender,
        image: $0.image
      )
    }
    return ListModel(results: items, pages: result.info.pages)
  }
}
