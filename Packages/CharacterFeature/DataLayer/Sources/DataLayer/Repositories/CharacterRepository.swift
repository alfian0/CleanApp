//
//  CharacterListUsecaseImpl.swift
//  DataLayer
//
//  Created by Alfian on 26/11/24.
//

import Foundation
import DomainLayer
import HTTPClient
import URLRequestBuilder

public final class CharacterRepositoryImpl: CharacterRepository {
    public init() {}
    
    public func getCharacters() async throws -> ListModel<CharacterModel> {
        let baseUrl = URL(string: "https://rickandmortyapi.com/api/")!
        let urlRequest = URLRequestBuilder(path: "character")
            .method(.get)
            .makeRequest(withBaseURL: baseUrl)
        
        let client = HTTPClient()
        let wrapper = HTTPClientErrorMapperDecorator(decoratee: client)
        let adapter = HTTPClientModelMapperAdapter(client: wrapper)
        let result = try await adapter.load(urlRequest: urlRequest, model: ListResponse.self)
        let items = result.results.map({ CharacterModel(id: $0.id, name: $0.name, status: $0.gender, species: $0.species, gender: $0.gender, image: $0.image) })
        return ListModel(results: items)
    }
}
