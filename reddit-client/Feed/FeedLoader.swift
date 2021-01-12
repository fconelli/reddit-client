//
//  FeedLoader.swift
//  reddit-client
//
//  Created by Francisco Conelli on 12/01/2021.
//

import Foundation

enum LoadFeedResult {
    case success([FeedItem])
    case error(Error)
}

protocol FeedLoader {
    func load(completion: @escaping (LoadFeedResult) -> Void)
}
