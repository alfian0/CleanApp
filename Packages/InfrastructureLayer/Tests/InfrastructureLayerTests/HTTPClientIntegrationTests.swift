//
//  HTTPClientIntegrationTests.swift
//  HTTPClient
//
//  Created by Alfian on 23/11/24.
//

import XCTest
import URLRequestBuilder
@testable import HTTPClient

final class HTTPClientIntegrationTests: XCTestCase {
    func test_loadCharacterEndpoint_returnsValidResponse() async throws {
        // Arrange: Set up the base URL and request
        let baseUrl = URL(string: "https://rickandmortyapi.com/api/")!
        let urlRequest = URLRequestBuilder(path: "character")
            .method(.get)
            .makeRequest(withBaseURL: baseUrl)
        
        let sut = HTTPClient()
        
        // Act: Perform the network request
        let (data, response) = try await sut.load(urlRequest: urlRequest)
        
        // Assert: Validate the response
        guard let httpResponse = response as? HTTPURLResponse else {
            XCTFail("Response is not an HTTPURLResponse")
            return
        }
        
        XCTAssertEqual(httpResponse.statusCode, 200, "Expected a 200 OK status code")
        
        let jsonObject = try JSONSerialization.jsonObject(with: data)
        XCTAssertNotNil(jsonObject, "Expected non-nil JSON object")
        
        // Optional: Validate JSON formatting (useful for debugging)
        let object = try JSONSerialization.jsonObject(with: data)
        let prettyPrintedData = try JSONSerialization.data(
            withJSONObject: object,
            options: [.prettyPrinted, .sortedKeys]
        )
        let prettyPrintedString = String(data: prettyPrintedData, encoding: .utf8)
        XCTAssertNotNil(prettyPrintedString)
    }
    
    func test_loadCharacterEndpoint_returns404Response() async throws {
        // Arrange: Set up the base URL and request
        let baseUrl = URL(string: "https://rickandmortyapi.com/api/")!
        let urlRequest = URLRequestBuilder(path: "character/827")
            .method(.get)
            .makeRequest(withBaseURL: baseUrl)
        
        let sut = HTTPClient()
        
        // Act: Perform the network request
        let (data, response) = try await sut.load(urlRequest: urlRequest)
        
        // Assert: Validate the response
        guard let httpResponse = response as? HTTPURLResponse else {
            XCTFail("Response is not an HTTPURLResponse")
            return
        }
        
        XCTAssertEqual(httpResponse.statusCode, 404, "Expected a 404 OK status code")
        
        let jsonObject = try JSONSerialization.jsonObject(with: data)
        XCTAssertNotNil(jsonObject, "Expected non-nil JSON object")
        
        // Optional: Validate JSON formatting (useful for debugging)
        let object = try JSONSerialization.jsonObject(with: data)
        let prettyPrintedData = try JSONSerialization.data(
            withJSONObject: object,
            options: [.prettyPrinted, .sortedKeys]
        )
        let prettyPrintedString = String(data: prettyPrintedData, encoding: .utf8)
        XCTAssertNotNil(prettyPrintedString)
    }
    
    func test_loadCharactherEndpoint_returnsErrorAfterMapping() async throws {
        let baseUrl = URL(string: "https://rickandmortyapi.com/api/")!
        let urlRequest = URLRequestBuilder(path: "character/827")
            .method(.get)
            .makeRequest(withBaseURL: baseUrl)
        
        let client = HTTPClient()
        let sut = HTTPClientErrorMapperDecorator(decoratee: client)
        
        do {
            _ = try await sut.load(urlRequest: urlRequest)
            XCTFail()
        } catch {
            XCTAssertTrue(error is HTTPClientError)
            XCTAssertEqual(error as? HTTPClientError, .serverError(statusCode: 404))
        }
    }
}

struct ListResponse: Decodable {
    let info: InfoResponse
    let results: [Character]
}

struct InfoResponse: Decodable {
    let count: Int
    let pages: Int
    let next: String?
    let pre: String?
}

struct Character: Decodable {
    let id: Int
    let name: String
    let status: String
    let species: String
    let gender: String
    let image: String
}
