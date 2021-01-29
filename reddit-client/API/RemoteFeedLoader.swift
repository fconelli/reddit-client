//
//  RemoteFeedLoader.swift
//  reddit-client
//
//  Created by Francisco Conelli on 12/01/2021.
//

import Foundation


public final class RemoteFeedLoader: FeedLoader {
    
    private let client: HTTPClient
    private let url: URL = URL(string: "https://www.reddit.com/top.json")!
    private var nextPage: String = ""
    private var postsList: [FeedItem] = []
    
    /// map http client errors to domain level errors
    public enum Error: Swift.Error, Equatable {
        case connectivity
        case invalidData
    }
    
    public init(client: HTTPClient) {
        self.client = client
    }
    
    func load(completion: @escaping (FeedLoader.Result) -> Void) {
        
        let loadURL = nextPage.isEmpty ? url : URL(string: "\(url)?after=\(nextPage)")!
        client.get(from: loadURL, completion: { [weak self] result in
            
            switch result {
            case let .success(data, response):
                if let (posts, pageLink) = try? FeedItemsMapper.map(data, response) {
                    self?.postsList = posts
                    self?.nextPage = pageLink
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
    
    func getPostsCount() -> Int {
        return self.postsList.count
    }
}

private class FeedItemsMapper {
    private struct ResponseJSONRootElement: Decodable {
        let data: ResponseJSONChildrenData
    }

    private struct ResponseJSONChildrenData: Decodable {
        let children: [ResponseJSONChildren]
        let after: String?
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
        var thumbnail: String
        var url: String
        var num_comments: Int
        var visited: Bool = false
        
        var post: FeedItem {
            return FeedItem(id: id,
                            title: title,
                            author: author,
                            created: Date(timeIntervalSince1970: created_utc),
                            imageUrl: thumbnail,
                            imageFullSizeUrl: url,
                            comments: num_comments,
                            visited: visited)
        }
    }
    
    static func map(_ data: Data, _ response: HTTPURLResponse) throws -> ([FeedItem], String) {
        guard response.statusCode == 200 else {
            throw RemoteFeedLoader.Error.invalidData
        }
        let posts = try JSONDecoder().decode(ResponseJSONRootElement.self, from: data).data.children.map({ $0.data.post})
        let nextPageLink = try JSONDecoder().decode(ResponseJSONRootElement.self, from: data).data.after ?? ""
        
        return (posts, nextPageLink)
    }
}
