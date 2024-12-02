//
//  AuthHTTPClientDecorator.swift
//  HTTPClient
//
//  Created by Alfian on 24/11/24.
//

import Foundation

final class AuthHTTPClientDecorator: HTTPClientProtocol {
  private let decoratee: HTTPClientProtocol
  private let manager: AuthManagerProtocol

  init(decoratee: HTTPClientProtocol, manager: AuthManagerProtocol) {
    self.decoratee = decoratee
    self.manager = manager
  }

  func load(urlRequest: URLRequest) async throws -> (Data, URLResponse) {
    var urlRequest = urlRequest

    // Attempt the request with a valid token
    do {
      let token = try manager.validToken()
      urlRequest = addAuthorizationHeader(to: urlRequest, token: token)
    } catch {
      let refreshedToken = try await manager.refreshToken()
      urlRequest = addAuthorizationHeader(to: urlRequest, token: refreshedToken)
    }

    // Perform the HTTP request
    do {
      let (data, response) = try await decoratee.load(urlRequest: urlRequest)
      guard let httpResponse = response as? HTTPURLResponse else {
        throw URLError(.badServerResponse)
      }
      if httpResponse.statusCode == 401 || httpResponse.statusCode == 403 {
        let refreshedToken = try await manager.refreshToken()
        urlRequest = addAuthorizationHeader(to: urlRequest, token: refreshedToken)
        return try await decoratee.load(urlRequest: urlRequest)
      }
      return (data, response)
    } catch {
      throw error
    }
  }

  // Helper function to set the Authorization header
  private func addAuthorizationHeader(to request: URLRequest, token: String) -> URLRequest {
    var request = request
    request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
    return request
  }
}
