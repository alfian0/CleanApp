import XCTest
import HTTPClient

final class HTTPClientTests: XCTestCase {
    func test_load_timeout() async {
        let url = URL(string: "https://example.com")!
        let sut = makeSUT(url: url, statusCode: 0, error: URLError(.timedOut))
        do {
            _ = try await sut.load(urlRequest: URLRequest(url: URL(string: "https://example.com")!))
            XCTFail()
        } catch let HTTPClientError.networkError(error) {
            XCTAssertEqual((error as? URLError)?.code, URLError(.timedOut).code)
        } catch {
            XCTFail()
        }
    }
    
    func test_load_serverError() async {
        let url = URL(string: "https://example.com")!
        let sut = makeSUT(url: url, statusCode: 0, error: URLError(.badServerResponse))
        do {
            _ = try await sut.load(urlRequest: URLRequest(url: url))
            XCTFail()
        } catch let HTTPClientError.networkError(error) {
            XCTAssertEqual((error as? URLError)?.code, URLError(.badServerResponse).code)
        } catch {
            XCTFail()
        }
    }
    
    func test_load_emptyData() async {
        let url = URL(string: "https://example.com")!
        let sut = makeSUT(url: url, statusCode: 200)
        do {
            let (data, response) = try await sut.load(urlRequest: URLRequest(url: url))
            XCTAssertEqual((response as? HTTPURLResponse)?.statusCode, 200)
            XCTAssertEqual(data, Data())
        } catch {
            XCTFail()
        }
    }
    
    func test_load_jsonData() async {
        let url = URL(string: "https://example.com")!
        let valid = """
            {
                "id": 1,
                "name": "valid name"
            }
        """.data(using: .utf8)!
        let sut = makeSUT(url: url, statusCode: 200, data: valid)
        do {
            let (data, response) = try await sut.load(urlRequest: URLRequest(url: url))
            XCTAssertEqual((response as? HTTPURLResponse)?.statusCode, 200)
            XCTAssertEqual(data, valid)
        } catch {
            XCTFail()
        }
    }
    
    private func makeSUT(url: URL, statusCode: Int, data: Data = Data(), error: Error? = nil) -> HTTPClient {
        MockURLProtocol.requestHandler = { request in
            if let error = error {
                throw error
            }
            
            let response = HTTPURLResponse(
                url: url,
                statusCode: statusCode,
                httpVersion: nil,
                headerFields: nil
            )!
            
            return (response, data)
        }
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        let session = URLSession(configuration: configuration)
        let sut = HTTPClient(session: session)
        return sut
    }
}

struct DataModel: Decodable {
    let id: Int
    let name: String
}

class MockURLProtocol: URLProtocol {
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    nonisolated(unsafe) static var requestHandler: ((URLRequest) throws -> (HTTPURLResponse, Data))?
    
    override func startLoading() {
        guard let handler = MockURLProtocol.requestHandler else {
            XCTFail("No request handler set")
            return
        }
        
        do {
            let (response, data) = try handler(request)
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            client?.urlProtocol(self, didLoad: data)
            client?.urlProtocolDidFinishLoading(self)
        } catch {
            client?.urlProtocol(self, didFailWithError: error)
        }
    }
    
    override func stopLoading() {}
}

class SpyHTTPClient: HTTPClientProtocol {
    private(set) var capturedRequests: [URLRequest] = []
    var resultToReturn: Result<(Data, URLResponse), Error> = .failure(URLError(.badServerResponse))
    
    func load(urlRequest: URLRequest) async throws -> (Data, URLResponse) {
        capturedRequests.append(urlRequest)
        switch resultToReturn {
        case .success(let result): return result
        case .failure(let error): throw error
        }
    }
}

class MockAuthManager: AuthManagerProtocol {
    var validTokenResult: Result<String, Error> = .failure(URLError(.badServerResponse))
    var refreshTokenResult: Result<String, Error> = .failure(URLError(.badServerResponse))
    
    func validToken() throws -> String {
        switch validTokenResult {
        case .success(let token): return token
        case .failure(let error): throw error
        }
    }
    
    func refreshToken() throws -> String {
        switch refreshTokenResult {
        case .success(let token): return token
        case .failure(let error): throw error
        }
    }
}
