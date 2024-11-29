//
//  HTTPClientErrorMapperDecoratorTests.swift
//  HTTPClient
//
//  Created by Alfian on 23/11/24.
//

import XCTest
@testable import InfrastructureLayer

final class HTTPClientErrorMapperDecoratorTests: XCTestCase {
    func test_load_serverError500() async {
        let url = URL(string: "https://example.com")!
        let sut = makeSUT(url: url, statusCode: 500)
        do {
            _ = try await sut.load(urlRequest: URLRequest(url: url))
            XCTFail()
        } catch {
            XCTAssertTrue(error is HTTPClientError)
            XCTAssertEqual(error as? HTTPClientError, .serverError(statusCode: 500))
        }
    }
    
    func test_load_notFoundError404() async {
        let url = URL(string: "https://example.com")!
        let sut = makeSUT(url: url, statusCode: 404)
        do {
            _ = try await sut.load(urlRequest: URLRequest(url: url))
            XCTFail()
        } catch {
            XCTAssertTrue(error is HTTPClientError)
            XCTAssertEqual(error as? HTTPClientError, .serverError(statusCode: 404))
        }
    }
    
    func test_load_unauthorizedError() async {
        let url = URL(string: "https://example.com")!
        let sut = makeSUT(url: url, statusCode: 401)
        do {
            _ = try await sut.load(urlRequest: URLRequest(url: url))
            XCTFail()
        } catch {
            XCTAssertTrue(error is HTTPClientError)
            XCTAssertEqual(error as? HTTPClientError, .serverError(statusCode: 401))
        }
    }
    
    func test_load_success200() async {
        let data = Data()
        let url = URL(string: "https://example.com")!
        let sut = makeSUT(url: url, statusCode: 200, data: data)
        do {
            let (d, _) = try await sut.load(urlRequest: URLRequest(url: url))
            XCTAssertEqual(d, data)
        } catch {
            XCTFail()
        }
    }
    
    private func makeSUT(url: URL, statusCode: Int, data: Data = Data()) -> HTTPClientErrorMapperDecorator {
        let response = HTTPURLResponse(
            url: url,
            statusCode: statusCode,
            httpVersion: nil,
            headerFields: nil
        )!
        let client = SpyHTTPClient()
        client.resultToReturn = .success((data, response))
        let sut = HTTPClientErrorMapperDecorator(decoratee: client)
        return sut
    }
}
