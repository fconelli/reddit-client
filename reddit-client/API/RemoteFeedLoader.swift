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
            case let .success(data, response):
                if let posts = try? FeedItemsMapper.map(data, response) {
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

private class FeedItemsMapper {
    static func map(_ data: Data, _ response: HTTPURLResponse) throws -> [FeedItem] {
        guard response.statusCode == 200 else {
            throw RemoteFeedLoader.Error.invalidData
        }
        return try JSONDecoder().decode(ResponseJSONRootElement.self, from: data).data.children.map({ $0.data.post})
    }
}

private struct ResponseJSONRootElement: Decodable {
    let data: ResponseJSONChildrenData
}

private struct ResponseJSONChildrenData: Decodable {
    let children: [ResponseJSONChildren]
}

private struct ResponseJSONChildren: Decodable {
    let data: FeedPost
}

/// internal representation of FeedItem for API module
private struct FeedPost: Decodable {
    var id: String
    var title: String
    var author: String
    var created_utc: Double
    var thumb_url: String?
    var num_comments: Int
    var visited: Bool = false
    
    var post: FeedItem {
        return FeedItem(id: id,
                        title: title,
                        author: author,
                        created: Date(timeIntervalSince1970: created_utc),
                        thumb_url: thumb_url,
                        comments: num_comments,
                        visited: visited)
    }
}
