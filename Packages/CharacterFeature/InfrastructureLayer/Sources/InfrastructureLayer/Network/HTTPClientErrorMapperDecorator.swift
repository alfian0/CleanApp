//
//  HTTPClientErrorMapperDecorator.swift
//  HTTPClient
//
//  Created by Alfian on 24/11/24.
//

import Foundation

public final class HTTPClientErrorMapperDecorator: HTTPClientProtocol {
  private let decoratee: HTTPClientProtocol

  public init(decoratee: HTTPClientProtocol) {
    self.decoratee = decoratee
  }

  public func load(urlRequest: URLRequest) async throws -> (Data, URLResponse) {
    let result = try await decoratee.load(urlRequest: urlRequest)
    guard let httpResponse = result.1 as? HTTPURLResponse else {
      throw HTTPClientError.invalidResponse
    }

    guard (200 ... 299).contains(httpResponse.statusCode) else {
      throw HTTPClientError.serverError(statusCode: httpResponse.statusCode)
    }

    return result
  }
}
