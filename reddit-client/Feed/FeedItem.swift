//
//  FeedItem.swift
//  reddit-client
//
//  Created by Francisco Conelli on 12/01/2021.
//

import Foundation

struct FeedItem {
    let id: String
    let title: String
    let author: String
    let created: String
    let thumb_url: String?
    let comments: Int
    let read: Bool = false
}
