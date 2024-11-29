//
//  HTTPClientError.swift
//  HTTPClient
//
//  Created by Alfian on 23/11/24.
//

public enum HTTPClientError: Swift.Error {
    case networkError(Error)
    case invalidResponse
    case serverError(statusCode: Int)
    case decodingError(Error)
}

extension HTTPClientError: Equatable {
    public static func ==(lhs: HTTPClientError, rhs: HTTPClientError) -> Bool {
        switch (lhs, rhs) {
        case (.networkError(let lhsError), .networkError(let rhsError)):
            // Compare network errors based on their descriptions or any specific property
            return lhsError.localizedDescription == rhsError.localizedDescription
        case (.invalidResponse, .invalidResponse):
            return true
        case (.serverError(let lhsStatusCode), .serverError(let rhsStatusCode)):
            return lhsStatusCode == rhsStatusCode
        case (.decodingError(let lhsError), .decodingError(let rhsError)):
            // Compare decoding errors based on their descriptions or any specific property
            return lhsError.localizedDescription == rhsError.localizedDescription
        default:
            return false
        }
    }
}
