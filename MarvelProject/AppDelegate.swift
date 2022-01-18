//
//  AppDelegate.swift
//  MarvelProject
//
//  Created by Rafiq Messai on 13/01/2022.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = UINavigationController(rootViewController: SearchViewController())
        window.makeKeyAndVisible()
        self.window = window
        
        return true
    }


}

