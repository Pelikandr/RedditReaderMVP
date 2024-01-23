//
//  AppDelegate.swift
//  RedditReaderMVP
//
//  Created by TrackimoM1Pro on 02.01.2024.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)

        let viewController = FeedViewController()
        let navigationController = UINavigationController(rootViewController: viewController)
        window!.rootViewController = navigationController

        window!.makeKeyAndVisible()
        return true
    }
}

