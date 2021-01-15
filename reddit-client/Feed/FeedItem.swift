//
//  FeedItem.swift
//  reddit-client
//
//  Created by Francisco Conelli on 12/01/2021.
//

import Foundation

struct FeedItem: Decodable {
    var id: String
    var title: String
    var author: String
    var created: Date
    var thumb_url: String?
    var comments: Int
    var visited: Bool = false
}

extension FeedItem: Equatable {
    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.id == rhs.id
    }
}
