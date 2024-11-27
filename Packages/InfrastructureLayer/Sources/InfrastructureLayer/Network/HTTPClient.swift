// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation

public protocol HTTPClientProtocol {
    func load(urlRequest: URLRequest) async throws -> (Data, URLResponse)
}

public final class HTTPClient: HTTPClientProtocol {
    private let session: URLSession
    
    public init(session: URLSession = .shared) {
        self.session = session
    }
    
    public func load(urlRequest: URLRequest) async throws -> (Data, URLResponse) {
        do {
            return try await session.data(for: urlRequest)
        } catch {
            throw HTTPClientError.networkError(error)
        }
    }
}
