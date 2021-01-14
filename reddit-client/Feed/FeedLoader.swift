//
//  FeedLoader.swift
//  reddit-client
//
//  Created by Francisco Conelli on 12/01/2021.
//

import Foundation


protocol FeedLoader {
    typealias Result = Swift.Result<[FeedItem], Error>
    
    func load(completion: @escaping (FeedLoader.Result) -> Void)
}
