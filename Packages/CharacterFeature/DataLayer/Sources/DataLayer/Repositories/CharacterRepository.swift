//
//  CharacterListUsecaseImpl.swift
//  DataLayer
//
//  Created by Alfian on 26/11/24.
//

import Foundation
import DomainLayer
import InfrastructureLayer
import URLRequestBuilder

public final class CharacterRepositoryImpl: CharacterRepository {
    private let decoder: JSONDecoder
    
    public init(decoder: JSONDecoder = JSONDecoder()) {
        self.decoder = decoder
    }
    
    public func getCharacters() async throws -> ListModel<CharacterModel> {
        let baseUrl = URL(string: "https://rickandmortyapi.com/api/")!
        let urlRequest = URLRequestBuilder(path: "character")
            .method(.get)
            .makeRequest(withBaseURL: baseUrl)
        
        let client = HTTPClient()
        let wrapper = HTTPClientErrorMapperDecorator(decoratee: client)
        let (data, _) = try await wrapper.load(urlRequest: urlRequest)
        let result = try decoder.decode(ListResponse.self, from: data)
        let items = result.results.map({ CharacterModel(id: $0.id, name: $0.name, status: $0.gender, species: $0.species, gender: $0.gender, image: $0.image) })
        return ListModel(results: items)
    }
}
