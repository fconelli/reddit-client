//
//  reddit_clientTests.swift
//  reddit-clientTests
//
//  Created by Francisco Conelli on 12/01/2021.
//

import XCTest
@testable import reddit_client


class reddit_clientTests: XCTestCase {

    //MARK: - feed tests
    
    func test_load_requestsDataFromURL() {
        let (sut, client) = makeSUT()
        let url = sut.getURL()
        
        sut.load() {_ in }
        
        XCTAssertEqual(client.requestedURL, url)
    }
    
    func test_load_deliversConnectivityErrorOnClientError() {
        let (sut, client) = makeSUT()
        client.error = NSError(domain: "test", code: 0)
        
        let expectedResult: Result<[FeedItem], RemoteFeedLoader.Error> = .failure(.connectivity)
        
        let exp = expectation(description: "Wait for load completion")
        
        sut.load() {
            switch ($0, expectedResult) {
            case let (.success(receivedItems), .success(expectedItems)):
                XCTAssertEqual(receivedItems, expectedItems)

            case let (.failure(receivedError as RemoteFeedLoader.Error), .failure(expectedError)):
                XCTAssertEqual(receivedError, expectedError)

            default:
                XCTFail("Expected result \(expectedResult) got \($0) instead")
            }
            
            exp.fulfill()
        }
        
        waitForExpectations(timeout: 0.1)
    }
    
    func test_load_deliversInvalidDataErrorOn200HTTPResponseWithInvalidJSON() {
        let (sut, client) = makeSUT()
        client.receivedInvalidJson = true
        
        let expectedResult: Result<[FeedItem], RemoteFeedLoader.Error> = .failure(.invalidData)
        
        let exp = expectation(description: "Wait for load completion")
        
        sut.load() {
            switch ($0, expectedResult) {
            case let (.success(receivedItems), .success(expectedItems)):
                XCTAssertEqual(receivedItems, expectedItems)

            case let (.failure(receivedError as RemoteFeedLoader.Error), .failure(expectedError)):
                XCTAssertEqual(receivedError, expectedError)

            default:
                XCTFail("Expected result \(expectedResult) got \($0) instead")
            }
            
            exp.fulfill()
        }
        
        waitForExpectations(timeout: 0.1)
    }

//    func test_load_deliversNoItemsOnHTTPResponseWithEmptyJSONList() {
//        let (sut, client) = makeSUT()
//
//    }
    
    // MARK: - helpers
    private func makeSUT() -> (sut: RemoteFeedLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteFeedLoader(client: client)
        
        addTeardownBlock { [weak sut] in
            // executes after each tests finishes
            XCTAssertNil(sut, "Potential memory leak!")
        }
        return (sut, client)
    }
    
    class HTTPClientSpy: HTTPClient {
        var requestedURL: URL?
        var error: Error?
        var complete: (HTTPClientResult) -> Void = {_ in }
        
        var receivedInvalidJson: Bool = false
        
        func get(from url: URL, completion: @escaping (HTTPClientResult) -> Void) {
            complete = completion
            if let error = error {
                complete(.failure(error))
            }
            requestedURL = url
            
            if receivedInvalidJson {
                let invalidJson = Data("invalid json".utf8)
                self.complete(withInvalidJSON: invalidJson, completion: completion)
            }
        }
        
        func complete(withInvalidJSON json: Data, completion: @escaping (HTTPClientResult) -> Void) {
            if let url = requestedURL, let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil) {
                completion(.success(json, response))
            }
        }
    }
}

class URLSessionHTTPClientTests: XCTestCase {
    
    func test_getFromURL_failsOnRequestError() {
        let url = URL(string: "http://any-url.com")!
        let error = NSError(domain: "any", code: 1)
        let session = URLSessionSpy()
        session.stub(url: url, error: error)
        
        let sut = URLSessionHTTPClient(session: session)
        
        let exp = expectation(description: "wait for completion")
        
        sut.get(from: url, completion: { result in
            switch result {
            case let .failure(receivedError):
                XCTAssertEqual(receivedError as NSError, error)
            default:
                XCTFail("Expected failure with error!")
            }
            
            exp.fulfill()
        })
        
        wait(for: [exp], timeout: 1.0)
    }
    
    // MARK: - helpers
    private class URLSessionSpy: URLSession {
        
        private struct Stub {
            let task: URLSessionDataTask
            let error: Error?
        }
        private var stubs = [URL: Stub]()
        
        func stub(url: URL, task: URLSessionDataTask = FakeURLSessionDataTask(), error: Error? = nil) {
            stubs[url] = Stub(task: task, error: error)
        }
        
        override func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
            
            if let stub = stubs[url] {
                completionHandler(nil, nil, stub.error)
                return stub.task
            }
            return FakeURLSessionDataTask()
        }
    }
    
    /// fake URLSession to avoid making real network requests during tests
    private class FakeURLSessionDataTask: URLSessionDataTask {
        override func resume() {}
    }
}
