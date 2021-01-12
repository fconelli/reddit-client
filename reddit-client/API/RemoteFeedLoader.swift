//
//  RemoteFeedLoader.swift
//  reddit-client
//
//  Created by Francisco Conelli on 12/01/2021.
//

import Foundation

public final class RemoteFeedLoader: FeedLoader {
    
    private let client: HTTPClient
    
    public init(client: HTTPClient) {
        self.client = client
    }
    
    func load(completion: @escaping (LoadFeedResult) -> Void) {
        client.requestedURL = URL(string: "www.reddit.com/top")
    }
}

public class HTTPClient {
    var requestedURL: URL?
}
