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
        let client = HTTPClientSpy()
        let sut = RemoteFeedLoader(client: client)
        let url = sut.getURL()
        
        sut.load() {_ in }
        
        XCTAssertEqual(client.requestedURL, url)
    }
    
    // MARK: - helpers
    class HTTPClientSpy: HTTPClient {
        var requestedURL: URL?
        
        func get(from url: URL) {
            requestedURL = url
        }
    }
}
