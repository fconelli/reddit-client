//
//  RemoteFeedLoader.swift
//  reddit-client
//
//  Created by Francisco Conelli on 12/01/2021.
//

import Foundation


public final class RemoteFeedLoader: FeedLoader {
    
    private let client: HTTPClient
    private let url: URL = URL(string: "http://www.reddit.com/top")!
    
    /// map http client errors to domain level errors
    public enum Error: Swift.Error {
        case connectivity
    }
    
    public init(client: HTTPClient) {
        self.client = client
    }
    
    func load(completion: @escaping (FeedLoader.Result) -> Void) {
        client.get(from: url, completion: { result in
            switch result {
            case .success:
                let list:[FeedItem] = []    // TODO: map response to FeedItems array
                completion(.success(list))
            case .failure:
                completion(.failure(Error.connectivity))
            }
        })
    }
    
    func getURL() -> URL {
        return self.url
    }
}
