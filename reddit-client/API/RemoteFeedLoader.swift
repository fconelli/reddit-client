//
//  RemoteFeedLoader.swift
//  reddit-client
//
//  Created by Francisco Conelli on 12/01/2021.
//

import Foundation

/// protocol for declaring extra functionality needed by RemoteFeedLoader.
/// The idea is to make a URLSession extension that conforms to this so the loader does not depend on concrete classes and can be more flexible and easier to test
public protocol HTTPClient {
    func get(from url: URL)
}

public final class RemoteFeedLoader: FeedLoader {
    
    private let client: HTTPClient
    private let url: URL = URL(string: "www.reddit.com/top")!
    
    public init(client: HTTPClient) {
        self.client = client
    }
    
    func load(completion: @escaping (LoadFeedResult) -> Void) {
        client.get(from: url)
    }
    
    func getURL() -> URL {
        return self.url
    }
}
