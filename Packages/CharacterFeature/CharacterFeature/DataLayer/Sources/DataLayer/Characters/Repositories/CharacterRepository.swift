//
//  CharacterListUsecaseImpl.swift
//  DataLayer
//
//  Created by Alfian on 26/11/24.
//

import Foundation
import DomainLayer

public final class CharacterRepositoryImpl: CharacterRepository {
    public init() {}
    
    public func getCharacters() async throws -> ListModel<CharacterModel> {
        let (data, response) = try await URLSession.shared.data(for: URLRequest(url: URL(string: "https://rickandmortyapi.com/api/character")!))
        let result = try JSONDecoder().decode(ListResponse.self, from: data)
        let items = result.results.map({ CharacterModel(id: $0.id, name: $0.name, status: $0.gender, species: $0.species, gender: $0.gender, image: $0.image) })
        return ListModel(results: items)
    }
}
