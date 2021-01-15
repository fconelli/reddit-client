//
//  ImageLoader.swift
//  reddit-client
//
//  Created by Francisco Conelli on 15/01/2021.
//

import Foundation
import UIKit

class ImageLoader {
    
    var task: URLSessionDownloadTask!
    var session: URLSession!
    var cache: NSCache<NSString, UIImage>!
    
    init() {
        session = URLSession.shared
        task = URLSessionDownloadTask()
        self.cache = NSCache()
    }
    
    func load(from imagePath: String, completionHandler: @escaping (UIImage) -> ()) {
        if let image = self.cache.object(forKey: imagePath as NSString) {
            DispatchQueue.main.async {
                completionHandler(image)
            }
        } else {
            let placeholder = UIImage(systemName: "photo")!
            DispatchQueue.main.async {
                completionHandler(placeholder)
            }
            if let url = URL(string: imagePath) {
                self.download(url, imagePath, completionHandler: completionHandler)
            } else {
                let url = URL(string: "https://www.reddit.com/static/noimage.png")!
                self.download(url, imagePath, completionHandler: completionHandler)
            }
        }
    }
    
    private func download(_ url: URL,_ path: String, completionHandler: @escaping (UIImage) -> ()) {
        task = session.downloadTask(with: url, completionHandler: { (location, response, error) in
            if let data = try? Data(contentsOf: url) {
                if let img = UIImage(data: data) {
                    self.cache.setObject(img, forKey: path as NSString)
                    DispatchQueue.main.async {
                        completionHandler(img)
                    }
                }
            }
        })
        task.resume()
    }
}
