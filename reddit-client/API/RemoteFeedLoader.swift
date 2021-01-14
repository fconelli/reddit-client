//
//  RemoteFeedLoader.swift
//  reddit-client
//
//  Created by Francisco Conelli on 12/01/2021.
//

import Foundation


public final class RemoteFeedLoader: FeedLoader {
    
    private let client: HTTPClient
    private let url: URL = URL(string: "www.reddit.com/top")!
    
    public init(client: HTTPClient) {
        self.client = client
    }
    
    func load(completion: @escaping (LoadFeedResult) -> Void) {
        client.get(from: url, completion: {result in
            // TODO
            // case error?  completion.error(error)
            // case data?   completion.success([FeedItem])
        })
    }
    
    func getURL() -> URL {
        return self.url
    }
}
