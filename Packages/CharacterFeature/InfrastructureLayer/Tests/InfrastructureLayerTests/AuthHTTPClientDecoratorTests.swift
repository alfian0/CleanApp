//
//  AuthHTTPClientDecoratorTests.swift
//  HTTPClient
//
//  Created by Alfian on 23/11/24.
//

@testable import InfrastructureLayer
import XCTest

final class AuthHTTPClientDecoratorTests: XCTestCase {
  func test_validTokenWith401Response() async throws {
    let url = URL(string: "https://example.com")!
    let response = HTTPURLResponse(
      url: url,
      statusCode: 401,
      httpVersion: nil,
      headerFields: nil
    )!

    let spyHTTPClient = SpyHTTPClient()
    let mockAuthManager = MockAuthManager()
    mockAuthManager.validTokenResult = .success("valid_token")
    mockAuthManager.refreshTokenResult = .success("refresh_token")
    spyHTTPClient.resultToReturn = .success((Data(), response))

    let sut = AuthHTTPClientDecorator(decoratee: spyHTTPClient, manager: mockAuthManager)
    let request = URLRequest(url: url)
    do {
      _ = try await sut.load(urlRequest: request)
      XCTAssertEqual(spyHTTPClient.capturedRequests.count, 2)
      XCTAssertEqual(
        spyHTTPClient.capturedRequests.first?.allHTTPHeaderFields?["Authorization"],
        "Bearer valid_token"
      )
      XCTAssertEqual(
        spyHTTPClient.capturedRequests.last?.allHTTPHeaderFields?["Authorization"],
        "Bearer refresh_token"
      )
    } catch {
      XCTFail()
    }
  }

  func test_validTokenIsUsedSuccessfully() async throws {
    // Arrange
    let spyHTTPClient = SpyHTTPClient()
    let mockAuthManager = MockAuthManager()
    mockAuthManager.validTokenResult = .success("valid_token")
    spyHTTPClient.resultToReturn = .success((Data(), HTTPURLResponse()))

    let sut = AuthHTTPClientDecorator(decoratee: spyHTTPClient, manager: mockAuthManager)
    let request = URLRequest(url: URL(string: "https://example.com")!)

    // Act
    _ = try await sut.load(urlRequest: request)

    // Assert
    XCTAssertEqual(spyHTTPClient.capturedRequests.count, 1)
    let capturedRequest = spyHTTPClient.capturedRequests.first
    XCTAssertEqual(capturedRequest?.value(forHTTPHeaderField: "Authorization"), "Bearer valid_token")
  }

  func test_refreshTokenIsUsedWhenValidTokenFails() async throws {
    // Arrange
    let spyHTTPClient = SpyHTTPClient()
    let mockAuthManager = MockAuthManager()
    mockAuthManager.validTokenResult = .failure(URLError(.userAuthenticationRequired))
    mockAuthManager.refreshTokenResult = .success("refreshed_token")
    spyHTTPClient.resultToReturn = .success((Data(), HTTPURLResponse()))

    let sut = AuthHTTPClientDecorator(decoratee: spyHTTPClient, manager: mockAuthManager)
    let request = URLRequest(url: URL(string: "https://example.com")!)

    // Act
    _ = try await sut.load(urlRequest: request)

    // Assert
    XCTAssertEqual(spyHTTPClient.capturedRequests.count, 1)
    let capturedRequest = spyHTTPClient.capturedRequests.first
    XCTAssertEqual(capturedRequest?.value(forHTTPHeaderField: "Authorization"), "Bearer refreshed_token")
  }

  func test_decorateeReceivesModifiedRequest() async throws {
    // Arrange
    let spyHTTPClient = SpyHTTPClient()
    let mockAuthManager = MockAuthManager()
    mockAuthManager.validTokenResult = .success("valid_token")
    spyHTTPClient.resultToReturn = .success((Data(), HTTPURLResponse()))

    let sut = AuthHTTPClientDecorator(decoratee: spyHTTPClient, manager: mockAuthManager)
    let request = URLRequest(url: URL(string: "https://example.com")!)

    // Act
    _ = try await sut.load(urlRequest: request)

    // Assert
    XCTAssertEqual(spyHTTPClient.capturedRequests.count, 1)
    let capturedRequest = spyHTTPClient.capturedRequests.first
    XCTAssertEqual(capturedRequest?.url, request.url)
  }

  func test_errorIsThrownWhenBothTokensFail() async throws {
    // Arrange
    let spyHTTPClient = SpyHTTPClient()
    let mockAuthManager = MockAuthManager()
    mockAuthManager.validTokenResult = .failure(URLError(.userAuthenticationRequired))
    mockAuthManager.refreshTokenResult = .failure(URLError(.userAuthenticationRequired))
    spyHTTPClient.resultToReturn = .success((Data(), HTTPURLResponse()))

    let sut = AuthHTTPClientDecorator(decoratee: spyHTTPClient, manager: mockAuthManager)
    let request = URLRequest(url: URL(string: "https://example.com")!)

    // Act & Assert
    do {
      _ = try await sut.load(urlRequest: request)
    } catch {
      XCTAssertEqual((error as? URLError)?.code, .userAuthenticationRequired)
    }
  }
}
