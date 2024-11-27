//
//  OAuthAuthManagerTests.swift
//  HTTPClient
//
//  Created by Alfian on 23/11/24.
//

import XCTest
import OAuthSwift
import KeychainSwift
@testable import InfrastructureLayer

final class OAuthAuthManagerTests: XCTestCase {
    func testValidToken_ReturnsToken_WhenTokenIsValid() throws {
        // Arrange
        let mockKeychain = MockKeychainSwift()
        _ = mockKeychain.set("valid_token", forKey: "auth.accessToken")
        _ = mockKeychain.set("\(Date().timeIntervalSince1970 + 3600)", forKey: "auth.tokenExpiry") // 1-hour expiry
        
        let mockOAuth = MockOAuth2Swift(consumerKey: "", consumerSecret: "", authorizeUrl: "", accessTokenUrl: "", responseType: "")
        let authManager = OAuthAuthManager(oauth: mockOAuth, keychain: mockKeychain)
        
        // Act
        let token = try authManager.validToken()
        
        // Assert
        XCTAssertEqual(token, "valid_token")
    }
    
    func testValidToken_ThrowsError_WhenTokenIsExpired() throws {
        // Arrange
        let mockKeychain = MockKeychainSwift()
        _ = mockKeychain.set("expired_token", forKey: "auth.accessToken")
        _ = mockKeychain.set("\(Date().timeIntervalSince1970 - 10)", forKey: "auth.tokenExpiry") // Expired
        
        let mockOAuth = MockOAuth2Swift(consumerKey: "", consumerSecret: "", authorizeUrl: "", accessTokenUrl: "", responseType: "")
        let authManager = OAuthAuthManager(oauth: mockOAuth, keychain: mockKeychain)
        
        // Act & Assert
        XCTAssertThrowsError(try authManager.validToken()) { error in
            XCTAssertEqual((error as? OAuthSwiftError)?.localizedDescription, OAuthSwiftError.tokenExpired(error: nil).localizedDescription)
        }
    }
    
    func testRefreshToken_ReturnsNewToken_WhenRefreshIsSuccessful() async throws {
        // Arrange
        let mockKeychain = MockKeychainSwift()
        _ = mockKeychain.set("valid_refresh_token", forKey: "auth.refreshToken")
        
        let mockOAuth = MockOAuth2Swift(consumerKey: "", consumerSecret: "", authorizeUrl: "", accessTokenUrl: "", responseType: "")
        let credential = OAuthSwiftCredential(consumerKey: "", consumerSecret: "")
        credential.oauthToken = "new_token"
        credential.oauthRefreshToken = "new_refresh_token"
        credential.oauthTokenExpiresAt = Date().addingTimeInterval(3600)
        mockOAuth.mockTokenRenewalResult = .success((
            credential: credential,
            response: nil,
            parameters: [:]
        ))
        
        let authManager = OAuthAuthManager(oauth: mockOAuth, keychain: mockKeychain)
        
        // Act
        let token = try await authManager.refreshToken()
        
        // Assert
        XCTAssertEqual(token, "new_token")
        XCTAssertEqual(mockKeychain.get("auth.accessToken"), "new_token")
        XCTAssertEqual(mockKeychain.get("auth.refreshToken"), "new_refresh_token")
    }

    func testRefreshToken_ThrowsError_WhenRefreshFails() async throws {
        // Arrange
        let mockKeychain = MockKeychainSwift()
        _ = mockKeychain.set("invalid_refresh_token", forKey: "auth.refreshToken")
        
        let mockOAuth = MockOAuth2Swift(consumerKey: "", consumerSecret: "", authorizeUrl: "", accessTokenUrl: "", responseType: "")
        mockOAuth.mockTokenRenewalResult = .failure(OAuthSwiftError.tokenExpired(error: nil))
        
        let authManager = OAuthAuthManager(oauth: mockOAuth, keychain: mockKeychain)
        
        // Act & Assert
        do {
            _ = try await authManager.refreshToken()
        } catch {
            XCTAssertEqual((error as? OAuthSwiftError)?.localizedDescription, OAuthSwiftError.tokenExpired(error: nil).localizedDescription)
        }
    }
}

class MockOAuth2Swift: OAuth2Swift {
    var mockTokenRenewalResult: Result<OAuthSwift.TokenSuccess, OAuthSwiftError>?
    
    override func renewAccessToken(withRefreshToken refreshToken: String, parameters: OAuthSwift.Parameters? = nil, headers: OAuthSwift.Headers? = nil, completionHandler completion: @escaping OAuth2Swift.TokenCompletionHandler) -> (any OAuthSwiftRequestHandle)? {
        guard let result = mockTokenRenewalResult else {
            completion(.failure(OAuthSwiftError.tokenExpired(error: nil)))
            return nil
        }
        completion(result)
        return nil
    }
}

class MockKeychainSwift: KeychainSwift {
    private var storage: [String: String] = [:]
    
    override func set(_ value: String, forKey key: String, withAccess access: KeychainSwiftAccessOptions? = nil) -> Bool {
        storage[key] = value
        return true
    }
    
    override func get(_ key: String) -> String? {
        return storage[key]
    }
    
    override func delete(_ key: String) -> Bool {
        storage[key] = nil
        return true
    }
}
