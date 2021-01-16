//
//  AppDelegate.swift
//  reddit-client
//
//  Created by Francisco Conelli on 12/01/2021.
//

import UIKit

var feedsProvider: FeedsProvider? = nil
let readPostsKey = "readPostsKey"
let dismissedPostsKey = "dismissedPostsKey"

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        self.startupConfig()
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    private func startupConfig() {
        
        let configuration = URLSessionConfiguration.default
        let urlSession = URLSession(configuration: configuration)
        let client = URLSessionHTTPClient(session: urlSession)
        let loader = RemoteFeedLoader(client: client)
        feedsProvider = FeedsProvider(feedsLoader: loader, readPostsIds: FeedsStorage.getReadPosts(), dismissedPostsIds: FeedsStorage.getDismissedPosts())
    }
}

