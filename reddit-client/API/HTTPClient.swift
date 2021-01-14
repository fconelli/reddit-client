//
//  HTTPClient.swift
//  reddit-client
//
//  Created by Francisco Conelli on 13/01/2021.
//

import Foundation

public enum HTTPClientResult {
    case success(Data, HTTPURLResponse)
    case failure(Error)
}

/// protocol for declaring extra functionality needed by RemoteFeedLoader.
/// The idea is to make a URLSession extension that conforms to this so the loader does not depend on concrete classes and can be more flexible and easier to test
public protocol HTTPClient {
    func get(from url: URL, completion: @escaping (HTTPClientResult) -> Void)
}

public class URLSessionHTTPClient: HTTPClient {
    private let session: URLSession
    
    init(session: URLSession) {
        self.session = session
    }
    
    public func get(from url: URL, completion: @escaping (HTTPClientResult) -> Void) {
        
        session.dataTask(with: url) { data, response, error in
            // TODO
            // case error?  completion.failure(error)
            // case data?   completion.success(data, response)
            if let error = error {
                completion(.failure(error))
            }
        }.resume()
    }
    
    
}
