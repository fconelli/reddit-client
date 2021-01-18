//
//  FeedsProvider.swift
//  reddit-client
//
//  Created by Francisco Conelli on 16/01/2021.
//

import Foundation

class FeedsProvider {
    
    private let feedsLoader: FeedLoader
    private var readPostsIds: [String]
    private var dismissedPostsIds: [String]
    
    private let defaults = UserDefaults.standard
  
    init(feedsLoader: FeedLoader, readPostsIds: [String], dismissedPostsIds: [String]) {
        self.feedsLoader = feedsLoader
        self.readPostsIds = readPostsIds
        self.dismissedPostsIds = dismissedPostsIds
    }
  
    func fetch(_ completion: @escaping (FeedLoader.Result) -> Void) {
        self.feedsLoader.load() { result in
            switch result {
            case let .success(list):
                completion(.success(list))
            case .failure:
                completion(.failure(NSError(domain: "Provider", code: 0)))
            }
        }
    }

    func markAsRead(_ post: FeedItem) {
        if !isPostRead(post) {
            readPostsIds.append(post.id)
            defaults.set(readPostsIds, forKey: readPostsKey)
            defaults.synchronize()
        }
    }
  
    func isPostRead(_ post: FeedItem) -> Bool {
        return FeedsStorage.getReadPosts().contains(post.id)
    }

    func markAsDismissed(_ post: FeedItem) {
        if !isPostDismissed(post) {
            dismissedPostsIds.append(post.id)
            defaults.set(dismissedPostsIds, forKey: dismissedPostsKey)
            defaults.synchronize()
        }
    }
  
    func isPostDismissed(_ post: FeedItem) -> Bool {
        return FeedsStorage.getDismissedPosts().contains(post.id)
    }
}


class FeedsStorage {
    static func getReadPosts() -> [String] {
        return UserDefaults.standard.stringArray(forKey: readPostsKey) ?? []
    }
    
    static func getDismissedPosts() -> [String] {
        return UserDefaults.standard.stringArray(forKey: dismissedPostsKey) ?? []
    }
}
