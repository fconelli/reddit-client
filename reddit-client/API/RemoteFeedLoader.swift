//
//  RemoteFeedLoader.swift
//  reddit-client
//
//  Created by Francisco Conelli on 12/01/2021.
//

import Foundation


public final class RemoteFeedLoader: FeedLoader {
    
    private let client: HTTPClient
    private let url: URL = URL(string: "https://www.reddit.com/top.json?limit=5")!
    
    /// map http client errors to domain level errors
    public enum Error: Swift.Error {
        case connectivity
        case invalidData
    }
    
    public init(client: HTTPClient) {
        self.client = client
    }
    
    func load(completion: @escaping (FeedLoader.Result) -> Void) {
        client.get(from: url, completion: { result in
            switch result {
            case let .success(data, _):
                if let root = try? JSONDecoder().decode(ResponseJSONRootElement.self, from: data), let posts = root.data?.children.map({ $0.data }) {
                    completion(.success(posts))
                } else {
                    completion(.failure(Error.invalidData))
                }
            case .failure:
                completion(.failure(Error.connectivity))
            }
        })
    }
    
    func getURL() -> URL {
        return self.url
    }
}

private struct ResponseJSONRootElement: Decodable {
    let data: ResponseJSONChildrenData?
}

private struct ResponseJSONChildrenData: Decodable {
    let children: [ResponseJSONChildren]
}

private struct ResponseJSONChildren: Decodable {
    let data: FeedItem
}
