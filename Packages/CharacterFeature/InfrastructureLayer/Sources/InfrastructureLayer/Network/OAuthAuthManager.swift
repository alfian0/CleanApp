//
//  OAuthAuthManager.swift
//  HTTPClient
//
//  Created by Alfian on 23/11/24.
//

import Foundation
import KeychainSwift
import OAuthSwift

public protocol AuthManagerProtocol {
  func validToken() throws -> String
  func refreshToken() async throws -> String
}

public final class OAuthAuthManager: AuthManagerProtocol {
  private let oauth: OAuth2Swift
  private let keychain: KeychainSwift

  // Keychain keys
  private enum Keys {
    static let accessToken = "auth.accessToken"
    static let refreshToken = "auth.refreshToken"
    static let tokenExpiry = "auth.tokenExpiry"
  }

  init(oauth: OAuth2Swift, keychain: KeychainSwift) {
    self.oauth = oauth
    self.keychain = keychain
  }

  public func validToken() throws -> String {
    guard let token = keychain.get(Keys.accessToken),
          let expiryString = keychain.get(Keys.tokenExpiry),
          let expiry = Double(expiryString) else {
      throw OAuthSwiftError.tokenExpired(error: nil)
    }

    // Check if token has expired
    if Date().timeIntervalSince1970 >= expiry {
      throw OAuthSwiftError.tokenExpired(error: nil)
    }

    return token
  }

  public func refreshToken() async throws -> String {
    guard let refreshToken = keychain.get(Keys.refreshToken) else {
      throw OAuthSwiftError.tokenExpired(error: nil)
    }

    // Perform the token refresh synchronously using async/await
    return try await withCheckedThrowingContinuation { continuation in
      oauth.renewAccessToken(withRefreshToken: refreshToken) { result in
        switch result {
        case let .success(credential):
          // Save the new token details in Keychain
          self.storeToken(credential: credential.credential)
          continuation.resume(returning: credential.credential.oauthToken)
        case let .failure(error):
          continuation.resume(throwing: error)
        }
      }
    }
  }

  // Store tokens securely in Keychain
  private func storeToken(credential: OAuthSwiftCredential) {
    keychain.set(credential.oauthToken, forKey: Keys.accessToken)
    keychain.set(credential.oauthRefreshToken, forKey: Keys.refreshToken)
    keychain.set(String(credential.oauthTokenExpiresAt?.timeIntervalSince1970 ?? 0), forKey: Keys.tokenExpiry)
  }
}
