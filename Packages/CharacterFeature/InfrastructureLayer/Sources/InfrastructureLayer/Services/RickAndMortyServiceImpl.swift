//
//  RickAndMortyServiceImpl.swift
//  InfrastructureLayer
//
//  Created by Alfian on 05/12/24.
//

import Foundation
import URLRequestBuilder

public class RickAndMortyServiceImpl {
  private let client: HTTPClientProtocol

  public init(client: HTTPClientProtocol) {
    self.client = client
  }

  public func getCharacters(page: Int) async throws -> Data {
    let baseUrl = URL(string: "https://rickandmortyapi.com/api/")!
    let urlRequest = URLRequestBuilder(path: "character")
      .method(.get)
      .queryItems([URLQueryItem(name: "page", value: "\(page)")])
      .makeRequest(withBaseURL: baseUrl)

    let (data, _) = try await client.load(urlRequest: urlRequest)

    return data
  }
}
