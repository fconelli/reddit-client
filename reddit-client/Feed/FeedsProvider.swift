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
            FeedsStorage.updateReadPosts(readPostsIds)
        }
    }
  
    func isPostRead(_ post: FeedItem) -> Bool {
        return FeedsStorage.getReadPosts().contains(post.id)
    }

    func markAsDismissed(_ post: FeedItem) {
        if !isPostDismissed(post) {
            dismissedPostsIds.append(post.id)
            FeedsStorage.updateDismissedPosts(dismissedPostsIds)
        }
    }
  
    func isPostDismissed(_ post: FeedItem) -> Bool {
        return FeedsStorage.getDismissedPosts().contains(post.id)
    }
    
    func clearAllDismissedPosts() {
        dismissedPostsIds.removeAll()
        FeedsStorage.updateDismissedPosts(dismissedPostsIds)
    }
}


class FeedsStorage {
    static let readPostsKey = "readPostsKey"
    static let dismissedPostsKey = "dismissedPostsKey"
    static let defaults = UserDefaults.standard
    
    static func getReadPosts() -> [String] {
        return UserDefaults.standard.stringArray(forKey: readPostsKey) ?? []
    }
    
    static func getDismissedPosts() -> [String] {
        return UserDefaults.standard.stringArray(forKey: dismissedPostsKey) ?? []
    }
    
    static func updateReadPosts(_ posts: [String]) {
        defaults.set(posts, forKey: readPostsKey)
        defaults.synchronize()
    }
    
    static func updateDismissedPosts(_ posts: [String]) {
        defaults.set(posts, forKey: dismissedPostsKey)
        defaults.synchronize()
    }
}
